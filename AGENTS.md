# AGENTS.md — ITALIAN BRAINROT WORLD, session 21 (build): LIVELY SMOOTH DECORATIONS PER ZONE

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
  = session 20 commit, BUILD 20, clean tree except untracked out/).
- Counted files = `main.ts` + `src/**/*.luau` only. A counted file already
  in the repo with final content when this recording began fails
  `transcripts_witnessed` — so you MUST write (or revise) every counted
  file you touch inside this session. `vendor/makefun-roblox.ts` must stay
  byte-identical. AGENTS.md is NOT counted — rewrite it yourself at the
  end for session 22 (livelier brainrots).
- Verify with: `~/workspace/bin/rojo build default.project.json -o
  game.rbxl` (rebuild game.rbxl from source — never hand-edit it),
  `node main.ts` twice (dossier must be byte-identical; main.ts writes to
  $MAKEFUN_OUTPUT_DIR, default /output — set MAKEFUN_OUTPUT_DIR to a /tmp
  dir and sha the dossier there), and `node cli/makefun.mjs check --repo
  /home/hatch/workspace/roblox-brainrot-01-italian-entry --worktree` from
  /home/hatch/workspace/roblox-brainrot-01-kit (expected: 4 passed, 1
  failed = play_link only, 17 skipped).
- Build marker: update `src/client/MenuController.luau` BuildMarker text
  to "BUILD 21 • 20 NOV 2026".

## JOB — one change (Ryan's brief, 02:34 EAT 20 Nov)
**LIVELY SMOOTH DECORATIONS PER ZONE.** Every zone's landscape should
feel alive and finished, not flat or empty. Add smooth, themed
decorations to each of the 7 zones, matching each zone's own look
(Starter cobble piazza, Italian terracotta village, Neon glowing night
city, Luxury white marble + gold, Volcano black basalt + lava, Sky
floating islands + clouds, Secret dark purple rift): more trees, plants,
flowers, bushes, street lamps, benches, fountains, statues, banners,
glowing accents, clouds, and small ambient details that make the world
feel lived-in. Smooth the decoration shapes (rounded, polished parts, no
sharp placeholder blocks) and vary the placement so it doesn't look
copy-pasted. Keep the decorations OUT of the way — they must not block
walking paths, stall access, travel pads, arrival platforms, or base
plots, and must not cover the market signs. Keep the part count
reasonable so the game still runs smoothly. Landings, anchors, stalls,
markets, paths, and barriers do NOT move. Keep everything from sessions
1–20. Do NOT change prices, incomes, rarity bands, zone multipliers,
gates, or the admin system.
- This is session 21, a BUILD session — the final session (PLAY.json +
  screenshots) is session 25, after Ryan re-tests this one and the
  sessions after it.

## Session 20 outcome (what you are building on — do NOT regress it)
- BUILD 20 (recording 01a1f636): two changes, nothing else touched (no
  price/income/rarity/gate/multiplier/admin change; Config.luau untouched).
- Change 1 (smaller starting shop): every zone marketplace tightened —
  stall grid spacing 20 -> 18 studs (4x5 grid now 54x72 instead of
  60x80; stands are 14 wide, so a 4-stud gap remains between neighbours,
  and a neighbouring stall is 18 studs away — just outside the 16-stud
  range of the session-19 stall labels, so labels still never overlap),
  fenced enclosure 100x120 -> 80x96 (halfW 50 -> 40, halfD 60 -> 48).
  Market sign offsets now derive from the fence half-extents
  (halfW+2 / halfD+2) instead of hardcoded 52/62, so the sign always
  sits on the fence line. All ~20 brainrots per zone still purchasable
  (Sky 19 — unchanged). The central Bazaar was trimmed the same way at
  the north end only: floor 280x580 -> 280x420 (z 480..900), north glass
  walls + MarketSign + MarketEntranceSign + MarketNorthRamp moved to
  z=480/472 (60 studs north of the first stall row instead of 220);
  south wall, halls (z=860), east entrance gap (z 580..620) and the
  east/west walls' south ends did NOT move. The south-end trim was
  rejected because the halls would collide with the CanalBridge.
