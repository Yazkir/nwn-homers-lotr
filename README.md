# Homer's LOTR VEL v3

Source-form mirror of the Neverwinter Nights 1 module **Homer's LOTR VEL v3**,
unpacked for git tracking and LLM-assisted editing.

The original `.mod` is a binary ERF archive (~68 MB, ~7280 resources). This
project keeps each resource as a plain-text file under `unpacked/` — GFFs as
JSON, scripts as `.nss` source — so changes diff cleanly and an LLM can read
or modify them directly.

## Layout

```
nasher.cfg       build-target definition (output filename, source patterns)
unpacked/        the source tree — JSON + .nss (committed)
.nasher/source   path of the .mod to unpack/install (per-machine, gitignored)
dist/            build output (gitignored)
wiki/            generated HTML wiki (gitignored)
.nasher/         nasher's working cache (gitignored)
```

## Round-trip workflow

Driven by `nwn-manager` from the [nwn_manager](../nwn_manager/README.md)
project:

```sh
nwn-manager unpack       # NWN/data/mod/Homer's…v3.mod  →  unpacked/
# ... edit JSON / .nss in unpacked/, commit to git ...
nwn-manager repack       # unpacked/  →  dist/  →  NWN/data/mod/Homer's…v3.mod
nwn-manager wiki         # unpacked/  →  wiki/index.html (multi-page HTML wiki)
# ... open the module in the NWN:EE toolset or run it ...
```

`unpack` overwrites whatever is currently in `unpacked/`; `repack` overwrites
the `.mod` in NWN's modules folder. Source of truth is `unpacked/` + git, not
the `.mod`. The wiki is regenerated only on explicit `nwn-manager wiki`.

## Source `.mod` path

The path to the installed `.mod` is recorded in `.nasher/source` (gitignored,
per-machine). It points at:

```
/home/james/Link to Neverwinter Nights/data/mod/Homer's LOTR VEL v3.mod
```

`nwn-manager` sanitizes the path through `/tmp` before invoking `nwn_erf`,
so the apostrophe in the filename is no longer an issue.

## Wiki

A browsable reference for all areas, creatures, items, quests, and scripts is
published at:

**<https://mrprice22.github.io/nwn-homers-lotr/index.html>**

The wiki is generated from `unpacked/` via `nwn-manager wiki` and deployed
separately; the `wiki/` directory is gitignored.

## Prerequisites

`nasher`, `nwn_gff`, `nwn_script_comp`, and `python3` (for `wiki`) must be
on `PATH`. See [`nwn-manager`](../nwn_manager/README.md) for install
instructions on Bazzite / immutable Fedora.
