# AGENTS.md — ITALIAN BRAINROT WORLD, session 24 (build): A HOME BASE FOR EVERY CHARACTER THAT JOINS

## Login / network (READ FIRST)
- There is NO network in the sandbox and NO login step here. Do NOT try to
  log in, connect, or run any `makefun login` command. The coordinator owns
  login, commit, push, bundle and submit; your job is ONLY the code below.
- You are writing directly (Muse-app harness). Codex hit its usage limit
  and is BLOCKED until 16 Dec 2026 — do NOT use Codex. Write the code with
  your own file tools. Do NOT start any `makefun record` command — the
  record tool is ALREADY RUNNING on the host (recording began BEFORE your
  session, so everything you write is witnessed). Do NOT seal, commit,
  push, or submit. Do NOT touch PLAY.json or screenshots/.

## Repo facts
- Repo: /home/hatch/workspace/roblox-brainrot-01-italian-entry (git HEAD
  = session 23 commit, BUILD 23, clean tree except untracked out/).
- Counted files = `main.ts` + `src/**/*.luau` only. A counted file already
  in the repo with final content when this recording began fails
  `transcripts_witnessed` — so you MUST write (or revise) every counted
  file you touch inside this session. `vendor/makefun-roblox.ts` must stay
  byte-identical. AGENTS.md is NOT counted — rewrite it yourself at the
  end for session 25 (PLAY.json + screenshots, the final session).
- Verify with: `~/workspace/bin/rojo build default.project.json -o
  game.rbxl` (rebuild game.rbxl from source — never hand-edit it),
  `node main.ts` twice (dossier must be byte-identical; main.ts writes to
  $MAKEFUN_OUTPUT_DIR, default /output — set MAKEFUN_OUTPUT_DIR to a /tmp
  dir and sha the dossier there), and `node cli/makefun.mjs check --repo
  /home/hatch/workspace/roblox-brainrot-01-italian-entry --worktree` from
  /home/hatch/workspace/roblox-brainrot-01-kit (expected: 4 passed, 1
  failed = play_link only, 17 skipped).
- Build marker: update `src/client/MenuController.luau` BuildMarker text
  to "BUILD 24 • 20 NOV 2026".

## JOB — one change (Ryan's brief, 02:37 EAT 20 Nov)
**A HOME BASE FOR EVERY CHARACTER THAT JOINS.** Every joining player
automatically gets their own base (name sign, collect pad, upgrade
station, garage, L1–L6 rebuilds). Currently only 8 base plots exist — fix
assignment so no player is ever baseless: assign a free plot on join; if
all plots are taken, add more plots or build additional plots
dynamically; never share a plot between two players; a player's base
persists across rejoins (same plot, owned brainrots still on display).
Existing base layout + upgrade system unchanged. Keep everything from
sessions 1–23. Do NOT change prices, incomes, rarity bands, zone
multipliers, gates, or the admin system.
- This is session 24, a BUILD session — the final session (PLAY.json +
  screenshots) is session 25, after Ryan re-tests this one.