- Change 2 (walkable routes + invisible barriers): a new "zoneroads"
  district in MapBuilder.luau builds 21 road legs (16-stud cobble
  inlays, top y=-0.9, gold edge strips) on shared trunks out of the
  Starter plaza (east z=0 to x=1000, west z=0 to x=-1000, south x=0 to
  z=290) to every zone slab edge, plus a Starter-market spur that routes
  around the Bank to the market's west entrance gap at (220,-130), and a
  21.8deg cobble Sky ramp (1160,500 -> 1160,750, top flush with the Sky
  island at y=99, side rails, east of the Sky market island which ends
  at x=1145). Seven signposts mark each branch ("TO ITALIAN VILLAGE",
  "TO NEON CITY", "TO LUXURY DISTRICT", "TO VOLCANO", "TO SKY ISLANDS",
  "TO SECRET DIMENSION", "TO STARTER MARKET"). Six invisible zone
  barriers (transparent, CanCollide, 20 wide x 12 tall) sit across each
  zone's road entrance: Italian (-700,5,308), Neon (560,5,-300), Luxury
  (800,5,510), Volcano (-960,5,-800), Sky (1160,5,500), Secret
  (140,5,1050); each carries ZoneName + ApproachDir attributes. Eight
  invisible world-edge barriers ring the world (north z=-1100, west
  x=-1300, east x=1300, south z=1100 with a step-out to z=1200 around
  the Secret slab). New server service ZoneBarrierService.luau enforces
  the zone barriers with the SAME live gate as the Map travel handler
  (cash + BaseLevel + Rebirths): unlocked player -> zone marked
  unlocked (d.UnlockedZones, so zone stalls can be bought from) and the
  barrier opens (CanCollide=false) for 3s; locked player entering ->
  solid wall + LOCKED notify with the requirements (same format as
  travel), throttled to once per 3s per player per barrier; locked
  player leaving -> always allowed, opens with no notify. A 0.5s
  Heartbeat sweep bounces back a locked player who slipped through
  while the barrier was open for someone else (only within 12 studs of
  a barrier and on its zone side, so legitimate zone visitors are never
  touched). Map travel and travel pads work exactly as before.
- Verification (session 20): Rojo build clean — game.rbxl 69,760 bytes,
  sha256 f7149bfac670a7a30bdae59d82d19bcc6cf31795f2f3214af53e30498a75136a
  (was 62,863); main.ts twice, exit 0, dossiers byte-identical, sha256
  8828ba0b1afc19c8a0f34a7d6991b966189cede8ae9773d77d12d18418c5f8da
  (189,778 bytes); kit check 4 passed, 1 failed (play_link only), 17
  skipped. All routes clearance-audited against every building footprint
  (half-width 8); the only real blocker was the Bank on the Starter-
  market spur, fixed by routing around it. Block-balance check on all
  touched Luau files: balanced (finalDepth 0).
- Caveat carried forward: a player can still walk AROUND a zone barrier
  on the grass beside the road (the barrier spans the road plus 2 studs
  each side, not the whole 280-wide slab) — but they cannot buy from
  that zone's stalls without UnlockedZones, and the Map travel gate
  still applies. The session-19 caveat also stands: at viewports
  narrower than ~900px the centred 620-wide event banner can briefly
  touch the left MENU button during an event only; at normal widths
  (1455) no overlap.

## Sessions 1–19 carried forward (do NOT regress)
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
What you changed per item (which files, what decorations went into each
zone, where they are, and how you kept them out of the paths/stalls/pads),
and the verification results (rojo sha + size, dossier sha, kit check).
Say plainly how Ryan confirms in Studio (walk each zone and see the new
decorations; nothing blocks a path or a stall). Quote any
transcript/record warnings in full.
