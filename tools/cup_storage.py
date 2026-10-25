# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Disk-only cup overlay: documented ROM sector I/O, no discarded QDOS calls."""
import hashlib,json,struct,zlib
from pathlib import Path


def preserve_journal(image_path,mdv,identity,record_bytes):
    """Recover valid slots from the existing cartridge before rebuilding it.

    Check each sector separately so a torn inactive journal cannot hide the
    previous valid one. Never mutate the mounted image in this helper.
    """
    if not image_path.is_file():return
    image=image_path.read_bytes()
    if len(image)!=255*686:return
    def checksum(data):return ((0x0f0f+sum(data))&65535).to_bytes(2,'little')
    blocks={}
    for pos in range(0,len(image),686):
        r=image[pos:pos+686]
        if r[26:28]!=checksum(r[12:26]) or r[42:44]!=checksum(r[40:42]) or r[564:566]!=checksum(r[52:564]):continue
        blocks[(r[40],r[41])]=r[52:564]
    if (0,0) not in blocks:return
    length=int.from_bytes(blocks[0,0][:4],'big')
    if not 64<=length<=8192 or length%64:return
    try:directory=b''.join(blocks[0,i] for i in range((length+511)//512))
    except KeyError:return
    def valid(data):
        return (len(data)==448 and data[:4]==b'QZR2' and int.from_bytes(data[4:8],'big')==identity and
                int.from_bytes(data[8:10],'big') in (2,3) and
                data[10:12]==struct.pack('>H',(record_bytes-32)//24) and
                int.from_bytes(data[16:20],'big')==zlib.crc32(data[20:20+record_bytes]))
    for i in range(1,length//64):
        h=directory[i*64:i*64+64];name=h[16:16+int.from_bytes(h[14:16],'big')]
        if name not in (b'score_a',b'score_b') or h[:4]!=struct.pack('>I',512):continue
        candidate=blocks.get((i,0),b'')[64:]
        if not valid(candidate):continue
        if candidate[8:10]==b'\0\2':
            candidate=bytearray(candidate)
            candidate[8:10]=b'\0\3'
            candidate[20+record_bytes-32:20+record_bytes]=bytes(32)
            candidate[16:20]=struct.pack('>I',zlib.crc32(candidate[20:20+record_bytes]))
            candidate=bytes(candidate)
        path=mdv/name.decode();old=path.read_bytes() if path.is_file() else b''
        if not valid(old) or int.from_bytes(candidate[12:16],'big')>=int.from_bytes(old[12:16],'big'):
            path.write_bytes(candidate)


def preserve_ghosts(image_path,mdv,identity,count):
    """Recover each complete valid ghost slot, leaving torn writes ignored."""
    if not image_path.is_file():return
    image=image_path.read_bytes()
    if len(image)!=255*686:return
    def checksum(data):return ((0x0f0f+sum(data))&65535).to_bytes(2,'little')
    blocks={}
    for pos in range(0,len(image),686):
        r=image[pos:pos+686]
        if r[26:28]!=checksum(r[12:26]) or r[42:44]!=checksum(r[40:42]) or r[564:566]!=checksum(r[52:564]):continue
        blocks[r[40],r[41]]=r[52:564]
    if (0,0) not in blocks:return
    length=int.from_bytes(blocks[0,0][:4],'big')
    if not 64<=length<=8192 or length%64:return
    try:directory=b''.join(blocks[0,i] for i in range((length+511)//512))
    except KeyError:return
    def valid(data,course):
        return (len(data)==960 and data[:8]==struct.pack('>4sI',b'QZG1',identity)
                and int.from_bytes(data[8:10],'big') in (1,2) and data[10:12]==struct.pack('>H',course)
                and 2<=int.from_bytes(data[20:22],'big')<=224
                and int.from_bytes(data[22:24],'big') in (10,20,40,80,160,320,640,1280,2560)
                and 0<int.from_bytes(data[24:26],'big')<60000
                and int.from_bytes(data[28:32],'big')==zlib.crc32(data[:28]+bytes(4)+data[32:]))
    for i in range(1,length//64):
        h=directory[i*64:(i+1)*64];name=h[16:16+int.from_bytes(h[14:16],'big')]
        if name not in [f'ghost{c}{s}'.encode() for c in range(count) for s in 'ab'] or h[:4]!=struct.pack('>I',1024):continue
        course=int(chr(name[5]))
        try:data=blocks[i,0][64:]+blocks[i,1]
        except KeyError:continue
        if not valid(data,course):continue
        path=mdv/name.decode();old=path.read_bytes() if path.is_file() else b''
        # Preserve legacy files too, but a high old lap generation must never
        # replace a newer full-race recording in the same desktop slot.
        if (not valid(old,course) or data[8:10]>old[8:10] or
            (data[8:10]==old[8:10] and int.from_bytes(data[12:16],'big')>=int.from_bytes(old[12:16],'big'))):path.write_bytes(data)


def prepare(src,assets,mdv,project):
    count=len(project['tracks'])
    identity=int.from_bytes(hashlib.sha256(json.dumps(project['tracks'],sort_keys=True).encode()).digest()[:4],'big')
    sizes=[]
    for i in range(count):
        road=(assets/f'course_{i}.lz').read_bytes();theme=(assets/f'theme_{i}.lz').read_bytes();payload=theme+road
        header=struct.pack('>4sI6HI',b'QZC2',identity,i,len(theme),len(road),11312,848,0,zlib.crc32(payload))
        data=header+payload;sizes.append(len(data))
        if (len(data)+64+511)//512*512>6688:raise ValueError('Circuit compressé trop volumineux pour le tampon de chargement (6,5 Ko).')
        (mdv/f'course{i}').write_bytes(data)
    record_bytes=24*count+32
    body=bytes(record_bytes)
    header=struct.pack('>4sIHHII',b'QZR2',identity,3,count,0,zlib.crc32(body))
    record=(header+body).ljust(448,b'\0')
    preserve_journal(mdv.parent/'qlzero_classic_cup.mdv',mdv,identity,record_bytes)
    for name in ('score_a','score_b'):
        path=mdv/name
        # Preserve journal slots on desktop rebuild when the track identity agrees.
        if not path.exists() or path.read_bytes()[:12]!=record[:12]:path.write_bytes(record)
    preserve_ghosts(mdv.parent/'qlzero_classic_cup.mdv',mdv,identity,count)
    ghost_names=[]
    for course in range(count):
        for slot in 'ab':
            name=f'ghost{course}{slot}';ghost_names.append(name);path=mdv/name
            if not path.is_file() or len(path.read_bytes())!=960 or path.read_bytes()[4:8]!=struct.pack('>I',identity):
                path.write_bytes(bytes(960))
    resources=['cup_track_table:']
    for t in project['tracks']:
        resources.extend(('        dc.l 0',f'        dc.w 0,{round(256*1.2/(2*t["width"]))}','        dc.l 0','        dc.w 0,0'))
    (src/'data/cup_resources.inc').write_text('\n'.join(resources)+'\n',encoding='ascii')
    lines=[f'qzr_game_id equ ${identity:08x}',f'qzr_record_bytes equ {record_bytes}','qzr_course_names:']
    for t in project['tracks']:
        name=t['name'].upper()[:23].replace("'",' ')
        lines.append(f"        dc.b '{name}',0")
        lines.append(f'        dcb.b {24-len(name)-1},0')
    lines.extend(('        even',))
    (src/'data/cup_disk.inc').write_text('\n'.join(lines)+'\n',encoding='ascii')
    return dict(identity=identity,record_payload_bytes=record_bytes,record_slots=['score_a','score_b'],
                ghost_slots=ghost_names,ghost_payload_bytes=960,streaming=True,microdrive_drive=1,
                rom_vectors=[0x124,0x126,0x128,0x12a],course_files=sizes)
