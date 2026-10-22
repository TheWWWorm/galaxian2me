extends RefCounted
## Reference prose in Polish. Each block is [story step it appears from,
## section heading or "", text, list item]. See src/wiki/prose.gd.
const PAGES := {
	"guide/basics": {"title": "Pierwsze kroki", "subtitle": "Poradnik", "category": "guide", "from": 0},
	"guide/blueprints": {"title": "Schematy i produkcja", "subtitle": "Poradnik", "category": "guide", "from": 0},
	"guide/combat": {"title": "Walka", "subtitle": "Poradnik", "category": "guide", "from": 0},
	"guide/fitting": {"title": "Statki i wyposażenie", "subtitle": "Poradnik", "category": "guide", "from": 0},
	"guide/flight": {"title": "Latanie", "subtitle": "Poradnik", "category": "guide", "from": 0},
	"guide/jobs": {"title": "Zlecenia", "subtitle": "Poradnik", "category": "guide", "from": 0},
	"guide/lounge": {"title": "Space Lounge", "subtitle": "Poradnik", "category": "guide", "from": 0},
	"guide/medals": {"title": "Medale", "subtitle": "Poradnik", "category": "guide", "from": 0},
	"guide/mining": {"title": "Wydobycie", "subtitle": "Poradnik", "category": "guide", "from": 0},
	"guide/navigation": {"title": "Nawigacja", "subtitle": "Poradnik", "category": "guide", "from": 0},
	"guide/trading": {"title": "Handel", "subtitle": "Poradnik", "category": "guide", "from": 0},
	"step/0": {"title": "Nagroda w pasie asteroid"},
	"step/1": {"title": "Dryfujący wrak"},
	"step/10": {"title": "Spotkanie z komendantem"},
	"step/11": {"title": "Milcząca stacja"},
	"step/12": {"title": "Raport dla komendanta"},
	"step/13": {"title": "W oczekiwaniu na konwój"},
	"step/14": {"title": "Terrański konwój"},
	"step/15": {"title": "Aresztowany"},
	"step/16": {"title": "Obrona stacji"},
	"step/17": {"title": "Opowieść o Voidach"},
	"step/18": {"title": "Spotkanie z naukowcem"},
	"step/19": {"title": "Porwanie"},
	"step/2": {"title": "Pierwszy urobek"},
	"step/20": {"title": "Montaż bomb"},
	"step/21": {"title": "Unieszkodliwienie porywaczy"},
	"step/22": {"title": "Uratowany naukowiec"},
	"step/23": {"title": "Tajna stacja badawcza"},
	"step/24": {"title": "Zbieranie szczątków Voidów"},
	"step/25": {"title": "Zagubieni w obcej przestrzeni"},
	"step/26": {"title": "Zgubić pościg"},
	"step/27": {"title": "Nowe zadanie"},
	"step/28": {"title": "Znów przez tunel"},
	"step/29": {"title": "Wystrzelenie sondy"},
	"step/3": {"title": "Dostawa rudy"},
	"step/30": {"title": "Telefon od starego przyjaciela"},
	"step/31": {"title": "Obiecana niespodzianka"},
	"step/32": {"title": "Naukowiec rasy Grey"},
	"step/33": {"title": "Kryształy z Pustki"},
	"step/34": {"title": "Plan zwycięstwa"},
	"step/35": {"title": "Spotkanie z dowódcą Vossk"},
	"step/36": {"title": "Pojedynek pilotów"},
	"step/37": {"title": "Meldunek do dowództwa"},
	"step/38": {"title": "Odbicie konwoju"},
	"step/39": {"title": "Ostatnie przygotowania"},
	"step/4": {"title": "Pełna ładownia"},
	"step/40": {"title": "Eskorta do tunelu"},
	"step/41": {"title": "Atak na statek-matkę"},
	"step/42": {"title": "Ucieczka z przestrzeni Void"},
	"step/43": {"title": "Świętowanie"},
	"step/44": {"title": "Następny poranek"},
	"step/45": {"title": "Epilog"},
	"step/5": {"title": "Ucieczka na stację"},
	"step/6": {"title": "Uzbrojenie statku"},
	"step/7": {"title": "Kryjówka piratów"},
	"step/8": {"title": "Po bitwie"},
	"step/9": {"title": "Wyrównanie rachunków"},
	"world/galaxy": {"title": "Galaktyka", "subtitle": "Świat gry", "category": "world", "from": 0},
	"world/history": {"title": "Historia", "subtitle": "Świat gry", "category": "world", "from": 0},
	"world/voids": {"title": "Voidy", "subtitle": "Świat gry", "category": "world", "from": 0},
}
const BLOCKS := {
	"agent/0": [
		[0, "", "[[agent/0]] to nivelijski agent w Space Lounge stacji [[station/3]] w ukrytym układzie [[system/0]]. Sprzedaje schemat lasera [[item/11]].", false],
	],
	"agent/1": [
		[0, "", "[[agent/1]] to nivelijski agent w Space Lounge stacji [[station/8]] w ukrytym układzie [[system/1]]. Sprzedaje schemat blastera [[item/15]], broni, którą opisuje jako rzadką.", false],
	],
	"agent/10": [
		[0, "", "[[agent/10]] to terrański agent żyjący wśród Vossk, w Space Lounge stacji [[station/59]] w układzie [[system/20]]. Sprzedaje schemat urządzenia maskującego [[item/96]].", false],
	],
	"agent/11": [
		[0, "", "[[agent/11]] to handlarz rudą [[character/2]], który pojawia się we własnym Space Lounge na stacji [[station/78]] w układzie [[system/15]]. Sprzedaje schemat swojego lasera górniczego, [[item/90]], po cenie znacznie wyższej niż u jakiegokolwiek innego agenta. Ponieważ układ [[system/15]] nie ma połączeń bramowych, dotarcie do niego później w grze wymaga napędu skokowego.", false],
		[10, "", "Wita Keitha ([[character/0]]) jako podróżnika w czasie i zaczął już produkować wiertło, które kiedyś zachował dla siebie.", false],
	],
	"agent/12": [
		[0, "", "[[agent/12]] to agent Vossk w Space Lounge stacji [[station/18]] w układzie [[system/3]]. Sprzedaje współrzędne ukrytego układu [[system/0]], zachwalając jego liczne zaawansowane stacje.", false],
	],
	"agent/13": [
		[0, "", "[[agent/13]] to boboliański agent w Space Lounge stacji [[station/26]] w układzie [[system/5]]. Sprzedaje współrzędne ukrytego układu [[system/1]].", false],
	],
	"agent/14": [
		[0, "", "[[agent/14]] to agent z rasy Cyborgów w Space Lounge stacji [[station/65]] w układzie [[system/13]]. Sprzedaje współrzędne układu [[system/10]], ale przyznaje, że nie ma pojęcia, jak się tam dostać. Bez napędu skokowego współrzędne na nic się nie zdadzą, bo układ nie ma połączeń bramowych.", false],
	],
	"agent/15": [
		[0, "", "[[agent/15]] to agent Vossk w Space Lounge stacji [[station/88]] w układzie [[system/17]]. Sprzedaje współrzędne ukrytego układu [[system/21]], który nazywa swoim domem. Gdy układ jest już znany, można do niego dotrzeć bramą z układu [[system/20]].", false],
	],
	"agent/2": [
		[0, "", "[[agent/2]] to midoriański agent w Space Lounge stacji [[station/20]] w układzie [[system/4]]. Sprzedaje schemat przedmiotu [[item/25]], najtańszy schemat broni oferowany przez agenta, nie licząc rakiety, którą sprzedaje [[agent/4]].", false],
	],
	"agent/3": [
		[0, "", "[[agent/3]] to terrański agent w Space Lounge stacji [[station/10]] w układzie [[system/6]]. Sprzedaje schemat przedmiotu [[item/27]], szybkostrzelnego działa masowego.", false],
	],
	"agent/4": [
		[0, "", "[[agent/4]] to terrański agent w Space Lounge stacji [[station/43]] w układzie [[system/8]]. Sprzedaje schemat przedmiotu [[item/33]], najtańszy schemat oferowany przez jakiegokolwiek agenta.", false],
	],
	"agent/5": [
		[0, "", "[[agent/5]] to agent Vossk w Space Lounge stacji [[station/54]] w układzie [[system/10]], do którego można dotrzeć tylko napędem skokowym. Sprzedaje schemat samonaprowadzającej torpedy [[item/37]], której nie ma w żadnym sklepie.", false],
	],
	"agent/6": [
		[0, "", "[[agent/6]] to jedyny Multipod w grze. Przesiaduje w Space Lounge stacji [[station/61]] w układzie [[system/12]] i sprzedaje schemat broni jądrowej [[item/46]].", false],
	],
	"agent/7": [
		[0, "", "[[agent/7]] to terrański agent w Space Lounge stacji [[station/72]] w układzie [[system/14]]. Sprzedaje schemat przedmiotu [[item/54]], potężnej osłony.", false],
	],
	"agent/8": [
		[0, "", "[[agent/8]] to agent Vossk w Space Lounge stacji [[station/84]] w układzie [[system/16]]. Sprzedaje schemat przedmiotu [[item/59]], płyty pancerza Vossk, której nigdy nie sprzedawano w sklepach. To najdroższy schemat sprzedawany przez agentów, zaraz po wiertle, które oferuje [[agent/11]].", false],
	],
	"agent/9": [
		[0, "", "[[agent/9]] to terrański agent w Space Lounge stacji [[station/90]] w układzie [[system/18]]. Sprzedaje schemat przedmiotu [[item/67]], kompresora ładunku, który poleca każdemu handlarzowi.", false],
	],
	"character/0": [
		[0, "", "[[character/0]] to protagonista i postać, którą grasz. Jest pilotem myśliwca z frakcji [[faction/0]], który utrzymuje się z polowania na [[faction/8|piratów]] dla wyznaczonych za nich nagród. Jest pewny siebie, sarkastyczny i skory do walki.", false],
		[1, "Rozbitek", "W drodze na Eden Prime, gdzie admirał Smith ma dla niego specjalną misję, jego hipernapęd zostaje uszkodzony w ataku piratów. Autopilot niesie nieprzytomnego pilota na stację [[station/78]].", false],
		[2, "", "Tam ratuje go handlarz rudą [[character/2]], który przejął jego statek jako znalezisko i zatrudnia go jako górnika.", false],
		[8, "", "Keith jest weteranem Terrańskiej Floty Kosmicznej, w której służył pod admirałem Smithem.", false],
		[9, "", "Dowiaduje się, że admirał zmarł ze starości i że jest teraz rok 3624.", false],
		[10, "", "Od jego wypadku minęło około 35 lat, najwyraźniej z powodu awarii hipernapędu, a jednak Keith wcale się nie postarzał. Uwięziony w odległym układzie [[system/15]], zaczyna od nowa ze statkiem [[ship/0]], prezentem od Gunanta.", false],
		[16, "Wojna z Voidami", "Po omyłkowym aresztowaniu spotyka na stacji [[station/98]] swojego starego przyjaciela, [[character/1]], i stacza pierwszą bitwę z [[faction/9|Voidami]].", false],
		[18, "", "Brent werbuje go jako pilota dla organizacji badawczej Deep Science, która bada Voidy.", false],
		[24, "", "Na stacji [[station/10]] poznaje kierowniczkę projektu, [[character/6]], i wkrótce zaczyna go do niej ciągnąć.", false],
		[26, "", "Razem z Carlą zostaje wciągnięty przez tunel Voidów do ich macierzystego sektora; oboje znajdują drogę powrotną.", false],
		[36, "", "Dowódca Vossk, [[character/7]], wie o wcześniejszej służbie Keitha na Novaterze.", false],
		[43, "", "Keith eskortuje frachtowiec, który niszczy statek-matkę Voidów i kończy najazdy, choć Errkt ginie w ataku.", false],
		[45, "Później", "Jego nagrodą jest noc z Carlą, która potem znika, by pracować przy innym tajnym projekcie, i zostawia mu ostatnią wypłatę. Po wykonanym zadaniu Keith może swobodnie przemierzać galaktykę.", false],
	],
	"character/1": [
		[16, "", "[[character/1]] to stary przyjaciel Keitha z czasów sprzed wypadku. W ciągu 35 lat, które Keith stracił, Brent awansował na komandora porucznika i szefa Międzygwiezdnej Agencji Bezpieczeństwa. Jest przyjazny, gadatliwy i lubi długie osobiste opowieści.", false],
		[18, "Kryzys Voidów", "Jako szef bezpieczeństwa przewodniczy sztabowi kryzysowemu, który koordynuje odpowiedź na zagrożenie ze strony [[faction/9|Voidów]]. Werbuje Keitha dla Deep Science i dba o to, by był dobrze opłacany. Na jego rozkaz statek Keitha zostaje przemalowany.", false],
		[19, "", "Gdy zostaje porwany naukowiec [[character/5]], Brent popiera plan ratunkowy Keitha i dostarcza bomby EMP na stację [[station/55]].", false],
		[32, "", "Jego zespół opracowuje system wczesnego ostrzegania, który pokazuje, gdzie Voidy otworzą następny tunel.", false],
		[35, "", "Wspólnie z kierowniczką projektu, [[character/6]], obmyśla plan zniszczenia statku-matki Voidów frachtowcem pełnym materiałów wybuchowych i załatwia umowę z dowódcą Vossk, [[character/7]].", false],
		[43, "Później", "Po zniszczeniu statku-matki Brent świętuje zwycięstwo z Keithem na stacji [[station/98]].", false],
	],
	"character/2": [
		[2, "", "[[character/2]] to handlarz rudą z frakcji [[faction/2]], który prowadzi małą stację górniczą [[station/78]] w układzie [[system/15]]. Znajduje wrak statku, którym leciał [[character/0]], ratuje pilota i przejmuje statek jako znalezisko. Szorstki i praktyczny, każe Keithowi odpracować dług przy wydobyciu rudy statkiem [[ship/0]], starą jednostką, którą sam połatał.", false],
		[8, "", "Gdy Keith pomaga mu zniszczyć kryjówkę piratów w pobliżu stacji, Gunant zaczyna go szanować.", false],
		[10, "", "W podzięce oddaje Keithowi statek [[ship/0]] z lepszym napędem i wysyła go do swojego przyjaciela, kapitana [[character/3]]. Gunant sam należy do [[faction/3|Konfederacji Mido]]. Projektuje własne lasery górnicze, a jako agent [[agent/11]] sprzedaje schemat jednego z nich: [[item/90]].", false],
	],
	"character/20": [
		[32, "", "[[character/20]] to naukowiec [[faction/7|rasy Grey]] pracujący dla Deep Science. Prosi o spotkanie z pilotem, którym jest [[character/0]], na stacji [[station/10]].", false],
		[33, "", "Khador wyraża się z wyszukaną uprzejmością. Po zbadaniu szczątków Voidów uważa, że kryształy występujące tylko w sektorze Voidów kryją tajemnicę ich tuneli. Od lat pracuje nad napędem, który przenosiłby statek natychmiast w dowolny punkt przestrzeni, i prosi Keitha o zebranie 50 sztuk towaru [[item/164]].", false],
		[34, "", "Gdy Keith dostarcza kryształy, Khador nagradza go kopią schematu napędu noszącego jego imię: [[item/85]].", false],
	],
	"character/3": [
		[10, "", "[[character/3]] to ludzki kapitan, który przystąpił do [[faction/3|Konfederacji Mido]] i dowodzi teraz stacją [[station/79]]. [[character/2]] poleca go Keithowi jako kogoś, kto może mu pomóc wrócić do przestrzeni Terran.", false],
		[11, "", "Norris wita Keitha i opowiada historię układu [[system/15]]. Proponuje, że skontaktuje Keitha z Terrańską Flotą Kosmiczną, jeśli ten najpierw zbada milczenie stacji [[station/76]].", false],
		[13, "", "Organizuje Keithowi spotkanie z terrańskim konwojem przelatującym przez układ i radzi mu, by w oczekiwaniu przyjmował zlecenia.", false],
	],
	"character/4": [
		[12, "", "[[character/4]] to osławiony diler, którego Keith znał dawno temu. Keith znajduje go na stacji [[station/76]], gdzie zaopatrzył całą załogę w neuroalgi, narkotyk o nieprzyjemnych skutkach ubocznych. Mkkt pamięta Keitha i jest ciekaw, dlaczego ten się nie postarzał.", false],
		[13, "", "Po wysłuchaniu raportu Keitha kapitan [[character/3]] obiecuje się nim zająć.", false],
	],
	"character/5": [
		[18, "", "Tommy to porucznik Thomas Boyle, naukowiec pracujący dla Deep Science. [[character/1]] organizuje mu spotkanie z Keithem na stacji [[station/56]], skąd ma zaprowadzić Keitha do tajnej stacji badawczej organizacji.", false],
		[19, "", "Przed spotkaniem Boyle zostaje porwany przez piratów w pobliżu stacji [[station/55]], którzy żądają za niego okupu.", false],
		[23, "", "Gdy Keith unieszkodliwia statek porywaczy, Boyle zostaje uratowany. Przekazuje Keithowi współrzędne układu [[system/6]] i leci z nim na stację [[station/10]].", false],
	],
	"character/6": [
		[23, "", "Dr Paolini to naukowczyni Deep Science, która czeka na Keitha i Boyle'a na stacji [[station/10]].", false],
		[24, "", "Dr Carla Paolini kieruje projektem Deep Science poświęconym [[faction/9|Voidom]]. Jest zdeterminowana i pracowita, a ponieważ upiera się, by zobaczyć Voidy na własne oczy, leci z pilotem, którym jest [[character/0]], na jego pierwszą misję zbierania szczątków. Keitha pociąga od pierwszego spotkania.", false],
		[26, "", "Razem z Keithem zostaje wciągnięta przez tunel do macierzystego sektora Voidów; oboje ledwo uchodzą z życiem.", false],
		[28, "", "Jej zespół buduje sondę do analizy statku-matki Voidów. Zgadza się na randkę z Keithem, jeśli ten wróci żywy z misji.", false],
		[34, "", "Zbyt zajęta badaniami, by dotrzymać umowy, obmyśla wraz z szefem bezpieczeństwa, [[character/1]], plan uderzenia na statek-matkę.", false],
		[44, "Później", "Po zwycięstwie dołącza do Keitha i Brenta na stacji [[station/98]] na długo odkładaną randkę.", false],
		[45, "", "Następnego ranka już jej nie ma, zostaje tylko liścik: wyjechała do innego tajnego projektu i prosi Keitha, by jej nie szukał.", false],
	],
	"character/7": [
		[35, "", "[[character/7]] to dowódca z frakcji [[faction/1]], komendant stacji [[station/29]] w układzie [[system/5]]. W zamian za jeńców dostarcza frachtowiec K'Sarr do ataku na statek-matkę Voidów.", false],
		[36, "", "Dumny i oficjalny, uważa, że tylko Vossk potrafi należycie pilotować statek Vossk, i nalega, by samemu prowadzić frachtowiec. Zanim przyjmie Keitha jako eskortę, sprawdza jego umiejętności.", false],
		[37, "", "Gdy Keith pokonuje go w zawodach przy kryjówce piratów, Errkt traktuje go z szacunkiem.", false],
		[40, "", "Przed misją jest spokojny i zamknięty w sobie, co Brent odczytuje jako determinację.", false],
		[42, "Śmierć", "Errkt przeprowadza frachtowiec przez tunel i wbija go w statek-matkę. Gdy jego kapsuła ratunkowa zostaje zniszczona, odmawia zawrócenia i ginie w eksplozji, odsyłając Keitha w bezpieczne miejsce.", false],
		[43, "", "Brent obiecuje zgłosić jego poświęcenie Imperium Vossk.", false],
	],
	"character/8": [
		[40, "", "Porucznik [[character/8]] dowodzi oddziałem posiłków, który dołącza do Keitha, by chronić frachtowiec Vossk w drodze do tunelu.", false],
		[41, "", "Jego oddział nie zdąża przejść przez tunel, zanim ten się zamknie, więc Keith i dowódca [[character/7]] stają przeciw Voidom sami.", false],
	],
	"chart": [
		[0, "", "Mapa galaktyki wymienia każdy układ wraz z frakcją, oceną bezpieczeństwa, liczbą stacji i położeniem na mapie. Położenie podają dwie liczby od 0 do 100: pierwsza liczona od lewej krawędzi mapy gwiazd, druga od góry. Układy o podobnych liczbach leżą blisko siebie.", false],
		[0, "", "W grze mapę gwiazd otwierasz na stacji lub w locie. Przerywana linia łączy Twój obecny układ z każdym układem, do którego prowadzi jego brama skokowa; pozostałe trasy bram widać jako cienkie linie. Gwiazdy, do których możesz teraz dotrzeć, są jasne, pozostałe przygaszone. Znaczniki pokazują układ Twojej misji fabularnej i bieżącego zlecenia, a przerywana kolorowa linia wskazuje najkrótszą trasę bramami. Wyblakła złota linia odtwarza kilka Twoich ostatnich podróży.", false],
		[0, "", "Wybierz układ, aby zobaczyć jego frakcję, ocenę bezpieczeństwa i odległość. Po przybliżeniu widać jego stacje, ich poziom technologii oraz znaczniki odwiedzonych stacji, celów misji i bramy skokowej. Ukryte układy nie pojawiają się, dopóki nie poznasz ich współrzędnych; zob. [[world/galaxy]].", false],
		[32, "", "Gdy masz już system wczesnego ostrzegania ([[step/31]]), mapa gwiazd oznacza też układ i stację, przy której otworzy się następny tunel Voidów.", false],
	],
	"faction/0": [
		[0, "", "Terranie to ludzie; jednym z nich jest [[character/0]]. Mają dziesięć układów, więcej niż jakakolwiek inna frakcja, rozsianych przez środek, prawą stronę i dół mapy, a ich rdzeniem są układy [[system/19]] i [[system/14]]. Przestrzeń Terran to najbezpieczniejsza część galaktyki: oba bezpieczne układy należą do Terran.", false],
		[0, "", "Terrańskie stacje sprzedają najszerszy wybór statków i wyposażenia. Sprzedawcy statków poza przestrzenią Vossk oferują szeroką gamę kadłubów. Tradycyjnym rywalem Terran jest frakcja [[faction/1]]: reputacja zdobyta u jednej strony przepada u drugiej.", false],
		[16, "", "Terrańska Flota Kosmiczna to wciąż ta sama siła, w której służył kiedyś [[character/0]], ale minęło 35 lat. Gdy w końcu napotyka terrański konwój, ten bierze jego stary statek piracki za wroga i aresztuje go.", false],
		[18, "", "Terranie przewodzą obronie przed Voidami. [[character/1]], obecnie szef Międzygwiezdnej Agencji Bezpieczeństwa, przewodniczy sztabowi kryzysowemu, a grupa badawcza Deep Science zajmuje się problemem w tajnej stacji.", false],
	],
	"faction/1": [
		[0, "", "Vossk to obcy lud zorganizowany w imperium. Mają sześć układów w prawej dolnej części mapy, od układów [[system/3]] i [[system/12]] aż po odległy układ [[system/21]]. Cztery z nich mają ocenę „Dangerous” (niebezpieczny) lub „Risky” (ryzykowny). Układ [[system/10]] nie ma żadnego połączenia bramowego.", false],
		[0, "", "Sprzedawcy statków Vossk oferują tylko jeden kadłub, [[ship/9]], model przystosowany dla innych ras. Stacje Vossk mają też broń i wyposażenie, których nie ma nigdzie indziej. Vossk to tradycyjni rywale [[faction/0|Terran]], więc ich statki mogą dołączać do napastników w przestrzeni Terran i odwrotnie.", false],
		[18, "", "Stosunki między Terranami a Imperium Vossk pozostają chłodne i nieprzewidywalne, ale najazdy Voidów dotykają również układów Vossk.", false],
		[36, "", "W fabule Vossk jawią się jako dumni i związani honorem. Ich dowódca [[character/7]] nalega, by samemu pilotować nosiciela bomby, i zanim przyjmie postać, którą jest [[character/0]], jako eskortę, poddaje go próbie w zawodach.", false],
		[42, "", "[[character/7]] oddaje życie, by zniszczyć statek-matkę Voidów, a Terranie obiecują zgłosić jego czyn Imperium Vossk.", false],
	],
	"faction/2": [
		[0, "", "Nivelianie to obcy lud, do którego należą cztery układy po lewej stronie mapy: [[system/2]], [[system/9]], [[system/17]] i ukryty [[system/0]]. Ich stacje to zarówno małe placówki, jak i jedne z najbardziej zaawansowanych w galaktyce. Ich rywalami są [[faction/3|Midorianie]].", false],
		[2, "", "Pierwszą osobą, którą spotyka [[character/0]], jest Nivelianin, handlarz rudą [[character/2]]. [[character/0]] ma niskie mniemanie o nivelijskich manierach, podczas gdy [[character/2]] upiera się, że jest uczciwym przedsiębiorcą.", false],
		[11, "", "Z nivelijskiej wojny domowej narodziła się [[faction/3|Konfederacja Mido]]. Nivelianie nigdy nie uznali jej niepodległości i wciąż roszczą sobie prawa do układu [[system/15]].", false],
		[35, "", "Plan przeciwko statkowi-matce Voidów opiera się na nivelijskich ładunkach jądrowych.", false],
	],
	"faction/3": [
		[0, "", "Midorianie to lud [[faction/3|Konfederacji Mido]]. Mają dwa układy w lewej górnej części mapy, [[system/15]] i [[system/4]], oba z oceną „Dangerous” (niebezpieczny). Ich stacje są przeważnie małe i mają niski poziom technologii. Ich rywalami są [[faction/2|Nivelianie]].", false],
		[11, "", "Konfederację założyli terrańscy i nivelijscy uchodźcy i banici w czasie nivelijskiej wojny domowej. Ogranicza kontakty z innymi układami do minimum. Należą do niej [[character/3]], komendant stacji [[station/79]], a także [[character/2]].", false],
		[38, "", "Konfederacja nie przyjaźni się z Nivelianami. Jej statki przejmują konwój z nivelijskimi materiałami wybuchowymi przeznaczonymi na statek-matkę Voidów, a [[character/0]] musi go odbić w pobliżu stacji [[station/22]].", false],
	],
	"faction/4": [
		[0, "", "Multipody to pomniejsza rasa bez własnych układów. Jedynym Multipodem, jakiego spotykasz, jest agent [[agent/6]], który sprzedaje schemat w Space Lounge stacji [[station/61]] w układzie [[system/12]].", false],
	],
	"faction/5": [
		[0, "", "Cyborgi nie mają terytorium. Jedynym Cyborgiem w grze jest agent [[agent/14]] w Space Lounge stacji [[station/65]], który handluje współrzędnymi ukrytego układu.", false],
	],
	"faction/6": [
		[0, "", "Bobolianie to pomniejsza rasa bez własnych układów. Agent [[agent/13]], przedstawiciel tej rasy, przesiaduje w Space Lounge stacji [[station/26]] w przestrzeni Vossk i sprzedaje współrzędne ukrytego układu.", false],
	],
	"faction/7": [
		[0, "", "Grey to rasa bez własnych układów, stacji i statków. Nie odgrywa żadnej roli w handlu ani w walce.", false],
		[32, "", "Jedynym przedstawicielem rasy Grey w fabule jest [[character/20]], naukowiec współpracujący z Deep Science.", false],
		[33, "", "Bada szczątki statków Voidów i opracowuje na ich podstawie nowy rodzaj napędu.", false],
	],
	"faction/8": [
		[0, "", "Piraci to banici wszystkich ras. Nie mają układów, ale pojawiają się wszędzie i są zawsze wrodzy. To, jak często czają się w pobliżu stacji, zależy od oceny bezpieczeństwa układu. Wiele zleceń polega na polowaniu na nich, a z ich wraków można zabrać ładunek.", false],
		[0, "", "Fabuła zaczyna się od tego, że [[character/0]] ściga gang piratów dla wyznaczonej za nich nagrody.", false],
		[2, "", "[[ship/0]], statek, który [[character/2]] pożycza Keithowi ([[character/0]]), był kiedyś statkiem pirackim.", false],
		[16, "", "Dlatego Terranie biorą go później za pirata.", false],
		[19, "", "Piraci porywają też naukowca [[character/5]] w pobliżu stacji [[station/55]] i żądają okupu.", false],
	],
	"faction/9": [
		[0, "", "Voidy to wroga siła, która atakuje bez ostrzeżenia. Nie mają układów na mapie, a ich statki otwierają ogień do wszystkich. Ich myśliwiec, [[ship/8]], to najmocniej opancerzony kadłub w grze. Zob. [[world/voids]].", false],
		[2, "", "W układzie [[system/15]] Voidy znane są tylko z pogłosek i rzadkich obserwacji.", false],
		[16, "", "Eskadra Voidów atakuje stację [[station/98]], gdy przebywa tam [[character/0]]. W komunikatach radiowych zapewniają o pokojowych zamiarach, jednocześnie strzelając.", false],
		[18, "", "Voidy przybywają przez tunele czasoprzestrzenne, które na krótko otwierają się w pobliżu stacji. Najeżdżają w równym stopniu układy Terran, Nivelian i Vossk i najwyraźniej szukają rudy. Nikt nie wie, skąd pochodzą.", false],
		[24, "", "Przy stacji [[station/48]] nadają jeszcze dziwniejszy komunikat: że przybywają z przyszłości i są wszystkim, co zostało z cywilizacji galaktyki.", false],
		[26, "", "Tunel czasoprzestrzenny prowadzi do ich własnego sektora, gdzie ogromny statek-matka wypuszcza ich myśliwce.", false],
		[35, "", "Statek-matka wydaje się źródłem tuneli.", false],
		[42, "", "Zniszczenie statku-matki ([[step/41]]) powoduje zapadnięcie się tuneli i kończy najazdy, przynajmniej na jakiś czas.", false],
	],
	"guide/basics": [
		[0, "Początek", "Nowa gra zaczyna się w kosmosie, a nie na stacji. [[character/0]] ściga bandę piratów przez pole asteroid, a pierwszy lot to krótka walka, która uczy sterowania, celowania i strzelania. Przez cały jej czas widać tylko celownik i znaczniki statków. Zniszcz piratów i poczekaj, aż scena się zakończy; potem fabuła toczy się dalej sama.", false],
		[2, "", "Po wstępie budzisz się na stacji [[station/78]], małej stacji górniczej, którą prowadzi [[character/2]]. Pożycza Ci on statek [[ship/0]], nieuzbrojoną jednostkę z laserem górniczym, a pierwsze kroki fabuły uczą wydobycia, obsługi autopilota i dokowania. Broń, mapa i reszta stacji odblokowują się w miarę postępu fabuły.", false],
		[0, "Dokowanie", "Aby zadokować, trzymaj celownik na stacji, aż zostanie namierzona, a potem naciśnij Ogień: autopilot przejmuje stery i wprowadza Cię do środka. Możesz też wlecieć w stację samodzielnie; statek dokuje w chwili, gdy dotknie jej kadłuba. Przy dokowaniu odbywa się większość rozliczeń. Kadłub, pancerz i osłony zostają bezpłatnie odnowione, dostawy i pasażerowie zostają przekazani, gotowe produkty ze schematów zostają odebrane, przyznawane są nowe medale, a gra zapisuje się sama.", false],
		[0, "Ekrany stacji", "Stacja, na której zadokowałeś, oferuje sześć działów: „Hangar” (Hangar), Space Lounge, „Map” (Mapa), „Missions” (Misje), „Status” (Status) i „Game Options” (Opcje gry). Na początku fabuły niektóre z nich są zablokowane i oznaczone kłódką. „Hangar” otwiera się, gdy nastąpi [[step/5]]; „Map”, gdy nastąpi [[step/9]]; a Space Lounge i „Missions”, gdy nastąpi [[step/13]]. „Status” i „Game Options” są dostępne zawsze.", false],
		[0, "", "W „Hangar” znajdują się: „Shop” (Sklep; kupno i sprzedaż towarów i wyposażenia), „Ship” (Statek; montaż i demontaż wyposażenia), „Ships” (Statki; sprzedawca kadłubów, na stacjach, które go mają) i „Blueprints” (Schematy; produkcja). W Space Lounge czekają zleceniodawcy, handlarze i piloci do wynajęcia. „Map” pokazuje galaktykę i pozwala wybrać cel podróży. „Missions” wymienia bieżący cel fabularny i przyjęte zlecenie. „Status” pokazuje przebieg kariery pilota, Twoją reputację u czterech wielkich ras i Twoje medale. Górny pasek pokazuje „Tec Level” (poziom technologii) stacji, od którego zależy, co może mieć w sklepie.", false],
		[0, "Opuszczanie stacji", "Naciśnij „Depart” (Odlot), aby wystartować. Każdy lot zaczyna się kilkoma sekundami obserwowania odlatującego statku, wraz z danymi układu i wskazówką; dowolny klawisz, kliknięcie lub dotknięcie pozwala to pominąć. Jeśli przed odlotem wybrałeś cel w „Map”, autopilot obiera do niego kurs zaraz po starcie. Nie możesz odlecieć z większym ładunkiem, niż zmieści ładownia, więc najpierw sprzedaj albo zamontuj nadmiar.", false],
		[0, "Zapisywanie", "Gra zapisuje się automatycznie po każdym zakończonym dokowaniu, gdy nagrody i następny krok fabuły zostaną rozliczone. Podczas dokowania możesz też zapisać grę ręcznie w jednym z trzech slotów w „Game Options” i stamtąd lub z ekranu tytułowego wczytać dowolny slot albo autozapis. Poza wersją przeglądarkową „Game Options” pozwalają też wyeksportować zapis do pliku i ponownie go zaimportować. Zapisy są powiązane z danymi gry, w których je utworzono.", false],
		[0, "", "Jeśli Twój statek zostanie zniszczony, lot się kończy i kontynuujesz od stacji ostatniego autozapisu, a jeśli go nie ma, zaczynasz od nowa. Wszystko, co zdobyłeś od tamtego dokowania, przepada, więc podczas długich podróży dokuj od czasu do czasu.", false],
		[0, "Poziom pilota", "Twój pilot ma poziom, widoczny na ekranie „Status”. Doświadczenie dają zestrzelenia, zlecenia (każde warte dwa punkty), wydobyte rdzenie, każde pięćdziesiąt ton wydobytej rudy i każdych dwóch wynajętych skrzydłowych. Poziom rośnie o jeden, gdy doświadczenie przekroczy 1,3-krotność wartości z poprzedniego awansu; sprawdzane jest to przy dokowaniu. Wyższy poziom sprawia, że wrogowie są twardsi, ale podnosi też nagrody za zlecenia i stawki wynajmowanych pilotów.", false],
	],
	"guide/blueprints": [
		[0, "Schematy", "Część najlepszej broni i wyposażenia nigdy nie trafia do sklepów. Zamiast tego buduje się je według schematów. Schemat wymienia potrzebne towary i ich ilości. Schematy kupuje się od agentów z imienia w Space Lounge, którzy pojawiają się, gdy fabuła minie [[step/16]]; każdy agent sprzedaje jeden schemat, jeden raz.", false],
		[34, "", "Schematu napędu skokowego [[item/85]] nikt nie sprzedaje: przekazuje go fabuła ([[step/34]]).", false],
		[0, "Produkcja", "Produkcja odbywa się na karcie „Blueprints” (Schematy) w „Hangar” (Hangar). Wybierz schemat i przekaż składniki z ładowni. Możesz je dostarczać w częściach podczas kilku wizyt. Stacja, na której dostarczysz je po raz pierwszy, staje się stacją produkcji dla tej partii. Składniki dostarczone na dowolnej innej stacji są tam wysyłane za 10 kredytów za tonę, więc opłaca się przywozić wszystko w jedno miejsce.", false],
		[0, "Gotowe produkty", "Gdy dotrze ostatni składnik, partia jest gotowa. Broń dodatkowa powstaje po dziesięć sztuk, wszystko inne po jednej. Jeśli kończysz na stacji produkcji, produkty trafiają prosto do ładowni, nawet jeśli ją przepełnią. W przeciwnym razie czekają na stacji produkcji i zostaną przekazane przy następnym dokowaniu tam. Schemat nigdy się nie zużywa: po ukończeniu partii możesz zacząć następną.", false],
		[0, "Medale", "Posiadanie schematów liczy się do medalu [[medal/13]], a ukończenie produkcji z różnych schematów do medalu [[medal/14]].", false],
	],
	"guide/combat": [
		[0, "Broń główna", "Broń główna to działa zamocowane na stałe i strzelające do przodu: lasery, blastery, działka automatyczne i broń termiczna. Każda ma własne obrażenia, szybkostrzelność, zasięg i prędkość pocisku, a cała zamontowana broń główna strzela jednocześnie. Niektóre blastery, na przykład [[item/16]], to broń EMP, która wyczerpuje energię statku zamiast niszczyć kadłub. Auto ogień sprawia, że działa strzelają do celu bez przytrzymywania przycisku.", false],
		[0, "Osłony, pancerz i kadłub", "Obrażenia najpierw wyczerpują osłonę, potem płytę pancerza, a dopiero na końcu sam kadłub. Osłona odnawia się w pełni w czasie swojego ładowania; pancerz i kadłub nie. Robot naprawczy powoli naprawia kadłub i pancerz w trakcie lotu. Dokowanie bezpłatnie przywraca wszystko. Gdy kadłub zostanie zniszczony, ginie cały statek.", false],
		[0, "EMP", "Każdy statek ma zapas energii. Broń EMP go wyczerpuje, a statek, któremu skończy się energia, zostaje unieszkodliwiony: dryfuje bezradnie, dopóki energia się nie odbuduje. Unieszkodliwionemu statkowi można odebrać ładunek promieniem ściągającym, a niektóre zlecenia wymagają unieszkodliwienia statku zamiast jego zniszczenia. Wyposażenie chroniące przed EMP, na przykład [[item/60]], ma parametr obrony przed EMP.", false],
		[0, "Broń dodatkowa", "Broń dodatkowa strzela ze slotów broni dodatkowej i zużywa amunicję, która gromadzi się w slocie. Rakiety lecą prosto. Torpedy krótko po starcie skręcają za celem namierzonym radarem. Bomby EMP i ładunki jądrowe wybuchają na pewnym obszarze i trafiają wszystko w zasięgu wybuchu, słabiej przy jego krawędzi; bomby EMP omijają asteroidy, a ładunki jądrowe je kruszą. Wyrzutnię wybierasz w menu Akcje; dopóki tego nie zrobisz, klawisz Broń dodatkowa odpala pierwszą załadowaną.", false],
		[0, "Wieżyczki", "Większe kadłuby mają sloty na wieżyczki. Z zamontowaną wieżyczką klawisz Widok w tył przełącza na widok wieżyczki: statek utrzymuje kurs, a Ty obracasz wieżyczkę i z niej strzelasz, dzięki czemu możesz odpowiadać ogniem statkom siedzącym Ci na ogonie.", false],
		[0, "Skrzydłowi", "Gdy nastąpi [[step/16]], w Space Lounge można spotkać pilotów do wynajęcia. Umowa obejmuje od jednego do trzech statków na dziesięć minut lotu, a skrzydłowi lecą z Tobą wszędzie, dopóki nie wygaśnie. Wydawaj im rozkazy z menu Akcje: ogień według uznania, atak na Twój cel, zabezpieczenie następnego punktu misji lub przełączenie między laserem a blasterem EMP. Zob. [[guide/lounge]].", false],
		[0, "Piraci", "Piraci napadają na stacje, częściej w niebezpiecznych układach, i czyhają na pilotów przewożących ładunek lub pasażerów. Wiele zleceń polega na walce z nimi. Strzelanie do piratów nikogo nie złości; nieznacznie poprawia za to Twoją reputację u rasy, która rządzi układem.", false],
		[0, "Reputacja", "Twoja reputacja jest liczona na dwóch skalach, każda od -100 do 100: jednej między rasami [[faction/0]] i [[faction/1]], drugiej między rasami [[faction/2]] i [[faction/3]]. Wyrządzenie krzywdy jednej rasie przesuwa skalę w stronę jej rywala: unieszkodliwienie lub ograbienie jednego z jej statków kosztuje 2 punkty, zestrzelenie 5. Wykonanie zlecenia przesuwa skalę o 2 punkty w stronę rasy zleceniodawcy. Gdy skala przekroczy 60 w którąkolwiek stronę, rasa po stronie przegranej staje się wroga, a jej statki atakują Cię od razu.", false],
		[0, "", "Wroga rasa wysyła do Space Lounge dyplomatę, który proponuje wyzerowanie skali za opłatą rosnącą wraz z tym, jak daleko się przesunęła: najwyżej 16 000 kredytów. Ekran „Status” (Status) pokazuje obie skale. Przekroczenie 60 na skali daje też medal [[medal/28]].", false],
		[0, "Bratobójczy ogień", "Statki rasy rządzącej układem tolerują zabłąkane strzały tylko do pewnego stopnia. Gdy zabierzesz miejscowemu statkowi jedną trzecią kadłuba lub energii, zaczyna się bronić i ostrzega Cię przez radio. Przy dwóch trzecich kadłuba albo po jego unieszkodliwieniu wszystkie statki tej rasy w układzie zwracają się przeciwko Tobie. Statki innych ras są mniej drażliwe, ale zestrzelenie zawsze kosztuje reputację.", false],
	],
	"guide/fitting": [
		[0, "Kadłuby", "Kadłub statku określa jego pancerz (wytrzymałość samego kadłuba), ładownię, sterowność i sloty: na broń główną, broń dodatkową, wieżyczki i wyposażenie. Lepszy kadłub oznacza przede wszystkim więcej slotów. Strony statków porównują wszystkie kadłuby.", false],
		[0, "Sloty i ekran „Ship” (Statek)", "Przedmioty kupuje się do ładowni, a następnie montuje na ekranie „Ship” w „Hangar” (Hangar). Każdy slot przyjmuje jeden przedmiot swojej kategorii; montaż w zajętym slocie odkłada stary przedmiot z powrotem do ładowni. Każdy rodzaj wyposażenia można zamontować tylko raz, z wyjątkiem rodzajów, które się sumują, takich jak kompresory ładunku, kabiny i ochrona przed EMP; tych można zamontować kilka, każdy we własnym slocie. Amunicja broni dodatkowej jednego typu zajmuje jeden wspólny slot. Zamontowany przedmiot można też sprzedać prosto ze slotu po cenie stacji.", false],
		[0, "Rodzaje wyposażenia", "Osłony pochłaniają obrażenia i się odnawiają. Płyty pancerza zwiększają wytrzymałość kadłuba. Ochrona przed EMP chroni przed wyczerpaniem energii. Kompresja ładunku powiększa ładownię. Promienie ściągające przyciągają ładunek z wraków i unieszkodliwionych statków; bez nich niczego nie da się zebrać w kosmosie. Dopalacze dają zrywy prędkości. Roboty naprawcze naprawiają statek w locie. Dysze sterujące poprawiają sterowność. Skanery skracają czas namierzania celu, a te lepsze pokazują ładunek celu. Lasery górnicze wiercą w asteroidach. Kabiny przewożą pasażerów. Urządzenia maskujące na jakiś czas ukrywają statek. Napęd skokowy pozwala podróżować bez bram.", false],
		[0, "Kupno kadłuba", "Stacje ze sprzedawcą pokazują w „Hangar” kartę „Ships” (Statki) z maksymalnie pięcioma kadłubami na sprzedaż. Sprzedawcy frakcji [[faction/1]] oferują tylko kadłub własnej rasy, [[ship/9]]. Sprzedawca odejmuje od ceny katalogowej tyle procent, ile wynosi „Tec Level” (poziom technologii) stacji, więc stacje zaawansowane technologicznie sprzedają kadłuby taniej. Twój stary kadłub zostaje przyjęty w rozliczeniu za cztery piąte ceny katalogowej. Całe zamontowane wyposażenie trafia do ładowni, więc przed odlotem sprawdź, czy się mieści, albo część sprzedaj. Nie możesz zmienić kadłuba, gdy na pokładzie są pasażerowie, a kabin nie da się zdemontować, dopóki są używane.", false],
		[5, "Pierwsza broń", "Gdy hangar na stacji [[station/78]] otwiera się po raz pierwszy, na jego półce leżą bezpłatnie laser, działko automatyczne i płyta pancerza. Zamontuj działo i płytę, zanim wyruszysz na kolejną misję.", false],
		[0, "Rzadkie kadłuby", "Niektórych kadłubów zwykli sprzedawcy nigdy nie oferują. Pilot, który zdobył wszystkie medale w złocie, otrzymuje na stacji [[station/10]] ofertę prototypu [[ship/8]]; zob. [[guide/medals]].", false],
	],
	"guide/flight": [
		[0, "Pilotowanie", "Statek zawsze leci do przodu. Obracasz go w lewo i w prawo oraz podnosisz i opuszczasz jego nos; gdy puścisz stery, sam wyrównuje skrzydła. Szybkość skrętu zależy od sterowności kadłuba i od zamontowanej dyszy sterującej. W Opcje → Sterowanie ustawienie Reakcja steru może mieć wartość Bezpośrednia, która od razu skręca z pełną prędkością, albo Płynna, która łagodnie wchodzi w skręt i z niego wychodzi. Przy sterowaniu myszą klawisze lewo i prawo mogą zamiast skrętu przesuwać statek w bok.", false],
		[0, "Przepustnica", "Ciąg w górę i Ciąg w dół zmieniają ustawienie przepustnicy o ćwierć, a przytrzymanie klawisza zmienia je dalej. Statek potrzebuje około sekundy, by ustabilizować się na nowej prędkości. Autopilot i dopalacz zawsze lecą na pełnym ciągu, a zmniejszenie ciągu podczas działania dopalacza go przerywa.", false],
		[0, "Dopalacz", "Gdy zamontowany jest dopalacz, klawisz Dopalacz daje krótki zryw dodatkowej prędkości. Zryw trwa tyle, ile czas działania dopalacza, a po nim następuje czas ładowania przed kolejnym; HUD pokazuje, czy dopalacz jest gotowy. Lepsze dopalacze są szybsze, działają dłużej lub ładują się szybciej. Dopalacz przydaje się do ucieczki z walki i do pokonywania dużych odległości wewnątrz układu.", false],
		[0, "Autopilot", "Klawisz Autopilot przekazuje ster komputerowi pokładowemu, a ponowne naciśnięcie go odbiera. Autopilot leci do namierzonego obiektu, a w przeciwnym razie do celu wybranego w „Map” (Mapa): do bramy skokowej, gdy cel leży w innym układzie, albo do planety celu w tym układzie. Lista autopilota oferuje opcje dostępne w danym miejscu: zaprogramowany cel, bramę skokową, tę stację, pole asteroid i następny punkt misji. Lot do namierzonej stacji kończy się dokowaniem.", false],
		[0, "Tempo czasu", "Klawisz Tempo czasu przyspiesza lot. Podwójna prędkość jest dostępna zawsze podczas lotu. Czterokrotna i ośmiokrotna są dostępne tylko wtedy, gdy leci autopilot, w pobliżu nie ma wroga i nie trwa nic innego, na przykład wydobycie, dokowanie czy skok.", false],
		[0, "Namierzanie", "Aby namierzyć obiekt, trzymaj go w celowniku, aż skanowanie dobiegnie końca. Od zamontowanego skanera zależy, jak długo to trwa: od kilku sekund przy podstawowym modelu do niecałych dwóch przy najlepszym. Następny cel przełącza pobliskie obiekty bez celowania w nie. Stacje, bramy skokowe i gwiazdy oznaczające inne planety namierza się jednym naciśnięciem. Działanie Ognia zależy od namierzonego obiektu: na statek strzela, na stacji dokuje, przy bramie wykonuje skok, przy gwieździe leci do tej planety, a przy asteroidzie rozpoczyna wydobycie. Lepsze skanery pokazują też ładunek namierzonego statku.", false],
		[0, "Znaczniki i radar", "Statki są oznaczone na ekranie ramkami, a strzałki przy krawędzi ekranu wskazują cel, stację i pobliskie zagrożenia, których nie widać. Wrogowie są oznaczeni na czerwono, sojusznicy na zielono, statki neutralne na żółto, a punkty misji na niebiesko; opcja Kolory dla daltonistów w Opcje → Interfejs zamienia je na pomarańczowych wrogów i niebieskich sojuszników. Statek blisko Ciebie ma obok ramki dwa małe paski: kadłub i, na niebiesko, energię EMP. Wyświetlacz lotu Rozszerzony dodaje panele z dokładnymi liczbami i okrągły radar; wyświetlacz Oryginał zachowuje narożne panele samej gry.", false],
		[0, "Rozglądanie się", "Widok w tył obraca kamerę, by patrzeć za statek. Jeśli zamontowana jest wieżyczka, ten sam klawisz przełącza zamiast tego na widok wieżyczki: statek utrzymuje kurs, a Ty obracasz wieżyczkę i z niej strzelasz. Możesz też rozglądać się wokół statku bez sterowania, przytrzymując Alt i ruszając myszą, prawą gałką gamepada albo przeciągając palcem po wolnym miejscu ekranu.", false],
		[0, "Maskowanie", "Urządzenie maskujące ukrywa Twój statek przed innymi statkami na czas swojego działania, a każdy, kto na Ciebie poluje, natychmiast traci trop. Naciśnij ponownie klawisz Urządzenie maskujące, aby wyłączyć je wcześniej. Po użyciu potrzebuje czasu na naładowanie, zanim znów zadziała.", false],
		[0, "Dokowanie i podróże", "Aby zadokować, namierz stację i naciśnij Ogień albo po prostu w nią wleć. Pozostałe stacje układu widać jako jasne gwiazdy; namierz jedną z nich i naciśnij Ogień, aby polecieć do tej planety. Większość układów ma bramę skokową w pobliżu jednej ze stacji, służącą do podróży do innych układów; zob. [[guide/navigation]]. Gdy przy stacji trwa walka w ramach zlecenia, nie możesz zadokować, odlecieć ani wykonać skoku, dopóki nie zostanie wygrana lub przegrana.", false],
	],
	"guide/help": [
		[0, "Klawiatura", "Oto domyślne klawisze. Wszystkie akcje lotu można przypisać na nowo w Opcje → Sterowanie → Klawiatura, gdzie Przywróć domyślne klawisze cofa zmiany.", false],
		[0, "", "Skręt w lewo / Skręt w prawo: strzałki w lewo i w prawo albo A i D.", true],
		[0, "", "Nos w górę / Nos w dół: strzałki w górę i w dół.", true],
		[0, "", "Ciąg w górę / Ciąg w dół: W i S.", true],
		[0, "", "Ogień / użyj: Spacja lub Ctrl. Strzela z dział albo dokuje, wykonuje skok, podróżuje lub wydobywa, gdy namierzona jest stacja, brama, gwiazda lub asteroida.", true],
		[0, "", "Broń dodatkowa: E.", true],
		[0, "", "Dopalacz: Shift.", true],
		[0, "", "Autopilot: Q. Lista autopilota: R. Gdy włączona jest opcja Przytrzymaj autopilot, by otworzyć listę, przytrzymanie Q przez pół sekundy otwiera listę.", true],
		[0, "", "Następny cel: Tab.", true],
		[0, "", "Auto ogień: F.", true],
		[0, "", "Widok w tył: C. Z zamontowaną wieżyczką przełącza na widok wieżyczki.", true],
		[0, "", "Akcje / napęd skokowy: M. Otwiera menu Akcje: wybór broni dodatkowej, maskowanie, rozkazy dla skrzydłowych i napęd skokowy.", true],
		[0, "", "Mapa tras: N.", true],
		[0, "", "Urządzenie maskujące: V.", true],
		[0, "", "Tempo czasu: T.", true],
		[0, "", "Tryb fotograficzny: P. Zatrzymuje lot i ukrywa interfejs; przeciągaj lub używaj klawiszy strzałek, aby obracać kamerę, a kółkiem albo klawiszami + i - przybliżaj.", true],
		[0, "", "Menu pauzy: Escape. F11 przełącza pełny ekran w systemach stacjonarnych.", true],
		[0, "", "W menu klawisze strzałek przechodzą między pozycjami, Enter wybiera, a Escape cofa.", true],
		[0, "Mysz", "Gdy włączone jest Sterowanie myszą, ruch myszy steruje statkiem. W trakcie lotu kursor jest przechwytywany, więc statek obraca się, gdy poruszasz myszą; opcję Przechwytuj kursor w locie można wyłączyć, a menu i pauzy zawsze zwalniają kursor. Lewy przycisk strzela, prawy odpala broń dodatkową, a przytrzymanie Alt podczas ruchu myszą pozwala rozglądać się wokół statku. Gdy steruje mysz, klawisze lewo i prawo przesuwają statek w bok; opcja Klawisze lewo / prawo w Opcje → Sterowanie może ustawić je na Zawsze ruch boczny lub Zawsze skręt. Czułość myszy określa, jak bardzo statek obraca się przy danym ruchu.", false],
		[0, "Gamepad", "Lewa gałka steruje, a prawa pozwala rozglądać się wokół statku. RT lub RB strzela, LB odpala broń dodatkową, A uruchamia dopalacz, Y włącza i wyłącza autopilota, X wybiera następny cel, wciśnięcie prawej gałki daje widok w tył lub widok wieżyczki, Back otwiera menu Akcje, a Start włącza pauzę. W menu krzyżak przesuwa, A wybiera, a B cofa. W Opcje → Sterowanie → Gamepad ustawisz martwą strefę gałki i wibracje.", false],
		[0, "Dotyk", "Na ekranach dotykowych przyciski pojawiają się na ekranie, gdy Sterowanie dotykowe ma wartość Automatyczne lub Wł. Gałka po jednej stronie steruje; domyślnie pojawia się pod kciukiem, gdziekolwiek dotknie on tej strony, a opcja Gałka w stałym miejscu utrzymuje ją w jednym miejscu. Steruj z dowolnego miejsca pozwala sterować palcem na dowolnej wolnej części ekranu. Przyciski po drugiej stronie obejmują Ogień / użyj, Dodatkowa, Dopalacz, Autopilot, Cel, Widok w tył, Akcje, Pauza oraz, podczas komunikatów radiowych, Następne radio. Suwak ustawia przepustnicę, a przycisk Szybciej przyspiesza czas.", false],
		[0, "", "Dotknij szybko dwa razy przycisku Ogień, aby włączyć ogień automatyczny; jedno dotknięcie go wyłącza. Przeciąganie palcem po wolnym miejscu ekranu pozwala rozglądać się wokół statku, a po puszczeniu widok wraca do przodu. Układ dla leworęcznych zamienia strony, Rozmiar przycisków dotykowych skaluje przyciski, a Dostosuj rozmieszczenie przycisków… pozwala przesunąć każdy z nich. Telefony i tablety mogą też sterować przechyłem: włącz Sterowanie przechyłem, trzymaj urządzenie tak jak podczas gry i skalibruj.", false],
		[0, "Opcje", "„Options” (Opcje) są dostępne z ekranu tytułowego, menu pauzy i „Game Options” (Opcje gry) na stacji. Mają pięć stron. Dźwięk ustawia głośność muzyki i efektów. Ekran obejmuje okno, liczbę klatek, proporcje obrazu oraz ustawienia i szczegóły grafiki. Sterowanie obejmuje pilotowanie, mysz, gamepad, dotyk i przypisania klawiszy. Interfejs obejmuje rozmiar interfejsu, wyświetlacz lotu Oryginał lub Rozszerzony, rozmiar i przezroczystość HUD, okienka pomocy, sekwencje startu i wejścia do stacji, okrągły radar, etykiety, rozmiar tekstu oraz ustawienia dostępności, takie jak Kolory dla daltonistów, Ogranicz błyski, Wstrząsy ekranu i Czas komunikatów. Gra ustawia język silnika i pozwala zaimportować inny plik gry lub zarządzać modami.", false],
		[0, "Pomoc", "„Help” (Pomoc), dostępna z tych samych miejsc, pokazuje tematy pomocy samej gry i porady z ekranu ładowania, listę bieżących przypisań klawiszy oraz tabelę, która tłumaczy klawisze telefonu wymieniane w tekstach gry na używane tu klawisze, przyciski i sterowanie dotykowe.", false],
	],
	"guide/jobs": [
		[0, "Szukanie pracy", "Zlecenia oferują goście w Space Lounge. Zleceniodawca opisuje pracę i zapłatę. Przed przyjęciem zlecenia w innym miejscu możesz zapytać, gdzie to jest i jak trudne będzie; możesz też poprosić o powtórzenie oferty lub ją odrzucić. Naraz możesz mieć tylko jedno zlecenie, a ekran „Missions” (Misje) pokazuje je wraz z celem i liczbą skoków przez bramy, jaka Cię od niego dzieli.", false],
		[0, "Rodzaje zleceń", "Istnieje trzynaście rodzajów. Dopóki nie nastąpi [[step/16]], a także w wersjach gry bez pełnej kampanii, oferowanych jest tylko pięć: [[job/11]], [[job/0]], [[job/7]], [[job/4]] i [[job/12]]. Później pojawia się pełna gama: [[job/1]], [[job/2]], [[job/3]], [[job/5]], [[job/6]], [[job/9]] i [[job/10]], a także kupcy poszukujący towarów ([[job/8]]).", false],
		[0, "Trudność i nagroda", "Wczesne zlecenia mają trudność jeden lub dwa; późniejsze sięgają nawet dziewięciu. Podstawowa nagroda za zlecenie wynosi 1500 kredytów plus do 5500 więcej zależnie od trudności. Następnie rośnie wraz z odległością do celu (podwaja się przy 1200 km), a za każdy poziom pilota dochodzi 200 kredytów. Usuwanie złomu płaci o 30 procent mniej, eskorty o 20 procent więcej, odzyskiwanie ładunku i zbieranie szczątków podwójnie, a zlecenia pasażerskie mają mniejszą podstawę plus dodatek za każdego pasażera. Nagrody są zaokrąglane do pięćdziesięciu kredytów.", false],
		[0, "Wykonywanie zlecenia", "Zlecenia kurierskie i pasażerskie wykonuje się, dokując w miejscu docelowym z ładunkiem lub pasażerami na pokładzie. Zlecenia zakupu wykonuje się, ponownie dokując na stacji kupca z towarem w ładowni. Wszystkie pozostałe zlecenia to walki przy stacji docelowej, które rozpoczynają się po przylocie; dopóki trwają, nie możesz zadokować, odlecieć ani wykonać skoku. Odzyskane kontenery i zakładników trzeba potem dostarczyć z powrotem na stację, na której przyjęto zlecenie. Po wykonaniu zlecenia nagroda jest wypłacana od razu, Twoja reputacja u rasy zleceniodawcy rośnie, a zlecenie liczy się do medalu [[medal/16]].", false],
		[0, "Porażka", "Walka kończy się porażką, jeśli warunek zostanie złamany: wszystkie chronione statki zostaną zniszczone, kontener przepadnie, skończy się czas lub rywal zestrzeli więcej od Ciebie. Nieudane zlecenie zostaje anulowane bez zapłaty. Zlecenie możesz też porzucić na ekranie „Missions”; ewentualny ładunek zostaje odebrany. Jeśli Twój statek zostanie zniszczony, kontynuujesz od ostatniego autozapisu.", false],
	],
	"guide/lounge": [
		[0, "Goście", "Każda stacja ma Space Lounge, dostępny, gdy nastąpi [[step/13]]. Siedzi tam od trzech do pięciu gości, którzy zmieniają się przy każdym dokowaniu. Większość należy do rasy rządzącej układem, ale niektórzy pochodzą skądkolwiek. Porozmawiaj z gościem, aby usłyszeć, czego chce; każda odpowiedź i decyzja liczy się do jednego z medali za rozmowy.", false],
		[0, "Odpowiedzi", "„OK” (Dobrze) przyjmuje ofertę, „No, thanks” (Nie, dziękuję) ją odrzuca, a „How was that again?” (Jak to było?) powtarza. W przypadku zlecenia w innym miejscu możesz zapytać „Can you show it on the map?” (Możesz pokazać to na mapie?), aby poznać cel, i „Will it be difficult?” (Czy to będzie trudne?), aby dowiedzieć się, jak trudne jest zadanie. Handlarze pozwalają najpierw obejrzeć towar. Odrzucanie ofert, proszenie o powtórzenie i przyjmowanie bez pytania liczą się kolejno do medali [[medal/32]], [[medal/33]], [[medal/34]] i [[medal/35]]; rozmowy z gośćmi mającymi ofertę liczą się do medalu [[medal/26]].", false],
		[0, "Zleceniodawcy i rozmówcy", "Wielu gości oferuje zlecenia; zob. [[guide/jobs]]. Inni tylko rozmawiają i przekazują plotki, które czasem wspominają o stacjach lub rudach wartych uwagi.", false],
		[0, "Handlarze i kupcy", "Handlarze sprzedają pojedynczą partię: element wyposażenia lub kilka jednostek towaru, za 40 do 160 procent zwykłej ceny. Gdy nastąpi [[step/16]], pojawiają się też kupcy, którzy proszą o dostarczenie określonej ilości przedmiotu na tę samą stację; zob. [[job/8]].", false],
		[0, "Piloci do wynajęcia", "Gdy nastąpi [[step/16]], jeden gość w każdym Space Lounge może oferować skrzydłowych: od jednego do trzech pilotów za 700 do 1999 kredytów od pilota, na dziesięć minut lotu. Pilotów frakcji [[faction/1]] nigdy nie można wynająć. Naraz możesz mieć tylko jedną grupę. Pilot, który ma wszystkie medale, spotyka zamiast tego wielbicieli, którzy płacą za to, by z nim latać.", false],
		[0, "Agenci", "Gdy fabuła minie [[step/16]], na określonych stacjach czekają agenci z imienia, z których każdy zawiera jedną transakcję. Większość sprzedaje schemat; czterech sprzedaje współrzędne ukrytego układu, który pojawia się potem na mapie. Każdy agent odchodzi po transakcji. Agenci mają własne strony.", false],
		[0, "Dyplomaci", "Gdy jedna z czterech wielkich ras stanie się wroga, w każdym Space Lounge siedzi jeden z jej dyplomatów. Za opłatę rosnącą wraz z tym, jak bardzo spadła Twoja reputacja, do 16 000 kredytów, dyplomata zeruje tę skalę reputacji.", false],
	],
	"guide/medals": [
		[0, "Stopnie", "Większość medali ma trzy stopnie: brąz, srebro i złoto. Każdy stopień ma własny próg, a osiągnięcie wyższego zastępuje niższy medal. Kilka medali ma tylko jeden stopień. Strony medali pokazują próg dla każdego stopnia.", false],
		[0, "Kiedy przyznawane są medale", "Twoje osiągnięcia są sprawdzane, gdy zbliżasz się do stacji, zanim dok naprawi statek, a nowe lub ulepszone medale są ogłaszane po zadokowaniu. W locie nic nie jest przyznawane, więc próg osiągnięty w kosmosie liczy się dopiero przy następnym dokowaniu. Ekran „Status” (Status) wymienia każdy posiadany medal, jego stopień i to, za co go przyznano.", false],
		[0, "Pierwszy i ostatni", "Medal [[medal/0]] posiadasz od początku gry. Medal [[medal/36]] jest przyznawany automatycznie, gdy masz wszystkie pozostałe medale.", false],
		[0, "Nagrody", "Posiadanie wszystkich medali zmienia to, jak traktują Cię piloci w Space Lounge: wielbiciele płacą Ci za to, by latać z Tobą jako skrzydłowi, zamiast pobierać opłatę. Posiadanie wszystkich medali w złocie daje ofertę statku [[ship/8]], prototypu sprzedawanego na stacji [[station/10]]. Na ekranie „Status” [[character/0]] nosi ciemne okulary, gdy ma wszystkie medale, a złote, gdy wszystkie medale są złote.", false],
	],
	"guide/mining": [
		[0, "Asteroidy", "W przestrzeni każdej stacji asteroidy tworzą dwa pola: jedno blisko stacji i jedno dalej, do którego może Cię zaprowadzić Lista autopilota. To, jakie rudy zawiera pole, zależy od tego, jak blisko układ leży od układu macierzystego każdej rudy, więc nie każdą rudę można znaleźć wszędzie. Asteroidy można też rozstrzelać; czasem zostaje wtedy trochę swobodnie dryfującej rudy, a zniszczone asteroidy liczą się do medalu [[medal/29]].", false],
		[0, "Rozpoczęcie wydobycia", "Wydobycie wymaga lasera górniczego i wolnego miejsca w ładowni. Namierz asteroidę, trzymając ją w celowniku, a potem naciśnij Ogień. Statek podlatuje do skały i wiertło rusza; lot jest zablokowany, dopóki nie skończysz. Po namierzeniu HUD pokazuje rudę i klasę asteroidy.", false],
		[0, "Wiertło", "Wskaźnik pokazuje warstwy skalne asteroidy ułożone jedna na drugiej, każda węższa od poprzedniej. Wiertło dryfuje w jedną stronę i losowo zmienia kierunek co pół sekundy do dwóch i pół sekundy. Steruj w lewo i w prawo, aby utrzymać je w zielonym obszarze bieżącej warstwy. Pierwsza warstwa wymaga sześciu sekund wiercenia, a każda głębsza zajmuje mniej więcej o jedną szóstą mniej czasu niż poprzednia. Ruda przybywa przez cały czas, gdy pozostajesz w zieleni, a w głębszych warstwach szybciej.", false],
		[0, "Czerwone strefy", "Czas spędzony poza zielonym obszarem liczy się jako uszkodzenie, a czerwone strefy na wskaźniku rosną. Po łącznie dwóch i pół sekundy w czerwieni asteroida rozpada się, a wszystko, co z niej wywiercono, przepada. Naciśnij Ogień w dowolnej chwili, aby przerwać i zachować zebraną dotąd rudę. Każdą asteroidę można eksploatować tylko raz.", false],
		[0, "Klasy i rdzenie", "Większe asteroidy mają więcej warstw, od dwóch do siedmiu. Największe, klasy A, mają wszystkie siedem, a przewiercenie się przez każdą z nich daje oprócz rudy także rdzeń. Rdzenie są warte znacznie więcej niż ruda i liczą się do medali [[medal/3]] i [[medal/7]]. Rudy liczą się do medali [[medal/2]] i [[medal/6]].", false],
		[0, "Lasery górnicze", "Laser górniczy ma dwa parametry. Wydajność sprawia, że wiertło dryfuje wolniej i daje się precyzyjniej sterować, przez co łatwiej utrzymać je w zieleni. Prędkość zwiększa tempo przybywania rudy. Lasery sięgają od modelu [[item/86]] po [[item/89]]; [[item/90]] buduje się według schematu.", false],
		[0, "Ładownia", "Ruda i rdzenie trafiają prosto do ładowni, a zatrzymujesz tylko tyle, ile się w niej zmieści. Gdy ładownia jest pełna, HUD to sygnalizuje i musisz sprzedać lub wyładować towar na stacji. Kompresory ładunku powiększają ładownię o część pojemności kadłuba i można zamontować kilka naraz. Najbardziej pomaga jednak większy kadłub.", false],
	],
	"guide/navigation": [
		[0, "Mapa galaktyki", "Dział „Map” (Mapa) na stacji oraz klawisz Mapa tras w locie pokazują galaktykę: każdy znany układ na swoim miejscu, połączenia bram między nimi, rządzącą rasę i bezpieczeństwo układu. Wybranie układu przybliża go i pokazuje jego stacje; wybranie tam stacji ustawia ją jako cel podróży. Mapa pokazuje też odległość do układu w kilometrach, oznacza odwiedzone stacje i wskazuje, gdzie toczy się dalej fabuła i Twoje bieżące zlecenie. Pole wyszukiwania znajduje znane stacje po nazwie. Strona [[chart]] wymienia wszystkie układy.", false],
		[0, "", "Na początku fabuły jesteś przywiązany do orbity pierwszej stacji. „Map” otwiera się, gdy nastąpi [[step/9]]; potem możesz latać do innych planet układu.", false],
		[0, "Układy i bezpieczeństwo", "Każdym układem rządzi jedna z czterech wielkich ras i każdy ma ocenę bezpieczeństwa: „Safe” (bezpieczny), „Average” (przeciętny), „Risky” (ryzykowny) lub „Dangerous” (niebezpieczny). W niebezpiecznych układach napady piratów i wrogów są znacznie częstsze, a bezpieczne układy są przeważnie spokojne. Większość układów ma kilka stacji, każdą na orbicie własnej planety, z własnym sklepem, Space Lounge i poziomem technologii.", false],
		[0, "Bramy skokowe", "Podróże między układami odbywają się przez bramy skokowe. Układ ma co najwyżej jedną bramę, która leży w przestrzeni jednej z jego stacji i łączy go tylko z sąsiednimi układami. Aby wykonać skok, wybierz w „Map” cel w sąsiednim układzie, leć do bramy (zaprowadzi Cię tam autopilot), namierz ją i naciśnij Ogień, gdy znajdziesz się w jej strefie. Dłuższe podróże odbywa się brama po bramie; ekran „Missions” (Misje) pokazuje, ilu skoków przez znane Ci układy wymaga dotarcie do celu.", false],
		[0, "Ukryte układy", "Pięciu układów początkowo brakuje na mapie: [[system/0]], [[system/1]], [[system/6]], [[system/10]] i [[system/21]]. Ukryty układ pojawia się, gdy już w nim byłeś lub kupiłeś jego współrzędne. Sprzedaje je czterech agentów w Space Lounge: [[agent/12]] współrzędne układu [[system/0]], [[agent/13]] układu [[system/1]], [[agent/14]] układu [[system/10]], a [[agent/15]] układu [[system/21]]. Agenci z imienia pojawiają się dopiero, gdy fabuła minie [[step/16]]. Układ [[system/10]] nie ma żadnego połączenia bramowego i można do niego dotrzeć tylko napędem skokowym.", false],
		[23, "", "Drogę do układu [[system/6]] przekazuje Ci fabuła ([[step/22]]).", false],
		[0, "Napęd skokowy", "Napęd skokowy przenosi statek prosto do stacji w dowolnym znanym układzie, bez bram. Jedynym takim napędem jest [[item/85]], którego nigdy nie ma w sklepach i trzeba go zbudować według schematu. Używa się go z menu Akcje w locie. Skok nie kosztuje paliwa ani opłat. Nie jest dostępny, gdy przy Twojej stacji trwa walka w ramach zlecenia, ale zlecenia kurierskie i pasażerskie go nie blokują.", false],
		[34, "", "Fabuła daje Ci schemat napędu [[item/85]] ([[step/34]]), a część jego składników jest już dostarczona.", false],
		[0, "Odległość", "Odległości między układami podawane są w kilometrach i mierzone według położenia układów na mapie. Odległość ma znaczenie w handlu, bo ceny rosną wraz z odległością od miejsca pochodzenia towaru, oraz w zleceniach, których nagroda rośnie wraz z odległością do celu.", false],
	],
	"guide/tips": [
		[0, "", "Przed wyprawą handlową przeczytaj stronę przedmiotu: podaje ona układ, w którym przedmiot jest najtańszy, i kierunek, w którym drożeje.", true],
		[0, "", "Stacje kupują i sprzedają po tej samej cenie, więc ładunek przynosi zysk dopiero wtedy, gdy oddali się od miejsca pochodzenia.", true],
		[0, "", "Podczas wydobycia reaguj od razu na każdą zmianę dryfu. Czas w czerwieni sumuje się przez całe wiercenie, więc krótkie potknięcia kosztują tyle samo co jedno długie.", true],
		[0, "", "Jeśli wiertło spędziło już dużo czasu w czerwieni, zatrzymaj je Ogniem i zachowaj to, co masz, zamiast stracić cały urobek.", true],
		[0, "", "Jeśli chcesz rdzeni, szukaj największych asteroid: rdzeń mają tylko skały klasy A i tylko wtedy, gdy przebijesz się przez wszystkie siedem warstw.", true],
		[0, "", "Zamontuj promień ściągający wcześnie. Bez niego w ogóle nie zbierzesz ładunku z wraków i unieszkodliwionych statków.", true],
		[0, "", "Lepszy skaner zwraca się w walce: szybciej namierza cele, a najlepsze pokazują, co statek przewozi, zanim go zaatakujesz.", true],
		[0, "", "Dokowanie bezpłatnie naprawia statek, więc warto zatrzymać się na stacji między walkami, zamiast lecieć dalej z uszkodzonym kadłubem.", true],
		[0, "", "Podczas długich podróży regularnie dokuj. Autozapis powstaje tylko po zakończonym dokowaniu, a zniszczenie statku cofa Cię do ostatniego.", true],
		[0, "", "Obserwuj swoją reputację na ekranie „Status” (Status). Zabłąkane strzały w miejscowe statki się sumują, a cała rasa może stać się wroga.", true],
		[0, "", "Zanim przyjmiesz zlecenie, zapytaj zleceniodawcę, gdzie jest cel i jak trudne będzie zadanie, chyba że zbierasz medale za niepytanie.", true],
		[0, "", "Przed przyjęciem zlecenia kurierskiego zrób miejsce w ładowni, a przed zleceniem pasażerskim zamontuj kabiny: bez miejsca żadnego z nich nie można przyjąć.", true],
		[0, "", "Na zlecenia odzyskiwania ładunku i ratunkowe zabierz broń EMP, skaner pokazujący ładunek, promień ściągający i trochę wolnego miejsca w ładowni.", true],
		[0, "", "Przywieź wszystkie składniki schematu na stację, na której rozpocząłeś produkcję, a unikniesz opłaty za wysyłkę.", true],
		[0, "", "Wynajmij skrzydłowych tuż przed trudną walką: ich umowa odlicza czas tylko wtedy, gdy lecisz.", true],
	],
	"guide/trading": [
		[0, "Jak ustalane są ceny", "Każdy przedmiot ma cenę najniższą i najwyższą oraz układ macierzysty, czyli miejsce pochodzenia. W miejscu pochodzenia sprzedaje się go po najniższej cenie; im dalej od niego leży stacja, tym wyższa cena, aż do najwyższej przy określonej odległości. Do tego każda stacja dodaje własne stałe odchylenie sięgające około pięciu procent w górę lub w dół. Strony przedmiotów pokazują, gdzie dany przedmiot jest najtańszy i w którym kierunku drożeje.", false],
		[0, "Kupno i sprzedaż", "Stacja skupuje po tej samej cenie, po jakiej sprzedaje, więc zysk daje wyłącznie przewożenie towarów: kupuj blisko miejsca pochodzenia przedmiotu i sprzedawaj daleko od niego. Sprzedane towary trafiają na półkę stacji. „Shop” (Sklep) zapamiętuje też najniższą i najwyższą cenę, jaką widziałeś dla każdego przedmiotu, wraz z układem, i pokazuje je obok przedmiotu. Niektórych ładunków nie można sprzedać, na przykład przesyłek kurierskich i kontenerów przewożonych dla klienta.", false],
		[0, "Co jest w sklepie", "Każda stacja ma „Tec Level” (poziom technologii). Na jej półce są przedmioty o tym poziomie lub niższym; stacje od poziomu czwartego wzwyż pomijają przedmioty poniżej połowy własnego poziomu. Każdy przedmiot ma też określoną szansę, że trafi na daną półkę, więc oferta różni się od wizyty do wizyty. Kilka przedmiotów jest zawsze na półce na określonej stacji. Niektóre towary są sprzedawane tylko w układach frakcji [[faction/1]], a produktów ze schematów nie sprzedaje się w ogóle.", false],
		[0, "", "Towary handlowe występują w większych ilościach, a w pobliżu miejsca pochodzenia w znacznie większych. Broń i wyposażenie zwykle są dostępne po jednej do trzech sztuk, a rakiety, torpedy i bomby w większych partiach. Półka jest uzupełniana przy każdym dokowaniu, z wyjątkiem trzech ostatnio odwiedzonych stacji, które zachowują półki w takim stanie, w jakim je zostawiłeś.", false],
		[0, "Alkohole", "Każdy układ ma własny lokalny trunek, sprzedawany tylko w nim, na przykład [[item/132]] w układzie [[system/0]] czy [[item/146]] w układzie [[system/14]]. Trunki są zwykłymi towarami handlowymi. Kupowanie ich w sklepach liczy się do medalu [[medal/8]]; posiadanie różnych rodzajów kupionych od handlarzy w Space Lounge lub odzyskanych z wraków liczy się do medalu [[medal/9]].", false],
		[0, "Inne źródła", "Handlarze w Space Lounge oferują pojedyncze partie za 40 do 160 procent zwykłej ceny, więc warto porównywać ich oferty. Statki przewożą ładunek, który po ich zniszczeniu lub unieszkodliwieniu można zabrać promieniem ściągającym, a rudę można wydobywać. Kupcy w Space Lounge proszą o określoną ilość danego przedmiotu i płacą za nią znacznie więcej, niż jest warta; zob. [[job/8]].", false],
	],
	"home": [
		[0, "", "Ta ściąga opisuje Galaxy on Fire 2, kosmiczną grę o handlu, wydobyciu, walce i eksploracji. Wcielasz się w postać, którą jest [[character/0]], doświadczonego pilota uwięzionego daleko od domu, i przemierzasz 22 układy gwiezdne należące do ludzi i obcych ras. Między misjami fabularnymi możesz przyjmować zlecenia, wydobywać rudę z asteroid, handlować towarami, budować wyposażenie według schematów i kupować coraz lepsze statki.", false],
		[0, "", "Strony są budowane na podstawie zaimportowanej gry. Pochodzą z niej nazwy, liczby, ceny i dialogi, a towarzyszące im objaśnienia napisano dla tej ściągi. Szczegóły fabuły wykraczające poza miejsce, do którego dotarł Twój zapis, pozostają ukryte, dopóki tam nie dotrzesz. Dobrym punktem wyjścia są strony [[world/galaxy]], [[chart]] i [[guide/basics]].", false],
	],
	"intro/agents": [
		[0, "", "Agenci to handlarze, którzy przesiadują w określonych Space Lounge i sprzedają coś, czego nie kupisz w sklepie: rzadki schemat albo współrzędne ukrytego układu. Pojawiają się, gdy nastąpi [[step/17]], a każdy sprzedaje tylko raz. Porozmawiaj z nimi w Space Lounge ich stacji, aby zobaczyć ofertę; zob. [[guide/lounge]].", false],
	],
	"intro/blueprints": [
		[0, "", "Przedmiotów ze schematów nigdy nie sprzedaje się w sklepach. Każdy buduje się z określonego zestawu towarów, gdy masz jego schemat, zwykle kupowany od agenta w Space Lounge. Działanie produkcji wyjaśnia strona [[guide/blueprints]].", false],
	],
	"intro/characters": [
		[0, "", "Oto ludzie, których [[character/0]] spotyka w swojej podróży: handlarze, oficerowie, naukowcy i bardziej niezwykłe towarzystwo. Każda biografia rozrasta się wraz z postępem fabuły, więc o każdej postaci wiesz tylko tyle, ile dowiedział się sam Keith.", false],
	],
	"intro/equipment": [
		[0, "", "Wyposażenie zajmuje sloty wyposażenia statku: osłony i płyty pancerza do ochrony, kompresory ładunku, promienie ściągające do zbierania kontenerów, dopalacze, dysze sterujące, skanery, lasery górnicze, kabiny pasażerskie, urządzenia maskujące, robot naprawczy i napęd skokowy. Każdy element zajmuje jeden slot, więc liczba slotów ogranicza, jak kompletny może być statek. Ceny różnią się między układami, a sklepy mają tylko przedmioty do poziomu technologii swojej stacji. Część najlepszych elementów buduje się według schematów, a kilka produkują [[faction/1|Vossk]] i sprzedają tylko w swoich układach.", false],
	],
	"intro/factions": [
		[0, "", "W grze występuje dziesięć frakcji. Cztery z nich mają układy i stacje: Terranie, Vossk, Nivelianie i Midorianie. Pozostałe nie mają terytorium i spotykasz je tylko jako pojedyncze osoby lub jako wrogów. Twoja reputacja u czterech wielkich potęg jest liczona na dwóch skalach: Terranie przeciw Vossk oraz Nivelianie przeciw Midorianom; zob. [[world/galaxy]].", false],
	],
	"intro/goods": [
		[0, "", "Towary to wszystko, co przewozi się w ładowni w celach handlowych. Towary handlowe i trunki kupuje się tanio w jednym układzie i sprzedaje drogo w innym (zob. [[guide/trading]]); każdy układ ma własny trunek. Rudy wydobywa się z asteroid, a przewiercenie wszystkich warstw asteroidy klasy A daje rdzeń o znacznie wyższej wartości (zob. [[guide/mining]]). Towary handlowe, rudy i rdzenie są też składnikami do budowania przedmiotów według schematów. Kilka towarów, takich jak [[item/116]] i [[item/131]], pojawia się tylko w zleceniach lub w fabule i nie można ich kupić.", false],
	],
	"intro/guide": [
		[0, "", "Te strony wyjaśniają, jak się gra: latanie i walkę, wydobycie i handel, ekrany stacji, zlecenia, produkcję i medale. Podane tu liczby wynikają z zasad silnika; tabele na stronach przedmiotów, statków i medali pochodzą z Twoich własnych danych gry. Zacznij od stron [[guide/basics]] i [[guide/help]].", false],
	],
	"intro/jobs": [
		[0, "", "Zlecenia to praca dodatkowa oferowana przez zleceniodawców w Space Lounge, od przewozu ładunku po polowanie na poszukiwanych przestępców. Dają kredyty, reputację u rasy zleceniodawcy i doświadczenie. Istnieje trzynaście rodzajów; to, jak są oferowane i opłacane, wyjaśnia strona [[guide/jobs]].", false],
	],
	"intro/medals": [
		[0, "", "Medale nagradzają osiągnięcia pilota: walkę, wydobycie, handel, podróże, a nawet to, jak rozmawiasz z ludźmi w Space Lounge. Większość ma stopnie brązowy, srebrny i złoty. Są sprawdzane przy każdym dokowaniu; zob. [[guide/medals]].", false],
	],
	"intro/ships": [
		[0, "", "Statki różnią się pancerzem, pojemnością ładowni, sterownością i liczbą slotów: sloty broni głównej na działa strzelające do przodu, sloty broni dodatkowej na rakiety, torpedy i bomby, opcjonalny slot wieżyczki oraz sloty wyposażenia na wszystko inne. Ceny rosną gwałtownie, od niecałych 20 000 kredytów za najmniejsze kadłuby do kilku milionów za najlepsze myśliwce. Sprzedawcy poza układami [[faction/1|Vossk]] pokazują podczas każdej wizyty do pięciu kadłubów; sprzedawcy [[faction/1|Vossk]] sprzedają tylko [[ship/9]]. Sprzedawca odejmuje od ceny katalogowej tyle procent, ile wynosi poziom technologii jego stacji, i płaci cztery piąte ceny katalogowej za Twój stary kadłub. Statków [[ship/0]] i [[ship/10]] nigdy nie ma w sprzedaży. Jak wyposażyć statek, wyjaśnia strona [[guide/fitting]].", false],
	],
	"intro/stations": [
		[0, "", "Każda stacja ma sklep, hangar, sprzedawcę statków i Space Lounge. Jej poziom technologii, od 1 do 10, określa, jak zaawansowane mogą być towary i wyposażenie na jej półkach, a sprzedawca odejmuje tyle samo procent od ceny katalogowej statków. Asortyment zmienia się z wizyty na wizytę. Stacje wymienione w fabule lub goszczące agenta mają tu krótki opis.", false],
	],
	"intro/story": [
		[0, "", "Fabuła śledzi losy terrańskiego pilota, którym jest [[character/0]]; jego polowanie na piratów kończy się bardzo źle. Opowieść obejmuje 45 kroków. Strona każdego kroku podaje zadanie, a po jego ukończeniu także to, co się wydarzyło. Strony odsłaniają tylko tyle, ile osiągnął Twój zapis; [[world/history]] opowiada dotychczasowe wydarzenia w jednym miejscu.", false],
	],
	"intro/systems": [
		[0, "", "Galaktyka liczy 22 układy gwiezdne. Każdy należy do jednej frakcji, ma ocenę bezpieczeństwa określającą, jak często pojawiają się napastnicy, i mieści do pięciu stacji, z których przy jednej stoi brama skokowa. Połączenia bram decydują, między którymi układami możesz podróżować; kilka układów jest ukrytych lub nie ma żadnych połączeń. Zob. [[world/galaxy]] i [[chart]].", false],
	],
	"intro/weapons": [
		[0, "", "Broń dzieli się na dwie grupy. Broń główna (lasery, blastery, działka automatyczne i działa termiczne) strzela bez amunicji ze slotów przednich; różni się obrażeniami na strzał, szybkostrzelnością i zasięgiem. Broń dodatkową (rakiety, torpedy, bomby EMP i ładunki jądrowe) kupuje się na sztuki i odpala ze slotów broni dodatkowej. Wieżyczki potrzebują własnego slotu i mogą strzelać w dowolnym kierunku. Niektóre rodzaje broni zamiast uszkadzać statek lub oprócz tego wyczerpują jego energię; statek bez energii zostaje na pewien czas unieszkodliwiony. Część najlepszej broni nigdy nie trafia do sklepów i trzeba ją budować według schematów (zob. [[guide/blueprints]]). Wiele modeli produkują [[faction/1|Vossk]] i są one dostępne tylko w ich układach. Taktykę opisuje strona [[guide/combat]].", false],
	],
	"intro/world": [
		[0, "", "Te strony opisują świat gry: galaktykę i jej rozmieszczenie, jej historię oraz siły, które ją kształtują. Uzupełniają strony układów, stacji i frakcji o szerszy obraz.", false],
	],
	"item/0": [
		[0, "", "[[item/0]] to podstawowy laser: 3 obrażenia na strzał co 0,4 s, z zasięgiem 2000 jednostek wspólnym dla wszystkich wczesnych laserów. To najsłabszy laser w grze, ale jest tani i ma go niemal każdy sklep. [[item/1]] i [[item/2]] zachowują tę samą szybkostrzelność i zadają więcej obrażeń.", false],
		[6, "", "To jeden z trzech elementów, które [[character/2]] oferuje bezpłatnie w swoim hangarze na stacji [[station/78]] przed atakiem na kryjówkę piratów, razem z przedmiotami [[item/22]] i [[item/55]].", false],
	],
	"item/1": [
		[0, "", "[[item/1]] to drugi stopień linii Nirai. Strzela tak samo szybko jak [[item/0]] (co 0,4 s), ale zadaje 5 obrażeń na strzał zamiast 3, przy tym samym zasięgu. To tanie ulepszenie, dopóki nie będzie Cię stać na [[item/2]].", false],
	],
	"item/10": [
		[0, "", "[[item/10]] zadaje 34 obrażenia co 1,4 s przy zasięgu 2600. Uderza mocniej na strzał niż [[item/9]] i sięga dalej, przy nieco niższej szybkostrzelności. To najmocniejszy laser dostępny w sklepach.", false],
	],
	"item/11": [
		[0, "", "[[item/11]] to najmocniejszy laser w grze: 45 obrażeń co 1,5 s przy zasięgu 2600, najcięższy pojedynczy strzał spośród wszystkich broni głównych. Nigdy nie jest sprzedawany w gotowej postaci. Jego schemat sprzedaje [[agent/0]] na stacji [[station/3]], a budowa zużywa [[item/9]] wraz z [[item/155]] i kilkoma towarami handlowymi.", false],
	],
	"item/116": [
		[0, "", "Zabezpieczone kontenery to zaplombowany ładunek, który pojawia się tylko w zleceniach. Przyjęcie zlecenia typu [[job/0]] ładuje uzgodnioną ich liczbę do ładowni, gdzie zajmują miejsce; nie można ich sprzedać i są przekazywane w miejscu docelowym. Reprezentują też skradziony towar w zleceniach typu [[job/3]], gdzie statek, który je przewozi, trzeba unieszkodliwić, a nie zniszczyć.", false],
	],
	"item/117": [
		[0, "", "Zabezpieczona kabina to specjalny ładunek, który pojawia się tylko w zleceniach typu [[job/5]], w których trzeba uwolnić jeńca z jednego z kilku statków i przywieźć go z powrotem. Podobnie jak [[item/116]], nie można jej kupić ani sprzedać.", false],
	],
	"item/12": [
		[0, "", "[[item/12]] to podstawowy blaster [[faction/1|Vossk]]: 11 obrażeń co 0,6 s przy zasięgu 1500. Blastery mają mniejszy zasięg niż lasery, ale w czasie zadają więcej obrażeń; nawet ten pierwszy model nieznacznie przewyższa najlepszy laser Nirai. Jest też potrzebny do budowy przedmiotu [[item/15]]. Mają go tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/13": [
		[0, "", "[[item/13]] to blaster [[faction/1|Vossk]], który zadaje 12 obrażeń co 0,5 s przy zasięgu 1500, wyraźnie lepszy od modelu [[item/12]] pod względem szybkostrzelności i obrażeń. Mają go tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/131": [
		[0, "", "[[item/131]] to szczątki myśliwców [[faction/9|Voidów]]. Każdy zniszczony wrogi statek [[faction/9|Voidów]] zostawia kontener z jednym do trzech takich szczątków, który można zebrać tylko promieniem ściągającym (zob. [[item/68]]). Sprzedają się po stałej cenie 199 kredytów, a ich zbieranie liczy się do medalu [[medal/21]].", false],
		[24, "", "[[character/6]] potrzebuje takich szczątków do swoich badań i wysyła Keitha ([[character/0]]), by zebrał je w pobliżu stacji [[station/48]].", false],
		[25, "", "Gdy [[character/0]] je przewozi, szczątków nie można sprzedać.", false],
		[28, "", "Po przybyciu na stację [[station/10]] zostają przekazane zespołowi, którym kieruje [[character/6]].", false],
	],
	"item/14": [
		[0, "", "[[item/14]] to blaster [[faction/1|Vossk]], który strzela co 0,4 s, zadając 10 obrażeń. W czasie zadaje nieco więcej obrażeń niż [[item/13]], ale jego zasięg 1000 jest krótki, więc pasuje pilotom, którzy podchodzą blisko celu. Mają go tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/15": [
		[0, "", "[[item/15]] to najlepszy blaster [[faction/1|Vossk]]: 10 obrażeń co 0,3 s przy zasięgu 1500. Łączy szybkostrzelność szybszych blasterów z zasięgiem modelu [[item/12]]. Nigdy nie jest sprzedawany w gotowej postaci. Jego schemat sprzedaje [[agent/1]] na stacji [[station/8]], a budowa zużywa [[item/12]] i [[item/166]] wraz z kilkoma towarami handlowymi.", false],
	],
	"item/154": [
		[0, "", "[[item/154]] to najcenniejsza zwykła ruda. Pola asteroid sprzyjają rudom, których układ macierzysty leży w pobliżu, a jej ojczyzną jest układ [[system/9]], gdzie jest też najtańsza. Potrzeba jej dużo do budowy przedmiotu [[item/27]]. Przewiercenie asteroidy klasy A z rudą [[item/154]] daje [[item/165]].", false],
	],
	"item/155": [
		[0, "", "[[item/155]] to ruda o średniej cenie, której układem macierzystym jest [[system/21]], gdzie sprzedaje się najtaniej. Jest składnikiem przedmiotów [[item/11]] i [[item/90]]. Jej rdzeń to [[item/166]].", false],
	],
	"item/156": [
		[0, "", "[[item/156]] to najtańsza ruda, której ojczyzną jest układ [[system/0]]. Niska wartość czyni ją kiepskim ładunkiem na sprzedaż, ale jest składnikiem płyty pancerza [[item/59]]. Jej rdzeń to [[item/167]].", false],
	],
	"item/157": [
		[0, "", "[[item/157]] to ruda o średniej cenie, której układem macierzystym jest [[system/7]]. Razem ze swoim rdzeniem, [[item/168]], jest potrzebna do budowy płyty pancerza [[item/59]].", false],
	],
	"item/158": [
		[0, "", "[[item/158]] to ruda o średniej cenie, której układem macierzystym jest [[system/4]]. To jedna z rud potrzebnych do budowy napędu [[item/85]]. Jej rdzeń to [[item/169]].", false],
	],
	"item/159": [
		[0, "", "[[item/159]] to ruda o średniej cenie, której układem macierzystym jest [[system/18]]. Nie wykorzystuje jej żaden schemat, więc wydobywa się ją tylko na sprzedaż lub dla medali za rudę. Jej rdzeń to [[item/170]].", false],
	],
	"item/16": [
		[0, "", "[[item/16]] to pierwszy blaster EMP. Nie uszkadza kadłuba ani pancerza; zamiast tego każde trafienie wyczerpuje 3 punkty energii statku, a statek, którego energia spadnie do zera, zostaje na pewien czas unieszkodliwiony. Broń EMP jest potrzebna, gdy cel trzeba zatrzymać, a nie zniszczyć. Ten model strzela co 0,3 s, ale sięga tylko 1200 jednostek. [[item/17]] i [[item/18]] sięgają dalej i wyczerpują więcej energii na strzał.", false],
	],
	"item/160": [
		[0, "", "[[item/160]] to tania ruda, której układem macierzystym jest [[system/13]]. To jedna z rud potrzebnych do budowy napędu [[item/85]]. Jej rdzeń to [[item/171]].", false],
	],
	"item/161": [
		[0, "", "[[item/161]] to ruda o średniej cenie, której układem macierzystym jest [[system/19]]. Nie wykorzystuje jej żaden schemat. Jej rdzeń to [[item/172]].", false],
	],
	"item/162": [
		[0, "", "[[item/162]] to ruda o średniej cenie, której układem macierzystym jest [[system/14]]. Nie wykorzystuje jej żaden schemat. Jej rdzeń to [[item/173]].", false],
	],
	"item/163": [
		[0, "", "[[item/163]] to ruda o średniej cenie, której układem macierzystym jest [[system/5]]. To główny składnik przedmiotu [[item/54]], który wymaga jej 80 t, a potrzebna jest też do budowy napędu [[item/85]]. Jej rdzeń to [[item/174]].", false],
	],
	"item/164": [
		[0, "", "[[item/164]] to ruda, która nigdy nie występuje na polach asteroid zamieszkanych układów. W przeciwieństwie do innych rud kryształowa asteroida rozstrzelana na kawałki nic po sobie nie zostawia, więc kryształy trzeba wywiercić. Są kluczowym składnikiem napędu [[item/85]], który wymaga ich 50.", false],
		[25, "", "Każda asteroida w macierzystej przestrzeni [[faction/9|Voidów]], do której prowadzą ich tunele czasoprzestrzenne, składa się z tych kryształów.", false],
		[33, "", "[[character/20]] prosi Keitha ([[character/0]]) o przywiezienie co najmniej 50 kryształów, które według niego kryją tajemnicę tuneli [[faction/9|Voidów]].", false],
	],
	"item/165": [
		[0, "", "Ten rdzeń to rzadkie wnętrze asteroidy klasy A zawierającej rudę [[item/154]]. Zdobywa się go, przewiercając wszystkie siedem warstw takiej asteroidy, a od czasu do czasu wypada też po rozstrzelaniu asteroidy klasy A. Sprzedaje się za wielokrotność ceny samej rudy, najtaniej w układzie [[system/9]]. To najcenniejszy rdzeń poza rdzeniem [[item/175]].", false],
	],
	"item/166": [
		[0, "", "Ten rdzeń to rzadkie wnętrze asteroidy klasy A zawierającej rudę [[item/155]]. Zdobywa się go, przewiercając wszystkie siedem warstw takiej asteroidy, a od czasu do czasu wypada też po rozstrzelaniu asteroidy klasy A. Sprzedaje się za wielokrotność ceny samej rudy, najtaniej w układzie [[system/21]]. Jest potrzebny do budowy przedmiotu [[item/15]], a w liczbie dziesięciu sztuk do budowy przedmiotu [[item/90]].", false],
	],
	"item/167": [
		[0, "", "Ten rdzeń to rzadkie wnętrze asteroidy klasy A zawierającej rudę [[item/156]]. Zdobywa się go, przewiercając wszystkie siedem warstw takiej asteroidy, a od czasu do czasu wypada też po rozstrzelaniu asteroidy klasy A. Sprzedaje się za wielokrotność ceny samej rudy, najtaniej w układzie [[system/0]]. To najmniej cenny rdzeń.", false],
	],
	"item/168": [
		[0, "", "Ten rdzeń to rzadkie wnętrze asteroidy klasy A zawierającej rudę [[item/157]]. Zdobywa się go, przewiercając wszystkie siedem warstw takiej asteroidy, a od czasu do czasu wypada też po rozstrzelaniu asteroidy klasy A. Sprzedaje się za wielokrotność ceny samej rudy, najtaniej w układzie [[system/7]]. Do budowy przedmiotu [[item/59]] potrzeba ich piętnastu.", false],
	],
	"item/169": [
		[0, "", "Ten rdzeń to rzadkie wnętrze asteroidy klasy A zawierającej rudę [[item/158]]. Zdobywa się go, przewiercając wszystkie siedem warstw takiej asteroidy, a od czasu do czasu wypada też po rozstrzelaniu asteroidy klasy A. Sprzedaje się za wielokrotność ceny samej rudy, najtaniej w układzie [[system/4]].", false],
	],
	"item/17": [
		[0, "", "[[item/17]] wyczerpuje 5 punktów energii na trafienie co 0,5 s i sięga 2000 jednostek, znacznie dalej niż [[item/16]]. Nie uszkadza kadłuba. Wyczerpuje energię mniej więcej w tym samym tempie co Mk I, ale z bezpieczniejszej odległości.", false],
	],
	"item/170": [
		[0, "", "Ten rdzeń to rzadkie wnętrze asteroidy klasy A zawierającej rudę [[item/159]]. Zdobywa się go, przewiercając wszystkie siedem warstw takiej asteroidy, a od czasu do czasu wypada też po rozstrzelaniu asteroidy klasy A. Sprzedaje się za wielokrotność ceny samej rudy, najtaniej w układzie [[system/18]].", false],
	],
	"item/171": [
		[0, "", "Ten rdzeń to rzadkie wnętrze asteroidy klasy A zawierającej rudę [[item/160]]. Zdobywa się go, przewiercając wszystkie siedem warstw takiej asteroidy, a od czasu do czasu wypada też po rozstrzelaniu asteroidy klasy A. Sprzedaje się za wielokrotność ceny samej rudy, najtaniej w układzie [[system/13]].", false],
	],
	"item/172": [
		[0, "", "Ten rdzeń to rzadkie wnętrze asteroidy klasy A zawierającej rudę [[item/161]]. Zdobywa się go, przewiercając wszystkie siedem warstw takiej asteroidy, a od czasu do czasu wypada też po rozstrzelaniu asteroidy klasy A. Sprzedaje się za wielokrotność ceny samej rudy, najtaniej w układzie [[system/19]].", false],
	],
	"item/173": [
		[0, "", "Ten rdzeń to rzadkie wnętrze asteroidy klasy A zawierającej rudę [[item/162]]. Zdobywa się go, przewiercając wszystkie siedem warstw takiej asteroidy, a od czasu do czasu wypada też po rozstrzelaniu asteroidy klasy A. Sprzedaje się za wielokrotność ceny samej rudy, najtaniej w układzie [[system/14]].", false],
	],
	"item/174": [
		[0, "", "Ten rdzeń to rzadkie wnętrze asteroidy klasy A zawierającej rudę [[item/163]]. Zdobywa się go, przewiercając wszystkie siedem warstw takiej asteroidy, a od czasu do czasu wypada też po rozstrzelaniu asteroidy klasy A. Sprzedaje się za wielokrotność ceny samej rudy, najtaniej w układzie [[system/5]].", false],
	],
	"item/175": [
		[0, "", "[[item/175]] to rdzeń asteroidy klasy A złożonej z kryształów [[item/164]]. Ponieważ kryształowe asteroidy po rozstrzelaniu nic nie zostawiają, jedynym sposobem na jego zdobycie jest przewiercenie wszystkich siedmiu warstw. Sprzedaje się po stałej cenie 5000 kredytów, ponad pięć razy wyższej niż najlepsza cena jakiegokolwiek innego rdzenia.", false],
		[25, "", "Można go znaleźć tylko w macierzystej przestrzeni [[faction/9|Voidów]].", false],
	],
	"item/18": [
		[0, "", "[[item/18]] to najmocniejszy blaster EMP: 8 punktów energii na trafienie co 0,5 s przy zasięgu 2000, co unieszkodliwia statki zauważalnie szybciej niż [[item/17]]. Podobnie jak inne blastery EMP nie uszkadza kadłuba.", false],
	],
	"item/19": [
		[0, "", "[[item/19]] zadaje 15 obrażeń co 0,3 s przy zasięgu 1400. W czasie uderza znacznie mocniej niż jakikolwiek laser. [[item/20]] i [[item/21]] strzelają szybciej, ale sięgają tylko 1000 jednostek.", false],
	],
	"item/2": [
		[0, "", "[[item/2]] to najlepszy laser Nirai: 7 obrażeń co 0,4 s. Każdy strzał jest słabszy niż w laserach Berger, ale ponieważ strzela mniej więcej dwa razy częściej, zadaje w czasie więcej obrażeń niż którykolwiek z nich, łącznie z modelem [[item/8]]. Wyraźnie przewyższają go tylko lasery wiązkowe M6 ([[item/9]] i jego następcy).", false],
	],
	"item/20": [
		[0, "", "[[item/20]] strzela co 0,2 s, zadając 13 obrażeń. W czasie zadaje więcej obrażeń niż [[item/19]], ale jego zasięg wynosi tylko 1000 jednostek, więc najlepiej sprawdza się z bliska.", false],
	],
	"item/21": [
		[0, "", "[[item/21]] zadaje 14 obrażeń co 0,2 s, co daje najwyższe obrażenia w czasie spośród wszystkich dział przednich. Podobnie jak [[item/20]] sięga tylko 1000 jednostek. Jest też najrzadszym blasterem w sklepach.", false],
	],
	"item/22": [
		[0, "", "[[item/22]] to najsłabsze działo w grze: 2 obrażenia co 0,4 s przy zasięgu 1000. Działka automatyczne strzelają małymi, szybkimi pociskami; trafiają lekko, ale niektóre modele strzelają bardzo szybko. Ten pierwszy model to tylko rozwiązanie tymczasowe.", false],
		[6, "", "To jeden z trzech elementów, które [[character/2]] oferuje bezpłatnie w swoim hangarze na stacji [[station/78]] przed atakiem na kryjówkę piratów, razem z przedmiotami [[item/0]] i [[item/55]].", false],
	],
	"item/23": [
		[0, "", "[[item/23]] podwaja obrażenia modelu [[item/22]] do 4 na strzał i strzela nieco szybciej (co 0,3 s), wciąż przy zasięgu 1000. To tania wczesna broń.", false],
	],
	"item/24": [
		[0, "", "[[item/24]] zadaje 6 obrażeń co 0,3 s przy zasięgu 1200. To solidne działko automatyczne średniej klasy, dorównujące obrażeniami w czasie modelowi [[item/25]], który sięga dalej.", false],
	],
	"item/25": [
		[0, "", "[[item/25]] zadaje 8 obrażeń co 0,4 s i sięga 1400 jednostek, najdalej spośród działek automatycznych. W czasie zadaje tyle samo obrażeń co [[item/24]]. Nigdy nie jest sprzedawany w gotowej postaci. Jego schemat sprzedaje [[agent/2]] na stacji [[station/20]], a buduje się go wyłącznie z towarów handlowych, bez rudy.", false],
	],
	"item/26": [
		[0, "", "[[item/26]] strzela co 0,2 s, zadając 5 obrażeń przy zasięgu 1000. Dzięki szybkiemu ogniowi zadaje w czasie więcej obrażeń niż działa szynowe, kosztem zasięgu.", false],
	],
	"item/27": [
		[0, "", "[[item/27]] strzela co 0,1 s, najszybciej spośród działek automatycznych, zadając 6 obrażeń na pocisk. Jego obrażenia w czasie zbliżają się do najlepszych blasterów, ale zasięg 900 jest najkrótszy ze wszystkich dział. Nigdy nie jest sprzedawany w gotowej postaci. Jego schemat sprzedaje [[agent/3]] na stacji [[station/10]], a do budowy potrzebny jest między innymi [[item/154]].", false],
	],
	"item/28": [
		[0, "", "[[item/28]] to pierwsze działo termiczne. Działa termiczne oddają szybkie, lekkie strzały przy zasięgu 1000; to zadaje 3 obrażenia co 0,3 s. Mimo wysokiego poziomu technologii jest w czasie słabsze niż większość blasterów i działek automatycznych średniej klasy.", false],
	],
	"item/29": [
		[0, "", "[[item/29]] zadaje 4 obrażenia co 0,2 s przy zasięgu 1000, czyli dwa razy więcej obrażeń w czasie niż [[item/28]].", false],
	],
	"item/3": [
		[0, "", "[[item/3]] to laser [[faction/1|Vossk]], który zadaje 7 obrażeń co 0,5 s. Na strzał dorównuje modelowi [[item/2]], ale strzela nieco wolniej, więc w czasie wypada trochę gorzej. Mają go tylko sklepy w układach [[faction/1|Vossk]].", false],
		[0, "", "[[ship/10]], którym lata [[character/0]], ma w scenie otwierającej dwa takie lasery.", false],
	],
	"item/30": [
		[0, "", "[[item/30]] strzela co 0,1 s, zadając 3 obrażenia, najszybciej spośród dział termicznych. W czasie zadaje więcej niż [[item/29]], ale mniej niż najlepsze blastery, takie jak [[item/21]].", false],
	],
	"item/31": [
		[0, "", "[[item/31]] to podstawowa rakieta [[faction/1|Vossk]] i najtańsza amunicja dodatkowa: 60 obrażeń na trafienie, jedno odpalenie co 1,2 s, zasięg 1200. Rakiety lecą prosto i nie śledzą celu, więc najlepiej sprawdzają się z bliska. Każda rakieta lub torpeda, która trafi w asteroidę, rozbija ją. Mają ją tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/32": [
		[0, "", "[[item/32]] to popularna niekierowana rakieta: 70 obrażeń na trafienie, odpalenie co 0,9 s i zasięg 1200. Uderza mocniej i odpala się szybciej niż [[item/31]], a sprzedaje się ją powszechnie.", false],
	],
	"item/33": [
		[0, "", "[[item/33]] zadaje 72 obrażenia i dodatkowo wyczerpuje 34 punkty energii, więc może zarówno uszkodzić cel, jak i pomóc go unieszkodliwić. Przeładowuje się powoli (2 s) i sięga 1000 jednostek. Nigdy nie jest sprzedawany w gotowej postaci. Jego schemat sprzedaje [[agent/4]] na stacji [[station/43]], a partia wymaga tylko kilku tanich towarów handlowych.", false],
	],
	"item/34": [
		[0, "", "[[item/34]] służy do unieszkodliwiania, a nie niszczenia: wyczerpuje 45 punktów energii i zadaje tylko 10 obrażeń na trafienie, z odpaleniem co sekundę. [[item/35]] wyczerpuje więcej energii i zadaje więcej obrażeń.", false],
	],
	"item/35": [
		[0, "", "[[item/35]] wyczerpuje 60 punktów energii i zadaje 30 obrażeń na trafienie, z odpaleniem co sekundę i zasięgiem 1000. Unieszkodliwia statki szybciej niż [[item/34]], jednocześnie nadwerężając ich kadłub.", false],
	],
	"item/36": [
		[0, "", "[[item/36]] to podstawowa torpeda. Torpedy lecą prosto przez pierwsze 1,5 s, a potem naprowadzają się na cel. [[item/36]] zadaje 70 obrażeń przy zasięgu 3000 jednostek, ale jest wolna i odpala się tylko co 3 s. [[item/38]] zadaje dwa razy więcej obrażeń.", false],
	],
	"item/37": [
		[0, "", "[[item/37]] to najszybsza torpeda: zadaje 100 obrażeń, wyczerpuje 50 punktów energii i sięga 4000 jednostek. Odpala się co 4 s. Nigdy nie jest sprzedawana w gotowej postaci. Jej schemat sprzedaje [[agent/5]] na stacji [[station/54]], a partia wymaga tylko kilku towarów handlowych.", false],
	],
	"item/38": [
		[0, "", "[[item/38]] to torpeda o najsilniejszym uderzeniu: 140 obrażeń na trafienie i zasięg 4000. Leci powoli i odpala się co 4 s. Mają ją tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/39": [
		[0, "", "[[item/39]] to samonaprowadzająca torpeda do unieszkodliwiania statków: wyczerpuje 100 punktów energii i nie zadaje obrażeń. Przy zasięgu 5000 to tani sposób na zatrzymanie celu z dużej odległości. [[item/40]] do tego samego wyczerpania energii dodaje 120 obrażeń.", false],
	],
	"item/4": [
		[0, "", "[[item/4]] to mocniejszy laser [[faction/1|Vossk]]: 10 obrażeń co 0,6 s. Jego obrażenia w czasie są niemal dokładnie takie same jak modelu [[item/2]], z cięższymi, ale rzadszymi strzałami niż [[item/3]]. Mają go tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/40": [
		[0, "", "[[item/40]] łączy w jednej samonaprowadzającej torpedzie 120 obrażeń i wyczerpanie 100 punktów energii, przy zasięgu 5000 i odpaleniu co 5 s. Kosztuje ponad dwa razy więcej niż [[item/39]].", false],
	],
	"item/41": [
		[0, "", "[[item/41]] to najmniejsza bomba EMP. Bombę odpala się jednym naciśnięciem i detonuje drugim; wybuch wyczerpuje energię wszystkich statków w jego promieniu, silniej bliżej środka, i oszczędza statek, który ją odpalił. Asteroidy nie są naruszane. Ten model wyczerpuje do 80 punktów energii w promieniu 22 000. [[item/42]] i [[item/43]] są silniejsze i mają większy zasięg.", false],
		[20, "", "Służby bezpieczeństwa [[faction/0|Terran]] zostawiają bezpłatnie dziesięć takich bomb na stacji [[station/55]], aby [[character/0]] mógł unieszkodliwić statek porywaczy bez jego niszczenia.", false],
	],
	"item/42": [
		[0, "", "[[item/42]] wyczerpuje do 150 punktów energii w promieniu 30 000, niemal dwa razy silniej niż [[item/41]] i w znacznie szerszym wybuchu.", false],
	],
	"item/43": [
		[0, "", "[[item/43]] to najsilniejsza bomba EMP: wyczerpuje do 300 punktów energii w promieniu 37 000. Ładuje się nieco szybciej niż [[item/42]], ale kosztuje niemal dwa razy więcej.", false],
	],
	"item/44": [
		[0, "", "[[item/44]] to najmniejsza bomba jądrowa. Podobnie jak bombę EMP odpala się ją, a potem detonuje drugim naciśnięciem, ale jej wybuch zadaje prawdziwe obrażenia: do 200 w promieniu 20 000, mniej przy krawędzi. Rozbija też asteroidy. Statek, który ją odpalił, nie odnosi szkód.", false],
	],
	"item/45": [
		[0, "", "[[item/45]] zadaje do 560 obrażeń w promieniu 30 000, niemal trzy razy więcej niż [[item/44]], w szerszym wybuchu.", false],
	],
	"item/46": [
		[0, "", "[[item/46]] to najbardziej niszczycielska broń w grze: do 950 obrażeń w promieniu 40 000. Nigdy nie jest sprzedawana w gotowej postaci. Jej schemat sprzedaje [[agent/6]] na stacji [[station/61]], a do budowy potrzebne są między innymi towary radioaktywne i materiały wybuchowe.", false],
	],
	"item/47": [
		[0, "", "[[item/47]] to podstawowa wieżyczka. Wieżyczka zajmuje własny slot, który mają tylko niektóre kadłuby, i może obracać się dookoła, więc trafia cele z boku i z tyłu statku; gdy nią celujesz, statek leci dalej sam. Ten model zadaje 6 obrażeń co 0,3 s przy zasięgu 2000 i obraca się powoli (sterowność 40).", false],
	],
	"item/48": [
		[0, "", "[[item/48]] zadaje 10 obrażeń co 0,2 s przy zasięgu 2500 i obraca się szybciej niż [[item/47]] (sterowność 60). Kosztuje ponad trzy razy więcej.", false],
	],
	"item/49": [
		[0, "", "[[item/49]] to najlepsza wieżyczka: 12 obrażeń co 0,1 s przy zasięgu 3000 i najszybszy obrót (sterowność 100). Jest też bardzo droga i kosztuje mniej więcej dwa razy tyle co [[item/48]]. Mają ją tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/5": [
		[0, "", "[[item/5]] otwiera linię laserów Berger, która poświęca szybkostrzelność na rzecz cięższych strzałów i nieco większego zasięgu (2200). Zadaje 8 obrażeń co 0,9 s, co daje mniej obrażeń w czasie niż tańszy [[item/2]]. Jego zaletą jest większy zasięg.", false],
	],
	"item/50": [
		[0, "", "[[item/50]] to podstawowa osłona. Osłona pochłania nadchodzące obrażenia, zanim dotkną pancerza i kadłuba, i sama się odnawia w czasie ładowania. Targe mieści tylko 50 punktów, ale odnawia się w pełni w 20 s, szybciej niż jakakolwiek inna osłona.", false],
	],
	"item/51": [
		[0, "", "[[item/51]] mieści 80 punktów, ale potrzebuje 46 s na pełne odnowienie. W pojedynczej walce pochłania więcej niż [[item/50]], ale między atakami regeneruje się znacznie wolniej.", false],
	],
	"item/52": [
		[0, "", "[[item/52]] to osłona [[faction/1|Vossk]], która mieści 120 punktów i odnawia się w 58 s. Pochłania znacznie więcej niż [[item/51]], ale [[item/53]] mieści więcej i odnawia się szybciej. Mają ją tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/53": [
		[0, "", "[[item/53]] mieści 150 punktów i odnawia się w 45 s, więc przewyższa [[item/52]] pod oboma względami. To najlepsza osłona dostępna w sklepach.", false],
	],
	"item/54": [
		[0, "", "[[item/54]] to najsilniejsza osłona: 220 punktów, odnawianie w 60 s. Nigdy nie jest sprzedawana w gotowej postaci. Jej schemat sprzedaje [[agent/7]] na stacji [[station/72]], a do budowy potrzeba dużej ilości towaru [[item/163]] wraz z elektroniką, nanotechnologią i mikroczipami.", false],
	],
	"item/55": [
		[0, "", "[[item/55]] to podstawowa płyta pancerza. Płyta dodaje swoje punkty do pancerza statku; po osłonie przyjmuje obrażenia przed kadłubem i w przeciwieństwie do osłony się nie odnawia. E2 dodaje 40 punktów, sporo jak na lekki statek startowy, taki jak [[ship/32]], który ma ich 100 własnych.", false],
		[6, "", "To jeden z trzech elementów, które [[character/2]] oferuje bezpłatnie w swoim hangarze na stacji [[station/78]] przed atakiem na kryjówkę piratów, razem z przedmiotami [[item/0]] i [[item/22]].", false],
	],
	"item/56": [
		[0, "", "[[item/56]] dodaje 80 punktów pancerza, dwa razy więcej niż [[item/55]], za umiarkowaną cenę.", false],
	],
	"item/57": [
		[0, "", "[[item/57]] dodaje 110 punktów pancerza. To najlepsza płyta sprzedawana poza układami [[faction/1|Vossk]].", false],
	],
	"item/58": [
		[0, "", "[[item/58]] to płyta [[faction/1|Vossk]], która dodaje 160 punktów pancerza, znacznie więcej niż [[item/57]]. Mają ją tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/59": [
		[0, "", "[[item/59]] to najlepsza płyta pancerza: dodaje 250 punktów, tyle co bazowy pancerz statku [[ship/9]] i więcej niż jakikolwiek inny kadłub poza statkiem [[ship/8]]. Nigdy nie jest sprzedawana w gotowej postaci. Jej schemat sprzedaje [[agent/8]] na stacji [[station/84]], a do budowy potrzebne są [[item/157]], [[item/168]] i [[item/156]] wraz z towarami handlowymi.", false],
	],
	"item/6": [
		[0, "", "[[item/6]] zadaje 9 obrażeń co 0,8 s przy zasięgu 2200. To skromny krok naprzód w stosunku do modelu [[item/5]], a jego cena prawie nie różni się między układami.", false],
	],
	"item/60": [
		[0, "", "[[item/60]] to najsłabszy z trzech modułów ochrony przed EMP, z obroną przed EMP równą 20. Żaden z trzech nie ma ceny i żaden sklep ich nie oferuje.", false],
	],
	"item/61": [
		[0, "", "[[item/61]] to średni moduł ochrony przed EMP, z obroną przed EMP równą 40, dwa razy większą niż [[item/60]]. Podobnie jak pozostałe nie ma ceny i nie ma go w sklepach.", false],
	],
	"item/62": [
		[0, "", "[[item/62]] to najsilniejszy moduł ochrony przed EMP, z obroną przed EMP równą 60. Podobnie jak [[item/60]] i [[item/61]] nie ma ceny i nie ma go w sklepach.", false],
	],
	"item/63": [
		[0, "", "[[item/63]] to podstawowy kompresor ładunku. Kompresor powiększa ładownię o procent pojemności samego kadłuba; ten dodaje 15%. Jest tani i opłaca się każdemu handlarzowi i górnikowi.", false],
	],
	"item/64": [
		[0, "", "[[item/64]] powiększa ładownię o 25%, co przy niskiej cenie jest wyraźnym krokiem naprzód w stosunku do modelu [[item/63]].", false],
	],
	"item/65": [
		[0, "", "[[item/65]] powiększa ładownię o 40%. Na dużym frachtowcu dodaje tyle miejsca, ile mieści cały mały statek.", false],
	],
	"item/66": [
		[0, "", "[[item/66]] powiększa ładownię o 75%, najwięcej spośród kompresorów dostępnych w sklepach.", false],
	],
	"item/67": [
		[0, "", "[[item/67]] podwaja ładownię, dodając 100% pojemności kadłuba: [[ship/36]] mieści z nim 700 t. Nigdy nie jest sprzedawany w gotowej postaci. Jego schemat sprzedaje [[agent/9]] na stacji [[station/90]], a buduje się go wyłącznie z towarów handlowych.", false],
	],
	"item/68": [
		[0, "", "[[item/68]] to podstawowy promień ściągający. Bez promienia ściągającego nie da się zebrać żadnego dryfującego kontenera; wlecenie w niego nic nie daje. Z Retractorem trzymasz kontener w celowniku przez 4 s, po czym zostaje on wciągnięty. [[item/69]] potrzebuje mniej czasu, a [[item/70]] działa automatycznie.", false],
		[24, "", "[[character/6]] prosi Keitha ([[character/0]]) o zamontowanie promienia ściągającego przed pierwszą wyprawą przeciwko [[faction/9|Voidom]], aby mógł zbierać szczątki ich statków. Do tego czasu sklepy mają dużą szansę, by poza zwykłym asortymentem oferować Retractor.", false],
	],
	"item/69": [
		[0, "", "[[item/69]] działa jak [[item/68]], ale wymaga trzymania celu w celowniku tylko przez 3 s, zanim wciągnie kontener.", false],
	],
	"item/7": [
		[0, "", "[[item/7]] zadaje 10 obrażeń co 0,8 s przy zasięgu 2200. W czasie dorównuje modelowi [[item/1]], więc jego wartość polega na rzadszych, cięższych trafieniach z dużej odległości.", false],
	],
	"item/70": [
		[0, "", "[[item/70]] to automatyczny promień ściągający: zbiera każdy kontener w widoku z przodu bez celowania i przytrzymywania, co oszczędza mnóstwo czasu przy plądrowaniu pola bitwy. Jest znacznie droższy niż [[item/69]].", false],
	],
	"item/71": [
		[0, "", "[[item/71]] to podstawowy dopalacz. Dopalacz daje krótki zryw dodatkowej prędkości, a potem potrzebuje czasu na naładowanie. Ten dodaje 60% prędkości na 3 s i ładuje się 8 s.", false],
	],
	"item/72": [
		[0, "", "[[item/72]] ma deklarowane 80% dodatkowej prędkości przez 4,4 s i ładowanie 10 s. W locie jego zryw osiąga tę samą prędkość maksymalną co [[item/71]]; zyskujesz dłuższy zryw.", false],
	],
	"item/73": [
		[0, "", "[[item/73]] daje ponad dwa razy więcej niż tańsze dopalacze: 160% dodatkowej prędkości przez 5,6 s, z ładowaniem 12 s.", false],
	],
	"item/74": [
		[0, "", "[[item/74]] to najsilniejszy dopalacz: 200% dodatkowej prędkości przez 6 s. Wymaga najdłuższego ładowania, 16 s. Mają go tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/75": [
		[0, "", "[[item/75]] to jedyny robot naprawczy w grze; zajmuje slot wyposażenia. W trakcie lotu odnawia jeden punkt kadłuba co 0,6 s i jeden punkt płyty pancerza co sekundę, więc uszkodzenia znikają między walkami bez dokowania. Jest tani i ma go większość sklepów.", false],
	],
	"item/76": [
		[0, "", "[[item/76]] to podstawowa dysza sterująca. Dysza dodaje swoją wartość do sterowności statku, więc statek skręca szybciej. Ta dodaje 20, niewiele dla zwrotnych myśliwców, ale zauważalnie na powolnym frachtowcu.", false],
	],
	"item/77": [
		[0, "", "[[item/77]] dodaje 40 sterowności, dwa razy więcej niż [[item/76]], za niską cenę.", false],
	],
	"item/78": [
		[0, "", "[[item/78]] to dysza [[faction/1|Vossk]], która dodaje 70 sterowności. Mają ją tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/79": [
		[0, "", "[[item/79]] to dysza [[faction/1|Vossk]], która dodaje 100 sterowności, dość, by ciężki frachtowiec skręcał jak zwrotny myśliwiec. Mają ją tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/8": [
		[0, "", "[[item/8]] to ostatni i najmocniejszy laser Berger: 12 obrażeń na strzał co 0,9 s przy zasięgu 2200. To najmocniej uderzający konwencjonalny laser w przeliczeniu na strzał, ale szybszy [[item/2]] wciąż zadaje więcej obrażeń w czasie. Następujące po nim lasery wiązkowe M6 (od [[item/9]] wzwyż) uderzają ponad dwa razy mocniej na strzał.", false],
	],
	"item/80": [
		[0, "", "[[item/80]] to najlepsza dysza sterująca, dodająca 130 sterowności. Podnosi sterowność statku [[ship/36]], najwolniej skręcającego kadłuba, z 45 do 175, czyli więcej, niż ma jakikolwiek myśliwiec bez dyszy. W sklepach występuje rzadko.", false],
	],
	"item/81": [
		[0, "", "[[item/81]] to podstawowy skaner. Skaner określa, jak długo trwa namierzanie celu, takiego jak statek, stacja czy asteroida; Quickscan potrzebuje 4 s. [[item/82]] namierza szybciej i pokazuje też, co przewożą inne statki.", false],
		[2, "", "Statek górniczy, który należy do handlarza [[character/2]], czyli [[ship/0]], ma jeden taki zamontowany.", false],
	],
	"item/82": [
		[0, "", "[[item/82]] namierza w 3 s i pokazuje ładunek namierzonych statków, co pomaga w polowaniu na łupy.", false],
	],
	"item/83": [
		[0, "", "[[item/83]] namierza w 1,8 s, a taki czas osiąga poza nim tylko [[item/84]]; pokazuje też ładunek celów.", false],
	],
	"item/84": [
		[0, "", "[[item/84]] namierza tak szybko jak [[item/83]] i pokazuje ładunek, a ponadto oznacza asteroidy klasy A, jedyne, które mogą dać rdzeń (zob. [[guide/mining]]). To skaner pierwszego wyboru dla górników.", false],
	],
	"item/85": [
		[0, "", "[[item/85]] to jedyny napęd skokowy w grze. Gdy jest zamontowany, możesz z mapy gwiazd podróżować prosto do stacji w innym układzie, bez przelatywania przez bramy skokowe. Nie można go używać podczas niektórych misji. Nigdy nie jest sprzedawany w gotowej postaci i żaden agent nie sprzedaje jego schematu. Do budowy potrzebne są [[item/164]], [[item/158]], [[item/160]] i [[item/163]] wraz z dużymi ilościami towarów handlowych.", false],
		[33, "", "Jego wynalazca, [[character/20]], prosi Keitha ([[character/0]]) o 50 sztuk towaru [[item/164]] do prac nad napędem, który mógłby dotrzeć w dowolne miejsce w przestrzeni.", false],
		[34, "", "W zamian za kryształy [[character/20]] daje Keithowi ([[character/0]]) kopię schematu. Dostarczone 50 kryształów zalicza się na poczet napędu, więc trzeba dostarczyć tylko pozostałe składniki.", false],
	],
	"item/86": [
		[0, "", "[[item/86]] to podstawowy laser górniczy. Laser górniczy jest potrzebny do wydobywania rudy z asteroid. Jego wydajność określa, jak stabilnie wiertło trzyma kurs, a każdy model ma też własną prędkość wiercenia (zob. [[guide/mining]]). Ten ma wydajność 30 i trudno utrzymać go na kursie w głębokich warstwach.", false],
	],
	"item/87": [
		[0, "", "[[item/87]] ma wydajność 50. Jest zauważalnie stabilniejszy niż [[item/86]], choć wierci nieco wolniej.", false],
	],
	"item/88": [
		[0, "", "[[item/88]] to laser górniczy [[faction/1|Vossk]] o wydajności 80, najstabilniejsze wiertło dostępne w sklepach. Jego wadą jest to, że najwolniej wydobywa rudę. Mają go tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/89": [
		[0, "", "[[item/89]] ma wydajność 60, mniej stabilną niż [[item/88]], ale wydobywa rudę znacznie szybciej niż jakikolwiek inny laser dostępny w sklepach. Pasuje górnikom, którzy sami potrafią utrzymać wiertło na kursie.", false],
	],
	"item/9": [
		[0, "", "[[item/9]] to pierwszy z laserów wiązkowych M6. Strzelają one rzadko, ale bardzo mocno: 27 obrażeń co 1,2 s przy zasięgu 2400, większym niż w jakimkolwiek wcześniejszym laserze. Liczy się celność, bo chybienie marnuje długie przeładowanie. Jest to też część bazowa do budowy przedmiotu [[item/11]].", false],
	],
	"item/90": [
		[0, "", "[[item/90]] to najlepszy laser górniczy: wydajność 100 i najszybsze wiercenie spośród wszystkich modeli. Nigdy nie jest sprzedawany w gotowej postaci. Jego schemat sprzedaje [[agent/11]] na stacji [[station/78]], a do budowy potrzeba dużych ilości nanotechnologii, części mechanicznych i hydrauliki oraz towaru [[item/155]] i dziesięciu sztuk [[item/166]].", false],
		[2, "", "Laser na pierwszym statku górniczym, którym lata [[character/0]], to ręcznie zbudowany prototyp tego wiertła, dzieło handlarza [[character/2]].", false],
		[10, "", "Gdy [[character/2]] oddaje Keithowi ([[character/0]]) statek [[ship/0]], zatrzymuje prototyp, jedyny, jaki ma, i sugeruje późniejszą wizytę, kiedy może zbuduje ich więcej.", false],
	],
	"item/91": [
		[0, "", "[[item/91]] mieści 3 pasażerów. Kabiny są potrzebne do zleceń typu [[job/11]], a miejsca w kilku kabinach się sumują. [[item/92]] i [[item/93]] mieszczą więcej.", false],
	],
	"item/92": [
		[0, "", "[[item/92]] mieści 5 pasażerów, o dwóch więcej niż [[item/91]].", false],
	],
	"item/93": [
		[0, "", "[[item/93]] mieści 10 pasażerów, dwa razy więcej niż [[item/92]], co otwiera dostęp do większych zleceń pasażerskich.", false],
	],
	"item/94": [
		[0, "", "[[item/94]] to podstawowe urządzenie maskujące. Gdy maskowanie jest aktywne, inne statki Cię nie widzą. Ten model ukrywa statek na 15 s, a potem potrzebuje 18 s na naładowanie. Czas spędzony w maskowaniu liczy się do medalu [[medal/19]].", false],
	],
	"item/95": [
		[0, "", "[[item/95]] to urządzenie maskujące [[faction/1|Vossk]], które ukrywa statek na 28 s i ładuje się 32 s, dając niemal dwa razy dłuższą osłonę niż [[item/94]]. Mają je tylko sklepy w układach [[faction/1|Vossk]].", false],
	],
	"item/96": [
		[0, "", "[[item/96]] to najlepsze urządzenie maskujące: ukrywa statek na 46 s i ładuje się tylko 40 s, więc przez większość czasu może być aktywne. Nigdy nie jest sprzedawane w gotowej postaci. Jego schemat sprzedaje [[agent/10]] na stacji [[station/59]].", false],
	],
	"job/0": [
		[0, "", "Zlecenie kurierskie polega na przewiezieniu ładunku zaplombowanych kontenerów na inną stację. Kontenery trafiają do ładowni w chwili przyjęcia, więc potrzebujesz dość wolnego miejsca; nie można ich sprzedać. Zlecenie jest wykonane, gdy zadokujesz w miejscu docelowym z ładunkiem na pokładzie. Piraci czasem czyhają na kurierów. Dostarczony ładunek liczy się do medalu [[medal/5]].", false],
	],
	"job/1": [
		[0, "", "W zleceniu obrony stacja ma zostać zaatakowana, a Ty zostajesz wynajęty, by pomóc jej własnym myśliwcom odeprzeć napastników. Atakującymi są zwykle piraci, a w przeciwnym razie statki rasy rywalizującej. Leć do stacji i zniszcz wszystkich napastników; zestrzelenia sojuszniczych myśliwców również się liczą. Trudniejsze zlecenia oznaczają więcej napastników.", false],
	],
	"job/10": [
		[0, "", "W zleceniu przechwycenia konwój dwóch lub trzech frachtowców z nielegalnym ładunkiem stoi daleko od stacji pod ochroną myśliwców. Podążaj za punktami nawigacyjnymi i zniszcz frachtowce. Ich strażnicy czekają po drodze i wokół konwoju.", false],
	],
	"job/11": [
		[0, "", "Zlecenie pasażerskie polega na przewiezieniu grupy osób na inną stację. W chwili przyjęcia potrzebujesz kabin z miejscem dla wszystkich; dopóki pasażerowie są na pokładzie, kabin nie można zdemontować, a kadłuba zmienić. Zadokuj w miejscu docelowym, aby ich dostarczyć. Podstawowa nagroda jest niższa, ale każdy pasażer ją powiększa. Dostarczeni pasażerowie liczą się do medalu [[medal/18]].", false],
	],
	"job/12": [
		[0, "", "Wyzwanie to zawody strzeleckie oferowane przez innego pilota w Space Lounge. Obaj wylatujecie z tej samej stacji do grupy piratów rozmieszczonych wzdłuż trasy, a wygrywa ten, kto zestrzeli ich więcej. Rywala nie da się zniszczyć, a trafia tak mocno jak Twoje własne działa. Zapłatę dostajesz tylko wtedy, gdy masz więcej zestrzeleń; piratów jest zawsze nieparzysta liczba, więc remisów nie ma.", false],
	],
	"job/2": [
		[0, "", "Zlecenie ochrony wysyła Cię do pilnowania statków górniczych pracujących na polu asteroid w pobliżu stacji. Przybywają napastnicy i kierują się ku stacji i górnikom. Zniszcz ich wszystkich, zanim zdążą wybić górników; jeśli przepadną wszystkie statki górnicze, zlecenie kończy się porażką.", false],
	],
	"job/3": [
		[0, "", "W zleceniu odzyskania skradziony towar przewozi jeden z grupy pirackich statków w pobliżu stacji. Musisz odzyskać kontener bez jego zniszczenia: unieszkodliw przewoźnika bronią EMP i przyciągnij kontener promieniem ściągającym. Skaner pokazujący ładunek pomaga znaleźć właściwy statek. Kontener przepada, jeśli przewoźnik zostanie zniszczony albo w Twojej ładowni zabraknie na niego miejsca. Gdy go masz, wróć na stację, na której przyjąłeś zlecenie, aby otrzymać zapłatę. Odzyskanie płaci podwójnie.", false],
	],
	"job/4": [
		[0, "", "Polowanie na piratów polega na oczyszczeniu pirackiej kryjówki w pobliżu stacji. Piraci czekają na polu asteroid lub na trasie z dwóch lub trzech punktów nawigacyjnych i ruszają dopiero, gdy Cię zobaczą. Podążaj za punktami i zniszcz każdego pirata. Wyższa trudność oznacza więcej piratów.", false],
	],
	"job/5": [
		[0, "", "Zlecenie ratunkowe polega na uwolnieniu zakładnika przetrzymywanego na pokładzie jednego z grupy statków w pobliżu stacji. Tak jak przy odzyskaniu, unieszkodliw statek porywacza bronią EMP i przyciągnij zakładnika na pokład promieniem ściągającym; zniszczenie tego statku kończy zlecenie. Następnie przywieź zakładnika na stację, na której przyjąłeś zlecenie. Akcja ratunkowa płaci podwójnie.", false],
	],
	"job/6": [
		[0, "", "Zlecenie list gończy wskazuje groźnego przestępcę, którego widziano w pobliżu stacji. Cel czeka w punkcie daleko od stacji i reaguje dopiero, gdy pojawisz się w zasięgu wzroku. Jest znacznie twardszy niż zwykły pirat i staje się jeszcze twardszy wraz z trudnością zlecenia i Twoim poziomem pilota. Zniszcz go, aby zgarnąć nagrodę.", false],
	],
	"job/7": [
		[0, "", "Usuwanie złomu polega na oczyszczeniu chmury kosmicznego śmiecia w pobliżu stacji w ciągu około dwóch minut. Każdy kawałek trzeba zniszczyć, zanim skończy się czas; przy wyższej trudności dołącza kilku piratów. Płaci mniej niż większość zleceń, ale jest szybkie, a zniszczony złom liczy się do medalu [[medal/10]].", false],
	],
	"job/8": [
		[0, "", "Zlecenie zakupu pochodzi od kupca w Space Lounge, który chce określonej ilości jednego konkretnego przedmiotu. Zdobądź towar w sklepach, od handlarzy lub z wydobycia i ponownie zadokuj na stacji kupca z towarem w ładowni. Towar zostaje przekazany, a Ty otrzymujesz połowę zwykłej nagrody za zlecenie plus trzykrotność średniej wartości towaru, więc kupiec płaci zwykle znacznie więcej niż jakikolwiek sklep. Kupcy pojawiają się, gdy nastąpi [[step/16]].", false],
	],
	"job/9": [
		[0, "", "Zlecenie eskorty polega na ochronie konwoju pięciu frachtowców w pobliżu stacji. Gdy frachtowce lecą dalej, napastnicy czekający na ich trasie zbliżają się do nich. Zniszcz wszystkich napastników. Jeśli przepadną wszystkie frachtowce, zlecenie kończy się porażką. Eskorty płacą o jedną piątą więcej niż większość zleceń.", false],
	],
	"medal/0": [
		[0, "", "[[character/0]] ma ten medal od początku gry za swoją dawną służbę. Nie trzeba nic robić, by go zdobyć.", false],
	],
	"medal/1": [
		[0, "", "Przyznawany za dotarcie do stacji z bardzo małą resztką kadłuba. Sprawdzenie następuje podczas zbliżania się, zanim dok naprawi statek, i dotyczy wytrzymałości samego kadłuba, a nie płyty pancerza. Im mniejsza pozostała część, tym wyższy stopień.", false],
	],
	"medal/10": [
		[0, "", "Przyznawany za niszczenie kosmicznego złomu, takiego jak w zleceniach typu [[job/7]]. Liczy się każdy zestrzelony kawałek.", false],
	],
	"medal/11": [
		[0, "", "Przyznawany za liczbę różnych stacji, na których zadokowałeś.", false],
	],
	"medal/12": [
		[0, "", "Przyznawany za liczbę różnych odwiedzonych układów. Ukryte układy liczą się, gdy do nich dotrzesz.", false],
	],
	"medal/13": [
		[0, "", "Przyznawany za liczbę posiadanych schematów. Schematy kupuje się od agentów w Space Lounge; zob. [[guide/blueprints]].", false],
	],
	"medal/14": [
		[0, "", "Przyznawany za liczbę różnych schematów, według których przynajmniej raz ukończyłeś produkcję. Ponowne zbudowanie tego samego przedmiotu go nie zwiększa.", false],
	],
	"medal/15": [
		[0, "", "Przyznawany za czas gry w godzinach. Gra liczy czas spędzony w locie.", false],
	],
	"medal/16": [
		[0, "", "Przyznawany za liczbę wykonanych zleceń. Nieudane i porzucone zlecenia się nie liczą.", false],
	],
	"medal/17": [
		[0, "", "Przyznawany za liczbę przelotów przez bramę skokową. Skoki napędem skokowym się nie liczą.", false],
	],
	"medal/18": [
		[0, "", "Przyznawany za liczbę pasażerów dostarczonych w zleceniach typu [[job/11]]. Więcej miejsca w kabinach oznacza większe grupy.", false],
	],
	"medal/19": [
		[0, "", "Przyznawany za łączną liczbę minut spędzonych w maskowaniu. Zamontuj urządzenie maskujące i używaj go, gdy tylko jest naładowane.", false],
	],
	"medal/2": [
		[0, "", "Przyznawany za wydobycie różnych rodzajów rudy. Każdy rodzaj liczy się raz, niezależnie od wydobytej ilości. Ponieważ pola zawierają rudy, których układ macierzysty leży w pobliżu, trzeba będzie wydobywać w kilku częściach galaktyki.", false],
	],
	"medal/20": [
		[0, "", "Przyznawany za liczbę odpalonych bomb EMP i ładunków jądrowych.", false],
	],
	"medal/21": [
		[0, "", "Przyznawany za tony towaru [[item/131]] zebranego promieniem ściągającym z wraków i unieszkodliwionych statków.", false],
	],
	"medal/22": [
		[0, "", "Medal jednostopniowy za latanie bez żadnej zamontowanej broni albo bez żadnego zamontowanego wyposażenia, sprawdzany przy najbliższym dokowaniu. Nie można go zdobyć na początku fabuły: dopóki nie nastąpi [[step/8]], statek zawsze liczy się jako uzbrojony.", false],
	],
	"medal/23": [
		[0, "", "Przyznawany za liczbę jednocześnie zamontowanych broni głównych, sprawdzaną przy dokowaniu. Do wyższych stopni potrzebny jest kadłub z wieloma slotami na broń główną. Podobnie jak [[medal/22]], liczy się dopiero, gdy nastąpi [[step/8]].", false],
	],
	"medal/24": [
		[0, "", "Przyznawany za tony ładunku zabranego promieniem ściągającym z wraków i unieszkodliwionych statków.", false],
	],
	"medal/25": [
		[0, "", "Przyznawany za największą liczbę kredytów posiadanych w jednej chwili. Późniejsze wydanie pieniędzy tego nie odbiera.", false],
	],
	"medal/26": [
		[0, "", "Przyznawany za rozmowy z gośćmi w Space Lounge, którzy mają coś do zaoferowania. Każdy gość liczy się raz, przy pierwszej rozmowie.", false],
	],
	"medal/27": [
		[0, "", "Przyznawany za liczbę skrzydłowych wynajętych w Space Lounge; liczy się każdy pilot w każdej grupie.", false],
	],
	"medal/28": [
		[0, "", "Medal jednostopniowy za zwrócenie przeciwko sobie jednej z czterech wielkich ras przez przesunięcie jednej z dwóch skal reputacji poza 60 w którąkolwiek stronę. Zob. [[guide/combat]].", false],
	],
	"medal/29": [
		[0, "", "Przyznawany za liczbę asteroid zniszczonych Twoją bronią. Asteroidy rozbite podczas wydobycia się nie liczą.", false],
	],
	"medal/3": [
		[0, "", "Przyznawany za wydobycie różnych rodzajów rdzeni. Rdzenie można zdobyć tylko przez przewiercenie wszystkich siedmiu warstw asteroidy klasy A, więc oprócz podróży potrzeba cierpliwości i dobrego lasera górniczego.", false],
	],
	"medal/30": [
		[0, "", "Medal jednostopniowy przyznawany za ukończenie fabuły.", false],
	],
	"medal/31": [
		[0, "", "Przyznawany za największą ilość wolnego miejsca w ładowni w jednej chwili. Wyższe stopnie daje duży kadłub z kompresorami ładunku i pustą ładownią.", false],
	],
	"medal/32": [
		[0, "", "Przyznawany za liczbę ofert odrzuconych w Space Lounge odpowiedzią „No, thanks” (Nie, dziękuję).", false],
	],
	"medal/33": [
		[0, "", "Przyznawany za liczbę próśb o powtórzenie oferty skierowanych do gościa w Space Lounge pytaniem „How was that again?” (Jak to było?).", false],
	],
	"medal/34": [
		[0, "", "Przyznawany za przyjmowanie zleceń na innych stacjach bez wcześniejszego pytania zleceniodawcy, czy będą trudne.", false],
	],
	"medal/35": [
		[0, "", "Przyznawany za przyjmowanie zleceń na innych stacjach bez wcześniejszej prośby, by zleceniodawca pokazał cel na mapie.", false],
	],
	"medal/36": [
		[0, "", "Przyznawany automatycznie, gdy masz wszystkie pozostałe medale, w dowolnym stopniu. Posiadanie ich wszystkich daje też inne nagrody; zob. [[guide/medals]].", false],
	],
	"medal/4": [
		[0, "", "Przyznawany za liczbę zniszczonych statków, liczoną przez całą grę. Liczą się piraci, wrogowie i cele zleceń.", false],
	],
	"medal/5": [
		[0, "", "Przyznawany za tony ładunku dostarczone w zleceniach typu [[job/0]]. Duże ładunki kurierskie liczą się bardziej, więc pomaga pojemna ładownia.", false],
	],
	"medal/6": [
		[0, "", "Przyznawany za łączną liczbę ton rudy wydobytej przez całą grę.", false],
	],
	"medal/7": [
		[0, "", "Przyznawany za liczbę rdzeni wydobytych przez całą grę. Każda asteroida klasy A przewiercona do końca daje jeden.", false],
	],
	"medal/8": [
		[0, "", "Przyznawany za tony alkoholu kupionego w sklepach stacji. Liczy się lokalny trunek każdego układu.", false],
	],
	"medal/9": [
		[0, "", "Przyznawany za posiadanie różnych rodzajów alkoholu. Rodzaje są liczone, gdy kupujesz je od handlarzy w Space Lounge lub zbierasz z wraków promieniem ściągającym.", false],
	],
	"ship/0": [
		[0, "", "[[ship/0]] to najsłabszy kadłub w tabeli statków: pancerz 95, ładownia 25 t, jeden slot broni głównej i jeden dodatkowej oraz trzy sloty wyposażenia. Sterowność 140 jest przyzwoita jak na statek startowy, ale [[ship/32]], najtańszy kadłub w sprzedaży, ma te same sloty broni oraz więcej pancerza, ładowni i zwrotności. Żaden sprzedawca nigdy nie oferuje statku [[ship/0]]; trafia on do gracza wyłącznie przez fabułę.", false],
		[2, "", "[[character/2]] jest właścicielem tego połatanego dawnego statku [[faction/8|pirackiego]] i sadza w nim Keitha ([[character/0]]) na stacji [[station/78]]; statek jest pomalowany w pirackie barwy i wyposażony w laser górniczy oraz [[item/81]], ale nie ma dział. Laser to jego własny prototyp, konstrukcja, którą później sprzedaje jako [[item/90]].", false],
		[10, "", "Po ataku na kryjówkę piratów [[character/2]] oddaje Keithowi ([[character/0]]) statek na stałe, z mocniejszym napędem do podróży między planetami układu, ale zatrzymuje prototypowy laser. Keith lata nim dalej także po dotarciu do przestrzeni [[faction/0|Terran]].", false],
		[18, "", "Na stacji [[station/98]] [[character/1]] każe przemalować kadłub w barwy [[faction/0|Terran]], aby patrole przestały brać go za statek piracki.", false],
	],
	"ship/1": [
		[0, "", "[[ship/1]] to najtańszy kadłub z czterema slotami broni dodatkowej; ma też slot wieżyczki, dwa działa główne i siedem slotów wyposażenia. Pancerz (192) i ładownia (65 t) są solidne. Jego sterowność 106 jest niska, więc najlepiej walczy torpedami i wieżyczką. Za niewiele więcej [[ship/9]] oferuje znacznie więcej pancerza i zwrotności, ale bez wieżyczki i tylko z dwoma slotami broni dodatkowej.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/10": [
		[0, "", "[[ship/10]] to statek, którym w scenie otwierającej lata [[character/0]], uzbrojony w dwa lasery [[item/3]]. Łączy solidny pancerz (200) i ładownię 100 t z czterema slotami broni dodatkowej i sterownością 150, dzięki czemu jest znacznie zwrotniejszy niż [[ship/11]], kadłub najbliższy mu ceną katalogową. Jego słabością jest mała liczba slotów wyposażenia: tylko pięć. Zwykli sprzedawcy nigdy go nie oferują.", false],
		[2, "", "Awaria hipernapędu przenosi Keitha ([[character/0]]) do stacji [[station/78]], gdzie [[character/2]] przejmuje wrak i rozbiera go na części. Statek nigdy nie wraca w ręce Keitha.", false],
	],
	"ship/11": [
		[0, "", "[[ship/11]] to dobrze wyposażony ciężki frachtowiec: ładownia 180 t, pancerz 210, slot wieżyczki, dwa sloty broni głównej i dwa dodatkowej oraz osiem slotów wyposażenia. Jego sterowność 75 jest słaba. W porównaniu z tańszym statkiem [[ship/7]] rezygnuje z 60 t ładowni na rzecz dodatkowego slotu broni dodatkowej i dodatkowego slotu wyposażenia.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/12": [
		[0, "", "[[ship/12]] to myśliwiec zbudowany wokół broni dodatkowej: trzy sloty broni dodatkowej, dwa działa główne, sześć slotów wyposażenia, pancerz 175 i sterowność 132. Jego ładownia 30 t jest bardzo mała, więc słabo nadaje się do handlu i wydobycia. [[ship/30]] kosztuje więcej, a oferuje mniej pancerza i o jeden slot broni dodatkowej mniej.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/16": [
		[0, "", "[[ship/16]] to myśliwiec nastawiony na pociski, z czterema slotami broni dodatkowej, dwoma działami głównymi, dziesięcioma slotami wyposażenia, pancerzem 180 i sterownością 120. Jego ładownia 45 t jest mała. Droższy [[ship/21]] dodaje dwa kolejne działa główne i slot wyposażenia.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/17": [
		[0, "", "[[ship/17]] ma cztery działa główne, dwa sloty broni dodatkowej i dziesięć slotów wyposażenia. Jak na statek w tej cenie jego pancerz (145), ładownia (65 t) i sterowność (95) są słabe, więc polega na wyposażeniu, zwłaszcza osłonach i płytach pancerza. Tańszy [[ship/19]] ma więcej pancerza i ładowni przy jednym slocie wyposażenia mniej.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/18": [
		[0, "", "[[ship/18]] to mały, zwrotny statek (sterowność 145) z ośmioma slotami wyposażenia; żaden tańszy kadłub nie ma ich tylu. Jego pancerz 115 i ładownia 28 t są słabe, a ma tylko dwa sloty broni głównej i dwa dodatkowej. Pasuje pilotowi, który polega na osłonach, maskowaniu i innym wyposażeniu, a nie na pancerzu.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/19": [
		[0, "", "[[ship/19]] to ciężka kanonierka z czterema slotami broni głównej, dwoma dodatkowej, dziewięcioma slotami wyposażenia, pancerzem 225 i ładownią 105 t. Jego sterowność 90 jest niska. To jedyny statek z czterema działami przednimi i ładownią powyżej 100 t.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/2": [
		[0, "", "[[ship/2]] to zwrotny statek uniwersalny wśród tanich kadłubów: pancerz 155, ładownia 52 t, jeden slot broni głównej i dwa dodatkowej, cztery sloty wyposażenia i sterowność 150. Dorównuje statkowi [[ship/35]] we wszystkim poza ładownią, która mieści 12 t więcej. Piloci, którzy chcą drugiego działa, rozglądają się raczej za [[ship/5]] lub [[ship/6]].", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/20": [
		[0, "", "[[ship/20]] to lekki myśliwiec, który mieści sześć slotów wyposażenia w małym, szybkim kadłubie (sterowność 155). Ma dwa działa główne, ale tylko jeden slot broni dodatkowej, pancerz 125 i ładownię 25 t, co dzieli z [[ship/0]] miano najmniejszej w tabeli. Pasuje pilotom, którzy chcą wcześnie mieć osłony, dopalacze i inne wyposażenie i nie planują przewozić ładunków.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/21": [
		[0, "", "[[ship/21]] to najtańszy kadłub z czterema slotami broni głównej i czterema dodatkowej. Do tego ma jedenaście slotów wyposażenia, pancerz 195 i ładownię 70 t. Jego sterowność 100 jest przeciętna. To pełnoprawny statek bojowy o stopień niższy od statku [[ship/29]].", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/22": [
		[0, "", "[[ship/22]] ma największą ładownię spośród statków kosztujących ponad milion kredytów (130 t), a do tego trzy sloty broni głównej i trzy dodatkowej, dziewięć slotów wyposażenia i sterowność 118. Jego pancerz 160 jest niski jak na tę cenę. Pasuje pilotom, którzy handlują i walczą tym samym statkiem.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/23": [
		[0, "", "[[ship/23]] to najtańszy kadłub ze slotem wieżyczki, a jego pancerz 205 jest najwyższy spośród statków poniżej 100 000 kredytów. Dochodzą do tego dwa sloty broni głównej i dwa dodatkowej, pięć slotów wyposażenia, ładownia 55 t i sterowność 128, co czyni go wytrzymałym statkiem uniwersalnym średniej klasy. Jego głównym ograniczeniem jest mała liczba slotów wyposażenia.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/24": [
		[0, "", "[[ship/24]] to uzbrojony statek handlowy: trzy działa główne, dwa sloty broni dodatkowej, wieżyczka, osiem slotów wyposażenia i ładownia 95 t. Jego pancerz 170 jest przeciętny, a sterowność 125 dobra jak na statek, który tyle przewozi. Równie dobrze sprawdza się w handlu, wydobyciu i walce.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/25": [
		[0, "", "[[ship/25]] to nosiciel pocisków: cztery sloty broni dodatkowej, osiem slotów wyposażenia i sterowność 130, ale tylko jedno działo główne. Jego pancerz 124 i ładownia 52 t są słabe jak na tę cenę, więc polega na torpedach i osłonach. [[ship/1]] oferuje tyle samo slotów broni dodatkowej i do tego wieżyczkę za jedną trzecią ceny, choć z mniejszą liczbą slotów wyposażenia.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/26": [
		[0, "", "[[ship/26]] to najtańszy kadłub z siedmioma slotami wyposażenia. Poza tym jest przeciętnym statkiem uniwersalnym: pancerz 152, ładownia 64 t, dwa sloty broni głównej i dwa dodatkowej oraz sterowność 108. Pasuje pilotom, którzy chcą mieć pełny zestaw wyposażenia, zanim będzie ich stać na cięższy statek.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/27": [
		[0, "", "[[ship/27]] to najtańszy kadłub z trzema slotami broni głównej. Łączy je z pancerzem 176, dwoma slotami broni dodatkowej, sześcioma slotami wyposażenia i ładownią 50 t. Jego sterowność 113 jest raczej niska, więc wymienia ciosy, zamiast wymanewrowywać wrogów.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/28": [
		[0, "", "[[ship/28]] to najbardziej kompletny statek uniwersalny w sprzedaży: trzy sloty broni głównej i cztery dodatkowej, wieżyczka, dwanaście slotów wyposażenia i ładownia 110 t. Żaden inny statek do kupienia nie łączy wieżyczki z tak wieloma slotami wyposażenia. Jego pancerz 195 jest dobry, a sterowność 92 niska. [[ship/29]] lepiej walczy, ale przewozi znacznie mniej.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/29": [
		[0, "", "[[ship/29]] to najdroższy statek sprzedawany przez zwykłych sprzedawców i ich najlepszy myśliwiec: cztery sloty broni głównej i cztery dodatkowej, dwanaście slotów wyposażenia, pancerz 240 i sterowność 118. Jego ładownia 75 t jest skromna i nie ma wieżyczki. W walce przewyższa go tylko [[ship/8]].", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/3": [
		[0, "", "[[ship/3]] to zrównoważony wczesny statek uniwersalny: dwa sloty broni głównej i dwa dodatkowej, pięć slotów wyposażenia, pancerz 135 i ładownia 55 t. Jego sterowność 112 jest niska jak na mały statek. Kosztuje mniej więcej tyle co [[ship/6]], który skręca znacznie szybciej, ale ma mniej pancerza, mniejszą ładownię i o jeden slot broni dodatkowej mniej.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/30": [
		[0, "", "[[ship/30]] to przeciętny myśliwiec: pancerz 165, ładownia 45 t, dwa sloty broni głównej i dwa dodatkowej, sześć slotów wyposażenia i sterowność 128. Jak na swoją cenę nie ma szczególnej zalety; tańszy [[ship/12]] ma więcej pancerza i dodatkowy slot broni dodatkowej, a [[ship/23]] dodaje wieżyczkę.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/31": [
		[0, "", "[[ship/31]] to lekki frachtowiec z ładownią 110 t, slotem wieżyczki, dwoma działami głównymi i sześcioma slotami wyposażenia. Jego pancerz (156), pojedynczy slot broni dodatkowej i sterowność 102 są skromne. Konkuruje z tańszym statkiem [[ship/33]], który ma nieco mniejszą ładownię i o jedno działo mniej, ale więcej pancerza i lepszą sterowność.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/32": [
		[0, "", "[[ship/32]] to najtańszy kadłub oferowany przez sprzedawców i zwykle pierwszy zakup. Jest mały i słabo chroniony (pancerz 100, ładownia 30 t, jeden slot broni głównej i jeden dodatkowej, trzy sloty wyposażenia), ale przy sterowności 160 szybciej skręca tylko [[ship/4]]. W porównaniu ze statkiem [[ship/0]] ma nieco więcej pancerza i ładowni oraz lepszą sterowność. [[ship/35]] kosztuje około 8000 kredytów więcej i daje znacznie lepszy pancerz, drugi slot broni dodatkowej i czwarty slot wyposażenia.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/33": [
		[0, "", "[[ship/33]] to najtańszy kadłub z ładownią powyżej 100 t (108 t), a do tego ma slot wieżyczki, pancerz 176 i sześć slotów wyposażenia. Z jednym działem głównym i sterownością 112 jest raczej statkiem handlowym zdolnym do obrony niż myśliwcem. Bliskim rywalem jest [[ship/31]] z drugim działem i nieco większą ładownią, ale jest słabszy i wolniejszy.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/34": [
		[0, "", "[[ship/34]] to kanonierka z czterema slotami broni głównej, jednym dodatkowej, sześcioma slotami wyposażenia, ładownią 60 t i sterownością 130. W porównaniu z tańszym statkiem [[ship/4]] rezygnuje z pancerza (135 wobec 170) i zwrotności na rzecz większej ładowni i dodatkowego slotu wyposażenia.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/35": [
		[0, "", "[[ship/35]] to lekki myśliwiec z dołu cennika. Za swoją cenę oferuje dobry pancerz (155), jeden slot broni głównej i dwa dodatkowej, cztery sloty wyposażenia i szybką sterowność 150, ale tylko 40 t ładowni. [[ship/2]] to niemal ten sam statek z 12 t więcej ładowni za kilka tysięcy kredytów więcej, a [[ship/5]] poświęca zwrotność na rzecz większego pancerza, ładowni i drugiego działa.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/36": [
		[0, "", "[[ship/36]] to największy frachtowiec w grze, z ładownią 350 t. Nie ma żadnego slotu broni głównej i do obrony musi polegać na czterech slotach broni dodatkowej i wieżyczce. Siedem slotów wyposażenia i pancerz 200 to dobre wartości, ale jego sterowność 45 jest najniższa w tabeli. [[ship/7]] przewozi mniej, ale zachowuje dwa działa przednie i lepiej skręca.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/4": [
		[0, "", "[[ship/4]] to najtańszy kadłub z czterema slotami broni głównej, a przy sterowności 162 jest najzwrotniejszym statkiem w grze. Jego pancerz 170 jest dobry jak na tę cenę. Ceną jest ładownia 38 t, pojedynczy slot broni dodatkowej i pięć slotów wyposażenia, więc to czysty myśliwiec do walki kołowej. [[ship/34]] również ma cztery działa, więcej ładowni i slotów wyposażenia, ale mniej pancerza i zwrotności.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/5": [
		[0, "", "[[ship/5]] to najtańszy kadłub z dwoma slotami broni głównej, a jego pancerz 170 jest wysoki jak na tę cenę. Ładownia 60 t sprawia, że przydaje się też do wczesnego handlu i wydobycia. Wadami są pojedynczy slot broni dodatkowej, tylko cztery sloty wyposażenia i ociężała sterowność 115. Piloci, którzy cenią zwrotność bardziej niż pancerz, wybierają w podobnej cenie [[ship/2]] lub [[ship/35]].", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/6": [
		[0, "", "[[ship/6]] to lekki, szybki myśliwiec z dwoma slotami broni głównej, jednym dodatkowej, pięcioma slotami wyposażenia i sterownością 148. Jego pancerz 105 jest bardzo cienki; mniej mają tylko [[ship/0]] i [[ship/32]], więc polega on na szybkości, a nie na wytrzymałości. W niemal tej samej cenie [[ship/3]] oferuje więcej pancerza, więcej ładowni i drugi slot broni dodatkowej kosztem sterowności.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/7": [
		[0, "", "[[ship/7]] to ciężki frachtowiec z ładownią 240 t, pancerzem 220, slotem wieżyczki, dwoma działami głównymi, jednym slotem broni dodatkowej i siedmioma slotami wyposażenia. Przy sterowności 65 skręca powoli. W porównaniu ze statkiem [[ship/36]] rezygnuje ze 110 t ładowni na rzecz dział przednich i lepszej sterowności; droższy [[ship/11]] dodaje slot wyposażenia i drugi slot broni dodatkowej.", false],
		[0, "", "Może go mieć w ofercie każdy sprzedawca poza układami [[faction/1|Vossk]].", false],
	],
	"ship/8": [
		[0, "", "[[ship/8]] to odrestaurowany myśliwiec [[faction/9|Voidów]] i najsilniejszy statek w grze. Jego pancerz 450 jest niemal dwa razy większy niż u jakiegokolwiek innego kadłuba, ma cztery sloty broni głównej i cztery dodatkowej oraz piętnaście slotów wyposażenia, a jego sterowność 155 należy do najlepszych. Jedyną słabością jest ładownia 30 t. Jego cena katalogowa, ponad osiem milionów kredytów, jest niemal dwukrotnie wyższa niż statku [[ship/29]].", false],
		[0, "", "Zwykli sprzedawcy go nie sprzedają. Jest oferowany wyłącznie na stacji [[station/10]] jako prototyp, gdy gracz ma wszystkie medale w złocie (zob. [[guide/medals]]).", false],
	],
	"ship/9": [
		[0, "", "[[ship/9]] to jedyny statek, który sprzedają sprzedawcy [[faction/1|Vossk]], i nie sprzedają oni nic innego. Jego pancerz 250 jest najwyższy ze wszystkich kadłubów poza statkiem [[ship/8]], a łączy go z szybką sterownością 152, dwoma slotami broni głównej i dwoma dodatkowej, siedmioma slotami wyposażenia i ładownią 65 t. W swojej cenie to najwytrzymalszy dostępny myśliwiec, choć brakuje mu wieżyczki i dodatkowych slotów, które ma [[ship/1]].", false],
		[36, "", "[[character/7]] wyjaśnia, że statkami [[faction/1|Vossk]] latają zwykle tylko przedstawiciele ich rasy; ten statek jest wyjątkiem, konstrukcją przystosowaną tak, by można ją było sprzedawać innym rasom.", false],
	],
	"station/0": [
		[0, "", "Przy stacji [[station/0]] stoi brama skokowa układu [[system/0]]. Okres oczekiwania ([[step/13]]) jest przypisany do tej stacji, ale ten krok zalicza się, wykonując zlecenia ze Space Lounge w dowolnym miejscu, i nic się tu nie dzieje.", false],
	],
	"station/10": [
		[0, "", "[[station/10]] to jedyna stacja układu [[system/6]] i przy niej stoi jego brama skokowa. Zlecenia nigdy nie kierują Cię tutaj. W Space Lounge agent [[agent/3]] sprzedaje schemat, a gdy wszystkie medale są złote, stacja oferuje prototyp statku [[ship/8]].", false],
		[23, "", "Stacja jest tajną bazą badawczą Deep Science, którą kieruje [[character/6]]. [[character/0]] przybywa tu z naukowcem [[character/5]] ([[step/23]]) i wraca jeszcze kilka razy: aby zaplanować wyprawę do Voidów, spotkać się z naukowcem [[character/20]] i dostarczyć mu kryształy.", false],
	],
	"station/18": [
		[0, "", "[[station/18]] to skromna stacja Vossk w układzie [[system/3]]. W jej Space Lounge agent [[agent/12]] sprzedaje współrzędne układu [[system/0]].", false],
	],
	"station/20": [
		[0, "", "Przy stacji [[station/20]] stoi brama skokowa układu [[system/4]]. W jej Space Lounge midoriański agent [[agent/2]] sprzedaje schemat broni.", false],
	],
	"station/22": [
		[0, "", "[[station/22]] to najbardziej zaawansowana stacja w układzie [[system/4]].", false],
		[38, "", "W pobliżu stacji zostaje zauważony konwój z nivelijskimi materiałami wybuchowymi pod eskortą midoriańskich myśliwców ([[step/38]]). [[character/0]] musi przegonić eskortę, nie niszcząc konwoju.", false],
	],
	"station/26": [
		[0, "", "[[station/26]] to stacja Vossk o najwyższym poziomie technologii w układzie [[system/5]]. W jej Space Lounge boboliański agent [[agent/13]] sprzedaje współrzędne układu [[system/1]].", false],
	],
	"station/27": [
		[36, "", "W pobliżu planety [[station/27]] dowódca [[character/7]] i pilot [[character/0]] atakują kryjówkę piratów ([[step/36]]); wygrywa ten, kto zniszczy więcej piratów.", false],
		[37, "", "[[character/0]] wygrywa i zdobywa prawo do eskortowania frachtowca Vossk. Stąd składa meldunek, który odbiera [[character/1]].", false],
	],
	"station/29": [
		[35, "", "[[station/29]] to stacja dowódcy Vossk, [[character/7]], który zgodził się dostarczyć frachtowiec K'Sarr do ataku na Voidy. [[character/0]] spotyka go tutaj ([[step/35]]).", false],
		[36, "", "[[character/7]] nie pozwala nikomu poza Vossk pilotować frachtowca i wyzywa Keitha ([[character/0]]), by ten dowiódł, że nadaje się na pilota eskorty.", false],
	],
	"station/3": [
		[0, "", "[[station/3]] to zaawansowana technologicznie stacja Nivelian w ukrytym układzie [[system/0]]. W jej Space Lounge przebywa agent [[agent/0]], który sprzedaje schemat broni.", false],
	],
	"station/30": [
		[34, "", "Na stacji [[station/30]] czeka [[character/1]] z planem przeciwko statkowi-matce Voidów ([[step/34]]).", false],
		[35, "", "Plan polega na wprowadzeniu w statek-matkę ciężkiego frachtowca pełnego nivelijskich ładunków jądrowych.", false],
		[39, "", "Odzyskane materiały wybuchowe trafiają tutaj i zostają załadowane na frachtowiec Vossk. [[character/1]] objaśnia ostateczną operację ([[step/39]]).", false],
	],
	"station/43": [
		[0, "", "[[station/43]] to mała stacja Terran w układzie [[system/8]]. W jej Space Lounge agent [[agent/4]] sprzedaje tani schemat rakiety.", false],
	],
	"station/48": [
		[24, "", "W pobliżu stacji [[station/48]] widziano statki Voidów. [[character/0]] przywozi tu dr Paolini ([[character/6]]), by mogła je obserwować, i zbiera szczątki promieniem ściągającym ([[step/24]]).", false],
		[25, "", "Pod koniec zbierania szczątków tunel czasoprzestrzenny wciąga statek, którym leci [[character/0]], z naukowczynią [[character/6]] na pokładzie.", false],
		[27, "", "Gdy wracają przez inny tunel, ścigają ich myśliwce Voidów, a [[character/0]] musi je tu zniszczyć, zanim wróci na stację [[station/10]].", false],
	],
	"station/54": [
		[0, "", "[[station/54]] to stacja Vossk o najwyższym poziomie technologii w układzie [[system/10]], do którego można dotrzeć tylko napędem skokowym. W jej Space Lounge agent Vossk [[agent/5]] sprzedaje schemat pocisku.", false],
	],
	"station/55": [
		[0, "", "Przy stacji [[station/55]] stoi brama skokowa układu [[system/11]].", false],
		[19, "", "W pobliżu stacji odnajdują się piraci, którzy dla okupu przetrzymują naukowca [[character/5]]. Deep Science zostawia w hangarze stacji bomby EMP dla Keitha ([[character/0]]).", false],
		[22, "", "Po akcji ratunkowej [[character/0]] spotyka na stacji uwolnionego oficera i otrzymuje współrzędne układu [[system/6]].", false],
	],
	"station/56": [
		[18, "", "[[station/56]] to miejsce spotkania, gdzie [[character/0]] ma zabrać oficera Deep Science ([[step/18]]).", false],
		[19, "", "Oficer nie przybywa. Zamiast tego przychodzi wiadomość, w której [[character/1]] donosi, że porwali go piraci.", false],
	],
	"station/59": [
		[0, "", "[[station/59]] to mała stacja w układzie Vossk [[system/20]]. W jej Space Lounge przebywa Terranin, agent [[agent/10]], który sprzedaje schemat urządzenia maskującego.", false],
	],
	"station/61": [
		[0, "", "[[station/61]] to jedna z zaledwie dwóch stacji w układzie [[system/12]]. W jej Space Lounge agent [[agent/6]] z rasy Multipodów sprzedaje schemat broni jądrowej.", false],
	],
	"station/65": [
		[0, "", "Przy stacji [[station/65]] stoi brama skokowa układu [[system/13]]. W jej Space Lounge agent [[agent/14]] z rasy Cyborgów sprzedaje współrzędne układu [[system/10]].", false],
	],
	"station/72": [
		[0, "", "[[station/72]] to mała stacja Terran w bezpiecznym układzie [[system/14]]. W jej Space Lounge agent [[agent/7]] sprzedaje schemat osłony.", false],
	],
	"station/76": [
		[11, "", "[[station/76]] to stacja w układzie [[system/15]], która przestała odpowiadać na wezwania. Kapitan [[character/3]] wysyła Keitha ([[character/0]]), by sprawdził dlaczego ([[step/11]]).", false],
		[12, "", "Stacja jest nienaruszona. Jej załoga po prostu nie jest w stanie pracować z powodu ładunku neuroalg dostarczonego przez dilera [[character/4]], starego znajomego Keitha ([[character/0]]).", false],
	],
	"station/78": [
		[0, "", "[[station/78]] to mała stacja górnicza nivelijskiego handlarza rudą [[character/2]] w układzie [[system/15]]. Na jej orbicie zaczyna się fabuła.", false],
		[1, "", "Uszkodzony statek, którym leciał [[character/0]], dryfuje tu na autopilocie, a [[character/2]] przejmuje go razem z pilotem.", false],
		[2, "", "[[character/2]] rozbiera wrak i każe Keithowi ([[character/0]]) wydobywać rudę z pobliskich asteroid statkiem [[ship/0]].", false],
		[8, "", "Po ucieczce przed napadem piratów [[character/0]] montuje swoją pierwszą broń i pomaga handlarzowi [[character/2]] zniszczyć kryjówkę piratów w pobliżu stacji.", false],
		[10, "", "[[character/2]] oddaje mu potem statek i wysyła go dalej, na stację [[station/79]].", false],
		[0, "", "Później w grze [[character/2]] sprzedaje w Space Lounge stacji schemat swojego wiertła górniczego.", false],
	],
	"station/79": [
		[0, "", "[[station/79]] to stacja w układzie [[system/15]] i siedziba jego komendanta, kapitana [[character/3]].", false],
		[10, "", "[[character/2]] wysyła tu Keitha ([[character/0]]) na spotkanie z kapitanem [[character/3]], człowiekiem, który może mu pomóc dostać się do przestrzeni Terran ([[step/9]]).", false],
		[11, "", "[[character/3]] opowiada o [[faction/3|Konfederacji Mido]] i w zamian za pomoc prosi Keitha o sprawdzenie stacji [[station/76]].", false],
		[13, "", "Po raporcie ze stacji [[station/76]] [[character/3]] obiecuje skontaktować Keitha z terrańskim konwojem, który ma przybyć na stację.", false],
		[15, "", "Gdy konwój przybywa ([[step/14]]), bierze Keitha ([[character/0]]) za pirata, unieszkodliwia jego statek i zabiera go na pokład.", false],
	],
	"station/8": [
		[0, "", "[[station/8]] to stacja Terran w ukrytym układzie [[system/1]]. W jej Space Lounge nivelijski agent [[agent/1]] sprzedaje schemat.", false],
	],
	"station/84": [
		[0, "", "[[station/84]] to stacja Terran w układzie [[system/16]]. W jej Space Lounge agent Vossk [[agent/8]] sprzedaje schemat pancerza Vossk.", false],
	],
	"station/88": [
		[0, "", "[[station/88]] to mała stacja Nivelian w układzie [[system/17]]. W jej Space Lounge agent Vossk [[agent/15]] sprzedaje współrzędne układu [[system/21]].", false],
	],
	"station/90": [
		[0, "", "Przy stacji [[station/90]] stoi brama skokowa układu [[system/18]]. W jej Space Lounge agent [[agent/9]] sprzedaje schemat kompresora ładunku.", false],
	],
	"station/91": [
		[28, "", "W pobliżu stacji [[station/91]] zgłoszono aktywność Voidów ([[step/28]]). [[character/0]] przebija się tu do tunelu czasoprzestrzennego, by dostarczyć sondę do statku-matki Voidów.", false],
		[31, "", "Po powrocie z sektora Voidów [[character/0]] odbiera tu wezwanie, w którym [[character/1]] zaprasza go na stację [[station/98]].", false],
	],
	"station/98": [
		[15, "", "[[station/98]] to stacja Terran w układzie [[system/19]]. Krążownik, który aresztował Keitha ([[character/0]]), przywozi go tutaj, a dowodzi tu jego stary przyjaciel, [[character/1]].", false],
		[16, "", "Podczas ich rozmowy stację atakują myśliwce Voidów, a [[character/0]] pomaga je odeprzeć.", false],
		[18, "", "[[character/1]] opowiada mu o Voidach i werbuje go dla Deep Science.", false],
		[32, "", "[[character/1]] instaluje na statku Keitha ([[character/0]]) system wczesnego ostrzegania i opowiada mu o naukowcu [[character/20]] ([[step/31]]).", false],
		[44, "", "Po zwycięstwie [[character/0]] i [[character/1]] świętują na stacji, a dołącza do nich [[character/6]].", false],
		[45, "", "Następnego ranka [[character/6]] znika, zostawiając liścik i ostatnią wypłatę od Deep Science.", false],
	],
	"step/0": [
		[0, "", "[[character/0]] ściga bandę [[faction/8|piratów]] przez pas asteroid, aby zgarnąć wyznaczoną za nich nagrodę. Musisz odnaleźć i zniszczyć każdy piracki statek.", false],
		[1, "", "Po rozprawieniu się z piratami Keith obiera kurs na Eden Prime, gdzie admirał Smith chce się z nim spotkać w sprawie specjalnego zadania. Gdy hipernapęd rusza, pożegnalny strzał trafia jego statek. Napęd zawodzi, podtrzymywanie życia zostaje poważnie uszkodzone, a autopilot niesie nieprzytomnego pilota ku najbliższej stacji, [[station/78]].", false],
	],
	"step/1": [
		[1, "", "Autopilot doprowadził uszkodzony statek Keitha na orbitę stacji [[station/78]], z nieprzytomnym pilotem na pokładzie.", false],
		[2, "", "Keith budzi się na małej stacji górniczej, którą prowadzi [[character/2]], handlarz rudą z frakcji [[faction/2]]. Gunant rozebrał statek na części i rości sobie do niego prawo jako do znaleziska. Śmieje się z pomysłu dotarcia na Eden Prime, leżącą na drugim końcu galaktyki, i dziwi się, że Keith nigdy nie słyszał o Voidach, wrogich istotach, które pojawiają się teraz nawet w układzie [[system/15]].", false],
		[2, "", "Keith nie ma pieniędzy ani statku, więc musi pracować dla Gunanta, wydobywając rudę nieuzbrojoną jednostką.", false],
	],
	"step/10": [
		[10, "", "Keith leci na stację [[station/79]], aby spotkać się z kapitanem [[character/3]].", false],
		[11, "", "Norris wyjaśnia, że układ [[system/15]] leży w niedawno odkrytym sektorze. Terrańscy i nivelijscy wygnańcy zasiedlili go w czasie nivelijskiej wojny domowej i założyli niezależną konfederację. Terranie ją uznają, ale Nivelianie wciąż roszczą sobie prawa do układu, więc na jego obrzeżach trwają walki.", false],
		[11, "", "Norris proponuje, że skontaktuje Keitha z Terrańską Flotą Kosmiczną w zamian za przysługę: urwał się kontakt ze stacją [[station/76]] i doświadczony pilot musi sprawdzić dlaczego.", false],
	],
	"step/11": [
		[11, "", "Keith leci na stację [[station/76]], aby zbadać przyczynę jej milczenia. Stacja wygląda na nienaruszoną, bez śladów walki, więc dokuje.", false],
		[12, "", "W środku Keith natyka się na dilera [[character/4]], osławionego handlarza, którego znał dawno temu. Mkkt przywiózł ładunek neuroalg i cała załoga jest zbyt odurzona, by obsługiwać łączność. Keith odlatuje najszybciej, jak może.", false],
	],
	"step/12": [
		[12, "", "Keith wraca na stację [[station/79]], aby złożyć raport.", false],
		[13, "", "Norris jest zbulwersowany i obiecuje zająć się dilerem. Terrański konwój wojskowy zmierza do Kernstal i da Keithowi okazję do skontaktowania się z flotą. Do jego przybycia Norris radzi Keithowi podjąć płatną pracę w Space Lounge (zob. [[guide/lounge]]).", false],
	],
	"step/13": [
		[13, "", "Czekając na konwój, Keith musi wykonać dwa zlecenia ze Space Lounge (zob. [[guide/jobs]]).", false],
		[14, "", "Norris melduje, że terrański konwój wszedł do układu i zmierza ku stacji [[station/79]]. Keith wyrusza mu na spotkanie.", false],
	],
	"step/14": [
		[14, "", "W pobliżu stacji [[station/79]] Keith znajduje terrański konwój i kilku piratów. Rusza, by przegonić piratów.", false],
		[15, "", "W swoim dawnym pirackim statku Keith zostaje wzięty za jednego z napastników. Konwój unieszkodliwia jego statek bronią EMP i aresztuje go. Keith trafia na pokład terrańskiego krążownika lecącego na stację [[station/98]] w przestrzeni Terran.", false],
	],
	"step/15": [
		[15, "", "Keith przybywa na stację [[station/98]] jako więzień konwoju.", false],
		[16, "", "Dowodzącym oficerem okazuje się [[character/1]], stary przyjaciel Keitha, obecnie szef Międzygwiezdnej Agencji Bezpieczeństwa. Przeprasza za pomyłkę. Spotkanie zostaje przerwane, gdy na orbicie pojawiają się myśliwce Voidów i stacja ogłasza alarm.", false],
	],
	"step/16": [
		[16, "", "Brent prosi Keitha o pomoc w odparciu statków [[faction/9|Voidów]] atakujących stację [[station/98]] (zob. [[world/voids]]).", false],
		[17, "", "Voidy nadają komunikat o pokojowych zamiarach, a mimo to atakują. Keith je odpiera, a Brent obiecuje opowiedzieć mu przy kieliszku wina wszystko, co wie.", false],
	],
	"step/17": [
		[17, "", "Keith dokuje na stacji [[station/98]], aby usłyszeć, co Brent wie o Voidach.", false],
		[18, "", "Voidy pojawiają się od kilku tygodni. Przybywają przez coś w rodzaju tuneli czasoprzestrzennych, atakują wszystko, co napotkają, i najwyraźniej szukają rudy; najeżdżają nawet układy frakcji [[faction/1]]. Brent przewodniczy sztabowi kryzysowemu, a jego naukowcy zbierają się w tajnej stacji badawczej prowadzonej przez Deep Science. Prosi Keitha, by latał dla nich.", false],
		[18, "", "Układu, w którym leży stacja, nie ma na standardowych mapach gwiazd, więc Keith musi spotkać się z porucznikiem Thomasem Boyle'em ([[character/5]]) na stacji [[station/56]] w układzie [[system/11]], aby zdobyć współrzędne. Brent przyznaje też, że statek Keitha nie jest nowy: został jedynie przemalowany, aby uniknąć kolejnych pomyłek.", false],
	],
	"step/18": [
		[18, "", "Keith leci na stację [[station/56]] na spotkanie z Boyle'em.", false],
		[19, "", "Boyle nie dotarł na miejsce. Brent donosi, że piraci porwali go w pobliżu stacji [[station/55]] i żądają okupu w wysokości pięciu milionów kredytów. Brent jest gotów zapłacić, ale Keith spodziewa się, że porywacze zabiją Boyle'a po otrzymaniu pieniędzy, i zamiast tego kieruje się do Kappy.", false],
	],
	"step/19": [
		[19, "", "Keith leci na stację [[station/55]], aby odszukać porywaczy.", false],
		[20, "", "Skanery Kappy namierzają statek porywaczy. Brent kazał zostawić w hangarze stacji bomby EMP, aby Keith mógł unieszkodliwić statek, podczas gdy porywacze będą myśleć, że dostarcza okup.", false],
	],
	"step/2": [
		[2, "", "Gunant daje Keithowi stary, wielokrotnie łatany statek [[ship/0]], dawną jednostkę piracką z laserem górniczym i bez uzbrojenia. Keith musi wydobyć co najmniej dziesięć ton rudy z asteroid w pobliżu stacji [[station/78]] (zob. [[guide/mining]]).", false],
		[3, "", "Gdy ruda jest na pokładzie, Gunant każe mu zadokować, aby sprawdzić ładunek. Bez broni Keith nie ma wyboru i musi się podporządkować.", false],
	],
	"step/20": [
		[20, "", "Keith musi zadokować na stacji [[station/55]] i zamontować bomby EMP na swoim statku.", false],
		[21, "", "Z zamontowanymi bombami Keith natychmiast wyrusza.", false],
	],
	"step/21": [
		[21, "", "Punkt nawigacyjny oznacza statek porywaczy, który może nie być sam. Keith musi go unieszkodliwić bombą EMP, a nie zniszczyć, i rozprawić się z ewentualną eskortą.", false],
		[22, "", "Porywacze sądzą, że nadszedł okup, dopóki bomba nie wyłączy ich systemów. Brent wysyła oddział, by odbić Boyle'a.", false],
	],
	"step/22": [
		[22, "", "Keith dokuje na stacji [[station/55]], aby spotkać się z uratowanym naukowcem.", false],
		[23, "", "Boyle mu dziękuje. Jego własny statek przepadł, więc Keith proponuje, że go podwiezie, a Boyle przesyła do komputera nawigacyjnego Keitha współrzędne układu [[system/6]], w którym leży stacja badawcza.", false],
	],
	"step/23": [
		[23, "", "Keith przywozi Boyle'a na stację [[station/10]] w układzie [[system/6]], gdzie czeka na nich dr Paolini.", false],
		[24, "", "Keith poznaje dr Carlę Paolini ([[character/6]]), która kieruje projektem Deep Science. Chce ona poznać technologię Voidów, zaczynając od szczątków ich statków. Deep Science płaci Keithowi 20 000 kredytów na wyposażenie statku, a promień ściągający jest niezbędny.", false],
		[24, "", "Carla upiera się, że poleci z nim na stację [[station/48]] w układzie [[system/9]], gdzie niedawno widziano Voidy. Keith protestuje, ale ustępuje.", false],
	],
	"step/24": [
		[24, "", "Przy stacji [[station/48]] Carla chce zobaczyć Voidy z jak najbliższej odległości. Voidy oznajmiają, że przybywają z przyszłości i są wszystkim, co zostało z cywilizacji galaktyki. Keith musi z nimi walczyć i zbierać szczątki ich statków promieniem ściągającym.", false],
		[25, "", "Gdy na pokładzie jest już dość szczątków, Carla wzywa do powrotu, lecz nagle coś chwyta statek.", false],
	],
	"step/25": [
		[25, "", "Keith i Carla odzyskują przytomność daleko od stacji [[station/48]], w obszarze kosmosu, którego żadne z nich nie zna.", false],
		[26, "", "W pobliżu znajduje się gigantyczny statek-matka Voidów, który wypuszcza myśliwce. Keith dochodzi do wniosku, że przeszli przez tunel czasoprzestrzenny do macierzystego sektora Voidów. Ten tunel zniknął, ale takie przejścia najwyraźniej zapadają się i pojawiają gdzie indziej, więc Keith musi dotrzeć do innego, aby wrócić.", false],
	],
	"step/26": [
		[26, "", "Tunel przenosi ich z powrotem do stacji [[station/48]], ale ruszyły za nimi myśliwce Voidów. Keith musi je zniszczyć, aby nie mogły pójść jego śladem do stacji [[station/10]].", false],
		[27, "", "Po pozbyciu się pościgu oboje wracają do Thynome, bardzo potrzebując odpoczynku.", false],
	],
	"step/27": [
		[27, "", "Keith dokuje na stacji [[station/10]].", false],
		[28, "", "Dwa dni później Carla prosi go, by tam wrócił. Jej zespół zbudował sondę, która wystrzelona w statek-matkę zbada go i prześle wyniki na statek Keitha. Carla zostaje, by badać szczątki, i wysyła go do układu [[system/18]], gdzie właśnie zgłoszono Voidy, aby znalazł kolejny tunel.", false],
		[28, "", "Keith zgadza się pod jednym warunkiem: jeśli wróci żywy, Carla jest mu winna randkę. Ona przystaje na to.", false],
	],
	"step/28": [
		[28, "", "W pobliżu stacji [[station/91]] przylatują myśliwce Voidów, a Keith musi dotrzeć do tunelu, zanim ten się zapadnie. Voidy ostrzegają, że ich zniszczenie zniszczy jego własną przyszłość.", false],
		[29, "", "Keith dociera do tunelu i przechodzi przez niego do przestrzeni Voidów.", false],
	],
	"step/29": [
		[29, "", "W pobliżu statku-matki Keith musi go namierzyć, co wystrzeliwuje sondę, a potem wytrwać, dopóki sonda nie zakończy analizy.", false],
		[30, "", "W trakcie oczekiwania Voidy znów nadają komunikat: muszą znaleźć sposób, by porozmawiać, zanim ludzie zniszczą je, a wraz z nimi własną przyszłość. Keith wytrzymuje do końca transmisji danych i odlatuje.", false],
	],
	"step/3": [
		[3, "", "Keith dokuje na stacji [[station/78]], aby oddać pierwszy ładunek rudy.", false],
		[4, "", "Gunant jest dość zadowolony, ale znów wysyła Keitha na wydobycie, tym razem aby zapełnił całą ładownię. Żartuje, że jeśli Keith będzie się dobrze sprawował, może kiedyś zatrzyma statek.", false],
	],
	"step/30": [
		[30, "", "Po powrocie przez tunel Keith czeka w pobliżu stacji [[station/91]].", false],
		[31, "", "Dzwoni Brent i prosi go, by przed powrotem do Thynome zatrzymał się na stacji [[station/98]] w układzie [[system/19]], obiecując niespodziankę. Stamtąd można też wysłać dane z sondy do Carli.", false],
	],
	"step/31": [
		[31, "", "Keith dokuje na stacji [[station/98]], aby zobaczyć się z Brentem.", false],
		[32, "", "Zespół Brenta opracował system wczesnego ostrzegania dla mapy gwiazd. Pokazuje on, gdzie Voidy zaraz otworzą tunel, a komputer nawigacyjny Keitha zostaje zmodyfikowany, by go odbierać. Brent chce, by Keith latał w takie miejsca i wspierał miejscowe siły, i płaci mu 30 000 kredytów.", false],
		[32, "", "Brent dodaje, że [[faction/7|przedstawiciel rasy Grey]] o imieniu [[character/20]], który pracuje dla Deep Science, chce się spotkać z Keithem.", false],
	],
	"step/32": [
		[32, "", "Keith wraca na stację [[station/10]], aby spotkać się z naukowcem [[character/20]].", false],
		[33, "", "Khador zbadał szczątki Voidów. Uważa, że tajemnica ich tuneli kryje się w strukturze pewnych kryształów, które występują tylko w sektorze Voidów. Pracuje nad napędem, który przenosiłby statek natychmiast w dowolny punkt przestrzeni, i prosi Keitha o dostarczenie co najmniej 50 takich kryształów.", false],
		[33, "", "Keith musi jeszcze raz wejść do tunelu, tym razem odnajdując go za pomocą systemu wczesnego ostrzegania Brenta.", false],
	],
	"step/33": [
		[33, "", "Keith musi zebrać w sektorze Voidów 50 sztuk towaru [[item/164]] i dostarczyć je na stację [[station/10]].", false],
		[34, "", "Khador jest zachwycony i daje Keithowi kopię swojego schematu przedmiotu [[item/85]], aby Keith mógł zbudować go dla siebie (zob. [[guide/blueprints]]). Taki napęd pozwala dotrzeć nawet do macierzystego sektora Voidów.", false],
		[34, "", "Pojawia się Carla, zbyt zajęta, by pójść na randkę. Mówi Keithowi, że wspólnie z Brentem obmyślili plan, i wysyła go do Brenta na stację [[station/30]] w układzie [[system/2]].", false],
	],
	"step/34": [
		[34, "", "Keith leci na stację [[station/30]], aby poznać plan Brenta.", false],
		[35, "", "Dane z sondy pokazują, że statek-matka jest źródłem tuneli. Jak dotąd żadna broń go nie uszkodziła, więc plan zakłada wprowadzenie w samo jego serce wytrzymałego frachtowca wyładowanego nivelijskimi ładunkami jądrowymi.", false],
		[35, "", "Do tego zadania najlepiej nadaje się frachtowiec Vossk typu K'Sarr. Brent załatwił, że w ramach tajnej wymiany jeńców otrzyma go od dowódcy [[character/7]], komendanta stacji [[station/29]] w układzie [[system/5]]. Errkt nalega, by osobiście poznać pilota.", false],
	],
	"step/35": [
		[35, "", "Keith leci na terytorium frakcji [[faction/1]], aby spotkać się z dowódcą [[character/7]] na stacji [[station/29]].", false],
		[36, "", "Errkt, który zapoznał się z przebiegiem służby Keitha, uważa, że tylko Vossk potrafi należycie pilotować statek Vossk. Ponieważ misja nie może się nie powieść, sam poprowadzi frachtowiec. Najpierw jednak Keith musi udowodnić swoje umiejętności pilota myśliwca w pobliżu planety [[station/27]].", false],
	],
	"step/36": [
		[36, "", "Errkt proponuje zawody przy kryjówce piratów w pobliżu planety [[station/27]]: wygrywa ten, kto zestrzeli więcej piratów.", false],
		[37, "", "Keith wygrywa. Errkt uznaje go za zdolnego pilota i przyznaje mu zaszczyt eskortowania frachtowca, który sam przyprowadzi w umówione miejsce. Keith dzwoni do Brenta z meldunkiem.", false],
	],
	"step/37": [
		[37, "", "Keith kontaktuje się z Brentem z planety [[station/27]], aby zdać relację z rozmów z Errktem.", false],
		[38, "", "Imperium Vossk potwierdziło swoje wsparcie, a Brent akceptuje Errkta jako pilota. Pojawił się jednak nowy problem: statki [[faction/3|Konfederacji Mido]], będącej w stanie wojny z Nivelianami, przejęły konwój z nivelijskimi materiałami wybuchowymi. Zauważono go w układzie [[system/4]] w pobliżu stacji [[station/22]], a Keith zgadza się go przechwycić.", false],
	],
	"step/38": [
		[38, "", "W pobliżu stacji [[station/22]] Keith znajduje skradziony konwój z eskortą myśliwców Mido. Musi zniszczyć eskortę, nie uszkadzając statków konwoju.", false],
		[39, "", "Gdy konwój znów jest pod kontrolą, Brent przekazuje go miejscowym siłom bezpieczeństwa na drogę do stacji [[station/30]] i prosi Keitha, by również tam wrócił.", false],
	],
	"step/39": [
		[39, "", "Keith dokuje na stacji [[station/30]] na ostatnią odprawę.", false],
		[40, "", "Materiały wybuchowe zostają załadowane na frachtowiec Vossk, a Errkt pozostaje jego pilotem. Gdy Voidy znów się pojawią, Keith i Errkt tam polecą. Errkt skieruje się do pierwszego tunelu, a Keith będzie go osłaniał i podąży za nim. Brent poprosi najbliższą stację o posiłki.", false],
		[40, "", "Errkt ma się katapultować w kapsule ratunkowej tuż przed uderzeniem. Keith musi wrócić przez tunel, zanim statek-matka zostanie zniszczony, bo inaczej nie będzie drogi do domu.", false],
	],
	"step/4": [
		[4, "", "Keith wraca do asteroid, by wydobywać rudę, aż ładownia będzie pełna.", false],
		[5, "", "Podczas wydobycia zbliża się piracki statek. Keith jest nieuzbrojony, więc dostaje polecenie, by uciekać na stację i unikać ostrzału.", false],
	],
	"step/40": [
		[40, "", "Korzystając z systemu wczesnego ostrzegania, Keith leci na orbitę atakowaną przez Voidy. Errkt przybywa z frachtowcem i kieruje się do pierwszego tunelu, a porucznik [[character/8]] dołącza ze swoim oddziałem. Keith musi chronić frachtowiec, dopóki ten nie przejdzie przez tunel.", false],
		[41, "", "Pancerz frachtowca jest mocno uszkodzony, ale Errkt dociera do tunelu, a Keith podąża za nim.", false],
	],
	"step/41": [
		[41, "", "Oddział Baffoura nie zdążył przejść przez tunel, więc Keith i Errkt są sami. Frachtowiec jest na kursie kolizyjnym ze statkiem-matką, a Keith musi oczyścić mu drogę z myśliwców Voidów.", false],
		[42, "", "Gdy frachtowiec się zbliża, Errkt melduje, że jego kapsuła ratunkowa została trafiona. Postanawia zostać na frachtowcu i każe Keithowi odlecieć, póki jest jeszcze czas. Keith żegna się i zawraca.", false],
	],
	"step/42": [
		[42, "", "Keith musi się oddalić, gdy frachtowiec Errkta zmierza do celu.", false],
		[43, "", "Brent melduje, że tunele w całym sektorze się zapadły: plan się powiódł. Keith mówi mu, że Errkt nie przeżył, a Brent obiecuje oddać mu cześć w raporcie dla Imperium Vossk. Umawiają się na drinka na stacji [[station/98]].", false],
	],
	"step/43": [
		[43, "", "Keith dołącza do Brenta na stacji [[station/98]], aby świętować.", false],
		[44, "", "Po kilku drinkach przychodzi Carla w wieczorowej sukni, by spłacić randkę, którą jest winna Keithowi. Brent taktownie zostawia ich samych.", false],
	],
	"step/44": [
		[44, "", "Keith budzi się na stacji [[station/98]] z kacem po nocy spędzonej z Carlą.", false],
		[45, "", "Carli już nie ma. W liściku wyjaśnia, że przeszła do innego tajnego projektu w miejscu, którego nie zdradzi, a Deep Science wypłaca Keithowi ostatnie 40 000 kredytów. Keith podejrzewa, że przez cały czas go wykorzystywano, i wraca do baru.", false],
	],
	"step/45": [
		[45, "", "Fabuła dobiegła końca. Statek-matka Voidów został zniszczony, tunele się zamknęły, a [[character/0]] może lecieć, dokąd zechce. Możesz dalej latać, handlować, wydobywać rudę i przyjmować zlecenia w całej galaktyce; streszczenie całej fabuły znajdziesz na stronie [[world/history]].", false],
	],
	"step/5": [
		[5, "", "Keith musi uciec piratowi i bezpiecznie zadokować na stacji [[station/78]].", false],
		[6, "", "Gunant przyznaje, że pirackie napady na jego stację są coraz częstsze. Keith proponuje, że się nimi zajmie, jeśli dostanie broń. Gunant postanawia zaatakować kryjówkę piratów w pobliżu stacji i otwiera swój mały hangar, aby Keith mógł zamontować broń i pancerz.", false],
	],
	"step/6": [
		[6, "", "W hangarze stacji Keith musi wyposażyć statek [[ship/0]] w broń i płytę pancerza (zob. [[guide/fitting]]).", false],
		[7, "", "Gunant pochwala wybór. Na wszelki wypadek ustawił broń Keitha tak, by nie mogła przebić jego własnych osłon. Obaj umawiają się na zewnątrz.", false],
	],
	"step/7": [
		[7, "", "Gunant przesyła trasę do kryjówki w postaci punktów nawigacyjnych. Keith musi nią podążać i zniszczyć znajdujące się tam statki piratów, a Gunant leci u jego boku (zob. [[guide/combat]]).", false],
		[8, "", "W kryjówce jest o wiele więcej piratów, niż się spodziewano. Gunant chce się wycofać, ale Keith walczy dalej i wygrywa. Zapytany, gdzie nauczył się tak walczyć, Keith odpowiada, że służył we Flocie Kosmicznej pod admirałem Smithem. Gunant uważa to za dziwne, bo Keith wygląda na zdecydowanie za młodego.", false],
	],
	"step/8": [
		[8, "", "Po wygranej bitwie Keith i Gunant wracają na stację [[station/78]].", false],
		[9, "", "Gunant dziękuje Keithowi za uratowanie życia i wspomina o grobie admirała Smitha na stacji [[station/5]]. Keith jest wstrząśnięty: admirał zmarł ze starości około roku 3612. Gunant mówi mu wtedy, że obecnie trwa rok 3624, który według niego zostanie zapamiętany z powodu Voidów.", false],
	],
	"step/9": [
		[9, "", "Wstrząśnięty tą wiadomością Keith ponownie dokuje na stacji [[station/78]], aby rozliczyć się z Gunantem.", false],
		[10, "", "Keith uświadamia sobie, że od trafienia w pasie asteroid minęło około 35 lat. Gunant podejrzewa awarię hipernapędu, bo ten typ napędu od lat wiąże się z podobnymi przypadkami.", false],
		[10, "", "W podziękowaniu za zwycięstwo nad piratami Gunant oddaje Keithowi statek [[ship/0]], wyposażony w mocniejszy napęd do podróży między planetami układu. Zatrzymuje jednak laser górniczy, prototyp własnej konstrukcji. Keith w końcu podaje swoje nazwisko i wyrusza na spotkanie z kapitanem [[character/3]], ludzkim komendantem stacji [[station/79]], który może mu pomóc dostać się do przestrzeni frakcji [[faction/0]]. Od teraz [[chart]] pozwala podróżować w obrębie układu.", false],
	],
	"system/0": [
		[0, "", "[[system/0]] to układ Nivelian na lewej krawędzi mapy. Jest ukryty na mapie gwiazd, dopóki nie kupisz jego współrzędnych od agenta [[agent/12]] na stacji [[station/18]]. Jego brama przy stacji [[station/0]] łączy go z układami [[system/2]] i [[system/8]].", false],
		[0, "", "Stacje układu Suteo należą do najbardziej zaawansowanych w przestrzeni Nivelian, a [[station/2]] i [[station/4]] mają najwyższy poziom technologii. Agent [[agent/0]] sprzedaje schemat na stacji [[station/3]].", false],
	],
	"system/1": [
		[0, "", "[[system/1]] to układ Terran w lewym dolnym rogu mapy. Jest ukryty, dopóki nie kupisz jego współrzędnych od agenta [[agent/13]] na stacji [[station/26]]. Jego brama przy stacji [[station/5]] łączy go z układami [[system/8]] i [[system/18]].", false],
		[0, "", "Jego stacje są dobrze rozwinięte, a [[station/7]] ma najwyższy poziom technologii. Agent [[agent/1]] sprzedaje schemat na stacji [[station/8]].", false],
		[9, "", "Według handlarza [[character/2]] na stacji [[station/5]] spoczywa admirał Smith, dawny dowódca Keitha ([[character/0]]).", false],
	],
	"system/10": [
		[0, "", "[[system/10]] to układ Vossk po prawej stronie mapy z oceną „Dangerous” (niebezpieczny). Jest ukryty, dopóki nie kupisz jego współrzędnych od agenta [[agent/14]], i nie ma żadnych połączeń bramowych: dotrze tu tylko statek z napędem skokowym. Wszystkie pięć jego stacji ma najwyższe poziomy technologii.", false],
		[0, "", "Agent [[agent/5]] sprzedaje schemat na stacji [[station/54]].", false],
	],
	"system/11": [
		[0, "", "[[system/11]] to układ Terran w górnej środkowej części mapy z oceną „Average” (przeciętny). Ma tylko trzy stacje. Jego brama przy stacji [[station/55]] łączy go z układami [[system/7]], [[system/9]], [[system/14]] i [[system/16]].", false],
		[18, "", "[[character/0]] zostaje wysłany na stację [[station/56]] na spotkanie z oficerem Deep Science.", false],
		[19, "", "Oficer, [[character/5]], został porwany przez piratów w pobliżu stacji [[station/55]].", false],
		[22, "", "[[character/0]] uwalnia go za pomocą bomb EMP ([[step/21]]).", false],
	],
	"system/12": [
		[0, "", "[[system/12]] to mały układ Vossk z zaledwie dwiema stacjami, po prawej stronie mapy, z oceną „Average” (przeciętny). Jego brama przy stacji [[station/60]] łączy go z układami [[system/3]], [[system/5]], [[system/13]] i [[system/14]], dzięki czemu łączy przestrzeń Vossk z terrańskim wschodem.", false],
		[0, "", "Agent [[agent/6]], przedstawiciel rasy Multipodów, sprzedaje schemat na stacji [[station/61]].", false],
	],
	"system/13": [
		[0, "", "[[system/13]] to układ Terran na prawej krawędzi mapy z oceną „Risky” (ryzykowny). Jego brama przy stacji [[station/65]] łączy go z układami [[system/12]] i [[system/16]].", false],
		[0, "", "Agent [[agent/14]], przedstawiciel rasy Cyborgów, sprzedaje współrzędne na stacji [[station/65]].", false],
	],
	"system/14": [
		[0, "", "[[system/14]] to układ Terran w pobliżu środka mapy i jeden z dwóch bezpiecznych układów w galaktyce. Jego brama przy stacji [[station/70]] łączy go z układami [[system/3]], [[system/11]], [[system/12]] i [[system/19]]. Jego stacje mają przeważnie niski poziom technologii.", false],
		[0, "", "Agent [[agent/7]] sprzedaje schemat na stacji [[station/72]].", false],
	],
	"system/15": [
		[0, "", "[[system/15]] to układ Midorian u góry mapy z oceną „Dangerous” (niebezpieczny). Nie ma połączeń bramowych, więc statek może do niego wlecieć lub go opuścić tylko z napędem skokowym. Wszystkie pięć stacji jest małych i ma niski poziom technologii. Sprzedawcy statków pozostają zamknięci, a statków przylatuje i odlatuje niewiele, dopóki nie nastąpi [[step/16]].", false],
		[0, "", "Tutaj, przy stacji [[station/78]], zaczyna się fabuła.", false],
		[11, "", "Układ jest terytorium [[faction/3|Konfederacji Mido]], założonej przez terrańskich i nivelijskich wygnańców w czasie nivelijskiej wojny domowej. Nivelianie wciąż roszczą sobie do niego prawa, a na jego obrzeżach trwają walki.", false],
		[15, "", "[[character/0]] opuszcza układ jako więzień na pokładzie terrańskiego krążownika ([[step/14]]). Późniejszy powrót wymaga napędu skokowego.", false],
		[0, "", "[[character/2]] sprzedaje schemat w Space Lounge stacji [[station/78]].", false],
	],
	"system/16": [
		[0, "", "[[system/16]] to układ Terran po prawej stronie mapy z oceną „Risky” (ryzykowny). Jego brama przy stacji [[station/80]] łączy go z układami [[system/11]] i [[system/13]].", false],
		[0, "", "Agent [[agent/8]], przedstawiciel Vossk, sprzedaje schemat na stacji [[station/84]].", false],
	],
	"system/17": [
		[0, "", "[[system/17]] to układ Nivelian w lewej górnej części mapy z oceną „Risky” (ryzykowny), najbliższy układowi [[system/15]]. Jego brama przy stacji [[station/85]] łączy go z układami [[system/2]], [[system/9]] i [[system/4]]; to jedyna trasa bramowa do układu [[system/4]].", false],
		[0, "", "Agent [[agent/15]], przedstawiciel Vossk, sprzedaje współrzędne na stacji [[station/88]].", false],
	],
	"system/18": [
		[0, "", "[[system/18]] to układ Terran u dołu mapy z oceną „Risky” (ryzykowny). Jego brama przy stacji [[station/90]] łączy go z układami [[system/1]] i [[system/8]].", false],
		[0, "", "Agent [[agent/9]] sprzedaje schemat na stacji [[station/90]].", false],
		[28, "", "Po doniesieniu o aktywności Voidów w pobliżu stacji [[station/91]] przybywa tu [[character/0]], aby wślizgnąć się do tunelu czasoprzestrzennego ([[step/28]]).", false],
	],
	"system/19": [
		[0, "", "[[system/19]] to układ Terran w środku mapy z oceną „Safe” (bezpieczny). Jego brama przy stacji [[station/95]] łączy go z układami [[system/3]], [[system/8]], [[system/9]] i [[system/14]].", false],
		[15, "", "Na stację [[station/98]] terrański krążownik przywozi Keitha ([[character/0]]) po aresztowaniu i tam spotyka on ponownie swojego starego przyjaciela, [[character/1]].", false],
		[16, "", "Nawet ten bezpieczny układ nie zostaje oszczędzony: eskadra Voidów atakuje stację [[station/98]] ([[step/16]]). [[character/1]] ma tam swoją kwaterę główną.", false],
	],
	"system/2": [
		[0, "", "[[system/2]] to układ Nivelian po lewej stronie mapy i skrzyżowanie dróg przestrzeni Nivelian. Jego brama przy stacji [[station/30]] łączy go z układami [[system/0]], [[system/8]], [[system/9]] i [[system/17]]. Ma cztery stacje o średnim poziomie technologii.", false],
		[34, "", "Kierowniczka projektu [[character/6]] wysyła pilota, którym jest [[character/0]], na stację [[station/30]], gdzie czeka [[character/1]] z nowym planem ([[step/33]]). Tam odbywają się też ostatnie przygotowania przeciwko Voidom.", false],
	],
	"system/20": [
		[0, "", "[[system/20]] to układ Vossk w prawej dolnej części mapy z oceną „Dangerous” (niebezpieczny). Jego brama przy stacji [[station/62]] łączy go z układami [[system/5]] i [[system/21]], co czyni go jedyną trasą bramową do układu [[system/21]].", false],
		[0, "", "Terranin, agent [[agent/10]], sprzedaje schemat na małej stacji [[station/59]].", false],
	],
	"system/21": [
		[0, "", "[[system/21]] to układ Vossk w najdalszym prawym dolnym rogu mapy z oceną „Dangerous” (niebezpieczny). Jest ukryty, dopóki nie kupisz jego współrzędnych od agenta [[agent/15]]. Jego brama przy stacji [[station/12]] łączy go tylko z układem [[system/20]]. Wszystkie jego stacje są prymitywne, z poziomem technologii 3 lub niższym.", false],
	],
	"system/3": [
		[0, "", "[[system/3]] to układ Vossk położony najbliżej środka mapy i główne wejście do przestrzeni Vossk. Jego brama przy stacji [[station/15]] łączy go z układami [[system/5]], [[system/12]], [[system/8]], [[system/14]] i [[system/19]]. Ma ocenę „Average” (przeciętny).", false],
		[0, "", "Agent [[agent/12]] na stacji [[station/18]] sprzedaje współrzędne ukrytego układu [[system/0]].", false],
	],
	"system/4": [
		[0, "", "[[system/4]] to układ Midorian w lewym górnym rogu mapy z oceną „Dangerous” (niebezpieczny). To ślepy zaułek: jego brama przy stacji [[station/20]] prowadzi tylko do układu [[system/17]]. Jego stacje to zarówno prymitywna [[station/21]], jak i dobrze wyposażona [[station/22]].", false],
		[0, "", "Agent [[agent/2]] sprzedaje schemat w Space Lounge stacji [[station/20]].", false],
		[38, "", "Skradziony konwój z nivelijskimi materiałami wybuchowymi zostaje wytropiony w tym układzie, w pobliżu stacji [[station/22]] ([[step/38]]).", false],
	],
	"system/5": [
		[0, "", "[[system/5]] to układ Vossk w prawej dolnej części mapy z oceną „Risky” (ryzykowny). Jego brama przy stacji [[station/25]] łączy go z układami [[system/3]], [[system/12]] i [[system/20]]. Agent [[agent/13]] sprzedaje współrzędne na stacji [[station/26]].", false],
		[35, "", "Układ jest bazą macierzystą dowódcy Vossk, [[character/7]], na stacji [[station/29]], gdzie spotyka go [[character/0]] ([[step/35]]).", false],
		[36, "", "Ich zawody odbywają się w pobliżu planety [[station/27]].", false],
	],
	"system/6": [
		[0, "", "[[system/6]] to układ Terran w prawym górnym rogu mapy z oceną „Dangerous” (niebezpieczny). Nie ma go na standardowych mapach gwiazd, a jego współrzędne ujawnia dopiero fabuła. Ma jedną stację, [[station/10]], której brama łączy go wyłącznie z układem [[system/7]].", false],
		[23, "", "W układzie ukryta jest tajna stacja badawcza Deep Science. [[character/5]] przekazuje Keithowi ([[character/0]]) jej współrzędne ([[step/22]]), a znaczna część walki z Voidami jest planowana właśnie tam.", false],
	],
	"system/7": [
		[0, "", "[[system/7]] to układ Terran w prawym górnym rogu mapy z oceną „Risky” (ryzykowny). Jego brama przy stacji [[station/35]] łączy go z układem [[system/11]] i z ukrytym układem [[system/6]], co czyni go jedyną trasą bramową do ukrytego układu. [[station/37]] to jego najbardziej zaawansowana stacja.", false],
	],
	"system/8": [
		[0, "", "[[system/8]] to układ Terran w lewej dolnej ćwiartce mapy i najlepiej połączony układ w galaktyce. Jego brama przy stacji [[station/40]] łączy go z sześcioma układami: [[system/0]], [[system/1]], [[system/2]], [[system/3]], [[system/18]] i [[system/19]]. Ma ocenę „Average” (przeciętny).", false],
		[0, "", "Agent [[agent/4]] sprzedaje schemat na stacji [[station/43]].", false],
	],
	"system/9": [
		[0, "", "[[system/9]] to układ Nivelian w górnej środkowej części mapy z oceną „Average” (przeciętny). Jego brama przy stacji [[station/45]] łączy go z układami [[system/2]], [[system/11]], [[system/17]] i [[system/19]].", false],
		[24, "", "W pobliżu stacji [[station/48]] zgłaszana jest aktywność Voidów; [[character/0]] i [[character/6]] lecą tam, by zbierać szczątki ([[step/24]]).", false],
	],
	"world/galaxy": [
		[0, "Przegląd", "Gra toczy się w jednej galaktyce liczącej 22 układy gwiezdne. Każdy układ należy do jednej frakcji, ma ocenę bezpieczeństwa i mieści od jednej do pięciu stacji kosmicznych. Każda stacja krąży wokół planety i ma własny sklep, hangar oraz Space Lounge. Układy są rozmieszczone na płaskiej mapie, a podróże między nimi odbywają się przez sieć bram skokowych.", false],
		[0, "", "Zbadane układy należą do czterech ludów. [[faction/0|Terranie]] mają ich dziesięć, frakcja [[faction/1]] sześć, [[faction/2|Nivelianie]] cztery, a [[faction/3|Midorianie]] dwa. Przedstawiciele mniejszych ras, takich jak [[faction/4|Multipody]], [[faction/5|Cyborgi]], [[faction/6|Bobolianie]] i [[faction/7]], żyją wśród nich bez własnego terytorium. [[faction/8|Piraci]] grasują w każdym układzie, a od samego początku krążą pogłoski o wrogiej sile zwanej [[faction/9|Voidami]].", false],
		[0, "Rozmieszczenie", "Układy Nivelian i Midorian leżą w lewej górnej części mapy, wokół układów [[system/15]], [[system/4]], [[system/17]] i [[system/2]]. Przestrzeń Terran ciągnie się przez środek, prawą stronę i dół mapy, a jej sercem są układy [[system/19]] i [[system/14]]. Układy Vossk tworzą osobny blok w prawym dolnym rogu, od układu [[system/3]] aż po układ [[system/21]] w najdalszym narożniku.", false],
		[0, "", "Trasy bram sprzyjają środkowi mapy. Układ [[system/8]] ma sześć połączeń bramowych, więcej niż jakikolwiek inny, a układy [[system/19]], [[system/14]], [[system/3]] i [[system/11]] łączą się z czterema lub pięcioma układami każdy. Układy na obrzeżach, takie jak [[system/4]], [[system/6]] i [[system/21]], są ślepymi zaułkami z jednym połączeniem.", false],
		[0, "Podróże", "W obrębie układu zwykły napęd statku przenosi go z orbity jednej stacji na orbitę drugiej. Aby opuścić układ, statek przelatuje przez bramę skokową, która stoi przy jednej ze stacji układu i prowadzi tylko do połączonych z nim układów. Dłuższe podróże to łańcuchy skoków przez bramy. Napęd skokowy to jedyny sposób, by ominąć sieć bram i dotrzeć bezpośrednio do dowolnego znanego układu; zob. [[guide/navigation]].", false],
		[33, "", "Jedynym napędem skokowym w grze jest [[item/85]], który w trakcie fabuły projektuje [[character/20]]. Buduje się go według schematu, a potrzebny jest do tego między innymi towar [[item/164]].", false],
		[0, "Bezpieczeństwo", "Każdy układ ma ocenę: „Safe” (bezpieczny), „Average” (przeciętny), „Risky” (ryzykowny) lub „Dangerous” (niebezpieczny). Od niej zależy, jak często po przylocie napastnicy czają się w pobliżu stacji. W układzie „Dangerous” pojawiają się przy większości wizyt, w układzie „Safe” rzadko. Napastnikami są zwykle piraci, ale czasem statki rasy rywalizującej z frakcją układu. Bezpieczniejsze układy utrzymują za to więcej miejscowych patroli wokół stacji.", false],
		[0, "Frakcje i reputacja", "Twoja reputacja jest liczona na dwóch skalach: jednej między Terranami a Vossk, drugiej między Nivelianami a Midorianami. Przychylność jednej strony pary kosztuje przychylność drugiej. Jeśli Twoja reputacja u danej frakcji spadnie zbyt nisko, jej statki atakują Cię od razu, a jej stacje Cię nie przyjmują. Piraci i Voidy są zawsze wrogie. Dyplomata w Space Lounge może za opłatą naprawić Twoją reputację.", false],
		[0, "Ukryte układy", "Nie każdy układ jest od początku widoczny na mapie gwiazd. Układy [[system/0]], [[system/1]], [[system/10]] i [[system/21]] pozostają ukryte, dopóki nie kupisz ich współrzędnych od agenta w Space Lounge; zob. [[guide/lounge]]. Jeszcze jednego układu, [[system/6]], brakuje na standardowych mapach gwiazd i ujawnia go dopiero fabuła.", false],
		[23, "", "Współrzędne układu [[system/6]] przekazuje Ci [[character/5]] ([[step/22]]). W układzie jest jedna stacja, [[station/10]], tajna baza badawcza organizacji Deep Science.", false],
		[0, "", "Dwa układy nie mają żadnych połączeń bramowych: [[system/15]] i [[system/10]]. Statek może do nich dotrzeć lub je opuścić tylko z napędem skokowym.", false],
		[0, "Odcięty początek", "Fabuła zaczyna się w układzie [[system/15]], odległym układzie u góry mapy bez połączenia bramowego z resztą galaktyki. Handel jest tu słaby, stacje mają niski poziom technologii, a sprzedawcy statków pozostają zamknięci przez pierwszą część fabuły. Na początku jedyną drogą wyjścia z układu jest ta, którą zapewnia fabuła.", false],
		[11, "", "Układ [[system/15]] to ojczyzna [[faction/3|Konfederacji Mido]], grupy terrańskich i nivelijskich uchodźców i banitów, którzy zasiedlili ten nowo zbadany sektor w czasie nivelijskiej wojny domowej. Konfederacja ogłosiła niepodległość. Terranie to akceptują, Nivelianie wciąż roszczą sobie prawa do układu, co podtrzymuje walki na jego obrzeżach.", false],
		[15, "", "[[character/0]] opuszcza układ [[system/15]] na pokładzie terrańskiego krążownika po tym, jak konwój przy stacji [[station/79]] unieszkodliwia go i aresztuje ([[step/14]]). Trafia na stację [[station/98]] w układzie [[system/19]], głęboko w przestrzeni Terran.", false],
		[9, "Luka w czasie", "Gdy [[character/0]] budzi się w układzie [[system/15]], sądzi, że minęło niewiele czasu. W rzeczywistości uszkodzony hipernapęd przerzucił go przez galaktykę i około 35 lat w przyszłość. Galaktyka, którą znał, się zmieniła: starzy przyjaciele się postarzeli lub zmarli, a w międzyczasie zasiedlono nowe sektory, w tym ten, w którym się znajduje.", false],
		[10, "", "Wadliwe hipernapędy tego typu już wcześniej powodowały podobne skoki w czasie i przestrzeni.", false],
		[18, "Poza mapą", "Voidy wchodzą do zbadanych układów przez coś w rodzaju tuneli czasoprzestrzennych. Najeżdżają w równym stopniu przestrzeń Terran, Nivelian i Vossk i najwyraźniej szukają rudy. Zob. [[world/voids]].", false],
		[25, "", "Tunel czasoprzestrzenny prowadzi poza zbadaną galaktykę do własnego sektora Voidów, którego nie ma na mapie gwiazd. Tunele otwierają się na jakiś czas w pobliżu stacji, a potem zapadają się i pojawiają gdzie indziej.", false],
		[34, "", "Z zamontowanym napędem [[item/85]] statek może też skoczyć prosto do sektora Voidów.", false],
		[32, "", "Gdy nastąpi [[step/31]], system wczesnego ostrzegania pokazuje na mapie gwiazd, gdzie otworzy się następny tunel.", false],
		[42, "", "Gdy statek-matka Voidów zostaje zniszczony ([[step/41]]), tunele w całym sektorze zapadają się, a najazdy ustają.", false],
	],
	"world/history": [
		[0, "", "Galaktykę zamieszkuje kilka ludów, wśród nich [[faction/0|Terranie]], [[faction/2|Nivelianie]] i [[faction/1|Vossk]]. Przestrzeń między ich stacjami nękają [[faction/8|piraci]]. Ta strona streszcza fabułę; każda część pojawia się, gdy dotrze do niej Twój zapis.", false],
		[0, "Akt pierwszy: rozbitek", "Terrański łowca nagród [[character/0]] rozbija gang piratów w pasie asteroid ([[step/0]]).", false],
		[1, "", "Gdy odlatuje skokiem na spotkanie ze swoim dawnym dowódcą, admirałem Smithem, ostatni strzał uszkadza jego hipernapęd. Statek z nieprzytomnym pilotem dryfuje do stacji [[station/78]].", false],
		[2, "", "Nivelijski handlarz rudą [[character/2]] przejmuje wrak, zatrzymuje statek i każe Keithowi wydobywać dla siebie rudę.", false],
		[8, "", "Keith pomaga Gunantowi zniszczyć pobliską kryjówkę piratów ([[step/7]]).", false],
		[9, "", "Potem Keith dowiaduje się, że jest rok 3624, a admirał Smith od dawna nie żyje.", false],
		[10, "", "Awaria hipernapędu przeniosła Keitha o 35 lat w przyszłość, w odległy zakątek galaktyki. Gunant daje mu statek [[ship/0]] i wysyła go do kapitana [[character/3]] na stację [[station/79]].", false],
		[11, "", "Układ [[system/15]] należy do [[faction/3|Konfederacji Mido]], założonej przez terrańskich i nivelijskich wygnańców w czasie nivelijskiej wojny domowej.", false],
		[12, "", "Keith odkrywa, że załogę milczącej stacji [[station/76]] odurzył narkotykami diler [[character/4]] ([[step/11]]).", false],
		[15, "", "Przelatujący terrański konwój bierze Keitha za pirata, unieszkodliwia jego statek i zabiera go na stację [[station/98]] ([[step/14]]).", false],
		[16, "Akt drugi: zagrożenie ze strony Voidów", "Tam spotyka swojego starego przyjaciela, [[character/1]], obecnie szefa bezpieczeństwa, akurat w chwili, gdy [[faction/9|Voidy]] atakują stację.", false],
		[18, "", "Voidy najeżdżają układy gwiezdne przez tunele czasoprzestrzenne w poszukiwaniu rudy. Brent werbuje Keitha jako pilota dla Deep Science, tajnej organizacji badawczej, która ich bada ([[step/17]]).", false],
		[19, "", "Naukowca [[character/5]], który miał zaprowadzić Keitha do stacji badawczej, porywają piraci.", false],
		[23, "", "Keith unieszkodliwia statek porywaczy bombami EMP, ratuje naukowca i otrzymuje współrzędne układu [[system/6]] ([[step/21]], [[step/22]]).", false],
		[24, "Akt trzeci: Deep Science", "Na stacji [[station/10]] Keith poznaje kierowniczkę projektu, [[character/6]], i zaczyna pracować dla Deep Science.", false],
		[25, "", "Keith i Carla zbierają szczątki Voidów przy stacji [[station/48]], lecz tunel czasoprzestrzenny wciąga ich statek ([[step/24]]).", false],
		[26, "", "Trafiają do macierzystego sektora Voidów, obok gigantycznego statku-matki, i uciekają innym tunelem.", false],
		[30, "", "Keith wraca do sektora Voidów przez tunel w pobliżu stacji [[station/91]] i wystrzeliwuje sondę w statek-matkę ([[step/29]]).", false],
		[32, "", "Brent daje Keithowi system wczesnego ostrzegania, który pokazuje, gdzie Voidy uderzą następnym razem.", false],
		[34, "", "Naukowiec rasy Grey, [[character/20]], zleca Keithowi zebranie kryształów Voidów do nowego napędu natychmiastowego i daje mu jego schemat ([[step/33]]).", false],
		[35, "Akt czwarty: uderzenie", "Sonda wykazuje, że to statek-matka tworzy tunele. Brent i Carla planują zniszczyć go frachtowcem pełnym nivelijskich materiałów wybuchowych, dostarczonym przez dowódcę Vossk, [[character/7]].", false],
		[37, "", "Errkt upiera się, że sam poprowadzi frachtowiec, a Keith zdobywa prawo do jego eskortowania ([[step/36]]).", false],
		[39, "", "Keith odbija konwój z materiałami wybuchowymi, przejęty wcześniej przez statki Mido ([[step/38]]).", false],
		[42, "", "Ze wsparciem pod dowództwem [[character/8]] Keith eskortuje Errkta przez tunel. Errkt taranuje frachtowcem statek-matkę i ginie w ataku ([[step/41]]).", false],
		[43, "", "Wszystkie tunele czasoprzestrzenne zapadają się, a najazdy Voidów ustają.", false],
		[45, "Epilog", "Keith świętuje z Brentem i wreszcie spędza noc z Carlą. Następnego ranka ona wyjeżdża do kolejnego tajnego projektu, a Keith może swobodnie przemierzać galaktykę.", false],
	],
	"world/voids": [
		[0, "", "[[faction/9|Voidy]] są głównym zagrożeniem w fabule. Ta strona zbiera to, czego się o nich dowiadujemy; więcej informacji pojawia się wraz z postępem Twojego zapisu.", false],
		[2, "Pierwsze wieści", "Keith po raz pierwszy słyszy o Voidach od handlarza [[character/2]]: to wrogie istoty, które od czasu do czasu pojawiają się nawet w odległym układzie [[system/15]].", false],
		[9, "", "Mieszkańcy układu Mido spodziewają się, że rok 3624 zostanie zapamiętany jako rok Voidów.", false],
		[16, "", "Myśliwce Voidów atakują stację [[station/98]] w przestrzeni Terran ([[step/15]]).", false],
		[17, "", "Podczas ataku Voidy nadają komunikat, że przybywają w pokoju, ale nie przestają strzelać.", false],
		[18, "Co wiadomo", "Voidy zaczęły się pojawiać kilka tygodni wcześniej. Wchodzą do zamieszkanych układów przez tunele czasoprzestrzenne, atakują wszystko, co napotkają, i najwyraźniej szukają rudy. Najeżdżają nawet układy frakcji [[faction/1]]. Nikt nie wie, skąd pochodzą ani czego chcą.", false],
		[24, "", "Przy stacji [[station/48]] oznajmiają, że przybywają z przyszłości i są wszystkim, co zostało z cywilizacji galaktyki.", false],
		[26, "Sektor macierzysty", "Ich tunele prowadzą do odległego sektora macierzystego, gdzie gigantyczny statek-matka wypuszcza myśliwce. Tunele otwierają się na krótki czas, po czym zapadają się i pojawiają w innym miejscu.", false],
		[28, "", "Voidy ostrzegają, że ich zniszczenie zniszczy przyszłość ludzkości.", false],
		[30, "", "Powtarzają, że muszą znaleźć sposób porozumienia, zanim ludzie zniszczą je, a wraz z nimi własną przyszłość. Nigdy nie wyjaśnia się, czy to prawda.", false],
		[32, "", "System wczesnego ostrzegania opracowany przez zespół, którym kieruje [[character/1]], przewiduje, gdzie Voidy otworzą następny tunel.", false],
		[33, "", "Naukowiec rasy Grey, [[character/20]], uważa, że kryształy występujące tylko w sektorze Voidów, [[item/164]], kryją tajemnicę ich tuneli.", false],
		[35, "Koniec najazdów", "Sonda wystrzelona w statek-matkę wykazuje, że to on jest źródłem tuneli. Żadna znana broń go nie uszkodziła.", false],
		[42, "", "Frachtowiec Vossk wyładowany nivelijskimi ładunkami jądrowymi, pilotowany przez dowódcę [[character/7]], niszczy statek-matkę ([[step/41]]).", false],
		[43, "", "Potem tunele w całym sektorze zapadają się, a najazdy Voidów ustają, przynajmniej na jakiś czas.", false],
	],
}
