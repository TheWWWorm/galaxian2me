# Galaxy on Fire 2 — J2ME remake engine

Play the **mobile (J2ME) Galaxy on Fire 2** as a modern desktop game, using your own copy of the original.

This is a separate game engine, built in Godot, in the spirit of OpenMW and fheroes2: it reads the Galaxy on Fire 2 JAR you already own, converts its models, textures, interface art, text, music and game tables on your own machine, and plays them with natively written flight, trading, combat and story systems.

> **You need your own copy of the game.** No game data ships with this engine — no models, textures, music, sound, text or interface art. Nothing is downloaded for you.

## Getting started

1. Start the engine.
2. Choose your Galaxy on Fire 2 JAR when asked, or drop it onto the window. Its file name does not matter.
3. Wait for the one-time conversion (under a minute). The converted content is kept in your user data folder, one folder per JAR, so different builds never mix.

Saves are kept per converted game in the same user folder. Each completed docking creates an **Autosave**, after the station arrival and campaign rewards have settled. Both load menus offer this checkpoint alongside three manual slots; use the station's Game Options section to make a manual save. Starting a new game, trading or loading a slot does not overwrite the docking checkpoint. When your ship is lost, **Game Over** offers to continue from the autosave's station (or to start the opening again when there is none), or to go back to the menu.

Docking repairs your ship's hull, armour and shields at no charge before the checkpoint is written.

To travel to another system, fly to the jump gate: pick a linked system on the station **Map**, depart and fly into the gate. Within a system, lock a planet or star and let the autopilot take you there.

## What is there

- **Title screen**: the station of your latest save (a random one before your first game) seen along the original's title camera path, with its theme music and the original's menu: Start new game, Load game, Options, Help and Exit (and Resume over a game in progress).
- **Stations**: the hangar with your ship on its lift pad, laid out as the original's: the station's name and tech level at the top left, the six sections in a list at the bottom left (locked ones marked), the credits at the bottom right and **Depart** on the footer bar. The shop uses the original stock and price rules and shows each item in the original's coloured frame for its kind (primary and secondary weapons, turrets, equipment, goods); you can fit weapons and equipment, buy ships from the dealer, plan routes on the galaxy map, check your status and standing, and save and load.
- **Flight**: the station and its surroundings as the original lays them out: jump gate, arrival point, asteroid fields whose ores depend on where the station is, local traffic, and freighters and pirates by the system's safety. The original flight model (constant cruise, handling, booster), weapons from the item tables, targeting and lock-on, docking, jump gates and in-system travel are all there.
- **Story**: missions, dialogue and in-flight radio come from the game's own tables. Scenes the original scripts in code are recreated natively. The campaign plays through to its ending and on into free play.

The engine is still in development. The campaign, free play and every freelance job kind can be played, but not every mission variant, production recipe or wingman situation has been tested, and a JAR without the later chapters' data (see below) ends where the free part of the game did.

### Space Lounge jobs

- **Wanted**: the named pirate waits at its encounter point until you approach. Only destroying that ship counts, not disabling it and not destroying another pirate. You are paid once, when its destruction finishes.
- **Defense**: support the local squad at the destination. Attackers gather near the station; defenders are spread out on one side. The attacking faction depends on the local system. Defenders stay allies even if you hit them by accident. The job pays once every attacker is destroyed, and kills by your allies count.
- **Passenger**: needs enough fitted cabin places before you accept. Cabins in the hold do not count, and passengers take no cargo space. While passengers are aboard, their cabins cannot be removed, sold or replaced, and you cannot change ships. Delivering them to the requested station pays once; cancelling sets them down without pay.
- **Purchase**: a buyer's order you can accept before owning the goods. Bring the full quantity to the named station. Exactly that amount is taken, any surplus stays in your hold, and the reward is paid once. If you already have the goods at the buyer's station, the order completes on the spot.
- **Recovery and hostage recovery**: find the ship carrying the entrusted container (a scanner with **Show cargo** reveals it), disable it with EMP weapons and pull the container in with a tractor beam. Then return it to the station where you took the job. Returned cargo cannot be sold; cancelling removes only that container.
- **Cleanup**: the debris is marked as enemy targets and the remaining time shows in the HUD. Destroying debris does not count as ship kills. Any scrap it drops must be collected in space. The client pays once when the field is clear.

### Tractor beams, scanners and EMP

