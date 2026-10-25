# SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
"""Format 8: preserve physics/path/PVS, pack only the 32 used render caps."""
def pack(track):
    assert len(track)==11824 and track[4:6]==b'\0\6'
    data=bytearray(track[:10288])
    data+=b''.join(track[10288+n*32:10304+n*32] for n in range(32))
    data+=track[11312:]
    data[4:6]=b'\0\10'
    assert len(data)==11312
    return bytes(data)
