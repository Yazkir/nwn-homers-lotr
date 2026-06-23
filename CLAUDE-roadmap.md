# Roadmap & merit-tracking backlog

`roadmap.yaml` (repo root) is the single source of truth for two things at once:

- the **public dev roadmap** at <https://homerslotr.com/manual/Roadmap.html> (what
  shipped, what's in progress, what's planned), and
- the **merit-tracking backlog** — almost every item started as a player suggestion or
  bug report, and when it ships the submitter earns **Merit** to spend on rewards. The
  `player:` field is the credit ledger.

It compiles to `docs.manual/Roadmap.html` via `bin/gen-roadmap.py`, which the wiki build
folds into the published `docs/`.

## The refresh process

```
edit roadmap.yaml                       # by hand, or with the GUI editor (below)
python3 bin/gen-roadmap.py              # -> rewrites docs.manual/Roadmap.html
bin/refresh-homers-lotr-wiki           # -> folds docs.manual/ into published docs/
```

`gen-roadmap.py --check` validates without writing (prints `roadmap.yaml OK` or the
errors). It also joins shipped items to git commit dates (the `commit:` field) and warns
on likely duplicate ideas. The wiki refresh does **not** call `gen-roadmap.py` — run it
yourself first.

## `roadmap.yaml` schema

Top-level keys, in order: `meta`, `groups`, `redemption`, `housing`, `ideas`. The GUI
editor only touches `ideas` (the last key); the others stay hand-edited.

Each entry under `ideas:` is one backlog item:

| Field | Required | Notes |
|-------|----------|-------|
| `id` | yes | Stable unique key, lowercase-hyphen (e.g. `forge-zero-value-exploit`). Referenced by `dupe_of`. |
| `title` | yes | The public one-line description shown on the page. This **is** the description. |
| `group` | yes | Must match a `groups[].id` (`forge`, `combat-classes`, `bosses`, …). |
| `status` | yes | One of the five below. |
| `player` | no | Submitter credit. Omit for admin/community items; use `community` for crowd-sourced. |
| `date` | no | `YYYY-MM-DD`, what the page shows. If absent, derived from `commit`. |
| `commit` | no | git ref used to derive `date` for shipped items. |
| `notes` | no | Extra detail beyond the title. |
| `dupe_of` | no | Another item's `id`; merges this submitter's credit into that canonical item. |

**Statuses** (workflow order): `awarded` (shipped, merit awarded) · `implemented`
(shipped, in testing) · `confirmed` (actively being worked) · `wip` (queued, "Up Next")
· `planned` (under consideration). The badge labels live in `STATUS` in
`bin/gen-roadmap.py` — the editor reads them from there so the two never drift.

**Duplicate ideas:** when several players suggest the same thing, keep one canonical item
and add a row per other submitter with `dupe_of: <canonical-id>` and their `player:`.
`gen-roadmap.py` folds all the credits onto the canonical item, and warns (advisory only)
when two same-group titles look similar but aren't linked with `dupe_of`.

**Established submitter names** (avoid typos — a misspelling silently splits a player's
credit): `Methonash`, `Piskan`, `Tukwut`, `McGondy`, `dc0960`, `Fugdish`,
`FLYING HITCHER`, `Yazkir`, plus the `community` sentinel. The GUI sources its player
picker from the names already in the file.

## GUI editor — `bin/roadmap-editor.py`

A local web app (Python stdlib `http.server` + PyYAML, no extra deps) that edits the
`ideas` backlog without the typo classes above. Run it and open the printed URL:

```
python3 bin/roadmap-editor.py            # serve + open a browser
python3 bin/roadmap-editor.py --serve    # serve only (no browser; used by the service)
python3 bin/roadmap-editor.py --port N   # default port is 8765
```

What it does:

- **Typo-proofs the controlled fields.** `group`, `status`, and `dupe_of` are dropdowns
  sourced from the file itself; `player` is a combobox of existing submitters that warns
  (but still allows) when you type a name that isn't already in use.
- **Validates before writing** using `gen-roadmap.py`'s own `validate()` — duplicate
  ids, unknown group/status, and dangling `dupe_of` block the save and are shown inline;
  nothing is written on error.
- **Preserves the file.** It only rewrites the `ideas:` block (the last top-level key);
  the header comments and the `meta`/`groups`/`redemption`/`housing` blocks are kept
  verbatim, and each item's leading section-header comment travels with it by `id`. An
  unchanged save is a byte-for-byte no-op.
- **Save & regenerate** writes `roadmap.yaml` then runs `gen-roadmap.py`, surfacing its
  output (including duplicate-idea warnings) in the page. You still run
  `bin/refresh-homers-lotr-wiki` to publish.

Reordering items in the list reorders them in the file; Add/Delete behave as expected.

### Run it on boot (systemd user service)

`systemd/roadmap-editor.service` keeps the editor always running at
`http://localhost:8765`, so it's just a bookmark instead of a command to remember:

```
mkdir -p ~/.config/systemd/user
ln -s /var/home/james/GIT/nwn_homers_lotr/systemd/roadmap-editor.service ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now roadmap-editor.service
loginctl enable-linger "$USER"      # start at boot, before you log in
```

Check it: `systemctl --user status roadmap-editor.service` and
`curl -s localhost:8765/api/data`.
