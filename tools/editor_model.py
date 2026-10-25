# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Portable editor projects and lossless UNION20 circuit/bitmap conversion."""
from __future__ import annotations

import copy
import json
import math
import os
import struct
from functools import lru_cache
from pathlib import Path

from PIL import Image
from generate_assets import PALETTE, WORDS, inside_quad

ROOT = Path(__file__).resolve().parents[1]
FORMAT = 'qlrace-editor'
VERSION = 1
CITY = [12,24,18,8,32,20,14,28,10,18,36,14,22,8,26,16,
        20,30,12,24,10,16,28,8,20,14,32,18,10,24,16,12]
ENV_KEYS = ('road','ground','speed','repair','skybox','clouds','background')
MUSIC_NAMES = ('Mute City','Big Blue','Red Canyon','Sector Alpha','Sand Ocean','Silence')
THEME_NAMES = ('Mute City','Red Canyon','Big Blue','Sector Alpha','Sand Ocean','Silence')
LEGACY_JET_RENDER = dict(jet_top=20,boost_top=20,normal_height=14,boost_height=20,phases=2)


def jet_render(project):
    return project.get('jet_render',LEGACY_JET_RENDER)


def music_bank(music):
    # Bank 4 remains the title song, including for older editor projects.
    return music+1 if music>=4 else music


def environment(project,index):
    return {k:project['tracks'][index].get('environment',{}).get(k,project['assets'][k]) for k in ENV_KEYS}


def planet_atmosphere(env):
    """Native Sector Alpha motifs: stars and the yellow limb of a planet."""
    result=copy.deepcopy(env)
    result['skybox']=[[0]*8]
    stars=[[-1]*32 for _ in range(16)]
    for x,y in ((2,3),(12,4),(25,4),(7,8),(19,12)):
        stars[y][x]=7
        for xx,yy in ((x-1,y),(x+1,y),(x,y-1),(x,y+1)):
            if 0<=xx<32 and 0<=yy<16:stars[yy][xx]=5
    for x,y,c in ((29,1,1),(17,2,5),(5,1,1),(23,9,5),(30,13,1),(3,13,5),(13,10,1),(28,7,1),(15,14,5)):
        stars[y][x]=c
    result['clouds']=stars
    # The existing column renderer draws this curve; no extra drawing pass.
    heights=[round(10+24*(.5+.5*math.cos((x-16)*math.tau/32))) for x in range(32)]
    result['background']=[[6 if y>=40-height else -1 for height in heights] for y in range(40)]
    return result


def theme(name):
    """Small native motifs; the sky bitmap is a transparent 32 x 16 overlay."""
    a=new_project()['assets'];result={k:copy.deepcopy(a[k]) for k in ENV_KEYS}
    result['skybox']=[[0]*8]
    if name=='Red Canyon':
        result['skybox']=[[5]*8];result['ground']=[[2]*8];result['road']=[[6,6,6,6,2,2,2,2]]
        heights=[24]*5+[36]*6+[20]*4+[28]*6+[40]*6+[16]*5;ink=2
    elif name=='Big Blue':
        result['skybox']=[[5]*8];result['ground']=[[1]*8];result['road']=[[4]*8]
        heights=[8,8,10,12,14,18,22,20,16,12,10,8,8,8,12,16,20,24,20,16,12,8,8,8,10,14,18,16,12,10,8,8];ink=1
        for y in range(16):
            for x in range(32):
                if any(((x-cx)/rx)**2+((y-cy)/ry)**2<=1 for cx,cy,rx,ry in ((7,6,6,3),(12,5,4,4),(24,11,6,3))):
                    result['clouds'][y][x]=7
    elif name=='Sector Alpha':
        result['ground']=[[0]*8]
        result['road']=[[1,1,5,5,4,4,3,3]]
        return planet_atmosphere(result)
    elif name=='Sand Ocean':
        result['skybox']=[[5]*8];result['ground']=[[6]*8];result['road']=[[1]*8]
        result['clouds']=[[-1]*32 for _ in range(16)]
        heights=[round(17+7*math.sin(x*math.tau/32)+5*math.sin(x*math.tau/16+.6)) for x in range(32)];ink=6
    elif name=='Silence':
        result['skybox']=[[1]*8];result['ground']=[[3]*8];result['road']=[[5]*8]
        result['clouds']=[[-1]*32 for _ in range(16)]
        # Narrow mesas and rock pillars, using the existing column skyline.
        heights=[2,3,2,31,2,2,3,3,2,18,38,16,2,3,2,32,
                 2,3,2,3,2,36,3,2,2,2,26,2,3,2,2,3];ink=6
    else:return result
    result['background']=[[ink if y>=40-h else -1 for h in heights] for y in range(40)]
    return result


