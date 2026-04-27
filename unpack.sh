#!/usr/bin/env bash
# unpack.sh — pull "Homer's LOTR VEL v3.mod" out of the NWN modules folder
# and refresh src/ from it.
#
# Symlinks the source .mod to a clean (apostrophe-free) path in /tmp first,
# because nwn_erf chokes on apostrophes in file paths.

set -euo pipefail

PROJECT=$(cd "$(dirname "$0")" && pwd)
SRC_MOD="/home/james/Link to Neverwinter Nights/data/mod/Homer's LOTR VEL v3.mod"
TMP_LINK=/tmp/homers_lotr_v3.mod

if [[ ! -f $SRC_MOD ]]; then
  echo "error: source module not found: $SRC_MOD" >&2
  exit 1
fi

ln -sf "$SRC_MOD" "$TMP_LINK"
PATH="$HOME/.nimble/bin:$PATH" exec "$PROJECT/bin/nwn-manager" unpack "$TMP_LINK"
