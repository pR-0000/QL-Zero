# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Lossless horizontal 4-cell dictionary, constant-time native queries."""
import struct
MAP_SIZE=8876
SAVING=16384-MAP_SIZE
def pack(track):
    grid=bytes(track[96:16480]);tiles=[];lookup={};indices=[]
    for y in range(128):
        for x in range(0,128,4):
            tile=grid[y*128+x:y*128+x+4]
            if len(set(tile))==1:indices.append(0x8000|tile[0]);continue
            if tile not in lookup:lookup[tile]=len(tiles);tiles.append(tile)
            indices.append(8192+4*lookup[tile])
    assert len(tiles)<=171
    data=bytearray(track[:96]);data[4:6]=b'\0\6'
    for offset in (66,70,72):data[offset:offset+2]=(int.from_bytes(data[offset:offset+2],'big')-SAVING).to_bytes(2,'big')
    data+=struct.pack('>4096H',*indices)+b''.join(tiles)+bytes((171-len(tiles))*4)
    data+=track[16480:]
    assert len(data)==len(track)-SAVING and unpack(data)==grid
    return bytes(data)
def unpack(track):
    grid=bytearray(16384)
    for y in range(128):
        for x in range(128):
            index=y*32+x//4 if track[4:6] in (b'\0\6',b'\0\7',b'\0\10') else (y//4)*32+x//4
            at=int.from_bytes(track[96+2*index:98+2*index],'big')
            local=x%4 if track[4:6] in (b'\0\6',b'\0\7',b'\0\10') else (y%4)*4+x%4
            grid[y*128+x]=(at&255) if at&0x8000 else track[96+at+local]
    return bytes(grid)
