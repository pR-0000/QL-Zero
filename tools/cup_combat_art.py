# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Generate 52 lossless sprite frames and the two-view rival caches."""
import struct
from collections import Counter
from PIL import Image
from title_screen import compress,decompress
from generate_assets import sprite_records,pack_pixels
from sprite_codec import native,word_pack,word_unpack

def compact(pixels):
    data=bytearray([len(pixels[0]),len(pixels)])
    grouped=len(pixels)>=24;y=0
    while y<len(pixels):
        row=pixels[y];repeat=2 if grouped and y+1<len(pixels) and pixels[y+1]==row else 1
        if grouped:data.append(repeat)
        groups=[pack_pixels(row[x:x+4]) for x in range(0,len(row),4)];i=0
        while i<len(groups):
            mask,_=groups[i]
            if mask==65535:i+=1;continue
            opaque=mask==0;j=i+1
            while j<len(groups) and groups[j][0]!=65535 and (groups[j][0]==0)==opaque:j+=1
            data.extend((i*2,(j-i if opaque else -(j-i))&255))
            for at in range(i,j):
                cs=[8 if c<0 else c for c in row[at*4:at*4+4]]
                data.extend((cs[0]*9+cs[1],cs[2]*9+cs[3]))
            i=j
        data.append(255);y+=repeat
    return bytes(data)


def shared_wreck():
    """Unrecognisable charred chassis, dark blue edges and magenta contact."""
    lines=(
        '                  ', '                  ', '                  ',
        '                  ', '                  ', '                  ',
        '      10001       ', '    11000001      ', '  110000000011    ',
        ' 10001000010001   ', '1000000000000011  ', '10010000010000001 ',
        '31000000000000113 ', ' 333333333333333  ', '                  ')
    return [[-1 if c==' ' else int(c) for c in row] for row in lines]


def generate(src,model):
    frames=[p for key in ('rivalViews','thirdViews') for vs in model[key] for p in vs]
    wreck=shared_wreck();im=Image.new('I',(18,15));im.putdata([c for r in wreck for c in r])
    for w,h in ((8,8),(16,13),(24,20),(36,30)):
        if (w,h)==(36,30):p=[[c for c in row for _ in (0,1)] for row in wreck for _ in (0,1)]
        else:
            scaled=im.resize((w,h),Image.Resampling.NEAREST);values=list(scaled.getdata());p=[values[y*w:(y+1)*w] for y in range(h)]
        frames.append(p)
    # The Time Attack ghost is the user's machine, not an opponent silhouette.
    # It borrows the first NPC cache; there is no third active sprite buffer.
    for view in model['playerViews']:
        for w,h in ((12,8),(20,15),(28,22),(48,30)):
            # White rendering ignores the original ink. Preserve alpha/shape,
            # allowing more identical row pairs and much smaller LZ resources.
            frames.append([[-1 if view[y*30//h][x*48//w]<0 else 7 for x in range(w)] for y in range(h)])

    frames=[native(compact(p)) for p in frames]
    counts=Counter(w for raw in frames for w in struct.unpack('>'+str(len(raw)//2)+'H',raw))
    palette=[w for w,n in counts.most_common(255)]
    packed=[word_pack(raw,palette) for raw in frames]
    assert all(word_unpack(data,palette)==raw for data,raw in zip(packed,frames))
    entries=['cup_sprite_table:']
    for i,(raw,data) in enumerate(zip(frames,packed)):
        entries.append(f'        dc.l cup_sprite_{i}-cup_sprite_table\n        dc.w {len(data)},{len(raw)}')
    for i,data in enumerate(packed):
        entries.extend((f'cup_sprite_{i}:',''.join('        dc.b '+','.join(map(str,data[j:j+24]))+'\n' for j in range(0,len(data),24)).rstrip(),'        even'))
    capacity=max(map(len,frames));palette=palette+[0]*(255-len(palette))
    entries.extend(('cup_sprite_word_palette:',''.join('        dc.w '+','.join(str(w) for w in palette[j:j+12])+'\n' for j in range(0,len(palette),12)).rstrip(),
                    f'cup_sprite_capacity equ {capacity}','cup_sprite_scratch_bytes equ 0',
                    'cup_sprite_keys: dc.w -1,-1,-1,-1','cup_sprite_recent: dc.w 0,0','cup_sprite_scratch:',
                    f'cup_sprite_buffers: dcb.b {capacity*4},0'))
    (src/'data/cup_sprites.inc').write_text('\n'.join(entries)+'\n',encoding='ascii')
    return dict(encoding='dictionary literals and 16-bit LZ matches',packed=sum(map(len,packed)),scratch=0,
                active_sprite_bytes=capacity*4,cache_entries_per_opponent=2,frames=len(frames),
                ghost_packed_bytes=sum(map(len,packed[36:])),ghost_palette='white silhouette')