def read_preview(path=None):
    p=new_project()
    return dict(font=json.loads((ROOT/'assets/font.json').read_text()),
                hills=p['tracks'][0]['hills'],bigHills=p['tracks'][2]['hills'])


@lru_cache(maxsize=6)
def _preset_environment(name):
    return {k:normalize_asset(k,p) for k,p in theme(name).items()}


def ambience_preset(project,index):
    """Identify a course's base without replacing its edited bitmaps."""
    track=project['tracks'][index];actual=environment(project,index)
    stored=track.get('environment_preset')
    if stored in THEME_NAMES:return stored,actual!=_preset_environment(stored)
    for name in THEME_NAMES:
        if actual==_preset_environment(name):return name,False
    # Older projects have no base metadata. Names/music provide a useful
    # estimate for edited presets; the GUI explicitly marks them customized.
    name=next((n for n in THEME_NAMES if track['name'].upper().startswith(n.upper())),
              MUSIC_NAMES[track['music']])
    return name,True


def new_project():
    """Return an independent copy of the six-course v1 project."""
    return json.loads((ROOT/'assets/project/classic_cup.qlr.json').read_text(encoding='utf-8'))


def asset_size(key):
    if key=='player' or key.startswith('player_'):return 24,15
    if key.startswith(('rival_','third_')):return 18,15
    if key.startswith('jet_'):return 40,24
    if key.startswith('wreck_'):return 24,18
    if key.startswith('explosion_'):return 48,40
    if key=='background':return 32,40
    if key=='clouds':return 32,16
    if key in ('road','ground','speed','repair','skybox'):return 8,1
    raise ValueError('Graphisme inconnu : '+key)


