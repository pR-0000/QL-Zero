# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Editor test driving: actual UNION20 M68000 physics, PC ribbon preview."""
from __future__ import annotations

import json
import math
import struct
from pathlib import Path

from PIL import Image, ImageDraw
from editor_model import ROOT, PALETTE, bitmap, native_track, preview_model
from native_cpu import CPU,state
from unicorn import UC_PROT_READ, UC_PROT_EXEC, UC_PROT_NONE
from unicorn.m68k_const import UC_M68K_REG_D0, UC_M68K_REG_D3, UC_M68K_REG_D7


def signed(value):return value-65536 if value>=32768 else value


def display_kmh(state):
    extra=max(0,min(32,96-state['goal_horizon']))*4 if state['boosting'] and state['hills'] else 0
    ground=math.isqrt(144*(state['vx']**2+state['vy']**2))
    return min(1490,ground+extra) if ground else 0


class TestEngine:
    def __init__(self,project,index):
        self.project=project;self.index=index;self.raw,self.model=preview_model(project,index)
        self.track=self.model['tracks'][0]
        self.native_loaded=False;self.cup_session=False;self.cup_core=False
        folder=ROOT/'build/classic_cup'
        if not (folder/'cup_image.bin').exists():folder=ROOT/'release/v1.0.0'
        self._load_cup_cpu(folder);self.reset()

    def word(self,name,value=None):
        at=self.cpu.symbols[name]
        if value is not None:self.cpu.u.mem_write(at,struct.pack('>H',value&65535))
        return int.from_bytes(self.cpu.u.mem_read(at,2),'big')

    def _load_cup_cpu(self,folder):
        meta=json.loads((Path(folder)/'metadata.json').read_text());c=CPU(meta,Path(folder))
        c.symbols=meta['symbols'];c.base=meta['image_base']
        c.u.mem_write(c.base,(Path(folder)/'cup_image.bin').read_bytes());c.u.ctl_flush_tb()
        if meta.get('streamed_courses'):
            from cup_emulation import attach_disk
            attach_disk(c,folder)
        c.u.mem_protect(0,0x18000,UC_PROT_READ|UC_PROT_EXEC)
        c.page();self.cpu=c;self.cup_core=True
        if meta.get('streamed_courses'):c.call('cup_storage_init')
        c.call('cup_init');state(c,'music_enabled',0)

    def load_cup(self,folder):
        from editor_model import open_project
        self.project=open_project(Path(folder)/'classic_cup.qlr.json');self.index=0
        self.raw,self.model=preview_model(self.project,0);self.track=self.model['tracks'][0]
        self._load_cup_cpu(folder);self.native_loaded=True;self.cup_session=True
        self.cpu.writes.clear()

    def continue_cup(self):
        if not self.cup_session:return False
        if not self.word('cup_phase'):return False
        self.cpu.word('controls',0);self.cpu.call('cup_menu_frame')
        self.cpu.word('controls',1);self.cpu.call('cup_menu_frame')
        self.cpu.word('controls',0);self.cpu.call('cup_menu_frame')
        self._sync_course();state(self.cpu,'music_enabled',0);return True

    def _sync_course(self):
        index=self.word('cup_round')
        if index!=self.index:
            self.index=index;self.raw,self.model=preview_model(self.project,index);self.track=self.model['tracks'][0]

    def reset(self):
        c=self.cpu
        if self.cup_session:
            c.call('cup_init');self._sync_course()
        elif self.cup_core:
            count=c.symbols.get('mode_menu_course_count',3)
            self.word('cup_round',min(self.index,count-1));c.call('cup_load_track')
            self.word('cup_round',0);self.word('cup_phase',0)
            c.u.mem_write(c.symbols['track_buffer'],native_track(self.raw,False));c.call('validate_track')
            c.u.mem_write(c.symbols['cup_hills'],struct.pack('>64h',*self.project['tracks'][self.index]['hills']))
            self.word('cup_factor',round(256*1.2/(2*self.project['tracks'][self.index]['width'])))
            from build_cup import minimap
            address=int.from_bytes(c.u.mem_read(c.symbols['cup_map'],4),'big')
            c.u.mem_write(address,minimap(self.project['tracks'][self.index]))
            c.call('reset_race');c.call('cup_grid')
        else:c.call('reset_race')
        state(c,'music_enabled',0);c.writes.clear()

    def load_export(self,folder):
        self.load_cup(folder)

    def step(self,keys,rivals=True):
        c=self.cpu;controls=0
        if self.cup_session:rivals=self.word('cup_mode') in (0,3)
        if self.cup_core and 'ghost_visible' in c.symbols:
            c.u.reg_write(UC_M68K_REG_D3,int('F4' in keys))
            c.call('read_extra_controls')
        if keys&{'Up','z','Z','w','W'}:controls|=4
        if keys&{'Down','s','S'}:controls|=128
        if keys&{'Left','q','Q','a','A'}:controls|=2
        if keys&{'Right','d','D'}:controls|=16
        if 'space' in keys:controls|=64
        if 'Escape' in keys:controls|=8
        if keys&{'Control_L','Control_R'}:controls|=256
        if self.cup_session and (self.word('cup_phase') or 'Escape' in keys):
            c.word('ticks',(c.word('ticks')+1)&65535)
            c.word('controls',controls);c.call('cup_menu_frame')
            self._sync_course()
            return
        c.word('controls',controls);state(c,'opponents',int(rivals))
        c.word('ticks',(c.word('ticks')+1)&65535)
        if c.word('started'):
            at=c.symbols['state']+c.symbols['s_race_ticks'];n=int.from_bytes(c.u.mem_read(at,4),'big')+1;c.u.mem_write(at,struct.pack('>I',n&0xffffffff))
        c.call('cup_physics_tick' if self.cup_core and 'cup_physics_tick' in c.symbols else 'physics_tick');c.call('ai_tick')
        if self.cup_core:c.call('cup_tick')
        c.writes.clear()

    def describe(self):
        c=self.cpu
        fields=('x','y','angle','speed','energy','laps','horizon','goal_horizon','hills','player_section','dead','death_ticks','death_angle','boosting','hit_ticks','message','steer','ticks')
        result={k:state(c,k) for k in fields};result['steer']=signed(result['steer'])
        result.update({k:signed(state(c,k)) for k in ('vx','vy')})
        result['race_ticks']=int.from_bytes(c.u.mem_read(c.symbols['state']+c.symbols['s_race_ticks'],4),'big')
        result['rank']=1;result['cup_phase']=self.word('cup_phase') if self.cup_core else 0
        result['finishing']=self.word('cup_finishing') if self.cup_core else 0
        result['finish_heading']=self.word('cup_finish_heading') if self.cup_core else 0
        result['attack']=self.word('cup_attack_ticks') if self.cup_core and 'cup_attack_ticks' in c.symbols else 0
        result['mode']=self.word('cup_mode') if self.cup_core else 0
        if self.cup_core and result['mode'] in (0,3):
            progress=[]
            for pilot in range(3):
                c.u.reg_write(UC_M68K_REG_D7,pilot);c.call('cup_progress')
                value=c.u.reg_read(UC_M68K_REG_D0);progress.append(value-(1<<32) if value&0x80000000 else value)
            result['rank']=1+sum(p>progress[0] for p in progress[1:])
            place=self.word('cup_places')
            if place:result['rank']=place
        result['rivals']=[]
        for i in range(2):
            values=struct.unpack('>8H',c.u.mem_read(c.symbols['state']+c.symbols['s_rivals']+i*16,16))
            damage=int.from_bytes(c.u.mem_read(c.symbols['state']+c.symbols['s_npc_damage']+i*2,2),'big')
            dead=int.from_bytes(c.u.mem_read(c.symbols['cup_npc_dead']+i*2,2),'big') if self.cup_core and 'cup_npc_dead' in c.symbols else 0
            result['rivals'].append(dict(x=values[2],y=values[3],angle=values[7],hit=damage,dead=dead))
        return result

    def native_frame(self):
        phase=self.word('cup_phase') if self.cup_session else 0
        if phase not in (7,9,10,11):
            self.cpu.call('cup_draw_menu' if phase else 'render_frame')
            if self.cup_core and not phase:self.cpu.call('cup_draw_go')
        data=bytes(self.cpu.u.mem_read(0x20000,32768));self.cpu.writes.clear()
        pixels=[]
        for i in range(0,len(data),2):
            g,rb=data[i:i+2]
            for n in range(4):
                shift=6-2*n;pixels.append(PALETTE[((g>>(shift+1))&1)*4+((rb>>(shift+1))&1)*2+((rb>>shift)&1)])
        image=Image.new('RGB',(256,256));image.putdata(pixels);return image


