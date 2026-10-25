# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Lossless cup sequencer with only 512 bytes of decoded history."""
import re
from title_screen import ROOT,compress_optimal,decompress


PREFIXES=('', 'blue_', 'red_', 'sector_', 'title_', 'sand_', 'silence_')


def events(text):
    header,stream=text.replace('blue_music_','music_').split('music_data:',1)
    tokens=[(k,int(v[1:],16) if v.startswith('$') else int(v))
            for k,v in re.findall(r'dc\.([bw])\s+(\$[0-9a-fA-F]+|\d+)',stream)]
    assert tokens[-1]==('b',255) and len(tokens)%3==1
    result=[]
    for n in range(0,len(tokens)-1,3):
        pitch,duration,effect=tokens[n:n+3]
        assert (pitch[0],duration[0],effect[0])==('b','w','b')
        p,t,e=pitch[1],duration[1],effect[1]
        assert 0<=p<255 and 1<=t<=32767 and 0<=e<=255
        result.append((p,t,e))
    return header,result


def encode(source):
    header,notes=events(source);raw=bytearray()
    for p,t,e in notes:
        raw.extend((p,t|(e<<7)) if t<128 and e<2 else (p,0,t>>8,t&255,e))
    raw.append(255)
    packed=compress_optimal(bytes(raw),max_distance=512,chain_limit=512)
    assert decompress(packed,len(raw))==raw
    return header,bytes(raw),packed


def install(src,red,sand=False,silence=False):
    sources=[(ROOT/'assets/music/music_mute_city.inc').read_text(),
             (ROOT/'assets/music/music_big_blue.inc').read_text(),red,
             (ROOT/'assets/music/music_sector_alpha.inc').read_text(),
             (ROOT/'assets/music/music_title.inc').read_text()]
    # Keep title=4 and Sand Ocean=5 stable, even for a Silence-only selection.
    if sand or silence:sources.append((ROOT/'assets/music/music_sand_ocean.inc').read_text())
    if silence:sources.append((ROOT/'assets/music/music_silence.inc').read_text())
    # Append after the course banks; their existing IDs remain unchanged.
    result_bank=len(sources)
    sources.append((ROOT/'assets/music/music_results.inc').read_text())
    prefixes=PREFIXES[:result_bank]+('results_',)
    banks=[f'cup_results_music_bank equ {result_bank}','        even','cup_music_banks:']
    for prefix,source in zip(prefixes,sources):
        header,_,_=encode(source)
        loop=int(re.search(r'music_loop\s+equ\s+(\d+)',header)[1])
        banks.append(f'        dc.w {prefix}music_data-cup_music_banks,{prefix}music_effects-cup_music_banks,{loop}')
    for prefix,source in zip(prefixes,sources):
        header,raw,packed=encode(source)
        header=header.replace('music_format_version equ 2','music_format_version equ 6')
        data=header+'music_data:\n'+''.join('        dc.b '+','.join(map(str,packed[i:i+24]))+'\n' for i in range(0,len(packed),24))+'        even\n'
        if prefix:data=data.replace('music_',prefix+'music_')
        banks.append(data)
    (src/'data/music_cup.inc').write_text('\n'.join(banks),encoding='ascii')
    return len(sources)