## How bases work today (read BaseService.luau + DataService.luau first)
- `Base.Init()` builds 8 plots at x=-700+(i-1)*180, z=900 (yards
  150x120, x -700..560). `Base.Claim(player)` takes the FIRST free plot,
  rebuilds it at L1 for that player and sets plot.Owner; if none is free
  it warns "[IBW] Base.Claim found no available plot" and returns nil —
  the player is BASELESS (no base, no collect pad, no garage).
  `Base.Get(player)` finds a plot by Owner. `Base.Release(p)` frees the
  plot and rebuilds it as an empty L1 house. `Base.Rebuild(plot, level,
  player)` destroys everything except the Yard and rebuilds the house
  (scales with level), fence, name sign (player DisplayName + "'S
  BRAINROT EMPIRE"), collect pad, upgrade station, garage, home-travel
  pad, and the owned brainrots on display pads (6 per row).
- DataStore "IBW_Player_v1" persists Cash, Gems, Level, XP, Rebirths,
  BaseLevel, Owned, Quests, TotalEarned, Discovered, Vehicles,
  GemUpgrades, UnlockedZones. There is NO BasePlot field — plot
  assignment is NOT persisted, so on rejoin Base.Claim assigns whatever
  plot happens to be free first, which may differ from the player's
  previous plot (the house rebuilds at their saved BaseLevel with their
  saved Owned brainrots, but at a different plot).
- Where extra plots can go: the row at z=900 extends east cleanly for
  1–2 more plots (x=740, 920 — no trees, palms or hills inside those
  yards), but further east runs into the RollingHills (x=1182/1228,
  z 824..916) and the Sky zone airspace. Westward extension (x=-880)
  puts a yard over the palm at (-940,910) and trees at (-910,940) /
  (-840,940) — the session-12 precedent is to skip trees inside base
  yards, so a dynamic builder must clear or avoid them the same way.
  South of the row is the Secret slab (z 1000..1200, x -140..140) and
  the south world-edge barriers — do NOT put plots there. Whatever you
  build must not move the existing 8 plots, the zone slabs, the roads,
  the markets, the pads, or the barriers.
- Design notes: persist the plot assignment in the player profile
  (e.g. d.BasePlot) so Claim prefers the player's own plot on rejoin;
  make sure a freed plot (Release) can be re-claimed cleanly; a second
  player joining while the first is still in-game must never be handed
  the first player's plot. If you build plots dynamically, build the
  full plot (yard + house at the player's saved BaseLevel + owned
  brainrots on display) through the same Rebuild path, not a second
  house builder.

## Session 23 outcome (what you are building on — do NOT regress it)
- BUILD 23 (recording 01a1f661): one change — a physical vehicle store,
  nothing else touched (no price/income/rarity/gate/multiplier/admin
  change; Config.luau untouched).
- `src/server/Services/MapBuilder.luau` (new "showroom" district):
  MOTORI SHOWROOM flush against the south face of the existing
  Dealership (same 80-wide footprint, centre (-140,0,185), z
  157.5..212.5), marble floor (top y=-0.9, flush with the roads), 12-tall
  blue walls, dark slate roof with 1.5-stud overhang, big neon rooftop
  sign "MOTORI SHOWROOM  •  VEHICLES" (label maxDist 150, readable from
  the plaza), "ENTER" label on the lintel, 24-stud entrance gap in the
  east wall (facing the plaza/spawn). Four display pads in a 2x2 grid
  (Scooter (-160,172), Car (-120,172), Supercar (-160,198),
  TralaleroMobile (-120,198)), each 16x2x20 in its Config colour with a
  neon trim, a non-colliding sign board at its west edge ("NAME\n$PRICE",
  150x40, 16 studs), and a buy prompt (E) created FIRST, before the
  display model (same lesson as the stalls).
- `src/server/Services/VehicleService.luau`: new
  `Vehicles.BuildDisplayModel(v)` — same shape as makeVehicle (chassis
  + seat + 4 wheels, same sizes/colours) but anchored and inert
  (MaxSpeed/Torque 0), displayed facing the entrance (+X, yaw -90deg),
  wheels touching the pad (body centre pad top + 2.2). Init wires each
  pad's prompt to the SAME validation as the Vehicles menu
  (Vehicles.Purchase: cash check, ownership saved to the profile);
  already-owned → spawns the vehicle instead; every outcome is
  notified visibly (bought / already owned + spawned / need $X /
  data loading / unavailable). The Dealership facade prompt now reads
  "MOTORI SHOWROOM" and points next door instead of "OPEN VEHICLE
  GARAGE".
- Prompts are named "PurchasePrompt", so the GameService travel scan
  skips them (a buy press can never teleport the player), and their
  parents carry no ZoneName/TravelTarget attribute. Prices are read
  from Config.Vehicles (Scooter $1,500, Car $18,000, Supercar $180,000,
  TralaleroMobile $350,000) — none invented. The Vehicles menu panel
  is untouched and still works.
- Verification (session 23): Rojo build clean — game.rbxl 82,719 bytes
  (was 79,470), sha256
  73439c82ce2389886a9873f0ce9ab115bdfbbff7c068c04b3efdeb934b7e0107;
  main.ts twice, exit 0, dossiers byte-identical, sha256
  0df0c6acb46f17cf44f54575dad7279ef1592e06fc8265c1fb3e44d8602d6386
  (189,861 bytes); kit check 4 passed, 1 failed (play_link only), 17
  skipped. Block-balance check on MapBuilder.luau +
  VehicleService.luau + MenuController.luau: balanced (finalDepth 0).
  XML Rojo build confirms the showroom source is in the build
  (MOTORI SHOWROOM, ShowroomWallNorth, ShowroomFloor, BuildDisplayModel,
  VehicleId, ShowroomLintel, facade prompt text). No Luau parser exists
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

## Sessions 1–22 carried forward (do NOT regress)
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
What you changed per item (which files, how plot assignment works now,
where extra plots go or how they are built dynamically, how a base
persists across rejoins), and the verification results (rojo sha + size,
dossier sha, kit check). Say plainly how Ryan confirms in Studio (join
with a second test player if possible — or simulate joins — and confirm
each player gets their own named base, no sharing; rejoin and confirm
the same plot and the owned brainrots still on display). Quote any
transcript/record warnings in full.
