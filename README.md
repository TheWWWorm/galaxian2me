# Galaxy on Fire 2 — J2ME remake engine

Play the **mobile (J2ME) Galaxy on Fire 2** as a modern desktop game, using your own copy of the original.

This is a separate game engine, built in Godot, in the spirit of OpenMW and fheroes2: it reads the Galaxy on Fire 2 JAR you already own, converts its models, textures, interface art, text, music and game tables on your own machine, and plays them with natively written flight, trading, combat and story systems.

> **You need your own copy of the game.** No game data ships with this engine — no models, textures, music, sound, text or interface art. Nothing is downloaded for you.

## Getting started

1. Start the engine.
2. Choose your Galaxy on Fire 2 JAR when asked, or drop it onto the window. Its file name does not matter.
3. Wait for the one-time conversion (under a minute). The converted content is kept in your user data folder, one folder per JAR, so different builds never mix.

Saves are kept per converted game in the same user folder (three slots plus an autosave taken whenever you dock).

## What is there

- The title screen with a station seen along the original's title camera path and its theme music.
- Stations: the hangar with your ship on its lift pad, the shop with the original stock and price rules, fitting weapons and equipment, the ship dealer, the galaxy map and departure, status and standing, saving and loading.
- Flight: the station and its surroundings as the original lays them out (jump gate, arrival point, asteroid fields whose ores depend on where the station is, local traffic, freighters and pirates by the system's safety), the original flight model (constant cruise, handling, booster), weapons from the item tables, other ships' behaviour, targeting and lock-on, docking, jump gates and in-system travel.
- The story: missions, dialogue and in-flight radio come from the game's own tables; scenes the original scripts in code are recreated natively.

Work in progress: many story scenes, the Space Lounge clients and freelance jobs, mining, blueprints, medals and wingmen are still being built.

## Controls

| Action | Keyboard / mouse | Gamepad |
| --- | --- | --- |
| Steer | Arrows / WASD, or the mouse (cursor offset from centre) | Left stick |
| Fire | Space, Ctrl or left mouse button | Right trigger / RB |
| Secondary weapon | E or right mouse button | LB |
| Booster | Shift | A |
| Autopilot | Q | Y |
| Next target | Tab | X |
| Auto fire | F | — |
| Rear view | C | Right stick click |
| Pause / back | Escape | Start / B |
| Next radio line | Enter | — |

Aim at a station, a star (another station of the system), the jump gate or an asteroid until it locks, then fire to fly there, jump, travel or mine.

## About the supplied game data

The retail game fetched part of its content — the station list of the later story chapters and the full ship table — from the publisher's online service after the free chapters. That service no longer exists. The engine uses that data only when your JAR itself carries it; otherwise the story stops where the free part ended and the game says so.

## For developers

Requires Godot **4.7**. Open `game/` as the project, or run the checks:

```sh
godot --headless --path game -s res://tests/import_check.gd -- /path/to/game.jar
godot --path game -s res://tests/smoke.gd -- /tmp/smoke
```

See [ARCHITECTURE.md](ARCHITECTURE.md) for how import and the engine fit together.

## License

The engine's own source is licensed under the [Apache License 2.0](LICENSE.md). It grants no rights to Galaxy on Fire 2, its JAR or anything converted from it; those belong to their respective rights holders. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
