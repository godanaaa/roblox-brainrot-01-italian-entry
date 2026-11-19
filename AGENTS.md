# Italian Brainrot World — session 5 map build fix

Session 5 fixes the oversized map parts that could leave the game with an
empty workspace. In `src/server/Services/MapBuilder.luau`, the old first
part was a 2600×8×2200 ground slab, and the horizontal highway edges were
2200×2×32. The build now uses four 1300×8×1100 ground tiles (line 16),
and each highway edge is two 1100×2×32 pieces (line 20). This is the
verified structural defect and safe correction. Roblox Studio is not
available in this environment, so whether the old `Size` assignment itself
threw was not runtime-confirmed.

`Map.Build` now builds five guarded districts: ground + roads, market,
nature, zones, and city (lines 11–75). District failures emit `[IBW]` with
the traceback and source line. The final self-check at lines 76–79 counts
world descendants and checks for all four ground tiles, the plaza, an
avenue, the highway, and marketplace; it warns if anything is missing or
the world has fewer than 100 descendants.

The server startup reports Init success/failure. Base claims are idempotent
and catch/report rebuild failures (`BaseService.luau`, lines 11–19). The
duplicate Play handler was removed from `GameService.luau`; the startup
handler reports data, claim, character-load, and spawn errors. `START
PLAYING` loads the character and moves it to (0, 8, 0), above the central
plaza top at y=3 (`init.server.luau`, lines 17–25). Roblox runtime
playtesting remains to be performed in Studio.

Static part-size audit: no part size exceeds 2048 studs in any dimension.
The largest left in place is 2000 studs (canal length and highway ramp
length); the avenues and boulevard are 1900, and the canal is 2000.

Session verification: Rojo builds `game.rbxl` cleanly; `MAKEFUN_OUTPUT_DIR=out
node main.ts` was run twice and produced identical `dossier.json` hashes.
The output directory contains `game.rbxl`, `PLAY.json`, `src/`,
`screenshots/`, and `dossier.json`. The fresh level-27 kit verified 21
files, then its check stopped at `git -C` with sandbox `EPERM`; the host
coordinator must rerun it. No Studio playtest or screenshot capture was
possible here. The coordinator runs the bundle dry-run with session 5
added; sessions 1–4 already passed.

## Final recording plan

After the owner opens the place in Studio, checks Output for the district
build and `WORLD SELF-CHECK PASSED` messages, confirms the START PLAYING
spawn is on the plaza, publishes, and captures the final screenshots, the
owner records the final play link in `PLAY.json` and refreshes the approved
screenshots. Then the coordinator reruns the host-side kit check and bundle
dry-run with this session included.