class Camera:
    def __init__(self,engine):self.reset(engine)
    def reset(self,engine):
        s=engine.describe();a=s['angle']*math.tau/256
        self.x=s['x']/256-3.5*math.cos(a);self.y=s['y']/256-3.5*math.sin(a)
        self.angle=float(s['angle']);self.height=1.0;self.pitch=0.0
    def step(self,keys,dt):
        speed=(18 if keys&{'Shift_L','Shift_R'} else 6)*dt
        if 'Left' in keys:self.angle-=50*dt
        if 'Right' in keys:self.angle+=50*dt
        a=self.angle*math.tau/256;c,s=math.cos(a),math.sin(a)
        forward=int(bool(keys&{'Up','z','Z','w','W'}))-int(bool(keys&{'Down','s','S'}))
        side=int(bool(keys&{'d','D'}))-int(bool(keys&{'q','Q','a','A'}))
        self.x+=speed*(forward*c-side*s);self.y+=speed*(forward*s+side*c)
        self.x=max(-16,min(144,self.x));self.y=max(-16,min(144,self.y))
        self.height=max(.25,min(3,self.height+(int(bool(keys&{'e','E'}))-int(bool(keys&{'c','C'})))*dt))
        self.angle%=256


def contour_intervals(records,factor,horizon=96,height=1):
    result={}
    for at,l,r in records:
        width=max(1,round((at-horizon+2)*72*1.2/(224*height)));components=result.setdefault(at,[])
        overlaps=[v for v in components if v[0]<=r and v[1]>=l]
        if not overlaps:components.append([l,r,width,width])
        else:
            first=min(overlaps,key=lambda v:v[0]);left,lw=(l,width) if l<first[0] else (first[0],first[2])
            right,rw=(r,width) if r>first[1] else (first[1],first[3])
            for v in sorted(overlaps,key=lambda v:v[0])[1:]:
                if v[1]>right:right,rw=v[1],v[3]
            components[:]=[v for v in components if v not in overlaps]+[[left,right,lw,rw]]
        components.sort()
    painted={}
    for at,components in result.items():
        spans=[]
        for i,(l,r,lw,rw) in enumerate(components):
            previous=components[i-1][1] if i else -32768;following=components[i+1][0] if i+1<len(components) else 32767
            if 0<l<256:
                begin=max(0,l-lw,previous)
                if begin<l:spans.append((begin,l))
            if 0<=r<256:
                end=min(256,r+rw,following)
                if r<end:spans.append((r,end))
        painted[at]=spans
    return painted