A fitted scanner with **Show cargo** shows the locked ship's cargo in the flight HUD; the basic Quickscan cannot. EMP-disabled ships drift without propulsion until their EMP energy recovers. To take cargo from a disabled ship, fit a tractor beam and keep the ship under the crosshair and within reach while the beam charges. The original's progress ring appears, then a container flies along the beam and transfers when it arrives. Once the pull has started, looking away does not stop it. A full hold loses the container.

Wreck crates left by destroyed ships are also collected only with a tractor beam, never by flying into them. An automatic beam takes a crate in the forward view at once; a manual beam takes it after it has sat under the crosshair for the charge time. The crate yields a random share of its first cargo, as in the original. Crates are bracketed in view, show as crate icons on the radar and blow up after 45 seconds. Without a beam, aiming at one tells you none is fitted.

### Wingmen

**Space Lounge → Wingmen** hires the named pilots for the quoted price. The contract gives ten minutes of active flight time, shown in the HUD; pausing or sitting in a station does not use it up. The pilots launch as allies that can be damaged, fly in formation and use their guns against enemies. The survivors keep their names, faction, portraits and remaining time through docking, saving, loading and new flight areas. A pilot who is shot down leaves the roster; survivors return with full hull on the next flight area. When time runs out, the lead pilot says goodbye. With every medal won, the lounge's wingmen become admirers who pay you to fly along.

In flight, **Actions → Wingmen** orders **Fire at will**, **Attack my target** (a locked ship that is not an ally), **Secure next waypoint**, or switches their guns between **Use EMP blaster** and **Use laser**. The EMP gun disables ships without harming them. Orders and gun choice last for the current flight area; a new area starts with ordinary guns and Fire at will.

### Standing and friendly fire

Each system belongs to a race, and its ships put up with some stray fire. A local ship fights back once you have taken a third of its hull or energy, and warns you over the radio. After two thirds, every ship of that race in the area turns on you and calls for back-up. Draining a local ship's energy also sets them all on you. Ships of other races do not turn on you when hit. A kill costs 5 standing with the victim's race. Disabling a ship or taking its cargo costs 2. A pirate kill costs 1 with the local race's rival. **Status** shows both standing bars, and at the ends either race may count you as a friend or an enemy.

### Routes, autopilot and secondary weapons

Every job and story scene that the original gives a route has one here: pirate hideouts, recovery, hostage and bounty points, intercept points, the challenge course, and the story's hideout, escort and challenge routes. The next point carries the waypoint frame and its distance, or an arrow at the screen edge when out of view. It shows on the radar, and reaching one announces "Waypoint reached" or "Last waypoint reached".

**Actions → Autopilot** is the original's autopilot list: the programmed destination, the jump gate, this station, the asteroid field and the mission waypoint, whichever exist here. The autopilot key, as in the original, switches the autopilot off when it is on. Otherwise it flies to the locked object, else the chosen destination, else the mission route, and with none of those it opens the list.

**Actions → Secondary weapons** chooses which fitted launcher the secondary button fires; the choice lasts until that launcher is empty. Without a choice, the first loaded launcher fires.

### Blueprints and the Khador Drive

**Hangar → Blueprints** shows your recipes, the materials already contributed and what is still needed. Buy materials in the shop or find them in flight, then pick an ingredient to contribute it from your hold. The first contribution makes the current station the production site. Contributing from another station asks first and costs ten credits per tonne to ship the goods there. A finished recipe makes one item, or ten for secondary weapons. It goes straight into your hold if you are at the production station; otherwise it waits there for you. A finished batch is never thrown away to fit the hold.

Fit the **Khador Drive** into an equipment slot to use it; carrying it in the hold is not enough. In flight, **Actions → Khador Drive** first asks whether to go to Void space. Answer **No** to pick a normal destination on the galaxy map; the drive skips gate links, but not undiscovered systems or mission restrictions, and costs nothing per jump. Answer **Yes** to enter the Void. There, the drive takes you back to the orbit you left. With the drive fitted, confirming a destination on the station **Map** launches and jumps at once; use **Depart** to leave without jumping.

## Flight, medals and more

**Other ships** fly as the original's pilots do: they stay upright and turn at the ship handling of the phone game, pick a new target every few seconds, break away to the side when they get close and come round for another pass, fire only when you sit in a narrow cone ahead of them, and boost now and then or after heavy damage. They steer around the station's modules and asteroids. Local traffic patrols a square around the station, ships launch from the station and jump away, freighters drift through, and raiders of the system's enemies come in waves by its safety. Destroyed locals are replaced from the station over time.

