# Session 9 — restore purchase audio pitch and market lock prompts

Session 9 restored two session-8 regressions in `src/server/Services/ShopService.luau`:

- Successful purchases play the existing built-in `rbxasset://sounds/electronicpingshort.wav` at rarity-specific speeds (COMMON 1, UNCOMMON 1.08, RARE 1.16, EPIC 1.24, LEGENDARY 1.34, MYTHIC 1.45, SECRET 1.58, DIVINE 1.72). LEGENDARY and higher also play the same asset at ×1.22 speed, Volume .55, after 0.12 seconds. Both sound paths are protected by `pcall` and cleaned up with Debris after 4 seconds. Audio is triggered only after spending succeeds and the Brainrot is added.
- SECRET and DIVINE market stalls show `VOLCANO LOCK` or `SECRET DIMENSION LOCK` and the configured Base Level and Rebirth requirements. Zone stalls retain their zone multiplier and buy prompt.

## Verification

- `/home/hatch/workspace/bin/rojo build default.project.json --output game.rbxl` succeeded after the final code edit.
- `MAKEFUN_OUTPUT_DIR=out node main.ts` succeeded twice. `out/dossier.json` had matching SHA-256 `6bae877c778b70efe34d19934db08c2edf2416558ceb92c0fa7448be5c6ffa61`; `out/` contains `game.rbxl`, `PLAY.json`, `src/`, `screenshots/`, and `dossier.json`.
- The fresh level-27 kit check verified 21 files and reported `spawnSync git EPERM` at its git probe. The coordinator should rerun this check where git access is available; the play link remains for the owner's publishing step.
- No Studio playtest or publish was performed here.

Only the purchase sound and market lock prompt logic changed. Startup, Play data, map, chibi models, zone stalls, and zone price tiers were left untouched.

## Final recording plan

After Ryan re-tests and publishes the build, capture the final gameplay screenshots and update `PLAY.json` with the published play link. The coordinator runs the bundle dry-run with this session's rollout added to the list; sessions 1–8 already passed their dry-runs.
