# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Build the QL-Zero v1 streamed cartridge from the final engine and project.

Only artwork, tables and resources are generated. Assembly engine routines
are assembled directly, without historical source patches or build profiles.
"""
from pathlib import Path
import argparse,hashlib,json,os,re,shutil,struct,subprocess,sys
from editor_model import ROOT,open_project,validate_project,save_project,preview_model,make_track,native_track,environment
from editor_export import replace_words,texture_word,cloud_words,symbols
from generate_assets import sprite_records,compact_fire
from title_screen import compress_optimal,compress,decompress,add_title
from cup_storage import prepare

TARGET=ROOT/'build/classic_cup'
BASE=0x2c680


def minimap(track):
    from PIL import Image,ImageDraw
    from generate_assets import pack_pixels
    import math
    im=Image.new('L',(32,24));draw=ImageDraw.Draw(im)
    points=[(min(31,int(x/4)),min(23,int(y*3/16))) for x,y in track['points']]
    draw.line(points+[points[0]],fill=7,width=1)
    x,y=track['points'][0];nx,ny=track['points'][1]
    dx,dy=nx-x,ny-y;length=math.hypot(dx,dy);half=max(track['width'],6)
    mx,my=points[0]
    draw.line([(mx+round(side*-dy/length*half/4),my+round(side*dx/length*half*3/16)) for side in (-1,1)],fill=4,width=1)
    return b''.join(struct.pack('>H',pack_pixels([im.getpixel((x+k,y)) for k in range(4)])[1])
                    for y in range(24) for x in range(0,32,4))


def artwork(src,project):
    """Refresh mutable sprite data in the copied assembly data template."""
    _,model=preview_model(project,0);p=src/'data/assets.inc';text=p.read_text()
    text=replace_words(text,'ship_1',sprite_records(model['ships'][1]))
    for i in range(1,4):text=replace_words(text,f'cup_player_view{i}',sprite_records(model['playerViews'][i]))
    for i,pixels in enumerate(model['jets']):
        h=model['jetRender']['normal_height' if i<6 else 'boost_height']
        text=replace_words(text,f'jet_{i}',[h]+sprite_records([r[:16] for r in pixels[:h]]))
        text=replace_words(text,f'jet_right_{i}',[h]+sprite_records([r[24:40] for r in pixels[:h]]))
    for i,pixels in enumerate(model['wrecks']):text=replace_words(text,f'wreck_{i}',sprite_records(pixels))
    for i,pixels in enumerate(model['explosions']):
        text,n=re.subn(rf'explosion_{i}:\n[ \t]+dc\.b[^\n]*\n[ \t]+even',
                        lambda m:f'explosion_{i}:\n'+compact_fire(pixels),text,count=1)
        if n!=1:raise ValueError('Missing explosion table')
    p.write_text(text,encoding='ascii')
    p=src/'race.asm';text=p.read_text()
    for name,key in (('jet_normal_y','jet_top'),('jet_boost_y','boost_top')):
        text,n=re.subn(rf'({name}\s+equ )\d+',lambda m:m[1]+str(156+model['jetRender'][key]),text)
        if n!=1:raise ValueError('Missing jet position')
    p.write_text(text,encoding='ascii')
    from cup_combat_art import generate
    return generate(src,model)


def courses(project,target,assets):
    result=[]
    for i,t in enumerate(project['tracks']):
        raw,_=make_track(t);native=native_track(raw)
        (target/f'course_{i}.qzt').write_bytes(native)
        road=compress_optimal(native);(assets/f'course_{i}.lz').write_bytes(road)
        env=environment(project,i);bg=env['background'];ink=next(c for row in bg for c in row if c>=0)
        heights=[40-next(y for y in range(40) if bg[y][x]>=0) for x in range(32)]
        patterns=[texture_word([[c]*8]) for c in range(8)]+[texture_word(env['speed']),texture_word(env['repair'])]
        patterns[0]=texture_word(env['ground']);patterns[1]=texture_word(env['road'])
        theme=(struct.pack('>64h2I',*t['hills'],texture_word([[ink]*8]),texture_word(env['skybox']))+bytes(heights)
               +struct.pack('>10I',*patterns)+struct.pack('>64I',*cloud_words(env))+minimap(t))
        assert len(theme)==848
        packed=compress_optimal(theme);(assets/f'theme_{i}.lz').write_bytes(packed)
        assert decompress(road,11312)==native and decompress(packed,848)==theme
        result.append(dict(name=t['name'],bytes=11312,packed=len(road),width=t['width'],music=t['music']))
    return result


def tool_path(env,name):
    local=ROOT/'.local-build.json'
    config=json.loads(local.read_text()) if local.exists() else {}
    path=os.environ.get(env) or config.get(env) or shutil.which(name)
    if not path or not Path(path).is_file():raise ValueError(f'Set {env} to the path of {name}. See docs/BUILD.md.')
    resolved=str(Path(path).resolve());os.environ[env]=resolved
    return resolved


def build(cup_project=None,target=None,progress=print):
    target=Path(target or TARGET).resolve()
    if target==ROOT or target.is_relative_to(ROOT/'src') or target.is_relative_to(ROOT/'assets'):
        raise ValueError('Choose a separate build output directory.')
    if target!=TARGET.resolve() and target.exists() and any(target.iterdir()):raise ValueError('Export directory must be empty.')
    assembler=tool_path('VASM_M68K','vasmm68k_mot')
    drive=tool_path('NANOQL_DRIVE','nanoql_drive.py')
    p=validate_project(cup_project) if cup_project is not None else open_project(ROOT/'assets/project/classic_cup.qlr.json')
    if not 3<=len(p['tracks'])<=6:raise ValueError('A cup needs three to six circuits.')
    target.mkdir(parents=True,exist_ok=True)
    src=target/'source/src';assets=target/'source/assets';assets.mkdir(parents=True,exist_ok=True)
    if src.exists():
        if not src.resolve().is_relative_to(target) or src.resolve()==ROOT/'src':raise ValueError('Unsafe source copy target.')
        shutil.rmtree(src)
    shutil.copytree(ROOT/'src',src,dirs_exist_ok=True)
    save_project(p,target/'classic_cup.qlr.json')
    progress('Preparing artwork, music and circuits…')
    from mode_menu import compile_menu
    from title_screen import compile_title,compile_intro
    compile_menu(p);compile_title();compile_intro(p,records=True)
    shutil.copytree(ROOT/'assets/title',assets/'title',dirs_exist_ok=True)
    shutil.copytree(ROOT/'assets/music',assets/'music',dirs_exist_ok=True)
    sprites=artwork(src,p);tracks=courses(p,target,assets)
    path=src/'cup.asm'
    path.write_text(path.read_text().replace('ROUND 1 / 6',f'ROUND 1 / {len(tracks)}'),encoding='ascii')
    from cup_music import install
    music_banks=install(src,(ROOT/'assets/music/music_red_canyon.inc').read_text(),sand=True,silence=True)
    mdv=target/'MDV1';mdv.mkdir(exist_ok=True);storage=prepare(src,assets,mdv,p)
    from cup_courses import map_preview
    map_preview(p,target/'circuits.png')
    def assemble(entry,stem,flags=()):
        binary=target/(stem+'.bin');listing=target/(stem+'.lst')
        r=subprocess.run([assembler,'-m68000','-Fbin','-quiet','-L',str(listing),'-o',str(binary),*flags,entry],cwd=src,capture_output=True,text=True)
        if r.returncode:raise RuntimeError(r.stdout+r.stderr)
        return binary,(symbols(listing) if entry=='cup_main.asm' else {})
    progress('Assembling the 68008 kernel…')
    image,table=assemble('cup_main.asm','cup_image');size=image.stat().st_size
    if BASE+size>0x3fc00:raise ValueError(f'Kernel overlaps the 1 KiB stack ({size} bytes).')
    packed=compress(image.read_bytes()[::-1],chain_limit=1024)
    assert decompress(packed,size)[::-1]==image.read_bytes()
    if len(packed)>64496:raise ValueError('Compressed kernel exceeds the QDOS loading allocation.')
    # Ensure backward expansion cannot overwrite any unread compressed byte.
    read=written=0;clearance=[]
    while read<len(packed):
        command=packed[read];read+=1
        if command<128:
            for _ in range(command+1):
                read+=1;written+=1;clearance.append(BASE+size-written-(0x20100+len(packed)-read))
        else:
            read+=2;written+=(command&127)+3;clearance.append(BASE+size-written-(0x20100+len(packed)-read))
    if written!=size or min(clearance)<0:raise ValueError('Unsafe backward expansion.')
    (assets/'cup_image.lz').write_bytes(packed[::-1])
    flags=[f'-Dcup_image_size={size}',f'-Dcup_image_base={BASE}']
    qdos,_=assemble('cup_boot.asm','cup_qdos',flags);nano,_=assemble('cup_boot.asm','cup_nanoql',flags+['-Dcup_injection=1'])
    shutil.copy2(qdos,mdv/'race')
    title=add_title(mdv,qdos.stat().st_size,music=True,project=p,records=True)
    progress('Creating the Microdrive cartridge…')
    r=subprocess.run([sys.executable,drive,str(mdv),str(target/'qlzero_classic_cup.mdv'),'--name','QLCUP'],capture_output=True,text=True)
    if r.returncode:raise RuntimeError(r.stdout+r.stderr)
    allocation=(target/'qlzero_classic_cup.mdv').read_bytes()[52:564]
    free=sum(allocation[i*2]==0xfd for i in range(255))
    meta=json.loads((ROOT/'assets/runtime.json').read_text())
    meta.update(version='1.0.0',courses=tracks,symbols=table,image_bytes=size,image_base=BASE,image_end=BASE+size,
                image_file='cup_image.bin',resident_margin_bytes=0x3fc00-BASE-size,compressed_image_bytes=len(packed),
                bootstrap_min_unread_clearance=min(clearance),compressed_loader_margin_bytes=64496-len(packed),
                title=title,qdos_allocation_bytes=title['allocation_bytes'],storage=storage,music_banks=music_banks,
                cached_lossless_sprites=sprites,player_jet_render=p['jet_render'],microdrive_free_sectors=free,
                microdrive_free_bytes=free*512,microdrive_payload_bytes=sum(f.stat().st_size for f in mdv.iterdir() if f.is_file()),
                microdrive_allocated_bytes=sum(allocation[i*2] not in (0xfd,0xff,0xf8,0x80) for i in range(255))*512)
    (target/'metadata.json').write_text(json.dumps(meta,indent=2),encoding='utf-8')
    # Names retained for the native verification utilities and editor exports.
    shutil.copy2(image,target/'cup_disk_image.bin');shutil.copy2(target/'cup_image.lst',target/'cup_disk_image.lst')
    (target/'disk_metadata.json').write_text(json.dumps(meta,indent=2),encoding='utf-8')
    progress('Cartridge ready: '+str(target/'qlzero_classic_cup.mdv'))
    return meta


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--project',type=Path);ap.add_argument('--output',type=Path)
    args=ap.parse_args()
    result=build(open_project(args.project) if args.project else None,args.output)
    print(json.dumps({k:result[k] for k in ('version','image_bytes','resident_margin_bytes','microdrive_free_bytes')},indent=2))
