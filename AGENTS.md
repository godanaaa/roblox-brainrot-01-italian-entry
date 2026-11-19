# Session 14 rollout — world and game-feel quality pass

## What changed

- `src/server/Services/MapBuilder.luau:75-93,95-101` adds original, Part-built landmarks around existing zone anchors: Starter City clock tower, Italian Village bell arch, Neon City crown skyline, Luxury District fountain, a volcanic summit and glowing lava crown, Sky Islands cloud cluster, and Secret Dimension rift. The existing volcano rim/lava lake and forge remain; existing floating islands remain. Existing district positions, arrival platforms, travel pads, and stall anchors were not moved.
- `src/server/Services/BrainrotService.luau:106-132` gives each catalogue design one of eight additional readable props (pizza, espresso, flag, music notes, pocket book, lantern, orbiting orb, or daisy), layered over its existing face, silhouette, rarity trim, accessory, and wardrobe. The catalogue and rarity colors were not edited.
- `src/server/Services/BaseService.luau:86-88,92-105` gives collect and upgrade interactions immediate visible results, expands display labels, and adds a rarity-colored plaque naming each Brainrot and its income above glowing display pads. Existing house palette, plot layout, doorway, porch, and fence remain in place.
- `src/server/init.server.luau:61-85` updates player income state twice as often while income events are active and carries fractional payouts, retaining configured income multipliers. Auto-collect still triggers on its five-second timer.
- `src/server/Services/ShopService.luau:42-51` puts the discounted amount and `SALE` / `% OFF` directly on the physical marketplace listing during Brainrot Rain.
- `src/client/MenuController.luau:6` updates the title screen marker to **BUILD 14 • 19 NOV 2026**.

## Preserved systems and values

Session 13’s 25-second first event delay and visible failed-purchase reasons remain in `src/server/Services/EventService.luau:14` and `src/server/Services/ShopService.luau:72-91`. Zone requirements, catalogue prices/incomes, stall multipliers, quest rewards, gem costs, travel destinations, Play startup flow, and base placement were not edited. No external assets or sounds were added. Money and purchases remain server-authoritative.

## Verification

- `/home/hatch/workspace/bin/rojo build default.project.json --output game.rbxl` completed successfully after the final edits.
- `MAKEFUN_OUTPUT_DIR=out node main.ts` ran twice. Both `out/dossier.json` files had SHA-256 `3df65e7cdfcf3207eb0170a22b3386fa0d1cb19f5beeea1e6c720d70b3f3a13e`. `out/` contains `game.rbxl`, `PLAY.json`, `src/`, `screenshots/`, and `dossier.json`.
- Fresh level-27 kit check verified 21 files. It exits 1 on `makefun check: git -C: spawnSync git EPERM`; this is the sandbox git probe, which the coordinator must rerun on the host. No other failed row was printed. `PLAY.json` remains the owner’s unpublished recording placeholder.
- Static review confirms BUILD 14 marker, seven recognizable zone landmarks, distinct prop variation, readable rarity/name/income base displays, event-timed income updates and visible Brainrot Rain discounts. `src/shared/Config.luau` and the economy/gate values are unchanged. Startup, Play, travel, and zone gate handlers were not edited.
- The owner should verify the rebuilt place in Studio before publishing. The coordinator runs the bundle dry-run on the host with session 14 added; sessions 1–13 passed their dry-runs.

## Recording plan

After Ryan re-tests and publishes this build, capture the final playthrough and screenshots from the published place, then update `PLAY.json` and `screenshots/`. At a glance, confirm the title marker; the clock tower, arch, neon skyline, fountain, volcano, cloud islands, and rift; Brainrots’ unique props; rarity-colored base pads with rarity/name/income labels; event banner and faster income updates; and the visible sale price during Brainrot Rain. Do not record from an unverified local place.
