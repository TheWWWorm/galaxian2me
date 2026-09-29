# Changelog

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
