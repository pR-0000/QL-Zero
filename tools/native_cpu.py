# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Strict 68000 instruction model for editor previews and native tests.

MODE 8/IPC/tape timing is not emulated; never use this to report QL FPS.
No ROM image is required: cup_emulation supplies only the sector-call ABI.
"""
import struct
from pathlib import Path
from unicorn import Uc,UC_ARCH_M68K,UC_MODE_BIG_ENDIAN,UC_HOOK_MEM_READ,UC_HOOK_MEM_WRITE
from unicorn.m68k_const import *


def state(c,name,value=None):
    at=c.symbols['state']+c.symbols['s_'+name]
    if value is not None:c.u.mem_write(at,struct.pack('>H',value&65535))
    return int.from_bytes(c.u.mem_read(at,2),'big')


class CPU:
    def __init__(self,meta,folder):
        self.symbols=meta['symbols'];self.base=meta['image_base']
        self.u=Uc(UC_ARCH_M68K,UC_MODE_BIG_ENDIAN)
        self.u.ctl_set_cpu_model(UC_CPU_M68K_M68000)
        self.u.mem_map(0,0x40000)
        self.u.mem_write(self.base,(Path(folder)/meta.get('image_file','cup_image.bin')).read_bytes())
        self.u.reg_write(UC_M68K_REG_SR,0x2700)
        self.u.reg_write(UC_M68K_REG_A7,0x3fff0)
        self.u.reg_write(UC_M68K_REG_A6,self.symbols['state'])
        self.writes=[]
        self.u.hook_add(UC_HOOK_MEM_READ|UC_HOOK_MEM_WRITE,self._aligned)
        self.u.hook_add(UC_HOOK_MEM_WRITE,lambda u,k,a,n,v,d:self.writes.append((a,n)))

    @staticmethod
    def _aligned(u,kind,at,size,value,arg):
        if size>1 and at&1:raise RuntimeError(f'68000 address error at {at:#x}')

    def word(self,name,value=None):return state(self,name,value)

    def page(self,value=0x20000):
        self.u.mem_write(self.symbols['state']+self.symbols['s_page'],struct.pack('>I',value))

    def call(self,name,count=5000000):
        self.u.reg_write(UC_M68K_REG_A7,0x3ffec)
        self.u.mem_write(0x3ffec,struct.pack('>I',0x1000))
        self.u.reg_write(UC_M68K_REG_A6,self.symbols['state'])
        self.u.emu_start(self.symbols[name],0x1000,count=count)
        if self.u.reg_read(UC_M68K_REG_PC)!=0x1000:raise RuntimeError(name+' did not return')
