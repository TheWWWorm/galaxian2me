# Third-party notices

## Mascot Capsule model and animation decoder

`game/src/import/micro3d.gd` is a GDScript port of the Micro3D `Loader` and `Action` readers from nikita36078/J2ME-Loader (copyright 2020 Yury Kharchenko), by way of the Abyssal engine's Python port. Those files are licensed under the Apache License 2.0; the retained header and the [Apache-2.0 license](licenses/Apache-2.0.txt) apply to the port and its modifications. Modifications: GDScript data structures, bounded parsing and error reporting instead of exceptions.

## MIDI renderer

`game/src/import/midi_synth.gd` is ported from the Abyssal engine's original procedural synthesizer (Apache-2.0). It contains no instrument samples; the music it renders is the player's own MIDI data.

## Interface fonts for Chinese, Japanese and Korean

`game/src/locale/noto_sans_sc.otf`, `noto_sans_jp.otf` and `noto_sans_kr.otf` are subsets of **Noto Sans CJK** (Regular, version 2.004, SC, JP and KR faces), copyright 2014-2021 Adobe, with Reserved Font Name 'Source', licensed under the [SIL Open Font License 1.1](licenses/OFL-1.1.txt). Each subset holds only the characters the matching engine text catalog uses; `tools/engine_text.py fonts` writes them from the unmodified upstream collection. Source: https://github.com/notofonts/noto-cjk . Keep the license with every distribution that includes these files.

## Godot Engine

Exported builds embed the Godot Engine (MIT license) and its third-party components; their notices are distributed with each export.

## Original game content

Galaxy on Fire 2 and the supplied JAR, its code, text, models, textures, animation and audio are not licensed by this project. They remain the property of their respective rights holders. No game content is included in this repository.
