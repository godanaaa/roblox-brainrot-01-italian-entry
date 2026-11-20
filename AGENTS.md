# AGENTS.md — ITALIAN BRAINROT WORLD, session 22 (build): LIVELIER BRAINROTS

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
  = session 21 commit, BUILD 21, clean tree except untracked out/).
- Counted files = `main.ts` + `src/**/*.luau` only. A counted file already
  in the repo with final content when this recording began fails
  `transcripts_witnessed` — so you MUST write (or revise) every counted
  file you touch inside this session. `vendor/makefun-roblox.ts` must stay
  byte-identical. AGENTS.md is NOT counted — rewrite it yourself at the
  end for session 23 (physical vehicle store).
- Verify with: `~/workspace/bin/rojo build default.project.json -o
  game.rbxl` (rebuild game.rbxl from source — never hand-edit it),
  `node main.ts` twice (dossier must be byte-identical; main.ts writes to
  $MAKEFUN_OUTPUT_DIR, default /output — set MAKEFUN_OUTPUT_DIR to a /tmp
  dir and sha the dossier there), and `node cli/makefun.mjs check --repo
  /home/hatch/workspace/roblox-brainrot-01-italian-entry --worktree` from
  /home/hatch/workspace/roblox-brainrot-01-kit (expected: 4 passed, 1
  failed = play_link only, 17 skipped).
- Build marker: update `src/client/MenuController.luau` BuildMarker text
  to "BUILD 22 • 20 NOV 2026".

## JOB — one change (Ryan's brief, 02:35 EAT 20 Nov)
**MAKE THE BRAINROTS LOOK MORE LIVELY.** All 100 brainrots should feel
livelier and more polished — still part-built only (no images, no decals,
no copied art; original chibi style: big heads, big eyes, signature
items). Brighter and more varied colours, richer signature-item detail
(Tralalero's shark + sneakers, Bombardiro's crocodile + bomber, Ballerina
Cappuccina's tutu, and so on for the other named characters), faces with
expression (eyes, shine, blush, smiles), small accessories where they
fit, and livelier idle motion (bob / spin / sway / hop — varied per
character, not the same motion on all 100). Rarity must still read at a
glance (bigger / brighter / more detailed for higher rarities, glow for
MYTHIC and SECRET). The catalogue stays EXACTLY as-is (100 names,
prices, incomes, rarity bands, zone multipliers, Tralalero override).
The session-19 stall-label fixes must still hold (labels 150x40, within
16 studs, short 2-line format). Keep the part count reasonable. Landings,
anchors, stalls, markets, paths, barriers and decorations do NOT move.
Keep everything from sessions 1–21. Do NOT change prices, incomes,
rarity bands, zone multipliers, gates, or the admin system.
- This is session 22, a BUILD session — the final session (PLAY.json +
  screenshots) is session 25, after Ryan re-tests this one and the
  sessions after it.

## Session 21 outcome (what you are building on — do NOT regress it)
- BUILD 21 (recording 01a1f648): one change — smooth themed decorations
  for all 7 zones, ~160 new parts, nothing else touched (no
  price/income/rarity/gate/multiplier/admin change; Config.luau untouched).
- A new "decorations" district in MapBuilder.luau builds them through one
  uniform `dec(name,x,z,w,h,d,color,material,shape,collide,gy,yOff)` helper
  (absolute coordinates, rounded parts only — balls, cylinders, wedges),
  placed in the OUTER band of each slab, outside the 140x140 inlay props.
  Starter City: 4 street lamps, 2 benches, 1 fountain, 4 flower
  planters, 2 banners. Italian Village: 2 terracotta pot clusters, 1
  grape-vine trellis, 1 laundry line, 2 cafe tables, 1 fountain. Neon
  City: 4 glowing trees, 2 light columns, 1 "NEON CITY • GLOW DISTRICT"
  sign, 2 neon ground strips. Luxury District: 2 gold statues, 3 marble
  columns, 1 gold fountain, 2 red carpets. Volcano: 2 lava-rock clusters,
  2 obsidian shards, 2 smoke vents, 2 ember lights. Sky Islands: 4
  floating clouds, 2 floating lanterns, 2 sky gardens, 2 wind chimes
  (gy=99). Secret Dimension: 2 purple crystal clusters, 2 floating
  shards, 2 glowing rune circles, 2 dark portals. Small ground items
  (flowers, carpets, strips, runes) are CanCollide=false; lamps, benches,
  fountains, statues, pillars and trees collide like street furniture.
- Every placement was clearance-audited by ~/workspace/s21-deco-audit.py
  (parses the dec() calls out of the Lua and checks each 3D box against
  169 exclusion boxes: roads, market fences + signs, platforms, pads,
  district buildings, existing props, residences, base plots, the Bazaar,
  the Sky ramp, city buildings). First run found 34 overlaps — all real:
  the four Starter-area buildings (Bank, QuestCenter, Dealership,
  PremiumShop) sit on the slab corners and swallowed the first draft's
  north/south planters and lamps; the Luxury fountain touched the travel
  pad; two Sky clouds intersected the district building / existing cloud
  puffs; one Secret rune nearly touched a rift pillar. All fixed by
  moving the items (lamps to (-45,-115)/(45,-115), planters to
  (-80,80)/(80,80)/(125,-30)/(-125,30), Luxury fountain to (800,540),
  clouds to (1030,780)/(1160,770)/(1020,880)/(1190,800), rune to
  (115,1165)); the second audit run (3D-aware, with y-ranges) passed with
  0 overlaps. The audit script is kept for reuse.
- Verification (session 21): Rojo build clean — game.rbxl <size>, sha256
  <sha> (was 69,760); main.ts twice, exit 0, dossiers byte-identical,
  sha256 <sha>; kit check 4 passed, 1 failed (play_link only), 17
  skipped. Block-balance check on all touched Luau files: balanced
  (finalDepth 0).
- Caveats carried forward: a player can still walk AROUND a zone barrier
  on the grass beside the road (the barrier spans the road plus 2 studs
  each side, not the whole 280-wide slab) — but they cannot buy from that
  zone's stalls without UnlockedZones, and the Map travel gate still
  applies. The session-19 caveat also stands: at viewports narrower than
  ~900px the centred 620-wide event banner can briefly touch the left
  MENU button during an event only; at normal widths (1455) no overlap.

## Sessions 1–20 carried forward (do NOT regress)
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
What you changed per item (which files, what livelier details went into
the brainrots, how the idle motion varies per character, and how rarity
still reads at a glance), and the verification results (rojo sha + size,
dossier sha, kit check). Say plainly how Ryan confirms in Studio (look
at brainrots up close in different zones — lively chibi characters, not
plain blocks). Quote any transcript/record warnings in full.
