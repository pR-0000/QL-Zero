# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Data conversion helpers and export of a full playable cup."""
import re
from generate_assets import pack_pixels,sprite_records,words,compact_fire

def replace_words(source,label,values):
    pattern=re.escape(label)+r':\n(?:[ \t]+dc\.w[^\n]*\n)+'
    source,n=re.subn(pattern,lambda m:words(label,values)+'\n',source,count=1)
    if n!=1:raise ValueError('Table native introuvable : '+label)
    return source


def texture_word(pixels):
    row=pixels[0]
    return (pack_pixels(row[:4])[1]<<16)|pack_pixels(row[4:8])[1]


def cloud_words(assets):
    return [texture_word([[assets['skybox'][0][x%8] if c<0 else c for x,c in enumerate(row)][i:i+8]])
            for row in assets['clouds'] for i in range(0,32,8)]


def symbols(listing):
    result={}
    for line in listing.read_text(encoding='utf-8',errors='replace').split('Symbols by value:')[-1].splitlines():
        match=re.match(r'\s*([0-9A-Fa-f]{8})\s+([A-Za-z_][\w.]*)\s*$',line)
        if match:result[match[2]]=int(match[1],16)
    if 'race_entry' not in result:raise ValueError('Les adresses du binaire exporté sont introuvables.')
    return result
