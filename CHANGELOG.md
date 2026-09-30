# Changelog

## 0.1.4

- Title screen: the bottom-left line shows the engine version before the supplied game's name and version. With touch controls active (phones, tablets, touch screens, or the Touch controls option set to On) the main menu uses 28 px text, 66 px rows and a 520 px wide panel.
- Model textures are sampled with anisotropic filtering (16x, 4x on mobile). With smooth textures off, the atlas is now mipmapped as well (nearest within a level), so distant surfaces no longer shimmer; up close the texels are unchanged.
- New option: Sharp stars (Graphics, on by default). The skybox's 512 star quads are drawn as points at the screen's resolution (a core and a halo in the star picture's mean colour, sized by the window height) instead of the 13-texel star picture enlarged. Off shows the skybox as before. A skybox that is not made of small quads is always drawn as is.
- Enhanced lighting: station hulls have a rim term (0.7, tint 0.3), so a station with the sun behind it shows lit edges instead of a flat silhouette.

## 0.1.3

- Recovered tables (weapon bolt models, gun mount offsets, camera distances, station collision boxes, hangar and lounge layouts, backdrop spots, medal thresholds, title scene keys) were looked up by the class and field names of one build's obfuscation. Builds obfuscated differently (for example 1.0.4) got none of them: shots were invisible, the chase camera used a default distance, and the hangar and lounge were empty. Each table is now found by its type and length, and where needed by the class it shares with another table, the sign of its values or its size relative to its sibling (`Library.TABLES`). A table that cannot be identified uniquely is left missing. Existing content caches work without a new import.
- Opening fight: the throttle (W/S) works. The opening's input filter was written before the throttle existed and dropped it.

## 0.1.2

- Enhanced lighting uses Godot's lights instead of a lighting approximation in the model shader: a directional light from the system's sun (from the station's own sky layout) with 4-split shadows, ambient light tinted by the system's sky colour, an omni light at each ship's engine flames (brightness follows the throttle and booster), and up to four omni lights at the brightest explosions and bomb blasts. The station hangar, lounge, title scene and ship/station previews have a ceiling or sun key light.
- Material hints are derived at run time from the supplied texture atlas (`surface_map.gd`): roughness, relief from texel brightness, and an emission mask for small bright islands on a darker surround (window rows, lamps, indicator lights). Large or long bright areas are excluded. The atlas itself is unchanged.
- New option: Shadows (with enhanced lighting).
- The sun's light takes 18% of the star sprite's mean colour; a second, unshadowed directional light from the station's planet adds a soft fill in half the planet picture's mean colour (energy 0.05–0.18). None in Void space.
- Engine lights take the colour of the ship's own flame model; weapon bolts nearest the camera (up to six) carry a light in their model's colour, brighter for the first 600 units from the muzzle and at the point of impact. The open wormhole and the tractor beam light what is near them.
- Asteroids use a matte, non-emissive variant of the material; station plating has less specular and a higher minimum roughness. The hangar and lounge key light is dimmer (0.48, ambient 0.24–0.3) so the pad's additive overlay no longer clips.
- With enhanced lighting off, the model shader writes the original's per-polygon lighting as emission with no albedo, so the classic look is unchanged while the lights are hidden.
- Removed the `gof_flash_*` shader globals.
- Metalness is derived from the atlas as well (surface map alpha: low saturation and mid-to-high brightness read as metal, 0.08–0.9). Ships use 60% of it and station plating 30%, so hulls keep part of their paint in dim scenes; ships also get a rim sheen on metal. The original's sphere-mapped highlight is kept at full strength with enhanced lighting (it is most of the hangar walls' brightness). Metal reflects a procedural sky (dark top, bright horizon band, dark floor) set as the environment's reflection source; the background is still the clear colour.
- Lamp lights: `Library.light_points` finds the glowing places of a model (additive faces and faces over the lamp mask), weighted by area, strength and saturation. Stations and motherships get up to 10 omni lights, gates 4, the hangar and lounge 8; lights closer than 60% of their reach merge.
- Omni lights use attenuation 0 (range falloff only). With the default attenuation of 1, the falloff at station scale left lamp and engine light with no visible effect.
- New options: Metal reflections (on/off) and Light sources (Off, Few, Many). At Few: the player's engine, the first 2–4 lamps of each structure, two explosions and two weapon bolts. The Quality preset turns on shadows and reflections and sets light sources to Many.
- Added the `gof_metal` shader global.
- Hangar and lounge: key light from a low slant (energy 0.5, shadow opacity 0.6) with an unshadowed fill from the other side (0.35) and ambient 0.2, instead of a key from overhead. Walls and the ship were darker than the original; the floor was lighter and its additive orange overlay less saturated. The reflection sky is dimmer with a warm floor colour.
- New option: Glare (Quality preset). Two canvas passes between the 3D world and the interface (layers 1 and 2): the first stores how far each pixel's brightest channel is past 0.7 (squared) in alpha; the second adds that mask, taken from five mip levels of the screen texture and coloured by the averaged picture, on top of the picture. Environment glow is not used, since it lifts the background clear colour in the Compatibility renderer.

## 0.1.1

- Web: the JAR conversion runs in slices of about 40 ms on the main thread and draws a frame between them, so the progress bar advances and the browser no longer reports the page as unresponsive.
- The import screen, README and the incompatible-build error state that the Sony Ericsson (Mascot Capsule 3D) version of the JAR is required.
- Space Lounge: the named agents' records (`data/txt/agents.bin`) were read with the secret-system and blueprint fields swapped. The twelve blueprint sellers now unlock the blueprint (previously a cargo item was put in the hold). The four coordinate sellers now reveal their hidden system (previously they created an invalid blueprint entry). The offers name the right blueprint or system, and the purchase question uses texts 503/504.
- Saves made with 0.1.0 are repaired on load: a blueprint or coordinates already paid for is granted, and the invalid blueprint entry is removed. Such saves could previously fail validation. The cargo item received in error is kept.
- Map: after coordinates are bought, the map opens on the galaxy chart and the new system's star grows over 4 s. Its gate links and details appear afterwards, and only Back works during the animation (StarMap discovery scene).
- Station: at campaign step 6, and at step 7 while no gun, shield or armour plate is fitted, Depart shows the original's hint instead of launching (text 258, or 259 when a primary weapon is in the hold).
- Freelance jobs: the client's line is shown when the job's scene starts in flight (texts 201–205, 194 for a challenge, 200 for the junk job). The lounge reply to an accepted job is texts 484–486 followed by 487–489, or 490 for a challenge (was 493).
- Space Lounge: the diplomat is labelled "Diplomat" (text 514).

## 0.1.0

First public build. Windows x86-64, Linux x86-64, macOS (universal, unsigned) and Android (ARM64, x86-64) packages. Every version requires a user-supplied Galaxy on Fire 2 J2ME JAR; acceptance is structural (manifest and expected data files), not by file name or checksum.

Changes since the last development snapshot:

- Weapons: the first step of each round is swept from the gun mount, not from the muzzle point 400/800 units ahead, so ships closer than the muzzle are hit.
- Weapons: hits spawn the original gun sparks (10 additive sprites from the space atlas, region 33,225–63,255, growing to 500 units over ~0.7 s, then fading). The previous single 0.3 s flash is removed.
- Weapons: sparks are placed where the round's line passes the target, not at the edge of the ship's hit box. A round that registers early keeps flying visually to that point, and the sparks appear when it arrives. Damage timing is unchanged.
- Station home menu: section entries have icons (lock icon when locked), one text colour and one highlight colour. Removed the sheen band from untitled frames. Keyboard focus is shown only after keyboard or gamepad input.
- Space Lounge: clicking a guest moves the camera to them; clicking outside the dialogue closes it and returns to the room view. Accepting an offer now asks for confirmation with the original prompts (498–503) and Yes/No. The guest's line after acceptance is text 493.
- Missions section: frames wrap their content instead of filling the screen height. Mission type, client and reward share one line, and the destination card is a single row. Stacked (portrait) layouts keep the wrapped height.
- Station sections opened in landscape show a ✕ close button in place of the footer.
- Map: one click opens a system. The system view shows a card for the selected planet with **Depart → name**. Departing with a planet selected engages the autopilot towards it after launch, as the original's `setAutoPilotToProgrammedStation` does.
- Flight: one click travels to a planet, station or gate under the crosshair (no second click after lock). A station or gate held in the crosshair wins over a ship passing near it. Clicking a rock that is being shot keeps firing instead of starting to mine.
- Flight: asteroids break after enough gun hits.
- Flight: 2× time speed is always available; higher speeds still require the autopilot with no enemies near.
- Flight: R opens the autopilot list (rebindable as "Autopilot list").
- Flight: stations where the story or the current job continues carry the map's quest icon.
- Launch: the camera follows the original's launch placement (10,000 units ahead, random side offset). Previously it sat behind the ship and the sequence looked like it never ended.
- Web: custom HTML shell for full-screen play from an iPhone/iPad Home Screen launch (standalone web app metadata, fixed full-viewport canvas, no page scrolling or bounce).
