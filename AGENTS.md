# AGENTS.md — ITALIAN BRAINROT WORLD, session 23 (build): PHYSICAL VEHICLE STORE

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
  = session 22 commit, BUILD 22, clean tree except untracked out/).
- Counted files = `main.ts` + `src/**/*.luau` only. A counted file already
  in the repo with final content when this recording began fails
  `transcripts_witnessed` — so you MUST write (or revise) every counted
  file you touch inside this session. `vendor/makefun-roblox.ts` must stay
  byte-identical. AGENTS.md is NOT counted — rewrite it yourself at the
  end for session 24 (a home base for every joining player).
- Verify with: `~/workspace/bin/rojo build default.project.json -o
  game.rbxl` (rebuild game.rbxl from source — never hand-edit it),
  `node main.ts` twice (dossier must be byte-identical; main.ts writes to
  $MAKEFUN_OUTPUT_DIR, default /output — set MAKEFUN_OUTPUT_DIR to a /tmp
  dir and sha the dossier there), and `node cli/makefun.mjs check --repo
  /home/hatch/workspace/roblox-brainrot-01-italian-entry --worktree` from
  /home/hatch/workspace/roblox-brainrot-01-kit (expected: 4 passed, 1
  failed = play_link only, 17 skipped).
- Build marker: update `src/client/MenuController.luau` BuildMarker text
  to "BUILD 23 • 20 NOV 2026".

## JOB — one change (Ryan's brief, 02:36 EAT 20 Nov)
**A PHYSICAL STORE TO BUY THE VEHICLES.** Build a showroom / dealership
building in or next to Starter City, easy to find from spawn, with a clear
sign, enterable through a clear entrance. Each vehicle — Scooter, Car,
Supercar, TralaleroMobile — sits on display on its own pad with a readable
name + price label and a buy prompt (E) that buys server-side with the
same validation as the existing vehicle system (cash check, ownership
saved to the profile, visible success/failure). The Vehicles menu panel
keeps working — the store is an ADDITIONAL way to buy, not a replacement.
The store must not block walking paths (including the session-20
zoneroads), travel pads, or the starting-village market. Prices: use the
EXISTING vehicle prices from the game's data (Scooter $1,500, Car $18,000,
Supercar $180,000, TralaleroMobile $350,000) — do NOT invent new prices.
The existing vehicle system lives in `src/server/Services/VehicleService.luau`
and the prices in `Config.Vehicles` — reuse that buy validation, do not
write a second one. Landings, anchors, stalls, markets, paths, barriers,
decorations and brainrots do NOT move. Keep everything from sessions 1–22.
Do NOT change prices, incomes, rarity bands, zone multipliers, gates, or
the admin system.
- This is session 23, a BUILD session — the final session (PLAY.json +
  screenshots) is session 25, after Ryan re-tests this one and the
  session after it.

## Session 22 outcome (what you are building on — do NOT regress it)
- BUILD 22 (recording 01a1f656): one change — livelier brainrots for all
  100, nothing else touched (no price/income/rarity/gate/multiplier/admin
  change; Config.luau untouched).
- `src/server/Services/BrainrotService.luau` (+131/-8): face() now gives
  every character a smile (three small balls in a shallow arc under the
  nose) and eyebrows whose tilt varies per character (id % 3: happy,
  playful, determined); body-colour palette brighter and more varied (12
  colours instead of 8); each of the 16 signature builders got 2–4 extra
  detail parts (Tralalero's tooth row + gold chain, Bombardiro's pilot
  goggles + bomb, Cappuccina's bow + steam, Gamberetta's gold trumpet +
  music notes, and so on); each of the 8 fallback forms got one small
  accessory placed where that form's head/top is (crown, saddle blanket,
  bowtie, flag, top hat, chef hat, flower, rocket flag). Rarity reads at
  a glance: whole-model scale by rarity via `Model:ScaleTo` (COMMON 1.0 …
  DIVINE 1.56; GOLDEN/DIAMOND/RAINBOW on the same ladder) plus a neon
  halo ring of 8 balls at the base for MYTHIC / SECRET / DIVINE (SECRET's
  halo is bright purple — its rarity colour is near-black). Idle motion
  varies per character (id % 5: bob, spin, sway, hop, waddle) and higher
  rarities move a little faster. Part-creating calls 136 → 198 (~+5 parts
  per model on average — reasonable).
- Session-19 stall-label format is UNCHANGED (150x40, 16 studs, 2-line
  "Name\n$price  +$income/s"); only the label height offset now grows
  with the rarity scale (4 × scale) so it still floats above the head.
- `face()` uses `curId`, a module-level variable that `B.Create` sets to
  the entry id before building — callers pass id when they have it,
  otherwise the face reads curId. Do not break this: the signature
  builders do not take an id parameter.
- Verification (session 22): Rojo build clean — game.rbxl 79,470 bytes
  (was 74,343), sha256
  78b5591324b427a2093988f6a5bb9b895651dc6715d36782868e65e79d1c3c35;
  main.ts twice, exit 0, dossiers byte-identical, sha256
  bde02e9bb2e9c564928189e9fdc55bfa07c5bfd4da177c6bbb2a889ff45dc814
  (189,861 bytes); kit check 4 passed, 1 failed (play_link only), 17
  skipped. Block-balance check on BrainrotService.luau +
  MenuController.luau: balanced (finalDepth 0).
- Caveats carried forward: a player can still walk AROUND a zone barrier
  on the grass beside the road (the barrier spans the road plus 2 studs
  each side, not the whole 280-wide slab) — but they cannot buy from that
  zone's stalls without UnlockedZones, and the Map travel gate still
  applies. The session-19 caveat also stands: at viewports narrower than
  ~900px the centred 620-wide event banner can briefly touch the left
  MENU button during an event only; at normal widths (1455) no overlap.
  New in session 22 (no action needed, just known): the biggest
  (DIVINE 1.56×) brainrots overhang their stall stand / base pad slightly
  — visual only, all parts are CanCollide=false.

## Sessions 1–21 carried forward (do NOT regress)
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
What you changed per item (which files, where the store is, what each
vehicle pad shows, how the buy prompt reuses the existing vehicle
validation), and the verification results (rojo sha + size, dossier sha,
kit check). Say plainly how Ryan confirms in Studio (walk into the store
from spawn, see all four vehicles with prices, press E on one, confirm it
buys and appears in the Vehicles panel). Quote any transcript/record
warnings in full.
