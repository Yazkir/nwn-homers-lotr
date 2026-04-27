#!/usr/bin/env bash
# repack.sh — build src/ into a .mod and install it back into the NWN
# modules folder, overwriting "Homer's LOTR VEL v3.mod".
#
# The build artifact lives under dist/ inside this project (gitignored);
# this script copies it to the NWN data dir so the module is playable.

set -euo pipefail

PROJECT=$(cd "$(dirname "$0")" && pwd)
DEST_MOD="/home/james/Link to Neverwinter Nights/data/mod/Homer's LOTR VEL v3.mod"
BUILT_MOD="$PROJECT/dist/homers_lotr_v3.mod"

PATH="$HOME/.nimble/bin:$PATH" "$PROJECT/bin/nwn-manager" repack

if [[ ! -f $BUILT_MOD ]]; then
  echo "error: expected build output not found: $BUILT_MOD" >&2
  exit 1
fi

cp -v "$BUILT_MOD" "$DEST_MOD"
echo "[repack.sh] installed to: $DEST_MOD"
