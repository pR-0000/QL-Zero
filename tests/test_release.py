# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Portable checks: no historical builds, assembler or QDOS ROM required."""
import hashlib,json,os,shutil,struct,sys,tempfile,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from editor_model import ROOT,open_project,new_project,native_track,preview_model
from native_cpu import CPU,state
from cup_emulation import attach_disk
from mdv_image import files,blank_records
from title_screen import compress,decompress,compress_optimal
from sprite_codec import word_pack,word_unpack
from unicorn import UC_HOOK_CODE,UC_HOOK_MEM_WRITE
from unicorn.m68k_const import *

DEFAULT=ROOT/'build/classic_cup'
FOLDER=Path(os.environ.get('QLZERO_TEST_BUILD',str(DEFAULT if (DEFAULT/'metadata.json').exists() else ROOT/'release/v1.0.0'))).resolve()


def word(c,name,value=None):
    if value is not None:c.u.mem_write(c.symbols[name],struct.pack('>H',value&65535))
    return int.from_bytes(c.u.mem_read(c.symbols[name],2),'big')


def cpu():
    meta=json.loads((FOLDER/'metadata.json').read_text());c=CPU(meta,FOLDER)
    attach_disk(c,FOLDER);c.page();c.call('cup_storage_init');c.call('cup_init')
    state(c,'music_enabled',0);c.writes.clear();return c


