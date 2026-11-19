# Session 10 — travel feedback, timed events, and richer Brainrots

Session 10 builds on the sealed sessions 1–9. Keep the tested startup and server authority intact. Do not change the economy's core rules or the configured zone requirements. Ryan owns Roblox Studio re-testing, publishing, and final recording.

## Travel audit and changes

The route is wired end to end: `HUDController` creates clickable Map rows and connects each row's `Activated` signal; the row calls `Remotes.Travel:InvokeServer(zone.Name)`; `Remotes` creates `Travel` as a `RemoteFunction`; `init.server` installs `OnServerInvoke` while the required Remotes module is available; and successful travel calls `Character:PivotTo`.

The apparent lockout was the configured progression gate: a fresh profile has $500, Base Lv 1, and 0 rebirths, so only Starter City is eligible. The client button was connected, `EffectsController.Init()` is called by `ClientMain`, and its `Notify.OnClientEvent` listener already presents the server's LOCKED response. The handler's previous missing-profile branch returned silently; it now attempts `Data.Load` and sends an on-screen failure if data or the character is still unavailable. Gate refusals name cash, Base level, and rebirth requirements. Every Map row shows READY or LOCKED plus all three requirements before clicking.

Static position review found that Volcano's configured arrival was on the lava feature and Sky Islands had no landing surface at the configured point. Volcano now lands on nearby ground; the map builder adds solid arrival platforms at all zone anchors, including the Sky Islands height. The Starter, Italian Village, Neon City, Luxury District, and Secret Dimension anchors have ground/platform support. Home uses the claimed plot position. Play still loads the profile and character before its spawn PivotTo.

The zone requirement numbers remain unchanged: Starter City $0 / Lv 1 / Reb 0; Italian Village $2,500 / Lv 2 / Reb 0; Neon City $10,000 / Lv 3 / Reb 0; Luxury District $50,000 / Lv 4 / Reb 1; Volcano $100,000 / Lv 5 / Reb 1; Sky Islands $250,000 / Lv 6 / Reb 2; Secret Dimension $500,000 / Lv 6 / Reb 3.

## World events

`EventService` is the single event scheduler. It rotates Golden Hour, Brainrot Rain, and Meme Rush. Each begins after a 180-second rest and lasts 75 seconds (a 255-second start-to-start cycle). Golden Hour and Meme Rush apply a server-side 2× multiplier to passive income and collected income. Brainrot Rain applies a server-side 25% discount to physical marketplace purchases. Effects stop when the event ends.

The server broadcasts the event name, effect description, and `GetServerTimeNow()` end timestamp through `WorldEvent`. The client shows a banner with a live seconds-left countdown and removes it when the server ends the event. The client only displays event state; all effect and discount checks run on the server.

## Brainrot designs

`BrainrotService.Create` remains deterministic from the catalogue ID. Models now have larger expressive faces with happy, angry, sleepy, or starry-eye variants; pupils, highlights, cheeks, two-tone bellies, limbs, tails, body stripes/spots/emblems/scarves, and layered character wardrobes/props such as berets, vests, backpacks, chef hats, capes, badges, and existing rarity accessories. All additions are anchored parts that move with the existing whole-model bob and spin. The design remains part-built with no external image assets.

## Preserved systems and verification

Startup flow, Play initialization, economy rules, zone gate numbers, and district layout are preserved; arrival platforms are additive. Existing text-size caps, chunked map parts, market stalls, placement, buy sounds, and whole-model idle animation remain in place.

Verified in session 10:

- `/home/hatch/workspace/bin/rojo build default.project.json --output game.rbxl` succeeds.
- `MAKEFUN_OUTPUT_DIR=out node main.ts` ran twice. `out/dossier.json` matched byte-for-byte across consecutive runs (SHA-256 `f16ddce41627f1ad31a8f7d1fd047b70bb49c3142a41c847d69aeeb599cc0671`). `out/` contains `game.rbxl`, `PLAY.json`, `src/`, `screenshots/`, and `dossier.json`.
- Fresh level-27 kit check: `node cli/makefun.mjs check --repo /home/hatch/workspace/roblox-brainrot-01-italian-entry --worktree` verified 21 files, then the sandbox blocked its Git probe with `spawnSync git EPERM`. The coordinator must rerun the check on the host. No Roblox Studio playtest was performed here.
- The coordinator runs the bundle dry-run on the host with session 10 added; sessions 1–9 passed their dry-runs.

## Final recording plan

After Ryan re-tests the built place and publishes it, update the recording's `PLAY.json` with the published play link and capture the final screenshots. Keep those owner-captured artifacts for the final bundle dry-run. Do not fabricate a play link or screenshots in this session.
