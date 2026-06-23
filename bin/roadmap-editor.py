#!/usr/bin/env python3
"""Local web GUI for editing the `ideas` backlog in roadmap.yaml.

roadmap.yaml is the source of truth for the public dev roadmap AND the merit-
tracking backlog (shipped player ideas credit a submitter with Merit). It is
edited constantly and typo-prone in the places that matter most: player names,
group ids, statuses, and dupe_of references. This tool serves a small browser
form whose pickers are sourced from the file's own existing values, so those
fields can't drift on a typo. It validates with gen-roadmap.py's own validate()
before writing, and only rewrites the `ideas:` block (the last top-level key),
preserving the header comments and the meta/groups/redemption/housing blocks
verbatim. Per-item leading comment blocks (the section headers) travel with
their item by id.

Usage:
    python3 bin/roadmap-editor.py            # serve + open a browser
    python3 bin/roadmap-editor.py --serve    # serve only (used by the systemd unit)
    python3 bin/roadmap-editor.py --port N   # bind a different port (default 8765)
"""
from __future__ import annotations

import argparse
import importlib.util
import io
import json
import os
import re
import subprocess
import sys
import tempfile
import webbrowser
from contextlib import redirect_stderr
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path

import yaml

REPO = Path(__file__).resolve().parent.parent
YAML_PATH = REPO / "roadmap.yaml"
GEN_PATH = REPO / "bin" / "gen-roadmap.py"

# Field order each idea is serialized in. Only `id/title/group/status` are
# required; the rest are emitted only when present.
FIELD_ORDER = ["id", "title", "group", "status", "player", "date",
               "commit", "notes", "dupe_of"]
# Fields always rendered as YAML double-quoted scalars.
QUOTED_FIELDS = {"title", "notes", "date"}
# Players that aren't real people but are valid credits.
RESERVED_PLAYERS = ["community"]


def load_gen():
    """Import gen-roadmap.py (hyphenated name) to reuse STATUS + validate()."""
    spec = importlib.util.spec_from_file_location("gen_roadmap", GEN_PATH)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


GEN = load_gen()
STATUS = GEN.STATUS  # ordered dict: status -> {label, cls, board, rank}


# --------------------------------------------------------------------------
# roadmap.yaml read / vocab
# --------------------------------------------------------------------------
def read_yaml() -> dict:
    return yaml.safe_load(YAML_PATH.read_text(encoding="utf-8")) or {}


def vocab(data: dict) -> dict:
    """Controlled vocabularies for the UI pickers, sourced from the file."""
    ideas = data.get("ideas", []) or []
    groups = [{"id": g["id"], "title": g["title"]} for g in data.get("groups", [])]
    seen_players = {i["player"] for i in ideas if i.get("player")}
    players = sorted(seen_players - set(RESERVED_PLAYERS), key=str.lower)
    players = RESERVED_PLAYERS + players
    statuses = [{"id": k, "label": v["label"]} for k, v in STATUS.items()]
    ids = [i.get("id") for i in ideas if i.get("id")]
    return {"groups": groups, "players": players, "statuses": statuses, "ids": ids}


# --------------------------------------------------------------------------
# Comment-preserving write of the `ideas:` block
# --------------------------------------------------------------------------
ITEM_START = re.compile(r"^\s*-\s+id:\s*(\S+)")


def split_head_and_prefixes(text: str):
    """Return (head_text, {id: [prefix lines]}, [trailing lines]).

    head_text is everything up to and including the `ideas:` line, kept
    verbatim. Per-item prefixes are the comment/blank lines that precede each
    `- id:` item; trailing lines are comment/blank lines after the last item.
    """
    lines = text.splitlines()
    idx = next(i for i, ln in enumerate(lines) if re.match(r"^ideas:\s*$", ln))
    head = "\n".join(lines[: idx + 1]) + "\n"

    prefixes: dict[str, list[str]] = {}
    pending: list[str] = []
    last_id: str | None = None
    for ln in lines[idx + 1:]:
        m = ITEM_START.match(ln)
        if m:
            last_id = m.group(1)
            prefixes[last_id] = pending
            pending = []
        elif ln.strip() == "" or ln.lstrip().startswith("#"):
            pending.append(ln)
        # else: a body continuation line (title:, group:, ...) — skip; the body
        # is regenerated from the edited data, not preserved verbatim.
    trailing = pending
    return head, prefixes, trailing


