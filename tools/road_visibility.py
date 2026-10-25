# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Conservative PVS for all integer headings and camera cells.

Uses the renderer's rounded signed 8.8 direction table and exact outer points.
A section is excluded only when its whole camera cell and heading bucket are
outside a guarded frustum. Affine extrema are at rectangle corners; the side
plane margin covers floor carries and integer near-clip intersections.
"""
import math,struct

def generate(mesh,far=4096):
    points=struct.unpack('>512H',mesh)
    sections=[]
    for n in range(32):
        a=n*16;b=((n+1)%32)*16
        sections.append([(points[k],points[k+1]) for k in (a,a+6,b,b+6)])
    out=bytearray()
    for cy in range(4):
        for cx in range(4):
            cams=[(x,y) for x in (cx*4096,(cx+1)*4096-1) for y in (cy*4096,(cy+1)*4096-1)]
            for bucket in range(8):
                mask=0
                for n,quad in enumerate(sections):
                    for angle in range(bucket*32,bucket*32+32):
                        co=round(math.cos(angle*math.tau/256)*256);si=round(math.sin(angle*math.tau/256)*256)
                        lat=[((-x*si+y*co)-(-xx*si+yy*co))>>8 for x,y in quad for xx,yy in cams]
                        depth=[((x*co+y*si)-(xx*co+yy*si))>>8 for x,y in quad for xx,yy in cams]
                        hi=max(depth);lo=min(depth)
                        # Correlated side planes are much tighter than an
                        # independent lateral/depth bounding box. Two pixels
                        # and 512 plane units protect projection, signed floor
                        # carries and the near-clipper's integer intersection.
                        if hi>=128 and lo<far and max(130*z-72*x for x,z in zip(lat,depth))>=-512 and max(130*z+72*x for x,z in zip(lat,depth))>=-512:
                            mask|=1<<(31-n);break
                out+=mask.to_bytes(4,'big')
    assert len(out)==512
    return bytes(out)
