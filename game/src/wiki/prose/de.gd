extends RefCounted
## Reference prose in German. Each block is [story step it appears from,
## section heading or "", text, list item]. See src/wiki/prose.gd.
const PAGES := {
	"guide/basics": {"title": "Erste Schritte", "subtitle": "Leitfaden", "category": "guide", "from": 0},
	"guide/blueprints": {"title": "Baupläne und Produktion", "subtitle": "Leitfaden", "category": "guide", "from": 0},
	"guide/combat": {"title": "Kampf", "subtitle": "Leitfaden", "category": "guide", "from": 0},
	"guide/fitting": {"title": "Schiffe und Ausrüstung", "subtitle": "Leitfaden", "category": "guide", "from": 0},
	"guide/flight": {"title": "Fliegen", "subtitle": "Leitfaden", "category": "guide", "from": 0},
	"guide/jobs": {"title": "Freelance-Aufträge", "subtitle": "Leitfaden", "category": "guide", "from": 0},
	"guide/lounge": {"title": "Space Lounge", "subtitle": "Leitfaden", "category": "guide", "from": 0},
	"guide/medals": {"title": "Medaillen", "subtitle": "Leitfaden", "category": "guide", "from": 0},
	"guide/mining": {"title": "Bergbau", "subtitle": "Leitfaden", "category": "guide", "from": 0},
	"guide/navigation": {"title": "Navigation", "subtitle": "Leitfaden", "category": "guide", "from": 0},
	"guide/trading": {"title": "Handel", "subtitle": "Leitfaden", "category": "guide", "from": 0},
	"step/0": {"title": "Kopfgeld im Asteroidengürtel"},
	"step/1": {"title": "Treibend aufgefunden"},
	"step/10": {"title": "Treffen mit dem Kommandanten"},
	"step/11": {"title": "Eine stille Station"},
	"step/12": {"title": "Bericht an den Kommandanten"},
	"step/13": {"title": "Warten auf den Konvoi"},
	"step/14": {"title": "Der terranische Konvoi"},
	"step/15": {"title": "Verhaftet"},
	"step/16": {"title": "Die Station verteidigen"},
	"step/17": {"title": "Die Geschichte der Voids"},
	"step/18": {"title": "Treffen mit einem Wissenschaftler"},
	"step/19": {"title": "Die Entführung"},
	"step/2": {"title": "Die erste Erzfahrt"},
	"step/20": {"title": "Die Bomben einbauen"},
	"step/21": {"title": "Die Entführer lahmlegen"},
	"step/22": {"title": "Der gerettete Wissenschaftler"},
	"step/23": {"title": "Die geheime Forschungsstation"},
	"step/24": {"title": "Void-Wrackteile bergen"},
	"step/25": {"title": "Verloren in fremdem Raum"},
	"step/26": {"title": "Verfolger abschütteln"},
	"step/27": {"title": "Ein neuer Auftrag"},
	"step/28": {"title": "Erneut ins Wurmloch"},
	"step/29": {"title": "Die Sonde starten"},
	"step/3": {"title": "Das Erz abliefern"},
	"step/30": {"title": "Anruf eines alten Freundes"},
	"step/31": {"title": "Eine versprochene Überraschung"},
	"step/32": {"title": "Der Grey-Wissenschaftler"},
	"step/33": {"title": "Kristalle aus dem Void"},
	"step/34": {"title": "Ein Plan für den Sieg"},
	"step/35": {"title": "Treffen mit dem Vossk-Kommandanten"},
	"step/36": {"title": "Ein Wettstreit der Piloten"},
	"step/37": {"title": "Anruf im Hauptquartier"},
	"step/38": {"title": "Den Konvoi zurückerobern"},
	"step/39": {"title": "Letzte Vorbereitungen"},
	"step/4": {"title": "Ein voller Frachtraum"},
	"step/40": {"title": "Geleit zum Wurmloch"},
	"step/41": {"title": "Angriff auf das Mutterschiff"},
	"step/42": {"title": "Flucht aus dem Void-Raum"},
	"step/43": {"title": "Eine Feier"},
	"step/44": {"title": "Der Morgen danach"},
	"step/45": {"title": "Epilog"},
	"step/5": {"title": "Flucht zur Station"},
	"step/6": {"title": "Das Schiff bewaffnen"},
	"step/7": {"title": "Das Piratenversteck"},
	"step/8": {"title": "Nach der Schlacht"},
	"step/9": {"title": "Abrechnung"},
	"world/galaxy": {"title": "Die Galaxie", "subtitle": "Hintergrund", "category": "world", "from": 0},
	"world/history": {"title": "Geschichte", "subtitle": "Hintergrund", "category": "world", "from": 0},
	"world/voids": {"title": "Die Voids", "subtitle": "Hintergrund", "category": "world", "from": 0},
}
const BLOCKS := {
	"agent/0": [
		[0, "", "[[agent/0]] ist ein nivelianischer Agent in der Lounge der Station [[station/3]] im verborgenen System [[system/0]]. Er verkauft den Bauplan für den Laser [[item/11]].", false],
	],
	"agent/1": [
		[0, "", "[[agent/1]] ist ein nivelianischer Agent in der Lounge der Station [[station/8]] im verborgenen System [[system/1]]. Er verkauft den Bauplan für den Blaster [[item/15]], eine Waffe, die er als selten bezeichnet.", false],
	],
	"agent/10": [
		[0, "", "[[agent/10]] ist ein terranischer Agent, der unter den Vossk lebt, in der Lounge der Station [[station/59]] in [[system/20]]. Er verkauft den Bauplan für die Tarnvorrichtung [[item/96]].", false],
	],
	"agent/11": [
		[0, "", "[[agent/11]] ist der Erzhändler [[character/2]], der in seiner eigenen Lounge auf der Station [[station/78]] in [[system/15]] auftritt. Er verkauft den Bauplan für [[item/90]], seinen eigenen Bergbaulaser, zu einem Preis weit über dem jedes anderen Agenten. Da [[system/15]] keine Torverbindungen hat, braucht man später im Spiel einen Sprungantrieb, um ihn zu erreichen.", false],
		[10, "", "Er begrüßt [[character/0]] als den Zeitreisenden und hat begonnen, den Bohrer herzustellen, den er einst für sich behielt.", false],
	],
	"agent/12": [
		[0, "", "[[agent/12]] ist ein Vossk-Agent in der Lounge der Station [[station/18]] in [[system/3]]. Er verkauft die Koordinaten des verborgenen Systems [[system/0]] und preist dessen viele fortschrittliche Stationen.", false],
	],
	"agent/13": [
		[0, "", "[[agent/13]] ist ein bobolianischer Agent in der Lounge der Station [[station/26]] in [[system/5]]. Er verkauft die Koordinaten des verborgenen Systems [[system/1]].", false],
	],
	"agent/14": [
		[0, "", "[[agent/14]] ist ein Cyborg-Agent in der Lounge der Station [[station/65]] in [[system/13]]. Er verkauft die Koordinaten von [[system/10]], gibt aber zu, keine Ahnung zu haben, wie man dorthin kommt. Ohne Sprungantrieb nützen die Koordinaten nichts, da das System keine Torverbindungen hat.", false],
	],
	"agent/15": [
		[0, "", "[[agent/15]] ist ein Vossk-Agent in der Lounge der Station [[station/88]] in [[system/17]]. Er verkauft die Koordinaten des verborgenen Systems [[system/21]], das er seine Heimat nennt. Sobald es bekannt ist, lässt sich das System per Tor von [[system/20]] aus erreichen.", false],
	],
	"agent/2": [
		[0, "", "[[agent/2]] ist ein midorianischer Agent in der Lounge der Station [[station/20]] in [[system/4]]. Er verkauft den Bauplan für [[item/25]], neben der Rakete von [[agent/4]] den günstigsten Waffenbauplan, den ein Agent anbietet.", false],
	],
	"agent/3": [
		[0, "", "[[agent/3]] ist ein terranischer Agent in der Lounge der Station [[station/10]] in [[system/6]]. Er verkauft den Bauplan für [[item/27]], einen schnell feuernden Massebeschleuniger.", false],
	],
	"agent/4": [
		[0, "", "[[agent/4]] ist ein terranischer Agent in der Lounge der Station [[station/43]] in [[system/8]]. Er verkauft den Bauplan für [[item/33]], den günstigsten Bauplan, den irgendein Agent anbietet.", false],
	],
	"agent/5": [
		[0, "", "[[agent/5]] ist ein Vossk-Agent in der Lounge der Station [[station/54]] in [[system/10]], einem System, das nur ein Sprungantrieb erreicht. Er verkauft den Bauplan für den Lenktorpedo [[item/37]], den kein Laden führt.", false],
	],
	"agent/6": [
		[0, "", "[[agent/6]] ist der einzige Multipode im Spiel. Er sitzt in der Lounge der Station [[station/61]] in [[system/12]] und verkauft den Bauplan für die Atomwaffe [[item/46]].", false],
	],
	"agent/7": [
		[0, "", "[[agent/7]] ist ein terranischer Agent in der Lounge der Station [[station/72]] in [[system/14]]. Er verkauft den Bauplan für [[item/54]], einen starken Schild.", false],
	],
	"agent/8": [
		[0, "", "[[agent/8]] ist ein Vossk-Agent in der Lounge der Station [[station/84]] in [[system/16]]. Er verkauft den Bauplan für [[item/59]], eine Vossk-Panzerplatte, die nie in Läden verkauft wurde. Nach dem Bohrer von [[agent/11]] ist es der teuerste Bauplan, den ein Agent verkauft.", false],
	],
	"agent/9": [
		[0, "", "[[agent/9]] ist ein terranischer Agent in der Lounge der Station [[station/90]] in [[system/18]]. Er verkauft den Bauplan für [[item/67]], einen Frachtkompressor, den er jedem Händler empfiehlt.", false],
	],
	"character/0": [
		[0, "", "[[character/0]] ist der Protagonist und die Figur, die du spielst. Er ist ein [[faction/0|terranischer]] Jagdpilot, der seinen Lebensunterhalt damit verdient, [[faction/8|Piraten]] für das auf sie ausgesetzte Kopfgeld zu jagen. Er ist selbstbewusst, sarkastisch und schnell bereit, sich auf einen Kampf einzulassen.", false],
		[1, "Gestrandet", "Auf dem Weg nach Eden Prime, wo Admiral Smith einen besonderen Auftrag für ihn hat, wird sein Hyperantrieb bei einem Piratenangriff beschädigt. Der Autopilot bringt ihn bewusstlos zur Station [[station/78]].", false],
		[2, "", "Dort wird er vom Erzhändler [[character/2]] gerettet, der sein Schiff als Bergungsgut beansprucht hat und ihn als Bergarbeiter einsetzt.", false],
		[8, "", "Keith ist ein Veteran der terranischen Raumflotte, wo er unter Admiral Smith diente.", false],
		[9, "", "Er erfährt, dass der Admiral an Altersschwäche gestorben ist und man inzwischen das Jahr 3624 schreibt.", false],
		[10, "", "Seit seinem Unfall sind etwa 35 Jahre vergangen, offenbar wegen eines Defekts am Hyperantrieb, und doch ist Keith keinen Tag gealtert. Gestrandet im abgelegenen System [[system/15]] fängt er mit der [[ship/0]] neu an, einem Geschenk von Gunant.", false],
		[16, "Der Krieg gegen die Voids", "Nach einer irrtümlichen Verhaftung trifft er auf der Station [[station/98]] seinen alten Freund [[character/1]] wieder und schlägt seine erste Schlacht gegen die [[faction/9|Voids]].", false],
		[18, "", "Brent wirbt ihn als Piloten für die Forschungsorganisation Deep Science an, die die Voids untersucht.", false],
		[24, "", "Auf der Station [[station/10]] lernt er [[character/6]] kennen, die Leiterin des Projekts, und fühlt sich bald zu ihr hingezogen.", false],
		[26, "", "Er und Carla werden durch ein Void-Wurmloch in den Heimatsektor der Voids gezogen und finden einen Weg zurück.", false],
		[36, "", "Der Vossk-Kommandant [[character/7]] weiß von Keiths früherem Einsatz bei Novaterra.", false],
		[43, "", "Keith eskortiert den Frachter, der das Mutterschiff der Voids zerstört und die Überfälle beendet, auch wenn Errkt bei dem Angriff stirbt.", false],
		[45, "Danach", "Seine Belohnung ist eine Nacht mit Carla, die danach zu einem anderen Geheimprojekt verschwindet und ihm eine letzte Zahlung hinterlässt. Mit erledigtem Auftrag kann Keith frei durch die Galaxie ziehen.", false],
	],
	"character/1": [
		[16, "", "[[character/1]] ist ein alter Freund von Keith aus der Zeit vor seinem Unfall. In den 35 Jahren, die Keith verloren hat, ist Brent zum Lieutenant Commander und Chef der Interstellar Security Agency aufgestiegen. Er ist freundlich, gesprächig und erzählt gern lange persönliche Geschichten.", false],
		[18, "Die Void-Krise", "Als Sicherheitschef leitet er den Krisenstab, der die Reaktion auf die [[faction/9|Voids]] koordiniert. Er wirbt Keith für Deep Science an und sorgt dafür, dass er gut bezahlt wird. Keiths Schiff wird auf seine Anweisung umlackiert.", false],
		[19, "", "Als der Wissenschaftler [[character/5]] entführt wird, unterstützt Brent Keiths Rettungsplan und stellt auf der Station [[station/55]] EMP-Bomben bereit.", false],
		[32, "", "Sein Team entwickelt das Frühwarnsystem, das zeigt, wo die Voids ihr nächstes Wurmloch öffnen.", false],
		[35, "", "Zusammen mit [[character/6]] entwirft er den Plan, das Mutterschiff der Voids mit einem Frachter voller Sprengstoff zu zerstören, und handelt den Austausch mit dem Vossk-Kommandanten [[character/7]] aus.", false],
		[43, "Danach", "Nach der Zerstörung des Mutterschiffs feiert Brent den Sieg mit Keith auf der Station [[station/98]].", false],
	],
	"character/2": [
		[2, "", "[[character/2]] ist ein [[faction/2|nivelianischer]] Erzhändler, der auf der Station [[station/78]] im System [[system/15]] eine kleine Bergbaustation betreibt. Er findet das Wrack des Schiffs von [[character/0]], rettet den Piloten und beansprucht das Schiff als Bergungsgut. Schroff und praktisch veranlagt, lässt er Keith seine Schulden abarbeiten, indem er mit der [[ship/0]], einem alten, selbst zusammengeflickten Schiff, Erz abbaut.", false],
		[8, "", "Als Keith ihm hilft, ein Piratenversteck nahe seiner Station zu zerstören, gewinnt er Gunants Respekt.", false],
		[10, "", "Aus Dankbarkeit schenkt er Keith die [[ship/0]] mit einem besseren Antrieb und schickt ihn zu seinem Freund [[character/3]]. Gunant selbst ist Mitglied der [[faction/3|Mido-Konföderation]]. Er entwirft seine eigenen Bergbaulaser und verkauft als Agent [[agent/11]] den Bauplan für einen davon, [[item/90]].", false],
	],
	"character/20": [
		[32, "", "[[character/20]] ist ein Wissenschaftler der [[faction/7|Grey]], der für Deep Science arbeitet. Er bittet darum, [[character/0]] auf der Station [[station/10]] zu treffen.", false],
		[33, "", "Khador spricht mit ausgesuchter Höflichkeit. Nach der Untersuchung der Void-Wrackteile glaubt er, dass Kristalle, die es nur im Void-Sektor gibt, das Geheimnis der Void-Wurmlöcher bergen. Er hat Jahre damit verbracht, einen Antrieb zu entwickeln, der ein Schiff augenblicklich an jeden Punkt im All tragen soll, und bittet Keith, dafür 50 [[item/164]] zu sammeln.", false],
		[34, "", "Als Keith die Kristalle abliefert, belohnt Khador ihn mit einer Kopie des Bauplans für den Antrieb, der seinen Namen trägt, den [[item/85]].", false],
	],
	"character/3": [
		[10, "", "[[character/3]] ist ein menschlicher Captain, der sich der [[faction/3|Mido-Konföderation]] angeschlossen hat und nun die Station [[station/79]] befehligt. [[character/2]] empfiehlt ihn Keith als jemanden, der ihm zurück in den terranischen Raum helfen kann.", false],
		[11, "", "Norris heißt Keith willkommen und erklärt ihm die Geschichte des Systems [[system/15]]. Er bietet an, Keith mit der terranischen Raumflotte in Kontakt zu bringen, wenn Keith zuvor dem Schweigen der Station [[station/76]] nachgeht.", false],
		[13, "", "Er sorgt dafür, dass Keith einen terranischen Konvoi trifft, der das System durchquert, und schlägt ihm vor, in der Wartezeit Freelance-Aufträge anzunehmen.", false],
	],
	"character/4": [
		[12, "", "[[character/4]] ist ein berüchtigter Dealer, den Keith vor langer Zeit kannte. Keith findet ihn auf der Station [[station/76]], deren gesamte Besatzung er mit Neuro-Algen versorgt hat, einer Droge mit unangenehmen Nebenwirkungen. Mkkt erinnert sich an Keith und wundert sich, warum er nicht gealtert ist.", false],
		[13, "", "Als [[character/3]] Keiths Bericht hört, verspricht er, sich um ihn zu kümmern.", false],
	],
	"character/5": [
		[18, "", "Tommy ist Lt. Thomas Boyle, ein Wissenschaftler im Dienst von Deep Science. [[character/1]] arrangiert, dass er Keith auf der Station [[station/56]] trifft und ihn zur geheimen Forschungsstation der Organisation führt.", false],
		[19, "", "Vor dem Treffen wird Boyle nahe der Station [[station/55]] von Piraten entführt, die Lösegeld für ihn fordern.", false],
		[23, "", "Nachdem Keith das Schiff der Entführer lahmgelegt hat, wird Boyle gerettet. Er gibt Keith die Koordinaten des Systems [[system/6]] und reist mit ihm zur Station [[station/10]].", false],
	],
	"character/6": [
		[23, "", "Dr. Paolini ist die Wissenschaftlerin von Deep Science, die auf der Station [[station/10]] auf Keith und Boyle wartet.", false],
		[24, "", "Dr. Carla Paolini leitet das Projekt von Deep Science über die [[faction/9|Voids]]. Sie ist entschlossen und fleißig und besteht darauf, die Voids mit eigenen Augen zu sehen, deshalb fliegt sie mit [[character/0]] bei seinem ersten Bergungseinsatz mit. Keith fühlt sich vom ersten Treffen an zu ihr hingezogen.", false],
		[26, "", "Sie und Keith werden durch ein Wurmloch in den Heimatsektor der Voids gezogen und entkommen gemeinsam nur knapp.", false],
		[28, "", "Ihr Team baut eine Sonde, um das Mutterschiff der Voids zu analysieren. Sie willigt in ein Date mit Keith ein, falls er lebend von der Mission zurückkehrt.", false],
		[34, "", "Zu sehr mit ihrer Forschung beschäftigt, um das Date wahrzunehmen, arbeitet sie mit [[character/1]] einen Plan für den Angriff auf das Mutterschiff aus.", false],
		[44, "Danach", "Nach dem Sieg kommt sie zu Keith und Brent auf die Station [[station/98]], um das lange aufgeschobene Date nachzuholen.", false],
		[45, "", "Am nächsten Morgen ist sie fort und hinterlässt eine Nachricht: Sie ist zu einem anderen Geheimprojekt aufgebrochen und bittet Keith, nicht nach ihr zu suchen.", false],
	],
	"character/7": [
		[35, "", "[[character/7]] ist ein Kommandant der [[faction/1]] und befehligt die Station [[station/29]] im System [[system/5]]. Er stellt im Austausch gegen Gefangene den K'Sarr-Frachter für den Angriff auf das Mutterschiff der Voids.", false],
		[36, "", "Stolz und förmlich ist er überzeugt, dass nur ein Vossk ein Vossk-Schiff richtig fliegen kann, und besteht darauf, den Frachter selbst zu steuern. Er prüft Keiths Können, bevor er ihn als Eskorte akzeptiert.", false],
		[37, "", "Nachdem Keith ihn in einem Wettstreit bei einem Piratenversteck geschlagen hat, begegnet Errkt ihm mit Respekt.", false],
		[40, "", "Vor der Mission ist er ruhig und in sich gekehrt, was Brent als Entschlossenheit deutet.", false],
		[42, "Tod", "Errkt fliegt den Frachter durch das Wurmloch und in das Mutterschiff. Als seine Rettungskapsel zerstört wird, weigert er sich umzukehren, stirbt in der Explosion und schickt Keith in Sicherheit.", false],
		[43, "", "Brent verspricht, dem Vossk-Imperium von seinem Opfer zu berichten.", false],
	],
	"character/8": [
		[40, "", "Lt. [[character/8]] führt die Verstärkungsstaffel, die sich Keith anschließt, um den Vossk-Frachter auf seinem Weg zum Wurmloch zu schützen.", false],
		[41, "", "Seine Staffel schafft es nicht durch das Wurmloch, bevor es sich schließt, also stellen sich Keith und [[character/7]] den Voids allein.", false],
	],
	"chart": [
		[0, "", "Die Galaxiekarte listet jedes System mit seiner Fraktion, Sicherheitsstufe, Anzahl der Stationen und seiner Position auf der Karte auf. Die Position wird als zwei Zahlen von 0 bis 100 angegeben: Die erste zählt vom linken Rand der Sternenkarte, die zweite vom oberen. Systeme mit ähnlichen Zahlen liegen nahe beieinander.", false],
		[0, "", "Im Spiel öffnest du die Sternenkarte von einer Station aus oder im Flug. Eine gestrichelte Linie verbindet dein aktuelles System mit jedem System, das sein Sprungtor erreicht; die übrigen Torrouten erscheinen als dünne Linien. Sterne, die du gerade erreichen kannst, sind hell, die übrigen gedimmt. Markierungen zeigen das System deiner Story-Mission und deines aktuellen Auftrags, und eine gestrichelte farbige Linie zeigt die kürzeste Torroute dorthin. Eine verblasste goldene Linie zeichnet deine letzten Reisen nach.", false],
		[0, "", "Wähle ein System, um seine Fraktion, Sicherheitsstufe und Entfernung zu sehen. Zoome hinein, um seine Stationen, ihren Techlevel und Markierungen für besuchte Stationen, Missionsziele und das Sprungtor zu sehen. Verborgene Systeme erscheinen erst, wenn du ihre Koordinaten kennst; siehe [[world/galaxy]].", false],
		[32, "", "Sobald du das Frühwarnsystem aus [[step/31]] hast, markiert die Sternenkarte auch das System und die Station, bei der sich das nächste Void-Wurmloch öffnen wird.", false],
	],
	"faction/0": [
		[0, "", "Die Terraner sind Menschen, und [[character/0]] ist einer von ihnen. Sie halten zehn Systeme, mehr als jede andere Fraktion, verteilt über die Mitte, die rechte Seite und den unteren Teil der Karte, mit [[system/19]] und [[system/14]] als Kern. Der terranische Raum ist der sicherste Teil der Galaxie: Beide als „Safe“ (sicher) eingestuften Systeme sind terranisch.", false],
		[0, "", "Terranische Stationen verkaufen die größte Auswahl an Schiffen und Ausrüstung. Schiffshändler außerhalb des Vossk-Raums bieten eine breite Palette von Schiffen an. Die traditionellen Rivalen der Terraner sind die [[faction/1]]: Ansehen, das man bei den einen gewinnt, verliert man bei den anderen.", false],
		[16, "", "Die terranische Raumflotte ist noch immer die Streitmacht, in der [[character/0]] einst diente, doch 35 Jahre sind vergangen. Als er endlich auf einen terranischen Konvoi trifft, hält dieser sein altes, von Piraten gebautes Schiff für einen Feind und verhaftet ihn.", false],
		[18, "", "Die Terraner führen die Verteidigung gegen die Voids an. [[character/1]], inzwischen Leiter der Interstellar Security Agency, leitet einen Krisenstab, und die Forschungsgruppe Deep Science arbeitet von einer geheimen Station aus an dem Problem.", false],
	],
	"faction/1": [
		[0, "", "Die Vossk sind ein außerirdisches Volk, das als Imperium organisiert ist. Sie halten sechs Systeme unten rechts auf der Karte, von [[system/3]] und [[system/12]] bis hinab zum abgelegenen [[system/21]]. Vier davon sind als „Dangerous“ (gefährlich) oder „Risky“ (riskant) eingestuft. [[system/10]] hat überhaupt keine Torverbindung.", false],
		[0, "", "Vossk-Schiffshändler verkaufen nur ein einziges Schiff, die [[ship/9]], ein für andere Rassen angepasstes Modell. Vossk-Stationen führen außerdem Waffen und Ausrüstung, die es sonst nirgends gibt. Die Vossk sind die traditionellen Rivalen der [[faction/0|Terraner]], daher können sich ihre Schiffe im terranischen Raum den Angreifern anschließen und umgekehrt.", false],
		[18, "", "Die Beziehungen zwischen den Terranern und dem Vossk-Imperium bleiben kühl und unberechenbar, doch die Überfälle der Voids treffen auch Vossk-Systeme.", false],
		[36, "", "In der Geschichte erscheinen die Vossk stolz und ehrgebunden. Ihr Kommandant [[character/7]] besteht darauf, den Bombenträger selbst zu fliegen, und prüft [[character/0]] mit einem Wettstreit, bevor er ihn als Eskorte akzeptiert.", false],
		[42, "", "[[character/7]] opfert sein Leben, um das Mutterschiff der Voids zu zerstören, und die Terraner versprechen, dem Vossk-Imperium von seiner Tat zu berichten.", false],
	],
	"faction/2": [
		[0, "", "Die Nivelianer sind ein außerirdisches Volk, das vier Systeme auf der linken Seite der Karte hält: [[system/2]], [[system/9]], [[system/17]] und das verborgene [[system/0]]. Ihre Stationen reichen von kleinen Außenposten bis zu einigen der fortschrittlichsten der Galaxie. Ihre Rivalen sind die [[faction/3|Midorianer]].", false],
		[2, "", "Die erste Person, der [[character/0]] begegnet, ist ein Nivelianer, der Erzhändler [[character/2]]. [[character/0]] hält wenig von nivelianischen Umgangsformen, während [[character/2]] darauf besteht, ein ehrlicher Geschäftsmann zu sein.", false],
		[11, "", "Aus einem nivelianischen Bürgerkrieg ging die [[faction/3|Mido-Konföderation]] hervor. Die Nivelianer haben ihre Unabhängigkeit nie anerkannt und beanspruchen weiterhin das System [[system/15]].", false],
		[35, "", "Der Plan gegen das Mutterschiff der Voids beruht auf nivelianischen Atomsprengstoffen.", false],
	],
	"faction/3": [
		[0, "", "Die Midorianer sind das Volk der [[faction/3|Mido-Konföderation]]. Sie halten zwei Systeme oben links auf der Karte, [[system/15]] und [[system/4]], beide als „Dangerous“ (gefährlich) eingestuft. Ihre Stationen sind meist klein und haben niedrige Techlevel. Ihre Rivalen sind die [[faction/2|Nivelianer]].", false],
		[11, "", "Die Konföderation wurde während des Nivelianischen Bürgerkriegs von terranischen und nivelianischen Flüchtlingen und Gesetzlosen gegründet. Sie hält den Kontakt zu anderen Systemen so gering wie möglich. [[character/3]], Kommandant der Station [[station/79]], ist eines ihrer Mitglieder, ebenso [[character/2]].", false],
		[38, "", "Die Konföderation ist den Nivelianern nicht freundlich gesinnt. Ihre Schiffe kapern den Konvoi mit den nivelianischen Sprengstoffen, die für das Mutterschiff der Voids bestimmt sind, und [[character/0]] muss ihn nahe der Station [[station/22]] zurückerobern.", false],
	],
	"faction/4": [
		[0, "", "Die Multipoden sind eine kleine Rasse ohne eigene Systeme. Der einzige Multipode, dem du begegnest, ist der Agent [[agent/6]], der in der Lounge der Station [[station/61]] im System [[system/12]] einen Bauplan verkauft.", false],
	],
	"faction/5": [
		[0, "", "Die Cyborgs besitzen kein Gebiet. Der einzige Cyborg im Spiel ist der Agent [[agent/14]] in der Lounge der Station [[station/65]], der mit den Koordinaten eines verborgenen Systems handelt.", false],
	],
	"faction/6": [
		[0, "", "Die Bobolianer sind eine kleine Rasse ohne eigene Systeme. Der Agent [[agent/13]], ein Bobolianer, sitzt in der Lounge der Station [[station/26]] im Vossk-Raum und verkauft die Koordinaten eines verborgenen Systems.", false],
	],
	"faction/7": [
		[0, "", "Die Grey sind eine Rasse ohne eigene Systeme, Stationen oder Schiffe. Sie spielen weder im Handel noch im Kampf eine Rolle.", false],
		[32, "", "Der einzige Grey in der Geschichte ist [[character/20]], ein Wissenschaftler, der mit Deep Science zusammenarbeitet.", false],
		[33, "", "Er untersucht die Überreste von Void-Schiffen und entwickelt daraus eine neue Art von Antrieb.", false],
	],
	"faction/8": [
		[0, "", "Piraten sind Gesetzlose aller Rassen. Sie besitzen keine Systeme, tauchen aber überall auf und sind immer feindlich. Wie oft sie nahe einer Station lauern, hängt von der Sicherheitsstufe des Systems ab. Viele Freelance-Aufträge verlangen, sie zu jagen, und ihre Wracks lassen sich nach Fracht plündern.", false],
		[0, "", "Die Geschichte beginnt damit, dass [[character/0]] eine Piratenbande wegen des auf sie ausgesetzten Kopfgelds jagt.", false],
		[2, "", "Die [[ship/0]], das Schiff, das [[character/2]] [[character/0]] leiht, war einst ein Piratenschiff.", false],
		[16, "", "Deshalb halten ihn die Terraner später für einen Piraten.", false],
		[19, "", "Piraten entführen außerdem [[character/5]] nahe der Station [[station/55]] und fordern Lösegeld.", false],
	],
	"faction/9": [
		[0, "", "Die Voids sind eine feindliche Macht, die ohne Vorwarnung angreift. Sie besitzen keine Systeme auf der Karte, und ihre Schiffe eröffnen auf jeden das Feuer. Ihr Jäger, die [[ship/8]], ist das am stärksten gepanzerte Schiff im Spiel. Siehe [[world/voids]].", false],
		[2, "", "In [[system/15]] kennt man die Voids nur aus Gerüchten und seltenen Sichtungen.", false],
		[16, "", "Eine Void-Staffel greift die Station [[station/98]] an, während [[character/0]] dort ist. Ihre Funksprüche beteuern friedliche Absichten, während sie schießen.", false],
		[18, "", "Die Voids kommen durch Wurmlöcher, die sich für kurze Zeit nahe von Stationen öffnen. Sie überfallen terranische, nivelianische und Vossk-Systeme gleichermaßen und scheinen es auf Erz abgesehen zu haben. Niemand weiß, woher sie kommen.", false],
		[24, "", "Bei der Station [[station/48]] senden sie eine noch seltsamere Behauptung: dass sie aus der Zukunft stammen und alles sind, was von den Zivilisationen der Galaxie übrig ist.", false],
		[26, "", "Ein Wurmloch führt in ihren eigenen Sektor, wo ein riesiges Mutterschiff ihre Jäger ausschleust.", false],
		[35, "", "Das Mutterschiff scheint die Quelle der Wurmlöcher zu sein.", false],
		[42, "", "Die Zerstörung des Mutterschiffs in [[step/41]] lässt die Wurmlöcher zusammenbrechen und beendet die Überfälle, zumindest vorerst.", false],
	],
	"guide/basics": [
		[0, "Der Auftakt", "Ein neues Spiel beginnt im All statt auf einer Station. [[character/0]] jagt eine Piratenbande durch ein Asteroidenfeld, und der erste Flug ist ein kurzer Kampf, der Steuern, Zielen und Feuern lehrt. Solange er dauert, werden nur das Fadenkreuz und die Schiffsmarkierungen angezeigt. Zerstöre die Piraten und lass die Szene ablaufen; danach geht die Geschichte von selbst weiter.", false],
		[2, "", "Nach dem Auftakt erwachst du auf der Station [[station/78]], einer kleinen Bergbaustation, die [[character/2]] betreibt. Er leiht dir die [[ship/0]], ein unbewaffnetes Schiff mit Bergbaulaser, und die ersten Schritte lehren Abbau, Autopilot und Andocken. Waffen, die Karte und der Rest der Station werden im Lauf der Geschichte freigeschaltet.", false],
		[0, "Andocken", "Zum Andocken hältst du das Fadenkreuz über eine Station, bis sie erfasst ist, und drückst dann Feuer: Der Autopilot übernimmt und fliegt dich hinein. Du kannst auch selbst in die Station fliegen; das Schiff dockt an, sobald es die Hülle berührt. Beim Andocken wird das meiste abgerechnet. Rumpf, Panzerung und Schilde werden kostenlos wiederhergestellt, Lieferungen und Passagiere übergeben, fertige Bauplan-Waren abgeholt, neue Medaillen verliehen, und das Spiel speichert sich selbst.", false],
		[0, "Stationsmenüs", "Eine Station bietet angedockt sechs Bereiche: „Hangar“, Space Lounge, „Map“ (Karte), „Missions“ (Missionen), „Status“ und „Game Options“ (Spieloptionen). Zu Beginn der Geschichte sind einige davon gesperrt und mit einem Vorhängeschloss markiert. Der „Hangar“ öffnet sich in [[step/5]], „Map“ in [[step/9]], die Space Lounge und „Missions“ in [[step/13]]. „Status“ und „Game Options“ sind immer verfügbar.", false],
		[0, "", "Im „Hangar“ findest du „Shop“ (Laden: Waren und Ausrüstung kaufen und verkaufen), „Ship“ (Schiff: Ausrüstung ein- und ausbauen), „Ships“ (Schiffe: der Schiffshändler, auf Stationen, die einen haben) und „Blueprints“ (Baupläne: Produktion). In der Space Lounge warten Auftraggeber, Händler und Piloten zum Anheuern. „Map“ zeigt die Galaxie und lässt dich ein Ziel wählen. „Missions“ listet das aktuelle Story-Ziel und jeden Freelance-Auftrag auf, den du angenommen hast. „Status“ zeigt deine Pilotenakte, dein Ansehen bei den vier großen Rassen und deine Medaillen. Die obere Leiste zeigt den „Tec Level“ (Techlevel) der Station, der bestimmt, was ihr Laden führen kann.", false],
		[0, "Eine Station verlassen", "Drücke „Depart“ (Abflug), um zu starten. Jeder Flug beginnt mit ein paar Sekunden, in denen du dein Schiff abfliegen siehst, mit den Daten des Systems und einem Tipp; jede Taste, jeder Klick oder jedes Antippen überspringt das. Wenn du vor dem Abflug auf der „Map“ ein Ziel gewählt hast, setzt der Autopilot nach dem Start sofort Kurs darauf. Du kannst nicht mit mehr Fracht abfliegen, als der Frachtraum fassen kann, also verkaufe oder baue das Überzählige vorher ein.", false],
		[0, "Speichern", "Das Spiel speichert automatisch nach jedem abgeschlossenen Andocken, sobald Belohnungen und der nächste Story-Schritt verrechnet sind. Angedockt kannst du auch über „Game Options“ von Hand in einen von drei Speicherplätzen speichern und von dort oder vom Titelbildschirm jeden Speicherplatz oder die Autospeicherung laden. Außerhalb der Browserversion können „Game Options“ einen Spielstand auch in eine Datei exportieren und wieder importieren. Spielstände gehören zu den Spieldaten, mit denen sie erstellt wurden.", false],
		[0, "", "Wird dein Schiff zerstört, endet der Flug, und du machst bei der Station deiner letzten Autospeicherung weiter oder beginnst neu, falls es keine gibt. Alles, was du seit diesem Andocken verdient hast, geht verloren, also docke auf langen Reisen ab und zu an.", false],
		[0, "Pilotenstufe", "Dein Pilot hat eine Stufe, die im „Status“-Bildschirm angezeigt wird. Erfahrung gibt es für Abschüsse, Freelance-Aufträge (je zwei Punkte), abgebaute Kerne, je fünfzig abgebaute Tonnen Erz und je zwei angeheuerte Flügelmänner. Die Stufe steigt um eins, sobald die Erfahrung das 1,3-Fache des Werts beim letzten Aufstieg übersteigt, und wird beim Andocken geprüft. Eine höhere Stufe macht Gegner zäher, erhöht aber auch die Belohnungen für Freelance-Aufträge und die Gebühren angeheuerter Piloten.", false],
	],
	"guide/blueprints": [
		[0, "Baupläne", "Einige der besten Waffen und Ausrüstungsteile werden nie in Läden verkauft. Sie werden stattdessen nach Bauplänen gebaut. Ein Bauplan listet die benötigten Waren und deren Mengen auf. Baupläne kauft man bei namentlichen Agenten in der Space Lounge, die erscheinen, sobald die Geschichte [[step/16]] hinter sich gelassen hat; jeder Agent verkauft einen Bauplan, und zwar nur einmal.", false],
		[34, "", "Den Bauplan für den Sprungantrieb [[item/85]] verkauft niemand: Die Geschichte übergibt ihn in [[step/34]].", false],
		[0, "Produktion", "Die Produktion findet im Reiter „Blueprints“ (Baupläne) des „Hangar“ statt. Wähle einen Bauplan und übergib Zutaten aus deinem Frachtraum. Du kannst sie in Teilen über mehrere Besuche liefern. Die Station, an der du zuerst lieferst, wird zur Produktionsstation für diese Charge. Zutaten, die an einer anderen Station geliefert werden, werden für 10 Credits pro Tonne dorthin verschickt, daher lohnt es sich, alles an denselben Ort zu bringen.", false],
		[0, "Fertige Waren", "Sobald die letzte Zutat geliefert ist, ist die Charge fertig. Sekundärwaffen werden zu zehnt hergestellt, alles andere einzeln. Schließt du an der Produktionsstation ab, wandern die Waren direkt in deinen Frachtraum, selbst wenn er dadurch überfüllt wird. Andernfalls warten sie an der Produktionsstation und werden beim nächsten Andocken dort übergeben. Ein Bauplan wird nie verbraucht: Ist eine Charge fertig, kannst du die nächste beginnen.", false],
		[0, "Medaillen", "Der Besitz von Bauplänen zählt für [[medal/13]], das Fertigstellen verschiedener Baupläne für [[medal/14]].", false],
	],
	"guide/combat": [
		[0, "Primärwaffen", "Primärwaffen sind fest nach vorn feuernde Kanonen: Laser, Blaster, Maschinenkanonen und Thermowaffen. Jede hat ihren eigenen Schaden, ihre Feuerrate, Reichweite und Projektilgeschwindigkeit, und alle eingebauten Primärwaffen feuern gemeinsam. Manche Blaster wie [[item/16]] sind EMP-Waffen, die die Energie eines Schiffs statt seines Rumpfs angreifen. Autofeuer lässt die Kanonen auf das Ziel feuern, ohne dass du die Taste hältst.", false],
		[0, "Schilde, Panzerung und Rumpf", "Schaden leert zuerst den Schild, dann die Panzerplatte und erst danach den Rumpf selbst. Ein Schild lädt sich über seine Ladezeit vollständig wieder auf, Panzerung und Rumpf nicht. Ein Reparaturbot flickt Rumpf und Panzerung während des Fluges langsam. Andocken stellt alles kostenlos wieder her. Ist der Rumpf aufgebraucht, wird das Schiff zerstört.", false],
		[0, "EMP", "Jedes Schiff hat einen Energievorrat. EMP-Waffen entziehen ihn, und ein Schiff ohne Energie ist lahmgelegt: Es treibt hilflos dahin, bis sich die Energie wieder aufgebaut hat. Einem lahmgelegten Schiff kann man mit einem Traktorstrahl die Fracht abnehmen, und manche Aufträge verlangen, ein Schiff lahmzulegen statt zu zerstören. EMP-Schutzausrüstung wie [[item/60]] hat einen Wert für EMP-Abwehr.", false],
		[0, "Sekundärwaffen", "Sekundärwaffen feuern aus den Sekundärplätzen und verbrauchen Munition, die im Platz gestapelt wird. Raketen fliegen geradeaus. Torpedos folgen kurz nach dem Start der Radarerfassung. EMP-Bomben und Atombomben explodieren über einer Fläche und treffen alles in ihrem Wirkungsbereich, zum Rand hin schwächer; EMP-Bomben lassen Asteroiden unberührt, Atombomben zerbrechen sie. Welchen Werfer du benutzt, wählst du im Menü Aktionen; bis dahin feuert die Taste Sekundärwaffe den ersten geladenen.", false],
		[0, "Geschütztürme", "Größere Schiffe haben Plätze für Geschütztürme. Ist ein Turm eingebaut, wechselt die Taste Rücksicht in die Geschützsicht: Das Schiff hält seinen Kurs, während du den Turm herumschwenkst und feuerst, sodass du dich gegen Schiffe in deinem Nacken wehren kannst.", false],
		[0, "Flügelmänner", "Ab [[step/16]] trifft man in der Space Lounge Piloten zum Anheuern. Ein Vertrag umfasst ein bis drei Schiffe für zehn Minuten Flugzeit, und sie fliegen mit dir, wohin du auch gehst, bis er ausläuft. Gib ihnen Befehle über das Menü Aktionen: nach Belieben feuern, dein Ziel angreifen, den nächsten Missionswegpunkt sichern oder zwischen ihrem Laser und EMP-Blaster wechseln. Siehe [[guide/lounge]].", false],
		[0, "Piraten", "Piraten überfallen Stationen, häufiger in gefährlichen Systemen, und lauern Piloten auf, die Fracht oder Passagiere befördern. Viele Freelance-Aufträge drehen sich um den Kampf gegen sie. Wer Piraten abschießt, verärgert niemanden; es verbessert sogar leicht dein Ansehen bei der Rasse, die das System beherrscht.", false],
		[0, "Ansehen", "Dein Ansehen wird auf zwei Skalen von jeweils -100 bis 100 geführt: eine zwischen den Rassen [[faction/0]] und [[faction/1]], die andere zwischen den Rassen [[faction/2]] und [[faction/3]]. Wer einer Rasse Unrecht tut, verschiebt die Skala in Richtung ihres Rivalen: Eines ihrer Schiffe lahmzulegen oder auszurauben kostet 2 Punkte, ein Abschuss 5. Ein erledigter Freelance-Auftrag verschiebt die Skala um 2 Punkte in Richtung der Rasse des Auftraggebers. Sobald eine Skala in einer Richtung 60 überschreitet, wird die Rasse auf der unterlegenen Seite feindlich, und ihre Schiffe greifen dich sofort an.", false],
		[0, "", "Eine feindliche Rasse schickt einen Diplomaten in die Space Lounges, der anbietet, die Skala gegen eine Gebühr auf null zurückzusetzen; die Gebühr wächst damit, wie weit die Skala ausgeschlagen ist, und beträgt höchstens 16.000 Credits. „Status“ zeigt beide Skalen. Wer eine Skala über 60 treibt, erhält außerdem [[medal/28]].", false],
		[0, "Beschuss Verbündeter", "Die Schiffe der Rasse, der ein System gehört, dulden Fehlschüsse nur bis zu einem gewissen Punkt. Sobald du einem örtlichen Schiff ein Drittel seines Rumpfs oder seiner Energie genommen hast, wehrt es sich und warnt dich über Funk. Bei zwei Dritteln seines Rumpfs, oder wenn du es lahmlegst, wendet sich jedes Schiff dieser Rasse im System gegen dich. Die Schiffe anderer Rassen sind weniger empfindlich, doch ein Abschuss kostet immer Ansehen.", false],
	],
	"guide/fitting": [
		[0, "Schiffe", "Das Schiff bestimmt seine Panzerung (die eigene Stärke des Rumpfs), seinen Frachtraum, seine Wendigkeit und seine Plätze: Primärwaffen, Sekundärwaffen, Geschütztürme und Ausrüstung. Ein besseres Schiff bedeutet vor allem mehr Plätze. Die Schiffsseiten vergleichen jedes Schiff.", false],
		[0, "Plätze und der „Ship“-Bildschirm", "Gegenstände werden in den Frachtraum gekauft und dann im „Hangar“ auf dem „Ship“-Bildschirm (Schiff) eingebaut. Jeder Platz nimmt einen Gegenstand seiner Kategorie auf; baust du etwas in einen belegten Platz ein, wandert der alte Gegenstand zurück in den Frachtraum. Ausrüstung lässt sich pro Art nur einmal einbauen, außer bei stapelbaren Arten wie Frachtkompressoren, Kabinen und EMP-Schutz, von denen mehrere eingebaut werden können, jeweils in einem eigenen Platz. Sekundärmunition eines Typs teilt sich einen einzigen Platz. Ein eingebauter Gegenstand kann auch direkt aus seinem Platz zum Preis der Station verkauft werden.", false],
		[0, "Ausrüstungsarten", "Schilde absorbieren Schaden und laden sich wieder auf. Panzerplatten verstärken den Rumpf. EMP-Schutz bewahrt vor Energieentzug. Frachtkompression vergrößert den Frachtraum. Traktorstrahlen ziehen Fracht aus Wracks und lahmgelegten Schiffen heran; ohne einen lässt sich im All nichts einsammeln. Booster geben Geschwindigkeitsschübe. Reparaturbots flicken das Schiff im Flug. Steuerdüsen verbessern die Wendigkeit. Scanner verkürzen die Zeit zum Erfassen eines Ziels, und die besseren zeigen die Fracht eines Ziels. Bergbaulaser bohren Asteroiden an. Kabinen befördern Passagiere. Tarnvorrichtungen verbergen das Schiff eine Zeit lang. Ein Sprungantrieb reist ohne Tore.", false],
		[0, "Ein Schiff kaufen", "Stationen mit Händler zeigen im „Hangar“ einen Reiter „Ships“ (Schiffe) mit bis zu fünf Schiffen zum Verkauf. Händler der [[faction/1]] bieten nur das Schiff ihrer eigenen Rasse an, die [[ship/9]]. Ein Händler zieht den „Tec Level“ (Techlevel) seiner Station in Prozent vom Listenpreis ab, daher verkaufen Hightech-Stationen Schiffe günstiger. Dein altes Schiff wird für vier Fünftel seines Listenpreises in Zahlung genommen. Alles Eingebaute wandert in den Frachtraum, also prüfe, ob es hineinpasst, oder verkaufe vor dem Abflug etwas. Du kannst das Schiff nicht wechseln, solange Passagiere an Bord sind, und Kabinen lassen sich nicht ausbauen, solange sie belegt sind.", false],
		[5, "Erste Waffen", "Wenn sich der Hangar der Station [[station/78]] zum ersten Mal öffnet, liegen in seinem Regal kostenlos ein Laser, eine Maschinenkanone und eine Panzerplatte. Baue eine Kanone und die Platte ein, bevor du zur nächsten Mission aufbrichst.", false],
		[0, "Seltene Schiffe", "Manche Schiffe bieten gewöhnliche Händler nie an. Einem Piloten, der jede Medaille in Gold gewonnen hat, wird auf der Station [[station/10]] ein Prototyp angeboten, die [[ship/8]]; siehe [[guide/medals]].", false],
	],
	"guide/flight": [
		[0, "Steuern", "Das Schiff fliegt immer vorwärts. Du drehst es nach links und rechts und hebst oder senkst seine Nase; lässt du los, richtet es sich von selbst wieder waagerecht aus. Wie schnell es dreht, hängt von der Wendigkeit des Schiffs und einer etwa eingebauten Steuerdüse ab. Unter „Options“ (Optionen), Steuerung kann das Ruderverhalten auf Direkt stehen, das sofort mit voller Rate dreht, oder auf Weich, das Drehungen sanft beginnt und beendet. Bei Maussteuerung können die Links- und Rechts-Tasten das Schiff seitwärts schieben, statt es zu drehen.", false],
		[0, "Schub", "Schub erhöhen und Schub verringern ändern den Schub in Vierteln, und Gedrückthalten der Taste schaltet weiter. Das Schiff braucht etwa eine Sekunde, um die neue Geschwindigkeit zu erreichen. Autopilot und Booster fliegen immer mit vollem Schub, und wer während eines Boosts den Schub verringert, beendet ihn.", false],
		[0, "Booster", "Mit eingebautem Booster gibt die Booster-Taste einen Schub zusätzlicher Geschwindigkeit. Ein Boost dauert so lange, wie der Booster es vorsieht, danach folgt eine Ladezeit bis zum nächsten; das HUD zeigt, ob er bereit ist. Bessere Booster sind schneller, halten länger oder laden schneller nach. Boosten hilft, aus einem Kampf zu fliehen und die großen Entfernungen innerhalb eines Systems zu überbrücken.", false],
		[0, "Autopilot", "Die Autopilot-Taste übergibt das Steuer dem Bordcomputer, ein weiterer Druck holt es zurück. Er fliegt zu dem, was erfasst ist, sonst zu dem auf der „Map“ (Karte) gewählten Ziel: zum Sprungtor, wenn das Ziel in einem anderen System liegt, oder zum Planeten des Ziels in diesem System. Die Autopilot-Liste bietet die Möglichkeiten, die es dort gibt, wo du bist: das programmierte Ziel, das Sprungtor, diese Station, das Asteroidenfeld und den nächsten Missionswegpunkt. Ein Flug zu einer erfassten Station endet mit dem Andocken.", false],
		[0, "Zeitraffer", "Die Zeitraffer-Taste lässt den Flug schneller ablaufen. Doppelte Geschwindigkeit ist während des Fluges immer verfügbar. Vier- und achtfach gibt es nur, solange der Autopilot fliegt, kein Feind in der Nähe ist und nichts anderes im Gange ist, etwa Abbau, Andocken oder ein Sprung.", false],
		[0, "Zielerfassung", "Um ein Objekt zu erfassen, halte es unter dem Fadenkreuz, bis der Scan abgeschlossen ist. Wie lange das dauert, hängt vom eingebauten Scanner ab, von mehreren Sekunden bei einem einfachen Modell bis unter zwei beim besten. Nächstes Ziel schaltet durch Objekte in der Nähe, ohne auf sie zu zielen. Stationen, Sprungtore und die Sterne, die andere Planeten markieren, werden mit einem einzigen Druck erfasst. Was Feuer bewirkt, hängt von der Erfassung ab: Bei einem Schiff schießt es, bei einer Station dockt es an, bei einem Tor springt es, bei einem Stern reist es zu diesem Planeten, und bei einem Asteroiden beginnt der Abbau. Bessere Scanner zeigen auch die Fracht eines erfassten Schiffs.", false],
		[0, "Markierungen und Radar", "Schiffe tragen auf dem Bildschirm Klammern, und Pfeile am Bildschirmrand zeigen auf das Ziel, die Station und nahe Bedrohungen, die außer Sicht sind. Feinde sind rot markiert, Freunde grün, neutrale Schiffe gelb und Missionswegpunkte blau; die Option Farbenblind-freundliche Farben unter „Options“, Oberfläche ersetzt das durch orange Feinde und blaue Freunde. Ein Schiff in deiner Nähe zeigt neben seiner Klammer zwei kleine Balken: seinen Rumpf und, in Blau, seine EMP-Energie. Die erweiterte Fluganzeige fügt Tafeln mit genauen Werten und einen runden Radarschirm hinzu; die originale Anzeige behält die Eckpaneele des Spiels.", false],
		[0, "Umsehen", "Rücksicht dreht die Kamera nach hinten. Ist ein Geschützturm eingebaut, wechselt dieselbe Taste stattdessen in die Geschützsicht: Das Schiff hält seinen Kurs, während du den Turm schwenkst und feuerst. Du kannst dich auch ohne zu steuern um das Schiff umsehen, indem du Alt hältst und die Maus bewegst, mit dem rechten Stick des Gamepads oder indem du einen Finger über freie Bildschirmfläche ziehst.", false],
		[0, "Tarnung", "Eine Tarnvorrichtung verbirgt dein Schiff für ihre Dauer vor anderen Schiffen, und wer dich jagt, verliert sofort deine Spur. Drücke die Taste Tarnvorrichtung erneut, um sie vorzeitig abzuschalten. Nach dem Einsatz muss sie sich aufladen, bevor sie wieder funktioniert.", false],
		[0, "Andocken und Reisen", "Erfasse die Station und drücke Feuer, oder fliege einfach hinein, um anzudocken. Die anderen Stationen des Systems erscheinen als helle Sterne; erfasse einen und drücke Feuer, um zu diesem Planeten zu reisen. Die meisten Systeme haben bei einer ihrer Stationen ein Sprungtor für Reisen in andere Systeme; siehe [[guide/navigation]]. Solange an einer Station ein Freelance-Kampf läuft, kannst du weder andocken, reisen noch wegspringen, bis er gewonnen oder verloren ist.", false],
	],
	"guide/help": [
		[0, "Tastatur", "Dies sind die Standardtasten. Alle Flugaktionen lassen sich unter „Options“ (Optionen), Steuerung, Tastatur neu belegen, wo Standardtasten wiederherstellen Änderungen rückgängig macht.", false],
		[0, "", "Links drehen / Rechts drehen: Pfeiltasten links und rechts oder A und D.", true],
		[0, "", "Nase hoch / Nase runter: Pfeiltasten oben und unten.", true],
		[0, "", "Schub erhöhen / Schub verringern: W und S.", true],
		[0, "", "Feuer / Benutzen: Leertaste oder Strg. Feuert die Kanonen oder dockt an, springt, reist oder baut ab, wenn eine Station, ein Tor, ein Stern oder ein Asteroid erfasst ist.", true],
		[0, "", "Sekundärwaffe: E.", true],
		[0, "", "Booster: Umschalt.", true],
		[0, "", "Autopilot: Q. Autopilot-Liste: R. Ist Autopilot halten für die Liste eingeschaltet, öffnet ein halbsekündiges Halten von Q die Liste.", true],
		[0, "", "Nächstes Ziel: Tab.", true],
		[0, "", "Autofeuer: F.", true],
		[0, "", "Rücksicht: C. Mit eingebautem Geschützturm wechselt die Taste in die Geschützsicht.", true],
		[0, "", "Aktionen / Sprungantrieb: M. Öffnet das Menü Aktionen: Wahl der Sekundärwaffe, Tarnung, Befehle an Flügelmänner und den Sprungantrieb.", true],
		[0, "", "Routenkarte: N.", true],
		[0, "", "Tarnvorrichtung: V.", true],
		[0, "", "Zeitraffer: T.", true],
		[0, "", "Fotomodus: P. Hält den Flug an und blendet die Oberfläche aus; ziehe oder nutze die Pfeiltasten, um die Kamera zu drehen, und das Mausrad oder + und -, um zu zoomen.", true],
		[0, "", "Pausenmenü: Escape. F11 schaltet auf Desktop-Systemen den Vollbildmodus um.", true],
		[0, "", "In Menüs wechseln die Pfeiltasten zwischen Einträgen, Enter wählt aus und Escape geht zurück.", true],
		[0, "Maus", "Ist Maussteuerung eingeschaltet, steuert die Mausbewegung das Schiff. Im Flug wird der Mauszeiger eingefangen, sodass sich das Schiff dreht, während du die Maus bewegst; Mauszeiger im Flug einfangen lässt sich ausschalten, und Menüs und Pausen geben den Zeiger immer frei. Die linke Taste feuert, die rechte startet die Sekundärwaffe, und Alt gedrückt halten beim Bewegen der Maus lässt dich um das Schiff herumsehen. Während die Maus lenkt, schieben die Links- und Rechts-Tasten das Schiff seitwärts; Links-/Rechts-Tasten unter „Options“, Steuerung kann sie auf Immer seitwärts oder Immer drehen stellen. Mausempfindlichkeit legt fest, wie weit sich das Schiff bei einer Bewegung dreht.", false],
		[0, "Gamepad", "Der linke Stick steuert, der rechte Stick dient zum Umsehen um das Schiff. RT oder RB feuert, LB startet die Sekundärwaffe, A boostet, Y schaltet den Autopiloten, X wählt das nächste Ziel, ein Klick auf den rechten Stick gibt die Rück- oder Geschützsicht, Back öffnet das Menü Aktionen und Start pausiert. In Menüs bewegt das D-Pad, A wählt aus und B geht zurück. „Options“, Steuerung, Gamepad stellt die Stick-Totzone und die Vibration ein.", false],
		[0, "Touch", "Auf Touchscreens erscheinen die Steuerelemente auf dem Bildschirm, wenn Touch-Steuerung auf Automatisch oder An steht. Ein Stick auf einer Seite steuert; standardmäßig kommt er zu deinem Daumen, wo immer dieser auf dieser Seite landet, und Stick fest verankert hält ihn an seinem Platz. Überall steuern lässt einen Finger auf jeder freien Stelle des Bildschirms steuern. Tasten auf der anderen Seite decken Feuer / Benutzen, Sekundär, Boost, Autopilot, Ziel, Rücksicht, Aktionen, Pause und, während Funksprüchen, Nächster Funk ab. Ein Schieberegler stellt den Schub ein, und eine Taste Schneller beschleunigt die Zeit.", false],
		[0, "", "Tippe zweimal schnell auf Feuer, um das automatische Feuern einzuschalten; ein Tippen beendet es. Ein Finger, den du über freie Bildschirmfläche ziehst, lässt dich um das Schiff herumsehen, und beim Loslassen blickt die Sicht wieder nach vorn. Linkshänder-Layout tauscht die Seiten, Größe der Touch-Steuerung skaliert die Steuerelemente, und mit Steuerelemente anordnen kannst du jedes einzeln verschieben. Handys und Tablets können auch durch Neigen steuern: Schalte Steuern durch Neigen ein, halte das Gerät wie beim Spielen und kalibriere.", false],
		[0, "Optionen", "„Options“ erreichst du vom Titelbildschirm, vom Pausenmenü und über „Game Options“ (Spieloptionen) auf einer Station. Sie haben fünf Seiten. Audio stellt die Lautstärke von Musik und Ton ein. Anzeige umfasst Fenster, Bildrate, Seitenverhältnis sowie Grafikvoreinstellungen und -details. Steuerung umfasst Lenkung, Maus, Gamepad, Touch und Tastaturbelegung. Oberfläche umfasst Oberflächengröße, die originale oder erweiterte Fluganzeige, HUD-Größe und -Deckkraft, Hilfe-Popups, die Start- und Stationseinfahrtssequenzen, den Radarschirm, Beschriftungen, Textgröße und Einstellungen zur Barrierefreiheit wie farbenblind-freundliche Farben, reduzierte Blitze, Bildschirmwackeln und Nachrichtendauer. Spiel stellt die Engine-Sprache ein und lässt dich eine andere Spieldatei importieren oder Mods verwalten.", false],
		[0, "Hilfe", "„Help“ (Hilfe), erreichbar von denselben Stellen, zeigt die Hilfethemen und Ladetipps des Spiels, eine Liste der aktuellen Tastenbelegung und eine Tabelle, die die in den Texten des Spiels genannten Handytasten in die hier verwendeten Tasten, Knöpfe und Touch-Steuerelemente übersetzt.", false],
	],
	"guide/jobs": [
		[0, "Arbeit finden", "Freelance-Aufträge werden von Gästen in der Space Lounge angeboten. Ein Auftraggeber beschreibt die Arbeit und die Bezahlung. Bevor du einen Auftrag anderswo annimmst, kannst du fragen, wo er ist und wie schwierig er wird; du kannst auch bitten, das Angebot noch einmal zu hören, oder es ablehnen. Du kannst nur einen Auftrag zur Zeit haben, und der „Missions“-Bildschirm (Missionen) zeigt ihn mit seinem Ziel und der Zahl der Torsprünge dorthin.", false],
		[0, "Arten von Aufträgen", "Es gibt dreizehn Arten. Bis [[step/16]] und in Ausgaben des Spiels ohne die vollständige Kampagne werden nur fünf angeboten: [[job/11]], [[job/0]], [[job/7]], [[job/4]] und [[job/12]]. Danach erscheint die ganze Palette: [[job/1]], [[job/2]], [[job/3]], [[job/5]], [[job/6]], [[job/9]] und [[job/10]] sowie Käufer, die Waren wollen ([[job/8]]).", false],
		[0, "Schwierigkeit und Belohnung", "Frühe Aufträge haben einen Schwierigkeitsgrad von eins oder zwei; spätere reichen bis neun. Die Grundbelohnung eines Auftrags beträgt 1.500 Credits plus bis zu 5.500 weitere je nach Schwierigkeit. Sie wird dann durch die Entfernung zum Ziel erhöht (verdoppelt bei 1.200 km), und pro Pilotenstufe kommen 200 Credits hinzu. Müllbeseitigung zahlt 30 Prozent weniger, Eskorten zahlen 20 Prozent mehr, Bergung und Rückholung zahlen das Doppelte, und Passagieraufträge zahlen eine kleinere Grundsumme plus einen Anteil pro Passagier. Belohnungen werden auf fünfzig Credits gerundet.", false],
		[0, "Einen Auftrag ausführen", "Kurier- und Passagieraufträge sind erledigt, wenn du mit der Fracht oder den Passagieren an Bord am Ziel andockst. Einkaufsaufträge sind erledigt, wenn du mit den Waren im Frachtraum erneut an der Station des Käufers andockst. Alle anderen Aufträge sind Kämpfe an der Zielstation, die bei deiner Ankunft beginnen; solange einer läuft, kannst du weder andocken, reisen noch wegspringen. Geborgene Container und Geiseln müssen danach zu der Station zurückgebracht werden, auf der du den Auftrag angenommen hast. Ist ein Auftrag erledigt, wird die Belohnung sofort ausgezahlt, dein Ansehen bei der Rasse des Auftraggebers steigt, und der Auftrag zählt für [[medal/16]].", false],
		[0, "Scheitern", "Ein Kampf scheitert, wenn seine Bedingung verloren geht: Die Schiffe, die du schützt, werden alle zerstört, der Container geht verloren, die Zeit läuft ab, oder der Rivale schießt mehr ab als du. Ein gescheiterter Auftrag wird ohne Bezahlung abgebrochen. Du kannst einen Auftrag auch im „Missions“-Bildschirm aufgeben; etwaige Fracht wird zurückgenommen. Wird dein Schiff zerstört, machst du bei deiner letzten Autospeicherung weiter.", false],
	],
	"guide/lounge": [
		[0, "Gäste", "Jede Station hat eine Space Lounge, die ab [[step/13]] geöffnet ist. Dort sitzen drei bis fünf Gäste, die bei jedem Andocken wechseln. Die meisten gehören der herrschenden Rasse des Systems an, manche kommen aber von überall her. Sprich einen Gast an, um zu hören, was er will; jede Antwort und Entscheidung zählt für eine der Gesprächsmedaillen.", false],
		[0, "Antworten", "„OK“ nimmt ein Angebot an, „No, thanks“ („Nein, danke“) lehnt es ab, und „How was that again?“ („Wie war das noch mal?“) wiederholt es. Bei einem Auftrag anderswo kannst du mit „Can you show it on the map?“ („Kannst du es mir auf der Karte zeigen?“) das Ziel erfahren und mit „Will it be difficult?“ („Wird es schwierig?“) hören, wie schwer er ist. Händler lassen dich ihre Ware zuerst ansehen. Angebote ablehnen, um Wiederholung bitten und ohne Nachfrage annehmen zählen jeweils für [[medal/32]], [[medal/33]], [[medal/34]] und [[medal/35]]; Gespräche mit Gästen, die ein Angebot haben, zählen für [[medal/26]].", false],
		[0, "Auftraggeber und Plauderer", "Viele Gäste bieten Freelance-Aufträge an; siehe [[guide/jobs]]. Andere plaudern nur und geben Gerüchte weiter, die manchmal Stationen oder Erze erwähnen, die man kennen sollte.", false],
		[0, "Händler und Käufer", "Händler verkaufen einen einzelnen Posten: ein Ausrüstungsteil oder einige Einheiten einer Handelsware, zu 40 bis 160 Prozent des üblichen Preises. Ab [[step/16]] erscheinen auch Käufer, die eine bestimmte Menge einer Ware zu ebendieser Station gebracht haben wollen; siehe [[job/8]].", false],
		[0, "Piloten zum Anheuern", "Ab [[step/16]] kann ein Gast pro Lounge Flügelmänner anbieten: ein bis drei Piloten für eine Gebühr von 700 bis 1.999 Credits pro Pilot, für zehn Minuten Flugzeit. Piloten der [[faction/1]] sind nie zu haben. Du kannst nur eine Gruppe zur Zeit haben. Ein Pilot, der jede Medaille besitzt, findet stattdessen Bewunderer, die dafür bezahlen, mitfliegen zu dürfen.", false],
		[0, "Agenten", "Sobald die Geschichte [[step/16]] hinter sich gelassen hat, warten namentliche Agenten auf bestimmten Stationen und machen jeweils ein Geschäft. Die meisten verkaufen einen Bauplan; vier verkaufen die Koordinaten eines verborgenen Systems, das danach auf der Karte erscheint. Jeder Agent verschwindet nach dem Geschäft. Die Agenten werden auf eigenen Seiten aufgeführt.", false],
		[0, "Diplomaten", "Ist eine der vier großen Rassen feindlich geworden, sitzt in jeder Lounge einer ihrer Diplomaten. Gegen eine Gebühr, die damit wächst, wie tief dein Ansehen gefallen ist, bis zu 16.000 Credits, setzt der Diplomat diese Ansehensskala auf null zurück.", false],
	],
	"guide/medals": [
		[0, "Stufen", "Die meisten Medaillen gibt es in drei Stufen: Bronze, Silber und Gold. Jede Stufe hat ihr eigenes Ziel, und das Erreichen einer höheren ersetzt die niedrigere Medaille. Einige Medaillen haben nur eine einzige Stufe. Die Medaillenseiten zeigen das Ziel für jede Stufe.", false],
		[0, "Wann Medaillen verliehen werden", "Deine Leistungen werden geprüft, wenn du dich einer Station näherst, bevor das Dock dein Schiff repariert, und neue oder verbesserte Medaillen werden nach dem Andocken verkündet. Im Flug wird nichts verliehen, daher zählt ein im All erreichtes Ziel erst beim nächsten Andocken. Der „Status“-Bildschirm listet jede Medaille auf, die du besitzt, mit ihrer Stufe und dem Grund der Verleihung.", false],
		[0, "Die erste und die letzte", "[[medal/0]] besitzt du von Spielbeginn an. [[medal/36]] wird automatisch verliehen, sobald du jede andere Medaille besitzt.", false],
		[0, "Belohnungen", "Wer jede Medaille besitzt, wird von Piloten in der Space Lounge anders behandelt: Bewunderer bezahlen dich dafür, als Flügelmänner mitzufliegen, statt eine Gebühr zu verlangen. Wer jede Medaille in Gold besitzt, erhält das Angebot der [[ship/8]], eines Prototyps, der auf der Station [[station/10]] verkauft wird. Im „Status“-Bildschirm trägt [[character/0]] eine dunkle Brille, sobald er jede Medaille besitzt, und eine goldene, sobald jede Medaille Gold ist.", false],
	],
	"guide/mining": [
		[0, "Asteroiden", "Im Raum jeder Station liegen Asteroiden in zwei Feldern: eines nahe der Station und eines weiter draußen, zu dem dich die Autopilot-Liste fliegen kann. Welche Erze ein Feld enthält, hängt davon ab, wie nahe das System am Heimatsystem des jeweiligen Erzes liegt, daher findet man nicht jedes Erz überall. Asteroiden lassen sich auch zerschießen; dabei treibt manchmal etwas Erz frei herum, und zerstörte Asteroiden zählen für [[medal/29]].", false],
		[0, "Mit dem Abbau beginnen", "Zum Abbau brauchst du einen Bergbaulaser und freien Platz im Frachtraum. Erfasse einen Asteroiden, indem du ihn unter dem Fadenkreuz hältst, und drücke dann Feuer. Das Schiff fliegt an den Brocken heran, und der Bohrer startet; das Fliegen ist gesperrt, bis du fertig bist. Sobald der Asteroid erfasst ist, zeigt das HUD sein Erz und seine Klasse.", false],
		[0, "Der Bohrer", "Eine Anzeige zeigt die Gesteinsschichten des Asteroiden übereinandergestapelt, jede schmaler als die vorige. Der Bohrer driftet zur Seite und wechselt zufällig alle halbe bis zweieinhalb Sekunden die Richtung. Steuere nach links und rechts, um ihn im grünen Bereich der aktuellen Schicht zu halten. Die erste Schicht braucht sechs Sekunden Bohrzeit, jede tiefere Schicht etwa ein Sechstel weniger als die vorige. Erz sammelt sich die ganze Zeit an, solange du im Grünen bleibst, und in den tieferen Schichten schneller.", false],
		[0, "Rote Zonen", "Zeit außerhalb des grünen Bereichs zählt als Schaden, und die roten Zonen auf der Anzeige wachsen. Nach insgesamt zweieinhalb Sekunden im Roten zerbricht der Asteroid, und alles daraus Gebohrte geht verloren. Drücke jederzeit Feuer, um aufzuhören und das bisher gesammelte Erz zu behalten. Jeder Asteroid kann nur einmal abgebaut werden.", false],
		[0, "Klassen und Kerne", "Größere Asteroiden haben mehr Schichten, zwei bis sieben. Die größten, Klasse A, haben alle sieben, und wer sich durch jede davon bohrt, erhält neben dem Erz auch einen Kern. Kerne sind weit mehr wert als Erz und zählen für [[medal/3]] und [[medal/7]]. Erze zählen für [[medal/2]] und [[medal/6]].", false],
		[0, "Bergbaulaser", "Ein Bergbaulaser hat zwei Werte. Sein Ertrag lässt den Bohrer langsamer driften und feiner steuern, sodass er leichter im Grünen bleibt. Seine Geschwindigkeit erhöht die Rate, mit der sich Erz ansammelt. Die Laser reichen von [[item/86]] bis [[item/89]]; [[item/90]] wird nach einem Bauplan gebaut.", false],
		[0, "Fracht", "Erz und Kerne wandern direkt in den Frachtraum, und du behältst nur so viel, wie Platz ist. Ist der Frachtraum voll, meldet das HUD dies, und du musst auf einer Station verkaufen oder ausladen. Frachtkompressoren vergrößern den Frachtraum um einen Anteil der Kapazität des Schiffs, und mehrere können gleichzeitig eingebaut werden. Am meisten hilft ein größeres Schiff.", false],
	],
	"guide/navigation": [
		[0, "Die Galaxiekarte", "Der Bereich „Map“ (Karte) einer Station und im Flug die Taste Routenkarte zeigen die Galaxie: jedes bekannte System an seinem Platz, die Torverbindungen zwischen ihnen, die herrschende Rasse und die Sicherheit des Systems. Die Wahl eines Systems zoomt hinein und zeigt seine Stationen; die Wahl einer Station dort legt sie als Ziel fest. Die Karte zeigt außerdem die Entfernung zu einem System in Kilometern, markiert die besuchten Stationen und kennzeichnet, wo die Geschichte und dein aktueller Auftrag weitergehen. Ein Suchfeld findet bekannte Stationen nach Namen. Die Seite [[chart]] listet alle Systeme auf.", false],
		[0, "", "Zu Beginn der Geschichte bist du an den Orbit deiner ersten Station gebunden. Die Karte öffnet sich in [[step/9]], danach kannst du zu den anderen Planeten des Systems fliegen.", false],
		[0, "Systeme und Sicherheit", "Jedes System wird von einer der vier großen Rassen beherrscht und hat eine Sicherheitsstufe: „Safe“ (sicher), „Average“ (mittel), „Risky“ (riskant) oder „Dangerous“ (gefährlich). Überfälle von Piraten und Feinden sind in gefährlichen Systemen weit häufiger, während sichere Systeme meist ruhig sind. Die meisten Systeme haben mehrere Stationen, die jeweils ihren eigenen Planeten umkreisen, mit eigenem Laden, eigener Lounge und eigenem „Tec Level“ (Techlevel).", false],
		[0, "Sprungtore", "Reisen zwischen Systemen führen durch Sprungtore. Ein System hat höchstens ein Tor, das im Raum einer seiner Stationen liegt und nur zu benachbarten Systemen führt. Um zu springen, wähle auf der „Map“ ein Ziel in einem benachbarten System, fliege zum Tor (der Autopilot bringt dich hin), erfasse es und drücke Feuer, sobald du in seiner Zone bist. Längere Reisen erfolgen Tor für Tor; der „Missions“-Bildschirm (Missionen) zeigt, wie viele Torsprünge ein Ziel über die dir bekannten Systeme erfordert.", false],
		[0, "Verborgene Systeme", "Fünf Systeme fehlen anfangs auf der Karte: [[system/0]], [[system/1]], [[system/6]], [[system/10]] und [[system/21]]. Ein verborgenes System erscheint, sobald du dort warst oder seine Koordinaten gekauft hast. Vier Agenten in der Space Lounge verkaufen sie: [[agent/12]] für [[system/0]], [[agent/13]] für [[system/1]], [[agent/14]] für [[system/10]] und [[agent/15]] für [[system/21]]. Namentliche Agenten erscheinen erst, wenn die Geschichte [[step/16]] hinter sich gelassen hat. [[system/10]] hat überhaupt keine Torverbindung und ist nur mit einem Sprungantrieb erreichbar.", false],
		[23, "", "Den Weg nach [[system/6]] gibt dir die Geschichte in [[step/22]].", false],
		[0, "Sprungantrieb", "Ein Sprungantrieb bringt das Schiff ohne Tore direkt zu einer Station in jedem bekannten System. Der einzige ist der [[item/85]], der nie in Läden verkauft wird und nach seinem Bauplan gebaut werden muss. Du benutzt ihn im Flug über das Menü Aktionen. Ein Sprung kostet weder Treibstoff noch Gebühr. Er ist nicht verfügbar, solange an deiner Station ein Freelance-Kampf läuft; Kurier- und Passagieraufträge hindern ihn jedoch nicht.", false],
		[34, "", "Die Geschichte gibt dir in [[step/34]] den Bauplan für den [[item/85]], wobei ein Teil der Zutaten bereits geliefert ist.", false],
		[0, "Entfernung", "Entfernungen zwischen Systemen werden in Kilometern angegeben, gemessen an den Positionen der Systeme auf der Karte. Die Entfernung ist für den Handel wichtig, weil die Preise mit dem Abstand zum Ursprung einer Ware steigen, und für Freelance-Aufträge, deren Belohnung mit der Entfernung zum Ziel wächst.", false],
	],
	"guide/tips": [
		[0, "", "Lies vor einer Handelsfahrt die Seite einer Ware: Sie nennt das System, in dem die Ware am günstigsten ist, und die Richtung, in der sie teurer wird.", true],
		[0, "", "Stationen kaufen und verkaufen zum selben Preis, daher bringt eine Ladung erst Geld, wenn sie sich von ihrem Ursprung entfernt hat.", true],
		[0, "", "Reagiere beim Abbau sofort auf jede Änderung der Drift. Die Zeit im Roten summiert sich über den ganzen Bohrvorgang, daher kosten kurze Ausrutscher ebenso viel wie ein langer.", true],
		[0, "", "Hat der Bohrer schon viel Zeit im Roten verbracht, stoppe ihn mit Feuer und behalte, was du hast, statt die ganze Ausbeute zu verlieren.", true],
		[0, "", "Suche nach den größten Asteroiden, wenn du Kerne willst: Nur Brocken der Klasse A enthalten einen, und nur, wenn du dich durch alle sieben Schichten bohrst.", true],
		[0, "", "Baue früh einen Traktorstrahl ein. Ohne ihn lässt sich die Fracht von Wracks und lahmgelegten Schiffen überhaupt nicht einsammeln.", true],
		[0, "", "Ein besserer Scanner macht sich im Kampf bezahlt: Er erfasst Ziele schneller, und die besten zeigen, was ein Schiff geladen hat, bevor du es angreifst.", true],
		[0, "", "Andocken repariert dein Schiff kostenlos, daher lohnt es sich, zwischen Kämpfen an einer Station haltzumachen, statt mit beschädigtem Rumpf weiterzufliegen.", true],
		[0, "", "Docke auf langen Reisen regelmäßig an. Nur ein abgeschlossenes Andocken erzeugt eine Autospeicherung, und ein zerstörtes Schiff bringt dich zur letzten zurück.", true],
		[0, "", "Behalte dein Ansehen im „Status“-Bildschirm im Auge. Fehlschüsse auf örtliche Schiffe summieren sich, und eine ganze Rasse kann feindlich werden.", true],
		[0, "", "Frag einen Auftraggeber vor dem Annehmen, wo der Auftrag ist und wie schwierig er wird, es sei denn, du sammelst die Medaillen fürs Nicht-Nachfragen.", true],
		[0, "", "Schaffe vor einem Kurierauftrag Platz im Frachtraum und baue vor einem Passagierauftrag Kabinen ein: Ohne den Platz kann keiner von beiden angenommen werden.", true],
		[0, "", "Bring für Rückholungs- und Bergungsaufträge eine EMP-Waffe, einen Scanner, der Fracht anzeigt, einen Traktorstrahl und etwas freien Frachtraum mit.", true],
		[0, "", "Bring alle Zutaten eines Bauplans zu der Station, an der du ihn begonnen hast, dann sparst du die Versandgebühr.", true],
		[0, "", "Heuere Flügelmänner erst kurz vor einem harten Kampf an: Ihr Vertrag läuft nur ab, während du fliegst.", true],
	],
	"guide/trading": [
		[0, "Wie Preise entstehen", "Jede Ware hat einen niedrigsten und einen höchsten Preis sowie ein Heimatsystem, ihren Ursprung. Am Ursprung wird sie zum niedrigsten Preis verkauft; je weiter eine Station vom Ursprung entfernt liegt, desto höher der Preis, bis zum höchsten Preis bei einer festgelegten Entfernung. Dazu kommt bei jeder Station eine eigene feste Abweichung von bis zu etwa fünf Prozent nach oben oder unten. Die Warenseiten zeigen, wo eine Ware am günstigsten ist und in welcher Richtung sie teurer wird.", false],
		[0, "Kaufen und verkaufen", "Eine Station kauft zum selben Preis an, zu dem sie verkauft, daher entsteht Gewinn nur durch den Transport von Waren: Kaufe nahe dem Ursprung einer Ware und verkaufe weit davon entfernt. Verkaufte Waren kommen ins Regal der Station. Der „Shop“ (Laden) merkt sich außerdem den niedrigsten und höchsten Preis, den du für jede Ware gesehen hast, samt System, und zeigt sie neben der Ware an. Manche Fracht lässt sich nicht verkaufen, etwa Kurierfracht und Container, die du für einen Auftraggeber transportierst.", false],
		[0, "Was ein Laden führt", "Jede Station hat einen „Tec Level“ (Techlevel). Ihr Regal enthält Waren dieses oder eines niedrigeren Levels; Stationen ab Level vier lassen Waren unter der Hälfte ihres eigenen Levels weg. Jede Ware hat außerdem eine Chance, in einem bestimmten Regal zu liegen, sodass sich das Angebot von Besuch zu Besuch unterscheidet. Einige Waren liegen auf einer bestimmten Station immer im Regal. Manche Waren werden nur in [[faction/1]]-Systemen verkauft, und Bauplan-Produkte werden überhaupt nicht verkauft.", false],
		[0, "", "Handelsgüter gibt es in größeren Mengen, nahe ihrem Ursprung in viel größeren. Waffen und Ausrüstung gibt es meist zu einem bis drei Stück, Raketen, Torpedos und Bomben dagegen in größeren Partien. Ein Regal wird bei jedem Andocken neu bestückt, außer auf den drei zuletzt besuchten Stationen, deren Regale so bleiben, wie du sie verlassen hast.", false],
		[0, "Schnaps", "Jedes System hat sein eigenes lokales Getränk, das nur dort verkauft wird, etwa [[item/132]] in [[system/0]] oder [[item/146]] in [[system/14]]. Getränke sind gewöhnliche Handelswaren. Ihr Kauf in Läden zählt für [[medal/8]]; der Besitz verschiedener Sorten, die bei Lounge-Händlern gekauft oder aus Wracks geborgen wurden, zählt für [[medal/9]].", false],
		[0, "Andere Quellen", "Händler in der Space Lounge bieten einzelne Posten zu 40 bis 160 Prozent des üblichen Preises an, daher lohnt sich ein Vergleich ihrer Angebote. Schiffe führen Fracht mit sich, die man mit einem Traktorstrahl aufnehmen kann, wenn sie zerstört oder lahmgelegt werden, und Erz lässt sich abbauen. Käufer in der Lounge verlangen eine bestimmte Menge einer Ware und zahlen dafür weit mehr als ihren Wert; siehe [[job/8]].", false],
	],
	"home": [
		[0, "", "Diese Übersicht behandelt Galaxy on Fire 2, ein Weltraumspiel über Handel, Bergbau, Kampf und Erkundung. Du fliegst als [[character/0]], ein erfahrener Pilot, der fern der Heimat gestrandet ist, durch 22 Sternsysteme, die Menschen und außerirdische Rassen beherrschen. Zwischen den Story-Missionen kannst du Freelance-Aufträge annehmen, Asteroiden abbauen, mit Waren handeln, Ausrüstung aus Bauplänen herstellen und immer bessere Schiffe kaufen.", false],
		[0, "", "Die Seiten werden aus dem Spiel erstellt, das du importiert hast. Namen, Werte, Preise und Dialoge stammen daraus, und die Erklärungen daneben wurden für diese Übersicht geschrieben. Details der Geschichte, die über den Punkt deines Spielstands hinausgehen, bleiben verborgen, bis du dort ankommst. Gute Einstiegspunkte sind [[world/galaxy]], die [[chart]] und [[guide/basics]].", false],
	],
	"intro/agents": [
		[0, "", "Agenten sind Händler, die in bestimmten Space Lounges sitzen und etwas verkaufen, das du in keinem Laden bekommst: entweder einen seltenen Bauplan oder die Koordinaten eines verborgenen Systems. Sie erscheinen ab [[step/17]], und jeder verkauft nur einmal. Sprich sie in der Lounge ihrer Station an, um das Angebot zu sehen; siehe [[guide/lounge]].", false],
	],
	"intro/blueprints": [
		[0, "", "Bauplan-Gegenstände werden nie in Läden verkauft. Jeder wird nach einem Rezept aus Waren gebaut, sobald du seinen Bauplan besitzt, den du meist bei einem Agenten in der Space Lounge kaufst. Wie die Produktion funktioniert, erklärt [[guide/blueprints]].", false],
	],
	"intro/characters": [
		[0, "", "Dies sind die Menschen, denen [[character/0]] auf seiner Reise begegnet: Händler, Offiziere, Wissenschaftler und seltsamere Gesellschaft. Jede Biografie wächst mit der Geschichte, sodass du über eine Figur nur erfährst, was Keith selbst erfahren hat.", false],
	],
	"intro/equipment": [
		[0, "", "Ausrüstung füllt die Ausrüstungsplätze eines Schiffs: Schilde und Panzerplatten zum Schutz, Frachtkompressoren, Traktorstrahlen zum Einsammeln von Containern, Booster, Steuerdüsen, Scanner, Bergbaulaser, Passagierkabinen, Tarnvorrichtungen, ein Reparaturbot und der Sprungantrieb. Jedes Teil belegt einen Platz, daher begrenzt die Zahl der Plätze, wie vollständig ein Schiff ausgestattet sein kann. Die Preise schwanken je nach System, und Läden führen nur Gegenstände bis zum Techlevel ihrer Station. Einige der besten Teile werden nach Bauplänen gebaut, und mehrere stammen von den [[faction/1|Vossk]] und werden nur in deren Systemen verkauft.", false],
	],
	"intro/factions": [
		[0, "", "Im Spiel treten zehn Fraktionen auf. Vier von ihnen besitzen Systeme und Stationen: die Terraner, die Vossk, die Nivelianer und die Midorianer. Andere haben kein Gebiet und begegnen dir nur als Einzelne oder als Feinde. Dein Ansehen bei den vier Großmächten wird auf zwei Skalen geführt, Terraner gegen Vossk und Nivelianer gegen Midorianer; siehe [[world/galaxy]].", false],
	],
	"intro/goods": [
		[0, "", "Waren sind alles, was zum Handel im Frachtraum transportiert wird. Handelsgüter und Getränke kauft man in einem System billig und verkauft sie in einem anderen teuer (siehe [[guide/trading]]); jedes System hat sein eigenes Getränk. Erze werden aus Asteroiden gebohrt, und wer sich durch jede Schicht eines Asteroiden der Klasse A bohrt, erhält einen weit wertvolleren Kern (siehe [[guide/mining]]). Handelsgüter, Erze und Kerne sind auch die Zutaten, um Gegenstände nach Bauplänen zu bauen. Einige Waren wie [[item/116]] und [[item/131]] tauchen nur durch Aufträge oder die Geschichte auf und können nicht gekauft werden.", false],
	],
	"intro/guide": [
		[0, "", "Diese Seiten erklären, wie das Spiel gespielt wird: Fliegen und Kämpfen, Bergbau und Handel, die Stationsmenüs, Freelance-Arbeit, Produktion und Medaillen. Die hier genannten Werte folgen den Regeln der Engine; die Tabellen auf den Seiten zu Gegenständen, Schiffen und Medaillen stammen aus deinen eigenen Spieldaten. Beginne mit [[guide/basics]] und [[guide/help]].", false],
	],
	"intro/jobs": [
		[0, "", "Freelance-Aufträge sind Nebenarbeiten, die Auftraggeber in der Space Lounge anbieten, vom Frachttransport bis zur Jagd auf gesuchte Verbrecher. Sie bringen Credits, Ansehen bei der Rasse des Auftraggebers und Erfahrung. Es gibt dreizehn Arten; wie sie angeboten und bezahlt werden, erklärt [[guide/jobs]].", false],
	],
	"intro/medals": [
		[0, "", "Medaillen belohnen die Leistungen eines Piloten: Kampf, Bergbau, Handel, Reisen und sogar die Art, wie du mit Leuten in der Space Lounge sprichst. Die meisten haben die Stufen Bronze, Silber und Gold. Sie werden bei jedem Andocken geprüft; siehe [[guide/medals]].", false],
	],
	"intro/ships": [
		[0, "", "Schiffe unterscheiden sich in Panzerung, Frachtraum, Wendigkeit und der Zahl ihrer Plätze: Primärplätze für nach vorn feuernde Kanonen, Sekundärplätze für Raketen, Torpedos und Bomben, ein optionaler Geschützturmplatz und Ausrüstungsplätze für alles andere. Die Preise steigen steil, von unter 20.000 Credits für die kleinsten Schiffe bis zu mehreren Millionen für die besten Jäger. Händler außerhalb der [[faction/1|Vossk]]-Systeme zeigen bei jedem Besuch bis zu fünf Schiffe; [[faction/1|Vossk]]-Händler verkaufen nur die [[ship/9]]. Ein Händler zieht den Techlevel seiner Station in Prozent vom Listenpreis ab und zahlt für dein altes Schiff vier Fünftel des Listenpreises. Die [[ship/0]] und die [[ship/10]] werden nie verkauft. Wie man ein Schiff ausrüstet, steht in [[guide/fitting]].", false],
	],
	"intro/stations": [
		[0, "", "Jede Station hat einen Laden, einen Hangar, einen Schiffshändler und eine Space Lounge. Ihr Techlevel von 1 bis 10 bestimmt, wie fortschrittlich die Waren und die Ausrüstung in ihren Regalen sein können, und ihr Händler zieht ebenso viele Prozent vom Listenpreis der Schiffe ab. Das Angebot wechselt von Besuch zu Besuch. Stationen, die in der Geschichte vorkommen oder einen Agenten beherbergen, haben hier eine kurze Beschreibung.", false],
	],
	"intro/story": [
		[0, "", "Die Geschichte begleitet [[character/0]], einen terranischen Piloten, dessen Piratenjagd gründlich schiefgeht, durch 45 Schritte. Jede Schrittseite nennt die Aufgabe und, sobald du sie erledigt hast, was geschah. Die Seiten verraten nur so viel, wie dein Spielstand erreicht hat; [[world/history]] erzählt die bisherige Geschichte an einem Ort.", false],
	],
	"intro/systems": [
		[0, "", "Die Galaxie hat 22 Sternsysteme. Jedes gehört einer Fraktion, hat eine Sicherheitsstufe, die bestimmt, wie oft Angreifer auftauchen, und umfasst bis zu fünf Stationen, von denen eine das Sprungtor trägt. Die Torverbindungen entscheiden, zwischen welchen Systemen du reisen kannst; einige Systeme sind verborgen oder haben gar keine Verbindungen. Siehe [[world/galaxy]] und die [[chart]].", false],
	],
	"intro/weapons": [
		[0, "", "Waffen teilen sich in zwei Gruppen. Primärwaffen (Laser, Blaster, Maschinenkanonen und Thermokanonen) feuern ohne Munition aus den vorderen Plätzen; sie unterscheiden sich in Schaden pro Schuss, Feuerrate und Reichweite. Sekundärwaffen (Raketen, Torpedos, EMP-Bomben und Atombomben) werden stückweise gekauft und aus den Sekundärplätzen abgefeuert. Geschütztürme brauchen ihren eigenen Platz und können in jede Richtung feuern. Manche Waffen entziehen einem Schiff Energie, statt es zu beschädigen oder zusätzlich dazu; ein Schiff ohne Energie ist eine Zeit lang lahmgelegt. Mehrere der besten Waffen werden nie in Läden verkauft und müssen nach Bauplänen gebaut werden (siehe [[guide/blueprints]]). Viele Modelle stammen von den [[faction/1|Vossk]] und sind nur in deren Systemen erhältlich. Taktik steht in [[guide/combat]].", false],
	],
	"intro/world": [
		[0, "", "Diese Seiten beschreiben den Hintergrund des Spiels: die Galaxie und ihren Aufbau, ihre Geschichte und die Mächte, die sie prägen. Sie ergänzen die Seiten zu Systemen, Stationen und Fraktionen um das größere Bild.", false],
	],
	"item/0": [
		[0, "", "Der [[item/0]] ist der Einstiegslaser: 3 Schaden pro Schuss alle 0,4 s, mit der Reichweite von 2.000 Einheiten, die alle frühen Laser teilen. Er ist der schwächste Laser im Spiel, aber billig, und fast jeder Laden führt ihn. Der [[item/1]] und der [[item/2]] behalten dieselbe Feuerrate und machen mehr Schaden.", false],
		[6, "", "Er ist eines der drei Teile, die [[character/2]] vor dem Angriff auf das Piratenversteck in seinem Hangar auf der Station [[station/78]] kostenlos anbietet, zusammen mit [[item/22]] und [[item/55]].", false],
	],
	"item/1": [
		[0, "", "Der [[item/1]] ist die zweite Stufe der Nirai-Reihe. Er feuert so schnell wie der [[item/0]] (alle 0,4 s), macht aber 5 statt 3 Schaden pro Schuss, bei gleicher Reichweite. Er ist ein günstiges Upgrade, bis man sich den [[item/2]] leisten kann.", false],
	],
	"item/10": [
		[0, "", "Der [[item/10]] macht 34 Schaden alle 1,4 s bei einer Reichweite von 2.600. Er trifft pro Schuss härter als der [[item/9]] und reicht weiter, bei etwas langsamerer Feuerrate. Er ist der stärkste Laser, den Läden verkaufen.", false],
	],
	"item/11": [
		[0, "", "Der [[item/11]] ist der stärkste Laser im Spiel: 45 Schaden alle 1,5 s bei einer Reichweite von 2.600, der schwerste Einzelschuss aller Primärwaffen. Er wird nie fertig verkauft. Sein Bauplan stammt von [[agent/0]] auf der Station [[station/3]], und sein Bau verbraucht einen [[item/9]] sowie [[item/155]] und mehrere Handelsgüter.", false],
	],
	"item/116": [
		[0, "", "Sichere Container sind versiegelte Fracht, die nur durch Freelance-Arbeit auftaucht. Wer einen [[job/0]]-Auftrag annimmt, bekommt die vereinbarte Zahl in den Frachtraum geladen, wo sie Platz belegen; sie lassen sich nicht verkaufen und werden am Ziel übergeben. Sie stehen auch für das Diebesgut bei [[job/3]]-Aufträgen, bei denen das Schiff, das sie trägt, lahmgelegt statt zerstört werden muss.", false],
	],
	"item/117": [
		[0, "", "Eine sichere Kabine ist eine besondere Fracht, die nur durch Freelance-Arbeit auftaucht, nämlich bei [[job/5]]-Aufträgen, die verlangen, einen Gefangenen aus einem von mehreren Schiffen zu befreien und zurückzubringen. Wie ein [[item/116]] lässt sie sich weder kaufen noch verkaufen.", false],
	],
	"item/12": [
		[0, "", "Der [[item/12]] ist der einfache [[faction/1|Vossk]]-Blaster: 11 Schaden alle 0,6 s bei einer Reichweite von 1.500. Blaster reichen weniger weit als Laser, richten auf Dauer aber mehr Schaden an; schon dieses erste Modell übertrifft den besten Nirai-Laser leicht. Er wird außerdem für den Bau des [[item/15]] gebraucht. Nur Läden in [[faction/1|Vossk]]-Systemen führen ihn.", false],
	],
	"item/13": [
		[0, "", "Der [[item/13]] ist ein [[faction/1|Vossk]]-Blaster, der alle 0,5 s 12 Schaden bei 1.500 Reichweite anrichtet, eine deutliche Verbesserung gegenüber dem [[item/12]] bei Feuerrate und Schaden. Nur Läden in [[faction/1|Vossk]]-Systemen führen ihn.", false],
	],
	"item/131": [
		[0, "", "[[item/131]] sind die Wrackteile von [[faction/9|Void]]-Jägern. Jedes feindliche [[faction/9|Void]]-Schiff, das zerstört wird, hinterlässt einen Container mit einem bis drei davon, der sich nur mit einem Traktorstrahl einsammeln lässt (siehe [[item/68]]). Sie werden zu festen 199 Credits verkauft, und ihr Einsammeln zählt für die Medaille [[medal/21]].", false],
		[24, "", "[[character/6]] braucht solche Überreste für ihre Forschung und schickt [[character/0]] los, sie nahe der Station [[station/48]] einzusammeln.", false],
		[25, "", "Während [[character/0]] sie zurückbringt, lassen sich die Überreste nicht verkaufen.", false],
		[28, "", "Bei der Ankunft auf der Station [[station/10]] werden sie dem Team von [[character/6]] übergeben.", false],
	],
	"item/14": [
		[0, "", "Der [[item/14]] ist ein [[faction/1|Vossk]]-Blaster, der alle 0,4 s für 10 Schaden feuert. Auf Dauer richtet er etwas mehr Schaden an als der [[item/13]], doch seine Reichweite von 1.000 ist kurz, daher passt er zu Piloten, die nah an ihre Ziele herangehen. Nur Läden in [[faction/1|Vossk]]-Systemen führen ihn.", false],
	],
	"item/15": [
		[0, "", "Der [[item/15]] ist der beste [[faction/1|Vossk]]-Blaster: 10 Schaden alle 0,3 s bei 1.500 Reichweite. Er verbindet die Feuerrate der schnelleren Blaster mit der Reichweite des [[item/12]]. Er wird nie fertig verkauft. Sein Bauplan stammt von [[agent/1]] auf der Station [[station/8]], und sein Bau verbraucht einen [[item/12]] und einen [[item/166]] sowie mehrere Handelsgüter.", false],
	],
	"item/154": [
		[0, "", "[[item/154]] ist das wertvollste gewöhnliche Erz. Asteroidenfelder bevorzugen Erze, deren Heimatsystem in der Nähe liegt, und seine Heimat ist [[system/9]], wo es auch am günstigsten ist. Es wird in großer Menge für den Bau des [[item/27]] gebraucht. Wer sich durch einen [[item/154]]-Asteroiden der Klasse A bohrt, erhält einen [[item/165]].", false],
	],
	"item/155": [
		[0, "", "[[item/155]] ist ein Erz mittlerer Preisklasse, dessen Heimatsystem [[system/21]] ist, wo es am günstigsten verkauft wird. Es ist eine Zutat für den [[item/11]] und für [[item/90]]. Sein Kern ist der [[item/166]].", false],
	],
	"item/156": [
		[0, "", "[[item/156]] ist das billigste Erz, mit seiner Heimat in [[system/0]]. Sein geringer Wert macht es zu einer schlechten Handelsfracht, doch es ist eine Zutat für die Panzerplatte [[item/59]]. Sein Kern ist der [[item/167]].", false],
	],
	"item/157": [
		[0, "", "[[item/157]] ist ein Erz mittlerer Preisklasse, dessen Heimatsystem [[system/7]] ist. Zusammen mit seinem Kern, dem [[item/168]], wird es für den Bau der Panzerplatte [[item/59]] gebraucht.", false],
	],
	"item/158": [
		[0, "", "[[item/158]] ist ein Erz mittlerer Preisklasse, dessen Heimatsystem [[system/4]] ist. Es ist eines der Erze, die für den [[item/85]] gebraucht werden. Sein Kern ist der [[item/169]].", false],
	],
	"item/159": [
		[0, "", "[[item/159]] ist ein Erz mittlerer Preisklasse, dessen Heimatsystem [[system/18]] ist. Kein Bauplan verwendet es, daher wird es nur zum Verkauf oder für die Erzmedaillen abgebaut. Sein Kern ist der [[item/170]].", false],
	],
	"item/16": [
		[0, "", "Der [[item/16]] ist der erste EMP-Blaster. Er beschädigt weder Rumpf noch Panzerung; stattdessen entzieht jeder Treffer einem Schiff 3 Punkte Energie, und ein Schiff, dessen Energie auf null fällt, ist eine Zeit lang lahmgelegt. EMP-Kanonen braucht man, wenn ein Ziel gestoppt statt zerstört werden muss. Dieses Modell feuert alle 0,3 s, reicht aber nur 1.200 Einheiten weit. Der [[item/17]] und der [[item/18]] reichen weiter und entziehen pro Schuss mehr.", false],
	],
	"item/160": [
		[0, "", "[[item/160]] ist ein günstiges Erz, dessen Heimatsystem [[system/13]] ist. Es ist eines der Erze, die für den [[item/85]] gebraucht werden. Sein Kern ist der [[item/171]].", false],
	],
	"item/161": [
		[0, "", "[[item/161]] ist ein Erz mittlerer Preisklasse, dessen Heimatsystem [[system/19]] ist. Kein Bauplan verwendet es. Sein Kern ist der [[item/172]].", false],
	],
	"item/162": [
		[0, "", "[[item/162]] ist ein Erz mittlerer Preisklasse, dessen Heimatsystem [[system/14]] ist. Kein Bauplan verwendet es. Sein Kern ist der [[item/173]].", false],
	],
	"item/163": [
		[0, "", "[[item/163]] ist ein Erz mittlerer Preisklasse, dessen Heimatsystem [[system/5]] ist. Es ist die Hauptzutat des [[item/54]], der 80 t davon benötigt, und wird auch für den [[item/85]] gebraucht. Sein Kern ist der [[item/174]].", false],
	],
	"item/164": [
		[0, "", "[[item/164]] sind ein Erz, das nie in den Asteroidenfeldern der bewohnten Systeme vorkommt. Anders als bei anderen Erzen hinterlässt ein Kristallasteroid nichts, wenn er zerschossen wird, daher müssen die Kristalle gebohrt werden. Sie sind die Schlüsselzutat des [[item/85]], der 50 davon benötigt.", false],
		[25, "", "Jeder Asteroid im Heimatraum der [[faction/9|Voids]], den man durch ihre Wurmlöcher erreicht, besteht aus diesen Kristallen.", false],
		[33, "", "[[character/20]] bittet [[character/0]], ihm mindestens 50 Kristalle zu bringen, die seiner Ansicht nach das Geheimnis der Wurmlöcher der [[faction/9|Voids]] bergen.", false],
	],
	"item/165": [
		[0, "", "Dieser Kern ist das seltene Zentrum eines [[item/154]]-Asteroiden der Klasse A. Man erhält ihn, indem man sich durch alle sieben Schichten eines solchen Asteroiden bohrt, und ab und zu fällt einer ab, wenn ein Asteroid der Klasse A zerschossen wird. Er wird für ein Mehrfaches des Preises des Erzes selbst verkauft, am günstigsten in [[system/9]]. Nach dem [[item/175]] ist er der wertvollste Kern.", false],
	],
	"item/166": [
		[0, "", "Dieser Kern ist das seltene Zentrum eines [[item/155]]-Asteroiden der Klasse A. Man erhält ihn, indem man sich durch alle sieben Schichten eines solchen Asteroiden bohrt, und ab und zu fällt einer ab, wenn ein Asteroid der Klasse A zerschossen wird. Er wird für ein Mehrfaches des Preises des Erzes selbst verkauft, am günstigsten in [[system/21]]. Er wird für den Bau des [[item/15]] und, zu zehnt, für [[item/90]] gebraucht.", false],
	],
	"item/167": [
		[0, "", "Dieser Kern ist das seltene Zentrum eines [[item/156]]-Asteroiden der Klasse A. Man erhält ihn, indem man sich durch alle sieben Schichten eines solchen Asteroiden bohrt, und ab und zu fällt einer ab, wenn ein Asteroid der Klasse A zerschossen wird. Er wird für ein Mehrfaches des Preises des Erzes selbst verkauft, am günstigsten in [[system/0]]. Er ist der am wenigsten wertvolle Kern.", false],
	],
	"item/168": [
		[0, "", "Dieser Kern ist das seltene Zentrum eines [[item/157]]-Asteroiden der Klasse A. Man erhält ihn, indem man sich durch alle sieben Schichten eines solchen Asteroiden bohrt, und ab und zu fällt einer ab, wenn ein Asteroid der Klasse A zerschossen wird. Er wird für ein Mehrfaches des Preises des Erzes selbst verkauft, am günstigsten in [[system/7]]. Fünfzehn davon werden für den Bau der [[item/59]] gebraucht.", false],
	],
	"item/169": [
		[0, "", "Dieser Kern ist das seltene Zentrum eines [[item/158]]-Asteroiden der Klasse A. Man erhält ihn, indem man sich durch alle sieben Schichten eines solchen Asteroiden bohrt, und ab und zu fällt einer ab, wenn ein Asteroid der Klasse A zerschossen wird. Er wird für ein Mehrfaches des Preises des Erzes selbst verkauft, am günstigsten in [[system/4]].", false],
	],
	"item/17": [
		[0, "", "Der [[item/17]] entzieht alle 0,5 s 5 Energie pro Treffer und reicht 2.000 Einheiten weit, viel weiter als der [[item/16]]. Er verursacht keinen Rumpfschaden. Er entzieht Energie etwa im selben Tempo wie das Mk I, kann das aber aus sichererer Entfernung tun.", false],
	],
	"item/170": [
		[0, "", "Dieser Kern ist das seltene Zentrum eines [[item/159]]-Asteroiden der Klasse A. Man erhält ihn, indem man sich durch alle sieben Schichten eines solchen Asteroiden bohrt, und ab und zu fällt einer ab, wenn ein Asteroid der Klasse A zerschossen wird. Er wird für ein Mehrfaches des Preises des Erzes selbst verkauft, am günstigsten in [[system/18]].", false],
	],
	"item/171": [
		[0, "", "Dieser Kern ist das seltene Zentrum eines [[item/160]]-Asteroiden der Klasse A. Man erhält ihn, indem man sich durch alle sieben Schichten eines solchen Asteroiden bohrt, und ab und zu fällt einer ab, wenn ein Asteroid der Klasse A zerschossen wird. Er wird für ein Mehrfaches des Preises des Erzes selbst verkauft, am günstigsten in [[system/13]].", false],
	],
	"item/172": [
		[0, "", "Dieser Kern ist das seltene Zentrum eines [[item/161]]-Asteroiden der Klasse A. Man erhält ihn, indem man sich durch alle sieben Schichten eines solchen Asteroiden bohrt, und ab und zu fällt einer ab, wenn ein Asteroid der Klasse A zerschossen wird. Er wird für ein Mehrfaches des Preises des Erzes selbst verkauft, am günstigsten in [[system/19]].", false],
	],
	"item/173": [
		[0, "", "Dieser Kern ist das seltene Zentrum eines [[item/162]]-Asteroiden der Klasse A. Man erhält ihn, indem man sich durch alle sieben Schichten eines solchen Asteroiden bohrt, und ab und zu fällt einer ab, wenn ein Asteroid der Klasse A zerschossen wird. Er wird für ein Mehrfaches des Preises des Erzes selbst verkauft, am günstigsten in [[system/14]].", false],
	],
	"item/174": [
		[0, "", "Dieser Kern ist das seltene Zentrum eines [[item/163]]-Asteroiden der Klasse A. Man erhält ihn, indem man sich durch alle sieben Schichten eines solchen Asteroiden bohrt, und ab und zu fällt einer ab, wenn ein Asteroid der Klasse A zerschossen wird. Er wird für ein Mehrfaches des Preises des Erzes selbst verkauft, am günstigsten in [[system/5]].", false],
	],
	"item/175": [
		[0, "", "[[item/175]] ist der Kern eines [[item/164]]-Asteroiden der Klasse A. Da Kristallasteroiden nichts hinterlassen, wenn sie zerschossen werden, kommt man nur an ihn, indem man sich durch alle sieben Schichten bohrt. Er wird zu festen 5.000 Credits verkauft, mehr als das Fünffache des besten Preises jedes anderen Kerns.", false],
		[25, "", "Er ist nur im Heimatraum der [[faction/9|Voids]] zu finden.", false],
	],
	"item/18": [
		[0, "", "Der [[item/18]] ist der stärkste EMP-Blaster: 8 Energie pro Treffer alle 0,5 s bei 2.000 Reichweite, was Schiffe spürbar schneller lahmlegt als der [[item/17]]. Wie die anderen EMP-Blaster verursacht er keinen Rumpfschaden.", false],
	],
	"item/19": [
		[0, "", "Der [[item/19]] macht 15 Schaden alle 0,3 s bei einer Reichweite von 1.400. Auf Dauer trifft er weit härter als jeder Laser. Der [[item/20]] und der [[item/21]] feuern schneller, reichen aber nur 1.000 Einheiten weit.", false],
	],
	"item/2": [
		[0, "", "Der [[item/2]] ist der beste Nirai-Laser: 7 Schaden alle 0,4 s. Jeder Schuss ist schwächer als die der Berger-Laser, doch da er etwa doppelt so oft feuert, richtet er auf Dauer mehr Schaden an als jeder von ihnen, einschließlich des [[item/8]]. Nur die M6-Strahllaser ([[item/9]] und seine Nachfolger) übertreffen ihn deutlich.", false],
	],
	"item/20": [
		[0, "", "Der [[item/20]] feuert alle 0,2 s für 13 Schaden. Auf Dauer übertrifft er den [[item/19]], doch seine Reichweite beträgt nur 1.000 Einheiten, daher wirkt er am besten auf kurze Entfernung.", false],
	],
	"item/21": [
		[0, "", "Der [[item/21]] macht 14 Schaden alle 0,2 s, der höchste Schaden auf Dauer aller nach vorn feuernden Kanonen. Wie der [[item/20]] reicht er nur 1.000 Einheiten weit. Er ist außerdem der seltenste Blaster in den Läden.", false],
	],
	"item/22": [
		[0, "", "Die [[item/22]] ist die schwächste Kanone im Spiel: 2 Schaden alle 0,4 s bei einer Reichweite von 1.000. Maschinenkanonen feuern kleine, schnelle Geschosse; sie treffen leicht, doch manche Modelle feuern sehr schnell. Dieses erste Modell ist nur eine Notlösung.", false],
		[6, "", "Sie ist eines der drei Teile, die [[character/2]] vor dem Angriff auf das Piratenversteck in seinem Hangar auf der Station [[station/78]] kostenlos anbietet, zusammen mit [[item/0]] und [[item/55]].", false],
	],
	"item/23": [
		[0, "", "Die [[item/23]] verdoppelt den Schaden der [[item/22]] auf 4 pro Schuss und feuert etwas schneller (alle 0,3 s), weiterhin bei 1.000 Reichweite. Sie ist eine günstige frühe Waffe.", false],
	],
	"item/24": [
		[0, "", "Die [[item/24]] macht 6 Schaden alle 0,3 s bei einer Reichweite von 1.200. Sie ist eine solide Maschinenkanone der Mittelklasse und erreicht auf Dauer denselben Schaden wie die [[item/25]], die weiter reicht.", false],
	],
	"item/25": [
		[0, "", "Die [[item/25]] macht 8 Schaden alle 0,4 s und reicht 1.400 Einheiten weit, die größte Reichweite aller Maschinenkanonen. Auf Dauer richtet sie denselben Schaden an wie die [[item/24]]. Sie wird nie fertig verkauft. Ihr Bauplan stammt von [[agent/2]] auf der Station [[station/20]], und sie wird allein aus Handelsgütern gebaut, ohne Erz.", false],
	],
	"item/26": [
		[0, "", "Die [[item/26]] feuert alle 0,2 s für 5 Schaden bei einer Reichweite von 1.000. Durch ihr schnelles Feuer richtet sie auf Dauer mehr Schaden an als die Railguns, auf Kosten der Reichweite.", false],
	],
	"item/27": [
		[0, "", "Die [[item/27]] feuert alle 0,1 s, die schnellste Feuerrate aller Maschinenkanonen, mit 6 Schaden pro Geschoss. Ihr Schaden auf Dauer kommt dem der besten Blaster nahe, doch ihre Reichweite von 900 ist die kürzeste aller Kanonen. Sie wird nie fertig verkauft. Ihr Bauplan stammt von [[agent/3]] auf der Station [[station/10]], und ihr Bau benötigt unter anderem [[item/154]].", false],
	],
	"item/28": [
		[0, "", "Die [[item/28]] ist die erste Thermokanone. Thermokanonen feuern schnelle, leichte Schüsse mit einer Reichweite von 1.000; diese macht 3 Schaden alle 0,3 s. Trotz ihres hohen Techlevels ist sie auf Dauer schwächer als die meisten Blaster und Maschinenkanonen der Mittelklasse.", false],
	],
	"item/29": [
		[0, "", "Die [[item/29]] macht 4 Schaden alle 0,2 s bei 1.000 Reichweite, auf Dauer doppelt so viel wie die [[item/28]].", false],
	],
	"item/3": [
		[0, "", "Der [[item/3]] ist ein [[faction/1|Vossk]]-Laser, der alle 0,5 s 7 Schaden anrichtet. Pro Schuss entspricht das dem [[item/2]], doch er feuert etwas langsamer und fällt daher auf Dauer leicht zurück. Nur Läden in [[faction/1|Vossk]]-Systemen führen ihn.", false],
		[0, "", "Die [[ship/10]] von [[character/0]] trägt in der Eröffnungsszene zwei davon.", false],
	],
	"item/30": [
		[0, "", "Die [[item/30]] feuert alle 0,1 s für 3 Schaden, die schnellste der Thermokanonen. Auf Dauer richtet sie mehr an als die [[item/29]], aber weniger als die besten Blaster wie der [[item/21]].", false],
	],
	"item/31": [
		[0, "", "Die [[item/31]] ist die einfache [[faction/1|Vossk]]-Rakete und die günstigste Sekundärmunition: 60 Schaden pro Treffer, ein Start alle 1,2 s, Reichweite 1.200. Raketen fliegen geradeaus und verfolgen ihr Ziel nicht, daher wirken sie am besten auf kurze Entfernung. Jede Rakete und jeder Torpedo, der einen Asteroiden trifft, zertrümmert ihn. Nur Läden in [[faction/1|Vossk]]-Systemen führen sie.", false],
	],
	"item/32": [
		[0, "", "Die [[item/32]] ist die gängige ungelenkte Rakete: 70 Schaden pro Treffer, ein Start alle 0,9 s und eine Reichweite von 1.200. Sie trifft härter und startet schneller als die [[item/31]] und wird vielerorts verkauft.", false],
	],
	"item/33": [
		[0, "", "Die [[item/33]] richtet 72 Schaden an und entzieht zusätzlich 34 Energie, kann ein Ziel also sowohl beschädigen als auch beim Lahmlegen helfen. Sie lädt langsam nach (2 s) und reicht 1.000 Einheiten weit. Sie wird nie fertig verkauft. Ihr Bauplan stammt von [[agent/4]] auf der Station [[station/43]], und eine Charge braucht nur ein paar billige Handelsgüter.", false],
	],
	"item/34": [
		[0, "", "Die [[item/34]] ist zum Lahmlegen statt zum Zerstören gedacht: Sie entzieht 45 Energie und richtet pro Treffer nur 10 Schaden an, mit einem Start pro Sekunde. Die [[item/35]] entzieht mehr und richtet mehr Schaden an.", false],
	],
	"item/35": [
		[0, "", "Die [[item/35]] entzieht 60 Energie und richtet pro Treffer 30 Schaden an, mit einem Start pro Sekunde bei 1.000 Reichweite. Sie legt Schiffe schneller lahm als die [[item/34]] und zermürbt dabei trotzdem ihren Rumpf.", false],
	],
	"item/36": [
		[0, "", "Der [[item/36]] ist der einfache Torpedo. Torpedos fliegen die ersten 1,5 s geradeaus und steuern dann ihr Ziel an. Der [[item/36]] richtet 70 Schaden bei 3.000 Einheiten Reichweite an, ist aber langsam und startet nur alle 3 s. Der [[item/38]] verdoppelt seinen Schaden.", false],
	],
	"item/37": [
		[0, "", "Der [[item/37]] ist der schnellste Torpedo: Er richtet 100 Schaden an, entzieht 50 Energie und reicht 4.000 Einheiten weit. Er startet alle 4 s. Er wird nie fertig verkauft. Sein Bauplan stammt von [[agent/5]] auf der Station [[station/54]], und eine Charge braucht nur ein paar Handelsgüter.", false],
	],
	"item/38": [
		[0, "", "Der [[item/38]] ist der am härtesten treffende Torpedo, mit 140 Schaden pro Treffer und einer Reichweite von 4.000. Er fliegt langsam und startet alle 4 s. Nur Läden in [[faction/1|Vossk]]-Systemen führen ihn.", false],
	],
	"item/39": [
		[0, "", "Der [[item/39]] ist ein Lenktorpedo zum Lahmlegen von Schiffen: Er entzieht 100 Energie und richtet keinen Schaden an. Mit einer Reichweite von 5.000 ist er ein günstiges Mittel, ein Ziel aus großer Entfernung zu stoppen. Der [[item/40]] fügt demselben Energieentzug 120 Schaden hinzu.", false],
	],
	"item/4": [
		[0, "", "Der [[item/4]] ist der stärkere [[faction/1|Vossk]]-Laser: 10 Schaden alle 0,6 s. Sein Schaden auf Dauer entspricht fast genau dem des [[item/2]], mit schwereren, aber selteneren Schüssen als der [[item/3]]. Nur Läden in [[faction/1|Vossk]]-Systemen führen ihn.", false],
	],
	"item/40": [
		[0, "", "Der [[item/40]] verbindet 120 Schaden mit 100 Punkten Energieentzug in einem Lenktorpedo, mit einer Reichweite von 5.000 und einem Start alle 5 s. Er kostet mehr als doppelt so viel wie der [[item/39]].", false],
	],
	"item/41": [
		[0, "", "Die [[item/41]] ist die kleinste EMP-Bombe. Eine Bombe wird mit einem Druck gestartet und mit einem zweiten gezündet; die Explosion entzieht jedem Schiff in ihrem Radius Energie, nahe der Mitte stärker, und verschont das Schiff, das sie gestartet hat. Asteroiden bleiben unberührt. Dieses Modell entzieht bis zu 80 Energie in einem Radius von 22.000. Die [[item/42]] und die [[item/43]] sind stärker und weiter.", false],
		[20, "", "Die [[faction/0|terranische]] Sicherheit hinterlegt zehn dieser Bomben kostenlos auf der Station [[station/55]], damit [[character/0]] das Schiff der Entführer lahmlegen kann, ohne es zu zerstören.", false],
	],
	"item/42": [
		[0, "", "Die [[item/42]] entzieht bis zu 150 Energie in einem Radius von 30.000, fast doppelt so stark wie die [[item/41]] und mit viel weiterer Explosion.", false],
	],
	"item/43": [
		[0, "", "Die [[item/43]] ist die stärkste EMP-Bombe: Sie entzieht bis zu 300 Energie in einem Radius von 37.000. Sie lädt etwas schneller nach als die [[item/42]], kostet aber fast doppelt so viel.", false],
	],
	"item/44": [
		[0, "", "Die [[item/44]] ist die kleinste Atombombe. Wie eine EMP-Bombe wird sie gestartet und dann mit einem zweiten Druck gezündet, doch ihre Explosion richtet echten Schaden an: bis zu 200 in einem Radius von 20.000, zum Rand hin weniger. Sie zerbricht auch Asteroiden. Das startende Schiff nimmt keinen Schaden.", false],
	],
	"item/45": [
		[0, "", "Die [[item/45]] richtet bis zu 560 Schaden in einem Radius von 30.000 an, fast die dreifache Kraft der [[item/44]] bei weiterer Explosion.", false],
	],
	"item/46": [
		[0, "", "Die [[item/46]] ist die zerstörerischste Waffe im Spiel: bis zu 950 Schaden in einem Radius von 40.000. Sie wird nie fertig verkauft. Ihr Bauplan stammt von [[agent/6]] auf der Station [[station/61]], und ihr Bau benötigt neben anderen Handelsgütern radioaktive Waren und Sprengstoffe.", false],
	],
	"item/47": [
		[0, "", "Der [[item/47]] ist der einfache Geschützturm. Ein Geschützturm sitzt in seinem eigenen Platz, den nur manche Schiffe haben, und kann sich ganz herumdrehen, sodass er Ziele neben oder hinter dem Schiff treffen kann; während du ihn ausrichtest, fliegt das Schiff von selbst weiter. Dieses Modell richtet 6 Schaden alle 0,3 s bei 2.000 Reichweite an und dreht langsam (Wendigkeit 40).", false],
	],
	"item/48": [
		[0, "", "Der [[item/48]] richtet 10 Schaden alle 0,2 s bei 2.500 Reichweite an und dreht schneller als der [[item/47]] (Wendigkeit 60). Er kostet mehr als dreimal so viel.", false],
	],
	"item/49": [
		[0, "", "Der [[item/49]] ist der beste Geschützturm: 12 Schaden alle 0,1 s bei 3.000 Reichweite, mit dem schnellsten Schwenk (Wendigkeit 100). Er ist auch sehr teuer und kostet etwa doppelt so viel wie der [[item/48]]. Nur Läden in [[faction/1|Vossk]]-Systemen führen ihn.", false],
	],
	"item/5": [
		[0, "", "Der [[item/5]] eröffnet die Berger-Laserreihe, die Feuerrate gegen schwerere Schüsse und eine etwas größere Reichweite (2.200) tauscht. Er macht 8 Schaden alle 0,9 s, auf Dauer weniger als der günstigere [[item/2]]. Sein Vorteil ist die größere Reichweite.", false],
	],
	"item/50": [
		[0, "", "Der [[item/50]] ist der einfache Schild. Ein Schild fängt eingehenden Schaden ab, bevor Panzerung und Rumpf etwas abbekommen, und lädt sich über seine Ladezeit von selbst wieder auf. Der Targe hält nur 50 Punkte, lädt sich aber in 20 s vollständig auf, schneller als jeder andere Schild.", false],
	],
	"item/51": [
		[0, "", "Der [[item/51]] hält 80 Punkte, braucht aber 46 s, um sich vollständig aufzuladen. In einem einzelnen Kampf fängt er mehr ab als der [[item/50]], erholt sich zwischen Angriffen aber viel langsamer.", false],
	],
	"item/52": [
		[0, "", "Der [[item/52]] ist ein [[faction/1|Vossk]]-Schild, der 120 Punkte hält und sich in 58 s auflädt. Er fängt viel mehr ab als der [[item/51]], doch der [[item/53]] hält mehr und lädt schneller. Nur Läden in [[faction/1|Vossk]]-Systemen führen ihn.", false],
	],
	"item/53": [
		[0, "", "Der [[item/53]] hält 150 Punkte und lädt sich in 45 s auf, schlägt den [[item/52]] also in beiden Punkten. Er ist der beste Schild, den Läden verkaufen.", false],
	],
	"item/54": [
		[0, "", "Der [[item/54]] ist der stärkste Schild: 220 Punkte, aufgeladen in 60 s. Er wird nie fertig verkauft. Sein Bauplan stammt von [[agent/7]] auf der Station [[station/72]], und sein Bau benötigt eine große Menge [[item/163]] sowie Elektronik, Nanotechnik und Mikrochips.", false],
	],
	"item/55": [
		[0, "", "Die [[item/55]] ist die einfache Panzerplatte. Eine Platte addiert ihre Punkte zur Panzerung des Schiffs; nach dem Schild nimmt sie Schaden vor dem Rumpf, und anders als ein Schild lädt sie sich nicht wieder auf. Die E2 fügt 40 Punkte hinzu, ein großer Anteil für ein leichtes Einsteigerschiff wie die [[ship/32]], die selbst 100 hat.", false],
		[6, "", "Sie ist eines der drei Teile, die [[character/2]] vor dem Angriff auf das Piratenversteck in seinem Hangar auf der Station [[station/78]] kostenlos anbietet, zusammen mit [[item/0]] und [[item/22]].", false],
	],
	"item/56": [
		[0, "", "Die [[item/56]] fügt 80 Panzerungspunkte hinzu, doppelt so viele wie die [[item/55]], zu einem bescheidenen Preis.", false],
	],
	"item/57": [
		[0, "", "Die [[item/57]] fügt 110 Panzerungspunkte hinzu. Sie ist die beste Platte, die außerhalb der [[faction/1|Vossk]]-Systeme verkauft wird.", false],
	],
	"item/58": [
		[0, "", "Die [[item/58]] ist eine [[faction/1|Vossk]]-Platte, die 160 Panzerungspunkte hinzufügt, viel mehr als die [[item/57]]. Nur Läden in [[faction/1|Vossk]]-Systemen führen sie.", false],
	],
	"item/59": [
		[0, "", "Die [[item/59]] ist die beste Panzerplatte: Sie fügt 250 Punkte hinzu, so viel wie die Grundpanzerung der [[ship/9]] und mehr als die jedes anderen Schiffs außer der [[ship/8]]. Sie wird nie fertig verkauft. Ihr Bauplan stammt von [[agent/8]] auf der Station [[station/84]], und ihr Bau benötigt [[item/157]], [[item/168]] und [[item/156]] sowie Handelsgüter.", false],
	],
	"item/6": [
		[0, "", "Der [[item/6]] macht 9 Schaden alle 0,8 s bei 2.200 Reichweite. Er ist eine bescheidene Verbesserung gegenüber dem [[item/5]], und sein Preis schwankt zwischen den Systemen kaum.", false],
	],
	"item/60": [
		[0, "", "Das [[item/60]] ist das schwächste von drei EMP-Schutzmodulen, mit einer EMP-Abwehr von 20. Keines der drei hat einen Preis, und kein Laden führt sie.", false],
	],
	"item/61": [
		[0, "", "Das [[item/61]] ist das mittlere EMP-Schutzmodul, mit einer EMP-Abwehr von 40, doppelt so viel wie das [[item/60]]. Wie seine Geschwister hat es keinen Preis und wird von keinem Laden geführt.", false],
	],
	"item/62": [
		[0, "", "Das [[item/62]] ist das stärkste EMP-Schutzmodul, mit einer EMP-Abwehr von 60. Wie das [[item/60]] und das [[item/61]] hat es keinen Preis und wird von keinem Laden geführt.", false],
	],
	"item/63": [
		[0, "", "Der [[item/63]] ist der einfache Frachtkompressor. Ein Kompressor vergrößert den Frachtraum um einen Prozentsatz der eigenen Kapazität des Schiffs; dieser fügt 15 % hinzu. Er ist billig und lohnt sich für jeden Händler oder Bergmann.", false],
	],
	"item/64": [
		[0, "", "Der [[item/64]] vergrößert den Frachtraum um 25 %, eine klare Verbesserung gegenüber dem [[item/63]] zu einem niedrigen Preis.", false],
	],
	"item/65": [
		[0, "", "Der [[item/65]] vergrößert den Frachtraum um 40 %. Auf einem großen Frachter fügt er so viel Platz hinzu, wie ein ganzes kleines Schiff fasst.", false],
	],
	"item/66": [
		[0, "", "Der [[item/66]] vergrößert den Frachtraum um 75 %, mehr als jeder andere Kompressor, der in Läden verkauft wird.", false],
	],
	"item/67": [
		[0, "", "Der [[item/67]] verdoppelt den Frachtraum und fügt 100 % der Kapazität des Schiffs hinzu: Eine [[ship/36]] fasst damit 700 t. Er wird nie fertig verkauft. Sein Bauplan stammt von [[agent/9]] auf der Station [[station/90]], und er wird allein aus Handelsgütern gebaut.", false],
	],
	"item/68": [
		[0, "", "Der [[item/68]] ist der einfache Traktorstrahl. Ohne Traktorstrahl lässt sich kein treibender Container einsammeln; hineinzufliegen bewirkt nichts. Mit dem Retractor hältst du den Container 4 s unter dem Fadenkreuz, danach wird er herangezogen. Der [[item/69]] braucht weniger Zeit, und der [[item/70]] arbeitet automatisch.", false],
		[24, "", "[[character/6]] bittet [[character/0]], vor der ersten Expedition gegen die [[faction/9|Voids]] einen Traktorstrahl einzubauen, damit er die Überreste ihrer Schiffe einsammeln kann. Bis dahin führen Läden mit guter Chance zusätzlich zu ihrem üblichen Angebot einen Retractor.", false],
	],
	"item/69": [
		[0, "", "Der [[item/69]] funktioniert wie der [[item/68]], braucht das Ziel aber nur 3 s unter dem Fadenkreuz, bevor er den Container heranzieht.", false],
	],
	"item/7": [
		[0, "", "Der [[item/7]] macht 10 Schaden alle 0,8 s bei 2.200 Reichweite. Auf Dauer entspricht er dem [[item/1]], sein Wert liegt also in weniger, aber schwereren Treffern auf große Entfernung.", false],
	],
	"item/70": [
		[0, "", "Der [[item/70]] ist der automatische Traktorstrahl: Er sammelt jeden Container im vorderen Sichtfeld ein, ohne ausgerichtet und gehalten werden zu müssen, was beim Plündern eines Schlachtfelds viel Zeit spart. Er ist weit teurer als der [[item/69]].", false],
	],
	"item/71": [
		[0, "", "Der [[item/71]] ist der einfache Booster. Ein Booster gibt einen kurzen Schub zusätzlicher Geschwindigkeit und muss sich dann wieder aufladen. Dieser fügt 3 s lang 60 % Geschwindigkeit hinzu und lädt in 8 s nach.", false],
	],
	"item/72": [
		[0, "", "Der [[item/72]] ist auf 80 % zusätzliche Geschwindigkeit für 4,4 s ausgelegt, mit 10 s Ladezeit. Im Flug erreicht sein Schub dieselbe Höchstgeschwindigkeit wie der [[item/71]]; was er hinzufügt, ist ein längerer Schub.", false],
	],
	"item/73": [
		[0, "", "Der [[item/73]] bietet mehr als das Doppelte der günstigeren Booster: 160 % zusätzliche Geschwindigkeit für 5,6 s, aufgeladen in 12 s.", false],
	],
	"item/74": [
		[0, "", "Der [[item/74]] ist der stärkste Booster: 200 % zusätzliche Geschwindigkeit für 6 s. Er braucht die längste Ladezeit, 16 s. Nur Läden in [[faction/1|Vossk]]-Systemen führen ihn.", false],
	],
	"item/75": [
		[0, "", "Der [[item/75]] ist der einzige Reparaturbot im Spiel und passt in einen Ausrüstungsplatz. Während du fliegst, stellt er alle 0,6 s einen Punkt Rumpf und jede Sekunde einen Punkt Panzerplatte wieder her, sodass Schäden zwischen Kämpfen ohne Andocken verschwinden. Er ist billig und in den meisten Läden erhältlich.", false],
	],
	"item/76": [
		[0, "", "Die [[item/76]] ist die einfache Steuerdüse. Eine Düse addiert ihren Wert zur Wendigkeit des Schiffs, sodass es schneller dreht. Diese fügt 20 hinzu, ein kleiner Gewinn für wendige Jäger, aber spürbar bei einem langsamen Frachter.", false],
	],
	"item/77": [
		[0, "", "Die [[item/77]] fügt 40 Wendigkeit hinzu, doppelt so viel wie die [[item/76]], zu einem niedrigen Preis.", false],
	],
	"item/78": [
		[0, "", "Die [[item/78]] ist eine [[faction/1|Vossk]]-Düse, die 70 Wendigkeit hinzufügt. Nur Läden in [[faction/1|Vossk]]-Systemen führen sie.", false],
	],
	"item/79": [
		[0, "", "Die [[item/79]] ist eine [[faction/1|Vossk]]-Düse, die 100 Wendigkeit hinzufügt, genug, um einen schweren Frachter wie einen wendigen Jäger drehen zu lassen. Nur Läden in [[faction/1|Vossk]]-Systemen führen sie.", false],
	],
	"item/8": [
		[0, "", "Der [[item/8]] ist der letzte und stärkste Berger-Laser: 12 Schaden pro Schuss alle 0,9 s bei 2.200 Reichweite. Er ist der pro Schuss am härtesten treffende konventionelle Laser, doch der schnellere [[item/2]] richtet auf Dauer immer noch mehr Schaden an. Die auf ihn folgenden M6-Strahllaser (ab [[item/9]]) treffen pro Schuss mehr als doppelt so hart.", false],
	],
	"item/80": [
		[0, "", "Die [[item/80]] ist die beste Steuerdüse und fügt 130 Wendigkeit hinzu. Sie hebt die [[ship/36]], das am langsamsten drehende Schiff, von 45 auf 175, mehr als jeder Jäger ohne Düse hat. Sie ist in Läden selten.", false],
	],
	"item/81": [
		[0, "", "Der [[item/81]] ist der einfache Scanner. Ein Scanner bestimmt, wie lange es dauert, ein Ziel wie ein Schiff, eine Station oder einen Asteroiden zu erfassen; der Quickscan braucht 4 s. Der [[item/82]] erfasst schneller und zeigt außerdem, was andere Schiffe geladen haben.", false],
		[2, "", "Das Bergbauschiff von [[character/2]], die [[ship/0]], ist mit einem ausgestattet.", false],
	],
	"item/82": [
		[0, "", "Der [[item/82]] erfasst in 3 s und zeigt die Fracht anvisierter Schiffe, was bei der Jagd nach Beute hilft.", false],
	],
	"item/83": [
		[0, "", "Der [[item/83]] erfasst in 1,8 s, eine Erfassungszeit, die nur der [[item/84]] erreicht, und zeigt ebenfalls die Fracht von Zielen.", false],
	],
	"item/84": [
		[0, "", "Der [[item/84]] erfasst so schnell wie der [[item/83]] und zeigt Fracht, und er markiert außerdem Asteroiden der Klasse A, die einzigen, die einen Kern liefern können (siehe [[guide/mining]]). Er ist der Scanner der Wahl für Bergleute.", false],
	],
	"item/85": [
		[0, "", "Der [[item/85]] ist der einzige Sprungantrieb im Spiel. Ist er eingebaut, kannst du von der Sternenkarte direkt zu einer Station in einem anderen System reisen, ohne Sprungtore zu durchqueren. Während mancher Missionen kann er nicht benutzt werden. Er wird nie fertig verkauft, und kein Agent verkauft seinen Bauplan. Sein Bau benötigt [[item/164]], [[item/158]], [[item/160]] und [[item/163]] sowie große Mengen an Handelsgütern.", false],
		[33, "", "Sein Erfinder [[character/20]] bittet [[character/0]] um 50 [[item/164]] für seine Arbeit an einem Antrieb, der jeden Ort im All erreichen könnte.", false],
		[34, "", "Im Gegenzug für die Kristalle gibt [[character/20]] [[character/0]] eine Kopie des Bauplans. Die 50 gelieferten Kristalle werden auf den Antrieb angerechnet, sodass nur die übrigen Zutaten beschafft werden müssen.", false],
	],
	"item/86": [
		[0, "", "Der [[item/86]] ist der einfache Bergbaulaser. Ein Bergbaulaser ist nötig, um Erz aus Asteroiden zu bohren. Sein Ertrag bestimmt, wie ruhig der Bohrer seinen Kurs hält, und jedes Modell hat außerdem seine eigene Bohrgeschwindigkeit (siehe [[guide/mining]]). Dieser hat einen Ertrag von 30 und ist in tiefen Schichten schwer auf Kurs zu halten.", false],
	],
	"item/87": [
		[0, "", "Der [[item/87]] hat einen Ertrag von 50. Er ist spürbar ruhiger als der [[item/86]], bohrt aber etwas langsamer.", false],
	],
	"item/88": [
		[0, "", "Der [[item/88]] ist ein [[faction/1|Vossk]]-Bergbaulaser mit einem Ertrag von 80, der ruhigste Bohrer, den Läden verkaufen. Sein Nachteil ist, dass er Erz am langsamsten fördert. Nur Läden in [[faction/1|Vossk]]-Systemen führen ihn.", false],
	],
	"item/89": [
		[0, "", "Der [[item/89]] hat einen Ertrag von 60, weniger ruhig als der [[item/88]], fördert Erz aber viel schneller als jeder andere Laser aus dem Laden. Er passt zu Bergleuten, die den Bohrer selbst auf Kurs halten können.", false],
	],
	"item/9": [
		[0, "", "Der [[item/9]] ist der erste der M6-Strahllaser. Diese feuern selten, treffen aber sehr hart: 27 Schaden alle 1,2 s bei einer Reichweite von 2.400, mehr als jeder frühere Laser. Genaues Zielen ist wichtig, denn ein Fehlschuss verschwendet eine lange Nachladezeit. Er ist außerdem das Grundbauteil für den [[item/11]].", false],
	],
	"item/90": [
		[0, "", "[[item/90]] ist der beste Bergbaulaser: ein Ertrag von 100 und das schnellste Bohren aller Modelle. Er wird nie fertig verkauft. Sein Bauplan stammt von [[agent/11]] auf der Station [[station/78]], und sein Bau benötigt große Mengen an Nanotechnik, mechanischen Teilen und Hydraulik sowie [[item/155]] und zehn [[item/166]].", false],
		[2, "", "Der Laser auf dem ersten Bergbauschiff von [[character/0]] ist der handgefertigte Prototyp dieses Bohrers, gebaut von [[character/2]].", false],
		[10, "", "Als [[character/2]] [[character/0]] die [[ship/0]] schenkt, behält er den Prototyp, den einzigen, den er hat, und schlägt einen späteren Besuch vor, wenn er vielleicht mehr gebaut hat.", false],
	],
	"item/91": [
		[0, "", "Die [[item/91]] bietet Platz für 3 Passagiere. Kabinen werden für [[job/11]]-Aufträge gebraucht, und der Platz mehrerer Kabinen addiert sich. Die [[item/92]] und die [[item/93]] fassen mehr.", false],
	],
	"item/92": [
		[0, "", "Die [[item/92]] bietet Platz für 5 Passagiere, zwei mehr als die [[item/91]].", false],
	],
	"item/93": [
		[0, "", "Die [[item/93]] bietet Platz für 10 Passagiere, doppelt so viele wie die [[item/92]], was die größeren Passagieraufträge erschließt.", false],
	],
	"item/94": [
		[0, "", "Die [[item/94]] ist die einfache Tarnvorrichtung. Solange eine Tarnung aktiv ist, können andere Schiffe dich nicht sehen. Diese verbirgt das Schiff 15 s lang und braucht dann 18 s zum Aufladen. Getarnt verbrachte Zeit zählt für die Medaille [[medal/19]].", false],
	],
	"item/95": [
		[0, "", "Die [[item/95]] ist eine [[faction/1|Vossk]]-Tarnvorrichtung, die das Schiff 28 s lang verbirgt und in 32 s auflädt, fast doppelt so viel Deckung wie die [[item/94]]. Nur Läden in [[faction/1|Vossk]]-Systemen führen sie.", false],
	],
	"item/96": [
		[0, "", "Die [[item/96]] ist die beste Tarnvorrichtung: Sie verbirgt das Schiff 46 s lang und lädt in nur 40 s auf, sodass sie öfter aktiv sein kann als nicht. Sie wird nie fertig verkauft. Ihr Bauplan stammt von [[agent/10]] auf der Station [[station/59]].", false],
	],
	"job/0": [
		[0, "", "Ein Kurierauftrag verlangt, eine Ladung versiegelter Frachtcontainer zu einer anderen Station zu bringen. Die Container werden beim Annehmen in deinen Frachtraum geladen, daher brauchst du genug freien Platz; verkaufen lassen sie sich nicht. Der Auftrag ist erledigt, wenn du mit der Fracht an Bord am Ziel andockst. Manchmal lauern Piraten Kurieren auf. Gelieferte Fracht zählt für [[medal/5]].", false],
	],
	"job/1": [
		[0, "", "Bei einem Verteidigungsauftrag steht ein Angriff auf eine Station bevor, und du wirst angeheuert, um ihren eigenen Jägern beim Vertreiben der Angreifer zu helfen. Die Angreifer sind meist Piraten, sonst Schiffe der rivalisierenden Rasse. Fliege zur Station und zerstöre jeden Angreifer; Abschüsse der verbündeten Jäger zählen mit. Schwierigere Aufträge bringen mehr Angreifer.", false],
	],
	"job/10": [
		[0, "", "Bei einem Abfangauftrag liegt ein Konvoi aus zwei oder drei Frachtern mit illegaler Fracht weit draußen vor einer Station, bewacht von Jägern. Folge den Wegpunkten und zerstöre die Frachter. Ihre Wachen warten unterwegs und rund um den Konvoi.", false],
	],
	"job/11": [
		[0, "", "Ein Passagierauftrag verlangt, eine Gruppe von Leuten zu einer anderen Station zu bringen. Beim Annehmen brauchst du Kabinen mit genug Platz für alle; solange sie an Bord sind, lassen sich die Kabinen nicht ausbauen und das Schiff nicht wechseln. Docke am Ziel an, um sie abzuliefern. Die Grundbelohnung ist niedriger, doch jeder Passagier erhöht sie. Abgelieferte Passagiere zählen für [[medal/18]].", false],
	],
	"job/12": [
		[0, "", "Eine Herausforderung ist ein Schießwettbewerb, den ein anderer Pilot in der Space Lounge anbietet. Ihr fliegt beide von derselben Station zu einer Gruppe von Piraten, die entlang einer Route verteilt sind, und wer mehr von ihnen abschießt, gewinnt. Der Rivale kann nicht zerstört werden und trifft so hart wie deine eigenen Kanonen. Du wirst nur bezahlt, wenn du mehr Abschüsse erzielst; die Zahl der Piraten ist immer ungerade, daher gibt es kein Unentschieden.", false],
	],
	"job/2": [
		[0, "", "Ein Schutzauftrag schickt dich los, um Bergbauschiffe zu bewachen, die ein Asteroidenfeld nahe einer Station abbauen. Angreifer tauchen auf und halten auf die Station und die Bergleute zu. Zerstöre sie alle, bevor sie die Bergleute auslöschen können; gehen alle Bergbauschiffe verloren, scheitert der Auftrag.", false],
	],
	"job/3": [
		[0, "", "Bei einem Rückholungsauftrag wird gestohlene Ware von einem Schiff aus einer Gruppe von Piratenschiffen nahe einer Station transportiert. Du musst den Container zurückholen, ohne ihn zu zerstören: Lege den Träger mit einer EMP-Waffe lahm und zieh den Container mit einem Traktorstrahl heran. Ein Scanner, der Fracht anzeigt, hilft dir, das richtige Schiff zu finden. Der Container geht verloren, wenn der Träger zerstört wird oder dein Frachtraum keinen Platz dafür hat. Sobald du ihn hast, kehre zu der Station zurück, auf der du den Auftrag angenommen hast, um bezahlt zu werden. Rückholung zahlt das Doppelte.", false],
	],
	"job/4": [
		[0, "", "Piratenjagd bedeutet, ein Piratenversteck nahe einer Station auszuräuchern. Die Piraten warten im Asteroidenfeld oder an einer Route aus zwei oder drei Wegpunkten und regen sich erst, wenn sie dich sehen. Folge den Wegpunkten und zerstöre jeden Piraten. Höhere Schwierigkeit bedeutet mehr Piraten.", false],
	],
	"job/5": [
		[0, "", "Ein Bergungsauftrag ist eine Rettung: Eine Geisel wird an Bord eines Schiffs aus einer Gruppe nahe einer Station festgehalten. Wie bei einer Rückholung legst du das Schiff des Entführers mit EMP lahm und holst die Geisel mit einem Traktorstrahl an Bord; wird dieses Schiff zerstört, endet der Auftrag. Bring die Geisel dann zu der Station zurück, auf der du den Auftrag angenommen hast. Bergung zahlt das Doppelte.", false],
	],
	"job/6": [
		[0, "", "Ein Fahndungsauftrag nennt einen gefährlichen Verbrecher, der nahe einer Station gesehen wurde. Das Ziel wartet an einem weit entfernten Punkt und reagiert erst, wenn du in Sicht kommst. Es ist viel zäher als ein gewöhnlicher Pirat und wird mit dem Schwierigkeitsgrad des Auftrags und deiner Pilotenstufe noch zäher. Zerstöre es, um das Kopfgeld zu kassieren.", false],
	],
	"job/7": [
		[0, "", "Müllbeseitigung verlangt, eine Wolke aus Weltraumschrott nahe einer Station in etwa zwei Minuten zu räumen. Jedes Stück muss zerstört sein, bevor die Zeit abläuft; bei höherer Schwierigkeit mischen ein paar Piraten mit. Der Auftrag zahlt weniger als die meisten, ist aber schnell erledigt, und zerstörter Schrott zählt für [[medal/10]].", false],
	],
	"job/8": [
		[0, "", "Ein Einkaufsauftrag kommt von einem Käufer in der Space Lounge, der eine bestimmte Menge einer bestimmten Ware will. Besorge die Waren aus Läden, bei Händlern oder durch Bergbau und docke mit ihnen im Frachtraum erneut an der Station des Käufers an. Die Waren werden übergeben, und du erhältst die halbe übliche Auftragsbelohnung plus das Dreifache des Durchschnittswerts der Waren, daher zahlt ein Käufer meist weit mehr als jeder Laden. Käufer erscheinen ab [[step/16]].", false],
	],
	"job/9": [
		[0, "", "Ein Eskortauftrag verlangt, einen Konvoi aus fünf Frachtern nahe einer Station zu schützen. Während die Frachter weiterfliegen, rücken Angreifer heran, die entlang ihrer Route warten. Zerstöre alle Angreifer. Gehen alle Frachter verloren, scheitert der Auftrag. Eskorten zahlen ein Fünftel mehr als die meisten Aufträge.", false],
	],
	"medal/0": [
		[0, "", "[[character/0]] besitzt diese Medaille von Spielbeginn an, für seine früheren Dienste. Es gibt nichts zu tun, um sie zu verdienen.", false],
	],
	"medal/1": [
		[0, "", "Verliehen für das Erreichen einer Station mit sehr wenig verbleibendem Rumpf. Geprüft wird beim Anflug, bevor das Dock das Schiff repariert, und zwar anhand der eigenen Stärke des Rumpfs, nicht der Panzerplatte. Je geringer der verbleibende Anteil, desto besser die Stufe.", false],
	],
	"medal/10": [
		[0, "", "Verliehen für die Zerstörung von Weltraumschrott, wie er bei [[job/7]]-Aufträgen vorkommt. Jedes abgeschossene Stück zählt.", false],
	],
	"medal/11": [
		[0, "", "Verliehen für die Zahl der verschiedenen Stationen, an denen du angedockt hast.", false],
	],
	"medal/12": [
		[0, "", "Verliehen für die Zahl der verschiedenen Systeme, die du besucht hast. Verborgene Systeme zählen, sobald du sie erreichst.", false],
	],
	"medal/13": [
		[0, "", "Verliehen für die Zahl der Baupläne, die du besitzt. Baupläne kauft man bei Agenten in der Space Lounge; siehe [[guide/blueprints]].", false],
	],
	"medal/14": [
		[0, "", "Verliehen für die Zahl der verschiedenen Baupläne, die du mindestens einmal fertiggestellt hast. Denselben Gegenstand erneut zu bauen, erhöht sie nicht.", false],
	],
	"medal/15": [
		[0, "", "Verliehen für die Spielzeit in Stunden. Das Spiel zählt die im Flug verbrachte Zeit.", false],
	],
	"medal/16": [
		[0, "", "Verliehen für die Zahl der erledigten Freelance-Aufträge. Gescheiterte und aufgegebene Aufträge zählen nicht.", false],
	],
	"medal/17": [
		[0, "", "Verliehen für die Zahl der Reisen durch ein Sprungtor. Sprünge mit einem Sprungantrieb zählen nicht.", false],
	],
	"medal/18": [
		[0, "", "Verliehen für die Zahl der Passagiere, die bei [[job/11]]-Aufträgen abgeliefert wurden. Mehr Kabinenplatz bedeutet größere Gruppen.", false],
	],
	"medal/19": [
		[0, "", "Verliehen für die Gesamtminuten, die du getarnt verbracht hast. Baue eine Tarnvorrichtung ein und nutze sie, sobald sie geladen ist.", false],
	],
	"medal/2": [
		[0, "", "Verliehen für den Abbau verschiedener Erzsorten. Jede Sorte zählt einmal, egal wie viel du davon abbaust. Da Felder die Erze enthalten, deren Heimat in der Nähe liegt, musst du in mehreren Teilen der Galaxie abbauen.", false],
	],
	"medal/20": [
		[0, "", "Verliehen für die Zahl der abgefeuerten EMP-Bomben und Atombomben.", false],
	],
	"medal/21": [
		[0, "", "Verliehen für die Tonnen an [[item/131]], die mit einem Traktorstrahl aus Wracks und lahmgelegten Schiffen eingesammelt wurden.", false],
	],
	"medal/22": [
		[0, "", "Eine einstufige Medaille dafür, ganz ohne eingebaute Waffen oder ganz ohne eingebaute Ausrüstung zu fliegen, geprüft beim nächsten Andocken. Im frühen Teil der Geschichte ist sie nicht zu verdienen: Bis [[step/8]] gilt das Schiff immer als bewaffnet.", false],
	],
	"medal/23": [
		[0, "", "Verliehen für die Zahl der gleichzeitig eingebauten Primärwaffen, geprüft beim Andocken. Für die höheren Stufen braucht es ein Schiff mit vielen Primärplätzen. Wie [[medal/22]] zählt sie erst ab [[step/8]].", false],
	],
	"medal/24": [
		[0, "", "Verliehen für die Tonnen an Fracht, die mit einem Traktorstrahl aus Wracks und lahmgelegten Schiffen geholt wurden.", false],
	],
	"medal/25": [
		[0, "", "Verliehen für die meisten Credits, die du je gleichzeitig besessen hast. Späteres Ausgeben nimmt sie dir nicht wieder.", false],
	],
	"medal/26": [
		[0, "", "Verliehen für Gespräche mit Gästen in der Space Lounge, die etwas anzubieten haben. Jeder Gast zählt einmal, beim ersten Gespräch.", false],
	],
	"medal/27": [
		[0, "", "Verliehen für die Zahl der Flügelmänner, die du in der Space Lounge angeheuert hast, wobei jeder Pilot jeder Gruppe zählt.", false],
	],
	"medal/28": [
		[0, "", "Eine einstufige Medaille dafür, eine der vier großen Rassen gegen dich aufzubringen, indem du eine der beiden Ansehensskalen in einer Richtung über 60 treibst. Siehe [[guide/combat]].", false],
	],
	"medal/29": [
		[0, "", "Verliehen für die Zahl der Asteroiden, die du mit deinen Waffen zerstört hast. Beim Abbau zerbrochene Asteroiden zählen nicht.", false],
	],
	"medal/3": [
		[0, "", "Verliehen für den Abbau verschiedener Kernsorten. Kerne gibt es nur, wenn man sich durch alle sieben Schichten eines Asteroiden der Klasse A bohrt, daher braucht es neben Reisen Geduld und einen guten Bergbaulaser.", false],
	],
	"medal/30": [
		[0, "", "Eine einstufige Medaille, die für den Abschluss der Geschichte verliehen wird.", false],
	],
	"medal/31": [
		[0, "", "Verliehen für den meisten freien Frachtraum, den du je gleichzeitig hattest. Ein großes Schiff mit Frachtkompressoren und leerem Frachtraum bringt die höheren Stufen.", false],
	],
	"medal/32": [
		[0, "", "Verliehen für die Zahl der Angebote, die du in der Space Lounge mit „No, thanks“ („Nein, danke“) abgelehnt hast.", false],
	],
	"medal/33": [
		[0, "", "Verliehen für die Zahl der Male, die du einen Gast in der Space Lounge mit „How was that again?“ („Wie war das noch mal?“) gebeten hast, ein Angebot zu wiederholen.", false],
	],
	"medal/34": [
		[0, "", "Verliehen für das Annehmen von Aufträgen an anderen Stationen, ohne den Auftraggeber vorher zu fragen, ob sie schwierig werden.", false],
	],
	"medal/35": [
		[0, "", "Verliehen für das Annehmen von Aufträgen an anderen Stationen, ohne den Auftraggeber vorher zu bitten, das Ziel auf der Karte zu zeigen.", false],
	],
	"medal/36": [
		[0, "", "Wird automatisch verliehen, sobald du jede andere Medaille besitzt, in beliebiger Stufe. Sie alle zu besitzen, bringt auch andere Belohnungen; siehe [[guide/medals]].", false],
	],
	"medal/4": [
		[0, "", "Verliehen für die Zahl der Schiffe, die du zerstört hast, gezählt über das ganze Spiel. Piraten, Feinde und Auftragsziele zählen alle.", false],
	],
	"medal/5": [
		[0, "", "Verliehen für die Tonnen an Fracht, die bei [[job/0]]-Aufträgen geliefert wurden. Große Kurierladungen zählen mehr, daher hilft ein großer Frachtraum.", false],
	],
	"medal/6": [
		[0, "", "Verliehen für die Gesamttonnen an Erz, die über das ganze Spiel abgebaut wurden.", false],
	],
	"medal/7": [
		[0, "", "Verliehen für die Zahl der Kerne, die über das ganze Spiel abgebaut wurden. Jeder bis zum Ende abgebaute Asteroid der Klasse A liefert einen.", false],
	],
	"medal/8": [
		[0, "", "Verliehen für die Tonnen an Schnaps, die in den Läden der Stationen gekauft wurden. Das lokale Getränk jedes Systems zählt.", false],
	],
	"medal/9": [
		[0, "", "Verliehen für den Besitz verschiedener Schnapssorten. Sorten werden gezählt, wenn du sie bei Händlern in der Space Lounge kaufst oder mit einem Traktorstrahl aus Wracks einsammelst.", false],
	],
	"ship/0": [
		[0, "", "Die [[ship/0]] ist das schwächste Schiff der Schiffstabelle: 95 Panzerung, 25 t Frachtraum, ein Primär- und ein Sekundärplatz und drei Ausrüstungsplätze. Ihre Wendigkeit von 140 ist für ein Einsteigerschiff ordentlich, doch die [[ship/32]], das günstigste käufliche Schiff, hat dieselben Plätze bei mehr Panzerung, Frachtraum und Beweglichkeit. Kein Händler bietet die [[ship/0]] je an; der Spieler erhält sie nur durch die Geschichte.", false],
		[2, "", "[[character/2]] besitzt dieses zusammengeflickte ehemalige [[faction/8|Piratenschiff]] und setzt [[character/0]] auf der Station [[station/78]] hinein, in Piratenfarben lackiert und mit einem Bergbaulaser und einem [[item/81]] ausgestattet, aber ohne Kanonen. Der Laser ist sein eigener Prototyp, das Modell, das er später als [[item/90]] verkauft.", false],
		[10, "", "Nach dem Angriff auf das Piratenversteck schenkt [[character/2]] [[character/0]] das Schiff endgültig, mit einem stärkeren Antrieb für Reisen zwischen den Planeten des Systems, behält aber den Prototyp-Laser. Keith fliegt es auch weiter, nachdem er den [[faction/0|terranischen]] Raum erreicht hat.", false],
		[18, "", "Auf der Station [[station/98]] lässt [[character/1]] das Schiff in [[faction/0|terranischen]] Farben umlackieren, damit Patrouillen es nicht länger für ein Piratenschiff halten.", false],
	],
	"ship/1": [
		[0, "", "Die [[ship/1]] ist das günstigste Schiff mit vier Sekundärplätzen und hat außerdem einen Geschützturmplatz, zwei Primärkanonen und sieben Ausrüstungsplätze. Panzerung (192) und Frachtraum (65 t) sind solide. Ihre Wendigkeit von 106 ist gering, daher kämpft sie am besten mit Torpedos und dem Geschützturm. Für etwas mehr Geld bietet die [[ship/9]] viel mehr Panzerung und Beweglichkeit, aber keinen Geschützturm und nur zwei Sekundärplätze.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/10": [
		[0, "", "Die [[ship/10]] ist das eigene Schiff von [[character/0]] in der Eröffnungsszene, bewaffnet mit zwei Lasern vom Typ [[item/3]]. Sie verbindet solide Panzerung (200) und 100 t Frachtraum mit vier Sekundärplätzen und einer Wendigkeit von 150, was sie weit beweglicher macht als die [[ship/11]], das Schiff mit dem nächstliegenden Listenpreis. Ihre Schwäche ist die geringe Zahl an Ausrüstungsplätzen: nur fünf. Gewöhnliche Händler bieten sie nie an.", false],
		[2, "", "Ein Ausfall des Hyperantriebs trägt [[character/0]] zur Station [[station/78]], wo [[character/2]] das Wrack birgt und als Ersatzteillager ausschlachtet. Keith bekommt es nie zurück.", false],
	],
	"ship/11": [
		[0, "", "Die [[ship/11]] ist ein gut ausgestatteter schwerer Frachter: 180 t Frachtraum, 210 Panzerung, ein Geschützturmplatz, zwei Primär- und zwei Sekundärplätze und acht Ausrüstungsplätze. Ihre Wendigkeit von 75 ist schwach. Gegenüber der günstigeren [[ship/7]] gibt sie 60 t Frachtraum für einen zusätzlichen Sekundärplatz und einen zusätzlichen Ausrüstungsplatz auf.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/12": [
		[0, "", "Die [[ship/12]] ist ein Jäger, der um seine Sekundärwaffen herum gebaut ist: drei Sekundärplätze, zwei Primärkanonen, sechs Ausrüstungsplätze, 175 Panzerung und eine Wendigkeit von 132. Ihr Frachtraum von 30 t ist sehr klein, daher eignet sie sich kaum für Handel oder Bergbau. Die [[ship/30]] kostet mehr und bietet weniger Panzerung und einen Sekundärplatz weniger.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/16": [
		[0, "", "Die [[ship/16]] ist ein raketenlastiger Jäger mit vier Sekundärplätzen, zwei Primärkanonen, zehn Ausrüstungsplätzen, 180 Panzerung und einer Wendigkeit von 120. Ihr Frachtraum von 45 t ist klein. Die teurere [[ship/21]] bietet zwei weitere Primärkanonen und einen Ausrüstungsplatz mehr.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/17": [
		[0, "", "Die [[ship/17]] trägt vier Primärkanonen, zwei Sekundärplätze und zehn Ausrüstungsplätze. Für ein Schiff ihres Preises sind Panzerung (145), Frachtraum (65 t) und Wendigkeit (95) schwach, daher verlässt sie sich auf ihre Ausrüstung, vor allem Schilde und Panzerplatten. Die günstigere [[ship/19]] hat mehr Panzerung und Frachtraum bei einem Ausrüstungsplatz weniger.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/18": [
		[0, "", "Die [[ship/18]] ist ein kleines, wendiges Schiff (Wendigkeit 145) mit acht Ausrüstungsplätzen; kein günstigeres Schiff hat so viele. Ihre Panzerung von 115 und ihr Frachtraum von 28 t sind dürftig, und sie hat nur zwei Primär- und zwei Sekundärplätze. Sie passt zu einem Piloten, der auf Schilde, Tarnung und andere Ausrüstung statt auf Panzerung setzt.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/19": [
		[0, "", "Die [[ship/19]] ist ein schweres Kanonenboot mit vier Primärplätzen, zwei Sekundärplätzen, neun Ausrüstungsplätzen, 225 Panzerung und 105 t Frachtraum. Ihre Wendigkeit von 90 ist gering. Sie ist das einzige Schiff mit vier nach vorn feuernden Kanonen und einem Frachtraum von mehr als 100 t.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/2": [
		[0, "", "Die [[ship/2]] ist ein wendiger Allrounder unter den günstigen Schiffen: 155 Panzerung, 52 t Frachtraum, ein Primär- und zwei Sekundärplätze, vier Ausrüstungsplätze und eine Wendigkeit von 150. Sie gleicht der [[ship/35]] in allem außer dem Frachtraum, von dem sie 12 t mehr hat. Wer eine zweite Kanone will, sieht sich stattdessen die [[ship/5]] oder die [[ship/6]] an.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/20": [
		[0, "", "Die [[ship/20]] ist ein leichter Jäger, der sechs Ausrüstungsplätze in ein kleines, flinkes Schiff packt (Wendigkeit 155). Sie trägt zwei Primärkanonen, aber nur einen Sekundärplatz, 125 Panzerung und 25 t Frachtraum, womit sie sich mit der [[ship/0]] den kleinsten Frachtraum der Tabelle teilt. Sie passt zu Piloten, die früh Schilde, Booster und andere Ausrüstung wollen und keine Fracht befördern möchten.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/21": [
		[0, "", "Die [[ship/21]] ist das günstigste Schiff mit vier Primär- und vier Sekundärplätzen. Dazu kommen elf Ausrüstungsplätze, 195 Panzerung und 70 t Frachtraum. Ihre Wendigkeit von 100 ist durchschnittlich. Sie ist ein vollwertiges Kampfschiff eine Stufe unter der [[ship/29]].", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/22": [
		[0, "", "Die [[ship/22]] hat den größten Frachtraum aller Schiffe über einer Million Credits (130 t), dazu drei Primär- und drei Sekundärplätze, neun Ausrüstungsplätze und eine Wendigkeit von 118. Ihre Panzerung von 160 ist für den Preis niedrig. Sie passt zu Piloten, die mit demselben Schiff handeln und kämpfen.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/23": [
		[0, "", "Die [[ship/23]] ist das günstigste Schiff mit Geschützturmplatz, und ihre 205 Panzerung sind der höchste Wert aller Schiffe unter 100.000 Credits. Dazu kommen zwei Primär- und zwei Sekundärplätze, fünf Ausrüstungsplätze, 55 t Frachtraum und eine Wendigkeit von 128, was sie zu einem robusten Allrounder der Mittelklasse macht. Ihre größte Einschränkung ist die geringe Zahl an Ausrüstungsplätzen.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/24": [
		[0, "", "Die [[ship/24]] ist ein bewaffneter Händler: drei Primärkanonen, zwei Sekundärplätze, ein Geschützturm, acht Ausrüstungsplätze und 95 t Frachtraum. Ihre Panzerung von 170 ist durchschnittlich, ihre Wendigkeit von 125 dagegen gut für ein Schiff, das so viel trägt. Sie eignet sich gleichermaßen für Handel, Bergbau und Kampf.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/25": [
		[0, "", "Die [[ship/25]] ist ein Raketenträger: vier Sekundärplätze, acht Ausrüstungsplätze und eine Wendigkeit von 130, aber nur eine Primärkanone. Ihre 124 Panzerung und 52 t Frachtraum sind für den Preis schwach, daher ist sie auf Torpedos und Schilde angewiesen. Die [[ship/1]] bietet für ein Drittel des Preises ebenso viele Sekundärplätze plus einen Geschützturm, bei weniger Ausrüstungsplätzen.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/26": [
		[0, "", "Die [[ship/26]] ist das günstigste Schiff mit sieben Ausrüstungsplätzen. Ansonsten ist sie ein durchschnittlicher Allrounder: 152 Panzerung, 64 t Frachtraum, zwei Primär- und zwei Sekundärplätze und eine Wendigkeit von 108. Sie passt zu Piloten, die eine vollständige Ausrüstung wollen, bevor sie sich ein schwereres Schiff leisten können.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/27": [
		[0, "", "Die [[ship/27]] ist das günstigste Schiff mit drei Primärplätzen. Sie kombiniert sie mit 176 Panzerung, zwei Sekundärplätzen, sechs Ausrüstungsplätzen und 50 t Frachtraum. Ihre Wendigkeit von 113 ist eher gering, daher steckt sie lieber Treffer ein, als ihre Gegner auszumanövrieren.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/28": [
		[0, "", "Die [[ship/28]] ist der vollständigste käufliche Allrounder: drei Primär- und vier Sekundärplätze, ein Geschützturm, zwölf Ausrüstungsplätze und 110 t Frachtraum. Kein anderes käufliches Schiff hat einen Geschützturm und so viele Ausrüstungsplätze. Ihre Panzerung von 195 ist gut, ihre Wendigkeit von 92 gering. Die [[ship/29]] kämpft besser, trägt aber viel weniger.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/29": [
		[0, "", "Die [[ship/29]] ist das teuerste Schiff, das gewöhnliche Händler verkaufen, und ihr bester Jäger: vier Primär- und vier Sekundärplätze, zwölf Ausrüstungsplätze, 240 Panzerung und eine Wendigkeit von 118. Ihr Frachtraum von 75 t ist bescheiden, und sie hat keinen Geschützturm. Nur die [[ship/8]] übertrifft sie im Kampf.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/3": [
		[0, "", "Die [[ship/3]] ist ein ausgewogener früher Allrounder: zwei Primär- und zwei Sekundärplätze, fünf Ausrüstungsplätze, 135 Panzerung und 55 t Frachtraum. Ihre Wendigkeit von 112 ist für ein kleines Schiff gering. Sie kostet etwa so viel wie die [[ship/6]], die viel schneller dreht, aber weniger Panzerung, weniger Frachtraum und einen Sekundärplatz weniger hat.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/30": [
		[0, "", "Die [[ship/30]] ist ein Jäger der Mittelklasse: 165 Panzerung, 45 t Frachtraum, zwei Primär- und zwei Sekundärplätze, sechs Ausrüstungsplätze und eine Wendigkeit von 128. Für ihren Preis hat sie keine besondere Stärke; die günstigere [[ship/12]] hat mehr Panzerung und einen zusätzlichen Sekundärplatz, und die [[ship/23]] bietet zusätzlich einen Geschützturm.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/31": [
		[0, "", "Die [[ship/31]] ist ein leichter Frachter mit 110 t Frachtraum, einem Geschützturmplatz, zwei Primärkanonen und sechs Ausrüstungsplätzen. Ihre Panzerung (156), der einzelne Sekundärplatz und die Wendigkeit von 102 sind bescheiden. Sie konkurriert mit der günstigeren [[ship/33]], die etwas weniger Frachtraum und eine Kanone weniger hat, dafür aber mehr Panzerung und bessere Wendigkeit.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/32": [
		[0, "", "Die [[ship/32]] ist das günstigste Schiff, das ein Händler verkauft, und der übliche erste Kauf. Sie ist klein und dünn geschützt (100 Panzerung, 30 t Frachtraum, ein Primär- und ein Sekundärplatz, drei Ausrüstungsplätze), doch mit einer Wendigkeit von 160 dreht nur die [[ship/4]] schneller. Gegenüber der [[ship/0]] bietet sie etwas mehr Panzerung und Frachtraum und ist wendiger. Die [[ship/35]] kostet etwa 8.000 Credits mehr und bringt weit bessere Panzerung, einen zweiten Sekundärplatz und einen vierten Ausrüstungsplatz.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/33": [
		[0, "", "Die [[ship/33]] ist das günstigste Schiff mit mehr als 100 t Frachtraum (108 t), und dazu kommen ein Geschützturmplatz, 176 Panzerung und sechs Ausrüstungsplätze. Mit nur einer Primärkanone und einer Wendigkeit von 112 ist sie eher ein wehrhafter Frachter als ein Jäger. Die [[ship/31]] ist eine enge Konkurrentin mit einer zweiten Kanone und etwas größerem Frachtraum, aber schwächer und langsamer.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/34": [
		[0, "", "Die [[ship/34]] ist ein Kanonenboot mit vier Primärplätzen, einem Sekundärplatz, sechs Ausrüstungsplätzen, 60 t Frachtraum und einer Wendigkeit von 130. Gegenüber der günstigeren [[ship/4]] gibt sie Panzerung (135 gegenüber 170) und Beweglichkeit für mehr Frachtraum und einen zusätzlichen Ausrüstungsplatz auf.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/35": [
		[0, "", "Die [[ship/35]] ist ein leichter Jäger am unteren Ende der Preisliste. Für ihr Geld bietet sie gute Panzerung (155), einen Primär- und zwei Sekundärplätze, vier Ausrüstungsplätze und eine flinke Wendigkeit von 150, aber nur 40 t Frachtraum. Die [[ship/2]] ist fast dasselbe Schiff mit 12 t mehr Frachtraum für ein paar Tausend Credits mehr, während die [[ship/5]] Beweglichkeit gegen mehr Panzerung, Frachtraum und eine zweite Kanone tauscht.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/36": [
		[0, "", "Die [[ship/36]] ist der größte Frachter im Spiel, mit 350 t Frachtraum. Sie hat überhaupt keinen Primärplatz und muss sich zur Verteidigung auf ihre vier Sekundärplätze und einen Geschützturm verlassen. Sieben Ausrüstungsplätze und 200 Panzerung sind gut, doch ihre Wendigkeit von 45 ist der niedrigste Wert der Tabelle. Die [[ship/7]] fasst weniger, behält aber zwei nach vorn feuernde Kanonen und dreht besser.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/4": [
		[0, "", "Die [[ship/4]] ist das günstigste Schiff mit vier Primärplätzen und mit einer Wendigkeit von 162 das beweglichste Schiff im Spiel. Ihre 170 Panzerung sind für den Preis gut. Der Preis dafür sind 38 t Frachtraum, ein einziger Sekundärplatz und fünf Ausrüstungsplätze, daher ist sie ein reiner Luftkämpfer. Die [[ship/34]] trägt ebenfalls vier Kanonen, mit mehr Frachtraum und Ausrüstungsplätzen, aber weniger Panzerung und Beweglichkeit.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/5": [
		[0, "", "Die [[ship/5]] ist das günstigste Schiff mit zwei Primärplätzen, und ihre 170 Panzerung sind für den Preis hoch. Mit 60 t Frachtraum eignet sie sich auch für frühen Handel und Bergbau. Die Nachteile sind ein einziger Sekundärplatz, nur vier Ausrüstungsplätze und eine träge Wendigkeit von 115. Wer Beweglichkeit über Panzerung stellt, wählt zu ähnlichem Preis die [[ship/2]] oder die [[ship/35]].", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/6": [
		[0, "", "Die [[ship/6]] ist ein leichter, schneller Jäger mit zwei Primärplätzen, einem Sekundärplatz, fünf Ausrüstungsplätzen und einer Wendigkeit von 148. Ihre Panzerung von 105 ist sehr dünn; nur die [[ship/0]] und die [[ship/32]] haben weniger, daher setzt sie auf Tempo statt Zähigkeit. Zu fast demselben Preis bietet die [[ship/3]] mehr Panzerung, mehr Frachtraum und einen zweiten Sekundärplatz, auf Kosten der Wendigkeit.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/7": [
		[0, "", "Die [[ship/7]] ist ein schwerer Frachter mit 240 t Frachtraum, 220 Panzerung, einem Geschützturmplatz, zwei Primärkanonen, einem Sekundärplatz und sieben Ausrüstungsplätzen. Mit einer Wendigkeit von 65 dreht sie langsam. Gegenüber der [[ship/36]] gibt sie 110 t Frachtraum für nach vorn feuernde Kanonen und bessere Wendigkeit auf; die teurere [[ship/11]] bietet einen zusätzlichen Ausrüstungsplatz und einen zweiten Sekundärplatz.", false],
		[0, "", "Jeder Händler außerhalb der [[faction/1|Vossk]]-Systeme kann sie führen.", false],
	],
	"ship/8": [
		[0, "", "Die [[ship/8]] ist ein restaurierter [[faction/9|Void]]-Jäger und das stärkste Schiff im Spiel. Ihre 450 Panzerung sind fast doppelt so viel wie bei jedem anderen Schiff, sie hat vier Primär- und vier Sekundärplätze und fünfzehn Ausrüstungsplätze, und ihre Wendigkeit von 155 gehört zu den besten. Die einzige Schwäche sind 30 t Frachtraum. Ihr Listenpreis von über acht Millionen Credits ist fast doppelt so hoch wie der der [[ship/29]].", false],
		[0, "", "Gewöhnliche Händler verkaufen sie nicht. Sie wird nur auf der Station [[station/10]] als Prototyp angeboten, sobald der Spieler jede Medaille in Gold besitzt (siehe [[guide/medals]]).", false],
	],
	"ship/9": [
		[0, "", "Die [[ship/9]] ist das einzige Schiff, das [[faction/1|Vossk]]-Händler verkaufen, und sie verkaufen sonst keines. Ihre 250 Panzerung sind der höchste Wert aller Schiffe außer der [[ship/8]], und sie verbindet das mit einer flinken Wendigkeit von 152, zwei Primär- und zwei Sekundärplätzen, sieben Ausrüstungsplätzen und 65 t Frachtraum. In ihrer Preisklasse ist sie der zäheste erhältliche Jäger, auch wenn ihr der Geschützturm und die zusätzlichen Plätze der [[ship/1]] fehlen.", false],
		[36, "", "[[character/7]] erklärt, dass [[faction/1|Vossk]]-Schiffe normalerweise nur von ihrer eigenen Rasse geflogen werden; dieses Schiff ist die Ausnahme, ein angepasstes Modell, das an andere Rassen verkauft werden kann.", false],
	],
	"station/0": [
		[0, "", "Die Station [[station/0]] trägt das Sprungtor von [[system/0]]. Die Wartezeit von [[step/13]] ist unter dieser Station verzeichnet, doch dieser Schritt wird durch das Erledigen von Lounge-Aufträgen an beliebigen Orten abgeschlossen, und hier geschieht nichts.", false],
	],
	"station/10": [
		[0, "", "Die Station [[station/10]] ist die einzige Station von [[system/6]] und trägt dessen Sprungtor. Freelance-Aufträge führen dich nie hierher. Der Agent [[agent/3]] verkauft in ihrer Lounge einen Bauplan, und sobald jede Medaille Gold ist, bietet die Station einen Prototyp der [[ship/8]] an.", false],
		[23, "", "Die Station ist die geheime Forschungsbasis von Deep Science unter der Leitung von [[character/6]]. [[character/0]] kommt in [[step/23]] mit [[character/5]] hier an und kehrt mehrmals zurück: um die Expedition zu den Voids zu planen, um [[character/20]] zu treffen und um seine Kristalle abzuliefern.", false],
	],
	"station/18": [
		[0, "", "Die Station [[station/18]] ist eine bescheidene Vossk-Station in [[system/3]]. Der Agent [[agent/12]] verkauft in ihrer Lounge die Koordinaten von [[system/0]].", false],
	],
	"station/20": [
		[0, "", "Die Station [[station/20]] trägt das Sprungtor von [[system/4]]. Der midorianische Agent [[agent/2]] verkauft in ihrer Lounge einen Waffenbauplan.", false],
	],
	"station/22": [
		[0, "", "Die Station [[station/22]] ist die fortschrittlichste Station in [[system/4]].", false],
		[38, "", "In [[step/38]] wird der Konvoi mit den nivelianischen Sprengstoffen unter einer Eskorte midorianischer Jäger nahe der Station gesichtet. [[character/0]] muss die Eskorte vertreiben, ohne den Konvoi zu zerstören.", false],
	],
	"station/26": [
		[0, "", "Die Station [[station/26]] ist eine Vossk-Station auf höchstem Techlevel in [[system/5]]. Der bobolianische Agent [[agent/13]] verkauft in ihrer Lounge die Koordinaten von [[system/1]].", false],
	],
	"station/27": [
		[36, "", "Nahe [[station/27]] greifen [[character/7]] und [[character/0]] in [[step/36]] ein Piratenversteck an; wer mehr Piraten zerstört, gewinnt.", false],
		[37, "", "[[character/0]] gewinnt und erwirbt das Recht, den Vossk-Frachter zu eskortieren. Von hier aus erstattet er [[character/1]] Bericht.", false],
	],
	"station/29": [
		[35, "", "Die Station [[station/29]] ist die Station des Vossk-Kommandanten [[character/7]], der zugesagt hat, einen K'Sarr-Frachter für den Angriff auf die Voids zu stellen. [[character/0]] trifft ihn hier in [[step/35]].", false],
		[36, "", "[[character/7]] lässt niemanden außer einem Vossk den Frachter fliegen und fordert [[character/0]] heraus, sich als Eskortpilot zu beweisen.", false],
	],
	"station/3": [
		[0, "", "Die Station [[station/3]] ist eine nivelianische Hightech-Station im verborgenen System [[system/0]]. In ihrer Lounge sitzt der Agent [[agent/0]], der einen Waffenbauplan verkauft.", false],
	],
	"station/30": [
		[34, "", "[[character/1]] wartet in [[step/34]] auf der Station [[station/30]] mit einem Plan gegen das Mutterschiff der Voids.", false],
		[35, "", "Der Plan sieht vor, einen schweren Frachter voller nivelianischer Atomsprengstoffe in das Mutterschiff zu fliegen.", false],
		[39, "", "Die zurückgewonnenen Sprengstoffe treffen hier ein und werden in den Vossk-Frachter verladen. In [[step/39]] erklärt [[character/1]] den letzten Einsatz.", false],
	],
	"station/43": [
		[0, "", "Die Station [[station/43]] ist eine kleine terranische Station in [[system/8]]. Der Agent [[agent/4]] verkauft in ihrer Lounge einen günstigen Raketenbauplan.", false],
	],
	"station/48": [
		[24, "", "Nahe der Station [[station/48]] wurden Void-Schiffe gesichtet. In [[step/24]] bringt [[character/0]] [[character/6]] hierher, um sie zu beobachten und mit einem Traktorstrahl Wrackteile einzusammeln.", false],
		[25, "", "Am Ende der Bergung verschluckt ein Wurmloch das Schiff von [[character/0]] mit [[character/6]] an Bord.", false],
		[27, "", "Als sie durch ein anderes Wurmloch zurückkehren, folgen ihnen Void-Jäger, und [[character/0]] muss sie hier zerstören, bevor er zur Station [[station/10]] zurückkehrt.", false],
	],
	"station/54": [
		[0, "", "Die Station [[station/54]] ist eine Vossk-Station auf höchstem Techlevel in [[system/10]], einem System, das nur ein Sprungantrieb erreicht. Der Vossk-Agent [[agent/5]] verkauft in ihrer Lounge einen Raketenbauplan.", false],
	],
	"station/55": [
		[0, "", "Die Station [[station/55]] trägt das Sprungtor von [[system/11]].", false],
		[19, "", "Nahe der Station werden Piraten gefunden, die [[character/5]] für Lösegeld gefangen halten. Deep Science hinterlegt in ihrem Hangar EMP-Bomben für [[character/0]].", false],
		[22, "", "Nach der Rettung trifft [[character/0]] den befreiten Offizier auf der Station und erhält die Koordinaten von [[system/6]].", false],
	],
	"station/56": [
		[18, "", "Die Station [[station/56]] ist der Treffpunkt, an dem [[character/0]] in [[step/18]] einen Offizier von Deep Science abholen soll.", false],
		[19, "", "Der Offizier kommt nie an. Stattdessen meldet eine Nachricht von [[character/1]], dass Piraten ihn entführt haben.", false],
	],
	"station/59": [
		[0, "", "Die Station [[station/59]] ist eine kleine Station im Vossk-System [[system/20]]. In ihrer Lounge sitzt ein Terraner, der Agent [[agent/10]], der einen Bauplan für eine Tarnvorrichtung verkauft.", false],
	],
	"station/61": [
		[0, "", "Die Station [[station/61]] ist eine von nur zwei Stationen in [[system/12]]. Der multipodische Agent [[agent/6]] verkauft in ihrer Lounge einen Bauplan für eine Atomwaffe.", false],
	],
	"station/65": [
		[0, "", "Die Station [[station/65]] trägt das Sprungtor von [[system/13]]. Der Cyborg-Agent [[agent/14]] verkauft in ihrer Lounge die Koordinaten von [[system/10]].", false],
	],
	"station/72": [
		[0, "", "Die Station [[station/72]] ist eine kleine terranische Station im sicheren System [[system/14]]. Der Agent [[agent/7]] verkauft in ihrer Lounge einen Schildbauplan.", false],
	],
	"station/76": [
		[11, "", "Die Station [[station/76]] in [[system/15]] antwortet nicht mehr auf Funkrufe. In [[step/11]] schickt [[character/3]] [[character/0]] los, um herauszufinden, warum.", false],
		[12, "", "Die Station ist unversehrt. Ihre Besatzung ist schlicht nicht arbeitsfähig, dank einer Ladung Neuro-Algen, die der Dealer [[character/4]] geliefert hat, ein alter Bekannter von [[character/0]].", false],
	],
	"station/78": [
		[0, "", "Die Station [[station/78]] ist die kleine Bergbaustation des nivelianischen Erzhändlers [[character/2]] in [[system/15]]. In ihrem Orbit beginnt die Geschichte.", false],
		[1, "", "Das beschädigte Schiff von [[character/0]] treibt im Autopilot hierher, und [[character/2]] nimmt es samt Pilot auf.", false],
		[2, "", "[[character/2]] schlachtet das Wrack aus und lässt [[character/0]] mit der [[ship/0]] in den nahen Asteroiden Erz abbauen.", false],
		[8, "", "Nachdem er einem Piratenüberfall entkommen ist, baut [[character/0]] seine erste Waffe ein und hilft [[character/2]], das Piratenversteck nahe der Station zu zerstören.", false],
		[10, "", "[[character/2]] schenkt ihm daraufhin das Schiff und schickt ihn weiter zur Station [[station/79]].", false],
		[0, "", "Später im Spiel verkauft [[character/2]] in der Lounge der Station den Bauplan seines Bergbaubohrers.", false],
	],
	"station/79": [
		[0, "", "Die Station [[station/79]] liegt in [[system/15]] und ist der Sitz ihres Kommandanten [[character/3]].", false],
		[10, "", "[[character/2]] schickt [[character/0]] in [[step/9]] hierher, um [[character/3]] zu treffen, einen Menschen, der ihm helfen kann, den terranischen Raum zu erreichen.", false],
		[11, "", "[[character/3]] erklärt ihm die [[faction/3|Mido-Konföderation]] und bittet ihn als Gegenleistung für seine Hilfe, nach der Station [[station/76]] zu sehen.", false],
		[13, "", "Nach dem Bericht von der Station [[station/76]] verspricht [[character/3]], ihn mit einem terranischen Konvoi in Kontakt zu bringen, der an der Station erwartet wird.", false],
		[15, "", "Als der Konvoi in [[step/14]] eintrifft, hält er [[character/0]] für einen Piraten, legt sein Schiff lahm und nimmt ihn an Bord.", false],
	],
	"station/8": [
		[0, "", "Die Station [[station/8]] ist eine terranische Station im verborgenen System [[system/1]]. Der nivelianische Agent [[agent/1]] verkauft in ihrer Lounge einen Bauplan.", false],
	],
	"station/84": [
		[0, "", "Die Station [[station/84]] ist eine terranische Station in [[system/16]]. Der Vossk-Agent [[agent/8]] verkauft in ihrer Lounge einen Bauplan für Vossk-Panzerung.", false],
	],
	"station/88": [
		[0, "", "Die Station [[station/88]] ist eine kleine nivelianische Station in [[system/17]]. Der Vossk-Agent [[agent/15]] verkauft in ihrer Lounge die Koordinaten von [[system/21]].", false],
	],
	"station/90": [
		[0, "", "Die Station [[station/90]] trägt das Sprungtor von [[system/18]]. Der Agent [[agent/9]] verkauft in ihrer Lounge einen Bauplan für einen Frachtkompressor.", false],
	],
	"station/91": [
		[28, "", "In [[step/28]] wird nahe der Station [[station/91]] Void-Aktivität gemeldet. [[character/0]] kämpft sich hier zu einem Wurmloch durch, um eine Sonde zum Mutterschiff der Voids zu bringen.", false],
		[31, "", "Zurück aus dem Void-Sektor erhält [[character/0]] hier einen Anruf von [[character/1]], der ihn zur Station [[station/98]] einlädt.", false],
	],
	"station/98": [
		[15, "", "Die Station [[station/98]] ist eine terranische Station in [[system/19]]. Der Kreuzer, der [[character/0]] verhaftet hat, bringt ihn hierher, und er findet seinen alten Freund [[character/1]] als Verantwortlichen vor.", false],
		[16, "", "Während ihres Gesprächs greifen Void-Jäger die Station an, und [[character/0]] hilft, sie zu vertreiben.", false],
		[18, "", "[[character/1]] unterrichtet ihn über die Voids und wirbt ihn für Deep Science an.", false],
		[32, "", "In [[step/31]] rüstet [[character/1]] das Schiff von [[character/0]] mit dem Frühwarnsystem aus und erzählt ihm von [[character/20]].", false],
		[44, "", "Nach dem Sieg feiern [[character/0]] und [[character/1]] auf der Station, und [[character/6]] gesellt sich zu ihnen.", false],
		[45, "", "Am nächsten Morgen ist [[character/6]] fort und hinterlässt eine Nachricht und eine letzte Zahlung von Deep Science.", false],
	],
	"step/0": [
		[0, "", "[[character/0]] jagt eine Bande von [[faction/8|Piraten]] durch einen Asteroidengürtel, um das auf sie ausgesetzte Kopfgeld zu kassieren. Du musst jedes Piratenschiff finden und zerstören.", false],
		[1, "", "Nachdem die Piraten erledigt sind, nimmt Keith Kurs auf Eden Prime, wo Admiral Smith ihn wegen eines besonderen Auftrags sprechen will. Als der Hyperantrieb anläuft, trifft ein letzter Schuss sein Schiff. Der Antrieb versagt, die Lebenserhaltung ist schwer beschädigt, und der Autopilot trägt den bewusstlosen Piloten zur nächsten Station, [[station/78]].", false],
	],
	"step/1": [
		[1, "", "Der Autopilot hat Keiths beschädigtes Schiff in eine Umlaufbahn um die Station [[station/78]] gebracht, mit dem bewusstlosen Piloten an Bord.", false],
		[2, "", "Keith erwacht auf einer kleinen Bergbaustation, die [[character/2]] betreibt, ein [[faction/2|nivelianischer]] Erzhändler. Gunant hat das Schiff zerlegt und beansprucht es nach Bergungsrecht. Er lacht über die Idee, Eden Prime zu erreichen, das am anderen Ende der Galaxie liegt, und wundert sich, dass Keith nie von den Voids gehört hat, feindseligen Wesen, die inzwischen sogar im System [[system/15]] auftauchen.", false],
		[2, "", "Keith hat weder Geld noch Schiff und muss deshalb für Gunant arbeiten, indem er mit einem unbewaffneten Schiff Erz abbaut.", false],
	],
	"step/10": [
		[10, "", "Keith fliegt zur Station [[station/79]], um [[character/3]] zu treffen.", false],
		[11, "", "Norris erklärt, dass [[system/15]] in einem erst kürzlich entdeckten Sektor liegt. Terranische und nivelianische Verbannte besiedelten ihn während des Nivelianischen Bürgerkriegs und gründeten eine unabhängige Konföderation. Die Terraner erkennen sie an, doch die Nivelianer beanspruchen das System weiterhin, weshalb an seinen Rändern gekämpft wird.", false],
		[11, "", "Norris bietet an, Keith mit der terranischen Raumflotte in Kontakt zu bringen, wenn er ihm dafür einen Gefallen tut: Der Kontakt zur Station [[station/76]] ist abgebrochen, und ein erfahrener Pilot soll herausfinden, warum.", false],
	],
	"step/11": [
		[11, "", "Keith fliegt zur Station [[station/76]], um ihrem Schweigen nachzugehen. Die Station wirkt unversehrt, ohne Spuren eines Kampfes, also dockt er an.", false],
		[12, "", "Drinnen stößt Keith auf [[character/4]], einen berüchtigten Dealer, den er vor langer Zeit kannte. Mkkt hat eine Ladung Neuro-Algen mitgebracht, und die gesamte Besatzung ist zu berauscht, um die Kommunikation zu bedienen. Keith verschwindet, so schnell er kann.", false],
	],
	"step/12": [
		[12, "", "Keith kehrt zur Station [[station/79]] zurück, um Bericht zu erstatten.", false],
		[13, "", "Norris ist entsetzt und verspricht, sich um den Dealer zu kümmern. Ein terranischer Militärkonvoi ist auf dem Weg nach Kernstal und wird Keith die Gelegenheit geben, Kontakt zur Flotte aufzunehmen. Bis er eintrifft, schlägt Norris vor, dass Keith in der Space Lounge bezahlte Arbeit annimmt (siehe [[guide/lounge]]).", false],
	],
	"step/13": [
		[13, "", "Während er auf den Konvoi wartet, muss Keith zwei Freelance-Aufträge aus der Space Lounge erledigen (siehe [[guide/jobs]]).", false],
		[14, "", "Norris meldet, dass der terranische Konvoi das System erreicht hat und Kurs auf die Station [[station/79]] nimmt. Keith macht sich auf, ihn zu treffen.", false],
	],
	"step/14": [
		[14, "", "Nahe der Station [[station/79]] findet Keith den terranischen Konvoi und einige Piraten. Er greift ein, um die Piraten zu vertreiben.", false],
		[15, "", "In seinem ehemaligen Piratenschiff wird Keith für einen der Angreifer gehalten. Der Konvoi legt sein Schiff mit EMP-Waffen lahm und verhaftet ihn. Er wird an Bord eines terranischen Kreuzers gebracht, der zur Station [[station/98]] im terranischen Raum unterwegs ist.", false],
	],
	"step/15": [
		[15, "", "Keith trifft als Gefangener des Konvois auf der Station [[station/98]] ein.", false],
		[16, "", "Der verantwortliche Offizier ist [[character/1]], ein alter Freund von Keith, inzwischen Chef der Interstellar Security Agency. Er entschuldigt sich für den Irrtum. Ihr Wiedersehen wird jäh unterbrochen, als Void-Jäger im Orbit auftauchen und die Station Alarm gibt.", false],
	],
	"step/16": [
		[16, "", "Brent bittet Keith, die [[faction/9|Void]]-Schiffe zu vertreiben, die die Station [[station/98]] angreifen (siehe [[world/voids]]).", false],
		[17, "", "Die Voids senden eine Botschaft, in der sie friedliche Absichten beteuern, und greifen trotzdem an. Keith schlägt sie zurück, und Brent verspricht, ihm bei einem Glas Wein alles zu erzählen, was er weiß.", false],
	],
	"step/17": [
		[17, "", "Keith dockt an der Station [[station/98]] an, um zu hören, was Brent über die Voids weiß.", false],
		[18, "", "Die Voids sind in den letzten Wochen aufgetaucht. Sie kommen durch eine Art Wurmloch, greifen alles an, was ihnen begegnet, und scheinen es auf Erz abgesehen zu haben; selbst [[faction/1]]-Systeme werden überfallen. Brent leitet einen Krisenstab, dessen Wissenschaftler sich auf einer geheimen Forschungsstation von Deep Science versammeln. Er bittet Keith, für sie zu fliegen.", false],
		[18, "", "Das System der Station fehlt auf gewöhnlichen Sternkarten, deshalb muss Keith Lt. Thomas Boyle ([[character/5]]) auf der Station [[station/56]] im System [[system/11]] treffen, um die Koordinaten zu erhalten. Brent gibt außerdem zu, dass Keiths Schiff nicht neu ist: Es wurde nur umlackiert, um weitere Verwechslungen zu vermeiden.", false],
	],
	"step/18": [
		[18, "", "Keith fliegt zur Station [[station/56]], um Boyle zu treffen.", false],
		[19, "", "Boyle ist nie angekommen. Brent berichtet, dass Piraten ihn nahe der Station [[station/55]] entführt haben und fünf Millionen Credits Lösegeld fordern. Brent ist bereit zu zahlen, doch Keith rechnet damit, dass die Entführer Boyle nach der Zahlung töten, und fliegt stattdessen nach Kappa.", false],
	],
	"step/19": [
		[19, "", "Keith fliegt zur Station [[station/55]], um nach den Entführern zu suchen.", false],
		[20, "", "Die Scanner von Kappa orten das Schiff der Entführer. Brent hat EMP-Bomben im Hangar der Station hinterlegen lassen, damit Keith das Schiff lahmlegen kann, während die Entführer glauben, er bringe das Lösegeld.", false],
	],
	"step/2": [
		[2, "", "Gunant gibt Keith ein altes, vielfach geflicktes Schiff, die [[ship/0]], ein ehemaliges Piratenschiff mit Bergbaulaser und ohne Waffen. Keith muss mindestens zehn Tonnen Erz aus den Asteroiden nahe der Station [[station/78]] abbauen (siehe [[guide/mining]]).", false],
		[3, "", "Mit dem Erz an Bord fordert Gunant ihn auf anzudocken, damit die Ladung geprüft werden kann. Ohne Waffen bleibt Keith nichts anderes übrig, als mitzuspielen.", false],
	],
	"step/20": [
		[20, "", "Keith muss an der Station [[station/55]] andocken und die EMP-Bomben an seinem Schiff einbauen.", false],
		[21, "", "Mit montierten Bomben bricht Keith sofort auf.", false],
	],
	"step/21": [
		[21, "", "Ein Wegpunkt markiert das Schiff der Entführer, das womöglich nicht allein ist. Keith muss es mit einer EMP-Bombe lahmlegen, statt es zu zerstören, und sich um eine etwaige Eskorte kümmern.", false],
		[22, "", "Die Entführer glauben, das Lösegeld sei eingetroffen, bis die Bombe ihre Systeme ausschaltet. Brent schickt ein Team, um Boyle zu holen.", false],
	],
	"step/22": [
		[22, "", "Keith dockt an der Station [[station/55]] an, um den geretteten Wissenschaftler zu treffen.", false],
		[23, "", "Boyle dankt ihm. Da sein eigenes Schiff verloren ist, bietet Keith ihm an, ihn mitzunehmen, und Boyle überträgt die Koordinaten des Systems [[system/6]], in dem die Forschungsstation liegt, in Keiths Navigationscomputer.", false],
	],
	"step/23": [
		[23, "", "Keith bringt Boyle zur Station [[station/10]] im System [[system/6]], wo Dr. Paolini sie erwartet.", false],
		[24, "", "Keith trifft Dr. Carla Paolini ([[character/6]]), die das Projekt von Deep Science leitet. Sie will mehr über die Technologie der Voids erfahren, beginnend mit Wrackteilen von Void-Schiffen. Deep Science zahlt Keith 20.000 Credits, um sein Schiff auszurüsten, und ein Traktorstrahl ist unerlässlich.", false],
		[24, "", "Carla besteht darauf, mit ihm zur Station [[station/48]] im System [[system/9]] zu fliegen, wo kürzlich Voids gesichtet wurden. Keith widerspricht, gibt aber nach.", false],
	],
	"step/24": [
		[24, "", "Bei der Station [[station/48]] will Carla die Voids aus möglichst großer Nähe sehen. Die Voids verkünden, dass sie aus der Zukunft stammen und alles sind, was von den Zivilisationen der Galaxie übrig ist. Keith muss sie bekämpfen und die Überreste ihrer Schiffe mit einem Traktorstrahl einsammeln.", false],
		[25, "", "Sobald genug Wrackteile an Bord sind, will Carla zurückkehren, doch plötzlich erfasst etwas das Schiff.", false],
	],
	"step/25": [
		[25, "", "Keith und Carla kommen weit entfernt von der Station [[station/48]] wieder zu sich, in einer Region des Weltraums, die keiner von beiden kennt.", false],
		[26, "", "Ganz in der Nähe liegt ein gigantisches Void-Mutterschiff, das Jäger ausschleust. Keith folgert, dass sie durch ein Wurmloch in den Heimatsektor der Voids geraten sind. Dieses Wurmloch ist verschwunden, doch solche Öffnungen scheinen zusammenzubrechen und anderswo neu zu erscheinen, also muss er ein anderes erreichen, um heimzukehren.", false],
	],
	"step/26": [
		[26, "", "Das Wurmloch bringt sie zurück zur Station [[station/48]], doch Void-Jäger sind ihnen gefolgt. Keith muss sie zerstören, damit sie dem Schiff nicht bis zur Station [[station/10]] folgen können.", false],
		[27, "", "Nachdem die Verfolger erledigt sind, kehren die beiden dringend erholungsbedürftig nach Thynome zurück.", false],
	],
	"step/27": [
		[27, "", "Keith dockt an der Station [[station/10]] an.", false],
		[28, "", "Zwei Tage später bittet Carla ihn, zurückzukehren. Ihr Team hat eine Sonde gebaut, die, auf das Mutterschiff abgeschossen, es analysiert und die Ergebnisse an Keiths Schiff sendet. Sie selbst bleibt, um die Wrackteile zu untersuchen, und schickt ihn ins System [[system/18]], wo gerade Voids gemeldet wurden, um ein weiteres Wurmloch zu finden.", false],
		[28, "", "Keith willigt unter einer Bedingung ein: Wenn er lebend zurückkehrt, schuldet Carla ihm ein Date. Sie nimmt an.", false],
	],
	"step/28": [
		[28, "", "Nahe der Station [[station/91]] treffen Void-Jäger ein, und Keith muss das Wurmloch erreichen, bevor es zusammenbricht. Die Voids warnen, dass ihre Vernichtung seine eigene Zukunft vernichten wird.", false],
		[29, "", "Keith erreicht das Wurmloch und fliegt hindurch in den Void-Raum.", false],
	],
	"step/29": [
		[29, "", "In der Nähe des Mutterschiffs muss Keith es erfassen, wodurch die Sonde startet, und dann durchhalten, bis die Sonde ihre Analyse abgeschlossen hat.", false],
		[30, "", "Während des Wartens senden die Voids erneut: Sie müssten einen Weg finden, miteinander zu reden, bevor die Menschen sie und mit ihnen ihre eigene Zukunft zerstören. Keith hält durch, bis die Datenübertragung abgeschlossen ist, und fliegt davon.", false],
	],
	"step/3": [
		[3, "", "Keith dockt an der Station [[station/78]] an, um seine erste Ladung Erz abzuliefern.", false],
		[4, "", "Gunant ist einigermaßen zufrieden, schickt Keith aber erneut los, diesmal, um den ganzen Frachtraum zu füllen. Er scherzt, Keith dürfe das Schiff vielleicht eines Tages behalten, wenn er sich benimmt.", false],
	],
	"step/30": [
		[30, "", "Zurück durch das Wurmloch wartet Keith nahe der Station [[station/91]].", false],
		[31, "", "Brent ruft an und bittet ihn, vor seiner Rückkehr nach Thynome auf der Station [[station/98]] im System [[system/19]] Halt zu machen, und verspricht eine Überraschung. Die Sondendaten können von dort an Carla geschickt werden.", false],
	],
	"step/31": [
		[31, "", "Keith dockt an der Station [[station/98]] an, um Brent zu sehen.", false],
		[32, "", "Brents Team hat ein Frühwarnsystem für die Sternkarte entwickelt. Es zeigt, wo die Voids gleich ein Wurmloch öffnen werden, und Keiths Navigationscomputer wird für den Empfang umgerüstet. Brent möchte, dass er zu diesen Orten fliegt und die örtlichen Kräfte unterstützt, und zahlt ihm 30.000 Credits.", false],
		[32, "", "Brent fügt hinzu, dass ein [[faction/7|Grey]] namens [[character/20]], der für Deep Science arbeitet, Keith sprechen möchte.", false],
	],
	"step/32": [
		[32, "", "Keith kehrt zur Station [[station/10]] zurück, um [[character/20]] zu treffen.", false],
		[33, "", "Khador hat die Void-Wrackteile untersucht. Er glaubt, dass das Geheimnis der Void-Wurmlöcher in der Struktur bestimmter Kristalle liegt, die es nur im Void-Sektor gibt. Er entwickelt einen Antrieb, der ein Schiff augenblicklich an jeden Punkt im All bringen soll, und bittet Keith, ihm mindestens 50 dieser Kristalle zu bringen.", false],
		[33, "", "Keith muss erneut in ein Wurmloch fliegen und diesmal Brents Frühwarnsystem nutzen, um eines zu finden.", false],
	],
	"step/33": [
		[33, "", "Keith muss im Void-Sektor 50 [[item/164]] sammeln und zur Station [[station/10]] bringen.", false],
		[34, "", "Khador ist begeistert und gibt Keith eine Kopie seines Bauplans für den [[item/85]], damit Keith sich selbst einen bauen kann (siehe [[guide/blueprints]]). Ein solcher Antrieb erreicht sogar den Heimatsektor der Voids.", false],
		[34, "", "Carla erscheint, zu beschäftigt für ihr Date. Sie erzählt Keith, dass sie und Brent einen Plan ausgearbeitet haben, und schickt ihn zu Brent auf die Station [[station/30]] im System [[system/2]].", false],
	],
	"step/34": [
		[34, "", "Keith fliegt zur Station [[station/30]], um Brents Plan zu hören.", false],
		[35, "", "Die Sondendaten zeigen, dass das Mutterschiff die Quelle der Wurmlöcher ist. Bisher hat ihm keine Waffe geschadet, deshalb soll ein robuster Frachter voller nivelianischer Atomsprengstoffe mitten hineinfliegen.", false],
		[35, "", "Ein Vossk-Frachter vom Typ K'Sarr eignet sich am besten für die Aufgabe. Brent hat vereinbart, einen solchen im Rahmen eines geheimen Gefangenenaustauschs von [[character/7]] zu erhalten, dem Kommandanten der Station [[station/29]] im System [[system/5]]. Errkt besteht darauf, den Piloten persönlich kennenzulernen.", false],
	],
	"step/35": [
		[35, "", "Keith fliegt in das Gebiet der [[faction/1]], um [[character/7]] auf der Station [[station/29]] zu treffen.", false],
		[36, "", "Errkt, der sich Keiths Akte angesehen hat, ist überzeugt, dass nur ein Vossk ein Vossk-Schiff richtig fliegen kann. Da die Mission nicht scheitern darf, wird er den Frachter selbst steuern. Zuerst aber muss Keith nahe dem Planeten [[station/27]] sein Können als Jagdpilot beweisen.", false],
	],
	"step/36": [
		[36, "", "Errkt schlägt einen Wettstreit bei einem Piratenversteck nahe [[station/27]] vor: Wer mehr Piraten abschießt, gewinnt.", false],
		[37, "", "Keith gewinnt. Errkt erkennt ihn als fähigen Piloten an und gewährt ihm die Ehre, den Frachter zu eskortieren, den er zum vereinbarten Treffpunkt bringen wird. Keith ruft Brent an, um Bericht zu erstatten.", false],
	],
	"step/37": [
		[37, "", "Keith meldet sich von [[station/27]] aus bei Brent, um über seine Gespräche mit Errkt zu berichten.", false],
		[38, "", "Das Vossk-Imperium hat seine Unterstützung bestätigt, und Brent akzeptiert Errkt als Piloten. Ein neues Problem ist aufgetaucht: Schiffe der [[faction/3|Mido-Konföderation]], die sich mit den Nivelianern im Krieg befindet, haben den Konvoi mit den nivelianischen Sprengstoffen gekapert. Er wurde im System [[system/4]] nahe der Station [[station/22]] gesichtet, und Keith erklärt sich bereit, ihn abzufangen.", false],
	],
	"step/38": [
		[38, "", "Nahe der Station [[station/22]] findet Keith den gestohlenen Konvoi mit einer Eskorte aus Mido-Jägern. Er muss die Eskorte zerstören, ohne die Schiffe des Konvois zu beschädigen.", false],
		[39, "", "Als der Konvoi wieder unter Kontrolle ist, übergibt Brent ihn den örtlichen Sicherheitskräften für den Flug zur Station [[station/30]] und bittet Keith, ebenfalls dorthin zurückzukehren.", false],
	],
	"step/39": [
		[39, "", "Keith dockt an der Station [[station/30]] zur letzten Einsatzbesprechung an.", false],
		[40, "", "Die Sprengstoffe werden an Bord des Vossk-Frachters verladen, und Errkt bleibt sein Pilot. Sobald die Voids das nächste Mal auftauchen, fliegen Keith und Errkt dorthin. Errkt hält auf das erste Wurmloch zu, und Keith gibt ihm Deckung und folgt. Brent wird die nächstgelegene Station um Verstärkung bitten.", false],
		[40, "", "Errkt soll kurz vor dem Aufprall in einer Rettungskapsel aussteigen. Keith muss es zurück durch das Wurmloch schaffen, bevor das Mutterschiff zerstört wird, sonst gibt es keinen Weg nach Hause.", false],
	],
	"step/4": [
		[4, "", "Keith kehrt zu den Asteroiden zurück, um abzubauen, bis der Frachtraum voll ist.", false],
		[5, "", "Während er abbaut, nähert sich ein Piratenschiff. Da Keith unbewaffnet ist, soll er zur Station fliehen und dem Feuer ausweichen.", false],
	],
	"step/40": [
		[40, "", "Mithilfe des Frühwarnsystems fliegt Keith zu einem Orbit, der von den Voids angegriffen wird. Errkt trifft mit dem Frachter ein und hält auf das erste Wurmloch zu, und Lt. [[character/8]] stößt mit seiner Staffel hinzu. Keith muss den Frachter schützen, bis er hindurch ist.", false],
		[41, "", "Die Panzerung des Frachters ist schwer beschädigt, doch Errkt erreicht das Wurmloch, und Keith folgt ihm hindurch.", false],
	],
	"step/41": [
		[41, "", "Baffours Staffel hat es nicht rechtzeitig durch das Wurmloch geschafft, also sind Keith und Errkt allein. Der Frachter ist auf Kollisionskurs mit dem Mutterschiff, und Keith muss die Void-Jäger auf seinem Weg beseitigen.", false],
		[42, "", "Als der Frachter sich nähert, meldet Errkt, dass seine Rettungskapsel getroffen wurde. Er beschließt, beim Frachter zu bleiben, und befiehlt Keith, zu verschwinden, solange noch Zeit ist. Keith verabschiedet sich und kehrt um.", false],
	],
	"step/42": [
		[42, "", "Keith muss sich in Sicherheit bringen, während Errkts Frachter auf sein Ziel zuhält.", false],
		[43, "", "Brent meldet, dass im ganzen Sektor Wurmlöcher zusammengebrochen sind: Der Plan ist aufgegangen. Keith berichtet ihm, dass Errkt nicht überlebt hat, und Brent verspricht, ihn in seinem Bericht an das Vossk-Imperium zu würdigen. Sie verabreden sich auf einen Drink auf der Station [[station/98]].", false],
	],
	"step/43": [
		[43, "", "Keith trifft Brent auf der Station [[station/98]], um zu feiern.", false],
		[44, "", "Nach einigen Drinks erscheint Carla im Abendkleid, um das Date einzulösen, das sie Keith schuldet. Brent lässt die beiden taktvoll allein.", false],
	],
	"step/44": [
		[44, "", "Keith erwacht nach seiner Nacht mit Carla verkatert auf der Station [[station/98]].", false],
		[45, "", "Carla ist fort. Ihre Nachricht erklärt, dass sie zu einem anderen Geheimprojekt an einem Ort aufgebrochen ist, den sie nicht verraten will, und dass Deep Science Keith abschließend 40.000 Credits zahlt. Keith ahnt, dass er die ganze Zeit benutzt wurde, und geht zurück an die Bar.", false],
	],
	"step/45": [
		[45, "", "Die Geschichte ist abgeschlossen. Das Mutterschiff der Voids ist zerstört, die Wurmlöcher haben sich geschlossen, und [[character/0]] kann hingehen, wohin er will. Du kannst weiterhin in der ganzen Galaxie fliegen, handeln, Erz abbauen und Aufträge annehmen; eine Zusammenfassung der gesamten Geschichte findest du unter [[world/history]].", false],
	],
	"step/5": [
		[5, "", "Keith muss dem Piraten entkommen und sicher an der Station [[station/78]] andocken.", false],
		[6, "", "Gunant gibt zu, dass die Piratenüberfälle auf seine Station schlimmer werden. Keith bietet an, sich darum zu kümmern, wenn er Waffen bekommt. Gunant beschließt, einen Angriff auf das Piratenversteck nahe der Station zu wagen, und öffnet seinen kleinen Hangar, damit Keith eine Waffe und Panzerung einbauen kann.", false],
	],
	"step/6": [
		[6, "", "Im Hangar der Station muss Keith die [[ship/0]] mit einer Waffe und einer Panzerplatte ausrüsten (siehe [[guide/fitting]]).", false],
		[7, "", "Gunant ist mit der Wahl einverstanden. Zur Vorsicht hat er Keiths Waffen so eingestellt, dass sie seine eigenen Schilde nicht durchdringen können. Die beiden verabreden sich draußen.", false],
	],
	"step/7": [
		[7, "", "Gunant überträgt die Route zum Versteck als Wegpunkte. Keith muss ihr folgen und die Piratenschiffe dort zerstören, während Gunant an seiner Seite fliegt (siehe [[guide/combat]]).", false],
		[8, "", "Im Versteck sind weit mehr Piraten als erwartet. Gunant will sich zurückziehen, doch Keith kämpft weiter und siegt. Auf die Frage, wo er so zu kämpfen gelernt habe, sagt Keith, er habe unter Admiral Smith in der Raumflotte gedient. Gunant findet das seltsam, denn Keith sieht viel zu jung aus.", false],
	],
	"step/8": [
		[8, "", "Nach gewonnener Schlacht kehren Keith und Gunant zur Station [[station/78]] zurück.", false],
		[9, "", "Gunant dankt Keith dafür, dass er ihm das Leben gerettet hat, und erwähnt das Grab von Admiral Smith auf [[station/5]]. Keith ist fassungslos: Der Admiral starb um 3612 an Altersschwäche. Dann erfährt er von Gunant, dass man das Jahr 3624 schreibt, ein Jahr, das nach Gunants Erwartung wegen der Voids in Erinnerung bleiben wird.", false],
	],
	"step/9": [
		[9, "", "Erschüttert von der Nachricht dockt Keith erneut an der Station [[station/78]] an, um die Dinge mit Gunant zu klären.", false],
		[10, "", "Keith begreift, dass etwa 35 Jahre vergangen sind, seit er im Asteroidengürtel getroffen wurde. Gunant vermutet einen Defekt am Hyperantrieb, denn diese Antriebsart wird seit Jahren mit ähnlichen Vorfällen in Verbindung gebracht.", false],
		[10, "", "Zum Dank für den Sieg über die Piraten schenkt Gunant Keith die [[ship/0]], ausgestattet mit einem stärkeren Antrieb für Reisen zwischen den Planeten des Systems. Den Bergbaulaser, einen selbst gebauten Prototyp, behält er. Keith nennt endlich seinen Namen und macht sich auf den Weg zu Captain [[character/3]], einem menschlichen Kommandanten auf der Station [[station/79]], der ihm helfen kann, den [[faction/0|terranischen]] Raum zu erreichen. Von nun an erlaubt die [[chart]] Reisen innerhalb des Systems.", false],
	],
	"system/0": [
		[0, "", "[[system/0]] ist ein nivelianisches System am linken Rand der Karte. Es ist auf der Sternenkarte verborgen, bis du seine Koordinaten bei [[agent/12]] auf der Station [[station/18]] kaufst. Sein Tor bei der Station [[station/0]] verbindet es mit [[system/2]] und [[system/8]].", false],
		[0, "", "Die Stationen von Suteo gehören zu den fortschrittlichsten im nivelianischen Raum, mit [[station/2]] und [[station/4]] auf dem höchsten Techlevel. Der Agent [[agent/0]] verkauft auf der Station [[station/3]] einen Bauplan.", false],
	],
	"system/1": [
		[0, "", "[[system/1]] ist ein terranisches System in der unteren linken Ecke der Karte. Es ist verborgen, bis du seine Koordinaten bei [[agent/13]] auf der Station [[station/26]] kaufst. Sein Tor bei der Station [[station/5]] verbindet es mit [[system/8]] und [[system/18]].", false],
		[0, "", "Seine Stationen sind gut entwickelt, mit [[station/7]] auf dem höchsten Techlevel. Der Agent [[agent/1]] verkauft auf der Station [[station/8]] einen Bauplan.", false],
		[9, "", "Laut [[character/2]] liegt Admiral Smith, der alte Kommandant von [[character/0]], auf [[station/5]] begraben.", false],
	],
	"system/10": [
		[0, "", "[[system/10]] ist ein Vossk-System auf der rechten Seite der Karte, eingestuft als „Dangerous“ (gefährlich). Es ist verborgen, bis du seine Koordinaten bei [[agent/14]] kaufst, und hat überhaupt keine Torverbindungen: Nur ein Schiff mit Sprungantrieb kann es erreichen. Alle fünf Stationen haben die höchsten Techlevel.", false],
		[0, "", "Der Agent [[agent/5]] verkauft auf der Station [[station/54]] einen Bauplan.", false],
	],
	"system/11": [
		[0, "", "[[system/11]] ist ein terranisches System in der oberen Mitte der Karte, eingestuft als „Average“ (mittel). Es hat nur drei Stationen. Sein Tor bei der Station [[station/55]] verbindet es mit [[system/7]], [[system/9]], [[system/14]] und [[system/16]].", false],
		[18, "", "[[character/0]] wird zur Station [[station/56]] geschickt, um einen Offizier von Deep Science zu treffen.", false],
		[19, "", "Der Offizier, [[character/5]], wurde nahe der Station [[station/55]] von Piraten entführt.", false],
		[22, "", "[[character/0]] befreit ihn in [[step/21]] mit EMP-Bomben.", false],
	],
	"system/12": [
		[0, "", "[[system/12]] ist ein kleines Vossk-System mit nur zwei Stationen auf der rechten Seite der Karte, eingestuft als „Average“ (mittel). Sein Tor bei der Station [[station/60]] verbindet es mit [[system/3]], [[system/5]], [[system/13]] und [[system/14]] und verknüpft so den Vossk-Raum mit dem terranischen Osten.", false],
		[0, "", "Der multipodische Agent [[agent/6]] verkauft auf der Station [[station/61]] einen Bauplan.", false],
	],
	"system/13": [
		[0, "", "[[system/13]] ist ein terranisches System am rechten Rand der Karte, eingestuft als „Risky“ (riskant). Sein Tor bei der Station [[station/65]] verbindet es mit [[system/12]] und [[system/16]].", false],
		[0, "", "Der Cyborg-Agent [[agent/14]] verkauft auf der Station [[station/65]] Koordinaten.", false],
	],
	"system/14": [
		[0, "", "[[system/14]] ist ein terranisches System nahe der Kartenmitte und eines der beiden als „Safe“ (sicher) eingestuften Systeme der Galaxie. Sein Tor bei der Station [[station/70]] verbindet es mit [[system/3]], [[system/11]], [[system/12]] und [[system/19]]. Seine Stationen haben meist niedrige Techlevel.", false],
		[0, "", "Der Agent [[agent/7]] verkauft auf der Station [[station/72]] einen Bauplan.", false],
	],
	"system/15": [
		[0, "", "[[system/15]] ist ein midorianisches System oben auf der Karte, eingestuft als „Dangerous“ (gefährlich). Es hat keine Torverbindungen, sodass ein Schiff es nur mit einem Sprungantrieb betreten oder verlassen kann. Seine fünf Stationen sind alle klein und haben niedrige Techlevel. Bis [[step/16]] bleiben seine Schiffshändler geschlossen, und nur wenige Schiffe kommen und gehen.", false],
		[0, "", "Die Geschichte beginnt hier, bei der Station [[station/78]].", false],
		[11, "", "Das System ist das Gebiet der [[faction/3|Mido-Konföderation]], die während des Nivelianischen Bürgerkriegs von terranischen und nivelianischen Verbannten gegründet wurde. Die Nivelianer beanspruchen es weiterhin, und an seinen Rändern wird gekämpft.", false],
		[15, "", "[[character/0]] verlässt das System nach [[step/14]] als Gefangener an Bord eines terranischen Kreuzers. Für eine spätere Rückkehr braucht man einen Sprungantrieb.", false],
		[0, "", "[[character/2]] verkauft in der Lounge der Station [[station/78]] einen Bauplan.", false],
	],
	"system/16": [
		[0, "", "[[system/16]] ist ein terranisches System auf der rechten Seite der Karte, eingestuft als „Risky“ (riskant). Sein Tor bei der Station [[station/80]] verbindet es mit [[system/11]] und [[system/13]].", false],
		[0, "", "Der Vossk-Agent [[agent/8]] verkauft auf der Station [[station/84]] einen Bauplan.", false],
	],
	"system/17": [
		[0, "", "[[system/17]] ist ein nivelianisches System oben links auf der Karte, eingestuft als „Risky“ (riskant), und das nächstgelegene System zu [[system/15]]. Sein Tor bei der Station [[station/85]] verbindet es mit [[system/2]], [[system/9]] und [[system/4]]; es ist die einzige Torroute nach [[system/4]].", false],
		[0, "", "Der Vossk-Agent [[agent/15]] verkauft auf der Station [[station/88]] Koordinaten.", false],
	],
	"system/18": [
		[0, "", "[[system/18]] ist ein terranisches System unten auf der Karte, eingestuft als „Risky“ (riskant). Sein Tor bei der Station [[station/90]] verbindet es mit [[system/1]] und [[system/8]].", false],
		[0, "", "Der Agent [[agent/9]] verkauft auf der Station [[station/90]] einen Bauplan.", false],
		[28, "", "In [[step/28]] kommt [[character/0]] nach einer Meldung über Void-Aktivität nahe der Station [[station/91]] hierher, um in ein Wurmloch zu schlüpfen.", false],
	],
	"system/19": [
		[0, "", "[[system/19]] ist ein terranisches System in der Mitte der Karte, eingestuft als „Safe“ (sicher). Sein Tor bei der Station [[station/95]] verbindet es mit [[system/3]], [[system/8]], [[system/9]] und [[system/14]].", false],
		[15, "", "Zur Station [[station/98]] bringt der terranische Kreuzer [[character/0]] nach seiner Verhaftung, und dort trifft er seinen alten Freund [[character/1]] wieder.", false],
		[16, "", "Selbst dieses sichere System bleibt nicht verschont: Eine Void-Staffel greift in [[step/16]] die Station [[station/98]] an. [[character/1]] hat dort sein Hauptquartier.", false],
	],
	"system/2": [
		[0, "", "[[system/2]] ist ein nivelianisches System auf der linken Seite der Karte und der Knotenpunkt des nivelianischen Raums. Sein Tor bei der Station [[station/30]] verbindet es mit [[system/0]], [[system/8]], [[system/9]] und [[system/17]]. Es hat vier Stationen mit mittlerem Techlevel.", false],
		[34, "", "In [[step/33]] schickt [[character/6]] [[character/0]] zur Station [[station/30]], wo [[character/1]] mit einem neuen Plan wartet. Auch die letzten Vorbereitungen gegen die Voids finden dort statt.", false],
	],
	"system/20": [
		[0, "", "[[system/20]] ist ein Vossk-System unten rechts auf der Karte, eingestuft als „Dangerous“ (gefährlich). Sein Tor bei der Station [[station/62]] verbindet es mit [[system/5]] und [[system/21]] und ist damit die einzige Torroute nach [[system/21]].", false],
		[0, "", "Ein Terraner, der Agent [[agent/10]], verkauft auf der kleinen Station [[station/59]] einen Bauplan.", false],
	],
	"system/21": [
		[0, "", "[[system/21]] ist ein Vossk-System in der äußersten unteren rechten Ecke der Karte, eingestuft als „Dangerous“ (gefährlich). Es ist verborgen, bis du seine Koordinaten bei [[agent/15]] kaufst. Sein Tor bei der Station [[station/12]] verbindet es nur mit [[system/20]]. Seine Stationen sind alle primitiv, mit Techleveln von 3 oder weniger.", false],
	],
	"system/3": [
		[0, "", "[[system/3]] ist das Vossk-System, das der Kartenmitte am nächsten liegt, und der Haupteingang zum Vossk-Raum. Sein Tor bei der Station [[station/15]] verbindet es mit [[system/5]], [[system/12]], [[system/8]], [[system/14]] und [[system/19]]. Es ist als „Average“ (mittel) eingestuft.", false],
		[0, "", "Der Agent [[agent/12]] auf der Station [[station/18]] verkauft die Koordinaten des verborgenen Systems [[system/0]].", false],
	],
	"system/4": [
		[0, "", "[[system/4]] ist ein midorianisches System in der oberen linken Ecke der Karte, eingestuft als „Dangerous“ (gefährlich). Es ist eine Sackgasse: Sein Tor bei der Station [[station/20]] erreicht nur [[system/17]]. Seine Stationen reichen von der primitiven [[station/21]] bis zur gut ausgestatteten [[station/22]].", false],
		[0, "", "Der Agent [[agent/2]] verkauft in der Lounge der Station [[station/20]] einen Bauplan.", false],
		[38, "", "In [[step/38]] wird ein gestohlener Konvoi mit nivelianischen Sprengstoffen bis in dieses System verfolgt, nahe der Station [[station/22]].", false],
	],
	"system/5": [
		[0, "", "[[system/5]] ist ein Vossk-System unten rechts auf der Karte, eingestuft als „Risky“ (riskant). Sein Tor bei der Station [[station/25]] verbindet es mit [[system/3]], [[system/12]] und [[system/20]]. Der Agent [[agent/13]] verkauft auf der Station [[station/26]] Koordinaten.", false],
		[35, "", "Das System ist der Heimatstützpunkt des Vossk-Kommandanten [[character/7]] auf der Station [[station/29]], wo [[character/0]] ihn in [[step/35]] trifft.", false],
		[36, "", "Ihr Wettstreit findet nahe [[station/27]] statt.", false],
	],
	"system/6": [
		[0, "", "[[system/6]] ist ein terranisches System oben rechts auf der Karte, eingestuft als „Dangerous“ (gefährlich). Es erscheint nicht auf gewöhnlichen Sternenkarten, und nur die Geschichte enthüllt seine Koordinaten. Es umfasst eine einzige Station, [[station/10]], deren Tor es allein mit [[system/7]] verbindet.", false],
		[23, "", "Das System verbirgt die geheime Forschungsstation von Deep Science. [[character/5]] gibt [[character/0]] in [[step/22]] ihre Koordinaten, und ein großer Teil des Kampfes gegen die Voids wird dort geplant.", false],
	],
	"system/7": [
		[0, "", "[[system/7]] ist ein terranisches System oben rechts auf der Karte, eingestuft als „Risky“ (riskant). Sein Tor bei der Station [[station/35]] verbindet es mit [[system/11]] und dem verborgenen [[system/6]] und ist damit die einzige Torroute in das verborgene System. [[station/37]] ist seine fortschrittlichste Station.", false],
	],
	"system/8": [
		[0, "", "[[system/8]] ist ein terranisches System im unteren linken Viertel der Karte und das am besten vernetzte System der Galaxie. Sein Tor bei der Station [[station/40]] verbindet es mit sechs Systemen: [[system/0]], [[system/1]], [[system/2]], [[system/3]], [[system/18]] und [[system/19]]. Es ist als „Average“ (mittel) eingestuft.", false],
		[0, "", "Der Agent [[agent/4]] verkauft auf der Station [[station/43]] einen Bauplan.", false],
	],
	"system/9": [
		[0, "", "[[system/9]] ist ein nivelianisches System in der oberen Mitte der Karte, eingestuft als „Average“ (mittel). Sein Tor bei der Station [[station/45]] verbindet es mit [[system/2]], [[system/11]], [[system/17]] und [[system/19]].", false],
		[24, "", "Bei der Station [[station/48]] wird Void-Aktivität gemeldet, und [[character/0]] und [[character/6]] fliegen in [[step/24]] dorthin, um Wrackteile zu sammeln.", false],
	],
	"world/galaxy": [
		[0, "Überblick", "Das Spiel findet in einer einzigen Galaxie mit 22 Sternsystemen statt. Jedes System gehört einer Fraktion, hat eine Sicherheitsstufe und umfasst eine bis fünf Raumstationen. Jede Station umkreist einen Planeten und hat ihren eigenen Laden, Hangar und ihre eigene Space Lounge. Die Systeme sind über eine flache Karte verteilt, und Reisen zwischen ihnen führen durch ein Netz von Sprungtoren.", false],
		[0, "", "Vier Völker besitzen die kartierten Systeme. Die [[faction/0|Terraner]] halten zehn, die [[faction/1]] sechs, die [[faction/2|Nivelianer]] vier und die [[faction/3|Midorianer]] zwei. Angehörige kleinerer Rassen wie die [[faction/4|Multipoden]], [[faction/5|Cyborgs]], [[faction/6|Bobolianer]] und [[faction/7]] leben unter ihnen, ohne eigenes Gebiet. [[faction/8|Piraten]] streifen durch jedes System, und von Anfang an gibt es Gerüchte über eine feindliche Macht namens [[faction/9|Voids]].", false],
		[0, "Aufbau", "Die nivelianischen und midorianischen Systeme liegen oben links auf der Karte, rund um [[system/15]], [[system/4]], [[system/17]] und [[system/2]]. Der terranische Raum erstreckt sich über die Mitte, die rechte Seite und den unteren Teil der Karte, mit [[system/19]] und [[system/14]] als Kern. Die Vossk-Systeme bilden einen eigenen Block unten rechts, der bei [[system/3]] beginnt und in der äußersten Ecke bei [[system/21]] endet.", false],
		[0, "", "Die Torrouten begünstigen die Mitte. [[system/8]] hat sechs Torverbindungen, mehr als jedes andere System, und [[system/19]], [[system/14]], [[system/3]] und [[system/11]] verbinden jeweils vier oder fünf Systeme. Systeme am Rand, etwa [[system/4]], [[system/6]] und [[system/21]], sind Sackgassen mit einer einzigen Verbindung.", false],
		[0, "Reisen", "Innerhalb eines Systems bringt der gewöhnliche Antrieb ein Schiff vom Orbit einer Station zum nächsten. Um ein System zu verlassen, fliegt ein Schiff durch dessen Sprungtor, das bei einer der Stationen des Systems steht und nur die damit verbundenen Systeme erreicht. Längere Reisen sind Ketten von Torsprüngen. Ein Sprungantrieb ist die einzige Möglichkeit, das Tornetz zu umgehen und jedes bekannte System direkt zu erreichen; siehe [[guide/navigation]].", false],
		[33, "", "Der einzige Sprungantrieb im Spiel ist der [[item/85]], den [[character/20]] im Lauf der Geschichte entwirft. Er wird nach einem Bauplan gebaut und benötigt unter anderem [[item/164]].", false],
		[0, "Sicherheit", "Jedes System ist als „Safe“ (sicher), „Average“ (mittel), „Risky“ (riskant) oder „Dangerous“ (gefährlich) eingestuft. Die Einstufung bestimmt, wie oft bei deiner Ankunft Angreifer nahe einer Station lauern. In einem gefährlichen System tauchen sie bei den meisten Besuchen auf, in einem sicheren sind sie selten. Meist sind die Angreifer Piraten, manchmal aber Schiffe der rivalisierenden Rasse der Fraktion. Sicherere Systeme halten dafür mehr örtliche Patrouillenschiffe in der Nähe ihrer Stationen.", false],
		[0, "Fraktionen und Ansehen", "Dein Ansehen wird auf zwei Skalen geführt: eine zwischen Terranern und Vossk, die andere zwischen Nivelianern und Midorianern. Gunst bei einer Seite eines Paares kostet Gunst bei der anderen. Sinkt dein Ansehen bei einer Fraktion zu tief, greifen ihre Schiffe dich sofort an, und ihre Stationen weisen dich ab. Piraten und Voids sind immer feindlich. Ein Diplomat in einer Space Lounge kann dein Ansehen gegen eine Gebühr wiederherstellen.", false],
		[0, "Verborgene Systeme", "Nicht jedes System erscheint anfangs auf der Sternenkarte. [[system/0]], [[system/1]], [[system/10]] und [[system/21]] bleiben verborgen, bis du ihre Koordinaten bei einem Agenten in einer Space Lounge kaufst; siehe [[guide/lounge]]. Ein weiteres System, [[system/6]], fehlt auf gewöhnlichen Sternenkarten und wird nur durch die Geschichte enthüllt.", false],
		[23, "", "Die Koordinaten von [[system/6]] erhältst du in [[step/22]] durch [[character/5]]. Das System umfasst eine einzige Station, [[station/10]], die geheime Forschungsbasis der Organisation Deep Science.", false],
		[0, "", "Zwei Systeme haben überhaupt keine Torverbindungen: [[system/15]] und [[system/10]]. Ein Schiff kann sie nur mit einem Sprungantrieb erreichen oder verlassen.", false],
		[0, "Ein abgeschiedener Anfang", "Die Geschichte beginnt in [[system/15]], einem abgelegenen System oben auf der Karte ohne Torverbindung zum Rest der Galaxie. Sein Handel ist dürftig, seine Stationen haben niedrige Techlevel, und seine Schiffshändler bleiben im ersten Teil der Geschichte geschlossen. Anfangs gibt es nur den Weg aus dem System, den die Geschichte vorgibt.", false],
		[11, "", "[[system/15]] ist die Heimat der [[faction/3|Mido-Konföderation]], einer Gruppe terranischer und nivelianischer Flüchtlinge und Gesetzloser, die diesen neu kartierten Sektor während des Nivelianischen Bürgerkriegs besiedelten. Die Konföderation erklärte sich für unabhängig. Die Terraner akzeptieren das; die Nivelianer beanspruchen das System weiterhin, weshalb an seinen Rändern weiter gekämpft wird.", false],
		[15, "", "[[character/0]] verlässt [[system/15]] an Bord eines terranischen Kreuzers, nachdem ihn der Konvoi bei der Station [[station/79]] in [[step/14]] lahmgelegt und verhaftet hat. Er kommt auf der Station [[station/98]] im System [[system/19]] an, tief im terranischen Raum.", false],
		[9, "Der Zeitsprung", "Als [[character/0]] in [[system/15]] erwacht, glaubt er, es sei nur kurze Zeit vergangen. Tatsächlich hat ihn sein beschädigter Hyperantrieb quer durch die Galaxie und rund 35 Jahre in die Zukunft geschleudert. Die Galaxie, die er kannte, hat sich verändert: Alte Freunde sind gealtert oder gestorben, und neue Sektoren, darunter sein jetziger Aufenthaltsort, wurden inzwischen besiedelt.", false],
		[10, "", "Defekte Hyperantriebe seines Typs haben schon früher ähnliche Sprünge durch Zeit und Raum verursacht.", false],
		[18, "Jenseits der Karte", "Die Voids dringen durch eine Art Wurmloch in die kartierten Systeme ein. Sie überfallen terranischen, nivelianischen und Vossk-Raum gleichermaßen und scheinen es auf Erz abgesehen zu haben. Siehe [[world/voids]].", false],
		[25, "", "Ein Wurmloch führt aus der kartierten Galaxie in den eigenen Sektor der Voids, der keinen Platz auf der Sternenkarte hat. Die Wurmlöcher öffnen sich eine Weile nahe einer Station, brechen dann zusammen und erscheinen anderswo.", false],
		[34, "", "Mit eingebautem [[item/85]] kann ein Schiff auch direkt in den Void-Sektor springen.", false],
		[32, "", "Ab [[step/31]] zeigt ein Frühwarnsystem auf der Sternenkarte, wo sich das nächste Wurmloch öffnen wird.", false],
		[42, "", "Als das Mutterschiff der Voids in [[step/41]] zerstört wird, brechen die Wurmlöcher im ganzen Sektor zusammen, und die Überfälle hören auf.", false],
	],
	"world/history": [
		[0, "", "Die Galaxie wird von mehreren Völkern geteilt, darunter die [[faction/0|Terraner]], die [[faction/2|Nivelianer]] und die [[faction/1|Vossk]]. Der Raum zwischen ihren Stationen wird von [[faction/8|Piraten]] heimgesucht. Diese Seite fasst die Geschichte zusammen; jeder Teil erscheint, sobald dein Spielstand ihn erreicht.", false],
		[0, "Erster Akt: gestrandet", "Der terranische Kopfgeldjäger [[character/0]] vernichtet eine Piratenbande in einem Asteroidengürtel ([[step/0]]).", false],
		[1, "", "Ein letzter Schuss beschädigt seinen Hyperantrieb, als er davonspringt, um seinen alten Kommandanten Admiral Smith zu treffen. Sein Schiff treibt mit bewusstlosem Piloten bis zur Station [[station/78]].", false],
		[2, "", "Der nivelianische Erzhändler [[character/2]] birgt das Wrack, behält das Schiff und lässt Keith für sich Erz abbauen.", false],
		[8, "", "Keith hilft Gunant, ein nahes Piratenversteck zu zerstören ([[step/7]]).", false],
		[9, "", "Danach erfährt Keith, dass man das Jahr 3624 schreibt und Admiral Smith längst tot ist.", false],
		[10, "", "Ein Defekt am Hyperantrieb hat Keith 35 Jahre in die Zukunft und in einen abgelegenen Winkel der Galaxie getragen. Gunant schenkt ihm das Schiff [[ship/0]] und schickt ihn zu [[character/3]] auf der Station [[station/79]].", false],
		[11, "", "Das System [[system/15]] gehört zur [[faction/3|Mido-Konföderation]], die während des Nivelianischen Bürgerkriegs von terranischen und nivelianischen Verbannten gegründet wurde.", false],
		[12, "", "Keith findet heraus, dass die stille Station [[station/76]] vom Händler [[character/4]] in einen Drogenrausch versetzt wurde ([[step/11]]).", false],
		[15, "", "Als ein terranischer Konvoi durchreist, hält er Keith für einen Piraten, legt sein Schiff lahm und bringt ihn zur Station [[station/98]] ([[step/14]]).", false],
		[16, "Zweiter Akt: die Bedrohung durch die Voids", "Dort trifft er seinen alten Freund [[character/1]], inzwischen Sicherheitschef, genau als die [[faction/9|Voids]] die Station angreifen.", false],
		[18, "", "Die Voids überfallen Sternsysteme durch Wurmlöcher auf der Suche nach Erz. Brent wirbt Keith als Piloten für Deep Science an, eine geheime Forschungsorganisation, die sie untersucht ([[step/17]]).", false],
		[19, "", "Der Wissenschaftler [[character/5]], der Keith zur Forschungsstation führen sollte, wird von Piraten entführt.", false],
		[23, "", "Keith legt das Schiff der Entführer mit EMP-Bomben lahm, rettet ihn und erhält die Koordinaten des Systems [[system/6]] ([[step/21]], [[step/22]]).", false],
		[24, "Dritter Akt: Deep Science", "Auf der Station [[station/10]] trifft Keith die Projektleiterin [[character/6]] und beginnt für Deep Science zu arbeiten.", false],
		[25, "", "Keith und Carla bergen Void-Wrackteile bei der Station [[station/48]], doch ein Wurmloch verschluckt ihr Schiff ([[step/24]]).", false],
		[26, "", "Sie finden sich im Heimatsektor der Voids wieder, neben einem gigantischen Mutterschiff, und entkommen durch ein weiteres Wurmloch.", false],
		[30, "", "Keith kehrt durch ein Wurmloch nahe der Station [[station/91]] in den Void-Sektor zurück und schießt eine Sonde auf das Mutterschiff ab ([[step/29]]).", false],
		[32, "", "Brent gibt Keith ein Frühwarnsystem, das anzeigt, wo die Voids als Nächstes zuschlagen.", false],
		[34, "", "Der Grey-Wissenschaftler [[character/20]] lässt Keith Void-Kristalle für einen neuen Sofortantrieb sammeln und gibt ihm dessen Bauplan ([[step/33]]).", false],
		[35, "Vierter Akt: der Angriff", "Die Sonde zeigt, dass das Mutterschiff die Wurmlöcher erzeugt. Brent und Carla wollen es mit einem Frachter voller nivelianischer Sprengstoffe zerstören, die der Vossk-Kommandant [[character/7]] stellt.", false],
		[37, "", "Errkt besteht darauf, den Frachter selbst zu fliegen, und Keith erkämpft sich das Recht, ihn zu eskortieren ([[step/36]]).", false],
		[39, "", "Keith erobert den Konvoi mit den Sprengstoffen zurück, nachdem Mido-Schiffe ihn gekapert haben ([[step/38]]).", false],
		[42, "", "Mit Verstärkung unter [[character/8]] eskortiert Keith Errkt durch ein Wurmloch. Errkt rammt den Frachter in das Mutterschiff und stirbt bei dem Angriff ([[step/41]]).", false],
		[43, "", "Alle Wurmlöcher brechen zusammen, und die Überfälle der Voids enden.", false],
		[45, "Epilog", "Keith feiert mit Brent und verbringt endlich eine Nacht mit Carla. Am nächsten Morgen bricht sie zu einem anderen Geheimprojekt auf, und Keith kann frei durch die Galaxie ziehen.", false],
	],
	"world/voids": [
		[0, "", "Die [[faction/9|Voids]] sind die zentrale Bedrohung der Geschichte. Diese Seite sammelt, was man über sie erfährt; mehr erscheint, während dein Spielstand voranschreitet.", false],
		[2, "Erste Berichte", "Keith hört zum ersten Mal von [[character/2]] von den Voids: feindselige Wesen, die von Zeit zu Zeit selbst im abgelegenen System [[system/15]] auftauchen.", false],
		[9, "", "Die Menschen im Mido-System erwarten, dass 3624 als das Jahr der Voids in Erinnerung bleiben wird.", false],
		[16, "", "Void-Jäger greifen die Station [[station/98]] im terranischen Raum an ([[step/15]]).", false],
		[17, "", "Während des Angriffs senden die Voids eine Botschaft, sie kämen in Frieden, feuern aber weiter.", false],
		[18, "Was bekannt ist", "Die Voids tauchten wenige Wochen zuvor zum ersten Mal auf. Sie dringen durch Wurmlöcher in bewohnte Systeme ein, greifen alles an, was ihnen begegnet, und scheinen es auf Erz abgesehen zu haben. Selbst [[faction/1]]-Systeme werden überfallen. Niemand weiß, woher sie kommen oder was sie wollen.", false],
		[24, "", "Bei der Station [[station/48]] verkünden sie, dass sie aus der Zukunft stammen und alles sind, was von den Zivilisationen der Galaxie übrig ist.", false],
		[26, "Der Heimatsektor", "Ihre Wurmlöcher führen in einen fernen Heimatsektor, wo ein gigantisches Mutterschiff Jäger ausschleust. Die Wurmlöcher öffnen sich für kurze Zeit, brechen dann zusammen und erscheinen anderswo neu.", false],
		[28, "", "Die Voids warnen, dass ihre Vernichtung die Zukunft der Menschheit vernichten würde.", false],
		[30, "", "Sie wiederholen, dass sie einen Weg der Verständigung finden müssen, bevor die Menschen sie und damit ihre eigene Zukunft zerstören. Ob diese Behauptung stimmt, wird nie geklärt.", false],
		[32, "", "Ein Frühwarnsystem, das das Team von [[character/1]] entwickelt hat, sagt voraus, wo die Voids ihr nächstes Wurmloch öffnen.", false],
		[33, "", "Der Grey-Wissenschaftler [[character/20]] glaubt, dass Kristalle, die es nur im Void-Sektor gibt, [[item/164]], das Geheimnis ihrer Wurmlöcher bergen.", false],
		[35, "Das Ende der Überfälle", "Die auf das Mutterschiff abgeschossene Sonde zeigt, dass es die Quelle der Wurmlöcher ist. Keine bekannte Waffe hat ihm bisher Schaden zugefügt.", false],
		[42, "", "Ein Vossk-Frachter voller nivelianischer Atomsprengstoffe, geflogen von [[character/7]], zerstört das Mutterschiff ([[step/41]]).", false],
		[43, "", "Danach brechen die Wurmlöcher im ganzen Sektor zusammen, und die Überfälle der Voids hören auf, zumindest vorerst.", false],
	],
}
