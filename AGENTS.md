# AGENTS.md — ITALIAN BRAINROT WORLD, session 20 (build): SMALLER STARTING SHOP + WALKABLE ROUTES

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
  = session 19 commit, BUILD 19, clean tree except untracked out/).
- Counted files = `main.ts` + `src/**/*.luau` only. A counted file already
  in the repo with final content when this recording began fails
  `transcripts_witnessed` — so you MUST write (or revise) every counted
  file you touch inside this session. `vendor/makefun-roblox.ts` must stay
  byte-identical. AGENTS.md is NOT counted — rewrite it yourself at the
  end for session 21 (lively smooth decorations per zone).
- Verify with: `~/workspace/bin/rojo build default.project.json -o
  game.rbxl` (rebuild game.rbxl from source — never hand-edit it),
  `node main.ts` twice (dossier must be byte-identical; main.ts writes to
  $MAKEFUN_OUTPUT_DIR, default /output — set MAKEFUN_OUTPUT_DIR to a /tmp
  dir and sha the dossier there), and `node cli/makefun.mjs check --repo
  /home/hatch/workspace/roblox-brainrot-01-italian-entry --worktree` from
  /home/hatch/workspace/roblox-brainrot-01-kit (expected: 4 passed, 1
  failed = play_link only, 17 skipped).
- Build marker: update `src/client/MenuController.luau` BuildMarker text
  to "BUILD 20 • 20 NOV 2026".

## JOB — two changes (Ryan's brief, 02:33 EAT 20 Nov)
1. **SMALLER SHOP IN THE STARTING VILLAGE.** The Starter City
   marketplace (the shop in the starting village) is too big. Shrink its
   physical footprint — tighter stall layout, smaller fenced area —
   while keeping all 20 of its brainrots purchasable. If the central
   Bazaar reads as oversized too, trim it the same way. Do NOT cut the
   brainrot counts; make the same shop smaller.
2. **WALKABLE ROUTES BETWEEN CITIES + INVISIBLE BARRIERS.** Right now
   the only way between cities is the Map or a travel pad. Add walkable
   ground paths (roads / bridges over the gaps between the zone slabs)
   so a player can WALK from Starter City into each other city. At each
   zone entrance put an INVISIBLE barrier (transparent, CanCollide)
   that blocks a player from walking in while the zone is still locked,
   and opens once the zone is unlocked — server-enforced, using the same
   gate requirements (cash + level + rebirth) as the Map travel. Also
   put invisible barriers at the world edges so players cannot walk off
   the slabs and fall. Keep the Map travel and the travel pads working
   exactly as before — walking is an additional way in, not a
   replacement. Landings, anchors, stalls, and markets do NOT move.
- Keep everything from sessions 1–19. Do NOT change prices, incomes,
  rarity bands, zone multipliers, gates, or the admin system.
- This is session 20, a BUILD session — the final session (PLAY.json +
  screenshots) is session 25, after Ryan re-tests this one and the
  sessions after it.

## Session 19 outcome (what you are building on — do NOT regress it)
- BUILD 19 (recording 01a1f626): four UI defects fixed, nothing else
  touched (no price/income/rarity/gate/multiplier/admin change;
  Config.luau untouched).
- Defect 1 (tofu boxes): the MENU button used U+2630 "☰" and the event
  banner used U+2726 "✦" — neither renders in Roblox Gotham, both showed
  as □. Both glyphs dropped: button is plain "MENU", banner is
  "%s • %s • %ds" (name • description • countdown). A full non-ASCII
  sweep found no other risky glyphs: "•" (U+2022), "×" (U+00D7) and the
  cash-panel emojis (money bag, diamond, star, flame) all render in
  Ryan's screenshots and were kept. The em dash "—" (U+2014) in four
  user-visible strings was replaced with "-" (hyphen) in
  HUDController.luau (leaderboard fallback), AdminService.luau (unknown
  zone; base full) and init.server.luau (welcome notify).
- Defect 2 (overlapping/clipped stall labels): `U.Label` in Util.luau
  now takes optional (width, height, maxDistance); defaults 190x48 /
  24 studs unchanged for signs, landmarks, travel pads and base plaques.
  Market stall labels (BrainrotService.luau) and zone stall labels
  (ShopService.luau) are now 150x40, show only within 16 studs (the
  same range as the buy prompt), and use a short 2-line format:
  market "Name\n$price  +$income/s" (rarity word dropped — rarity is
  in the buy prompt and the stall's rarity glow); zone "Name\n$price"
  (the "ZONE ×N" line dropped — the buy prompt already shows
  "ZONE ×N • BUY $price" + name/rarity/income). RefreshMarketPrices
  (ShopService.luau) writes the SAME short format, so the two writers
  no longer fight; the rain discount still shows in the buy prompt
  (" • SALE") and the label price is already discounted.
- Defect 3 (Neon sign blocked): the pink/cyan NeonSkylineSign towers +
  bars + "NEON CROWN" moved from (850,0,-285) to (850,0,-180) — 105
  studs north of the market, same avenue block, clear of the sign
  sightline from every approach. The sign itself stays at the west
  fence (798,6,-350), entrance side.
- Defect 4 (leaderboard overlaps MENU): the panel in Ryan's screenshots
  is the ROBLOX CORE player list (People / Cash / Rebirths / Brainrots —
  the leaderstats columns), which renders above PlayerGui and cannot be
  moved by the developer. Fix: the MENU button moved from top-right
  (1,-145,0,18) to the LEFT below the cash bar (12,66), and the
  MenuPanel dropdown moved from top-right (1,-275,0,80) to the left
  below the button (12,126). The game's own InfoPanel stays top-right
  (1,-480,0,82) — it never overlapped the button. Caveat: at viewports
  narrower than ~900px the centred 620-wide event banner can briefly
  touch the left MENU button during an event only; at normal widths
  (screenshots are 1455 wide) there is no overlap.

## Sessions 1–18 carried forward (do NOT regress)
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
What you changed per item (which files, the new shop footprint and stall
layout, where the walkable paths run, where each invisible barrier is
and how it opens), and the verification results (rojo sha + size,
dossier sha, kit check). Say plainly how Ryan confirms in Studio (walk
from Starter City into Italian Village on foot; try walking into a
locked zone and confirm the invisible barrier stops him; check the
starting-village shop is visibly smaller). Quote any transcript/record
warnings in full.
