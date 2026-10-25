# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Create a playable v1 archive with blank records and SHA-256 checksums."""
import argparse,hashlib,zipfile
from pathlib import Path
from editor_model import ROOT
from mdv_image import blank_records


def package(folder,output):
    folder=Path(folder);output=Path(output)
    if output.exists():raise ValueError('Choose a new archive name; an existing release is never overwritten.')
    payload={'qlzero_classic_cup.mdv':blank_records((folder/'qlzero_classic_cup.mdv').read_bytes()),
             'cup_nanoql.bin':(folder/'cup_nanoql.bin').read_bytes(),
             'jaquette-ql-zero.png':(ROOT/'media/cover.png').read_bytes(),
             'ecran-titre-ql.png':(ROOT/'media/title.png').read_bytes(),
             'LIRE-MOI.md':(ROOT/'docs/PLAYING.md').read_bytes(),
             'LICENSE':(ROOT/'LICENSE').read_bytes(),'NOTICE':(ROOT/'NOTICE').read_bytes(),
             'CREDITS.md':(ROOT/'CREDITS.md').read_bytes()}
    payload['SHA256SUMS.txt']=''.join(f'{hashlib.sha256(data).hexdigest()}  {name}\n' for name,data in payload.items()).encode()
    output.parent.mkdir(parents=True,exist_ok=True)
    with zipfile.ZipFile(output,'w',zipfile.ZIP_DEFLATED,compresslevel=6) as z:
        for name,data in payload.items():z.writestr(name,data)
    with zipfile.ZipFile(output) as z:
        if z.testzip() is not None:raise ValueError('Release archive failed integrity check')
    return output


if __name__=='__main__':
    ap=argparse.ArgumentParser(description=__doc__)
    ap.add_argument('--build',type=Path,default=ROOT/'build/classic_cup')
    ap.add_argument('--output',type=Path,default=ROOT/'build/QL-Zero-v1.0.0.zip')
    args=ap.parse_args();print(package(args.build,args.output))
