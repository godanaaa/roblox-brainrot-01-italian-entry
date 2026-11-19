# AGENTS.md — ITALIAN BRAINROT WORLD, session 19 (final): PLAY.json + SCREENSHOTS ONLY

## Login / network (READ FIRST)
- There is NO network in the sandbox and NO login step here. Do NOT try to
  log in, connect, or run any `makefun login` command. The coordinator owns
  login, commit, push, bundle and submit; your job is ONLY the work
  below. Do NOT start any `makefun record` command — the record tool is
  ALREADY RUNNING on the host (recording began BEFORE your session, so
  everything you write is witnessed). Do NOT seal, commit, push, or
  submit.

## What this session is
- You are a Muse agent writing DIRECTLY (not via Codex). Your session is
  being recorded by the make.fun record tool running in the background;
  everything you write is witnessed. Keep the build marker at "BUILD 18 •
  20 NOV 2026" (src/client/MenuController.luau, BuildMarker label).
- This session fills in PLAY.json (the published place's universe id /
  play link) and `screenshots/` ONLY, then rebuilds game.rbxl from the
  unchanged source. Do NOT change any .luau, main.ts, or Config in this
  session — the game is finished. Verify with Rojo (`~/workspace/bin/rojo
  build default.project.json -o game.rbxl`) and `node main.ts` (twice,
  dossier must be byte-identical) and the kit check (`node cli/makefun.mjs
  check --repo <repo> --worktree` from ~/workspace/roblox-brainrot-01-kit).
  Rebuild game.rbxl from the source — never hand-edit game.rbxl.
- PLAY.json and the screenshots come from Ryan: he publishes game.rbxl to
  a NEW Roblox place, puts `makefun-spatula-panorama-collar` in the place
  description, and sends 3–4 captures (≤256 KiB each, first by name =
  cover). If he has not sent them yet, WAIT — do not invent a play link
  or fake captures.

## Session 18 outcome (what you are building on — do NOT regress it)
- BUILD 18 (recording 01a1f616, Muse-app harness): owner-only in-game
  admin (`src/server/Services/AdminService.luau`, new file, wired into
  init.server.luau). Every command verifies the speaker against the
  game's creator (game.CreatorId / game.CreatorType) ON THE SERVER first
  — never a hardcoded name, so it works for Ryan's account (rkobeast544)
  whichever place he publishes to. Unpublished Studio test fallback:
  CreatorId == 0 means no creator on record, so the testing player is
  the owner (a published place always has a real CreatorId). Commands
  (owner only, typed in game chat): :cash N, :gems N, :level N,
  :rebirth N, :unlock (all 7 zones + $25,000,000 + Base Lv 6 + Rebirth 3),
  :tp <zone> (Starter, Italian, Neon, Luxury, Volcano, Sky, Secret —
  match by name, list shown if wrong), :give <brainrot name or id>
  (respects base slots, says visibly if full), :help. Every command
  answers with a top notification (success or the reason it failed);
  unknown commands from the owner show the list; non-owners typing these
  get NOTHING. Admin only ever touches the owner's own profile.
- Sessions 1–17 carried forward: distinct landscapes per zone (own
  280x280 slab), chibi brainrot look, early gates (Starter $0/Lv1/Reb0,
  Italian $100/Lv1/Reb0, Neon $1,000/Lv1/Reb0, Luxury $5,000/Lv2/Reb0,
  Volcano $25,000/Lv3/Reb0, Sky $75,000/Lv4/Reb1, Secret $250,000/Lv5/
  Reb2; rebirth $25k x (n+1)), welcome guide, early quests buy3 $750 +
  visit3 $1,000 + 5 gems, central Bazaar glassed in + trimmed to 20,
  each zone its own fenced marketplace (~20 brainrots; Sky 19). Cheapest
  brainrot $50 vs $500 starting cash. First event ~25s. Travel free
  (Map TRAVEL + pads). Notifications at the TOP. Left cash panel 340x46.
  Ground flat.
- Key invariants (do NOT break): init.server line 12 is
  `local Services=script:WaitForChild("Services")` (the line-12 bug from
  session 6 — never reintroduce `script.Parent.Services`); zone stall
  PurchasePrompts are NOT travel prompts (GameService scan skips prompts
  named "PurchasePrompt"); zone anchors, travel pads, arrival platforms
  and stall positions stay where they are; every teleport landing must
  still be on solid ground.
- Zone anchors (Config.Zones): Starter City (0,0,0) $0/Lv1/Reb0; Italian
  Village (−700,0,450) $100/Lv1/Reb0; Neon City (700,0,−400) $1,000/Lv1/
  Reb0; Luxury District (800,0,650) $5,000/Lv2/Reb0; Volcano (−1100,0,
  −800) $25,000/Lv3/Reb0; Sky Islands (1100,100,850) $75,000/Lv4/Reb1;
  Secret Dimension (0,0,1100) $250,000/Lv5/Reb2. Zone multipliers
  {1,1.5,2,3,5,8,12} (Starter ×1 … Secret ×12). Zone rarity offers:
  Starter COMMON/UNCOMMON/RARE; Village UNCOMMON/RARE/EPIC; Neon RARE/
  EPIC; Luxury EPIC/LEGENDARY; Volcano LEGENDARY/MYTHIC; Sky MYTHIC/
  SECRET; Secret MYTHIC/SECRET/DIVINE.
- Known gap (left as-is, out of scope): the HomeTravel pad in BaseService
  has TravelTarget="City" but NO ProximityPrompt (label only). Secret
  Dimension destination (0,8,1075) lands on the GROUND tiles (top y=−1),
  6 studs NORTH of the platform (z 1081..1119) — SAFE (solid ground), but
  NOT on the platform.

## Repo facts
- `default.project.json` maps src/server → a Script named "Server" under
  ServerScriptService; `Services/` is a CHILD of that script — use
  `script:WaitForChild("Services")`, never `script.Parent.Services`.
- Counted files = main.ts + src/**/*.luau only. `vendor/makefun-roblox.ts`
  must stay byte-identical.
- Both reference images are STYLE + LAYOUT reference only. Do NOT copy
  the base-screenshot character names (Burgerone Bazooka, Il Re dei
  Calzini, Orologio Infinito, Spaghettus Maximus, Cosmic La Mucca
  Cosmica), UI text or art. Ryan's explicit instructions override them
  where they differ.
