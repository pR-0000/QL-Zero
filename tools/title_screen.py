# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Compile the QL-ZERO title to MODE 8 and package unchanged UNION20 games.

No image buffer remains in the race. The relocatable title file occupies the
future game allocation, decompresses to VRAM, and retains only a ready footer
in a 512-byte prefix. QDOS loads the game over the compressed title afterwards.
"""
from __future__ import annotations

import argparse
from collections import defaultdict, deque
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys

from PIL import Image
from generate_assets import PALETTE, pack_pixels

ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT/'assets/title'
PREFIX = 512
TITLE_VERSION = 2
SCREEN_BYTES = 32768


def compress(data,chain_limit=96,max_distance=65535):
    """Literals 1..128 bytes or backward copies 3..130, unsigned BE distance.

    Byte-oriented decoding permits overlapping matches, all 68000 addresses
    and no aligned-word assumptions. Three-byte match commands and a bounded
    hash chain keep the compiler simple; decoding needs no dictionary RAM.
    """
    output=bytearray();literal=bytearray();chains=defaultdict(lambda:deque(maxlen=chain_limit))
    def flush():
        if literal:output.append(len(literal)-1);output.extend(literal);literal.clear()
    def remember(at):
        if at+2<len(data):chains[data[at:at+3]].append(at)
    pos=0
    while pos<len(data):
        length=0;distance=0;limit=min(130,len(data)-pos)
        if limit>=3:
            for at in reversed(chains[data[pos:pos+3]]):
                if pos-at>max_distance:break
                n=3
                while n<limit and data[at+n]==data[pos+n]:n+=1
                if n>length:length=n;distance=pos-at
                if n==limit:break
        if length>=4:
            flush();output.append(128+length-3);output.extend(distance.to_bytes(2,'big'))
            for at in range(pos,pos+length):remember(at)
            pos+=length
        else:
            literal.append(data[pos]);remember(pos);pos+=1
            if len(literal)==128:flush()
    flush();return bytes(output)


def decompress(data,expected=SCREEN_BYTES):
    out=bytearray();pos=0
    while pos<len(data):
        code=data[pos];pos+=1
        if code<128:
            count=code+1
            if pos+count>len(data):raise ValueError('Truncated title literals.')
            out.extend(data[pos:pos+count]);pos+=count
        else:
            count=(code&127)+3
            if pos+2>len(data):raise ValueError('Truncated title reference.')
            distance=int.from_bytes(data[pos:pos+2],'big');pos+=2
            if not 0<distance<=len(out):raise ValueError('Invalid title distance.')
            for _ in range(count):out.append(out[-distance])
        if len(out)>expected:raise ValueError('Title exceeds screen memory.')
    if len(out)!=expected:raise ValueError('Incomplete title screen.')
    return bytes(out)


def compress_optimal(data,max_distance=65535,chain_limit=1024):
    """Minimum-cost parsing of the same native LZ commands (bounded search).

    This costs build time only: the 68008 decoder and decoded bytes are
    unchanged. Greedy parsing misses short matches near literal boundaries.
    """
    chains=defaultdict(lambda:deque(maxlen=chain_limit));matches=[]
    for pos in range(len(data)):
        length=0;distance=0;limit=min(130,len(data)-pos)
        if limit>=3:
            key=data[pos:pos+3]
            for at in reversed(chains[key]):
                if pos-at>max_distance:break
                n=3
                while n<limit and data[at+n]==data[pos+n]:n+=1
                if n>length:length=n;distance=pos-at
                if n==limit:break
            chains[key].append(pos)
        matches.append((length,distance))
    costs=[0]*(len(data)+1);choices=[None]*len(data)
    for pos in range(len(data)-1,-1,-1):
        count=min(range(1,min(128,len(data)-pos)+1),key=lambda n:n+1+costs[pos+n])
        cost=count+1+costs[pos+count];choice=(count,0)
        length,distance=matches[pos]
        for n in range(3,length+1):
            candidate=3+costs[pos+n]
            if candidate<cost:cost=candidate;choice=(n,distance)
        costs[pos]=cost;choices[pos]=choice
    out=bytearray();pos=0
    while pos<len(data):
        n,distance=choices[pos]
        if distance:out.append(128+n-3);out.extend(distance.to_bytes(2,'big'))
        else:out.append(n-1);out.extend(data[pos:pos+n])
        pos+=n
    assert decompress(bytes(out),len(data))==data
    return bytes(out)


def encode(rows):
    return b''.join(pack_pixels(row[x:x+4])[1].to_bytes(2,'big') for row in rows for x in range(0,len(row),4))


def decode(data,width=256):
    pixels=[]
    for green,redblue in zip(data[::2],data[1::2]):
        for shift in (6,4,2,0):
            pixels.append(PALETTE[((green>>(shift+1))&1)*4+((redblue>>(shift+1))&1)*2+((redblue>>shift)&1)])
    image=Image.new('RGB',(width,len(pixels)//width));image.putdata(pixels);return image


def lettering(rows,text,y,color=7):
    font=json.loads((ROOT/'assets/font.json').read_text())
    width=len(rows[0]);start=(width-(len(text)*6-1))//2
    if start<0:raise ValueError('Title footer too wide.')
    for i,c in enumerate(text):
        for j,line in enumerate(font.get(c,font['?'])):
            for x,bit in enumerate(line):
                if bit=='1':rows[y+j][start+6*i+x]=color


def compile_title():
    ASSETS.mkdir(exist_ok=True)
    # Native format conversion, not artwork editing. Pixels are twice as wide
    # physically; a 4:3 illustration becomes the QL's 256 x 256 pixel array.
    image=Image.open(ASSETS/'ql-zero-title-art.png').convert('RGB').resize((256,256),Image.Resampling.NEAREST)
    flat=[min(range(8),key=lambda c:sum((a-b)**2 for a,b in zip(rgb,PALETTE[c]))) for rgb in image.getdata()]
    rows=[flat[y*256:(y+1)*256] if y<224 else [0]*256 for y in range(256)]
    lettering(rows,'LOADING...',248,6)
    ready=[[0]*96 for _ in range(8)];lettering(ready,'PRESS ENTER',0,7)
    raw=encode(rows);packed=compress(raw)
    assert len(raw)==SCREEN_BYTES and decompress(packed)==raw
    assert all(raw[i]&0x55==0 for i in range(0,len(raw),2)), 'Hardware flash bit must stay clear.'
    (ASSETS/'loading.q8').write_bytes(raw);(ASSETS/'loading.lz').write_bytes(packed)
    (ASSETS/'ready.q8').write_bytes(encode(ready))
    decode(raw).resize((1024,768),Image.Resampling.NEAREST).save(ASSETS/'loading-preview.png')
    ready_raw=bytearray(raw)
    footer=encode(ready)
    for y in range(8):ready_raw[(248+y)*128+40:(248+y)*128+88]=footer[y*48:(y+1)*48]
    decode(ready_raw).resize((1024,768),Image.Resampling.NEAREST).save(ASSETS/'ready-preview.png')
    asm=Path(os.environ.get('VASM_M68K',shutil.which('vasmm68k_mot') or 'vasmm68k_mot'))
    result=subprocess.run([str(asm),'-m68000','-Fbin','-quiet','-L',str(ASSETS/'loader.lst'),'-o',str(ASSETS/'title.bin'),'title_loader.asm'],cwd=ROOT/'src',capture_output=True,text=True)
    if result.returncode:raise RuntimeError(result.stdout+result.stderr)
    size=(ASSETS/'title.bin').stat().st_size
    meta=dict(loader_version=TITLE_VERSION,raw_bytes=len(raw),compressed_bytes=len(packed),loader_bytes=size-len(packed),file_bytes=size,
              compressed_reduction_percent=round(100*(1-len(packed)/len(raw)),1),temporary_prefix_bytes=PREFIX,
              extra_screen_buffer_bytes=0,game_binary_modified=False,
              sha256=hashlib.sha256((ASSETS/'title.bin').read_bytes()).hexdigest())
    (ASSETS/'metadata.json').write_text(json.dumps(meta,indent=2));return meta


def boot_lines(size,device='mdv1',music=False):
    if music:
        return ['100 REM QL-ZERO - title music in reused game allocation',
                '110 MODE 8','115 WINDOW #1,512,16,0,240: BORDER #1,0',
                f'120 a=RESPR({size+PREFIX+256})',
                f'125 LBYTES "{device}_title",a+{PREFIX}',f'127 CALL a+{PREFIX}',
                f'128 LBYTES "{device}_intro",a+{PREFIX}',
                '129 CALL a',f'130 CALL a+{PREFIX}',
                f'140 LBYTES "{device}_race",a+{PREFIX}',
                '180 REPeat clear_keys','190 k$=INKEY$(#1,0)',
                '200 IF k$="" OR k$=CHR$(0) THEN EXIT clear_keys','210 END REPeat clear_keys',
                f'240 CALL a+{PREFIX}']
    return ['100 REM QL-ZERO - compressed title then unchanged UNION20',
            '110 MODE 8','115 WINDOW #1,512,16,0,240: BORDER #1,0',
            f'120 a=RESPR({size+PREFIX+256})',
            f'125 LBYTES "{device}_title",a+{PREFIX}',f'127 CALL a+{PREFIX}',
            f'130 LBYTES "{device}_race",a+{PREFIX}',
            '180 REPeat clear_keys','190 k$=INKEY$(#1,0)',
            '200 IF k$="" OR k$=CHR$(0) THEN EXIT clear_keys','210 END REPeat clear_keys',
            '220 CALL a','230 k$=INKEY$(#1,-1)',f'240 CALL a+{PREFIX}']


def compile_intro(project=None,records=False):
    from mode_menu import compile_menu
    compile_menu(project)
    if records:
        font=json.loads((ROOT/'assets/font.json').read_text())
        rows=[[0]*256 for _ in range(8)];message='CTRL: RECORDS';start=(256-len(message)*8)//2
        for i,ch in enumerate(message):
            for y,line in enumerate(font.get(ch,font['?'])):
                for x,bit in enumerate(line):
                    if bit=='1':rows[y][start+8*i+1+x]=7
        (ASSETS/'records_hint.lz').write_bytes(compress(encode(rows)))
    raw=(ASSETS/'loading.q8').read_bytes()
    (ASSETS/'intro_loading.q8').write_bytes(b''.join(raw[(248+y)*128+40:(248+y)*128+88] for y in range(8)))
    assembler=Path(os.environ.get('VASM_M68K',shutil.which('vasmm68k_mot') or 'vasmm68k_mot'))
    stem='intro_records' if records else 'intro'
    result=subprocess.run([str(assembler),'-m68000','-Fbin','-quiet',*(['-Dmenu_records=1'] if records else []),
                           '-L',str(ASSETS/(stem+'.lst')),'-o',str(ASSETS/(stem+'.bin')),
                           'title_music.asm'],cwd=ROOT/'src',capture_output=True,text=True)
    if result.returncode:raise RuntimeError(result.stdout+result.stderr)
    return ASSETS/(stem+'.bin')


def add_title(folder,size,device='mdv1',music=False,project=None,records=False):
    folder=Path(folder)
    compile_title()
    title=(ASSETS/'title.bin').read_bytes()
    if len(title)>size:raise ValueError('Title does not fit the reused game allocation.')
    if size+PREFIX+256>65520:raise ValueError('Loader exceeds original QL memory reservation.')
    shutil.copyfile(ASSETS/'title.bin',folder/'title')
    music_bytes=0
    if music:
        intro=compile_intro(project,records=records)
        music_bytes=intro.stat().st_size
        from mode_menu import ICON_BANK_BYTES
        if music_bytes+ICON_BANK_BYTES>size:raise ValueError('Title music/icons exceed the reused game allocation.')
        shutil.copyfile(intro,folder/'intro')
    elif (folder/'intro').is_file():
        (folder/'intro').unlink()
    (folder/'BOOT').write_bytes(('\n'.join(boot_lines(size,device,music))+'\n').encode('ascii'))
    return dict(json.loads((ASSETS/'metadata.json').read_text()),allocation_bytes=size+PREFIX+256,
                music=music,music_file_bytes=music_bytes,music_extra_resident_bytes=0)
