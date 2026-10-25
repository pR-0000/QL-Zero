# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Compile shared MODE 8 menu graphics for the loader and resident selector."""
import json
import struct
from PIL import Image
from title_screen import ROOT,ASSETS,compress,decompress,encode,decode,lettering
from editor_model import open_project
from generate_assets import PALETTE

# Glyphs use seven lit rows; the native records renderer reserves eight.
# A 13-row rhythm fills the footer; rows 248..255 remain reserved for I/O.
RULES_Y=200
RECORDS_Y=213
RECORDS_ROWS=8
MODE_KEYS_Y=226
COURSE_KEYS_Y=239
ICON_Y=38
LABEL_Y=130
CAPTION_Y=150
PREVIEW_Y=163
ICON_BANK_BYTES=36//2*84*4
BACKGROUND_BANDS=((4,26),(LABEL_Y,LABEL_Y+7),(MODE_KEYS_Y,COURSE_KEYS_Y+7))

def course_preview(track):
    """Sparse 1-bit words, no runtime geometry or decompression scratch."""
    from PIL import ImageDraw
    from editor_model import make_track
    _,model=make_track(track)
    points=model['path'];xs,ys=zip(*points)
    scale=min(58/(max(xs)-min(xs)),26/((max(ys)-min(ys))*4/3))
    cx,cy=(max(xs)+min(xs))/2,(max(ys)+min(ys))/2
    pts=[(round(31.5+(x-cx)*scale),round(15.5+(y-cy)*scale*4/3)) for x,y in points]
    im=Image.new('1',(64,32));ImageDraw.Draw(im).line(pts+[pts[0]],fill=1)
    x,y=pts[0];marker=y*128+(x//4)*2
    packed=bytearray(struct.pack('>H',marker))
    pixels=[[0]*256 for _ in range(32)]
    for y in range(32):
        row=[sum(int(im.getpixel((4*x+k,y)))<<(3-k) for k in range(4)) for x in range(16)]
        used=[x for x,v in enumerate(row) if v]
        start,end=(min(used),max(used)+1) if used else (0,0)
        packed.extend((start*2,end-start))
        for i in range(start,end,2):packed.append((row[i]<<4)|(row[i+1] if i+1<end else 0))
        for x in range(64):pixels[y][96+x]=7 if im.getpixel((x,y)) else 0
    x,y=pts[0]
    for k in range(4):pixels[y][96+(x//4)*4+k]=4
    return bytes(packed),pixels


def compile_menu(cup_project=None):
    icons=[]
    for name in ('gp','time_attack','practice','death_race'):
        editable=ASSETS/f'menu_{name}.png'
        icon=Image.open(editable).convert('RGB')
        if icon.size!=(36,84):raise ValueError(f'{editable.name}: use 36 x 84 pixels.')
        icons.append(icon)
    project=cup_project if cup_project is not None else open_project(ROOT/'assets/project/classic_cup.qlr.json')
    font=json.loads((ROOT/'assets/font.json').read_text())
    base=[[0]*256 for _ in range(256)]
    lettering(base,'QL-ZERO',4,5);lettering(base,'SELECT MODE',19,6)
    icon_bank=bytearray()
    for i,icon in enumerate(icons):
        pixels=[]
        for y in range(icon.height):
            row=[]
            for x in range(icon.width):
                rgb=icon.getpixel((x,y))
                color=min(range(8),key=lambda c:sum((a-b)**2 for a,b in zip(rgb,PALETTE[c])))
                base[ICON_Y+y][20+60*i+x]=color;row.append(color)
            pixels.append(row)
        icon_bank.extend(encode(pixels))
    for text,x,color in (('GP',32,4),('TIME',86,3),('PRACTICE',134,6),('DEATH',200,2)):
        for i,ch in enumerate(text):
            for y,line in enumerate(font[ch]):
                for k,bit in enumerate(line):
                    if bit=='1':base[LABEL_Y+y][x+6*i+k]=color
    lettering(base,'LEFT/RIGHT: MODE',MODE_KEYS_Y,7)
    lettering(base,'UP/DOWN: COURSE/LEVEL',COURSE_KEYS_Y,7)
    # Keep the last eight rows black for LOADING / SAVING overlays.
    # One shared icon dictionary in the existing scene workspace. Copy only
    # the two affected icons, applying the checker to each word BEFORE VRAM.
    assert len(icon_bank)==ICON_BANK_BYTES
    icon_packed=compress(bytes(icon_bank))
    (ASSETS/'mode_menu_icons.lz').write_bytes(icon_packed)
    background=[]
    for i,(top,bottom) in enumerate(BACKGROUND_BANDS):
        packed=compress(encode(base[top:bottom]));background.append(packed)
        (ASSETS/f'mode_menu_background_{i}.lz').write_bytes(packed)
    entries=[];banks=[];indices=[]
    previews=[course_preview(t) for t in project['tracks']]
    def bank(data):
        if data not in banks:banks.append(data)
        return banks.index(data)
    course_count=len(project['tracks'])
    for i in range(4+3*course_count):
        mode=0 if i<4 else 1+(i-4)//course_count
        option=i if mode==0 else (i-4)%course_count
        rows=[r[:] for r in base]
        # Black checkerboard dims only the three unselected icons. The chosen
        # sprite retains every pixel, with no extra selection frame.
        for icon_index in range(4):
            if icon_index==mode:continue
            for y in range(84):
                for x in range(36):
                    if (x+y)&1:rows[ICON_Y+y][20+60*icon_index+x]=0
        if mode==0:
            lettering(rows,'CLASSIC CUP',CAPTION_Y,4)
            lettering(rows,('NOVICE','STANDARD','EXPERT','MASTER')[option],RULES_Y,7)
        else:
            lettering(rows,project['tracks'][option]['name'][:31],CAPTION_Y,3 if mode==1 else 6)
            rows[PREVIEW_Y:PREVIEW_Y+32]=[r[:] for r in previews[option][1]]
            lettering(rows,('3 LAPS - SOLO' if mode==1 else 'FREE LAPS - FULL ENERGY' if mode==2 else 'DESTROY BOTH - FASTEST TIME'),RULES_Y,7)
        top,bottom=CAPTION_Y,RULES_Y
        raw=encode(rows);indices.append((bank(encode(rows[top:top+7])),bank(encode(rows[bottom:bottom+7]))))
        (ASSETS/f'mode_menu_{i}.q8').write_bytes(raw)
    lines=[f'mode_menu_course_count equ {course_count}',f'mode_menu_rules_y equ {RULES_Y}',f'mode_menu_records_y equ {RECORDS_Y}',
           f'mode_menu_records_rows equ {RECORDS_ROWS}',
           f'mode_menu_icon_y equ {ICON_Y}',f'mode_menu_icon_bank_bytes equ {ICON_BANK_BYTES}',
           f'mode_menu_caption_y equ {CAPTION_Y}',f'mode_menu_preview_y equ {PREVIEW_Y}',
           '        even','mode_menu_data:','        dc.l mode_menu_background-mode_menu_data']
    for top,bottom in indices:lines.append(f'        dc.l mode_menu_caption_{top}-mode_menu_data,mode_menu_caption_{bottom}-mode_menu_data')
    lines.extend(('mode_menu_previews_offset equ mode_menu_previews-mode_menu_data','mode_menu_previews:'))
    for i in range(course_count):lines.append(f'        dc.l mode_menu_preview_{i}-mode_menu_data')
    for i,(packed,_) in enumerate(previews):
        (ASSETS/f'mode_menu_preview_{i}.bin').write_bytes(packed)
        lines.extend((f'mode_menu_preview_{i}:',f'        incbin "../assets/title/mode_menu_preview_{i}.bin"','        even'))
    for i,raw in enumerate(banks):
        packed=compress(raw);assert decompress(packed,len(raw))==raw
        (ASSETS/f'mode_menu_caption_{i}.lz').write_bytes(packed);entries.append(len(packed))
        lines.extend((f'mode_menu_caption_{i}:',f'        incbin "../assets/title/mode_menu_caption_{i}.lz"','        even'))
    lines.extend(('mode_menu_icons_offset equ mode_menu_icons-mode_menu_data','mode_menu_icons:',
                  '        incbin "../assets/title/mode_menu_icons.lz"','        even',
                  'mode_menu_background:'))
    for i,(top,bottom) in enumerate(BACKGROUND_BANDS):
        lines.extend((f'        dc.l mode_menu_background_{i}-mode_menu_data',f'        dc.w {top*128},{bottom*128}'))
    lines.append('        dc.l 0')
    for i in range(len(BACKGROUND_BANDS)):
        lines.extend((f'mode_menu_background_{i}:',f'        incbin "../assets/title/mode_menu_background_{i}.lz"','        even'))
    (ASSETS/'mode_menu.inc').write_text('\n'.join(lines)+'\n',encoding='ascii')
    decode((ASSETS/'mode_menu_1.q8').read_bytes()).resize((1024,768),Image.Resampling.NEAREST).save(ASSETS/'mode-menu-preview.png')
    return dict(background=sum(map(len,background)),icons=len(icon_packed),captions=entries,
                previews=[len(p[0]) for p in previews],icon_scratch_bytes=ICON_BANK_BYTES)


if __name__=='__main__':print(compile_menu())
