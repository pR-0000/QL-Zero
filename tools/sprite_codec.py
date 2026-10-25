# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Offline native sprite conversion and optimal WORD-LZ parsing."""
import struct
from collections import defaultdict
from generate_assets import pack_pixels

def native(compact):
    """Perform the exact runtime palette-pair conversion on the build machine."""
    w,h=compact[:2];out=bytearray(struct.pack('>HH',w,h));at=2;y=0
    while y<h:
        repeat=compact[at] if h>=24 else 1
        if h>=24:at+=1;out.extend(struct.pack('>H',repeat))
        while compact[at]!=255:
            x,count=compact[at:at+2];at+=2
            if count>=128:count-=256
            out.extend(struct.pack('>Hh',x,count))
            for _ in range(abs(count)):
                a,b=compact[at:at+2];at+=2
                colors=[a//9,a%9,b//9,b%9]
                mask,ink=pack_pixels([-1 if c==8 else c for c in colors])
                if count<0:out.extend(struct.pack('>H',mask))
                out.extend(struct.pack('>H',ink))
        at+=1;out.extend(b'\xff\xff');y+=repeat
    assert at==len(compact) and y==h
    return bytes(out)


def word_pack(raw,palette):
    words=struct.unpack('>'+str(len(raw)//2)+'H',raw);tokens={w:i for i,w in enumerate(palette)}
    literal_cost=[1 if w in tokens else 3 for w in words]
    chains=defaultdict(list);matches=[]
    for pos in range(len(words)):
        length=0;distance=0;limit=min(130,len(words)-pos)
        if limit>=3:
            key=words[pos:pos+3]
            for previous in reversed(chains[key]):
                if pos-previous>255:break
                n=3
                while n<limit and words[previous+n]==words[pos+n]:n+=1
                if n>length:length=n;distance=pos-previous
                if n==limit:break
            chains[key].append(pos)
        matches.append((length,distance))
    costs=[0]*(len(words)+1);choices=[None]*len(words)
    for pos in range(len(words)-1,-1,-1):
        best=10**9;cost=1
        for n in range(1,min(128,len(words)-pos)+1):
            cost+=literal_cost[pos+n-1]
            if cost+costs[pos+n]<best:best=cost+costs[pos+n];choices[pos]=(n,0)
        length,distance=matches[pos]
        for n in range(3,length+1):
            if 2+costs[pos+n]<best:best=2+costs[pos+n];choices[pos]=(n,distance)
        costs[pos]=best
    out=bytearray();pos=0
    while pos<len(words):
        n,distance=choices[pos]
        if distance:out.extend((128+n-3,distance))
        else:
            out.append(n-1)
            for w in words[pos:pos+n]:
                if w in tokens:out.append(tokens[w])
                else:out.append(255);out.extend(struct.pack('>H',w))
        pos+=n
    return bytes(out)


def word_unpack(packed,palette):
    out=[];at=0
    while at<len(packed):
        command=packed[at];at+=1
        if command<128:
            for _ in range(command+1):
                token=packed[at];at+=1
                if token==255:out.append(int.from_bytes(packed[at:at+2],'big'));at+=2
                else:out.append(palette[token])
        else:
            distance=packed[at];at+=1
            assert 0<distance<=len(out)
            for _ in range((command&127)+3):out.append(out[-distance])
    return struct.pack('>'+str(len(out))+'H',*out)