def asset_title(key):
    names={'player':'Joueur · arrière · 24 × 15 (doublé sur QL)', 'road':'Asphalte · motif 8 × 1',
           'speed':'Bandes de vitesse · motif 8 × 1', 'repair':'Recharge · motif 8 × 1',
           'skybox':'Ciel · couleur / motif 8 × 1', 'ground':'Hors piste · motif 8 × 1',
           'clouds':'Nuages / motifs du ciel · 32 × 16', 'background':'Décor · 32 colonnes × 40'}
    if key in names:return names[key]
    name,index=key.rsplit('_',1);i=int(index)
    if name=='player':return 'Joueur · '+('arrière','côté droit','face','côté gauche')[i]+' · 24 × 15'
    if name in ('rival','third'):
        return f'Adversaire {1 if name=="rival" else 2} · '+('arrière','côté droit','face','côté gauche')[i]
    if name=='jet':return f'Flammes {"boost" if i>=6 else "accélération"} · '+('gauche','centre','droite')[(i%6)//2]+f' · image {i%2+1}'
    if name=='wreck':return 'Carcasse · '+('arrière','côté droit','face','côté gauche')[i]+' · 24 × 18'
    return ('Carcasse' if name=='wreck' else 'Explosion')+f' · image {i+1}'


def quantize(image, size, fit=True, white_transparent=False, fire=False):
    image=image.convert('RGBA')
    if white_transparent:
        image.putdata([(r,g,b,0 if min(r,g,b)>245 else a) for r,g,b,a in image.getdata()])
    if fit:
        image.thumbnail(size,Image.Resampling.NEAREST)
        canvas=Image.new('RGBA',size,(0,0,0,0))
        canvas.paste(image,((size[0]-image.width)//2,(size[1]-image.height)//2))
        image=canvas
    else:image=image.resize(size,Image.Resampling.NEAREST)
    allowed=(2,6,7) if fire else range(8)
    values=[]
    for r,g,b,a in image.getdata():
        values.append(-1 if a<128 else min(allowed,key=lambda c:sum((v-t)**2 for v,t in zip((r,g,b),PALETTE[c]))))
    return [values[y*size[0]:(y+1)*size[0]] for y in range(size[1])]


def normalize_asset(key,pixels,render=None):
    w,h=asset_size(key)
    if key.startswith('jet_') and len(pixels)==20:
        pixels=copy.deepcopy(pixels)+[[-1]*w for _ in range(4)]
    if len(pixels)!=h or any(len(row)!=w for row in pixels):raise ValueError('Dimensions incorrectes : '+key)
    if any(type(c)!=int or c not in range(-1,8) for row in pixels for c in row):raise ValueError('Palette incorrecte : '+key)
    pixels=copy.deepcopy(pixels)
    if key.startswith('jet_'):
        height=(render or dict(normal_height=18,boost_height=24))['normal_height' if int(key.split('_')[1])<6 else 'boost_height']
        for y,row in enumerate(pixels):
            row[16:24]=[-1]*8
            if y>=height:row[:]=[-1]*40
    if key.startswith('explosion_'):
        pixels=[[c if c in (-1,2,6,7) else min((2,6,7),key=lambda q:sum((a-b)**2 for a,b in zip(PALETTE[c],PALETTE[q]))) for c in row] for row in pixels]
    if key in ('road','ground','speed','repair','skybox'):pixels=[[max(0,c) for c in pixels[0]]]
    if key=='background':
        occupied=[c for row in pixels for c in row if c>=0]
        ink=max(range(8),key=lambda c:occupied.count(c)) if occupied else 3
        heights=[max(8,min(40,40-next((y for y in range(40) if pixels[y][x]>=0),40))) for x in range(32)]
        pixels=[[ink if y>=40-heights[x] else -1 for x in range(32)] for y in range(40)]
    return pixels


def bitmap(pixels,checker=False):
    h,w=len(pixels),len(pixels[0]);im=Image.new('RGBA',(w,h))
    im.putdata([(*PALETTE[c],255) if c>=0 else ((48,59,71,255) if checker and (x+y)%2 else (26,35,45,255)) if checker else (0,0,0,0)
                for y,row in enumerate(pixels) for x,c in enumerate(row)])
    return im


def validate_project(project):
    if not isinstance(project,dict) or project.get('format')!=FORMAT or project.get('version')!=VERSION:
        raise ValueError('Ce fichier n’est pas un projet QL Racing Editor version 1.')
    if not isinstance(project.get('tracks'),list) or not 1<=len(project['tracks'])<=32:raise ValueError('Nombre de circuits incorrect.')
    # Version 1 projects predating per-course environments remain readable.
    for k in ('ground','clouds'):project.setdefault('assets',{}).setdefault(k,copy.deepcopy(new_project()['assets'][k]))
    defaults=new_project()['assets']
    for k in ('player_1','player_2','player_3'):
        project['assets'].setdefault(k,copy.deepcopy(defaults[k]))
    if set(project.get('assets',{}))!=set(new_project()['assets']):raise ValueError('La liste des graphismes est incomplète.')
    render=project.setdefault('jet_render',copy.deepcopy(LEGACY_JET_RENDER))
    if (not isinstance(render,dict) or set(render)!=set(LEGACY_JET_RENDER)
        or any(type(v)!=int for v in render.values()) or render['phases']!=2
        or any(not 0<=render[k]<=24 for k in ('jet_top','boost_top'))
        or any(not 1<=render[k]<=24 for k in ('normal_height','boost_height'))):
        raise ValueError('Position ou dimensions des flammes incorrectes.')
    for k,p in project['assets'].items():project['assets'][k]=normalize_asset(k,p,render)
    for track in project['tracks']:
        env=track.get('environment',{})
        if not isinstance(env,dict) or any(k not in ENV_KEYS for k in env):raise ValueError('Ambiance du circuit incorrecte.')
        for k,p in env.items():env[k]=normalize_asset(k,p)
        if not isinstance(track.get('name'),str) or not 1<=len(track['name'])<=16:raise ValueError('Le nom doit contenir entre 1 et 16 caractères.')
        try:track['name'].encode('ascii')
        except UnicodeEncodeError:raise ValueError('Le nom QL doit utiliser des caractères ASCII.')
        if not isinstance(track.get('points'),list) or len(track['points'])!=32:raise ValueError('Un circuit UNION20 possède 32 points.')
        if any(len(p)!=2 or any(type(v) not in (int,float) or not math.isfinite(v) or not 0<=v<=128 for v in p) for p in track['points']):raise ValueError('Coordonnées incorrectes.')
        if type(track.get('width')) not in (int,float) or not math.isfinite(track['width']) or not 3<=track['width']<=7:raise ValueError('La demi-largeur doit être comprise entre 3 et 7.')
        if len(track.get('hills',[]))!=64 or any(type(v)!=int or v not in range(-32,33,4) for v in track['hills']):raise ValueError('Le relief doit contenir 64 valeurs, multiples de 4 entre −32 et 32.')
        if type(track.get('music'))!=int or track['music'] not in range(len(MUSIC_NAMES)):raise ValueError('Musique incorrecte.')
    return project


def save_project(project,path):
    validate_project(project);path=Path(path)
    temp=path.with_name(path.name+'.tmp')
    temp.write_text(json.dumps(project,ensure_ascii=False,indent=2),encoding='utf-8')
    os.replace(temp,path)


def open_project(path):
    path=Path(path)
    if path.stat().st_size>8*1024*1024:raise ValueError('Le fichier de projet dépasse 8 Mo.')
    return validate_project(json.loads(path.read_text(encoding='utf-8')))


def resample_closed(points,count=32):
    lengths=[0.0]
    for a,b in zip(points,points[1:]+points[:1]):lengths.append(lengths[-1]+math.dist(a,b))
    if lengths[-1]<1:raise ValueError('Le circuit est trop court.')
    result=[];j=0
    for i in range(count):
        target=i*lengths[-1]/count
        while j<len(points)-1 and lengths[j+1]<target:j+=1
        span=lengths[j+1]-lengths[j];f=(target-lengths[j])/span if span else 0
        result.append([points[j][a]+(points[(j+1)%len(points)][a]-points[j][a])*f for a in (0,1)])
    return result


def track_geometry(track):
    points=track['points'];caps=[];width=track['width']
    for i,(x,y) in enumerate(points):
        prev,next=points[(i-1)%32],points[(i+1)%32];dx,dy=next[0]-prev[0],next[1]-prev[1]
        length=math.hypot(dx,dy)
        if length<.01:raise ValueError(f'Point {i+1} : direction indéfinie ; écartez les points voisins.')
        nx,ny=-dy/length,dx/length
        caps.append([[round((x+nx*w)*256)/256,round((y+ny*w)*256)/256]
                     for w in (-width-1.2,-width,width,width+1.2)])
    mesh=[]
    for i,a in enumerate(caps):
        b=caps[(i+1)%32];mesh.extend([a,[[round((p[k]+q[k])*128)/256 for k in (0,1)] for p,q in zip(a,b)]])
    path=[[round((points[i//16][k]+(points[(i//16+1)%32][k]-points[i//16][k])*(i%16)/16)*256)/256 for k in (0,1)] for i in range(512)]
    return mesh,path


def track_issues(track):
    errors=[]
    try:mesh,path=track_geometry(track)
    except ValueError as exc:return [str(exc)]
    for i in range(32):
        a,b=mesh[i*2],mesh[((i+1)*2)%64]
        if math.dist(track['points'][i],track['points'][(i+1)%32])<.6:errors.append(f'Tronçon {i+1} trop court.')
        if any(not 1<=v<=127 for p in a for v in p):errors.append(f'Bordure {i+1} hors de la carte ; rapprochez le point du centre.')
        quad=[a[0],a[3],b[3],b[0]]
        cross=[(q[0]-p[0])*(r[1]-q[1])-(q[1]-p[1])*(r[0]-q[0]) for p,q,r in zip(quad,quad[1:]+quad[:1],quad[2:]+quad[:2])]
        if min(cross)<-1e-6 and max(cross)>1e-6:errors.append(f'Virage {i+1} replié ; élargissez le rayon ou réduisez la largeur.')
    return errors


def widen_track(track,percent):
    """Widen asphalt and its collision rails together, keeping the centreline."""
    if not math.isfinite(percent) or not 0<percent<=50:
        raise ValueError('Choisissez un élargissement entre 1 et 50 %.')
    candidate=copy.deepcopy(track)
    candidate['width']=round(min(7,track['width']*(1+percent/100)),2)
    if candidate['width']<=track['width']:
        raise ValueError('Ce circuit a déjà la demi-largeur maximale de 7.')
    errors=track_issues(candidate)
    if errors and not track_issues(track):
        # Existing tight turns may not accept the whole requested increase.
        # Use the widest safe hundredth instead of folding/cropping the rails.
        for width in range(round(candidate['width']*100)-1,round(track['width']*100),-1):
            candidate['width']=width/100
            if not track_issues(candidate):return candidate
    if errors:
        raise ValueError('Cet élargissement ferait sortir ou replier des bordures.\n'
                         'Réduisez le pourcentage ou rapprochez les points du centre.\n\n'+'\n'.join(errors[:4]))
    return candidate


def make_track(track):
    errors=track_issues(track)
    if errors:raise ValueError('\n'.join(errors[:8]))
    mesh,path=track_geometry(track);grid=bytearray(16384)
    # Map/AI and rendering all use this exact 32-quad ribbon.
    for i in range(32):
        a,b=mesh[i*2],mesh[((i+1)*2)%64];outer=[a[0],a[3],b[3],b[0]];inner=[a[1],a[2],b[2],b[1]]
        repair=i in (16,17);boost=i==2
        for y in range(max(0,math.floor(min(p[1] for p in outer))),min(128,math.ceil(max(p[1] for p in outer)))):
            for x in range(max(0,math.floor(min(p[0] for p in outer))),min(128,math.ceil(max(p[0] for p in outer)))):
                at=y*128+x
                if inside_quad(x+.5,y+.5,inner):grid[at]=8|1|(64 if repair else 0)|(16 if boost else 0)
                elif inside_quad(x+.5,y+.5,outer) and not grid[at]&8:grid[at]=32|7
    gates=[]
    for i in range(4):
        x,y=path[i*128];r=track['width']+1
        gates.append([round(max(1,x-r)*256),round(max(1,y-r)*256),round(min(127,x+r)*256),round(min(127,y+r)*256)])
    # Start is at node 1; spawn on the last ribbon segment, just before it.
    x,y=path[508];a,b=path[508],path[0];angle=round(math.atan2(b[1]-a[1],b[0]-a[0])*256/math.tau)&255
    spawn=[round(x*256),round(y*256),angle]
    markers=[]
    for i,color,fraction in ((0,7,.12),(2,6,1.0)):
        a,b=mesh[2*i],mesh[(2*i+2)%64]
        markers.append((color,[a[1],a[2],[a[2][k]+(b[2][k]-a[2][k])*fraction for k in (0,1)],
                                      [a[1][k]+(b[1][k]-a[1][k])*fraction for k in (0,1)]]))
    flat_mesh=b''.join(struct.pack('>8H',*(round(v*256) for p in cap for v in p)) for cap in mesh)
    marker_bytes=b''.join(struct.pack('>9H',c,*(round(v*256) for p in ps for v in p)) for c,ps in markers)
    waypoints=b''.join(struct.pack('>2H',*(round(v*256) for v in path[i*8])) for i in range(64))
    header=struct.pack('>4s6H',b'QZR1',2,128,128,*spawn)+track['name'].encode('ascii').ljust(16,b'\0')
    header+=b''.join(struct.pack('>4H',*g) for g in gates)
    header+=struct.pack('>8H',64,16480,2,17504,17540,music_bank(track['music']),int(track['width']<5.2),round(128/track['width']))
    raw=header.ljust(96,b'\0')+bytes(grid)+flat_mesh+marker_bytes+waypoints
    assert len(raw)==17796
    if not grid[(spawn[1]>>8)*128+(spawn[0]>>8)]&8:raise ValueError('Le départ se trouve hors de la route ; déplacez les derniers points.')
    return raw,dict(name=track['name'],data=list(grid),spawn=spawn,gates=gates,mesh=mesh,path=path,
                    markers=markers,music=track['music'],profile=int(track['width']<5.2),
                    normalFactor=round(128/track['width']))


def native_track(raw,pvs=True):
    from compact_track import pack
    from compact_render_mesh import pack as compact_render
    data=bytearray(raw);data[4:6]=b'\0\4'
    render=b''.join((int.from_bytes(raw[at:at+2],'big')>>1).to_bytes(2,'big') for at in range(16480,17504,2))
    from road_visibility import generate
    data+=render+(generate(render) if pvs else b'\xff'*512)
    try:data=pack(data)
    except AssertionError as exc:raise ValueError('La carte est trop complexe pour le dictionnaire QL 128 Kio. Simplifiez quelques virages ou zones proches.') from exc
    result=compact_render(data);assert len(result)==11312
    return result


def import_track(path):
    """Import all existing full/native layouts; editable render caps are authoritative."""
    data=Path(path).read_bytes()
    if data[:4]!=b'QZR1' or len(data)<96:raise ValueError('Ce fichier n’est pas un circuit QZR1.')
    version=int.from_bytes(data[4:6],'big')
    sizes={2:17796,3:18820,4:19332,6:11824,8:11312}
    if version not in sizes or len(data)!=sizes[version]:raise ValueError('Format de circuit non pris en charge ou fichier incomplet.')
    off=int.from_bytes(data[66:68],'big');caps=[]
    if off+1024>len(data):raise ValueError('Maillage tronqué.')
    for i in range(0,64,2):
        values=struct.unpack('>8H',data[off+i*16:off+(i+1)*16])
        caps.append([[values[j]/256,values[j+1]/256] for j in range(0,8,2)])
    points=[[(p[1][k]+p[2][k])/2 for k in (0,1)] for p in caps]
    width=sum(math.dist(p[1],p[2])/2 for p in caps)/32
    model=read_preview();profile=int.from_bytes(data[76:78],'big')
    return dict(name=data[16:32].split(b'\0',1)[0].decode('ascii','replace'),points=points,
                width=round(max(3,min(7,width)),2),music=4 if int.from_bytes(data[74:76],'big')==5 else min(3,int.from_bytes(data[74:76],'big')),
                hills=copy.deepcopy(model['bigHills'] if profile else model['hills']))


def preview_model(project,track_index):
    model=read_preview();assets={**project['assets'],**environment(project,track_index)};raw,track=make_track(project['tracks'][track_index])
    player=assets['player'];model['ships']=[[[player[y//2][x//2] for x in range(48)] for y in range(30)]]*3
    model['playerViews']=[model['ships'][1]]+[
        [[assets[f'player_{i}'][y//2][x//2] for x in range(48)] for y in range(30)] for i in range(1,4)]
    for key,name in (('rival','rivalViews'),('third','thirdViews')):
        model[name]=[]
        for view in range(4):
            p=assets[f'{key}_{view}'];model[name].append([[[p[y*15//h][x*18//w] for x in range(w)] for y in range(h)] for w,h in ((12,8),(20,15),(28,22),(36,30))])
    model['rivals']=model['rivalViews'][0];model['third']=model['thirdViews'][0]
    model['jets']=[assets[f'jet_{i}'] for i in range(12)]
    model['jetRender']=copy.deepcopy(jet_render(project))
    model['wrecks']=[assets[f'wreck_{i}'] for i in range(4)]
    model['explosions']=[assets[f'explosion_{i}'] for i in range(8)]
    model['tracks']=[track];model['hills']=model['bigHills']=project['tracks'][track_index]['hills']
    model['editorAssets']=copy.deepcopy(assets)
    return raw,model
