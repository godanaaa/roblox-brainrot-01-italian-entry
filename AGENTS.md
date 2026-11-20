# AGENTS.md — ITALIAN BRAINROT WORLD, session 26 (FINAL, recorded): PLAY.json + SCREENSHOTS

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
  = session 25 commit, BUILD 25, clean tree except untracked out/).
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
  ("BUILD 25 • 20 NOV 2026" in `src/client/MenuController.luau`,
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

## Session 25 outcome (what you are building on — do NOT regress it)
- BUILD 25 (recording 01a1f827): three fixes, no price/income/rarity/
  gate/multiplier/admin change; Config.luau untouched.
- DEFECT 1 (zone barriers): root cause — the road gates were 20-stud
  walls on open ground (each slab 280 wide), so players walked around
  them on the grass; the 0.5s sweep could not catch a walk-around (its
  catch window is a ~2.8-stud strip crossed in ~0.18s between ticks).
  The markets sit OUTSIDE their slabs and Volcano's road entered through
  its south edge with no gate (its east gate's ApproachDir was inverted,
  bouncing locked players TOWARD the market). A perimeter fence was
  rejected (different L-shaped slab+market regions per zone; the Sky ramp
  can be boarded from the side). Fix in ZoneBarrierService.luau: per-zone
  intrusion boxes (slab + market; the gate-side edge is 2 studs inside
  the gate line so the gate touch zone is outside the box; Sky's box is
  the island volume only, y 85..120) + a Heartbeat position sweep — a
  player inside a box who never unlocked the zone is ejected to the
  road-gate approach with LOCKED; a player who passes the live gate is
  flagged in instead. MapBuilder.luau: new Volcano entry gate at
  (-1000,5,-660) on the actual road, and the old Volcano gate's approach
  flipped to (-1,0,0). Audit ~/workspace/s25-zone-audit.py: 0 failures
  (anchors + markets inside their boxes, all 21 base plots + the Bazaar
  outside all boxes, every road enters a box only at its gate). Leaving
  is still always allowed; a player who unlocked a zone and then spent
  below its gate is never ejected.
- DEFECT 2 (vehicles): VehicleService.luau now has one shared builder
  for driven + display models — real shaping, not a single box: Scooter
  (step-through floor, handlebar, saddle, 2 in-line wheels); Car (hood,
  cabin with glass windshield/side/rear windows, rear roof, bumpers,
  grille, mirrors, headlights/taillights, 4 round wheels with hubcaps);
  Supercar (low wedge nose, roadster cabin, spoiler, side skirts, neon
  underglow, slim headlights, full-width taillight bar, gold-rimmed
  wheels); TralaleroMobile (shark snout, toothy grin, shark eyes, dorsal
  + tail fins, gold band, white sneaker rims). Wheels are true round
  discs (Size (diameter, thickness, diameter) rotated 90deg about Z;
  the old (2,2,1) wheels were elliptical). Wheel bottoms at y=-2.2, so
  displays rest on the pads and driven spawns settle on the ground.
  Prices, purchase validation and spawn behaviour unchanged.
- HOME button: HUDController.luau has a green HOME button next to MENU
  (148,66, same 128x52 size) that calls Travel("Home"); init.server
  Travel("Home") now claims a plot first if the player has none, and
  lands them on the yard in front of their house (14 studs in front of
  the porch, depth grows with BaseLevel), facing the house (+Z) — the
  old landing was the plot centre, inside the house. The menu's Home
  item is unchanged (same remote).
- Verification (session 25): Rojo build clean; main.ts twice, dossiers
  byte-identical; kit check 4 passed, 1 failed (play_link only), 17
  skipped. Block-balance check on the changed files: balanced
  (finalDepth 0). No Luau parser exists on this machine (only rojo in
  ~/workspace/bin; no network), so Ryan's Studio test is the runtime
  check.
- Caveats carried forward: the session-19 caveat stands (at viewports
  narrower than ~900px the centred 620-wide event banner can briefly
  touch the left MENU button during an event only; at normal widths
  (1455) no overlap). Session-22 known cosmetic: the biggest (DIVINE
  1.56×) brainrots overhang their stall stand / base pad slightly —
  visual only, all parts are CanCollide=false. Honest cap: 21 concurrent
  plots; a 22nd simultaneous player would be baseless (warns as
  before) — beyond any realistic session for this entry.

## Sessions 1–24 carried forward (do NOT regress)
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
  with the same live gate as Map travel (session 25 added the intrusion
  sweep + the Volcano entry gate).
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
  scan skips them. (Session 25 rebuilt the vehicle models themselves.)
- Session 24 (do NOT regress): a home base for every joining player —
  BasePlot persisted in the DataStore profile, 10 static plots + 11
  dynamic slots (21 total), Claim prefers the persisted plot, else first
  free, else builds dynamically; never shares, never baseless while
  slots remain.
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
