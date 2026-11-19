# Italian Brainrot World — session 3 handoff

Sessions 1 and 2 remain the sealed foundation. Session 3 extends their Rojo world and keeps the existing start path: menu opens automatically, START PLAYING invokes the server, the character loads, and the player arrives at the central plaza.

## Session 3 build

- Corrected the cash catalogue from 97 names / 64 explicitly listed tiers to 100 names / 100 tiers. The 33 session 2 additions receive a deliberate rarity spread; three original names complete the catalogue. All 100 calculated cash prices fit their rarity bands, the top price is $2,000,000, and Tralalero Tralala remains LEGENDARY at $25,000 and +$500/s.
- Added server validated Scooter, Car, Supercar and TralaleroMobile purchases. Owned vehicles spawn by the player’s base garage (or at the dealership before a base exists), use a VehicleSeat, and clean up on exit or leave.
- Added a quest-gem shop for permanent 2X income, timed Auto Collect of the existing five-second collection bonus, +5 base slots, and Golden / Diamond / Rainbow Brainrots that display and earn at the base. There is no Robux purchase flow.
- Persisted zone unlocks. Secret stalls require a successful Volcano unlock; Divine stalls require a successful Secret Dimension unlock. Those zones also check cash, base level and rebirth requirements. Physical zone pads explain requirements, and server travel checks them.
- Shop rows show Secret / Divine zone lock state. The collection index uses the OwnedIds set and counts unique discoveries.

## Session 3 verification

- `/home/hatch/workspace/bin/rojo build default.project.json --output game.rbxl` succeeds.
- `MAKEFUN_OUTPUT_DIR=out node main.ts` was run twice; `out/dossier.json` was byte-identical. `out/` contains game.rbxl, PLAY.json, src/, screenshots/ and dossier.json.
- Fresh kit check (`node cli/makefun.mjs check --repo /home/hatch/workspace/roblox-brainrot-01-italian-entry --worktree`) verifies 21 files. The sandbox blocks its git probe with EPERM; the coordinator should rerun on the host. PLAY.json is still unpublished and must be completed by Ryan.
- Client startup review: ClientMain lines 2–7 guards each Init and runs MenuController first; MenuController lines 1–8 creates the menu and visible START PLAYING button before connecting the play action; HUDController lines 2–8 creates HUD elements and subscribes to state. Each client Init is isolated by ClientMain’s pcall wrapper.

## Final recording plan

After Ryan publishes the place, record the actual Roblox play link in PLAY.json and capture fresh screenshots in `screenshots/`. Show the automatic start menu, START PLAYING into the plaza, the central city and marketplace, a purchase and base display/income, vehicle purchase and driving, gem shop, and locked/unlocked zone behavior. Then rerun the fresh kit check and have the coordinator run the bundle dry-run on the host with this session’s rollout added; sessions 1 and 2 already passed their dry-run. Do not fabricate play evidence before publishing.

Do not edit `vendor/makefun-roblox.ts`, `screenshots/`, PLAY.json or TOUR.json before the owner’s recording. Do not commit or push from this sandbox; the coordinator handles the commit. Keep the working menu → plaza path and server-side validation intact.
