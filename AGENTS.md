# AGENTS.md — Italian Brainrot World, session 6

## Session 6 fixes

The owner’s Studio Output showed `Services is not a valid member of ServerScriptService` at `Server:12`. Rojo maps `src/server` to the `Server` Script, with `Services` beneath that Script. Updated `src/server/init.server.luau:12` to `script:WaitForChild("Services")`, which resolves the actual child.

The world self-check in `src/server/Services/MapBuilder.luau:78–79` previously searched for `BrainrotMarketplace` beneath `ItalianBrainrotWorld`, although MapBuilder parents the marketplace directly to Workspace. The check now looks up the market in `workspace` and retains the other required-object checks beneath the world model.

Remote references in the server bootstrap after Play installation are guarded by `if Remotes then` at line 54. The client controllers now wait for the server-created `ReplicatedStorage.Remotes` folder before accessing it: `InteractionController`, `EffectsController`, and `HUDController`.

## Path audit

Audited all `script.Parent`, `script:`, `GetService`, `FindFirstChild`, and `WaitForChild` uses in `src/**/*.luau` against `default.project.json` and the created instance tree.

- `init.server.luau`: `script:WaitForChild("Services")` matches the `Services` child Rojo places beneath the `Server` Script. Its module lookups (`DataService`, `BaseService`, `GameService`, `MapBuilder`, `ShopService`, `CoinService`, `QuestService`, `RebirthService`, `EventService`, `LeaderboardService`, `VehicleService`, and `PremiumService`) are children of that folder.
- Server service `script.Parent.*` module references resolve to sibling ModuleScripts in `src/server/Services` (`DataService`, `BaseService`, `BrainrotService`, and `CoinService` as used). Shared `Config`, `Util`, and `Remotes` resolve beneath `ReplicatedStorage.Modules` from the project mapping.
- `ClientMain.client.luau` uses `script.Parent[name]` for sibling client controllers in the `Client` folder. `PlayerGui` waits target the local player’s child. Client remote-folder references now wait for the server-created child of `ReplicatedStorage`.
- `src/shared/Remotes.luau` creates or reuses `ReplicatedStorage.Remotes`, then creates/reuses the named remote children.
- World lookups were checked against `MapBuilder`: the world model is in Workspace; `BrainrotMarketplace` is a Workspace sibling of that model; `PremiumShop/Facade` and `Dealership/Facade` are under the world model. The market floor is under the marketplace. Base garage and vehicle seat lookups target children created by their respective builders. GUI and leaderstats lookups target children created by those scripts.
- All `GetService` targets checked (`Players`, `ReplicatedStorage`, `ContextActionService`, `DataStoreService`, `RunService`, and `Debris`) are Roblox services.

No other parent-versus-self path error was found. The `Play` handler is installed at line 17 before loading the other services and before `Map.Build` at line 39. The tail remote handlers and the state broadcast loop are inside the `Remotes` guard at lines 54–63.

## Verification completed

- Rojo build: `/home/hatch/workspace/bin/rojo build default.project.json --output game.rbxl` succeeded.
- Ran `MAKEFUN_OUTPUT_DIR=out node main.ts` twice. `out/dossier.json` had the same SHA-256 both times: `8998cb8467632dd9f9f7823c035df144bc344bddd80092ac2737933d30036b34`. `out/` contains `game.rbxl`, `PLAY.json`, `src/`, `screenshots/`, and `dossier.json`.
- Fresh level-27 kit check verified 21 files. Its only reported issue was the sandbox git probe (`spawnSync git EPERM`); the coordinator must rerun that check where git works. `PLAY.json` remains for the owner’s publish/recording step.
- Static scan of literal `Vector3.new` dimensions found none above 2048. The four 1300×8×1100 ground tiles, split highway, guarded districts, and earlier text-size limits remain in place.
- The coordinator runs the bundle dry-run on the host with session 6 added; sessions 1–5 already passed.

## Final recording plan

Ryan should first re-test in Studio and confirm the Server script reaches the `[IBW] Map district` / `WORLD SELF-CHECK PASSED` output without the line-12 error. Ryan then publishes and captures the final screenshots. The final recording session should update `PLAY.json` and screenshots only after that owner-side re-test and capture. Do not commit or push from this sandbox; the coordinator handles the commit.
