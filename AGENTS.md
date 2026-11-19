# Session 11 re-record — landscape, enterable bases, presentation, and event fixes

Session 11 reapplies the landscape and base design work on top of the sealed sessions 1–10 baseline. The game remains built from Roblox parts, materials, and colors. Ryan owns Studio playtesting, publishing, and final screenshots.

## Landscape

`MapBuilder` adds 16 rounded rolling hills in the outer belts (x = ±1182/±1228; z = 270/470/670/870), 16 palms, 16 garden stones, and 48 wildflowers. Palms occupy x = ±940/±1060 and are filtered against both highway ramp bands. Stones are added only when their horizontal ellipse value against every new hill is greater than 1. The existing roads, districts, zone coordinates, and travel positions remain as before.

Static geometry audit checked all 7 zone arrivals, all 8 plot centers, 100 market stalls, and 28 zone stalls against the new hill ellipses: 143 points total. The lowest ellipse value was 3.23 at the Sky Islands arrival (the hill boundary is 1). All 16 stones are clear; the minimum nearest-hill value is 11.88. There are 0 palms on either ramp; the closest trunk center is 24 studs beyond the ramp edge. The nearest hill surface clears the highway ramp by more than 1.5 studs. Plot, stall, and arrival footprints also remain outside the outer hills.

## Enterable houses and base displays

`BaseService.Rebuild` now builds each house from separate walls and leaves a 9-stud front doorway aligned with an open fence gap and porch. The bright interior has a wood floor, table, bed, transparent rear windows with actual wall openings, and a PointLight. Roof wedges, a chimney, porch, trims, and a per-plot color palette distinguish the eight plots. House scale and trim detail increase with levels 1–6. Existing collect, upgrade, travel, garage, and ownership flows remain wired.

Plots have white picket fencing and glowing rarity-colored circular display pads. The existing Brainrot billboard is reused and updated with rarity, name, and income text to avoid duplicate labels. Existing gameplay display, collection, and income logic remains server-side.

## Events and pricing

`Shop.Buy` applies `GetDiscount()` to non-zone market purchases before calling `Coin.TrySpend`. For example, a $25,000 market Brainrot costs `floor(25000 × .75 + .5) = $18,750` during Brainrot Rain, a 25% reduction. Zone stall multipliers remain unchanged. Market prompts and character price labels refresh when events start and end. Meme Rush now applies 3× income server-side and its event description says “3× passive income burst”; Golden Hour remains 2×. The client event banner is larger and includes a visible countdown progress bar.

## Preserved systems and verification

Startup flow, Play initialization, districts, travel behavior, economy rules, and zone gate amounts are unchanged. The session-6 `script:WaitForChild("Services")` path remains in place. No Studio playtest was run in this environment.

- `/home/hatch/workspace/bin/rojo build default.project.json --output game.rbxl` succeeded.
- `MAKEFUN_OUTPUT_DIR=out node main.ts` ran twice. `out/dossier.json` was byte-identical on both runs (SHA-256 `e8b8ee9d1cb2930fd51f1c10edca1c5d1b446673afeef0eb7abb842ce3d590fd`). `out/` contains `game.rbxl`, `PLAY.json`, `src/`, `screenshots/`, and `dossier.json`.
- Fresh level-27 kit check verified 21 files, then its Git probe failed with sandbox `spawnSync git EPERM`. The coordinator reruns this check on the host. The play link remains Ryan's publishing step.
- The coordinator runs the bundle dry-run on the host with session 11 added; sessions 1–10 passed their dry-runs.

## Final recording plan

After Ryan re-tests and publishes the place, update `PLAY.json` with the published link and capture the final screenshots. Keep those owner-captured artifacts for the coordinator's final bundle dry-run.
