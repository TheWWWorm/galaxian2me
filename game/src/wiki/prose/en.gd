extends RefCounted
## Reference prose in English. Each block is [story step it appears from,
## section heading or "", text, list item]. See src/wiki/prose.gd.
const PAGES := {
	"guide/basics": {"title": "Getting started", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/blueprints": {"title": "Blueprints and production", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/combat": {"title": "Combat", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/fitting": {"title": "Ships and fitting", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/flight": {"title": "Flying", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/jobs": {"title": "Freelance jobs", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/lounge": {"title": "Space Lounge", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/medals": {"title": "Medals", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/mining": {"title": "Mining", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/navigation": {"title": "Navigation", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/trading": {"title": "Trading", "subtitle": "Guide", "category": "guide", "from": 0},
	"step/0": {"title": "Bounty in the asteroid belt"},
	"step/1": {"title": "Found adrift"},
	"step/10": {"title": "Meeting the commander"},
	"step/11": {"title": "A silent station"},
	"step/12": {"title": "Report to the commander"},
	"step/13": {"title": "Waiting for the convoy"},
	"step/14": {"title": "The Terran convoy"},
	"step/15": {"title": "Under arrest"},
	"step/16": {"title": "Defending the station"},
	"step/17": {"title": "The story of the Voids"},
	"step/18": {"title": "Rendezvous with a scientist"},
	"step/19": {"title": "The kidnapping"},
	"step/2": {"title": "The first ore run"},
	"step/20": {"title": "Fitting the bombs"},
	"step/21": {"title": "Disabling the kidnappers"},
	"step/22": {"title": "The rescued scientist"},
	"step/23": {"title": "The secret research station"},
	"step/24": {"title": "Salvaging Void wreckage"},
	"step/25": {"title": "Lost in strange space"},
	"step/26": {"title": "Shaking off pursuers"},
	"step/27": {"title": "A new assignment"},
	"step/28": {"title": "Into the wormhole again"},
	"step/29": {"title": "Launching the probe"},
	"step/3": {"title": "Delivering the ore"},
	"step/30": {"title": "A call from an old friend"},
	"step/31": {"title": "A promised surprise"},
	"step/32": {"title": "The Grey scientist"},
	"step/33": {"title": "Crystals from the Void"},
	"step/34": {"title": "A plan for victory"},
	"step/35": {"title": "Meeting the Vossk commander"},
	"step/36": {"title": "A contest of pilots"},
	"step/37": {"title": "Calling headquarters"},
	"step/38": {"title": "Recapturing the convoy"},
	"step/39": {"title": "Final preparations"},
	"step/4": {"title": "A full cargo hold"},
	"step/40": {"title": "Escort to the wormhole"},
	"step/41": {"title": "Strike on the mother ship"},
	"step/42": {"title": "Escape from Void space"},
	"step/43": {"title": "A celebration"},
	"step/44": {"title": "The morning after"},
	"step/45": {"title": "Epilogue"},
	"step/5": {"title": "Fleeing to the station"},
	"step/6": {"title": "Arming the ship"},
	"step/7": {"title": "The pirate hideout"},
	"step/8": {"title": "After the battle"},
	"step/9": {"title": "Settling accounts"},
	"world/galaxy": {"title": "The galaxy", "subtitle": "Setting", "category": "world", "from": 0},
	"world/history": {"title": "History", "subtitle": "Setting", "category": "world", "from": 0},
	"world/khador": {"title": "Khador", "subtitle": "Character", "category": "characters", "from": 32},
	"world/voids": {"title": "The Voids", "subtitle": "Setting", "category": "world", "from": 0},
}
const BLOCKS := {
	"agent/0": [
		[0, "", "[[agent/0]] is a Nivelian agent in the lounge of [[station/3]] in the hidden [[system/0]] system. He sells the blueprint for the [[item/11]] laser.", false],
	],
	"agent/1": [
		[0, "", "[[agent/1]] is a Nivelian agent in the lounge of [[station/8]] in the hidden [[system/1]] system. He sells the blueprint for the [[item/15]] blaster, a weapon he describes as rare.", false],
	],
	"agent/10": [
		[0, "", "[[agent/10]] is a Terran agent living among the Vossk, in the lounge of [[station/59]] in [[system/20]]. He sells the blueprint for the [[item/96]] cloaking device.", false],
	],
	"agent/11": [
		[0, "", "[[agent/11]] is the ore trader [[character/2]], who appears in his own lounge at [[station/78]] in [[system/15]]. He sells the blueprint for [[item/90]], his own mining laser, at a price far above any other agent's. Since [[system/15]] has no gate links, reaching him later in the game takes a jump drive.", false],
		[10, "", "He greets [[character/0]] as the time traveller and has started producing the drill he once kept to himself.", false],
	],
	"agent/12": [
		[0, "", "[[agent/12]] is a Vossk agent in the lounge of [[station/18]] in [[system/3]]. He sells the coordinates of the hidden [[system/0]] system, praising its many advanced stations.", false],
	],
	"agent/13": [
		[0, "", "[[agent/13]] is a Bobolian agent in the lounge of [[station/26]] in [[system/5]]. He sells the coordinates of the hidden [[system/1]] system.", false],
	],
	"agent/14": [
		[0, "", "[[agent/14]] is a Cyborg agent in the lounge of [[station/65]] in [[system/13]]. He sells the coordinates of [[system/10]] but admits he has no idea how to get there. Without a jump drive the coordinates are of no use, since the system has no gate links.", false],
	],
	"agent/15": [
		[0, "", "[[agent/15]] is a Vossk agent in the lounge of [[station/88]] in [[system/17]]. He sells the coordinates of the hidden [[system/21]], which he calls his home. Once known, the system can be reached by gate from [[system/20]].", false],
	],
	"agent/2": [
		[0, "", "[[agent/2]] is a Midorian agent in the lounge of [[station/20]] in [[system/4]]. He sells the blueprint for the [[item/25]], the cheapest weapon blueprint on offer from an agent besides the rocket of [[agent/4]].", false],
	],
	"agent/3": [
		[0, "", "[[agent/3]] is a Terran agent in the lounge of [[station/10]] in [[system/6]]. He sells the blueprint for the [[item/27]], a fast-firing mass driver.", false],
	],
	"agent/4": [
		[0, "", "[[agent/4]] is a Terran agent in the lounge of [[station/43]] in [[system/8]]. He sells the blueprint for the [[item/33]], the cheapest blueprint any agent offers.", false],
	],
	"agent/5": [
		[0, "", "[[agent/5]] is a Vossk agent in the lounge of [[station/54]] in [[system/10]], a system only a jump drive can reach. He sells the blueprint for the [[item/37]] homing torpedo, which no shop stocks.", false],
	],
	"agent/6": [
		[0, "", "[[agent/6]] is the only Multipod in the game. He sits in the lounge of [[station/61]] in [[system/12]] and sells the blueprint for the [[item/46]] nuclear weapon.", false],
	],
	"agent/7": [
		[0, "", "[[agent/7]] is a Terran agent in the lounge of [[station/72]] in [[system/14]]. He sells the blueprint for the [[item/54]], a powerful shield.", false],
	],
	"agent/8": [
		[0, "", "[[agent/8]] is a Vossk agent in the lounge of [[station/84]] in [[system/16]]. He sells the blueprint for the [[item/59]], a Vossk armour plate that was never sold in shops. It is the most expensive blueprint any agent sells, after the drill of [[agent/11]].", false],
	],
	"agent/9": [
		[0, "", "[[agent/9]] is a Terran agent in the lounge of [[station/90]] in [[system/18]]. He sells the blueprint for the [[item/67]], a cargo compressor he recommends to every trader.", false],
	],
	"character/0": [
		[0, "", "[[character/0]] is the protagonist and the character you play. He is a [[faction/0]] fighter pilot who makes a living hunting [[faction/8|pirates]] for the bounties on their heads. He is confident, sarcastic and quick to take a fight.", false],
		[1, "Stranded", "On his way to Eden Prime, where Admiral Smith has a special mission for him, his hyperdrive is damaged in a pirate attack. The autopilot carries him, unconscious, to [[station/78]].", false],
		[2, "", "There he is rescued by the ore trader [[character/2]], who has claimed his ship as salvage and puts him to work as a miner.", false],
		[8, "", "Keith is a veteran of the Terran Space Fleet, where he served under Admiral Smith.", false],
		[9, "", "He learns that the admiral has died of old age and that the year is now 3624.", false],
		[10, "", "About 35 years have passed since his accident, apparently because of a hyperdrive fault, yet Keith has not aged at all. Stranded in the remote [[system/15]] system, he starts again with [[ship/0]], a gift from Gunant.", false],
		[16, "The Void war", "After a mistaken arrest he is reunited with his old friend [[character/1]] at [[station/98]] and fights his first battle against the [[faction/9|Voids]].", false],
		[18, "", "Brent recruits him as a pilot for the research organisation Deep Science, which is investigating the Voids.", false],
		[24, "", "At [[station/10]] he meets [[character/6]], the project's leader, and is soon drawn to her.", false],
		[26, "", "He and Carla are pulled through a Void wormhole into the Voids' home sector and find a way back.", false],
		[36, "", "The Vossk commander [[character/7]] knows of Keith's earlier service at Novaterra.", false],
		[43, "", "Keith escorts the freighter that destroys the Void mother ship and ends the raids, though Errkt dies in the attack.", false],
		[45, "Afterwards", "His reward is a night with Carla, who then disappears to another secret project and leaves him with a final payment. With his job done, Keith is free to roam the galaxy.", false],
	],
	"character/1": [
		[16, "", "[[character/1]] is an old friend of Keith's from before his accident. In the 35 years Keith lost, Brent has risen to Lieutenant Commander and chief of the Interstellar Security Agency. He is friendly, talkative and fond of long personal stories.", false],
		[18, "The Void crisis", "As head of security he chairs the crisis team that coordinates the response to the [[faction/9|Voids]]. He recruits Keith for Deep Science and makes sure he is well paid. Keith's ship is repainted on his orders.", false],
		[19, "", "When the scientist [[character/5]] is kidnapped, Brent supports Keith's rescue plan and supplies EMP bombs at [[station/55]].", false],
		[32, "", "His team develops the early-warning system that shows where the Voids will open their next wormhole.", false],
		[35, "", "Together with [[character/6]] he devises the plan to destroy the Void mother ship with a freighter full of explosives, and arranges the deal with the Vossk commander [[character/7]].", false],
		[43, "Afterwards", "After the mother ship is destroyed, Brent celebrates the victory with Keith at [[station/98]].", false],
	],
	"character/2": [
		[2, "", "[[character/2]] is a [[faction/2]] ore trader who runs a small mining station at [[station/78]] in the [[system/15]] system. He finds the wreck of [[character/0]]'s ship, saves its pilot and claims the ship as salvage. Gruff and practical, he makes Keith work off his debt by mining ore in [[ship/0]], an old ship he patched together himself.", false],
		[8, "", "When Keith helps him destroy a pirate hideout near his station, Gunant comes to respect him.", false],
		[10, "", "In gratitude he gives [[ship/0]] to Keith with a better drive, and sends him to his friend [[character/3]]. Gunant is himself a member of the [[faction/3|Mido Confederation]]. He designs his own mining lasers, and as the agent [[agent/11]] he sells the blueprint for one of them, [[item/90]].", false],
	],
	"character/20": [
		[32, "", "[[character/20]] is a scientist of the [[faction/7|Grey]] who works for Deep Science. He asks to meet [[character/0]] at [[station/10]].", false],
		[33, "", "Khador speaks with elaborate courtesy. After studying the Void wreckage, he believes that crystals found only in the Void sector hold the secret of the Voids' wormholes. He has spent years developing a drive that would carry a ship instantly to any point in space, and asks Keith to collect 50 [[item/164]] for it.", false],
		[34, "", "When Keith delivers the crystals, Khador rewards him with a copy of the blueprint for the drive that bears his name, the [[item/85]].", false],
	],
	"character/3": [
		[10, "", "[[character/3]] is a human captain who joined the [[faction/3|Mido Confederation]] and now commands [[station/79]]. [[character/2]] recommends him to Keith as someone who can help him get back to Terran space.", false],
		[11, "", "Norris welcomes Keith and explains the history of the [[system/15]] system. He offers to put Keith in touch with the Terran Space Fleet if Keith first investigates the silence at [[station/76]].", false],
		[13, "", "He arranges for Keith to meet a Terran convoy passing through the system, and suggests he take freelance jobs while he waits.", false],
	],
	"character/4": [
		[12, "", "[[character/4]] is a notorious dealer whom Keith knew long ago. Keith finds him at [[station/76]], where he has supplied the whole crew with neuro-algae, a drug with unpleasant side effects. Mkkt remembers Keith and is curious why he has not aged.", false],
		[13, "", "On hearing Keith's report, [[character/3]] promises to deal with him.", false],
	],
	"character/5": [
		[18, "", "Tommy is Lt. Thomas Boyle, a scientist working for Deep Science. [[character/1]] arranges for him to meet Keith at [[station/56]] and guide him to the organisation's secret research station.", false],
		[19, "", "Boyle is kidnapped by pirates near [[station/55]] before the meeting, and they demand a ransom for him.", false],
		[23, "", "After Keith disables the kidnappers' ship, Boyle is rescued. He gives Keith the coordinates of the [[system/6]] system and travels with him to [[station/10]].", false],
	],
	"character/6": [
		[23, "", "Dr. Paolini is the Deep Science scientist waiting for Keith and Boyle at [[station/10]].", false],
		[24, "", "Dr. Carla Paolini leads the Deep Science project on the [[faction/9|Voids]]. She is determined and hard-working, and insists on seeing the Voids with her own eyes, so she flies with [[character/0]] on his first salvage mission. Keith is attracted to her from their first meeting.", false],
		[26, "", "She and Keith are pulled through a wormhole into the Voids' home sector and narrowly escape together.", false],
		[28, "", "Her team builds a probe to analyse the Void mother ship. She agrees to a date with Keith if he returns from the mission alive.", false],
		[34, "", "Too busy with her research to keep the date, she works out a plan with [[character/1]] to strike at the mother ship.", false],
		[44, "Afterwards", "After the victory she joins Keith and Brent at [[station/98]] for the long-delayed date.", false],
		[45, "", "The next morning she is gone, leaving a note: she has left for another secret project and asks Keith not to look for her.", false],
	],
	"character/7": [
		[35, "", "[[character/7]] is a [[faction/1]] commander in charge of [[station/29]] in the [[system/5]] system. He supplies the K'Sarr freighter for the attack on the Void mother ship, in exchange for prisoners.", false],
		[36, "", "Proud and formal, he believes that only a Vossk can fly a Vossk ship properly and insists on piloting the freighter himself. He tests Keith's skill before accepting him as an escort.", false],
		[37, "", "After Keith beats him in a contest at a pirate hideout, Errkt treats him with respect.", false],
		[40, "", "Before the mission he is calm and withdrawn, which Brent reads as determination.", false],
		[42, "Death", "Errkt flies the freighter through the wormhole and into the mother ship. When his escape pod is destroyed, he refuses to turn back and dies in the explosion, sending Keith away to safety.", false],
		[43, "", "Brent promises to report his sacrifice to the Vossk Empire.", false],
	],
	"character/8": [
		[40, "", "Lt. [[character/8]] leads the squad of reinforcements that joins Keith to protect the Vossk freighter on its way to the wormhole.", false],
		[41, "", "His squad does not make it through the wormhole before it closes, so Keith and [[character/7]] face the Voids alone.", false],
	],
	"chart": [
		[0, "", "The galaxy map lists every system with its faction, safety rating, number of stations and position on the chart. The position is given as two numbers from 0 to 100: the first counts from the left edge of the star map, the second from the top. Systems with similar numbers lie close together.", false],
		[0, "", "In the game, open the star map from a station or in flight. A dashed line joins your current system to every system its jump gate reaches; the other gate routes appear as thin lines. Stars you can reach right now are bright, the rest are dimmed. Markers show the system of your story mission and of your current job, and a dashed coloured line shows the shortest gate route there. A faded gold line traces your last few trips.", false],
		[0, "", "Select a system to see its faction, safety rating and distance. Zoom in to see its stations, their tech level, and markers for stations you have visited, mission goals and the jump gate. Hidden systems do not appear until you learn their coordinates; see [[world/galaxy]].", false],
		[32, "", "Once you have the early-warning system from [[step/31]], the star map also marks the system and station where the next Void wormhole will open.", false],
	],
	"faction/0": [
		[0, "", "The Terrans are humans, and [[character/0]] is one of them. They hold ten systems, more than any other faction, spread across the centre, the right side and the bottom of the chart, with [[system/19]] and [[system/14]] at their core. Terran space is the safest part of the galaxy: its two Safe systems are both Terran.", false],
		[0, "", "Terran stations sell the widest range of ships and equipment. Ship dealers outside Vossk space offer a broad range of hulls. The Terrans' traditional rivals are the [[faction/1]]: standing gained with one is lost with the other.", false],
		[16, "", "The Terran Space Fleet is still the force [[character/0]] once served in, but 35 years have passed. When he finally meets a Terran convoy, it mistakes his old pirate-built ship for an enemy and arrests him.", false],
		[18, "", "The Terrans lead the defence against the Voids. [[character/1]], now head of the Interstellar Security Agency, chairs a crisis team, and the research group Deep Science works on the problem from a secret station.", false],
	],
	"faction/1": [
		[0, "", "The Vossk are an alien people organised as an empire. They hold six systems in the lower right of the chart, from [[system/3]] and [[system/12]] down to the remote [[system/21]]. Four of them are rated Dangerous or Risky. [[system/10]] has no gate link at all.", false],
		[0, "", "Vossk ship dealers sell only one hull, the [[ship/9]], a model adapted for other races. Vossk stations also stock weapons and equipment found nowhere else. The Vossk are the traditional rivals of the [[faction/0|Terrans]], so their ships may join the raiders in Terran space and the reverse.", false],
		[18, "", "Relations between the Terrans and the Vossk Empire remain cool and unpredictable, but the Void raids hit Vossk systems as well.", false],
		[36, "", "In the story the Vossk come across as proud and bound by honour. Their commander [[character/7]] insists on flying the bomb carrier himself and tests [[character/0]] with a contest before accepting him as escort.", false],
		[42, "", "[[character/7]] gives his life to destroy the Void mother ship, and the Terrans promise to report his deed to the Vossk Empire.", false],
	],
	"faction/2": [
		[0, "", "The Nivelians are an alien people who hold four systems on the left side of the chart: [[system/2]], [[system/9]], [[system/17]] and the hidden [[system/0]]. Their stations range from small outposts to some of the most advanced in the galaxy. Their rivals are the [[faction/3|Midorians]].", false],
		[2, "", "The first person [[character/0]] meets is a Nivelian, the ore trader [[character/2]]. [[character/0]] has a low opinion of Nivelian manners, while [[character/2]] insists on being an honest businessman.", false],
		[11, "", "A Nivelian civil war gave rise to the [[faction/3|Mido Confederation]]. The Nivelians never accepted its independence and still claim the [[system/15]] system.", false],
		[35, "", "The plan against the Void mother ship relies on Nivelian nuclear explosives.", false],
	],
	"faction/3": [
		[0, "", "The Midorians are the people of the [[faction/3|Mido Confederation]]. They hold two systems in the upper left of the chart, [[system/15]] and [[system/4]], both rated Dangerous. Their stations are mostly small and low-tech. Their rivals are the [[faction/2|Nivelians]].", false],
		[11, "", "The Confederation was founded by Terran and Nivelian refugees and outlaws during the Nivelian Civil War. It keeps contact with other systems to a minimum. [[character/3]], commander of [[station/79]], is one of its members, and so is [[character/2]].", false],
		[38, "", "The Confederation is no friend of the Nivelians. Its ships seize the convoy carrying the Nivelian explosives meant for the Void mother ship, and [[character/0]] has to take it back near [[station/22]].", false],
	],
	"faction/4": [
		[0, "", "The Multipods are a minor race without systems of their own. The only Multipod you meet is the agent [[agent/6]], who sells a blueprint in the lounge of [[station/61]] in [[system/12]].", false],
	],
	"faction/5": [
		[0, "", "The Cyborgs hold no territory. The only Cyborg in the game is the agent [[agent/14]] in the lounge of [[station/65]], who trades in the coordinates of a hidden system.", false],
	],
	"faction/6": [
		[0, "", "The Bobolians are a minor race without systems of their own. The agent [[agent/13]], a Bobolian, sits in the lounge of [[station/26]] in Vossk space and sells the coordinates of a hidden system.", false],
	],
	"faction/7": [
		[0, "", "The Grey are a race without systems, stations or ships of their own. They play no part in trade or combat.", false],
		[32, "", "The one Grey in the story is [[character/20]], a scientist working with Deep Science; see [[world/khador]].", false],
		[33, "", "He studies the remains of Void ships and develops a new kind of drive from them.", false],
	],
	"faction/8": [
		[0, "", "Pirates are outlaws of every race. They hold no systems but turn up everywhere, and they are always hostile. How often they lie in wait near a station depends on the system's safety rating. Many freelance jobs ask you to hunt them, and their wrecks can be looted for cargo.", false],
		[0, "", "The story opens with [[character/0]] chasing a pirate gang for the bounty on their heads.", false],
		[2, "", "[[ship/0]], the ship [[character/2]] lends [[character/0]], was once a pirate ship.", false],
		[16, "", "This is why the Terrans later take him for a pirate.", false],
		[19, "", "Pirates also kidnap [[character/5]] near [[station/55]] and demand a ransom.", false],
	],
	"faction/9": [
		[0, "", "The Voids are a hostile force that attacks without warning. They hold no systems on the chart, and their ships open fire on everyone. Their fighter, the [[ship/8]], is the most heavily armoured hull in the game. See [[world/voids]].", false],
		[2, "", "In [[system/15]], the Voids are known only from rumour and from rare sightings.", false],
		[16, "", "A Void squadron attacks [[station/98]] while [[character/0]] is there. Their radio messages claim peaceful intentions while they shoot.", false],
		[18, "", "The Voids arrive through wormholes that open near stations for a short time. They raid Terran, Nivelian and Vossk systems alike and seem to be after ore. Nobody knows where they come from.", false],
		[24, "", "At [[station/48]] they broadcast a stranger claim: that they come from the future and are all that is left of the galaxy's civilisations.", false],
		[26, "", "A wormhole leads to their own sector, where a huge mother ship launches their fighters.", false],
		[35, "", "The mother ship appears to be the source of the wormholes.", false],
		[42, "", "The destruction of the mother ship in [[step/41]] collapses the wormholes and ends the raids, at least for the time being.", false],
	],
	"guide/basics": [
		[0, "The opening", "A new game begins in space rather than at a station. [[character/0]] is chasing a band of pirates through an asteroid field, and the first flight is a short fight that teaches steering, aiming and firing. Only the crosshair and the ship markers are shown while it lasts. Destroy the pirates and let the scene play out; the story then moves on by itself.", false],
		[2, "", "After the opening you wake at [[station/78]], a small mining station run by [[character/2]]. He lends you [[ship/0]], an unarmed ship with a mining laser, and the first steps teach mining, the autopilot and docking. Weapons, the map and the rest of the station open up as the story goes on.", false],
		[0, "Docking", "To dock, hold the crosshair over a station until it locks, then press Fire: the autopilot takes over and flies you in. You can also fly into the station yourself; the ship docks the moment it touches the hull. Docking is where most bookkeeping happens. Your hull, armour and shields are restored free of charge, deliveries and passengers are handed over, finished blueprint goods are collected, new medals are awarded and the game saves itself.", false],
		[0, "Station screens", "A docked station offers six sections: Hangar, Space Lounge, Map, Missions, Status and Game Options. Early in the story some of them are locked and shown with a padlock. The Hangar opens at [[step/5]], the Map at [[step/9]], and the Space Lounge and Missions at [[step/13]]. Status and Game Options are always available.", false],
		[0, "", "The Hangar holds the Shop (buy and sell goods and equipment), Ship (fit and remove equipment), Ships (the hull dealer, at stations that have one) and Blueprints (production). The Space Lounge is where clients, traders and pilots for hire wait. The Map shows the galaxy and lets you pick a destination. Missions lists the current story goal and any freelance job you have taken. Status shows your pilot record, your standing with the four great races and your medals. The top bar shows the station's Tec Level, which decides what its shop can stock.", false],
		[0, "Leaving a station", "Press Depart to launch. Each flight opens with a few seconds of watching your ship leave, with the system's details and a tip; any key, click or tap skips it. If you picked a destination on the Map before leaving, the autopilot sets course for it as soon as the launch is over. You cannot leave with more cargo than the hold can carry, so sell or fit the extra first.", false],
		[0, "Saving", "The game saves automatically after every completed docking, once rewards and the next story step have been settled. You can also save by hand to one of three slots from Game Options while docked, and load any slot or the autosave from there or from the title screen. Outside the browser version, Game Options can also export a save to a file and import one again. Saves belong to the game data they were made with.", false],
		[0, "", "If your ship is destroyed, the flight ends and you continue from the station of your last autosave, or start again if there is none. Anything earned since that docking is lost, so dock now and then during long trips.", false],
		[0, "Pilot level", "Your pilot has a level, shown on the Status screen. Experience comes from kills, freelance jobs (each worth two points), cores mined, every fifty tonnes of ore mined and every two wingmen hired. The level rises by one whenever experience passes 1.3 times the figure it had at the last rise, and is checked when you dock. A higher level makes enemies tougher, but also raises freelance rewards and the fees of hired pilots.", false],
	],
	"guide/blueprints": [
		[0, "Blueprints", "Some of the best weapons and equipment are never sold in shops. They are built from blueprints instead. A blueprint lists the goods it needs and in what amounts. Blueprints are bought from named agents in the Space Lounge, who appear once the story has passed [[step/16]]; each agent sells one blueprint, once.", false],
		[34, "", "The blueprint for the [[item/85]] jump drive is not sold by anyone: the story hands it over in [[step/34]].", false],
		[0, "Production", "Production takes place in the Blueprints tab of the Hangar. Choose a blueprint and hand over ingredients from your hold. You can deliver them in parts over several visits. The station where you deliver first becomes the production station for that batch. Ingredients delivered at any other station are shipped there for 10 credits per tonne, so it pays to bring everything to the same place.", false],
		[0, "Finished goods", "When the last ingredient is in, the batch is finished. Secondary weapons are made ten at a time; everything else one at a time. If you finish at the production station, the goods go straight into your hold, even if that overfills it. Otherwise they wait at the production station and are handed over the next time you dock there. A blueprint is never used up: once a batch is done, you can start the next.", false],
		[0, "Medals", "Owning blueprints counts towards [[medal/13]], and finishing different blueprints towards [[medal/14]].", false],
	],
	"guide/combat": [
		[0, "Primary weapons", "Primary weapons are guns fixed to fire forwards: lasers, blasters, autocannons and thermo weapons. Each has its own damage, fire rate, range and projectile speed, and every fitted primary fires together. Some blasters, such as [[item/16]], are EMP weapons that drain a ship's energy instead of its hull. Auto fire keeps the guns firing at the target without holding the button.", false],
		[0, "Shields, armour and hull", "Damage first drains the shield, then the armour plate, and only then the hull itself. A shield refills completely over its recharge time; armour and hull do not. A repair bot slowly mends both hull and armour during flight. Docking restores everything free of charge. When the hull is gone, the ship is destroyed.", false],
		[0, "EMP", "Every ship has a store of energy. EMP weapons drain it, and a ship whose energy runs out is disabled: it drifts helplessly until the energy has built up again. A disabled ship can be robbed of its cargo with a tractor beam, and some jobs require a ship to be disabled rather than destroyed. EMP protection equipment, such as [[item/60]], carries an EMP defence figure.", false],
		[0, "Secondary weapons", "Secondary weapons fire from the secondary slots and use up ammunition, which stacks in the slot. Rockets fly straight. Torpedoes turn after the radar lock shortly after launch. EMP bombs and nukes burst over an area and hit everything within their blast, more weakly towards the edge; EMP bombs pass asteroids by, while nukes break them. Choose which launcher to use from the Actions menu; until you do, the Secondary weapon key fires the first loaded one.", false],
		[0, "Turrets", "Larger hulls have turret slots. With a turret fitted, the Rear view key switches to turret view: the ship holds its course while you swing the turret round and fire it, which lets you fight back against ships on your tail.", false],
		[0, "Wingmen", "From [[step/16]] on, pilots for hire can be met in the Space Lounge. A contract covers one to three ships for ten minutes of flight, and they fly with you wherever you go until it runs out. Give them orders from the Actions menu: fire at will, attack your target, secure the next mission waypoint, or switch between their laser and EMP blaster. See [[guide/lounge]].", false],
		[0, "Pirates", "Pirates raid stations, more often in dangerous systems, and lie in wait for pilots carrying freight or passengers. Many freelance jobs are about fighting them. Shooting pirates does not anger anyone; it slightly improves your standing with the race that rules the system.", false],
		[0, "Standing", "Your standing is kept on two scales, each from -100 to 100: one between the [[faction/0]] and the [[faction/1]] races, the other between the [[faction/2]] and the [[faction/3]] races. Wronging one race moves the scale towards its rival: disabling or robbing one of its ships costs 2 points, a kill costs 5. Completing a freelance job moves the scale 2 points towards the client's race. Once a scale passes 60 in either direction, the race on the losing side turns hostile, and its ships attack you on sight.", false],
		[0, "", "A hostile race sends a diplomat to the Space Lounges, who offers to set the scale back to zero for a fee that grows with how far it has gone: at most 16,000 credits. Status shows both scales. Taking a scale past 60 also earns [[medal/28]].", false],
		[0, "Friendly fire", "The ships of a system's own race tolerate stray shots only so far. Once you have taken a third of a local ship's hull or energy, it fights back and warns you over the radio. At two thirds of its hull, or when you disable it, every ship of that race in the system turns on you. Other races' ships are less touchy, but a kill always costs standing.", false],
	],
	"guide/fitting": [
		[0, "Hulls", "A ship's hull sets its armour (the hull's own strength), its cargo hold, its handling and its slots: primary weapons, secondary weapons, turrets and equipment. A better hull mostly means more slots. Ship pages compare every hull.", false],
		[0, "Slots and the Ship screen", "Items are bought into the hold and then fitted on the Ship screen in the Hangar. Each slot takes one item of its category; fitting over an occupied slot puts the old item back in the hold. Equipment can be fitted only once per kind, except for kinds that stack, such as cargo compression units, cabins and EMP protection, of which several can be fitted, each in its own slot. Secondary ammunition of one type shares a single slot. A fitted item can also be sold straight from its slot at the station's price.", false],
		[0, "Equipment kinds", "Shields absorb damage and recharge. Armour plates add to the hull's strength. EMP protection guards against energy drain. Cargo compression enlarges the hold. Tractor beams pull in cargo from wrecks and disabled ships; without one, nothing can be collected in space. Boosters give bursts of speed. Repair bots mend the ship in flight. Steering nozzles improve handling. Scanners shorten the time to lock a target, and the better ones show a target's cargo. Mining lasers drill asteroids. Cabins carry passengers. Cloaks hide the ship for a while. A jump drive travels without gates.", false],
		[0, "Buying a hull", "Stations with a dealer show a Ships tab in the Hangar with up to five hulls for sale. [[faction/1]] dealers offer only their own race's hull, [[ship/9]]. A dealer takes its station's Tec Level in percent off the list price, so high-tech stations sell hulls cheaper. Your old hull is taken in part exchange for four fifths of its list price. Everything fitted is moved to the hold, so check that it fits or sell some before leaving. You cannot change hulls while passengers are aboard, and cabins cannot be removed while they are in use.", false],
		[5, "First weapons", "When the hangar at [[station/78]] first opens, its shelf holds a laser, an autocannon and an armour plate free of charge. Fit a gun and the plate before setting out on the next mission.", false],
		[0, "Rare hulls", "Some hulls are never offered by ordinary dealers. A pilot who has won every medal in gold is offered a prototype, [[ship/8]], at [[station/10]]; see [[guide/medals]].", false],
	],
	"guide/flight": [
		[0, "Steering", "The ship always flies forwards. You turn it left and right and pitch its nose up and down; when you let go, it levels its wings by itself. How quickly it turns depends on the hull's handling and on any steering nozzle fitted. Under Options, Controls, Helm response can be Direct, which turns at full rate at once, or Smooth, which eases in and out of turns. With mouse steering the left and right keys can slide the ship sideways instead of turning it.", false],
		[0, "Throttle", "Thrust up and Thrust down change the throttle in steps of a quarter, and holding the key keeps stepping. The ship takes about a second to settle at the new speed. The autopilot and the booster always fly at full throttle, and easing off the throttle during a boost ends it.", false],
		[0, "Booster", "With a booster fitted, the Booster key gives a burst of extra speed. A burst lasts for the booster's duration and is followed by a recharge time before the next one; the HUD shows whether it is ready. Better boosters are faster, last longer or recharge sooner. Boosting is useful for escaping a fight and for crossing the long distances inside a system.", false],
		[0, "Autopilot", "The Autopilot key hands the helm to the ship's computer, and pressing it again takes it back. It flies to whatever is locked, or else to the destination chosen on the Map: the jump gate when the destination lies in another system, or the destination's planet in this one. The Autopilot list offers the choices that exist where you are: the programmed destination, the jump gate, this station, the asteroid field and the next mission waypoint. Flying to a locked station ends in docking.", false],
		[0, "Time speed", "The Time speed key makes the flight run faster. Double speed is always available while you fly. Four and eight times are only offered while the autopilot is flying, no enemy is near and nothing else is under way, such as mining, docking or a jump.", false],
		[0, "Targeting", "To lock an object, keep it under the crosshair until the scan completes. The scanner fitted decides how long that takes, from several seconds with a basic model to under two with the best. Next target cycles through nearby objects without aiming at them. Stations, jump gates and the stars that mark other planets lock with a single press. What Fire does depends on the lock: on a ship it shoots, on a station it docks, on a gate it jumps, on a star it travels to that planet, and on an asteroid it starts mining. Better scanners also show the cargo of a locked ship.", false],
		[0, "Markers and radar", "Ships carry brackets on screen, and arrows at the edge of the screen point to the target, the station and nearby threats that are out of view. Enemies are marked in red, friends in green, neutral ships in yellow and mission waypoints in blue; the colour-blind option in Options, Interface swaps these for orange enemies and blue friends. A ship close to you shows two small bars beside its bracket: its hull and, in blue, its EMP energy. The Extended flight display adds plates with exact figures and a round radar scope; the Original display keeps the game's own corner panels.", false],
		[0, "Looking around", "Rear view turns the camera to look behind the ship. If a turret is fitted, the same key switches to turret view instead: the ship holds its course while you swing the turret and fire it. You can also look around the ship without steering by holding Alt and moving the mouse, with the gamepad's right stick, or by dragging a finger over free screen space.", false],
		[0, "Cloaking", "A cloaking device hides your ship from other ships for its duration, and anyone hunting you loses track at once. Press the Cloaking device key again to switch it off early. After use it needs time to recharge before it works again.", false],
		[0, "Docking and travel", "Lock the station and press Fire, or simply fly into it, to dock. The other stations of the system appear as bright stars; lock one and press Fire to travel to that planet. Most systems have a jump gate, near one of their stations, for travel to other systems; see [[guide/navigation]]. While a freelance fight is under way at a station, you cannot dock, travel or jump away until it is won or lost.", false],
	],
	"guide/help": [
		[0, "Keyboard", "These are the default keys. All flight actions can be rebound under Options, Controls, Keyboard, where Restore default keys undoes changes.", false],
		[0, "", "Turn left / Turn right: Left and Right arrows, or A and D.", true],
		[0, "", "Pitch up / Pitch down: Up and Down arrows.", true],
		[0, "", "Thrust up / Thrust down: W and S.", true],
		[0, "", "Fire / use: Space or Ctrl. Fires the guns, or docks, jumps, travels or mines when a station, gate, star or asteroid is locked.", true],
		[0, "", "Secondary weapon: E.", true],
		[0, "", "Booster: Shift.", true],
		[0, "", "Autopilot: Q. Autopilot list: R. With Hold autopilot for the list switched on, holding Q for half a second opens the list.", true],
		[0, "", "Next target: Tab.", true],
		[0, "", "Auto fire: F.", true],
		[0, "", "Rear view: C. With a turret fitted it switches to turret view.", true],
		[0, "", "Actions / jump drive: M. Opens the Actions menu: secondary weapon choice, cloak, wingman orders and the jump drive.", true],
		[0, "", "Route map: N.", true],
		[0, "", "Cloaking device: V.", true],
		[0, "", "Time speed: T.", true],
		[0, "", "Photo mode: P. Freezes the flight and hides the interface; drag or use the arrow keys to turn the camera and the wheel or + and - to zoom.", true],
		[0, "", "Pause menu: Escape. F11 switches full screen on desktop systems.", true],
		[0, "", "In menus, the arrow keys move between entries, Enter selects and Escape goes back.", true],
		[0, "Mouse", "With Mouse steering on, moving the mouse steers the ship. During flight the pointer is captured, so the ship turns as you move it; Capture the pointer in flight can be switched off, and menus and pauses always free the pointer. The left button fires, the right button launches the secondary weapon, and holding Alt while moving the mouse looks around the ship. While the mouse steers, the left and right keys slide the ship sideways; Left / right keys under Options, Controls can make them always strafe or always turn. Mouse sensitivity sets how far the ship turns for a movement.", false],
		[0, "Gamepad", "The left stick steers and the right stick looks around the ship. RT or RB fires, LB launches the secondary weapon, A boosts, Y switches the autopilot, X selects the next target, clicking the right stick gives the rear or turret view, Back opens the Actions menu and Start pauses. In menus the D-pad moves, A selects and B goes back. Options, Controls, Gamepad sets the stick deadzone and vibration.", false],
		[0, "Touch", "On touch screens the controls appear on screen when Touch controls is set to Automatic or On. A stick on one side steers; by default it comes to your thumb wherever it lands on that side, and Stick fixed in place keeps it put. Steer from anywhere lets a finger on any free part of the screen steer. Buttons on the other side cover Fire / use, Secondary, Boost, Autopilot, Target, Rear view, Actions, Pause and, during radio messages, Next radio. A slider sets the throttle, and a Faster button speeds up time.", false],
		[0, "", "Tap Fire twice quickly to switch on automatic fire; one tap stops it. Dragging a finger over free screen space looks around the ship, and letting go looks ahead again. Left-handed layout swaps the sides, Touch control size scales the controls, and Adjust control placement lets you move each one. Phones and tablets can also steer by tilting: switch on Steer by tilting, hold the device as you play and calibrate.", false],
		[0, "Options", "Options is reached from the title screen, the pause menu and Game Options at a station. It has five pages. Audio sets music and sound volume. Display covers the window, frame rate, aspect ratio and graphics presets and details. Controls covers steering, mouse, gamepad, touch and keyboard bindings. Interface covers interface size, the Original or Extended flight display, HUD size and opacity, help pop-ups, the launch and station-entry sequences, the radar scope, labels, text size and accessibility settings such as colour-blind friendly colours, reduced flashing, screen shake and message time. Game sets the engine language and lets you import a different game file or manage mods.", false],
		[0, "Help", "Help, reached from the same places, shows the game's own help topics and loading tips, a list of the current key bindings, and a table that translates the phone keys named in the game's texts into the keys, buttons and touch controls used here.", false],
	],
	"guide/jobs": [
		[0, "Finding work", "Freelance jobs are offered by guests in the Space Lounge. A client describes the work and the payment. Before accepting a job elsewhere you can ask where it is and how difficult it will be; you can also ask to hear the offer again or turn it down. You can hold only one job at a time, and the Missions screen shows it with its destination and how many gate jumps away it is.", false],
		[0, "Kinds of job", "There are thirteen kinds. Until [[step/16]], and in copies of the game without the full campaign, only five are offered: [[job/11]], [[job/0]], [[job/7]], [[job/4]] and [[job/12]]. Afterwards the full range appears: [[job/1]], [[job/2]], [[job/3]], [[job/5]], [[job/6]], [[job/9]] and [[job/10]], and buyers who want goods ([[job/8]]).", false],
		[0, "Difficulty and reward", "Early jobs have a difficulty of one or two; later ones range up to nine. A job's base reward is 1,500 credits plus up to 5,500 more with difficulty. It is then raised by the distance to the destination (doubled at 1,200 km), and 200 credits are added per pilot level. Junk removal pays 30 percent less, escorts pay 20 percent more, recovery and salvage pay double, and passenger jobs pay a smaller base plus a share for every passenger. Rewards are rounded to fifty credits.", false],
		[0, "Carrying out a job", "Courier and passenger jobs are done by docking at the destination with the freight or passengers aboard. Purchase jobs are done by docking again at the buyer's station with the goods in the hold. All other jobs are fights at the destination station, set up when you arrive there; while one is under way you cannot dock, travel or jump away. Recovered containers and hostages must then be brought back to the station where you took the job. When a job is done, the reward is paid at once, your standing with the client's race improves and the job counts towards [[medal/16]].", false],
		[0, "Failure", "A fight fails if its condition is lost: the ships you protect are all destroyed, the container is lost, time runs out or the rival out-shoots you. A failed job is cancelled without pay. You can also abandon a job from the Missions screen; any freight is taken back. If your ship is destroyed, you continue from your last autosave.", false],
	],
	"guide/lounge": [
		[0, "Guests", "Every station has a Space Lounge, open from [[step/13]]. Three to five guests sit there, and they change every time you dock. Most belong to the system's ruling race, but some come from anywhere. Talk to a guest to hear what they want; each answer and decision counts towards one of the conversation medals.", false],
		[0, "Answers", "OK accepts an offer, No, thanks turns it down and How was that again? repeats it. For a job elsewhere you can ask Can you show it on the map? to learn the destination and Will it be difficult? to hear how hard it is. Traders let you look at their goods first. Turning offers down, asking for repeats and accepting without asking each count towards [[medal/32]], [[medal/33]], [[medal/34]] and [[medal/35]]; talking to guests with an offer counts towards [[medal/26]].", false],
		[0, "Clients and talkers", "Many guests offer freelance jobs; see [[guide/jobs]]. Others just talk and pass on rumours, which sometimes mention stations or ores worth knowing about.", false],
		[0, "Traders and buyers", "Traders sell a single lot: a piece of equipment or a few units of a commodity, at anywhere from 40 to 160 percent of its usual price. From [[step/16]] on, buyers also appear, asking for a quantity of an item to be brought to that same station; see [[job/8]].", false],
		[0, "Pilots for hire", "From [[step/16]] on, one guest per lounge may offer wingmen: one to three pilots for a fee of 700 to 1,999 credits per pilot, for ten minutes of flight. [[faction/1]] pilots are never for hire. You can only have one group at a time. A pilot who holds every medal finds admirers instead, who pay to fly along.", false],
		[0, "Agents", "Once the story has passed [[step/16]], named agents wait at certain stations and make one deal each. Most sell a blueprint; four sell the coordinates of a hidden system, which then appears on the map. Each agent leaves after the deal. The agents are listed on their own pages.", false],
		[0, "Diplomats", "When one of the four great races has turned hostile, one of its diplomats sits in each lounge. For a fee that grows with how far your standing has fallen, up to 16,000 credits, the diplomat sets that standing scale back to zero.", false],
	],
	"guide/medals": [
		[0, "Tiers", "Most medals come in three tiers: bronze, silver and gold. Each tier has its own target, and reaching a higher one replaces the lower medal. A few medals have a single tier only. Medal pages show the target for each tier.", false],
		[0, "When medals are awarded", "Your record is checked as you approach a station, before the dock repairs your ship, and new or improved medals are announced once you have docked. Nothing is awarded in flight, so a target reached in space only counts at the next docking. The Status screen lists every medal you hold, its tier and what it was awarded for.", false],
		[0, "The first and the last", "[[medal/0]] is held from the start of the game. [[medal/36]] is awarded automatically once every other medal is held.", false],
		[0, "Rewards", "Holding every medal changes how pilots in the Space Lounge treat you: admirers pay you to fly along as wingmen instead of charging a fee. Holding every medal in gold earns the offer of [[ship/8]], a prototype sold at [[station/10]]. On the Status screen, [[character/0]] wears dark glasses once he holds every medal, and golden ones once every medal is gold.", false],
	],
	"guide/mining": [
		[0, "Asteroids", "Every station's space holds asteroids in two fields: one close to the station and one further out, which the Autopilot list can fly you to. Which ores a field holds depends on how close the system lies to each ore's home system, so not every ore can be found everywhere. Asteroids can also be shot to pieces; this sometimes leaves a little ore floating free, and destroyed asteroids count towards [[medal/29]].", false],
		[0, "Starting to mine", "Mining needs a mining laser and free space in the hold. Lock an asteroid by holding it under the crosshair, then press Fire. The ship flies up to the rock and the drill starts; flying is locked until you finish. The HUD shows the asteroid's ore and class once it is locked.", false],
		[0, "The drill", "A gauge shows the asteroid's rock layers stacked on top of each other, each narrower than the one before. The drill drifts to one side and changes direction at random every half second to two and a half seconds. Steer left and right to keep it inside the current layer's green area. The first layer takes six seconds of drilling, and each deeper layer takes about a sixth less time than the one before. Ore builds up all the while you stay in the green, and faster in the deeper layers.", false],
		[0, "Red zones", "Time spent outside the green area counts as damage and the red zones on the gauge grow. After two and a half seconds in the red in total, the asteroid breaks apart and everything drilled from it is lost. Press Fire at any time to stop and keep the ore gathered so far. Each asteroid can be mined only once.", false],
		[0, "Classes and cores", "Larger asteroids have more layers, from two to seven. The largest, class A, has all seven, and drilling through every one of them yields a core as well as the ore. Cores are worth far more than ore and count towards [[medal/3]] and [[medal/7]]. Ores count towards [[medal/2]] and [[medal/6]].", false],
		[0, "Mining lasers", "A mining laser has two figures. Its yield makes the drill drift more slowly and steer more finely, which keeps it in the green more easily. Its speed raises the rate at which ore builds up. The lasers range from [[item/86]] to [[item/89]]; [[item/90]] is built from a blueprint.", false],
		[0, "Cargo", "Ore and cores go straight into the hold, and you only keep as much as there is room for. When the hold is full the HUD says so and you must sell or unload at a station. Cargo compression units enlarge the hold by a share of the hull's capacity, and several can be fitted at once. A bigger hull helps most of all.", false],
	],
	"guide/navigation": [
		[0, "The galaxy map", "The Map section of a station, and the Route map key in flight, show the galaxy: every known system at its place, the gate links between them, the ruling race and the system's safety. Choosing a system zooms into it and shows its stations; choosing a station there sets it as your destination. The map also shows the distance to a system in kilometres, marks the stations you have visited, and flags where the story and your current job continue. A search box finds known stations by name. The [[chart]] page lists all systems.", false],
		[0, "", "Early in the story you are held to your first station's orbit. The map opens at [[step/9]], after which you can fly to the other planets of the system.", false],
		[0, "Systems and safety", "Each system is ruled by one of the four great races and has a safety rating: Safe, Average, Risky or Dangerous. Pirate and enemy raids are far more frequent in dangerous systems, while safe systems are mostly quiet. Most systems have several stations, each orbiting its own planet, with its own shop, lounge and Tec Level.", false],
		[0, "Jump gates", "Travel between systems goes through jump gates. A system has at most one gate, which lies in the space of one of its stations, and it only links to neighbouring systems. To jump, choose a destination in a neighbouring system on the Map, fly to the gate (the autopilot will take you), lock it and press Fire once inside its zone. Longer journeys are made one gate at a time; the Missions screen shows how many gate jumps a destination needs through the systems you know.", false],
		[0, "Hidden systems", "Five systems are missing from the map at first: [[system/0]], [[system/1]], [[system/6]], [[system/10]] and [[system/21]]. A hidden system appears once you have been there or bought its coordinates. Four agents in the Space Lounge sell them: [[agent/12]] for [[system/0]], [[agent/13]] for [[system/1]], [[agent/14]] for [[system/10]] and [[agent/15]] for [[system/21]]. Named agents only appear once the story has passed [[step/16]]. [[system/10]] has no gate link at all and can only be reached with a jump drive.", false],
		[23, "", "The way to [[system/6]] is handed to you by the story in [[step/22]].", false],
		[0, "Jump drive", "A jump drive takes the ship straight to a station in any known system, without gates. The only one is [[item/85]], which is never sold in shops and must be built from its blueprint. Use it from the Actions menu in flight. A jump costs no fuel and no fee. It is not available while a freelance fight is under way at your station, though courier and passenger jobs do not stop it.", false],
		[34, "", "The story gives you the blueprint for [[item/85]] in [[step/34]], with part of its ingredients already delivered.", false],
		[0, "Distance", "Distances between systems are given in kilometres, measured from the systems' places on the map. Distance matters for trade, because prices rise with the distance from an item's origin, and for freelance jobs, whose reward grows with the distance to the destination.", false],
	],
	"guide/tips": [
		[0, "", "Read an item's page before a trading run: it names the system where the item is cheapest and the direction in which it gets dearer.", true],
		[0, "", "Stations buy and sell at the same price, so a cargo only earns money once it has travelled away from its origin.", true],
		[0, "", "When mining, react to every change of drift at once. Red time adds up over the whole drill, so short slips are as costly as one long one.", true],
		[0, "", "If the drill has already spent a lot of time in the red, stop it with Fire and keep what you have rather than lose the whole haul.", true],
		[0, "", "Look for the largest asteroids when you want cores: only class A rocks hold one, and only if you get through all seven layers.", true],
		[0, "", "Fit a tractor beam early. Without one, the cargo of wrecks and disabled ships cannot be collected at all.", true],
		[0, "", "A better scanner pays for itself in combat: it locks targets faster, and the best ones show what a ship is carrying before you attack it.", true],
		[0, "", "Docking repairs your ship for free, so it is worth stopping at a station between fights instead of pressing on with a damaged hull.", true],
		[0, "", "Dock regularly on long journeys. Only a completed docking makes an autosave, and a destroyed ship returns you to the last one.", true],
		[0, "", "Watch your standing on the Status screen. Stray shots at local ships add up, and a whole race can turn hostile.", true],
		[0, "", "Ask a client where the job is and how difficult it will be before you accept, unless you are collecting the medals for not asking.", true],
		[0, "", "Make room in the hold before accepting a courier job, and fit cabins before a passenger job: neither can be accepted without the space.", true],
		[0, "", "For recovery and salvage jobs, bring an EMP weapon, a scanner that shows cargo, a tractor beam and some free hold space.", true],
		[0, "", "Bring every ingredient of a blueprint to the station where you started it, and you avoid the shipping charge.", true],
		[0, "", "Hire wingmen just before a hard fight: their contract counts down only while you fly.", true],
	],
	"guide/trading": [
		[0, "How prices are set", "Every item has a lowest and a highest price and a home system, its origin. At the origin it sells for its lowest price; the further a station lies from the origin, the higher the price, up to the highest price at a set distance. On top of that, each station adds its own fixed variation of up to about five percent either way. Item pages show where an item is cheapest and in which direction it gets dearer.", false],
		[0, "Buying and selling", "A station buys at the same price it sells for, so profit comes only from moving goods: buy close to an item's origin and sell far from it. Goods you sell are added to the station's shelf. The Shop also remembers the lowest and highest price you have seen for each item, and in which system, and shows them beside the item. Some cargo cannot be sold, such as courier freight and containers you are carrying for a client.", false],
		[0, "What a shop stocks", "Each station has a Tec Level. Its shelf holds items of that level or below; stations of level four and above leave out items below half their own level. Each item also has a chance of being on a given shelf, so shelves differ from visit to visit. A few items are always on the shelf at a particular station. Some goods are only sold in [[faction/1]] systems, and blueprint products are never sold at all.", false],
		[0, "", "Commodities come in larger amounts, and in much larger amounts near their origin. Weapons and equipment usually come one to three at a time, while rockets, torpedoes and bombs come in larger batches. A shelf is restocked each time you dock, except at the last three stations you visited, which keep their shelves as you left them.", false],
		[0, "Booze", "Every system has its own local drink, which is only sold in that system, such as [[item/132]] in [[system/0]] or [[item/146]] in [[system/14]]. Drinks are ordinary trade goods. Buying them from shops counts towards [[medal/8]]; owning different kinds bought from Lounge traders or recovered from wrecks counts towards [[medal/9]].", false],
		[0, "Other sources", "Traders in the Space Lounge offer single lots at anything from 40 to 160 percent of the usual price, so their deals are worth comparing. Ships carry cargo that can be taken with a tractor beam when they are destroyed or disabled, and ore can be mined. Lounge buyers ask for a quantity of a particular item and pay well above its value for it; see [[job/8]].", false],
	],
	"home": [
		[0, "", "This reference covers Galaxy on Fire 2, a space game of trading, mining, combat and exploration. You fly as [[character/0]], a veteran pilot stranded far from home, through 22 star systems held by humans and alien races. Between story missions you can take freelance jobs, mine asteroids, trade goods, build equipment from blueprints and buy ever better ships.", false],
		[0, "", "The pages are built from the game you imported. Names, figures, prices and dialogue come from it, and the explanations alongside them are written for this reference. Story details beyond the point your save has reached stay hidden until you get there. Good places to start are [[world/galaxy]], the [[chart]] and [[guide/basics]].", false],
	],
	"intro/agents": [
		[0, "", "Agents are traders who sit in particular space lounges and sell something you cannot buy in a shop: either a rare blueprint or the coordinates of a hidden system. They appear from [[step/17]] on, and each sells only once. Talk to them in the lounge of their station to see the offer; see [[guide/lounge]].", false],
	],
	"intro/blueprints": [
		[0, "", "Blueprint items are never sold in shops. Each is built from a recipe of goods once you own its blueprint, which is usually bought from an agent in the Space Lounge. How production works is explained in [[guide/blueprints]].", false],
	],
	"intro/characters": [
		[0, "", "These are the people [[character/0]] meets on his journey: traders, officers, scientists and stranger company. Each biography grows as the story advances, so you only learn about a character what Keith himself has learned.", false],
	],
	"intro/equipment": [
		[0, "", "Equipment fills a ship's equipment slots: shields and armour plates for protection, cargo compressors, tractor beams for collecting containers, boosters, steering nozzles, scanners, mining lasers, passenger cabins, cloaks, a repair bot and the jump drive. Each piece takes one slot, so the number of slots limits how complete a ship can be. Prices vary by system, and shops only stock items up to their station's tech level. Some of the best pieces are built from blueprints, and several are made by the [[faction/1|Vossk]] and sold only in their systems.", false],
	],
	"intro/factions": [
		[0, "", "Ten factions appear in the game. Four of them own systems and stations: the Terrans, the Vossk, the Nivelians and the Midorians. Others have no territory and meet you only as individuals or as enemies. Your standing with the four great powers is kept on two scales, Terran against Vossk and Nivelian against Midorian; see [[world/galaxy]].", false],
	],
	"intro/goods": [
		[0, "", "Goods are everything carried in the hold for trade. Commodities and drinks are bought cheaply in one system and sold dearly in another (see [[guide/trading]]); every system has its own drink. Ores are drilled from asteroids, and drilling through every layer of a class A asteroid yields a core of much higher value (see [[guide/mining]]). Commodities, ores and cores are also the ingredients for building items from blueprints. A few goods, such as [[item/116]] and [[item/131]], only appear through jobs or the story and cannot be bought.", false],
	],
	"intro/guide": [
		[0, "", "These pages explain how the game is played: flying and fighting, mining and trading, the station screens, freelance work, production and medals. Figures quoted here follow the engine's rules; the tables on item, ship and medal pages come from your own game data. Start with [[guide/basics]] and [[guide/help]].", false],
	],
	"intro/jobs": [
		[0, "", "Freelance jobs are side work offered by clients in the Space Lounge, from carrying freight to hunting wanted criminals. They earn credits, standing with the client's race and experience. Thirteen kinds exist; how they are offered and paid is explained in [[guide/jobs]].", false],
	],
	"intro/medals": [
		[0, "", "Medals reward a pilot's record: fighting, mining, trading, travel and even how you talk to people in the Space Lounge. Most have bronze, silver and gold tiers. They are checked whenever you dock; see [[guide/medals]].", false],
	],
	"intro/ships": [
		[0, "", "Ships differ in armour, cargo space, handling and the number of mounts they offer: primary mounts for forward guns, secondary mounts for rockets, torpedoes and bombs, an optional turret mount, and equipment slots for everything else. Prices rise steeply, from under 20,000 credits for the smallest hulls to several million for the best fighters. Dealers outside [[faction/1|Vossk]] systems show up to five hulls at each visit; [[faction/1|Vossk]] dealers sell only the [[ship/9]]. A dealer takes its station's tech level in percent off the list price and pays four fifths of the list price for your old hull. The [[ship/0]] and the [[ship/10]] are never sold. See [[guide/fitting]] for how to equip a ship.", false],
	],
	"intro/stations": [
		[0, "", "Every station has a shop, a hangar, a ship dealer and a space lounge. Its tech level, from 1 to 10, decides how advanced the goods and equipment on its shelves can be, and its dealer takes that many percent off the list price of ships. Stocks change from visit to visit. Stations named in the story or holding an agent have a short description here.", false],
	],
	"intro/story": [
		[0, "", "The story follows [[character/0]], a Terran pilot whose hunt for pirates goes badly wrong, through 45 steps. Each step page gives the task and, once you have completed it, what happened. Pages only reveal as much as your save has reached; [[world/history]] tells the story so far in one place.", false],
	],
	"intro/systems": [
		[0, "", "The galaxy has 22 star systems. Each belongs to one faction, has a safety rating that sets how often raiders appear, and holds up to five stations, one of which carries the jump gate. Gate links decide which systems you can travel between; a few systems are hidden or have no links at all. See [[world/galaxy]] and the [[chart]].", false],
	],
	"intro/weapons": [
		[0, "", "Weapons fall into two groups. Primary weapons (lasers, blasters, autocannons and thermal guns) fire without ammunition from the forward mounts; they differ in damage per shot, fire rate and reach. Secondary weapons (rockets, torpedoes, EMP bombs and nukes) are bought by the piece and fired from the secondary mounts. Turrets need their own mount and can fire in any direction. Some weapons drain a ship's energy instead of, or as well as, damaging it; a ship with no energy left is disabled for a while. Several of the best weapons are never sold in shops and have to be built from blueprints (see [[guide/blueprints]]). Many models are made by the [[faction/1|Vossk]] and are stocked only in their systems. See [[guide/combat]] for tactics.", false],
	],
	"intro/world": [
		[0, "", "These pages describe the setting of the game: the galaxy and its layout, its history, and the forces that shape it. They complement the system, station and faction pages with the wider picture.", false],
	],
	"item/0": [
		[0, "", "The [[item/0]] is the entry-level laser: 3 damage per shot every 0.4 s, with the 2,000-unit reach shared by all early lasers. It is the weakest laser in the game, but it is cheap and almost every shop stocks it. The [[item/1]] and [[item/2]] keep the same fire rate and add damage.", false],
		[6, "", "It is one of the three pieces [[character/2]] offers for free in his hangar at [[station/78]] before the raid on the pirates' hideout, together with the [[item/22]] and the [[item/55]].", false],
	],
	"item/1": [
		[0, "", "The [[item/1]] is the second step of the Nirai line. It fires as quickly as the [[item/0]] (every 0.4 s) but deals 5 damage per shot instead of 3, at the same reach. It is a cheap upgrade until the [[item/2]] becomes affordable.", false],
	],
	"item/10": [
		[0, "", "The [[item/10]] deals 34 damage every 1.4 s at a reach of 2,600. It hits harder per shot than the [[item/9]] and reaches further, with a slightly slower fire rate. It is the strongest laser on sale in shops.", false],
	],
	"item/11": [
		[0, "", "The [[item/11]] is the strongest laser in the game: 45 damage every 1.5 s at a reach of 2,600, the heaviest single shot of any primary gun. It is never sold ready-made. Its blueprint comes from [[agent/0]] at [[station/3]], and building it consumes an [[item/9]] together with [[item/155]] and several commodities.", false],
	],
	"item/116": [
		[0, "", "Secure containers are sealed freight that only appears through freelance work. Accepting a [[job/0]] job loads the agreed number into your hold, where they take up cargo space; they cannot be sold and are handed over at the destination. They also stand for the stolen goods in [[job/3]] jobs, where the ship carrying them has to be disabled rather than destroyed.", false],
	],
	"item/117": [
		[0, "", "A secure cabin is special cargo that only appears through freelance work, in the [[job/5]] jobs that ask you to free a captive from one of several ships and bring them back. Like a [[item/116]], it cannot be bought or sold.", false],
	],
	"item/12": [
		[0, "", "The [[item/12]] is the basic [[faction/1|Vossk]] blaster: 11 damage every 0.6 s at a reach of 1,500. Blasters reach less far than lasers but hit harder over time; even this first model slightly outdamages the best Nirai laser. It is also needed to build the [[item/15]]. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/13": [
		[0, "", "The [[item/13]] is a [[faction/1|Vossk]] blaster that deals 12 damage every 0.5 s at 1,500 reach, a clear step up from the [[item/12]] in fire rate and damage. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/131": [
		[0, "", "[[item/131]] are the wreckage of [[faction/9|Void]] fighters. Each hostile [[faction/9|Void]] ship that is destroyed drops a container with one to three of them, which can only be collected with a tractor beam (see [[item/68]]). They sell at a fixed 199 credits, and collecting them counts towards the [[medal/21]] medal.", false],
		[24, "", "[[character/6]] needs such remains for her research and sends [[character/0]] to collect them near [[station/48]].", false],
		[25, "", "While [[character/0]] is carrying them back, the remains cannot be sold.", false],
		[28, "", "They are handed over to [[character/6]]'s team on arrival at [[station/10]].", false],
	],
	"item/14": [
		[0, "", "The [[item/14]] is a [[faction/1|Vossk]] blaster that fires every 0.4 s for 10 damage. It deals slightly more damage over time than the [[item/13]], but its reach of 1,000 is short, so it suits pilots who close in on their targets. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/15": [
		[0, "", "The [[item/15]] is the best [[faction/1|Vossk]] blaster: 10 damage every 0.3 s at 1,500 reach. It combines the fire rate of the faster blasters with the reach of the [[item/12]]. It is never sold ready-made. Its blueprint comes from [[agent/1]] at [[station/8]], and building it consumes an [[item/12]] and a [[item/166]] along with several commodities.", false],
	],
	"item/154": [
		[0, "", "[[item/154]] is the most valuable ordinary ore. Asteroid fields favour ores whose home system lies close by, and its home is [[system/9]], where it is also cheapest. It is needed in quantity to build the [[item/27]]. Drilling through a class A [[item/154]] asteroid yields a [[item/165]].", false],
	],
	"item/155": [
		[0, "", "[[item/155]] is a mid-priced ore whose home system is [[system/21]], where it sells cheapest. It is an ingredient of the [[item/11]] and of [[item/90]]. Its core is the [[item/166]].", false],
	],
	"item/156": [
		[0, "", "[[item/156]] is the cheapest ore, with its home in [[system/0]]. Its low value makes it a poor cargo for selling, but it is an ingredient of the [[item/59]] armour plate. Its core is the [[item/167]].", false],
	],
	"item/157": [
		[0, "", "[[item/157]] is a mid-priced ore whose home system is [[system/7]]. Together with its core, the [[item/168]], it is needed to build the [[item/59]] armour plate.", false],
	],
	"item/158": [
		[0, "", "[[item/158]] is a mid-priced ore whose home system is [[system/4]]. It is one of the ores needed for the [[item/85]]. Its core is the [[item/169]].", false],
	],
	"item/159": [
		[0, "", "[[item/159]] is a mid-priced ore whose home system is [[system/18]]. No blueprint uses it, so it is mined only for sale or for the ore medals. Its core is the [[item/170]].", false],
	],
	"item/16": [
		[0, "", "The [[item/16]] is the first EMP blaster. It does no damage to hull or armour; instead each hit drains 3 points of a ship's energy, and a ship whose energy reaches zero is disabled for a while. EMP guns are needed when a target must be stopped rather than destroyed. This model fires every 0.3 s but reaches only 1,200 units. The [[item/17]] and [[item/18]] reach further and drain more per shot.", false],
	],
	"item/160": [
		[0, "", "[[item/160]] is a low-priced ore whose home system is [[system/13]]. It is one of the ores needed for the [[item/85]]. Its core is the [[item/171]].", false],
	],
	"item/161": [
		[0, "", "[[item/161]] is a mid-priced ore whose home system is [[system/19]]. No blueprint uses it. Its core is the [[item/172]].", false],
	],
	"item/162": [
		[0, "", "[[item/162]] is a mid-priced ore whose home system is [[system/14]]. No blueprint uses it. Its core is the [[item/173]].", false],
	],
	"item/163": [
		[0, "", "[[item/163]] is a mid-priced ore whose home system is [[system/5]]. It is the main ingredient of the [[item/54]], which needs 80 t of it, and it is also needed for the [[item/85]]. Its core is the [[item/174]].", false],
	],
	"item/164": [
		[0, "", "[[item/164]] are an ore that never occurs in the asteroid fields of the inhabited systems. Unlike other ores, a crystal asteroid leaves nothing behind when it is shot apart, so the crystals must be drilled. They are the key ingredient of the [[item/85]], which needs 50 of them.", false],
		[25, "", "Every asteroid in the home space of the [[faction/9|Voids]], reached through their wormholes, is made of these crystals.", false],
		[33, "", "[[character/20]] asks [[character/0]] to bring him at least 50 crystals, which he believes hold the secret of the [[faction/9|Voids]]' wormholes.", false],
	],
	"item/165": [
		[0, "", "This core is the rare centre of a class A [[item/154]] asteroid. It is obtained by drilling through all seven layers of such an asteroid, and now and then one drops when a class A asteroid is shot apart. It sells for several times the price of the ore itself, most cheaply in [[system/9]]. It is the most valuable core apart from the [[item/175]].", false],
	],
	"item/166": [
		[0, "", "This core is the rare centre of a class A [[item/155]] asteroid. It is obtained by drilling through all seven layers of such an asteroid, and now and then one drops when a class A asteroid is shot apart. It sells for several times the price of the ore itself, most cheaply in [[system/21]]. It is needed to build the [[item/15]] and, ten at a time, [[item/90]].", false],
	],
	"item/167": [
		[0, "", "This core is the rare centre of a class A [[item/156]] asteroid. It is obtained by drilling through all seven layers of such an asteroid, and now and then one drops when a class A asteroid is shot apart. It sells for several times the price of the ore itself, most cheaply in [[system/0]]. It is the least valuable core.", false],
	],
	"item/168": [
		[0, "", "This core is the rare centre of a class A [[item/157]] asteroid. It is obtained by drilling through all seven layers of such an asteroid, and now and then one drops when a class A asteroid is shot apart. It sells for several times the price of the ore itself, most cheaply in [[system/7]]. Fifteen of them are needed to build the [[item/59]].", false],
	],
	"item/169": [
		[0, "", "This core is the rare centre of a class A [[item/158]] asteroid. It is obtained by drilling through all seven layers of such an asteroid, and now and then one drops when a class A asteroid is shot apart. It sells for several times the price of the ore itself, most cheaply in [[system/4]].", false],
	],
	"item/17": [
		[0, "", "The [[item/17]] drains 5 energy per hit every 0.5 s and reaches 2,000 units, much further than the [[item/16]]. It deals no hull damage. It drains energy at about the same rate as the Mk I but can do so from a safer distance.", false],
	],
	"item/170": [
		[0, "", "This core is the rare centre of a class A [[item/159]] asteroid. It is obtained by drilling through all seven layers of such an asteroid, and now and then one drops when a class A asteroid is shot apart. It sells for several times the price of the ore itself, most cheaply in [[system/18]].", false],
	],
	"item/171": [
		[0, "", "This core is the rare centre of a class A [[item/160]] asteroid. It is obtained by drilling through all seven layers of such an asteroid, and now and then one drops when a class A asteroid is shot apart. It sells for several times the price of the ore itself, most cheaply in [[system/13]].", false],
	],
	"item/172": [
		[0, "", "This core is the rare centre of a class A [[item/161]] asteroid. It is obtained by drilling through all seven layers of such an asteroid, and now and then one drops when a class A asteroid is shot apart. It sells for several times the price of the ore itself, most cheaply in [[system/19]].", false],
	],
	"item/173": [
		[0, "", "This core is the rare centre of a class A [[item/162]] asteroid. It is obtained by drilling through all seven layers of such an asteroid, and now and then one drops when a class A asteroid is shot apart. It sells for several times the price of the ore itself, most cheaply in [[system/14]].", false],
	],
	"item/174": [
		[0, "", "This core is the rare centre of a class A [[item/163]] asteroid. It is obtained by drilling through all seven layers of such an asteroid, and now and then one drops when a class A asteroid is shot apart. It sells for several times the price of the ore itself, most cheaply in [[system/5]].", false],
	],
	"item/175": [
		[0, "", "[[item/175]] is the core of a class A [[item/164]] asteroid. Since crystal asteroids leave nothing when shot apart, the only way to get it is to drill through all seven layers. It sells at a fixed 5,000 credits, more than five times the best price of any other core.", false],
		[25, "", "It can only be found in the home space of the [[faction/9|Voids]].", false],
	],
	"item/18": [
		[0, "", "The [[item/18]] is the strongest EMP blaster: 8 energy per hit every 0.5 s at 2,000 reach, which disables ships noticeably faster than the [[item/17]]. Like the other EMP blasters it causes no hull damage.", false],
	],
	"item/19": [
		[0, "", "The [[item/19]] deals 15 damage every 0.3 s at a reach of 1,400. It hits far harder over time than any laser. The [[item/20]] and [[item/21]] fire faster but reach only 1,000 units.", false],
	],
	"item/2": [
		[0, "", "The [[item/2]] is the top Nirai laser: 7 damage every 0.4 s. Each shot is weaker than those of the Berger lasers, but because it fires about twice as often it deals more damage over time than any of them, including the [[item/8]]. Only the M6 beam lasers ([[item/9]] and its successors) clearly outperform it.", false],
	],
	"item/20": [
		[0, "", "The [[item/20]] fires every 0.2 s for 13 damage. Over time it outdamages the [[item/19]], but its reach is only 1,000 units, so it works best at close range.", false],
	],
	"item/21": [
		[0, "", "The [[item/21]] deals 14 damage every 0.2 s, the highest damage over time of any forward gun. Like the [[item/20]] it reaches only 1,000 units. It is also the rarest blaster in shops.", false],
	],
	"item/22": [
		[0, "", "The [[item/22]] is the weakest gun in the game: 2 damage every 0.4 s at a reach of 1,000. Autocannons fire small, quick rounds; they hit lightly but some models fire very fast. This first model is only a stopgap.", false],
		[6, "", "It is one of the three pieces [[character/2]] offers for free in his hangar at [[station/78]] before the raid on the pirates' hideout, together with the [[item/0]] and the [[item/55]].", false],
	],
	"item/23": [
		[0, "", "The [[item/23]] doubles the damage of the [[item/22]] to 4 per shot and fires a little faster (every 0.3 s), still at 1,000 reach. It is a cheap early weapon.", false],
	],
	"item/24": [
		[0, "", "The [[item/24]] deals 6 damage every 0.3 s at a reach of 1,200. It is a solid mid-range autocannon and matches the damage over time of the [[item/25]], which reaches further.", false],
	],
	"item/25": [
		[0, "", "The [[item/25]] deals 8 damage every 0.4 s and reaches 1,400 units, the longest reach of any autocannon. Over time it deals the same damage as the [[item/24]]. It is never sold ready-made. Its blueprint comes from [[agent/2]] at [[station/20]], and it is built from commodities alone, without ore.", false],
	],
	"item/26": [
		[0, "", "The [[item/26]] fires every 0.2 s for 5 damage at a reach of 1,000. Its fast fire gives it more damage over time than the railguns, at the cost of reach.", false],
	],
	"item/27": [
		[0, "", "The [[item/27]] fires every 0.1 s, the fastest fire rate of any autocannon, for 6 damage per round. Its damage over time is close to that of the best blasters, but its reach of 900 is the shortest of any gun. It is never sold ready-made. Its blueprint comes from [[agent/3]] at [[station/10]], and building it needs [[item/154]] among other goods.", false],
	],
	"item/28": [
		[0, "", "The [[item/28]] is the first thermal gun. Thermal guns fire rapid, light shots at a reach of 1,000; this one deals 3 damage every 0.3 s. Despite its high tech level it is weaker over time than most mid-range blasters and autocannons.", false],
	],
	"item/29": [
		[0, "", "The [[item/29]] deals 4 damage every 0.2 s at 1,000 reach, twice the damage over time of the [[item/28]].", false],
	],
	"item/3": [
		[0, "", "The [[item/3]] is a [[faction/1|Vossk]] laser that deals 7 damage every 0.5 s. That matches the [[item/2]] per shot but fires a little slower, so it falls slightly behind over time. Only shops in [[faction/1|Vossk]] systems stock it.", false],
		[0, "", "[[character/0]]'s [[ship/10]] carries two of them in the opening scene.", false],
	],
	"item/30": [
		[0, "", "The [[item/30]] fires every 0.1 s for 3 damage, the fastest of the thermal guns. Over time it deals more than the [[item/29]], but less than the top blasters such as the [[item/21]].", false],
	],
	"item/31": [
		[0, "", "The [[item/31]] is the basic [[faction/1|Vossk]] rocket and the cheapest secondary ammunition: 60 damage per hit, one launch every 1.2 s, reach 1,200. Rockets fly straight and do not track their target, so they work best at close range. Any rocket or torpedo that hits an asteroid shatters it. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/32": [
		[0, "", "The [[item/32]] is the common unguided rocket: 70 damage per hit, a launch every 0.9 s and a reach of 1,200. It hits harder and launches faster than the [[item/31]] and is sold widely.", false],
	],
	"item/33": [
		[0, "", "The [[item/33]] deals 72 damage and also drains 34 energy, so it can both damage and help disable a target. It reloads slowly (2 s) and reaches 1,000 units. It is never sold ready-made. Its blueprint comes from [[agent/4]] at [[station/43]], and a batch needs only a few cheap commodities.", false],
	],
	"item/34": [
		[0, "", "The [[item/34]] is meant for disabling rather than destroying: it drains 45 energy and deals only 10 damage per hit, with a launch every second. The [[item/35]] drains more and does more damage.", false],
	],
	"item/35": [
		[0, "", "The [[item/35]] drains 60 energy and deals 30 damage per hit, launching every second at 1,000 reach. It disables ships faster than the [[item/34]] while still wearing down their hull.", false],
	],
	"item/36": [
		[0, "", "The [[item/36]] is the basic torpedo. Torpedoes fly straight for their first 1.5 s and then home in on their target. The [[item/36]] deals 70 damage with a 3,000-unit reach, but it is slow and launches only every 3 s. The [[item/38]] doubles its damage.", false],
	],
	"item/37": [
		[0, "", "The [[item/37]] is the fastest torpedo: it deals 100 damage, drains 50 energy and reaches 4,000 units. It launches every 4 s. It is never sold ready-made. Its blueprint comes from [[agent/5]] at [[station/54]], and a batch needs only a few commodities.", false],
	],
	"item/38": [
		[0, "", "The [[item/38]] is the hardest-hitting torpedo, with 140 damage per hit and a reach of 4,000. It is slow in flight and launches every 4 s. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/39": [
		[0, "", "The [[item/39]] is a homing torpedo for disabling ships: it drains 100 energy and does no damage. With a reach of 5,000 it is a cheap way to stop a target from far away. The [[item/40]] adds 120 damage to the same energy drain.", false],
	],
	"item/4": [
		[0, "", "The [[item/4]] is the stronger [[faction/1|Vossk]] laser: 10 damage every 0.6 s. Its damage over time is almost exactly that of the [[item/2]], with heavier but rarer shots than the [[item/3]]. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/40": [
		[0, "", "The [[item/40]] combines 120 damage with a 100-point energy drain in one homing torpedo, with a reach of 5,000 and a launch every 5 s. It costs more than twice as much as the [[item/39]].", false],
	],
	"item/41": [
		[0, "", "The [[item/41]] is the smallest EMP bomb. A bomb is launched with one press and set off with a second; the blast drains energy from every ship within its radius, more strongly near the centre, and spares the ship that launched it. Asteroids are not affected. This model drains up to 80 energy over a radius of 22,000. The [[item/42]] and [[item/43]] are stronger and wider.", false],
		[20, "", "[[faction/0|Terran]] security leaves ten of these bombs at [[station/55]] free of charge, so that [[character/0]] can disable the kidnappers' ship without destroying it.", false],
	],
	"item/42": [
		[0, "", "The [[item/42]] drains up to 150 energy over a radius of 30,000, nearly twice the strength of the [[item/41]] and a much wider blast.", false],
	],
	"item/43": [
		[0, "", "The [[item/43]] is the strongest EMP bomb: it drains up to 300 energy over a radius of 37,000. It recharges a little faster than the [[item/42]] but costs nearly twice as much.", false],
	],
	"item/44": [
		[0, "", "The [[item/44]] is the smallest nuclear bomb. Like an EMP bomb it is launched and then detonated with a second press, but its blast deals real damage: up to 200 within a radius of 20,000, less towards the edge. It also breaks asteroids. The launching ship is not harmed.", false],
	],
	"item/45": [
		[0, "", "The [[item/45]] deals up to 560 damage over a radius of 30,000, almost three times the power of the [[item/44]] in a wider blast.", false],
	],
	"item/46": [
		[0, "", "The [[item/46]] is the most destructive weapon in the game: up to 950 damage over a radius of 40,000. It is never sold ready-made. Its blueprint comes from [[agent/6]] at [[station/61]], and building it needs radioactive goods and explosives among other commodities.", false],
	],
	"item/47": [
		[0, "", "The [[item/47]] is the basic turret. A turret sits in its own mount, which only some hulls have, and can swing all the way round, so it can hit targets beside or behind the ship; while you aim it, the ship flies on by itself. This model deals 6 damage every 0.3 s at 2,000 reach and turns slowly (handling 40).", false],
	],
	"item/48": [
		[0, "", "The [[item/48]] deals 10 damage every 0.2 s at 2,500 reach and turns faster than the [[item/47]] (handling 60). It costs more than three times as much.", false],
	],
	"item/49": [
		[0, "", "The [[item/49]] is the best turret: 12 damage every 0.1 s at 3,000 reach, with the fastest traverse (handling 100). It is also very expensive, costing about twice as much as the [[item/48]]. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/5": [
		[0, "", "The [[item/5]] opens the Berger laser line, which trades fire rate for heavier shots and a slightly longer reach (2,200). It deals 8 damage every 0.9 s, which is less damage over time than the cheaper [[item/2]]. Its advantage is the longer reach.", false],
	],
	"item/50": [
		[0, "", "The [[item/50]] is the basic shield. A shield absorbs incoming damage before armour and hull take any, and it refills by itself over its loading time. The Targe holds only 50 points, but it refills fully in 20 s, faster than any other shield.", false],
	],
	"item/51": [
		[0, "", "The [[item/51]] holds 80 points but needs 46 s to refill completely. It absorbs more than the [[item/50]] in a single fight but recovers much more slowly between attacks.", false],
	],
	"item/52": [
		[0, "", "The [[item/52]] is a [[faction/1|Vossk]] shield that holds 120 points and refills in 58 s. It absorbs much more than the [[item/51]], but the [[item/53]] holds more and refills faster. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/53": [
		[0, "", "The [[item/53]] holds 150 points and refills in 45 s, so it beats the [[item/52]] on both counts. It is the best shield sold in shops.", false],
	],
	"item/54": [
		[0, "", "The [[item/54]] is the strongest shield: 220 points, refilling in 60 s. It is never sold ready-made. Its blueprint comes from [[agent/7]] at [[station/72]], and building it needs a large amount of [[item/163]] along with electronics, nanotech and microchips.", false],
	],
	"item/55": [
		[0, "", "The [[item/55]] is the basic armour plate. A plate adds its points to the ship's armour; after the shield, it takes damage before the hull does, and unlike a shield it does not recharge. The E2 adds 40 points, a large share for a light starter ship such as the [[ship/32]], which has 100 of its own.", false],
		[6, "", "It is one of the three pieces [[character/2]] offers for free in his hangar at [[station/78]] before the raid on the pirates' hideout, together with the [[item/0]] and the [[item/22]].", false],
	],
	"item/56": [
		[0, "", "The [[item/56]] adds 80 armour points, twice the [[item/55]], for a modest price.", false],
	],
	"item/57": [
		[0, "", "The [[item/57]] adds 110 armour points. It is the best plate sold outside [[faction/1|Vossk]] systems.", false],
	],
	"item/58": [
		[0, "", "The [[item/58]] is a [[faction/1|Vossk]] plate that adds 160 armour points, much more than the [[item/57]]. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/59": [
		[0, "", "The [[item/59]] is the best armour plate: it adds 250 points, as much as the base armour of the [[ship/9]] and more than that of any other hull except the [[ship/8]]. It is never sold ready-made. Its blueprint comes from [[agent/8]] at [[station/84]], and building it needs [[item/157]], [[item/168]] and [[item/156]] along with commodities.", false],
	],
	"item/6": [
		[0, "", "The [[item/6]] deals 9 damage every 0.8 s at 2,200 reach. It is a modest step up from the [[item/5]], and its price barely varies between systems.", false],
	],
	"item/60": [
		[0, "", "The [[item/60]] is the weakest of three EMP protection modules, with an EMP defence of 20. None of the three carries a price, and no shop stocks them.", false],
	],
	"item/61": [
		[0, "", "The [[item/61]] is the middle EMP protection module, with an EMP defence of 40, twice that of the [[item/60]]. Like its siblings it carries no price and is not stocked by shops.", false],
	],
	"item/62": [
		[0, "", "The [[item/62]] is the strongest EMP protection module, with an EMP defence of 60. Like the [[item/60]] and [[item/61]] it carries no price and is not stocked by shops.", false],
	],
	"item/63": [
		[0, "", "The [[item/63]] is the basic cargo compressor. A compressor enlarges the hold by a percentage of the hull's own capacity; this one adds 15 %. It is cheap and worthwhile for any trader or miner.", false],
	],
	"item/64": [
		[0, "", "The [[item/64]] enlarges the hold by 25 %, a clear step up from the [[item/63]] at a low price.", false],
	],
	"item/65": [
		[0, "", "The [[item/65]] enlarges the hold by 40 %. On a large freighter it adds as much space as a whole small ship carries.", false],
	],
	"item/66": [
		[0, "", "The [[item/66]] enlarges the hold by 75 %, the most of any compressor sold in shops.", false],
	],
	"item/67": [
		[0, "", "The [[item/67]] doubles the hold, adding 100 % of the hull's capacity: a [[ship/36]] carries 700 t with it. It is never sold ready-made. Its blueprint comes from [[agent/9]] at [[station/90]], and it is built from commodities alone.", false],
	],
	"item/68": [
		[0, "", "The [[item/68]] is the basic tractor beam. Without a tractor beam no floating container can be collected; flying into one does nothing. With the Retractor you keep the container under the crosshair for 4 s, after which it is pulled in. The [[item/69]] needs less time, and the [[item/70]] works automatically.", false],
		[24, "", "[[character/6]] asks [[character/0]] to fit a tractor beam before the first expedition against the [[faction/9|Voids]], so that he can collect the remains of their ships. Until then, shops have a good chance of stocking a Retractor on top of their usual range.", false],
	],
	"item/69": [
		[0, "", "The [[item/69]] works like the [[item/68]] but needs the target under the crosshair for only 3 s before it pulls the container in.", false],
	],
	"item/7": [
		[0, "", "The [[item/7]] deals 10 damage every 0.8 s at 2,200 reach. Over time it equals the [[item/1]], so its value lies in fewer, heavier hits at long range.", false],
	],
	"item/70": [
		[0, "", "The [[item/70]] is the automatic tractor beam: it collects any container in the forward view without having to be aimed and held, which saves a lot of time when looting a battlefield. It is far dearer than the [[item/69]].", false],
	],
	"item/71": [
		[0, "", "The [[item/71]] is the basic booster. A booster gives a short burst of extra speed, then needs time to recharge. This one adds 60 % speed for 3 s and recharges in 8 s.", false],
	],
	"item/72": [
		[0, "", "The [[item/72]] is rated at 80 % extra speed for 4.4 s, with a 10 s recharge. In flight its burst reaches the same top speed as the [[item/71]]; what it adds is a longer burst.", false],
	],
	"item/73": [
		[0, "", "The [[item/73]] more than doubles the gain of the cheaper boosters: 160 % extra speed for 5.6 s, recharging in 12 s.", false],
	],
	"item/74": [
		[0, "", "The [[item/74]] is the strongest booster: 200 % extra speed for 6 s. It needs the longest recharge, 16 s. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/75": [
		[0, "", "The [[item/75]] is the only repair bot in the game and fits in an equipment slot. While you fly it restores one point of hull every 0.6 s and one point of armour plating every second, so damage wears off between fights without docking. It is cheap and stocked by most shops.", false],
	],
	"item/76": [
		[0, "", "The [[item/76]] is the basic steering nozzle. A nozzle adds its figure to the ship's handling, so the ship turns faster. This one adds 20, a small gain for nimble fighters but noticeable on a slow freighter.", false],
	],
	"item/77": [
		[0, "", "The [[item/77]] adds 40 handling, twice the [[item/76]], at a low price.", false],
	],
	"item/78": [
		[0, "", "The [[item/78]] is a [[faction/1|Vossk]] nozzle that adds 70 handling. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/79": [
		[0, "", "The [[item/79]] is a [[faction/1|Vossk]] nozzle that adds 100 handling, enough to make a heavy freighter turn like an agile fighter. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/8": [
		[0, "", "The [[item/8]] is the last and strongest Berger laser: 12 damage per shot every 0.9 s at 2,200 reach. It is the hardest-hitting conventional laser per shot, but the faster [[item/2]] still deals more damage over time. The M6 beam lasers that follow it ([[item/9]] onward) hit more than twice as hard per shot.", false],
	],
	"item/80": [
		[0, "", "The [[item/80]] is the best steering nozzle, adding 130 handling. It lifts the [[ship/36]], the slowest-turning hull, from 45 to 175, more than any fighter has without a nozzle. It is rare in shops.", false],
	],
	"item/81": [
		[0, "", "The [[item/81]] is the basic scanner. A scanner sets how long it takes to lock onto a target such as a ship, a station or an asteroid; the Quickscan needs 4 s. The [[item/82]] locks faster and also shows what other ships carry.", false],
		[2, "", "[[character/2]]'s mining ship, the [[ship/0]], comes fitted with one.", false],
	],
	"item/82": [
		[0, "", "The [[item/82]] locks on in 3 s and shows the cargo carried by targeted ships, which helps when hunting for loot.", false],
	],
	"item/83": [
		[0, "", "The [[item/83]] locks on in 1.8 s, a lock time matched only by the [[item/84]], and also shows targets' cargo.", false],
	],
	"item/84": [
		[0, "", "The [[item/84]] locks on as fast as the [[item/83]] and shows cargo, and it also marks class A asteroids, the only ones that can yield a core (see [[guide/mining]]). It is the scanner of choice for miners.", false],
	],
	"item/85": [
		[0, "", "The [[item/85]] is the only jump drive in the game. With it fitted, you can travel from the star map straight to a station in another system without passing through jump gates. It cannot be used during some missions. It is never sold ready-made, and no agent sells its blueprint. Building it needs [[item/164]], [[item/158]], [[item/160]] and [[item/163]] along with large amounts of commodities.", false],
		[33, "", "Its inventor, [[character/20]], asks [[character/0]] for 50 [[item/164]] for his work on a drive that could reach any place in space.", false],
		[34, "", "In return for the crystals [[character/20]] gives [[character/0]] a copy of the blueprint. The 50 crystals delivered count towards the drive, so only the remaining ingredients have to be supplied.", false],
	],
	"item/86": [
		[0, "", "The [[item/86]] is the basic mining laser. A mining laser is needed to drill ore out of asteroids. Its yield sets how steadily the drill holds its course, and each model also has its own drilling speed (see [[guide/mining]]). This one has a yield of 30 and is hard to keep on track in deep layers.", false],
	],
	"item/87": [
		[0, "", "The [[item/87]] has a yield of 50. It is noticeably steadier than the [[item/86]], though it drills a little slower.", false],
	],
	"item/88": [
		[0, "", "The [[item/88]] is a [[faction/1|Vossk]] mining laser with a yield of 80, the steadiest drill sold in shops. Its drawback is that it is the slowest at extracting ore. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/89": [
		[0, "", "The [[item/89]] has a yield of 60, less steady than the [[item/88]], but it extracts ore much faster than any other laser sold in shops. It suits miners who can keep the drill on track themselves.", false],
	],
	"item/9": [
		[0, "", "The [[item/9]] is the first of the M6 beam lasers. These fire rarely but hit very hard: 27 damage every 1.2 s, at a reach of 2,400, longer than any earlier laser. Accurate aim matters, since a miss wastes a long reload. It is also the base part for building the [[item/11]].", false],
	],
	"item/90": [
		[0, "", "[[item/90]] is the best mining laser: a yield of 100 and the fastest drilling of any model. It is never sold ready-made. Its blueprint comes from [[agent/11]] at [[station/78]], and building it needs large amounts of nanotech, mechanical supplies and hydraulics, plus [[item/155]] and ten [[item/166]].", false],
		[2, "", "The laser on [[character/0]]'s first mining ship is [[character/2]]'s hand-built prototype of this drill.", false],
		[10, "", "When [[character/2]] gives [[character/0]] the [[ship/0]], he keeps the prototype, the only one he has, and suggests a later visit, when he may have built more.", false],
	],
	"item/91": [
		[0, "", "The [[item/91]] houses 3 passengers. Cabins are needed for [[job/11]] jobs, and the space of several cabins adds up. The [[item/92]] and [[item/93]] hold more.", false],
	],
	"item/92": [
		[0, "", "The [[item/92]] houses 5 passengers, two more than the [[item/91]].", false],
	],
	"item/93": [
		[0, "", "The [[item/93]] houses 10 passengers, twice the [[item/92]], which opens up the larger passenger jobs.", false],
	],
	"item/94": [
		[0, "", "The [[item/94]] is the basic cloak. While a cloak is active, other ships cannot see you. This one hides the ship for 15 s and then needs 18 s to recharge. Time spent cloaked counts towards the [[medal/19]] medal.", false],
	],
	"item/95": [
		[0, "", "The [[item/95]] is a [[faction/1|Vossk]] cloak that hides the ship for 28 s and recharges in 32 s, almost twice the cover of the [[item/94]]. Only shops in [[faction/1|Vossk]] systems stock it.", false],
	],
	"item/96": [
		[0, "", "The [[item/96]] is the best cloak: it hides the ship for 46 s and recharges in only 40 s, so it can stay active more often than not. It is never sold ready-made. Its blueprint comes from [[agent/10]] at [[station/59]].", false],
	],
	"job/0": [
		[0, "", "A courier job asks you to carry a load of sealed freight containers to another station. The containers are loaded into your hold when you accept, so you need enough free space; they cannot be sold. The job is done when you dock at the destination with the freight aboard. Pirates sometimes lie in wait for couriers. Delivered freight counts towards [[medal/5]].", false],
	],
	"job/1": [
		[0, "", "In a defence job a station is about to be attacked, and you are hired to help its own fighters drive the raiders off. The attackers are usually pirates, otherwise ships of the rival race. Fly to the station and destroy every attacker; kills by the allied fighters count too. More difficult jobs bring more attackers.", false],
	],
	"job/10": [
		[0, "", "In an intercept job a convoy of two or three freighters with illegal cargo lies far out from a station, guarded by fighters. Follow the waypoints and destroy the freighters. Their guards wait along the way and around the convoy.", false],
	],
	"job/11": [
		[0, "", "A passenger job asks you to take a group of people to another station. You need cabins with enough room for all of them when you accept; while they are aboard, the cabins cannot be removed and the hull cannot be changed. Dock at the destination to deliver them. The base reward is lower, but each passenger adds to it. Delivered passengers count towards [[medal/18]].", false],
	],
	"job/12": [
		[0, "", "A challenge is a shooting contest offered by another pilot in the Space Lounge. You both fly out from the same station to a group of pirates spread along a route, and whoever shoots down more of them wins. The rival cannot be destroyed and hits as hard as your own guns. You are paid only if you score more kills; there is always an odd number of pirates, so there are no ties.", false],
	],
	"job/2": [
		[0, "", "A protection job sends you to guard mining ships working an asteroid field near a station. Raiders arrive and make for the station and the miners. Destroy all of them before they can wipe out the miners; if every mining ship is lost, the job fails.", false],
	],
	"job/3": [
		[0, "", "In a recovery job, stolen goods are being carried by one of a group of pirate ships near a station. You must take the container back without destroying it: disable the carrier with an EMP weapon and pull the container in with a tractor beam. A scanner that shows cargo helps you find the right ship. The container is lost if the carrier is destroyed or your hold has no room for it. Once you have it, return to the station where you took the job to be paid. Recovery pays double.", false],
	],
	"job/4": [
		[0, "", "Pirate hunting means clearing out a pirate hideout near a station. The pirates wait in the asteroid field or at a route of two or three waypoints, and only stir when they see you. Follow the waypoints and destroy every pirate. Higher difficulty means more pirates.", false],
	],
	"job/5": [
		[0, "", "A salvage job is a rescue: a hostage is held aboard one of a group of ships near a station. As in a recovery job, disable the kidnapper's ship with EMP and use a tractor beam to take the hostage aboard; destroying that ship ends the job. Then bring the hostage back to the station where you accepted it. Salvage pays double.", false],
	],
	"job/6": [
		[0, "", "A wanted job names a dangerous criminal who has been seen near a station. The target waits at a point far out and only reacts once you come into sight. It is much tougher than an ordinary pirate, and grows tougher with the job's difficulty and your pilot level. Destroy it to collect the bounty.", false],
	],
	"job/7": [
		[0, "", "Junk removal asks you to clear a cloud of space junk near a station within about two minutes. Every piece must be destroyed before time runs out; at higher difficulty a few pirates join in. It pays less than most jobs, but it is quick, and destroyed junk counts towards [[medal/10]].", false],
	],
	"job/8": [
		[0, "", "A purchase job comes from a buyer in the Space Lounge who wants a quantity of one particular item. Get the goods, from shops, traders or mining, and dock at the buyer's station again with them in the hold. The goods are handed over and you are paid half the usual job reward plus three times the goods' average value, so a buyer usually pays far more than any shop. Buyers appear from [[step/16]] on.", false],
	],
	"job/9": [
		[0, "", "An escort job asks you to protect a convoy of five freighters near a station. As the freighters fly on, attackers waiting along their route close in. Destroy all the attackers. If every freighter is lost, the job fails. Escorts pay a fifth more than most jobs.", false],
	],
	"medal/0": [
		[0, "", "[[character/0]] holds this medal from the start of the game, for his past service. There is nothing to do to earn it.", false],
	],
	"medal/1": [
		[0, "", "Awarded for reaching a station with very little hull left. The check is made as you approach, before the dock repairs the ship, and it uses the hull's own strength, not the armour plate. The lower the remaining share, the better the tier.", false],
	],
	"medal/10": [
		[0, "", "Awarded for destroying space junk, as found in [[job/7]] jobs. Every piece you shoot counts.", false],
	],
	"medal/11": [
		[0, "", "Awarded for the number of different stations you have docked at.", false],
	],
	"medal/12": [
		[0, "", "Awarded for the number of different systems you have visited. Hidden systems count once you reach them.", false],
	],
	"medal/13": [
		[0, "", "Awarded for the number of blueprints you own. Blueprints are bought from agents in the Space Lounge; see [[guide/blueprints]].", false],
	],
	"medal/14": [
		[0, "", "Awarded for the number of different blueprints you have finished at least once. Building the same item again does not add to it.", false],
	],
	"medal/15": [
		[0, "", "Awarded for the time you have spent playing, in hours. The game counts the time spent in flight.", false],
	],
	"medal/16": [
		[0, "", "Awarded for the number of freelance jobs completed. Failed and abandoned jobs do not count.", false],
	],
	"medal/17": [
		[0, "", "Awarded for the number of times you have travelled through a jump gate. Jumps with a jump drive do not count.", false],
	],
	"medal/18": [
		[0, "", "Awarded for the number of passengers delivered on [[job/11]] jobs. More cabin space means larger groups.", false],
	],
	"medal/19": [
		[0, "", "Awarded for the total minutes spent cloaked. Fit a cloaking device and use it whenever it is charged.", false],
	],
	"medal/2": [
		[0, "", "Awarded for mining different kinds of ore. Each kind counts once, however much you mine of it. Since fields hold the ores whose home lies nearby, you will need to mine in several parts of the galaxy.", false],
	],
	"medal/20": [
		[0, "", "Awarded for the number of EMP bombs and nukes launched.", false],
	],
	"medal/21": [
		[0, "", "Awarded for the tonnes of [[item/131]] collected with a tractor beam from wrecks and disabled ships.", false],
	],
	"medal/22": [
		[0, "", "A single-tier medal for flying with no weapons, or with no equipment, fitted at all, checked when you next dock. It cannot be earned in the early story: until [[step/8]] the ship always counts as armed.", false],
	],
	"medal/23": [
		[0, "", "Awarded for the number of primary weapons fitted at once, checked when you dock. A hull with many primary slots is needed for the higher tiers. Like [[medal/22]], it only counts from [[step/8]] on.", false],
	],
	"medal/24": [
		[0, "", "Awarded for the tonnes of cargo taken from wrecks and disabled ships with a tractor beam.", false],
	],
	"medal/25": [
		[0, "", "Awarded for the most credits you have held at one time. Spending money later does not take it away.", false],
	],
	"medal/26": [
		[0, "", "Awarded for talking to guests in the Space Lounge who have something to offer. Each guest counts once, the first time you speak to them.", false],
	],
	"medal/27": [
		[0, "", "Awarded for the number of wingmen you have hired in the Space Lounge, counting every pilot in each group.", false],
	],
	"medal/28": [
		[0, "", "A single-tier medal for turning one of the four great races against you, by pushing one of the two standing scales past 60 in either direction. See [[guide/combat]].", false],
	],
	"medal/29": [
		[0, "", "Awarded for the number of asteroids destroyed by your weapons. Asteroids broken by mining do not count.", false],
	],
	"medal/3": [
		[0, "", "Awarded for mining different kinds of core. Cores only come from drilling through all seven layers of a class A asteroid, so this needs patience and a good mining laser as well as travel.", false],
	],
	"medal/30": [
		[0, "", "A single-tier medal awarded for completing the story.", false],
	],
	"medal/31": [
		[0, "", "Awarded for the most free cargo space you have had at one time. A large hull with cargo compression units and an empty hold earns the higher tiers.", false],
	],
	"medal/32": [
		[0, "", "Awarded for the number of offers you have turned down with No, thanks in the Space Lounge.", false],
	],
	"medal/33": [
		[0, "", "Awarded for the number of times you have asked a guest in the Space Lounge to repeat an offer with How was that again?", false],
	],
	"medal/34": [
		[0, "", "Awarded for accepting jobs at other stations without first asking the client whether they will be difficult.", false],
	],
	"medal/35": [
		[0, "", "Awarded for accepting jobs at other stations without first asking the client to show the destination on the map.", false],
	],
	"medal/36": [
		[0, "", "Awarded automatically once you hold every other medal, in any tier. Holding them all also has other rewards; see [[guide/medals]].", false],
	],
	"medal/4": [
		[0, "", "Awarded for the number of ships you have destroyed, counted over the whole game. Pirates, enemies and job targets all count.", false],
	],
	"medal/5": [
		[0, "", "Awarded for the tonnes of freight delivered on [[job/0]] jobs. Large courier loads count for more, so a big hold helps.", false],
	],
	"medal/6": [
		[0, "", "Awarded for the total tonnes of ore mined over the whole game.", false],
	],
	"medal/7": [
		[0, "", "Awarded for the number of cores mined over the whole game. Each class A asteroid drilled to the end gives one.", false],
	],
	"medal/8": [
		[0, "", "Awarded for the tonnes of booze bought from station shops. Every system's local drink counts.", false],
	],
	"medal/9": [
		[0, "", "Awarded for owning different kinds of booze. Kinds are counted when you buy them from traders in the Space Lounge or collect them from wrecks with a tractor beam.", false],
	],
	"ship/0": [
		[0, "", "The [[ship/0]] is the weakest hull in the ship table: 95 armour, a 25 t hold, one primary and one secondary mount and three equipment slots. Its handling of 140 is respectable for a starter, but the [[ship/32]], the cheapest hull on sale, has the same mounts with more armour, cargo space and agility. No dealer ever offers the [[ship/0]]; it reaches the player only through the story.", false],
		[2, "", "[[character/2]] owns this patched-up former [[faction/8|pirate]] ship and puts [[character/0]] in it at [[station/78]], painted in pirate colours and fitted with a mining laser and a [[item/81]] but no guns. The laser is his own prototype, the design he later sells as [[item/90]].", false],
		[10, "", "After the raid on the pirates' hideout, [[character/2]] gives [[character/0]] the ship for good, with a stronger drive for travel between the planets of the system, but keeps the prototype laser. He keeps flying it after reaching [[faction/0|Terran]] space.", false],
		[18, "", "At [[station/98]], [[character/1]] has the hull repainted in [[faction/0|Terran]] colours so that patrols stop taking it for a pirate ship.", false],
	],
	"ship/1": [
		[0, "", "The [[ship/1]] is the cheapest hull with four secondary mounts, and it also has a turret mount, two primary guns and seven equipment slots. Armour (192) and hold (65 t) are solid. Its handling of 106 is slow, so it fights best with torpedoes and the turret. For a little more money the [[ship/9]] offers much more armour and agility but no turret and only two secondary mounts.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/10": [
		[0, "", "The [[ship/10]] is [[character/0]]'s own ship in the opening scene, armed with two [[item/3]] lasers. It joins solid armour (200) and a 100 t hold to four secondary mounts and a handling of 150, which makes it far nimbler than the [[ship/11]], the hull nearest to it in list price. Its weak point is the small number of equipment slots: only five. Ordinary dealers never offer it.", false],
		[2, "", "A hyperdrive failure carries [[character/0]] to [[station/78]], where [[character/2]] recovers the wreck and strips it for parts. It never returns to his hands.", false],
	],
	"ship/11": [
		[0, "", "The [[ship/11]] is a well-equipped heavy freighter: a 180 t hold, 210 armour, a turret mount, two primary and two secondary mounts and eight equipment slots. Its handling of 75 is poor. Against the cheaper [[ship/7]] it gives up 60 t of cargo space for an extra secondary mount and an extra equipment slot.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/12": [
		[0, "", "The [[ship/12]] is a fighter built around its secondary weapons: three secondary mounts, two primary guns, six equipment slots, 175 armour and a handling of 132. Its 30 t hold is very small, so it is poorly suited to trade or mining. The [[ship/30]] costs more and offers less armour and one secondary mount fewer.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/16": [
		[0, "", "The [[ship/16]] is a missile-heavy fighter with four secondary mounts, two primary guns, ten equipment slots, 180 armour and a handling of 120. Its 45 t hold is small. The dearer [[ship/21]] adds two more primary guns and an equipment slot.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/17": [
		[0, "", "The [[ship/17]] carries four primary guns, two secondary mounts and ten equipment slots. For a ship of its price its armour (145), hold (65 t) and handling (95) are weak, so it relies on its equipment, especially shields and armour plating. The cheaper [[ship/19]] has more armour and cargo space with one equipment slot fewer.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/18": [
		[0, "", "The [[ship/18]] is a small, agile ship (handling 145) with eight equipment slots; no cheaper hull has as many. Its armour of 115 and its 28 t hold are poor, and it has only two primary and two secondary mounts. It suits a pilot who relies on shields, a cloak and other equipment rather than armour.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/19": [
		[0, "", "The [[ship/19]] is a heavy gunship with four primary mounts, two secondary mounts, nine equipment slots, 225 armour and a 105 t hold. Its handling of 90 is slow. It is the only ship with four forward guns and a hold of more than 100 t.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/2": [
		[0, "", "The [[ship/2]] is an agile all-rounder among the cheap hulls: 155 armour, a 52 t hold, one primary and two secondary mounts, four equipment slots and a handling of 150. It matches the [[ship/35]] on everything but cargo space, where it carries 12 t more. Pilots who want a second gun look at the [[ship/5]] or the [[ship/6]] instead.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/20": [
		[0, "", "The [[ship/20]] is a light fighter that packs six equipment slots into a small, quick hull (handling 155). It carries two primary guns but only one secondary mount, 125 armour and a 25 t hold, which ties with the [[ship/0]] for the smallest in the table. It suits pilots who want shields, boosters and other equipment early and do not plan to haul cargo.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/21": [
		[0, "", "The [[ship/21]] is the cheapest hull with four primary and four secondary mounts. It adds eleven equipment slots, 195 armour and a 70 t hold. Its handling of 100 is average. It is a full combat ship one step below the [[ship/29]].", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/22": [
		[0, "", "The [[ship/22]] has the largest hold of any ship costing over a million credits (130 t), together with three primary and three secondary mounts, nine equipment slots and a handling of 118. Its armour of 160 is low for its price. It suits pilots who trade and fight in the same ship.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/23": [
		[0, "", "The [[ship/23]] is the cheapest hull with a turret mount, and its 205 armour is the highest of any ship under 100,000 credits. It adds two primary and two secondary mounts, five equipment slots, a 55 t hold and a handling of 128, which makes it a sturdy mid-range all-rounder. Its main limit is the small number of equipment slots.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/24": [
		[0, "", "The [[ship/24]] is an armed trader: three primary guns, two secondary mounts, a turret, eight equipment slots and a 95 t hold. Its armour of 170 is average, while its handling of 125 is good for a ship that carries so much. It covers trade, mining and combat equally well.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/25": [
		[0, "", "The [[ship/25]] is a missile carrier: four secondary mounts, eight equipment slots and a handling of 130, but only one primary gun. Its 124 armour and 52 t hold are weak for its price, so it depends on torpedoes and shields. The [[ship/1]] offers the same number of secondary mounts plus a turret for a third of the price, with fewer equipment slots.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/26": [
		[0, "", "The [[ship/26]] is the cheapest hull with seven equipment slots. Otherwise it is an average all-rounder: 152 armour, a 64 t hold, two primary and two secondary mounts and a handling of 108. It suits pilots who want a full set of equipment before they can afford a heavier ship.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/27": [
		[0, "", "The [[ship/27]] is the cheapest hull with three primary mounts. It pairs them with 176 armour, two secondary mounts, six equipment slots and a 50 t hold. Its handling of 113 is on the slow side, so it trades blows rather than outturning its enemies.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/28": [
		[0, "", "The [[ship/28]] is the most complete all-rounder on sale: three primary and four secondary mounts, a turret, twelve equipment slots and a 110 t hold. No other buyable ship has a turret and so many equipment slots. Its armour of 195 is good and its handling of 92 is slow. The [[ship/29]] fights better but carries much less.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/29": [
		[0, "", "The [[ship/29]] is the most expensive ship that ordinary dealers sell and their best fighter: four primary and four secondary mounts, twelve equipment slots, 240 armour and a handling of 118. Its 75 t hold is modest, and it has no turret. Only the [[ship/8]] outclasses it in combat.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/3": [
		[0, "", "The [[ship/3]] is a balanced early all-rounder: two primary and two secondary mounts, five equipment slots, 135 armour and a 55 t hold. Its handling of 112 is slow for a small ship. It costs about the same as the [[ship/6]], which turns much faster but has less armour, less cargo space and one secondary mount fewer.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/30": [
		[0, "", "The [[ship/30]] is a middle-of-the-road fighter: 165 armour, a 45 t hold, two primary and two secondary mounts, six equipment slots and a handling of 128. It has no particular strength for its price; the cheaper [[ship/12]] has more armour and an extra secondary mount, and the [[ship/23]] adds a turret.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/31": [
		[0, "", "The [[ship/31]] is a light freighter with a 110 t hold, a turret mount, two primary guns and six equipment slots. Its armour (156), single secondary mount and handling of 102 are modest. It competes with the cheaper [[ship/33]], which has slightly less cargo space and one gun fewer but more armour and better handling.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/32": [
		[0, "", "The [[ship/32]] is the cheapest hull any dealer sells and the usual first purchase. It is small and thinly protected (100 armour, 30 t hold, one primary and one secondary mount, three equipment slots), but with a handling of 160 only the [[ship/4]] turns faster. Compared with the [[ship/0]] it adds a little armour and cargo space and handles better. The [[ship/35]] costs about 8,000 credits more and brings far better armour, a second secondary mount and a fourth equipment slot.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/33": [
		[0, "", "The [[ship/33]] is the cheapest hull with more than 100 t of cargo space (108 t), and it adds a turret mount, 176 armour and six equipment slots. With only one primary gun and a handling of 112 it is a trader that can defend itself rather than a fighter. The [[ship/31]] is a close rival with a second gun and a slightly bigger hold, but it is weaker and slower.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/34": [
		[0, "", "The [[ship/34]] is a gunship with four primary mounts, one secondary mount, six equipment slots, a 60 t hold and a handling of 130. Compared with the cheaper [[ship/4]] it gives up armour (135 against 170) and agility for more cargo space and an extra equipment slot.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/35": [
		[0, "", "The [[ship/35]] is a light fighter at the bottom of the price list. For the money it offers good armour (155), one primary and two secondary mounts, four equipment slots and a quick handling of 150, but only a 40 t hold. The [[ship/2]] is almost the same ship with 12 t more cargo space for a few thousand credits more, while the [[ship/5]] trades agility for more armour, cargo and a second gun.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/36": [
		[0, "", "The [[ship/36]] is the largest freighter in the game, with a 350 t hold. It has no primary mount at all and must rely on its four secondary mounts and a turret for defence. Seven equipment slots and 200 armour are good, but its handling of 45 is the lowest in the table. The [[ship/7]] carries less but keeps two forward guns and turns better.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/4": [
		[0, "", "The [[ship/4]] is the cheapest hull with four primary mounts, and with a handling of 162 it is the most agile ship in the game. Its 170 armour is good for its price. The cost is a 38 t hold, a single secondary mount and five equipment slots, so it is a pure dogfighter. The [[ship/34]] also carries four guns, with more cargo space and equipment slots but less armour and agility.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/5": [
		[0, "", "The [[ship/5]] is the cheapest hull with two primary mounts, and its 170 armour is high for its price. A 60 t hold makes it useful for early trading and mining as well. The drawbacks are a single secondary mount, only four equipment slots and a sluggish handling of 115. Pilots who value agility over armour pick the [[ship/2]] or [[ship/35]] at a similar price.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/6": [
		[0, "", "The [[ship/6]] is a light, fast fighter with two primary mounts, one secondary mount, five equipment slots and a handling of 148. Its armour of 105 is very thin; only the [[ship/0]] and the [[ship/32]] have less, so it relies on speed rather than toughness. At almost the same price the [[ship/3]] offers more armour, more cargo space and a second secondary mount, at the cost of handling.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/7": [
		[0, "", "The [[ship/7]] is a heavy freighter with a 240 t hold, 220 armour, a turret mount, two primary guns, one secondary mount and seven equipment slots. With a handling of 65 it is slow to turn. Compared with the [[ship/36]] it gives up 110 t of cargo space for forward guns and better handling; the dearer [[ship/11]] adds an equipment slot and a second secondary mount.", false],
		[0, "", "Any dealer outside [[faction/1|Vossk]] systems may stock it.", false],
	],
	"ship/8": [
		[0, "", "The [[ship/8]] is a restored [[faction/9|Void]] fighter and the strongest ship in the game. Its 450 armour is almost double that of any other hull, it has four primary and four secondary mounts and fifteen equipment slots, and its handling of 155 is among the best. The only weakness is a 30 t hold. Its list price of over eight million credits is nearly twice that of the [[ship/29]].", false],
		[0, "", "Ordinary dealers do not sell it. It is offered only at [[station/10]], as a prototype, once the player holds every medal in gold (see [[guide/medals]]).", false],
	],
	"ship/9": [
		[0, "", "The [[ship/9]] is the only ship that [[faction/1|Vossk]] dealers sell, and they sell nothing else. Its 250 armour is the highest of any hull except the [[ship/8]], and it combines this with a quick handling of 152, two primary and two secondary mounts, seven equipment slots and a 65 t hold. At its price it is the toughest fighter available, though it lacks the turret and extra mounts of the [[ship/1]].", false],
		[36, "", "[[character/7]] explains that [[faction/1|Vossk]] ships are normally flown only by their own race; this ship is the exception, a design adapted so that it can be sold to other races.", false],
	],
	"station/0": [
		[0, "", "[[station/0]] carries the jump gate of [[system/0]]. The waiting period of [[step/13]] is filed under this station, but that step is completed by finishing lounge jobs anywhere, and nothing happens here.", false],
	],
	"station/10": [
		[0, "", "[[station/10]] is the only station of [[system/6]] and carries its jump gate. Freelance jobs never send you here. The agent [[agent/3]] sells a blueprint in its lounge, and once every medal is gold the station offers a prototype [[ship/8]].", false],
		[23, "", "The station is the secret research base of Deep Science, led by [[character/6]]. [[character/0]] arrives there with [[character/5]] in [[step/23]] and returns several times: to plan the expedition to the Voids, to meet [[character/20]] and to deliver his crystals.", false],
	],
	"station/18": [
		[0, "", "[[station/18]] is a modest Vossk station in [[system/3]]. The agent [[agent/12]] sells the coordinates of [[system/0]] in its lounge.", false],
	],
	"station/20": [
		[0, "", "[[station/20]] carries the jump gate of [[system/4]]. The Midorian agent [[agent/2]] sells a weapon blueprint in its lounge.", false],
	],
	"station/22": [
		[0, "", "[[station/22]] is the most advanced station in [[system/4]].", false],
		[38, "", "In [[step/38]] the convoy with the Nivelian explosives is spotted near the station under a Midorian fighter escort. [[character/0]] has to drive off the escort without destroying the convoy.", false],
	],
	"station/26": [
		[0, "", "[[station/26]] is a top-tech Vossk station in [[system/5]]. The Bobolian agent [[agent/13]] sells the coordinates of [[system/1]] in its lounge.", false],
	],
	"station/27": [
		[36, "", "Near [[station/27]], [[character/7]] and [[character/0]] raid a pirate hideout in [[step/36]]; whoever destroys more pirates wins.", false],
		[37, "", "[[character/0]] wins and earns the right to escort the Vossk freighter. From here he reports back to [[character/1]].", false],
	],
	"station/29": [
		[35, "", "[[station/29]] is the station of the Vossk commander [[character/7]], who has agreed to provide a K'Sarr freighter for the attack on the Voids. [[character/0]] meets him here in [[step/35]].", false],
		[36, "", "[[character/7]] refuses to let anyone but a Vossk fly the freighter and challenges [[character/0]] to prove himself as an escort pilot.", false],
	],
	"station/3": [
		[0, "", "[[station/3]] is a high-tech Nivelian station in the hidden [[system/0]] system. Its lounge is home to the agent [[agent/0]], who sells a weapon blueprint.", false],
	],
	"station/30": [
		[34, "", "[[character/1]] waits at [[station/30]] in [[step/34]] with a plan against the Void mother ship.", false],
		[35, "", "The plan is to fly a heavy freighter full of Nivelian nuclear explosives into the mother ship.", false],
		[39, "", "The recovered explosives arrive here and are loaded into the Vossk freighter. In [[step/39]] [[character/1]] explains the final operation.", false],
	],
	"station/43": [
		[0, "", "[[station/43]] is a small Terran station in [[system/8]]. The agent [[agent/4]] sells a cheap rocket blueprint in its lounge.", false],
	],
	"station/48": [
		[24, "", "Void ships have been sighted near [[station/48]]. In [[step/24]] [[character/0]] brings [[character/6]] here to watch them and to collect wreckage with a tractor beam.", false],
		[25, "", "At the end of the salvage a wormhole swallows the ship of [[character/0]] with [[character/6]] aboard.", false],
		[27, "", "When they come back through another wormhole, Void fighters follow them, and [[character/0]] has to destroy them here before returning to [[station/10]].", false],
	],
	"station/54": [
		[0, "", "[[station/54]] is a top-tech Vossk station in [[system/10]], a system that only a jump drive can reach. The Vossk agent [[agent/5]] sells a missile blueprint in its lounge.", false],
	],
	"station/55": [
		[0, "", "[[station/55]] carries the jump gate of [[system/11]].", false],
		[19, "", "Pirates holding [[character/5]] for ransom are found near the station. Deep Science leaves EMP bombs in its hangar for [[character/0]].", false],
		[22, "", "After the rescue [[character/0]] meets the freed officer at the station and receives the coordinates of [[system/6]].", false],
	],
	"station/56": [
		[18, "", "[[station/56]] is the meeting point where [[character/0]] is supposed to pick up a Deep Science officer in [[step/18]].", false],
		[19, "", "The officer never arrives. Instead a message from [[character/1]] reports that pirates have kidnapped him.", false],
	],
	"station/59": [
		[0, "", "[[station/59]] is a small station in the Vossk system [[system/20]]. Its lounge hosts a Terran, the agent [[agent/10]], who sells a cloaking device blueprint.", false],
	],
	"station/61": [
		[0, "", "[[station/61]] is one of only two stations in [[system/12]]. The Multipod agent [[agent/6]] sells a nuclear weapon blueprint in its lounge.", false],
	],
	"station/65": [
		[0, "", "[[station/65]] carries the jump gate of [[system/13]]. The Cyborg agent [[agent/14]] sells the coordinates of [[system/10]] in its lounge.", false],
	],
	"station/72": [
		[0, "", "[[station/72]] is a small Terran station in the safe [[system/14]] system. The agent [[agent/7]] sells a shield blueprint in its lounge.", false],
	],
	"station/76": [
		[11, "", "[[station/76]] is a station in [[system/15]] that has stopped answering calls. In [[step/11]] [[character/3]] sends [[character/0]] to find out why.", false],
		[12, "", "The station is unharmed. Its crew is simply in no state to work, thanks to a load of neuro-algae delivered by the dealer [[character/4]], an old acquaintance of [[character/0]].", false],
	],
	"station/78": [
		[0, "", "[[station/78]] is the small mining station of the Nivelian ore trader [[character/2]] in [[system/15]]. The story begins in its orbit.", false],
		[1, "", "The damaged ship of [[character/0]] drifts here on autopilot, and [[character/2]] takes it in, pilot and all.", false],
		[2, "", "[[character/2]] strips the wreck and puts [[character/0]] to work mining ore in the nearby asteroids with [[ship/0]].", false],
		[8, "", "After escaping a pirate raid, [[character/0]] fits his first weapon and helps [[character/2]] destroy the pirate hideout near the station.", false],
		[10, "", "[[character/2]] then gives him the ship and sends him on to [[station/79]].", false],
		[0, "", "Later in the game [[character/2]] sells the blueprint of his mining drill in the station's lounge.", false],
	],
	"station/79": [
		[0, "", "[[station/79]] is a station in [[system/15]] and the seat of its commander, [[character/3]].", false],
		[10, "", "[[character/2]] sends [[character/0]] here in [[step/9]] to meet [[character/3]], a human who may help him reach Terran space.", false],
		[11, "", "[[character/3]] explains the [[faction/3|Mido Confederation]] and asks him to check on [[station/76]] in return for his help.", false],
		[13, "", "After the report from [[station/76]], [[character/3]] promises to put him in touch with a Terran convoy due at the station.", false],
		[15, "", "When the convoy arrives in [[step/14]], it mistakes [[character/0]] for a pirate, disables his ship and takes him aboard.", false],
	],
	"station/8": [
		[0, "", "[[station/8]] is a Terran station in the hidden [[system/1]] system. The Nivelian agent [[agent/1]] sells a blueprint in its lounge.", false],
	],
	"station/84": [
		[0, "", "[[station/84]] is a Terran station in [[system/16]]. The Vossk agent [[agent/8]] sells a blueprint for Vossk armour in its lounge.", false],
	],
	"station/88": [
		[0, "", "[[station/88]] is a small Nivelian station in [[system/17]]. The Vossk agent [[agent/15]] sells the coordinates of [[system/21]] in its lounge.", false],
	],
	"station/90": [
		[0, "", "[[station/90]] carries the jump gate of [[system/18]]. The agent [[agent/9]] sells a cargo compressor blueprint in its lounge.", false],
	],
	"station/91": [
		[28, "", "Void activity is reported near [[station/91]] in [[step/28]]. [[character/0]] fights his way to a wormhole here to carry a probe to the Void mother ship.", false],
		[31, "", "Back from the Void sector, [[character/0]] receives a call from [[character/1]] here, inviting him to [[station/98]].", false],
	],
	"station/98": [
		[15, "", "[[station/98]] is a Terran station in [[system/19]]. The cruiser that arrested [[character/0]] brings him here, and he finds his old friend [[character/1]] in charge.", false],
		[16, "", "Void fighters attack the station during their conversation, and [[character/0]] helps to drive them off.", false],
		[18, "", "[[character/1]] briefs him on the Voids and recruits him for Deep Science.", false],
		[32, "", "In [[step/31]] [[character/1]] fits the ship of [[character/0]] with the early-warning system and tells him about [[character/20]].", false],
		[44, "", "After the victory [[character/0]] and [[character/1]] celebrate at the station, and [[character/6]] joins them.", false],
		[45, "", "The next morning [[character/6]] is gone, leaving a note and a final payment from Deep Science.", false],
	],
	"step/0": [
		[0, "", "[[character/0]] chases a band of [[faction/8|pirates]] through an asteroid belt to collect the bounty on their heads. You must find and destroy every pirate ship.", false],
		[1, "", "Once the pirates are dealt with, Keith sets course for Eden Prime, where Admiral Smith has asked to see him about a special assignment. As the hyperdrive starts, a parting shot damages his ship. The drive fails, life support is crippled, and the autopilot carries the unconscious pilot towards the nearest station, [[station/78]].", false],
	],
	"step/1": [
		[1, "", "The autopilot has brought Keith's crippled ship into orbit around [[station/78]], with its pilot unconscious on board.", false],
		[2, "", "Keith wakes on a small mining station run by [[character/2]], a [[faction/2]] ore trader. Gunant has taken the ship apart and claims it by right of salvage. He laughs at the idea of reaching Eden Prime, which lies at the far end of the galaxy, and is surprised that Keith has never heard of the Voids, hostile beings that now appear even in the [[system/15]] system.", false],
		[2, "", "Keith has no money and no ship, so he must work for Gunant by mining ore in an unarmed vessel.", false],
	],
	"step/10": [
		[10, "", "Keith flies to [[station/79]] to meet [[character/3]].", false],
		[11, "", "Norris explains that [[system/15]] lies in a recently discovered sector. Terran and Nivelian exiles settled it during the Nivelian Civil War and founded an independent confederation. The Terrans accept it, but the Nivelians still claim the system, so there is fighting on its outskirts.", false],
		[11, "", "Norris offers to put Keith in touch with the Terran Space Fleet in return for a favour: contact with the station [[station/76]] has been lost, and an experienced pilot must find out why.", false],
	],
	"step/11": [
		[11, "", "Keith flies to [[station/76]] to investigate its silence. The station looks intact, with no sign of a fight, so he docks.", false],
		[12, "", "Inside, Keith runs into [[character/4]], a notorious dealer he knew long ago. Mkkt has brought in a load of neuro-algae, and the whole crew is too intoxicated to work the communications. Keith leaves as soon as he can.", false],
	],
	"step/12": [
		[12, "", "Keith returns to [[station/79]] to report.", false],
		[13, "", "Norris is appalled and promises to deal with the dealer. A Terran military convoy is heading for Kernstal and will give Keith his chance to contact the fleet. Until it arrives, Norris suggests Keith take paid work in the Space Lounge (see [[guide/lounge]]).", false],
	],
	"step/13": [
		[13, "", "While waiting for the convoy, Keith must complete two freelance jobs from the Space Lounge (see [[guide/jobs]]).", false],
		[14, "", "Norris reports that the Terran convoy has entered the system and is heading for [[station/79]]. Keith sets off to meet it.", false],
	],
	"step/14": [
		[14, "", "Near [[station/79]] Keith finds the Terran convoy and a few pirates. He moves in to drive the pirates off.", false],
		[15, "", "In his former pirate ship, Keith is taken for one of the raiders. The convoy disables his ship with EMP weapons and arrests him. He is taken aboard a Terran cruiser bound for [[station/98]] in Terran space.", false],
	],
	"step/15": [
		[15, "", "Keith arrives at [[station/98]] as a prisoner of the convoy.", false],
		[16, "", "The officer in charge is [[character/1]], an old friend of Keith's, now chief of the Interstellar Security Agency. He apologises for the mistake. Their reunion is cut short when Void fighters appear in orbit and the station sounds the alarm.", false],
	],
	"step/16": [
		[16, "", "Brent asks Keith to help drive off the [[faction/9|Void]] ships attacking [[station/98]] (see [[world/voids]]).", false],
		[17, "", "The Voids broadcast a message claiming peaceful intentions, yet they attack all the same. Keith beats them back, and Brent promises to tell him everything he knows over a glass of wine.", false],
	],
	"step/17": [
		[17, "", "Keith docks at [[station/98]] to hear what Brent knows about the Voids.", false],
		[18, "", "The Voids have appeared over the past few weeks. They arrive through some kind of wormhole, attack whatever they meet and seem to be after ore; even [[faction/1]] systems are raided. Brent chairs a crisis team, and its scientists are gathering at a secret research station run by Deep Science. He asks Keith to fly for them.", false],
		[18, "", "The station's system is missing from standard star maps, so Keith must meet Lt. Thomas Boyle ([[character/5]]) at [[station/56]] in the [[system/11]] system to get the coordinates. Brent also admits that Keith's ship is not new: it has only been repainted to prevent further mix-ups.", false],
	],
	"step/18": [
		[18, "", "Keith flies to [[station/56]] to meet Boyle.", false],
		[19, "", "Boyle never arrived. Brent reports that pirates have kidnapped him near [[station/55]] and demand a ransom of five million credits. Brent is ready to pay, but Keith expects the kidnappers to kill Boyle once paid and heads for Kappa instead.", false],
	],
	"step/19": [
		[19, "", "Keith flies to [[station/55]] to look for the kidnappers.", false],
		[20, "", "Kappa's scanners locate the kidnappers' ship. Brent has had EMP bombs left in the station hangar, so that Keith can disable the ship while the kidnappers believe he is delivering the ransom.", false],
	],
	"step/2": [
		[2, "", "Gunant gives Keith an old, much repaired ship, [[ship/0]], a former pirate vessel fitted with a mining laser and no weapons. Keith must mine at least ten tons of ore from the asteroids near [[station/78]] (see [[guide/mining]]).", false],
		[3, "", "With the ore aboard, Gunant tells him to dock so the load can be checked. Without weapons, Keith has no choice but to play along.", false],
	],
	"step/20": [
		[20, "", "Keith must dock at [[station/55]] and fit the EMP bombs to his ship.", false],
		[21, "", "With the bombs mounted, Keith sets out at once.", false],
	],
	"step/21": [
		[21, "", "A waypoint marks the kidnappers' ship, which may not be alone. Keith must disable it with an EMP bomb rather than destroy it, and deal with any escort.", false],
		[22, "", "The kidnappers think the ransom has arrived until the bomb knocks out their systems. Brent sends a squad to recover Boyle.", false],
	],
	"step/22": [
		[22, "", "Keith docks at [[station/55]] to meet the rescued scientist.", false],
		[23, "", "Boyle thanks him. His own ship was lost, so Keith offers him a ride, and Boyle transfers the coordinates of the [[system/6]] system, where the research station lies, to Keith's navigation computer.", false],
	],
	"step/23": [
		[23, "", "Keith brings Boyle to [[station/10]] in the [[system/6]] system, where Dr. Paolini is expecting them.", false],
		[24, "", "Keith meets Dr. Carla Paolini ([[character/6]]), who leads the Deep Science project. She wants to learn about Void technology, starting with wreckage from Void ships. Deep Science pays Keith 20,000 credits to equip his ship, and a tractor beam is essential.", false],
		[24, "", "Carla insists on flying with him to [[station/48]] in the [[system/9]] system, where Voids have recently been sighted. Keith objects, but gives in.", false],
	],
	"step/24": [
		[24, "", "At [[station/48]] Carla wants to see the Voids as closely as possible. The Voids announce that they come from the future and are all that remains of the galaxy's civilisations. Keith must fight them and collect the remains of their ships with a tractor beam.", false],
		[25, "", "Once enough wreckage is aboard, Carla calls for a return, but something suddenly seizes the ship.", false],
	],
	"step/25": [
		[25, "", "Keith and Carla come round far from [[station/48]], in a region of space neither of them knows.", false],
		[26, "", "A gigantic Void mother ship lies nearby, launching fighters. Keith concludes that they passed through a wormhole into the Voids' home sector. That wormhole has gone, but such openings seem to collapse and reappear elsewhere, so he must reach another one to get home.", false],
	],
	"step/26": [
		[26, "", "The wormhole brings them back to [[station/48]], but Void fighters have followed. Keith must destroy them so they cannot trail the ship to [[station/10]].", false],
		[27, "", "With the pursuers gone, the pair head back to Thynome, badly in need of a rest.", false],
	],
	"step/27": [
		[27, "", "Keith docks at [[station/10]].", false],
		[28, "", "Two days later Carla asks him to go back. Her team has built a probe that, fired at the mother ship, analyses it and sends the results to Keith's ship. She stays behind to study the wreckage and sends him to the [[system/18]] system, where Voids have just been reported, to find another wormhole.", false],
		[28, "", "Keith agrees on one condition: if he returns alive, Carla owes him a date. She accepts.", false],
	],
	"step/28": [
		[28, "", "Near [[station/91]] Void fighters arrive, and Keith must reach the wormhole before it collapses. The Voids warn that destroying them will destroy his own future.", false],
		[29, "", "Keith reaches the wormhole and passes through into Void space.", false],
	],
	"step/29": [
		[29, "", "Near the mother ship Keith must lock on to it, which launches the probe, and then hold out while the probe completes its analysis.", false],
		[30, "", "During the wait the Voids broadcast again, saying they must find a way to talk before humans destroy them and, with them, their own future. Keith holds out until the data transfer is complete and leaves.", false],
	],
	"step/3": [
		[3, "", "Keith docks at [[station/78]] to hand over his first load of ore.", false],
		[4, "", "Gunant is reasonably pleased but sends Keith out again, this time to fill the whole cargo hold. He jokes that Keith might keep the ship one day if he behaves.", false],
	],
	"step/30": [
		[30, "", "Back through the wormhole, Keith waits near [[station/91]].", false],
		[31, "", "Brent calls and asks him to stop at [[station/98]] in the [[system/19]] system before returning to Thynome, promising a surprise. The probe data can be sent to Carla from there.", false],
	],
	"step/31": [
		[31, "", "Keith docks at [[station/98]] to see Brent.", false],
		[32, "", "Brent's team has developed an early-warning system for the star map. It shows where the Voids are about to open a wormhole, and Keith's navigation computer is modified to receive it. Brent wants him to fly to those places and support the local forces, and pays him 30,000 credits.", false],
		[32, "", "Brent adds that a [[faction/7|Grey]] named [[character/20]], who works for Deep Science, has asked to see Keith.", false],
	],
	"step/32": [
		[32, "", "Keith returns to [[station/10]] to meet [[character/20]].", false],
		[33, "", "Khador has studied the Void wreckage. He believes the secret of the Voids' wormholes lies in the structure of certain crystals found only in the Void sector. He is developing a drive that would take a ship instantly to any point in space, and asks Keith to bring him at least 50 of these crystals.", false],
		[33, "", "Keith must enter a wormhole once more, this time using Brent's early-warning system to find one.", false],
	],
	"step/33": [
		[33, "", "Keith must gather 50 [[item/164]] in the Void sector and deliver them to [[station/10]].", false],
		[34, "", "Khador is delighted and gives Keith a copy of his blueprint for the [[item/85]], so that Keith can build one for himself (see [[guide/blueprints]]). Such a drive can even reach the Voids' home sector.", false],
		[34, "", "Carla appears, too busy for their date. She tells Keith that she and Brent have worked out a plan and sends him to Brent at [[station/30]] in the [[system/2]] system.", false],
	],
	"step/34": [
		[34, "", "Keith flies to [[station/30]] to hear Brent's plan.", false],
		[35, "", "The probe data shows that the mother ship is the source of the wormholes. No weapon has harmed it so far, so the plan is to fly a sturdy freighter loaded with Nivelian nuclear explosives into its heart.", false],
		[35, "", "A Vossk K'Sarr freighter is best suited for the task. Brent has arranged to obtain one from [[character/7]], commander of [[station/29]] in the [[system/5]] system, as part of a secret prisoner exchange. Errkt insists on meeting the pilot in person.", false],
	],
	"step/35": [
		[35, "", "Keith flies into [[faction/1]] territory to meet [[character/7]] at [[station/29]].", false],
		[36, "", "Errkt, who has looked into Keith's record, holds that only a Vossk can fly a Vossk ship properly. Since the mission must not fail, he will pilot the freighter himself. First, however, Keith must prove his skill as a fighter pilot near the planet [[station/27]].", false],
	],
	"step/36": [
		[36, "", "Errkt proposes a contest at a pirate hideout near [[station/27]]: whoever shoots down more pirates wins.", false],
		[37, "", "Keith wins. Errkt accepts him as a capable pilot and grants him the honour of escorting the freighter, which he will bring to the agreed meeting point. Keith calls Brent to report.", false],
	],
	"step/37": [
		[37, "", "Keith contacts Brent from [[station/27]] to report on his talks with Errkt.", false],
		[38, "", "The Vossk Empire has confirmed its support, and Brent accepts Errkt as the pilot. A new problem has arisen: ships of the [[faction/3|Mido Confederation]], at war with the Nivelians, have seized the convoy carrying the Nivelian explosives. It was spotted in the [[system/4]] system near [[station/22]], and Keith agrees to intercept it.", false],
	],
	"step/38": [
		[38, "", "Near [[station/22]] Keith finds the stolen convoy with a Mido fighter escort. He must destroy the escort without damaging the convoy ships.", false],
		[39, "", "With the convoy back under control, Brent hands it to local security forces for the trip to [[station/30]] and asks Keith to return there too.", false],
	],
	"step/39": [
		[39, "", "Keith docks at [[station/30]] for the final briefing.", false],
		[40, "", "The explosives are loaded aboard the Vossk freighter, and Errkt remains its pilot. When the Voids next appear, Keith and Errkt will fly there. Errkt will make for the first wormhole, and Keith will cover him and follow. Brent will ask the nearest station for reinforcements.", false],
		[40, "", "Errkt is to eject in an escape pod shortly before impact. Keith must make it back through the wormhole before the mother ship is destroyed, or there will be no way home.", false],
	],
	"step/4": [
		[4, "", "Keith returns to the asteroids to mine until the hold is full.", false],
		[5, "", "While he is mining, a pirate ship approaches. Unarmed, Keith is told to run for the station and dodge its fire.", false],
	],
	"step/40": [
		[40, "", "Using the early-warning system, Keith flies to an orbit under Void attack. Errkt arrives with the freighter and heads for the first wormhole, and Lt. [[character/8]] joins with his squad. Keith must protect the freighter until it is through.", false],
		[41, "", "The freighter's armour is badly damaged, but Errkt reaches the wormhole, and Keith follows him through.", false],
	],
	"step/41": [
		[41, "", "Baffour's squad did not get through the wormhole in time, so Keith and Errkt are alone. The freighter is on a collision course with the mother ship, and Keith must clear away the Void fighters in its path.", false],
		[42, "", "As the freighter closes in, Errkt reports that his escape pod has been hit. He chooses to stay with the freighter and orders Keith to leave while there is still time. Keith says farewell and turns back.", false],
	],
	"step/42": [
		[42, "", "Keith must get clear as Errkt's freighter heads for its target.", false],
		[43, "", "Brent reports that wormholes all over the sector have collapsed: the plan has worked. Keith tells him that Errkt did not survive, and Brent promises to honour him in his report to the Vossk Empire. They agree to meet for a drink at [[station/98]].", false],
	],
	"step/43": [
		[43, "", "Keith joins Brent at [[station/98]] to celebrate.", false],
		[44, "", "After several drinks, Carla arrives in an evening dress to claim the date she owes Keith. Brent tactfully leaves the two of them alone.", false],
	],
	"step/44": [
		[44, "", "Keith wakes at [[station/98]] with a hangover after his night with Carla.", false],
		[45, "", "Carla is gone. Her note explains that she has moved on to another secret project in a place she will not reveal, and that Deep Science is paying Keith a final 40,000 credits. Keith suspects he has been used all along, and heads back to the bar.", false],
	],
	"step/45": [
		[45, "", "The story is complete. The Void mother ship has been destroyed, the wormholes have closed, and [[character/0]] is free to go wherever he likes. You can keep flying, trading, mining and taking jobs across the galaxy; see [[world/history]] for a summary of the whole story.", false],
	],
	"step/5": [
		[5, "", "Keith must outrun the pirate and dock safely at [[station/78]].", false],
		[6, "", "Gunant admits that pirate raids on his station are getting worse. Keith offers to deal with them if he gets weapons. Gunant decides to try a strike on the pirate hideout near the station and opens his small hangar so that Keith can fit a weapon and armour.", false],
	],
	"step/6": [
		[6, "", "In the station hangar Keith must fit [[ship/0]] with a weapon and an armour plate (see [[guide/fitting]]).", false],
		[7, "", "Gunant approves of the choice. As a precaution he has set Keith's weapons so that they cannot pierce his own shields. The two agree to meet outside.", false],
	],
	"step/7": [
		[7, "", "Gunant transfers the route to the hideout as waypoints. Keith must follow it and destroy the pirate ships there, with Gunant flying alongside (see [[guide/combat]]).", false],
		[8, "", "The hideout holds far more pirates than expected. Gunant wants to retreat, but Keith fights on and wins. Asked where he learned to fight like that, Keith says he served in the Space Fleet under Admiral Smith. Gunant finds this odd, since Keith looks far too young.", false],
	],
	"step/8": [
		[8, "", "The battle won, Keith and Gunant return to [[station/78]].", false],
		[9, "", "Gunant thanks Keith for saving his life and mentions Admiral Smith's grave on [[station/5]]. Keith is stunned: the admiral died of old age around 3612. Gunant then tells him that the current year is 3624, a year he expects to be remembered for the Voids.", false],
	],
	"step/9": [
		[9, "", "Shaken by the news, Keith docks again at [[station/78]] to settle matters with Gunant.", false],
		[10, "", "Keith realises that about 35 years have passed since he was hit in the asteroid belt. Gunant suspects a hyperdrive fault, since that type of drive has been linked to similar incidents for years.", false],
		[10, "", "To thank him for the victory over the pirates, Gunant gives [[ship/0]] to Keith, fitted with a stronger drive for travel between the planets of the system. He keeps the mining laser, a prototype he built himself. Keith finally gives his name and sets off to meet Captain [[character/3]], a human commander at [[station/79]] who can help him reach [[faction/0]] space. From now on the [[chart]] allows travel within the system.", false],
	],
	"system/0": [
		[0, "", "[[system/0]] is a Nivelian system on the left edge of the chart. It is hidden on the star map until you buy its coordinates from [[agent/12]] at [[station/18]]. Its gate at [[station/0]] links it to [[system/2]] and [[system/8]].", false],
		[0, "", "Suteo's stations are among the most advanced in Nivelian space, with [[station/2]] and [[station/4]] at the top tech level. The agent [[agent/0]] sells a blueprint at [[station/3]].", false],
	],
	"system/1": [
		[0, "", "[[system/1]] is a Terran system in the lower left corner of the chart. It is hidden until you buy its coordinates from [[agent/13]] at [[station/26]]. Its gate at [[station/5]] links it to [[system/8]] and [[system/18]].", false],
		[0, "", "Its stations are well developed, with [[station/7]] at the top tech level. The agent [[agent/1]] sells a blueprint at [[station/8]].", false],
		[9, "", "According to [[character/2]], Admiral Smith, the old commander of [[character/0]], lies buried on [[station/5]].", false],
	],
	"system/10": [
		[0, "", "[[system/10]] is a Vossk system on the right side of the chart, rated Dangerous. It is hidden until you buy its coordinates from [[agent/14]], and it has no gate links at all: only a ship with a jump drive can reach it. All five of its stations are of the highest tech levels.", false],
		[0, "", "The agent [[agent/5]] sells a blueprint at [[station/54]].", false],
	],
	"system/11": [
		[0, "", "[[system/11]] is a Terran system in the upper centre of the chart, rated Average. It has only three stations. Its gate at [[station/55]] links it to [[system/7]], [[system/9]], [[system/14]] and [[system/16]].", false],
		[18, "", "[[character/0]] is sent to [[station/56]] to meet a Deep Science officer.", false],
		[19, "", "The officer, [[character/5]], has been kidnapped by pirates near [[station/55]].", false],
		[22, "", "[[character/0]] frees him with EMP bombs in [[step/21]].", false],
	],
	"system/12": [
		[0, "", "[[system/12]] is a small Vossk system with only two stations, on the right side of the chart and rated Average. Its gate at [[station/60]] links it to [[system/3]], [[system/5]], [[system/13]] and [[system/14]], so it joins Vossk space to the Terran east.", false],
		[0, "", "The Multipod agent [[agent/6]] sells a blueprint at [[station/61]].", false],
	],
	"system/13": [
		[0, "", "[[system/13]] is a Terran system on the right edge of the chart, rated Risky. Its gate at [[station/65]] links it to [[system/12]] and [[system/16]].", false],
		[0, "", "The Cyborg agent [[agent/14]] sells coordinates at [[station/65]].", false],
	],
	"system/14": [
		[0, "", "[[system/14]] is a Terran system near the centre of the chart and one of the two Safe systems in the galaxy. Its gate at [[station/70]] links it to [[system/3]], [[system/11]], [[system/12]] and [[system/19]]. Its stations are mostly low-tech.", false],
		[0, "", "The agent [[agent/7]] sells a blueprint at [[station/72]].", false],
	],
	"system/15": [
		[0, "", "[[system/15]] is a Midorian system at the top of the chart, rated Dangerous. It has no gate links, so a ship can only enter or leave it with a jump drive. Its five stations are all small and low-tech. Until [[step/16]] its ship dealers stay closed and few ships come and go.", false],
		[0, "", "The story begins here, at [[station/78]].", false],
		[11, "", "The system is the territory of the [[faction/3|Mido Confederation]], founded by Terran and Nivelian exiles during the Nivelian Civil War. The Nivelians still claim it, and there is fighting on its outskirts.", false],
		[15, "", "[[character/0]] leaves the system as a prisoner on a Terran cruiser after [[step/14]]. Returning later takes a jump drive.", false],
		[0, "", "[[character/2]] sells a blueprint in the lounge of [[station/78]].", false],
	],
	"system/16": [
		[0, "", "[[system/16]] is a Terran system on the right side of the chart, rated Risky. Its gate at [[station/80]] links it to [[system/11]] and [[system/13]].", false],
		[0, "", "The Vossk agent [[agent/8]] sells a blueprint at [[station/84]].", false],
	],
	"system/17": [
		[0, "", "[[system/17]] is a Nivelian system in the upper left of the chart, rated Risky, and the nearest system to [[system/15]]. Its gate at [[station/85]] links it to [[system/2]], [[system/9]] and [[system/4]]; it is the only gate route into [[system/4]].", false],
		[0, "", "The Vossk agent [[agent/15]] sells coordinates at [[station/88]].", false],
	],
	"system/18": [
		[0, "", "[[system/18]] is a Terran system at the bottom of the chart, rated Risky. Its gate at [[station/90]] links it to [[system/1]] and [[system/8]].", false],
		[0, "", "The agent [[agent/9]] sells a blueprint at [[station/90]].", false],
		[28, "", "In [[step/28]] [[character/0]] comes here after a report of Void activity near [[station/91]], to slip into a wormhole.", false],
	],
	"system/19": [
		[0, "", "[[system/19]] is a Terran system at the centre of the chart, rated Safe. Its gate at [[station/95]] links it to [[system/3]], [[system/8]], [[system/9]] and [[system/14]].", false],
		[15, "", "[[station/98]] is where the Terran cruiser brings [[character/0]] after his arrest, and where he meets his old friend [[character/1]] again.", false],
		[16, "", "Even this safe system is not spared: a Void squadron attacks [[station/98]] in [[step/16]]. [[character/1]] keeps his headquarters there.", false],
	],
	"system/2": [
		[0, "", "[[system/2]] is a Nivelian system on the left side of the chart and the crossroads of Nivelian space. Its gate at [[station/30]] links it to [[system/0]], [[system/8]], [[system/9]] and [[system/17]]. It has four stations of middling tech level.", false],
		[34, "", "In [[step/33]] [[character/6]] sends [[character/0]] to [[station/30]], where [[character/1]] is waiting with a new plan. The final preparations against the Voids also take place there.", false],
	],
	"system/20": [
		[0, "", "[[system/20]] is a Vossk system in the lower right of the chart, rated Dangerous. Its gate at [[station/62]] links it to [[system/5]] and [[system/21]], making it the only gate route into [[system/21]].", false],
		[0, "", "A Terran, the agent [[agent/10]], sells a blueprint at the small station [[station/59]].", false],
	],
	"system/21": [
		[0, "", "[[system/21]] is a Vossk system in the far lower right corner of the chart, rated Dangerous. It is hidden until you buy its coordinates from [[agent/15]]. Its gate at [[station/12]] links it only to [[system/20]]. Its stations are all primitive, with tech levels of 3 or less.", false],
	],
	"system/3": [
		[0, "", "[[system/3]] is the Vossk system nearest the centre of the chart and the main entrance to Vossk space. Its gate at [[station/15]] links it to [[system/5]], [[system/12]], [[system/8]], [[system/14]] and [[system/19]]. It is rated Average.", false],
		[0, "", "The agent [[agent/12]] at [[station/18]] sells the coordinates of the hidden [[system/0]] system.", false],
	],
	"system/4": [
		[0, "", "[[system/4]] is a Midorian system in the upper left corner of the chart, rated Dangerous. It is a dead end: its gate at [[station/20]] reaches only [[system/17]]. Its stations range from the primitive [[station/21]] to the well-equipped [[station/22]].", false],
		[0, "", "The agent [[agent/2]] sells a blueprint in the lounge of [[station/20]].", false],
		[38, "", "In [[step/38]] a stolen convoy carrying Nivelian explosives is tracked to this system, near [[station/22]].", false],
	],
	"system/5": [
		[0, "", "[[system/5]] is a Vossk system in the lower right of the chart, rated Risky. Its gate at [[station/25]] links it to [[system/3]], [[system/12]] and [[system/20]]. The agent [[agent/13]] sells coordinates at [[station/26]].", false],
		[35, "", "The system is the home base of the Vossk commander [[character/7]] at [[station/29]], where [[character/0]] meets him in [[step/35]].", false],
		[36, "", "Their contest takes place near [[station/27]].", false],
	],
	"system/6": [
		[0, "", "[[system/6]] is a Terran system in the top right of the chart, rated Dangerous. It does not appear on standard star charts, and only the story reveals its coordinates. It holds a single station, [[station/10]], whose gate links it to [[system/7]] alone.", false],
		[23, "", "The system hides the secret research station of Deep Science. [[character/5]] gives [[character/0]] its coordinates in [[step/22]], and much of the struggle against the Voids is planned there.", false],
	],
	"system/7": [
		[0, "", "[[system/7]] is a Terran system at the top right of the chart, rated Risky. Its gate at [[station/35]] links it to [[system/11]] and to the hidden [[system/6]], making it the only gate route into the hidden system. [[station/37]] is its most advanced station.", false],
	],
	"system/8": [
		[0, "", "[[system/8]] is a Terran system in the lower left quarter of the chart and the best-connected system in the galaxy. Its gate at [[station/40]] links it to six systems: [[system/0]], [[system/1]], [[system/2]], [[system/3]], [[system/18]] and [[system/19]]. It is rated Average.", false],
		[0, "", "The agent [[agent/4]] sells a blueprint at [[station/43]].", false],
	],
	"system/9": [
		[0, "", "[[system/9]] is a Nivelian system in the upper centre of the chart, rated Average. Its gate at [[station/45]] links it to [[system/2]], [[system/11]], [[system/17]] and [[system/19]].", false],
		[24, "", "Void activity is reported near [[station/48]], and [[character/0]] and [[character/6]] go there in [[step/24]] to collect wreckage.", false],
	],
	"world/galaxy": [
		[0, "Overview", "The game takes place in a single galaxy of 22 star systems. Each system belongs to one faction, carries a safety rating and holds between one and five space stations. Every station orbits a planet, and each has its own shop, hangar and space lounge. The systems are spread over a flat chart, and travel between them runs through a network of jump gates.", false],
		[0, "", "Four peoples own the charted systems. The [[faction/0|Terrans]] hold ten, the [[faction/1]] six, the [[faction/2|Nivelians]] four and the [[faction/3|Midorians]] two. Members of smaller races, such as the [[faction/4|Multipods]], [[faction/5|Cyborgs]], [[faction/6|Bobolians]] and [[faction/7]], live among them without territory of their own. [[faction/8|Pirates]] roam every system, and from the start there are rumours of a hostile force called the [[faction/9|Voids]].", false],
		[0, "Layout", "The Nivelian and Midorian systems lie in the upper left of the chart, around [[system/15]], [[system/4]], [[system/17]] and [[system/2]]. Terran space runs across the centre, the right side and the bottom of the chart, with [[system/19]] and [[system/14]] at its heart. The Vossk systems form a separate block in the lower right, beginning at [[system/3]] and ending in the far corner at [[system/21]].", false],
		[0, "", "Gate routes favour the centre. [[system/8]] has six gate links, more than any other system, and [[system/19]], [[system/14]], [[system/3]] and [[system/11]] connect four or five systems each. Systems at the edges, such as [[system/4]], [[system/6]] and [[system/21]], are dead ends with a single link.", false],
		[0, "Travel", "Inside a system, a ship's ordinary drive carries it from one station's orbit to another. To leave a system, a ship flies through its jump gate, which stands at one of the system's stations and reaches only the systems linked to it. Longer trips are chains of gate jumps. A jump drive is the only way to skip the gate network and reach any known system directly; see [[guide/navigation]].", false],
		[33, "", "The only jump drive in the game is the [[item/85]], which [[character/20]] designs during the story. It is built from a blueprint and needs [[item/164]], among other things.", false],
		[0, "Safety", "Every system is rated Safe, Average, Risky or Dangerous. The rating decides how often raiders lie in wait near a station when you arrive. In a Dangerous system they turn up on most visits; in a Safe one they are rare. Raiders are usually pirates, but sometimes ships of the faction's rival race. Safer systems, in turn, keep more local patrol ships around their stations.", false],
		[0, "Factions and standing", "Your standing is kept on two scales: one between the Terrans and the Vossk, the other between the Nivelians and the Midorians. Favour with one side of a pair costs favour with the other. If your standing with a faction falls too low, its ships attack you on sight and its stations refuse you. Pirates and Voids are always hostile. A diplomat in a space lounge can repair your standing for a fee.", false],
		[0, "Hidden systems", "Not every system appears on the star map at first. [[system/0]], [[system/1]], [[system/10]] and [[system/21]] stay hidden until you buy their coordinates from an agent in a space lounge; see [[guide/lounge]]. One more system, [[system/6]], is missing from standard star charts and only the story reveals it.", false],
		[23, "", "The coordinates of [[system/6]] reach you through [[character/5]] in [[step/22]]. The system holds a single station, [[station/10]], the secret research base of the Deep Science organisation.", false],
		[0, "", "Two systems have no gate links at all: [[system/15]] and [[system/10]]. A ship can only reach them, or leave them, with a jump drive.", false],
		[0, "An isolated start", "The story opens in [[system/15]], a remote system at the top of the chart with no gate connection to the rest of the galaxy. Its trade is poor, its stations are low-tech, and its ship dealers stay closed for the first part of the story. Early on, the only way out of the system is the one the story provides.", false],
		[11, "", "[[system/15]] is the home of the [[faction/3|Mido Confederation]], a group of Terran and Nivelian refugees and outlaws who settled this newly charted sector during the Nivelian Civil War. The Confederation declared itself independent. The Terrans accept this; the Nivelians still claim the system, which keeps the fighting going along its edges.", false],
		[15, "", "[[character/0]] leaves [[system/15]] aboard a Terran cruiser after the convoy at [[station/79]] disables and arrests him in [[step/14]]. He arrives at [[station/98]] in [[system/19]], deep in Terran space.", false],
		[9, "The time gap", "When [[character/0]] wakes up in [[system/15]], he believes only a short time has passed. In fact his damaged hyperdrive has thrown him across the galaxy and some 35 years into the future. The galaxy he knew has changed: old friends have aged or died, and new sectors, his present location among them, have been settled in the meantime.", false],
		[10, "", "Faulty hyperdrives of his type have caused similar jumps through time and space before.", false],
		[18, "Beyond the chart", "The Voids enter the charted systems through some kind of wormhole. They raid Terran, Nivelian and Vossk space alike and seem to be after ore. See [[world/voids]].", false],
		[25, "", "A wormhole leads out of the charted galaxy into the Voids' own sector, which has no place on the star map. The wormholes open near a station for a while, then collapse and appear elsewhere.", false],
		[34, "", "With the [[item/85]] fitted, a ship can also jump straight into the Void sector.", false],
		[32, "", "From [[step/31]] on, an early-warning system shows on the star map where the next wormhole will open.", false],
		[42, "", "When the Void mother ship is destroyed in [[step/41]], the wormholes across the sector collapse and the raids stop.", false],
	],
	"world/history": [
		[0, "", "The galaxy is shared by several peoples, among them the [[faction/0|Terrans]], the [[faction/2|Nivelians]] and the [[faction/1|Vossk]]. Space between their stations is plagued by [[faction/8|pirates]]. This page sums up the story; each part appears once your save reaches it.", false],
		[0, "Act one: stranded", "The Terran bounty hunter [[character/0]] destroys a pirate gang in an asteroid belt ([[step/0]]).", false],
		[1, "", "A last shot damages his hyperdrive as he jumps away to meet his old commander, Admiral Smith. His ship drifts, its pilot unconscious, to [[station/78]].", false],
		[2, "", "The Nivelian ore trader [[character/2]] salvages the wreck, keeps the ship and makes Keith mine ore for him.", false],
		[8, "", "Keith helps Gunant destroy a nearby pirate hideout ([[step/7]]).", false],
		[9, "", "Afterwards Keith learns that it is 3624 and that Admiral Smith is long dead.", false],
		[10, "", "A hyperdrive fault has carried Keith 35 years into the future and to a remote corner of the galaxy. Gunant gives him the ship [[ship/0]] and sends him to [[character/3]] at [[station/79]].", false],
		[11, "", "The [[system/15]] system belongs to the [[faction/3|Mido Confederation]], founded by Terran and Nivelian exiles during the Nivelian Civil War.", false],
		[12, "", "Keith discovers that the silent station [[station/76]] has been drugged into a stupor by the dealer [[character/4]] ([[step/11]]).", false],
		[15, "", "When a Terran convoy passes through, it mistakes Keith for a pirate, disables his ship and takes him to [[station/98]] ([[step/14]]).", false],
		[16, "Act two: the Void threat", "There he meets his old friend [[character/1]], now chief of security, just as the [[faction/9|Voids]] attack the station.", false],
		[18, "", "The Voids raid star systems through wormholes in search of ore. Brent recruits Keith to fly for Deep Science, a secret research organisation studying them ([[step/17]]).", false],
		[19, "", "The scientist [[character/5]], who was to guide Keith to the research station, is kidnapped by pirates.", false],
		[23, "", "Keith disables the kidnappers' ship with EMP bombs, rescues him and receives the coordinates of the [[system/6]] system ([[step/21]], [[step/22]]).", false],
		[24, "Act three: Deep Science", "At [[station/10]] Keith meets the project leader [[character/6]] and starts working for Deep Science.", false],
		[25, "", "Keith and Carla salvage Void wreckage at [[station/48]], but a wormhole swallows their ship ([[step/24]]).", false],
		[26, "", "They find themselves in the Voids' home sector, beside a gigantic mother ship, and escape through another wormhole.", false],
		[30, "", "Keith returns to the Void sector through a wormhole near [[station/91]] and launches a probe at the mother ship ([[step/29]]).", false],
		[32, "", "Brent gives Keith an early-warning system that shows where the Voids will strike next.", false],
		[34, "", "The Grey scientist [[character/20]] has Keith collect Void crystals for a new instant drive and gives him its blueprint ([[step/33]]).", false],
		[35, "Act four: the strike", "The probe shows that the mother ship creates the wormholes. Brent and Carla plan to destroy it with a freighter full of Nivelian explosives, supplied by the Vossk commander [[character/7]].", false],
		[37, "", "Errkt insists on flying the freighter himself, and Keith wins the right to escort him ([[step/36]]).", false],
		[39, "", "Keith recaptures the convoy carrying the explosives after Mido ships seize it ([[step/38]]).", false],
		[42, "", "With reinforcements under [[character/8]], Keith escorts Errkt through a wormhole. Errkt rams the freighter into the mother ship and dies in the attack ([[step/41]]).", false],
		[43, "", "Every wormhole collapses and the Void raids end.", false],
		[45, "Epilogue", "Keith celebrates with Brent and finally spends a night with Carla. She leaves the next morning for another secret project, and Keith is left free to roam the galaxy.", false],
	],
	"world/khador": [
		[32, "", "Khador, a Grey scientist working for Deep Science, has his own page: see [[character/20]].", false],
	],
	"world/voids": [
		[0, "", "The [[faction/9|Voids]] are the central threat of the story. This page collects what is learned about them; more appears as your save advances.", false],
		[2, "First reports", "Keith first hears of the Voids from [[character/2]]: hostile beings that turn up from time to time even in the remote [[system/15]] system.", false],
		[9, "", "People in the Mido system expect 3624 to be remembered as the year of the Voids.", false],
		[16, "", "Void fighters attack [[station/98]] in Terran space ([[step/15]]).", false],
		[17, "", "During the attack the Voids broadcast a message claiming that they come in peace, but they keep firing.", false],
		[18, "What is known", "The Voids began appearing a few weeks earlier. They enter inhabited systems through wormholes, attack anything they meet and appear to be after ore. Even [[faction/1]] systems are raided. Nobody knows where they come from or what they want.", false],
		[24, "", "At [[station/48]] they announce that they come from the future and are all that remains of the galaxy's civilisations.", false],
		[26, "The home sector", "Their wormholes lead to a distant home sector, where a gigantic mother ship launches fighters. The wormholes open for a short time, then collapse and reappear elsewhere.", false],
		[28, "", "The Voids warn that destroying them would destroy humanity's future.", false],
		[30, "", "They repeat that they must find a way to communicate before humans destroy them and their own future with them. Whether this claim is true is never settled.", false],
		[32, "", "An early-warning system developed by [[character/1]]'s team predicts where the Voids will open their next wormhole.", false],
		[33, "", "The Grey scientist [[character/20]] believes that crystals found only in the Void sector, [[item/164]], hold the secret of their wormholes.", false],
		[35, "The end of the raids", "The probe launched at the mother ship shows that it is the source of the wormholes. No known weapon has damaged it.", false],
		[42, "", "A Vossk freighter loaded with Nivelian nuclear explosives, flown by [[character/7]], destroys the mother ship ([[step/41]]).", false],
		[43, "", "Afterwards the wormholes collapse across the sector and the Void raids stop, at least for the time being.", false],
	],
}
