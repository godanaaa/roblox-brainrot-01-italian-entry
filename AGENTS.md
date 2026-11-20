# AGENTS.md — ITALIAN BRAINROT WORLD, session 25 (FINAL, recorded): PLAY.json + SCREENSHOTS

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
- Do NOT start this session until the coordinator says Ryan has published
  the game to a NEW Roblox place and sent 3–4 screenshots. The play link
  and the screenshots come from Ryan — never invent them, never fake a
  capture.

## Repo facts
- Repo: /home/hatch/workspace/roblox-brainrot-01-italian-entry (git HEAD
  = session 24 commit, BUILD 24, clean tree except untracked out/).
- Counted files = `main.ts` + `src/**/*.luau` only. A counted file already
  in the repo with final content when this recording began fails
  `transcripts_witnessed` — so you MUST write (or revise) every counted
  file you touch inside this session. `vendor/makefun-roblox.ts` must stay
  byte-identical. AGENTS.md is NOT counted.
- PLAY.json must be filled in DURING this recording (it is the last
  missing check: play_link). Screenshots go in `screenshots/` — 3–4
  files, ≤256 KiB each, first by name = cover. They MUST be the captures
  Ryan sends from his Studio playtest of the published place — never
  generate, copy, or reuse other images.
- Verify with: `~/workspace/bin/rojo build default.project.json -o
  game.rbxl` (rebuild game.rbxl from source — never hand-edit it),
  `node main.ts` twice (dossier must be byte-identical; main.ts writes to
  $MAKEFUN_OUTPUT_DIR, default /output — set MAKEFUN_OUTPUT_DIR to a /tmp
  dir and sha the dossier there), and `node cli/makefun.mjs check --repo
  /home/hatch/workspace/roblox-brainrot-01-italian-entry --worktree` from
  /home/hatch/workspace/roblox-brainrot-01-kit (expected AFTER this
  session: 5 passed, 0 failed, 17 skipped — play_link included).
- Build marker: the marker stays at the last build's text
  ("BUILD 24 • 20 NOV 2026" in `src/client/MenuController.luau`,
  BuildMarker label). Do NOT bump it — this session adds no gameplay.

## JOB — final session (Ryan's flow)
1. Take the NEW place's play link from the coordinator (Ryan publishes
   game.rbxl to a NEW Roblox place and puts the play code
   `makefun-spatula-panorama-collar` in the place description) and fill
   PLAY.json with it — universe id, place id, play link — exactly as the
   kit expects (see the PLAY.json schema / main.ts: the kit check's
   play_link must pass afterwards).
2. Copy Ryan's 3–4 screenshots into `screenshots/` (≤256 KiB each;
   first by name = cover). Verify each file's size; do not rename them
   unless the coordinator says so.
3. Rebuild game.rbxl with Rojo from the unchanged source (no gameplay
   change this session) and run main.ts twice + the kit check.
4. Report back: the PLAY.json contents, the screenshot file names +
   sizes, rojo sha + size, dossier sha, kit check result (expect 5/0/17).

## Session 24 outcome (what you are building on — do NOT regress it)
- BUILD 24 (recording 01a1f66d): one change — a home base for every
  character that joins. No price/income/rarity/gate/multiplier/admin
  change; Config.luau untouched.
- `src/server/Services/DataService.luau`: `fresh()` gains `BasePlot=0`
  (0 = no assigned plot). `Data.Load` backfills it for old profiles, and
  `Data.Save`/`Data.Remove`/`BindToClose` persist it — plot assignment
  now lives in the DataStore profile "IBW_Player_v1" like Cash and
  BaseLevel.
- `src/server/Services/BaseService.luau`: `Base.Init` now builds 10
  static plots (1–8 unchanged at x=-700+(i-1)*180, z=900; 9 at x=740 and
  10 at x=920 — both verified clear; plot 10's yard is cleared of the
  palm at (940,910) + stone at (940,870)). New `Base.ClearYard(x,z)`
  destroys small landscape items (TreeTrunk/TreeCrown/PalmTrunk/
  PalmCrown/PalmFrond/GardenStone/Wildflower) inside a yard — the
  session-12 precedent. New `Base.BuildPlot()` builds a plot dynamically
  from `extraSlots` (11 slots: (-880,900); then a second row at z=1030:
  500, 680, 860, 1040, 1220, -320, -500, -680, -860, -1040 — all
  clearance-audited with 0 hill intrusions and 0 yard overlaps,
  ~/workspace/s24-base-audit.py, kept for reuse). `Base.Claim(player)`
  now: (1) prefers the player's persisted plot (same base across
  rejoins, rebuilt at their saved BaseLevel with their owned brainrots
  on display); (2) else first free plot; (3) else builds one dynamically.
  Never shares a plot; never baseless while slots remain (10 static +
  11 dynamic = 21 plots — beyond any realistic session; if all 21 are
  taken Claim warns as before). Claim also rebuilds at the player's
  saved BaseLevel now (was hardcoded L1; new players are L1 anyway).
  Existing base layout + upgrade system unchanged. `Base.Release`
  unchanged (frees the plot, rebuilds empty L1; the profile keeps
  BasePlot so a rejoin reclaims it if still free).
