# Session 13 rollout — audit and verified fixes

## Findings

- Before edits, `/home/hatch/workspace/bin/rojo build default.project.json --output /tmp/session13-rebuild.rbxl` was byte-identical to the committed `game.rbxl` at `636da06`. This ruled out a stale committed place or Rojo mapping omission. The final rebuilt file differs because it includes this session's changes.
- Roblox binary place files compress script source, so raw byte searching their `.rbxl` output does not find all markers. I checked a Rojo XML place build of the same project: `ArrivalPlatform`, `TravelPad`, `WorldEventBanner`, `FrontLeft`, `PalmTrunk`, and `RefreshMarketPrices` are present. The matching source/artifact names are `RollingHill` (not `RollingGreenHill`) and `DisplayPad` (not `DisplayPlatform`). The features are included; those two example marker spellings do not match the implementation names.
- The first event delay in `src/server/Services/EventService.luau:14` was 180 seconds, making the banner easy to miss in a short Studio playtest. The first event now starts after 25 seconds; later cycles still wait 180 seconds and stay active for 75 seconds.
- `src/server/Services/ShopService.luau:72-91` returned `false` silently when player data was missing, a listing was invalid, a zone offer was unavailable, storage was full, or the player lacked cash. These paths now send a visible purchase-failure notification; invalid item IDs also emit an `[IBW]` warning. Server-side validation and purchase authority remain in place.

## Verified paths and unchanged requirements

- `src/server/init.server.luau:12` still waits for `Services`. Safe requires and initialization report `[IBW]` results; `Map.Build` runs before `Base.Init`, then shop, travel, vehicles, premium, events, and leaderboard services initialize. Play is installed before map building and claims a base before moving the player to spawn.
- Map district guards at `src/server/Services/MapBuilder.luau:11-13` log both success and full traceback on failure. Landscape, zones, and travel pads are created inside named districts. Arrival platforms meet the ground surface; travel pads sit above it.
- `Base.Claim` calls `Base.Rebuild` for a fresh player (`src/server/Services/BaseService.luau:39-46`); failures warn with traceback. The front wall leaves a 9-stud gap (`:65-68`), the porch is outside it (`:81`), and the collect pad is offset to the left (`:85`). The fence opening is centered at the yard entrance. No confirmed doorway blocker was found.
- Event delivery and rendering are connected through `EventService` and `EffectsController`; the banner is positioned below the top HUD. Rain pricing is recalculated at event start/end and applied in `ShopService.marketPrice` at buy time.
- DataStore access/load/save failures already warn and use memory fallback (`DataService.luau:2-8`). Zone gate numbers, travel handling, map districts, Play, and income logic were not changed. No confirmed startup crash or swallowed district error was found.

## Build marker and Studio checks

`src/client/MenuController.luau:6` adds the only new UI element: **BUILD 13 • 19 NOV 2026**, centered along the bottom of the initial title menu.

Ryan can confirm the build in this order:

1. On launch, read `BUILD 13 • 19 NOV 2026` at the bottom of the title menu.
2. Press Start Playing; within about 25 seconds, look for the timed event banner below the top HUD. It should show a name, description, countdown, and green progress bar.
3. Open Map and inspect READY/LOCKED rows with cash, base level, and rebirth requirements. At a zone beacon, read its glowing pad and `TRAVEL • $X • LV n • REBIRTH n` prompt; locked attempts should show a LOCKED notification.
4. Inspect the outer edge for rolling hills, palms, stones, and wildflowers. Walk the highway ramps and check they remain clear of wildflowers.
5. Go to the first claimed base. Confirm its colored house has a porch and walk-through front doorway, then buy a Brainrot and confirm it appears on a glowing rarity-colored display pad.
6. Try a marketplace purchase without enough cash and with full storage; each attempt should explain why it failed. During BRAINROT RAIN, confirm the displayed price and charged price are discounted.

If any existing feature still appears absent, check Studio Output for `[IBW] Map district '<name>' failed at part/line:`, `[IBW] Base.Claim failed`, or the corresponding initialization warnings. A healthy startup reports completed initialization and built map districts. DataStore fallback is expected to print `[IBW] DataStore unavailable; using memory-only profiles: ...` or load/save failure warnings when Studio API access is unavailable.

## Build and release recording

- Required final build: `/home/hatch/workspace/bin/rojo build default.project.json --output game.rbxl` completed successfully. `MAKEFUN_OUTPUT_DIR=out node main.ts` ran twice; `out/dossier.json` was byte-identical after the second run. `out/` contains `game.rbxl`, `PLAY.json`, `src/`, `screenshots/`, and `dossier.json`.
- The fresh level-27 kit check verified 21 files. Its git probe reports `spawnSync git EPERM` in this sandbox; the coordinator must rerun that check on the host. The play link remains at 0 seconds until Ryan publishes.
- The coordinator runs the bundle dry-run on the host with session 13 added to the rollout list; sessions 1–12 passed their dry-runs.
- Final recording comes after Ryan re-tests, publishes, and captures the playthrough. Then update `PLAY.json` and screenshots from the published build; do not record from an unverified local place.