**Each flight opens** as the original's does: for seven seconds the camera holds still and watches your ship leave, with the faction emblem, station, system and its safety at the top left and one of the game's tips along the bottom. A key, click or tap skips it, and **Options → Interface → Launch sequence** turns it off. Ships and the camera move smoothly at any display rate: the view draws between the simulation's fixed steps.

**The flight display** is the original's by default: its corner panels; the booster, autopilot and auto-fire icons at the top left; the cloak, menu and hold icons at the top right; the armour and shield bars at the foot; the chosen secondary weapon with its count; and the hull in percent once it is damaged. The **Extended** display (Options → Interface → Flight display) groups the instruments on slim translucent plates without outlines: location, cargo, credits and the current objective at the top left; hull, armour, shield, booster and cloak at the top right; the weapon bank with reload gauges at the bottom left; the selected target at the bottom centre; and a radar scope at the bottom right, whose stems show whether contacts lie above or below you. The scope is this engine's addition (the original marks ships only on screen and at its edges) and can be turned off under Options → Interface. Stations, gates and the target carry name and range labels, and arrows at the screen edge point to the target, the station and nearby threats out of view. The crosshair sits where the original puts it, on the guns' line of fire ahead of the ship, a little below the screen centre in the chase view. Arcs around it show where hits come from. An asteroid under the crosshair is scanned there, as in the original: the scan ring fills once it has been held for half a second, and once it is locked the full ring blinks. The original HUD then names the locked object at the bottom right: an asteroid's ore icon, class and ore name, a ship's name and hull, or a station's name. With control hints on, a line under the crosshair says what the fire button will do to a locked station, gate, wormhole or asteroid (dock, fly in, mine), or, for a station, gate or wormhole, that it still needs holding in the crosshair to lock. Ships within the original's range carry its two small bars beside them: hull in their standing's colour and EMP charge in blue. Every ship's engines burn with the original's flames, which lengthen while the booster runs and go out while the drill is in a rock and wherever a story scene puts them out. Fighters also draw the original's engine trails: blue-white behind most ships, white through yellow to red behind pirates and Voids. A message already on screen is not repeated; it simply stays up longer. Held upright, a phone gets an upright canvas: the flight HUD stacks its top panels and puts the radio box under them, the camera widens, and in a station the section rail gives way to a **Back** button while each page stacks its columns. On touch screens the radar moves to the top right and the vitals and weapons stack down the top left, clear of the stick and buttons. On phones, the panels, menus and touch controls keep clear of the camera cutout and rounded corners on both sides, while the 3D view still fills the screen.

**Medals** follow the original's list and thresholds. Your record is checked on the way into a station and new or improved medals are announced once docked; **Status** lists all of them. Winning every medal and every gold medal unlocks the original's rewards, and Keith wears the original's black or golden glasses on the Status page. That page follows the original's: the pilot's face, credit, level and time played, the reputation bars, then the statistics (ship, fire power, defense, missions, kills, salvage, stations, jumpgates, goods produced, ore and cores).

**Pilot level** starts at 1 and rises as in the original: while docked, experience from kills, half the wingmen ever hired, every fifty tons of ore, cores and twice the freelance missions done is compared with the mark of the last level, and passing 1.3 times that mark raises the level by one. The level strengthens enemies and raises mission rewards and hired pilots' fees, capped where the original caps it.

**Space Lounge** is the station's bar in 3D, as in the original: the guests stand about the room, pointing at someone names them and their trade over their head, and clicking them (or Chat) starts the conversation. Conversations offer the original's answers: accept, decline, have the offer repeated, and for jobs elsewhere ask where it is and how difficult it will be; traders let you look at the goods first.

The **cloaking device** is used from **Actions** or with V: other ships lose track of you until its duration ends, then it recharges. On ships with a **turret**, C switches to the turret view: steering swings the turret while the ship flies on, and fire uses the turret. The ship otherwise levels its wings whenever you stop steering, as in the original. Ships drop crates holding one or two kinds of goods from the original's loot tables.

**Looking around**: hold Alt and move the mouse, or use the gamepad's right stick, to swing the camera round your ship; it eases back behind the ship when you let go. The crosshair hides while the view is turned away from the line of fire.

**Time speed-up**: while the autopilot flies and no enemy is within 25 km, T (or the touch **Faster** button) runs time at 2×, 4× or 8×. It drops back to normal as soon as an enemy comes near, the autopilot disengages, a conversation opens or docking begins.

