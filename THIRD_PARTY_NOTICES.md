# Third-party notices

## Mascot Capsule model and animation decoder

`game/src/import/micro3d.gd` is a GDScript port of the Micro3D `Loader` and `Action` readers from nikita36078/J2ME-Loader (copyright 2020 Yury Kharchenko), by way of the Abyssal engine's Python port. Those files are licensed under the Apache License 2.0; the retained header and the [Apache-2.0 license](licenses/Apache-2.0.txt) apply to the port and its modifications. Modifications: GDScript data structures, bounded parsing and error reporting instead of exceptions.

## MIDI renderer

`game/src/import/midi_synth.gd` is ported from the Abyssal engine's original procedural synthesizer (Apache-2.0). It contains no instrument samples; the music it renders is the player's own MIDI data.

## Godot Engine

Exported builds embed the Godot Engine (MIT license) and its third-party components; their notices are distributed with each export.

## Original game content

Galaxy on Fire 2 and the supplied JAR, its code, text, models, textures, animation and audio are not licensed by this project. They remain the property of their respective rights holders. No game content is included in this repository.
