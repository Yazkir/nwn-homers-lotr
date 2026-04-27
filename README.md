# Homer's LOTR VEL v3

Source-form mirror of the Neverwinter Nights 1 module **Homer's LOTR VEL v3**,
unpacked for git tracking and LLM-assisted editing.

The original `.mod` is a binary ERF archive (~68 MB, ~7280 resources). This
project keeps each resource as a plain-text file under `src/` — GFFs as JSON,
scripts as `.nss` source — so changes diff cleanly and an LLM can read or
modify them directly.

## Layout

```
unpack.sh       pull a fresh copy out of NWN's modules folder into src/
repack.sh       build src/ → .mod and install it back into NWN's modules folder
bin/nwn-manager thin wrapper around nasher (the actual unpack/repack worker)
nasher.cfg      build-target definition (output filename, source patterns)
src/            the source tree — JSON + .nss
dist/           build output (gitignored)
.nasher/        nasher's working cache (gitignored)
```

## Round-trip workflow

```sh
./unpack.sh             # NWN/data/mod/Homer's…v3.mod  →  src/
# ... edit JSON / .nss in src/, commit to git ...
./repack.sh             # src/  →  dist/  →  NWN/data/mod/Homer's…v3.mod
# ... open the module in the NWN:EE toolset or run it ...
```

`unpack.sh` overwrites whatever is currently in `src/`; `repack.sh` overwrites
the `.mod` in NWN's modules folder. Source of truth is `src/` + git, not the
`.mod`.

## Why the symlink in `/tmp`?

`unpack.sh` symlinks the source `.mod` to `/tmp/homers_lotr_v3.mod` before
running unpack. The underlying `nwn_erf` tool fails to open paths containing
an apostrophe (`Homer's…`), so the clean-named symlink is a workaround.

## Prerequisites

`nasher`, `nwn_gff`, and `nwn_script_comp` must be on `PATH`. See the
top-level [`nwn-manager`](../nwn_manager/README.md) project for install
instructions on Bazzite / immutable Fedora.