- Verification (session 24): Rojo build clean — game.rbxl 84,125 bytes
  (was 82,719), sha256
  199bb74b8b57b916c3ad3582230553ff5db983e59637ce1be64b9cea0f73789c;
  main.ts twice, exit 0, dossiers byte-identical, sha256
  c80f6f001a98d2744a52afd026f5dc492d766f87929ca6528749f7c3aa397b09
  (189,902 bytes); kit check 4 passed, 1 failed (play_link only), 17
  skipped. Block-balance check on BaseService.luau + DataService.luau +
  MenuController.luau: balanced (finalDepth 0). No Luau parser exists
  on this machine (only rojo in ~/workspace/bin; no network), so Ryan's
  Studio test is the runtime check.
- Caveats carried forward: a player can still walk AROUND a zone barrier
  on the grass beside the road (the barrier spans the road plus 2 studs
  each side, not the whole 280-wide slab) — but they cannot buy from that
  zone's stalls without UnlockedZones, and the Map travel gate still
  applies. The session-19 caveat also stands: at viewports narrower than
  ~900px the centred 620-wide event banner can briefly touch the left
  MENU button during an event only; at normal widths (1455) no overlap.
  Session-22 known cosmetic: the biggest (DIVINE 1.56×) brainrots
  overhang their stall stand / base pad slightly — visual only, all
  parts are CanCollide=false.

## Sessions 1–23 carried forward (do NOT regress)
- Distinct landscapes per zone (own 280x280 slab), chibi brainrot look
  (oversized eyes + shine + blush, all 100), early gates (Starter
  $0/Lv1/Reb0, Italian $100/Lv1/Reb0, Neon $1,000/Lv1/Reb0, Luxury
  $5,000/Lv2/Reb0, Volcano $25,000/Lv3/Reb0, Sky $75,000/Lv4/Reb1,
  Secret $250,000/Lv5/Reb2; rebirth $25k x (n+1)), welcome guide, early
  quests buy3 $750 + visit3 $1,000 + 5 gems, central Bazaar glassed in
  + trimmed to 20, each zone its own fenced marketplace (~20 brainrots;
  Sky 19). Cheapest brainrot $50 vs $500 starting cash. First event
  ~25s. Travel free (Map TRAVEL + pads). Notifications at the TOP. Left
  cash panel 340x46. Ground flat. Owner-only in-game admin (session 18):
  :cash :gems :level :rebirth :unlock :tp :give :help — server-side
  creator check (game.CreatorId / game.CreatorType), CreatorId == 0
  means the Studio tester is the owner.
- Session 19 UI fixes (do NOT regress): no tofu boxes (MENU button is
  plain "MENU", event banner is "%s • %s • %ds", no "—" in user-visible
  strings — "•", "×" and the cash-panel emojis render and were kept);
  stall labels 150x40, visible only within 16 studs, short 2-line
  format; NeonSkylineSign towers at (850,0,-180); MENU button on the
  LEFT below the cash bar (12,66), MenuPanel below it (12,126).
- Session 20 (do NOT regress): smaller starting shop (stall grid spacing
  20 -> 18 studs, fenced enclosure 100x120 -> 80x96; central Bazaar
  trimmed at the north end to 280x420); walkable routes (21 gold-edged
  cobble road legs + Sky ramp + 7 signposts) with 6 invisible zone
  barriers + 8 world-edge barriers, enforced by ZoneBarrierService.luau
  with the same live gate as Map travel.
- Session 21 (do NOT regress): smooth themed decorations for all 7 zones
  (~160 parts, rounded shapes only) via the `dec()` helper in
  MapBuilder.luau, clearance-audited with 0 overlaps
  (~/workspace/s21-deco-audit.py, kept for reuse). Small ground items are
  CanCollide=false; lamps, benches, fountains, statues, pillars and trees
  collide like street furniture.
- Session 22 (do NOT regress): livelier brainrots — smiles + eyebrows
  varying per character, 12-colour palette, 2–4 extra detail parts per
  signature builder, one accessory per fallback form, rarity scale via
  Model:ScaleTo (COMMON 1.0 … DIVINE 1.56) + neon halo ring for MYTHIC /
  SECRET / DIVINE, idle motion varying per character (bob / spin / sway /
  hop / waddle, faster for higher rarities). `face()` uses `curId`, a
  module-level variable that `B.Create` sets to the entry id before
  building — the signature builders do not take an id parameter.
- Session 23 (do NOT regress): MOTORI SHOWROOM flush against the south
  face of the Dealership (centre (-140,0,185)), four display pads
  (Scooter $1,500, Car $18,000, Supercar $180,000, TralaleroMobile
  $350,000) with E buy prompts wired to the same Vehicles.Purchase
  validation as the menu; prompts named "PurchasePrompt" so the travel
  scan skips them.
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

## Report back when done
The PLAY.json contents, the screenshot file names + sizes, rojo sha +
size, dossier sha, kit check result. Quote any transcript/record
warnings in full.