def dquote(s: str) -> str:
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"') + '"'


def emit_scalar(field: str, value) -> str:
    s = str(value)
    if field in QUOTED_FIELDS:
        return dquote(s)
    if field == "player" and not re.fullmatch(r"[A-Za-z0-9_]+", s):
        return dquote(s)
    return s


def serialize_ideas(ideas: list[dict], prefixes: dict, trailing: list[str]) -> str:
    out: list[str] = []
    for idea in ideas:
        iid = idea.get("id", "")
        for pre in prefixes.get(iid, []):
            out.append(pre)
        first = True
        for field in FIELD_ORDER:
            val = idea.get(field)
            if val in (None, ""):
                continue
            scalar = emit_scalar(field, val)
            if first:
                out.append(f"  - {field}: {scalar}")
                first = False
            else:
                out.append(f"    {field}: {scalar}")
    out.extend(trailing)
    return "\n".join(out).rstrip("\n") + "\n"


def write_yaml(ideas: list[dict]) -> None:
    """Rewrite only the ideas block; everything above it is preserved verbatim."""
    original = YAML_PATH.read_text(encoding="utf-8")
    head, prefixes, trailing = split_head_and_prefixes(original)
    body = serialize_ideas(ideas, prefixes, trailing)
    new_text = head + body
    fd, tmp = tempfile.mkstemp(dir=str(REPO), prefix=".roadmap.", suffix=".tmp")
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            f.write(new_text)
        os.replace(tmp, YAML_PATH)
    except BaseException:
        if os.path.exists(tmp):
            os.unlink(tmp)
        raise


def validate_ideas(ideas: list[dict]) -> tuple[list[str], list[str]]:
    """Run gen-roadmap's validate(); return (fatal errors, warnings)."""
    data = read_yaml()
    data["ideas"] = ideas
    buf = io.StringIO()
    with redirect_stderr(buf):
        errors = GEN.validate(data)
    warnings = [ln.strip() for ln in buf.getvalue().splitlines() if ln.strip()]
    return errors, warnings


def regenerate() -> tuple[bool, str]:
    proc = subprocess.run(
        [sys.executable, str(GEN_PATH)],
        cwd=str(REPO), capture_output=True, text=True,
    )
    output = (proc.stdout + proc.stderr).strip()
    return proc.returncode == 0, output


# --------------------------------------------------------------------------
# HTTP server
# --------------------------------------------------------------------------
class Handler(BaseHTTPRequestHandler):
    def log_message(self, *a):  # quiet
        pass

    def _send(self, code: int, body: bytes, ctype: str):
        self.send_response(code)
        self.send_header("Content-Type", ctype)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _json(self, obj, code: int = 200):
        self._send(code, json.dumps(obj).encode("utf-8"), "application/json")

    def do_GET(self):
        if self.path == "/" or self.path.startswith("/index"):
            self._send(200, PAGE.encode("utf-8"), "text/html; charset=utf-8")
        elif self.path == "/api/data":
            data = read_yaml()
            self._json({"ideas": data.get("ideas", []) or [], "vocab": vocab(data)})
        else:
            self._send(404, b"not found", "text/plain")

    def _read_body(self) -> dict:
        n = int(self.headers.get("Content-Length", 0))
        return json.loads(self.rfile.read(n) or b"{}")

    def do_POST(self):
        try:
            payload = self._read_body()
        except Exception as e:
            return self._json({"ok": False, "errors": [f"bad request: {e}"]}, 400)
        ideas = payload.get("ideas", [])
        errors, warnings = validate_ideas(ideas)
        if errors:
            return self._json({"ok": False, "errors": errors, "warnings": warnings})

        if self.path == "/api/save":
            write_yaml(ideas)
            return self._json({"ok": True, "warnings": warnings,
                               "message": "Saved roadmap.yaml."})
        if self.path == "/api/regenerate":
            write_yaml(ideas)
            ok, output = regenerate()
            return self._json({"ok": ok, "warnings": warnings, "output": output,
                               "message": "Saved + regenerated Roadmap.html."
                                          if ok else "Regenerate FAILED."})
        return self._json({"ok": False, "errors": ["unknown endpoint"]}, 404)


