# AGENTS.md — ITALIAN BRAINROT WORLD, session 27 (recorded): FIX the two 422 repo checks (owner.json + README badges)

## Login / network (READ FIRST)
- There is NO network in the sandbox and NO login step here. Do NOT try to
  log in, connect, or run any `makefun login` command. The coordinator owns
  login, commit, push, bundle and submit; your job is ONLY the work below.
- You are writing directly (Muse-app harness). Codex hit its usage limit
  and is BLOCKED until 16 Dec 2026 — do NOT use Codex. Write the code with
  your own file tools. Do NOT start any `makefun record` command — the
  record tool is ALREADY RUNNING on the host (recording began BEFORE your
  session, so everything you write is witnessed). Do NOT seal, commit,
  push, or submit.
- Do NOT start this session until the coordinator says so. The play link
  and the screenshots are already in the repo from session 26 — this
  session touches ONLY the two files below.

## Why this session exists
- Session 26 (recording 01a1f8a9, commit bc89cce, pushed tip a04070f) is
  DONE and all kit checks pass (5 passed, 0 failed, 17 skipped). The
  submit was REFUSED HTTP 422 on two repo checks — the entry was NOT
  taken in:
  1. repo_owner: the repo at a04070f has NO .makefun/owner.json.
  2. repo_readme: README.md shows none of the three make.fun badges and
     no link to the bounty page.
- Your job is ONLY to fix those two checks. NOTHING ELSE changes.

## Repo facts
- Repo: /home/hatch/workspace/roblox-brainrot-01-italian-entry (git HEAD
  = a04070f = session 26 pushed tip, BUILD 25, clean tree except
  untracked out/).
- Counted files = `main.ts` + `src/**/*.luau` only. You touch NO counted
  file this session. `vendor/makefun-roblox.ts` must stay byte-identical.
  AGENTS.md is NOT counted — leave it as this session-27 brief (there is
  no next session planned; do NOT rewrite it).
- PLAY.json is already filled (place 108937451835753, universe
  10777984263, "ITALIAN BRAINROT SIMULATOR"). screenshots/ already holds
  exactly Ryan's 4 captures (01-volcano.jpg cover first, 02-menu-home.jpg,
  03-secret-dimension.jpg, 04-neon-market.jpg). game.rbxl is the session-25
  build (91,209 bytes, sha f96b4557...). Do NOT touch any of these.

## JOB — fix the two 422 repo checks, nothing else
1. Create `.makefun/owner.json` containing exactly:
   {"wallet": "DwP3TCxxSWTTqia3HiEMGNQAq3iMaUR4NWLELyMREhMR"}
   (one line, valid JSON — verify it parses.)
2. Fix README.md. Start from the make.fun readme_template (the
   coordinator fetched it from GET /api/competitions/roblox-brainrot-01/
   requirements) and fill its placeholders, keeping the existing README
   content otherwise:
   - Title stays `# ITALIAN BRAINROT WORLD`.
   - Directly under the title, add these three badge lines EXACTLY
     (character-for-character, no changes):
     [![make.fun · roblox-brainrot-01](https://make.fun/badge/roblox-brainrot-01.svg)](https://make.fun/bounty/roblox-brainrot-01?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)
     [![rank](https://make.fun/badge/roblox-brainrot-01/godanaaa/roblox-brainrot-01-italian-entry/rank.svg)](https://make.fun/bounty/roblox-brainrot-01/leaderboard?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)
     [![reward](https://make.fun/badge/roblox-brainrot-01/godanaaa/roblox-brainrot-01-italian-entry/reward.svg)](https://make.fun/bounty/roblox-brainrot-01?utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01)
   - {description} = the existing README description paragraph ("A bright,
     open-world collecting and base-building game built entirely from
     Roblox Parts. Explore a connected city, visit the Brainrot Bazaar,
     collect animated Brainrots, earn passive cash, and grow your personal
     empire.").
   - {run} = the repo's build command: `rojo build default.project.json --output game.rbxl`
   - {referral_code} = `3wc56acn`
   - {repo} = `roblox-brainrot-01-italian-entry`, {owner} = `godanaaa`
   - Keep the existing README content otherwise: the Build section (with
     its rojo command and the make.fun handoff command) and the Session 1
     systems section stay as they are. NOTE: the Build section's line
     "`PLAY.json` remains an unpublished placeholder; the owner adds the
     Roblox place link after publishing." is STALE — PLAY.json is filled
     now. Update that line to say PLAY.json names the published place
     (https://www.roblox.com/games/108937451835753/ITALIAN-BRAINROT-SIMULATOR).
   - End the README with the template's footer line, with the referral
     code filled in:
     <sub>Entered on [make.fun](https://make.fun/?ref=3wc56acn&utm_source=github&utm_medium=readme&utm_campaign=roblox-brainrot-01) · AI agents build software for cash rewards</sub>
     (This plus the badges gives the README its link to
     https://make.fun/bounty/roblox-brainrot-01.)
   - Verify afterwards: the README contains all three badge lines
     verbatim, a link to https://make.fun/bounty/roblox-brainrot-01, and
     the referral code 3wc56acn.
3. Verify (same as session 26): `~/workspace/bin/rojo build
   default.project.json -o game.rbxl` (expect byte-identical to the
   session-25 build — no source change this session; never hand-edit
   game.rbxl), `node main.ts` twice (dossier must be byte-identical;
   main.ts writes to $MAKEFUN_OUTPUT_DIR, default /output — set
   MAKEFUN_OUTPUT_DIR to a /tmp dir and sha the dossier there), and
   `node cli/makefun.mjs check --repo
   /home/hatch/workspace/roblox-brainrot-01-italian-entry --worktree`
   from /home/hatch/workspace/roblox-brainrot-01-kit (expected AFTER this
   session: 5 passed, 0 failed, 17 skipped — play_link, repo_owner and
   repo_readme all passing).
4. Do NOT touch main.ts, any src/**.luau, PLAY.json, screenshots/,
   game.rbxl (beyond the verification rebuild), or vendor/makefun-roblox.ts.
   Do NOT change prices, incomes, rarity bands, zone multipliers, gates,
   or the admin system. Do NOT bump the BUILD 25 marker
   (src/client/MenuController.luau). The marker stays at
   "BUILD 25 • 20 NOV 2026".

## Sessions 1–26 carried forward (do NOT regress)
- BUILD 25 (recording 01a1f827): zone-barrier intrusion boxes + sweep,
  rebuilt vehicle models, HOME button. BUILD 26 (recording 01a1f8a9):
  PLAY.json + Ryan's 4 screenshots, kit placeholders removed.
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
The .makefun/owner.json contents, confirmation that README.md contains
all three badge lines verbatim + the bounty link + referral code
3wc56acn, rojo sha + size, dossier sha, kit check result (expect 5/0/17).
Quote any transcript/record warnings in full.
