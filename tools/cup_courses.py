# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Cup defaults and circuit contact sheet."""
from editor_model import new_project

def project():return new_project()

def map_preview(p,path):
    from PIL import Image, ImageDraw
    from editor_model import make_track, PALETTE
    canvas=Image.new('RGB',(440*len(p['tracks']),520),(14,17,24));draw=ImageDraw.Draw(canvas)
    for i,t in enumerate(p['tracks']):
        raw,model=make_track(t);im=Image.new('RGB',(128,128))
        im.putdata([PALETTE[v&7] if v else (12,12,18) for v in model['data']])
        canvas.paste(im.resize((400,400),Image.Resampling.NEAREST),(20+440*i,58))
        draw.text((20+440*i,24),t['name'],fill='white')
        x,y=model['spawn'][:2];x=20+440*i+x/256*400/128;y=58+y/256*400/128
        draw.ellipse((x-4,y-4,x+4,y+4),fill='lime')
        xs=[q[0] for q in t['points']];ys=[q[1] for q in t['points']]
        draw.text((20+440*i,475),f'128 x 128 | {max(xs)-min(xs):.0f} x {max(ys)-min(ys):.0f} units | 3 laps',fill=(210,210,220))
    canvas.save(path)
