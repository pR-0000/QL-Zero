# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Inspect QLAY sectors and clear only preallocated record payloads offline."""
import struct,zlib


def checksum(data):return ((0x0f0f+sum(data))&65535).to_bytes(2,'little')


def blocks(image):
    if len(image)!=255*686:raise ValueError('Expected a 255-sector QLAY cartridge')
    result={}
    for at in range(0,len(image),686):
        r=image[at:at+686]
        if r[26:28]!=checksum(r[12:26]):raise ValueError('Bad sector header checksum')
        if r[40]==0xff:continue
        if r[42:44]!=checksum(r[40:42]) or r[564:566]!=checksum(r[52:564]):
            raise ValueError('Bad sector data checksum')
        result[r[40],r[41]]=(at,r[52:564])
    return result


def directory(image):
    b=blocks(image);length=int.from_bytes(b[0,0][1][:4],'big')
    data=b''.join(b[0,i][1] for i in range((length+511)//512))
    result={}
    for i in range(1,length//64):
        h=data[i*64:(i+1)*64];n=int.from_bytes(h[14:16],'big')
        if n:result[h[16:16+n].decode('ascii')]=(i,h)
    return b,result


def files(image):
    b,d=directory(image);result={}
    for name,(i,h) in d.items():
        size=int.from_bytes(h[:4],'big');n=(size+511)//512
        result[name]=b''.join(b[i,j][1] for j in range(n))[64:size]
    return result


def blank_records(image):
    """Return a distributable copy; never overwrite the player's cartridge."""
    b,d=directory(image);payloads=files(image);out=bytearray(image)
    for name,(i,h) in d.items():
        if name in ('score_a','score_b'):
            old=payloads[name];count=int.from_bytes(old[10:12],'big');body=bytes(count*24+32)
            data=(old[:12]+bytes(4)+struct.pack('>I',zlib.crc32(body))+body).ljust(448,b'\0')
        elif name.startswith('ghost') and name[-1:] in ('a','b'):data=bytes(960)
        else:continue
        padded=(h+data).ljust(((len(data)+64+511)//512)*512,b'\0')
        for j in range(len(padded)//512):
            at=b[i,j][0];block=padded[j*512:(j+1)*512]
            out[at+52:at+564]=block;out[at+564:at+566]=checksum(block)
    result=bytes(out);files(result)
    return result
