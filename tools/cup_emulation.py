# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""In-memory microdrive backend for the editor's native 68000 preview.

Implements the documented ROM sector ABI. Cartridge writes affect this
private preview copy only, never the user's mounted microdrive or records.
This is an instruction emulator, not a measurement of QL tape/bus timing.
"""
from pathlib import Path
from unicorn import UC_HOOK_CODE, UC_HOOK_MEM_READ
from unicorn.m68k_const import *
from editor_model import ROOT


def checksum(data):return ((0x0f0f+sum(data))&65535).to_bytes(2,'little')


class Tape:
    def __init__(self,data=None):
        self.records=[bytearray(r) for r in self.chunks(data if data is not None else (ROOT/'build/classic_cup/qlzero_classic_cup.mdv').read_bytes())]
        self.index=0;self.calls=[];self.writes=[];self.readonly=False;self.torn=False;self.missing=False
    @staticmethod
    def chunks(data):return [data[i:i+686] for i in range(0,len(data),686)]
    def image(self):return b''.join(self.records)
    def sector(self,file,block=0):return next(r for r in self.records if r[40:42]==bytes((file,block)))
    def file_id(self,name):
        length=int.from_bytes(self.sector(0,0)[52:56],'big')
        directory=b''.join(bytes(self.sector(0,i)[52:564]) for i in range((length+511)//512))
        for i in range(int.from_bytes(directory[:4],'big')//64):
            header=directory[i*64:(i+1)*64]
            if header[16:16+int.from_bytes(header[14:16],'big')]==name.encode():return i
        raise KeyError(name)
    def block_good(self,r):
        return r[42:44]==checksum(r[40:42]) and r[564:566]==checksum(r[52:564])
    def hook(self,c,vector):
        u=c.u;self.calls.append(vector)
        sp=u.reg_read(UC_M68K_REG_A7);ret=int.from_bytes(u.mem_read(sp,4),'big')
        at=u.reg_read(UC_M68K_REG_A1);a3=u.reg_read(UC_M68K_REG_A3);a6=u.reg_read(UC_M68K_REG_A6)
        assert a3==0x18020 and u.reg_read(UC_M68K_REG_SR)&0x700==0x700
        # Conservatively honor only the two documented preserved registers.
        for reg in list(range(UC_M68K_REG_D0,UC_M68K_REG_D7+1))+list(range(UC_M68K_REG_A0,UC_M68K_REG_A6+1)):
            if reg not in (UC_M68K_REG_A3,UC_M68K_REG_A6):u.reg_write(reg,0xbad00000+reg)
        r=self.records[self.index];skip=0
        if vector==0x12a:
            if not self.missing:
                self.index=(self.index+1)%len(self.records);r=self.records[self.index]
                if r[26:28]==checksum(r[12:26]):
                    u.mem_write(at,bytes(r[12:26]));u.reg_write(UC_M68K_REG_A1,at+14)
                    u.reg_write(UC_M68K_REG_D7,r[13]);skip=4
                else:skip=2
        elif vector==0x124:
            if self.block_good(r):
                u.mem_write(at,bytes(r[52:564]));u.reg_write(UC_M68K_REG_A1,at+512);skip=2
            u.reg_write(UC_M68K_REG_D1,r[40]);u.reg_write(UC_M68K_REG_D2,r[41])
        elif vector==0x126:
            tag=bytes(u.mem_read(sp+4,2));data=bytes(u.mem_read(at,512))
            assert tag==bytes(r[40:42]),'Write targeted a different file/block'
            allowed={(self.file_id(n),0) for n in ('score_a','score_b')}
            for course in range(6):
                for slot in 'ab':
                    try:file=self.file_id(f'ghost{course}{slot}')
                    except KeyError:continue
                    allowed.update((file,block) for block in (0,1))
            assert (r[40],r[41]) in allowed
            self.writes.append((r[13],tag))
            if self.torn:r[52:164]=data[:112] # incomplete, checksum intentionally stale
            elif not self.readonly:
                r[52:564]=data;r[564:566]=checksum(data)
            u.reg_write(UC_M68K_REG_A1,at+512)
        else:
            assert vector==0x128
            if self.block_good(r) and bytes(r[52:564])==bytes(u.mem_read(at,512)):
                skip=2;u.reg_write(UC_M68K_REG_A1,at+512)
            u.reg_write(UC_M68K_REG_D1,r[40]);u.reg_write(UC_M68K_REG_D2,r[41])
        assert u.reg_read(UC_M68K_REG_A3)==a3 and u.reg_read(UC_M68K_REG_A6)==a6
        u.reg_write(UC_M68K_REG_A7,sp+4);u.reg_write(UC_M68K_REG_PC,ret+skip)


def attach_disk(c,folder,tape=None):
    folder=Path(folder)
    c.tape=tape if tape is not None else Tape((folder/'qlzero_classic_cup.mdv').read_bytes())
    vectors=(0x124,0x126,0x128,0x12a)
    for i,vector in enumerate(vectors):
        c.u.mem_write(vector,(0x1000+i*8).to_bytes(2,'big'))
    # ZX8302 interrupts are cleared by writing ones. Ordinary Unicorn RAM
    # would read those written bits as new VBLs during every drawing pass.
    # The editor advances time explicitly, so no hardware VBL is pending.
    c.u.hook_add(UC_HOOK_MEM_READ,lambda u,*args:u.mem_write(0x18021,b'\0'),begin=0x18021,end=0x18021)
    for vector in (0x124,0x126,0x128,0x12a):
        address=0x4000+int.from_bytes(c.u.mem_read(vector,2),'big',signed=True)
        c.u.hook_add(UC_HOOK_CODE,lambda u,pc,n,data,v=vector:c.tape.hook(c,v),begin=address,end=address)
    # Tape seeks have a bounded scan loop exceeding an ordinary frame call.
    original=c.call
    def call(name,count=5000000):return original(name,count=count)
    c.call=call
