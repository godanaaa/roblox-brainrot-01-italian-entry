# Session 12 — clear base yards and highway ramps

Session 12 made two focused placement fixes in `src/server/Services/MapBuilder.luau`.

## Map fixes

- The forest loop now skips trees whose grid positions fall within any of the eight base yards (plot x ±70, z 840–960). Ten trees were removed: `(-770,880)`, `(-700,880)`, `(-630,880)`, `(-560,880)`, `(-490,880)`, and the same five positions at z=940. The other 70 forest trees remain on their original grid.
- The four wildflowers at `(-1102,330)`, `(-1102,475)`, `(-1102,620)`, and `(-1102,765)` were shifted to x=−1040. All 48 flowers remain present.
- Runtime placement diagnostics report skipped yard trees and shifted ramp flowers.

## Verification

- Static geometry audit: plots 1–8 each have 0 trees inside the yard and 0 in the doorway approach. No remaining wildflower is inside either highway ramp band (x=±1084..±1116, z=−1000..1000).
- `/home/hatch/workspace/bin/rojo build default.project.json --output game.rbxl` succeeded.
- `MAKEFUN_OUTPUT_DIR=out node main.ts` ran twice; `out/dossier.json` was byte-identical. `out/` contains `game.rbxl`, `PLAY.json`, `src/`, `screenshots/`, and `dossier.json`.
- The fresh level-27 kit check verified 21 files, then its Git probe stopped with `spawnSync git EPERM` in this sandbox. The coordinator reruns the check on the host; the play link remains pending Ryan’s publish step.
- Forest outside the ten yard points, hills, palms, stones, wildflowers outside the four shifted positions, houses, startup, Play, map districts, travel, economy, and zone gate numbers were otherwise untouched.
- The coordinator runs the bundle dry-run on the host with session 12 added; sessions 1–11 already passed.

## Final recording plan

After Ryan re-tests and publishes the place, update `PLAY.json` with the published link and capture the final screenshots. Keep those owner-captured artifacts for the coordinator’s final bundle dry-run.