def render(engine,camera=None,rivals=True,unlimited=False,wire=False):
    if engine.cup_session and engine.word('cup_phase') and not camera:return engine.native_frame()
    if not camera and 'jet_animation_phase' in engine.cpu.symbols:engine.cpu.call('jet_animation_phase')
    model=engine.model;track=engine.track;assets=model['editorAssets'];state=engine.describe()
    if camera:
        camx,camy,angle,height=camera.x,camera.y,camera.angle,camera.height
        nearest=min(range(64),key=lambda i:(track['path'][i*8][0]-camx)**2+(track['path'][i*8][1]-camy)**2)
        horizon=max(64,min(128,round(96+model['hills'][nearest]+camera.pitch)))
    else:
        angle=state['angle'];height=1.0;a=angle*math.tau/256
        camx=state['x']/256-3.5*math.cos(a);camy=state['y']/256-3.5*math.sin(a);horizon=state['horizon']
    c,s=math.cos(angle*math.tau/256),math.sin(angle*math.tau/256)
    image=Image.new('P',(256,256),0);image.putpalette([v for p in PALETTE for v in p]+[0]*(768-24));draw=ImageDraw.Draw(image)
    sky=assets['skybox'][0]
    row=Image.new('P',(256,1));row.putpalette(image.getpalette());row.putdata([sky[x%8] for x in range(256)])
    image.paste(row.resize((256,horizon-24),Image.Resampling.NEAREST),(0,24))
    for y,row0 in enumerate(assets['clouds']):
        for x in range(256):
            if row0[x%32]>=0:image.putpixel((x,28+y),row0[x%32])
    heights=[40-next(y for y in range(40) if assets['background'][y][x]>=0) for x in range(32)]
    ink=next(v for row0 in assets['background'] for v in row0 if v>=0)
    for i in range(32):draw.rectangle((i*8,horizon-heights[(int(angle)//4+i)%32],i*8+7,horizon-1),fill=ink)
    ground=assets['ground'][0]
    for x in range(256):draw.line((x,horizon,x,223),fill=ground[x%8])
    records=[]
    def polygon(points,material,record=False):
        ps=[(-s*(x-camx)+c*(y-camy),c*(x-camx)+s*(y-camy)) for x,y in points]
        if not unlimited and all(z>=32 for _,z in ps):return
        clipped=[]
        for a,b in zip(ps[-1:]+ps[:-1],ps):
            ia,ib=a[1]>=1,b[1]>=1
            if ia!=ib:
                t=(1-a[1])/(b[1]-a[1]);clipped.append((a[0]+t*(b[0]-a[0]),1))
            if ib:clipped.append(b)
        if len(clipped)<3:return
        ps=[(128+math.trunc(72*x/z),math.floor(224*height/z)) for x,z in clipped]
        top=max(0,min(y for _,y in ps));bottom=min(224-horizon,max(y for _,y in ps));top=((top+1)&-4)+2
        for y in range(top,bottom,4):
            xs=[]
            for a,b in zip(ps,ps[1:]+ps[:1]):
                if a[1]>b[1]:a,b=b,a
                if a[1]<=y<b[1]:xs.append(a[0]+(y-a[1])*(b[0]-a[0])/(b[1]-a[1]))
            if len(xs)<2:continue
            rawl,rawr=math.floor(min(xs)),math.floor(max(xs));l,r=max(0,rawl),min(256,rawr)
            if r<=l:continue
            yy=horizon+y-2
            if record:records.append((yy,rawl,rawr))
            if isinstance(material,str):
                pattern=assets[material][0]
                for x in range(l,r):draw.line((x,yy,x,min(223,yy+3)),fill=pattern[x%8])
            else:draw.rectangle((l,yy,r-1,min(223,yy+3)),fill=material)
        if wire:
            outline=[(max(-4096,min(4096,x)),max(24,min(4096,horizon+y))) for x,y in ps]
            draw.line(outline+[outline[0]],fill=6,width=1)
    mesh=track['mesh'][::2]
    for i,a in enumerate(mesh):
        b=mesh[(i+1)%32];material='repair' if i in (16,17) else 'speed' if i%4==1 else 'road'
        polygon([a[1],a[2],b[2],b[1]],material,True)
    factor=round(256*1.2/(2*engine.project['tracks'][engine.index]['width']))
    for y,spans in contour_intervals(records,factor,horizon,height).items():
        for l,r in spans:draw.rectangle((l,y,r-1,min(223,y+3)),fill=7)
    for color,points in track['markers']:polygon(points,color)
    image=image.convert('RGBA')
    def sprite(p,x,y,white=False,red=False):
        if white or red:p=[[(2 if red else 7) if v>=0 else -1 for v in row0] for row0 in p]
        art=bitmap(p);image.alpha_composite(art,(int(x),int(y)))
    if rivals:
        projected=[]
        for i,r in enumerate(state['rivals']):
            dx,dy=r['x']/256-camx,r['y']/256-camy;z=c*dx+s*dy
            if z>=3:projected.append((z,i,128+math.trunc(72*(-s*dx+c*dy)/z),math.floor(224*height/z)))
        for z,i,x,y in sorted(projected,reverse=True):
            r=state['rivals'][i];view=((r['angle']-round(angle)+32)&255)>>6;level=0 if y<14 else 1 if y<28 else 2 if y<44 else 3
            p=model['rivalViews' if i==0 else 'thirdViews'][view][level];x=(x-len(p[0])//2)&~3
            if r['dead']:
                from cup_combat_art import shared_wreck
                wreck=bitmap(shared_wreck()).resize((len(p[0]),len(p)),Image.Resampling.NEAREST)
                if r['dead']<8:
                    mask=wreck.getchannel('A');wreck=Image.new('RGBA',wreck.size,(255,255,255,0));wreck.putalpha(mask)
                image.alpha_composite(wreck,(int(x),int(horizon+y-wreck.height)))
                continue
            sprite(p,x,horizon+y-len(p),r['hit']>0 and (r['hit']>=16 or r['hit']<8))
    if not camera:
        if state['dead']:
            view=((state['death_angle']-state['angle']+32)&255)>>6
            sprite(model['wrecks'][view],116,horizon+46)
            if state['death_ticks']<64:sprite(model['explosions'][state['death_ticks']//8],104,horizon+35)
        else:
            view=((state['finish_heading']-state['angle']+32)&255)>>6 if state['finishing'] else 0
            if state['attack']:view=((40-state['attack'])//5)&3
            sprite(model['playerViews'][view],104,156,state['hit_ticks']>8,
                   state['attack']>0 and not state['attack']&8)
            if not state['finishing'] and not state['attack'] and state['speed'] and (state['boosting'] or engine.cpu.word('controls')&4):
                phase=(engine.cpu.u.mem_read(engine.cpu.symbols['state']+engine.cpu.symbols['s_jet_phase'],2)[1]
                       if 's_jet_phase' in engine.cpu.symbols else (state['ticks']>>2)&1)
                jet=(6 if state['boosting'] else 0)+(state['steer']+1)*2+phase
                mount=model['jetRender'];boost=bool(state['boosting'])
                height=mount['boost_height' if boost else 'normal_height']
                sprite(model['jets'][jet][:height],108,156+mount['boost_top' if boost else 'jet_top'])
    # Repaint HUD after sprites, retaining the native road viewport boundaries.
    draw=ImageDraw.Draw(image);draw.rectangle((0,0,255,23),fill=(0,0,0));draw.rectangle((0,224,255,255),fill=(0,0,0))
    def text(value,x,y,color=7):
        for ch in value.upper():
            glyph=model['font'].get(ch,model['font']['?'])
            for yy,line in enumerate(glyph):
                for xx,bit in enumerate(line):
                    if bit=='1':draw.point((x+1+xx,y+yy),fill=PALETTE[color])
            x+=8
    if camera:
        text(track['name'],4,2);text('CAMERA LIBRE',4,15)
        text(f'HORIZON {horizon:03}',4,232);text(f'HAUT. {height:.1f}',140,232)
    else:
        if state['mode']==3:text(f'K.O {sum(bool(r["dead"]) for r in state["rivals"])}/2',4,2)
        else:text(f'LAP {min(3,state["laps"]+1)}/3',4,2)
        text(f'{state["rank"] if rivals else 1}/3',112,2,3)
        if state['energy']>32 or not state['ticks']&16:text('ENERGY',184,2,6)
        energy=state['energy'];ink=2 if energy<=64 else 6 if energy<=128 else 4
        draw.rectangle((176,11,239,13),fill=PALETTE[0],outline=PALETTE[7])
        if energy:draw.rectangle((176,11,176+max(1,energy//4)-1,13),fill=PALETTE[ink])
        ticks=state['race_ticks'];seconds=ticks//50
        text(f'{min(99,seconds//60):02}:{seconds%60:02}.{ticks%50*2:02}',184,16)
        text(f'{display_kmh(state):04} KM/H',180,248,6)
        points=[(4+min(31,int(x/4)),224+min(23,int(y*3/16))) for x,y in engine.project['tracks'][engine.index]['points']]
        draw.line(points+[points[0]],fill=PALETTE[7])
        ships=([(r['x'],r['y'],5 if i==0 else 6) for i,r in enumerate(state['rivals'])] if rivals else [])+[(state['x'],state['y'],3)]
        for x,y,ink in ships:
            x=4+max(0,min(30,x//1024));y=224+max(0,min(22,y*3//4096))
            draw.rectangle((x,y,x+1,y+1),fill=PALETTE[ink])
    message='Too bad! You lost your machine.' if state['dead'] else 'Enemy machine destroyed!' if state['message']==6 else ('','You got boost power!','Final lap!',"You're going the wrong way!",'Finish!')[min(4,state['message'])]
    if message and not camera:
        if state['dead']:lines=['Too bad!','You lost your machine.'];y=224;h=24
        else:lines=[message];y=224;h=24
        draw.rectangle((0,y,255,y+h-1),fill=PALETTE[0],outline=PALETTE[7],width=2)
        for i,line in enumerate(lines):text(line,128-len(line)*4,y+(4 if state['dead'] else 8)+i*10)
    return image.convert('RGB')