# --------------------------------------------------------------------------
# Browser UI (single inline page, no build step, no external deps)
# --------------------------------------------------------------------------
PAGE = r"""<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Roadmap / Merit Backlog Editor</title>
<style>
  :root { --bg:#1e2127; --panel:#272b33; --ink:#e6e6e6; --mut:#9aa3af;
          --line:#3a3f4a; --accent:#6ea8fe; --warn:#e6b800; --err:#ff6b6b;
          --ok:#5cd6a0; }
  * { box-sizing:border-box; }
  body { margin:0; font:14px/1.45 system-ui,sans-serif; background:var(--bg);
         color:var(--ink); display:flex; height:100vh; }
  h1 { font-size:15px; margin:0 0 8px; }
  #left { width:380px; min-width:300px; border-right:1px solid var(--line);
          display:flex; flex-direction:column; }
  #right { flex:1; padding:16px 20px; overflow:auto; }
  .pad { padding:12px 14px; }
  #filter { width:100%; padding:7px 9px; background:var(--panel); color:var(--ink);
            border:1px solid var(--line); border-radius:6px; }
  #list { overflow:auto; flex:1; }
  .row { padding:8px 14px; border-bottom:1px solid var(--line); cursor:pointer; }
  .row:hover { background:#2d323b; }
  .row.sel { background:#33405a; }
  .row .t { display:block; }
  .row .meta { color:var(--mut); font-size:12px; }
  .badge { display:inline-block; padding:1px 7px; border-radius:10px; font-size:11px;
           background:#3a3f4a; color:#cfd6e0; }
  .badge.shipped,.badge.awarded { background:#26543f; color:#bdf0d6; }
  .badge.wip { background:#3a4a66; color:#cfe0ff; }
  .badge.planned { background:#4a4636; color:#f0e6bd; }
  .badge.confirmed,.badge.implemented { background:#503a4f; color:#f0cfe6; }
  label { display:block; margin:10px 0 3px; color:var(--mut); font-size:12px; }
  input,select,textarea { width:100%; padding:7px 9px; background:var(--panel);
           color:var(--ink); border:1px solid var(--line); border-radius:6px;
           font:inherit; }
  textarea { min-height:64px; resize:vertical; }
  .grid2 { display:grid; grid-template-columns:1fr 1fr; gap:0 14px; }
  button { padding:8px 13px; border:1px solid var(--line); border-radius:6px;
           background:var(--panel); color:var(--ink); cursor:pointer; font:inherit; }
  button:hover { border-color:var(--accent); }
  button.primary { background:var(--accent); color:#10161f; border-color:var(--accent);
                   font-weight:600; }
  button.danger { color:var(--err); }
  .bar { display:flex; gap:8px; flex-wrap:wrap; margin-top:14px; }
  .spacer { flex:1; }
  #banner { margin:10px 0; padding:9px 11px; border-radius:6px; display:none;
            white-space:pre-wrap; }
  #banner.ok { display:block; background:#193a2b; color:var(--ok);
               border:1px solid #2c6b4e; }
  #banner.bad { display:block; background:#3a1d1d; color:var(--err);
               border:1px solid #6b2c2c; }
  #banner.warn { display:block; background:#3a3417; color:var(--warn);
               border:1px solid #6b5e2c; }
  .hint { color:var(--warn); font-size:12px; margin-top:3px; min-height:14px; }
  .small { color:var(--mut); font-size:12px; }
</style></head>
<body>
<div id="left">
  <div class="pad">
    <h1>Roadmap / Merit Backlog</h1>
    <input id="filter" placeholder="filter by title, player, group, status…">
    <div class="bar">
      <button id="add">+ Add idea</button>
      <span class="spacer"></span>
      <span id="count" class="small"></span>
    </div>
  </div>
  <div id="list"></div>
</div>
<div id="right">
  <div id="banner"></div>
  <div id="form"></div>
</div>
<script>
let DATA = {ideas:[], vocab:{groups:[],players:[],statuses:[],ids:[]}};
let sel = -1;
const $ = s => document.querySelector(s);

function statusCls(s){ return s || ''; }
function esc(s){ return (s||'').replace(/[&<>"]/g, c => (
  {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c])); }

function groupTitle(id){
  const g = DATA.vocab.groups.find(g=>g.id===id);
  return g ? g.title.replace(/&amp;/g,'&') : (id||'—');
}

async function load(){
  const r = await fetch('/api/data'); DATA = await r.json();
  renderList(); if (DATA.ideas.length) select(0);
}

function renderList(){
  const q = $('#filter').value.toLowerCase();
  const box = $('#list'); box.innerHTML='';
  let shown=0;
  DATA.ideas.forEach((it,i)=>{
    const hay = [it.title,it.player,it.group,it.status,it.id].join(' ').toLowerCase();
    if (q && !hay.includes(q)) return;
    shown++;
    const d = document.createElement('div');
    d.className = 'row'+(i===sel?' sel':'');
    d.innerHTML = `<span class="t">${esc(it.title||'(untitled)')}</span>
      <span class="meta"><span class="badge ${statusCls(it.status)}">${esc(it.status||'?')}</span>
      ${esc(groupTitle(it.group))}${it.player?' · '+esc(it.player):''}</span>`;
    d.onclick = ()=>select(i);
    box.appendChild(d);
  });
  $('#count').textContent = `${shown}/${DATA.ideas.length} ideas`;
}

function opt(value,label,cur){
  return `<option value="${esc(value)}"${value===cur?' selected':''}>${esc(label)}</option>`;
}

function select(i){
  sel = i; renderList();
  const it = DATA.ideas[i]; if (!it) { $('#form').innerHTML=''; return; }
  const groups = DATA.vocab.groups.map(g=>opt(g.id, g.title.replace(/&amp;/g,'&'), it.group)).join('');
  const stats  = DATA.vocab.statuses.map(s=>opt(s.id, s.id+' — '+s.label, it.status)).join('');
  const players = ['<option value=""></option>'].concat(
      DATA.vocab.players.map(p=>opt(p,p,it.player||''))).join('');
  const dupes = ['<option value=""></option>'].concat(
      DATA.vocab.ids.filter(id=>id!==it.id).map(id=>opt(id,id,it.dupe_of||''))).join('');
  $('#form').innerHTML = `
    <label>Title (this IS the public one-line description)</label>
    <input id="f_title" value="${esc(it.title)}">
    <div class="grid2">
      <div><label>Group</label><select id="f_group">${groups}</select></div>
      <div><label>Status</label><select id="f_status">${stats}</select></div>
    </div>
    <div class="grid2">
      <div>
        <label>Player (submitter credit)</label>
        <input id="f_player" list="players_dl" value="${esc(it.player||'')}"
               placeholder="(none / admin)">
        <datalist id="players_dl">${players}</datalist>
        <div class="hint" id="player_hint"></div>
      </div>
      <div><label>Duplicate of (merges credit)</label>
        <select id="f_dupe">${dupes}</select></div>
    </div>
    <div class="grid2">
      <div><label>Date (shown on page)</label>
        <input id="f_date" type="date" value="${esc(it.date||'')}"></div>
      <div><label>Commit (optional git ref)</label>
        <input id="f_commit" value="${esc(it.commit||'')}"></div>
    </div>
    <label>id (stable key; lowercase-hyphen)</label>
    <input id="f_id" value="${esc(it.id||'')}">
    <label>Notes (extra detail, optional)</label>
    <textarea id="f_notes">${esc(it.notes||'')}</textarea>
    <div class="bar">
      <button class="primary" id="save">Save</button>
      <button id="regen">Save &amp; regenerate HTML</button>
      <span class="spacer"></span>
      <button class="danger" id="del">Delete</button>
    </div>
    <p class="small">Order in this list = order in the file. Use the buttons to move.</p>
    <div class="bar">
      <button id="up">↑ Move up</button>
      <button id="down">↓ Move down</button>
    </div>`;
  bindPlayerHint();
  $('#save').onclick = ()=>commit('/api/save');
  $('#regen').onclick = ()=>commit('/api/regenerate');
  $('#del').onclick = del;
  $('#up').onclick = ()=>move(-1);
  $('#down').onclick = ()=>move(1);
}

function bindPlayerHint(){
  const inp = $('#f_player'); const hint = $('#player_hint');
  const known = new Set(DATA.vocab.players);
  const check = ()=>{
    const v = inp.value.trim();
    hint.textContent = (v && !known.has(v))
      ? `“${v}” is not a known submitter — typo? (saving will still work)` : '';
  };
  inp.oninput = check; check();
}

function readForm(){
  return {
    id: $('#f_id').value.trim(),
    title: $('#f_title').value.trim(),
    group: $('#f_group').value,
    status: $('#f_status').value,
    player: $('#f_player').value.trim(),
    date: $('#f_date').value.trim(),
    commit: $('#f_commit').value.trim(),
    notes: $('#f_notes').value.trim(),
    dupe_of: $('#f_dupe').value,
  };
}

function pruneEmpty(o){
  const r={}; for (const k of ['id','title','group','status','player','date','commit','notes','dupe_of'])
    if (o[k]!=='' && o[k]!=null) r[k]=o[k];
  return r;
}

function banner(cls,msg){ const b=$('#banner'); b.className=cls; b.textContent=msg; }

async function commit(endpoint){
  if (sel>=0) DATA.ideas[sel] = pruneEmpty(readForm());
  const r = await fetch(endpoint, {method:'POST',
    headers:{'Content-Type':'application/json'},
    body: JSON.stringify({ideas: DATA.ideas})});
  const res = await r.json();
  if (!res.ok){
    banner('bad', 'Not saved:\n• ' + (res.errors||['unknown error']).join('\n• ')
      + (res.warnings&&res.warnings.length ? '\n\nWarnings:\n• '+res.warnings.join('\n• '):''));
    return;
  }
  let msg = res.message || 'Saved.';
  if (res.warnings && res.warnings.length) msg += '\n\nWarnings:\n• '+res.warnings.join('\n• ');
  if (res.output) msg += '\n\n'+res.output;
  banner(res.warnings&&res.warnings.length ? 'warn':'ok', msg);
  await load(); if (sel>=0) select(Math.min(sel, DATA.ideas.length-1));
}

function move(dir){
  if (sel<0) return;
  DATA.ideas[sel] = pruneEmpty(readForm());
  const j = sel+dir; if (j<0||j>=DATA.ideas.length) return;
  [DATA.ideas[sel],DATA.ideas[j]]=[DATA.ideas[j],DATA.ideas[sel]];
  sel=j; renderList(); select(sel);
}

function del(){
  if (sel<0) return;
  if (!confirm('Delete this idea from the backlog?')) return;
  DATA.ideas.splice(sel,1);
  sel = Math.min(sel, DATA.ideas.length-1);
  renderList(); if (sel>=0) select(sel); else $('#form').innerHTML='';
  banner('warn','Deleted in the editor. Click Save to write it to roadmap.yaml.');
}

$('#add').onclick = ()=>{
  const g = DATA.vocab.groups[0] ? DATA.vocab.groups[0].id : '';
  DATA.ideas.unshift({id:'', title:'', group:g, status:'planned'});
  sel=0; renderList(); select(0);
  banner('warn','New idea added. Give it a unique id + title, then Save.');
};
$('#filter').oninput = renderList;
load();
</script>
</body></html>
"""


def main():
    ap = argparse.ArgumentParser(description="Local web editor for roadmap.yaml ideas.")
    ap.add_argument("--port", type=int, default=8765)
    ap.add_argument("--serve", action="store_true",
                    help="serve without opening a browser (used by the systemd unit)")
    args = ap.parse_args()

    httpd = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    url = f"http://localhost:{args.port}/"
    print(f"Roadmap editor serving at {url}  (editing {YAML_PATH})")
    if not args.serve:
        try:
            webbrowser.open(url)
        except Exception:
            pass
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nbye")


if __name__ == "__main__":
    main()