Actions that cannot be undone ask first, with the game's own questions: saving over a used slot, loading over the current game, leaving for the main menu (from flight this loses progress since the last save) and abandoning a contract. **No** is highlighted, and Esc or B answers it.

With a keyboard or controller, opening a station section moves the highlight to its first entry. Changing an amount, buying, selling or fitting keeps the highlight on the same button, and so does changing a setting in Options. In the Space Lounge, left and right move between the guests, turning to each and showing their name and trade before you talk to them.

The station **Map** zooms with the mouse wheel, a pinch, + / − or the pad triggers, and pans by dragging; a click or tap that does not move picks a system, and the arrow keys or D-pad step between systems and bring the chosen one into view. **Zoom**, Enter, the pad's A or a double click opens the chosen system as the original draws it: the sun, the planets on their orbits, the chosen station in orange with its Tec Level, and markers for stations already visited, story and job destinations and the jump gate (the **Key** beside the chart explains them). In a system, pick a station the same ways and choose it again to fly there; **Back**, Esc or a right click returns to the galaxy. Type in its search field to list matching stations. Each system is the original's star sprite in its star's colour, and dotted lines join this system to the ones its jump gate reaches, as the game's map help describes. A fading gold line traces your last six trips between systems. Dashed lines show the fewest jumps through known systems to the story's destination (yellow) and your job's (blue). **Missions** shows each destination with its owner's emblem and how many jumps away it is, and its **Map** button opens the chart on that system. The card beside the chart shows the station under the pointer or highlight, turning in a small showroom.

**Saves** keep the copy they replace as a backup. If a save is ever damaged, loading it falls back to that copy and tells you so. **Export save…** (station Game Options) writes the current game to a file, and **Import save…** (Load game, in the title or at a station) loads one, to carry a game between devices. An export holds the save only, never the game's content, and loads only where the same game was imported.

**Photo mode** (P, or Photo mode in the pause menu) freezes the flight and lets you orbit the camera around your ship: drag, the arrow keys or a stick turn it, the wheel, +/−, the triggers or the on-screen buttons zoom, **Save picture** saves the view without the bar, **Hide bar** clears the view (click or tap to bring the bar back), and P, Escape or **Back to flight** return. F12 saves a picture of whatever is on screen at any time; pictures go to the `screenshots` folder in the user data folder.

