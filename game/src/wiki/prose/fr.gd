extends RefCounted
## Reference prose in French. Each block is [story step it appears from,
## section heading or "", text, list item]. See src/wiki/prose.gd.
const PAGES := {
	"guide/basics": {"title": "Premiers pas", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/blueprints": {"title": "Plans et production", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/combat": {"title": "Combat", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/fitting": {"title": "Vaisseaux et équipement", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/flight": {"title": "Piloter", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/jobs": {"title": "Contrats freelance", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/lounge": {"title": "Space Lounge", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/medals": {"title": "Médailles", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/mining": {"title": "Extraction minière", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/navigation": {"title": "Navigation", "subtitle": "Guide", "category": "guide", "from": 0},
	"guide/trading": {"title": "Commerce", "subtitle": "Guide", "category": "guide", "from": 0},
	"step/0": {"title": "Prime dans la ceinture d'astéroïdes"},
	"step/1": {"title": "À la dérive"},
	"step/10": {"title": "Rencontre avec le commandant"},
	"step/11": {"title": "Une station muette"},
	"step/12": {"title": "Rapport au commandant"},
	"step/13": {"title": "En attendant le convoi"},
	"step/14": {"title": "Le convoi terrien"},
	"step/15": {"title": "En état d'arrestation"},
	"step/16": {"title": "La défense de la station"},
	"step/17": {"title": "L'histoire des Voids"},
	"step/18": {"title": "Rendez-vous avec un scientifique"},
	"step/19": {"title": "L'enlèvement"},
	"step/2": {"title": "Le premier chargement de minerai"},
	"step/20": {"title": "L'installation des bombes"},
	"step/21": {"title": "Neutraliser les ravisseurs"},
	"step/22": {"title": "Le scientifique sauvé"},
	"step/23": {"title": "La station de recherche secrète"},
	"step/24": {"title": "Récupérer des épaves voids"},
	"step/25": {"title": "Perdus dans un espace étrange"},
	"step/26": {"title": "Semer les poursuivants"},
	"step/27": {"title": "Une nouvelle mission"},
	"step/28": {"title": "De nouveau dans le trou de ver"},
	"step/29": {"title": "Le lancement de la sonde"},
	"step/3": {"title": "La livraison du minerai"},
	"step/30": {"title": "L'appel d'un vieil ami"},
	"step/31": {"title": "Une surprise promise"},
	"step/32": {"title": "Le scientifique grey"},
	"step/33": {"title": "Des cristaux venus du Void"},
	"step/34": {"title": "Un plan pour la victoire"},
	"step/35": {"title": "Rencontre avec le commandant vossk"},
	"step/36": {"title": "Un duel de pilotes"},
	"step/37": {"title": "Appel au quartier général"},
	"step/38": {"title": "La reprise du convoi"},
	"step/39": {"title": "Derniers préparatifs"},
	"step/4": {"title": "Une soute pleine"},
	"step/40": {"title": "Escorte jusqu'au trou de ver"},
	"step/41": {"title": "Attaque contre le vaisseau-mère"},
	"step/42": {"title": "Évasion de l'espace du Void"},
	"step/43": {"title": "Une fête"},
	"step/44": {"title": "Le lendemain matin"},
	"step/45": {"title": "Épilogue"},
	"step/5": {"title": "Fuite vers la station"},
	"step/6": {"title": "Armer le vaisseau"},
	"step/7": {"title": "Le repaire des pirates"},
	"step/8": {"title": "Après la bataille"},
	"step/9": {"title": "Règlement de comptes"},
	"world/galaxy": {"title": "La galaxie", "subtitle": "Univers", "category": "world", "from": 0},
	"world/history": {"title": "Histoire", "subtitle": "Univers", "category": "world", "from": 0},
	"world/khador": {"title": "Khador", "subtitle": "Personnage", "category": "characters", "from": 32},
	"world/voids": {"title": "Les Voids", "subtitle": "Univers", "category": "world", "from": 0},
}
const BLOCKS := {
	"agent/0": [
		[0, "", "[[agent/0]] est un agent nivélien installé au lounge de la station [[station/3]], dans le système caché [[system/0]]. Il vend le plan du laser [[item/11]].", false],
	],
	"agent/1": [
		[0, "", "[[agent/1]] est un agent nivélien installé au lounge de la station [[station/8]], dans le système caché [[system/1]]. Il vend le plan du blaster [[item/15]], une arme qu'il présente comme rare.", false],
	],
	"agent/10": [
		[0, "", "[[agent/10]] est un agent terrien qui vit parmi les Vossk, au lounge de la station [[station/59]], dans [[system/20]]. Il vend le plan du dispositif de camouflage [[item/96]].", false],
	],
	"agent/11": [
		[0, "", "[[agent/11]] est le négociant en minerai [[character/2]], qui apparaît dans son propre lounge à la station [[station/78]], dans [[system/15]]. Il vend le plan de [[item/90]], son propre laser d'extraction, à un prix bien supérieur à celui de tout autre agent. Comme [[system/15]] n'a aucune liaison par portail, il faut un moteur de saut pour le rejoindre plus tard dans le jeu.", false],
		[10, "", "Il accueille [[character/0]] comme le voyageur temporel et a commencé à produire la foreuse qu'il gardait autrefois pour lui seul.", false],
	],
	"agent/12": [
		[0, "", "[[agent/12]] est un agent vossk installé au lounge de la station [[station/18]], dans [[system/3]]. Il vend les coordonnées du système caché [[system/0]], dont il vante les nombreuses stations avancées.", false],
	],
	"agent/13": [
		[0, "", "[[agent/13]] est un agent bobolian installé au lounge de la station [[station/26]], dans [[system/5]]. Il vend les coordonnées du système caché [[system/1]].", false],
	],
	"agent/14": [
		[0, "", "[[agent/14]] est un agent cyborg installé au lounge de la station [[station/65]], dans [[system/13]]. Il vend les coordonnées de [[system/10]], mais avoue n'avoir aucune idée de la façon de s'y rendre. Sans moteur de saut, ces coordonnées ne servent à rien, car le système n'a aucune liaison par portail.", false],
	],
	"agent/15": [
		[0, "", "[[agent/15]] est un agent vossk installé au lounge de la station [[station/88]], dans [[system/17]]. Il vend les coordonnées du système caché [[system/21]], qu'il appelle son foyer. Une fois connu, le système est accessible par portail depuis [[system/20]].", false],
	],
	"agent/2": [
		[0, "", "[[agent/2]] est un agent midorien installé au lounge de la station [[station/20]], dans [[system/4]]. Il vend le plan du [[item/25]], le plan d'arme le moins cher proposé par un agent, après la roquette de [[agent/4]].", false],
	],
	"agent/3": [
		[0, "", "[[agent/3]] est un agent terrien installé au lounge de la station [[station/10]], dans [[system/6]]. Il vend le plan du [[item/27]], un canon électromagnétique à cadence rapide.", false],
	],
	"agent/4": [
		[0, "", "[[agent/4]] est un agent terrien installé au lounge de la station [[station/43]], dans [[system/8]]. Il vend le plan du [[item/33]], le plan le moins cher proposé par un agent.", false],
	],
	"agent/5": [
		[0, "", "[[agent/5]] est un agent vossk installé au lounge de la station [[station/54]], dans [[system/10]], un système que seul un moteur de saut permet d'atteindre. Il vend le plan de la torpille à tête chercheuse [[item/37]], qu'aucune boutique ne propose.", false],
	],
	"agent/6": [
		[0, "", "[[agent/6]] est le seul Multipode du jeu. Il se trouve au lounge de la station [[station/61]], dans [[system/12]], et vend le plan de l'arme nucléaire [[item/46]].", false],
	],
	"agent/7": [
		[0, "", "[[agent/7]] est un agent terrien installé au lounge de la station [[station/72]], dans [[system/14]]. Il vend le plan du [[item/54]], un bouclier puissant.", false],
	],
	"agent/8": [
		[0, "", "[[agent/8]] est un agent vossk installé au lounge de la station [[station/84]], dans [[system/16]]. Il vend le plan du [[item/59]], une plaque de blindage vossk qui n'a jamais été vendue en boutique. C'est le plan le plus cher vendu par un agent, après la foreuse de [[agent/11]].", false],
	],
	"agent/9": [
		[0, "", "[[agent/9]] est un agent terrien installé au lounge de la station [[station/90]], dans [[system/18]]. Il vend le plan du [[item/67]], un compresseur de soute qu'il recommande à tous les négociants.", false],
	],
	"character/0": [
		[0, "", "[[character/0]] est le protagoniste et le personnage que vous incarnez. C'est un pilote de chasse [[faction/0|terrien]] qui gagne sa vie en traquant les [[faction/8|pirates]] pour les primes offertes pour leur capture. Il est sûr de lui, sarcastique et prompt à se battre.", false],
		[1, "Naufragé", "En route vers Eden Prime, où l'amiral Smith lui réserve une mission spéciale, il voit son hyperpropulseur endommagé lors d'une attaque pirate. Le pilote automatique l'emmène, inconscient, jusqu'à la station [[station/78]].", false],
		[2, "", "Il y est secouru par le négociant en minerai [[character/2]], qui a revendiqué son vaisseau au titre du droit d'épave et le fait travailler comme mineur.", false],
		[8, "", "Keith est un vétéran de la Flotte spatiale terrienne, où il a servi sous les ordres de l'amiral Smith.", false],
		[9, "", "Il apprend que l'amiral est mort de vieillesse et que l'on est désormais en 3624.", false],
		[10, "", "Environ 35 ans se sont écoulés depuis son accident, apparemment à cause d'une panne de l'hyperpropulseur, et pourtant Keith n'a pas vieilli du tout. Bloqué dans le système reculé [[system/15]], il repart de zéro avec le [[ship/0]], un cadeau de Gunant.", false],
		[16, "La guerre contre les Voids", "Après une arrestation par erreur, il retrouve son vieil ami [[character/1]] à la station [[station/98]] et livre sa première bataille contre les [[faction/9|Voids]].", false],
		[18, "", "Brent le recrute comme pilote pour l'organisation de recherche Deep Science, qui enquête sur les Voids.", false],
		[24, "", "À la station [[station/10]], il rencontre [[character/6]], la responsable du projet, et se sent vite attiré par elle.", false],
		[26, "", "Carla et lui sont aspirés par un trou de ver void jusqu'au secteur d'origine des Voids et trouvent un moyen de revenir.", false],
		[36, "", "Le commandant vossk [[character/7]] connaît les anciens états de service de Keith à Novaterra.", false],
		[43, "", "Keith escorte le cargo qui détruit le vaisseau-mère void et met fin aux raids, mais Errkt meurt dans l'attaque.", false],
		[45, "Ensuite", "Sa récompense est une nuit avec Carla, qui disparaît ensuite vers un autre projet secret en lui laissant un dernier paiement. Sa mission accomplie, Keith est libre de parcourir la galaxie.", false],
	],
	"character/1": [
		[16, "", "[[character/1]] est un vieil ami de Keith, d'avant son accident. Pendant les 35 ans que Keith a perdus, Brent est devenu capitaine de corvette et chef de l'Agence de sécurité interstellaire. Il est amical, bavard et friand de longues anecdotes personnelles.", false],
		[18, "La crise des Voids", "En tant que chef de la sécurité, il préside la cellule de crise qui coordonne la riposte aux [[faction/9|Voids]]. Il recrute Keith pour Deep Science et veille à ce qu'il soit bien payé. C'est sur ses ordres que le vaisseau de Keith est repeint.", false],
		[19, "", "Lorsque le scientifique [[character/5]] est enlevé, Brent soutient le plan de sauvetage de Keith et fournit des bombes IEM à la station [[station/55]].", false],
		[32, "", "Son équipe met au point le système d'alerte précoce qui indique où les Voids ouvriront leur prochain trou de ver.", false],
		[35, "", "Avec [[character/6]], il conçoit le plan visant à détruire le vaisseau-mère void avec un cargo rempli d'explosifs, et négocie l'accord avec le commandant vossk [[character/7]].", false],
		[43, "Ensuite", "Après la destruction du vaisseau-mère, Brent fête la victoire avec Keith à la station [[station/98]].", false],
	],
	"character/2": [
		[2, "", "[[character/2]] est un négociant en minerai [[faction/2|nivélien]] qui dirige une petite station minière, [[station/78]], dans le système [[system/15]]. Il trouve l'épave du vaisseau de [[character/0]], sauve son pilote et revendique le vaisseau au titre du droit d'épave. Bourru et pragmatique, il fait rembourser sa dette à Keith en l'envoyant extraire du minerai à bord du [[ship/0]], un vieux vaisseau qu'il a rafistolé lui-même.", false],
		[8, "", "Lorsque Keith l'aide à détruire un repaire pirate près de sa station, Gunant finit par le respecter.", false],
		[10, "", "En signe de gratitude, il offre le [[ship/0]] à Keith avec un meilleur propulseur et l'envoie voir son ami [[character/3]]. Gunant est lui-même membre de la [[faction/3|Confédération Mido]]. Il conçoit ses propres lasers d'extraction et, en tant qu'agent [[agent/11]], vend le plan de l'un d'eux, le [[item/90]].", false],
	],
	"character/20": [
		[32, "", "[[character/20]] est un scientifique [[faction/7|grey]] qui travaille pour Deep Science. Il demande à rencontrer [[character/0]] à la station [[station/10]].", false],
		[33, "", "Khador s'exprime avec une politesse raffinée. Après avoir étudié les épaves voids, il pense que des cristaux que l'on ne trouve que dans le secteur des Voids détiennent le secret de leurs trous de ver. Il travaille depuis des années sur un propulseur capable d'emmener instantanément un vaisseau en n'importe quel point de l'espace, et demande à Keith de collecter 50 [[item/164]] à cet effet.", false],
		[34, "", "Lorsque Keith lui livre les cristaux, Khador le récompense avec une copie du plan du propulseur qui porte son nom, le [[item/85]].", false],
	],
	"character/3": [
		[10, "", "[[character/3]] est un capitaine humain qui a rejoint la [[faction/3|Confédération Mido]] et commande désormais la station [[station/79]]. [[character/2]] le recommande à Keith comme quelqu'un qui peut l'aider à regagner l'espace terrien.", false],
		[11, "", "Norris accueille Keith et lui explique l'histoire du système [[system/15]]. Il propose de mettre Keith en contact avec la Flotte spatiale terrienne si Keith enquête d'abord sur le silence de la station [[station/76]].", false],
		[13, "", "Il organise la rencontre de Keith avec un convoi terrien de passage dans le système et lui suggère d'accepter des contrats freelance en attendant.", false],
	],
	"character/4": [
		[12, "", "[[character/4]] est un trafiquant notoire que Keith a connu il y a longtemps. Keith le retrouve à la station [[station/76]], où il a fourni à tout l'équipage des neuro-algues, une drogue aux effets secondaires désagréables. Mkkt se souvient de Keith et se demande pourquoi il n'a pas vieilli.", false],
		[13, "", "Après avoir entendu le rapport de Keith, [[character/3]] promet de s'occuper de lui.", false],
	],
	"character/5": [
		[18, "", "Tommy est le lieutenant Thomas Boyle, un scientifique qui travaille pour Deep Science. [[character/1]] organise sa rencontre avec Keith à la station [[station/56]] pour qu'il le guide jusqu'à la station de recherche secrète de l'organisation.", false],
		[19, "", "Avant le rendez-vous, Boyle est enlevé par des pirates près de la station [[station/55]], qui exigent une rançon.", false],
		[23, "", "Après que Keith a neutralisé le vaisseau des ravisseurs, Boyle est sauvé. Il donne à Keith les coordonnées du système [[system/6]] et voyage avec lui jusqu'à la station [[station/10]].", false],
	],
	"character/6": [
		[23, "", "La Dr Paolini est la scientifique de Deep Science qui attend Keith et Boyle à la station [[station/10]].", false],
		[24, "", "La Dr Carla Paolini dirige le projet de Deep Science consacré aux [[faction/9|Voids]]. Déterminée et travailleuse, elle tient à voir les Voids de ses propres yeux ; elle accompagne donc [[character/0]] lors de sa première mission de récupération. Keith est attiré par elle dès leur première rencontre.", false],
		[26, "", "Keith et elle sont aspirés par un trou de ver jusqu'au secteur d'origine des Voids et s'en échappent ensemble de justesse.", false],
		[28, "", "Son équipe construit une sonde pour analyser le vaisseau-mère void. Elle accepte un rendez-vous avec Keith s'il revient vivant de la mission.", false],
		[34, "", "Trop absorbée par ses recherches pour honorer le rendez-vous, elle élabore avec [[character/1]] un plan pour frapper le vaisseau-mère.", false],
		[44, "Ensuite", "Après la victoire, elle rejoint Keith et Brent à la station [[station/98]] pour le rendez-vous si longtemps reporté.", false],
		[45, "", "Le lendemain matin, elle a disparu en laissant un mot : elle est partie pour un autre projet secret et demande à Keith de ne pas la chercher.", false],
	],
	"character/7": [
		[35, "", "[[character/7]] est un commandant [[faction/1|vossk]] responsable de la station [[station/29]] dans le système [[system/5]]. Il fournit le cargo K'Sarr pour l'attaque contre le vaisseau-mère void, en échange de prisonniers.", false],
		[36, "", "Fier et cérémonieux, il estime que seul un Vossk peut piloter correctement un vaisseau vossk et tient à piloter lui-même le cargo. Il met à l'épreuve les talents de Keith avant de l'accepter comme escorte.", false],
		[37, "", "Après que Keith l'a battu lors d'un concours dans un repaire pirate, Errkt le traite avec respect.", false],
		[40, "", "Avant la mission, il est calme et renfermé, ce que Brent interprète comme de la détermination.", false],
		[42, "Mort", "Errkt pilote le cargo à travers le trou de ver jusque dans le vaisseau-mère. Quand sa capsule de sauvetage est détruite, il refuse de faire demi-tour et meurt dans l'explosion, après avoir renvoyé Keith en lieu sûr.", false],
		[43, "", "Brent promet de rapporter son sacrifice à l'Empire vossk.", false],
	],
	"character/8": [
		[40, "", "Le lieutenant [[character/8]] commande l'escadron de renfort qui rejoint Keith pour protéger le cargo vossk en route vers le trou de ver.", false],
		[41, "", "Son escadron ne franchit pas le trou de ver avant sa fermeture ; Keith et [[character/7]] affrontent donc seuls les Voids.", false],
	],
	"chart": [
		[0, "", "La carte de la galaxie liste chaque système avec sa faction, son niveau de sécurité, son nombre de stations et sa position sur la carte. La position est donnée par deux nombres de 0 à 100 : le premier se compte depuis le bord gauche de la carte, le second depuis le haut. Des systèmes aux nombres proches sont voisins.", false],
		[0, "", "Dans le jeu, ouvrez la carte de la galaxie depuis une station ou en vol. Une ligne pointillée relie votre système actuel à chaque système accessible par son portail de saut ; les autres routes de portail apparaissent en traits fins. Les étoiles que vous pouvez atteindre tout de suite sont lumineuses, les autres sont atténuées. Des marqueurs indiquent le système de votre mission de l'histoire et celui de votre contrat en cours, et une ligne pointillée colorée montre la route de portails la plus courte pour s'y rendre. Une ligne dorée estompée retrace vos derniers trajets.", false],
		[0, "", "Sélectionnez un système pour voir sa faction, son niveau de sécurité et sa distance. Zoomez pour voir ses stations, leur niveau technologique, ainsi que des marqueurs pour les stations visitées, les objectifs de mission et le portail de saut. Les systèmes cachés n'apparaissent pas tant que vous ne connaissez pas leurs coordonnées ; voir [[world/galaxy]].", false],
		[32, "", "Une fois que vous disposez du système d'alerte précoce de l'[[step/31]], la carte de la galaxie signale aussi le système et la station où s'ouvrira le prochain trou de ver void.", false],
	],
	"faction/0": [
		[0, "", "Les Terriens sont des humains, et [[character/0]] en fait partie. Ils possèdent dix systèmes, plus que toute autre faction, répartis au centre, sur la droite et en bas de la carte, avec [[system/19]] et [[system/14]] en leur cœur. L'espace terrien est la partie la plus sûre de la galaxie : ses deux systèmes Sûrs sont tous deux terriens.", false],
		[0, "", "Les stations terriennes vendent le plus large choix de vaisseaux et d'équipements. Les concessionnaires hors de l'espace vossk proposent une large gamme de coques. Les rivaux traditionnels des Terriens sont les [[faction/1|Vossk]] : la réputation gagnée auprès des uns est perdue auprès des autres.", false],
		[16, "", "La Flotte spatiale terrienne est toujours la force dans laquelle [[character/0]] a servi autrefois, mais 35 ans ont passé. Lorsqu'il croise enfin un convoi terrien, celui-ci prend son vieux vaisseau d'origine pirate pour un ennemi et l'arrête.", false],
		[18, "", "Les Terriens mènent la défense contre les Voids. [[character/1]], désormais à la tête de l'Agence de sécurité interstellaire, préside une cellule de crise, et le groupe de recherche Deep Science travaille sur le problème depuis une station secrète.", false],
	],
	"faction/1": [
		[0, "", "Les Vossk sont un peuple extraterrestre organisé en empire. Ils possèdent six systèmes en bas à droite de la carte, de [[system/3]] et [[system/12]] jusqu'au lointain [[system/21]]. Quatre d'entre eux sont classés Dangereux ou Risqués. [[system/10]] n'a aucune liaison par portail.", false],
		[0, "", "Les concessionnaires vossk ne vendent qu'une seule coque, le [[ship/9]], un modèle adapté aux autres races. Les stations vossk proposent aussi des armes et des équipements introuvables ailleurs. Les Vossk sont les rivaux traditionnels des [[faction/0|Terriens]] ; leurs vaisseaux peuvent donc se joindre aux assaillants dans l'espace terrien, et inversement.", false],
		[18, "", "Les relations entre les Terriens et l'Empire vossk restent froides et imprévisibles, mais les raids des Voids frappent aussi les systèmes vossk.", false],
		[36, "", "Dans l'histoire, les Vossk apparaissent comme fiers et attachés à l'honneur. Leur commandant [[character/7]] tient à piloter lui-même le porteur de bombe et met [[character/0]] à l'épreuve par un concours avant de l'accepter comme escorte.", false],
		[42, "", "[[character/7]] sacrifie sa vie pour détruire le vaisseau-mère void, et les Terriens promettent de rapporter son acte à l'Empire vossk.", false],
	],
	"faction/2": [
		[0, "", "Les Nivéliens sont un peuple extraterrestre qui possède quatre systèmes sur la gauche de la carte : [[system/2]], [[system/9]], [[system/17]] et le système caché [[system/0]]. Leurs stations vont du petit avant-poste à certaines des plus avancées de la galaxie. Leurs rivaux sont les [[faction/3|Midoriens]].", false],
		[2, "", "La première personne que rencontre [[character/0]] est un Nivélien, le négociant en minerai [[character/2]]. [[character/0]] a une piètre opinion des manières nivéliennes, tandis que [[character/2]] affirme être un honnête homme d'affaires.", false],
		[11, "", "Une guerre civile nivélienne a donné naissance à la [[faction/3|Confédération Mido]]. Les Nivéliens n'ont jamais accepté son indépendance et revendiquent toujours le système [[system/15]].", false],
		[35, "", "Le plan contre le vaisseau-mère void repose sur des explosifs nucléaires nivéliens.", false],
	],
	"faction/3": [
		[0, "", "Les Midoriens sont le peuple de la [[faction/3|Confédération Mido]]. Ils possèdent deux systèmes en haut à gauche de la carte, [[system/15]] et [[system/4]], tous deux classés Dangereux. Leurs stations sont pour la plupart petites et de faible niveau technologique. Leurs rivaux sont les [[faction/2|Nivéliens]].", false],
		[11, "", "La Confédération a été fondée par des réfugiés et des hors-la-loi terriens et nivéliens pendant la guerre civile nivélienne. Elle limite au minimum ses contacts avec les autres systèmes. [[character/3]], commandant de la station [[station/79]], en est membre, tout comme [[character/2]].", false],
		[38, "", "La Confédération n'est pas l'amie des Nivéliens. Ses vaisseaux s'emparent du convoi transportant les explosifs nivéliens destinés au vaisseau-mère void, et [[character/0]] doit le reprendre près de la station [[station/22]].", false],
	],
	"faction/4": [
		[0, "", "Les Multipodes sont une race mineure sans systèmes propres. Le seul Multipode que vous rencontrez est l'agent [[agent/6]], qui vend un plan au lounge de la station [[station/61]], dans le système [[system/12]].", false],
	],
	"faction/5": [
		[0, "", "Les Cyborgs ne possèdent aucun territoire. Le seul Cyborg du jeu est l'agent [[agent/14]], au lounge de la station [[station/65]], qui fait commerce des coordonnées d'un système caché.", false],
	],
	"faction/6": [
		[0, "", "Les Bobolians sont une race mineure sans systèmes propres. L'agent [[agent/13]], un Bobolian, se trouve au lounge de la station [[station/26]], en espace vossk, et vend les coordonnées d'un système caché.", false],
	],
	"faction/7": [
		[0, "", "Les Grey sont une race sans systèmes, stations ni vaisseaux propres. Ils ne jouent aucun rôle dans le commerce ni dans les combats.", false],
		[32, "", "Le seul Grey de l'histoire est [[character/20]], un scientifique qui travaille avec Deep Science ; voir [[world/khador]].", false],
		[33, "", "Il étudie les débris des vaisseaux voids et en tire un nouveau type de propulseur.", false],
	],
	"faction/8": [
		[0, "", "Les pirates sont des hors-la-loi de toutes les races. Ils ne possèdent aucun système mais surgissent partout, et ils sont toujours hostiles. La fréquence à laquelle ils guettent près d'une station dépend du niveau de sécurité du système. De nombreux contrats freelance vous demandent de les traquer, et leurs épaves peuvent être pillées pour récupérer leur cargaison.", false],
		[0, "", "L'histoire commence alors que [[character/0]] pourchasse une bande de pirates pour la prime offerte pour leur capture.", false],
		[2, "", "Le [[ship/0]], le vaisseau que [[character/2]] prête à [[character/0]], était autrefois un vaisseau pirate.", false],
		[16, "", "C'est pourquoi les Terriens le prennent plus tard pour un pirate.", false],
		[19, "", "Des pirates enlèvent aussi [[character/5]] près de la station [[station/55]] et exigent une rançon.", false],
	],
	"faction/9": [
		[0, "", "Les Voids sont une force hostile qui attaque sans prévenir. Ils ne possèdent aucun système sur la carte, et leurs vaisseaux ouvrent le feu sur tout le monde. Leur chasseur, le [[ship/8]], est la coque la plus lourdement blindée du jeu. Voir [[world/voids]].", false],
		[2, "", "Dans [[system/15]], les Voids ne sont connus que par des rumeurs et de rares observations.", false],
		[16, "", "Une escadrille void attaque la station [[station/98]] pendant que [[character/0]] s'y trouve. Leurs messages radio affirment des intentions pacifiques pendant qu'ils tirent.", false],
		[18, "", "Les Voids arrivent par des trous de ver qui s'ouvrent près des stations pour peu de temps. Ils pillent indifféremment les systèmes terriens, nivéliens et vossk et semblent chercher du minerai. Personne ne sait d'où ils viennent.", false],
		[24, "", "Près de la station [[station/48]], ils diffusent une affirmation plus étrange encore : ils viendraient du futur et seraient tout ce qui reste des civilisations de la galaxie.", false],
		[26, "", "Un trou de ver mène à leur propre secteur, où un immense vaisseau-mère lance leurs chasseurs.", false],
		[35, "", "Le vaisseau-mère semble être la source des trous de ver.", false],
		[42, "", "La destruction du vaisseau-mère lors de l'[[step/41]] provoque l'effondrement des trous de ver et met fin aux raids, du moins pour le moment.", false],
	],
	"guide/basics": [
		[0, "L'ouverture", "Une nouvelle partie commence dans l'espace et non dans une station. [[character/0]] pourchasse une bande de pirates à travers un champ d'astéroïdes, et le premier vol est un court combat qui enseigne à piloter, viser et tirer. Pendant ce temps, seuls le viseur et les marqueurs de vaisseaux sont affichés. Détruisez les pirates et laissez la scène se dérouler ; l'histoire avance ensuite d'elle-même.", false],
		[2, "", "Après l'ouverture, vous vous réveillez à la station [[station/78]], une petite station minière dirigée par [[character/2]]. Il vous prête le [[ship/0]], un vaisseau sans armes équipé d'un laser d'extraction, et les premières étapes vous apprennent l'extraction minière, le pilote automatique et l'amarrage. Les armes, la carte et le reste de la station se débloquent au fil de l'histoire.", false],
		[0, "L'amarrage", "Pour vous amarrer, gardez le viseur sur une station jusqu'au verrouillage, puis appuyez sur Tir : le pilote automatique prend le relais et vous fait entrer. Vous pouvez aussi entrer dans la station vous-même ; le vaisseau s'amarre dès qu'il touche la coque. C'est à l'amarrage que se règlent la plupart des comptes. Votre coque, votre blindage et vos boucliers sont restaurés gratuitement, les livraisons et les passagers sont remis, les produits fabriqués à partir de plans sont récupérés, les nouvelles médailles sont décernées et la partie se sauvegarde d'elle-même.", false],
		[0, "Les écrans de la station", "Une station où vous êtes amarré propose six sections : Hangar, Space Lounge, Map, Missions, Status et Game Options. Au début de l'histoire, certaines sont verrouillées et marquées d'un cadenas. Le Hangar s'ouvre à l'[[step/5]], la Map à l'[[step/9]], et le Space Lounge et les Missions à l'[[step/13]]. Status et Game Options sont toujours disponibles.", false],
		[0, "", "Le Hangar regroupe Shop (achat et vente de marchandises et d'équipements), Ship (installation et retrait d'équipements), Ships (le concessionnaire, dans les stations qui en ont un) et Blueprints (production). Le Space Lounge est l'endroit où attendent clients, négociants et pilotes à louer. La Map affiche la galaxie et permet de choisir une destination. Missions liste l'objectif actuel de l'histoire et le contrat freelance que vous avez accepté. Status affiche vos états de service, votre réputation auprès des quatre grandes races et vos médailles. La barre supérieure indique le Tec Level de la station, qui détermine ce que sa boutique peut proposer.", false],
		[0, "Quitter une station", "Appuyez sur Depart pour décoller. Chaque vol commence par quelques secondes où l'on voit votre vaisseau partir, avec les détails du système et une astuce ; n'importe quelle touche, un clic ou un toucher permet de passer. Si vous avez choisi une destination sur la Map avant de partir, le pilote automatique met le cap dessus dès la fin du départ. Vous ne pouvez pas partir avec plus de marchandises que la soute ne peut en contenir ; vendez ou installez d'abord l'excédent.", false],
		[0, "Sauvegarder", "La partie se sauvegarde automatiquement après chaque amarrage réussi, une fois les récompenses et l'étape suivante de l'histoire réglées. Vous pouvez aussi sauvegarder à la main dans l'un des trois emplacements depuis Game Options pendant que vous êtes amarré, et charger n'importe quel emplacement ou la sauvegarde automatique depuis cet écran ou depuis l'écran titre. Hors de la version navigateur, Game Options permet aussi d'exporter une sauvegarde dans un fichier et de la réimporter. Les sauvegardes sont liées aux données de jeu avec lesquelles elles ont été créées.", false],
		[0, "", "Si votre vaisseau est détruit, le vol prend fin et vous reprenez depuis la station de votre dernière sauvegarde automatique, ou recommencez s'il n'y en a pas. Tout ce qui a été gagné depuis cet amarrage est perdu ; amarrez-vous donc de temps en temps lors des longs trajets.", false],
		[0, "Niveau de pilote", "Votre pilote a un niveau, affiché sur l'écran Status. L'expérience provient des vaisseaux abattus, des contrats freelance (deux points chacun), des noyaux extraits, de chaque tranche de cinquante tonnes de minerai extrait et de chaque paire d'ailiers engagés. Le niveau augmente d'un cran chaque fois que l'expérience dépasse 1,3 fois la valeur qu'elle avait lors de la dernière hausse, et il est vérifié à l'amarrage. Un niveau plus élevé rend les ennemis plus coriaces, mais augmente aussi les récompenses des contrats freelance et les tarifs des pilotes engagés.", false],
	],
	"guide/blueprints": [
		[0, "Plans", "Certaines des meilleures armes et des meilleurs équipements ne sont jamais vendus en boutique. Ils se construisent à partir de plans. Un plan indique les marchandises nécessaires et en quelles quantités. Les plans s'achètent auprès d'agents nommés au Space Lounge, qui apparaissent une fois l'histoire passée au-delà de l'[[step/16]] ; chaque agent vend un plan, une seule fois.", false],
		[34, "", "Le plan du moteur de saut [[item/85]] n'est vendu par personne : l'histoire vous le remet lors de l'[[step/34]].", false],
		[0, "Production", "La production a lieu dans l'onglet Blueprints du Hangar. Choisissez un plan et fournissez des ingrédients depuis votre soute. Vous pouvez les livrer en plusieurs fois, sur plusieurs visites. La station où vous livrez en premier devient la station de production de ce lot. Les ingrédients livrés dans toute autre station y sont expédiés pour 10 crédits la tonne ; il est donc avantageux de tout apporter au même endroit.", false],
		[0, "Produits finis", "Quand le dernier ingrédient est fourni, le lot est terminé. Les armes secondaires sont fabriquées par dix ; tout le reste à l'unité. Si vous terminez à la station de production, les produits vont directement dans votre soute, même si cela la surcharge. Sinon, ils attendent à la station de production et vous sont remis la prochaine fois que vous vous y amarrez. Un plan ne s'use jamais : une fois un lot terminé, vous pouvez lancer le suivant.", false],
		[0, "Médailles", "Posséder des plans compte pour [[medal/13]], et terminer différents plans pour [[medal/14]].", false],
	],
	"guide/combat": [
		[0, "Armes principales", "Les armes principales sont des canons fixes qui tirent vers l'avant : lasers, blasters, autocanons et armes thermiques. Chacune a ses propres dégâts, cadence de tir, portée et vitesse de projectile, et toutes les armes principales installées tirent ensemble. Certains blasters, comme le [[item/16]], sont des armes IEM qui drainent l'énergie d'un vaisseau au lieu d'endommager sa coque. Le Tir automatique maintient le feu sur la cible sans avoir à garder le bouton enfoncé.", false],
		[0, "Boucliers, blindage et coque", "Les dégâts vident d'abord le bouclier, puis la plaque de blindage, et seulement ensuite la coque elle-même. Un bouclier se recharge entièrement au cours de son temps de recharge ; le blindage et la coque, non. Un robot de réparation répare lentement la coque et le blindage en vol. L'amarrage restaure tout gratuitement. Quand la coque est épuisée, le vaisseau est détruit.", false],
		[0, "IEM", "Chaque vaisseau dispose d'une réserve d'énergie. Les armes IEM la drainent, et un vaisseau dont l'énergie est épuisée est neutralisé : il dérive sans défense jusqu'à ce que son énergie se soit reconstituée. On peut dépouiller un vaisseau neutralisé de sa cargaison avec un rayon tracteur, et certains contrats exigent de neutraliser un vaisseau plutôt que de le détruire. Les équipements de protection IEM, comme le [[item/60]], ont une valeur de défense IEM.", false],
		[0, "Armes secondaires", "Les armes secondaires tirent depuis les emplacements secondaires et consomment des munitions, qui s'empilent dans l'emplacement. Les roquettes volent en ligne droite. Les torpilles suivent la cible verrouillée au radar peu après le lancement. Les bombes IEM et les armes nucléaires explosent sur une zone et touchent tout ce qui se trouve dans leur rayon, plus faiblement vers le bord ; les bombes IEM épargnent les astéroïdes, tandis que les armes nucléaires les brisent. Choisissez le lanceur à utiliser dans le menu Actions ; tant que vous ne l'avez pas fait, la touche Arme secondaire tire avec le premier lanceur chargé.", false],
		[0, "Tourelles", "Les coques plus grandes ont des emplacements de tourelle. Avec une tourelle installée, la touche Vue arrière passe en vue tourelle : le vaisseau garde son cap pendant que vous orientez la tourelle et faites feu, ce qui permet de riposter aux vaisseaux qui vous talonnent.", false],
		[0, "Ailiers", "À partir de l'[[step/16]], on peut rencontrer des pilotes à louer au Space Lounge. Un contrat couvre un à trois vaisseaux pour dix minutes de vol, et ils vous accompagnent partout jusqu'à son expiration. Donnez-leur des ordres depuis le menu Actions : tirer à volonté, attaquer votre cible, sécuriser le prochain point de passage de mission, ou passer de leur laser à leur blaster IEM. Voir [[guide/lounge]].", false],
		[0, "Pirates", "Les pirates attaquent les stations, plus souvent dans les systèmes dangereux, et guettent les pilotes qui transportent du fret ou des passagers. De nombreux contrats freelance consistent à les combattre. Abattre des pirates ne fâche personne ; cela améliore légèrement votre réputation auprès de la race qui gouverne le système.", false],
		[0, "Réputation", "Votre réputation est mesurée sur deux échelles, chacune de -100 à 100 : l'une entre les races [[faction/0|terrienne]] et [[faction/1|vossk]], l'autre entre les races [[faction/2|nivélienne]] et [[faction/3|midorienne]]. Nuire à une race fait pencher l'échelle vers sa rivale : neutraliser ou dépouiller l'un de ses vaisseaux coûte 2 points, en abattre un en coûte 5. Accomplir un contrat freelance fait pencher l'échelle de 2 points vers la race du client. Dès qu'une échelle dépasse 60 dans un sens ou dans l'autre, la race du côté perdant devient hostile, et ses vaisseaux vous attaquent à vue.", false],
		[0, "", "Une race hostile envoie un diplomate dans les Space Lounges, qui propose de ramener l'échelle à zéro moyennant des frais qui augmentent selon l'écart : 16 000 crédits au maximum. Status affiche les deux échelles. Faire dépasser 60 à une échelle rapporte aussi [[medal/28]].", false],
		[0, "Tirs amis", "Les vaisseaux de la race qui gouverne un système ne tolèrent les tirs égarés que jusqu'à un certain point. Dès que vous avez enlevé un tiers de la coque ou de l'énergie d'un vaisseau local, il riposte et vous avertit par radio. Aux deux tiers de sa coque, ou si vous le neutralisez, tous les vaisseaux de cette race présents dans le système se retournent contre vous. Les vaisseaux des autres races sont moins susceptibles, mais en abattre un coûte toujours de la réputation.", false],
	],
	"guide/fitting": [
		[0, "Coques", "La coque d'un vaisseau détermine son blindage (la résistance propre de la coque), sa soute, sa maniabilité et ses emplacements : armes principales, armes secondaires, tourelles et équipements. Une meilleure coque signifie surtout plus d'emplacements. Les pages des vaisseaux comparent toutes les coques.", false],
		[0, "Emplacements et écran Ship", "Les articles s'achètent dans la soute, puis s'installent sur l'écran Ship du Hangar. Chaque emplacement accueille un article de sa catégorie ; installer un article sur un emplacement occupé renvoie l'ancien dans la soute. Chaque type d'équipement ne peut être installé qu'une fois, sauf les types empilables, comme les compresseurs de soute, les cabines et la protection IEM, dont on peut installer plusieurs exemplaires, chacun dans son propre emplacement. Les munitions secondaires d'un même type partagent un seul emplacement. Un article installé peut aussi être vendu directement depuis son emplacement, au prix de la station.", false],
		[0, "Types d'équipement", "Les boucliers absorbent les dégâts et se rechargent. Les plaques de blindage renforcent la coque. La protection IEM protège contre le drainage d'énergie. La compression de soute agrandit la soute. Les rayons tracteurs attirent la cargaison des épaves et des vaisseaux neutralisés ; sans eux, rien ne peut être ramassé dans l'espace. Les boosters donnent des poussées de vitesse. Les robots de réparation réparent le vaisseau en vol. Les tuyères de pilotage améliorent la maniabilité. Les scanners réduisent le temps de verrouillage d'une cible, et les meilleurs affichent sa cargaison. Les lasers d'extraction forent les astéroïdes. Les cabines transportent des passagers. Les dispositifs de camouflage cachent le vaisseau pendant un moment. Un moteur de saut permet de voyager sans portail.", false],
		[0, "Acheter une coque", "Les stations dotées d'un concessionnaire affichent dans le Hangar un onglet Ships avec jusqu'à cinq coques en vente. Les concessionnaires [[faction/1|vossk]] ne proposent que la coque de leur propre race, le [[ship/9]]. Un concessionnaire retire du prix catalogue un pourcentage égal au Tec Level de sa station ; les stations de haute technologie vendent donc les coques moins cher. Votre ancienne coque est reprise aux quatre cinquièmes de son prix catalogue. Tout ce qui est installé est transféré dans la soute ; vérifiez donc que tout y tient, ou vendez-en une partie avant de partir. Vous ne pouvez pas changer de coque avec des passagers à bord, et les cabines ne peuvent pas être retirées tant qu'elles sont occupées.", false],
		[5, "Premières armes", "Lorsque le hangar de la station [[station/78]] ouvre pour la première fois, son rayon propose gratuitement un laser, un autocanon et une plaque de blindage. Installez une arme et la plaque avant de partir pour la mission suivante.", false],
		[0, "Coques rares", "Certaines coques ne sont jamais proposées par les concessionnaires ordinaires. Un pilote qui a remporté toutes les médailles en or se voit proposer un prototype, le [[ship/8]], à la station [[station/10]] ; voir [[guide/medals]].", false],
	],
	"guide/flight": [
		[0, "Diriger", "Le vaisseau avance toujours. Vous le faites tourner à gauche et à droite et levez ou baissez son nez ; quand vous relâchez, il remet ses ailes à plat de lui-même. La vitesse de rotation dépend de la maniabilité de la coque et de la tuyère de pilotage éventuellement installée. Dans Options, Commandes, la Réponse des commandes peut être Directe, qui tourne immédiatement à pleine vitesse, ou Douce, qui adoucit l'entrée et la sortie des virages. Avec le pilotage à la souris, les touches gauche et droite peuvent faire glisser le vaisseau latéralement au lieu de le faire tourner.", false],
		[0, "Poussée", "Poussée + et Poussée − modifient la poussée par paliers d'un quart, et maintenir la touche continue de changer de palier. Le vaisseau met environ une seconde à se stabiliser à la nouvelle vitesse. Le pilote automatique et le booster volent toujours à pleine poussée, et réduire la poussée pendant un boost y met fin.", false],
		[0, "Booster", "Avec un booster installé, la touche Booster donne une poussée de vitesse supplémentaire. Elle dure le temps propre au booster et est suivie d'un temps de recharge avant la suivante ; le HUD indique s'il est prêt. Les meilleurs boosters sont plus rapides, durent plus longtemps ou se rechargent plus vite. Le boost est utile pour fuir un combat et pour franchir les longues distances à l'intérieur d'un système.", false],
		[0, "Pilote automatique", "La touche Pilote auto confie la barre à l'ordinateur de bord, et une nouvelle pression vous la rend. Il vole vers l'objet verrouillé, sinon vers la destination choisie sur la Map : le portail de saut si la destination se trouve dans un autre système, ou la planète de destination dans celui-ci. La Liste du pilote auto propose les choix disponibles là où vous êtes : la destination programmée, le portail de saut, cette station, le champ d'astéroïdes et le prochain point de passage de mission. Voler vers une station verrouillée se termine par un amarrage.", false],
		[0, "Vitesse du temps", "La touche Vitesse du temps fait défiler le vol plus vite. La vitesse double est toujours disponible en vol. Les vitesses quadruple et octuple ne sont proposées que lorsque le pilote automatique vole, qu'aucun ennemi n'est proche et que rien d'autre n'est en cours, comme une extraction, un amarrage ou un saut.", false],
		[0, "Ciblage", "Pour verrouiller un objet, gardez-le sous le viseur jusqu'à la fin du scan. Le scanner installé détermine la durée de l'opération, de plusieurs secondes avec un modèle de base à moins de deux avec le meilleur. Cible suivante fait défiler les objets proches sans avoir à les viser. Les stations, les portails de saut et les étoiles qui marquent les autres planètes se verrouillent d'une seule pression. L'effet de Tir dépend du verrouillage : sur un vaisseau, il tire ; sur une station, il amarre ; sur un portail, il saute ; sur une étoile, il vous emmène vers cette planète ; et sur un astéroïde, il lance l'extraction. Les meilleurs scanners affichent aussi la cargaison d'un vaisseau verrouillé.", false],
		[0, "Marqueurs et radar", "Les vaisseaux sont encadrés à l'écran, et des flèches au bord de l'écran indiquent la cible, la station et les menaces proches hors du champ de vision. Les ennemis sont marqués en rouge, les alliés en vert, les vaisseaux neutres en jaune et les points de passage de mission en bleu ; l'option Couleurs adaptées aux daltoniens, dans Options, Interface, les remplace par des ennemis orange et des alliés bleus. Un vaisseau proche affiche deux petites barres à côté de son cadre : sa coque et, en bleu, son énergie IEM. L'Affichage de vol Étendu ajoute des plaques avec les valeurs exactes et un écran radar rond ; l'affichage Original conserve les panneaux d'angle du jeu.", false],
		[0, "Regarder autour", "Vue arrière tourne la caméra vers l'arrière du vaisseau. Si une tourelle est installée, la même touche passe plutôt en vue tourelle : le vaisseau garde son cap pendant que vous orientez la tourelle et faites feu. Vous pouvez aussi regarder autour du vaisseau sans le diriger en maintenant Alt et en bougeant la souris, avec le stick droit de la manette, ou en faisant glisser un doigt sur une zone libre de l'écran.", false],
		[0, "Camouflage", "Un dispositif de camouflage cache votre vaisseau aux autres vaisseaux pendant sa durée d'action, et ceux qui vous traquent perdent immédiatement votre trace. Appuyez de nouveau sur la touche Dispositif de camouflage pour le couper plus tôt. Après usage, il lui faut un temps de recharge avant de fonctionner à nouveau.", false],
		[0, "Amarrage et voyage", "Verrouillez la station et appuyez sur Tir, ou entrez-y simplement, pour vous amarrer. Les autres stations du système apparaissent comme des étoiles brillantes ; verrouillez-en une et appuyez sur Tir pour voyager vers cette planète. La plupart des systèmes ont un portail de saut, près de l'une de leurs stations, pour voyager vers d'autres systèmes ; voir [[guide/navigation]]. Tant qu'un combat de contrat freelance est en cours près d'une station, vous ne pouvez ni vous amarrer, ni voyager, ni sauter ailleurs avant qu'il soit gagné ou perdu.", false],
	],
	"guide/help": [
		[0, "Clavier", "Voici les touches par défaut. Toutes les actions de vol peuvent être réattribuées dans Options, Commandes, Clavier, où Rétablir les touches par défaut annule les modifications.", false],
		[0, "", "Tourner à gauche / Tourner à droite : flèches gauche et droite, ou A et D.", true],
		[0, "", "Cabrer / Piquer : flèches haut et bas.", true],
		[0, "", "Poussée + / Poussée − : W et S.", true],
		[0, "", "Tir / utiliser : Espace ou Ctrl. Tire avec les canons, ou amarre, saute, voyage ou extrait lorsqu'une station, un portail, une étoile ou un astéroïde est verrouillé.", true],
		[0, "", "Arme secondaire : E.", true],
		[0, "", "Booster : Maj.", true],
		[0, "", "Pilote auto : Q. Liste du pilote auto : R. Avec l'option Maintenir le pilote auto pour la liste activée, maintenir Q une demi-seconde ouvre la liste.", true],
		[0, "", "Cible suivante : Tab.", true],
		[0, "", "Tir automatique : F.", true],
		[0, "", "Vue arrière : C. Avec une tourelle installée, passe en vue tourelle.", true],
		[0, "", "Actions / moteur de saut : M. Ouvre le menu Actions : choix de l'arme secondaire, camouflage, ordres aux ailiers et moteur de saut.", true],
		[0, "", "Carte des routes : N.", true],
		[0, "", "Dispositif de camouflage : V.", true],
		[0, "", "Vitesse du temps : T.", true],
		[0, "", "Mode photo : P. Fige le vol et masque l'interface ; faites glisser ou utilisez les touches fléchées pour tourner la caméra, et la molette ou + et - pour zoomer.", true],
		[0, "", "Menu pause : Échap. F11 bascule le plein écran sur les systèmes de bureau.", true],
		[0, "", "Dans les menus, les touches fléchées passent d'une entrée à l'autre, Entrée sélectionne et Échap revient en arrière.", true],
		[0, "Souris", "Avec le Pilotage à la souris activé, bouger la souris dirige le vaisseau. En vol, le pointeur est capturé, si bien que le vaisseau tourne au gré de vos mouvements ; l'option Capturer le pointeur en vol peut être désactivée, et les menus et les pauses libèrent toujours le pointeur. Le bouton gauche tire, le bouton droit lance l'arme secondaire, et maintenir Alt en bougeant la souris permet de regarder autour du vaisseau. Quand la souris pilote, les touches gauche et droite font glisser le vaisseau latéralement ; l'option Touches gauche / droite, dans Options, Commandes, peut les régler sur Toujours en latéral ou Toujours tourner. La Sensibilité de la souris règle l'amplitude de rotation du vaisseau pour un mouvement donné.", false],
		[0, "Manette", "Le stick gauche dirige et le stick droit permet de regarder autour du vaisseau. RT ou RB tire, LB lance l'arme secondaire, A active le boost, Y bascule le pilote automatique, X sélectionne la cible suivante, un clic du stick droit donne la vue arrière ou la vue tourelle, Back ouvre le menu Actions et Start met en pause. Dans les menus, la croix directionnelle déplace la sélection, A sélectionne et B revient en arrière. Options, Commandes, Manette règle la zone morte du stick et la vibration.", false],
		[0, "Tactile", "Sur les écrans tactiles, les commandes apparaissent à l'écran lorsque Commandes tactiles est réglé sur Automatique ou Activé. Un stick d'un côté sert à diriger ; par défaut, il vient sous votre pouce où qu'il se pose de ce côté, et Stick fixe le maintient en place. Piloter de partout permet de diriger avec un doigt posé sur n'importe quelle zone libre de l'écran. Les boutons de l'autre côté couvrent Tir / utiliser, Secondaire, Boost, Pilote auto, Cible, Vue arrière, Actions, Pause et, pendant les messages radio, Radio suivante. Un curseur règle la poussée, et un bouton Plus vite accélère le temps.", false],
		[0, "", "Touchez deux fois rapidement Tir pour activer le tir automatique ; une seule touche l'arrête. Faire glisser un doigt sur une zone libre de l'écran permet de regarder autour du vaisseau, et le relâcher ramène la vue vers l'avant. Disposition pour gaucher inverse les côtés, Taille des commandes tactiles redimensionne les commandes, et Ajuster la position des commandes permet de déplacer chacune d'elles. Les téléphones et tablettes peuvent aussi piloter par inclinaison : activez Piloter en inclinant, tenez l'appareil comme pour jouer et calibrez.", false],
		[0, "Options", "Les Options sont accessibles depuis l'écran titre, le menu pause et Game Options dans une station. Elles comptent cinq pages. Audio règle le volume de la musique et des sons. Affichage couvre la fenêtre, la fréquence d'images, le format d'image, ainsi que les préréglages et détails graphiques. Commandes couvre le pilotage, la souris, la manette, le tactile et les touches du clavier. Interface couvre la taille de l'interface, l'affichage de vol Original ou Étendu, la taille et l'opacité du HUD, les bulles d'aide, les séquences de départ et d'entrée dans la station, l'écran radar, les étiquettes, la taille du texte et les réglages d'accessibilité comme les couleurs adaptées aux daltoniens, la réduction des flashs, le tremblement de l'écran et la durée des messages. Jeu règle la langue du moteur et permet d'importer un autre fichier de jeu ou de gérer les mods.", false],
		[0, "Aide", "Help, accessible depuis les mêmes endroits, affiche les rubriques d'aide du jeu et les astuces de chargement, la liste des touches actuellement attribuées, et un tableau qui fait correspondre les touches de téléphone citées dans les textes du jeu aux touches, boutons et commandes tactiles utilisés ici.", false],
	],
	"guide/jobs": [
		[0, "Trouver du travail", "Les contrats freelance sont proposés par des clients au Space Lounge. Un client décrit le travail et la rémunération. Avant d'accepter un contrat ailleurs, vous pouvez demander où il se situe et quelle sera sa difficulté ; vous pouvez aussi demander à réentendre l'offre ou la refuser. Vous ne pouvez avoir qu'un contrat à la fois, et l'écran Missions l'affiche avec sa destination et le nombre de sauts par portail qui vous en séparent.", false],
		[0, "Types de contrats", "Il en existe treize types. Jusqu'à l'[[step/16]], et dans les versions du jeu sans la campagne complète, seuls cinq sont proposés : [[job/11]], [[job/0]], [[job/7]], [[job/4]] et [[job/12]]. Ensuite, toute la gamme apparaît : [[job/1]], [[job/2]], [[job/3]], [[job/5]], [[job/6]], [[job/9]] et [[job/10]], ainsi que des acheteurs qui veulent des marchandises ([[job/8]]).", false],
		[0, "Difficulté et récompense", "Les premiers contrats ont une difficulté de un ou deux ; les suivants vont jusqu'à neuf. La récompense de base d'un contrat est de 1 500 crédits, plus jusqu'à 5 500 de plus selon la difficulté. Elle est ensuite augmentée selon la distance jusqu'à la destination (doublée à 1 200 km), et 200 crédits sont ajoutés par niveau de pilote. L'enlèvement de débris paie 30 pour cent de moins, les escortes 20 pour cent de plus, la récupération et le sauvetage le double, et les contrats de passagers paient une base plus faible plus une part pour chaque passager. Les récompenses sont arrondies à cinquante crédits.", false],
		[0, "Accomplir un contrat", "Les contrats de coursier et de passagers s'accomplissent en s'amarrant à la destination avec le fret ou les passagers à bord. Les contrats d'achat s'accomplissent en revenant s'amarrer à la station de l'acheteur avec les marchandises dans la soute. Tous les autres contrats sont des combats près de la station de destination, déclenchés à votre arrivée ; tant que l'un d'eux est en cours, vous ne pouvez ni vous amarrer, ni voyager, ni sauter ailleurs. Les conteneurs récupérés et les otages doivent ensuite être ramenés à la station où vous avez accepté le contrat. Une fois le contrat accompli, la récompense est versée immédiatement, votre réputation auprès de la race du client s'améliore et le contrat compte pour [[medal/16]].", false],
		[0, "Échec", "Un combat échoue si sa condition n'est plus remplie : les vaisseaux que vous protégez sont tous détruits, le conteneur est perdu, le temps est écoulé ou le rival abat plus de cibles que vous. Un contrat échoué est annulé sans paiement. Vous pouvez aussi abandonner un contrat depuis l'écran Missions ; le fret éventuel est repris. Si votre vaisseau est détruit, vous reprenez depuis votre dernière sauvegarde automatique.", false],
	],
	"guide/lounge": [
		[0, "Les clients", "Chaque station a un Space Lounge, ouvert à partir de l'[[step/13]]. Trois à cinq clients y sont installés, et ils changent à chaque amarrage. La plupart appartiennent à la race qui gouverne le système, mais certains viennent de n'importe où. Parlez à un client pour savoir ce qu'il veut ; chaque réponse et chaque décision compte pour l'une des médailles de conversation.", false],
		[0, "Réponses", "« OK » accepte une offre, « No, thanks » la refuse et « How was that again? » la fait répéter. Pour un contrat ailleurs, vous pouvez demander « Can you show it on the map? » pour connaître la destination et « Will it be difficult? » pour savoir s'il est difficile. Les négociants vous laissent d'abord examiner leurs marchandises. Refuser des offres, demander des répétitions et accepter sans poser de questions comptent chacun pour [[medal/32]], [[medal/33]], [[medal/34]] et [[medal/35]] ; parler aux clients qui ont une offre compte pour [[medal/26]].", false],
		[0, "Clients et bavards", "De nombreux clients proposent des contrats freelance ; voir [[guide/jobs]]. D'autres se contentent de bavarder et de colporter des rumeurs, qui mentionnent parfois des stations ou des minerais utiles à connaître.", false],
		[0, "Négociants et acheteurs", "Les négociants vendent un lot unique : une pièce d'équipement ou quelques unités d'une matière première, entre 40 et 160 pour cent de son prix habituel. À partir de l'[[step/16]], des acheteurs apparaissent aussi, qui demandent qu'une quantité d'un article soit livrée à cette même station ; voir [[job/8]].", false],
		[0, "Pilotes à louer", "À partir de l'[[step/16]], un client par lounge peut proposer des ailiers : un à trois pilotes, pour 700 à 1 999 crédits par pilote, pour dix minutes de vol. Les pilotes [[faction/1|vossk]] ne sont jamais à louer. Vous ne pouvez avoir qu'un groupe à la fois. Un pilote qui détient toutes les médailles trouve plutôt des admirateurs, qui paient pour voler à ses côtés.", false],
		[0, "Agents", "Une fois l'histoire passée au-delà de l'[[step/16]], des agents nommés attendent dans certaines stations et concluent chacun une seule affaire. La plupart vendent un plan ; quatre vendent les coordonnées d'un système caché, qui apparaît alors sur la carte. Chaque agent s'en va après l'affaire. Les agents ont chacun leur propre page.", false],
		[0, "Diplomates", "Lorsque l'une des quatre grandes races est devenue hostile, l'un de ses diplomates est présent dans chaque lounge. Moyennant des frais qui augmentent avec la chute de votre réputation, jusqu'à 16 000 crédits, le diplomate ramène cette échelle de réputation à zéro.", false],
	],
	"guide/medals": [
		[0, "Niveaux", "La plupart des médailles existent en trois niveaux : bronze, argent et or. Chaque niveau a son propre objectif, et atteindre un niveau supérieur remplace la médaille inférieure. Quelques médailles n'ont qu'un seul niveau. Les pages des médailles indiquent l'objectif de chaque niveau.", false],
		[0, "Quand les médailles sont décernées", "Vos états de service sont vérifiés à l'approche d'une station, avant que le dock ne répare votre vaisseau, et les médailles nouvelles ou améliorées sont annoncées une fois amarré. Rien n'est décerné en vol ; un objectif atteint dans l'espace ne compte donc qu'au prochain amarrage. L'écran Status liste toutes les médailles que vous détenez, leur niveau et la raison de leur attribution.", false],
		[0, "La première et la dernière", "[[medal/0]] est détenue dès le début de la partie. [[medal/36]] est décernée automatiquement une fois toutes les autres médailles obtenues.", false],
		[0, "Récompenses", "Détenir toutes les médailles change la façon dont les pilotes du Space Lounge vous traitent : des admirateurs vous paient pour voler avec vous comme ailiers au lieu de vous facturer leurs services. Détenir toutes les médailles en or vous vaut l'offre du [[ship/8]], un prototype vendu à la station [[station/10]]. Sur l'écran Status, [[character/0]] porte des lunettes noires une fois qu'il détient toutes les médailles, et des lunettes dorées une fois toutes les médailles en or.", false],
	],
	"guide/mining": [
		[0, "Astéroïdes", "L'espace de chaque station contient des astéroïdes répartis en deux champs : l'un proche de la station et l'autre plus éloigné, vers lequel la Liste du pilote auto peut vous emmener. Les minerais présents dans un champ dépendent de la proximité du système avec le système d'origine de chaque minerai ; on ne trouve donc pas tous les minerais partout. Les astéroïdes peuvent aussi être réduits en miettes à coups de tir ; cela libère parfois un peu de minerai, et les astéroïdes détruits comptent pour [[medal/29]].", false],
		[0, "Commencer l'extraction", "L'extraction nécessite un laser d'extraction et de la place libre dans la soute. Verrouillez un astéroïde en le gardant sous le viseur, puis appuyez sur Tir. Le vaisseau s'approche de la roche et le forage commence ; le pilotage est bloqué jusqu'à ce que vous ayez fini. Une fois l'astéroïde verrouillé, le HUD affiche son minerai et sa classe.", false],
		[0, "Le forage", "Une jauge montre les couches rocheuses de l'astéroïde empilées les unes sur les autres, chacune plus étroite que la précédente. Le foret dérive d'un côté et change de direction au hasard toutes les demi-secondes à deux secondes et demie. Dirigez à gauche et à droite pour le maintenir dans la zone verte de la couche en cours. La première couche demande six secondes de forage, et chaque couche plus profonde environ un sixième de temps de moins que la précédente. Le minerai s'accumule tant que vous restez dans le vert, et plus vite dans les couches profondes.", false],
		[0, "Zones rouges", "Le temps passé hors de la zone verte compte comme des dégâts, et les zones rouges de la jauge s'agrandissent. Après deux secondes et demie passées dans le rouge au total, l'astéroïde se brise et tout ce qui en a été extrait est perdu. Appuyez sur Tir à tout moment pour arrêter et garder le minerai récolté jusque-là. Chaque astéroïde ne peut être exploité qu'une seule fois.", false],
		[0, "Classes et noyaux", "Les astéroïdes plus gros ont plus de couches, de deux à sept. Les plus gros, de classe A, en ont sept, et les traverser toutes rapporte un noyau en plus du minerai. Les noyaux valent bien plus que le minerai et comptent pour [[medal/3]] et [[medal/7]]. Les minerais comptent pour [[medal/2]] et [[medal/6]].", false],
		[0, "Lasers d'extraction", "Un laser d'extraction a deux caractéristiques. Son rendement fait dériver le foret plus lentement et le rend plus précis à diriger, ce qui aide à rester dans le vert. Sa vitesse augmente le rythme d'accumulation du minerai. Les lasers vont du [[item/86]] au [[item/89]] ; le [[item/90]] se construit à partir d'un plan.", false],
		[0, "Soute", "Le minerai et les noyaux vont directement dans la soute, et vous n'en gardez que ce qu'elle peut contenir. Quand la soute est pleine, le HUD l'indique et vous devez vendre ou décharger dans une station. Les compresseurs de soute agrandissent la soute d'une part de la capacité de la coque, et plusieurs peuvent être installés à la fois. Une coque plus grande aide plus que tout.", false],
	],
	"guide/navigation": [
		[0, "La carte de la galaxie", "La section Map d'une station, et la touche Carte des routes en vol, affichent la galaxie : chaque système connu à sa place, les liaisons par portail entre eux, la race dominante et le niveau de sécurité du système. Choisir un système zoome dessus et affiche ses stations ; choisir alors une station en fait votre destination. La carte indique aussi la distance d'un système en kilomètres, marque les stations que vous avez visitées et signale où se poursuivent l'histoire et votre contrat en cours. Un champ de recherche trouve les stations connues par leur nom. La page [[chart]] liste tous les systèmes.", false],
		[0, "", "Au début de l'histoire, vous êtes cantonné à l'orbite de votre première station. La carte s'ouvre à l'[[step/9]] ; vous pouvez ensuite voler vers les autres planètes du système.", false],
		[0, "Systèmes et sécurité", "Chaque système est gouverné par l'une des quatre grandes races et possède un niveau de sécurité : Sûr, Moyen, Risqué ou Dangereux. Les raids de pirates et d'ennemis sont bien plus fréquents dans les systèmes dangereux, tandis que les systèmes sûrs sont généralement calmes. La plupart des systèmes comptent plusieurs stations, chacune en orbite autour de sa propre planète, avec sa propre boutique, son lounge et son Tec Level.", false],
		[0, "Portails de saut", "On voyage d'un système à l'autre par les portails de saut. Un système a au plus un portail, situé dans l'espace de l'une de ses stations, qui ne mène qu'aux systèmes voisins. Pour sauter, choisissez sur la Map une destination dans un système voisin, volez jusqu'au portail (le pilote automatique vous y emmène), verrouillez-le et appuyez sur Tir une fois dans sa zone. Les longs voyages se font un portail à la fois ; l'écran Missions indique combien de sauts par portail une destination nécessite à travers les systèmes que vous connaissez.", false],
		[0, "Systèmes cachés", "Cinq systèmes sont d'abord absents de la carte : [[system/0]], [[system/1]], [[system/6]], [[system/10]] et [[system/21]]. Un système caché apparaît une fois que vous y êtes allé ou que vous avez acheté ses coordonnées. Quatre agents du Space Lounge les vendent : [[agent/12]] pour [[system/0]], [[agent/13]] pour [[system/1]], [[agent/14]] pour [[system/10]] et [[agent/15]] pour [[system/21]]. Les agents nommés n'apparaissent qu'une fois l'histoire passée au-delà de l'[[step/16]]. [[system/10]] n'a aucune liaison par portail et ne peut être atteint qu'avec un moteur de saut.", false],
		[23, "", "Le chemin vers [[system/6]] vous est donné par l'histoire lors de l'[[step/22]].", false],
		[0, "Moteur de saut", "Un moteur de saut emmène le vaisseau directement vers une station de n'importe quel système connu, sans portail. Le seul qui existe est le [[item/85]], qui n'est jamais vendu en boutique et doit être construit à partir de son plan. Utilisez-le depuis le menu Actions en vol. Un saut ne coûte ni carburant ni frais. Il est indisponible tant qu'un combat de contrat freelance est en cours près de votre station, mais les contrats de coursier et de passagers ne l'empêchent pas.", false],
		[34, "", "L'histoire vous donne le plan du [[item/85]] lors de l'[[step/34]], avec une partie de ses ingrédients déjà livrée.", false],
		[0, "Distance", "Les distances entre systèmes sont données en kilomètres, mesurées à partir de la position des systèmes sur la carte. La distance compte pour le commerce, car les prix augmentent avec l'éloignement de l'origine d'un article, et pour les contrats freelance, dont la récompense croît avec la distance jusqu'à la destination.", false],
	],
	"guide/tips": [
		[0, "", "Consultez la page d'un article avant une tournée commerciale : elle indique le système où l'article est le moins cher et la direction dans laquelle il devient plus cher.", true],
		[0, "", "Les stations achètent et vendent au même prix ; une cargaison ne rapporte donc de l'argent qu'une fois éloignée de son origine.", true],
		[0, "", "Pendant l'extraction, réagissez immédiatement à chaque changement de dérive. Le temps passé dans le rouge s'additionne sur tout le forage, si bien que de brefs écarts coûtent autant qu'un seul long.", true],
		[0, "", "Si le foret a déjà passé beaucoup de temps dans le rouge, arrêtez-le avec Tir et gardez ce que vous avez plutôt que de perdre toute la récolte.", true],
		[0, "", "Cherchez les plus gros astéroïdes si vous voulez des noyaux : seules les roches de classe A en contiennent un, et seulement si vous traversez les sept couches.", true],
		[0, "", "Installez tôt un rayon tracteur. Sans lui, impossible de ramasser la cargaison des épaves et des vaisseaux neutralisés.", true],
		[0, "", "Un meilleur scanner se rentabilise au combat : il verrouille les cibles plus vite, et les meilleurs montrent ce que transporte un vaisseau avant que vous ne l'attaquiez.", true],
		[0, "", "L'amarrage répare votre vaisseau gratuitement ; mieux vaut donc s'arrêter dans une station entre deux combats que de continuer avec une coque endommagée.", true],
		[0, "", "Amarrez-vous régulièrement lors des longs voyages. Seul un amarrage réussi crée une sauvegarde automatique, et un vaisseau détruit vous ramène à la dernière.", true],
		[0, "", "Surveillez votre réputation sur l'écran Status. Les tirs égarés sur les vaisseaux locaux s'accumulent, et toute une race peut devenir hostile.", true],
		[0, "", "Demandez à un client où se trouve le contrat et quelle sera sa difficulté avant d'accepter, sauf si vous visez les médailles récompensant le fait de ne pas demander.", true],
		[0, "", "Libérez de la place dans la soute avant d'accepter un contrat de coursier, et installez des cabines avant un contrat de passagers : ni l'un ni l'autre ne peut être accepté sans la place nécessaire.", true],
		[0, "", "Pour les contrats de récupération et de sauvetage, emportez une arme IEM, un scanner qui affiche la cargaison, un rayon tracteur et de la place libre dans la soute.", true],
		[0, "", "Apportez tous les ingrédients d'un plan à la station où vous l'avez lancé, et vous éviterez les frais d'expédition.", true],
		[0, "", "Engagez des ailiers juste avant un combat difficile : leur contrat ne s'écoule que pendant que vous volez.", true],
	],
	"guide/trading": [
		[0, "Comment les prix sont fixés", "Chaque article a un prix minimal, un prix maximal et un système d'origine. À l'origine, il se vend à son prix minimal ; plus une station est éloignée de l'origine, plus le prix est élevé, jusqu'au prix maximal à une distance donnée. Chaque station y ajoute en outre sa propre variation fixe, jusqu'à environ cinq pour cent dans un sens ou dans l'autre. Les pages des articles indiquent où un article est le moins cher et dans quelle direction il devient plus cher.", false],
		[0, "Acheter et vendre", "Une station achète au même prix qu'elle vend ; le profit ne vient donc que du transport des marchandises : achetez près de l'origine d'un article et vendez loin de celle-ci. Les marchandises que vous vendez s'ajoutent au rayon de la station. Le Shop retient aussi le prix le plus bas et le plus haut que vous avez vus pour chaque article, et dans quel système, et les affiche à côté de l'article. Certaines cargaisons ne peuvent pas être vendues, comme le fret de coursier et les conteneurs que vous transportez pour un client.", false],
		[0, "Ce que propose une boutique", "Chaque station a un Tec Level. Son rayon propose des articles de ce niveau ou d'un niveau inférieur ; les stations de niveau quatre ou plus excluent les articles inférieurs à la moitié de leur propre niveau. Chaque article a aussi une certaine chance de figurer dans un rayon donné, si bien que les rayons varient d'une visite à l'autre. Quelques articles sont toujours en rayon dans une station précise. Certaines marchandises ne sont vendues que dans les systèmes [[faction/1|vossk]], et les produits fabriqués à partir de plans ne sont jamais vendus.", false],
		[0, "", "Les matières premières sont proposées en plus grandes quantités, et en quantités bien plus grandes près de leur origine. Les armes et équipements sont généralement proposés par un à trois exemplaires, tandis que les roquettes, torpilles et bombes le sont par lots plus importants. Un rayon est réapprovisionné à chaque amarrage, sauf dans les trois dernières stations visitées, qui gardent leur rayon tel que vous l'avez laissé.", false],
		[0, "Alcools", "Chaque système a sa propre boisson locale, vendue uniquement dans ce système, comme le [[item/132]] dans [[system/0]] ou le [[item/146]] dans [[system/14]]. Les boissons sont des marchandises ordinaires. Les acheter en boutique compte pour [[medal/8]] ; posséder différentes sortes achetées à des négociants du Lounge ou récupérées sur des épaves compte pour [[medal/9]].", false],
		[0, "Autres sources", "Les négociants du Space Lounge proposent des lots uniques entre 40 et 160 pour cent du prix habituel ; leurs offres méritent donc d'être comparées. Les vaisseaux transportent des cargaisons que l'on peut récupérer avec un rayon tracteur quand ils sont détruits ou neutralisés, et le minerai peut être extrait. Les acheteurs du Lounge demandent une quantité d'un article précis et le paient bien au-dessus de sa valeur ; voir [[job/8]].", false],
	],
	"home": [
		[0, "", "Cette référence couvre Galaxy on Fire 2, un jeu spatial de commerce, d'extraction minière, de combat et d'exploration. Vous incarnez [[character/0]], un pilote chevronné échoué loin de chez lui, à travers 22 systèmes stellaires tenus par des humains et des races extraterrestres. Entre les missions de l'histoire, vous pouvez accepter des contrats freelance, exploiter des astéroïdes, faire du commerce, fabriquer de l'équipement à partir de plans et acheter des vaisseaux toujours meilleurs.", false],
		[0, "", "Les pages sont construites à partir du jeu que vous avez importé. Les noms, chiffres, prix et dialogues en proviennent, et les explications qui les accompagnent ont été rédigées pour cette référence. Les détails de l'histoire au-delà du point atteint par votre sauvegarde restent cachés jusqu'à ce que vous y arriviez. Pour commencer, consultez [[world/galaxy]], la [[chart]] et [[guide/basics]].", false],
	],
	"intro/agents": [
		[0, "", "Les agents sont des négociants installés dans certains Space Lounges, qui vendent ce que l'on ne trouve pas en boutique : un plan rare ou les coordonnées d'un système caché. Ils apparaissent à partir de l'[[step/17]], et chacun ne vend qu'une seule fois. Parlez-leur au lounge de leur station pour voir leur offre ; voir [[guide/lounge]].", false],
	],
	"intro/blueprints": [
		[0, "", "Les objets issus de plans ne sont jamais vendus en boutique. Chacun se construit à partir d'une recette de marchandises une fois que vous possédez son plan, qui s'achète généralement auprès d'un agent au Space Lounge. Le fonctionnement de la production est expliqué dans [[guide/blueprints]].", false],
	],
	"intro/characters": [
		[0, "", "Voici les personnes que [[character/0]] rencontre au cours de son voyage : négociants, officiers, scientifiques et compagnie plus étrange. Chaque biographie s'étoffe à mesure que l'histoire avance ; vous n'apprenez donc d'un personnage que ce que Keith lui-même a appris.", false],
	],
	"intro/equipment": [
		[0, "", "L'équipement occupe les emplacements d'équipement d'un vaisseau : boucliers et plaques de blindage pour la protection, compresseurs de soute, rayons tracteurs pour ramasser les conteneurs, boosters, tuyères de pilotage, scanners, lasers d'extraction, cabines de passagers, dispositifs de camouflage, un robot de réparation et le moteur de saut. Chaque pièce occupe un emplacement ; le nombre d'emplacements limite donc l'équipement complet d'un vaisseau. Les prix varient selon le système, et les boutiques ne proposent que des articles jusqu'au niveau technologique de leur station. Certaines des meilleures pièces se construisent à partir de plans, et plusieurs sont fabriquées par les [[faction/1|Vossk]] et vendues uniquement dans leurs systèmes.", false],
	],
	"intro/factions": [
		[0, "", "Dix factions apparaissent dans le jeu. Quatre d'entre elles possèdent des systèmes et des stations : les Terriens, les Vossk, les Nivéliens et les Midoriens. Les autres n'ont pas de territoire et ne se présentent à vous que sous forme d'individus ou d'ennemis. Votre réputation auprès des quatre grandes puissances est mesurée sur deux échelles, Terriens contre Vossk et Nivéliens contre Midoriens ; voir [[world/galaxy]].", false],
	],
	"intro/goods": [
		[0, "", "Les marchandises désignent tout ce que l'on transporte dans la soute pour le commerce. Les matières premières et les boissons s'achètent bon marché dans un système et se revendent cher dans un autre (voir [[guide/trading]]) ; chaque système a sa propre boisson. Les minerais s'extraient des astéroïdes, et forer toutes les couches d'un astéroïde de classe A rapporte un noyau d'une valeur bien supérieure (voir [[guide/mining]]). Les matières premières, minerais et noyaux sont aussi les ingrédients pour construire des objets à partir de plans. Quelques marchandises, comme [[item/116]] et [[item/131]], n'apparaissent que par les contrats ou l'histoire et ne peuvent pas être achetées.", false],
	],
	"intro/guide": [
		[0, "", "Ces pages expliquent comment se joue le jeu : piloter et combattre, extraire du minerai et commercer, les écrans des stations, le travail freelance, la production et les médailles. Les chiffres cités ici suivent les règles du moteur ; les tableaux des pages d'objets, de vaisseaux et de médailles proviennent de vos propres données de jeu. Commencez par [[guide/basics]] et [[guide/help]].", false],
	],
	"intro/jobs": [
		[0, "", "Les contrats freelance sont des travaux annexes proposés par des clients au Space Lounge, du transport de fret à la traque de criminels recherchés. Ils rapportent des crédits, de la réputation auprès de la race du client et de l'expérience. Il en existe treize types ; la façon dont ils sont proposés et payés est expliquée dans [[guide/jobs]].", false],
	],
	"intro/medals": [
		[0, "", "Les médailles récompensent les états de service d'un pilote : combat, extraction, commerce, voyages et même la façon dont vous parlez aux gens au Space Lounge. La plupart existent en bronze, argent et or. Elles sont vérifiées à chaque amarrage ; voir [[guide/medals]].", false],
	],
	"intro/ships": [
		[0, "", "Les vaisseaux diffèrent par leur blindage, leur soute, leur maniabilité et le nombre d'emplacements qu'ils offrent : emplacements principaux pour les canons avant, emplacements secondaires pour les roquettes, torpilles et bombes, un éventuel emplacement de tourelle, et des emplacements d'équipement pour tout le reste. Les prix grimpent fortement, de moins de 20 000 crédits pour les plus petites coques à plusieurs millions pour les meilleurs chasseurs. Les concessionnaires hors des systèmes [[faction/1|vossk]] présentent jusqu'à cinq coques à chaque visite ; les concessionnaires [[faction/1|vossk]] ne vendent que le [[ship/9]]. Un concessionnaire retire du prix catalogue un pourcentage égal au niveau technologique de sa station et reprend votre ancienne coque aux quatre cinquièmes de son prix catalogue. Le [[ship/0]] et le [[ship/10]] ne sont jamais vendus. Voir [[guide/fitting]] pour savoir comment équiper un vaisseau.", false],
	],
	"intro/stations": [
		[0, "", "Chaque station dispose d'une boutique, d'un hangar, d'un concessionnaire et d'un Space Lounge. Son niveau technologique, de 1 à 10, détermine le degré d'avancement des marchandises et équipements en rayon, et son concessionnaire retire autant de pour cent du prix catalogue des vaisseaux. Les stocks changent d'une visite à l'autre. Les stations citées dans l'histoire ou abritant un agent ont ici une courte description.", false],
	],
	"intro/story": [
		[0, "", "L'histoire suit [[character/0]], un pilote terrien dont la chasse aux pirates tourne mal, à travers 45 étapes. Chaque page d'étape présente la tâche puis, une fois celle-ci accomplie, ce qui s'est passé. Les pages ne révèlent que ce que votre sauvegarde a atteint ; [[world/history]] raconte l'histoire jusqu'ici en un seul endroit.", false],
	],
	"intro/systems": [
		[0, "", "La galaxie compte 22 systèmes stellaires. Chacun appartient à une faction, possède un niveau de sécurité qui détermine la fréquence des assaillants et compte jusqu'à cinq stations, dont l'une abrite le portail de saut. Les liaisons par portail déterminent entre quels systèmes vous pouvez voyager ; quelques systèmes sont cachés ou n'ont aucune liaison. Voir [[world/galaxy]] et la [[chart]].", false],
	],
	"intro/weapons": [
		[0, "", "Les armes se répartissent en deux groupes. Les armes principales (lasers, blasters, autocanons et armes thermiques) tirent sans munitions depuis les emplacements avant ; elles diffèrent par les dégâts par tir, la cadence de tir et la portée. Les armes secondaires (roquettes, torpilles, bombes IEM et armes nucléaires) s'achètent à l'unité et se tirent depuis les emplacements secondaires. Les tourelles nécessitent leur propre emplacement et peuvent tirer dans toutes les directions. Certaines armes drainent l'énergie d'un vaisseau au lieu de l'endommager, ou en plus ; un vaisseau à court d'énergie est neutralisé pendant un moment. Plusieurs des meilleures armes ne sont jamais vendues en boutique et doivent être construites à partir de plans (voir [[guide/blueprints]]). De nombreux modèles sont fabriqués par les [[faction/1|Vossk]] et ne sont proposés que dans leurs systèmes. Voir [[guide/combat]] pour la tactique.", false],
	],
	"intro/world": [
		[0, "", "Ces pages décrivent l'univers du jeu : la galaxie et sa géographie, son histoire et les forces qui la façonnent. Elles complètent les pages des systèmes, des stations et des factions par une vue d'ensemble.", false],
	],
	"item/0": [
		[0, "", "Le [[item/0]] est le laser d'entrée de gamme : 3 de dégâts par tir toutes les 0,4 s, avec la portée de 2 000 unités commune à tous les premiers lasers. C'est le laser le plus faible du jeu, mais il est bon marché et presque toutes les boutiques le proposent. Le [[item/1]] et le [[item/2]] conservent la même cadence de tir et ajoutent des dégâts.", false],
		[6, "", "C'est l'une des trois pièces que [[character/2]] offre gratuitement dans son hangar de la station [[station/78]] avant le raid sur le repaire des pirates, avec le [[item/22]] et le [[item/55]].", false],
	],
	"item/1": [
		[0, "", "Le [[item/1]] est le deuxième échelon de la gamme Nirai. Il tire aussi vite que le [[item/0]] (toutes les 0,4 s), mais inflige 5 de dégâts par tir au lieu de 3, avec la même portée. C'est une amélioration bon marché en attendant de pouvoir s'offrir le [[item/2]].", false],
	],
	"item/10": [
		[0, "", "Le [[item/10]] inflige 34 de dégâts toutes les 1,4 s avec une portée de 2 600. Il frappe plus fort par tir que le [[item/9]] et porte plus loin, avec une cadence de tir un peu plus lente. C'est le laser le plus puissant vendu en boutique.", false],
	],
	"item/11": [
		[0, "", "Le [[item/11]] est le laser le plus puissant du jeu : 45 de dégâts toutes les 1,5 s avec une portée de 2 600, le tir unique le plus lourd de toutes les armes principales. Il n'est jamais vendu tout fait. Son plan s'obtient auprès de [[agent/0]] à la station [[station/3]], et sa fabrication consomme un [[item/9]] ainsi que du [[item/155]] et plusieurs matières premières.", false],
	],
	"item/116": [
		[0, "", "Les conteneurs sécurisés sont du fret scellé qui n'apparaît que par le travail freelance. Accepter un contrat [[job/0]] charge le nombre convenu dans votre soute, où ils occupent de l'espace ; ils ne peuvent pas être vendus et sont remis à destination. Ils représentent aussi les marchandises volées dans les contrats [[job/3]], où le vaisseau qui les transporte doit être neutralisé plutôt que détruit.", false],
	],
	"item/117": [
		[0, "", "Une cabine sécurisée est une cargaison spéciale qui n'apparaît que par le travail freelance, dans les contrats [[job/5]] qui vous demandent de libérer un captif retenu à bord de l'un de plusieurs vaisseaux et de le ramener. Comme un [[item/116]], elle ne peut être ni achetée ni vendue.", false],
	],
	"item/12": [
		[0, "", "Le [[item/12]] est le blaster [[faction/1|vossk]] de base : 11 de dégâts toutes les 0,6 s avec une portée de 1 500. Les blasters portent moins loin que les lasers mais frappent plus fort dans la durée ; même ce premier modèle inflige un peu plus de dégâts que le meilleur laser Nirai. Il est aussi nécessaire pour construire le [[item/15]]. Seules les boutiques des systèmes [[faction/1|vossk]] le proposent.", false],
	],
	"item/13": [
		[0, "", "Le [[item/13]] est un blaster [[faction/1|vossk]] qui inflige 12 de dégâts toutes les 0,5 s avec une portée de 1 500, un net progrès par rapport au [[item/12]] en cadence et en dégâts. Seules les boutiques des systèmes [[faction/1|vossk]] le proposent.", false],
	],
	"item/131": [
		[0, "", "Les [[item/131]] sont les débris des chasseurs [[faction/9|voids]]. Chaque vaisseau [[faction/9|void]] hostile détruit lâche un conteneur qui en contient un à trois, que l'on ne peut ramasser qu'avec un rayon tracteur (voir [[item/68]]). Ils se vendent à un prix fixe de 199 crédits, et leur collecte compte pour la médaille [[medal/21]].", false],
		[24, "", "[[character/6]] a besoin de ces débris pour ses recherches et envoie [[character/0]] en collecter près de la station [[station/48]].", false],
		[25, "", "Tant que [[character/0]] les rapporte, les débris ne peuvent pas être vendus.", false],
		[28, "", "Ils sont remis à l'équipe de [[character/6]] à l'arrivée à la station [[station/10]].", false],
	],
	"item/14": [
		[0, "", "Le [[item/14]] est un blaster [[faction/1|vossk]] qui tire toutes les 0,4 s pour 10 de dégâts. Il inflige un peu plus de dégâts dans la durée que le [[item/13]], mais sa portée de 1 000 est courte ; il convient donc aux pilotes qui serrent leurs cibles de près. Seules les boutiques des systèmes [[faction/1|vossk]] le proposent.", false],
	],
	"item/15": [
		[0, "", "Le [[item/15]] est le meilleur blaster [[faction/1|vossk]] : 10 de dégâts toutes les 0,3 s avec une portée de 1 500. Il allie la cadence des blasters les plus rapides à la portée du [[item/12]]. Il n'est jamais vendu tout fait. Son plan s'obtient auprès de [[agent/1]] à la station [[station/8]], et sa fabrication consomme un [[item/12]] et un [[item/166]] ainsi que plusieurs matières premières.", false],
	],
	"item/154": [
		[0, "", "Le minerai [[item/154]] est le minerai ordinaire le plus précieux. Les champs d'astéroïdes privilégient les minerais dont le système d'origine est proche ; le sien est [[system/9]], où il est aussi le moins cher. Il en faut en quantité pour construire le [[item/27]]. Forer jusqu'au bout un astéroïde de [[item/154]] de classe A donne un [[item/165]].", false],
	],
	"item/155": [
		[0, "", "Le minerai [[item/155]] est un minerai de prix moyen dont le système d'origine est [[system/21]], où il se vend le moins cher. C'est un ingrédient du [[item/11]] et du [[item/90]]. Son noyau est le [[item/166]].", false],
	],
	"item/156": [
		[0, "", "Le minerai [[item/156]] est le minerai le moins cher, originaire de [[system/0]]. Sa faible valeur en fait une piètre cargaison à vendre, mais c'est un ingrédient de la plaque de blindage [[item/59]]. Son noyau est le [[item/167]].", false],
	],
	"item/157": [
		[0, "", "Le minerai [[item/157]] est un minerai de prix moyen dont le système d'origine est [[system/7]]. Avec son noyau, le [[item/168]], il est nécessaire pour construire la plaque de blindage [[item/59]].", false],
	],
	"item/158": [
		[0, "", "Le minerai [[item/158]] est un minerai de prix moyen dont le système d'origine est [[system/4]]. C'est l'un des minerais nécessaires au [[item/85]]. Son noyau est le [[item/169]].", false],
	],
	"item/159": [
		[0, "", "Le minerai [[item/159]] est un minerai de prix moyen dont le système d'origine est [[system/18]]. Aucun plan ne l'utilise ; on ne l'extrait donc que pour le vendre ou pour les médailles de minerai. Son noyau est le [[item/170]].", false],
	],
	"item/16": [
		[0, "", "Le [[item/16]] est le premier blaster IEM. Il n'inflige aucun dégât à la coque ni au blindage ; chaque impact draine plutôt 3 points d'énergie d'un vaisseau, et un vaisseau dont l'énergie tombe à zéro est neutralisé pendant un moment. Les canons IEM sont nécessaires quand une cible doit être arrêtée plutôt que détruite. Ce modèle tire toutes les 0,3 s mais ne porte qu'à 1 200 unités. Le [[item/17]] et le [[item/18]] portent plus loin et drainent davantage par tir.", false],
	],
	"item/160": [
		[0, "", "Le minerai [[item/160]] est un minerai bon marché dont le système d'origine est [[system/13]]. C'est l'un des minerais nécessaires au [[item/85]]. Son noyau est le [[item/171]].", false],
	],
	"item/161": [
		[0, "", "Le minerai [[item/161]] est un minerai de prix moyen dont le système d'origine est [[system/19]]. Aucun plan ne l'utilise. Son noyau est le [[item/172]].", false],
	],
	"item/162": [
		[0, "", "Le minerai [[item/162]] est un minerai de prix moyen dont le système d'origine est [[system/14]]. Aucun plan ne l'utilise. Son noyau est le [[item/173]].", false],
	],
	"item/163": [
		[0, "", "Le minerai [[item/163]] est un minerai de prix moyen dont le système d'origine est [[system/5]]. C'est l'ingrédient principal du [[item/54]], qui en demande 80 t, et il est aussi nécessaire au [[item/85]]. Son noyau est le [[item/174]].", false],
	],
	"item/164": [
		[0, "", "Les [[item/164]] sont un minerai que l'on ne trouve jamais dans les champs d'astéroïdes des systèmes habités. Contrairement aux autres minerais, un astéroïde de cristal ne laisse rien derrière lui quand on le détruit à coups de tir ; les cristaux doivent donc être forés. Ils sont l'ingrédient clé du [[item/85]], qui en demande 50.", false],
		[25, "", "Tous les astéroïdes de l'espace d'origine des [[faction/9|Voids]], accessible par leurs trous de ver, sont faits de ces cristaux.", false],
		[33, "", "[[character/20]] demande à [[character/0]] de lui rapporter au moins 50 cristaux, qui selon lui détiennent le secret des trous de ver des [[faction/9|Voids]].", false],
	],
	"item/165": [
		[0, "", "Ce noyau est le cœur rare d'un astéroïde de [[item/154]] de classe A. On l'obtient en forant les sept couches d'un tel astéroïde, et il arrive qu'un noyau tombe quand un astéroïde de classe A est détruit à coups de tir. Il se vend plusieurs fois le prix du minerai lui-même, le moins cher à [[system/9]]. C'est le noyau le plus précieux après le [[item/175]].", false],
	],
	"item/166": [
		[0, "", "Ce noyau est le cœur rare d'un astéroïde de [[item/155]] de classe A. On l'obtient en forant les sept couches d'un tel astéroïde, et il arrive qu'un noyau tombe quand un astéroïde de classe A est détruit à coups de tir. Il se vend plusieurs fois le prix du minerai lui-même, le moins cher à [[system/21]]. Il est nécessaire pour construire le [[item/15]] et, par dix, le [[item/90]].", false],
	],
	"item/167": [
		[0, "", "Ce noyau est le cœur rare d'un astéroïde de [[item/156]] de classe A. On l'obtient en forant les sept couches d'un tel astéroïde, et il arrive qu'un noyau tombe quand un astéroïde de classe A est détruit à coups de tir. Il se vend plusieurs fois le prix du minerai lui-même, le moins cher à [[system/0]]. C'est le noyau le moins précieux.", false],
	],
	"item/168": [
		[0, "", "Ce noyau est le cœur rare d'un astéroïde de [[item/157]] de classe A. On l'obtient en forant les sept couches d'un tel astéroïde, et il arrive qu'un noyau tombe quand un astéroïde de classe A est détruit à coups de tir. Il se vend plusieurs fois le prix du minerai lui-même, le moins cher à [[system/7]]. Il en faut quinze pour construire le [[item/59]].", false],
	],
	"item/169": [
		[0, "", "Ce noyau est le cœur rare d'un astéroïde de [[item/158]] de classe A. On l'obtient en forant les sept couches d'un tel astéroïde, et il arrive qu'un noyau tombe quand un astéroïde de classe A est détruit à coups de tir. Il se vend plusieurs fois le prix du minerai lui-même, le moins cher à [[system/4]].", false],
	],
	"item/17": [
		[0, "", "Le [[item/17]] draine 5 d'énergie par impact toutes les 0,5 s et porte à 2 000 unités, bien plus loin que le [[item/16]]. Il n'inflige aucun dégât à la coque. Il draine l'énergie à peu près au même rythme que le Mk I, mais depuis une distance plus sûre.", false],
	],
	"item/170": [
		[0, "", "Ce noyau est le cœur rare d'un astéroïde de [[item/159]] de classe A. On l'obtient en forant les sept couches d'un tel astéroïde, et il arrive qu'un noyau tombe quand un astéroïde de classe A est détruit à coups de tir. Il se vend plusieurs fois le prix du minerai lui-même, le moins cher à [[system/18]].", false],
	],
	"item/171": [
		[0, "", "Ce noyau est le cœur rare d'un astéroïde de [[item/160]] de classe A. On l'obtient en forant les sept couches d'un tel astéroïde, et il arrive qu'un noyau tombe quand un astéroïde de classe A est détruit à coups de tir. Il se vend plusieurs fois le prix du minerai lui-même, le moins cher à [[system/13]].", false],
	],
	"item/172": [
		[0, "", "Ce noyau est le cœur rare d'un astéroïde de [[item/161]] de classe A. On l'obtient en forant les sept couches d'un tel astéroïde, et il arrive qu'un noyau tombe quand un astéroïde de classe A est détruit à coups de tir. Il se vend plusieurs fois le prix du minerai lui-même, le moins cher à [[system/19]].", false],
	],
	"item/173": [
		[0, "", "Ce noyau est le cœur rare d'un astéroïde de [[item/162]] de classe A. On l'obtient en forant les sept couches d'un tel astéroïde, et il arrive qu'un noyau tombe quand un astéroïde de classe A est détruit à coups de tir. Il se vend plusieurs fois le prix du minerai lui-même, le moins cher à [[system/14]].", false],
	],
	"item/174": [
		[0, "", "Ce noyau est le cœur rare d'un astéroïde de [[item/163]] de classe A. On l'obtient en forant les sept couches d'un tel astéroïde, et il arrive qu'un noyau tombe quand un astéroïde de classe A est détruit à coups de tir. Il se vend plusieurs fois le prix du minerai lui-même, le moins cher à [[system/5]].", false],
	],
	"item/175": [
		[0, "", "Le [[item/175]] est le noyau d'un astéroïde de [[item/164]] de classe A. Comme les astéroïdes de cristal ne laissent rien quand on les détruit à coups de tir, le seul moyen de l'obtenir est de forer les sept couches. Il se vend à un prix fixe de 5 000 crédits, plus de cinq fois le meilleur prix de tout autre noyau.", false],
		[25, "", "On ne le trouve que dans l'espace d'origine des [[faction/9|Voids]].", false],
	],
	"item/18": [
		[0, "", "Le [[item/18]] est le blaster IEM le plus puissant : 8 d'énergie par impact toutes les 0,5 s avec une portée de 2 000, ce qui neutralise les vaisseaux sensiblement plus vite que le [[item/17]]. Comme les autres blasters IEM, il n'inflige aucun dégât à la coque.", false],
	],
	"item/19": [
		[0, "", "Le [[item/19]] inflige 15 de dégâts toutes les 0,3 s avec une portée de 1 400. Il frappe bien plus fort dans la durée que n'importe quel laser. Le [[item/20]] et le [[item/21]] tirent plus vite mais ne portent qu'à 1 000 unités.", false],
	],
	"item/2": [
		[0, "", "Le [[item/2]] est le meilleur laser Nirai : 7 de dégâts toutes les 0,4 s. Chaque tir est plus faible que ceux des lasers Berger, mais comme il tire environ deux fois plus souvent, il inflige plus de dégâts dans la durée que chacun d'eux, y compris le [[item/8]]. Seuls les lasers à faisceau M6 (le [[item/9]] et ses successeurs) le surpassent nettement.", false],
	],
	"item/20": [
		[0, "", "Le [[item/20]] tire toutes les 0,2 s pour 13 de dégâts. Dans la durée, il surpasse le [[item/19]], mais sa portée n'est que de 1 000 unités ; il est donc plus efficace à courte distance.", false],
	],
	"item/21": [
		[0, "", "Le [[item/21]] inflige 14 de dégâts toutes les 0,2 s, les dégâts dans la durée les plus élevés de tous les canons avant. Comme le [[item/20]], il ne porte qu'à 1 000 unités. C'est aussi le blaster le plus rare en boutique.", false],
	],
	"item/22": [
		[0, "", "Le [[item/22]] est le canon le plus faible du jeu : 2 de dégâts toutes les 0,4 s avec une portée de 1 000. Les autocanons tirent de petits projectiles rapides ; ils frappent légèrement, mais certains modèles tirent très vite. Ce premier modèle n'est qu'un pis-aller.", false],
		[6, "", "C'est l'une des trois pièces que [[character/2]] offre gratuitement dans son hangar de la station [[station/78]] avant le raid sur le repaire des pirates, avec le [[item/0]] et le [[item/55]].", false],
	],
	"item/23": [
		[0, "", "Le [[item/23]] double les dégâts du [[item/22]], à 4 par tir, et tire un peu plus vite (toutes les 0,3 s), toujours avec une portée de 1 000. C'est une arme de début de partie bon marché.", false],
	],
	"item/24": [
		[0, "", "Le [[item/24]] inflige 6 de dégâts toutes les 0,3 s avec une portée de 1 200. C'est un autocanon solide de milieu de gamme, qui égale les dégâts dans la durée du [[item/25]], lequel porte plus loin.", false],
	],
	"item/25": [
		[0, "", "Le [[item/25]] inflige 8 de dégâts toutes les 0,4 s et porte à 1 400 unités, la plus longue portée de tous les autocanons. Dans la durée, il inflige les mêmes dégâts que le [[item/24]]. Il n'est jamais vendu tout fait. Son plan s'obtient auprès de [[agent/2]] à la station [[station/20]], et il se construit uniquement à partir de matières premières, sans minerai.", false],
	],
	"item/26": [
		[0, "", "Le [[item/26]] tire toutes les 0,2 s pour 5 de dégâts avec une portée de 1 000. Sa cadence élevée lui donne plus de dégâts dans la durée que les canons à rail, au détriment de la portée.", false],
	],
	"item/27": [
		[0, "", "Le [[item/27]] tire toutes les 0,1 s, la cadence la plus élevée de tous les autocanons, pour 6 de dégâts par projectile. Ses dégâts dans la durée sont proches de ceux des meilleurs blasters, mais sa portée de 900 est la plus courte de toutes les armes. Il n'est jamais vendu tout fait. Son plan s'obtient auprès de [[agent/3]] à la station [[station/10]], et sa fabrication nécessite notamment du [[item/154]].", false],
	],
	"item/28": [
		[0, "", "Le [[item/28]] est la première arme thermique. Les armes thermiques tirent des coups rapides et légers avec une portée de 1 000 ; celle-ci inflige 3 de dégâts toutes les 0,3 s. Malgré son niveau technologique élevé, elle est plus faible dans la durée que la plupart des blasters et autocanons de milieu de gamme.", false],
	],
	"item/29": [
		[0, "", "Le [[item/29]] inflige 4 de dégâts toutes les 0,2 s avec une portée de 1 000, soit le double des dégâts dans la durée du [[item/28]].", false],
	],
	"item/3": [
		[0, "", "Le [[item/3]] est un laser [[faction/1|vossk]] qui inflige 7 de dégâts toutes les 0,5 s. Il égale le [[item/2]] par tir mais tire un peu moins vite, et prend donc un léger retard dans la durée. Seules les boutiques des systèmes [[faction/1|vossk]] le proposent.", false],
		[0, "", "Le [[ship/10]] de [[character/0]] en porte deux dans la scène d'ouverture.", false],
	],
	"item/30": [
		[0, "", "Le [[item/30]] tire toutes les 0,1 s pour 3 de dégâts, la plus rapide des armes thermiques. Dans la durée, il inflige plus que le [[item/29]], mais moins que les meilleurs blasters comme le [[item/21]].", false],
	],
	"item/31": [
		[0, "", "Le [[item/31]] est la roquette [[faction/1|vossk]] de base et la munition secondaire la moins chère : 60 de dégâts par impact, un lancement toutes les 1,2 s, portée de 1 200. Les roquettes volent en ligne droite et ne suivent pas leur cible ; elles sont donc plus efficaces à courte distance. Toute roquette ou torpille qui touche un astéroïde le fait éclater. Seules les boutiques des systèmes [[faction/1|vossk]] la proposent.", false],
	],
	"item/32": [
		[0, "", "Le [[item/32]] est la roquette non guidée courante : 70 de dégâts par impact, un lancement toutes les 0,9 s et une portée de 1 200. Elle frappe plus fort et se lance plus vite que le [[item/31]], et elle est largement vendue.", false],
	],
	"item/33": [
		[0, "", "Le [[item/33]] inflige 72 de dégâts et draine aussi 34 d'énergie ; il peut donc à la fois endommager une cible et aider à la neutraliser. Il se recharge lentement (2 s) et porte à 1 000 unités. Il n'est jamais vendu tout fait. Son plan s'obtient auprès de [[agent/4]] à la station [[station/43]], et un lot ne demande que quelques matières premières bon marché.", false],
	],
	"item/34": [
		[0, "", "Le [[item/34]] sert à neutraliser plutôt qu'à détruire : il draine 45 d'énergie et n'inflige que 10 de dégâts par impact, avec un lancement par seconde. Le [[item/35]] draine davantage et inflige plus de dégâts.", false],
	],
	"item/35": [
		[0, "", "Le [[item/35]] draine 60 d'énergie et inflige 30 de dégâts par impact, avec un lancement par seconde et une portée de 1 000. Il neutralise les vaisseaux plus vite que le [[item/34]] tout en usant leur coque.", false],
	],
	"item/36": [
		[0, "", "Le [[item/36]] est la torpille de base. Les torpilles volent en ligne droite pendant leurs 1,5 premières secondes, puis se dirigent vers leur cible. Le [[item/36]] inflige 70 de dégâts avec une portée de 3 000 unités, mais il est lent et ne se lance que toutes les 3 s. Le [[item/38]] double ses dégâts.", false],
	],
	"item/37": [
		[0, "", "Le [[item/37]] est la torpille la plus rapide : elle inflige 100 de dégâts, draine 50 d'énergie et porte à 4 000 unités. Elle se lance toutes les 4 s. Elle n'est jamais vendue toute faite. Son plan s'obtient auprès de [[agent/5]] à la station [[station/54]], et un lot ne demande que quelques matières premières.", false],
	],
	"item/38": [
		[0, "", "Le [[item/38]] est la torpille qui frappe le plus fort, avec 140 de dégâts par impact et une portée de 4 000. Elle est lente en vol et se lance toutes les 4 s. Seules les boutiques des systèmes [[faction/1|vossk]] la proposent.", false],
	],
	"item/39": [
		[0, "", "Le [[item/39]] est une torpille à tête chercheuse destinée à neutraliser les vaisseaux : elle draine 100 d'énergie et n'inflige aucun dégât. Avec une portée de 5 000, c'est un moyen bon marché d'arrêter une cible de loin. Le [[item/40]] ajoute 120 de dégâts au même drainage d'énergie.", false],
	],
	"item/4": [
		[0, "", "Le [[item/4]] est le laser [[faction/1|vossk]] le plus puissant : 10 de dégâts toutes les 0,6 s. Ses dégâts dans la durée sont presque exactement ceux du [[item/2]], avec des tirs plus lourds mais plus espacés que ceux du [[item/3]]. Seules les boutiques des systèmes [[faction/1|vossk]] le proposent.", false],
	],
	"item/40": [
		[0, "", "Le [[item/40]] associe 120 de dégâts et un drainage de 100 points d'énergie dans une même torpille à tête chercheuse, avec une portée de 5 000 et un lancement toutes les 5 s. Il coûte plus de deux fois plus cher que le [[item/39]].", false],
	],
	"item/41": [
		[0, "", "Le [[item/41]] est la plus petite bombe IEM. Une bombe se lance d'une pression et se déclenche d'une seconde ; l'explosion draine l'énergie de tous les vaisseaux dans son rayon, plus fortement près du centre, et épargne le vaisseau qui l'a lancée. Les astéroïdes ne sont pas affectés. Ce modèle draine jusqu'à 80 d'énergie dans un rayon de 22 000. Le [[item/42]] et le [[item/43]] sont plus puissants et plus étendus.", false],
		[20, "", "La sécurité [[faction/0|terrienne]] laisse gratuitement dix de ces bombes à la station [[station/55]], afin que [[character/0]] puisse neutraliser le vaisseau des ravisseurs sans le détruire.", false],
	],
	"item/42": [
		[0, "", "Le [[item/42]] draine jusqu'à 150 d'énergie dans un rayon de 30 000, soit près du double de la puissance du [[item/41]] et une explosion bien plus étendue.", false],
	],
	"item/43": [
		[0, "", "Le [[item/43]] est la bombe IEM la plus puissante : elle draine jusqu'à 300 d'énergie dans un rayon de 37 000. Elle se recharge un peu plus vite que le [[item/42]], mais coûte près de deux fois plus cher.", false],
	],
	"item/44": [
		[0, "", "Le [[item/44]] est la plus petite bombe nucléaire. Comme une bombe IEM, elle se lance puis se fait exploser d'une seconde pression, mais son explosion inflige de vrais dégâts : jusqu'à 200 dans un rayon de 20 000, moins vers le bord. Elle brise aussi les astéroïdes. Le vaisseau qui la lance n'est pas touché.", false],
	],
	"item/45": [
		[0, "", "Le [[item/45]] inflige jusqu'à 560 de dégâts dans un rayon de 30 000, soit presque trois fois la puissance du [[item/44]] dans une explosion plus étendue.", false],
	],
	"item/46": [
		[0, "", "Le [[item/46]] est l'arme la plus destructrice du jeu : jusqu'à 950 de dégâts dans un rayon de 40 000. Il n'est jamais vendu tout fait. Son plan s'obtient auprès de [[agent/6]] à la station [[station/61]], et sa fabrication nécessite notamment des marchandises radioactives et des explosifs, entre autres matières premières.", false],
	],
	"item/47": [
		[0, "", "Le [[item/47]] est la tourelle de base. Une tourelle occupe son propre emplacement, que seules certaines coques possèdent, et peut pivoter sur tout un tour, ce qui lui permet de toucher des cibles sur le côté ou à l'arrière du vaisseau ; pendant que vous la pointez, le vaisseau vole tout seul. Ce modèle inflige 6 de dégâts toutes les 0,3 s avec une portée de 2 000 et tourne lentement (maniabilité 40).", false],
	],
	"item/48": [
		[0, "", "Le [[item/48]] inflige 10 de dégâts toutes les 0,2 s avec une portée de 2 500 et tourne plus vite que le [[item/47]] (maniabilité 60). Il coûte plus de trois fois plus cher.", false],
	],
	"item/49": [
		[0, "", "Le [[item/49]] est la meilleure tourelle : 12 de dégâts toutes les 0,1 s avec une portée de 3 000, et la rotation la plus rapide (maniabilité 100). Elle est aussi très chère, environ deux fois le prix du [[item/48]]. Seules les boutiques des systèmes [[faction/1|vossk]] la proposent.", false],
	],
	"item/5": [
		[0, "", "Le [[item/5]] ouvre la gamme des lasers Berger, qui sacrifie la cadence de tir pour des tirs plus lourds et une portée un peu plus longue (2 200). Il inflige 8 de dégâts toutes les 0,9 s, soit moins de dégâts dans la durée que le [[item/2]], moins cher. Son avantage est sa plus longue portée.", false],
	],
	"item/50": [
		[0, "", "Le [[item/50]] est le bouclier de base. Un bouclier absorbe les dégâts reçus avant que le blindage et la coque n'en subissent, et il se recharge de lui-même au cours de son temps de chargement. Le Targe ne retient que 50 points, mais il se recharge entièrement en 20 s, plus vite que tout autre bouclier.", false],
	],
	"item/51": [
		[0, "", "Le [[item/51]] retient 80 points mais met 46 s à se recharger entièrement. Il absorbe plus que le [[item/50]] au cours d'un même combat, mais récupère bien plus lentement entre deux attaques.", false],
	],
	"item/52": [
		[0, "", "Le [[item/52]] est un bouclier [[faction/1|vossk]] qui retient 120 points et se recharge en 58 s. Il absorbe bien plus que le [[item/51]], mais le [[item/53]] retient davantage et se recharge plus vite. Seules les boutiques des systèmes [[faction/1|vossk]] le proposent.", false],
	],
	"item/53": [
		[0, "", "Le [[item/53]] retient 150 points et se recharge en 45 s ; il surpasse donc le [[item/52]] sur les deux plans. C'est le meilleur bouclier vendu en boutique.", false],
	],
	"item/54": [
		[0, "", "Le [[item/54]] est le bouclier le plus puissant : 220 points, rechargés en 60 s. Il n'est jamais vendu tout fait. Son plan s'obtient auprès de [[agent/7]] à la station [[station/72]], et sa fabrication nécessite une grande quantité de [[item/163]] ainsi que de l'électronique, des nanotechnologies et des micropuces.", false],
	],
	"item/55": [
		[0, "", "Le [[item/55]] est la plaque de blindage de base. Une plaque ajoute ses points au blindage du vaisseau ; après le bouclier, elle encaisse les dégâts avant la coque et, contrairement à un bouclier, elle ne se recharge pas. La E2 ajoute 40 points, une part importante pour un vaisseau de départ léger comme le [[ship/32]], qui en possède 100 par lui-même.", false],
		[6, "", "C'est l'une des trois pièces que [[character/2]] offre gratuitement dans son hangar de la station [[station/78]] avant le raid sur le repaire des pirates, avec le [[item/0]] et le [[item/22]].", false],
	],
	"item/56": [
		[0, "", "Le [[item/56]] ajoute 80 points de blindage, le double du [[item/55]], pour un prix modeste.", false],
	],
	"item/57": [
		[0, "", "Le [[item/57]] ajoute 110 points de blindage. C'est la meilleure plaque vendue hors des systèmes [[faction/1|vossk]].", false],
	],
	"item/58": [
		[0, "", "Le [[item/58]] est une plaque [[faction/1|vossk]] qui ajoute 160 points de blindage, bien plus que le [[item/57]]. Seules les boutiques des systèmes [[faction/1|vossk]] la proposent.", false],
	],
	"item/59": [
		[0, "", "Le [[item/59]] est la meilleure plaque de blindage : elle ajoute 250 points, autant que le blindage de base du [[ship/9]] et plus que celui de toute autre coque, à l'exception du [[ship/8]]. Elle n'est jamais vendue toute faite. Son plan s'obtient auprès de [[agent/8]] à la station [[station/84]], et sa fabrication nécessite du [[item/157]], des [[item/168]] et du [[item/156]], ainsi que des matières premières.", false],
	],
	"item/6": [
		[0, "", "Le [[item/6]] inflige 9 de dégâts toutes les 0,8 s avec une portée de 2 200. C'est une modeste amélioration par rapport au [[item/5]], et son prix varie à peine d'un système à l'autre.", false],
	],
	"item/60": [
		[0, "", "Le [[item/60]] est le plus faible des trois modules de protection IEM, avec une défense IEM de 20. Aucun des trois n'a de prix, et aucune boutique ne les propose.", false],
	],
	"item/61": [
		[0, "", "Le [[item/61]] est le module de protection IEM intermédiaire, avec une défense IEM de 40, le double du [[item/60]]. Comme les deux autres, il n'a pas de prix et n'est proposé par aucune boutique.", false],
	],
	"item/62": [
		[0, "", "Le [[item/62]] est le module de protection IEM le plus puissant, avec une défense IEM de 60. Comme le [[item/60]] et le [[item/61]], il n'a pas de prix et n'est proposé par aucune boutique.", false],
	],
	"item/63": [
		[0, "", "Le [[item/63]] est le compresseur de soute de base. Un compresseur agrandit la soute d'un pourcentage de la capacité propre de la coque ; celui-ci ajoute 15 %. Il est bon marché et utile à tout négociant ou mineur.", false],
	],
	"item/64": [
		[0, "", "Le [[item/64]] agrandit la soute de 25 %, un net progrès par rapport au [[item/63]] pour un prix modique.", false],
	],
	"item/65": [
		[0, "", "Le [[item/65]] agrandit la soute de 40 %. Sur un gros cargo, il ajoute autant d'espace que la soute entière d'un petit vaisseau.", false],
	],
	"item/66": [
		[0, "", "Le [[item/66]] agrandit la soute de 75 %, le plus fort gain de tous les compresseurs vendus en boutique.", false],
	],
	"item/67": [
		[0, "", "Le [[item/67]] double la soute en ajoutant 100 % de la capacité de la coque : un [[ship/36]] emporte ainsi 700 t. Il n'est jamais vendu tout fait. Son plan s'obtient auprès de [[agent/9]] à la station [[station/90]], et il se construit uniquement à partir de matières premières.", false],
	],
	"item/68": [
		[0, "", "Le [[item/68]] est le rayon tracteur de base. Sans rayon tracteur, aucun conteneur flottant ne peut être ramassé ; foncer dessus ne sert à rien. Avec le Retractor, vous gardez le conteneur sous le viseur pendant 4 s, après quoi il est attiré à bord. Le [[item/69]] demande moins de temps, et le [[item/70]] fonctionne automatiquement.", false],
		[24, "", "[[character/6]] demande à [[character/0]] d'installer un rayon tracteur avant la première expédition contre les [[faction/9|Voids]], afin qu'il puisse ramasser les débris de leurs vaisseaux. Jusque-là, les boutiques ont de bonnes chances de proposer un Retractor en plus de leur assortiment habituel.", false],
	],
	"item/69": [
		[0, "", "Le [[item/69]] fonctionne comme le [[item/68]], mais ne demande que 3 s de cible sous le viseur avant d'attirer le conteneur à bord.", false],
	],
	"item/7": [
		[0, "", "Le [[item/7]] inflige 10 de dégâts toutes les 0,8 s avec une portée de 2 200. Dans la durée, il égale le [[item/1]] ; son intérêt réside donc dans des coups moins nombreux mais plus lourds, à longue portée.", false],
	],
	"item/70": [
		[0, "", "Le [[item/70]] est le rayon tracteur automatique : il ramasse tout conteneur situé dans le champ de vision avant sans qu'il faille le viser et le maintenir, ce qui fait gagner beaucoup de temps lors du pillage d'un champ de bataille. Il est bien plus cher que le [[item/69]].", false],
	],
	"item/71": [
		[0, "", "Le [[item/71]] est le booster de base. Un booster donne une courte poussée de vitesse supplémentaire, puis a besoin de temps pour se recharger. Celui-ci ajoute 60 % de vitesse pendant 3 s et se recharge en 8 s.", false],
	],
	"item/72": [
		[0, "", "Le [[item/72]] est annoncé à 80 % de vitesse supplémentaire pendant 4,4 s, avec une recharge de 10 s. En vol, sa poussée atteint la même vitesse maximale que le [[item/71]] ; ce qu'il apporte, c'est une poussée plus longue.", false],
	],
	"item/73": [
		[0, "", "Le [[item/73]] fait plus que doubler le gain des boosters moins chers : 160 % de vitesse supplémentaire pendant 5,6 s, avec une recharge de 12 s.", false],
	],
	"item/74": [
		[0, "", "Le [[item/74]] est le booster le plus puissant : 200 % de vitesse supplémentaire pendant 6 s. Il demande la recharge la plus longue, 16 s. Seules les boutiques des systèmes [[faction/1|vossk]] le proposent.", false],
	],
	"item/75": [
		[0, "", "Le [[item/75]] est le seul robot de réparation du jeu et s'installe dans un emplacement d'équipement. En vol, il restaure un point de coque toutes les 0,6 s et un point de plaque de blindage chaque seconde ; les dégâts s'effacent ainsi entre deux combats sans amarrage. Il est bon marché et proposé par la plupart des boutiques.", false],
	],
	"item/76": [
		[0, "", "Le [[item/76]] est la tuyère de pilotage de base. Une tuyère ajoute sa valeur à la maniabilité du vaisseau, qui tourne alors plus vite. Celle-ci ajoute 20, un petit gain pour les chasseurs agiles mais sensible sur un cargo lent.", false],
	],
	"item/77": [
		[0, "", "Le [[item/77]] ajoute 40 de maniabilité, le double du [[item/76]], pour un prix modique.", false],
	],
	"item/78": [
		[0, "", "Le [[item/78]] est une tuyère [[faction/1|vossk]] qui ajoute 70 de maniabilité. Seules les boutiques des systèmes [[faction/1|vossk]] la proposent.", false],
	],
	"item/79": [
		[0, "", "Le [[item/79]] est une tuyère [[faction/1|vossk]] qui ajoute 100 de maniabilité, assez pour qu'un cargo lourd tourne comme un chasseur agile. Seules les boutiques des systèmes [[faction/1|vossk]] la proposent.", false],
	],
	"item/8": [
		[0, "", "Le [[item/8]] est le dernier et le plus puissant des lasers Berger : 12 de dégâts par tir toutes les 0,9 s avec une portée de 2 200. C'est le laser conventionnel qui frappe le plus fort par tir, mais le [[item/2]], plus rapide, inflige toujours plus de dégâts dans la durée. Les lasers à faisceau M6 qui lui succèdent (à partir du [[item/9]]) frappent plus de deux fois plus fort par tir.", false],
	],
	"item/80": [
		[0, "", "Le [[item/80]] est la meilleure tuyère de pilotage, avec 130 de maniabilité en plus. Elle fait passer le [[ship/36]], la coque qui tourne le plus lentement, de 45 à 175, plus que n'importe quel chasseur sans tuyère. Elle est rare en boutique.", false],
	],
	"item/81": [
		[0, "", "Le [[item/81]] est le scanner de base. Un scanner détermine le temps nécessaire pour verrouiller une cible telle qu'un vaisseau, une station ou un astéroïde ; le Quickscan demande 4 s. Le [[item/82]] verrouille plus vite et affiche aussi ce que transportent les autres vaisseaux.", false],
		[2, "", "Le vaisseau minier de [[character/2]], le [[ship/0]], en est équipé d'origine.", false],
	],
	"item/82": [
		[0, "", "Le [[item/82]] verrouille en 3 s et affiche la cargaison des vaisseaux ciblés, ce qui aide lors de la chasse au butin.", false],
	],
	"item/83": [
		[0, "", "Le [[item/83]] verrouille en 1,8 s, un temps égalé seulement par le [[item/84]], et affiche aussi la cargaison des cibles.", false],
	],
	"item/84": [
		[0, "", "Le [[item/84]] verrouille aussi vite que le [[item/83]] et affiche la cargaison ; il signale en outre les astéroïdes de classe A, les seuls qui peuvent donner un noyau (voir [[guide/mining]]). C'est le scanner de prédilection des mineurs.", false],
	],
	"item/85": [
		[0, "", "Le [[item/85]] est le seul moteur de saut du jeu. Une fois qu'il est installé, vous pouvez voyager depuis la carte de la galaxie directement vers une station d'un autre système, sans passer par les portails de saut. Il ne peut pas être utilisé pendant certaines missions. Il n'est jamais vendu tout fait, et aucun agent ne vend son plan. Sa fabrication nécessite des [[item/164]], du [[item/158]], du [[item/160]] et du [[item/163]], ainsi que de grandes quantités de matières premières.", false],
		[33, "", "Son inventeur, [[character/20]], demande à [[character/0]] 50 [[item/164]] pour ses travaux sur un propulseur capable d'atteindre n'importe quel point de l'espace.", false],
		[34, "", "En échange des cristaux, [[character/20]] donne à [[character/0]] une copie du plan. Les 50 cristaux livrés comptent pour le moteur ; il ne reste donc à fournir que les autres ingrédients.", false],
	],
	"item/86": [
		[0, "", "Le [[item/86]] est le laser d'extraction de base. Un laser d'extraction est nécessaire pour forer le minerai des astéroïdes. Son rendement détermine la stabilité du foret, et chaque modèle a aussi sa propre vitesse de forage (voir [[guide/mining]]). Celui-ci a un rendement de 30 et il est difficile à maintenir sur sa trajectoire dans les couches profondes.", false],
	],
	"item/87": [
		[0, "", "Le [[item/87]] a un rendement de 50. Il est nettement plus stable que le [[item/86]], bien qu'il fore un peu plus lentement.", false],
	],
	"item/88": [
		[0, "", "Le [[item/88]] est un laser d'extraction [[faction/1|vossk]] avec un rendement de 80, le foret le plus stable vendu en boutique. Son défaut est d'être le plus lent à extraire le minerai. Seules les boutiques des systèmes [[faction/1|vossk]] le proposent.", false],
	],
	"item/89": [
		[0, "", "Le [[item/89]] a un rendement de 60, moins stable que le [[item/88]], mais il extrait le minerai bien plus vite que tout autre laser vendu en boutique. Il convient aux mineurs capables de maintenir eux-mêmes le foret sur sa trajectoire.", false],
	],
	"item/9": [
		[0, "", "Le [[item/9]] est le premier des lasers à faisceau M6. Ceux-ci tirent rarement mais frappent très fort : 27 de dégâts toutes les 1,2 s, avec une portée de 2 400, plus longue que celle de tous les lasers précédents. La précision compte, car un tir manqué gaspille un long rechargement. C'est aussi la pièce de base pour construire le [[item/11]].", false],
	],
	"item/90": [
		[0, "", "Le [[item/90]] est le meilleur laser d'extraction : un rendement de 100 et le forage le plus rapide de tous les modèles. Il n'est jamais vendu tout fait. Son plan s'obtient auprès de [[agent/11]] à la station [[station/78]], et sa fabrication nécessite de grandes quantités de nanotechnologies, de fournitures mécaniques et d'hydraulique, plus du [[item/155]] et dix [[item/166]].", false],
		[2, "", "Le laser du premier vaisseau minier de [[character/0]] est le prototype de cette foreuse, fabriqué à la main par [[character/2]].", false],
		[10, "", "Lorsque [[character/2]] donne le [[ship/0]] à [[character/0]], il garde le prototype, le seul qu'il possède, et suggère de revenir plus tard, quand il en aura peut-être construit d'autres.", false],
	],
	"item/91": [
		[0, "", "Le [[item/91]] loge 3 passagers. Les cabines sont nécessaires pour les contrats [[job/11]], et l'espace de plusieurs cabines s'additionne. Le [[item/92]] et le [[item/93]] en accueillent davantage.", false],
	],
	"item/92": [
		[0, "", "Le [[item/92]] loge 5 passagers, deux de plus que le [[item/91]].", false],
	],
	"item/93": [
		[0, "", "Le [[item/93]] loge 10 passagers, le double du [[item/92]], ce qui ouvre l'accès aux contrats de passagers les plus importants.", false],
	],
	"item/94": [
		[0, "", "Le [[item/94]] est le dispositif de camouflage de base. Tant qu'un camouflage est actif, les autres vaisseaux ne peuvent pas vous voir. Celui-ci cache le vaisseau pendant 15 s, puis a besoin de 18 s pour se recharger. Le temps passé camouflé compte pour la médaille [[medal/19]].", false],
	],
	"item/95": [
		[0, "", "Le [[item/95]] est un dispositif de camouflage [[faction/1|vossk]] qui cache le vaisseau pendant 28 s et se recharge en 32 s, soit presque le double de la couverture du [[item/94]]. Seules les boutiques des systèmes [[faction/1|vossk]] le proposent.", false],
	],
	"item/96": [
		[0, "", "Le [[item/96]] est le meilleur dispositif de camouflage : il cache le vaisseau pendant 46 s et se recharge en seulement 40 s, si bien qu'il peut rester actif la plupart du temps. Il n'est jamais vendu tout fait. Son plan s'obtient auprès de [[agent/10]] à la station [[station/59]].", false],
	],
	"job/0": [
		[0, "", "Un contrat de coursier vous demande de transporter un chargement de conteneurs de fret scellés vers une autre station. Les conteneurs sont chargés dans votre soute dès que vous acceptez ; il vous faut donc assez de place libre, et ils ne peuvent pas être vendus. Le contrat est accompli lorsque vous vous amarrez à la destination avec le fret à bord. Des pirates guettent parfois les coursiers. Le fret livré compte pour [[medal/5]].", false],
	],
	"job/1": [
		[0, "", "Dans un contrat de défense, une station est sur le point d'être attaquée, et vous êtes engagé pour aider ses propres chasseurs à repousser les assaillants. Les attaquants sont généralement des pirates, sinon des vaisseaux de la race rivale. Rendez-vous à la station et détruisez tous les attaquants ; les victimes des chasseurs alliés comptent aussi. Les contrats plus difficiles amènent plus d'attaquants.", false],
	],
	"job/10": [
		[0, "", "Dans un contrat d'interception, un convoi de deux ou trois cargos transportant une cargaison illégale se trouve loin d'une station, gardé par des chasseurs. Suivez les points de passage et détruisez les cargos. Leurs gardes attendent le long du chemin et autour du convoi.", false],
	],
	"job/11": [
		[0, "", "Un contrat de passagers vous demande d'emmener un groupe de personnes vers une autre station. Il vous faut, au moment d'accepter, des cabines assez spacieuses pour tous ; tant qu'ils sont à bord, les cabines ne peuvent pas être retirées et la coque ne peut pas être changée. Amarrez-vous à la destination pour les déposer. La récompense de base est plus faible, mais chaque passager l'augmente. Les passagers livrés comptent pour [[medal/18]].", false],
	],
	"job/12": [
		[0, "", "Un défi est un concours de tir proposé par un autre pilote au Space Lounge. Vous partez tous deux de la même station vers un groupe de pirates répartis le long d'un itinéraire, et celui qui en abat le plus gagne. Le rival ne peut pas être détruit et frappe aussi fort que vos propres armes. Vous n'êtes payé que si vous abattez plus de pirates que lui ; le nombre de pirates est toujours impair, il n'y a donc jamais d'égalité.", false],
	],
	"job/2": [
		[0, "", "Un contrat de protection vous envoie garder des vaisseaux miniers qui exploitent un champ d'astéroïdes près d'une station. Des assaillants arrivent et foncent vers la station et les mineurs. Détruisez-les tous avant qu'ils n'anéantissent les mineurs ; si tous les vaisseaux miniers sont perdus, le contrat échoue.", false],
	],
	"job/3": [
		[0, "", "Dans un contrat de récupération, des marchandises volées sont transportées par l'un des vaisseaux d'un groupe de pirates près d'une station. Vous devez reprendre le conteneur sans le détruire : neutralisez le transporteur avec une arme IEM et attirez le conteneur avec un rayon tracteur. Un scanner qui affiche la cargaison vous aide à trouver le bon vaisseau. Le conteneur est perdu si le transporteur est détruit ou si votre soute n'a pas de place pour lui. Une fois le conteneur récupéré, retournez à la station où vous avez accepté le contrat pour être payé. La récupération paie le double.", false],
	],
	"job/4": [
		[0, "", "La chasse aux pirates consiste à nettoyer un repaire de pirates près d'une station. Les pirates attendent dans le champ d'astéroïdes ou sur un itinéraire de deux ou trois points de passage, et ne bougent que lorsqu'ils vous voient. Suivez les points de passage et détruisez tous les pirates. Une difficulté plus élevée signifie plus de pirates.", false],
	],
	"job/5": [
		[0, "", "Un contrat de sauvetage est une opération de secours : un otage est retenu à bord de l'un des vaisseaux d'un groupe près d'une station. Comme pour une récupération, neutralisez le vaisseau du ravisseur par IEM et utilisez un rayon tracteur pour prendre l'otage à bord ; détruire ce vaisseau met fin au contrat. Ramenez ensuite l'otage à la station où vous avez accepté le contrat. Le sauvetage paie le double.", false],
	],
	"job/6": [
		[0, "", "Un avis de recherche désigne un dangereux criminel aperçu près d'une station. La cible attend en un point éloigné et ne réagit que lorsque vous entrez dans son champ de vision. Elle est bien plus coriace qu'un pirate ordinaire, et le devient davantage avec la difficulté du contrat et votre niveau de pilote. Détruisez-la pour toucher la prime.", false],
	],
	"job/7": [
		[0, "", "L'enlèvement de débris vous demande de nettoyer un nuage de débris spatiaux près d'une station en deux minutes environ. Chaque débris doit être détruit avant la fin du temps imparti ; à difficulté plus élevée, quelques pirates s'en mêlent. Il paie moins que la plupart des contrats, mais il est rapide, et les débris détruits comptent pour [[medal/10]].", false],
	],
	"job/8": [
		[0, "", "Un contrat d'achat vient d'un acheteur du Space Lounge qui veut une certaine quantité d'un article précis. Procurez-vous les marchandises, en boutique, auprès de négociants ou par extraction, et revenez vous amarrer à la station de l'acheteur avec elles dans la soute. Les marchandises sont remises et vous recevez la moitié de la récompense habituelle d'un contrat plus trois fois la valeur moyenne des marchandises ; un acheteur paie donc généralement bien plus que n'importe quelle boutique. Les acheteurs apparaissent à partir de l'[[step/16]].", false],
	],
	"job/9": [
		[0, "", "Un contrat d'escorte vous demande de protéger un convoi de cinq cargos près d'une station. Pendant que les cargos avancent, des attaquants postés le long de leur route se rapprochent. Détruisez tous les attaquants. Si tous les cargos sont perdus, le contrat échoue. Les escortes paient un cinquième de plus que la plupart des contrats.", false],
	],
	"medal/0": [
		[0, "", "[[character/0]] détient cette médaille dès le début de la partie, pour ses services passés. Il n'y a rien à faire pour l'obtenir.", false],
	],
	"medal/1": [
		[0, "", "Décernée pour avoir atteint une station avec très peu de coque restante. La vérification a lieu à l'approche, avant que le dock ne répare le vaisseau, et porte sur la résistance propre de la coque, pas sur la plaque de blindage. Plus la part restante est faible, meilleur est le niveau.", false],
	],
	"medal/10": [
		[0, "", "Décernée pour avoir détruit des débris spatiaux, comme ceux des contrats [[job/7]]. Chaque débris abattu compte.", false],
	],
	"medal/11": [
		[0, "", "Décernée pour le nombre de stations différentes où vous vous êtes amarré.", false],
	],
	"medal/12": [
		[0, "", "Décernée pour le nombre de systèmes différents que vous avez visités. Les systèmes cachés comptent une fois atteints.", false],
	],
	"medal/13": [
		[0, "", "Décernée pour le nombre de plans que vous possédez. Les plans s'achètent auprès d'agents au Space Lounge ; voir [[guide/blueprints]].", false],
	],
	"medal/14": [
		[0, "", "Décernée pour le nombre de plans différents que vous avez menés à bien au moins une fois. Fabriquer de nouveau le même objet ne compte pas.", false],
	],
	"medal/15": [
		[0, "", "Décernée pour le temps de jeu, en heures. Le jeu compte le temps passé en vol.", false],
	],
	"medal/16": [
		[0, "", "Décernée pour le nombre de contrats freelance accomplis. Les contrats échoués ou abandonnés ne comptent pas.", false],
	],
	"medal/17": [
		[0, "", "Décernée pour le nombre de passages par un portail de saut. Les sauts au moteur de saut ne comptent pas.", false],
	],
	"medal/18": [
		[0, "", "Décernée pour le nombre de passagers livrés lors des contrats [[job/11]]. Plus d'espace de cabine permet des groupes plus nombreux.", false],
	],
	"medal/19": [
		[0, "", "Décernée pour le total de minutes passées camouflé. Installez un dispositif de camouflage et utilisez-le dès qu'il est chargé.", false],
	],
	"medal/2": [
		[0, "", "Décernée pour avoir extrait différents types de minerai. Chaque type compte une fois, quelle que soit la quantité extraite. Comme les champs contiennent les minerais dont l'origine est proche, il vous faudra extraire dans plusieurs régions de la galaxie.", false],
	],
	"medal/20": [
		[0, "", "Décernée pour le nombre de bombes IEM et d'armes nucléaires lancées.", false],
	],
	"medal/21": [
		[0, "", "Décernée pour les tonnes de [[item/131]] récupérées avec un rayon tracteur sur des épaves et des vaisseaux neutralisés.", false],
	],
	"medal/22": [
		[0, "", "Médaille à niveau unique, décernée pour avoir volé sans aucune arme, ou sans aucun équipement, installé ; la vérification a lieu au prochain amarrage. Elle ne peut pas être obtenue au début de l'histoire : jusqu'à l'[[step/8]], le vaisseau compte toujours comme armé.", false],
	],
	"medal/23": [
		[0, "", "Décernée pour le nombre d'armes principales installées simultanément, vérifié à l'amarrage. Une coque dotée de nombreux emplacements principaux est nécessaire pour les niveaux supérieurs. Comme [[medal/22]], elle ne compte qu'à partir de l'[[step/8]].", false],
	],
	"medal/24": [
		[0, "", "Décernée pour les tonnes de cargaison prélevées sur des épaves et des vaisseaux neutralisés avec un rayon tracteur.", false],
	],
	"medal/25": [
		[0, "", "Décernée pour le plus grand nombre de crédits détenus en même temps. Dépenser de l'argent ensuite ne la retire pas.", false],
	],
	"medal/26": [
		[0, "", "Décernée pour avoir parlé à des clients du Space Lounge qui ont quelque chose à proposer. Chaque client compte une fois, la première fois que vous lui parlez.", false],
	],
	"medal/27": [
		[0, "", "Décernée pour le nombre d'ailiers que vous avez engagés au Space Lounge, en comptant chaque pilote de chaque groupe.", false],
	],
	"medal/28": [
		[0, "", "Médaille à niveau unique, décernée pour avoir retourné contre vous l'une des quatre grandes races, en faisant dépasser 60 à l'une des deux échelles de réputation dans un sens ou dans l'autre. Voir [[guide/combat]].", false],
	],
	"medal/29": [
		[0, "", "Décernée pour le nombre d'astéroïdes détruits par vos armes. Les astéroïdes brisés lors de l'extraction ne comptent pas.", false],
	],
	"medal/3": [
		[0, "", "Décernée pour avoir extrait différents types de noyaux. Les noyaux ne s'obtiennent qu'en traversant les sept couches d'un astéroïde de classe A ; il faut donc de la patience et un bon laser d'extraction, en plus des voyages.", false],
	],
	"medal/30": [
		[0, "", "Médaille à niveau unique, décernée pour avoir terminé l'histoire.", false],
	],
	"medal/31": [
		[0, "", "Décernée pour le plus grand espace de soute libre dont vous avez disposé en même temps. Une grande coque avec des compresseurs de soute et une soute vide permet d'obtenir les niveaux supérieurs.", false],
	],
	"medal/32": [
		[0, "", "Décernée pour le nombre d'offres que vous avez refusées avec « No, thanks » au Space Lounge.", false],
	],
	"medal/33": [
		[0, "", "Décernée pour le nombre de fois où vous avez demandé à un client du Space Lounge de répéter une offre avec « How was that again? ».", false],
	],
	"medal/34": [
		[0, "", "Décernée pour avoir accepté des contrats dans d'autres stations sans demander d'abord au client s'ils seraient difficiles.", false],
	],
	"medal/35": [
		[0, "", "Décernée pour avoir accepté des contrats dans d'autres stations sans demander d'abord au client de montrer la destination sur la carte.", false],
	],
	"medal/36": [
		[0, "", "Décernée automatiquement une fois que vous détenez toutes les autres médailles, quel que soit leur niveau. Les détenir toutes apporte aussi d'autres récompenses ; voir [[guide/medals]].", false],
	],
	"medal/4": [
		[0, "", "Décernée pour le nombre de vaisseaux que vous avez détruits, sur l'ensemble de la partie. Les pirates, les ennemis et les cibles de contrats comptent tous.", false],
	],
	"medal/5": [
		[0, "", "Décernée pour les tonnes de fret livrées lors des contrats [[job/0]]. Les gros chargements de coursier comptent davantage ; une grande soute aide donc.", false],
	],
	"medal/6": [
		[0, "", "Décernée pour le total de tonnes de minerai extraites sur l'ensemble de la partie.", false],
	],
	"medal/7": [
		[0, "", "Décernée pour le nombre de noyaux extraits sur l'ensemble de la partie. Chaque astéroïde de classe A foré jusqu'au bout en donne un.", false],
	],
	"medal/8": [
		[0, "", "Décernée pour les tonnes d'alcool achetées dans les boutiques des stations. La boisson locale de chaque système compte.", false],
	],
	"medal/9": [
		[0, "", "Décernée pour avoir possédé différentes sortes d'alcool. Les sortes sont comptées lorsque vous les achetez à des négociants du Space Lounge ou les ramassez sur des épaves avec un rayon tracteur.", false],
	],
	"ship/0": [
		[0, "", "Le [[ship/0]] est la coque la plus faible du tableau des vaisseaux : 95 de blindage, une soute de 25 t, un emplacement principal et un secondaire, et trois emplacements d'équipement. Sa maniabilité de 140 est honorable pour un vaisseau de départ, mais le [[ship/32]], la coque la moins chère en vente, a les mêmes emplacements avec plus de blindage, de soute et d'agilité. Aucun concessionnaire ne propose jamais le [[ship/0]] ; le joueur ne l'obtient que par l'histoire.", false],
		[2, "", "[[character/2]] possède cet ancien vaisseau [[faction/8|pirate]] rafistolé et y installe [[character/0]] à la station [[station/78]], peint aux couleurs pirates et équipé d'un laser d'extraction et d'un [[item/81]], mais sans canons. Le laser est son propre prototype, le modèle qu'il vendra plus tard sous le nom de [[item/90]].", false],
		[10, "", "Après le raid sur le repaire des pirates, [[character/2]] donne définitivement le vaisseau à [[character/0]], avec un propulseur plus puissant pour voyager entre les planètes du système, mais garde le laser prototype. Keith continue de le piloter après avoir rejoint l'espace [[faction/0|terrien]].", false],
		[18, "", "À la station [[station/98]], [[character/1]] fait repeindre la coque aux couleurs [[faction/0|terriennes]] pour que les patrouilles cessent de la prendre pour un vaisseau pirate.", false],
	],
	"ship/1": [
		[0, "", "Le [[ship/1]] est la coque la moins chère dotée de quatre emplacements secondaires, et il possède aussi un emplacement de tourelle, deux canons principaux et sept emplacements d'équipement. Son blindage (192) et sa soute (65 t) sont solides. Sa maniabilité de 106 est lente ; il combat donc mieux avec des torpilles et la tourelle. Pour un peu plus d'argent, le [[ship/9]] offre bien plus de blindage et d'agilité, mais sans tourelle et avec seulement deux emplacements secondaires.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/10": [
		[0, "", "Le [[ship/10]] est le vaisseau personnel de [[character/0]] dans la scène d'ouverture, armé de deux lasers [[item/3]]. Il associe un blindage solide (200) et une soute de 100 t à quatre emplacements secondaires et une maniabilité de 150, ce qui le rend bien plus agile que le [[ship/11]], la coque la plus proche de lui en prix catalogue. Son point faible est le petit nombre d'emplacements d'équipement : cinq seulement. Les concessionnaires ordinaires ne le proposent jamais.", false],
		[2, "", "Une panne d'hyperpropulseur emmène [[character/0]] jusqu'à la station [[station/78]], où [[character/2]] récupère l'épave et la démonte pour en tirer des pièces. Le vaisseau ne revient jamais entre ses mains.", false],
	],
	"ship/11": [
		[0, "", "Le [[ship/11]] est un cargo lourd bien équipé : une soute de 180 t, 210 de blindage, un emplacement de tourelle, deux emplacements principaux et deux secondaires, et huit emplacements d'équipement. Sa maniabilité de 75 est médiocre. Face au [[ship/7]], moins cher, il sacrifie 60 t de soute pour un emplacement secondaire et un emplacement d'équipement supplémentaires.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/12": [
		[0, "", "Le [[ship/12]] est un chasseur conçu autour de ses armes secondaires : trois emplacements secondaires, deux canons principaux, six emplacements d'équipement, 175 de blindage et une maniabilité de 132. Sa soute de 30 t est très petite ; il se prête donc mal au commerce et à l'extraction. Le [[ship/30]] coûte plus cher et offre moins de blindage et un emplacement secondaire de moins.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/16": [
		[0, "", "Le [[ship/16]] est un chasseur riche en missiles avec quatre emplacements secondaires, deux canons principaux, dix emplacements d'équipement, 180 de blindage et une maniabilité de 120. Sa soute de 45 t est petite. Le [[ship/21]], plus cher, ajoute deux canons principaux et un emplacement d'équipement.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/17": [
		[0, "", "Le [[ship/17]] porte quatre canons principaux, deux emplacements secondaires et dix emplacements d'équipement. Pour un vaisseau de ce prix, son blindage (145), sa soute (65 t) et sa maniabilité (95) sont faibles ; il compte donc sur son équipement, surtout les boucliers et les plaques de blindage. Le [[ship/19]], moins cher, a plus de blindage et de soute avec un emplacement d'équipement de moins.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/18": [
		[0, "", "Le [[ship/18]] est un petit vaisseau agile (maniabilité 145) doté de huit emplacements d'équipement ; aucune coque moins chère n'en a autant. Son blindage de 115 et sa soute de 28 t sont faibles, et il n'a que deux emplacements principaux et deux secondaires. Il convient à un pilote qui compte sur les boucliers, le camouflage et d'autres équipements plutôt que sur le blindage.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/19": [
		[0, "", "Le [[ship/19]] est un vaisseau de combat lourd avec quatre emplacements principaux, deux emplacements secondaires, neuf emplacements d'équipement, 225 de blindage et une soute de 105 t. Sa maniabilité de 90 est lente. C'est le seul vaisseau qui combine quatre canons avant et une soute de plus de 100 t.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/2": [
		[0, "", "Le [[ship/2]] est un polyvalent agile parmi les coques bon marché : 155 de blindage, une soute de 52 t, un emplacement principal et deux secondaires, quatre emplacements d'équipement et une maniabilité de 150. Il égale le [[ship/35]] en tout sauf la soute, où il emporte 12 t de plus. Les pilotes qui veulent un second canon se tournent plutôt vers le [[ship/5]] ou le [[ship/6]].", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/20": [
		[0, "", "Le [[ship/20]] est un chasseur léger qui loge six emplacements d'équipement dans une coque petite et vive (maniabilité 155). Il porte deux canons principaux mais un seul emplacement secondaire, 125 de blindage et une soute de 25 t, à égalité avec le [[ship/0]] pour la plus petite du tableau. Il convient aux pilotes qui veulent tôt des boucliers, des boosters et d'autres équipements et ne comptent pas transporter de cargaison.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/21": [
		[0, "", "Le [[ship/21]] est la coque la moins chère dotée de quatre emplacements principaux et de quatre secondaires. Il y ajoute onze emplacements d'équipement, 195 de blindage et une soute de 70 t. Sa maniabilité de 100 est moyenne. C'est un vaisseau de combat complet, un cran en dessous du [[ship/29]].", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/22": [
		[0, "", "Le [[ship/22]] a la plus grande soute de tous les vaisseaux coûtant plus d'un million de crédits (130 t), avec trois emplacements principaux et trois secondaires, neuf emplacements d'équipement et une maniabilité de 118. Son blindage de 160 est faible pour son prix. Il convient aux pilotes qui commercent et combattent avec le même vaisseau.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/23": [
		[0, "", "Le [[ship/23]] est la coque la moins chère dotée d'un emplacement de tourelle, et son blindage de 205 est le plus élevé de tous les vaisseaux à moins de 100 000 crédits. Il y ajoute deux emplacements principaux et deux secondaires, cinq emplacements d'équipement, une soute de 55 t et une maniabilité de 128, ce qui en fait un polyvalent robuste de milieu de gamme. Sa principale limite est le petit nombre d'emplacements d'équipement.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/24": [
		[0, "", "Le [[ship/24]] est un vaisseau marchand armé : trois canons principaux, deux emplacements secondaires, une tourelle, huit emplacements d'équipement et une soute de 95 t. Son blindage de 170 est moyen, tandis que sa maniabilité de 125 est bonne pour un vaisseau qui emporte autant. Il se prête aussi bien au commerce qu'à l'extraction et au combat.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/25": [
		[0, "", "Le [[ship/25]] est un lance-missiles : quatre emplacements secondaires, huit emplacements d'équipement et une maniabilité de 130, mais un seul canon principal. Son blindage de 124 et sa soute de 52 t sont faibles pour son prix ; il dépend donc des torpilles et des boucliers. Le [[ship/1]] offre le même nombre d'emplacements secondaires plus une tourelle pour un tiers du prix, avec moins d'emplacements d'équipement.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/26": [
		[0, "", "Le [[ship/26]] est la coque la moins chère dotée de sept emplacements d'équipement. Pour le reste, c'est un polyvalent moyen : 152 de blindage, une soute de 64 t, deux emplacements principaux et deux secondaires, et une maniabilité de 108. Il convient aux pilotes qui veulent un équipement complet avant de pouvoir s'offrir un vaisseau plus lourd.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/27": [
		[0, "", "Le [[ship/27]] est la coque la moins chère dotée de trois emplacements principaux. Il les associe à 176 de blindage, deux emplacements secondaires, six emplacements d'équipement et une soute de 50 t. Sa maniabilité de 113 est plutôt lente ; il encaisse et rend les coups plutôt que de déborder ses ennemis en virage.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/28": [
		[0, "", "Le [[ship/28]] est le polyvalent le plus complet en vente : trois emplacements principaux et quatre secondaires, une tourelle, douze emplacements d'équipement et une soute de 110 t. Aucun autre vaisseau achetable n'associe une tourelle à autant d'emplacements d'équipement. Son blindage de 195 est bon et sa maniabilité de 92 est lente. Le [[ship/29]] combat mieux mais emporte bien moins.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/29": [
		[0, "", "Le [[ship/29]] est le vaisseau le plus cher vendu par les concessionnaires ordinaires et leur meilleur chasseur : quatre emplacements principaux et quatre secondaires, douze emplacements d'équipement, 240 de blindage et une maniabilité de 118. Sa soute de 75 t est modeste, et il n'a pas de tourelle. Seul le [[ship/8]] le surclasse au combat.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/3": [
		[0, "", "Le [[ship/3]] est un polyvalent équilibré de début de partie : deux emplacements principaux et deux secondaires, cinq emplacements d'équipement, 135 de blindage et une soute de 55 t. Sa maniabilité de 112 est lente pour un petit vaisseau. Il coûte à peu près autant que le [[ship/6]], qui tourne bien plus vite mais a moins de blindage, moins de soute et un emplacement secondaire de moins.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/30": [
		[0, "", "Le [[ship/30]] est un chasseur moyen en tout : 165 de blindage, une soute de 45 t, deux emplacements principaux et deux secondaires, six emplacements d'équipement et une maniabilité de 128. Il n'a pas de point fort particulier pour son prix ; le [[ship/12]], moins cher, a plus de blindage et un emplacement secondaire de plus, et le [[ship/23]] ajoute une tourelle.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/31": [
		[0, "", "Le [[ship/31]] est un cargo léger avec une soute de 110 t, un emplacement de tourelle, deux canons principaux et six emplacements d'équipement. Son blindage (156), son unique emplacement secondaire et sa maniabilité de 102 sont modestes. Il concurrence le [[ship/33]], moins cher, qui a un peu moins de soute et un canon de moins, mais plus de blindage et une meilleure maniabilité.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/32": [
		[0, "", "Le [[ship/32]] est la coque la moins chère vendue par les concessionnaires et le premier achat habituel. Il est petit et peu protégé (100 de blindage, soute de 30 t, un emplacement principal et un secondaire, trois emplacements d'équipement), mais avec une maniabilité de 160, seul le [[ship/4]] tourne plus vite. Comparé au [[ship/0]], il ajoute un peu de blindage et de soute et se manie mieux. Le [[ship/35]] coûte environ 8 000 crédits de plus et apporte un bien meilleur blindage, un deuxième emplacement secondaire et un quatrième emplacement d'équipement.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/33": [
		[0, "", "Le [[ship/33]] est la coque la moins chère offrant plus de 100 t de soute (108 t), et il y ajoute un emplacement de tourelle, 176 de blindage et six emplacements d'équipement. Avec un seul canon principal et une maniabilité de 112, c'est un vaisseau marchand capable de se défendre plutôt qu'un chasseur. Le [[ship/31]] est un proche rival, avec un second canon et une soute légèrement plus grande, mais il est plus faible et plus lent.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/34": [
		[0, "", "Le [[ship/34]] est un vaisseau de combat avec quatre emplacements principaux, un emplacement secondaire, six emplacements d'équipement, une soute de 60 t et une maniabilité de 130. Comparé au [[ship/4]], moins cher, il sacrifie du blindage (135 contre 170) et de l'agilité pour plus de soute et un emplacement d'équipement supplémentaire.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/35": [
		[0, "", "Le [[ship/35]] est un chasseur léger en bas de la liste des prix. Pour son prix, il offre un bon blindage (155), un emplacement principal et deux secondaires, quatre emplacements d'équipement et une maniabilité vive de 150, mais seulement une soute de 40 t. Le [[ship/2]] est presque le même vaisseau avec 12 t de soute en plus pour quelques milliers de crédits de plus, tandis que le [[ship/5]] sacrifie l'agilité pour plus de blindage, de soute et un second canon.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/36": [
		[0, "", "Le [[ship/36]] est le plus gros cargo du jeu, avec une soute de 350 t. Il n'a aucun emplacement principal et doit compter sur ses quatre emplacements secondaires et une tourelle pour se défendre. Ses sept emplacements d'équipement et ses 200 de blindage sont bons, mais sa maniabilité de 45 est la plus faible du tableau. Le [[ship/7]] emporte moins mais conserve deux canons avant et tourne mieux.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/4": [
		[0, "", "Le [[ship/4]] est la coque la moins chère dotée de quatre emplacements principaux, et avec une maniabilité de 162, c'est le vaisseau le plus agile du jeu. Son blindage de 170 est bon pour son prix. En contrepartie, il n'a qu'une soute de 38 t, un seul emplacement secondaire et cinq emplacements d'équipement : c'est un pur chasseur de combat rapproché. Le [[ship/34]] porte aussi quatre canons, avec plus de soute et d'emplacements d'équipement, mais moins de blindage et d'agilité.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/5": [
		[0, "", "Le [[ship/5]] est la coque la moins chère dotée de deux emplacements principaux, et son blindage de 170 est élevé pour son prix. Une soute de 60 t le rend aussi utile pour le commerce et l'extraction en début de partie. Ses défauts sont un seul emplacement secondaire, seulement quatre emplacements d'équipement et une maniabilité poussive de 115. Les pilotes qui préfèrent l'agilité au blindage choisissent le [[ship/2]] ou le [[ship/35]], à un prix comparable.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/6": [
		[0, "", "Le [[ship/6]] est un chasseur léger et rapide avec deux emplacements principaux, un emplacement secondaire, cinq emplacements d'équipement et une maniabilité de 148. Son blindage de 105 est très mince ; seuls le [[ship/0]] et le [[ship/32]] en ont moins, si bien qu'il compte sur la vitesse plutôt que sur la robustesse. Pour presque le même prix, le [[ship/3]] offre plus de blindage, plus de soute et un deuxième emplacement secondaire, au détriment de la maniabilité.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/7": [
		[0, "", "Le [[ship/7]] est un cargo lourd avec une soute de 240 t, 220 de blindage, un emplacement de tourelle, deux canons principaux, un emplacement secondaire et sept emplacements d'équipement. Avec une maniabilité de 65, il tourne lentement. Comparé au [[ship/36]], il sacrifie 110 t de soute pour des canons avant et une meilleure maniabilité ; le [[ship/11]], plus cher, ajoute un emplacement d'équipement et un deuxième emplacement secondaire.", false],
		[0, "", "Tout concessionnaire hors des systèmes [[faction/1|vossk]] peut le proposer.", false],
	],
	"ship/8": [
		[0, "", "Le [[ship/8]] est un chasseur [[faction/9|void]] restauré et le vaisseau le plus puissant du jeu. Son blindage de 450 est presque le double de celui de toute autre coque ; il a quatre emplacements principaux et quatre secondaires, quinze emplacements d'équipement, et sa maniabilité de 155 compte parmi les meilleures. Sa seule faiblesse est une soute de 30 t. Son prix catalogue de plus de huit millions de crédits est presque le double de celui du [[ship/29]].", false],
		[0, "", "Les concessionnaires ordinaires ne le vendent pas. Il n'est proposé qu'à la station [[station/10]], comme prototype, une fois que le joueur détient toutes les médailles en or (voir [[guide/medals]]).", false],
	],
	"ship/9": [
		[0, "", "Le [[ship/9]] est le seul vaisseau que vendent les concessionnaires [[faction/1|vossk]], et ils ne vendent rien d'autre. Son blindage de 250 est le plus élevé de toutes les coques après le [[ship/8]], et il l'associe à une maniabilité vive de 152, deux emplacements principaux et deux secondaires, sept emplacements d'équipement et une soute de 65 t. À son prix, c'est le chasseur le plus robuste disponible, même s'il lui manque la tourelle et les emplacements supplémentaires du [[ship/1]].", false],
		[36, "", "[[character/7]] explique que les vaisseaux [[faction/1|vossk]] ne sont normalement pilotés que par leur propre race ; ce vaisseau est l'exception, un modèle adapté pour pouvoir être vendu aux autres races.", false],
	],
	"station/0": [
		[0, "", "La station [[station/0]] abrite le portail de saut de [[system/0]]. La période d'attente de l'[[step/13]] est rattachée à cette station, mais cette étape s'accomplit en terminant des contrats du lounge n'importe où, et il ne se passe rien ici.", false],
	],
	"station/10": [
		[0, "", "[[station/10]] est la seule station de [[system/6]] et abrite son portail de saut. Les contrats freelance ne vous envoient jamais ici. L'agent [[agent/3]] vend un plan dans son lounge et, une fois toutes les médailles en or, la station propose un prototype de [[ship/8]].", false],
		[23, "", "La station est la base de recherche secrète de Deep Science, dirigée par [[character/6]]. [[character/0]] y arrive avec [[character/5]] lors de l'[[step/23]] et y revient plusieurs fois : pour préparer l'expédition chez les Voids, pour rencontrer [[character/20]] et pour livrer ses cristaux.", false],
	],
	"station/18": [
		[0, "", "[[station/18]] est une modeste station vossk de [[system/3]]. L'agent [[agent/12]] vend les coordonnées de [[system/0]] dans son lounge.", false],
	],
	"station/20": [
		[0, "", "La station [[station/20]] abrite le portail de saut de [[system/4]]. L'agent midorien [[agent/2]] vend un plan d'arme dans son lounge.", false],
	],
	"station/22": [
		[0, "", "[[station/22]] est la station la plus avancée de [[system/4]].", false],
		[38, "", "Lors de l'[[step/38]], le convoi transportant les explosifs nivéliens est repéré près de la station, sous l'escorte de chasseurs midoriens. [[character/0]] doit chasser l'escorte sans détruire le convoi.", false],
	],
	"station/26": [
		[0, "", "[[station/26]] est une station vossk de pointe dans [[system/5]]. L'agent bobolian [[agent/13]] vend les coordonnées de [[system/1]] dans son lounge.", false],
	],
	"station/27": [
		[36, "", "Près de [[station/27]], [[character/7]] et [[character/0]] attaquent un repaire pirate lors de l'[[step/36]] ; celui qui détruit le plus de pirates gagne.", false],
		[37, "", "[[character/0]] gagne et obtient le droit d'escorter le cargo vossk. C'est d'ici qu'il fait son rapport à [[character/1]].", false],
	],
	"station/29": [
		[35, "", "[[station/29]] est la station du commandant vossk [[character/7]], qui a accepté de fournir un cargo K'Sarr pour l'attaque contre les Voids. [[character/0]] le rencontre ici lors de l'[[step/35]].", false],
		[36, "", "[[character/7]] refuse que quiconque d'autre qu'un Vossk pilote le cargo et met [[character/0]] au défi de faire ses preuves comme pilote d'escorte.", false],
	],
	"station/3": [
		[0, "", "[[station/3]] est une station nivélienne de haute technologie, dans le système caché [[system/0]]. Son lounge accueille l'agent [[agent/0]], qui vend un plan d'arme.", false],
	],
	"station/30": [
		[34, "", "[[character/1]] attend à la station [[station/30]] lors de l'[[step/34]] avec un plan contre le vaisseau-mère void.", false],
		[35, "", "Le plan consiste à précipiter dans le vaisseau-mère un cargo lourd rempli d'explosifs nucléaires nivéliens.", false],
		[39, "", "Les explosifs récupérés arrivent ici et sont chargés à bord du cargo vossk. Lors de l'[[step/39]], [[character/1]] expose l'opération finale.", false],
	],
	"station/43": [
		[0, "", "[[station/43]] est une petite station terrienne de [[system/8]]. L'agent [[agent/4]] vend un plan de roquette bon marché dans son lounge.", false],
	],
	"station/48": [
		[24, "", "Des vaisseaux voids ont été aperçus près de la station [[station/48]]. Lors de l'[[step/24]], [[character/0]] y amène [[character/6]] pour les observer et récupérer des épaves avec un rayon tracteur.", false],
		[25, "", "À la fin de la récupération, un trou de ver engloutit le vaisseau de [[character/0]], avec [[character/6]] à bord.", false],
		[27, "", "Lorsqu'ils reviennent par un autre trou de ver, des chasseurs voids les suivent, et [[character/0]] doit les détruire ici avant de retourner à la station [[station/10]].", false],
	],
	"station/54": [
		[0, "", "[[station/54]] est une station vossk de pointe dans [[system/10]], un système que seul un moteur de saut permet d'atteindre. L'agent vossk [[agent/5]] vend un plan de missile dans son lounge.", false],
	],
	"station/55": [
		[0, "", "La station [[station/55]] abrite le portail de saut de [[system/11]].", false],
		[19, "", "Les pirates qui retiennent [[character/5]] contre rançon sont repérés près de la station. Deep Science laisse des bombes IEM dans son hangar à l'intention de [[character/0]].", false],
		[22, "", "Après le sauvetage, [[character/0]] retrouve l'officier libéré à la station et reçoit les coordonnées de [[system/6]].", false],
	],
	"station/56": [
		[18, "", "La station [[station/56]] est le point de rendez-vous où [[character/0]] doit récupérer un officier de Deep Science lors de l'[[step/18]].", false],
		[19, "", "L'officier n'arrive jamais. À la place, un message de [[character/1]] annonce que des pirates l'ont enlevé.", false],
	],
	"station/59": [
		[0, "", "[[station/59]] est une petite station du système vossk [[system/20]]. Son lounge accueille un Terrien, l'agent [[agent/10]], qui vend un plan de dispositif de camouflage.", false],
	],
	"station/61": [
		[0, "", "[[station/61]] est l'une des deux seules stations de [[system/12]]. L'agent multipode [[agent/6]] vend un plan d'arme nucléaire dans son lounge.", false],
	],
	"station/65": [
		[0, "", "La station [[station/65]] abrite le portail de saut de [[system/13]]. L'agent cyborg [[agent/14]] vend les coordonnées de [[system/10]] dans son lounge.", false],
	],
	"station/72": [
		[0, "", "[[station/72]] est une petite station terrienne du système sûr [[system/14]]. L'agent [[agent/7]] vend un plan de bouclier dans son lounge.", false],
	],
	"station/76": [
		[11, "", "[[station/76]] est une station de [[system/15]] qui ne répond plus aux appels. Lors de l'[[step/11]], [[character/3]] envoie [[character/0]] découvrir pourquoi.", false],
		[12, "", "La station est intacte. Son équipage est simplement hors d'état de travailler, à cause d'une cargaison de neuro-algues livrée par le trafiquant [[character/4]], une vieille connaissance de [[character/0]].", false],
	],
	"station/78": [
		[0, "", "[[station/78]] est la petite station minière du négociant en minerai nivélien [[character/2]], dans [[system/15]]. L'histoire commence sur son orbite.", false],
		[1, "", "Le vaisseau endommagé de [[character/0]] dérive jusqu'ici en pilote automatique, et [[character/2]] le récupère, pilote compris.", false],
		[2, "", "[[character/2]] dépouille l'épave et fait travailler [[character/0]] à l'extraction de minerai dans les astéroïdes voisins avec le [[ship/0]].", false],
		[8, "", "Après avoir échappé à un raid pirate, [[character/0]] installe sa première arme et aide [[character/2]] à détruire le repaire pirate proche de la station.", false],
		[10, "", "[[character/2]] lui donne ensuite le vaisseau et l'envoie à la station [[station/79]].", false],
		[0, "", "Plus tard dans le jeu, [[character/2]] vend le plan de sa foreuse d'extraction au lounge de la station.", false],
	],
	"station/79": [
		[0, "", "[[station/79]] est une station de [[system/15]] et le siège de son commandant, [[character/3]].", false],
		[10, "", "[[character/2]] envoie [[character/0]] ici lors de l'[[step/9]] pour rencontrer [[character/3]], un humain qui pourrait l'aider à rejoindre l'espace terrien.", false],
		[11, "", "[[character/3]] lui présente la [[faction/3|Confédération Mido]] et lui demande, en échange de son aide, d'aller voir ce qui se passe à la station [[station/76]].", false],
		[13, "", "Après le rapport sur la station [[station/76]], [[character/3]] promet de le mettre en contact avec un convoi terrien attendu à la station.", false],
		[15, "", "Lorsque le convoi arrive, lors de l'[[step/14]], il prend [[character/0]] pour un pirate, neutralise son vaisseau et l'emmène à bord.", false],
	],
	"station/8": [
		[0, "", "[[station/8]] est une station terrienne du système caché [[system/1]]. L'agent nivélien [[agent/1]] vend un plan dans son lounge.", false],
	],
	"station/84": [
		[0, "", "[[station/84]] est une station terrienne de [[system/16]]. L'agent vossk [[agent/8]] vend un plan de blindage vossk dans son lounge.", false],
	],
	"station/88": [
		[0, "", "[[station/88]] est une petite station nivélienne de [[system/17]]. L'agent vossk [[agent/15]] vend les coordonnées de [[system/21]] dans son lounge.", false],
	],
	"station/90": [
		[0, "", "La station [[station/90]] abrite le portail de saut de [[system/18]]. L'agent [[agent/9]] vend un plan de compresseur de soute dans son lounge.", false],
	],
	"station/91": [
		[28, "", "Une activité void est signalée près de la station [[station/91]] lors de l'[[step/28]]. [[character/0]] s'y fraie un chemin jusqu'à un trou de ver pour porter une sonde jusqu'au vaisseau-mère void.", false],
		[31, "", "De retour du secteur des Voids, [[character/0]] reçoit ici un appel de [[character/1]], qui l'invite à la station [[station/98]].", false],
	],
	"station/98": [
		[15, "", "[[station/98]] est une station terrienne de [[system/19]]. Le croiseur qui a arrêté [[character/0]] l'amène ici, et il découvre que son vieil ami [[character/1]] y commande.", false],
		[16, "", "Des chasseurs voids attaquent la station pendant leur conversation, et [[character/0]] aide à les repousser.", false],
		[18, "", "[[character/1]] l'informe sur les Voids et le recrute pour Deep Science.", false],
		[32, "", "Lors de l'[[step/31]], [[character/1]] équipe le vaisseau de [[character/0]] du système d'alerte précoce et lui parle de [[character/20]].", false],
		[44, "", "Après la victoire, [[character/0]] et [[character/1]] font la fête à la station, et [[character/6]] les rejoint.", false],
		[45, "", "Le lendemain matin, [[character/6]] a disparu, laissant un mot et un dernier paiement de Deep Science.", false],
	],
	"step/0": [
		[0, "", "[[character/0]] poursuit une bande de [[faction/8|pirates]] à travers une ceinture d'astéroïdes pour toucher la prime offerte pour leur capture. Vous devez trouver et détruire tous les vaisseaux pirates.", false],
		[1, "", "Une fois les pirates éliminés, Keith met le cap sur Eden Prime, où l'amiral Smith l'a convoqué pour une mission spéciale. Au démarrage de l'hyperpropulseur, un dernier tir endommage son vaisseau. Le propulseur tombe en panne, le système de survie est gravement touché, et le pilote automatique emmène le pilote inconscient vers la station la plus proche, [[station/78]].", false],
	],
	"step/1": [
		[1, "", "Le pilote automatique a mis le vaisseau endommagé de Keith en orbite autour de la station [[station/78]], avec son pilote inconscient à bord.", false],
		[2, "", "Keith se réveille sur une petite station minière dirigée par [[character/2]], un négociant en minerai [[faction/2|nivélien]]. Gunant a démonté le vaisseau et le revendique au titre du droit d'épave. Il rit à l'idée de rejoindre Eden Prime, qui se trouve à l'autre bout de la galaxie, et s'étonne que Keith n'ait jamais entendu parler des Voids, des êtres hostiles qui apparaissent désormais même dans le système [[system/15]].", false],
		[2, "", "Keith n'a ni argent ni vaisseau ; il doit donc travailler pour Gunant en extrayant du minerai à bord d'un vaisseau sans armes.", false],
	],
	"step/10": [
		[10, "", "Keith se rend à la station [[station/79]] pour rencontrer [[character/3]].", false],
		[11, "", "Norris explique que [[system/15]] se trouve dans un secteur découvert récemment. Des exilés terriens et nivéliens s'y sont installés pendant la guerre civile nivélienne et ont fondé une confédération indépendante. Les Terriens l'acceptent, mais les Nivéliens revendiquent toujours le système, si bien que l'on se bat à sa périphérie.", false],
		[11, "", "Norris propose de mettre Keith en contact avec la Flotte spatiale terrienne en échange d'un service : le contact avec la station [[station/76]] a été perdu, et un pilote expérimenté doit découvrir pourquoi.", false],
	],
	"step/11": [
		[11, "", "Keith se rend à la station [[station/76]] pour enquêter sur son silence. La station semble intacte, sans trace de combat ; il s'amarre donc.", false],
		[12, "", "À l'intérieur, Keith tombe sur [[character/4]], un trafiquant notoire qu'il a connu il y a longtemps. Mkkt a apporté une cargaison de neuro-algues, et tout l'équipage est trop intoxiqué pour faire fonctionner les communications. Keith repart dès qu'il le peut.", false],
	],
	"step/12": [
		[12, "", "Keith retourne à la station [[station/79]] pour faire son rapport.", false],
		[13, "", "Norris est consterné et promet de s'occuper du trafiquant. Un convoi militaire terrien fait route vers Kernstal et donnera à Keith l'occasion de contacter la flotte. En attendant son arrivée, Norris suggère à Keith d'accepter des travaux rémunérés au Space Lounge (voir [[guide/lounge]]).", false],
	],
	"step/13": [
		[13, "", "En attendant le convoi, Keith doit accomplir deux contrats freelance proposés au Space Lounge (voir [[guide/jobs]]).", false],
		[14, "", "Norris annonce que le convoi terrien est entré dans le système et se dirige vers la station [[station/79]]. Keith part à sa rencontre.", false],
	],
	"step/14": [
		[14, "", "Près de la station [[station/79]], Keith trouve le convoi terrien et quelques pirates. Il s'approche pour chasser les pirates.", false],
		[15, "", "À bord de son ancien vaisseau pirate, Keith est pris pour l'un des assaillants. Le convoi neutralise son vaisseau avec des armes IEM et l'arrête. Il est emmené à bord d'un croiseur terrien en route vers la station [[station/98]], en territoire terrien.", false],
	],
	"step/15": [
		[15, "", "Keith arrive à la station [[station/98]] en tant que prisonnier du convoi.", false],
		[16, "", "L'officier responsable est [[character/1]], un vieil ami de Keith, aujourd'hui chef de l'Agence de sécurité interstellaire. Il s'excuse pour la méprise. Leurs retrouvailles sont écourtées lorsque des chasseurs voids apparaissent en orbite et que l'alarme retentit dans la station.", false],
	],
	"step/16": [
		[16, "", "Brent demande à Keith de l'aider à repousser les vaisseaux [[faction/9|voids]] qui attaquent la station [[station/98]] (voir [[world/voids]]).", false],
		[17, "", "Les Voids diffusent un message affirmant leurs intentions pacifiques, mais attaquent malgré tout. Keith les repousse, et Brent promet de lui raconter tout ce qu'il sait autour d'un verre de vin.", false],
	],
	"step/17": [
		[17, "", "Keith s'amarre à la station [[station/98]] pour apprendre ce que Brent sait des Voids.", false],
		[18, "", "Les Voids sont apparus ces dernières semaines. Ils arrivent par une sorte de trou de ver, attaquent tout ce qu'ils rencontrent et semblent chercher du minerai ; même les systèmes [[faction/1|vossk]] sont pillés. Brent préside une cellule de crise, dont les scientifiques se rassemblent dans une station de recherche secrète gérée par Deep Science. Il demande à Keith de piloter pour eux.", false],
		[18, "", "Le système de la station ne figure pas sur les cartes stellaires ordinaires ; Keith doit donc rencontrer le lieutenant Thomas Boyle ([[character/5]]) à la station [[station/56]], dans le système [[system/11]], pour obtenir les coordonnées. Brent avoue aussi que le vaisseau de Keith n'est pas neuf : il a seulement été repeint pour éviter d'autres méprises.", false],
	],
	"step/18": [
		[18, "", "Keith se rend à la station [[station/56]] pour rencontrer Boyle.", false],
		[19, "", "Boyle n'est jamais arrivé. Brent annonce que des pirates l'ont enlevé près de la station [[station/55]] et réclament une rançon de cinq millions de crédits. Brent est prêt à payer, mais Keith s'attend à ce que les ravisseurs tuent Boyle une fois payés et part plutôt pour Kappa.", false],
	],
	"step/19": [
		[19, "", "Keith se rend à la station [[station/55]] pour chercher les ravisseurs.", false],
		[20, "", "Les scanners de Kappa localisent le vaisseau des ravisseurs. Brent a fait déposer des bombes IEM dans le hangar de la station, afin que Keith puisse neutraliser le vaisseau pendant que les ravisseurs croient qu'il apporte la rançon.", false],
	],
	"step/2": [
		[2, "", "Gunant confie à Keith un vieux vaisseau maintes fois réparé, le [[ship/0]], un ancien vaisseau pirate équipé d'un laser d'extraction et dépourvu d'armes. Keith doit extraire au moins dix tonnes de minerai des astéroïdes proches de la station [[station/78]] (voir [[guide/mining]]).", false],
		[3, "", "Une fois le minerai à bord, Gunant lui ordonne de s'amarrer pour faire vérifier la cargaison. Sans armes, Keith n'a d'autre choix que de jouer le jeu.", false],
	],
	"step/20": [
		[20, "", "Keith doit s'amarrer à la station [[station/55]] et installer les bombes IEM sur son vaisseau.", false],
		[21, "", "Les bombes montées, Keith part sur-le-champ.", false],
	],
	"step/21": [
		[21, "", "Un point de passage signale le vaisseau des ravisseurs, qui n'est peut-être pas seul. Keith doit le neutraliser avec une bombe IEM au lieu de le détruire, et se débarrasser de toute escorte.", false],
		[22, "", "Les ravisseurs croient que la rançon est arrivée, jusqu'à ce que la bombe mette leurs systèmes hors service. Brent envoie une équipe récupérer Boyle.", false],
	],
	"step/22": [
		[22, "", "Keith s'amarre à la station [[station/55]] pour retrouver le scientifique sauvé.", false],
		[23, "", "Boyle le remercie. Son propre vaisseau ayant été perdu, Keith propose de l'emmener, et Boyle transfère dans l'ordinateur de navigation de Keith les coordonnées du système [[system/6]], où se trouve la station de recherche.", false],
	],
	"step/23": [
		[23, "", "Keith conduit Boyle à la station [[station/10]], dans le système [[system/6]], où la Dr Paolini les attend.", false],
		[24, "", "Keith fait la connaissance de la Dr Carla Paolini ([[character/6]]), qui dirige le projet de Deep Science. Elle veut étudier la technologie des Voids, en commençant par les épaves de leurs vaisseaux. Deep Science verse à Keith 20 000 crédits pour équiper son vaisseau, et un rayon tracteur est indispensable.", false],
		[24, "", "Carla tient à l'accompagner à la station [[station/48]], dans le système [[system/9]], où des Voids ont récemment été aperçus. Keith proteste, mais finit par céder.", false],
	],
	"step/24": [
		[24, "", "Près de la station [[station/48]], Carla veut voir les Voids d'aussi près que possible. Les Voids annoncent qu'ils viennent du futur et qu'ils sont tout ce qui reste des civilisations de la galaxie. Keith doit les combattre et ramasser les débris de leurs vaisseaux avec un rayon tracteur.", false],
		[25, "", "Une fois assez d'épaves à bord, Carla demande à rentrer, mais quelque chose s'empare soudain du vaisseau.", false],
	],
	"step/25": [
		[25, "", "Keith et Carla reprennent connaissance loin de la station [[station/48]], dans une région de l'espace qu'aucun d'eux ne connaît.", false],
		[26, "", "Un gigantesque vaisseau-mère void se trouve à proximité et lance des chasseurs. Keith en conclut qu'ils ont traversé un trou de ver jusqu'au secteur d'origine des Voids. Ce trou de ver a disparu, mais ces passages semblent s'effondrer puis réapparaître ailleurs ; il doit donc en atteindre un autre pour rentrer.", false],
	],
	"step/26": [
		[26, "", "Le trou de ver les ramène près de la station [[station/48]], mais des chasseurs voids les ont suivis. Keith doit les détruire pour qu'ils ne puissent pas suivre le vaisseau jusqu'à la station [[station/10]].", false],
		[27, "", "Débarrassés de leurs poursuivants, tous deux repartent vers Thynome, ayant grand besoin de repos.", false],
	],
	"step/27": [
		[27, "", "Keith s'amarre à la station [[station/10]].", false],
		[28, "", "Deux jours plus tard, Carla lui demande d'y retourner. Son équipe a construit une sonde qui, tirée sur le vaisseau-mère, l'analyse et transmet les résultats au vaisseau de Keith. Elle reste sur place pour étudier les épaves et l'envoie dans le système [[system/18]], où des Voids viennent d'être signalés, pour trouver un autre trou de ver.", false],
		[28, "", "Keith accepte à une condition : s'il revient vivant, Carla lui doit un rendez-vous. Elle accepte.", false],
	],
	"step/28": [
		[28, "", "Près de la station [[station/91]], des chasseurs voids arrivent, et Keith doit atteindre le trou de ver avant qu'il ne s'effondre. Les Voids préviennent que les détruire détruira son propre avenir.", false],
		[29, "", "Keith atteint le trou de ver et passe dans l'espace du Void.", false],
	],
	"step/29": [
		[29, "", "Près du vaisseau-mère, Keith doit le verrouiller, ce qui lance la sonde, puis tenir bon pendant que la sonde termine son analyse.", false],
		[30, "", "Pendant l'attente, les Voids émettent de nouveau : ils doivent trouver un moyen de dialoguer avant que les humains ne les détruisent et, avec eux, leur propre avenir. Keith tient jusqu'à la fin du transfert des données et repart.", false],
	],
	"step/3": [
		[3, "", "Keith s'amarre à la station [[station/78]] pour livrer son premier chargement de minerai.", false],
		[4, "", "Gunant est plutôt satisfait mais renvoie Keith au travail, cette fois pour remplir toute la soute. Il plaisante en disant que Keith pourrait un jour garder le vaisseau s'il se tient bien.", false],
	],
	"step/30": [
		[30, "", "De retour par le trou de ver, Keith attend près de la station [[station/91]].", false],
		[31, "", "Brent appelle et lui demande de passer par la station [[station/98]], dans le système [[system/19]], avant de retourner à Thynome, en lui promettant une surprise. Les données de la sonde pourront être envoyées à Carla depuis là-bas.", false],
	],
	"step/31": [
		[31, "", "Keith s'amarre à la station [[station/98]] pour voir Brent.", false],
		[32, "", "L'équipe de Brent a mis au point un système d'alerte précoce pour la carte stellaire. Il indique où les Voids s'apprêtent à ouvrir un trou de ver, et l'ordinateur de navigation de Keith est modifié pour le recevoir. Brent veut qu'il se rende sur ces lieux pour soutenir les forces locales, et lui verse 30 000 crédits.", false],
		[32, "", "Brent ajoute qu'un [[faction/7|Grey]] nommé [[character/20]], qui travaille pour Deep Science, a demandé à voir Keith.", false],
	],
	"step/32": [
		[32, "", "Keith retourne à la station [[station/10]] pour rencontrer [[character/20]].", false],
		[33, "", "Khador a étudié les épaves voids. Il pense que le secret des trous de ver des Voids réside dans la structure de certains cristaux que l'on ne trouve que dans le secteur des Voids. Il met au point un propulseur capable d'emmener instantanément un vaisseau en n'importe quel point de l'espace, et demande à Keith de lui rapporter au moins 50 de ces cristaux.", false],
		[33, "", "Keith doit de nouveau entrer dans un trou de ver, cette fois en s'aidant du système d'alerte précoce de Brent pour en trouver un.", false],
	],
	"step/33": [
		[33, "", "Keith doit rassembler 50 [[item/164]] dans le secteur des Voids et les livrer à la station [[station/10]].", false],
		[34, "", "Khador, ravi, donne à Keith une copie de son plan du [[item/85]], pour que Keith puisse en construire un (voir [[guide/blueprints]]). Un tel propulseur peut même atteindre le secteur d'origine des Voids.", false],
		[34, "", "Carla arrive, trop occupée pour leur rendez-vous. Elle explique à Keith qu'elle et Brent ont élaboré un plan et l'envoie rejoindre Brent à la station [[station/30]], dans le système [[system/2]].", false],
	],
	"step/34": [
		[34, "", "Keith se rend à la station [[station/30]] pour découvrir le plan de Brent.", false],
		[35, "", "Les données de la sonde montrent que le vaisseau-mère est la source des trous de ver. Aucune arme ne l'a endommagé jusqu'ici ; le plan consiste donc à précipiter en son cœur un cargo robuste chargé d'explosifs nucléaires nivéliens.", false],
		[35, "", "Un cargo vossk K'Sarr est le mieux adapté à cette tâche. Brent s'est arrangé pour en obtenir un auprès de [[character/7]], commandant de la station [[station/29]] dans le système [[system/5]], dans le cadre d'un échange secret de prisonniers. Errkt tient à rencontrer le pilote en personne.", false],
	],
	"step/35": [
		[35, "", "Keith pénètre en territoire [[faction/1|vossk]] pour rencontrer [[character/7]] à la station [[station/29]].", false],
		[36, "", "Errkt, qui s'est penché sur les états de service de Keith, estime que seul un Vossk peut piloter correctement un vaisseau vossk. Comme la mission ne doit pas échouer, il pilotera lui-même le cargo. Mais Keith doit d'abord prouver ses talents de pilote de chasse près de la planète [[station/27]].", false],
	],
	"step/36": [
		[36, "", "Errkt propose un concours dans un repaire pirate près de [[station/27]] : celui qui abat le plus de pirates gagne.", false],
		[37, "", "Keith gagne. Errkt le reconnaît comme un pilote compétent et lui accorde l'honneur d'escorter le cargo, qu'il amènera au point de rendez-vous convenu. Keith appelle Brent pour lui faire son rapport.", false],
	],
	"step/37": [
		[37, "", "Keith contacte Brent depuis [[station/27]] pour lui rendre compte de ses entretiens avec Errkt.", false],
		[38, "", "L'Empire vossk a confirmé son soutien, et Brent accepte Errkt comme pilote. Un nouveau problème surgit : des vaisseaux de la [[faction/3|Confédération Mido]], en guerre contre les Nivéliens, se sont emparés du convoi transportant les explosifs nivéliens. Il a été repéré dans le système [[system/4]], près de la station [[station/22]], et Keith accepte de l'intercepter.", false],
	],
	"step/38": [
		[38, "", "Près de la station [[station/22]], Keith trouve le convoi volé sous l'escorte de chasseurs de Mido. Il doit détruire l'escorte sans endommager les vaisseaux du convoi.", false],
		[39, "", "Le convoi repris, Brent le confie aux forces de sécurité locales pour le trajet jusqu'à la station [[station/30]] et demande à Keith d'y retourner lui aussi.", false],
	],
	"step/39": [
		[39, "", "Keith s'amarre à la station [[station/30]] pour le briefing final.", false],
		[40, "", "Les explosifs sont chargés à bord du cargo vossk, et Errkt en reste le pilote. À la prochaine apparition des Voids, Keith et Errkt s'y rendront. Errkt fera route vers le premier trou de ver, et Keith le couvrira puis le suivra. Brent demandera des renforts à la station la plus proche.", false],
		[40, "", "Errkt doit s'éjecter dans une capsule de sauvetage peu avant l'impact. Keith doit repasser le trou de ver avant la destruction du vaisseau-mère, faute de quoi il n'aura aucun moyen de rentrer.", false],
	],
	"step/4": [
		[4, "", "Keith retourne aux astéroïdes pour extraire du minerai jusqu'à remplir la soute.", false],
		[5, "", "Pendant qu'il extrait, un vaisseau pirate approche. Sans armes, Keith reçoit l'ordre de fuir vers la station en esquivant ses tirs.", false],
	],
	"step/40": [
		[40, "", "Grâce au système d'alerte précoce, Keith se rend sur une orbite attaquée par les Voids. Errkt arrive avec le cargo et se dirige vers le premier trou de ver, et le lieutenant [[character/8]] les rejoint avec son escadron. Keith doit protéger le cargo jusqu'à ce qu'il soit passé.", false],
		[41, "", "Le blindage du cargo est gravement endommagé, mais Errkt atteint le trou de ver, et Keith le suit de l'autre côté.", false],
	],
	"step/41": [
		[41, "", "L'escadron de Baffour n'a pas franchi le trou de ver à temps ; Keith et Errkt sont donc seuls. Le cargo est sur une trajectoire de collision avec le vaisseau-mère, et Keith doit éliminer les chasseurs voids sur son chemin.", false],
		[42, "", "Alors que le cargo approche, Errkt signale que sa capsule de sauvetage a été touchée. Il choisit de rester à bord du cargo et ordonne à Keith de partir tant qu'il en est encore temps. Keith lui fait ses adieux et fait demi-tour.", false],
	],
	"step/42": [
		[42, "", "Keith doit s'éloigner pendant que le cargo d'Errkt fonce vers sa cible.", false],
		[43, "", "Brent annonce que les trous de ver se sont effondrés dans tout le secteur : le plan a fonctionné. Keith lui apprend qu'Errkt n'a pas survécu, et Brent promet de lui rendre hommage dans son rapport à l'Empire vossk. Ils conviennent de se retrouver pour boire un verre à la station [[station/98]].", false],
	],
	"step/43": [
		[43, "", "Keith rejoint Brent à la station [[station/98]] pour fêter la victoire.", false],
		[44, "", "Après plusieurs verres, Carla arrive en robe de soirée pour honorer le rendez-vous qu'elle doit à Keith. Brent a le tact de les laisser seuls.", false],
	],
	"step/44": [
		[44, "", "Keith se réveille à la station [[station/98]] avec la gueule de bois après sa nuit avec Carla.", false],
		[45, "", "Carla est partie. Son mot explique qu'elle est passée à un autre projet secret, en un lieu qu'elle ne révélera pas, et que Deep Science verse à Keith un dernier paiement de 40 000 crédits. Keith soupçonne d'avoir été manipulé depuis le début et retourne au bar.", false],
	],
	"step/45": [
		[45, "", "L'histoire est terminée. Le vaisseau-mère void a été détruit, les trous de ver se sont refermés et [[character/0]] est libre d'aller où bon lui semble. Vous pouvez continuer à voler, commercer, extraire du minerai et accepter des contrats dans toute la galaxie ; voir [[world/history]] pour un résumé de toute l'histoire.", false],
	],
	"step/5": [
		[5, "", "Keith doit distancer le pirate et s'amarrer sain et sauf à la station [[station/78]].", false],
		[6, "", "Gunant reconnaît que les raids pirates contre sa station s'aggravent. Keith propose de s'en charger s'il obtient des armes. Gunant décide de tenter une attaque contre le repaire pirate proche de la station et ouvre son petit hangar pour que Keith puisse installer une arme et un blindage.", false],
	],
	"step/6": [
		[6, "", "Dans le hangar de la station, Keith doit équiper le [[ship/0]] d'une arme et d'une plaque de blindage (voir [[guide/fitting]]).", false],
		[7, "", "Gunant approuve ce choix. Par précaution, il a réglé les armes de Keith pour qu'elles ne puissent pas percer ses propres boucliers. Les deux hommes conviennent de se retrouver dehors.", false],
	],
	"step/7": [
		[7, "", "Gunant transmet l'itinéraire vers le repaire sous forme de points de passage. Keith doit le suivre et y détruire les vaisseaux pirates, avec Gunant à ses côtés (voir [[guide/combat]]).", false],
		[8, "", "Le repaire abrite bien plus de pirates que prévu. Gunant veut battre en retraite, mais Keith continue le combat et l'emporte. Quand Gunant lui demande où il a appris à se battre ainsi, Keith répond qu'il a servi dans la Flotte spatiale sous les ordres de l'amiral Smith. Gunant trouve cela étrange, car Keith a l'air bien trop jeune.", false],
	],
	"step/8": [
		[8, "", "La bataille gagnée, Keith et Gunant retournent à la station [[station/78]].", false],
		[9, "", "Gunant remercie Keith de lui avoir sauvé la vie et évoque la tombe de l'amiral Smith sur la station [[station/5]]. Keith est abasourdi : l'amiral est mort de vieillesse vers 3612. Gunant lui apprend alors que l'on est en 3624, une année qui, selon lui, restera dans les mémoires à cause des Voids.", false],
	],
	"step/9": [
		[9, "", "Ébranlé par la nouvelle, Keith s'amarre de nouveau à la station [[station/78]] pour régler ses affaires avec Gunant.", false],
		[10, "", "Keith comprend qu'environ 35 ans se sont écoulés depuis qu'il a été touché dans la ceinture d'astéroïdes. Gunant soupçonne une panne de l'hyperpropulseur, car ce type de propulseur est associé à des incidents similaires depuis des années.", false],
		[10, "", "Pour le remercier de la victoire sur les pirates, Gunant offre le [[ship/0]] à Keith, équipé d'un propulseur plus puissant pour voyager entre les planètes du système. Il garde le laser d'extraction, un prototype qu'il a construit lui-même. Keith donne enfin son nom et part rencontrer le capitaine [[character/3]], un commandant humain de la station [[station/79]] qui peut l'aider à rejoindre l'espace [[faction/0|terrien]]. Désormais, la [[chart]] permet de voyager à l'intérieur du système.", false],
	],
	"system/0": [
		[0, "", "[[system/0]] est un système nivélien situé sur le bord gauche de la carte. Il reste caché sur la carte de la galaxie tant que vous n'avez pas acheté ses coordonnées à [[agent/12]], à la station [[station/18]]. Son portail, près de la station [[station/0]], le relie à [[system/2]] et [[system/8]].", false],
		[0, "", "Les stations de Suteo comptent parmi les plus avancées de l'espace nivélien, [[station/2]] et [[station/4]] atteignant le niveau technologique maximal. L'agent [[agent/0]] vend un plan à la station [[station/3]].", false],
	],
	"system/1": [
		[0, "", "[[system/1]] est un système terrien situé dans le coin inférieur gauche de la carte. Il reste caché tant que vous n'avez pas acheté ses coordonnées à [[agent/13]], à la station [[station/26]]. Son portail, près de la station [[station/5]], le relie à [[system/8]] et [[system/18]].", false],
		[0, "", "Ses stations sont bien développées, [[station/7]] atteignant le niveau technologique maximal. L'agent [[agent/1]] vend un plan à la station [[station/8]].", false],
		[9, "", "D'après [[character/2]], l'amiral Smith, l'ancien commandant de [[character/0]], est enterré sur la station [[station/5]].", false],
	],
	"system/10": [
		[0, "", "[[system/10]] est un système vossk situé sur la droite de la carte, classé Dangereux. Il reste caché tant que vous n'avez pas acheté ses coordonnées à [[agent/14]], et il n'a aucune liaison par portail : seul un vaisseau équipé d'un moteur de saut peut l'atteindre. Ses cinq stations sont toutes des niveaux technologiques les plus élevés.", false],
		[0, "", "L'agent [[agent/5]] vend un plan à la station [[station/54]].", false],
	],
	"system/11": [
		[0, "", "[[system/11]] est un système terrien situé en haut au centre de la carte, classé Moyen. Il ne compte que trois stations. Son portail, près de la station [[station/55]], le relie à [[system/7]], [[system/9]], [[system/14]] et [[system/16]].", false],
		[18, "", "[[character/0]] est envoyé à la station [[station/56]] pour rencontrer un officier de Deep Science.", false],
		[19, "", "L'officier, [[character/5]], a été enlevé par des pirates près de la station [[station/55]].", false],
		[22, "", "[[character/0]] le libère à l'aide de bombes IEM lors de l'[[step/21]].", false],
	],
	"system/12": [
		[0, "", "[[system/12]] est un petit système vossk de seulement deux stations, situé sur la droite de la carte et classé Moyen. Son portail, près de la station [[station/60]], le relie à [[system/3]], [[system/5]], [[system/13]] et [[system/14]] ; il rattache ainsi l'espace vossk à l'est terrien.", false],
		[0, "", "L'agent multipode [[agent/6]] vend un plan à la station [[station/61]].", false],
	],
	"system/13": [
		[0, "", "[[system/13]] est un système terrien situé sur le bord droit de la carte, classé Risqué. Son portail, près de la station [[station/65]], le relie à [[system/12]] et [[system/16]].", false],
		[0, "", "L'agent cyborg [[agent/14]] vend des coordonnées à la station [[station/65]].", false],
	],
	"system/14": [
		[0, "", "[[system/14]] est un système terrien situé près du centre de la carte et l'un des deux systèmes Sûrs de la galaxie. Son portail, près de la station [[station/70]], le relie à [[system/3]], [[system/11]], [[system/12]] et [[system/19]]. Ses stations sont pour la plupart de faible niveau technologique.", false],
		[0, "", "L'agent [[agent/7]] vend un plan à la station [[station/72]].", false],
	],
	"system/15": [
		[0, "", "[[system/15]] est un système midorien situé en haut de la carte, classé Dangereux. Il n'a aucune liaison par portail ; un vaisseau ne peut donc y entrer ou en sortir qu'avec un moteur de saut. Ses cinq stations sont toutes petites et de faible niveau technologique. Jusqu'à l'[[step/16]], ses concessionnaires restent fermés et peu de vaisseaux vont et viennent.", false],
		[0, "", "L'histoire commence ici, à la station [[station/78]].", false],
		[11, "", "Le système est le territoire de la [[faction/3|Confédération Mido]], fondée par des exilés terriens et nivéliens pendant la guerre civile nivélienne. Les Nivéliens le revendiquent toujours, et l'on se bat à sa périphérie.", false],
		[15, "", "[[character/0]] quitte le système en tant que prisonnier à bord d'un croiseur terrien après l'[[step/14]]. Pour y revenir plus tard, il faut un moteur de saut.", false],
		[0, "", "[[character/2]] vend un plan au lounge de la station [[station/78]].", false],
	],
	"system/16": [
		[0, "", "[[system/16]] est un système terrien situé sur la droite de la carte, classé Risqué. Son portail, près de la station [[station/80]], le relie à [[system/11]] et [[system/13]].", false],
		[0, "", "L'agent vossk [[agent/8]] vend un plan à la station [[station/84]].", false],
	],
	"system/17": [
		[0, "", "[[system/17]] est un système nivélien situé en haut à gauche de la carte, classé Risqué, et le système le plus proche de [[system/15]]. Son portail, près de la station [[station/85]], le relie à [[system/2]], [[system/9]] et [[system/4]] ; c'est la seule route de portail vers [[system/4]].", false],
		[0, "", "L'agent vossk [[agent/15]] vend des coordonnées à la station [[station/88]].", false],
	],
	"system/18": [
		[0, "", "[[system/18]] est un système terrien situé en bas de la carte, classé Risqué. Son portail, près de la station [[station/90]], le relie à [[system/1]] et [[system/8]].", false],
		[0, "", "L'agent [[agent/9]] vend un plan à la station [[station/90]].", false],
		[28, "", "Lors de l'[[step/28]], [[character/0]] vient ici après un signalement d'activité void près de la station [[station/91]], pour se glisser dans un trou de ver.", false],
	],
	"system/19": [
		[0, "", "[[system/19]] est un système terrien situé au centre de la carte, classé Sûr. Son portail, près de la station [[station/95]], le relie à [[system/3]], [[system/8]], [[system/9]] et [[system/14]].", false],
		[15, "", "C'est à la station [[station/98]] que le croiseur terrien amène [[character/0]] après son arrestation, et c'est là qu'il retrouve son vieil ami [[character/1]].", false],
		[16, "", "Même ce système sûr n'est pas épargné : une escadrille void attaque la station [[station/98]] lors de l'[[step/16]]. [[character/1]] y a son quartier général.", false],
	],
	"system/2": [
		[0, "", "[[system/2]] est un système nivélien situé sur la gauche de la carte, carrefour de l'espace nivélien. Son portail, près de la station [[station/30]], le relie à [[system/0]], [[system/8]], [[system/9]] et [[system/17]]. Il compte quatre stations de niveau technologique moyen.", false],
		[34, "", "Lors de l'[[step/33]], [[character/6]] envoie [[character/0]] à la station [[station/30]], où [[character/1]] l'attend avec un nouveau plan. Les derniers préparatifs contre les Voids s'y déroulent également.", false],
	],
	"system/20": [
		[0, "", "[[system/20]] est un système vossk situé en bas à droite de la carte, classé Dangereux. Son portail, près de la station [[station/62]], le relie à [[system/5]] et [[system/21]], ce qui en fait la seule route de portail vers [[system/21]].", false],
		[0, "", "Un Terrien, l'agent [[agent/10]], vend un plan à la petite station [[station/59]].", false],
	],
	"system/21": [
		[0, "", "[[system/21]] est un système vossk situé tout au fond du coin inférieur droit de la carte, classé Dangereux. Il reste caché tant que vous n'avez pas acheté ses coordonnées à [[agent/15]]. Son portail, près de la station [[station/12]], le relie uniquement à [[system/20]]. Ses stations sont toutes primitives, avec un niveau technologique de 3 ou moins.", false],
	],
	"system/3": [
		[0, "", "[[system/3]] est le système vossk le plus proche du centre de la carte et la principale porte d'entrée de l'espace vossk. Son portail, près de la station [[station/15]], le relie à [[system/5]], [[system/12]], [[system/8]], [[system/14]] et [[system/19]]. Il est classé Moyen.", false],
		[0, "", "L'agent [[agent/12]], à la station [[station/18]], vend les coordonnées du système caché [[system/0]].", false],
	],
	"system/4": [
		[0, "", "[[system/4]] est un système midorien situé dans le coin supérieur gauche de la carte, classé Dangereux. C'est un cul-de-sac : son portail, près de la station [[station/20]], ne mène qu'à [[system/17]]. Ses stations vont de la primitive [[station/21]] à la bien équipée [[station/22]].", false],
		[0, "", "L'agent [[agent/2]] vend un plan au lounge de la station [[station/20]].", false],
		[38, "", "Lors de l'[[step/38]], un convoi volé transportant des explosifs nivéliens est repéré dans ce système, près de la station [[station/22]].", false],
	],
	"system/5": [
		[0, "", "[[system/5]] est un système vossk situé en bas à droite de la carte, classé Risqué. Son portail, près de la station [[station/25]], le relie à [[system/3]], [[system/12]] et [[system/20]]. L'agent [[agent/13]] vend des coordonnées à la station [[station/26]].", false],
		[35, "", "Le système est le port d'attache du commandant vossk [[character/7]], à la station [[station/29]], où [[character/0]] le rencontre lors de l'[[step/35]].", false],
		[36, "", "Leur concours a lieu près de [[station/27]].", false],
	],
	"system/6": [
		[0, "", "[[system/6]] est un système terrien situé en haut à droite de la carte, classé Dangereux. Il ne figure pas sur les cartes stellaires ordinaires, et seule l'histoire révèle ses coordonnées. Il ne compte qu'une station, [[station/10]], dont le portail le relie uniquement à [[system/7]].", false],
		[23, "", "Le système abrite la station de recherche secrète de Deep Science. [[character/5]] en donne les coordonnées à [[character/0]] lors de l'[[step/22]], et une grande partie de la lutte contre les Voids s'y prépare.", false],
	],
	"system/7": [
		[0, "", "[[system/7]] est un système terrien situé en haut à droite de la carte, classé Risqué. Son portail, près de la station [[station/35]], le relie à [[system/11]] et au système caché [[system/6]], ce qui en fait la seule route de portail vers ce dernier. [[station/37]] est sa station la plus avancée.", false],
	],
	"system/8": [
		[0, "", "[[system/8]] est un système terrien situé dans le quart inférieur gauche de la carte et le système le mieux relié de la galaxie. Son portail, près de la station [[station/40]], le relie à six systèmes : [[system/0]], [[system/1]], [[system/2]], [[system/3]], [[system/18]] et [[system/19]]. Il est classé Moyen.", false],
		[0, "", "L'agent [[agent/4]] vend un plan à la station [[station/43]].", false],
	],
	"system/9": [
		[0, "", "[[system/9]] est un système nivélien situé en haut au centre de la carte, classé Moyen. Son portail, près de la station [[station/45]], le relie à [[system/2]], [[system/11]], [[system/17]] et [[system/19]].", false],
		[24, "", "Une activité void est signalée près de la station [[station/48]], et [[character/0]] et [[character/6]] s'y rendent lors de l'[[step/24]] pour récupérer des épaves.", false],
	],
	"world/galaxy": [
		[0, "Vue d'ensemble", "Le jeu se déroule dans une seule galaxie de 22 systèmes stellaires. Chaque système appartient à une faction, possède un niveau de sécurité et compte entre une et cinq stations spatiales. Chaque station orbite autour d'une planète et dispose de sa propre boutique, de son hangar et de son Space Lounge. Les systèmes sont répartis sur une carte plane, et l'on voyage de l'un à l'autre par un réseau de portails de saut.", false],
		[0, "", "Quatre peuples se partagent les systèmes cartographiés. Les [[faction/0|Terriens]] en possèdent dix, les [[faction/1|Vossk]] six, les [[faction/2|Nivéliens]] quatre et les [[faction/3|Midoriens]] deux. Des membres de races plus petites, comme les [[faction/4|Multipodes]], les [[faction/5|Cyborgs]], les [[faction/6|Bobolians]] et les [[faction/7|Grey]], vivent parmi eux sans territoire propre. Les [[faction/8|pirates]] sillonnent tous les systèmes et, dès le début, des rumeurs évoquent une force hostile appelée les [[faction/9|Voids]].", false],
		[0, "Géographie", "Les systèmes nivéliens et midoriens se trouvent en haut à gauche de la carte, autour de [[system/15]], [[system/4]], [[system/17]] et [[system/2]]. L'espace terrien s'étend au centre, sur la droite et en bas de la carte, avec [[system/19]] et [[system/14]] en son cœur. Les systèmes vossk forment un bloc séparé en bas à droite, qui commence à [[system/3]] et se termine dans le coin le plus éloigné, à [[system/21]].", false],
		[0, "", "Les routes des portails favorisent le centre. [[system/8]] compte six liaisons par portail, plus que tout autre système, et [[system/19]], [[system/14]], [[system/3]] et [[system/11]] relient chacun quatre ou cinq systèmes. Les systèmes situés en bordure, comme [[system/4]], [[system/6]] et [[system/21]], sont des culs-de-sac avec une seule liaison.", false],
		[0, "Voyager", "À l'intérieur d'un système, le propulseur ordinaire d'un vaisseau le mène de l'orbite d'une station à celle d'une autre. Pour quitter un système, un vaisseau traverse son portail de saut, qui se trouve près de l'une des stations du système et ne mène qu'aux systèmes qui lui sont reliés. Les longs trajets sont des enchaînements de sauts par portail. Un moteur de saut est le seul moyen de contourner le réseau des portails et d'atteindre directement n'importe quel système connu ; voir [[guide/navigation]].", false],
		[33, "", "Le seul moteur de saut du jeu est le [[item/85]], que [[character/20]] conçoit au cours de l'histoire. Il se construit à partir d'un plan et nécessite, entre autres, des [[item/164]].", false],
		[0, "Sécurité", "Chaque système est classé Sûr, Moyen, Risqué ou Dangereux. Ce niveau détermine la fréquence à laquelle des assaillants vous guettent près d'une station à votre arrivée. Dans un système Dangereux, ils sont là à la plupart des visites ; dans un système Sûr, ils sont rares. Les assaillants sont généralement des pirates, mais parfois des vaisseaux de la race rivale de la faction. Les systèmes plus sûrs, en revanche, entretiennent davantage de patrouilles locales autour de leurs stations.", false],
		[0, "Factions et réputation", "Votre réputation est mesurée sur deux échelles : l'une entre les Terriens et les Vossk, l'autre entre les Nivéliens et les Midoriens. Gagner la faveur d'un camp d'une paire coûte la faveur de l'autre. Si votre réputation auprès d'une faction tombe trop bas, ses vaisseaux vous attaquent à vue et ses stations vous refusent l'accès. Les pirates et les Voids sont toujours hostiles. Un diplomate dans un Space Lounge peut rétablir votre réputation moyennant finance.", false],
		[0, "Systèmes cachés", "Tous les systèmes n'apparaissent pas d'emblée sur la carte de la galaxie. [[system/0]], [[system/1]], [[system/10]] et [[system/21]] restent cachés tant que vous n'avez pas acheté leurs coordonnées à un agent dans un Space Lounge ; voir [[guide/lounge]]. Un autre système, [[system/6]], ne figure pas sur les cartes stellaires ordinaires et seule l'histoire le révèle.", false],
		[23, "", "Les coordonnées de [[system/6]] vous parviennent par [[character/5]] lors de l'[[step/22]]. Le système ne compte qu'une station, [[station/10]], la base de recherche secrète de l'organisation Deep Science.", false],
		[0, "", "Deux systèmes n'ont aucune liaison par portail : [[system/15]] et [[system/10]]. Un vaisseau ne peut les atteindre ou les quitter qu'avec un moteur de saut.", false],
		[0, "Un départ isolé", "L'histoire commence dans [[system/15]], un système reculé situé en haut de la carte et sans liaison par portail avec le reste de la galaxie. Son commerce est pauvre, ses stations sont de faible niveau technologique, et ses concessionnaires restent fermés pendant la première partie de l'histoire. Au début, le seul moyen de quitter le système est celui que fournit l'histoire.", false],
		[11, "", "[[system/15]] abrite la [[faction/3|Confédération Mido]], un groupe de réfugiés et de hors-la-loi terriens et nivéliens qui se sont installés dans ce secteur récemment cartographié pendant la guerre civile nivélienne. La Confédération s'est proclamée indépendante. Les Terriens l'acceptent ; les Nivéliens revendiquent toujours le système, ce qui entretient les combats à sa périphérie.", false],
		[15, "", "[[character/0]] quitte [[system/15]] à bord d'un croiseur terrien, après que le convoi l'a neutralisé et arrêté près de la station [[station/79]] lors de l'[[step/14]]. Il arrive à la station [[station/98]], dans le système [[system/19]], au cœur de l'espace terrien.", false],
		[9, "Le saut dans le temps", "Lorsque [[character/0]] se réveille dans [[system/15]], il croit que peu de temps s'est écoulé. En réalité, son hyperpropulseur endommagé l'a projeté à travers la galaxie et quelque 35 ans dans le futur. La galaxie qu'il connaissait a changé : ses vieux amis ont vieilli ou sont morts, et de nouveaux secteurs, dont celui où il se trouve, ont été colonisés entre-temps.", false],
		[10, "", "Des hyperpropulseurs défectueux de ce type ont déjà provoqué des sauts semblables à travers le temps et l'espace.", false],
		[18, "Au-delà de la carte", "Les Voids pénètrent dans les systèmes cartographiés par une sorte de trou de ver. Ils pillent indifféremment l'espace terrien, nivélien et vossk, et semblent chercher du minerai. Voir [[world/voids]].", false],
		[25, "", "Un trou de ver mène hors de la galaxie cartographiée, dans le secteur des Voids, qui ne figure pas sur la carte de la galaxie. Les trous de ver s'ouvrent près d'une station pendant un certain temps, puis s'effondrent et apparaissent ailleurs.", false],
		[34, "", "Équipé du [[item/85]], un vaisseau peut aussi sauter directement dans le secteur des Voids.", false],
		[32, "", "À partir de l'[[step/31]], un système d'alerte précoce indique sur la carte de la galaxie où s'ouvrira le prochain trou de ver.", false],
		[42, "", "Lorsque le vaisseau-mère void est détruit lors de l'[[step/41]], les trous de ver s'effondrent dans tout le secteur et les raids cessent.", false],
	],
	"world/history": [
		[0, "", "La galaxie est partagée entre plusieurs peuples, parmi lesquels les [[faction/0|Terriens]], les [[faction/2|Nivéliens]] et les [[faction/1|Vossk]]. L'espace entre leurs stations est infesté de [[faction/8|pirates]]. Cette page résume l'histoire ; chaque partie apparaît dès que votre sauvegarde l'atteint.", false],
		[0, "Acte I : naufragé", "Le chasseur de primes terrien [[character/0]] anéantit une bande de pirates dans une ceinture d'astéroïdes ([[step/0]]).", false],
		[1, "", "Un dernier tir endommage son hyperpropulseur au moment où il part rejoindre son ancien commandant, l'amiral Smith. Son vaisseau dérive, son pilote inconscient, jusqu'à la station [[station/78]].", false],
		[2, "", "Le négociant en minerai nivélien [[character/2]] récupère l'épave, garde le vaisseau et oblige Keith à extraire du minerai pour lui.", false],
		[8, "", "Keith aide Gunant à détruire un repaire de pirates tout proche ([[step/7]]).", false],
		[9, "", "Keith apprend ensuite que l'on est en 3624 et que l'amiral Smith est mort depuis longtemps.", false],
		[10, "", "Une panne de l'hyperpropulseur a projeté Keith 35 ans dans le futur, dans un coin reculé de la galaxie. Gunant lui donne le vaisseau [[ship/0]] et l'envoie voir [[character/3]] à la station [[station/79]].", false],
		[11, "", "Le système [[system/15]] appartient à la [[faction/3|Confédération Mido]], fondée par des exilés terriens et nivéliens pendant la guerre civile nivélienne.", false],
		[12, "", "Keith découvre que la station muette [[station/76]] a été plongée dans l'hébétude par les drogues du trafiquant [[character/4]] ([[step/11]]).", false],
		[15, "", "Lorsqu'un convoi terrien passe par là, il prend Keith pour un pirate, neutralise son vaisseau et l'emmène à la station [[station/98]] ([[step/14]]).", false],
		[16, "Acte II : la menace void", "Il y retrouve son vieil ami [[character/1]], devenu chef de la sécurité, au moment même où les [[faction/9|Voids]] attaquent la station.", false],
		[18, "", "Les Voids pillent les systèmes stellaires par des trous de ver, à la recherche de minerai. Brent recrute Keith comme pilote pour Deep Science, une organisation de recherche secrète qui les étudie ([[step/17]]).", false],
		[19, "", "Le scientifique [[character/5]], qui devait guider Keith jusqu'à la station de recherche, est enlevé par des pirates.", false],
		[23, "", "Keith neutralise le vaisseau des ravisseurs avec des bombes IEM, libère le scientifique et reçoit les coordonnées du système [[system/6]] ([[step/21]], [[step/22]]).", false],
		[24, "Acte III : Deep Science", "À la station [[station/10]], Keith rencontre la responsable du projet, [[character/6]], et commence à travailler pour Deep Science.", false],
		[25, "", "Keith et Carla récupèrent des épaves voids près de la station [[station/48]], mais un trou de ver engloutit leur vaisseau ([[step/24]]).", false],
		[26, "", "Ils se retrouvent dans le secteur d'origine des Voids, à côté d'un gigantesque vaisseau-mère, et s'échappent par un autre trou de ver.", false],
		[30, "", "Keith retourne dans le secteur des Voids par un trou de ver proche de la station [[station/91]] et lance une sonde sur le vaisseau-mère ([[step/29]]).", false],
		[32, "", "Brent donne à Keith un système d'alerte précoce qui indique où les Voids vont frapper.", false],
		[34, "", "Le scientifique grey [[character/20]] charge Keith de collecter des cristaux voids pour un nouveau propulseur instantané et lui en remet le plan ([[step/33]]).", false],
		[35, "Acte IV : l'attaque", "La sonde révèle que le vaisseau-mère crée les trous de ver. Brent et Carla prévoient de le détruire avec un cargo rempli d'explosifs nivéliens, fournis par le commandant vossk [[character/7]].", false],
		[37, "", "Errkt tient à piloter lui-même le cargo, et Keith gagne le droit de l'escorter ([[step/36]]).", false],
		[39, "", "Keith reprend le convoi transportant les explosifs après sa capture par des vaisseaux de Mido ([[step/38]]).", false],
		[42, "", "Avec des renforts menés par [[character/8]], Keith escorte Errkt à travers un trou de ver. Errkt précipite le cargo sur le vaisseau-mère et meurt dans l'attaque ([[step/41]]).", false],
		[43, "", "Tous les trous de ver s'effondrent et les raids des Voids prennent fin.", false],
		[45, "Épilogue", "Keith fait la fête avec Brent et passe enfin une nuit avec Carla. Elle part le lendemain matin pour un autre projet secret, et Keith reste libre de parcourir la galaxie.", false],
	],
	"world/khador": [
		[32, "", "Khador, un scientifique grey qui travaille pour Deep Science, a sa propre page : voir [[character/20]].", false],
	],
	"world/voids": [
		[0, "", "Les [[faction/9|Voids]] sont la menace centrale de l'histoire. Cette page rassemble ce que l'on apprend à leur sujet ; d'autres éléments apparaissent à mesure que votre sauvegarde progresse.", false],
		[2, "Premiers rapports", "Keith entend parler des Voids pour la première fois par [[character/2]] : des êtres hostiles qui surgissent de temps à autre, même dans le système reculé [[system/15]].", false],
		[9, "", "Dans le système Mido, on s'attend à ce que 3624 reste dans les mémoires comme l'année des Voids.", false],
		[16, "", "Des chasseurs voids attaquent la station [[station/98]] en territoire terrien ([[step/15]]).", false],
		[17, "", "Pendant l'attaque, les Voids diffusent un message affirmant qu'ils viennent en paix, mais ils continuent de tirer.", false],
		[18, "Ce que l'on sait", "Les Voids ont commencé à apparaître quelques semaines plus tôt. Ils pénètrent dans les systèmes habités par des trous de ver, attaquent tout ce qu'ils rencontrent et semblent chercher du minerai. Même les systèmes [[faction/1|vossk]] sont pillés. Personne ne sait d'où ils viennent ni ce qu'ils veulent.", false],
		[24, "", "Près de la station [[station/48]], ils annoncent qu'ils viennent du futur et qu'ils sont tout ce qui reste des civilisations de la galaxie.", false],
		[26, "Le secteur d'origine", "Leurs trous de ver mènent à un lointain secteur d'origine, où un gigantesque vaisseau-mère lance des chasseurs. Les trous de ver s'ouvrent peu de temps, puis s'effondrent et réapparaissent ailleurs.", false],
		[28, "", "Les Voids avertissent que les détruire reviendrait à détruire l'avenir de l'humanité.", false],
		[30, "", "Ils répètent qu'ils doivent trouver un moyen de communiquer avant que les humains ne les détruisent, et leur propre avenir avec eux. La véracité de cette affirmation n'est jamais établie.", false],
		[32, "", "Un système d'alerte précoce mis au point par l'équipe de [[character/1]] prédit où les Voids ouvriront leur prochain trou de ver.", false],
		[33, "", "Le scientifique grey [[character/20]] pense que des cristaux que l'on ne trouve que dans le secteur des Voids, les [[item/164]], détiennent le secret de leurs trous de ver.", false],
		[35, "La fin des raids", "La sonde lancée sur le vaisseau-mère montre qu'il est la source des trous de ver. Aucune arme connue n'a pu l'endommager.", false],
		[42, "", "Un cargo vossk chargé d'explosifs nucléaires nivéliens, piloté par [[character/7]], détruit le vaisseau-mère ([[step/41]]).", false],
		[43, "", "Les trous de ver s'effondrent ensuite dans tout le secteur et les raids des Voids cessent, du moins pour le moment.", false],
	],
}
