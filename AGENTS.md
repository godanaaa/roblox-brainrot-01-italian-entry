# AGENTS.md — ITALIAN BRAINROT WORLD, session 28 (recorded): ADD the 16:9 thumbnail file (entry_link fix)

## Login / network (READ FIRST)
- There is NO network in the sandbox and NO login step here. Do NOT try to
  log in, connect, or run any `makefun login` command. The coordinator owns
  login, commit, push, bundle and submit; your job is ONLY the work below.
- You are writing directly (Muse-app harness). Codex hit its usage limit
  and is BLOCKED until 16 Dec 2026 — do NOT use Codex. Write the file with
  your own file tools. Do NOT start any `makefun record` command — the
  record tool is ALREADY RUNNING on the host (recording began BEFORE your
  session, so everything you write is witnessed). Do NOT seal, commit,
  push, or submit.
- Do NOT start this session until the coordinator says so. The cover
  screenshot is already in the repo from session 26 — this session derives
  ONE new file from it.

## Why this session exists
- Round 3 was REJECTED on entry_link (HTTP 422, checked live): the place's
  first thumbnail is not the same picture as any of the 4 screenshots —
  nearest is screenshots/02-menu-home.jpg at 107/256 perceptual-hash bits
  (same picture resized/re-encoded stands at most 32). All other checks
  pass (repo_owner, repo_readme, repo_about, signature, security audit,
  duplicate_snapshot).
- Fix from the site: upload the same picture as the experience's first
  thumbnail AND keep it in screenshots/ — a 16:9 picture such as 1280x720,
  PNG or JPEG at most 256 KiB — then submit round 4 before 17:30 EAT.
- Your job is ONLY to create that file. The coordinator (main chat) then
  pushes, gets the thumbnail uploaded as the place's FIRST thumbnail
  (browser via Creator Dashboard, or Ryan), verifies the place page shows
  it, and submits round 4.

## Repo facts
- Repo: /home/hatch/workspace/roblox-brainrot-01-italian-entry (git HEAD
  = 470a02a = session 27 pushed tip, BUILD 25, clean tree except
  untracked out/).
- Counted files = `main.ts` + `src/**/*.luau` only. You touch NO counted
  file this session. `vendor/makefun-roblox.ts` must stay byte-identical.
  AGENTS.md is NOT counted — leave it as this session-28 brief (there is
  no next session planned; do NOT rewrite it).
- PLAY.json is already filled (place 108937451835753, universe
  10777984263, "ITALIAN BRAINROT SIMULATOR"). screenshots/ already holds
  exactly Ryan's 4 captures (01-volcano.jpg cover first, 02-menu-home.jpg,
  03-secret-dimension.jpg, 04-neon-market.jpg). .makefun/owner.json is
  already in place. README.md already has the badges + bounty link.
  game.rbxl is the session-25 build (91,209 bytes, sha f96b4557...). Do
  NOT touch any of these.

## JOB — create the 16:9 thumbnail file, nothing else
1. Create `screenshots/05-thumbnail-1280x720.jpg` from the cover
   screenshot `screenshots/01-volcano.jpg` (1280x548, 62,832 bytes):
   center COVER-CROP to exactly 1280x720 — no stretch, no bars. The
   source is 1280x548 (wider than 16:9), so: take the CENTER 16:9 region
   (974 wide x 548 tall, centred horizontally) and resize it to 1280x720
   (Lanczos). Save as JPEG quality 82, optimize=True (PIL 10.2.0 is
   available; no ImageMagick on this machine). The file must be at most
   256 KiB (262,144 bytes).
2. Verify by VIEWING the result (read the file back as an image): the
   volcano subject must be intact (lava flows, red building, market
   stalls in the distance), no distortion, no black bars, no stretching.
   Also check the dimensions are exactly 1280x720 and the size is
   <=256 KiB. If the crop cuts the volcano subject badly, shift the crop
   window horizontally (stay centred vertically — the source is only
   548 tall, so there is no vertical room to move) and re-verify.
3. Verify (same as sessions 26–27): `~/workspace/bin/rojo build
   default.project.json -o game.rbxl` (expect byte-identical to the
   session-25 build — no source change this session; never hand-edit
   game.rbxl), `node main.ts` twice (dossier must be byte-identical;
   main.ts writes to $MAKEFUN_OUTPUT_DIR, default /output — set
   MAKEFUN_OUTPUT_DIR to a /tmp dir and sha the dossier there), and
   `node cli/makefun.mjs check --repo
   /home/hatch/workspace/roblox-brainrot-01-italian-entry --worktree`
   from /home/hatch/workspace/roblox-brainrot-01-kit (expected AFTER this
   session: 5 passed, 0 failed, 17 skipped).
4. Do NOT touch main.ts, any src/**.luau, PLAY.json, the 4 existing
   screenshots, game.rbxl (beyond the verification rebuild),
   .makefun/owner.json, README.md, AGENTS.md, or vendor/makefun-roblox.ts.
   Do NOT change prices, incomes, rarity bands, zone multipliers, gates,
   or the admin system. Do NOT bump the BUILD 25 marker
   (src/client/MenuController.luau). The marker stays at
   "BUILD 25 • 20 NOV 2026". The cover stays 01-volcano.jpg — the new
   file is named 05-... so it sorts AFTER the 4 existing screenshots and
   does NOT become the cover.

## Sessions 1–27 carried forward (do NOT regress)
- BUILD 25 (recording 01a1f827): zone-barrier intrusion boxes + sweep,
  rebuilt vehicle models, HOME button. BUILD 26 (recording 01a1f8a9):
  PLAY.json + Ryan's 4 screenshots, kit placeholders removed. Session 27
  (recording 01a1f8d6): .makefun/owner.json + README badges/bounty link.
- Key invariants (do NOT break): init.server line 12 is
  `local Services=script:WaitForChild("Services")` (the line-12 bug from
  session 6 — never reintroduce `script.Parent.Services`); zone stall
  PurchasePrompts are NOT travel prompts (GameService scan skips prompts
  named "PurchasePrompt"); zone anchors, travel pads, arrival platforms
  and stall positions stay where they are; every teleport landing must
  still be on solid ground.
- Caveats carried forward: the session-19 caveat stands (at viewports
  narrower than ~900px the centred 620-wide event banner can briefly
  touch the left MENU button during an event only; at normal widths
  (1455) no overlap). Session-22 known cosmetic: the biggest (DIVINE
  1.56×) brainrots overhang their stall stand / base pad slightly —
  visual only, all parts are CanCollide=false. Honest cap: 21 concurrent
  plots; a 22nd simultaneous player would be baseless (warns as
  before) — beyond any realistic session for this entry.

## Report back when done
The new file's name, dimensions, size, and what you saw when you viewed
it (volcano subject intact, no distortion, no bars), rojo sha + size,
dossier sha, kit check result (expect 5/0/17). Quote any
transcript/record warnings in full.
