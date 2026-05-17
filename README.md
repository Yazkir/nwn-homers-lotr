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

## Redemption codes

Players redeem codes by typing `Code:<name>` in chat (any channel). The
handler is `unpacked/code_redeem.nss`, wired to `Mod_OnPlrChat`. Matching is
case-insensitive; the chat line is suppressed so the code doesn't broadcast
to other players.

Each redemption is keyed on the player's CD key, so a code can be used at
most once per CD key. Redemptions live in the NWN:EE campaign SQLite
database `coderedeem` (`<server>/database/coderedeem.sqlite3`), table
`redemptions(code, cdkey, redeemed_at)`.

Players see one of:

- **Unknown redemption code.** — the code name isn't defined.
- **That code has expired (was valid until YYYY-MM-DD).** — past expiration.
- **You have already redeemed that code.** — this CD key already used it.
- **Code redeemed successfully!** — reward applied.

### Adding a new code

Edit `unpacked/code_redeem.nss` and add a case in **both** functions:

```nwscript
// Expiration (UTC date, YYYY-MM-DD; "" = unknown code).
string GetCodeExpiration(string sCodeLower)
{
    if (sCodeLower == "freelegendary") return "2026-07-01";
    if (sCodeLower == "mynewcode")     return "2026-12-31";  // ← add
    return "";
}

// Reward.
int ApplyCodeBenefit(string sCodeLower, object oPC)
{
    if (sCodeLower == "freelegendary") { SetXP(oPC, 17498600); return TRUE; }
    if (sCodeLower == "mynewcode")     {                                    // ← add
        CreateItemOnObject("some_item_resref", oPC, 1);
        return TRUE;
    }
    return FALSE;
}
```

Code names in the script must be **lowercase** (the handler lowercases
incoming chat before matching). Advertise them in any case you like —
`Code:MyNewCode`, `code:mynewcode`, etc., all work.

Then `nwn-manager repack` to compile and install.

### Changing or removing an expiration

Edit the date string in `GetCodeExpiration()`. Comparison is `date('now') >
expiration`, so a code with expiration `2026-07-01` stops working on
`2026-07-02` (server time). To make a code permanent, set the expiration to
a far-future date like `9999-12-31`.

To pull a code immediately, set its expiration to a past date or remove its
case from `GetCodeExpiration()` (returning `""` makes it report "Unknown
redemption code.").

### Resetting / inspecting redemptions

Use any SQLite client against `<server>/database/coderedeem.sqlite3`:

```sh
sqlite3 coderedeem.sqlite3 'SELECT * FROM redemptions;'
sqlite3 coderedeem.sqlite3 "DELETE FROM redemptions WHERE code='freelegendary';"
```

Deleting a row lets that CD key redeem the code again.

## Server override files

Some server-side settings require files in NWN's `override/` directory
(`$HOME/.local/share/Neverwinter Nights/override/`). These are **not** tracked
in `unpacked/` and are not part of the `.mod` — they live outside the git
round-trip and must be recreated manually on a fresh server environment.

### `xptable.2da` — XP thresholds for levels 1–60

**Why it exists:** `NWNX_MaxLevel` (configured via `NWNX_MAXLEVEL_MAX=60` in
`server.env`) requires an XP threshold to be defined for every level up to the
configured cap. The base NWN data and CEP HAKs only define thresholds through
level 40. Without this file the server logs:

```
[NWNX_MaxLevel] No xp threshold set for level 42!  Max level reverted to 40.
```

and caps at 40 regardless of `server.env`.

**Interaction with HGLL (Higher Ground Legendary Leveling):**
Levels 41–60 are managed entirely by the HGLL NPC dialog, not the standard NWN
level-up UI. HGLL has its own XP thresholds in `hgll_const_inc.nss` (828,800
for level 41, escalating to 17,498,600 for level 60). Critically, `CheckLegendaryLevel`
in `hgll_func_inc.nss` uses `GetHitDice` (the player's actual game level) to
select which HGLL bonus to award — so if the standard NWN level-up UI were to
advance a player's HitDice beyond 40, HGLL would skip legendary levels silently
and players would double-dip on class benefits.

**Current file:** rows 0–39 use the standard NWN quadratic formula
(`XP(level N) = N×(N−1)/2 × 1000`), identical to the vanilla table.
Rows 40–59 are set to a sentinel value of **2,000,000,000** — unreachable in
practice and well below NWScript's INT_MAX (2,147,483,647) — so the standard
NWN level-up button for levels 41–60 can never fire. NWNX_MaxLevel only requires
those rows to *exist*; the sentinel values satisfy the plugin without interfering
with HGLL. (Using HGLL's own max of 17,498,600 as the sentinel would be too low:
a player finishing HGLL 60 who earns even 1 more XP from combat would cross it
and could bypass HGLL entirely via the standard UI.)

**Recreate from scratch:**

```sh
python3 - <<'EOF'
import pathlib
SENTINEL = 2_000_000_000  # unreachable in practice; blocks standard UI for 41-60
lines = ['2DA V2.0', '', '    XPThreshold']
for row in range(40):
    lines.append(f'{row}   {row * (row + 1) // 2 * 1000}')
for row in range(40, 60):
    lines.append(f'{row}   {SENTINEL}')
out = pathlib.Path.home() / '.local/share/Neverwinter Nights/override/xptable.2da'
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text('\n'.join(lines) + '\n')
print(f'Written: {out}')
EOF
```

**If you want standard NWN leveling 41–60 instead of HGLL** (double-dip mode —
players get both class levels and HGLL bonuses, very powerful): replace the
sentinel values with the standard quadratic formula continued through row 59.
Be aware this causes HGLL to skip legendary levels for any player whose HitDice
advances ahead of their HGLL documented level.

**Roll back to default (levels 1–40 only, max cap 40):**

```sh
rm "$HOME/.local/share/Neverwinter Nights/override/xptable.2da"
```

Removing the file lets the server fall back to whatever `xptable.2da` the CEP
HAKs provide, which only covers levels 1–40. Also set `NWNX_MAXLEVEL_MAX=40`
in `server.env` (or remove `NWNX_MAXLEVEL_SKIP=n`) to match.

## Prerequisites

`nasher`, `nwn_gff`, `nwn_script_comp`, and `python3` (for `wiki`) must be
on `PATH`. See [`nwn-manager`](../nwn_manager/README.md) for install
instructions on Bazzite / immutable Fedora.
