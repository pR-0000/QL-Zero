# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""QL MODE 8 palette, masked row runs and compact explosions."""
import struct
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
PALETTE=[(0,0,0),(0,0,255),(255,0,0),(255,0,255),(0,255,0),(0,255,255),(255,255,0),(255,255,255)]
WORDS=[0x0000,0x0055,0x00aa,0x00ff,0xaa00,0xaa55,0xaaaa,0xaaff]

def words(label, values):
    out = [label + ":"]
    for i in range(0, len(values), 8):
        out.append("        dc.w    " + ",".join(f"${v & 65535:04x}" for v in values[i:i+8]))
    return "\n".join(out)


def inside_quad(x,y,ps):
    signs=[(b[0]-a[0])*(y-a[1])-(b[1]-a[1])*(x-a[0]) for a,b in zip(ps,ps[1:]+ps[:1])]
    return min(signs)>=0 or max(signs)<=0


def pack_pixels(pixels):
    """Four MODE 8 pixels -> interleaved green/flash and red/blue bytes."""
    mask = bits = 0
    for i, c in enumerate(pixels):
        if c < 0:
            mask |= 0xC0C0 >> (2*i)
        else:
            bits |= WORDS[c] & (0xC0C0 >> (2*i))
    return mask, bits


def sprite_records(pixels):
    records=[]
    width=len(pixels[0])
    assert width%4==0
    grouped=len(pixels)>=24  # small sprites keep the cheaper single-row format
    y=0
    while y<len(pixels):
        row=pixels[y]
        repeat=2 if grouped and y+1<len(pixels) and pixels[y+1]==row else 1
        if grouped:records.append(repeat)
        groups=[pack_pixels(row[x:x+4]) for x in range(0,width,4)]
        i=0
        while i<len(groups):
            mask,ink=groups[i]
            if mask==65535:i+=1;continue
            opaque=mask==0;j=i+1
            while j<len(groups) and groups[j][0]!=65535 and (groups[j][0]==0)==opaque:j+=1
            # Absolute byte offset; positive opaque count or negative mixed count.
            records.extend((i*2,j-i if opaque else -(j-i)))
            for m,p in groups[i:j]:records.extend((p,) if opaque else (m,p))
            i=j
        records.append(-1)  # end of row; fully transparent gaps cost no work
        y+=repeat
    return records


def compact_fire(pixels):
    # Four 2-bit colors per byte: transparent, red, yellow, white.
    colors={-1:0,2:1,6:2,7:3};out=bytearray()
    for row in pixels:
        occupied=[x for x in range(0,48,4) if any(c>=0 for c in row[x:x+4])]
        first,last=(occupied[0],occupied[-1]+4) if occupied else (0,0)
        out.extend((first//2,(last-first)//4))
        for x in range(first,last,4):out.append(sum(colors[row[x+i]]<<(6-i*2) for i in range(4)))
    return '        dc.b '+','.join(str(n) for n in out)+'\n        even'
