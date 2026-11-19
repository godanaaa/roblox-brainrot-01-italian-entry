# ITALIAN BRAINROT WORLD

A bright, open-world collecting and base-building game built entirely from Roblox Parts. Explore a connected city, visit the Brainrot Bazaar, collect animated Brainrots, earn passive cash, and grow your personal empire.

## Build

From this directory run:

```sh
/home/hatch/workspace/bin/rojo build default.project.json --output game.rbxl
```

Then run the make.fun handoff command:

```sh
mkdir -p out && MAKEFUN_OUTPUT_DIR=out node main.ts
```

The grader check is run from the kit checkout with `node cli/makefun.mjs check --repo /home/hatch/workspace/roblox-brainrot-01-italian-entry --worktree`. `PLAY.json` remains an unpublished placeholder; the owner adds the Roblox place link after publishing.

## Session 1 systems

Central city, roads and highway ring, canals and bridges, beach, lake, forests and hills, districts, physical rarity halls and purchase prompts, eight player plots, six visible base levels, server-side cash and purchase validation, collection/index data, quest claims, rebirths, timed events, leaderboard stats, and a start-first menu. Vehicle ownership, expanded zone locks, premium product integration, and later-session content remain planned expansions.
