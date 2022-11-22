#!/usr/bin/env python3

# Original code by, and Copyright, Alexander O'Mara:
#
# https://alexomara.com/blog/adding-a-segment-to-an-existing-macos-mach-o-binary/

import io
import os
import sys
import contextlib
from macholib.ptypes import (
    sizeof
)
from macholib.mach_o import (
    LC_SEGMENT_64,
    load_command,
    segment_command_64,
    section_64,
    dyld_info_command,
    symtab_command,
    dysymtab_command,
    linkedit_data_command
)
from macholib.MachO import (
    MachO
)

VM_PROT_NONE = 0x00
VM_PROT_READ = 0x01
VM_PROT_WRITE = 0x02
VM_PROT_EXECUTE = 0x04

SEG_LINKEDIT = b'__LINKEDIT'

def align(size, base):
    over = size % base
    if over:
        return size + (base - over)
    return size

def copy_io(src, dst, size=None):
    blocksize = 2 ** 23
    if size is None:
        while True:
            d = src.read(blocksize)
            if not d:
                break
            dst.write(d)
    else:
        while size:
            s = min(blocksize, size)
            d = src.read(s)
            if len(d) != s:
                raise Exception('Read error')
            dst.write(d)
            size -= s

def vmsize_align(size):
    return align(max(size, 0x4000), 0x1000)

def cstr_fill(data, size):
    if len(data) > size:
        raise Exception('Pad error')
    return data.ljust(size, b'\x00')

def find_linkedit(commands):
    for i, cmd in enumerate(commands):
        if not isinstance(cmd[1], segment_command_64):
            continue
        if cmd[1].segname.split(b'\x00')[0] == SEG_LINKEDIT:
            return (i, cmd)

def shift_within(value, amount, within):
    if value < within[0] or value > (within[0] + within[1]):
        return value
    return value + amount

def shift_commands(commands, amount, within, shifts):
    for (Command, props) in shifts:
        for (_, cmd, _) in commands:
            if not isinstance(cmd, Command):
                continue
            for p in props:
                v = getattr(cmd, p)
                setattr(cmd, p, shift_within(v, amount, within))

def main(args):
    if len(args) <= 5:
        print('Usage: macho_in macho_out segname sectname sectfile')
        return 1
    (_, macho_in, macho_out, segname, sectname, sectfile, *optional) = args

    with contextlib.ExitStack() as stack:
        fi = stack.enter_context(open(macho_in, 'rb'))
        fo = stack.enter_context(open(macho_out, 'wb'))
        fs = stack.enter_context(open(sectfile, 'rb'))

        macho = MachO(macho_in)
        if macho.fat:
            raise Exception('FAT unsupported')
        header = macho.headers[0]

        # Find the closing segment.
        (linkedit_i, linkedit) = find_linkedit(header.commands)
        (_, linkedit_cmd, _) = linkedit

        # Remember where closing segment data is.
        linkedit_fileoff = linkedit_cmd.fileoff

        # Find the size of the new segment content.
        fs.seek(0, io.SEEK_END)
        sect_size = fs.tell()
        fs.seek(0)

        # Create the new segment with section.
        lc = load_command(_endian_=header.endian)
        seg = segment_command_64(_endian_=header.endian)
        sect = section_64(_endian_=header.endian)
        lc.cmd = LC_SEGMENT_64
        lc.cmdsize = sizeof(lc) + sizeof(seg) + sizeof(sect)
        seg.segname = cstr_fill(segname.encode('ascii'), 16)
        seg.vmaddr = linkedit_cmd.vmaddr
        seg.vmsize = vmsize_align(sect_size)
        seg.fileoff = linkedit_cmd.fileoff
        seg.filesize = seg.vmsize
        seg.maxprot = int(optional[0]) if len(optional) >= 1 else VM_PROT_READ | VM_PROT_WRITE;
        seg.initprot = seg.maxprot
        seg.nsects = 1
        sect.sectname = cstr_fill(sectname.encode('ascii'), 16)
        sect.segname = seg.segname
        sect.addr = seg.vmaddr
        sect.size = sect_size
        sect.offset = seg.fileoff
        sect.align = 0 if sect_size < 16 else 4

        # Shift closing segment down.
        linkedit_cmd.vmaddr += seg.vmsize
        linkedit_cmd.fileoff += seg.filesize

        # Shift any offsets that could reference that segment.
        shift_commands(
            header.commands,
            seg.filesize,
            (linkedit_fileoff, linkedit_cmd.filesize),
            [
                (dyld_info_command, [
                    'rebase_off',
                    'bind_off',
                    'weak_bind_off',
                    'lazy_bind_off',
                    'export_off'
                ]),
                (symtab_command, [
                    'symoff',
                    'stroff'
                ]),
                (dysymtab_command, [
                    'tocoff',
                    'modtaboff',
                    'extrefsymoff',
                    'indirectsymoff',
                    'extreloff',
                    'locreloff'
                ]),
                (linkedit_data_command, [
                    'dataoff'
                ])
            ]
        )

        # Update header and insert the segment.
        header.header.ncmds += 1
        header.header.sizeofcmds += lc.cmdsize
        header.commands.insert(linkedit_i, (lc, seg, [sect]))

        # Write the new header.
        header.write(fo)

        # Copy the unchanged data.
        fi.seek(fo.tell())
        copy_io(fi, fo, linkedit_fileoff - fo.tell())

        # Write new section data, padded to segment size.
        copy_io(fs, fo, sect_size)
        fo.write(b'\x00' * (seg.filesize - sect_size))

        # Copy remaining unchanged data.
        copy_io(fi, fo)

    # Copy mode to the new file.
    os.chmod(macho_out, os.stat(macho_in).st_mode)

    return 0

if __name__ == '__main__':
    sys.exit(main(sys.argv))
