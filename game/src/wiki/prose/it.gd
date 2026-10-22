extends RefCounted
## Reference prose in Italian. Each block is [story step it appears from,
## section heading or "", text, list item]. See src/wiki/prose.gd.
const PAGES := {
	"guide/basics": {"title": "Primi passi", "subtitle": "Guida", "category": "guide", "from": 0},
	"guide/blueprints": {"title": "Progetti e produzione", "subtitle": "Guida", "category": "guide", "from": 0},
	"guide/combat": {"title": "Combattimento", "subtitle": "Guida", "category": "guide", "from": 0},
	"guide/fitting": {"title": "Navi ed equipaggiamento", "subtitle": "Guida", "category": "guide", "from": 0},
	"guide/flight": {"title": "Volo", "subtitle": "Guida", "category": "guide", "from": 0},
	"guide/jobs": {"title": "Incarichi freelance", "subtitle": "Guida", "category": "guide", "from": 0},
	"guide/lounge": {"title": "Space Lounge", "subtitle": "Guida", "category": "guide", "from": 0},
	"guide/medals": {"title": "Medaglie", "subtitle": "Guida", "category": "guide", "from": 0},
	"guide/mining": {"title": "Estrazione mineraria", "subtitle": "Guida", "category": "guide", "from": 0},
	"guide/navigation": {"title": "Navigazione", "subtitle": "Guida", "category": "guide", "from": 0},
	"guide/trading": {"title": "Commercio", "subtitle": "Guida", "category": "guide", "from": 0},
	"step/0": {"title": "Taglia nella fascia di asteroidi"},
	"step/1": {"title": "Alla deriva"},
	"step/10": {"title": "Incontro con il comandante"},
	"step/11": {"title": "Una stazione muta"},
	"step/12": {"title": "Rapporto al comandante"},
	"step/13": {"title": "In attesa del convoglio"},
	"step/14": {"title": "Il convoglio terrestre"},
	"step/15": {"title": "In arresto"},
	"step/16": {"title": "In difesa della stazione"},
	"step/17": {"title": "La storia dei Void"},
	"step/18": {"title": "Appuntamento con uno scienziato"},
	"step/19": {"title": "Il rapimento"},
	"step/2": {"title": "Il primo carico di minerale"},
	"step/20": {"title": "Montare le bombe"},
	"step/21": {"title": "Neutralizzare i rapitori"},
	"step/22": {"title": "Lo scienziato salvato"},
	"step/23": {"title": "La stazione di ricerca segreta"},
	"step/24": {"title": "Recupero di relitti Void"},
	"step/25": {"title": "Perduti in uno spazio sconosciuto"},
	"step/26": {"title": "Seminare gli inseguitori"},
	"step/27": {"title": "Un nuovo incarico"},
	"step/28": {"title": "Di nuovo nel wormhole"},
	"step/29": {"title": "Il lancio della sonda"},
	"step/3": {"title": "La consegna del minerale"},
	"step/30": {"title": "La chiamata di un vecchio amico"},
	"step/31": {"title": "Una sorpresa promessa"},
	"step/32": {"title": "Lo scienziato Grey"},
	"step/33": {"title": "Cristalli dal Void"},
	"step/34": {"title": "Un piano per la vittoria"},
	"step/35": {"title": "Incontro con il comandante Vossk"},
	"step/36": {"title": "Una sfida tra piloti"},
	"step/37": {"title": "Chiamata al quartier generale"},
	"step/38": {"title": "Riconquistare il convoglio"},
	"step/39": {"title": "Gli ultimi preparativi"},
	"step/4": {"title": "Una stiva piena"},
	"step/40": {"title": "Scorta fino al wormhole"},
	"step/41": {"title": "Attacco alla nave madre"},
	"step/42": {"title": "Fuga dallo spazio Void"},
	"step/43": {"title": "Una festa"},
	"step/44": {"title": "Il mattino dopo"},
	"step/45": {"title": "Epilogo"},
	"step/5": {"title": "Fuga verso la stazione"},
	"step/6": {"title": "Armare la nave"},
	"step/7": {"title": "Il covo dei pirati"},
	"step/8": {"title": "Dopo la battaglia"},
	"step/9": {"title": "Regolare i conti"},
	"world/galaxy": {"title": "La galassia", "subtitle": "Ambientazione", "category": "world", "from": 0},
	"world/history": {"title": "Storia", "subtitle": "Ambientazione", "category": "world", "from": 0},
	"world/khador": {"title": "Khador", "subtitle": "Personaggio", "category": "characters", "from": 32},
	"world/voids": {"title": "I Void", "subtitle": "Ambientazione", "category": "world", "from": 0},
}
const BLOCKS := {
	"agent/0": [
		[0, "", "[[agent/0]] è un agente niveliano nella lounge di [[station/3]], nel sistema nascosto [[system/0]]. Vende il progetto del laser [[item/11]].", false],
	],
	"agent/1": [
		[0, "", "[[agent/1]] è un agente niveliano nella lounge di [[station/8]], nel sistema nascosto [[system/1]]. Vende il progetto del blaster [[item/15]], un'arma che lui descrive come rara.", false],
	],
	"agent/10": [
		[0, "", "[[agent/10]] è un agente terrestre che vive tra i Vossk, nella lounge di [[station/59]] in [[system/20]]. Vende il progetto del dispositivo di occultamento [[item/96]].", false],
	],
	"agent/11": [
		[0, "", "[[agent/11]] è il commerciante di minerali [[character/2]], che compare nella propria lounge presso [[station/78]] in [[system/15]]. Vende il progetto del [[item/90]], il suo laser minerario, a un prezzo molto più alto di quello di qualsiasi altro agente. Poiché [[system/15]] non ha collegamenti tramite portale, per raggiungerlo più avanti nel gioco serve un motore di salto.", false],
		[10, "", "Accoglie [[character/0]] come il viaggiatore nel tempo e ha cominciato a produrre la trivella che un tempo teneva per sé.", false],
	],
	"agent/12": [
		[0, "", "[[agent/12]] è un agente Vossk nella lounge di [[station/18]] in [[system/3]]. Vende le coordinate del sistema nascosto [[system/0]], di cui elogia le numerose stazioni avanzate.", false],
	],
	"agent/13": [
		[0, "", "[[agent/13]] è un agente boboliano nella lounge di [[station/26]] in [[system/5]]. Vende le coordinate del sistema nascosto [[system/1]].", false],
	],
	"agent/14": [
		[0, "", "[[agent/14]] è un agente Cyborg nella lounge di [[station/65]] in [[system/13]]. Vende le coordinate di [[system/10]], ma ammette di non avere idea di come arrivarci. Senza un motore di salto le coordinate sono inutili, perché il sistema non ha collegamenti tramite portale.", false],
	],
	"agent/15": [
		[0, "", "[[agent/15]] è un agente Vossk nella lounge di [[station/88]] in [[system/17]]. Vende le coordinate del sistema nascosto [[system/21]], che chiama casa sua. Una volta noto, il sistema si può raggiungere tramite portale da [[system/20]].", false],
	],
	"agent/2": [
		[0, "", "[[agent/2]] è un agente midoriano nella lounge di [[station/20]] in [[system/4]]. Vende il progetto del [[item/25]], il progetto d'arma più economico offerto da un agente, a parte il razzo di [[agent/4]].", false],
	],
	"agent/3": [
		[0, "", "[[agent/3]] è un agente terrestre nella lounge di [[station/10]] in [[system/6]]. Vende il progetto del [[item/27]], un cannone a propulsione di massa a tiro rapido.", false],
	],
	"agent/4": [
		[0, "", "[[agent/4]] è un agente terrestre nella lounge di [[station/43]] in [[system/8]]. Vende il progetto del [[item/33]], il progetto più economico offerto da un agente.", false],
	],
	"agent/5": [
		[0, "", "[[agent/5]] è un agente Vossk nella lounge di [[station/54]] in [[system/10]], un sistema raggiungibile solo con un motore di salto. Vende il progetto del siluro a ricerca [[item/37]], che nessun negozio tiene in vendita.", false],
	],
	"agent/6": [
		[0, "", "[[agent/6]] è l'unico Multipod del gioco. Si trova nella lounge di [[station/61]] in [[system/12]] e vende il progetto dell'arma nucleare [[item/46]].", false],
	],
	"agent/7": [
		[0, "", "[[agent/7]] è un agente terrestre nella lounge di [[station/72]] in [[system/14]]. Vende il progetto del [[item/54]], uno scudo potente.", false],
	],
	"agent/8": [
		[0, "", "[[agent/8]] è un agente Vossk nella lounge di [[station/84]] in [[system/16]]. Vende il progetto della [[item/59]], una piastra di corazza Vossk mai venduta nei negozi. È il progetto più costoso venduto da un agente, dopo la trivella di [[agent/11]].", false],
	],
	"agent/9": [
		[0, "", "[[agent/9]] è un agente terrestre nella lounge di [[station/90]] in [[system/18]]. Vende il progetto del [[item/67]], un compressore di carico che consiglia a ogni commerciante.", false],
	],
	"character/0": [
		[0, "", "[[character/0]] è il protagonista e il personaggio che interpreti. È un pilota da caccia [[faction/0]] che si guadagna da vivere dando la caccia ai [[faction/8|pirati]] per le taglie sulle loro teste. È sicuro di sé, sarcastico e pronto a menare le mani.", false],
		[1, "Naufrago", "Mentre è diretto a Eden Prime, dove l'ammiraglio Smith ha una missione speciale per lui, il suo iperpropulsore viene danneggiato in un attacco pirata. L'autopilota lo porta, privo di sensi, a [[station/78]].", false],
		[2, "", "Lì viene soccorso dal commerciante di minerali [[character/2]], che ha rivendicato la sua nave come relitto recuperato e lo mette al lavoro come minatore.", false],
		[8, "", "Keith è un veterano della Space Fleet terrestre, dove ha servito agli ordini dell'ammiraglio Smith.", false],
		[9, "", "Scopre che l'ammiraglio è morto di vecchiaia e che ora è il 3624.", false],
		[10, "", "Dal suo incidente sono passati circa 35 anni, a quanto pare per un guasto all'iperpropulsore, eppure Keith non è invecchiato affatto. Bloccato nel remoto sistema [[system/15]], ricomincia da capo con la [[ship/0]], un dono di Gunant.", false],
		[16, "La guerra contro i Void", "Dopo un arresto per errore ritrova il suo vecchio amico [[character/1]] a [[station/98]] e combatte la sua prima battaglia contro i [[faction/9|Void]].", false],
		[18, "", "Brent lo recluta come pilota per l'organizzazione di ricerca Deep Science, che indaga sui Void.", false],
		[24, "", "Presso [[station/10]] conosce [[character/6]], la responsabile del progetto, e ne è presto attratto.", false],
		[26, "", "Lui e Carla vengono trascinati attraverso un wormhole Void nel settore d'origine dei Void e trovano la strada del ritorno.", false],
		[36, "", "Il comandante Vossk [[character/7]] è a conoscenza del passato servizio di Keith a Novaterra.", false],
		[43, "", "Keith scorta il mercantile che distrugge la nave madre Void e pone fine alle incursioni, anche se Errkt muore nell'attacco.", false],
		[45, "In seguito", "La sua ricompensa è una notte con Carla, che poi sparisce verso un altro progetto segreto lasciandogli un ultimo pagamento. Compiuto il suo lavoro, Keith è libero di girare la galassia.", false],
	],
	"character/1": [
		[16, "", "[[character/1]] è un vecchio amico di Keith dai tempi prima dell'incidente. Nei 35 anni persi da Keith, Brent è diventato capitano di corvetta e capo della Interstellar Security Agency. È cordiale, loquace e ama le lunghe storie personali.", false],
		[18, "La crisi dei Void", "Come capo della sicurezza presiede l'unità di crisi che coordina la risposta ai [[faction/9|Void]]. Recluta Keith per la Deep Science e si assicura che sia ben pagato. È per suo ordine che la nave di Keith viene riverniciata.", false],
		[19, "", "Quando lo scienziato [[character/5]] viene rapito, Brent sostiene il piano di salvataggio di Keith e fornisce le bombe EMP presso [[station/55]].", false],
		[32, "", "La sua squadra sviluppa il sistema di allerta precoce che mostra dove i Void apriranno il prossimo wormhole.", false],
		[35, "", "Insieme a [[character/6]] elabora il piano per distruggere la nave madre Void con un mercantile pieno di esplosivi, e organizza l'accordo con il comandante Vossk [[character/7]].", false],
		[43, "In seguito", "Dopo la distruzione della nave madre, Brent festeggia la vittoria con Keith a [[station/98]].", false],
	],
	"character/2": [
		[2, "", "[[character/2]] è un commerciante di minerali [[faction/2]] che gestisce una piccola stazione mineraria, [[station/78]], nel sistema [[system/15]]. Trova il relitto della nave di [[character/0]], ne salva il pilota e rivendica la nave come relitto recuperato. Burbero e pratico, fa saldare a Keith il suo debito estraendo minerale con la [[ship/0]], una vecchia nave che ha rimesso insieme lui stesso.", false],
		[8, "", "Quando Keith lo aiuta a distruggere un covo di pirati vicino alla sua stazione, Gunant comincia a rispettarlo.", false],
		[10, "", "Per gratitudine regala la [[ship/0]] a Keith con un motore migliore e lo manda dal suo amico [[character/3]]. Gunant stesso è membro della [[faction/3|Confederazione Mido]]. Progetta da sé i propri laser minerari e, come agente [[agent/11]], vende il progetto di uno di essi, il [[item/90]].", false],
	],
	"character/20": [
		[32, "", "[[character/20]] è uno scienziato dei [[faction/7|Grey]] che lavora per la Deep Science. Chiede di incontrare [[character/0]] presso [[station/10]].", false],
		[33, "", "Khador si esprime con una cortesia ricercata. Dopo aver studiato i relitti Void, ritiene che alcuni cristalli presenti solo nel settore Void custodiscano il segreto dei wormhole dei Void. Ha passato anni a sviluppare un motore capace di portare una nave all'istante in qualsiasi punto dello spazio, e chiede a Keith di raccogliere 50 [[item/164]] a questo scopo.", false],
		[34, "", "Quando Keith consegna i cristalli, Khador lo ricompensa con una copia del progetto del motore che porta il suo nome, il [[item/85]].", false],
	],
	"character/3": [
		[10, "", "[[character/3]] è un capitano umano che si è unito alla [[faction/3|Confederazione Mido]] e ora comanda [[station/79]]. [[character/2]] lo raccomanda a Keith come qualcuno che può aiutarlo a tornare nello spazio terrestre.", false],
		[11, "", "Norris accoglie Keith e gli spiega la storia del sistema [[system/15]]. Si offre di metterlo in contatto con la Space Fleet terrestre, se prima Keith indaga sul silenzio di [[station/76]].", false],
		[13, "", "Organizza un incontro tra Keith e un convoglio terrestre di passaggio nel sistema, e gli suggerisce di accettare incarichi freelance nell'attesa.", false],
	],
	"character/4": [
		[12, "", "[[character/4]] è un famigerato spacciatore che Keith conosceva da tempo. Keith lo trova presso [[station/76]], dove ha rifornito l'intero equipaggio di neuroalghe, una droga con sgradevoli effetti collaterali. Mkkt si ricorda di Keith e si chiede come mai non sia invecchiato.", false],
		[13, "", "Udito il rapporto di Keith, [[character/3]] promette di occuparsi di lui.", false],
	],
	"character/5": [
		[18, "", "Tommy è il tenente Thomas Boyle, uno scienziato che lavora per la Deep Science. [[character/1]] gli organizza un incontro con Keith presso [[station/56]], perché lo guidi alla stazione di ricerca segreta dell'organizzazione.", false],
		[19, "", "Prima dell'incontro Boyle viene rapito dai pirati vicino a [[station/55]], che chiedono un riscatto per lui.", false],
		[23, "", "Dopo che Keith ha messo fuori uso la nave dei rapitori, Boyle viene liberato. Dà a Keith le coordinate del sistema [[system/6]] e viaggia con lui fino a [[station/10]].", false],
	],
	"character/6": [
		[23, "", "La dottoressa Paolini è la scienziata della Deep Science che aspetta Keith e Boyle presso [[station/10]].", false],
		[24, "", "La dottoressa Carla Paolini dirige il progetto della Deep Science sui [[faction/9|Void]]. Determinata e instancabile, insiste per vedere i Void con i propri occhi, e così vola con [[character/0]] nella sua prima missione di recupero. Keith è attratto da lei fin dal primo incontro.", false],
		[26, "", "Lei e Keith vengono trascinati attraverso un wormhole nel settore d'origine dei Void e riescono a fuggire insieme per un soffio.", false],
		[28, "", "La sua squadra costruisce una sonda per analizzare la nave madre Void. Accetta un appuntamento con Keith se lui tornerà vivo dalla missione.", false],
		[34, "", "Troppo presa dalle sue ricerche per rispettare l'appuntamento, elabora con [[character/1]] un piano per colpire la nave madre.", false],
		[44, "In seguito", "Dopo la vittoria raggiunge Keith e Brent a [[station/98]] per l'appuntamento tanto rimandato.", false],
		[45, "", "Il mattino dopo se n'è andata, lasciando un biglietto: è partita per un altro progetto segreto e chiede a Keith di non cercarla.", false],
	],
	"character/7": [
		[35, "", "[[character/7]] è un comandante [[faction/1]] a capo di [[station/29]] nel sistema [[system/5]]. Fornisce il mercantile K'Sarr per l'attacco alla nave madre Void, in cambio di prigionieri.", false],
		[36, "", "Orgoglioso e formale, crede che solo un Vossk sappia pilotare a dovere una nave Vossk e insiste per pilotare lui stesso il mercantile. Mette alla prova l'abilità di Keith prima di accettarlo come scorta.", false],
		[37, "", "Dopo che Keith lo batte in una sfida presso un covo di pirati, Errkt lo tratta con rispetto.", false],
		[40, "", "Prima della missione è calmo e riservato, cosa che Brent interpreta come determinazione.", false],
		[42, "Morte", "Errkt pilota il mercantile attraverso il wormhole e contro la nave madre. Quando la sua capsula di salvataggio viene distrutta, si rifiuta di tornare indietro e muore nell'esplosione, dopo aver mandato Keith in salvo.", false],
		[43, "", "Brent promette di riferire il suo sacrificio all'Impero Vossk.", false],
	],
	"character/8": [
		[40, "", "Il tenente [[character/8]] guida la squadra di rinforzi che si unisce a Keith per proteggere il mercantile Vossk nel suo tragitto verso il wormhole.", false],
		[41, "", "La sua squadra non riesce ad attraversare il wormhole prima che si chiuda, quindi Keith e [[character/7]] affrontano i Void da soli.", false],
	],
	"chart": [
		[0, "", "La mappa della galassia elenca ogni sistema con la sua fazione, il livello di sicurezza, il numero di stazioni e la posizione sulla mappa. La posizione è data da due numeri da 0 a 100: il primo si conta dal bordo sinistro della mappa stellare, il secondo dall'alto. I sistemi con numeri simili sono vicini tra loro.", false],
		[0, "", "Nel gioco, apri la mappa stellare da una stazione o in volo. Una linea tratteggiata collega il tuo sistema attuale a ogni sistema raggiungibile dal suo portale di salto; le altre rotte dei portali appaiono come linee sottili. Le stelle che puoi raggiungere subito sono luminose, le altre sono attenuate. Dei segnalini indicano il sistema della tua missione della storia e quello dell'incarico in corso, e una linea colorata tratteggiata mostra la rotta più breve tra i portali per arrivarci. Una tenue linea dorata traccia i tuoi ultimi viaggi.", false],
		[0, "", "Seleziona un sistema per vederne la fazione, il livello di sicurezza e la distanza. Ingrandisci per vederne le stazioni, il loro livello tecnologico e i segnalini delle stazioni che hai visitato, degli obiettivi di missione e del portale di salto. I sistemi nascosti non compaiono finché non ne conosci le coordinate; vedi [[world/galaxy]].", false],
		[32, "", "Quando hai il sistema di allerta precoce della [[step/31]], la mappa stellare segnala anche il sistema e la stazione dove si aprirà il prossimo wormhole Void.", false],
	],
	"faction/0": [
		[0, "", "I Terrestri sono umani, e [[character/0]] è uno di loro. Controllano dieci sistemi, più di qualsiasi altra fazione, distribuiti al centro, sul lato destro e in basso sulla mappa, con [[system/19]] e [[system/14]] come nucleo. Lo spazio terrestre è la parte più sicura della galassia: i due sistemi classificati \"Safe\" (Sicuro) sono entrambi terrestri.", false],
		[0, "", "Le stazioni terrestri vendono la più ampia gamma di navi e di equipaggiamento. I rivenditori di navi fuori dallo spazio Vossk offrono un vasto assortimento di scafi. I rivali tradizionali dei Terrestri sono i [[faction/1]]: la reputazione guadagnata con gli uni si perde con gli altri.", false],
		[16, "", "La Space Fleet terrestre è ancora la forza in cui [[character/0]] ha servito un tempo, ma sono passati 35 anni. Quando finalmente incontra un convoglio terrestre, questo scambia la sua vecchia nave di fabbricazione pirata per un nemico e lo arresta.", false],
		[18, "", "I Terrestri guidano la difesa contro i Void. [[character/1]], ora capo della Interstellar Security Agency, presiede un'unità di crisi, e il gruppo di ricerca Deep Science studia il problema da una stazione segreta.", false],
	],
	"faction/1": [
		[0, "", "I Vossk sono un popolo alieno organizzato in un impero. Controllano sei sistemi in basso a destra sulla mappa, da [[system/3]] e [[system/12]] fino al remoto [[system/21]]. Quattro di essi sono classificati come \"Dangerous\" (Pericoloso) o \"Risky\" (Rischioso). [[system/10]] non ha alcun collegamento tramite portale.", false],
		[0, "", "I rivenditori di navi Vossk vendono un solo scafo, la [[ship/9]], un modello adattato alle altre razze. Le stazioni Vossk offrono anche armi ed equipaggiamento che non si trovano altrove. I Vossk sono i rivali tradizionali dei [[faction/0|Terrestri]], quindi le loro navi possono unirsi ai predoni nello spazio terrestre, e viceversa.", false],
		[18, "", "I rapporti tra i Terrestri e l'Impero Vossk restano freddi e imprevedibili, ma le incursioni dei Void colpiscono anche i sistemi Vossk.", false],
		[36, "", "Nella storia i Vossk appaiono orgogliosi e legati all'onore. Il loro comandante [[character/7]] insiste per pilotare personalmente la nave con l'esplosivo e mette alla prova [[character/0]] con una sfida prima di accettarlo come scorta.", false],
		[42, "", "[[character/7]] sacrifica la vita per distruggere la nave madre Void, e i Terrestri promettono di riferire la sua impresa all'Impero Vossk.", false],
	],
	"faction/2": [
		[0, "", "I Niveliani sono un popolo alieno che controlla quattro sistemi sul lato sinistro della mappa: [[system/2]], [[system/9]], [[system/17]] e il nascosto [[system/0]]. Le loro stazioni vanno da piccoli avamposti ad alcune delle più avanzate della galassia. I loro rivali sono i [[faction/3|Midoriani]].", false],
		[2, "", "La prima persona che [[character/0]] incontra è un niveliano, il commerciante di minerali [[character/2]]. [[character/0]] non ha una grande opinione delle maniere niveliane, mentre [[character/2]] insiste di essere un onesto uomo d'affari.", false],
		[11, "", "Una guerra civile niveliana ha dato origine alla [[faction/3|Confederazione Mido]]. I Niveliani non ne hanno mai accettato l'indipendenza e rivendicano ancora il sistema [[system/15]].", false],
		[35, "", "Il piano contro la nave madre Void si basa su esplosivi nucleari niveliani.", false],
	],
	"faction/3": [
		[0, "", "I Midoriani sono il popolo della [[faction/3|Confederazione Mido]]. Controllano due sistemi in alto a sinistra sulla mappa, [[system/15]] e [[system/4]], entrambi classificati come \"Dangerous\" (Pericoloso). Le loro stazioni sono per lo più piccole e poco avanzate. I loro rivali sono i [[faction/2|Niveliani]].", false],
		[11, "", "La Confederazione è stata fondata da profughi e fuorilegge terrestri e niveliani durante la guerra civile niveliana. Riduce al minimo i contatti con gli altri sistemi. [[character/3]], comandante di [[station/79]], è uno dei suoi membri, e lo è anche [[character/2]].", false],
		[38, "", "La Confederazione non è amica dei Niveliani. Le sue navi si impadroniscono del convoglio che trasporta gli esplosivi niveliani destinati alla nave madre Void, e [[character/0]] deve riprenderlo vicino a [[station/22]].", false],
	],
	"faction/4": [
		[0, "", "I Multipod sono una razza minore senza sistemi propri. L'unico Multipod che incontri è l'agente [[agent/6]], che vende un progetto nella lounge di [[station/61]] in [[system/12]].", false],
	],
	"faction/5": [
		[0, "", "I Cyborg non possiedono territori. L'unico Cyborg del gioco è l'agente [[agent/14]] nella lounge di [[station/65]], che commercia le coordinate di un sistema nascosto.", false],
	],
	"faction/6": [
		[0, "", "I Boboliani sono una razza minore senza sistemi propri. L'agente [[agent/13]], un boboliano, si trova nella lounge di [[station/26]] nello spazio Vossk e vende le coordinate di un sistema nascosto.", false],
	],
	"faction/7": [
		[0, "", "I Grey sono una razza senza sistemi, stazioni o navi propri. Non hanno alcun ruolo nel commercio o nei combattimenti.", false],
		[32, "", "L'unico Grey della storia è [[character/20]], uno scienziato che lavora con la Deep Science; vedi [[world/khador]].", false],
		[33, "", "Studia i resti delle navi Void e ne ricava un nuovo tipo di motore.", false],
	],
	"faction/8": [
		[0, "", "I pirati sono fuorilegge di ogni razza. Non controllano sistemi, ma compaiono ovunque e sono sempre ostili. La frequenza con cui tendono agguati vicino a una stazione dipende dal livello di sicurezza del sistema. Molti incarichi freelance ti chiedono di dar loro la caccia, e i loro relitti possono essere saccheggiati per recuperarne il carico.", false],
		[0, "", "La storia comincia con [[character/0]] che insegue una banda di pirati per la taglia sulle loro teste.", false],
		[2, "", "La [[ship/0]], la nave che [[character/2]] presta a [[character/0]], era un tempo una nave pirata.", false],
		[16, "", "Per questo in seguito i Terrestri lo scambiano per un pirata.", false],
		[19, "", "Sono i pirati anche a rapire [[character/5]] vicino a [[station/55]] e a chiedere un riscatto.", false],
	],
	"faction/9": [
		[0, "", "I Void sono una forza ostile che attacca senza preavviso. Non controllano sistemi sulla mappa, e le loro navi aprono il fuoco su chiunque. Il loro caccia, la [[ship/8]], è lo scafo più corazzato del gioco. Vedi [[world/voids]].", false],
		[2, "", "In [[system/15]] i Void sono noti solo per sentito dire e per rari avvistamenti.", false],
		[16, "", "Una squadriglia Void attacca [[station/98]] mentre [[character/0]] si trova lì. I loro messaggi radio dichiarano intenzioni pacifiche mentre sparano.", false],
		[18, "", "I Void arrivano attraverso wormhole che si aprono vicino alle stazioni per breve tempo. Razziano allo stesso modo i sistemi terrestri, niveliani e Vossk e sembrano interessati al minerale. Nessuno sa da dove vengano.", false],
		[24, "", "Presso [[station/48]] trasmettono un'affermazione ancora più strana: di venire dal futuro e di essere tutto ciò che resta delle civiltà della galassia.", false],
		[26, "", "Un wormhole conduce al loro settore, dove un'enorme nave madre lancia i loro caccia.", false],
		[35, "", "La nave madre sembra essere l'origine dei wormhole.", false],
		[42, "", "La distruzione della nave madre ([[step/41]]) fa collassare i wormhole e pone fine alle incursioni, almeno per il momento.", false],
	],
	"guide/basics": [
		[0, "L'inizio", "Una nuova partita comincia nello spazio e non in una stazione. [[character/0]] sta inseguendo una banda di pirati attraverso un campo di asteroidi, e il primo volo è un breve combattimento che insegna a pilotare, mirare e sparare. Finché dura, sullo schermo compaiono solo il mirino e i segnalini delle navi. Distruggi i pirati e lascia che la scena si svolga; poi la storia prosegue da sola.", false],
		[2, "", "Dopo l'inizio ti risvegli presso [[station/78]], una piccola stazione mineraria gestita da [[character/2]]. Lui ti presta la [[ship/0]], una nave disarmata con un laser minerario, e le prime fasi insegnano l'estrazione mineraria, l'autopilota e l'attracco. Le armi, la mappa e il resto della stazione si sbloccano man mano che la storia procede.", false],
		[0, "Attracco", "Per attraccare, tieni il mirino su una stazione finché non si aggancia, poi premi Fuoco: l'autopilota prende il comando e ti porta dentro. Puoi anche entrare nella stazione da solo; la nave attracca nel momento in cui tocca lo scafo. L'attracco è il momento in cui avviene la maggior parte della contabilità. Scafo, corazza e scudi vengono ripristinati gratuitamente, le consegne e i passeggeri vengono affidati a destinazione, i prodotti finiti dei progetti vengono ritirati, vengono assegnate le nuove medaglie e il gioco salva automaticamente.", false],
		[0, "Le schermate della stazione", "Una stazione in cui sei attraccato offre sei sezioni: \"Hangar\", Space Lounge, \"Map\" (Mappa), \"Missions\" (Missioni), \"Status\" (Stato) e \"Game Options\" (Opzioni di gioco). All'inizio della storia alcune sono bloccate e mostrate con un lucchetto. \"Hangar\" si apre alla [[step/5]], \"Map\" alla [[step/9]], la Space Lounge e \"Missions\" alla [[step/13]]. \"Status\" e \"Game Options\" sono sempre disponibili.", false],
		[0, "", "\"Hangar\" contiene \"Shop\" (Negozio: compra e vendi merci ed equipaggiamento), \"Ship\" (Nave: monta e smonta l'equipaggiamento), \"Ships\" (Navi: il rivenditore di scafi, nelle stazioni che ne hanno uno) e \"Blueprints\" (Progetti: la produzione). Nella Space Lounge aspettano clienti, commercianti e piloti a noleggio. \"Map\" mostra la galassia e ti permette di scegliere una destinazione. \"Missions\" elenca l'obiettivo attuale della storia e l'eventuale incarico freelance che hai accettato. \"Status\" mostra il tuo stato di servizio da pilota, la tua reputazione presso le quattro grandi razze e le tue medaglie. La barra superiore mostra il \"Tec Level\" (livello tecnologico) della stazione, che determina che cosa può tenere in vendita il suo negozio.", false],
		[0, "Lasciare una stazione", "Premi \"Depart\" (Partenza) per decollare. Ogni volo comincia con qualche secondo in cui guardi la nave uscire, con i dati del sistema e un suggerimento; un tasto qualsiasi, un clic o un tocco lo saltano. Se hai scelto una destinazione in \"Map\" prima di partire, l'autopilota fa rotta verso di essa appena terminato il decollo. Non puoi partire con più carico di quanto la stiva possa contenere, quindi prima vendi o monta ciò che è in eccesso.", false],
		[0, "Salvataggio", "Il gioco salva automaticamente dopo ogni attracco completato, una volta sistemate le ricompense e la fase successiva della storia. Puoi anche salvare manualmente in uno dei tre slot da \"Game Options\" mentre sei attraccato, e caricare qualsiasi slot o il salvataggio automatico da lì o dalla schermata del titolo. Fuori dalla versione per browser, \"Game Options\" permette anche di esportare un salvataggio in un file e di importarlo di nuovo. I salvataggi appartengono ai dati di gioco con cui sono stati creati.", false],
		[0, "", "Se la tua nave viene distrutta, il volo termina e riprendi dalla stazione del tuo ultimo salvataggio automatico, o ricominci da capo se non ce n'è uno. Tutto ciò che hai guadagnato dopo quell'attracco va perduto, quindi attracca di tanto in tanto durante i viaggi lunghi.", false],
		[0, "Livello del pilota", "Il tuo pilota ha un livello, mostrato nella schermata \"Status\". L'esperienza deriva dalle uccisioni, dagli incarichi freelance (ciascuno vale due punti), dai nuclei estratti, da ogni cinquanta tonnellate di minerale estratto e da ogni due gregari ingaggiati. Il livello sale di uno ogni volta che l'esperienza supera di 1,3 volte il valore che aveva all'ultimo aumento, e viene verificato quando attracchi. Un livello più alto rende i nemici più forti, ma aumenta anche le ricompense degli incarichi freelance e i compensi dei piloti a noleggio.", false],
	],
	"guide/blueprints": [
		[0, "Progetti", "Alcune delle armi e degli equipaggiamenti migliori non sono mai in vendita nei negozi. Si costruiscono invece a partire dai progetti. Un progetto elenca le merci necessarie e in quali quantità. I progetti si comprano dagli agenti con un nome nella Space Lounge, che compaiono quando la storia ha superato la [[step/16]]; ogni agente vende un solo progetto, una sola volta.", false],
		[34, "", "Il progetto del motore di salto [[item/85]] non è venduto da nessuno: lo consegna la storia, nella [[step/34]].", false],
		[0, "Produzione", "La produzione si svolge nella scheda \"Blueprints\" (Progetti) di \"Hangar\". Scegli un progetto e fornisci gli ingredienti dalla tua stiva. Puoi consegnarli a più riprese, in diverse visite. La stazione in cui fai la prima consegna diventa la stazione di produzione per quel lotto. Gli ingredienti consegnati in qualsiasi altra stazione vengono spediti lì per 10 crediti a tonnellata, quindi conviene portare tutto nello stesso posto.", false],
		[0, "Prodotti finiti", "Quando arriva l'ultimo ingrediente, il lotto è finito. Le armi secondarie vengono prodotte dieci alla volta; tutto il resto una alla volta. Se completi il lotto presso la stazione di produzione, i prodotti finiscono direttamente nella stiva, anche se questo la riempie oltre il limite. Altrimenti attendono presso la stazione di produzione e ti vengono consegnati al prossimo attracco lì. Un progetto non si esaurisce mai: completato un lotto, puoi cominciare il successivo.", false],
		[0, "Medaglie", "Possedere progetti conta per [[medal/13]], e completare progetti diversi conta per [[medal/14]].", false],
	],
	"guide/combat": [
		[0, "Armi primarie", "Le armi primarie sono cannoni fissi che sparano in avanti: laser, blaster, cannoni automatici e armi termiche. Ognuna ha danno, cadenza di fuoco, gittata e velocità del proiettile propri, e tutte le armi primarie montate sparano insieme. Alcuni blaster, come il [[item/16]], sono armi EMP che prosciugano l'energia di una nave invece del suo scafo. Il Fuoco automatico continua a sparare sul bersaglio senza dover tenere premuto il pulsante.", false],
		[0, "Scudi, corazza e scafo", "Il danno prosciuga prima lo scudo, poi la piastra di corazza e solo dopo lo scafo stesso. Uno scudo si ricarica completamente nel suo tempo di ricarica; corazza e scafo no. Un robot di riparazione ripara lentamente sia lo scafo sia la corazza durante il volo. L'attracco ripristina tutto gratuitamente. Quando lo scafo è esaurito, la nave viene distrutta.", false],
		[0, "EMP", "Ogni nave ha una riserva di energia. Le armi EMP la prosciugano, e una nave che resta senza energia viene messa fuori uso: va alla deriva, inerme, finché l'energia non si è ricostituita. A una nave fuori uso si può sottrarre il carico con un raggio traente, e alcuni incarichi richiedono di mettere fuori uso una nave invece di distruggerla. L'equipaggiamento di protezione EMP, come il [[item/60]], ha un valore di difesa EMP.", false],
		[0, "Armi secondarie", "Le armi secondarie sparano dagli slot secondari e consumano munizioni, che si accumulano nello slot. I razzi volano dritti. I siluri, poco dopo il lancio, virano seguendo l'aggancio radar. Bombe EMP e armi nucleari esplodono su un'area e colpiscono tutto ciò che si trova nel raggio dell'esplosione, con meno forza verso il bordo; le bombe EMP lasciano intatti gli asteroidi, mentre le armi nucleari li spezzano. Scegli quale lanciatore usare dal menu Azioni; finché non lo fai, il tasto Arma secondaria spara con il primo carico.", false],
		[0, "Torrette", "Gli scafi più grandi hanno slot per torrette. Con una torretta montata, il tasto Vista posteriore passa alla vista torretta: la nave mantiene la rotta mentre ruoti la torretta e spari, così puoi rispondere al fuoco delle navi che ti stanno alle calcagna.", false],
		[0, "Gregari", "Dalla [[step/16]] in poi, nella Space Lounge si possono incontrare piloti a noleggio. Un contratto copre da una a tre navi per dieci minuti di volo, e queste ti seguono ovunque tu vada finché non scade. Dai loro ordini dal menu Azioni: fuoco a volontà, attaccare il tuo bersaglio, mettere in sicurezza il prossimo punto di missione, o passare dal laser al blaster EMP e viceversa. Vedi [[guide/lounge]].", false],
		[0, "Pirati", "I pirati assaltano le stazioni, più spesso nei sistemi pericolosi, e tendono agguati ai piloti che trasportano merci o passeggeri. Molti incarichi freelance consistono nel combatterli. Sparare ai pirati non fa arrabbiare nessuno; migliora leggermente la tua reputazione presso la razza che governa il sistema.", false],
		[0, "Reputazione", "La tua reputazione è registrata su due scale, ciascuna da -100 a 100: una tra le razze [[faction/0]] e [[faction/1]], l'altra tra le razze [[faction/2]] e [[faction/3]]. Fare un torto a una razza sposta la scala verso la sua rivale: mettere fuori uso o derubare una delle sue navi costa 2 punti, un'uccisione ne costa 5. Completare un incarico freelance sposta la scala di 2 punti verso la razza del cliente. Quando una scala supera 60 in una delle due direzioni, la razza dalla parte perdente diventa ostile e le sue navi ti attaccano a vista.", false],
		[0, "", "Una razza ostile manda un diplomatico nelle Space Lounge, che si offre di riportare la scala a zero in cambio di un compenso che cresce con lo spostamento: al massimo 16.000 crediti. La schermata \"Status\" (Stato) mostra entrambe le scale. Portare una scala oltre 60 fa anche guadagnare [[medal/28]].", false],
		[0, "Fuoco amico", "Le navi della razza a cui appartiene il sistema tollerano i colpi vaganti solo fino a un certo punto. Quando hai tolto a una nave locale un terzo del suo scafo o della sua energia, risponde al fuoco e ti avverte via radio. Ai due terzi del suo scafo, o quando la metti fuori uso, tutte le navi di quella razza nel sistema ti si rivoltano contro. Le navi delle altre razze sono meno suscettibili, ma un'uccisione costa sempre reputazione.", false],
	],
	"guide/fitting": [
		[0, "Scafi", "Lo scafo di una nave ne determina la corazza (la resistenza propria dello scafo), la stiva, la manovrabilità e gli slot: armi primarie, armi secondarie, torrette ed equipaggiamento. Uno scafo migliore significa soprattutto più slot. Le pagine delle navi mettono a confronto tutti gli scafi.", false],
		[0, "Gli slot e la schermata \"Ship\"", "Gli oggetti acquistati finiscono nella stiva e poi si montano nella schermata \"Ship\" (Nave) di \"Hangar\". Ogni slot accoglie un oggetto della propria categoria; montare un oggetto in uno slot occupato rimette nella stiva quello vecchio. Ogni tipo di equipaggiamento si può montare una sola volta, tranne i tipi cumulabili, come le unità di compressione del carico, le cabine e la protezione EMP, di cui se ne possono montare diversi, ognuno nel proprio slot. Le munizioni secondarie dello stesso tipo condividono un unico slot. Un oggetto montato si può anche vendere direttamente dal suo slot al prezzo della stazione.", false],
		[0, "Tipi di equipaggiamento", "Gli scudi assorbono i danni e si ricaricano. Le piastre di corazza aumentano la resistenza dello scafo. La protezione EMP difende dal prosciugamento dell'energia. La compressione del carico amplia la stiva. I raggi traenti attirano il carico dai relitti e dalle navi fuori uso; senza uno di essi, nello spazio non si può raccogliere nulla. I booster danno scatti di velocità. I robot di riparazione riparano la nave in volo. Gli ugelli di manovra migliorano la manovrabilità. Gli scanner riducono il tempo per agganciare un bersaglio, e i migliori mostrano il carico del bersaglio. I laser minerari trivellano gli asteroidi. Le cabine trasportano passeggeri. I dispositivi di occultamento nascondono la nave per un certo tempo. Un motore di salto permette di viaggiare senza portali.", false],
		[0, "Comprare uno scafo", "Le stazioni con un rivenditore mostrano in \"Hangar\" una scheda \"Ships\" (Navi) con fino a cinque scafi in vendita. I rivenditori [[faction/1]] offrono solo lo scafo della propria razza, la [[ship/9]]. Un rivenditore sconta dal prezzo di listino una percentuale pari al \"Tec Level\" (livello tecnologico) della sua stazione, quindi le stazioni ad alta tecnologia vendono gli scafi a prezzi più bassi. Il tuo vecchio scafo viene ritirato in permuta per quattro quinti del suo prezzo di listino. Tutto ciò che era montato viene spostato nella stiva, quindi controlla che ci stia o vendine una parte prima di partire. Non puoi cambiare scafo mentre hai passeggeri a bordo, e le cabine non si possono smontare finché sono occupate.", false],
		[5, "Le prime armi", "Quando l'hangar di [[station/78]] si apre per la prima volta, il suo scaffale contiene gratuitamente un laser, un cannone automatico e una piastra di corazza. Monta un'arma e la piastra prima di partire per la missione successiva.", false],
		[0, "Scafi rari", "Alcuni scafi non vengono mai offerti dai rivenditori ordinari. A un pilota che ha vinto tutte le medaglie d'oro viene offerto un prototipo, la [[ship/8]], presso [[station/10]]; vedi [[guide/medals]].", false],
	],
	"guide/flight": [
		[0, "Pilotaggio", "La nave vola sempre in avanti. La fai virare a sinistra e a destra e alzi o abbassi il muso; quando lasci i comandi, rimette le ali in piano da sola. La rapidità di virata dipende dalla manovrabilità dello scafo e dall'eventuale ugello di manovra montato. In \"Options\" (Opzioni), Controlli, la Risposta del timone può essere Diretta, che vira subito alla massima velocità, oppure Morbida, che entra ed esce dalle virate gradualmente. Con il pilotaggio col mouse, i tasti sinistra e destra possono far scivolare la nave lateralmente invece di farla virare.", false],
		[0, "Manetta", "Spinta su e Spinta giù cambiano la manetta a scatti di un quarto, e tenendo premuto il tasto si continua a cambiare. La nave impiega circa un secondo a stabilizzarsi alla nuova velocità. L'autopilota e il booster volano sempre a manetta piena, e ridurre la manetta durante un boost lo interrompe.", false],
		[0, "Booster", "Con un booster montato, il tasto Booster dà uno scatto di velocità extra. Uno scatto dura quanto previsto dal booster ed è seguito da un tempo di ricarica prima del successivo; l'HUD mostra se è pronto. I booster migliori sono più veloci, durano di più o si ricaricano prima. Il boost è utile per sfuggire a un combattimento e per coprire le lunghe distanze all'interno di un sistema.", false],
		[0, "Autopilota", "Il tasto Autopilota affida il timone al computer di bordo, e premendolo di nuovo lo riprendi. Vola verso ciò che è agganciato, oppure verso la destinazione scelta in \"Map\" (Mappa): il portale di salto se la destinazione si trova in un altro sistema, o il pianeta della destinazione se è in questo. L'elenco dell'Autopilota offre le scelte disponibili dove ti trovi: la destinazione programmata, il portale di salto, questa stazione, il campo di asteroidi e il prossimo punto di missione. Volare verso una stazione agganciata termina con l'attracco.", false],
		[0, "Velocità del tempo", "Il tasto Velocità del tempo fa scorrere il volo più rapidamente. La velocità doppia è sempre disponibile in volo. Le velocità quadrupla e ottupla sono offerte solo mentre vola l'autopilota, nessun nemico è vicino e non è in corso nient'altro, come un'estrazione, un attracco o un salto.", false],
		[0, "Puntamento", "Per agganciare un oggetto, tienilo sotto il mirino finché la scansione non è completa. Il tempo necessario dipende dallo scanner montato: da diversi secondi con un modello base a meno di due con il migliore. Bersaglio successivo passa in rassegna gli oggetti vicini senza doverli mirare. Stazioni, portali di salto e le stelle che indicano gli altri pianeti si agganciano con una sola pressione. L'effetto di Fuoco dipende dall'aggancio: su una nave spara, su una stazione attracca, su un portale salta, su una stella viaggia verso quel pianeta e su un asteroide avvia l'estrazione. Gli scanner migliori mostrano anche il carico di una nave agganciata.", false],
		[0, "Segnalini e radar", "Le navi hanno delle parentesi sullo schermo, e delle frecce sul bordo dello schermo indicano il bersaglio, la stazione e le minacce vicine fuori dal campo visivo. I nemici sono segnati in rosso, gli amici in verde, le navi neutrali in giallo e i punti di missione in blu; l'opzione per daltonici in \"Options\", Interfaccia sostituisce questi colori con l'arancione per i nemici e il blu per gli amici. Una nave vicina mostra due piccole barre accanto alla sua parentesi: il suo scafo e, in blu, la sua energia EMP. Il Display di volo Esteso aggiunge riquadri con i valori esatti e un radar circolare; quello Originale mantiene i pannelli d'angolo del gioco.", false],
		[0, "Guardarsi intorno", "Vista posteriore gira la telecamera per guardare dietro la nave. Se è montata una torretta, lo stesso tasto passa invece alla vista torretta: la nave mantiene la rotta mentre tu ruoti la torretta e spari. Puoi anche guardarti intorno senza pilotare tenendo premuto Alt e muovendo il mouse, con lo stick destro del gamepad o trascinando un dito su una zona libera dello schermo.", false],
		[0, "Occultamento", "Un dispositivo di occultamento nasconde la tua nave alle altre navi per la sua durata, e chiunque ti stia dando la caccia perde subito le tue tracce. Premi di nuovo il tasto Dispositivo di occultamento per spegnerlo prima. Dopo l'uso ha bisogno di tempo per ricaricarsi prima di funzionare di nuovo.", false],
		[0, "Attracco e viaggi", "Aggancia la stazione e premi Fuoco, o semplicemente entraci in volo, per attraccare. Le altre stazioni del sistema appaiono come stelle luminose; agganciane una e premi Fuoco per viaggiare verso quel pianeta. La maggior parte dei sistemi ha un portale di salto, vicino a una delle sue stazioni, per viaggiare verso altri sistemi; vedi [[guide/navigation]]. Mentre presso una stazione è in corso un combattimento di un incarico freelance, non puoi attraccare, viaggiare o saltare via finché non è vinto o perso.", false],
	],
	"guide/help": [
		[0, "Tastiera", "Questi sono i tasti predefiniti. Tutte le azioni di volo si possono riassegnare in \"Options\" (Opzioni), Controlli, Tastiera, dove Ripristina tasti predefiniti annulla le modifiche.", false],
		[0, "", "Vira a sinistra / Vira a destra: frecce sinistra e destra, oppure A e D.", true],
		[0, "", "Cabra / Picchia: frecce su e giù.", true],
		[0, "", "Spinta su / Spinta giù: W e S.", true],
		[0, "", "Fuoco / usa: Spazio o Ctrl. Spara con le armi, oppure attracca, salta, viaggia o estrae quando è agganciata una stazione, un portale, una stella o un asteroide.", true],
		[0, "", "Arma secondaria: E.", true],
		[0, "", "Booster: Maiusc.", true],
		[0, "", "Autopilota: Q. Elenco autopilota: R. Con Tieni premuto l'autopilota per l'elenco attivo, tenere premuto Q per mezzo secondo apre l'elenco.", true],
		[0, "", "Bersaglio successivo: Tab.", true],
		[0, "", "Fuoco automatico: F.", true],
		[0, "", "Vista posteriore: C. Con una torretta montata passa alla vista torretta.", true],
		[0, "", "Azioni / motore di salto: M. Apre il menu Azioni: scelta dell'arma secondaria, occultamento, ordini ai gregari e motore di salto.", true],
		[0, "", "Mappa rotte: N.", true],
		[0, "", "Dispositivo di occultamento: V.", true],
		[0, "", "Velocità del tempo: T.", true],
		[0, "", "Modalità foto: P. Blocca il volo e nasconde l'interfaccia; trascina o usa i tasti freccia per ruotare la telecamera e la rotella o + e - per lo zoom.", true],
		[0, "", "Menu di pausa: Esc. F11 attiva lo schermo intero sui sistemi desktop.", true],
		[0, "", "Nei menu, i tasti freccia si spostano tra le voci, Invio seleziona ed Esc torna indietro.", true],
		[0, "Mouse", "Con Pilotaggio col mouse attivo, muovere il mouse pilota la nave. Durante il volo il puntatore viene catturato, così la nave vira mentre lo muovi; Cattura il puntatore in volo si può disattivare, e menu e pause liberano sempre il puntatore. Il tasto sinistro spara, il tasto destro lancia l'arma secondaria, e tenere premuto Alt mentre muovi il mouse ti permette di guardarti intorno. Mentre il mouse pilota, i tasti sinistra e destra fanno scivolare la nave lateralmente; Tasti sinistra / destra in \"Options\", Controlli può impostarli su Sempre laterale o Sempre virata. Sensibilità del mouse stabilisce quanto vira la nave per un dato movimento.", false],
		[0, "Gamepad", "Lo stick sinistro pilota e lo stick destro ti permette di guardarti intorno. RT o RB spara, LB lancia l'arma secondaria, A attiva il booster, Y attiva o disattiva l'autopilota, X seleziona il bersaglio successivo, premere lo stick destro dà la vista posteriore o la vista torretta, Back apre il menu Azioni e Start mette in pausa. Nei menu la croce direzionale si sposta, A seleziona e B torna indietro. \"Options\", Controlli, Gamepad imposta la zona morta dello stick e la vibrazione.", false],
		[0, "Touch", "Sugli schermi touch i controlli compaiono sullo schermo quando Controlli touch è impostato su Automatico o On. Uno stick su un lato pilota; per impostazione predefinita si sposta sotto il pollice ovunque tu lo appoggi su quel lato, e Stick fisso lo tiene fermo. Pilota da ovunque permette di pilotare con un dito appoggiato su qualsiasi zona libera dello schermo. I pulsanti sull'altro lato comprendono Fuoco / usa, Secondaria, Boost, Autopilota, Bersaglio, Vista posteriore, Azioni, Pausa e, durante i messaggi radio, Radio successiva. Un cursore regola la manetta, e un pulsante Più veloce accelera il tempo.", false],
		[0, "", "Tocca Fuoco due volte rapidamente per attivare il fuoco automatico; un solo tocco lo ferma. Trascinare un dito su una zona libera dello schermo ti permette di guardarti intorno, e quando lo sollevi la visuale torna in avanti. Layout per mancini scambia i lati, Dimensione controlli touch ridimensiona i controlli e Regola posizione controlli ti permette di spostarli uno per uno. Telefoni e tablet possono anche pilotare inclinando il dispositivo: attiva Pilota inclinando, tieni il dispositivo come quando giochi e calibra.", false],
		[0, "Opzioni", "A \"Options\" si accede dalla schermata del titolo, dal menu di pausa e da \"Game Options\" (Opzioni di gioco) in una stazione. Ha cinque pagine. Audio regola il volume di musica ed effetti sonori. Schermo riguarda la finestra, la frequenza dei fotogrammi, le proporzioni e le preimpostazioni e i dettagli grafici. Controlli riguarda pilotaggio, mouse, gamepad, touch e assegnazione dei tasti. Interfaccia riguarda la dimensione dell'interfaccia, il Display di volo Originale o Esteso, dimensione e opacità dell'HUD, le finestre di aiuto, le sequenze di decollo e di ingresso nella stazione, il radar circolare, le etichette, la dimensione del testo e le impostazioni di accessibilità come i colori per daltonici, la riduzione dei lampi, la scossa dello schermo e la durata dei messaggi. Gioco imposta la lingua del motore e permette di importare un file di gioco diverso o di gestire le mod.", false],
		[0, "Aiuto", "\"Help\" (Aiuto), raggiungibile dagli stessi punti, mostra gli argomenti di aiuto e i suggerimenti di caricamento del gioco, un elenco delle assegnazioni dei tasti attuali e una tabella che traduce i tasti del telefono citati nei testi del gioco nei tasti, pulsanti e controlli touch usati qui.", false],
	],
	"guide/jobs": [
		[0, "Trovare lavoro", "Gli incarichi freelance vengono offerti dagli ospiti della Space Lounge. Un cliente descrive il lavoro e il compenso. Prima di accettare un incarico altrove puoi chiedere dove si trova e quanto sarà difficile; puoi anche chiedere di risentire l'offerta o rifiutarla. Puoi avere un solo incarico alla volta, e la schermata \"Missions\" (Missioni) lo mostra con la sua destinazione e il numero di salti tra portali che la separano.", false],
		[0, "Tipi di incarico", "Esistono tredici tipi. Fino alla [[step/16]], e nelle copie del gioco prive della campagna completa, ne vengono offerti solo cinque: [[job/11]], [[job/0]], [[job/7]], [[job/4]] e [[job/12]]. In seguito compare la gamma completa: [[job/1]], [[job/2]], [[job/3]], [[job/5]], [[job/6]], [[job/9]] e [[job/10]], oltre agli acquirenti che vogliono merci ([[job/8]]).", false],
		[0, "Difficoltà e ricompensa", "I primi incarichi hanno una difficoltà di uno o due; quelli successivi arrivano fino a nove. La ricompensa base di un incarico è di 1.500 crediti più fino a 5.500 in aggiunta a seconda della difficoltà. Viene poi aumentata in base alla distanza dalla destinazione (raddoppiata a 1.200 km), e si aggiungono 200 crediti per ogni livello del pilota. La rimozione di rottami paga il 30 per cento in meno, le scorte il 20 per cento in più, i recuperi pagano il doppio, e gli incarichi di trasporto passeggeri pagano una base più bassa più una quota per ogni passeggero. Le ricompense sono arrotondate a multipli di cinquanta crediti.", false],
		[0, "Svolgere un incarico", "Gli incarichi di corriere e di trasporto passeggeri si completano attraccando alla destinazione con le merci o i passeggeri a bordo. Gli incarichi di acquisto si completano attraccando di nuovo alla stazione dell'acquirente con le merci nella stiva. Tutti gli altri incarichi sono combattimenti presso la stazione di destinazione, che iniziano quando ci arrivi; mentre uno è in corso non puoi attraccare, viaggiare o saltare via. I container recuperati e gli ostaggi vanno poi riportati alla stazione in cui hai accettato l'incarico. Quando un incarico è completato, la ricompensa viene pagata subito, la tua reputazione presso la razza del cliente migliora e l'incarico conta per [[medal/16]].", false],
		[0, "Fallimento", "Un combattimento fallisce se la sua condizione viene meno: le navi che proteggi vengono tutte distrutte, il container va perduto, il tempo scade o il rivale abbatte più navi di te. Un incarico fallito viene annullato senza compenso. Puoi anche abbandonare un incarico dalla schermata \"Missions\"; le eventuali merci vengono ritirate. Se la tua nave viene distrutta, riprendi dall'ultimo salvataggio automatico.", false],
	],
	"guide/lounge": [
		[0, "Ospiti", "Ogni stazione ha una Space Lounge, aperta dalla [[step/13]]. Vi siedono da tre a cinque ospiti, che cambiano ogni volta che attracchi. La maggior parte appartiene alla razza dominante del sistema, ma alcuni vengono da qualsiasi luogo. Parla con un ospite per sapere che cosa vuole; ogni risposta e ogni decisione conta per una delle medaglie legate alle conversazioni.", false],
		[0, "Risposte", "\"OK\" accetta un'offerta, \"No, thanks\" (No, grazie) la rifiuta e \"How was that again?\" (Come hai detto?) la fa ripetere. Per un incarico altrove puoi chiedere \"Can you show it on the map?\" (Puoi mostrarlo sulla mappa?) per conoscere la destinazione e \"Will it be difficult?\" (Sarà difficile?) per sapere quanto è impegnativo. I commercianti ti lasciano prima dare un'occhiata alla merce. Rifiutare offerte, chiedere di ripetere e accettare senza fare domande contano per [[medal/32]], [[medal/33]], [[medal/34]] e [[medal/35]]; parlare con gli ospiti che hanno un'offerta conta per [[medal/26]].", false],
		[0, "Clienti e chiacchieroni", "Molti ospiti offrono incarichi freelance; vedi [[guide/jobs]]. Altri si limitano a chiacchierare e a riferire voci, che a volte menzionano stazioni o minerali che vale la pena conoscere.", false],
		[0, "Commercianti e acquirenti", "I commercianti vendono un singolo lotto: un pezzo di equipaggiamento o qualche unità di una merce, a un prezzo che va dal 40 al 160 per cento di quello abituale. Dalla [[step/16]] in poi compaiono anche gli acquirenti, che chiedono di portare una certa quantità di un oggetto in quella stessa stazione; vedi [[job/8]].", false],
		[0, "Piloti a noleggio", "Dalla [[step/16]] in poi, in ogni lounge un ospite può offrire dei gregari: da uno a tre piloti per un compenso da 700 a 1.999 crediti a pilota, per dieci minuti di volo. I piloti [[faction/1]] non sono mai a noleggio. Puoi avere un solo gruppo alla volta. Un pilota che possiede tutte le medaglie trova invece degli ammiratori, che pagano per volare con lui.", false],
		[0, "Agenti", "Quando la storia ha superato la [[step/16]], degli agenti con un nome attendono in determinate stazioni e concludono un solo affare ciascuno. La maggior parte vende un progetto; quattro vendono le coordinate di un sistema nascosto, che poi compare sulla mappa. Ogni agente se ne va dopo l'affare. Gli agenti sono elencati nelle loro pagine.", false],
		[0, "Diplomatici", "Quando una delle quattro grandi razze è diventata ostile, in ogni lounge siede uno dei suoi diplomatici. In cambio di un compenso che cresce con quanto è scesa la tua reputazione, fino a 16.000 crediti, il diplomatico riporta a zero quella scala di reputazione.", false],
	],
	"guide/medals": [
		[0, "Gradi", "La maggior parte delle medaglie ha tre gradi: bronzo, argento e oro. Ogni grado ha il proprio obiettivo, e raggiungere quello superiore sostituisce la medaglia inferiore. Alcune medaglie hanno un solo grado. Le pagine delle medaglie mostrano l'obiettivo di ogni grado.", false],
		[0, "Quando vengono assegnate le medaglie", "Il tuo stato di servizio viene verificato quando ti avvicini a una stazione, prima che l'attracco ripari la nave, e le medaglie nuove o migliorate vengono annunciate una volta attraccato. In volo non viene assegnato nulla, quindi un obiettivo raggiunto nello spazio conta solo al prossimo attracco. La schermata \"Status\" (Stato) elenca tutte le medaglie che possiedi, il loro grado e il motivo per cui sono state assegnate.", false],
		[0, "La prima e l'ultima", "[[medal/0]] si possiede fin dall'inizio della partita. [[medal/36]] viene assegnata automaticamente quando si possiedono tutte le altre medaglie.", false],
		[0, "Ricompense", "Possedere tutte le medaglie cambia il modo in cui ti trattano i piloti della Space Lounge: degli ammiratori ti pagano per volare con te come gregari invece di chiederti un compenso. Possedere tutte le medaglie d'oro ti fa ricevere l'offerta della [[ship/8]], un prototipo venduto presso [[station/10]]. Nella schermata \"Status\", [[character/0]] indossa occhiali scuri quando possiede tutte le medaglie, e occhiali dorati quando sono tutte d'oro.", false],
	],
	"guide/mining": [
		[0, "Asteroidi", "Lo spazio di ogni stazione contiene asteroidi in due campi: uno vicino alla stazione e uno più lontano, verso cui l'elenco dell'Autopilota può portarti. Quali minerali contenga un campo dipende da quanto il sistema è vicino al sistema d'origine di ciascun minerale, quindi non tutti i minerali si trovano ovunque. Gli asteroidi possono anche essere fatti a pezzi a colpi d'arma; a volte questo lascia fluttuare un po' di minerale libero, e gli asteroidi distrutti contano per [[medal/29]].", false],
		[0, "Cominciare a estrarre", "Per estrarre servono un laser minerario e spazio libero nella stiva. Aggancia un asteroide tenendolo sotto il mirino, poi premi Fuoco. La nave si avvicina alla roccia e la trivella si avvia; il volo resta bloccato finché non hai finito. Una volta agganciato l'asteroide, l'HUD ne mostra il minerale e la classe.", false],
		[0, "La trivella", "Un indicatore mostra gli strati di roccia dell'asteroide impilati uno sull'altro, ognuno più stretto del precedente. La trivella scivola da un lato e cambia direzione a caso ogni mezzo secondo fino a due secondi e mezzo. Sposta la trivella a sinistra e a destra per tenerla dentro l'area verde dello strato attuale. Il primo strato richiede sei secondi di trivellazione, e ogni strato più profondo richiede circa un sesto di tempo in meno del precedente. Il minerale si accumula per tutto il tempo in cui resti nel verde, e più rapidamente negli strati profondi.", false],
		[0, "Zone rosse", "Il tempo trascorso fuori dall'area verde conta come danno, e le zone rosse dell'indicatore si allargano. Dopo due secondi e mezzo complessivi nel rosso, l'asteroide si spezza e tutto ciò che ne hai estratto va perduto. Premi Fuoco in qualsiasi momento per fermarti e tenere il minerale raccolto fin lì. Ogni asteroide si può sfruttare una sola volta.", false],
		[0, "Classi e nuclei", "Gli asteroidi più grandi hanno più strati, da due a sette. Il più grande, di classe A, li ha tutti e sette, e trivellarli tutti fornisce un nucleo oltre al minerale. I nuclei valgono molto più del minerale e contano per [[medal/3]] e [[medal/7]]. I minerali contano per [[medal/2]] e [[medal/6]].", false],
		[0, "Laser minerari", "Un laser minerario ha due valori. La resa fa scivolare la trivella più lentamente e la rende più precisa da manovrare, così è più facile tenerla nel verde. La velocità aumenta il ritmo con cui si accumula il minerale. I laser vanno dal [[item/86]] al [[item/89]]; il [[item/90]] si costruisce a partire da un progetto.", false],
		[0, "Stiva", "Minerale e nuclei finiscono direttamente nella stiva, e ne tieni solo quanto c'è spazio. Quando la stiva è piena l'HUD lo segnala e devi vendere o scaricare in una stazione. Le unità di compressione del carico ampliano la stiva di una quota della capacità dello scafo, e se ne possono montare diverse contemporaneamente. Ma soprattutto aiuta uno scafo più grande.", false],
	],
	"guide/navigation": [
		[0, "La mappa della galassia", "La sezione \"Map\" (Mappa) di una stazione, e il tasto Mappa rotte in volo, mostrano la galassia: ogni sistema conosciuto al suo posto, i collegamenti tra i portali, la razza dominante e la sicurezza del sistema. Scegliendo un sistema lo si ingrandisce e se ne vedono le stazioni; scegliendo lì una stazione la si imposta come destinazione. La mappa mostra anche la distanza da un sistema in chilometri, segnala le stazioni che hai visitato e indica dove proseguono la storia e il tuo incarico attuale. Una casella di ricerca trova le stazioni conosciute per nome. La pagina [[chart]] elenca tutti i sistemi.", false],
		[0, "", "All'inizio della storia sei vincolato all'orbita della tua prima stazione. La mappa si apre alla [[step/9]], dopodiché puoi volare verso gli altri pianeti del sistema.", false],
		[0, "Sistemi e sicurezza", "Ogni sistema è governato da una delle quattro grandi razze e ha un livello di sicurezza: \"Safe\" (Sicuro), \"Average\" (Medio), \"Risky\" (Rischioso) o \"Dangerous\" (Pericoloso). Le incursioni di pirati e nemici sono molto più frequenti nei sistemi pericolosi, mentre quelli sicuri sono per lo più tranquilli. La maggior parte dei sistemi ha diverse stazioni, ognuna in orbita attorno al proprio pianeta, con il proprio negozio, la propria lounge e il proprio \"Tec Level\" (livello tecnologico).", false],
		[0, "Portali di salto", "Si viaggia tra i sistemi attraverso i portali di salto. Un sistema ha al massimo un portale, che si trova nello spazio di una delle sue stazioni, ed è collegato solo ai sistemi vicini. Per saltare, scegli in \"Map\" una destinazione in un sistema vicino, vola fino al portale (l'autopilota ti ci porta), aggancialo e premi Fuoco una volta entrato nella sua zona. I viaggi più lunghi si fanno un portale alla volta; la schermata \"Missions\" (Missioni) mostra quanti salti tra portali servono per una destinazione attraverso i sistemi che conosci.", false],
		[0, "Sistemi nascosti", "All'inizio cinque sistemi mancano dalla mappa: [[system/0]], [[system/1]], [[system/6]], [[system/10]] e [[system/21]]. Un sistema nascosto compare quando ci sei stato o ne hai comprato le coordinate. Quattro agenti nella Space Lounge le vendono: [[agent/12]] per [[system/0]], [[agent/13]] per [[system/1]], [[agent/14]] per [[system/10]] e [[agent/15]] per [[system/21]]. Gli agenti con un nome compaiono solo quando la storia ha superato la [[step/16]]. [[system/10]] non ha alcun collegamento tramite portale e si può raggiungere solo con un motore di salto.", false],
		[23, "", "La strada per [[system/6]] te la consegna la storia ([[step/22]]).", false],
		[0, "Motore di salto", "Un motore di salto porta la nave direttamente a una stazione di qualsiasi sistema conosciuto, senza portali. L'unico è il [[item/85]], che non è mai in vendita nei negozi e va costruito a partire dal suo progetto. Si usa dal menu Azioni in volo. Un salto non costa carburante né tariffe. Non è disponibile mentre presso la tua stazione è in corso il combattimento di un incarico freelance, mentre gli incarichi di corriere e di trasporto passeggeri non lo impediscono.", false],
		[34, "", "La storia ti consegna il progetto del [[item/85]] nella [[step/34]], con una parte dei suoi ingredienti già consegnata.", false],
		[0, "Distanza", "Le distanze tra i sistemi sono indicate in chilometri, misurate a partire dalla posizione dei sistemi sulla mappa. La distanza conta per il commercio, perché i prezzi salgono con la distanza dall'origine di un oggetto, e per gli incarichi freelance, la cui ricompensa cresce con la distanza dalla destinazione.", false],
	],
	"guide/tips": [
		[0, "", "Leggi la pagina di un oggetto prima di un viaggio commerciale: indica il sistema in cui l'oggetto costa meno e la direzione in cui diventa più caro.", true],
		[0, "", "Le stazioni comprano e vendono allo stesso prezzo, quindi un carico rende solo dopo essersi allontanato dalla sua origine.", true],
		[0, "", "Durante l'estrazione, reagisci subito a ogni cambio di direzione della trivella. Il tempo nel rosso si somma per l'intera trivellazione, quindi brevi sbandate costano quanto una lunga.", true],
		[0, "", "Se la trivella ha già passato molto tempo nel rosso, fermala con Fuoco e tieni ciò che hai invece di perdere l'intero bottino.", true],
		[0, "", "Cerca gli asteroidi più grandi quando vuoi dei nuclei: solo le rocce di classe A ne contengono uno, e solo se riesci ad attraversare tutti e sette gli strati.", true],
		[0, "", "Monta presto un raggio traente. Senza, il carico dei relitti e delle navi fuori uso non si può proprio raccogliere.", true],
		[0, "", "Uno scanner migliore si ripaga in combattimento: aggancia i bersagli più in fretta, e i migliori mostrano che cosa trasporta una nave prima che tu la attacchi.", true],
		[0, "", "L'attracco ripara la nave gratuitamente, quindi conviene fermarsi in una stazione tra un combattimento e l'altro invece di proseguire con lo scafo danneggiato.", true],
		[0, "", "Attracca regolarmente durante i viaggi lunghi. Solo un attracco completato crea un salvataggio automatico, e una nave distrutta ti riporta all'ultimo.", true],
		[0, "", "Tieni d'occhio la tua reputazione nella schermata \"Status\" (Stato). I colpi vaganti contro le navi locali si sommano, e un'intera razza può diventare ostile.", true],
		[0, "", "Chiedi a un cliente dove si trova l'incarico e quanto sarà difficile prima di accettare, a meno che tu non stia collezionando le medaglie per chi non fa domande.", true],
		[0, "", "Fai spazio nella stiva prima di accettare un incarico da corriere, e monta delle cabine prima di un incarico di trasporto passeggeri: senza lo spazio necessario non si possono accettare.", true],
		[0, "", "Per gli incarichi di recupero, porta un'arma EMP, uno scanner che mostra il carico, un raggio traente e un po' di spazio libero nella stiva.", true],
		[0, "", "Porta tutti gli ingredienti di un progetto alla stazione in cui hai iniziato la produzione, e ti eviterai il costo di spedizione.", true],
		[0, "", "Ingaggia i gregari subito prima di un combattimento difficile: il loro contratto scorre solo mentre voli.", true],
	],
	"guide/trading": [
		[0, "Come si formano i prezzi", "Ogni oggetto ha un prezzo minimo, un prezzo massimo e un sistema d'origine. Nell'origine si vende al prezzo minimo; più una stazione è lontana dall'origine, più il prezzo è alto, fino al prezzo massimo a una distanza prestabilita. Inoltre ogni stazione aggiunge una propria variazione fissa di circa il cinque per cento al massimo, in più o in meno. Le pagine degli oggetti mostrano dove un oggetto costa meno e in quale direzione diventa più caro.", false],
		[0, "Comprare e vendere", "Una stazione compra allo stesso prezzo a cui vende, quindi il profitto deriva solo dallo spostamento delle merci: compra vicino all'origine di un oggetto e vendi lontano da essa. Le merci che vendi vengono aggiunte allo scaffale della stazione. \"Shop\" (Negozio) ricorda anche il prezzo più basso e quello più alto che hai visto per ogni oggetto, e in quale sistema, e li mostra accanto all'oggetto. Alcuni carichi non si possono vendere, come le merci da corriere e i container che trasporti per un cliente.", false],
		[0, "Che cosa vende un negozio", "Ogni stazione ha un \"Tec Level\" (livello tecnologico). Il suo scaffale contiene oggetti di quel livello o inferiori; le stazioni di livello quattro o superiore escludono gli oggetti al di sotto della metà del proprio livello. Ogni oggetto ha inoltre una certa probabilità di trovarsi su un dato scaffale, quindi gli scaffali cambiano da una visita all'altra. Alcuni oggetti sono sempre sullo scaffale di una determinata stazione. Alcune merci sono vendute solo nei sistemi [[faction/1]], e i prodotti dei progetti non sono mai in vendita.", false],
		[0, "", "Le merci di consumo arrivano in quantità maggiori, e in quantità molto maggiori vicino alla loro origine. Armi ed equipaggiamento arrivano di solito da uno a tre pezzi alla volta, mentre razzi, siluri e bombe arrivano in lotti più grandi. Uno scaffale viene rifornito ogni volta che attracchi, tranne nelle ultime tre stazioni che hai visitato, che mantengono gli scaffali come li hai lasciati.", false],
		[0, "Alcolici", "Ogni sistema ha una propria bevanda locale, venduta solo in quel sistema, come il [[item/132]] in [[system/0]] o il [[item/146]] in [[system/14]]. Le bevande sono normali merci di scambio. Comprarle nei negozi conta per [[medal/8]]; possederne tipi diversi comprati dai commercianti della Lounge o recuperati dai relitti conta per [[medal/9]].", false],
		[0, "Altre fonti", "I commercianti della Space Lounge offrono singoli lotti a un prezzo che va dal 40 al 160 per cento di quello abituale, quindi conviene confrontare le loro offerte. Le navi trasportano un carico che si può prendere con un raggio traente quando vengono distrutte o messe fuori uso, e il minerale si può estrarre. Gli acquirenti della Lounge chiedono una certa quantità di un determinato oggetto e la pagano ben al di sopra del suo valore; vedi [[job/8]].", false],
	],
	"home": [
		[0, "", "Questo compendio riguarda Galaxy on Fire 2, un gioco spaziale di commercio, estrazione mineraria, combattimento ed esplorazione. Vesti i panni di [[character/0]], un pilota veterano naufragato lontano da casa, in 22 sistemi stellari controllati da umani e razze aliene. Tra una missione della storia e l'altra puoi accettare incarichi freelance, estrarre minerale dagli asteroidi, commerciare merci, costruire equipaggiamento a partire dai progetti e acquistare navi sempre migliori.", false],
		[0, "", "Le pagine sono generate dal gioco che hai importato. Nomi, valori, prezzi e dialoghi provengono da esso, mentre le spiegazioni che li accompagnano sono scritte per questo compendio. I dettagli della storia oltre il punto raggiunto dal tuo salvataggio restano nascosti finché non ci arrivi. Buoni punti di partenza sono [[world/galaxy]], la [[chart]] e [[guide/basics]].", false],
	],
	"intro/agents": [
		[0, "", "Gli agenti sono commercianti che stanno in determinate Space Lounge e vendono qualcosa che non si può comprare in un negozio: un progetto raro oppure le coordinate di un sistema nascosto. Compaiono dalla [[step/17]] in poi, e ognuno vende una sola volta. Parla con loro nella lounge della loro stazione per vedere l'offerta; vedi [[guide/lounge]].", false],
	],
	"intro/blueprints": [
		[0, "", "Gli oggetti da progetto non sono mai in vendita nei negozi. Ciascuno si costruisce secondo una ricetta di merci una volta che ne possiedi il progetto, che di solito si compra da un agente nella Space Lounge. Il funzionamento della produzione è spiegato in [[guide/blueprints]].", false],
	],
	"intro/characters": [
		[0, "", "Queste sono le persone che [[character/0]] incontra nel suo viaggio: commercianti, ufficiali, scienziati e compagnie più insolite. Ogni biografia si arricchisce con l'avanzare della storia, così di un personaggio scopri solo ciò che ha scoperto Keith stesso.", false],
	],
	"intro/equipment": [
		[0, "", "L'equipaggiamento occupa gli slot di equipaggiamento di una nave: scudi e piastre di corazza per la protezione, compressori di carico, raggi traenti per raccogliere i container, booster, ugelli di manovra, scanner, laser minerari, cabine passeggeri, dispositivi di occultamento, un robot di riparazione e il motore di salto. Ogni pezzo occupa uno slot, quindi il numero di slot limita quanto può essere completa una nave. I prezzi variano da sistema a sistema, e i negozi tengono solo oggetti fino al livello tecnologico della loro stazione. Alcuni dei pezzi migliori si costruiscono a partire dai progetti, e diversi sono fabbricati dai [[faction/1|Vossk]] e venduti solo nei loro sistemi.", false],
	],
	"intro/factions": [
		[0, "", "Nel gioco compaiono dieci fazioni. Quattro di esse possiedono sistemi e stazioni: i Terrestri, i Vossk, i Niveliani e i Midoriani. Le altre non hanno territorio e le incontri solo come singoli individui o come nemici. La tua reputazione presso le quattro grandi potenze è registrata su due scale, Terrestri contro Vossk e Niveliani contro Midoriani; vedi [[world/galaxy]].", false],
	],
	"intro/goods": [
		[0, "", "Le merci sono tutto ciò che si trasporta nella stiva per commerciare. Merci di consumo e bevande si comprano a poco in un sistema e si vendono a caro prezzo in un altro (vedi [[guide/trading]]); ogni sistema ha la propria bevanda. I minerali si estraggono dagli asteroidi, e trivellare tutti gli strati di un asteroide di classe A fornisce un nucleo di valore molto più alto (vedi [[guide/mining]]). Merci di consumo, minerali e nuclei sono anche gli ingredienti per costruire oggetti a partire dai progetti. Alcune merci, come [[item/116]] e [[item/131]], compaiono solo tramite incarichi o la storia e non si possono comprare.", false],
	],
	"intro/guide": [
		[0, "", "Queste pagine spiegano come si gioca: volo e combattimento, estrazione mineraria e commercio, le schermate della stazione, il lavoro freelance, la produzione e le medaglie. I valori citati qui seguono le regole del motore; le tabelle nelle pagine di oggetti, navi e medaglie provengono dai tuoi dati di gioco. Comincia da [[guide/basics]] e [[guide/help]].", false],
	],
	"intro/jobs": [
		[0, "", "Gli incarichi freelance sono lavori secondari offerti dai clienti nella Space Lounge, dal trasporto di merci alla caccia ai criminali ricercati. Fruttano crediti, reputazione presso la razza del cliente ed esperienza. Ne esistono tredici tipi; come vengono offerti e pagati è spiegato in [[guide/jobs]].", false],
	],
	"intro/medals": [
		[0, "", "Le medaglie premiano lo stato di servizio di un pilota: combattimento, estrazione mineraria, commercio, viaggi e perfino il modo in cui parli con le persone nella Space Lounge. La maggior parte ha i gradi bronzo, argento e oro. Vengono verificate ogni volta che attracchi; vedi [[guide/medals]].", false],
	],
	"intro/ships": [
		[0, "", "Le navi differiscono per corazza, spazio di carico, manovrabilità e numero di slot: slot primari per le armi che sparano in avanti, slot secondari per razzi, siluri e bombe, un eventuale slot per torretta e slot di equipaggiamento per tutto il resto. I prezzi salgono rapidamente, da meno di 20.000 crediti per gli scafi più piccoli a diversi milioni per i caccia migliori. I rivenditori fuori dai sistemi [[faction/1|Vossk]] mostrano fino a cinque scafi a ogni visita; i rivenditori [[faction/1|Vossk]] vendono solo la [[ship/9]]. Un rivenditore sconta dal prezzo di listino una percentuale pari al livello tecnologico della sua stazione e paga quattro quinti del prezzo di listino per il tuo vecchio scafo. La [[ship/0]] e la [[ship/10]] non sono mai in vendita. Vedi [[guide/fitting]] per sapere come equipaggiare una nave.", false],
	],
	"intro/stations": [
		[0, "", "Ogni stazione ha un negozio, un hangar, un rivenditore di navi e una Space Lounge. Il suo livello tecnologico, da 1 a 10, stabilisce quanto possono essere avanzate le merci e l'equipaggiamento sui suoi scaffali, e il suo rivenditore sconta il prezzo di listino delle navi della stessa percentuale. Le scorte cambiano da una visita all'altra. Le stazioni citate nella storia o che ospitano un agente hanno qui una breve descrizione.", false],
	],
	"intro/story": [
		[0, "", "La storia segue [[character/0]], un pilota terrestre la cui caccia ai pirati finisce molto male, attraverso 45 fasi. Ogni pagina di fase indica il compito e, una volta completato, che cosa è accaduto. Le pagine rivelano solo quanto il tuo salvataggio ha raggiunto; [[world/history]] racconta in un unico luogo la storia fin qui.", false],
	],
	"intro/systems": [
		[0, "", "La galassia conta 22 sistemi stellari. Ognuno appartiene a una fazione, ha un livello di sicurezza che stabilisce quanto spesso compaiono i predoni e ospita fino a cinque stazioni, una delle quali ha il portale di salto. I collegamenti tra portali determinano tra quali sistemi puoi viaggiare; alcuni sistemi sono nascosti o del tutto privi di collegamenti. Vedi [[world/galaxy]] e la [[chart]].", false],
	],
	"intro/weapons": [
		[0, "", "Le armi si dividono in due gruppi. Le armi primarie (laser, blaster, cannoni automatici e armi termiche) sparano senza munizioni dagli slot anteriori; differiscono per danno per colpo, cadenza di fuoco e gittata. Le armi secondarie (razzi, siluri, bombe EMP e armi nucleari) si comprano al pezzo e si sparano dagli slot secondari. Le torrette richiedono un proprio slot e possono sparare in qualsiasi direzione. Alcune armi prosciugano l'energia di una nave invece di danneggiarla, o oltre a danneggiarla; una nave rimasta senza energia resta fuori uso per un po'. Diverse tra le armi migliori non sono mai in vendita nei negozi e vanno costruite a partire dai progetti (vedi [[guide/blueprints]]). Molti modelli sono fabbricati dai [[faction/1|Vossk]] e si trovano solo nei loro sistemi. Vedi [[guide/combat]] per le tattiche.", false],
	],
	"intro/world": [
		[0, "", "Queste pagine descrivono l'ambientazione del gioco: la galassia e la sua disposizione, la sua storia e le forze che la plasmano. Completano con un quadro più ampio le pagine dedicate a sistemi, stazioni e fazioni.", false],
	],
	"item/0": [
		[0, "", "Il [[item/0]] è il laser di livello base: 3 di danno per colpo ogni 0,4 s, con la gittata di 2.000 unità comune a tutti i primi laser. È il laser più debole del gioco, ma è economico e quasi ogni negozio lo vende. Il [[item/1]] e il [[item/2]] mantengono la stessa cadenza di fuoco e aggiungono danno.", false],
		[6, "", "È uno dei tre pezzi che [[character/2]] offre gratuitamente nel suo hangar presso [[station/78]] prima dell'attacco al covo dei pirati, insieme al [[item/22]] e alla [[item/55]].", false],
	],
	"item/1": [
		[0, "", "Il [[item/1]] è il secondo gradino della linea Nirai. Spara rapidamente quanto il [[item/0]] (ogni 0,4 s) ma infligge 5 di danno per colpo invece di 3, con la stessa gittata. È un miglioramento economico finché il [[item/2]] non diventa accessibile.", false],
	],
	"item/10": [
		[0, "", "Il [[item/10]] infligge 34 di danno ogni 1,4 s con una gittata di 2.600. Colpisce più forte per colpo del [[item/9]] e arriva più lontano, con una cadenza di fuoco leggermente più lenta. È il laser più potente in vendita nei negozi.", false],
	],
	"item/11": [
		[0, "", "Il [[item/11]] è il laser più potente del gioco: 45 di danno ogni 1,5 s con una gittata di 2.600, il colpo singolo più pesante di tutte le armi primarie. Non è mai venduto già pronto. Il suo progetto viene da [[agent/0]] presso [[station/3]], e costruirlo consuma un [[item/9]] insieme a [[item/155]] e a diverse merci di consumo.", false],
	],
	"item/116": [
		[0, "", "I container sigillati sono merci chiuse che compaiono solo con il lavoro freelance. Accettare un incarico [[job/0]] carica nella stiva il numero concordato di container, che occupano spazio di carico; non si possono vendere e vengono consegnati a destinazione. Rappresentano anche la merce rubata negli incarichi [[job/3]], in cui la nave che li trasporta va messa fuori uso invece che distrutta.", false],
	],
	"item/117": [
		[0, "", "Una cabina sicura è un carico speciale che compare solo con il lavoro freelance, negli incarichi [[job/5]] che ti chiedono di liberare un prigioniero da una tra diverse navi e di riportarlo indietro. Come un [[item/116]], non si può comprare né vendere.", false],
	],
	"item/12": [
		[0, "", "Il [[item/12]] è il blaster [[faction/1|Vossk]] di base: 11 di danno ogni 0,6 s con una gittata di 1.500. I blaster arrivano meno lontano dei laser, ma nel tempo colpiscono più forte; perfino questo primo modello infligge un po' più danno del miglior laser Nirai. Serve anche per costruire il [[item/15]]. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/13": [
		[0, "", "Il [[item/13]] è un blaster [[faction/1|Vossk]] che infligge 12 di danno ogni 0,5 s con una gittata di 1.500, un netto passo avanti rispetto al [[item/12]] per cadenza di fuoco e danno. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/131": [
		[0, "", "I [[item/131]] sono i rottami dei caccia [[faction/9|Void]]. Ogni nave [[faction/9|Void]] ostile distrutta lascia cadere un container con da uno a tre esemplari, che si può raccogliere solo con un raggio traente (vedi [[item/68]]). Si vendono al prezzo fisso di 199 crediti, e raccoglierli conta per la medaglia [[medal/21]].", false],
		[24, "", "[[character/6]] ha bisogno di questi resti per le sue ricerche e manda [[character/0]] a raccoglierli vicino a [[station/48]].", false],
		[25, "", "Finché [[character/0]] li sta riportando indietro, i resti non si possono vendere.", false],
		[28, "", "Vengono consegnati alla squadra di [[character/6]] all'arrivo presso [[station/10]].", false],
	],
	"item/14": [
		[0, "", "Il [[item/14]] è un blaster [[faction/1|Vossk]] che spara ogni 0,4 s per 10 di danno. Nel tempo infligge un po' più danno del [[item/13]], ma la sua gittata di 1.000 è corta, quindi è adatto ai piloti che si avvicinano ai bersagli. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/15": [
		[0, "", "Il [[item/15]] è il miglior blaster [[faction/1|Vossk]]: 10 di danno ogni 0,3 s con una gittata di 1.500. Unisce la cadenza di fuoco dei blaster più rapidi alla gittata del [[item/12]]. Non è mai venduto già pronto. Il suo progetto viene da [[agent/1]] presso [[station/8]], e costruirlo consuma un [[item/12]] e un [[item/166]] insieme a diverse merci di consumo.", false],
	],
	"item/154": [
		[0, "", "[[item/154]] è il minerale comune più prezioso. I campi di asteroidi favoriscono i minerali il cui sistema d'origine è vicino, e la sua origine è [[system/9]], dove costa anche meno. Ne serve una grande quantità per costruire il [[item/27]]. Trivellare fino in fondo un asteroide di [[item/154]] di classe A fornisce un [[item/165]].", false],
	],
	"item/155": [
		[0, "", "[[item/155]] è un minerale di prezzo medio il cui sistema d'origine è [[system/21]], dove costa meno. È un ingrediente del [[item/11]] e del [[item/90]]. Il suo nucleo è il [[item/166]].", false],
	],
	"item/156": [
		[0, "", "[[item/156]] è il minerale più economico, con origine in [[system/0]]. Il suo basso valore lo rende un carico poco redditizio da vendere, ma è un ingrediente della piastra di corazza [[item/59]]. Il suo nucleo è il [[item/167]].", false],
	],
	"item/157": [
		[0, "", "[[item/157]] è un minerale di prezzo medio il cui sistema d'origine è [[system/7]]. Insieme al suo nucleo, il [[item/168]], serve per costruire la piastra di corazza [[item/59]].", false],
	],
	"item/158": [
		[0, "", "[[item/158]] è un minerale di prezzo medio il cui sistema d'origine è [[system/4]]. È uno dei minerali necessari per il [[item/85]]. Il suo nucleo è il [[item/169]].", false],
	],
	"item/159": [
		[0, "", "[[item/159]] è un minerale di prezzo medio il cui sistema d'origine è [[system/18]]. Nessun progetto lo usa, quindi si estrae solo per venderlo o per le medaglie dei minerali. Il suo nucleo è il [[item/170]].", false],
	],
	"item/16": [
		[0, "", "Il [[item/16]] è il primo blaster EMP. Non danneggia né lo scafo né la corazza; ogni colpo prosciuga invece 3 punti dell'energia di una nave, e una nave la cui energia arriva a zero resta fuori uso per un po'. Le armi EMP servono quando un bersaglio va fermato invece che distrutto. Questo modello spara ogni 0,3 s ma ha una gittata di sole 1.200 unità. Il [[item/17]] e il [[item/18]] arrivano più lontano e prosciugano di più per colpo.", false],
	],
	"item/160": [
		[0, "", "[[item/160]] è un minerale di basso prezzo il cui sistema d'origine è [[system/13]]. È uno dei minerali necessari per il [[item/85]]. Il suo nucleo è il [[item/171]].", false],
	],
	"item/161": [
		[0, "", "[[item/161]] è un minerale di prezzo medio il cui sistema d'origine è [[system/19]]. Nessun progetto lo usa. Il suo nucleo è il [[item/172]].", false],
	],
	"item/162": [
		[0, "", "[[item/162]] è un minerale di prezzo medio il cui sistema d'origine è [[system/14]]. Nessun progetto lo usa. Il suo nucleo è il [[item/173]].", false],
	],
	"item/163": [
		[0, "", "[[item/163]] è un minerale di prezzo medio il cui sistema d'origine è [[system/5]]. È l'ingrediente principale dello [[item/54]], che ne richiede 80 t, e serve anche per il [[item/85]]. Il suo nucleo è il [[item/174]].", false],
	],
	"item/164": [
		[0, "", "I [[item/164]] sono un minerale che non si trova mai nei campi di asteroidi dei sistemi abitati. A differenza degli altri minerali, un asteroide di cristallo non lascia nulla quando viene distrutto a colpi d'arma, quindi i cristalli vanno trivellati. Sono l'ingrediente chiave del [[item/85]], che ne richiede 50.", false],
		[25, "", "Tutti gli asteroidi dello spazio d'origine dei [[faction/9|Void]], raggiungibile attraverso i loro wormhole, sono fatti di questi cristalli.", false],
		[33, "", "[[character/20]] chiede a [[character/0]] di portargli almeno 50 cristalli, che secondo lui custodiscono il segreto dei wormhole dei [[faction/9|Void]].", false],
	],
	"item/165": [
		[0, "", "Questo nucleo è il raro centro di un asteroide di [[item/154]] di classe A. Si ottiene trivellando tutti e sette gli strati di un asteroide simile, e di tanto in tanto ne cade uno quando un asteroide di classe A viene distrutto a colpi d'arma. Si vende a un prezzo diverse volte superiore a quello del minerale stesso, al prezzo più basso in [[system/9]]. È il nucleo più prezioso dopo il [[item/175]].", false],
	],
	"item/166": [
		[0, "", "Questo nucleo è il raro centro di un asteroide di [[item/155]] di classe A. Si ottiene trivellando tutti e sette gli strati di un asteroide simile, e di tanto in tanto ne cade uno quando un asteroide di classe A viene distrutto a colpi d'arma. Si vende a un prezzo diverse volte superiore a quello del minerale stesso, al prezzo più basso in [[system/21]]. Serve per costruire il [[item/15]] e, dieci alla volta, il [[item/90]].", false],
	],
	"item/167": [
		[0, "", "Questo nucleo è il raro centro di un asteroide di [[item/156]] di classe A. Si ottiene trivellando tutti e sette gli strati di un asteroide simile, e di tanto in tanto ne cade uno quando un asteroide di classe A viene distrutto a colpi d'arma. Si vende a un prezzo diverse volte superiore a quello del minerale stesso, al prezzo più basso in [[system/0]]. È il nucleo meno prezioso.", false],
	],
	"item/168": [
		[0, "", "Questo nucleo è il raro centro di un asteroide di [[item/157]] di classe A. Si ottiene trivellando tutti e sette gli strati di un asteroide simile, e di tanto in tanto ne cade uno quando un asteroide di classe A viene distrutto a colpi d'arma. Si vende a un prezzo diverse volte superiore a quello del minerale stesso, al prezzo più basso in [[system/7]]. Ne servono quindici per costruire la [[item/59]].", false],
	],
	"item/169": [
		[0, "", "Questo nucleo è il raro centro di un asteroide di [[item/158]] di classe A. Si ottiene trivellando tutti e sette gli strati di un asteroide simile, e di tanto in tanto ne cade uno quando un asteroide di classe A viene distrutto a colpi d'arma. Si vende a un prezzo diverse volte superiore a quello del minerale stesso, al prezzo più basso in [[system/4]].", false],
	],
	"item/17": [
		[0, "", "Il [[item/17]] prosciuga 5 di energia per colpo ogni 0,5 s e ha una gittata di 2.000 unità, molto più del [[item/16]]. Non infligge danni allo scafo. Prosciuga energia più o meno allo stesso ritmo del Mk I, ma può farlo da una distanza più sicura.", false],
	],
	"item/170": [
		[0, "", "Questo nucleo è il raro centro di un asteroide di [[item/159]] di classe A. Si ottiene trivellando tutti e sette gli strati di un asteroide simile, e di tanto in tanto ne cade uno quando un asteroide di classe A viene distrutto a colpi d'arma. Si vende a un prezzo diverse volte superiore a quello del minerale stesso, al prezzo più basso in [[system/18]].", false],
	],
	"item/171": [
		[0, "", "Questo nucleo è il raro centro di un asteroide di [[item/160]] di classe A. Si ottiene trivellando tutti e sette gli strati di un asteroide simile, e di tanto in tanto ne cade uno quando un asteroide di classe A viene distrutto a colpi d'arma. Si vende a un prezzo diverse volte superiore a quello del minerale stesso, al prezzo più basso in [[system/13]].", false],
	],
	"item/172": [
		[0, "", "Questo nucleo è il raro centro di un asteroide di [[item/161]] di classe A. Si ottiene trivellando tutti e sette gli strati di un asteroide simile, e di tanto in tanto ne cade uno quando un asteroide di classe A viene distrutto a colpi d'arma. Si vende a un prezzo diverse volte superiore a quello del minerale stesso, al prezzo più basso in [[system/19]].", false],
	],
	"item/173": [
		[0, "", "Questo nucleo è il raro centro di un asteroide di [[item/162]] di classe A. Si ottiene trivellando tutti e sette gli strati di un asteroide simile, e di tanto in tanto ne cade uno quando un asteroide di classe A viene distrutto a colpi d'arma. Si vende a un prezzo diverse volte superiore a quello del minerale stesso, al prezzo più basso in [[system/14]].", false],
	],
	"item/174": [
		[0, "", "Questo nucleo è il raro centro di un asteroide di [[item/163]] di classe A. Si ottiene trivellando tutti e sette gli strati di un asteroide simile, e di tanto in tanto ne cade uno quando un asteroide di classe A viene distrutto a colpi d'arma. Si vende a un prezzo diverse volte superiore a quello del minerale stesso, al prezzo più basso in [[system/5]].", false],
	],
	"item/175": [
		[0, "", "[[item/175]] è il nucleo di un asteroide di [[item/164]] di classe A. Poiché gli asteroidi di cristallo non lasciano nulla quando vengono distrutti a colpi d'arma, l'unico modo per ottenerlo è trivellare tutti e sette gli strati. Si vende al prezzo fisso di 5.000 crediti, più di cinque volte il prezzo migliore di qualsiasi altro nucleo.", false],
		[25, "", "Si trova solo nello spazio d'origine dei [[faction/9|Void]].", false],
	],
	"item/18": [
		[0, "", "Il [[item/18]] è il blaster EMP più potente: 8 di energia per colpo ogni 0,5 s con una gittata di 2.000, il che mette fuori uso le navi sensibilmente più in fretta del [[item/17]]. Come gli altri blaster EMP non danneggia lo scafo.", false],
	],
	"item/19": [
		[0, "", "Il [[item/19]] infligge 15 di danno ogni 0,3 s con una gittata di 1.400. Nel tempo colpisce molto più forte di qualsiasi laser. Il [[item/20]] e il [[item/21]] sparano più rapidamente, ma hanno una gittata di sole 1.000 unità.", false],
	],
	"item/2": [
		[0, "", "Il [[item/2]] è il miglior laser Nirai: 7 di danno ogni 0,4 s. Ogni colpo è più debole di quelli dei laser Berger, ma poiché spara circa il doppio delle volte infligge nel tempo più danni di ciascuno di essi, compreso il [[item/8]]. Solo i laser a raggio M6 (il [[item/9]] e i successivi) lo superano nettamente.", false],
	],
	"item/20": [
		[0, "", "Il [[item/20]] spara ogni 0,2 s per 13 di danno. Nel tempo infligge più danno del [[item/19]], ma la sua gittata è di sole 1.000 unità, quindi rende al meglio a distanza ravvicinata.", false],
	],
	"item/21": [
		[0, "", "Il [[item/21]] infligge 14 di danno ogni 0,2 s, il danno nel tempo più alto di tutte le armi anteriori. Come il [[item/20]] ha una gittata di sole 1.000 unità. È anche il blaster più raro nei negozi.", false],
	],
	"item/22": [
		[0, "", "Il [[item/22]] è l'arma più debole del gioco: 2 di danno ogni 0,4 s con una gittata di 1.000. I cannoni automatici sparano proiettili piccoli e rapidi; colpiscono leggermente, ma alcuni modelli sparano molto in fretta. Questo primo modello è solo un ripiego.", false],
		[6, "", "È uno dei tre pezzi che [[character/2]] offre gratuitamente nel suo hangar presso [[station/78]] prima dell'attacco al covo dei pirati, insieme al [[item/0]] e alla [[item/55]].", false],
	],
	"item/23": [
		[0, "", "Il [[item/23]] raddoppia il danno del [[item/22]] portandolo a 4 per colpo e spara un po' più rapidamente (ogni 0,3 s), sempre con una gittata di 1.000. È un'arma economica per le prime fasi.", false],
	],
	"item/24": [
		[0, "", "Il [[item/24]] infligge 6 di danno ogni 0,3 s con una gittata di 1.200. È un solido cannone automatico di fascia media ed eguaglia il danno nel tempo del [[item/25]], che arriva più lontano.", false],
	],
	"item/25": [
		[0, "", "Il [[item/25]] infligge 8 di danno ogni 0,4 s e ha una gittata di 1.400 unità, la più lunga di tutti i cannoni automatici. Nel tempo infligge lo stesso danno del [[item/24]]. Non è mai venduto già pronto. Il suo progetto viene da [[agent/2]] presso [[station/20]], e si costruisce solo con merci di consumo, senza minerale.", false],
	],
	"item/26": [
		[0, "", "Il [[item/26]] spara ogni 0,2 s per 5 di danno con una gittata di 1.000. La sua cadenza rapida gli dà più danno nel tempo dei cannoni a rotaia, a scapito della gittata.", false],
	],
	"item/27": [
		[0, "", "Il [[item/27]] spara ogni 0,1 s, la cadenza più rapida di tutti i cannoni automatici, per 6 di danno a proiettile. Il suo danno nel tempo si avvicina a quello dei blaster migliori, ma la sua gittata di 900 è la più corta di tutte le armi. Non è mai venduto già pronto. Il suo progetto viene da [[agent/3]] presso [[station/10]], e per costruirlo serve, tra le altre merci, [[item/154]].", false],
	],
	"item/28": [
		[0, "", "Il [[item/28]] è la prima arma termica. Le armi termiche sparano colpi rapidi e leggeri con una gittata di 1.000; questa infligge 3 di danno ogni 0,3 s. Nonostante il suo alto livello tecnologico, nel tempo è più debole della maggior parte dei blaster e dei cannoni automatici di fascia media.", false],
	],
	"item/29": [
		[0, "", "Il [[item/29]] infligge 4 di danno ogni 0,2 s con una gittata di 1.000, il doppio del danno nel tempo del [[item/28]].", false],
	],
	"item/3": [
		[0, "", "Il [[item/3]] è un laser [[faction/1|Vossk]] che infligge 7 di danno ogni 0,5 s. Per colpo eguaglia il [[item/2]], ma spara un po' più lentamente, quindi nel tempo resta leggermente indietro. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
		[0, "", "La [[ship/10]] di [[character/0]] ne porta due nella scena iniziale.", false],
	],
	"item/30": [
		[0, "", "Il [[item/30]] spara ogni 0,1 s per 3 di danno, la più rapida delle armi termiche. Nel tempo infligge più del [[item/29]], ma meno dei blaster migliori come il [[item/21]].", false],
	],
	"item/31": [
		[0, "", "Il [[item/31]] è il razzo [[faction/1|Vossk]] di base e la munizione secondaria più economica: 60 di danno per colpo, un lancio ogni 1,2 s, gittata 1.200. I razzi volano dritti e non inseguono il bersaglio, quindi rendono al meglio a distanza ravvicinata. Qualsiasi razzo o siluro che colpisce un asteroide lo frantuma. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/32": [
		[0, "", "Il [[item/32]] è il comune razzo non guidato: 70 di danno per colpo, un lancio ogni 0,9 s e una gittata di 1.200. Colpisce più forte e si lancia più rapidamente del [[item/31]], ed è venduto ovunque.", false],
	],
	"item/33": [
		[0, "", "Il [[item/33]] infligge 72 di danno e prosciuga anche 34 di energia, quindi può sia danneggiare un bersaglio sia contribuire a metterlo fuori uso. Si ricarica lentamente (2 s) e ha una gittata di 1.000 unità. Non è mai venduto già pronto. Il suo progetto viene da [[agent/4]] presso [[station/43]], e un lotto richiede solo poche merci di consumo economiche.", false],
	],
	"item/34": [
		[0, "", "Il [[item/34]] è pensato per mettere fuori uso più che per distruggere: prosciuga 45 di energia e infligge solo 10 di danno per colpo, con un lancio al secondo. Il [[item/35]] prosciuga di più e infligge più danno.", false],
	],
	"item/35": [
		[0, "", "Il [[item/35]] prosciuga 60 di energia e infligge 30 di danno per colpo, con un lancio al secondo e una gittata di 1.000. Mette fuori uso le navi più in fretta del [[item/34]], continuando a logorarne lo scafo.", false],
	],
	"item/36": [
		[0, "", "Il [[item/36]] è il siluro di base. I siluri volano dritti per il primo 1,5 s e poi si dirigono sul bersaglio. Il [[item/36]] infligge 70 di danno con una gittata di 3.000 unità, ma è lento e si lancia solo ogni 3 s. Il [[item/38]] ne raddoppia il danno.", false],
	],
	"item/37": [
		[0, "", "Il [[item/37]] è il siluro più veloce: infligge 100 di danno, prosciuga 50 di energia e ha una gittata di 4.000 unità. Si lancia ogni 4 s. Non è mai venduto già pronto. Il suo progetto viene da [[agent/5]] presso [[station/54]], e un lotto richiede solo poche merci di consumo.", false],
	],
	"item/38": [
		[0, "", "Il [[item/38]] è il siluro che colpisce più forte, con 140 di danno per colpo e una gittata di 4.000. È lento in volo e si lancia ogni 4 s. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/39": [
		[0, "", "Il [[item/39]] è un siluro a ricerca per mettere fuori uso le navi: prosciuga 100 di energia e non infligge danni. Con una gittata di 5.000 è un modo economico per fermare un bersaglio da lontano. Il [[item/40]] aggiunge 120 di danno allo stesso prosciugamento di energia.", false],
	],
	"item/4": [
		[0, "", "Il [[item/4]] è il laser [[faction/1|Vossk]] più potente: 10 di danno ogni 0,6 s. Il suo danno nel tempo è quasi esattamente quello del [[item/2]], con colpi più pesanti ma più radi di quelli del [[item/3]]. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/40": [
		[0, "", "Il [[item/40]] unisce in un unico siluro a ricerca 120 di danno e un prosciugamento di 100 punti di energia, con una gittata di 5.000 e un lancio ogni 5 s. Costa più del doppio del [[item/39]].", false],
	],
	"item/41": [
		[0, "", "La [[item/41]] è la bomba EMP più piccola. Una bomba si lancia con una pressione e si fa esplodere con una seconda; l'esplosione prosciuga l'energia di tutte le navi nel suo raggio, con più forza vicino al centro, e risparmia la nave che l'ha lanciata. Gli asteroidi non vengono colpiti. Questo modello prosciuga fino a 80 di energia in un raggio di 22.000. La [[item/42]] e la [[item/43]] sono più potenti e più ampie.", false],
		[20, "", "La sicurezza [[faction/0|terrestre]] lascia gratuitamente dieci di queste bombe presso [[station/55]], così che [[character/0]] possa mettere fuori uso la nave dei rapitori senza distruggerla.", false],
	],
	"item/42": [
		[0, "", "La [[item/42]] prosciuga fino a 150 di energia in un raggio di 30.000, quasi il doppio della potenza della [[item/41]] e con un'esplosione molto più ampia.", false],
	],
	"item/43": [
		[0, "", "La [[item/43]] è la bomba EMP più potente: prosciuga fino a 300 di energia in un raggio di 37.000. Si ricarica un po' più in fretta della [[item/42]], ma costa quasi il doppio.", false],
	],
	"item/44": [
		[0, "", "La [[item/44]] è la bomba nucleare più piccola. Come una bomba EMP si lancia e poi si fa esplodere con una seconda pressione, ma la sua esplosione infligge danni reali: fino a 200 entro un raggio di 20.000, meno verso il bordo. Spezza anche gli asteroidi. La nave che la lancia non subisce danni.", false],
	],
	"item/45": [
		[0, "", "La [[item/45]] infligge fino a 560 di danno in un raggio di 30.000, quasi il triplo della potenza della [[item/44]] in un'esplosione più ampia.", false],
	],
	"item/46": [
		[0, "", "La [[item/46]] è l'arma più distruttiva del gioco: fino a 950 di danno in un raggio di 40.000. Non è mai venduta già pronta. Il suo progetto viene da [[agent/6]] presso [[station/61]], e per costruirla servono, tra le altre merci di consumo, materiali radioattivi ed esplosivi.", false],
	],
	"item/47": [
		[0, "", "La [[item/47]] è la torretta di base. Una torretta occupa un proprio slot, presente solo su alcuni scafi, e può ruotare completamente, quindi può colpire bersagli a fianco o dietro la nave; mentre la punti, la nave prosegue da sola. Questo modello infligge 6 di danno ogni 0,3 s con una gittata di 2.000 e ruota lentamente (manovrabilità 40).", false],
	],
	"item/48": [
		[0, "", "La [[item/48]] infligge 10 di danno ogni 0,2 s con una gittata di 2.500 e ruota più in fretta della [[item/47]] (manovrabilità 60). Costa più del triplo.", false],
	],
	"item/49": [
		[0, "", "La [[item/49]] è la torretta migliore: 12 di danno ogni 0,1 s con una gittata di 3.000, con la rotazione più rapida (manovrabilità 100). È anche molto costosa, circa il doppio della [[item/48]]. La vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/5": [
		[0, "", "Il [[item/5]] apre la linea di laser Berger, che sacrifica la cadenza di fuoco in cambio di colpi più pesanti e di una gittata leggermente maggiore (2.200). Infligge 8 di danno ogni 0,9 s, cioè meno danno nel tempo del più economico [[item/2]]. Il suo vantaggio è la gittata maggiore.", false],
	],
	"item/50": [
		[0, "", "Lo [[item/50]] è lo scudo di base. Uno scudo assorbe i danni in arrivo prima che corazza e scafo ne subiscano, e si ricarica da solo nel suo tempo di ricarica. Il Targe contiene solo 50 punti, ma si ricarica completamente in 20 s, più in fretta di qualsiasi altro scudo.", false],
	],
	"item/51": [
		[0, "", "Lo [[item/51]] contiene 80 punti ma impiega 46 s per ricaricarsi completamente. In un singolo combattimento assorbe più dello [[item/50]], ma tra un attacco e l'altro si riprende molto più lentamente.", false],
	],
	"item/52": [
		[0, "", "Lo [[item/52]] è uno scudo [[faction/1|Vossk]] che contiene 120 punti e si ricarica in 58 s. Assorbe molto più dello [[item/51]], ma lo [[item/53]] contiene di più e si ricarica più in fretta. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/53": [
		[0, "", "Lo [[item/53]] contiene 150 punti e si ricarica in 45 s, quindi supera lo [[item/52]] sotto entrambi gli aspetti. È il miglior scudo venduto nei negozi.", false],
	],
	"item/54": [
		[0, "", "Lo [[item/54]] è lo scudo più potente: 220 punti, con una ricarica in 60 s. Non è mai venduto già pronto. Il suo progetto viene da [[agent/7]] presso [[station/72]], e per costruirlo servono una grande quantità di [[item/163]] insieme a elettronica, nanotecnologia e microchip.", false],
	],
	"item/55": [
		[0, "", "La [[item/55]] è la piastra di corazza di base. Una piastra aggiunge i suoi punti alla corazza della nave; dopo lo scudo, subisce i danni prima dello scafo e, a differenza di uno scudo, non si ricarica. La E2 aggiunge 40 punti, una quota notevole per una nave iniziale leggera come la [[ship/32]], che ne ha 100 di suoi.", false],
		[6, "", "È uno dei tre pezzi che [[character/2]] offre gratuitamente nel suo hangar presso [[station/78]] prima dell'attacco al covo dei pirati, insieme al [[item/0]] e al [[item/22]].", false],
	],
	"item/56": [
		[0, "", "La [[item/56]] aggiunge 80 punti di corazza, il doppio della [[item/55]], a un prezzo modesto.", false],
	],
	"item/57": [
		[0, "", "La [[item/57]] aggiunge 110 punti di corazza. È la migliore piastra venduta fuori dai sistemi [[faction/1|Vossk]].", false],
	],
	"item/58": [
		[0, "", "La [[item/58]] è una piastra [[faction/1|Vossk]] che aggiunge 160 punti di corazza, molto più della [[item/57]]. La vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/59": [
		[0, "", "La [[item/59]] è la migliore piastra di corazza: aggiunge 250 punti, quanto la corazza base della [[ship/9]] e più di quella di qualsiasi altro scafo tranne la [[ship/8]]. Non è mai venduta già pronta. Il suo progetto viene da [[agent/8]] presso [[station/84]], e per costruirla servono [[item/157]], [[item/168]] e [[item/156]] insieme a merci di consumo.", false],
	],
	"item/6": [
		[0, "", "Il [[item/6]] infligge 9 di danno ogni 0,8 s con una gittata di 2.200. È un modesto passo avanti rispetto al [[item/5]], e il suo prezzo varia appena da un sistema all'altro.", false],
	],
	"item/60": [
		[0, "", "Il [[item/60]] è il più debole dei tre moduli di protezione EMP, con una difesa EMP di 20. Nessuno dei tre ha un prezzo, e nessun negozio li vende.", false],
	],
	"item/61": [
		[0, "", "Il [[item/61]] è il modulo di protezione EMP intermedio, con una difesa EMP di 40, il doppio del [[item/60]]. Come gli altri due non ha prezzo e non è venduto nei negozi.", false],
	],
	"item/62": [
		[0, "", "Il [[item/62]] è il modulo di protezione EMP più potente, con una difesa EMP di 60. Come il [[item/60]] e il [[item/61]] non ha prezzo e non è venduto nei negozi.", false],
	],
	"item/63": [
		[0, "", "Il [[item/63]] è il compressore di carico di base. Un compressore amplia la stiva di una percentuale della capacità propria dello scafo; questo aggiunge il 15 %. È economico e conviene a qualsiasi commerciante o minatore.", false],
	],
	"item/64": [
		[0, "", "Il [[item/64]] amplia la stiva del 25 %, un netto passo avanti rispetto al [[item/63]] a un prezzo basso.", false],
	],
	"item/65": [
		[0, "", "Il [[item/65]] amplia la stiva del 40 %. Su un grande mercantile aggiunge tanto spazio quanto ne trasporta un'intera nave piccola.", false],
	],
	"item/66": [
		[0, "", "Il [[item/66]] amplia la stiva del 75 %, il massimo tra i compressori venduti nei negozi.", false],
	],
	"item/67": [
		[0, "", "Il [[item/67]] raddoppia la stiva, aggiungendo il 100 % della capacità dello scafo: con esso una [[ship/36]] trasporta 700 t. Non è mai venduto già pronto. Il suo progetto viene da [[agent/9]] presso [[station/90]], e si costruisce solo con merci di consumo.", false],
	],
	"item/68": [
		[0, "", "Il [[item/68]] è il raggio traente di base. Senza un raggio traente non si può raccogliere nessun container alla deriva; volarci contro non serve a nulla. Con il Retractor tieni il container sotto il mirino per 4 s, dopodiché viene attirato a bordo. Il [[item/69]] richiede meno tempo, e il [[item/70]] funziona in automatico.", false],
		[24, "", "[[character/6]] chiede a [[character/0]] di montare un raggio traente prima della prima spedizione contro i [[faction/9|Void]], così da poter raccogliere i resti delle loro navi. Fino ad allora, i negozi hanno buone probabilità di offrire un Retractor oltre al loro assortimento abituale.", false],
	],
	"item/69": [
		[0, "", "Il [[item/69]] funziona come il [[item/68]], ma richiede di tenere il bersaglio sotto il mirino per soli 3 s prima di attirare il container.", false],
	],
	"item/7": [
		[0, "", "Il [[item/7]] infligge 10 di danno ogni 0,8 s con una gittata di 2.200. Nel tempo eguaglia il [[item/1]], quindi il suo pregio sta in colpi più radi e pesanti a lunga distanza.", false],
	],
	"item/70": [
		[0, "", "Il [[item/70]] è il raggio traente automatico: raccoglie qualsiasi container nella visuale anteriore senza bisogno di mirarlo e tenerlo sotto il mirino, il che fa risparmiare molto tempo quando si saccheggia un campo di battaglia. È molto più caro del [[item/69]].", false],
	],
	"item/71": [
		[0, "", "Il [[item/71]] è il booster di base. Un booster dà un breve scatto di velocità extra, poi ha bisogno di tempo per ricaricarsi. Questo aggiunge il 60 % di velocità per 3 s e si ricarica in 8 s.", false],
	],
	"item/72": [
		[0, "", "Il [[item/72]] è dichiarato per l'80 % di velocità extra per 4,4 s, con una ricarica di 10 s. In volo il suo scatto raggiunge la stessa velocità massima del [[item/71]]; ciò che aggiunge è uno scatto più lungo.", false],
	],
	"item/73": [
		[0, "", "Il [[item/73]] dà più del doppio del guadagno dei booster più economici: il 160 % di velocità extra per 5,6 s, con una ricarica in 12 s.", false],
	],
	"item/74": [
		[0, "", "Il [[item/74]] è il booster più potente: il 200 % di velocità extra per 6 s. Richiede la ricarica più lunga, 16 s. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/75": [
		[0, "", "Il [[item/75]] è l'unico robot di riparazione del gioco e si monta in uno slot di equipaggiamento. Mentre voli ripristina un punto di scafo ogni 0,6 s e un punto di piastra di corazza ogni secondo, così i danni si smaltiscono tra un combattimento e l'altro senza attraccare. È economico e lo vendono quasi tutti i negozi.", false],
	],
	"item/76": [
		[0, "", "Il [[item/76]] è l'ugello di manovra di base. Un ugello aggiunge il suo valore alla manovrabilità della nave, che così vira più in fretta. Questo aggiunge 20, un piccolo guadagno per i caccia agili ma un miglioramento notevole su un mercantile lento.", false],
	],
	"item/77": [
		[0, "", "Il [[item/77]] aggiunge 40 di manovrabilità, il doppio del [[item/76]], a un prezzo basso.", false],
	],
	"item/78": [
		[0, "", "Il [[item/78]] è un ugello [[faction/1|Vossk]] che aggiunge 70 di manovrabilità. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/79": [
		[0, "", "Il [[item/79]] è un ugello [[faction/1|Vossk]] che aggiunge 100 di manovrabilità, abbastanza da far virare un mercantile pesante come un caccia agile. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/8": [
		[0, "", "Il [[item/8]] è l'ultimo e il più potente dei laser Berger: 12 di danno per colpo ogni 0,9 s con una gittata di 2.200. È il laser convenzionale che colpisce più forte per singolo colpo, ma il più rapido [[item/2]] infligge comunque più danno nel tempo. I laser a raggio M6 che lo seguono (dal [[item/9]] in poi) colpiscono più del doppio per colpo.", false],
	],
	"item/80": [
		[0, "", "Il [[item/80]] è il miglior ugello di manovra e aggiunge 130 di manovrabilità. Porta la [[ship/36]], lo scafo che vira più lentamente, da 45 a 175, più di quanto abbia qualsiasi caccia senza ugello. È raro nei negozi.", false],
	],
	"item/81": [
		[0, "", "Il [[item/81]] è lo scanner di base. Uno scanner stabilisce quanto tempo serve per agganciare un bersaglio come una nave, una stazione o un asteroide; il Quickscan richiede 4 s. Il [[item/82]] aggancia più in fretta e mostra anche che cosa trasportano le altre navi.", false],
		[2, "", "La nave mineraria di [[character/2]], la [[ship/0]], ne ha uno già montato.", false],
	],
	"item/82": [
		[0, "", "Il [[item/82]] aggancia in 3 s e mostra il carico trasportato dalle navi agganciate, il che aiuta quando si va a caccia di bottino.", false],
	],
	"item/83": [
		[0, "", "Il [[item/83]] aggancia in 1,8 s, un tempo eguagliato solo dal [[item/84]], e mostra anch'esso il carico dei bersagli.", false],
	],
	"item/84": [
		[0, "", "Il [[item/84]] aggancia rapidamente quanto il [[item/83]] e mostra il carico, e in più segnala gli asteroidi di classe A, gli unici che possono fornire un nucleo (vedi [[guide/mining]]). È lo scanner preferito dai minatori.", false],
	],
	"item/85": [
		[0, "", "Il [[item/85]] è l'unico motore di salto del gioco. Con questo montato, puoi viaggiare dalla mappa stellare direttamente a una stazione di un altro sistema senza passare dai portali di salto. Non si può usare durante alcune missioni. Non è mai venduto già pronto, e nessun agente ne vende il progetto. Per costruirlo servono [[item/164]], [[item/158]], [[item/160]] e [[item/163]] insieme a grandi quantità di merci di consumo.", false],
		[33, "", "Il suo inventore, [[character/20]], chiede a [[character/0]] 50 [[item/164]] per il suo lavoro su un motore capace di raggiungere qualsiasi luogo dello spazio.", false],
		[34, "", "In cambio dei cristalli [[character/20]] dà a [[character/0]] una copia del progetto. I 50 cristalli consegnati contano per il motore, quindi vanno forniti solo gli ingredienti restanti.", false],
	],
	"item/86": [
		[0, "", "Il [[item/86]] è il laser minerario di base. Per estrarre minerale dagli asteroidi serve un laser minerario. La sua resa stabilisce con quanta stabilità la trivella mantiene la rotta, e ogni modello ha anche una propria velocità di trivellazione (vedi [[guide/mining]]). Questo ha una resa di 30 ed è difficile da tenere in traiettoria negli strati profondi.", false],
	],
	"item/87": [
		[0, "", "Il [[item/87]] ha una resa di 50. È sensibilmente più stabile del [[item/86]], anche se trivella un po' più lentamente.", false],
	],
	"item/88": [
		[0, "", "Il [[item/88]] è un laser minerario [[faction/1|Vossk]] con una resa di 80, la trivella più stabile venduta nei negozi. Il suo svantaggio è che è il più lento a estrarre minerale. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/89": [
		[0, "", "Il [[item/89]] ha una resa di 60, meno stabile del [[item/88]], ma estrae minerale molto più in fretta di qualsiasi altro laser venduto nei negozi. È adatto ai minatori che sanno tenere da soli la trivella in traiettoria.", false],
	],
	"item/9": [
		[0, "", "Il [[item/9]] è il primo dei laser a raggio M6. Questi sparano di rado ma colpiscono molto forte: 27 di danno ogni 1,2 s, con una gittata di 2.400, superiore a quella di qualsiasi laser precedente. La mira precisa è importante, perché un colpo mancato spreca una lunga ricarica. È anche il componente di base per costruire il [[item/11]].", false],
	],
	"item/90": [
		[0, "", "Il [[item/90]] è il miglior laser minerario: una resa di 100 e la trivellazione più rapida di tutti i modelli. Non è mai venduto già pronto. Il suo progetto viene da [[agent/11]] presso [[station/78]], e per costruirlo servono grandi quantità di nanotecnologia, forniture meccaniche e idraulica, più [[item/155]] e dieci [[item/166]].", false],
		[2, "", "Il laser della prima nave mineraria di [[character/0]] è il prototipo di questa trivella costruito a mano da [[character/2]].", false],
		[10, "", "Quando [[character/2]] regala a [[character/0]] la [[ship/0]], si tiene il prototipo, l'unico che possiede, e gli suggerisce di tornare più avanti, quando forse ne avrà costruiti altri.", false],
	],
	"item/91": [
		[0, "", "La [[item/91]] ospita 3 passeggeri. Le cabine servono per gli incarichi [[job/11]], e lo spazio di più cabine si somma. La [[item/92]] e la [[item/93]] ne ospitano di più.", false],
	],
	"item/92": [
		[0, "", "La [[item/92]] ospita 5 passeggeri, due in più della [[item/91]].", false],
	],
	"item/93": [
		[0, "", "La [[item/93]] ospita 10 passeggeri, il doppio della [[item/92]], il che dà accesso agli incarichi di trasporto passeggeri più grandi.", false],
	],
	"item/94": [
		[0, "", "Il [[item/94]] è il dispositivo di occultamento di base. Mentre è attivo, le altre navi non possono vederti. Questo nasconde la nave per 15 s e poi richiede 18 s di ricarica. Il tempo trascorso occultato conta per la medaglia [[medal/19]].", false],
	],
	"item/95": [
		[0, "", "Il [[item/95]] è un dispositivo di occultamento [[faction/1|Vossk]] che nasconde la nave per 28 s e si ricarica in 32 s, quasi il doppio della copertura del [[item/94]]. Lo vendono solo i negozi dei sistemi [[faction/1|Vossk]].", false],
	],
	"item/96": [
		[0, "", "Il [[item/96]] è il miglior dispositivo di occultamento: nasconde la nave per 46 s e si ricarica in soli 40 s, quindi può restare attivo per la maggior parte del tempo. Non è mai venduto già pronto. Il suo progetto viene da [[agent/10]] presso [[station/59]].", false],
	],
	"job/0": [
		[0, "", "Un incarico da corriere ti chiede di trasportare un carico di container sigillati a un'altra stazione. I container vengono caricati nella stiva quando accetti, quindi ti serve abbastanza spazio libero; non si possono vendere. L'incarico è completato quando attracchi alla destinazione con le merci a bordo. A volte i pirati tendono agguati ai corrieri. Le merci consegnate contano per [[medal/5]].", false],
	],
	"job/1": [
		[0, "", "In un incarico di difesa una stazione sta per essere attaccata, e vieni ingaggiato per aiutare i suoi caccia a respingere i predoni. Gli attaccanti sono di solito pirati, altrimenti navi della razza rivale. Vola fino alla stazione e distruggi tutti gli attaccanti; contano anche le uccisioni dei caccia alleati. Gli incarichi più difficili portano più attaccanti.", false],
	],
	"job/10": [
		[0, "", "In un incarico di intercettazione un convoglio di due o tre mercantili con un carico illegale si trova lontano da una stazione, sorvegliato da caccia. Segui i punti di navigazione e distruggi i mercantili. Le loro guardie aspettano lungo il percorso e attorno al convoglio.", false],
	],
	"job/11": [
		[0, "", "Un incarico di trasporto passeggeri ti chiede di portare un gruppo di persone a un'altra stazione. Quando accetti ti servono cabine con abbastanza posto per tutti; finché sono a bordo, le cabine non si possono smontare e lo scafo non si può cambiare. Attracca alla destinazione per farli scendere. La ricompensa base è più bassa, ma ogni passeggero la aumenta. I passeggeri trasportati contano per [[medal/18]].", false],
	],
	"job/12": [
		[0, "", "Una sfida è una gara di tiro proposta da un altro pilota nella Space Lounge. Partite entrambi dalla stessa stazione verso un gruppo di pirati sparsi lungo una rotta, e vince chi ne abbatte di più. Il rivale non può essere distrutto e colpisce con la stessa forza delle tue armi. Vieni pagato solo se fai più uccisioni; il numero di pirati è sempre dispari, quindi non ci sono pareggi.", false],
	],
	"job/2": [
		[0, "", "Un incarico di protezione ti manda a sorvegliare delle navi minerarie al lavoro in un campo di asteroidi vicino a una stazione. Arrivano dei predoni che puntano alla stazione e ai minatori. Distruggili tutti prima che possano annientare i minatori; se tutte le navi minerarie vanno perdute, l'incarico fallisce.", false],
	],
	"job/3": [
		[0, "", "In un incarico di recupero, della merce rubata viene trasportata da una delle navi di un gruppo di pirati vicino a una stazione. Devi riprendere il container senza distruggerlo: metti fuori uso la nave che lo trasporta con un'arma EMP e attira il container con un raggio traente. Uno scanner che mostra il carico ti aiuta a trovare la nave giusta. Il container va perduto se la nave che lo trasporta viene distrutta o se nella tua stiva non c'è posto. Una volta recuperato, torna alla stazione in cui hai accettato l'incarico per essere pagato. Il recupero paga il doppio.", false],
	],
	"job/4": [
		[0, "", "La caccia ai pirati consiste nello sgominare un covo di pirati vicino a una stazione. I pirati aspettano nel campo di asteroidi o lungo una rotta di due o tre punti di navigazione, e si muovono solo quando ti vedono. Segui i punti di navigazione e distruggi tutti i pirati. Una difficoltà più alta significa più pirati.", false],
	],
	"job/5": [
		[0, "", "Un incarico di salvataggio è un'operazione di soccorso: un ostaggio è tenuto a bordo di una delle navi di un gruppo vicino a una stazione. Come in un incarico di recupero, metti fuori uso con l'EMP la nave del rapitore e usa un raggio traente per prendere a bordo l'ostaggio; distruggere quella nave pone fine all'incarico. Poi riporta l'ostaggio alla stazione in cui hai accettato l'incarico. Il salvataggio paga il doppio.", false],
	],
	"job/6": [
		[0, "", "Un incarico di ricercato indica un pericoloso criminale avvistato vicino a una stazione. Il bersaglio aspetta in un punto lontano e reagisce solo quando entri nel suo campo visivo. È molto più resistente di un normale pirata, e lo diventa ancora di più con la difficoltà dell'incarico e il tuo livello di pilota. Distruggilo per riscuotere la taglia.", false],
	],
	"job/7": [
		[0, "", "La rimozione di rottami ti chiede di ripulire una nube di rottami spaziali vicino a una stazione entro circa due minuti. Ogni pezzo va distrutto prima che scada il tempo; alle difficoltà più alte si aggiungono alcuni pirati. Paga meno della maggior parte degli incarichi, ma è rapida, e i rottami distrutti contano per [[medal/10]].", false],
	],
	"job/8": [
		[0, "", "Un incarico di acquisto viene da un acquirente della Space Lounge che vuole una certa quantità di un determinato oggetto. Procurati le merci, dai negozi, dai commercianti o dall'estrazione, e attracca di nuovo alla stazione dell'acquirente con le merci nella stiva. Le merci vengono consegnate e ricevi metà della ricompensa abituale di un incarico più il triplo del valore medio delle merci, quindi un acquirente di solito paga molto più di qualsiasi negozio. Gli acquirenti compaiono dalla [[step/16]] in poi.", false],
	],
	"job/9": [
		[0, "", "Un incarico di scorta ti chiede di proteggere un convoglio di cinque mercantili vicino a una stazione. Mentre i mercantili proseguono, gli attaccanti appostati lungo la loro rotta si avvicinano. Distruggi tutti gli attaccanti. Se tutti i mercantili vanno perduti, l'incarico fallisce. Le scorte pagano un quinto in più della maggior parte degli incarichi.", false],
	],
	"medal/0": [
		[0, "", "[[character/0]] possiede questa medaglia fin dall'inizio della partita, per il suo servizio passato. Non c'è nulla da fare per ottenerla.", false],
	],
	"medal/1": [
		[0, "", "Assegnata per aver raggiunto una stazione con pochissimo scafo rimasto. La verifica avviene durante l'avvicinamento, prima che l'attracco ripari la nave, e considera la resistenza propria dello scafo, non la piastra di corazza. Più bassa è la quota rimasta, migliore è il grado.", false],
	],
	"medal/10": [
		[0, "", "Assegnata per aver distrutto rottami spaziali, come quelli degli incarichi [[job/7]]. Conta ogni pezzo che abbatti.", false],
	],
	"medal/11": [
		[0, "", "Assegnata in base al numero di stazioni diverse a cui hai attraccato.", false],
	],
	"medal/12": [
		[0, "", "Assegnata in base al numero di sistemi diversi che hai visitato. I sistemi nascosti contano una volta raggiunti.", false],
	],
	"medal/13": [
		[0, "", "Assegnata in base al numero di progetti che possiedi. I progetti si comprano dagli agenti nella Space Lounge; vedi [[guide/blueprints]].", false],
	],
	"medal/14": [
		[0, "", "Assegnata in base al numero di progetti diversi che hai completato almeno una volta. Costruire di nuovo lo stesso oggetto non aumenta il conteggio.", false],
	],
	"medal/15": [
		[0, "", "Assegnata in base al tempo trascorso a giocare, in ore. Il gioco conta il tempo passato in volo.", false],
	],
	"medal/16": [
		[0, "", "Assegnata in base al numero di incarichi freelance completati. Gli incarichi falliti o abbandonati non contano.", false],
	],
	"medal/17": [
		[0, "", "Assegnata in base al numero di volte in cui hai attraversato un portale di salto. I salti con un motore di salto non contano.", false],
	],
	"medal/18": [
		[0, "", "Assegnata in base al numero di passeggeri trasportati negli incarichi [[job/11]]. Più spazio nelle cabine significa gruppi più numerosi.", false],
	],
	"medal/19": [
		[0, "", "Assegnata in base ai minuti totali trascorsi occultato. Monta un dispositivo di occultamento e usalo ogni volta che è carico.", false],
	],
	"medal/2": [
		[0, "", "Assegnata per aver estratto tipi diversi di minerale. Ogni tipo conta una volta, a prescindere da quanto ne estrai. Poiché i campi contengono i minerali originari delle vicinanze, dovrai estrarre in diverse parti della galassia.", false],
	],
	"medal/20": [
		[0, "", "Assegnata in base al numero di bombe EMP e armi nucleari lanciate.", false],
	],
	"medal/21": [
		[0, "", "Assegnata in base alle tonnellate di [[item/131]] raccolte con un raggio traente da relitti e navi fuori uso.", false],
	],
	"medal/22": [
		[0, "", "Una medaglia a grado unico per aver volato senza alcuna arma, o senza alcun equipaggiamento, montato, verificata al successivo attracco. Non si può ottenere all'inizio della storia: fino alla [[step/8]] la nave conta sempre come armata.", false],
	],
	"medal/23": [
		[0, "", "Assegnata in base al numero di armi primarie montate contemporaneamente, verificato quando attracchi. Per i gradi più alti serve uno scafo con molti slot primari. Come [[medal/22]], conta solo dalla [[step/8]] in poi.", false],
	],
	"medal/24": [
		[0, "", "Assegnata in base alle tonnellate di carico prese con un raggio traente da relitti e navi fuori uso.", false],
	],
	"medal/25": [
		[0, "", "Assegnata in base alla somma più alta di crediti che hai posseduto in un dato momento. Spendere denaro in seguito non la toglie.", false],
	],
	"medal/26": [
		[0, "", "Assegnata per aver parlato con gli ospiti della Space Lounge che hanno qualcosa da offrire. Ogni ospite conta una volta, la prima volta che gli parli.", false],
	],
	"medal/27": [
		[0, "", "Assegnata in base al numero di gregari che hai ingaggiato nella Space Lounge, contando ogni pilota di ciascun gruppo.", false],
	],
	"medal/28": [
		[0, "", "Una medaglia a grado unico per aver messo contro di te una delle quattro grandi razze, spingendo una delle due scale di reputazione oltre 60 in una delle due direzioni. Vedi [[guide/combat]].", false],
	],
	"medal/29": [
		[0, "", "Assegnata in base al numero di asteroidi distrutti dalle tue armi. Gli asteroidi spezzati durante l'estrazione non contano.", false],
	],
	"medal/3": [
		[0, "", "Assegnata per aver estratto tipi diversi di nucleo. I nuclei si ottengono solo trivellando tutti e sette gli strati di un asteroide di classe A, quindi servono pazienza e un buon laser minerario, oltre ai viaggi.", false],
	],
	"medal/30": [
		[0, "", "Una medaglia a grado unico assegnata per aver completato la storia.", false],
	],
	"medal/31": [
		[0, "", "Assegnata in base al massimo spazio di carico libero che hai avuto in un dato momento. Uno scafo grande con unità di compressione del carico e una stiva vuota fa ottenere i gradi più alti.", false],
	],
	"medal/32": [
		[0, "", "Assegnata in base al numero di offerte che hai rifiutato con \"No, thanks\" (No, grazie) nella Space Lounge.", false],
	],
	"medal/33": [
		[0, "", "Assegnata in base al numero di volte in cui hai chiesto a un ospite della Space Lounge di ripetere un'offerta con \"How was that again?\" (Come hai detto?)", false],
	],
	"medal/34": [
		[0, "", "Assegnata per aver accettato incarichi presso altre stazioni senza prima chiedere al cliente se saranno difficili.", false],
	],
	"medal/35": [
		[0, "", "Assegnata per aver accettato incarichi presso altre stazioni senza prima chiedere al cliente di mostrare la destinazione sulla mappa.", false],
	],
	"medal/36": [
		[0, "", "Assegnata automaticamente quando possiedi tutte le altre medaglie, di qualsiasi grado. Possederle tutte comporta anche altre ricompense; vedi [[guide/medals]].", false],
	],
	"medal/4": [
		[0, "", "Assegnata in base al numero di navi che hai distrutto, contate sull'intera partita. Contano pirati, nemici e bersagli degli incarichi.", false],
	],
	"medal/5": [
		[0, "", "Assegnata in base alle tonnellate di merci consegnate negli incarichi [[job/0]]. I carichi grandi contano di più, quindi una stiva capiente aiuta.", false],
	],
	"medal/6": [
		[0, "", "Assegnata in base alle tonnellate totali di minerale estratte nell'intera partita.", false],
	],
	"medal/7": [
		[0, "", "Assegnata in base al numero di nuclei estratti nell'intera partita. Ogni asteroide di classe A trivellato fino in fondo ne fornisce uno.", false],
	],
	"medal/8": [
		[0, "", "Assegnata in base alle tonnellate di alcolici comprate nei negozi delle stazioni. Conta la bevanda locale di ogni sistema.", false],
	],
	"medal/9": [
		[0, "", "Assegnata per aver posseduto tipi diversi di alcolici. I tipi vengono contati quando li compri dai commercianti della Space Lounge o li raccogli dai relitti con un raggio traente.", false],
	],
	"ship/0": [
		[0, "", "La [[ship/0]] è lo scafo più debole della tabella delle navi: 95 di corazza, una stiva da 25 t, uno slot primario e uno secondario e tre slot di equipaggiamento. La sua manovrabilità di 140 è rispettabile per una nave iniziale, ma la [[ship/32]], lo scafo più economico in vendita, ha gli stessi slot con più corazza, più spazio di carico e più agilità. Nessun rivenditore offre mai la [[ship/0]]; il giocatore la ottiene solo attraverso la storia.", false],
		[2, "", "[[character/2]] possiede questa ex nave [[faction/8|pirata]] rattoppata e ci mette a bordo [[character/0]] presso [[station/78]], dipinta con i colori dei pirati e dotata di un laser minerario e di un [[item/81]], ma senza armi. Il laser è un suo prototipo, il modello che in seguito vende come [[item/90]].", false],
		[10, "", "Dopo l'attacco al covo dei pirati, [[character/2]] regala definitivamente la nave a [[character/0]], con un motore più potente per viaggiare tra i pianeti del sistema, ma si tiene il laser prototipo. Keith continua a pilotarla anche dopo aver raggiunto lo spazio [[faction/0|terrestre]].", false],
		[18, "", "Presso [[station/98]], [[character/1]] fa riverniciare lo scafo con i colori [[faction/0|terrestri]] perché le pattuglie smettano di scambiarlo per una nave pirata.", false],
	],
	"ship/1": [
		[0, "", "La [[ship/1]] è lo scafo più economico con quattro slot secondari, e ha anche uno slot per torretta, due armi primarie e sette slot di equipaggiamento. Corazza (192) e stiva (65 t) sono solide. La sua manovrabilità di 106 è lenta, quindi combatte meglio con siluri e torretta. Con un po' di denaro in più la [[ship/9]] offre molta più corazza e agilità, ma nessuna torretta e solo due slot secondari.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/10": [
		[0, "", "La [[ship/10]] è la nave di [[character/0]] nella scena iniziale, armata con due laser [[item/3]]. Unisce una corazza solida (200) e una stiva da 100 t a quattro slot secondari e a una manovrabilità di 150, che la rende molto più agile della [[ship/11]], lo scafo più vicino a lei per prezzo di listino. Il suo punto debole è il basso numero di slot di equipaggiamento: solo cinque. I rivenditori ordinari non la offrono mai.", false],
		[2, "", "Un guasto all'iperpropulsore porta [[character/0]] a [[station/78]], dove [[character/2]] recupera il relitto e lo smonta per ricavarne pezzi. La nave non torna mai nelle mani di Keith.", false],
	],
	"ship/11": [
		[0, "", "La [[ship/11]] è un mercantile pesante ben equipaggiato: una stiva da 180 t, 210 di corazza, uno slot per torretta, due slot primari e due secondari e otto slot di equipaggiamento. La sua manovrabilità di 75 è scarsa. Rispetto alla più economica [[ship/7]] rinuncia a 60 t di spazio di carico in cambio di uno slot secondario e di uno slot di equipaggiamento in più.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/12": [
		[0, "", "La [[ship/12]] è un caccia costruito attorno alle armi secondarie: tre slot secondari, due armi primarie, sei slot di equipaggiamento, 175 di corazza e una manovrabilità di 132. La sua stiva da 30 t è molto piccola, quindi è poco adatta al commercio o all'estrazione mineraria. La [[ship/30]] costa di più e offre meno corazza e uno slot secondario in meno.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/16": [
		[0, "", "La [[ship/16]] è un caccia ricco di missili con quattro slot secondari, due armi primarie, dieci slot di equipaggiamento, 180 di corazza e una manovrabilità di 120. La sua stiva da 45 t è piccola. La più cara [[ship/21]] aggiunge altre due armi primarie e uno slot di equipaggiamento.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/17": [
		[0, "", "La [[ship/17]] porta quattro armi primarie, due slot secondari e dieci slot di equipaggiamento. Per una nave del suo prezzo, corazza (145), stiva (65 t) e manovrabilità (95) sono deboli, quindi si affida al suo equipaggiamento, soprattutto scudi e piastre di corazza. La più economica [[ship/19]] ha più corazza e spazio di carico con uno slot di equipaggiamento in meno.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/18": [
		[0, "", "La [[ship/18]] è una nave piccola e agile (manovrabilità 145) con otto slot di equipaggiamento; nessuno scafo più economico ne ha altrettanti. La sua corazza di 115 e la stiva da 28 t sono scarse, e ha solo due slot primari e due secondari. È adatta a un pilota che si affida a scudi, occultamento e altro equipaggiamento più che alla corazza.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/19": [
		[0, "", "La [[ship/19]] è una cannoniera pesante con quattro slot primari, due slot secondari, nove slot di equipaggiamento, 225 di corazza e una stiva da 105 t. La sua manovrabilità di 90 è lenta. È l'unica nave con quattro armi anteriori e una stiva di oltre 100 t.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/2": [
		[0, "", "La [[ship/2]] è una nave versatile e agile tra gli scafi economici: 155 di corazza, una stiva da 52 t, uno slot primario e due secondari, quattro slot di equipaggiamento e una manovrabilità di 150. Eguaglia la [[ship/35]] in tutto tranne che nello spazio di carico, dove trasporta 12 t in più. I piloti che vogliono una seconda arma guardano invece alla [[ship/5]] o alla [[ship/6]].", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/20": [
		[0, "", "La [[ship/20]] è un caccia leggero che concentra sei slot di equipaggiamento in uno scafo piccolo e rapido (manovrabilità 155). Porta due armi primarie ma un solo slot secondario, 125 di corazza e una stiva da 25 t, la più piccola della tabella a pari merito con la [[ship/0]]. È adatta ai piloti che vogliono presto scudi, booster e altro equipaggiamento e non intendono trasportare merci.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/21": [
		[0, "", "La [[ship/21]] è lo scafo più economico con quattro slot primari e quattro secondari. Aggiunge undici slot di equipaggiamento, 195 di corazza e una stiva da 70 t. La sua manovrabilità di 100 è nella media. È una nave da combattimento completa, un gradino sotto la [[ship/29]].", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/22": [
		[0, "", "La [[ship/22]] ha la stiva più grande tra le navi che costano oltre un milione di crediti (130 t), insieme a tre slot primari e tre secondari, nove slot di equipaggiamento e una manovrabilità di 118. La sua corazza di 160 è bassa per il prezzo. È adatta ai piloti che commerciano e combattono con la stessa nave.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/23": [
		[0, "", "La [[ship/23]] è lo scafo più economico con uno slot per torretta, e i suoi 205 di corazza sono il valore più alto tra le navi sotto i 100.000 crediti. Aggiunge due slot primari e due secondari, cinque slot di equipaggiamento, una stiva da 55 t e una manovrabilità di 128, il che la rende una robusta nave versatile di fascia media. Il suo limite principale è il basso numero di slot di equipaggiamento.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/24": [
		[0, "", "La [[ship/24]] è un mercantile armato: tre armi primarie, due slot secondari, una torretta, otto slot di equipaggiamento e una stiva da 95 t. La sua corazza di 170 è nella media, mentre la manovrabilità di 125 è buona per una nave che trasporta così tanto. Si presta altrettanto bene al commercio, all'estrazione mineraria e al combattimento.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/25": [
		[0, "", "La [[ship/25]] è una lanciamissili: quattro slot secondari, otto slot di equipaggiamento e una manovrabilità di 130, ma una sola arma primaria. I suoi 124 di corazza e la stiva da 52 t sono deboli per il prezzo, quindi dipende da siluri e scudi. La [[ship/1]] offre lo stesso numero di slot secondari più una torretta a un terzo del prezzo, con meno slot di equipaggiamento.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/26": [
		[0, "", "La [[ship/26]] è lo scafo più economico con sette slot di equipaggiamento. Per il resto è una nave versatile nella media: 152 di corazza, una stiva da 64 t, due slot primari e due secondari e una manovrabilità di 108. È adatta ai piloti che vogliono un equipaggiamento completo prima di potersi permettere una nave più pesante.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/27": [
		[0, "", "La [[ship/27]] è lo scafo più economico con tre slot primari. Li abbina a 176 di corazza, due slot secondari, sei slot di equipaggiamento e una stiva da 50 t. La sua manovrabilità di 113 è piuttosto lenta, quindi più che superare i nemici in virata scambia colpi con loro.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/28": [
		[0, "", "La [[ship/28]] è la nave versatile più completa in vendita: tre slot primari e quattro secondari, una torretta, dodici slot di equipaggiamento e una stiva da 110 t. Nessun'altra nave acquistabile ha una torretta e così tanti slot di equipaggiamento. La sua corazza di 195 è buona e la manovrabilità di 92 è lenta. La [[ship/29]] combatte meglio ma trasporta molto meno.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/29": [
		[0, "", "La [[ship/29]] è la nave più costosa venduta dai rivenditori ordinari e il loro caccia migliore: quattro slot primari e quattro secondari, dodici slot di equipaggiamento, 240 di corazza e una manovrabilità di 118. La sua stiva da 75 t è modesta, e non ha torretta. Solo la [[ship/8]] la supera in combattimento.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/3": [
		[0, "", "La [[ship/3]] è una nave versatile ed equilibrata per le prime fasi: due slot primari e due secondari, cinque slot di equipaggiamento, 135 di corazza e una stiva da 55 t. La sua manovrabilità di 112 è lenta per una nave piccola. Costa all'incirca quanto la [[ship/6]], che vira molto più rapidamente ma ha meno corazza, meno spazio di carico e uno slot secondario in meno.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/30": [
		[0, "", "La [[ship/30]] è un caccia nella media: 165 di corazza, una stiva da 45 t, due slot primari e due secondari, sei slot di equipaggiamento e una manovrabilità di 128. Per il suo prezzo non ha punti di forza particolari; la più economica [[ship/12]] ha più corazza e uno slot secondario in più, e la [[ship/23]] aggiunge una torretta.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/31": [
		[0, "", "La [[ship/31]] è un mercantile leggero con una stiva da 110 t, uno slot per torretta, due armi primarie e sei slot di equipaggiamento. La sua corazza (156), l'unico slot secondario e la manovrabilità di 102 sono modesti. È in concorrenza con la più economica [[ship/33]], che ha un po' meno spazio di carico e un'arma in meno, ma più corazza e una manovrabilità migliore.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/32": [
		[0, "", "La [[ship/32]] è lo scafo più economico venduto dai rivenditori e il solito primo acquisto. È piccola e poco protetta (100 di corazza, stiva da 30 t, uno slot primario e uno secondario, tre slot di equipaggiamento), ma con una manovrabilità di 160 solo la [[ship/4]] vira più rapidamente. Rispetto alla [[ship/0]] aggiunge un po' di corazza e di spazio di carico ed è più maneggevole. La [[ship/35]] costa circa 8.000 crediti in più e offre una corazza molto migliore, un secondo slot secondario e un quarto slot di equipaggiamento.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/33": [
		[0, "", "La [[ship/33]] è lo scafo più economico con oltre 100 t di spazio di carico (108 t), e aggiunge uno slot per torretta, 176 di corazza e sei slot di equipaggiamento. Con una sola arma primaria e una manovrabilità di 112 è più un mercantile in grado di difendersi che un caccia. La [[ship/31]] è una rivale diretta con una seconda arma e una stiva leggermente più grande, ma è più debole e più lenta.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/34": [
		[0, "", "La [[ship/34]] è una cannoniera con quattro slot primari, uno secondario, sei slot di equipaggiamento, una stiva da 60 t e una manovrabilità di 130. Rispetto alla più economica [[ship/4]] rinuncia a corazza (135 contro 170) e agilità in cambio di più spazio di carico e di uno slot di equipaggiamento in più.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/35": [
		[0, "", "La [[ship/35]] è un caccia leggero in fondo al listino. Per il suo prezzo offre una buona corazza (155), uno slot primario e due secondari, quattro slot di equipaggiamento e una manovrabilità rapida di 150, ma solo una stiva da 40 t. La [[ship/2]] è quasi la stessa nave con 12 t di spazio di carico in più per qualche migliaio di crediti in più, mentre la [[ship/5]] sacrifica l'agilità per più corazza, più carico e una seconda arma.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/36": [
		[0, "", "La [[ship/36]] è il mercantile più grande del gioco, con una stiva da 350 t. Non ha alcuno slot primario e per difendersi deve affidarsi ai suoi quattro slot secondari e a una torretta. Sette slot di equipaggiamento e 200 di corazza sono buoni, ma la sua manovrabilità di 45 è la più bassa della tabella. La [[ship/7]] trasporta meno, ma conserva due armi anteriori e vira meglio.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/4": [
		[0, "", "La [[ship/4]] è lo scafo più economico con quattro slot primari, e con una manovrabilità di 162 è la nave più agile del gioco. I suoi 170 di corazza sono buoni per il prezzo. Il prezzo da pagare è una stiva da 38 t, un solo slot secondario e cinque slot di equipaggiamento, quindi è un puro caccia da duello. Anche la [[ship/34]] porta quattro armi, con più spazio di carico e più slot di equipaggiamento ma meno corazza e meno agilità.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/5": [
		[0, "", "La [[ship/5]] è lo scafo più economico con due slot primari, e i suoi 170 di corazza sono molti per il suo prezzo. Una stiva da 60 t la rende utile anche per i primi commerci e l'estrazione mineraria. Gli svantaggi sono un solo slot secondario, appena quattro slot di equipaggiamento e una manovrabilità lenta di 115. I piloti che preferiscono l'agilità alla corazza scelgono la [[ship/2]] o la [[ship/35]] a un prezzo simile.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/6": [
		[0, "", "La [[ship/6]] è un caccia leggero e veloce con due slot primari, uno secondario, cinque slot di equipaggiamento e una manovrabilità di 148. La sua corazza di 105 è molto sottile; solo la [[ship/0]] e la [[ship/32]] ne hanno meno, quindi punta sulla velocità più che sulla resistenza. A un prezzo quasi identico la [[ship/3]] offre più corazza, più spazio di carico e un secondo slot secondario, a scapito della manovrabilità.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/7": [
		[0, "", "La [[ship/7]] è un mercantile pesante con una stiva da 240 t, 220 di corazza, uno slot per torretta, due armi primarie, uno slot secondario e sette slot di equipaggiamento. Con una manovrabilità di 65 è lenta a virare. Rispetto alla [[ship/36]] rinuncia a 110 t di spazio di carico in cambio di armi anteriori e di una manovrabilità migliore; la più cara [[ship/11]] aggiunge uno slot di equipaggiamento e un secondo slot secondario.", false],
		[0, "", "Qualsiasi rivenditore fuori dai sistemi [[faction/1|Vossk]] può averla in vendita.", false],
	],
	"ship/8": [
		[0, "", "La [[ship/8]] è un caccia [[faction/9|Void]] restaurato e la nave più potente del gioco. I suoi 450 di corazza sono quasi il doppio di quelli di qualsiasi altro scafo, ha quattro slot primari e quattro secondari e quindici slot di equipaggiamento, e la sua manovrabilità di 155 è tra le migliori. L'unico punto debole è una stiva da 30 t. Il suo prezzo di listino di oltre otto milioni di crediti è quasi il doppio di quello della [[ship/29]].", false],
		[0, "", "I rivenditori ordinari non la vendono. Viene offerta solo presso [[station/10]], come prototipo, quando il giocatore possiede tutte le medaglie d'oro (vedi [[guide/medals]]).", false],
	],
	"ship/9": [
		[0, "", "La [[ship/9]] è l'unica nave venduta dai rivenditori [[faction/1|Vossk]], che non vendono nient'altro. I suoi 250 di corazza sono il valore più alto di qualsiasi scafo tranne la [[ship/8]], e li combina con una manovrabilità rapida di 152, due slot primari e due secondari, sette slot di equipaggiamento e una stiva da 65 t. Al suo prezzo è il caccia più resistente disponibile, anche se le mancano la torretta e gli slot aggiuntivi della [[ship/1]].", false],
		[36, "", "[[character/7]] spiega che le navi [[faction/1|Vossk]] sono di norma pilotate solo dalla loro razza; questa nave è l'eccezione, un modello adattato per poter essere venduto alle altre razze.", false],
	],
	"station/0": [
		[0, "", "[[station/0]] ospita il portale di salto di [[system/0]]. Il periodo di attesa della [[step/13]] è archiviato sotto questa stazione, ma quella fase si completa portando a termine incarichi della lounge ovunque, e qui non succede nulla.", false],
	],
	"station/10": [
		[0, "", "[[station/10]] è l'unica stazione di [[system/6]] e ne ospita il portale di salto. Gli incarichi freelance non ti mandano mai qui. L'agente [[agent/3]] vende un progetto nella sua lounge, e quando tutte le medaglie sono d'oro la stazione offre un prototipo della [[ship/8]].", false],
		[23, "", "La stazione è la base di ricerca segreta della Deep Science, guidata da [[character/6]]. [[character/0]] vi arriva con [[character/5]] ([[step/23]]) e ci torna più volte: per pianificare la spedizione contro i Void, per incontrare [[character/20]] e per consegnargli i cristalli.", false],
	],
	"station/18": [
		[0, "", "[[station/18]] è una modesta stazione Vossk in [[system/3]]. L'agente [[agent/12]] vende le coordinate di [[system/0]] nella sua lounge.", false],
	],
	"station/20": [
		[0, "", "[[station/20]] ospita il portale di salto di [[system/4]]. L'agente midoriano [[agent/2]] vende il progetto di un'arma nella sua lounge.", false],
	],
	"station/22": [
		[0, "", "[[station/22]] è la stazione più avanzata di [[system/4]].", false],
		[38, "", "Nella [[step/38]] il convoglio con gli esplosivi niveliani viene avvistato vicino alla stazione, scortato da caccia midoriani. [[character/0]] deve respingere la scorta senza distruggere il convoglio.", false],
	],
	"station/26": [
		[0, "", "[[station/26]] è una stazione Vossk di altissima tecnologia in [[system/5]]. L'agente boboliano [[agent/13]] vende le coordinate di [[system/1]] nella sua lounge.", false],
	],
	"station/27": [
		[36, "", "Vicino a [[station/27]], [[character/7]] e [[character/0]] attaccano un covo di pirati ([[step/36]]); vince chi distrugge più pirati.", false],
		[37, "", "[[character/0]] vince e si guadagna il diritto di scortare il mercantile Vossk. Da qui fa rapporto a [[character/1]].", false],
	],
	"station/29": [
		[35, "", "[[station/29]] è la stazione del comandante Vossk [[character/7]], che ha accettato di fornire un mercantile K'Sarr per l'attacco contro i Void. [[character/0]] lo incontra qui ([[step/35]]).", false],
		[36, "", "[[character/7]] non permette a nessuno tranne un Vossk di pilotare il mercantile e sfida [[character/0]] a dimostrare il suo valore come pilota di scorta.", false],
	],
	"station/3": [
		[0, "", "[[station/3]] è una stazione niveliana ad alta tecnologia nel sistema nascosto [[system/0]]. Nella sua lounge si trova l'agente [[agent/0]], che vende il progetto di un'arma.", false],
	],
	"station/30": [
		[34, "", "[[character/1]] attende presso [[station/30]] ([[step/34]]) con un piano contro la nave madre Void.", false],
		[35, "", "Il piano consiste nel lanciare contro la nave madre un pesante mercantile pieno di esplosivi nucleari niveliani.", false],
		[39, "", "Gli esplosivi recuperati arrivano qui e vengono caricati sul mercantile Vossk. Nella [[step/39]] [[character/1]] illustra l'operazione finale.", false],
	],
	"station/43": [
		[0, "", "[[station/43]] è una piccola stazione terrestre in [[system/8]]. L'agente [[agent/4]] vende il progetto di un razzo economico nella sua lounge.", false],
	],
	"station/48": [
		[24, "", "Vicino a [[station/48]] sono state avvistate navi Void. Nella [[step/24]] [[character/0]] porta qui [[character/6]] per osservarle e raccogliere relitti con un raggio traente.", false],
		[25, "", "Al termine del recupero un wormhole inghiotte la nave di [[character/0]] con [[character/6]] a bordo.", false],
		[27, "", "Quando i due tornano attraverso un altro wormhole, dei caccia Void li seguono, e [[character/0]] deve distruggerli qui prima di tornare a [[station/10]].", false],
	],
	"station/54": [
		[0, "", "[[station/54]] è una stazione Vossk di altissima tecnologia in [[system/10]], un sistema raggiungibile solo con un motore di salto. L'agente Vossk [[agent/5]] vende il progetto di un missile nella sua lounge.", false],
	],
	"station/55": [
		[0, "", "[[station/55]] ospita il portale di salto di [[system/11]].", false],
		[19, "", "Vicino alla stazione vengono trovati i pirati che tengono in ostaggio [[character/5]] per un riscatto. La Deep Science lascia delle bombe EMP nel suo hangar per [[character/0]].", false],
		[22, "", "Dopo il salvataggio [[character/0]] incontra alla stazione l'ufficiale liberato e riceve le coordinate di [[system/6]].", false],
	],
	"station/56": [
		[18, "", "[[station/56]] è il punto d'incontro dove [[character/0]] dovrebbe prendere a bordo un ufficiale della Deep Science ([[step/18]]).", false],
		[19, "", "L'ufficiale non arriva mai. Un messaggio di [[character/1]] riferisce invece che i pirati lo hanno rapito.", false],
	],
	"station/59": [
		[0, "", "[[station/59]] è una piccola stazione nel sistema Vossk [[system/20]]. La sua lounge ospita un terrestre, l'agente [[agent/10]], che vende il progetto di un dispositivo di occultamento.", false],
	],
	"station/61": [
		[0, "", "[[station/61]] è una delle sole due stazioni di [[system/12]]. L'agente Multipod [[agent/6]] vende il progetto di un'arma nucleare nella sua lounge.", false],
	],
	"station/65": [
		[0, "", "[[station/65]] ospita il portale di salto di [[system/13]]. L'agente Cyborg [[agent/14]] vende le coordinate di [[system/10]] nella sua lounge.", false],
	],
	"station/72": [
		[0, "", "[[station/72]] è una piccola stazione terrestre nel sicuro sistema [[system/14]]. L'agente [[agent/7]] vende il progetto di uno scudo nella sua lounge.", false],
	],
	"station/76": [
		[11, "", "[[station/76]] è una stazione di [[system/15]] che ha smesso di rispondere alle chiamate. Nella [[step/11]] [[character/3]] manda [[character/0]] a scoprirne il motivo.", false],
		[12, "", "La stazione è intatta. Il suo equipaggio semplicemente non è in condizione di lavorare, a causa di un carico di neuroalghe consegnato dallo spacciatore [[character/4]], una vecchia conoscenza di [[character/0]].", false],
	],
	"station/78": [
		[0, "", "[[station/78]] è la piccola stazione mineraria del commerciante di minerali niveliano [[character/2]] in [[system/15]]. La storia comincia nella sua orbita.", false],
		[1, "", "La nave danneggiata di [[character/0]] arriva qui alla deriva con l'autopilota, e [[character/2]] la accoglie, pilota compreso.", false],
		[2, "", "[[character/2]] smonta il relitto e mette [[character/0]] al lavoro a estrarre minerale dagli asteroidi vicini con la [[ship/0]].", false],
		[8, "", "Dopo essere sfuggito a un'incursione pirata, [[character/0]] monta la sua prima arma e aiuta [[character/2]] a distruggere il covo dei pirati vicino alla stazione.", false],
		[10, "", "[[character/2]] gli regala poi la nave e lo manda a [[station/79]].", false],
		[0, "", "Più avanti nel gioco [[character/2]] vende il progetto della sua trivella mineraria nella lounge della stazione.", false],
	],
	"station/79": [
		[0, "", "[[station/79]] è una stazione di [[system/15]] e la sede del suo comandante, [[character/3]].", false],
		[10, "", "Nella [[step/9]] [[character/2]] manda qui [[character/0]] per incontrare [[character/3]], un umano che potrebbe aiutarlo a raggiungere lo spazio terrestre.", false],
		[11, "", "[[character/3]] gli spiega che cos'è la [[faction/3|Confederazione Mido]] e, in cambio del suo aiuto, gli chiede di controllare [[station/76]].", false],
		[13, "", "Dopo il rapporto su [[station/76]], [[character/3]] promette di metterlo in contatto con un convoglio terrestre atteso alla stazione.", false],
		[15, "", "Quando il convoglio arriva ([[step/14]]), scambia [[character/0]] per un pirata, ne mette fuori uso la nave e lo prende a bordo.", false],
	],
	"station/8": [
		[0, "", "[[station/8]] è una stazione terrestre nel sistema nascosto [[system/1]]. L'agente niveliano [[agent/1]] vende un progetto nella sua lounge.", false],
	],
	"station/84": [
		[0, "", "[[station/84]] è una stazione terrestre in [[system/16]]. L'agente Vossk [[agent/8]] vende il progetto di una corazza Vossk nella sua lounge.", false],
	],
	"station/88": [
		[0, "", "[[station/88]] è una piccola stazione niveliana in [[system/17]]. L'agente Vossk [[agent/15]] vende le coordinate di [[system/21]] nella sua lounge.", false],
	],
	"station/90": [
		[0, "", "[[station/90]] ospita il portale di salto di [[system/18]]. L'agente [[agent/9]] vende il progetto di un compressore di carico nella sua lounge.", false],
	],
	"station/91": [
		[28, "", "Nella [[step/28]] viene segnalata attività Void vicino a [[station/91]]. Qui [[character/0]] si apre la strada combattendo fino a un wormhole per portare una sonda alla nave madre Void.", false],
		[31, "", "Tornato dal settore Void, [[character/0]] riceve qui una chiamata di [[character/1]], che lo invita a [[station/98]].", false],
	],
	"station/98": [
		[15, "", "[[station/98]] è una stazione terrestre in [[system/19]]. L'incrociatore che ha arrestato [[character/0]] lo porta qui, e lui scopre che al comando c'è il suo vecchio amico [[character/1]].", false],
		[16, "", "Durante la loro conversazione dei caccia Void attaccano la stazione, e [[character/0]] aiuta a respingerli.", false],
		[18, "", "[[character/1]] lo informa sui Void e lo recluta per la Deep Science.", false],
		[32, "", "Nella [[step/31]] [[character/1]] installa sulla nave di [[character/0]] il sistema di allerta precoce e gli parla di [[character/20]].", false],
		[44, "", "Dopo la vittoria [[character/0]] e [[character/1]] festeggiano alla stazione, e [[character/6]] li raggiunge.", false],
		[45, "", "Il mattino dopo [[character/6]] se n'è andata, lasciando un biglietto e un ultimo pagamento da parte della Deep Science.", false],
	],
	"step/0": [
		[0, "", "[[character/0]] insegue una banda di [[faction/8|pirati]] attraverso una fascia di asteroidi per riscuotere la taglia sulle loro teste. Devi trovare e distruggere tutte le navi pirata.", false],
		[1, "", "Sistemati i pirati, Keith fa rotta verso Eden Prime, dove l'ammiraglio Smith vuole vederlo per un incarico speciale. All'avvio dell'iperpropulsore, un ultimo colpo danneggia la nave. Il motore si guasta, il supporto vitale è compromesso e l'autopilota porta il pilota privo di sensi verso la stazione più vicina, [[station/78]].", false],
	],
	"step/1": [
		[1, "", "L'autopilota ha portato la nave danneggiata di Keith in orbita attorno a [[station/78]], con il pilota privo di sensi a bordo.", false],
		[2, "", "Keith si risveglia su una piccola stazione mineraria gestita da [[character/2]], un commerciante di minerali [[faction/2]]. Gunant ha smontato la nave e la rivendica per diritto di recupero. Ride all'idea di raggiungere Eden Prime, che si trova all'estremità opposta della galassia, e si stupisce che Keith non abbia mai sentito parlare dei Void, esseri ostili che ormai compaiono perfino nel sistema [[system/15]].", false],
		[2, "", "Keith non ha né soldi né nave, quindi deve lavorare per Gunant estraendo minerale con un velivolo disarmato.", false],
	],
	"step/10": [
		[10, "", "Keith vola a [[station/79]] per incontrare [[character/3]].", false],
		[11, "", "Norris spiega che [[system/15]] si trova in un settore scoperto di recente. Esuli terrestri e niveliani vi si sono stabiliti durante la guerra civile niveliana e hanno fondato una confederazione indipendente. I Terrestri la riconoscono, ma i Niveliani rivendicano ancora il sistema, e ai suoi confini si combatte.", false],
		[11, "", "Norris si offre di mettere Keith in contatto con la Space Fleet terrestre in cambio di un favore: si sono persi i contatti con la stazione [[station/76]], e serve un pilota esperto per scoprirne il motivo.", false],
	],
	"step/11": [
		[11, "", "Keith vola a [[station/76]] per indagare sul suo silenzio. La stazione sembra intatta, senza segni di combattimento, quindi attracca.", false],
		[12, "", "All'interno Keith si imbatte in [[character/4]], un famigerato spacciatore che conosceva da tempo. Mkkt ha portato un carico di neuroalghe, e l'intero equipaggio è troppo intossicato per occuparsi delle comunicazioni. Keith se ne va appena può.", false],
	],
	"step/12": [
		[12, "", "Keith torna a [[station/79]] per fare rapporto.", false],
		[13, "", "Norris è sconvolto e promette di occuparsi dello spacciatore. Un convoglio militare terrestre è diretto a Kernstal e darà a Keith l'occasione di contattare la flotta. In attesa del suo arrivo, Norris suggerisce a Keith di accettare lavori retribuiti nella Space Lounge (vedi [[guide/lounge]]).", false],
	],
	"step/13": [
		[13, "", "In attesa del convoglio, Keith deve completare due incarichi freelance della Space Lounge (vedi [[guide/jobs]]).", false],
		[14, "", "Norris comunica che il convoglio terrestre è entrato nel sistema e si dirige verso [[station/79]]. Keith parte per andargli incontro.", false],
	],
	"step/14": [
		[14, "", "Vicino a [[station/79]] Keith trova il convoglio terrestre e alcuni pirati. Si avvicina per scacciarli.", false],
		[15, "", "A bordo della sua ex nave pirata, Keith viene scambiato per uno dei predoni. Il convoglio mette fuori uso la sua nave con armi EMP e lo arresta. Viene portato a bordo di un incrociatore terrestre diretto a [[station/98]], nello spazio terrestre.", false],
	],
	"step/15": [
		[15, "", "Keith arriva a [[station/98]] come prigioniero del convoglio.", false],
		[16, "", "L'ufficiale al comando è [[character/1]], un vecchio amico di Keith, ora capo della Interstellar Security Agency. Si scusa per l'errore. Il loro incontro viene interrotto quando dei caccia Void compaiono in orbita e la stazione dà l'allarme.", false],
	],
	"step/16": [
		[16, "", "Brent chiede a Keith di aiutarlo a respingere le navi [[faction/9|Void]] che attaccano [[station/98]] (vedi [[world/voids]]).", false],
		[17, "", "I Void trasmettono un messaggio in cui dichiarano intenzioni pacifiche, ma attaccano comunque. Keith li respinge, e Brent promette di raccontargli tutto ciò che sa davanti a un bicchiere di vino.", false],
	],
	"step/17": [
		[17, "", "Keith attracca a [[station/98]] per sentire che cosa sa Brent dei Void.", false],
		[18, "", "I Void sono comparsi nelle ultime settimane. Arrivano attraverso una specie di wormhole, attaccano tutto ciò che incontrano e sembrano interessati al minerale; vengono razziati perfino i sistemi [[faction/1]]. Brent presiede un'unità di crisi, i cui scienziati si stanno riunendo in una stazione di ricerca segreta gestita dalla Deep Science. Chiede a Keith di volare per loro.", false],
		[18, "", "Il sistema della stazione non compare sulle normali mappe stellari, quindi Keith deve incontrare il tenente Thomas Boyle ([[character/5]]) presso [[station/56]], nel sistema [[system/11]], per ottenere le coordinate. Brent ammette anche che la nave di Keith non è nuova: è stata solo riverniciata per evitare altri equivoci.", false],
	],
	"step/18": [
		[18, "", "Keith vola a [[station/56]] per incontrare Boyle.", false],
		[19, "", "Boyle non è mai arrivato. Brent riferisce che dei pirati lo hanno rapito vicino a [[station/55]] e chiedono un riscatto di cinque milioni di crediti. Brent è disposto a pagare, ma Keith è convinto che i rapitori uccideranno Boyle una volta pagati e si dirige invece verso Kappa.", false],
	],
	"step/19": [
		[19, "", "Keith vola a [[station/55]] per cercare i rapitori.", false],
		[20, "", "Gli scanner di Kappa individuano la nave dei rapitori. Brent ha fatto lasciare delle bombe EMP nell'hangar della stazione, così che Keith possa mettere fuori uso la nave mentre i rapitori credono che stia consegnando il riscatto.", false],
	],
	"step/2": [
		[2, "", "Gunant affida a Keith una nave vecchia e più volte riparata, la [[ship/0]], un'ex nave pirata dotata di un laser minerario e priva di armi. Keith deve estrarre almeno dieci tonnellate di minerale dagli asteroidi vicino a [[station/78]] (vedi [[guide/mining]]).", false],
		[3, "", "Con il minerale a bordo, Gunant gli dice di attraccare per controllare il carico. Senza armi, Keith non ha altra scelta che stare al gioco.", false],
	],
	"step/20": [
		[20, "", "Keith deve attraccare a [[station/55]] e montare le bombe EMP sulla sua nave.", false],
		[21, "", "Con le bombe montate, Keith parte subito.", false],
	],
	"step/21": [
		[21, "", "Un punto di navigazione segnala la nave dei rapitori, che potrebbe non essere sola. Keith deve metterla fuori uso con una bomba EMP invece di distruggerla, e occuparsi di un'eventuale scorta.", false],
		[22, "", "I rapitori credono che il riscatto sia arrivato, finché la bomba non mette fuori uso i loro sistemi. Brent invia una squadra a recuperare Boyle.", false],
	],
	"step/22": [
		[22, "", "Keith attracca a [[station/55]] per incontrare lo scienziato liberato.", false],
		[23, "", "Boyle lo ringrazia. La sua nave è andata perduta, quindi Keith gli offre un passaggio, e Boyle trasferisce al computer di navigazione di Keith le coordinate del sistema [[system/6]], dove si trova la stazione di ricerca.", false],
	],
	"step/23": [
		[23, "", "Keith accompagna Boyle a [[station/10]], nel sistema [[system/6]], dove la dottoressa Paolini li sta aspettando.", false],
		[24, "", "Keith conosce la dottoressa Carla Paolini ([[character/6]]), che dirige il progetto della Deep Science. Vuole studiare la tecnologia Void, a cominciare dai relitti delle loro navi. La Deep Science paga a Keith 20.000 crediti per equipaggiare la nave, e un raggio traente è indispensabile.", false],
		[24, "", "Carla insiste per volare con lui fino a [[station/48]], nel sistema [[system/9]], dove di recente sono stati avvistati dei Void. Keith protesta, ma alla fine cede.", false],
	],
	"step/24": [
		[24, "", "Presso [[station/48]] Carla vuole vedere i Void il più da vicino possibile. I Void annunciano di venire dal futuro e di essere tutto ciò che resta delle civiltà della galassia. Keith deve combatterli e raccogliere i resti delle loro navi con un raggio traente.", false],
		[25, "", "Quando a bordo ci sono abbastanza rottami, Carla chiede di rientrare, ma all'improvviso qualcosa afferra la nave.", false],
	],
	"step/25": [
		[25, "", "Keith e Carla riprendono i sensi lontano da [[station/48]], in una regione dello spazio che nessuno dei due conosce.", false],
		[26, "", "Lì vicino c'è una gigantesca nave madre Void che lancia caccia. Keith conclude che sono passati attraverso un wormhole nel settore d'origine dei Void. Quel wormhole è scomparso, ma sembra che queste aperture collassino e ricompaiano altrove, quindi deve raggiungerne un'altra per tornare a casa.", false],
	],
	"step/26": [
		[26, "", "Il wormhole li riporta a [[station/48]], ma alcuni caccia Void li hanno seguiti. Keith deve distruggerli perché non possano pedinare la nave fino a [[station/10]].", false],
		[27, "", "Eliminati gli inseguitori, i due tornano a Thynome, con un gran bisogno di riposo.", false],
	],
	"step/27": [
		[27, "", "Keith attracca a [[station/10]].", false],
		[28, "", "Due giorni dopo Carla gli chiede di tornare laggiù. La sua squadra ha costruito una sonda che, lanciata contro la nave madre, la analizza e invia i risultati alla nave di Keith. Lei resta a studiare i relitti e lo manda nel sistema [[system/18]], dove sono appena stati segnalati dei Void, per trovare un altro wormhole.", false],
		[28, "", "Keith accetta a una condizione: se tornerà vivo, Carla gli dovrà un appuntamento. Lei acconsente.", false],
	],
	"step/28": [
		[28, "", "Vicino a [[station/91]] arrivano dei caccia Void, e Keith deve raggiungere il wormhole prima che collassi. I Void avvertono che distruggerli significherà distruggere il suo stesso futuro.", false],
		[29, "", "Keith raggiunge il wormhole e lo attraversa, entrando nello spazio Void.", false],
	],
	"step/29": [
		[29, "", "Vicino alla nave madre Keith deve agganciarla come bersaglio, il che lancia la sonda, e poi resistere finché la sonda non completa l'analisi.", false],
		[30, "", "Durante l'attesa i Void trasmettono di nuovo, dicendo di dover trovare un modo per parlare prima che gli umani distruggano loro e, con loro, il proprio futuro. Keith resiste finché il trasferimento dei dati non è completo e se ne va.", false],
	],
	"step/3": [
		[3, "", "Keith attracca a [[station/78]] per consegnare il suo primo carico di minerale.", false],
		[4, "", "Gunant è abbastanza soddisfatto, ma rimanda fuori Keith, stavolta per riempire tutta la stiva. Scherza dicendo che un giorno, se si comporterà bene, Keith potrebbe anche tenersi la nave.", false],
	],
	"step/30": [
		[30, "", "Tornato attraverso il wormhole, Keith attende vicino a [[station/91]].", false],
		[31, "", "Brent lo chiama e gli chiede di fermarsi a [[station/98]], nel sistema [[system/19]], prima di tornare a Thynome, promettendogli una sorpresa. Da lì i dati della sonda potranno essere inviati a Carla.", false],
	],
	"step/31": [
		[31, "", "Keith attracca a [[station/98]] per vedere Brent.", false],
		[32, "", "La squadra di Brent ha sviluppato un sistema di allerta precoce per la mappa stellare. Mostra dove i Void stanno per aprire un wormhole, e il computer di navigazione di Keith viene modificato per riceverlo. Brent vuole che Keith voli in quei luoghi a sostegno delle forze locali, e gli paga 30.000 crediti.", false],
		[32, "", "Brent aggiunge che un [[faction/7|Grey]] di nome [[character/20]], che lavora per la Deep Science, ha chiesto di vedere Keith.", false],
	],
	"step/32": [
		[32, "", "Keith torna a [[station/10]] per incontrare [[character/20]].", false],
		[33, "", "Khador ha studiato i relitti Void. È convinto che il segreto dei wormhole dei Void stia nella struttura di certi cristalli che si trovano solo nel settore Void. Sta sviluppando un motore capace di portare una nave all'istante in qualsiasi punto dello spazio, e chiede a Keith di procurargli almeno 50 di questi cristalli.", false],
		[33, "", "Keith deve entrare ancora una volta in un wormhole, stavolta usando il sistema di allerta precoce di Brent per trovarne uno.", false],
	],
	"step/33": [
		[33, "", "Keith deve raccogliere 50 [[item/164]] nel settore Void e consegnarli a [[station/10]].", false],
		[34, "", "Khador è entusiasta e dà a Keith una copia del suo progetto per il [[item/85]], così che Keith possa costruirsene uno (vedi [[guide/blueprints]]). Un motore simile può raggiungere perfino il settore d'origine dei Void.", false],
		[34, "", "Arriva Carla, troppo occupata per il loro appuntamento. Dice a Keith che lei e Brent hanno messo a punto un piano e lo manda da Brent presso [[station/30]], nel sistema [[system/2]].", false],
	],
	"step/34": [
		[34, "", "Keith vola a [[station/30]] per ascoltare il piano di Brent.", false],
		[35, "", "I dati della sonda mostrano che la nave madre è l'origine dei wormhole. Finora nessun'arma l'ha scalfita, quindi il piano è lanciare nel suo cuore un robusto mercantile carico di esplosivi nucleari niveliani.", false],
		[35, "", "Il mercantile più adatto all'impresa è un K'Sarr dei Vossk. Brent ha concordato di ottenerne uno da [[character/7]], comandante di [[station/29]] nel sistema [[system/5]], nell'ambito di uno scambio segreto di prigionieri. Errkt insiste per incontrare il pilota di persona.", false],
	],
	"step/35": [
		[35, "", "Keith vola nel territorio [[faction/1]] per incontrare [[character/7]] presso [[station/29]].", false],
		[36, "", "Errkt, che si è informato sul passato di Keith, sostiene che solo un Vossk sappia pilotare a dovere una nave Vossk. Poiché la missione non può fallire, pilota lui stesso il mercantile. Prima, però, Keith deve dimostrare la sua abilità di pilota da caccia vicino al pianeta [[station/27]].", false],
	],
	"step/36": [
		[36, "", "Errkt propone una sfida in un covo di pirati vicino a [[station/27]]: vince chi abbatte più pirati.", false],
		[37, "", "Keith vince. Errkt lo riconosce come pilota capace e gli concede l'onore di scortare il mercantile, che porterà al punto d'incontro concordato. Keith chiama Brent per fare rapporto.", false],
	],
	"step/37": [
		[37, "", "Keith contatta Brent da [[station/27]] per riferire dei suoi colloqui con Errkt.", false],
		[38, "", "L'Impero Vossk ha confermato il suo sostegno, e Brent accetta Errkt come pilota. È però sorto un nuovo problema: navi della [[faction/3|Confederazione Mido]], in guerra con i Niveliani, si sono impadronite del convoglio che trasporta gli esplosivi niveliani. È stato avvistato nel sistema [[system/4]] vicino a [[station/22]], e Keith accetta di intercettarlo.", false],
	],
	"step/38": [
		[38, "", "Vicino a [[station/22]] Keith trova il convoglio rubato, scortato da caccia Mido. Deve distruggere la scorta senza danneggiare le navi del convoglio.", false],
		[39, "", "Ripreso il controllo del convoglio, Brent lo affida alle forze di sicurezza locali per il viaggio fino a [[station/30]] e chiede a Keith di tornare anche lui laggiù.", false],
	],
	"step/39": [
		[39, "", "Keith attracca a [[station/30]] per il briefing finale.", false],
		[40, "", "Gli esplosivi vengono caricati sul mercantile Vossk, ed Errkt resta il suo pilota. Alla prossima comparsa dei Void, Keith ed Errkt voleranno sul posto. Errkt punterà al primo wormhole, e Keith lo coprirà e lo seguirà. Brent chiederà rinforzi alla stazione più vicina.", false],
		[40, "", "Errkt dovrà eiettarsi in una capsula di salvataggio poco prima dell'impatto. Keith deve riattraversare il wormhole prima che la nave madre venga distrutta, altrimenti non ci sarà via di ritorno.", false],
	],
	"step/4": [
		[4, "", "Keith torna tra gli asteroidi per estrarre minerale finché la stiva non è piena.", false],
		[5, "", "Mentre è al lavoro, si avvicina una nave pirata. Disarmato, Keith riceve l'ordine di fuggire verso la stazione schivando i colpi.", false],
	],
	"step/40": [
		[40, "", "Usando il sistema di allerta precoce, Keith vola verso un'orbita sotto attacco dei Void. Errkt arriva con il mercantile e si dirige verso il primo wormhole, e il tenente [[character/8]] si unisce a loro con la sua squadra. Keith deve proteggere il mercantile finché non è passato.", false],
		[41, "", "La corazza del mercantile è gravemente danneggiata, ma Errkt raggiunge il wormhole, e Keith lo segue.", false],
	],
	"step/41": [
		[41, "", "La squadra di Baffour non è riuscita ad attraversare il wormhole in tempo, quindi Keith ed Errkt sono soli. Il mercantile è in rotta di collisione con la nave madre, e Keith deve sgombrare il suo percorso dai caccia Void.", false],
		[42, "", "Mentre il mercantile si avvicina, Errkt comunica che la sua capsula di salvataggio è stata colpita. Sceglie di restare sul mercantile e ordina a Keith di andarsene finché c'è tempo. Keith lo saluta e torna indietro.", false],
	],
	"step/42": [
		[42, "", "Keith deve allontanarsi mentre il mercantile di Errkt punta verso il bersaglio.", false],
		[43, "", "Brent riferisce che i wormhole sono collassati in tutto il settore: il piano ha funzionato. Keith gli dice che Errkt non è sopravvissuto, e Brent promette di rendergli onore nel suo rapporto all'Impero Vossk. I due si danno appuntamento per un drink a [[station/98]].", false],
	],
	"step/43": [
		[43, "", "Keith raggiunge Brent a [[station/98]] per festeggiare.", false],
		[44, "", "Dopo diversi drink arriva Carla, in abito da sera, a riscattare l'appuntamento che deve a Keith. Brent li lascia discretamente soli.", false],
	],
	"step/44": [
		[44, "", "Keith si sveglia a [[station/98]] con i postumi della sbornia dopo la notte trascorsa con Carla.", false],
		[45, "", "Carla se n'è andata. Il suo biglietto spiega che è passata a un altro progetto segreto in un luogo che non può rivelare, e che la Deep Science paga a Keith un ultimo compenso di 40.000 crediti. Keith sospetta di essere stato usato fin dall'inizio, e torna al bar.", false],
	],
	"step/45": [
		[45, "", "La storia è conclusa. La nave madre Void è stata distrutta, i wormhole si sono chiusi e [[character/0]] è libero di andare dove vuole. Puoi continuare a volare, commerciare, estrarre minerale e accettare incarichi in tutta la galassia; vedi [[world/history]] per un riassunto dell'intera storia.", false],
	],
	"step/5": [
		[5, "", "Keith deve seminare il pirata e attraccare sano e salvo a [[station/78]].", false],
		[6, "", "Gunant ammette che le incursioni dei pirati sulla sua stazione stanno peggiorando. Keith si offre di occuparsene se avrà delle armi. Gunant decide di tentare un attacco al covo dei pirati vicino alla stazione e apre il suo piccolo hangar, così che Keith possa montare un'arma e una corazza.", false],
	],
	"step/6": [
		[6, "", "Nell'hangar della stazione Keith deve equipaggiare la [[ship/0]] con un'arma e una piastra di corazza (vedi [[guide/fitting]]).", false],
		[7, "", "Gunant approva la scelta. Per precauzione ha impostato le armi di Keith in modo che non possano perforare i suoi scudi. I due si danno appuntamento all'esterno.", false],
	],
	"step/7": [
		[7, "", "Gunant trasmette la rotta per il covo sotto forma di punti di navigazione. Keith deve seguirla e distruggere le navi pirata che vi trova, con Gunant al suo fianco (vedi [[guide/combat]]).", false],
		[8, "", "Il covo ospita molti più pirati del previsto. Gunant vuole ritirarsi, ma Keith continua a combattere e vince. Quando Gunant gli chiede dove abbia imparato a combattere così, Keith risponde di aver servito nella Space Fleet agli ordini dell'ammiraglio Smith. Gunant lo trova strano, perché Keith sembra troppo giovane.", false],
	],
	"step/8": [
		[8, "", "Vinta la battaglia, Keith e Gunant tornano a [[station/78]].", false],
		[9, "", "Gunant ringrazia Keith per avergli salvato la vita e accenna alla tomba dell'ammiraglio Smith su [[station/5]]. Keith è sconvolto: l'ammiraglio è morto di vecchiaia intorno al 3612. Gunant gli rivela allora che l'anno in corso è il 3624, un anno che secondo lui sarà ricordato per i Void.", false],
	],
	"step/9": [
		[9, "", "Scosso dalla notizia, Keith attracca di nuovo a [[station/78]] per chiarire le cose con Gunant.", false],
		[10, "", "Keith si rende conto che sono passati circa 35 anni da quando è stato colpito nella fascia di asteroidi. Gunant sospetta un guasto all'iperpropulsore, dato che da anni quel tipo di motore viene associato a incidenti simili.", false],
		[10, "", "Per ringraziarlo della vittoria sui pirati, Gunant regala la [[ship/0]] a Keith, dotata di un motore più potente per viaggiare tra i pianeti del sistema. Si tiene però il laser minerario, un prototipo costruito da lui stesso. Keith rivela finalmente il suo nome e parte per incontrare il capitano [[character/3]], un comandante umano presso [[station/79]] che può aiutarlo a raggiungere lo spazio [[faction/0]]. Da questo momento la [[chart]] permette di viaggiare all'interno del sistema.", false],
	],
	"system/0": [
		[0, "", "[[system/0]] è un sistema niveliano sul bordo sinistro della mappa. Resta nascosto sulla mappa stellare finché non ne compri le coordinate da [[agent/12]] presso [[station/18]]. Il suo portale presso [[station/0]] lo collega a [[system/2]] e [[system/8]].", false],
		[0, "", "Le stazioni di Suteo sono tra le più avanzate dello spazio niveliano, con [[station/2]] e [[station/4]] al livello tecnologico massimo. L'agente [[agent/0]] vende un progetto presso [[station/3]].", false],
	],
	"system/1": [
		[0, "", "[[system/1]] è un sistema terrestre nell'angolo in basso a sinistra della mappa. Resta nascosto finché non ne compri le coordinate da [[agent/13]] presso [[station/26]]. Il suo portale presso [[station/5]] lo collega a [[system/8]] e [[system/18]].", false],
		[0, "", "Le sue stazioni sono ben sviluppate, con [[station/7]] al livello tecnologico massimo. L'agente [[agent/1]] vende un progetto presso [[station/8]].", false],
		[9, "", "Secondo [[character/2]], l'ammiraglio Smith, il vecchio comandante di [[character/0]], è sepolto su [[station/5]].", false],
	],
	"system/10": [
		[0, "", "[[system/10]] è un sistema Vossk sul lato destro della mappa, classificato come \"Dangerous\" (Pericoloso). Resta nascosto finché non ne compri le coordinate da [[agent/14]], e non ha alcun collegamento tramite portale: solo una nave con un motore di salto può raggiungerlo. Tutte e cinque le sue stazioni sono ai livelli tecnologici più alti.", false],
		[0, "", "L'agente [[agent/5]] vende un progetto presso [[station/54]].", false],
	],
	"system/11": [
		[0, "", "[[system/11]] è un sistema terrestre nella parte centrale alta della mappa, classificato come \"Average\" (Medio). Ha solo tre stazioni. Il suo portale presso [[station/55]] lo collega a [[system/7]], [[system/9]], [[system/14]] e [[system/16]].", false],
		[18, "", "[[character/0]] viene mandato a [[station/56]] per incontrare un ufficiale della Deep Science.", false],
		[19, "", "L'ufficiale, [[character/5]], è stato rapito dai pirati vicino a [[station/55]].", false],
		[22, "", "[[character/0]] lo libera con le bombe EMP ([[step/21]]).", false],
	],
	"system/12": [
		[0, "", "[[system/12]] è un piccolo sistema Vossk con sole due stazioni, sul lato destro della mappa e classificato come \"Average\" (Medio). Il suo portale presso [[station/60]] lo collega a [[system/3]], [[system/5]], [[system/13]] e [[system/14]], unendo così lo spazio Vossk all'est terrestre.", false],
		[0, "", "L'agente Multipod [[agent/6]] vende un progetto presso [[station/61]].", false],
	],
	"system/13": [
		[0, "", "[[system/13]] è un sistema terrestre sul bordo destro della mappa, classificato come \"Risky\" (Rischioso). Il suo portale presso [[station/65]] lo collega a [[system/12]] e [[system/16]].", false],
		[0, "", "L'agente Cyborg [[agent/14]] vende coordinate presso [[station/65]].", false],
	],
	"system/14": [
		[0, "", "[[system/14]] è un sistema terrestre vicino al centro della mappa e uno dei due sistemi della galassia classificati \"Safe\" (Sicuro). Il suo portale presso [[station/70]] lo collega a [[system/3]], [[system/11]], [[system/12]] e [[system/19]]. Le sue stazioni sono per lo più poco avanzate.", false],
		[0, "", "L'agente [[agent/7]] vende un progetto presso [[station/72]].", false],
	],
	"system/15": [
		[0, "", "[[system/15]] è un sistema midoriano in cima alla mappa, classificato come \"Dangerous\" (Pericoloso). Non ha collegamenti tramite portale, quindi una nave può entrarvi o uscirne solo con un motore di salto. Le sue cinque stazioni sono tutte piccole e poco avanzate. Fino alla [[step/16]] i suoi rivenditori di navi restano chiusi e poche navi vanno e vengono.", false],
		[0, "", "La storia comincia qui, presso [[station/78]].", false],
		[11, "", "Il sistema è il territorio della [[faction/3|Confederazione Mido]], fondata da esuli terrestri e niveliani durante la guerra civile niveliana. I Niveliani lo rivendicano ancora, e ai suoi confini si combatte.", false],
		[15, "", "[[character/0]] lascia il sistema come prigioniero a bordo di un incrociatore terrestre dopo la [[step/14]]. Per tornarci in seguito serve un motore di salto.", false],
		[0, "", "[[character/2]] vende un progetto nella lounge di [[station/78]].", false],
	],
	"system/16": [
		[0, "", "[[system/16]] è un sistema terrestre sul lato destro della mappa, classificato come \"Risky\" (Rischioso). Il suo portale presso [[station/80]] lo collega a [[system/11]] e [[system/13]].", false],
		[0, "", "L'agente Vossk [[agent/8]] vende un progetto presso [[station/84]].", false],
	],
	"system/17": [
		[0, "", "[[system/17]] è un sistema niveliano in alto a sinistra sulla mappa, classificato come \"Risky\" (Rischioso), e il sistema più vicino a [[system/15]]. Il suo portale presso [[station/85]] lo collega a [[system/2]], [[system/9]] e [[system/4]]; è l'unica rotta tramite portale verso [[system/4]].", false],
		[0, "", "L'agente Vossk [[agent/15]] vende coordinate presso [[station/88]].", false],
	],
	"system/18": [
		[0, "", "[[system/18]] è un sistema terrestre in fondo alla mappa, classificato come \"Risky\" (Rischioso). Il suo portale presso [[station/90]] lo collega a [[system/1]] e [[system/8]].", false],
		[0, "", "L'agente [[agent/9]] vende un progetto presso [[station/90]].", false],
		[28, "", "Nella [[step/28]] [[character/0]] arriva qui dopo una segnalazione di attività Void vicino a [[station/91]], per infilarsi in un wormhole.", false],
	],
	"system/19": [
		[0, "", "[[system/19]] è un sistema terrestre al centro della mappa, classificato come \"Safe\" (Sicuro). Il suo portale presso [[station/95]] lo collega a [[system/3]], [[system/8]], [[system/9]] e [[system/14]].", false],
		[15, "", "[[station/98]] è il luogo in cui l'incrociatore terrestre porta [[character/0]] dopo l'arresto, e dove ritrova il suo vecchio amico [[character/1]].", false],
		[16, "", "Nemmeno questo sistema sicuro viene risparmiato: una squadriglia Void attacca [[station/98]] ([[step/16]]). [[character/1]] ha lì il suo quartier generale.", false],
	],
	"system/2": [
		[0, "", "[[system/2]] è un sistema niveliano sul lato sinistro della mappa e il crocevia dello spazio niveliano. Il suo portale presso [[station/30]] lo collega a [[system/0]], [[system/8]], [[system/9]] e [[system/17]]. Ha quattro stazioni di livello tecnologico medio.", false],
		[34, "", "Nella [[step/33]] [[character/6]] manda [[character/0]] a [[station/30]], dove [[character/1]] lo aspetta con un nuovo piano. Anche gli ultimi preparativi contro i Void si svolgono lì.", false],
	],
	"system/20": [
		[0, "", "[[system/20]] è un sistema Vossk in basso a destra sulla mappa, classificato come \"Dangerous\" (Pericoloso). Il suo portale presso [[station/62]] lo collega a [[system/5]] e [[system/21]], ed è quindi l'unica rotta tramite portale verso [[system/21]].", false],
		[0, "", "Un terrestre, l'agente [[agent/10]], vende un progetto nella piccola stazione [[station/59]].", false],
	],
	"system/21": [
		[0, "", "[[system/21]] è un sistema Vossk nell'angolo più lontano in basso a destra della mappa, classificato come \"Dangerous\" (Pericoloso). Resta nascosto finché non ne compri le coordinate da [[agent/15]]. Il suo portale presso [[station/12]] lo collega soltanto a [[system/20]]. Le sue stazioni sono tutte primitive, con livelli tecnologici pari o inferiori a 3.", false],
	],
	"system/3": [
		[0, "", "[[system/3]] è il sistema Vossk più vicino al centro della mappa e il principale ingresso allo spazio Vossk. Il suo portale presso [[station/15]] lo collega a [[system/5]], [[system/12]], [[system/8]], [[system/14]] e [[system/19]]. È classificato come \"Average\" (Medio).", false],
		[0, "", "L'agente [[agent/12]] presso [[station/18]] vende le coordinate del sistema nascosto [[system/0]].", false],
	],
	"system/4": [
		[0, "", "[[system/4]] è un sistema midoriano nell'angolo in alto a sinistra della mappa, classificato come \"Dangerous\" (Pericoloso). È un vicolo cieco: il suo portale presso [[station/20]] raggiunge solo [[system/17]]. Le sue stazioni vanno dalla primitiva [[station/21]] alla ben attrezzata [[station/22]].", false],
		[0, "", "L'agente [[agent/2]] vende un progetto nella lounge di [[station/20]].", false],
		[38, "", "Nella [[step/38]] un convoglio rubato che trasporta esplosivi niveliani viene rintracciato in questo sistema, vicino a [[station/22]].", false],
	],
	"system/5": [
		[0, "", "[[system/5]] è un sistema Vossk in basso a destra sulla mappa, classificato come \"Risky\" (Rischioso). Il suo portale presso [[station/25]] lo collega a [[system/3]], [[system/12]] e [[system/20]]. L'agente [[agent/13]] vende coordinate presso [[station/26]].", false],
		[35, "", "Il sistema è la base del comandante Vossk [[character/7]], presso [[station/29]], dove [[character/0]] lo incontra ([[step/35]]).", false],
		[36, "", "La loro sfida si svolge vicino a [[station/27]].", false],
	],
	"system/6": [
		[0, "", "[[system/6]] è un sistema terrestre in alto a destra sulla mappa, classificato come \"Dangerous\" (Pericoloso). Non compare sulle normali mappe stellari, e solo la storia ne rivela le coordinate. Ospita un'unica stazione, [[station/10]], il cui portale lo collega soltanto a [[system/7]].", false],
		[23, "", "Il sistema nasconde la stazione di ricerca segreta della Deep Science. [[character/5]] ne dà le coordinate a [[character/0]] ([[step/22]]), e lì viene pianificata gran parte della lotta contro i Void.", false],
	],
	"system/7": [
		[0, "", "[[system/7]] è un sistema terrestre in alto a destra sulla mappa, classificato come \"Risky\" (Rischioso). Il suo portale presso [[station/35]] lo collega a [[system/11]] e al nascosto [[system/6]], ed è quindi l'unica rotta tramite portale verso il sistema nascosto. [[station/37]] è la sua stazione più avanzata.", false],
	],
	"system/8": [
		[0, "", "[[system/8]] è un sistema terrestre nel quadrante in basso a sinistra della mappa e il sistema meglio collegato della galassia. Il suo portale presso [[station/40]] lo collega a sei sistemi: [[system/0]], [[system/1]], [[system/2]], [[system/3]], [[system/18]] e [[system/19]]. È classificato come \"Average\" (Medio).", false],
		[0, "", "L'agente [[agent/4]] vende un progetto presso [[station/43]].", false],
	],
	"system/9": [
		[0, "", "[[system/9]] è un sistema niveliano nella parte centrale alta della mappa, classificato come \"Average\" (Medio). Il suo portale presso [[station/45]] lo collega a [[system/2]], [[system/11]], [[system/17]] e [[system/19]].", false],
		[24, "", "Vicino a [[station/48]] viene segnalata attività Void, e [[character/0]] e [[character/6]] vi si recano ([[step/24]]) per raccogliere relitti.", false],
	],
	"world/galaxy": [
		[0, "Panoramica", "Il gioco si svolge in un'unica galassia di 22 sistemi stellari. Ogni sistema appartiene a una fazione, ha un livello di sicurezza e ospita da una a cinque stazioni spaziali. Ogni stazione orbita attorno a un pianeta e ha il proprio negozio, il proprio hangar e la propria Space Lounge. I sistemi sono distribuiti su una mappa piatta, e si viaggia dall'uno all'altro attraverso una rete di portali di salto.", false],
		[0, "", "Quattro popoli possiedono i sistemi cartografati. I [[faction/0|Terrestri]] ne controllano dieci, i [[faction/1]] sei, i [[faction/2|Niveliani]] quattro e i [[faction/3|Midoriani]] due. Membri di razze minori, come i [[faction/4|Multipod]], i [[faction/5|Cyborg]], i [[faction/6|Boboliani]] e i [[faction/7]], vivono in mezzo a loro senza un territorio proprio. I [[faction/8|pirati]] scorrazzano in ogni sistema, e fin dall'inizio circolano voci su una forza ostile chiamata [[faction/9|Void]].", false],
		[0, "Disposizione", "I sistemi niveliani e midoriani si trovano in alto a sinistra sulla mappa, attorno a [[system/15]], [[system/4]], [[system/17]] e [[system/2]]. Lo spazio terrestre si estende al centro, sul lato destro e in basso, con [[system/19]] e [[system/14]] come cuore. I sistemi Vossk formano un blocco separato in basso a destra, che comincia con [[system/3]] e finisce nell'angolo più lontano con [[system/21]].", false],
		[0, "", "Le rotte dei portali favoriscono il centro. [[system/8]] ha sei collegamenti, più di qualsiasi altro sistema, e [[system/19]], [[system/14]], [[system/3]] e [[system/11]] collegano ciascuno quattro o cinque sistemi. I sistemi ai margini, come [[system/4]], [[system/6]] e [[system/21]], sono vicoli ciechi con un solo collegamento.", false],
		[0, "Viaggi", "All'interno di un sistema, il normale motore di una nave la porta dall'orbita di una stazione a quella di un'altra. Per lasciare un sistema, una nave attraversa il suo portale di salto, che si trova presso una delle stazioni del sistema e raggiunge solo i sistemi collegati. I viaggi più lunghi sono catene di salti tra portali. Un motore di salto è l'unico modo per evitare la rete dei portali e raggiungere direttamente qualsiasi sistema conosciuto; vedi [[guide/navigation]].", false],
		[33, "", "L'unico motore di salto del gioco è il [[item/85]], che [[character/20]] progetta nel corso della storia. Si costruisce a partire da un progetto e richiede, tra l'altro, dei [[item/164]].", false],
		[0, "Sicurezza", "Ogni sistema è classificato come \"Safe\" (Sicuro), \"Average\" (Medio), \"Risky\" (Rischioso) o \"Dangerous\" (Pericoloso). La classificazione determina quanto spesso dei predoni ti tendono un agguato vicino a una stazione al tuo arrivo. In un sistema \"Dangerous\" li incontri quasi a ogni visita; in uno \"Safe\" sono rari. Di solito i predoni sono pirati, ma a volte sono navi della razza rivale della fazione. I sistemi più sicuri, d'altra parte, mantengono più navi di pattuglia locali attorno alle loro stazioni.", false],
		[0, "Fazioni e reputazione", "La tua reputazione è registrata su due scale: una tra Terrestri e Vossk, l'altra tra Niveliani e Midoriani. Guadagnare il favore di una parte di una coppia costa il favore dell'altra. Se la tua reputazione presso una fazione scende troppo, le sue navi ti attaccano a vista e le sue stazioni ti respingono. Pirati e Void sono sempre ostili. Un diplomatico in una Space Lounge può riparare la tua reputazione a pagamento.", false],
		[0, "Sistemi nascosti", "Non tutti i sistemi compaiono subito sulla mappa stellare. [[system/0]], [[system/1]], [[system/10]] e [[system/21]] restano nascosti finché non ne compri le coordinate da un agente in una Space Lounge; vedi [[guide/lounge]]. Un altro sistema, [[system/6]], manca dalle normali mappe stellari e viene rivelato solo dalla storia.", false],
		[23, "", "Le coordinate di [[system/6]] ti arrivano tramite [[character/5]] ([[step/22]]). Il sistema ospita un'unica stazione, [[station/10]], la base di ricerca segreta dell'organizzazione Deep Science.", false],
		[0, "", "Due sistemi non hanno alcun collegamento tramite portale: [[system/15]] e [[system/10]]. Una nave può raggiungerli, o lasciarli, solo con un motore di salto.", false],
		[0, "Un inizio isolato", "La storia comincia in [[system/15]], un sistema remoto in cima alla mappa, senza collegamenti tramite portale con il resto della galassia. Il suo commercio è povero, le sue stazioni sono poco avanzate e i suoi rivenditori di navi restano chiusi per la prima parte della storia. All'inizio, l'unica via d'uscita dal sistema è quella offerta dalla storia.", false],
		[11, "", "[[system/15]] è la patria della [[faction/3|Confederazione Mido]], un gruppo di profughi e fuorilegge terrestri e niveliani che si sono stabiliti in questo settore appena cartografato durante la guerra civile niveliana. La Confederazione si è dichiarata indipendente. I Terrestri lo accettano; i Niveliani rivendicano ancora il sistema, e per questo ai suoi confini si continua a combattere.", false],
		[15, "", "[[character/0]] lascia [[system/15]] a bordo di un incrociatore terrestre dopo che il convoglio presso [[station/79]] ne ha messo fuori uso la nave e lo ha arrestato ([[step/14]]). Arriva a [[station/98]] in [[system/19]], nel cuore dello spazio terrestre.", false],
		[9, "Il salto nel tempo", "Quando [[character/0]] si risveglia in [[system/15]], crede che sia passato poco tempo. In realtà il suo iperpropulsore danneggiato lo ha scagliato attraverso la galassia e circa 35 anni nel futuro. La galassia che conosceva è cambiata: i vecchi amici sono invecchiati o morti, e nel frattempo sono stati colonizzati nuovi settori, tra cui quello in cui si trova ora.", false],
		[10, "", "Iperpropulsori difettosi del suo tipo hanno già causato in passato salti simili nel tempo e nello spazio.", false],
		[18, "Oltre la mappa", "I Void entrano nei sistemi cartografati attraverso una specie di wormhole. Razziano allo stesso modo lo spazio terrestre, niveliano e Vossk e sembrano interessati al minerale. Vedi [[world/voids]].", false],
		[25, "", "Un wormhole conduce fuori dalla galassia cartografata, nel settore dei Void, che non ha posto sulla mappa stellare. I wormhole si aprono vicino a una stazione per qualche tempo, poi collassano e compaiono altrove.", false],
		[34, "", "Con il [[item/85]] montato, una nave può anche saltare direttamente nel settore Void.", false],
		[32, "", "Dalla [[step/31]] in poi, un sistema di allerta precoce mostra sulla mappa stellare dove si aprirà il prossimo wormhole.", false],
		[42, "", "Quando la nave madre Void viene distrutta ([[step/41]]), i wormhole collassano in tutto il settore e le incursioni cessano.", false],
	],
	"world/history": [
		[0, "", "La galassia è condivisa da diversi popoli, tra cui i [[faction/0|Terrestri]], i [[faction/2|Niveliani]] e i [[faction/1|Vossk]]. Lo spazio tra le loro stazioni è infestato dai [[faction/8|pirati]]. Questa pagina riassume la storia; ogni parte compare quando il tuo salvataggio la raggiunge.", false],
		[0, "Atto primo: naufrago", "Il cacciatore di taglie terrestre [[character/0]] distrugge una banda di pirati in una fascia di asteroidi ([[step/0]]).", false],
		[1, "", "Un ultimo colpo danneggia il suo iperpropulsore mentre salta via per incontrare il suo vecchio comandante, l'ammiraglio Smith. La nave va alla deriva, con il pilota privo di sensi, fino a [[station/78]].", false],
		[2, "", "Il commerciante di minerali niveliano [[character/2]] recupera il relitto, si tiene la nave e costringe Keith a estrarre minerale per lui.", false],
		[8, "", "Keith aiuta Gunant a distruggere un vicino covo di pirati ([[step/7]]).", false],
		[9, "", "In seguito Keith scopre che è il 3624 e che l'ammiraglio Smith è morto da tempo.", false],
		[10, "", "Un guasto all'iperpropulsore ha portato Keith 35 anni nel futuro e in un angolo remoto della galassia. Gunant gli regala la nave [[ship/0]] e lo manda da [[character/3]] presso [[station/79]].", false],
		[11, "", "Il sistema [[system/15]] appartiene alla [[faction/3|Confederazione Mido]], fondata da esuli terrestri e niveliani durante la guerra civile niveliana.", false],
		[12, "", "Keith scopre che la stazione muta [[station/76]] è stata stordita dalla droga dello spacciatore [[character/4]] ([[step/11]]).", false],
		[15, "", "Quando un convoglio terrestre passa per il sistema, scambia Keith per un pirata, ne mette fuori uso la nave e lo porta a [[station/98]] ([[step/14]]).", false],
		[16, "Atto secondo: la minaccia Void", "Lì ritrova il suo vecchio amico [[character/1]], ora capo della sicurezza, proprio mentre i [[faction/9|Void]] attaccano la stazione.", false],
		[18, "", "I Void razziano i sistemi stellari attraverso dei wormhole in cerca di minerale. Brent recluta Keith come pilota per la Deep Science, un'organizzazione di ricerca segreta che li studia ([[step/17]]).", false],
		[19, "", "Lo scienziato [[character/5]], che doveva guidare Keith alla stazione di ricerca, viene rapito dai pirati.", false],
		[23, "", "Keith mette fuori uso la nave dei rapitori con bombe EMP, lo libera e riceve le coordinate del sistema [[system/6]] ([[step/21]], [[step/22]]).", false],
		[24, "Atto terzo: Deep Science", "Presso [[station/10]] Keith conosce la responsabile del progetto, [[character/6]], e comincia a lavorare per la Deep Science.", false],
		[25, "", "Keith e Carla recuperano relitti Void presso [[station/48]], ma un wormhole inghiotte la loro nave ([[step/24]]).", false],
		[26, "", "Si ritrovano nel settore d'origine dei Void, accanto a una gigantesca nave madre, e fuggono attraverso un altro wormhole.", false],
		[30, "", "Keith torna nel settore Void attraverso un wormhole vicino a [[station/91]] e lancia una sonda contro la nave madre ([[step/29]]).", false],
		[32, "", "Brent dà a Keith un sistema di allerta precoce che mostra dove i Void colpiranno la prossima volta.", false],
		[34, "", "Lo scienziato Grey [[character/20]] fa raccogliere a Keith dei cristalli Void per un nuovo motore istantaneo e gli consegna il relativo progetto ([[step/33]]).", false],
		[35, "Atto quarto: l'attacco", "La sonda rivela che è la nave madre a creare i wormhole. Brent e Carla decidono di distruggerla con un mercantile carico di esplosivi niveliani, fornito dal comandante Vossk [[character/7]].", false],
		[37, "", "Errkt insiste per pilotare personalmente il mercantile, e Keith si guadagna il diritto di scortarlo ([[step/36]]).", false],
		[39, "", "Keith riconquista il convoglio che trasporta gli esplosivi dopo che le navi Mido se ne sono impadronite ([[step/38]]).", false],
		[42, "", "Con i rinforzi guidati da [[character/8]], Keith scorta Errkt attraverso un wormhole. Errkt lancia il mercantile contro la nave madre e muore nell'attacco ([[step/41]]).", false],
		[43, "", "Tutti i wormhole collassano e le incursioni dei Void cessano.", false],
		[45, "Epilogo", "Keith festeggia con Brent e trascorre finalmente una notte con Carla. Lei parte il mattino dopo per un altro progetto segreto, e Keith resta libero di girare la galassia.", false],
	],
	"world/khador": [
		[32, "", "Khador, uno scienziato Grey che lavora per la Deep Science, ha una propria pagina: vedi [[character/20]].", false],
	],
	"world/voids": [
		[0, "", "I [[faction/9|Void]] sono la minaccia centrale della storia. Questa pagina raccoglie ciò che si scopre su di loro; altre informazioni compaiono man mano che il tuo salvataggio avanza.", false],
		[2, "Prime notizie", "Keith sente parlare dei Void per la prima volta da [[character/2]]: esseri ostili che di tanto in tanto compaiono perfino nel remoto sistema [[system/15]].", false],
		[9, "", "Nel sistema Mido ci si aspetta che il 3624 sarà ricordato come l'anno dei Void.", false],
		[16, "", "Dei caccia Void attaccano [[station/98]] nello spazio terrestre ([[step/15]]).", false],
		[17, "", "Durante l'attacco i Void trasmettono un messaggio in cui affermano di venire in pace, ma continuano a sparare.", false],
		[18, "Ciò che si sa", "I Void hanno cominciato a comparire alcune settimane prima. Entrano nei sistemi abitati attraverso dei wormhole, attaccano tutto ciò che incontrano e sembrano interessati al minerale. Vengono razziati perfino i sistemi [[faction/1]]. Nessuno sa da dove vengano né che cosa vogliano.", false],
		[24, "", "Presso [[station/48]] annunciano di venire dal futuro e di essere tutto ciò che resta delle civiltà della galassia.", false],
		[26, "Il settore d'origine", "I loro wormhole conducono a un lontano settore d'origine, dove una gigantesca nave madre lancia caccia. I wormhole restano aperti per poco tempo, poi collassano e ricompaiono altrove.", false],
		[28, "", "I Void avvertono che distruggerli significherebbe distruggere il futuro dell'umanità.", false],
		[30, "", "Ripetono di dover trovare un modo per comunicare prima che gli umani li distruggano, e con loro il proprio futuro. Se questa affermazione sia vera non viene mai chiarito.", false],
		[32, "", "Un sistema di allerta precoce sviluppato dalla squadra di [[character/1]] prevede dove i Void apriranno il prossimo wormhole.", false],
		[33, "", "Lo scienziato Grey [[character/20]] ritiene che alcuni cristalli presenti solo nel settore Void, i [[item/164]], custodiscano il segreto dei loro wormhole.", false],
		[35, "La fine delle incursioni", "La sonda lanciata contro la nave madre rivela che è lei l'origine dei wormhole. Nessun'arma conosciuta è mai riuscita a danneggiarla.", false],
		[42, "", "Un mercantile Vossk carico di esplosivi nucleari niveliani, pilotato da [[character/7]], distrugge la nave madre ([[step/41]]).", false],
		[43, "", "In seguito i wormhole collassano in tutto il settore e le incursioni dei Void cessano, almeno per il momento.", false],
	],
}