**Help** (in the title, the pause menu and the station's Game Options) opens the original's manual: its help topics, its tips and the current controls. The original's short help windows also appear the first time you meet a feature; they can be switched off or shown again in Options → Interface.

## Options

**Options** (from the title, the station's Game Options, or the pause menu in flight) has tabs for audio, display (graphics presets from Performance to Quality, fullscreen, vertical sync, frame-rate limit and counter, aspect ratio with letterboxing, 3D resolution, antialiasing, optional enhanced lighting, field of view, space dust, the original's lens flare, texture smoothing, chosen apart for ships and for stations), controls (helm response, mouse steering and sensitivity, pointer capture, whether left/right strafe or turn, inverted pitch, steering by tilting on phones and tablets with calibration and sensitivity, gamepad deadzone and vibration, touch control size, a left-handed layout and a placement editor for dragging the stick and buttons where your thumbs rest, rebindable keys), interface (the original or the extended flight display, the radar scope, HUD size and opacity, control hints, object labels, screen transitions, menu text size) and accessibility (colour-blind friendly standing colours, reduced flashing, screen shake, longer message time). Enhanced lighting keeps the original models and textures but lights them per pixel. It adds a soft highlight and rim, and explosions and bomb blasts cast their glow on nearby ships, stations and asteroids as they burn out.

On the first start with game content, the title measures your device on its own station scene. Starting from Quality, it picks the best graphics preset that holds about 60 frames a second, and **Options → Display** marks that preset **(Recommended)**. If you never changed a graphics setting, the recommendation is applied; settings you chose yourself are kept. The measurement takes a few seconds; leaving the title first cancels it, and it runs again on the next start.

The ship dealer shows the selected hull, or your own, turning in a small showroom; drag across it to turn it yourself. Each figure of an offered hull shows how far it is ahead of your current ship (green) or behind it (orange). The shop does the same for weapons and equipment, comparing each with the item fitted in its place, and, as in the original, the item's details name the lowest and highest price you have seen for it and in which system. **Hangar → Ship** heads each slot group with its filled and total slots. **Help → Phone keys** explains the phone keys the game's own texts mention ("Fire", 2/4/6/8, the softkeys) in terms of your current keys and the gamepad. Any message, tip or radio line that names such a key also carries a short dim note of what to press here: your bound key and the pad button, or the on-screen button when playing by touch. Radio and story boxes in flight grow to show a long line whole, and the readouts under them move down with them.

**Options → Game → Credits** rolls the game's own credits from your JAR, followed by this engine's notices.

## Replacing art, music and models

You can replace converted art and music with your own files without touching the conversion. Create a `mods` folder in the engine's user data folder (or next to the executable) with any of:

- `textures/space.png` — the 3D model atlas. Any size works: models address it in the original's texels, so a larger atlas is simply sharper. Keep the original's colour key for cut-out parts.
- `interface/<name>.png` — an interface image, named as in the converted content.
- `music/<track>.ogg` (or `.mp3`, `.wav`) — a music track, for example `music/gof2_theme.ogg`.
- `sounds/<name>.wav` (or `.ogg`) — a sound effect.
- `models/<name>.glb` (or `.gltf`) — a model, named as in the converted content (`ship_02_body_01`, `stat_hangar0`, `box` and so on). Ships and stations are assembled from these parts. The file is scaled to the original part's size and centred where it sat, and one texture serves every livery. Explosions, the wormhole and the sky are animated or sized from their own mesh, so they keep their originals.

Replacements affect only what you see and hear; the game's rules always use the original data.

**Options → Game → Mods** does the atlas, the music and the models for you. It lists the 3D model atlas, each music track and every still model, and shows whether a replacement is in use. From there you can **View** the atlas or a model (drag to turn it) or **Listen** to a track, and **Replace…** it with a file from your device. **Restore original** removes your replacement. The game checks a file by its content, not its name, and copies it into the user data folder's `mods` folder. Music changes at once; the atlas and models apply from the next scene. A model replacement must be a binary glTF (`.glb`). On desktop the page also opens the mods folder and the folder of converted originals, which you can use as a base for your own repaint.

## Controls

| Action | Keyboard / mouse | Gamepad |
| --- | --- | --- |
| Steer | Arrows / WASD, or the mouse (captured; motion turns the ship) | Left stick |
| Strafe (while the mouse steers) | Left / Right, A / D | — |
| Fire | Space, Ctrl or left mouse button | Right trigger / RB |
| Secondary weapon | E or right mouse button | LB |
| Booster | Shift | A |
| Autopilot | Q | Y |
| Next target | Tab | X |
| Auto fire | F | — |
| Rear view, or turret view on ships with a turret | C | Right stick click |
| Cloaking device | V | — |
| Look around the ship | Hold Alt and move the mouse | Right stick |
| Time speed-up during autopilot | T | — |
| Photo mode | P | — |
| Save a picture | F12 | — |
| Fullscreen | F11 | — |
| Actions / fitted jump drive | M | Back / Select |
| In-flight route map | N | — |
| Pause / back | Escape | Start / B |
| Next radio line, skip a cinematic's wait | Enter | A |

A new game opens as the original does: fifteen silent seconds as the camera turns over the asteroid field before the first line of the story, with the briefing at the five-second mark. The three pirates wait in sight with their engines off until they wake, and the fight that follows shows only the crosshair and the markers over ships, as the original's intro does. As there, only ships can be locked during it, and the autopilot, map and action menu stay closed, so the opening cannot be left for the station. During a cinematic, Enter, a mouse click, the pad's A or the touch **Skip** button moves on to the next line, or brings the next timed line forward while nobody is speaking; a hint at the foot of the screen says so. Lines and scenes that wait on events play out as they are.

In flight the window captures the mouse pointer for the whole flight, as in Deep, and moving the mouse turns the ship directly: as fast as the ship can turn, with at most a fifth of a second of motion waiting, so it follows your hand and flies straight the moment you stop. Hold Alt to look around instead. Menus, pauses, conversations and losing window focus free the pointer; **Options → Controls → Capture the pointer in flight** turns this off, and the pointer then steers by its offset from the centre. The mouse steers only after you move it; a steering key or the pad's stick takes the helm back.

While the mouse steers, the left and right keys **strafe**, as Deep's do: the ship slides sideways, leaning into it, without turning. **Options → Controls → Left / right keys** sets them to strafe only with the mouse (the default), always strafe, or always turn.

Aim at a station, a star (another station of the system), the jump gate or an asteroid until it locks, then fire to fly there, jump, travel or mine.

With a destination chosen on the Map, the object you reach it through is marked in gold: the station itself, the jump gate, or, when this station has no gate, the star of the system's gate station. Off screen it gets an arrow with its distance, and the autopilot with nothing locked flies there. While a freelance fight is under way in the area, the station will not take you in and gates and planet flights refuse with the game's "Not possible while on a mission", as in the original; deliveries, passengers and a recovered container are exempt, and the restriction ends once the mission is won or lost. Autopilot keeps its selected destination when another object crosses the reticle. Change it explicitly with Next target or disengage autopilot to resume ordinary crosshair targeting. Asteroids remain collision hazards.

The in-flight route map sets a destination without jumping immediately. Use a physical linked gate, local star travel, or the fitted drive action to make the journey. A physical gate never becomes an unrestricted drive just because the ship has one fitted.

### Touch

Set **Options → Touch controls** to **Automatic**, **On** or **Off**. Automatic enables the overlay on mobile platforms or when Godot detects a touchscreen. In flight, pressing a key, clicking or moving a real mouse, or using a gamepad puts it away and gives the HUD its desktop layout, with mouse steering, until the screen is touched again. Mouse events generated by a touch and slight stick drift do not count. On keeps the overlay whatever you press, and also lets a desktop touchscreen use the same controls. **Boost** and **Secondary** appear only while a booster or a secondary launcher is fitted. Tap **Fire** twice quickly for automatic fire; the button's rim lights up and it reads **AUTO**, and one tap stops it. While a station, gate, wormhole or asteroid is locked, **Fire** reads **Dock**, **Fly in** or **Mine** with a pulsing rim, since a tap then does that instead of firing.

The left stick steers the ship and moves the mining drill. It comes to your thumb wherever it lands on the stick's side of the screen and returns to its corner when you let go; **Stick fixed in place** keeps it in the corner. **Steer from anywhere** drops the resting stick altogether: a finger on any free part of the screen, on either side, becomes the stick where it lands (looking around by dragging is off in this mode). While the autopilot flies with no enemies near, a **Faster** button speeds up time. The right-hand buttons fire/use a locked object, launch a secondary weapon, boost, select a target, toggle autopilot or auto fire, and switch the rear view. Steering, firing and boosting can be held with separate fingers. A finger on free screen space looks around the ship while it is held (switch it off or change its sensitivity under **Options → Controls → Touch**), and **Adjust control placement…** there lets you drag the stick and every button to a new place. Tapping a control selects it, so you can make it smaller or larger, from 60% to 200%, or reset just that one. Keyboard and gamepad input remain available; mouse steering and mouse-button firing are disabled while touch controls are enabled to avoid interpreting a touch twice.

Gameplay controls hide during locked story scenes and drive cinematics; **Next radio** appears when a radio line is visible. **Actions** opens the same flight equipment menu as M, and **Pause** opens a centered pause menu. Pausing, hiding the controls, losing window focus or leaving flight releases held touch input. In menus, drag anywhere in a list to scroll it; a flick coasts on. A drag that starts on a row does not select it, and a short tap still does. A gamepad disconnecting, or a phone putting the game away, pauses it; resume explicitly from the menu. Switching to another window (to take a screenshot, say) only lets go of held keys; **Options → Controls → Pause when the window loses focus** pauses then too.

### Platforms

The native Linux runtime is exercised by the checks below. `game/export_presets.cfg` also has presets for Windows (x86-64), macOS (universal, unsigned and not notarized), Linux ARM64 and the browser (Web). They export with Godot 4.7's standard templates, for example:

```sh
godot --headless --path game --export-release "Windows" builds/gof2-remake.exe
```

These builds are not tested on their native systems. macOS may warn about or block an unsigned app.

The **Web** preset builds a single-threaded browser version. It must be served from a web host, because opening `index.html` from disk does not work. Its first screen uses the browser's own file picker for the JAR. The file is read into the browser's storage and converted there, never uploaded. Without threads, the page stops responding while it converts (under a minute). Only the boot and the JAR screen of the browser build have been checked so far.

The **Android** preset builds an arm64 APK (Android 7 or later, targeting SDK 36) with Godot's prebuilt template, no Gradle project needed. Exporting it needs a JDK and an Android SDK configured in Godot's editor settings, for example `godot --headless --path game --export-debug "Android" builds/gof2-remake.apk` for a debug-signed test build. On the phone, **Choose JAR** opens the system file picker; the chosen file is copied into the app's own storage, converted, and the copy removed. The APK has been built and inspected but not yet run on a device.

## About the supplied game data

The retail game fetched part of its content — the station list of the later story chapters and the full ship table — from the publisher's online service after the free chapters. That service no longer exists. The engine uses that data only when your JAR itself carries it; otherwise the story stops where the free part ended and the game says so.

## For developers

Requires Godot **4.7**. Open `game/` as the project, or run the checks:

```sh
godot --headless --path game -s res://tests/import_check.gd -- /path/to/game.jar
godot --headless --path game -s res://tests/touch_controls_check.gd
godot --headless --path game -s res://tests/navigation_lock_check.gd
godot --headless --path game -s res://tests/flight_transition_check.gd
godot --headless --path game -s res://tests/drive_boundary_check.gd
godot --headless --path game --fixed-fps 60 -s res://tests/touch_flight_run.gd
godot --path game --fixed-fps 60 -s res://tests/touch_flight_run.gd -- /tmp/gof2-touch-check
godot --headless --path game --fixed-fps 60 -s res://tests/smoke.gd -- /tmp/gof2-earned-check
godot --path game --fixed-fps 60 -s res://tests/smoke.gd -- /tmp/gof2-earned-window
godot --headless --path game --fixed-fps 60 -s res://tests/earned_travel_run.gd -- /path/to/earned-step6/slot0.json /tmp/gof2-travel-check
godot --path game --fixed-fps 60 -s res://tests/earned_travel_run.gd -- /path/to/earned-step6/slot0.json /tmp/gof2-travel-window
godot --path game --fixed-fps 60 -s res://tests/earned_travel_run.gd -- /path/to/earned-step13/slot0.json /tmp/gof2-convoy-window
godot --path game --fixed-fps 60 -s res://tests/earned_travel_run.gd -- /path/to/earned-step16/slot0.json /tmp/gof2-alioth-gates-window
godot --headless --path game -s res://tests/alioth_scene_check.gd
godot --headless --path game -s res://tests/campaign_inventory_check.gd
godot --headless --path game -s res://tests/passenger_contract_check.gd
godot --headless --path game --fixed-fps 60 -s res://tests/convoy_transfer_check.gd
godot --headless --path game -s res://tests/map_routes_check.gd
godot --headless --path game --fixed-fps 60 -s res://tests/save_recovery_check.gd -- /path/to/earned/slot0.json /tmp/gof2-save-check
godot --headless --path game --fixed-fps 60 -s res://tests/docking_transaction_check.gd -- /path/to/earned-step13/slot0.json /tmp/gof2-docking-fixture
```

The input-only check requires no game data. The flight check reads a previously imported JAR cache, drives real screen-touch events through native flight, mining and opening radio, and checks pause behavior and release of discarded worlds/resources. Its test host keeps settings and saves in memory, leaving the player's files untouched. Its free-flight setup is a fixture, not proof of campaign progression. Supplying an output folder writes a JSON report and, for a windowed run, screenshots.

The flight-transition check also needs no game data. It verifies that completing docking, a gate jump or local star travel retires the old physics world before further weapons, collisions, salvage or traffic updates can run. Repeated updates must not create additional transitions or count a gate twice. These are lifecycle fixtures, not earned travel checkpoints.

The drive-boundary check uses installed content and synthetic in-memory states, never player saves. It checks fitted equipment, current versus remote mission restrictions, transit locks, invalid destinations, separate drive/gate accounting, and Void return-address preservation. The earned drive and separate-process reload checks exercise the real hangar and flight interfaces from recorded product checkpoints; their pilot only returns ordinary controls. Synthetic Void checks are not proof of an earned Void round trip.

`earned_drive_branches.gd` separately continues recorded native saves through a Void round trip or a confirmed station-Map drive departure. It dispatches keyboard, pointer and screen-touch events through Godot's input system and uses ordinary pilot controls only for physical docking. Each result is checked again in a separate rendered process. This validates native input-event integration on Linux, not physical touchscreen/gamepad hardware or Android/browser packaging. The Void check returns promptly; it is not an extended Void combat or mining playthrough.

The buyer checks separate memory-only transaction and station-screen boundaries from earned gameplay. `earned_buyer_order.gd` continues a recorded native buyer checkpoint through real lounge, map and shop input events, finite purchases and physical delivery; `earned_buyer_reload.gd` checks a recorded result in a separate process. The flight pickup observer stops at the native world's terminal boundary, before station delivery changes inventory; it still rejects unexplained cargo gains or losses during active flight. These checks require their recorded local input and content, and do not establish support for every freelance mission or original-game content variant.

The wingman checks use the same separation. `wingmen_check.gd` labels its synthetic funds, death, deadline, contest and malformed-save cases as memory-only fixtures, including native expiry dialogue and combat-projectile boundaries. `earned_wingmen_run.gd` instead pays for a retained offer through real UI input, launches, physically docks, makes a fitted-drive trip and saves its surviving crew. `earned_wingmen_reload.gd` checks an exact recorded result in a separate rendered process and reconstructs its paid pilots without resetting their timer. These checks require their recorded local inputs and imported content; no fixture-produced save is an earned continuation.

`wingman_orders_check.gd` adds memory-only targeting, real projectile collisions, EMP/gun selection, independent mission-waypoint copies, same-faction command targets, pause ownership and keyboard focus boundaries. `earned_wingman_orders_run.gd` continues the actual paid-crew save through native pointer and keyboard orders and a physical return to its station. `earned_wingman_orders_reload.gd` checks that exact result in a separate rendered process. Test ledgers record the source hashes used for each run; a later collision-boundary fix is not presented as part of an earlier earned flight. These local diagnostics do not prove every mission, content variant or export platform.

`smoke.gd` runs `earned_opening_run.gd`: it starts a new game, steers and fires native weapons, completes the rescue and both mining flights, verifies both cargo handovers, buys and sells an actual starter-shop item, and exercises both save/load menus at campaign step 6. Its full-hold check includes any cores or salvage, just as the supplied goal does. It never assigns campaign progress, ship positions, cargo or enemy damage. A supplied output directory contains the report, native screenshots for a windowed run, and a new `test-saves-<run>/<content-id>/` directory with the earned autosave and manual `slot0.json`. Without an output directory saves stay in memory. Windowed checks resume focus-loss pauses through the actual Resume button; normal gameplay still requires explicit resume.

`earned_travel_run.gd` copies an earned step-6, step-13, step-14 or step-16 save into a fresh isolated host and selects its installed content by SHA. From step 6 it buys and fits starter equipment through the real shop controls, fights with native projectiles, travels through the Map and station targeting controls, sells earned cargo when available, and completes the first actual courier job. From a one-job step-13 input it completes the second courier, preserves a separate earned step-14 JSON, then plays the convoy and debrief transport to Alioth. An earned two-job step-14 input resumes that last leg directly. From step 16 it plays the Alioth battle and return, preserves `earned-alioth-return.json`, then uses the supplied gate graph and actual Map/flight controls to reach the next arrival objective. The report separates physical gate entries from local star travel and verifies docking autosave and manual reload. It does not assign campaign progress, mission results, positions, damage, cargo or random seeds. The controller avoids firing through friendly formations but can still fail combat or find no eligible route or courier within its bounded search; those failures remain in the report rather than replacing the world with a fixture.

The inventory, convoy-transfer, Alioth-scene and Map-route checks are separate synthetic unit fixtures against installed content. They verify cargo-handover boundaries, debrief acknowledgment before transport and its single autosave, Alioth ally durability and combat AI, the post-Alioth livery transition, and numeric reachability across the whole imported graph. They do not establish earned campaign progression or actual gate-flight completion. Navigation-lock tests are separate targeting fixtures with no campaign or game data. Never pass a fixture-produced save as an earned continuation input.

The save-recovery check accepts an earned post-mining `slot0.json` from either run and copies it into a separate test directory in a fresh process. It checks JSON persistence, invalid-state rejection without changing the live session, preservation of the previous checkpoint on a write failure, and defeat recovery. Malformed files and lethal player damage in this check are explicit failure fixtures, not campaign-completion evidence. The checks do not read or write player save files or change player settings. Opening and local-travel checks do not establish completion of the remaining campaign or platform exports.

The docking-transaction check requires an earned step-13 checkpoint with one completed job. It adds explicitly synthetic freight and damage only to its isolated copy, then verifies that delivery, the next story goal, free servicing and autosave settle together. Its step-14 output is a fixture, not an earned campaign checkpoint.

The engine is split into `game/src/import` (local content conversion), `content` (converted data/resources), `simulation` (session and station rules), `flight` (native world, input and HUD), and `screens`/`presentation` (Godot interface and rendering). `tests/parse_check.gd` accepts script paths after `--` and exits nonzero when a script cannot be instantiated.

## License

The engine's own source is licensed under the [Apache License 2.0](LICENSE.md). It grants no rights to Galaxy on Fire 2, its JAR or anything converted from it; those belong to their respective rights holders. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