class Release(unittest.TestCase):
    def test_integrity(self):
        if (FOLDER/'SHA256SUMS.txt').exists():
            for line in (FOLDER/'SHA256SUMS.txt').read_text().splitlines():
                digest,name=line.split('  ',1)
                self.assertEqual(hashlib.sha256((FOLDER/name).read_bytes()).hexdigest(),digest,name)
        m=json.loads((FOLDER/'metadata.json').read_text())
        self.assertEqual(m['image_bytes'],(FOLDER/'cup_image.bin').stat().st_size)
        self.assertGreaterEqual(m['resident_margin_bytes'],0)
        self.assertEqual(m['music_banks'],8);self.assertEqual(len(m['game_modes']),4)
        self.assertFalse(m['victory_ceremony_skippable'])

    def test_cartridge_and_records(self):
        image=(FOLDER/'qlzero_classic_cup.mdv').read_bytes();data=files(blank_records(image))
        self.assertEqual(len(data),24)
        self.assertTrue(all(f'course{i}' in data for i in range(6)))
        for name in ('score_a','score_b'):
            self.assertEqual(data[name][:4],b'QZR2');self.assertFalse(any(data[name][20:]))
        for name,payload in data.items():
            if name.startswith('ghost'):self.assertFalse(any(payload))
        clean=files(blank_records(image));self.assertEqual(clean,data)
        self.assertIn(b'127 CALL',data['BOOT'])

    def test_codecs(self):
        for data in (bytes(range(256)),b'QL-ZERO'*100,bytes(512)):
            self.assertEqual(decompress(compress(data),len(data)),data)
            self.assertEqual(decompress(compress_optimal(data),len(data)),data)
        data=struct.pack('>100H',*([0,65535,1234,4,5]*20));palette=[0,65535,4,5]
        self.assertEqual(word_unpack(word_pack(data,palette),palette),data)

    def test_project(self):
        p=open_project(ROOT/'assets/project/classic_cup.qlr.json')
        self.assertEqual(len(p['tracks']),6)
        a=new_project();a['tracks'][0]['width']=3
        self.assertNotEqual(new_project()['tracks'][0]['width'],3)
        self.assertEqual(p,open_project(FOLDER/'classic_cup.qlr.json'))

    def test_edited_artwork_generation(self):
        from build_cup import artwork
        with tempfile.TemporaryDirectory(prefix='qlzero-artwork-') as temp:
            src=Path(temp)/'src';shutil.copytree(ROOT/'src',src)
            p=new_project();old=(src/'data/assets.inc').read_bytes()
            p['assets']['player'][0][0]=7
            p['assets']['rival_0'][0][0]=6
            artwork(src,p)
            self.assertNotEqual((src/'data/assets.inc').read_bytes(),old)
            self.assertIn('cup_sprite_word_palette:',(src/'data/cup_sprites.inc').read_text())

    def test_editor_native_preview(self):
        from editor_preview import TestEngine,Camera,render
        p=new_project()
        for course in range(6):
            e=TestEngine(p,course);e._load_cup_cpu(FOLDER);e.reset();before=e.describe();e.step({'Up'})
            self.assertEqual(e.native_frame().size,(256,256))
            self.assertEqual(len(native_track(e.raw,False)),11312)
            camera=Camera(e);x,y=camera.x,camera.y;camera.step({'Up'},.1)
            self.assertNotEqual((camera.x,camera.y),(x,y))
            self.assertEqual(before['mode'],0)

    def test_f4_and_pause(self):
        c=cpu();word(c,'cup_mode',1);c.call('cup_load_track');word(c,'cup_phase',0);state(c,'started',1)
        c.call('render_frame')
        c.u.reg_write(UC_M68K_REG_D3,1);c.call('read_extra_controls');self.assertEqual(word(c,'ghost_visible'),1)
        c.call('read_extra_controls');self.assertEqual(word(c,'ghost_visible'),1)
        c.u.reg_write(UC_M68K_REG_D3,0);c.call('read_extra_controls')
        c.u.reg_write(UC_M68K_REG_D3,1);c.call('read_extra_controls');self.assertEqual(word(c,'ghost_visible'),0)
        word(c,'cup_enter',0);state(c,'controls',8);c.call('cup_menu_frame')
        self.assertEqual(word(c,'cup_phase'),11)
        state(c,'controls',0);c.call('cup_menu_frame');state(c,'controls',1);c.call('cup_menu_frame')
        self.assertEqual(word(c,'cup_phase'),0)

    def test_mandatory_ceremony(self):
        c=cpu();word(c,'cup_round',5);word(c,'cup_phase',1)
        c.u.mem_write(c.symbols['cup_order'],struct.pack('>3H',0,1,2))
        state(c,'ticks',65500);word(c,'cup_enter',0);state(c,'controls',1);c.call('cup_menu_frame')
        self.assertEqual(word(c,'cup_phase'),9);start=word(c,'podium_start');calls=len(c.tape.calls)
        for t,keys in ((0,1),(1,0),(2,8),(999,511),(1000,0),(1200,1),(1399,8),(1400,511),(1699,1),(1700,1)):
            state(c,'ticks',start+t);state(c,'controls',keys);c.call('cup_menu_frame')
            self.assertEqual(word(c,'cup_phase'),9 if t<1700 else 2)
        self.assertEqual(len(c.tape.calls),calls)
        state(c,'controls',1);c.call('cup_menu_frame');self.assertEqual(word(c,'cup_phase'),2)
        state(c,'controls',0);c.call('cup_menu_frame');state(c,'controls',1);c.call('cup_menu_frame')
        self.assertEqual(word(c,'cup_phase'),5)

    def test_music_toggle_keyboard(self):
        c=cpu();word(c,'cup_phase',0);state(c,'music_pending',0);c.call('music_init')
        packet=[];row=[0];current=[None]
        def ipc(u,k,a,n,value,arg):
            packet.append(value);at=len(packet)-1
            if at==7:
                bits=[(v>>1)&1 for v in packet]
                self.assertEqual(sum(bits[i]<<(3-i) for i in range(4)),9)
                current[0]=sum(bits[4+i]<<(3-i) for i in range(4))
            response=row[0] if current[0]==0 else 4 if current[0]==1 else 0
            u.mem_write(0x18020,bytes([128 if at>=8 and response&(1<<(15-at)) else 0]))
            if at==15:packet.clear()
        h=c.u.hook_add(UC_HOOK_MEM_WRITE,ipc,begin=0x18003,end=0x18003)
        for contact,enabled in ((0,1),(8,0),(8,0),(0,0),(8,1),(8,1)):
            row[0]=contact;c.call('read_controls');c.call('read_controls')
            self.assertEqual(state(c,'music_enabled'),enabled)
            self.assertEqual(state(c,'controls'),4)
        c.u.hook_del(h)


if __name__=='__main__':unittest.main()
