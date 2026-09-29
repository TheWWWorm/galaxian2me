#!/usr/bin/env python3
"""Refresh the hosted Web files (public/, parts.json, export-hashes.json) from an
engine-only Web export.

The numbered-part approach follows the Apache-2.0 DEEP remake. Original game
archives and converted resources must never be placed in the exported directory.
"""
import argparse
import hashlib
import json
from pathlib import Path
import shutil

ROOT = Path(__file__).resolve().parents[1]
LIMIT = 25 * 1024 * 1024
CHUNK = 20 * 1024 * 1024
SUFFIXES = ('.html', '.js', '.wasm', '.pck', '.png')
HEADERS = '''/*
  Cross-Origin-Opener-Policy: same-origin
  Cross-Origin-Embedder-Policy: require-corp
  Cross-Origin-Resource-Policy: same-origin
  X-Content-Type-Options: nosniff
  Referrer-Policy: no-referrer
  Cache-Control: no-cache
'''

def prepare(source, output):
    source, output = Path(source).resolve(), Path(output).resolve()
    if source == output or output.is_relative_to(source):
        raise ValueError('Output must be separate from the export')
    files = sorted(p.name for p in source.iterdir()
                   if p.is_file() and not p.is_symlink() and p.suffix in SUFFIXES)
    if 'index.html' not in files or 'index.pck' not in files:
        raise ValueError('Not a Web export: index.html and index.pck are required')
    public = output / 'public'
    if public.exists():
        shutil.rmtree(public)
    public.mkdir(parents=True)
    parts, hashes = {}, {}
    for name in files:
        raw = (source / name).read_bytes()
        hashes[name] = hashlib.sha256(raw).hexdigest()
        if len(raw) > LIMIT:
            count = (len(raw) + CHUNK - 1) // CHUNK
            parts['/' + name] = {'count': count, 'size': len(raw)}
            for index in range(count):
                (public / f'{name}.part{index}').write_bytes(raw[index*CHUNK:(index+1)*CHUNK])
        else:
            (public / name).write_bytes(raw)
    (public / '_headers').write_text(HEADERS)
    (output / 'parts.json').write_text(json.dumps(parts, indent=2)+'\n')
    (output / 'export-hashes.json').write_text(json.dumps(hashes, indent=2)+'\n')
    if output != ROOT:
        for name in ('worker.js', 'wrangler.toml'):
            shutil.copyfile(ROOT / name, output / name)
    print(f'{output}: {len(files)} engine files, {len(parts)} split for the host limit')

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source', required=True, type=Path)
    parser.add_argument('--output', default=ROOT, type=Path)
    args = parser.parse_args()
    prepare(args.source, args.output)
