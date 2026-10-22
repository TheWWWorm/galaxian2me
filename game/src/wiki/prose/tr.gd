extends RefCounted
## Reference prose in Turkish. Each block is [story step it appears from,
## section heading or "", text, list item]. See src/wiki/prose.gd.
const PAGES := {
	"guide/basics": {"title": "Başlarken", "subtitle": "Rehber", "category": "guide", "from": 0},
	"guide/blueprints": {"title": "Planlar ve üretim", "subtitle": "Rehber", "category": "guide", "from": 0},
	"guide/combat": {"title": "Savaş", "subtitle": "Rehber", "category": "guide", "from": 0},
	"guide/fitting": {"title": "Gemiler ve donanım", "subtitle": "Rehber", "category": "guide", "from": 0},
	"guide/flight": {"title": "Uçuş", "subtitle": "Rehber", "category": "guide", "from": 0},
	"guide/jobs": {"title": "Serbest görevler", "subtitle": "Rehber", "category": "guide", "from": 0},
	"guide/lounge": {"title": "Uzay Salonu", "subtitle": "Rehber", "category": "guide", "from": 0},
	"guide/medals": {"title": "Madalyalar", "subtitle": "Rehber", "category": "guide", "from": 0},
	"guide/mining": {"title": "Madencilik", "subtitle": "Rehber", "category": "guide", "from": 0},
	"guide/navigation": {"title": "Seyir", "subtitle": "Rehber", "category": "guide", "from": 0},
	"guide/trading": {"title": "Ticaret", "subtitle": "Rehber", "category": "guide", "from": 0},
	"step/0": {"title": "Asteroit kuşağında ödül avı"},
	"step/1": {"title": "Sürüklenirken bulundu"},
	"step/10": {"title": "Komutanla buluşma"},
	"step/11": {"title": "Sessiz bir istasyon"},
	"step/12": {"title": "Komutana rapor"},
	"step/13": {"title": "Konvoyu beklerken"},
	"step/14": {"title": "Terran konvoyu"},
	"step/15": {"title": "Tutuklu"},
	"step/16": {"title": "İstasyonun savunması"},
	"step/17": {"title": "Void'lerin hikâyesi"},
	"step/18": {"title": "Bir bilim insanıyla buluşma"},
	"step/19": {"title": "Kaçırılma"},
	"step/2": {"title": "İlk cevher seferi"},
	"step/20": {"title": "Bombaların takılması"},
	"step/21": {"title": "Kaçıranları etkisiz hâle getirmek"},
	"step/22": {"title": "Kurtarılan bilim insanı"},
	"step/23": {"title": "Gizli araştırma istasyonu"},
	"step/24": {"title": "Void enkazını toplamak"},
	"step/25": {"title": "Yabancı bir uzayda kayıp"},
	"step/26": {"title": "Takipçilerden kurtulmak"},
	"step/27": {"title": "Yeni bir görev"},
	"step/28": {"title": "Yeniden solucan deliğine"},
	"step/29": {"title": "Sondanın fırlatılması"},
	"step/3": {"title": "Cevherin teslimi"},
	"step/30": {"title": "Eski bir dosttan çağrı"},
	"step/31": {"title": "Vaat edilen sürpriz"},
	"step/32": {"title": "Grey bilim insanı"},
	"step/33": {"title": "Void'den gelen kristaller"},
	"step/34": {"title": "Zafer için bir plan"},
	"step/35": {"title": "Vossk komutanıyla buluşma"},
	"step/36": {"title": "Pilotların yarışı"},
	"step/37": {"title": "Karargâhı aramak"},
	"step/38": {"title": "Konvoyun geri alınması"},
	"step/39": {"title": "Son hazırlıklar"},
	"step/4": {"title": "Dolu bir kargo ambarı"},
	"step/40": {"title": "Solucan deliğine eskort"},
	"step/41": {"title": "Ana gemiye saldırı"},
	"step/42": {"title": "Void uzayından kaçış"},
	"step/43": {"title": "Bir kutlama"},
	"step/44": {"title": "Ertesi sabah"},
	"step/45": {"title": "Son söz"},
	"step/5": {"title": "İstasyona kaçış"},
	"step/6": {"title": "Gemiyi silahlandırmak"},
	"step/7": {"title": "Korsan sığınağı"},
	"step/8": {"title": "Savaştan sonra"},
	"step/9": {"title": "Hesaplaşma"},
	"world/galaxy": {"title": "Galaksi", "subtitle": "Evren", "category": "world", "from": 0},
	"world/history": {"title": "Tarihçe", "subtitle": "Evren", "category": "world", "from": 0},
	"world/khador": {"title": "Khador", "subtitle": "Karakter", "category": "characters", "from": 32},
	"world/voids": {"title": "Void'ler", "subtitle": "Evren", "category": "world", "from": 0},
}
const BLOCKS := {
	"agent/0": [
		[0, "", "[[agent/0]], gizli [[system/0]] sistemindeki [[station/3]] istasyonunun salonunda bulunan bir Nivelian ajandır. [[item/11]] lazerinin planını satar.", false],
	],
	"agent/1": [
		[0, "", "[[agent/1]], gizli [[system/1]] sistemindeki [[station/8]] istasyonunun salonunda bulunan bir Nivelian ajandır. Nadir olarak tanımladığı bir silah olan [[item/15]] blasterının planını satar.", false],
	],
	"agent/10": [
		[0, "", "[[agent/10]], Vossklar arasında, [[system/20]] sistemindeki [[station/59]] istasyonunun salonunda yaşayan bir Terran ajandır. Gizlenme cihazı [[item/96]] için plan satar.", false],
	],
	"agent/11": [
		[0, "", "[[agent/11]], [[system/15]] sistemindeki [[station/78]] istasyonunda kendi salonunda beliren cevher tüccarı [[character/2]] adlı karakterin kendisidir. Kendi maden lazeri olan [[item/90]] için, diğer tüm ajanlarınkinin çok üzerinde bir fiyata plan satar. [[system/15]] sisteminin kapı bağlantısı olmadığından, oyunun ilerleyen bölümlerinde ona ulaşmak için bir atlama motoru gerekir.", false],
		[10, "", "[[character/0]] adlı pilotu zaman yolcusu diye karşılar ve bir zamanlar kendine sakladığı matkabı üretmeye başlamıştır.", false],
	],
	"agent/12": [
		[0, "", "[[agent/12]], [[system/3]] sistemindeki [[station/18]] istasyonunun salonunda bulunan bir Vossk ajandır. Gizli [[system/0]] sisteminin koordinatlarını, sistemin pek çok gelişmiş istasyonunu överek satar.", false],
	],
	"agent/13": [
		[0, "", "[[agent/13]], [[system/5]] sistemindeki [[station/26]] istasyonunun salonunda bulunan bir Bobolian ajandır. Gizli [[system/1]] sisteminin koordinatlarını satar.", false],
	],
	"agent/14": [
		[0, "", "[[agent/14]], [[system/13]] sistemindeki [[station/65]] istasyonunun salonunda bulunan bir Cyborg ajandır. [[system/10]] sisteminin koordinatlarını satar, ama oraya nasıl gidileceği hakkında hiçbir fikri olmadığını itiraf eder. Sistemin kapı bağlantısı olmadığından, atlama motoru olmadan koordinatların hiçbir yararı yoktur.", false],
	],
	"agent/15": [
		[0, "", "[[agent/15]], [[system/17]] sistemindeki [[station/88]] istasyonunun salonunda bulunan bir Vossk ajandır. Yurdu dediği gizli [[system/21]] sisteminin koordinatlarını satar. Bilindikten sonra sisteme [[system/20]] sisteminden kapıyla ulaşılabilir.", false],
	],
	"agent/2": [
		[0, "", "[[agent/2]], [[system/4]] sistemindeki [[station/20]] istasyonunun salonunda bulunan bir Midorian ajandır. [[item/25]] planını satar; bu, [[agent/4]] adlı ajanın roketi dışında bir ajanın sunduğu en ucuz silah planıdır.", false],
	],
	"agent/3": [
		[0, "", "[[agent/3]], [[system/6]] sistemindeki [[station/10]] istasyonunun salonunda bulunan bir Terran ajandır. Hızlı ateş eden bir kütle sürücüsü olan [[item/27]] silahının planını satar.", false],
	],
	"agent/4": [
		[0, "", "[[agent/4]], [[system/8]] sistemindeki [[station/43]] istasyonunun salonunda bulunan bir Terran ajandır. [[item/33]] planını satar; bu, herhangi bir ajanın sunduğu en ucuz plandır.", false],
	],
	"agent/5": [
		[0, "", "[[agent/5]], yalnızca bir atlama motoruyla ulaşılabilen [[system/10]] sistemindeki [[station/54]] istasyonunun salonunda bulunan bir Vossk ajandır. Hiçbir dükkânın satmadığı güdümlü torpido [[item/37]] için plan satar.", false],
	],
	"agent/6": [
		[0, "", "[[agent/6]], oyundaki tek Multipod'dur. [[system/12]] sistemindeki [[station/61]] istasyonunun salonunda oturur ve nükleer silah [[item/46]] için plan satar.", false],
	],
	"agent/7": [
		[0, "", "[[agent/7]], [[system/14]] sistemindeki [[station/72]] istasyonunun salonunda bulunan bir Terran ajandır. Güçlü bir kalkan olan [[item/54]] için plan satar.", false],
	],
	"agent/8": [
		[0, "", "[[agent/8]], [[system/16]] sistemindeki [[station/84]] istasyonunun salonunda bulunan bir Vossk ajandır. Dükkânlarda hiç satılmamış bir Vossk zırh plakası olan [[item/59]] için plan satar. [[agent/11]] adlı ajanın matkabından sonra ajanların sattığı en pahalı plandır.", false],
	],
	"agent/9": [
		[0, "", "[[agent/9]], [[system/18]] sistemindeki [[station/90]] istasyonunun salonunda bulunan bir Terran ajandır. Her tüccara önerdiği bir kargo sıkıştırıcı olan [[item/67]] için plan satar.", false],
	],
	"character/0": [
		[0, "", "[[character/0]] hikâyenin kahramanı ve oynadığınız karakterdir. Başlarına konan ödüller için [[faction/8|korsan]] avlayarak geçimini sağlayan bir [[faction/0]] avcı pilotudur. Kendinden emin, alaycıdır ve kavgaya hemen girer.", false],
		[1, "Mahsur", "Amiral Smith'in kendisi için özel bir görevi olduğu Eden Prime'a giderken bir korsan saldırısında hiper sürücüsü hasar görür. Otopilot onu baygın hâlde [[station/78]] istasyonuna götürür.", false],
		[2, "", "Orada, gemisine kurtarma hakkıyla el koyan ve onu madenci olarak çalıştıran cevher tüccarı [[character/2]] tarafından kurtarılır.", false],
		[8, "", "Keith, Terran Uzay Filosu'nun bir gazisidir ve orada Amiral Smith'in emrinde hizmet etmiştir.", false],
		[9, "", "Amiralin yaşlılıktan öldüğünü ve yılın artık 3624 olduğunu öğrenir.", false],
		[10, "", "Görünüşe göre bir hiper sürücü arızası yüzünden kazasından bu yana yaklaşık 35 yıl geçmiştir, ama Keith hiç yaşlanmamıştır. Ücra [[system/15]] sisteminde mahsur kalan Keith, Gunant'ın hediyesi olan [[ship/0]] adlı gemiyle yeniden başlar.", false],
		[16, "Void savaşı", "Yanlışlıkla tutuklandıktan sonra [[station/98]] istasyonunda eski dostu [[character/1]] ile yeniden buluşur ve [[faction/9|Void'lere]] karşı ilk savaşını verir.", false],
		[18, "", "Brent onu, Void'leri araştıran Deep Science adlı araştırma kuruluşu için pilot olarak işe alır.", false],
		[24, "", "[[station/10]] istasyonunda projenin lideri [[character/6]] ile tanışır ve kısa sürede ondan hoşlanır.", false],
		[26, "", "Carla ile birlikte bir Void solucan deliğinden geçerek Void'lerin ana bölgesine sürüklenir ve geri dönmenin bir yolunu bulurlar.", false],
		[36, "", "Vossk komutanı [[character/7]], Keith'in daha önce Novaterra'da hizmet ettiğini bilir.", false],
		[43, "", "Keith, Void ana gemisini yok edip baskınlara son veren yük gemisine eskortluk eder; ne var ki Errkt saldırıda hayatını kaybeder.", false],
		[45, "Sonrası", "Ödülü Carla ile geçirdiği bir gecedir; Carla ardından başka bir gizli proje için ortadan kaybolur ve ona son bir ödeme bırakır. İşini bitiren Keith, galakside dilediği gibi dolaşmakta özgürdür.", false],
	],
	"character/1": [
		[16, "", "[[character/1]], Keith'in kazasından önceki günlerden eski bir dostudur. Keith'in kaybettiği 35 yılda Brent, Yarbay rütbesine ve Yıldızlararası Güvenlik Ajansı şefliğine yükselmiştir. Cana yakın, konuşkandır ve uzun kişisel hikâyeler anlatmayı sever.", false],
		[18, "Void krizi", "Güvenlik şefi olarak [[faction/9|Void'lere]] karşı müdahaleyi koordine eden kriz ekibine başkanlık eder. Keith'i Deep Science için işe alır ve iyi ücret almasını sağlar. Keith'in gemisi onun emriyle yeniden boyanır.", false],
		[19, "", "Bilim insanı [[character/5]] kaçırıldığında Brent, Keith'in kurtarma planını destekler ve [[station/55]] istasyonunda EMP bombaları sağlar.", false],
		[32, "", "Ekibi, Void'lerin bir sonraki solucan deliğini nerede açacağını gösteren erken uyarı sistemini geliştirir.", false],
		[35, "", "[[character/6]] ile birlikte Void ana gemisini patlayıcı dolu bir yük gemisiyle yok etme planını tasarlar ve Vossk komutanı [[character/7]] ile anlaşmayı ayarlar.", false],
		[43, "Sonrası", "Ana gemi yok edildikten sonra Brent, [[station/98]] istasyonunda Keith ile zaferi kutlar.", false],
	],
	"character/2": [
		[2, "", "[[character/2]], [[system/15]] sistemindeki [[station/78]] istasyonunda küçük bir maden istasyonu işleten bir [[faction/2]] cevher tüccarıdır. Enkaz hâlindeki bir gemi bulur, pilotu [[character/0]] adlı adamı kurtarır ve gemiye kurtarma hakkıyla el koyar. Sert ve pratik biri olarak Keith'e, kendi elleriyle yamayıp onardığı eski gemi [[ship/0]] ile cevher kazdırarak borcunu ödetir.", false],
		[8, "", "Keith, istasyonunun yakınındaki bir korsan sığınağını yok etmesinde ona yardım edince Gunant ona saygı duymaya başlar.", false],
		[10, "", "Minnetinin işareti olarak [[ship/0]] adlı gemiyi daha iyi bir sürücüyle Keith'e verir ve onu dostu [[character/3]] ile görüşmeye gönderir. Gunant'ın kendisi de [[faction/3|Mido Konfederasyonu]] üyesidir. Kendi maden lazerlerini tasarlar ve [[agent/11]] adlı ajan olarak bunlardan birinin, [[item/90]] adlı lazerin planını satar.", false],
	],
	"character/20": [
		[32, "", "[[character/20]], Deep Science için çalışan bir [[faction/7|Grey]] bilim insanıdır. [[character/0]] ile [[station/10]] istasyonunda görüşmek ister.", false],
		[33, "", "Khador son derece kibar ve süslü bir dille konuşur. Void enkazını inceledikten sonra, yalnızca Void bölgesinde bulunan kristallerin Void'lerin solucan deliklerinin sırrını taşıdığına inanır. Bir gemiyi uzayın herhangi bir noktasına anında taşıyacak bir sürücü geliştirmek için yıllarını vermiştir ve bunun için Keith'ten 50 adet [[item/164]] toplamasını ister.", false],
		[34, "", "Keith kristalleri teslim edince Khador onu, kendi adını taşıyan sürücünün planının bir kopyasıyla ([[item/85]]) ödüllendirir.", false],
	],
	"character/3": [
		[10, "", "[[character/3]], [[faction/3|Mido Konfederasyonu'na]] katılmış ve şimdi [[station/79]] istasyonunu yöneten insan bir yüzbaşıdır. [[character/2]] onu, Terran uzayına dönmesine yardım edebilecek biri olarak Keith'e önerir.", false],
		[11, "", "Norris, Keith'i iyi karşılar ve [[system/15]] sisteminin tarihini anlatır. Keith önce [[station/76]] istasyonundaki sessizliği araştırırsa onu Terran Uzay Filosu ile temasa geçirmeyi önerir.", false],
		[13, "", "Keith'in sistemden geçen bir Terran konvoyuyla buluşmasını ayarlar ve beklerken serbest görevler almasını önerir.", false],
	],
	"character/4": [
		[12, "", "[[character/4]], Keith'in uzun zaman önce tanıdığı kötü şöhretli bir satıcıdır. Keith onu, tüm mürettebata hoş olmayan yan etkileri olan bir uyuşturucu olan nöro-alg sağladığı [[station/76]] istasyonunda bulur. Mkkt, Keith'i hatırlar ve neden yaşlanmadığını merak eder.", false],
		[13, "", "Keith'in raporunu duyan [[character/3]], onun icabına bakacağına söz verir.", false],
	],
	"character/5": [
		[18, "", "Tommy, Deep Science için çalışan bir bilim insanı olan Tğm. Thomas Boyle'dur. [[character/1]], onun [[station/56]] istasyonunda Keith ile buluşup ona kuruluşun gizli araştırma istasyonuna kadar rehberlik etmesini ayarlar.", false],
		[19, "", "Boyle, buluşmadan önce [[station/55]] yakınında korsanlar tarafından kaçırılır ve korsanlar onun için fidye ister.", false],
		[23, "", "Keith kaçıranların gemisini etkisiz hâle getirdikten sonra Boyle kurtarılır. Keith'e [[system/6]] sisteminin koordinatlarını verir ve onunla birlikte [[station/10]] istasyonuna gider.", false],
	],
	"character/6": [
		[23, "", "Dr. Paolini, [[station/10]] istasyonunda Keith ile Boyle'u bekleyen Deep Science bilim insanıdır.", false],
		[24, "", "Dr. Carla Paolini, Deep Science'ın [[faction/9|Void'ler]] üzerine yürüttüğü projeyi yönetir. Kararlı ve çalışkandır; Void'leri kendi gözleriyle görmekte ısrar ettiği için [[character/0]] ile ilk enkaz toplama görevinde birlikte uçar. Keith ilk karşılaşmalarından itibaren ondan etkilenir.", false],
		[26, "", "Keith ile birlikte bir solucan deliğinden geçerek Void'lerin ana bölgesine sürüklenir ve birlikte kıl payı kaçarlar.", false],
		[28, "", "Ekibi, Void ana gemisini analiz etmek için bir sonda yapar. Keith görevden sağ dönerse onunla randevuya çıkmayı kabul eder.", false],
		[34, "", "Araştırmaları yüzünden randevuya vakit bulamaz; [[character/1]] ile birlikte ana gemiye saldırmak için bir plan hazırlar.", false],
		[44, "Sonrası", "Zaferden sonra uzun süredir ertelenen randevu için [[station/98]] istasyonunda Keith ile Brent'e katılır.", false],
		[45, "", "Ertesi sabah bir not bırakarak gitmiştir: başka bir gizli proje için ayrıldığını yazar ve Keith'ten onu aramamasını ister.", false],
	],
	"character/7": [
		[35, "", "[[character/7]], [[system/5]] sistemindeki [[station/29]] istasyonundan sorumlu bir [[faction/1]] komutanıdır. Esirler karşılığında, Void ana gemisine yapılacak saldırı için K'Sarr yük gemisini sağlar.", false],
		[36, "", "Gururlu ve resmî biridir; bir Vossk gemisini yalnızca bir Vossk'un gereği gibi uçurabileceğine inanır ve yük gemisini bizzat uçurmakta ısrar eder. Keith'i eskort olarak kabul etmeden önce becerisini sınar.", false],
		[37, "", "Keith onu bir korsan sığınağındaki yarışmada yendikten sonra Errkt ona saygıyla davranır.", false],
		[40, "", "Görevden önce sakin ve içine kapanıktır; Brent bunu kararlılık olarak yorumlar.", false],
		[42, "Ölümü", "Errkt yük gemisini solucan deliğinden geçirip ana gemiye çarptırır. Kaçış kapsülü yok edilince geri dönmeyi reddeder ve Keith'i güvenli yere gönderip patlamada ölür.", false],
		[43, "", "Brent, onun fedakârlığını Vossk İmparatorluğu'na bildireceğine söz verir.", false],
	],
	"character/8": [
		[40, "", "Tğm. [[character/8]], Vossk yük gemisini solucan deliğine giden yolda korumak için Keith'e katılan takviye birliğine komuta eder.", false],
		[41, "", "Birliği, solucan deliği kapanmadan önce içinden geçemez; böylece Keith ile [[character/7]] Void'lerle yalnız yüzleşir.", false],
	],
	"chart": [
		[0, "", "Galaksi haritası her sistemi fraksiyonu, güvenlik derecesi, istasyon sayısı ve haritadaki konumuyla listeler. Konum, 0 ile 100 arasında iki sayıyla verilir: ilki yıldız haritasının sol kenarından, ikincisi üst kenarından sayılır. Sayıları birbirine yakın sistemler birbirine yakın konumdadır.", false],
		[0, "", "Oyunda yıldız haritasını bir istasyondan ya da uçuş sırasında açın. Kesik bir çizgi, bulunduğunuz sistemi atlama kapısının ulaştığı her sisteme bağlar; diğer kapı rotaları ince çizgiler olarak görünür. Şu anda ulaşabileceğiniz yıldızlar parlak, diğerleri soluktur. İşaretler hikâye görevinizin ve mevcut işinizin bulunduğu sistemi gösterir; kesik renkli bir çizgi de oraya giden en kısa kapı rotasını gösterir. Soluk altın rengi bir çizgi son birkaç yolculuğunuzun izini sürer.", false],
		[0, "", "Fraksiyonunu, güvenlik derecesini ve uzaklığını görmek için bir sistem seçin. İstasyonlarını, teknoloji seviyelerini ve ziyaret ettiğiniz istasyonlar, görev hedefleri ve atlama kapısı için işaretleri görmek üzere yakınlaştırın. Gizli sistemler, koordinatlarını öğrenene kadar görünmez; bkz. [[world/galaxy]].", false],
		[32, "", "[[step/31]] sırasında erken uyarı sistemini edindiğinizde yıldız haritası, bir sonraki Void solucan deliğinin açılacağı sistemi ve istasyonu da işaretler.", false],
	],
	"faction/0": [
		[0, "", "Terranlar insandır ve [[character/0]] de onlardan biridir. Diğer tüm fraksiyonlardan fazla olan on sisteme sahiptirler; bu sistemler haritanın ortasına, sağ tarafına ve alt kısmına yayılmıştır ve merkezlerinde [[system/19]] ile [[system/14]] bulunur. Terran uzayı galaksinin en güvenli bölümüdür: iki \"Safe\" (Güvenli) sistemin ikisi de Terran'dır.", false],
		[0, "", "Terran istasyonları en geniş gemi ve donanım yelpazesini satar. Vossk uzayı dışındaki gemi satıcıları geniş bir gövde yelpazesi sunar. Terranların geleneksel rakipleri [[faction/1]] fraksiyonudur: birinde kazanılan itibar diğerinde kaybedilir.", false],
		[16, "", "Terran Uzay Filosu hâlâ [[character/0]] adlı pilotun bir zamanlar hizmet ettiği güçtür, ama 35 yıl geçmiştir. Sonunda bir Terran konvoyuyla karşılaştığında konvoy, korsan yapımı eski gemisini düşman sanır ve onu tutuklar.", false],
		[18, "", "Void'lere karşı savunmaya Terranlar önderlik eder. Artık Yıldızlararası Güvenlik Ajansı'nın başında olan [[character/1]] bir kriz ekibine başkanlık eder ve araştırma grubu Deep Science soruna gizli bir istasyondan eğilir.", false],
	],
	"faction/1": [
		[0, "", "Vossklar, bir imparatorluk olarak örgütlenmiş uzaylı bir halktır. Haritanın sağ altında, [[system/3]] ve [[system/12]] sistemlerinden ücra [[system/21]] sistemine kadar uzanan altı sisteme sahiptirler. Bunların dördü \"Dangerous\" (Tehlikeli) ya da \"Risky\" (Riskli) olarak derecelendirilmiştir. [[system/10]] sisteminin hiç kapı bağlantısı yoktur.", false],
		[0, "", "Vossk gemi satıcıları yalnızca tek bir gövde satar: diğer ırklara uyarlanmış bir model olan [[ship/9]]. Vossk istasyonları ayrıca başka hiçbir yerde bulunmayan silah ve donanımlar da satar. Vossklar [[faction/0|Terranların]] geleneksel rakipleridir; bu yüzden gemileri Terran uzayındaki baskıncılara katılabilir, tersi de geçerlidir.", false],
		[18, "", "Terranlar ile Vossk İmparatorluğu arasındaki ilişkiler soğuk ve öngörülemez olmayı sürdürür, ama Void baskınları Vossk sistemlerini de vurur.", false],
		[36, "", "Hikâyede Vossklar gururlu ve onura bağlı bir halk olarak görünür. Komutanları [[character/7]], bomba taşıyıcısını bizzat uçurmakta ısrar eder ve [[character/0]] adlı pilotu eskort olarak kabul etmeden önce bir yarışmayla sınar.", false],
		[42, "", "[[character/7]], Void ana gemisini yok etmek için hayatını feda eder; Terranlar da bu eylemi Vossk İmparatorluğu'na bildireceklerine söz verir.", false],
	],
	"faction/2": [
		[0, "", "Nivelianlar, haritanın sol tarafında dört sisteme sahip uzaylı bir halktır: [[system/2]], [[system/9]], [[system/17]] ve gizli [[system/0]]. İstasyonları küçük karakollardan galaksinin en gelişmişleri arasındakilere kadar uzanır. Rakipleri [[faction/3|Midorianlardır]].", false],
		[2, "", "[[character/0]] adlı pilotun karşılaştığı ilk kişi bir Nivelian'dır: cevher tüccarı [[character/2]]. [[character/0]] Nivelian görgü kurallarını pek beğenmez; [[character/2]] ise dürüst bir iş insanı olduğunda ısrar eder.", false],
		[11, "", "Bir Nivelian iç savaşı [[faction/3|Mido Konfederasyonu'nun]] doğmasına yol açtı. Nivelianlar onun bağımsızlığını hiçbir zaman kabul etmedi ve [[system/15]] sisteminde hâlâ hak iddia ederler.", false],
		[35, "", "Void ana gemisine karşı plan, Nivelian nükleer patlayıcılarına dayanır.", false],
	],
	"faction/3": [
		[0, "", "Midorianlar, [[faction/3|Mido Konfederasyonu'nun]] halkıdır. Haritanın sol üst kısmında, her ikisi de \"Dangerous\" (Tehlikeli) olarak derecelendirilmiş iki sisteme sahiptirler: [[system/15]] ve [[system/4]]. İstasyonları çoğunlukla küçük ve düşük teknolojilidir. Rakipleri [[faction/2|Nivelianlardır]].", false],
		[11, "", "Konfederasyon, Nivelian İç Savaşı sırasında Terran ve Nivelian mülteciler ile kanun kaçakları tarafından kuruldu. Diğer sistemlerle teması en aza indirir. [[station/79]] istasyonunun komutanı [[character/3]] onun üyelerinden biridir; [[character/2]] de öyle.", false],
		[38, "", "Konfederasyon Nivelianların dostu değildir. Gemileri, Void ana gemisi için ayrılmış Nivelian patlayıcılarını taşıyan konvoyu ele geçirir ve [[character/0]] onu [[station/22]] yakınında geri almak zorunda kalır.", false],
	],
	"faction/4": [
		[0, "", "Multipodlar, kendi sistemleri olmayan küçük bir ırktır. Karşılaştığınız tek Multipod, [[system/12]] sistemindeki [[station/61]] istasyonunun salonunda bir plan satan ajan [[agent/6]] olur.", false],
	],
	"faction/5": [
		[0, "", "Cyborgların toprağı yoktur. Oyundaki tek Cyborg, [[station/65]] istasyonunun salonunda gizli bir sistemin koordinatlarını satan ajan [[agent/14]] olur.", false],
	],
	"faction/6": [
		[0, "", "Bobolianlar, kendi sistemleri olmayan küçük bir ırktır. Bir Bobolian olan ajan [[agent/13]], Vossk uzayındaki [[station/26]] istasyonunun salonunda oturur ve gizli bir sistemin koordinatlarını satar.", false],
	],
	"faction/7": [
		[0, "", "Grey'ler, kendi sistemleri, istasyonları ya da gemileri olmayan bir ırktır. Ticarette ya da savaşta hiçbir rol oynamazlar.", false],
		[32, "", "Hikâyedeki tek Grey, Deep Science ile çalışan bir bilim insanı olan [[character/20]] adlı karakterdir; bkz. [[world/khador]].", false],
		[33, "", "Void gemilerinin kalıntılarını inceler ve onlardan yeni türde bir sürücü geliştirir.", false],
	],
	"faction/8": [
		[0, "", "Korsanlar her ırktan kanun kaçaklarıdır. Hiçbir sisteme sahip değildirler, ama her yerde ortaya çıkarlar ve her zaman düşmandırlar. Bir istasyonun yakınında ne sıklıkla pusuda beklediklerini sistemin güvenlik derecesi belirler. Pek çok serbest görev onları avlamanızı ister ve enkazlarından kargo yağmalanabilir.", false],
		[0, "", "Hikâye, [[character/0]] adlı pilotun başlarına konan ödül için bir korsan çetesini kovalamasıyla başlar.", false],
		[2, "", "[[ship/0]], yani [[character/2]] adlı tüccarın [[character/0]] adlı pilota ödünç verdiği gemi, bir zamanlar bir korsan gemisiydi.", false],
		[16, "", "Terranların daha sonra onu korsan sanmasının nedeni budur.", false],
		[19, "", "Korsanlar ayrıca [[station/55]] yakınında [[character/5]] adlı bilim insanını kaçırır ve fidye ister.", false],
	],
	"faction/9": [
		[0, "", "Void'ler uyarmadan saldıran düşmanca bir güçtür. Haritada hiçbir sisteme sahip değildirler ve gemileri herkese ateş açar. Avcı gemileri [[ship/8]], oyundaki en ağır zırhlı gövdedir. Bkz. [[world/voids]].", false],
		[2, "", "[[system/15]] sisteminde Void'ler yalnızca söylentilerden ve nadir görülmelerden bilinir.", false],
		[16, "", "[[character/0]] oradayken bir Void filosu [[station/98]] istasyonuna saldırır. Ateş ederken telsiz mesajlarında barışçıl niyetler taşıdıklarını iddia ederler.", false],
		[18, "", "Void'ler istasyonların yakınında kısa bir süreliğine açılan solucan deliklerinden gelir. Terran, Nivelian ve Vossk sistemlerine aynı şekilde baskın düzenler ve cevher peşinde gibi görünürler. Nereden geldiklerini kimse bilmez.", false],
		[24, "", "[[station/48]] yakınında daha da tuhaf bir iddia yayınlarlar: gelecekten geldiklerini ve galaksideki uygarlıklardan geriye kalan tek şey olduklarını.", false],
		[26, "", "Bir solucan deliği, devasa bir ana geminin avcı gemilerini fırlattığı kendi bölgelerine açılır.", false],
		[35, "", "Ana gemi, solucan deliklerinin kaynağı gibi görünmektedir.", false],
		[42, "", "[[step/41]] sırasında ana geminin yok edilmesi solucan deliklerini çökertir ve baskınlara, en azından şimdilik, son verir.", false],
	],
	"guide/basics": [
		[0, "Açılış", "Yeni bir oyun bir istasyonda değil, uzayda başlar. [[character/0]] bir asteroit alanında bir korsan çetesini kovalamaktadır ve ilk uçuş; yönlendirmeyi, nişan almayı ve ateş etmeyi öğreten kısa bir çatışmadır. Bu bölüm sürerken yalnızca nişangâh ve gemi işaretleri gösterilir. Korsanları yok edin ve sahnenin akmasına izin verin; ardından hikâye kendiliğinden ilerler.", false],
		[2, "", "Açılıştan sonra [[character/2]] adlı tüccarın işlettiği küçük bir maden istasyonu olan [[station/78]] istasyonunda uyanırsınız. Size maden lazerli, silahsız bir gemi olan [[ship/0]] gemisini ödünç verir; ilk adımlar madenciliği, otopilotu ve kenetlenmeyi öğretir. Silahlar, harita ve istasyonun geri kalanı hikâye ilerledikçe açılır.", false],
		[0, "Kenetlenme", "Kenetlenmek için nişangâhı kilitlenene kadar bir istasyonun üzerinde tutun, sonra Ateş'e basın: otopilot devralır ve sizi içeri uçurur. İstasyona kendiniz de uçabilirsiniz; gemi gövdeye değdiği anda kenetlenir. Hesap kitap işlerinin çoğu kenetlenince yapılır. Gövdeniz, zırhınız ve kalkanlarınız ücretsiz olarak onarılır, teslimatlar ve yolcular teslim edilir, biten plan ürünleri alınır, yeni madalyalar verilir ve oyun kendini kaydeder.", false],
		[0, "İstasyon ekranları", "Kenetlenilen bir istasyon altı bölüm sunar: \"Hangar\" (Hangar), Uzay Salonu, \"Map\" (Harita), \"Missions\" (Görevler), \"Status\" (Durum) ve \"Game Options\" (Oyun Seçenekleri). Hikâyenin başında bazıları kilitlidir ve bir asma kilitle gösterilir. \"Hangar\" [[step/5]] ile, \"Map\" [[step/9]] ile, Uzay Salonu ve \"Missions\" ise [[step/13]] ile açılır. \"Status\" ve \"Game Options\" her zaman kullanılabilir.", false],
		[0, "", "\"Hangar\" bölümünde \"Shop\" (Dükkân; mal ve donanım alıp satma), \"Ship\" (Gemi; donanım takma ve sökme), \"Ships\" (Gemiler; gemi satıcısı olan istasyonlarda gövde satıcısı) ve \"Blueprints\" (Planlar; üretim) bulunur. Uzay Salonu; müşterilerin, tüccarların ve kiralık pilotların beklediği yerdir. \"Map\" galaksiyi gösterir ve bir hedef seçmenizi sağlar. \"Missions\", mevcut hikâye hedefini ve aldığınız serbest görevi listeler. \"Status\"; pilot kaydınızı, dört büyük ırktaki itibarınızı ve madalyalarınızı gösterir. Üst çubuk, istasyonun dükkânında ne bulunabileceğini belirleyen \"Tec Level\" (teknoloji seviyesi) değerini gösterir.", false],
		[0, "İstasyondan ayrılmak", "Kalkış için \"Depart\" (Ayrıl) düğmesine basın. Her uçuş, geminizin ayrılışını izlediğiniz birkaç saniyeyle açılır; bu sırada sistemin ayrıntıları ve bir ipucu gösterilir. Herhangi bir tuş, tıklama ya da dokunuş bu bölümü geçer. Ayrılmadan önce \"Map\" ekranında bir hedef seçtiyseniz otopilot, kalkış biter bitmez rotayı oraya çizer. Ambarın taşıyabileceğinden fazla kargoyla ayrılamazsınız; bu yüzden fazlasını önce satın ya da takın.", false],
		[0, "Kayıt", "Oyun, ödüller ve bir sonraki hikâye adımı belirlendikten sonra, tamamlanan her kenetlenmenin ardından otomatik olarak kaydeder. Kenetliyken \"Game Options\" ekranından üç yuvadan birine elle de kaydedebilir, herhangi bir yuvayı ya da otomatik kaydı oradan veya başlık ekranından yükleyebilirsiniz. Tarayıcı sürümü dışında \"Game Options\" bir kaydı dosyaya dışa aktarabilir ve yeniden içe aktarabilir. Kayıtlar, oluşturuldukları oyun verilerine aittir.", false],
		[0, "", "Geminiz yok edilirse uçuş sona erer ve son otomatik kaydınızın istasyonundan devam edersiniz; hiç kayıt yoksa baştan başlarsınız. O kenetlenmeden bu yana kazanılan her şey kaybolur; bu yüzden uzun yolculuklarda ara sıra kenetlenin.", false],
		[0, "Pilot seviyesi", "Pilotunuzun \"Status\" ekranında gösterilen bir seviyesi vardır. Deneyim; düşürülen gemilerden, serbest görevlerden (her biri iki puan), kazılan çekirdeklerden, kazılan her elli ton cevherden ve kiralanan her iki kanat pilotundan gelir. Deneyim, son yükselişteki değerin 1,3 katını aştığında seviye bir artar ve bu, kenetlendiğinizde denetlenir. Daha yüksek seviye düşmanları zorlaştırır, ama serbest görev ödüllerini ve kiralık pilotların ücretlerini de artırır.", false],
	],
	"guide/blueprints": [
		[0, "Planlar", "En iyi silah ve donanımların bazıları dükkânlarda asla satılmaz. Bunun yerine planlardan üretilirler. Bir plan, gereken malları ve miktarlarını listeler. Planlar, hikâyede [[step/16]] geride kaldıktan sonra ortaya çıkan, Uzay Salonu'ndaki adı olan ajanlardan satın alınır; her ajan bir planı, bir kez satar.", false],
		[34, "", "[[item/85]] atlama motorunun planını kimse satmaz: hikâye onu [[step/34]] sırasında verir.", false],
		[0, "Üretim", "Üretim, \"Hangar\" (Hangar) bölümünün \"Blueprints\" (Planlar) sekmesinde yapılır. Bir plan seçin ve ambarınızdan bileşenleri teslim edin. Bunları birkaç ziyarette parça parça teslim edebilirsiniz. İlk teslimatı yaptığınız istasyon o partinin üretim istasyonu olur. Başka herhangi bir istasyonda teslim edilen bileşenler oraya ton başına 10 krediye gönderilir; bu yüzden her şeyi aynı yere getirmek kazançlıdır.", false],
		[0, "Biten ürünler", "Son bileşen de teslim edildiğinde parti tamamlanır. İkincil silahlar onar onar, diğer her şey birer birer üretilir. Üretim istasyonunda bitirirseniz ürünler, ambarı taşırsa bile doğrudan ambarınıza gider. Aksi hâlde üretim istasyonunda bekler ve oraya bir sonraki kenetlenişinizde teslim edilir. Bir plan asla tükenmez: bir parti bittiğinde bir sonrakine başlayabilirsiniz.", false],
		[0, "Madalyalar", "Planlara sahip olmak [[medal/13]] için, farklı planları tamamlamak ise [[medal/14]] için sayılır.", false],
	],
	"guide/combat": [
		[0, "Birincil silahlar", "Birincil silahlar ileriye ateş edecek şekilde sabitlenmiş toplardır: lazerler, blasterlar, otomatik toplar ve termo silahlar. Her birinin kendi hasarı, atış hızı, menzili ve mermi hızı vardır ve takılı tüm birincil silahlar birlikte ateş eder. [[item/16]] gibi bazı blasterlar, bir geminin gövdesi yerine enerjisini tüketen EMP silahlarıdır. Otomatik ateş, düğmeyi basılı tutmadan silahların hedefe ateş etmeyi sürdürmesini sağlar.", false],
		[0, "Kalkanlar, zırh ve gövde", "Hasar önce kalkanı, sonra zırh plakasını ve ancak ondan sonra gövdenin kendisini tüketir. Kalkan dolum süresi boyunca tamamen yenilenir; zırh ve gövde yenilenmez. Bir onarım robotu uçuş sırasında hem gövdeyi hem zırhı yavaşça onarır. Kenetlenme her şeyi ücretsiz olarak onarır. Gövde tükendiğinde gemi yok olur.", false],
		[0, "EMP", "Her geminin bir enerji deposu vardır. EMP silahları bu enerjiyi tüketir ve enerjisi biten bir gemi etkisiz hâle gelir: enerji yeniden birikene kadar çaresizce sürüklenir. Etkisiz hâle gelmiş bir geminin kargosu bir çekici ışınla alınabilir ve bazı görevler bir geminin yok edilmesini değil etkisiz hâle getirilmesini ister. [[item/60]] gibi EMP koruma donanımları bir EMP savunma değeri taşır.", false],
		[0, "İkincil silahlar", "İkincil silahlar ikincil yuvalardan ateşlenir ve yuvada yığılan cephaneyi tüketir. Roketler düz uçar. Torpidolar fırlatıldıktan kısa süre sonra radar kilidinin peşinden döner. EMP bombaları ve nükleer bombalar bir alan üzerinde patlar ve etki alanındaki her şeyi, kenara doğru daha zayıf olmak üzere vurur; EMP bombaları asteroitlere dokunmaz, nükleer bombalar ise onları parçalar. Hangi fırlatıcının kullanılacağını Eylemler menüsünden seçin; seçene kadar İkincil silah tuşu ilk dolu fırlatıcıyı ateşler.", false],
		[0, "Taretler", "Büyük gövdelerin taret yuvaları vardır. Bir taret takılıyken Arka görüş tuşu taret görünümüne geçer: siz tareti çevirip ateşlerken gemi rotasını korur; bu da peşinizdeki gemilere karşılık vermenizi sağlar.", false],
		[0, "Kanat pilotları", "[[step/16]] itibarıyla Uzay Salonu'nda kiralık pilotlarla karşılaşabilirsiniz. Bir sözleşme, on dakikalık uçuş için bir ile üç gemiyi kapsar ve süre dolana kadar nereye giderseniz gidin sizinle uçarlar. Onlara Eylemler menüsünden emir verin: serbest ateş, hedefinize saldırı, bir sonraki görev ara noktasını güvenceye alma ya da lazer ile EMP blaster arasında geçiş. Bkz. [[guide/lounge]].", false],
		[0, "Korsanlar", "Korsanlar istasyonlara, tehlikeli sistemlerde daha sık olmak üzere baskın düzenler ve yük ya da yolcu taşıyan pilotları pusuda bekler. Pek çok serbest görev onlarla savaşmak üzerinedir. Korsanlara ateş etmek kimseyi kızdırmaz; sistemi yöneten ırktaki itibarınızı biraz artırır.", false],
		[0, "İtibar", "İtibarınız, her biri -100 ile 100 arasında olan iki ölçekte tutulur: biri [[faction/0]] ve [[faction/1]] ırkları arasında, diğeri [[faction/2]] ve [[faction/3]] ırkları arasında. Bir ırka haksızlık etmek ölçeği rakibine doğru kaydırır: gemilerinden birini etkisiz hâle getirmek ya da soymak 2 puana, birini yok etmek 5 puana mal olur. Bir serbest görevi tamamlamak ölçeği müşterinin ırkına doğru 2 puan kaydırır. Bir ölçek herhangi bir yönde 60'ı geçtiğinde kaybeden taraftaki ırk düşman olur ve gemileri sizi görür görmez saldırır.", false],
		[0, "", "Düşman olan bir ırk Uzay Salonlarına bir diplomat gönderir; diplomat, ölçeği ne kadar kaydığına göre artan bir ücret karşılığında sıfıra döndürmeyi önerir: en fazla 16.000 kredi. \"Status\" (Durum) ekranı iki ölçeği de gösterir. Bir ölçeği 60'ın ötesine taşımak ayrıca [[medal/28]] kazandırır.", false],
		[0, "Dost ateşi", "Bir sistemin kendi ırkının gemileri başıboş atışlara ancak bir yere kadar katlanır. Yerel bir geminin gövdesinin ya da enerjisinin üçte birini götürdüğünüzde karşılık verir ve sizi telsizden uyarır. Gövdesinin üçte ikisinde ya da onu etkisiz hâle getirdiğinizde, sistemdeki o ırka ait her gemi size döner. Diğer ırkların gemileri daha az alıngandır, ama bir gemiyi yok etmek her zaman itibara mal olur.", false],
	],
	"guide/fitting": [
		[0, "Gövdeler", "Bir geminin gövdesi; zırhını (gövdenin kendi dayanıklılığı), kargo ambarını, manevra kabiliyetini ve yuvalarını belirler: birincil silahlar, ikincil silahlar, taretler ve donanım. Daha iyi bir gövde çoğunlukla daha fazla yuva demektir. Gemi sayfaları tüm gövdeleri karşılaştırır.", false],
		[0, "Yuvalar ve \"Ship\" ekranı", "Eşyalar satın alınınca ambara gelir, ardından \"Hangar\" (Hangar) bölümündeki \"Ship\" (Gemi) ekranında takılır. Her yuva kendi kategorisinden bir eşya alır; dolu bir yuvaya takmak eski eşyayı ambara geri koyar. Donanım her türden yalnızca bir kez takılabilir; kargo sıkıştırma birimleri, kabinler ve EMP koruması gibi yığılan türler ise istisnadır: bunlardan her biri kendi yuvasında olmak üzere birkaç tane takılabilir. Aynı türden ikincil cephane tek bir yuvayı paylaşır. Takılı bir eşya, istasyonun fiyatından doğrudan yuvasından da satılabilir.", false],
		[0, "Donanım türleri", "Kalkanlar hasarı emer ve yeniden dolar. Zırh plakaları gövdenin dayanıklılığını artırır. EMP koruması enerji tükenmesine karşı korur. Kargo sıkıştırma ambarı büyütür. Çekici ışınlar enkazlardan ve etkisiz hâle getirilmiş gemilerden kargo çeker; çekici ışın olmadan uzayda hiçbir şey toplanamaz. Takviyeler ani hız sağlar. Onarım robotları gemiyi uçuşta onarır. Yönlendirme memeleri manevra kabiliyetini artırır. Tarayıcılar bir hedefe kilitlenme süresini kısaltır; iyileri bir hedefin kargosunu da gösterir. Maden lazerleri asteroitleri deler. Kabinler yolcu taşır. Gizlenme cihazları gemiyi bir süreliğine gizler. Bir atlama motoru kapı kullanmadan yolculuk eder.", false],
		[0, "Gövde satın almak", "Satıcısı olan istasyonlar \"Hangar\" bölümünde, satışta en fazla beş gövdenin bulunduğu bir \"Ships\" (Gemiler) sekmesi gösterir. [[faction/1]] satıcıları yalnızca kendi ırklarının gövdesini, [[ship/9]] gemisini sunar. Bir satıcı, liste fiyatından istasyonunun \"Tec Level\" (teknoloji seviyesi) değeri kadar yüzde indirim yapar; bu yüzden yüksek teknolojili istasyonlar gövdeleri daha ucuza satar. Eski gövdeniz, liste fiyatının beşte dördü karşılığında takasa alınır. Takılı her şey ambara taşınır; bu yüzden ayrılmadan önce sığdığını kontrol edin ya da bir kısmını satın. Gemide yolcu varken gövde değiştiremezsiniz ve kullanımdaki kabinler sökülemez.", false],
		[5, "İlk silahlar", "[[station/78]] istasyonundaki hangar ilk açıldığında rafında ücretsiz bir lazer, bir otomatik top ve bir zırh plakası bulunur. Bir sonraki göreve çıkmadan önce bir silah ve plakayı takın.", false],
		[0, "Nadir gövdeler", "Bazı gövdeleri sıradan satıcılar asla sunmaz. Tüm madalyaları altın olarak kazanmış bir pilota [[station/10]] istasyonunda bir prototip, [[ship/8]], sunulur; bkz. [[guide/medals]].", false],
	],
	"guide/flight": [
		[0, "Yönlendirme", "Gemi her zaman ileri uçar. Onu sola ve sağa döndürür, burnunu yukarı ve aşağı eğersiniz; bıraktığınızda kanatlarını kendiliğinden düzeltir. Ne kadar hızlı döndüğü, gövdenin manevra kabiliyetine ve takılı bir yönlendirme memesine bağlıdır. \"Options\" (Seçenekler) > Kontroller altında Dümen tepkisi, hemen tam hızla dönen Doğrudan ya da dönüşlere yumuşakça girip çıkan Yumuşak olarak ayarlanabilir. Fareyle yönlendirmede sol ve sağ tuşlar gemiyi döndürmek yerine yana kaydırabilir.", false],
		[0, "Gaz", "İtkiyi artır ve İtkiyi azalt, gazı çeyrek adımlarla değiştirir; tuşu basılı tutmak adım atmayı sürdürür. Geminin yeni hıza oturması yaklaşık bir saniye sürer. Otopilot ve takviye her zaman tam gazla uçar; takviye sırasında gazı azaltmak takviyeyi bitirir.", false],
		[0, "Takviye", "Bir takviye takılıysa Takviye tuşu ani bir ek hız sağlar. Bir patlama takviyenin süresi boyunca sürer ve ardından bir sonrakinden önce bir dolum süresi gelir; HUD hazır olup olmadığını gösterir. Daha iyi takviyeler daha hızlıdır, daha uzun sürer ya da daha çabuk dolar. Takviye, bir çatışmadan kaçmak ve bir sistemin içindeki uzun mesafeleri aşmak için kullanışlıdır.", false],
		[0, "Otopilot", "Otopilot tuşu dümeni geminin bilgisayarına devreder; tuşa yeniden basmak dümeni geri alır. Kilitli olan şeye, yoksa \"Map\" (Harita) ekranında seçilen hedefe uçar: hedef başka bir sistemdeyse atlama kapısına, bu sistemdeyse hedefin gezegenine. Otopilot listesi bulunduğunuz yerde var olan seçenekleri sunar: programlanmış hedef, atlama kapısı, bu istasyon, asteroit alanı ve bir sonraki görev ara noktası. Kilitli bir istasyona uçuş kenetlenmeyle biter.", false],
		[0, "Zaman hızı", "Zaman hızı tuşu uçuşu hızlandırır. Uçarken iki kat hız her zaman kullanılabilir. Dört ve sekiz kat yalnızca otopilot uçarken, yakında düşman yokken ve madencilik, kenetlenme ya da atlama gibi başka bir şey sürmüyorken sunulur.", false],
		[0, "Hedefleme", "Bir nesneye kilitlenmek için tarama tamamlanana kadar onu nişangâhın altında tutun. Bunun ne kadar süreceğini takılı tarayıcı belirler: basit bir modelle birkaç saniye, en iyisiyle iki saniyenin altında. Sonraki hedef, nişan almadan yakındaki nesneler arasında geçiş yapar. İstasyonlar, atlama kapıları ve diğer gezegenleri işaretleyen yıldızlar tek basışta kilitlenir. Ateş'in ne yapacağı kilide bağlıdır: bir gemide ateş eder, bir istasyonda kenetlenir, bir kapıda atlar, bir yıldızda o gezegene yolculuk eder ve bir asteroitte kazıyı başlatır. Daha iyi tarayıcılar kilitli bir geminin kargosunu da gösterir.", false],
		[0, "İşaretler ve radar", "Gemilerin ekranda çerçeveleri vardır; ekranın kenarındaki oklar da görüş dışında kalan hedefi, istasyonu ve yakındaki tehditleri gösterir. Düşmanlar kırmızı, dostlar yeşil, tarafsız gemiler sarı ve görev ara noktaları mavi ile işaretlenir; \"Options\" > Arayüz altındaki renk körü seçeneği bunları turuncu düşmanlar ve mavi dostlarla değiştirir. Size yakın bir gemi, çerçevesinin yanında iki küçük çubuk gösterir: gövdesi ve mavi renkle EMP enerjisi. Genişletilmiş uçuş göstergesi kesin değerleri gösteren paneller ve yuvarlak bir radar ekranı ekler; Orijinal gösterge oyunun kendi köşe panellerini korur.", false],
		[0, "Etrafa bakmak", "Arka görüş, kamerayı geminin arkasına çevirir. Bir taret takılıysa aynı tuş bunun yerine taret görünümüne geçer: siz tareti çevirip ateşlerken gemi rotasını korur. Alt tuşunu basılı tutup fareyi hareket ettirerek, oyun kumandasının sağ çubuğuyla ya da boş ekran alanında parmağınızı sürükleyerek yönlendirmeden geminin etrafına da bakabilirsiniz.", false],
		[0, "Gizlenme", "Bir gizlenme cihazı, süresi boyunca geminizi diğer gemilerden gizler ve sizi avlayan herkes izinizi hemen kaybeder. Erken kapatmak için Gizlenme cihazı tuşuna yeniden basın. Kullanımdan sonra yeniden çalışmadan önce dolması için zaman gerekir.", false],
		[0, "Kenetlenme ve yolculuk", "Kenetlenmek için istasyona kilitlenip Ateş'e basın ya da doğrudan içine uçun. Sistemin diğer istasyonları parlak yıldızlar olarak görünür; o gezegene yolculuk etmek için birine kilitlenip Ateş'e basın. Çoğu sistemin, diğer sistemlere yolculuk için istasyonlarından birinin yakınında bir atlama kapısı vardır; bkz. [[guide/navigation]]. Bir istasyonda serbest görev çatışması sürerken, çatışma kazanılana ya da kaybedilene kadar kenetlenemez, yolculuk edemez ya da atlayıp gidemezsiniz.", false],
	],
	"guide/help": [
		[0, "Klavye", "Bunlar varsayılan tuşlardır. Tüm uçuş eylemleri \"Options\" (Seçenekler) > Kontroller > Klavye altında yeniden atanabilir; orada Varsayılan tuşları geri yükle değişiklikleri geri alır.", false],
		[0, "", "Sola dön / Sağa dön: Sol ve Sağ ok tuşları ya da A ve D.", true],
		[0, "", "Burun yukarı / Burun aşağı: Yukarı ve Aşağı ok tuşları.", true],
		[0, "", "İtkiyi artır / İtkiyi azalt: W ve S.", true],
		[0, "", "Ateş / kullan: Boşluk ya da Ctrl. Silahları ateşler; bir istasyon, kapı, yıldız ya da asteroit kilitliyken kenetlenir, atlar, yolculuk eder ya da kazı yapar.", true],
		[0, "", "İkincil silah: E.", true],
		[0, "", "Takviye: Shift.", true],
		[0, "", "Otopilot: Q. Otopilot listesi: R. Liste için otopilotu basılı tut açıkken Q'yu yarım saniye basılı tutmak listeyi açar.", true],
		[0, "", "Sonraki hedef: Tab.", true],
		[0, "", "Otomatik ateş: F.", true],
		[0, "", "Arka görüş: C. Bir taret takılıyken taret görünümüne geçer.", true],
		[0, "", "Eylemler / atlama motoru: M. Eylemler menüsünü açar: ikincil silah seçimi, gizlenme, kanat pilotu emirleri ve atlama motoru.", true],
		[0, "", "Rota haritası: N.", true],
		[0, "", "Gizlenme cihazı: V.", true],
		[0, "", "Zaman hızı: T.", true],
		[0, "", "Fotoğraf modu: P. Uçuşu dondurur ve arayüzü gizler; kamerayı çevirmek için sürükleyin ya da ok tuşlarını kullanın, yakınlaştırmak için tekerleği ya da + ve - tuşlarını kullanın.", true],
		[0, "", "Duraklatma menüsü: Escape. Masaüstü sistemlerde F11 tam ekrana geçer.", true],
		[0, "", "Menülerde ok tuşları girişler arasında gezinir, Enter seçer ve Escape geri döner.", true],
		[0, "Fare", "Fareyle yönlendirme açıkken fareyi hareket ettirmek gemiyi yönlendirir. Uçuş sırasında imleç yakalanır; böylece gemi siz fareyi hareket ettirdikçe döner. Uçuşta imleci yakala kapatılabilir; menüler ve duraklatmalar imleci her zaman serbest bırakır. Sol düğme ateş eder, sağ düğme ikincil silahı fırlatır ve fareyi hareket ettirirken Alt tuşunu basılı tutmak geminin etrafına bakmanızı sağlar. Fare yönlendirirken sol ve sağ tuşlar gemiyi yana kaydırır; \"Options\" > Kontroller altındaki Sol / sağ tuşlar ayarı onları her zaman yana kaydıracak ya da her zaman döndürecek şekilde ayarlayabilir. Fare hassasiyeti, bir hareket için geminin ne kadar döneceğini belirler.", false],
		[0, "Oyun kumandası", "Sol çubuk yönlendirir, sağ çubuk geminin etrafına bakar. RT ya da RB ateş eder, LB ikincil silahı fırlatır, A takviye verir, Y otopilotu açıp kapatır, X sonraki hedefi seçer, sağ çubuğa basmak arka ya da taret görünümünü verir, Back Eylemler menüsünü açar ve Start duraklatır. Menülerde D-pad gezinir, A seçer ve B geri döner. \"Options\" > Kontroller > Oyun kumandası, çubuk ölü bölgesini ve titreşimi ayarlar.", false],
		[0, "Dokunmatik", "Dokunmatik ekranlarda Dokunmatik kontroller Otomatik ya da Açık olarak ayarlandığında kontroller ekranda görünür. Bir taraftaki çubuk yönlendirir; varsayılan olarak o tarafta başparmağınızın değdiği yere gelir, Sabit çubuk ise onu yerinde tutar. Her yerden yönlendir, ekranın boş herhangi bir yerindeki bir parmağın yönlendirmesini sağlar. Diğer taraftaki düğmeler Ateş / kullan, İkincil, Takviye, Otopilot, Hedef, Arka görüş, Eylemler, Duraklat ve telsiz mesajları sırasında Sonraki radyo işlevlerini karşılar. Bir kaydırıcı gazı ayarlar, Daha hızlı düğmesi ise zamanı hızlandırır.", false],
		[0, "", "Otomatik ateşi açmak için Ateş'e hızlıca iki kez dokunun; tek dokunuş onu durdurur. Boş ekran alanında parmak sürüklemek geminin etrafına bakar, bırakınca yeniden ileri bakılır. Solak düzeni tarafları değiştirir, Dokunmatik kontrol boyutu kontrolleri ölçeklendirir ve Kontrol yerleşimini ayarla her birini taşımanızı sağlar. Telefonlar ve tabletler eğerek de yönlendirebilir: Eğerek yönlendir'i açın, cihazı oynarken tuttuğunuz gibi tutun ve kalibre edin.", false],
		[0, "Seçenekler", "\"Options\" ekranına başlık ekranından, duraklatma menüsünden ve bir istasyondaki \"Game Options\" (Oyun Seçenekleri) bölümünden ulaşılır. Beş sayfası vardır. Ses, müzik ve efekt ses düzeyini ayarlar. Ekran; pencereyi, kare hızını, en-boy oranını, grafik ön ayarlarını ve ayrıntıları kapsar. Kontroller; yönlendirmeyi, fareyi, oyun kumandasını, dokunmatik kontrolleri ve klavye atamalarını kapsar. Arayüz; arayüz boyutunu, Orijinal ya da Genişletilmiş uçuş göstergesini, HUD boyutunu ve opaklığını, yardım pencerelerini, kalkış ve istasyona giriş sekanslarını, radar ekranını, etiketleri, metin boyutunu ve renk körü dostu renkler, yanıp sönmeyi azaltma, ekran sarsıntısı ve mesaj süresi gibi erişilebilirlik ayarlarını kapsar. Oyun, motor dilini ayarlar ve başka bir oyun dosyasını içe aktarmanızı ya da modları yönetmenizi sağlar.", false],
		[0, "Yardım", "Aynı yerlerden ulaşılan \"Help\" (Yardım) ekranı; oyunun kendi yardım konularını ve yükleme ipuçlarını, mevcut tuş atamalarının bir listesini ve oyun metinlerinde adı geçen telefon tuşlarını burada kullanılan tuşlara, düğmelere ve dokunmatik kontrollere çeviren bir tabloyu gösterir.", false],
	],
	"guide/jobs": [
		[0, "İş bulmak", "Serbest görevleri Uzay Salonu'ndaki konuklar sunar. Müşteri işi ve ödemeyi anlatır. Başka bir yerdeki bir görevi kabul etmeden önce nerede olduğunu ve ne kadar zor olacağını sorabilirsiniz; teklifi yeniden dinlemek isteyebilir ya da geri çevirebilirsiniz. Aynı anda yalnızca bir görev üstlenebilirsiniz; \"Missions\" (Görevler) ekranı onu hedefiyle ve kaç kapı atlaması uzakta olduğuyla gösterir.", false],
		[0, "Görev türleri", "On üç tür vardır. [[step/16]] öncesinde ve tam kampanyayı içermeyen oyun kopyalarında yalnızca beşi sunulur: [[job/11]], [[job/0]], [[job/7]], [[job/4]] ve [[job/12]]. Sonrasında tüm yelpaze ortaya çıkar: [[job/1]], [[job/2]], [[job/3]], [[job/5]], [[job/6]], [[job/9]] ve [[job/10]], ayrıca mal isteyen alıcılar ([[job/8]]).", false],
		[0, "Zorluk ve ödül", "İlk görevlerin zorluğu bir ya da ikidir; sonrakiler dokuza kadar çıkar. Bir görevin temel ödülü 1.500 kredi artı zorlukla birlikte 5.500 krediye kadar ek tutardır. Ardından hedefe olan uzaklıkla artar (1.200 km'de iki katına çıkar) ve pilot seviyesi başına 200 kredi eklenir. Çöp temizleme yüzde 30 daha az, eskort görevleri yüzde 20 daha fazla öder; geri alma ve kurtarma görevleri iki katı öder; yolcu görevleri ise daha düşük bir temel tutar artı her yolcu için bir pay öder. Ödüller elli krediye yuvarlanır.", false],
		[0, "Görevi yerine getirmek", "Kurye ve yolcu görevleri, yük ya da yolcular gemideyken hedefe kenetlenerek tamamlanır. Satın alma görevleri, mallar ambardayken alıcının istasyonuna yeniden kenetlenerek tamamlanır. Diğer tüm görevler, oraya vardığınızda başlayan hedef istasyondaki çatışmalardır; biri sürerken kenetlenemez, yolculuk edemez ya da atlayıp gidemezsiniz. Kurtarılan konteynerler ve rehineler daha sonra görevi aldığınız istasyona geri getirilmelidir. Bir görev bittiğinde ödül hemen ödenir, müşterinin ırkındaki itibarınız artar ve görev [[medal/16]] için sayılır.", false],
		[0, "Başarısızlık", "Bir çatışma, koşulu kaybedilirse başarısız olur: koruduğunuz gemilerin hepsi yok edilir, konteyner kaybolur, süre dolar ya da rakip sizden fazla vurur. Başarısız bir görev ödemesiz iptal edilir. Bir görevi \"Missions\" ekranından bırakabilirsiniz de; yük geri alınır. Geminiz yok edilirse son otomatik kaydınızdan devam edersiniz.", false],
	],
	"guide/lounge": [
		[0, "Konuklar", "Her istasyonda [[step/13]] itibarıyla açık olan bir Uzay Salonu vardır. Orada üç ile beş arasında konuk oturur ve her kenetlendiğinizde değişirler. Çoğu sistemi yöneten ırka mensuptur, ama bazıları herhangi bir yerden gelir. Ne istediğini duymak için bir konukla konuşun; her yanıt ve karar sohbet madalyalarından biri için sayılır.", false],
		[0, "Yanıtlar", "\"OK\" (Tamam) bir teklifi kabul eder, \"No, thanks\" (Hayır, teşekkürler) geri çevirir ve \"How was that again?\" (Nasıldı, bir daha?) tekrarlatır. Başka bir yerdeki bir görev için hedefi öğrenmek üzere \"Can you show it on the map?\" (Haritada gösterebilir misiniz?), ne kadar zor olduğunu duymak üzere \"Will it be difficult?\" (Zor olacak mı?) diye sorabilirsiniz. Tüccarlar önce mallarına bakmanıza izin verir. Teklifleri geri çevirmek, tekrar istemek ve sormadan kabul etmek her biri [[medal/32]], [[medal/33]], [[medal/34]] ve [[medal/35]] için sayılır; teklifi olan konuklarla konuşmak [[medal/26]] için sayılır.", false],
		[0, "Müşteriler ve sohbet edenler", "Pek çok konuk serbest görev sunar; bkz. [[guide/jobs]]. Diğerleri yalnızca sohbet eder ve söylentiler aktarır; bunlar bazen bilinmeye değer istasyonlardan ya da cevherlerden söz eder.", false],
		[0, "Tüccarlar ve alıcılar", "Tüccarlar tek bir parti satar: bir donanım parçası ya da birkaç birim ticari mal, olağan fiyatının yüzde 40'ı ile 160'ı arasında herhangi bir fiyata. [[step/16]] itibarıyla, bir eşyadan belirli bir miktarın aynı istasyona getirilmesini isteyen alıcılar da ortaya çıkar; bkz. [[job/8]].", false],
		[0, "Kiralık pilotlar", "[[step/16]] itibarıyla her salonda bir konuk kanat pilotu sunabilir: pilot başına 700 ile 1.999 kredi arasında bir ücretle, on dakikalık uçuş için bir ile üç pilot. [[faction/1]] pilotları asla kiralanamaz. Aynı anda yalnızca bir grubunuz olabilir. Tüm madalyalara sahip bir pilot bunun yerine, birlikte uçmak için para ödeyen hayranlar bulur.", false],
		[0, "Ajanlar", "Hikâyede [[step/16]] geride kaldıktan sonra, adı olan ajanlar belirli istasyonlarda bekler ve her biri bir anlaşma yapar. Çoğu bir plan satar; dördü ise gizli bir sistemin koordinatlarını satar ve o sistem haritada görünür. Her ajan anlaşmadan sonra ayrılır. Ajanlar kendi sayfalarında listelenir.", false],
		[0, "Diplomatlar", "Dört büyük ırktan biri düşman olduğunda, onun diplomatlarından biri her salonda oturur. Diplomat, itibarınızın ne kadar düştüğüne göre artan ve en fazla 16.000 krediye varan bir ücret karşılığında o itibar ölçeğini sıfıra döndürür.", false],
	],
	"guide/medals": [
		[0, "Kademeler", "Çoğu madalyanın üç kademesi vardır: bronz, gümüş ve altın. Her kademenin kendi hedefi vardır ve daha yüksek bir kademeye ulaşmak alttaki madalyanın yerini alır. Birkaç madalyanın yalnızca tek bir kademesi vardır. Madalya sayfaları her kademenin hedefini gösterir.", false],
		[0, "Madalyalar ne zaman verilir", "Kaydınız bir istasyona yaklaşırken, kenetlenme geminizi onarmadan önce denetlenir ve yeni ya da yükseltilmiş madalyalar kenetlendikten sonra duyurulur. Uçuşta hiçbir şey verilmez; bu yüzden uzayda ulaşılan bir hedef ancak bir sonraki kenetlenmede sayılır. \"Status\" (Durum) ekranı sahip olduğunuz her madalyayı, kademesini ve ne için verildiğini listeler.", false],
		[0, "İlk ve son", "[[medal/0]] oyunun başından itibaren sizdedir. [[medal/36]], diğer tüm madalyalara sahip olunduğunda otomatik olarak verilir.", false],
		[0, "Ödüller", "Tüm madalyalara sahip olmak, Uzay Salonu'ndaki pilotların size davranışını değiştirir: hayranlar ücret istemek yerine kanat pilotu olarak sizinle uçmak için size para öder. Tüm madalyalara altın olarak sahip olmak, [[station/10]] istasyonunda satılan bir prototip olan [[ship/8]] teklifini kazandırır. \"Status\" ekranında [[character/0]], tüm madalyalara sahip olduğunda koyu, tüm madalyalar altın olduğunda ise altın renkli gözlük takar.", false],
	],
	"guide/mining": [
		[0, "Asteroitler", "Her istasyonun uzayında iki alanda asteroitler bulunur: biri istasyona yakın, diğeri daha uzakta; Otopilot listesi sizi oraya uçurabilir. Bir alanda hangi cevherlerin bulunduğu, sistemin her cevherin ana sistemine ne kadar yakın olduğuna bağlıdır; bu yüzden her cevher her yerde bulunmaz. Asteroitler ateş edilerek parçalanabilir de; bu bazen ortada biraz serbest cevher bırakır ve yok edilen asteroitler [[medal/29]] için sayılır.", false],
		[0, "Kazıya başlamak", "Madencilik için bir maden lazeri ve ambarda boş yer gerekir. Bir asteroidi nişangâhın altında tutarak ona kilitlenin, sonra Ateş'e basın. Gemi kayaya yaklaşır ve matkap çalışmaya başlar; bitirene kadar uçuş kilitlenir. Kilitlendikten sonra HUD asteroidin cevherini ve sınıfını gösterir.", false],
		[0, "Matkap", "Bir gösterge, asteroidin üst üste yığılmış kaya katmanlarını gösterir; her katman bir öncekinden daha dardır. Matkap bir yana kayar ve yarım saniye ile iki buçuk saniye arasında rastgele aralıklarla yön değiştirir. Matkabı geçerli katmanın yeşil alanında tutmak için sola ve sağa yönlendirin. İlk katman altı saniyelik kazı gerektirir ve her derin katman bir öncekinden yaklaşık altıda bir daha kısa sürer. Yeşilde kaldığınız sürece cevher birikir; derin katmanlarda daha hızlı birikir.", false],
		[0, "Kırmızı bölgeler", "Yeşil alanın dışında geçen süre hasar sayılır ve göstergedeki kırmızı bölgeler büyür. Kırmızıda toplam iki buçuk saniye geçtikten sonra asteroit parçalanır ve ondan kazılan her şey kaybolur. Durmak ve o ana kadar toplanan cevheri saklamak için istediğiniz zaman Ateş'e basın. Her asteroit yalnızca bir kez kazılabilir.", false],
		[0, "Sınıflar ve çekirdekler", "Büyük asteroitlerin ikiden yediye kadar daha fazla katmanı vardır. En büyüğü olan A sınıfında yedi katmanın hepsi bulunur ve hepsini delip geçmek cevherin yanında bir çekirdek de verir. Çekirdekler cevherden çok daha değerlidir ve [[medal/3]] ile [[medal/7]] için sayılır. Cevherler [[medal/2]] ile [[medal/6]] için sayılır.", false],
		[0, "Maden lazerleri", "Bir maden lazerinin iki değeri vardır. Verimi, matkabın daha yavaş kaymasını ve daha hassas yönlendirilmesini sağlar; bu da onu yeşilde tutmayı kolaylaştırır. Hızı ise cevherin birikme oranını artırır. Lazerler [[item/86]] ile [[item/89]] arasında değişir; [[item/90]] bir plandan üretilir.", false],
		[0, "Kargo", "Cevher ve çekirdekler doğrudan ambara gider ve yalnızca yer olduğu kadarını saklarsınız. Ambar dolduğunda HUD bunu bildirir ve bir istasyonda satmanız ya da boşaltmanız gerekir. Kargo sıkıştırma birimleri ambarı gövde kapasitesinin bir payı kadar büyütür ve aynı anda birkaç tane takılabilir. En çok da daha büyük bir gövde işe yarar.", false],
	],
	"guide/navigation": [
		[0, "Galaksi haritası", "Bir istasyonun \"Map\" (Harita) bölümü ve uçuşta Rota haritası tuşu galaksiyi gösterir: bilinen her sistemi yerinde, aralarındaki kapı bağlantılarını, hâkim ırkı ve sistemin güvenliğini. Bir sistem seçmek ona yakınlaştırır ve istasyonlarını gösterir; oradan bir istasyon seçmek onu hedefiniz yapar. \"Map\" ayrıca bir sisteme olan uzaklığı kilometre olarak gösterir, ziyaret ettiğiniz istasyonları işaretler ve hikâyenin ile mevcut işinizin nerede devam ettiğini belirtir. Bir arama kutusu bilinen istasyonları adlarıyla bulur. [[chart]] sayfası tüm sistemleri listeler.", false],
		[0, "", "Hikâyenin başında ilk istasyonunuzun yörüngesine bağlı kalırsınız. \"Map\" [[step/9]] ile açılır; ardından sistemin diğer gezegenlerine uçabilirsiniz.", false],
		[0, "Sistemler ve güvenlik", "Her sistemi dört büyük ırktan biri yönetir ve her sistemin bir güvenlik derecesi vardır: \"Safe\" (Güvenli), \"Average\" (Orta), \"Risky\" (Riskli) ya da \"Dangerous\" (Tehlikeli). Korsan ve düşman baskınları tehlikeli sistemlerde çok daha sıktır; güvenli sistemler ise çoğunlukla sakindir. Çoğu sistemde, her biri kendi gezegeninin yörüngesinde dönen ve kendi dükkânı, salonu ve teknoloji seviyesi olan birkaç istasyon bulunur.", false],
		[0, "Atlama kapıları", "Sistemler arası yolculuk atlama kapılarından geçer. Bir sistemde en fazla bir kapı vardır; kapı, istasyonlarından birinin uzayında bulunur ve yalnızca komşu sistemlere bağlanır. Atlamak için \"Map\" ekranında komşu bir sistemde bir hedef seçin, kapıya uçun (otopilot sizi götürür), ona kilitlenin ve bölgesine girince Ateş'e basın. Daha uzun yolculuklar kapı kapı yapılır; \"Missions\" (Görevler) ekranı, bildiğiniz sistemler üzerinden bir hedefin kaç kapı atlaması gerektirdiğini gösterir.", false],
		[0, "Gizli sistemler", "Beş sistem başta haritada yoktur: [[system/0]], [[system/1]], [[system/6]], [[system/10]] ve [[system/21]]. Gizli bir sistem, oraya gittiğinizde ya da koordinatlarını satın aldığınızda görünür. Uzay Salonu'nda dört ajan bunları satar: [[system/0]] için [[agent/12]], [[system/1]] için [[agent/13]], [[system/10]] için [[agent/14]] ve [[system/21]] için [[agent/15]]. Adı olan ajanlar ancak hikâyede [[step/16]] geride kaldıktan sonra ortaya çıkar. [[system/10]] sisteminin hiç kapı bağlantısı yoktur ve ona yalnızca bir atlama motoruyla ulaşılabilir.", false],
		[23, "", "[[system/6]] sistemine giden yol size hikâye tarafından [[step/22]] sırasında verilir.", false],
		[0, "Atlama motoru", "Bir atlama motoru, gemiyi kapı kullanmadan bilinen herhangi bir sistemdeki bir istasyona doğrudan götürür. Tek örneği, dükkânlarda asla satılmayan ve planından üretilmesi gereken [[item/85]] sürücüsüdür. Uçuşta Eylemler menüsünden kullanın. Atlama yakıt ya da ücret gerektirmez. İstasyonunuzda bir serbest görev çatışması sürerken kullanılamaz; ancak kurye ve yolcu görevleri onu engellemez.", false],
		[34, "", "Hikâye, [[item/85]] planını [[step/34]] sırasında, bileşenlerinin bir kısmı önceden teslim edilmiş olarak size verir.", false],
		[0, "Uzaklık", "Sistemler arası uzaklıklar, sistemlerin haritadaki yerlerinden ölçülerek kilometre olarak verilir. Uzaklık ticaret için önemlidir, çünkü fiyatlar bir eşyanın çıkış yerinden uzaklaştıkça artar; serbest görevler için de önemlidir, çünkü ödülleri hedefe olan uzaklıkla büyür.", false],
	],
	"guide/tips": [
		[0, "", "Bir ticaret seferinden önce eşyanın sayfasını okuyun: eşyanın en ucuz olduğu sistemi ve hangi yönde pahalılaştığını belirtir.", true],
		[0, "", "İstasyonlar aynı fiyattan alıp satar; bu yüzden bir kargo ancak çıkış yerinden uzaklaştıktan sonra para kazandırır.", true],
		[0, "", "Kazı yaparken kaymadaki her değişikliğe hemen tepki verin. Kırmızıda geçen süre tüm kazı boyunca toplanır; bu yüzden kısa kaymalar da tek bir uzun kayma kadar pahalıya mal olur.", true],
		[0, "", "Matkap kırmızıda zaten çok zaman geçirdiyse, tüm yükü kaybetmek yerine Ateş ile durdurun ve elinizdekini saklayın.", true],
		[0, "", "Çekirdek istiyorsanız en büyük asteroitleri arayın: yalnızca A sınıfı kayalarda çekirdek bulunur, o da ancak yedi katmanın hepsini geçerseniz.", true],
		[0, "", "Erkenden bir çekici ışın takın. Çekici ışın olmadan enkazların ve etkisiz hâle getirilmiş gemilerin kargosu hiç toplanamaz.", true],
		[0, "", "Daha iyi bir tarayıcı savaşta kendini amorti eder: hedeflere daha hızlı kilitlenir, en iyileri de saldırmadan önce bir geminin ne taşıdığını gösterir.", true],
		[0, "", "Kenetlenme geminizi ücretsiz onarır; bu yüzden hasarlı bir gövdeyle devam etmek yerine çatışmaların arasında bir istasyona uğramaya değer.", true],
		[0, "", "Uzun yolculuklarda düzenli olarak kenetlenin. Yalnızca tamamlanan bir kenetlenme otomatik kayıt oluşturur ve yok edilen bir gemi sizi sonuncusuna geri götürür.", true],
		[0, "", "\"Status\" (Durum) ekranında itibarınızı takip edin. Yerel gemilere yapılan başıboş atışlar birikir ve bütün bir ırk düşmanınız olabilir.", true],
		[0, "", "Sormama madalyalarını toplamıyorsanız, kabul etmeden önce müşteriye görevin nerede olduğunu ve ne kadar zor olacağını sorun.", true],
		[0, "", "Bir kurye görevini kabul etmeden önce ambarda yer açın, bir yolcu görevinden önce de kabin takın: ikisi de yer olmadan kabul edilemez.", true],
		[0, "", "Geri alma ve kurtarma görevleri için bir EMP silahı, kargo gösteren bir tarayıcı, bir çekici ışın ve biraz boş ambar alanı getirin.", true],
		[0, "", "Bir planın tüm bileşenlerini başladığınız istasyona getirirseniz gönderim ücretinden kurtulursunuz.", true],
		[0, "", "Kanat pilotlarını zorlu bir çatışmadan hemen önce kiralayın: sözleşmeleri yalnızca siz uçarken geri sayar.", true],
	],
	"guide/trading": [
		[0, "Fiyatlar nasıl belirlenir", "Her eşyanın bir en düşük ve bir en yüksek fiyatı ve bir ana sistemi, yani çıkış yeri vardır. Çıkış yerinde en düşük fiyatına satılır; bir istasyon çıkış yerinden ne kadar uzaksa fiyat o kadar yüksektir ve belirli bir uzaklıkta en yüksek fiyata ulaşır. Bunun üstüne her istasyon, iki yönde de yaklaşık yüzde beşe kadar kendi sabit sapmasını ekler. Eşya sayfaları, bir eşyanın en ucuz olduğu yeri ve hangi yönde pahalılaştığını gösterir.", false],
		[0, "Alış ve satış", "Bir istasyon sattığı fiyata alır; bu yüzden kâr yalnızca malları taşımaktan gelir: bir eşyanın çıkış yerine yakın yerden alın ve uzak yerde satın. Sattığınız mallar istasyonun rafına eklenir. \"Shop\" (Dükkân) ekranı ayrıca her eşya için gördüğünüz en düşük ve en yüksek fiyatı ve bunların hangi sistemde olduğunu hatırlar ve eşyanın yanında gösterir. Kurye yükü ve bir müşteri için taşıdığınız konteynerler gibi bazı kargolar satılamaz.", false],
		[0, "Bir dükkânda neler bulunur", "Her istasyonun bir teknoloji seviyesi vardır. Rafında o seviyede ya da altındaki eşyalar bulunur; dört ve üzeri seviyedeki istasyonlar, kendi seviyelerinin yarısının altındaki eşyaları dışarıda bırakır. Her eşyanın belirli bir rafta bulunma şansı da vardır; bu yüzden raflar ziyaretten ziyarete değişir. Birkaç eşya belirli bir istasyonda her zaman raftadır. Bazı mallar yalnızca [[faction/1]] sistemlerinde satılır, plan ürünleri ise hiç satılmaz.", false],
		[0, "", "Ticari mallar daha büyük miktarlarda, çıkış yerlerine yakın yerlerde ise çok daha büyük miktarlarda gelir. Silahlar ve donanım genellikle birer ile üçer adet gelirken roketler, torpidolar ve bombalar daha büyük partiler hâlinde gelir. Bir raf her kenetlendiğinizde yenilenir; ancak ziyaret ettiğiniz son üç istasyon raflarını bıraktığınız gibi tutar.", false],
		[0, "İçki", "Her sistemin yalnızca o sistemde satılan kendi yerel içkisi vardır; örneğin [[system/0]] sisteminde [[item/132]] ya da [[system/14]] sisteminde [[item/146]]. İçkiler sıradan ticari mallardır. Onları dükkânlardan satın almak [[medal/8]] için sayılır; Salon tüccarlarından alınan ya da enkazlardan kurtarılan farklı türlere sahip olmak ise [[medal/9]] için sayılır.", false],
		[0, "Diğer kaynaklar", "Uzay Salonu'ndaki tüccarlar tekil partileri olağan fiyatın yüzde 40'ı ile 160'ı arasında herhangi bir fiyata sunar; bu yüzden tekliflerini karşılaştırmaya değer. Gemiler, yok edildiklerinde ya da etkisiz hâle getirildiklerinde bir çekici ışınla alınabilecek kargo taşır; cevher de kazılabilir. Salondaki alıcılar belirli bir eşyadan belirli bir miktar ister ve karşılığında değerinin çok üzerinde öder; bkz. [[job/8]].", false],
	],
	"home": [
		[0, "", "Bu başvuru kaynağı; ticaret, madencilik, savaş ve keşif üzerine bir uzay oyunu olan Galaxy on Fire 2'yi kapsar. Yurdundan çok uzakta mahsur kalmış deneyimli bir pilot olan [[character/0]] rolünde, insanların ve uzaylı ırkların elindeki 22 yıldız sistemi boyunca uçarsınız. Hikâye görevlerinin arasında serbest görevler alabilir, asteroitlerde madencilik yapabilir, mal ticareti yapabilir, planlardan donanım üretebilir ve giderek daha iyi gemiler satın alabilirsiniz.", false],
		[0, "", "Sayfalar içe aktardığınız oyundan oluşturulur. Adlar, sayılar, fiyatlar ve diyaloglar oradan gelir; yanlarındaki açıklamalar ise bu başvuru kaynağı için yazılmıştır. Kaydınızın ulaştığı noktanın ötesindeki hikâye ayrıntıları, oraya varana kadar gizli kalır. Başlamak için iyi yerler: [[world/galaxy]], [[chart]] ve [[guide/basics]].", false],
	],
	"intro/agents": [
		[0, "", "Ajanlar, belirli uzay salonlarında oturan ve dükkânda satın alamayacağınız bir şey satan tüccarlardır: ya nadir bir plan ya da gizli bir sistemin koordinatları. [[step/17]] itibarıyla ortaya çıkarlar ve her biri yalnızca bir kez satış yapar. Teklifi görmek için istasyonlarının salonunda onlarla konuşun; bkz. [[guide/lounge]].", false],
	],
	"intro/blueprints": [
		[0, "", "Plan eşyaları dükkânlarda asla satılmaz. Her biri, genellikle Uzay Salonu'ndaki bir ajandan satın alınan planına sahip olduğunuzda, bir mal tarifinden üretilir. Üretimin nasıl işlediği [[guide/blueprints]] sayfasında açıklanır.", false],
	],
	"intro/characters": [
		[0, "", "Bunlar [[character/0]] adlı kahramanın yolculuğu boyunca karşılaştığı kişilerdir: tüccarlar, subaylar, bilim insanları ve daha tuhaf tanıdıklar. Her biyografi hikâye ilerledikçe büyür; böylece bir karakter hakkında yalnızca Keith'in öğrendiği kadarını öğrenirsiniz.", false],
	],
	"intro/equipment": [
		[0, "", "Donanım, bir geminin donanım yuvalarını doldurur: koruma için kalkanlar ve zırh plakaları, kargo sıkıştırıcılar, konteyner toplamak için çekici ışınlar, takviyeler, yönlendirme memeleri, tarayıcılar, maden lazerleri, yolcu kabinleri, gizlenme cihazları, bir onarım robotu ve atlama motoru. Her parça bir yuva kaplar; bu yüzden yuva sayısı bir geminin ne kadar eksiksiz donatılabileceğini sınırlar. Fiyatlar sisteme göre değişir ve dükkânlar yalnızca istasyonlarının teknoloji seviyesine kadar olan eşyaları satar. En iyi parçaların bazıları planlardan üretilir, birçoğunu da [[faction/1|Vossklar]] üretir ve yalnızca kendi sistemlerinde satar.", false],
	],
	"intro/factions": [
		[0, "", "Oyunda on fraksiyon yer alır. Bunların dördü sistem ve istasyon sahibidir: Terranlar, Vossklar, Nivelianlar ve Midorianlar. Diğerlerinin toprağı yoktur ve karşınıza yalnızca bireyler ya da düşmanlar olarak çıkarlar. Dört büyük güçteki itibarınız iki ölçekte tutulur: Terran'a karşı Vossk ve Nivelian'a karşı Midorian; bkz. [[world/galaxy]].", false],
	],
	"intro/goods": [
		[0, "", "Mallar, ticaret için ambarda taşınan her şeydir. Ticari mallar ve içkiler bir sistemde ucuza alınıp başka bir sistemde pahalıya satılır (bkz. [[guide/trading]]); her sistemin kendi içkisi vardır. Cevherler asteroitlerden kazılır ve A sınıfı bir asteroidin tüm katmanlarını delip geçmek çok daha değerli bir çekirdek verir (bkz. [[guide/mining]]). Ticari mallar, cevherler ve çekirdekler aynı zamanda planlardan eşya üretmenin bileşenleridir. [[item/116]] ve [[item/131]] gibi birkaç mal yalnızca görevler ya da hikâye yoluyla ortaya çıkar ve satın alınamaz.", false],
	],
	"intro/guide": [
		[0, "", "Bu sayfalar oyunun nasıl oynandığını açıklar: uçuş ve savaş, madencilik ve ticaret, istasyon ekranları, serbest işler, üretim ve madalyalar. Burada verilen sayılar motorun kurallarını izler; eşya, gemi ve madalya sayfalarındaki tablolar ise kendi oyun verilerinizden gelir. [[guide/basics]] ve [[guide/help]] ile başlayın.", false],
	],
	"intro/jobs": [
		[0, "", "Serbest görevler, Uzay Salonu'ndaki müşterilerin sunduğu yan işlerdir; yük taşımaktan aranan suçluları avlamaya kadar uzanır. Kredi, müşterinin ırkında itibar ve deneyim kazandırırlar. On üç tür vardır; nasıl sunuldukları ve ödendikleri [[guide/jobs]] sayfasında açıklanır.", false],
	],
	"intro/medals": [
		[0, "", "Madalyalar bir pilotun kaydını ödüllendirir: savaş, madencilik, ticaret, yolculuk, hatta Uzay Salonu'ndaki insanlarla nasıl konuştuğunuz. Çoğunun bronz, gümüş ve altın kademeleri vardır. Her kenetlendiğinizde denetlenirler; bkz. [[guide/medals]].", false],
	],
	"intro/ships": [
		[0, "", "Gemiler zırh, kargo alanı, manevra kabiliyeti ve sundukları yuva sayısı bakımından farklılaşır: ileri silahlar için birincil yuvalar, roketler, torpidolar ve bombalar için ikincil yuvalar, isteğe bağlı bir taret yuvası ve geri kalan her şey için donanım yuvaları. Fiyatlar en küçük gövdelerde 20.000 kredinin altından en iyi avcılarda birkaç milyona kadar hızla yükselir. [[faction/1|Vossk]] sistemleri dışındaki satıcılar her ziyarette en fazla beş gövde gösterir; [[faction/1|Vossk]] satıcıları yalnızca [[ship/9]] satar. Bir satıcı, liste fiyatından istasyonunun teknoloji seviyesi kadar yüzde indirim yapar ve eski gövdeniz için liste fiyatının beşte dördünü öder. [[ship/0]] ve [[ship/10]] asla satılmaz. Bir geminin nasıl donatılacağı için bkz. [[guide/fitting]].", false],
	],
	"intro/stations": [
		[0, "", "Her istasyonda bir dükkân, bir hangar, bir gemi satıcısı ve bir uzay salonu vardır. 1 ile 10 arasındaki teknoloji seviyesi, raflarındaki mal ve donanımın ne kadar gelişmiş olabileceğini belirler; gemi satıcısı da gemilerin liste fiyatından bu kadar yüzde indirim yapar. Stoklar ziyaretten ziyarete değişir. Hikâyede adı geçen ya da bir ajan barındıran istasyonların burada kısa bir açıklaması vardır.", false],
	],
	"intro/story": [
		[0, "", "Hikâye, korsan avı feci biçimde ters giden Terran pilotu [[character/0]] adlı kahramanı 45 adım boyunca izler. Her adım sayfası görevi ve, tamamladığınızda, neler olduğunu anlatır. Sayfalar yalnızca kaydınızın ulaştığı kadarını açığa çıkarır; [[world/history]] o ana kadarki hikâyeyi tek bir yerde anlatır.", false],
	],
	"intro/systems": [
		[0, "", "Galakside 22 yıldız sistemi vardır. Her biri bir fraksiyona aittir, baskıncıların ne sıklıkla ortaya çıkacağını belirleyen bir güvenlik derecesine sahiptir ve biri atlama kapısını taşıyan en fazla beş istasyon barındırır. Kapı bağlantıları hangi sistemler arasında yolculuk yapabileceğinizi belirler; birkaç sistem gizlidir ya da hiç bağlantısı yoktur. Bkz. [[world/galaxy]] ve [[chart]].", false],
	],
	"intro/weapons": [
		[0, "", "Silahlar iki gruba ayrılır. Birincil silahlar (lazerler, blasterlar, otomatik toplar ve termal toplar) ileri yuvalardan cephanesiz ateş eder; atış başına hasar, atış hızı ve menzil bakımından farklılaşırlar. İkincil silahlar (roketler, torpidolar, EMP bombaları ve nükleer bombalar) tane hesabıyla satın alınır ve ikincil yuvalardan ateşlenir. Taretler kendi yuvalarını gerektirir ve her yöne ateş edebilir. Bazı silahlar bir gemiye hasar vermek yerine ya da hasarın yanı sıra enerjisini tüketir; enerjisi kalmayan bir gemi bir süreliğine etkisiz hâle gelir. En iyi silahların birçoğu dükkânlarda asla satılmaz ve planlardan üretilmesi gerekir (bkz. [[guide/blueprints]]). Pek çok modeli [[faction/1|Vossklar]] üretir ve bunlar yalnızca onların sistemlerinde satılır. Taktikler için bkz. [[guide/combat]].", false],
	],
	"intro/world": [
		[0, "", "Bu sayfalar oyunun evrenini anlatır: galaksiyi ve yerleşimini, tarihini ve onu biçimlendiren güçleri. Sistem, istasyon ve fraksiyon sayfalarını daha geniş bir tabloyla tamamlar.", false],
	],
	"item/0": [
		[0, "", "[[item/0]], başlangıç seviyesi lazerdir: her 0,4 saniyede atış başına 3 hasar ve tüm erken lazerlerin paylaştığı 2.000 birimlik menzil. Oyundaki en zayıf lazerdir, ama ucuzdur ve neredeyse her dükkânda bulunur. [[item/1]] ve [[item/2]] aynı atış hızını korur ve hasar ekler.", false],
		[6, "", "[[character/2]] adlı tüccarın, korsan sığınağına yapılan baskından önce [[station/78]] istasyonundaki hangarında ücretsiz sunduğu üç parçadan biridir; diğerleri [[item/22]] ve [[item/55]].", false],
	],
	"item/1": [
		[0, "", "[[item/1]], Nirai serisinin ikinci basamağıdır. [[item/0]] kadar hızlı ateş eder (her 0,4 saniyede), ama aynı menzilde atış başına 3 yerine 5 hasar verir. [[item/2]] alınabilir hâle gelene kadar ucuz bir yükseltmedir.", false],
	],
	"item/10": [
		[0, "", "[[item/10]], 2.600 menzilde her 1,4 saniyede 34 hasar verir. [[item/9]] lazerinden atış başına daha sert vurur ve daha uzağa ulaşır; atış hızı biraz daha yavaştır. Dükkânlarda satılan en güçlü lazerdir.", false],
	],
	"item/11": [
		[0, "", "[[item/11]], oyundaki en güçlü lazerdir: 2.600 menzilde her 1,5 saniyede 45 hasar; birincil silahlar arasında en ağır tekil atış. Asla hazır satılmaz. Planı [[station/3]] istasyonundaki [[agent/0]] adlı ajandan gelir ve üretimi, [[item/155]] ve birkaç ticari malla birlikte bir [[item/9]] tüketir.", false],
	],
	"item/116": [
		[0, "", "Güvenli konteynerler, yalnızca serbest işler yoluyla ortaya çıkan mühürlü yüklerdir. Bir [[job/0]] görevini kabul etmek, kararlaştırılan sayıda konteyneri ambarınıza yükler; orada kargo alanı kaplarlar, satılamazlar ve hedefte teslim edilirler. Ayrıca [[job/3]] görevlerinde çalınan malları temsil ederler; bu görevlerde onları taşıyan geminin yok edilmek yerine etkisiz hâle getirilmesi gerekir.", false],
	],
	"item/117": [
		[0, "", "Güvenli kabin, yalnızca serbest işler yoluyla, birkaç gemiden birindeki bir tutsağı kurtarıp geri getirmenizi isteyen [[job/5]] görevlerinde ortaya çıkan özel bir kargodur. Bir [[item/116]] gibi satın alınamaz ve satılamaz.", false],
	],
	"item/12": [
		[0, "", "[[item/12]], temel [[faction/1|Vossk]] blasterıdır: 1.500 menzilde her 0,6 saniyede 11 hasar. Blasterlar lazerlerden daha kısa menzillidir, ama zaman içinde daha sert vurur; bu ilk model bile en iyi Nirai lazerinden biraz fazla hasar verir. [[item/15]] üretimi için de gereklidir. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/13": [
		[0, "", "[[item/13]], 1.500 menzilde her 0,5 saniyede 12 hasar veren bir [[faction/1|Vossk]] blasterıdır; atış hızı ve hasarda [[item/12]] blasterına göre belirgin bir ilerlemedir. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/131": [
		[0, "", "[[item/131]], [[faction/9|Void]] avcı gemilerinin enkazıdır. Yok edilen her düşman [[faction/9|Void]] gemisi, içinde bunlardan bir ile üç tane bulunan ve yalnızca bir çekici ışınla toplanabilen bir konteyner düşürür (bkz. [[item/68]]). Sabit 199 krediye satılırlar ve toplanmaları [[medal/21]] madalyası için sayılır.", false],
		[24, "", "[[character/6]], araştırması için bu tür kalıntılara ihtiyaç duyar ve onları toplaması için [[character/0]] adlı pilotu [[station/48]] yakınına gönderir.", false],
		[25, "", "[[character/0]] onları geri taşırken kalıntılar satılamaz.", false],
		[28, "", "[[station/10]] istasyonuna varıldığında [[character/6]] adlı bilim insanının ekibine teslim edilirler.", false],
	],
	"item/14": [
		[0, "", "[[item/14]], her 0,4 saniyede 10 hasarla ateş eden bir [[faction/1|Vossk]] blasterıdır. Zaman içinde [[item/13]] blasterından biraz fazla hasar verir, ama 1.000 olan menzili kısadır; bu yüzden hedeflerine yaklaşan pilotlara uygundur. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/15": [
		[0, "", "[[item/15]], en iyi [[faction/1|Vossk]] blasterıdır: 1.500 menzilde her 0,3 saniyede 10 hasar. Hızlı blasterların atış hızını [[item/12]] blasterının menziliyle birleştirir. Asla hazır satılmaz. Planı [[station/8]] istasyonundaki [[agent/1]] adlı ajandan gelir ve üretimi, birkaç ticari malla birlikte bir [[item/12]] ve bir [[item/166]] tüketir.", false],
	],
	"item/154": [
		[0, "", "[[item/154]], en değerli sıradan cevherdir. Asteroit alanları ana sistemi yakında olan cevherleri kayırır; bu cevherin ana sistemi, aynı zamanda en ucuz olduğu yer olan [[system/9]] sistemidir. [[item/27]] üretmek için bol miktarda gerekir. A sınıfı bir [[item/154]] asteroidini delip geçmek bir [[item/165]] verir.", false],
	],
	"item/155": [
		[0, "", "[[item/155]], ana sistemi [[system/21]] olan orta fiyatlı bir cevherdir; en ucuz orada satılır. [[item/11]] ve [[item/90]] üretiminin bileşenidir. Çekirdeği: [[item/166]].", false],
	],
	"item/156": [
		[0, "", "[[item/156]], ana yurdu [[system/0]] sistemi olan en ucuz cevherdir. Düşük değeri onu satış için kötü bir kargo yapar, ama [[item/59]] zırh plakasının bir bileşenidir. Çekirdeği: [[item/167]].", false],
	],
	"item/157": [
		[0, "", "[[item/157]], ana sistemi [[system/7]] olan orta fiyatlı bir cevherdir. Çekirdeği [[item/168]] ile birlikte [[item/59]] zırh plakasını üretmek için gerekir.", false],
	],
	"item/158": [
		[0, "", "[[item/158]], ana sistemi [[system/4]] olan orta fiyatlı bir cevherdir. [[item/85]] için gereken cevherlerden biridir. Çekirdeği: [[item/169]].", false],
	],
	"item/159": [
		[0, "", "[[item/159]], ana sistemi [[system/18]] olan orta fiyatlı bir cevherdir. Hiçbir plan onu kullanmaz; bu yüzden yalnızca satış ya da cevher madalyaları için kazılır. Çekirdeği: [[item/170]].", false],
	],
	"item/16": [
		[0, "", "[[item/16]], ilk EMP blasterıdır. Gövdeye ya da zırha hasar vermez; bunun yerine her isabet bir geminin enerjisinden 3 puan tüketir ve enerjisi sıfıra inen bir gemi bir süreliğine etkisiz hâle gelir. Bir hedefin yok edilmek yerine durdurulması gerektiğinde EMP silahları gerekir. Bu model her 0,3 saniyede ateş eder, ama yalnızca 1.200 birime ulaşır. [[item/17]] ve [[item/18]] daha uzağa ulaşır ve atış başına daha fazla tüketir.", false],
	],
	"item/160": [
		[0, "", "[[item/160]], ana sistemi [[system/13]] olan düşük fiyatlı bir cevherdir. [[item/85]] için gereken cevherlerden biridir. Çekirdeği: [[item/171]].", false],
	],
	"item/161": [
		[0, "", "[[item/161]], ana sistemi [[system/19]] olan orta fiyatlı bir cevherdir. Hiçbir plan onu kullanmaz. Çekirdeği: [[item/172]].", false],
	],
	"item/162": [
		[0, "", "[[item/162]], ana sistemi [[system/14]] olan orta fiyatlı bir cevherdir. Hiçbir plan onu kullanmaz. Çekirdeği: [[item/173]].", false],
	],
	"item/163": [
		[0, "", "[[item/163]], ana sistemi [[system/5]] olan orta fiyatlı bir cevherdir. 80 t gerektiren [[item/54]] kalkanının ana bileşenidir ve [[item/85]] için de gereklidir. Çekirdeği: [[item/174]].", false],
	],
	"item/164": [
		[0, "", "[[item/164]], yerleşik sistemlerin asteroit alanlarında hiç bulunmayan bir cevherdir. Diğer cevherlerin aksine, bir kristal asteroidi ateşle parçalandığında geride hiçbir şey bırakmaz; bu yüzden kristallerin kazılması gerekir. 50 tane gerektiren [[item/85]] sürücüsünün temel bileşenidir.", false],
		[25, "", "Solucan delikleriyle ulaşılan [[faction/9|Void'lerin]] ana uzayındaki her asteroit bu kristallerden oluşur.", false],
		[33, "", "[[character/20]], [[faction/9|Void'lerin]] solucan deliklerinin sırrını taşıdığına inandığı en az 50 kristali getirmesini [[character/0]] adlı pilottan ister.", false],
	],
	"item/165": [
		[0, "", "Bu çekirdek, A sınıfı bir [[item/154]] asteroidinin nadir merkezidir. Böyle bir asteroidin yedi katmanının hepsini delip geçerek elde edilir; ara sıra A sınıfı bir asteroit ateşle parçalandığında da düşer. Cevherin kendisinin birkaç katı fiyata satılır; en ucuz [[system/9]] sisteminde bulunur. [[item/175]] dışındaki en değerli çekirdektir.", false],
	],
	"item/166": [
		[0, "", "Bu çekirdek, A sınıfı bir [[item/155]] asteroidinin nadir merkezidir. Böyle bir asteroidin yedi katmanının hepsini delip geçerek elde edilir; ara sıra A sınıfı bir asteroit ateşle parçalandığında da düşer. Cevherin kendisinin birkaç katı fiyata satılır; en ucuz [[system/21]] sisteminde bulunur. [[item/15]] üretmek için ve onar onar [[item/90]] üretmek için gerekir.", false],
	],
	"item/167": [
		[0, "", "Bu çekirdek, A sınıfı bir [[item/156]] asteroidinin nadir merkezidir. Böyle bir asteroidin yedi katmanının hepsini delip geçerek elde edilir; ara sıra A sınıfı bir asteroit ateşle parçalandığında da düşer. Cevherin kendisinin birkaç katı fiyata satılır; en ucuz [[system/0]] sisteminde bulunur. En az değerli çekirdektir.", false],
	],
	"item/168": [
		[0, "", "Bu çekirdek, A sınıfı bir [[item/157]] asteroidinin nadir merkezidir. Böyle bir asteroidin yedi katmanının hepsini delip geçerek elde edilir; ara sıra A sınıfı bir asteroit ateşle parçalandığında da düşer. Cevherin kendisinin birkaç katı fiyata satılır; en ucuz [[system/7]] sisteminde bulunur. [[item/59]] üretmek için bunlardan on beş tane gerekir.", false],
	],
	"item/169": [
		[0, "", "Bu çekirdek, A sınıfı bir [[item/158]] asteroidinin nadir merkezidir. Böyle bir asteroidin yedi katmanının hepsini delip geçerek elde edilir; ara sıra A sınıfı bir asteroit ateşle parçalandığında da düşer. Cevherin kendisinin birkaç katı fiyata satılır; en ucuz [[system/4]] sisteminde bulunur.", false],
	],
	"item/17": [
		[0, "", "[[item/17]], her 0,5 saniyede isabet başına 5 enerji tüketir ve [[item/16]] blasterından çok daha uzağa, 2.000 birime ulaşır. Gövde hasarı vermez. Enerjiyi Mk I ile hemen hemen aynı hızda tüketir, ama bunu daha güvenli bir mesafeden yapabilir.", false],
	],
	"item/170": [
		[0, "", "Bu çekirdek, A sınıfı bir [[item/159]] asteroidinin nadir merkezidir. Böyle bir asteroidin yedi katmanının hepsini delip geçerek elde edilir; ara sıra A sınıfı bir asteroit ateşle parçalandığında da düşer. Cevherin kendisinin birkaç katı fiyata satılır; en ucuz [[system/18]] sisteminde bulunur.", false],
	],
	"item/171": [
		[0, "", "Bu çekirdek, A sınıfı bir [[item/160]] asteroidinin nadir merkezidir. Böyle bir asteroidin yedi katmanının hepsini delip geçerek elde edilir; ara sıra A sınıfı bir asteroit ateşle parçalandığında da düşer. Cevherin kendisinin birkaç katı fiyata satılır; en ucuz [[system/13]] sisteminde bulunur.", false],
	],
	"item/172": [
		[0, "", "Bu çekirdek, A sınıfı bir [[item/161]] asteroidinin nadir merkezidir. Böyle bir asteroidin yedi katmanının hepsini delip geçerek elde edilir; ara sıra A sınıfı bir asteroit ateşle parçalandığında da düşer. Cevherin kendisinin birkaç katı fiyata satılır; en ucuz [[system/19]] sisteminde bulunur.", false],
	],
	"item/173": [
		[0, "", "Bu çekirdek, A sınıfı bir [[item/162]] asteroidinin nadir merkezidir. Böyle bir asteroidin yedi katmanının hepsini delip geçerek elde edilir; ara sıra A sınıfı bir asteroit ateşle parçalandığında da düşer. Cevherin kendisinin birkaç katı fiyata satılır; en ucuz [[system/14]] sisteminde bulunur.", false],
	],
	"item/174": [
		[0, "", "Bu çekirdek, A sınıfı bir [[item/163]] asteroidinin nadir merkezidir. Böyle bir asteroidin yedi katmanının hepsini delip geçerek elde edilir; ara sıra A sınıfı bir asteroit ateşle parçalandığında da düşer. Cevherin kendisinin birkaç katı fiyata satılır; en ucuz [[system/5]] sisteminde bulunur.", false],
	],
	"item/175": [
		[0, "", "[[item/175]], A sınıfı bir [[item/164]] asteroidinin çekirdeğidir. Kristal asteroitleri ateşle parçalandığında geride hiçbir şey bırakmadığından, onu elde etmenin tek yolu yedi katmanın hepsini delip geçmektir. Sabit 5.000 krediye satılır; bu, diğer tüm çekirdeklerin en iyi fiyatının beş katından fazladır.", false],
		[25, "", "Yalnızca [[faction/9|Void'lerin]] ana uzayında bulunabilir.", false],
	],
	"item/18": [
		[0, "", "[[item/18]], en güçlü EMP blasterıdır: 2.000 menzilde her 0,5 saniyede isabet başına 8 enerji; bu da gemileri [[item/17]] blasterından belirgin biçimde daha hızlı etkisiz hâle getirir. Diğer EMP blasterları gibi gövde hasarı vermez.", false],
	],
	"item/19": [
		[0, "", "[[item/19]], 1.400 menzilde her 0,3 saniyede 15 hasar verir. Zaman içinde herhangi bir lazerden çok daha sert vurur. [[item/20]] ve [[item/21]] daha hızlı ateş eder, ama yalnızca 1.000 birime ulaşır.", false],
	],
	"item/2": [
		[0, "", "[[item/2]], en üst Nirai lazeridir: her 0,4 saniyede 7 hasar. Her atışı Berger lazerlerininkinden zayıftır, ama yaklaşık iki kat sık ateş ettiği için zaman içinde [[item/8]] dahil hepsinden fazla hasar verir. Onu açıkça geride bırakan yalnızca M6 ışın lazerleridir ([[item/9]] ve ardılları).", false],
	],
	"item/20": [
		[0, "", "[[item/20]], her 0,2 saniyede 13 hasarla ateş eder. Zaman içinde [[item/19]] silahından fazla hasar verir, ama menzili yalnızca 1.000 birimdir; bu yüzden en iyi yakın mesafede çalışır.", false],
	],
	"item/21": [
		[0, "", "[[item/21]], her 0,2 saniyede 14 hasar verir; bu, ileri silahlar arasında zaman içindeki en yüksek hasardır. [[item/20]] gibi yalnızca 1.000 birime ulaşır. Aynı zamanda dükkânlardaki en nadir blasterdır.", false],
	],
	"item/22": [
		[0, "", "[[item/22]], oyundaki en zayıf silahtır: 1.000 menzilde her 0,4 saniyede 2 hasar. Otomatik toplar küçük ve hızlı mermiler atar; hafif vururlar, ama bazı modeller çok hızlı ateş eder. Bu ilk model yalnızca geçici bir çözümdür.", false],
		[6, "", "[[character/2]] adlı tüccarın, korsan sığınağına yapılan baskından önce [[station/78]] istasyonundaki hangarında ücretsiz sunduğu üç parçadan biridir; diğerleri [[item/0]] ve [[item/55]].", false],
	],
	"item/23": [
		[0, "", "[[item/23]], [[item/22]] topunun hasarını atış başına 4'e çıkararak ikiye katlar ve yine 1.000 menzilde biraz daha hızlı ateş eder (her 0,3 saniyede). Ucuz bir erken silahtır.", false],
	],
	"item/24": [
		[0, "", "[[item/24]], 1.200 menzilde her 0,3 saniyede 6 hasar verir. Sağlam bir orta sınıf otomatik toptur ve zaman içindeki hasarı, daha uzağa ulaşan [[item/25]] ile eşittir.", false],
	],
	"item/25": [
		[0, "", "[[item/25]], her 0,4 saniyede 8 hasar verir ve 1.400 birime ulaşır; bu, otomatik toplar arasındaki en uzun menzildir. Zaman içinde [[item/24]] ile aynı hasarı verir. Asla hazır satılmaz. Planı [[station/20]] istasyonundaki [[agent/2]] adlı ajandan gelir ve cevher olmadan yalnızca ticari mallardan üretilir.", false],
	],
	"item/26": [
		[0, "", "[[item/26]], 1.000 menzilde her 0,2 saniyede 5 hasarla ateş eder. Hızlı atışı, menzil pahasına ona raylı toplardan daha fazla zaman içi hasar kazandırır.", false],
	],
	"item/27": [
		[0, "", "[[item/27]], her 0,1 saniyede, yani otomatik toplar arasındaki en yüksek atış hızıyla, mermi başına 6 hasarla ateş eder. Zaman içindeki hasarı en iyi blasterlarınkine yakındır, ama 900 olan menzili tüm silahların en kısasıdır. Asla hazır satılmaz. Planı [[station/10]] istasyonundaki [[agent/3]] adlı ajandan gelir ve üretimi için diğer malların yanı sıra [[item/154]] gerekir.", false],
	],
	"item/28": [
		[0, "", "[[item/28]], ilk termal toptur. Termal toplar 1.000 menzilde hızlı ve hafif atışlar yapar; bu model her 0,3 saniyede 3 hasar verir. Yüksek teknoloji seviyesine rağmen zaman içinde çoğu orta sınıf blaster ve otomatik toptan zayıftır.", false],
	],
	"item/29": [
		[0, "", "[[item/29]], 1.000 menzilde her 0,2 saniyede 4 hasar verir; zaman içindeki hasarı [[item/28]] topunun iki katıdır.", false],
	],
	"item/3": [
		[0, "", "[[item/3]], her 0,5 saniyede 7 hasar veren bir [[faction/1|Vossk]] lazeridir. Atış başına [[item/2]] ile eşittir, ama biraz daha yavaş ateş eder; bu yüzden zaman içinde biraz geride kalır. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
		[0, "", "Açılış sahnesinde [[character/0]] adlı pilotun gemisi [[ship/10]] bunlardan iki tane taşır.", false],
	],
	"item/30": [
		[0, "", "[[item/30]], her 0,1 saniyede 3 hasarla ateş eder ve termal topların en hızlısıdır. Zaman içinde [[item/29]] topundan fazla, ama [[item/21]] gibi en iyi blasterlardan az hasar verir.", false],
	],
	"item/31": [
		[0, "", "[[item/31]], temel [[faction/1|Vossk]] roketi ve en ucuz ikincil cephanedir: isabet başına 60 hasar, her 1,2 saniyede bir fırlatma, 1.200 menzil. Roketler düz uçar ve hedeflerini izlemez; bu yüzden en iyi yakın mesafede çalışır. Bir asteroide çarpan her roket ya da torpido onu parçalar. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/32": [
		[0, "", "[[item/32]], yaygın güdümsüz rokettir: isabet başına 70 hasar, her 0,9 saniyede bir fırlatma ve 1.200 menzil. [[item/31]] roketinden daha sert vurur ve daha hızlı fırlatılır; geniş çapta satılır.", false],
	],
	"item/33": [
		[0, "", "[[item/33]], 72 hasar verir ve ayrıca 34 enerji tüketir; böylece bir hedefe hem hasar verebilir hem de onu etkisiz hâle getirmeye yardım edebilir. Yavaş yeniden dolar (2 sn) ve 1.000 birime ulaşır. Asla hazır satılmaz. Planı [[station/43]] istasyonundaki [[agent/4]] adlı ajandan gelir ve bir parti için yalnızca birkaç ucuz ticari mal gerekir.", false],
	],
	"item/34": [
		[0, "", "[[item/34]], yok etmekten çok etkisiz hâle getirmek içindir: isabet başına 45 enerji tüketir ve yalnızca 10 hasar verir; her saniye bir fırlatma yapar. [[item/35]] daha fazla tüketir ve daha fazla hasar verir.", false],
	],
	"item/35": [
		[0, "", "[[item/35]], isabet başına 60 enerji tüketir ve 30 hasar verir; 1.000 menzilde her saniye fırlatılır. Gemileri [[item/34]] füzesinden daha hızlı etkisiz hâle getirirken gövdelerini de aşındırır.", false],
	],
	"item/36": [
		[0, "", "[[item/36]], temel torpidodur. Torpidolar ilk 1,5 saniye düz uçar, sonra hedeflerine yönelir. [[item/36]], 3.000 birimlik menzille 70 hasar verir, ama yavaştır ve yalnızca her 3 saniyede bir fırlatılır. [[item/38]] hasarını ikiye katlar.", false],
	],
	"item/37": [
		[0, "", "[[item/37]], en hızlı torpidodur: 100 hasar verir, 50 enerji tüketir ve 4.000 birime ulaşır. Her 4 saniyede bir fırlatılır. Asla hazır satılmaz. Planı [[station/54]] istasyonundaki [[agent/5]] adlı ajandan gelir ve bir parti için yalnızca birkaç ticari mal gerekir.", false],
	],
	"item/38": [
		[0, "", "[[item/38]], isabet başına 140 hasar ve 4.000 menzille en sert vuran torpidodur. Uçuşta yavaştır ve her 4 saniyede bir fırlatılır. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/39": [
		[0, "", "[[item/39]], gemileri etkisiz hâle getirmek için güdümlü bir torpidodur: 100 enerji tüketir ve hasar vermez. 5.000 menziliyle bir hedefi uzaktan durdurmanın ucuz bir yoludur. [[item/40]] aynı enerji tüketimine 120 hasar ekler.", false],
	],
	"item/4": [
		[0, "", "[[item/4]], daha güçlü [[faction/1|Vossk]] lazeridir: her 0,6 saniyede 10 hasar. Zaman içindeki hasarı neredeyse tam olarak [[item/2]] ile aynıdır; atışları [[item/3]] lazerininkinden daha ağır ama daha seyrektir. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/40": [
		[0, "", "[[item/40]], tek bir güdümlü torpidoda 120 hasarı 100 puanlık enerji tüketimiyle birleştirir; menzili 5.000'dir ve her 5 saniyede bir fırlatılır. [[item/39]] torpidosunun iki katından fazla tutar.", false],
	],
	"item/41": [
		[0, "", "[[item/41]], en küçük EMP bombasıdır. Bomba bir basışla fırlatılır ve ikinci bir basışla patlatılır; patlama, yarıçapı içindeki her geminin enerjisini merkeze yakın yerlerde daha güçlü olmak üzere tüketir ve onu fırlatan gemiyi esirger. Asteroitler etkilenmez. Bu model 22.000 yarıçapta 80 enerjiye kadar tüketir. [[item/42]] ve [[item/43]] daha güçlü ve daha geniştir.", false],
		[20, "", "[[faction/0|Terran]] güvenlik birimleri, [[character/0]] kaçıranların gemisini yok etmeden etkisiz hâle getirebilsin diye [[station/55]] istasyonuna bu bombalardan on tanesini ücretsiz bırakır.", false],
	],
	"item/42": [
		[0, "", "[[item/42]], 30.000 yarıçapta 150 enerjiye kadar tüketir; bu, [[item/41]] bombasının neredeyse iki katı güç ve çok daha geniş bir patlamadır.", false],
	],
	"item/43": [
		[0, "", "[[item/43]], en güçlü EMP bombasıdır: 37.000 yarıçapta 300 enerjiye kadar tüketir. [[item/42]] bombasından biraz daha hızlı yeniden dolar, ama neredeyse iki katı tutar.", false],
	],
	"item/44": [
		[0, "", "[[item/44]], en küçük nükleer bombadır. Bir EMP bombası gibi fırlatılır ve ardından ikinci bir basışla patlatılır, ama patlaması gerçek hasar verir: 20.000 yarıçap içinde 200'e kadar, kenara doğru daha az. Asteroitleri de parçalar. Fırlatan gemi zarar görmez.", false],
	],
	"item/45": [
		[0, "", "[[item/45]], 30.000 yarıçapta 560'a kadar hasar verir; bu, daha geniş bir patlamada [[item/44]] bombasının neredeyse üç katı güçtür.", false],
	],
	"item/46": [
		[0, "", "[[item/46]], oyundaki en yıkıcı silahtır: 40.000 yarıçapta 950'ye kadar hasar. Asla hazır satılmaz. Planı [[station/61]] istasyonundaki [[agent/6]] adlı ajandan gelir ve üretimi için diğer ticari malların yanı sıra radyoaktif mallar ve patlayıcılar gerekir.", false],
	],
	"item/47": [
		[0, "", "[[item/47]], temel tarettir. Taret, yalnızca bazı gövdelerde bulunan kendi yuvasında durur ve tam tur dönebilir; böylece geminin yanındaki ya da arkasındaki hedefleri vurabilir. Siz nişan alırken gemi kendi kendine uçmayı sürdürür. Bu model 2.000 menzilde her 0,3 saniyede 6 hasar verir ve yavaş döner (manevra 40).", false],
	],
	"item/48": [
		[0, "", "[[item/48]], 2.500 menzilde her 0,2 saniyede 10 hasar verir ve [[item/47]] taretinden daha hızlı döner (manevra 60). Üç katından fazla tutar.", false],
	],
	"item/49": [
		[0, "", "[[item/49]], en iyi tarettir: 3.000 menzilde her 0,1 saniyede 12 hasar ve en hızlı dönüş (manevra 100). Ayrıca çok pahalıdır; [[item/48]] taretinin yaklaşık iki katı tutar. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/5": [
		[0, "", "[[item/5]], daha ağır atışlar ve biraz daha uzun menzil (2.200) için atış hızından feragat eden Berger lazer serisini açar. Her 0,9 saniyede 8 hasar verir; bu, daha ucuz [[item/2]] lazerinin zaman içindeki hasarından azdır. Avantajı daha uzun menzilidir.", false],
	],
	"item/50": [
		[0, "", "[[item/50]], temel kalkandır. Bir kalkan, gelen hasarı zırh ve gövde etkilenmeden önce emer ve dolum süresi boyunca kendiliğinden yenilenir. Targe yalnızca 50 puan tutar, ama 20 saniyede, diğer tüm kalkanlardan hızlı biçimde tamamen dolar.", false],
	],
	"item/51": [
		[0, "", "[[item/51]], 80 puan tutar, ama tamamen dolması için 46 saniye gerekir. Tek bir çatışmada [[item/50]] kalkanından fazlasını emer, ama saldırılar arasında çok daha yavaş toparlanır.", false],
	],
	"item/52": [
		[0, "", "[[item/52]], 120 puan tutan ve 58 saniyede dolan bir [[faction/1|Vossk]] kalkanıdır. [[item/51]] kalkanından çok daha fazlasını emer, ama [[item/53]] daha fazla tutar ve daha hızlı dolar. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/53": [
		[0, "", "[[item/53]], 150 puan tutar ve 45 saniyede dolar; böylece her iki açıdan da [[item/52]] kalkanını geride bırakır. Dükkânlarda satılan en iyi kalkandır.", false],
	],
	"item/54": [
		[0, "", "[[item/54]], en güçlü kalkandır: 220 puan, 60 saniyede dolum. Asla hazır satılmaz. Planı [[station/72]] istasyonundaki [[agent/7]] adlı ajandan gelir ve üretimi için elektronik, nanoteknoloji ve mikroçiplerin yanı sıra büyük miktarda [[item/163]] gerekir.", false],
	],
	"item/55": [
		[0, "", "[[item/55]], temel zırh plakasıdır. Bir plaka puanlarını geminin zırhına ekler; kalkandan sonra, gövdeden önce hasar alır ve bir kalkanın aksine yeniden dolmaz. E2, 40 puan ekler; bu, kendi zırhı 100 olan [[ship/32]] gibi hafif bir başlangıç gemisi için büyük bir paydır.", false],
		[6, "", "[[character/2]] adlı tüccarın, korsan sığınağına yapılan baskından önce [[station/78]] istasyonundaki hangarında ücretsiz sunduğu üç parçadan biridir; diğerleri [[item/0]] ve [[item/22]].", false],
	],
	"item/56": [
		[0, "", "[[item/56]], mütevazı bir fiyata [[item/55]] plakasının iki katı olan 80 zırh puanı ekler.", false],
	],
	"item/57": [
		[0, "", "[[item/57]], 110 zırh puanı ekler. [[faction/1|Vossk]] sistemleri dışında satılan en iyi plakadır.", false],
	],
	"item/58": [
		[0, "", "[[item/58]], [[item/57]] plakasından çok daha fazla, 160 zırh puanı ekleyen bir [[faction/1|Vossk]] plakasıdır. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/59": [
		[0, "", "[[item/59]], en iyi zırh plakasıdır: 250 puan ekler; bu, [[ship/9]] gemisinin temel zırhı kadardır ve [[ship/8]] dışındaki tüm gövdelerinkinden fazladır. Asla hazır satılmaz. Planı [[station/84]] istasyonundaki [[agent/8]] adlı ajandan gelir ve üretimi için ticari malların yanı sıra [[item/157]], [[item/168]] ve [[item/156]] gerekir.", false],
	],
	"item/6": [
		[0, "", "[[item/6]], 2.200 menzilde her 0,8 saniyede 9 hasar verir. [[item/5]] lazerine göre mütevazı bir ilerlemedir ve fiyatı sistemler arasında neredeyse hiç değişmez.", false],
	],
	"item/60": [
		[0, "", "[[item/60]], üç EMP koruma modülünün en zayıfıdır ve EMP savunması 20'dir. Üçünün de fiyatı yoktur ve hiçbir dükkân onları satmaz.", false],
	],
	"item/61": [
		[0, "", "[[item/61]], ortadaki EMP koruma modülüdür; EMP savunması 40'tır, yani [[item/60]] modülünün iki katı. Kardeşleri gibi fiyatı yoktur ve dükkânlarda satılmaz.", false],
	],
	"item/62": [
		[0, "", "[[item/62]], en güçlü EMP koruma modülüdür ve EMP savunması 60'tır. [[item/60]] ve [[item/61]] gibi fiyatı yoktur ve dükkânlarda satılmaz.", false],
	],
	"item/63": [
		[0, "", "[[item/63]], temel kargo sıkıştırıcıdır. Bir sıkıştırıcı ambarı gövdenin kendi kapasitesinin belirli bir yüzdesi kadar büyütür; bu model %15 ekler. Ucuzdur ve her tüccar ya da madenci için değer.", false],
	],
	"item/64": [
		[0, "", "[[item/64]], ambarı %25 büyütür; düşük bir fiyata [[item/63]] modeline göre belirgin bir ilerlemedir.", false],
	],
	"item/65": [
		[0, "", "[[item/65]], ambarı %40 büyütür. Büyük bir yük gemisinde küçük bir geminin taşıdığı alanın tamamı kadar yer ekler.", false],
	],
	"item/66": [
		[0, "", "[[item/66]], ambarı %75 büyütür; bu, dükkânlarda satılan sıkıştırıcıların en yüksek değeridir.", false],
	],
	"item/67": [
		[0, "", "[[item/67]], gövde kapasitesinin %100'ünü ekleyerek ambarı ikiye katlar: bununla bir [[ship/36]] 700 t taşır. Asla hazır satılmaz. Planı [[station/90]] istasyonundaki [[agent/9]] adlı ajandan gelir ve yalnızca ticari mallardan üretilir.", false],
	],
	"item/68": [
		[0, "", "[[item/68]], temel çekici ışındır. Çekici ışın olmadan yüzen hiçbir konteyner toplanamaz; içine uçmak bir şey yapmaz. Retractor ile konteyneri 4 saniye nişangâhın altında tutarsınız, ardından içeri çekilir. [[item/69]] daha az süre gerektirir, [[item/70]] ise otomatik çalışır.", false],
		[24, "", "[[character/6]], [[faction/9|Void'lere]] karşı ilk seferden önce, gemilerinin kalıntılarını toplayabilmesi için [[character/0]] adlı pilottan bir çekici ışın takmasını ister. O zamana kadar dükkânların, olağan çeşitlerinin üstüne bir Retractor bulundurma olasılığı yüksektir.", false],
	],
	"item/69": [
		[0, "", "[[item/69]], [[item/68]] gibi çalışır, ama konteyneri içeri çekmeden önce hedefin yalnızca 3 saniye nişangâhın altında kalması gerekir.", false],
	],
	"item/7": [
		[0, "", "[[item/7]], 2.200 menzilde her 0,8 saniyede 10 hasar verir. Zaman içinde [[item/1]] ile eşittir; bu yüzden değeri uzun menzilde daha az ama daha ağır vuruşlarında yatar.", false],
	],
	"item/70": [
		[0, "", "[[item/70]], otomatik çekici ışındır: ileri görüş alanındaki her konteyneri nişan alıp tutmaya gerek kalmadan toplar; bu da bir savaş alanını yağmalarken çok zaman kazandırır. [[item/69]] ışınından çok daha pahalıdır.", false],
	],
	"item/71": [
		[0, "", "[[item/71]], temel takviyedir. Bir takviye kısa bir ek hız patlaması sağlar, ardından dolmak için zamana ihtiyaç duyar. Bu model 3 saniye boyunca %60 hız ekler ve 8 saniyede dolar.", false],
	],
	"item/72": [
		[0, "", "[[item/72]], 4,4 saniye boyunca %80 ek hız ve 10 saniyelik dolum süresiyle derecelendirilmiştir. Uçuşta patlaması [[item/71]] ile aynı azami hıza ulaşır; kattığı şey daha uzun bir patlamadır.", false],
	],
	"item/73": [
		[0, "", "[[item/73]], daha ucuz takviyelerin kazancını iki katından fazlasına çıkarır: 5,6 saniye boyunca %160 ek hız, 12 saniyede dolum.", false],
	],
	"item/74": [
		[0, "", "[[item/74]], en güçlü takviyedir: 6 saniye boyunca %200 ek hız. En uzun dolum süresine, 16 saniyeye ihtiyaç duyar. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/75": [
		[0, "", "[[item/75]], oyundaki tek onarım robotudur ve bir donanım yuvasına takılır. Siz uçarken her 0,6 saniyede bir gövde puanını ve her saniye bir zırh kaplama puanını geri getirir; böylece hasar, kenetlenmeden çatışmalar arasında silinir. Ucuzdur ve çoğu dükkânda bulunur.", false],
	],
	"item/76": [
		[0, "", "[[item/76]], temel yönlendirme memesidir. Bir meme değerini geminin manevra kabiliyetine ekler; böylece gemi daha hızlı döner. Bu model 20 ekler; çevik avcılar için küçük bir kazançtır, ama yavaş bir yük gemisinde fark edilir.", false],
	],
	"item/77": [
		[0, "", "[[item/77]], düşük bir fiyata [[item/76]] memesinin iki katı olan 40 manevra ekler.", false],
	],
	"item/78": [
		[0, "", "[[item/78]], 70 manevra ekleyen bir [[faction/1|Vossk]] memesidir. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/79": [
		[0, "", "[[item/79]], 100 manevra ekleyen bir [[faction/1|Vossk]] memesidir; bu, ağır bir yük gemisini çevik bir avcı gibi döndürmeye yeter. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/8": [
		[0, "", "[[item/8]], son ve en güçlü Berger lazeridir: 2.200 menzilde her 0,9 saniyede atış başına 12 hasar. Atış başına en sert vuran geleneksel lazerdir, ama daha hızlı [[item/2]] zaman içinde yine de daha fazla hasar verir. Ondan sonra gelen M6 ışın lazerleri ([[item/9]] ve sonrası) atış başına iki katından fazla sert vurur.", false],
	],
	"item/80": [
		[0, "", "[[item/80]], en iyi yönlendirme memesidir ve 130 manevra ekler. En yavaş dönen gövde olan [[ship/36]] gemisini 45'ten 175'e çıkarır; bu, memesiz hiçbir avcının sahip olmadığı bir değerdir. Dükkânlarda nadirdir.", false],
	],
	"item/81": [
		[0, "", "[[item/81]], temel tarayıcıdır. Bir tarayıcı, gemi, istasyon ya da asteroit gibi bir hedefe kilitlenmenin ne kadar süreceğini belirler; Quickscan 4 saniye gerektirir. [[item/82]] daha hızlı kilitlenir ve diğer gemilerin ne taşıdığını da gösterir.", false],
		[2, "", "[[character/2]] adlı tüccarın maden gemisi [[ship/0]], bunlardan biri takılı olarak gelir.", false],
	],
	"item/82": [
		[0, "", "[[item/82]], 3 saniyede kilitlenir ve hedeflenen gemilerin taşıdığı kargoyu gösterir; bu da ganimet ararken işe yarar.", false],
	],
	"item/83": [
		[0, "", "[[item/83]], 1,8 saniyede kilitlenir; bu süreye yalnızca [[item/84]] erişir. Hedeflerin kargosunu da gösterir.", false],
	],
	"item/84": [
		[0, "", "[[item/84]], [[item/83]] kadar hızlı kilitlenir ve kargoyu gösterir; ayrıca çekirdek verebilen tek asteroitler olan A sınıfı asteroitleri de işaretler (bkz. [[guide/mining]]). Madencilerin tercih ettiği tarayıcıdır.", false],
	],
	"item/85": [
		[0, "", "[[item/85]], oyundaki tek atlama motorudur. Takılıyken atlama kapılarından geçmeden yıldız haritasından başka bir sistemdeki bir istasyona doğrudan yolculuk edebilirsiniz. Bazı görevler sırasında kullanılamaz. Asla hazır satılmaz ve hiçbir ajan planını satmaz. Üretimi için büyük miktarda ticari malın yanı sıra [[item/164]], [[item/158]], [[item/160]] ve [[item/163]] gerekir.", false],
		[33, "", "Mucidi [[character/20]], uzayda her yere ulaşabilecek bir sürücü üzerindeki çalışması için [[character/0]] adlı pilottan 50 adet [[item/164]] ister.", false],
		[34, "", "Kristallerin karşılığında [[character/20]], [[character/0]] adlı pilota planın bir kopyasını verir. Teslim edilen 50 kristal sürücüye sayılır; bu yüzden yalnızca kalan bileşenlerin sağlanması gerekir.", false],
	],
	"item/86": [
		[0, "", "[[item/86]], temel maden lazeridir. Asteroitlerden cevher kazmak için bir maden lazeri gerekir. Verimi matkabın rotasını ne kadar istikrarlı tuttuğunu belirler ve her modelin kendi kazı hızı da vardır (bkz. [[guide/mining]]). Bu modelin verimi 30'dur ve derin katmanlarda rotada tutmak zordur.", false],
	],
	"item/87": [
		[0, "", "[[item/87]], 50 verime sahiptir. [[item/86]] lazerinden belirgin biçimde daha istikrarlıdır, ama biraz daha yavaş kazar.", false],
	],
	"item/88": [
		[0, "", "[[item/88]], 80 verimli bir [[faction/1|Vossk]] maden lazeridir; dükkânlarda satılan en istikrarlı matkaptır. Dezavantajı, cevher çıkarmada en yavaş olmasıdır. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/89": [
		[0, "", "[[item/89]], 60 verime sahiptir ve [[item/88]] lazerinden daha az istikrarlıdır, ama dükkânlarda satılan diğer tüm lazerlerden çok daha hızlı cevher çıkarır. Matkabı kendi başına rotada tutabilen madencilere uygundur.", false],
	],
	"item/9": [
		[0, "", "[[item/9]], M6 ışın lazerlerinin ilkidir. Bunlar seyrek ateş eder ama çok sert vurur: her 1,2 saniyede 27 hasar, önceki tüm lazerlerden uzun olan 2.400 menzilde. Hassas nişan önemlidir, çünkü ıska uzun bir yeniden doldurmayı boşa harcar. Aynı zamanda [[item/11]] üretiminin temel parçasıdır.", false],
	],
	"item/90": [
		[0, "", "[[item/90]], en iyi maden lazeridir: 100 verim ve tüm modeller arasında en hızlı kazı. Asla hazır satılmaz. Planı [[station/78]] istasyonundaki [[agent/11]] adlı ajandan gelir ve üretimi için büyük miktarda nanoteknoloji, mekanik malzeme ve hidrolik ile birlikte [[item/155]] ve on adet [[item/166]] gerekir.", false],
		[2, "", "[[character/0]] adlı pilotun ilk maden gemisindeki lazer, [[character/2]] adlı tüccarın bu matkaptan elle yaptığı prototiptir.", false],
		[10, "", "[[character/2]], [[ship/0]] gemisini [[character/0]] adlı pilota verirken elindeki tek örnek olan prototipi kendine saklar ve daha fazlasını yapmış olabileceği ileriki bir zamanda yeniden uğramasını önerir.", false],
	],
	"item/91": [
		[0, "", "[[item/91]], 3 yolcu barındırır. [[job/11]] görevleri için kabinler gerekir ve birkaç kabinin alanı toplanır. [[item/92]] ve [[item/93]] daha fazlasını alır.", false],
	],
	"item/92": [
		[0, "", "[[item/92]], 5 yolcu barındırır; [[item/91]] kabininden iki fazla.", false],
	],
	"item/93": [
		[0, "", "[[item/93]], 10 yolcu barındırır; [[item/92]] kabininin iki katı. Bu da daha büyük yolcu görevlerinin yolunu açar.", false],
	],
	"item/94": [
		[0, "", "[[item/94]], temel gizlenme cihazıdır. Gizlenme etkinken diğer gemiler sizi göremez. Bu model gemiyi 15 saniye gizler, sonra dolmak için 18 saniyeye ihtiyaç duyar. Gizli geçirilen süre [[medal/19]] madalyası için sayılır.", false],
	],
	"item/95": [
		[0, "", "[[item/95]], gemiyi 28 saniye gizleyen ve 32 saniyede dolan bir [[faction/1|Vossk]] gizlenme cihazıdır; [[item/94]] cihazının neredeyse iki katı koruma sağlar. Yalnızca [[faction/1|Vossk]] sistemlerindeki dükkânlarda bulunur.", false],
	],
	"item/96": [
		[0, "", "[[item/96]], en iyi gizlenme cihazıdır: gemiyi 46 saniye gizler ve yalnızca 40 saniyede dolar; böylece zamanın çoğunda etkin kalabilir. Asla hazır satılmaz. Planı [[station/59]] istasyonundaki [[agent/10]] adlı ajandan gelir.", false],
	],
	"job/0": [
		[0, "", "Bir kurye görevi, mühürlü yük konteynerlerinden oluşan bir yükü başka bir istasyona taşımanızı ister. Konteynerler kabul ettiğinizde ambarınıza yüklenir; bu yüzden yeterli boş yer gerekir. Konteynerler satılamaz. Görev, yük gemideyken hedefe kenetlendiğinizde tamamlanır. Korsanlar bazen kuryeleri pusuda bekler. Teslim edilen yük [[medal/5]] için sayılır.", false],
	],
	"job/1": [
		[0, "", "Bir savunma görevinde bir istasyon saldırıya uğramak üzeredir ve siz, istasyonun kendi avcılarının baskıncıları püskürtmesine yardım etmek için tutulursunuz. Saldırganlar genellikle korsandır, değilse rakip ırkın gemileridir. İstasyona uçun ve tüm saldırganları yok edin; müttefik avcıların düşürdükleri de sayılır. Daha zor görevler daha fazla saldırgan getirir.", false],
	],
	"job/10": [
		[0, "", "Bir önleme görevinde, yasa dışı kargo taşıyan iki ya da üç yük gemisinden oluşan bir konvoy bir istasyondan çok uzakta, avcı gemilerinin korumasında durur. Ara noktaları izleyin ve yük gemilerini yok edin. Muhafızları yol boyunca ve konvoyun çevresinde bekler.", false],
	],
	"job/11": [
		[0, "", "Bir yolcu görevi, bir grup insanı başka bir istasyona götürmenizi ister. Kabul ettiğinizde hepsine yetecek yere sahip kabinler gerekir; onlar gemideyken kabinler sökülemez ve gövde değiştirilemez. Onları teslim etmek için hedefe kenetlenin. Temel ödül daha düşüktür, ama her yolcu ona eklenir. Teslim edilen yolcular [[medal/18]] için sayılır.", false],
	],
	"job/12": [
		[0, "", "Bir meydan okuma, Uzay Salonu'nda başka bir pilotun sunduğu bir atış yarışmasıdır. İkiniz de aynı istasyondan, bir rota boyunca dağılmış bir grup korsana doğru uçarsınız ve onlardan daha çoğunu düşüren kazanır. Rakip yok edilemez ve sizin silahlarınız kadar sert vurur. Yalnızca daha çok düşürürseniz ödeme alırsınız; korsan sayısı her zaman tektir, bu yüzden beraberlik olmaz.", false],
	],
	"job/2": [
		[0, "", "Bir koruma görevi sizi, bir istasyonun yakınındaki bir asteroit alanında çalışan maden gemilerini korumaya gönderir. Baskıncılar gelir ve istasyona ve madencilere yönelir. Madencileri yok etmelerine fırsat vermeden hepsini yok edin; tüm maden gemileri kaybedilirse görev başarısız olur.", false],
	],
	"job/3": [
		[0, "", "Bir geri alma görevinde çalınan mallar, bir istasyonun yakınındaki bir grup korsan gemisinden biri tarafından taşınmaktadır. Konteyneri yok etmeden geri almanız gerekir: taşıyıcıyı bir EMP silahıyla etkisiz hâle getirin ve konteyneri bir çekici ışınla içeri çekin. Kargo gösteren bir tarayıcı doğru gemiyi bulmanıza yardım eder. Taşıyıcı yok edilirse ya da ambarınızda yer yoksa konteyner kaybolur. Konteyneri aldıktan sonra ödemeyi almak için görevi aldığınız istasyona dönün. Geri alma iki katı öder.", false],
	],
	"job/4": [
		[0, "", "Korsan avı, bir istasyonun yakınındaki bir korsan sığınağını temizlemek demektir. Korsanlar asteroit alanında ya da iki veya üç ara noktalık bir rota üzerinde bekler ve ancak sizi gördüklerinde harekete geçer. Ara noktaları izleyin ve tüm korsanları yok edin. Daha yüksek zorluk daha fazla korsan demektir.", false],
	],
	"job/5": [
		[0, "", "Bir kurtarma görevi bir kurtarma operasyonudur: bir istasyonun yakınındaki bir grup gemiden birinde bir rehine tutulmaktadır. Geri alma görevinde olduğu gibi, kaçıranın gemisini EMP ile etkisiz hâle getirin ve rehineyi gemiye almak için bir çekici ışın kullanın; o gemiyi yok etmek görevi sona erdirir. Ardından rehineyi görevi kabul ettiğiniz istasyona geri getirin. Kurtarma iki katı öder.", false],
	],
	"job/6": [
		[0, "", "Bir aranan suçlu görevi, bir istasyonun yakınında görülmüş tehlikeli bir suçlunun adını verir. Hedef uzakta bir noktada bekler ve ancak siz göründüğünüzde tepki verir. Sıradan bir korsandan çok daha dayanıklıdır ve görevin zorluğuyla ve pilot seviyenizle daha da dayanıklı hâle gelir. Ödülü almak için onu yok edin.", false],
	],
	"job/7": [
		[0, "", "Çöp temizleme, bir istasyonun yakınındaki bir uzay çöpü bulutunu yaklaşık iki dakika içinde temizlemenizi ister. Süre dolmadan her parça yok edilmelidir; yüksek zorlukta birkaç korsan da katılır. Çoğu görevden daha az öder, ama çabuktur ve yok edilen çöp [[medal/10]] için sayılır.", false],
	],
	"job/8": [
		[0, "", "Bir satın alma görevi, Uzay Salonu'nda belirli bir eşyadan belirli bir miktar isteyen bir alıcıdan gelir. Malları dükkânlardan, tüccarlardan ya da madencilikle edinin ve mallar ambarınızdayken alıcının istasyonuna yeniden kenetlenin. Mallar teslim edilir ve size olağan görev ödülünün yarısı artı malların ortalama değerinin üç katı ödenir; bu yüzden bir alıcı genellikle herhangi bir dükkândan çok daha fazla öder. Alıcılar [[step/16]] itibarıyla ortaya çıkar.", false],
	],
	"job/9": [
		[0, "", "Bir eskort görevi, bir istasyonun yakınında beş yük gemisinden oluşan bir konvoyu korumanızı ister. Yük gemileri ilerledikçe rotaları boyunca bekleyen saldırganlar yaklaşır. Tüm saldırganları yok edin. Tüm yük gemileri kaybedilirse görev başarısız olur. Eskort görevleri çoğu görevden beşte bir daha fazla öder.", false],
	],
	"medal/0": [
		[0, "", "[[character/0]], geçmişteki hizmetleri için bu madalyaya oyunun başından itibaren sahiptir. Onu kazanmak için yapacak bir şey yoktur.", false],
	],
	"medal/1": [
		[0, "", "Çok az gövde kalmışken bir istasyona ulaşınca verilir. Denetim, kenetlenme gemiyi onarmadan önce, yaklaşırken yapılır ve zırh plakasını değil gövdenin kendi dayanıklılığını kullanır. Kalan pay ne kadar düşükse kademe o kadar iyidir.", false],
	],
	"medal/10": [
		[0, "", "[[job/7]] görevlerinde bulunan türden uzay çöpünü yok edince verilir. Vurduğunuz her parça sayılır.", false],
	],
	"medal/11": [
		[0, "", "Kenetlendiğiniz farklı istasyonların sayısı için verilir.", false],
	],
	"medal/12": [
		[0, "", "Ziyaret ettiğiniz farklı sistemlerin sayısı için verilir. Gizli sistemler, onlara ulaştığınızda sayılır.", false],
	],
	"medal/13": [
		[0, "", "Sahip olduğunuz planların sayısı için verilir. Planlar Uzay Salonu'ndaki ajanlardan satın alınır; bkz. [[guide/blueprints]].", false],
	],
	"medal/14": [
		[0, "", "En az bir kez tamamladığınız farklı planların sayısı için verilir. Aynı eşyayı yeniden üretmek sayıyı artırmaz.", false],
	],
	"medal/15": [
		[0, "", "Oyunda geçirdiğiniz sürenin saat cinsinden değeri için verilir. Oyun, uçuşta geçen süreyi sayar.", false],
	],
	"medal/16": [
		[0, "", "Tamamlanan serbest görevlerin sayısı için verilir. Başarısız olan ve bırakılan görevler sayılmaz.", false],
	],
	"medal/17": [
		[0, "", "Bir atlama kapısından geçtiğiniz kez sayısı için verilir. Atlama motoruyla yapılan atlamalar sayılmaz.", false],
	],
	"medal/18": [
		[0, "", "[[job/11]] görevlerinde teslim edilen yolcu sayısı için verilir. Daha fazla kabin alanı daha büyük gruplar demektir.", false],
	],
	"medal/19": [
		[0, "", "Gizlenmiş hâlde geçirilen toplam dakika için verilir. Bir gizlenme cihazı takın ve dolu olduğu her an kullanın.", false],
	],
	"medal/2": [
		[0, "", "Farklı türde cevher kazınca verilir. Ne kadar kazarsanız kazın, her tür bir kez sayılır. Alanlar ana yurdu yakında olan cevherleri barındırdığından, galaksinin birkaç farklı bölgesinde kazı yapmanız gerekir.", false],
	],
	"medal/20": [
		[0, "", "Fırlatılan EMP bombası ve nükleer bomba sayısı için verilir.", false],
	],
	"medal/21": [
		[0, "", "Enkazlardan ve etkisiz hâle getirilmiş gemilerden bir çekici ışınla toplanan [[item/131]] tonu için verilir.", false],
	],
	"medal/22": [
		[0, "", "Hiç silah ya da hiç donanım takılı olmadan uçmak için verilen tek kademeli bir madalyadır; bir sonraki kenetlenmenizde denetlenir. Hikâyenin başında kazanılamaz: [[step/8]] öncesinde gemi her zaman silahlı sayılır.", false],
	],
	"medal/23": [
		[0, "", "Aynı anda takılı birincil silah sayısı için verilir ve kenetlendiğinizde denetlenir. Yüksek kademeler için çok sayıda birincil yuvası olan bir gövde gerekir. [[medal/22]] gibi bu madalya da ancak [[step/8]] itibarıyla sayılır.", false],
	],
	"medal/24": [
		[0, "", "Enkazlardan ve etkisiz hâle getirilmiş gemilerden bir çekici ışınla alınan kargonun tonu için verilir.", false],
	],
	"medal/25": [
		[0, "", "Bir anda sahip olduğunuz en yüksek kredi miktarı için verilir. Sonradan para harcamak bunu geri almaz.", false],
	],
	"medal/26": [
		[0, "", "Uzay Salonu'nda sunacak bir şeyi olan konuklarla konuşunca verilir. Her konuk, onunla ilk konuştuğunuzda bir kez sayılır.", false],
	],
	"medal/27": [
		[0, "", "Uzay Salonu'nda kiraladığınız kanat pilotu sayısı için verilir; her gruptaki her pilot sayılır.", false],
	],
	"medal/28": [
		[0, "", "İki itibar ölçeğinden birini herhangi bir yönde 60'ın ötesine iterek dört büyük ırktan birini kendinize düşman etmek için verilen tek kademeli bir madalyadır. Bkz. [[guide/combat]].", false],
	],
	"medal/29": [
		[0, "", "Silahlarınızla yok ettiğiniz asteroit sayısı için verilir. Madencilikle parçalanan asteroitler sayılmaz.", false],
	],
	"medal/3": [
		[0, "", "Farklı türde çekirdek kazınca verilir. Çekirdekler yalnızca A sınıfı bir asteroidin yedi katmanının hepsini delip geçince elde edilir; bu yüzden yolculuğun yanı sıra sabır ve iyi bir maden lazeri de gerekir.", false],
	],
	"medal/30": [
		[0, "", "Hikâyeyi tamamlamak için verilen tek kademeli bir madalyadır.", false],
	],
	"medal/31": [
		[0, "", "Bir anda sahip olduğunuz en fazla boş kargo alanı için verilir. Kargo sıkıştırma birimleri takılı ve ambarı boş büyük bir gövde yüksek kademeleri kazandırır.", false],
	],
	"medal/32": [
		[0, "", "Uzay Salonu'nda \"No, thanks\" (Hayır, teşekkürler) ile geri çevirdiğiniz teklif sayısı için verilir.", false],
	],
	"medal/33": [
		[0, "", "Uzay Salonu'nda bir konuktan \"How was that again?\" (Nasıldı, bir daha?) ile bir teklifi tekrarlamasını istediğiniz kez sayısı için verilir.", false],
	],
	"medal/34": [
		[0, "", "Başka istasyonlardaki görevleri, müşteriye önce zor olup olmayacağını sormadan kabul ettiğinizde verilir.", false],
	],
	"medal/35": [
		[0, "", "Başka istasyonlardaki görevleri, müşteriden önce hedefi haritada göstermesini istemeden kabul ettiğinizde verilir.", false],
	],
	"medal/36": [
		[0, "", "Diğer tüm madalyalara, herhangi bir kademede sahip olduğunuzda otomatik olarak verilir. Hepsine sahip olmanın başka ödülleri de vardır; bkz. [[guide/medals]].", false],
	],
	"medal/4": [
		[0, "", "Tüm oyun boyunca yok ettiğiniz gemi sayısı için verilir. Korsanlar, düşmanlar ve görev hedeflerinin hepsi sayılır.", false],
	],
	"medal/5": [
		[0, "", "[[job/0]] görevlerinde teslim edilen yükün tonu için verilir. Büyük kurye yükleri daha çok sayılır; bu yüzden büyük bir ambar işe yarar.", false],
	],
	"medal/6": [
		[0, "", "Tüm oyun boyunca kazılan toplam cevher tonu için verilir.", false],
	],
	"medal/7": [
		[0, "", "Tüm oyun boyunca kazılan çekirdek sayısı için verilir. Sonuna kadar delinen her A sınıfı asteroit bir tane verir.", false],
	],
	"medal/8": [
		[0, "", "İstasyon dükkânlarından satın alınan içkinin tonu için verilir. Her sistemin yerel içkisi sayılır.", false],
	],
	"medal/9": [
		[0, "", "Farklı türde içkiye sahip olunca verilir. Türler, onları Uzay Salonu'ndaki tüccarlardan satın aldığınızda ya da enkazlardan bir çekici ışınla topladığınızda sayılır.", false],
	],
	"ship/0": [
		[0, "", "[[ship/0]], gemi tablosundaki en zayıf gövdedir: 95 zırh, 25 t ambar, bir birincil ve bir ikincil yuva ve üç donanım yuvası. 140 olan manevra kabiliyeti bir başlangıç gemisi için saygındır, ama satıştaki en ucuz gövde olan [[ship/32]] aynı yuvalara daha fazla zırh, kargo alanı ve çeviklikle sahiptir. Hiçbir satıcı [[ship/0]] sunmaz; oyuncuya yalnızca hikâye yoluyla ulaşır.", false],
		[2, "", "[[character/2]], yamalı bu eski [[faction/8|korsan]] gemisinin sahibidir ve [[station/78]] istasyonunda [[character/0]] adlı pilotu, korsan renklerine boyanmış, bir maden lazeri ve bir [[item/81]] takılı ama silahsız olan bu gemiye bindirir. Lazer kendi prototipidir; daha sonra [[item/90]] adıyla satacağı tasarımdır.", false],
		[10, "", "Korsan sığınağına yapılan baskından sonra [[character/2]], sistemin gezegenleri arasında yolculuk için daha güçlü bir sürücüyle birlikte gemiyi temelli olarak [[character/0]] adlı pilota verir, ama prototip lazeri kendine saklar. Pilot, [[faction/0|Terran]] uzayına ulaştıktan sonra da bu gemiyle uçmayı sürdürür.", false],
		[18, "", "[[station/98]] istasyonunda [[character/1]], devriyeler onu korsan gemisi sanmasın diye gövdeyi [[faction/0|Terran]] renklerine boyatır.", false],
	],
	"ship/1": [
		[0, "", "[[ship/1]], dört ikincil yuvası olan en ucuz gövdedir; ayrıca bir taret yuvası, iki birincil silahı ve yedi donanım yuvası vardır. Zırhı (192) ve ambarı (65 t) sağlamdır. 106 olan manevra kabiliyeti yavaştır; bu yüzden en iyi torpidolar ve taretle savaşır. Biraz daha fazla paraya [[ship/9]], çok daha fazla zırh ve çeviklik sunar, ama tareti yoktur ve yalnızca iki ikincil yuvası vardır.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/10": [
		[0, "", "[[ship/10]], açılış sahnesinde [[character/0]] adlı pilotun kendi gemisidir ve iki [[item/3]] lazeriyle silahlanmıştır. Sağlam zırhı (200) ve 100 t ambarı dört ikincil yuva ve 150 manevra kabiliyetiyle birleştirir; bu da onu liste fiyatı en yakın gövde olan [[ship/11]] gemisinden çok daha çevik kılar. Zayıf noktası donanım yuvalarının azlığıdır: yalnızca beş. Sıradan satıcılar onu asla sunmaz.", false],
		[2, "", "Bir hiper sürücü arızası [[character/0]] adlı pilotu [[station/78]] istasyonuna taşır; orada [[character/2]] enkazı kurtarır ve parçalarına ayırır. Gemi bir daha sahibinin eline geçmez.", false],
	],
	"ship/11": [
		[0, "", "[[ship/11]], iyi donanımlı ağır bir yük gemisidir: 180 t ambar, 210 zırh, bir taret yuvası, iki birincil ve iki ikincil yuva ve sekiz donanım yuvası. 75 olan manevra kabiliyeti zayıftır. Daha ucuz [[ship/7]] ile karşılaştırıldığında ek bir ikincil yuva ve ek bir donanım yuvası için 60 t kargo alanından vazgeçer.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/12": [
		[0, "", "[[ship/12]], ikincil silahları üzerine kurulu bir avcıdır: üç ikincil yuva, iki birincil silah, altı donanım yuvası, 175 zırh ve 132 manevra kabiliyeti. 30 t ambarı çok küçüktür; bu yüzden ticarete ya da madenciliğe pek uygun değildir. [[ship/30]] daha pahalıdır ve daha az zırhla bir eksik ikincil yuva sunar.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/16": [
		[0, "", "[[ship/16]]; dört ikincil yuvası, iki birincil silahı, on donanım yuvası, 180 zırhı ve 120 manevra kabiliyeti olan, füze ağırlıklı bir avcıdır. 45 t ambarı küçüktür. Daha pahalı [[ship/21]] iki birincil silah ve bir donanım yuvası daha ekler.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/17": [
		[0, "", "[[ship/17]]; dört birincil silah, iki ikincil yuva ve on donanım yuvası taşır. Fiyatındaki bir gemi için zırhı (145), ambarı (65 t) ve manevra kabiliyeti (95) zayıftır; bu yüzden donanımına, özellikle kalkanlara ve zırh kaplamaya güvenir. Daha ucuz [[ship/19]], bir eksik donanım yuvasıyla daha fazla zırh ve kargo alanına sahiptir.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/18": [
		[0, "", "[[ship/18]], sekiz donanım yuvası olan küçük ve çevik bir gemidir (manevra 145); daha ucuz hiçbir gövdede bu kadar yuva yoktur. 115 olan zırhı ve 28 t ambarı zayıftır ve yalnızca iki birincil ve iki ikincil yuvası vardır. Zırhtan çok kalkanlara, gizlenme cihazına ve diğer donanımlara güvenen bir pilota uygundur.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/19": [
		[0, "", "[[ship/19]]; dört birincil yuvası, iki ikincil yuvası, dokuz donanım yuvası, 225 zırhı ve 105 t ambarı olan ağır bir hücumbottur. 90 olan manevra kabiliyeti yavaştır. Dört ileri silahı ve 100 t'dan büyük ambarı olan tek gemidir.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/2": [
		[0, "", "[[ship/2]], ucuz gövdeler arasında çevik bir çok yönlü gemidir: 155 zırh, 52 t ambar, bir birincil ve iki ikincil yuva, dört donanım yuvası ve 150 manevra kabiliyeti. Kargo alanı dışında her şeyde [[ship/35]] ile aynıdır; kargoda ise 12 t daha fazla taşır. İkinci bir silah isteyen pilotlar bunun yerine [[ship/5]] ya da [[ship/6]] gemisine bakar.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/20": [
		[0, "", "[[ship/20]], küçük ve hızlı bir gövdeye (manevra 155) altı donanım yuvası sığdıran hafif bir avcıdır. İki birincil silah taşır, ama yalnızca bir ikincil yuvası, 125 zırhı ve tablodaki en küçük ambar unvanını [[ship/0]] ile paylaşan 25 t ambarı vardır. Kalkanları, takviyeleri ve diğer donanımları erkenden isteyen ve kargo taşımayı düşünmeyen pilotlara uygundur.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/21": [
		[0, "", "[[ship/21]], dört birincil ve dört ikincil yuvası olan en ucuz gövdedir. Buna on bir donanım yuvası, 195 zırh ve 70 t ambar ekler. 100 olan manevra kabiliyeti ortalamadır. [[ship/29]] gemisinin bir basamak altında, eksiksiz bir savaş gemisidir.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/22": [
		[0, "", "[[ship/22]], bir milyon krediden pahalı gemiler arasında en büyük ambara (130 t) sahiptir; buna üç birincil ve üç ikincil yuva, dokuz donanım yuvası ve 118 manevra kabiliyeti eşlik eder. 160 olan zırhı fiyatına göre düşüktür. Aynı gemiyle hem ticaret yapan hem savaşan pilotlara uygundur.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/23": [
		[0, "", "[[ship/23]], taret yuvası olan en ucuz gövdedir ve 205 zırhı 100.000 kredinin altındaki gemilerin en yükseğidir. Buna iki birincil ve iki ikincil yuva, beş donanım yuvası, 55 t ambar ve 128 manevra kabiliyeti ekler; bu da onu sağlam bir orta sınıf çok yönlü gemi yapar. Başlıca sınırı donanım yuvalarının azlığıdır.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/24": [
		[0, "", "[[ship/24]], silahlı bir tüccar gemisidir: üç birincil silah, iki ikincil yuva, bir taret, sekiz donanım yuvası ve 95 t ambar. 170 olan zırhı ortalamadır; 125 olan manevra kabiliyeti ise bu kadar yük taşıyan bir gemi için iyidir. Ticaret, madencilik ve savaşı eşit derecede iyi karşılar.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/25": [
		[0, "", "[[ship/25]] bir füze taşıyıcısıdır: dört ikincil yuva, sekiz donanım yuvası ve 130 manevra kabiliyeti, ama yalnızca bir birincil silah. 124 zırhı ve 52 t ambarı fiyatına göre zayıftır; bu yüzden torpidolara ve kalkanlara bağımlıdır. [[ship/1]], fiyatının üçte birine aynı sayıda ikincil yuva artı bir taret sunar, ama daha az donanım yuvası vardır.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/26": [
		[0, "", "[[ship/26]], yedi donanım yuvası olan en ucuz gövdedir. Bunun dışında ortalama bir çok yönlü gemidir: 152 zırh, 64 t ambar, iki birincil ve iki ikincil yuva ve 108 manevra kabiliyeti. Daha ağır bir gemiyi alabilecek duruma gelmeden tam bir donanım seti isteyen pilotlara uygundur.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/27": [
		[0, "", "[[ship/27]], üç birincil yuvası olan en ucuz gövdedir. Bunları 176 zırh, iki ikincil yuva, altı donanım yuvası ve 50 t ambarla birleştirir. 113 olan manevra kabiliyeti yavaş sayılır; bu yüzden düşmanlarını dönüşte geride bırakmaktan çok karşılıklı darbelerle savaşır.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/28": [
		[0, "", "[[ship/28]], satıştaki en eksiksiz çok yönlü gemidir: üç birincil ve dört ikincil yuva, bir taret, on iki donanım yuvası ve 110 t ambar. Satın alınabilen başka hiçbir gemide hem taret hem bu kadar çok donanım yuvası yoktur. 195 olan zırhı iyi, 92 olan manevra kabiliyeti yavaştır. [[ship/29]] daha iyi savaşır, ama çok daha az taşır.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/29": [
		[0, "", "[[ship/29]], sıradan satıcıların sattığı en pahalı gemi ve en iyi avcıdır: dört birincil ve dört ikincil yuva, on iki donanım yuvası, 240 zırh ve 118 manevra kabiliyeti. 75 t ambarı mütevazıdır ve tareti yoktur. Savaşta onu yalnızca [[ship/8]] geride bırakır.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/3": [
		[0, "", "[[ship/3]], dengeli bir erken dönem çok yönlü gemisidir: iki birincil ve iki ikincil yuva, beş donanım yuvası, 135 zırh ve 55 t ambar. 112 olan manevra kabiliyeti küçük bir gemi için yavaştır. Fiyatı, çok daha hızlı dönen ama daha az zırhı, daha az kargo alanı ve bir eksik ikincil yuvası olan [[ship/6]] ile hemen hemen aynıdır.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/30": [
		[0, "", "[[ship/30]], vasat bir avcıdır: 165 zırh, 45 t ambar, iki birincil ve iki ikincil yuva, altı donanım yuvası ve 128 manevra kabiliyeti. Fiyatına göre belirgin bir güçlü yanı yoktur; daha ucuz [[ship/12]] daha fazla zırha ve ek bir ikincil yuvaya sahiptir, [[ship/23]] ise bir taret ekler.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/31": [
		[0, "", "[[ship/31]]; 110 t ambarı, bir taret yuvası, iki birincil silahı ve altı donanım yuvası olan hafif bir yük gemisidir. Zırhı (156), tek ikincil yuvası ve 102 manevra kabiliyeti mütevazıdır. Biraz daha az kargo alanına ve bir eksik silaha, ama daha fazla zırha ve daha iyi manevra kabiliyetine sahip olan daha ucuz [[ship/33]] ile rekabet eder.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/32": [
		[0, "", "[[ship/32]], herhangi bir satıcının sattığı en ucuz gövde ve olağan ilk satın alımdır. Küçüktür ve zayıf korunur (100 zırh, 30 t ambar, bir birincil ve bir ikincil yuva, üç donanım yuvası), ama 160 manevra kabiliyetiyle ondan hızlı dönen tek gemi [[ship/4]] olur. [[ship/0]] ile karşılaştırıldığında biraz zırh ve kargo alanı ekler ve daha iyi manevra yapar. [[ship/35]] yaklaşık 8.000 kredi daha pahalıdır ve çok daha iyi zırh, ikinci bir ikincil yuva ve dördüncü bir donanım yuvası getirir.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/33": [
		[0, "", "[[ship/33]], 100 t'dan fazla kargo alanı (108 t) olan en ucuz gövdedir ve buna bir taret yuvası, 176 zırh ve altı donanım yuvası ekler. Yalnızca bir birincil silahı ve 112 manevra kabiliyetiyle bir avcıdan çok kendini savunabilen bir tüccar gemisidir. [[ship/31]], ikinci bir silahı ve biraz daha büyük ambarıyla yakın bir rakiptir, ama daha zayıf ve daha yavaştır.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/34": [
		[0, "", "[[ship/34]]; dört birincil yuvası, bir ikincil yuvası, altı donanım yuvası, 60 t ambarı ve 130 manevra kabiliyeti olan bir hücumbottur. Daha ucuz [[ship/4]] ile karşılaştırıldığında daha fazla kargo alanı ve ek bir donanım yuvası için zırhtan (170'e karşı 135) ve çeviklikten feragat eder.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/35": [
		[0, "", "[[ship/35]], fiyat listesinin en altındaki hafif bir avcıdır. Parasına karşılık iyi zırh (155), bir birincil ve iki ikincil yuva, dört donanım yuvası ve 150 gibi hızlı bir manevra kabiliyeti sunar, ama ambarı yalnızca 40 t'dur. [[ship/2]] birkaç bin kredi fazlasına 12 t daha fazla kargo alanı olan neredeyse aynı gemidir; [[ship/5]] ise daha fazla zırh, kargo ve ikinci bir silah için çeviklikten feragat eder.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/36": [
		[0, "", "[[ship/36]], 350 t ambarıyla oyundaki en büyük yük gemisidir. Hiç birincil yuvası yoktur ve savunma için dört ikincil yuvasına ve bir tarete güvenmek zorundadır. Yedi donanım yuvası ve 200 zırh iyidir, ama 45 olan manevra kabiliyeti tablodaki en düşük değerdir. [[ship/7]] daha az taşır, ama iki ileri silahı korur ve daha iyi döner.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/4": [
		[0, "", "[[ship/4]], dört birincil yuvası olan en ucuz gövdedir ve 162 manevra kabiliyetiyle oyundaki en çevik gemidir. 170 zırhı fiyatına göre iyidir. Bedeli 38 t ambar, tek ikincil yuva ve beş donanım yuvasıdır; bu yüzden saf bir it dalaşı gemisidir. [[ship/34]] de dört silah taşır; daha fazla kargo alanı ve donanım yuvasına, ama daha az zırh ve çevikliğe sahiptir.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/5": [
		[0, "", "[[ship/5]], iki birincil yuvası olan en ucuz gövdedir ve 170 zırhı fiyatına göre yüksektir. 60 t ambarı onu erken ticaret ve madencilik için de kullanışlı kılar. Dezavantajları tek ikincil yuva, yalnızca dört donanım yuvası ve 115 gibi ağır bir manevra kabiliyetidir. Çevikliği zırha tercih eden pilotlar benzer fiyattaki [[ship/2]] ya da [[ship/35]] gemisini seçer.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/6": [
		[0, "", "[[ship/6]], iki birincil yuvası, bir ikincil yuvası, beş donanım yuvası ve 148 manevra kabiliyeti olan hafif ve hızlı bir avcıdır. 105 olan zırhı çok incedir; yalnızca [[ship/0]] ve [[ship/32]] daha azına sahiptir; bu yüzden dayanıklılıktan çok hıza güvenir. Neredeyse aynı fiyata [[ship/3]], manevra kabiliyeti pahasına daha fazla zırh, daha fazla kargo alanı ve ikinci bir ikincil yuva sunar.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/7": [
		[0, "", "[[ship/7]]; 240 t ambarı, 220 zırhı, bir taret yuvası, iki birincil silahı, bir ikincil yuvası ve yedi donanım yuvası olan ağır bir yük gemisidir. 65 manevra kabiliyetiyle yavaş döner. [[ship/36]] ile karşılaştırıldığında ileri silahlar ve daha iyi manevra kabiliyeti için 110 t kargo alanından vazgeçer; daha pahalı [[ship/11]] ise bir donanım yuvası ve ikinci bir ikincil yuva ekler.", false],
		[0, "", "[[faction/1|Vossk]] sistemleri dışındaki her satıcı bunu satabilir.", false],
	],
	"ship/8": [
		[0, "", "[[ship/8]], onarılmış bir [[faction/9|Void]] avcısı ve oyundaki en güçlü gemidir. 450 zırhı diğer tüm gövdelerin neredeyse iki katıdır; dört birincil ve dört ikincil yuvası ve on beş donanım yuvası vardır; 155 olan manevra kabiliyeti de en iyiler arasındadır. Tek zayıflığı 30 t ambarıdır. Sekiz milyon krediyi aşan liste fiyatı, [[ship/29]] gemisininkinin neredeyse iki katıdır.", false],
		[0, "", "Sıradan satıcılar onu satmaz. Yalnızca [[station/10]] istasyonunda, oyuncu tüm madalyalara altın olarak sahip olduğunda bir prototip olarak sunulur (bkz. [[guide/medals]]).", false],
	],
	"ship/9": [
		[0, "", "[[ship/9]], [[faction/1|Vossk]] satıcılarının sattığı tek gemidir ve başka bir şey satmazlar. 250 zırhı, [[ship/8]] dışındaki tüm gövdelerin en yükseğidir ve bunu 152 gibi hızlı bir manevra kabiliyeti, iki birincil ve iki ikincil yuva, yedi donanım yuvası ve 65 t ambarla birleştirir. Fiyatına göre bulunabilecek en dayanıklı avcıdır, ama [[ship/1]] gemisinin tareti ve ek yuvaları onda yoktur.", false],
		[36, "", "[[character/7]], [[faction/1|Vossk]] gemilerini normalde yalnızca kendi ırklarının uçurduğunu açıklar; bu gemi bir istisnadır: diğer ırklara satılabilmesi için uyarlanmış bir tasarımdır.", false],
	],
	"station/0": [
		[0, "", "[[station/0]], [[system/0]] sisteminin atlama kapısını taşır. [[step/13]] sırasındaki bekleme süresi bu istasyona kayıtlıdır, ama bu adım herhangi bir yerde salon görevleri bitirilerek tamamlanır ve burada hiçbir şey olmaz.", false],
	],
	"station/10": [
		[0, "", "[[station/10]], [[system/6]] sisteminin tek istasyonudur ve atlama kapısını taşır. Serbest görevler sizi asla buraya göndermez. Salonunda ajan [[agent/3]] bir plan satar ve tüm madalyalar altın olduğunda istasyon bir prototip [[ship/8]] sunar.", false],
		[23, "", "İstasyon, [[character/6]] tarafından yönetilen Deep Science'ın gizli araştırma üssüdür. [[character/0]] buraya [[step/23]] sırasında [[character/5]] ile gelir ve birkaç kez geri döner: Void'lere yapılacak keşif seferini planlamak, [[character/20]] ile buluşmak ve kristallerini teslim etmek için.", false],
	],
	"station/18": [
		[0, "", "[[station/18]], [[system/3]] sisteminde mütevazı bir Vossk istasyonudur. Salonunda ajan [[agent/12]], [[system/0]] sisteminin koordinatlarını satar.", false],
	],
	"station/20": [
		[0, "", "[[station/20]], [[system/4]] sisteminin atlama kapısını taşır. Salonunda Midorian ajan [[agent/2]] bir silah planı satar.", false],
	],
	"station/22": [
		[0, "", "[[station/22]], [[system/4]] sistemindeki en gelişmiş istasyondur.", false],
		[38, "", "[[step/38]] sırasında Nivelian patlayıcılarını taşıyan konvoy, istasyonun yakınında Midorian avcı gemilerinin eskortunda görülür. [[character/0]], konvoyu yok etmeden eskortu püskürtmek zorundadır.", false],
	],
	"station/26": [
		[0, "", "[[station/26]], [[system/5]] sisteminde en yüksek teknolojiye sahip bir Vossk istasyonudur. Salonunda Bobolian ajan [[agent/13]], [[system/1]] sisteminin koordinatlarını satar.", false],
	],
	"station/27": [
		[36, "", "[[station/27]] yakınında [[character/7]] ve [[character/0]], [[step/36]] sırasında bir korsan sığınağına baskın düzenler; daha çok korsan yok eden kazanır.", false],
		[37, "", "[[character/0]] kazanır ve Vossk yük gemisine eskortluk etme hakkını elde eder. Buradan [[character/1]] adlı dostuna rapor verir.", false],
	],
	"station/29": [
		[35, "", "[[station/29]], Void'lere karşı saldırı için bir K'Sarr yük gemisi sağlamayı kabul eden Vossk komutanı [[character/7]] adlı karakterin istasyonudur. [[character/0]] onunla [[step/35]] sırasında burada buluşur.", false],
		[36, "", "[[character/7]], yük gemisini bir Vossk dışında kimsenin uçurmasına izin vermez ve [[character/0]] adlı pilotu eskort pilotu olarak kendini kanıtlamaya davet eder.", false],
	],
	"station/3": [
		[0, "", "[[station/3]], gizli [[system/0]] sisteminde yüksek teknolojili bir Nivelian istasyonudur. Salonunda bir silah planı satan ajan [[agent/0]] bulunur.", false],
	],
	"station/30": [
		[34, "", "[[step/34]] sırasında [[character/1]], Void ana gemisine karşı bir planla [[station/30]] istasyonunda bekler.", false],
		[35, "", "Plan, Nivelian nükleer patlayıcılarıyla dolu ağır bir yük gemisini ana geminin içine uçurmaktır.", false],
		[39, "", "Geri alınan patlayıcılar buraya ulaşır ve Vossk yük gemisine yüklenir. [[step/39]] sırasında [[character/1]] son operasyonu açıklar.", false],
	],
	"station/43": [
		[0, "", "[[station/43]], [[system/8]] sisteminde küçük bir Terran istasyonudur. Salonunda ajan [[agent/4]] ucuz bir roket planı satar.", false],
	],
	"station/48": [
		[24, "", "[[station/48]] yakınında Void gemileri görülmüştür. [[step/24]] sırasında [[character/0]], onları gözlemlemek ve bir çekici ışınla enkaz toplamak için [[character/6]] adlı bilim insanını buraya getirir.", false],
		[25, "", "Enkaz toplamanın sonunda bir solucan deliği, [[character/6]] de içindeyken [[character/0]] adlı pilotun gemisini yutar.", false],
		[27, "", "Başka bir solucan deliğinden geri döndüklerinde Void avcı gemileri peşlerine düşer ve [[character/0]], [[station/10]] istasyonuna dönmeden önce onları burada yok etmek zorunda kalır.", false],
	],
	"station/54": [
		[0, "", "[[station/54]], yalnızca bir atlama motoruyla ulaşılabilen [[system/10]] sisteminde en yüksek teknolojiye sahip bir Vossk istasyonudur. Salonunda Vossk ajan [[agent/5]] bir füze planı satar.", false],
	],
	"station/55": [
		[0, "", "[[station/55]], [[system/11]] sisteminin atlama kapısını taşır.", false],
		[19, "", "[[character/5]] adlı bilim insanını fidye için tutan korsanlar istasyonun yakınında bulunur. Deep Science, [[character/0]] için hangarına EMP bombaları bırakır.", false],
		[22, "", "Kurtarmanın ardından [[character/0]], serbest kalan subayla istasyonda buluşur ve [[system/6]] sisteminin koordinatlarını alır.", false],
	],
	"station/56": [
		[18, "", "[[station/56]], [[step/18]] sırasında [[character/0]] adlı pilotun bir Deep Science subayını alması gereken buluşma noktasıdır.", false],
		[19, "", "Subay hiç gelmez. Bunun yerine [[character/1]] adlı dostundan gelen bir mesaj, korsanların onu kaçırdığını bildirir.", false],
	],
	"station/59": [
		[0, "", "[[station/59]], Vossk sistemi [[system/20]] içinde küçük bir istasyondur. Salonunda bir gizlenme cihazı planı satan Terran ajan [[agent/10]] bulunur.", false],
	],
	"station/61": [
		[0, "", "[[station/61]], [[system/12]] sistemindeki yalnızca iki istasyondan biridir. Salonunda Multipod ajan [[agent/6]] bir nükleer silah planı satar.", false],
	],
	"station/65": [
		[0, "", "[[station/65]], [[system/13]] sisteminin atlama kapısını taşır. Salonunda Cyborg ajan [[agent/14]], [[system/10]] sisteminin koordinatlarını satar.", false],
	],
	"station/72": [
		[0, "", "[[station/72]], güvenli [[system/14]] sisteminde küçük bir Terran istasyonudur. Salonunda ajan [[agent/7]] bir kalkan planı satar.", false],
	],
	"station/76": [
		[11, "", "[[station/76]], [[system/15]] sisteminde çağrılara yanıt vermeyi bırakmış bir istasyondur. [[step/11]] sırasında [[character/3]], nedenini öğrenmesi için [[character/0]] adlı pilotu gönderir.", false],
		[12, "", "İstasyon zarar görmemiştir. Mürettebatı yalnızca çalışacak durumda değildir; bunun nedeni, [[character/0]] adlı pilotun eski bir tanıdığı olan satıcı [[character/4]] tarafından getirilen bir parti nöro-algdir.", false],
	],
	"station/78": [
		[0, "", "[[station/78]], [[system/15]] sisteminde Nivelian cevher tüccarı [[character/2]] adlı karaktere ait küçük bir maden istasyonudur. Hikâye onun yörüngesinde başlar.", false],
		[1, "", "[[character/0]] adlı pilotun hasarlı gemisi otopilotla buraya sürüklenir ve [[character/2]] gemiyi pilotuyla birlikte içeri alır.", false],
		[2, "", "[[character/2]] enkazı söker ve [[character/0]] adlı pilotu [[ship/0]] ile yakındaki asteroitlerde cevher kazmaya koşar.", false],
		[8, "", "Bir korsan baskınından kaçtıktan sonra [[character/0]] ilk silahını takar ve istasyonun yakınındaki korsan sığınağını yok etmesinde [[character/2]] adlı tüccara yardım eder.", false],
		[10, "", "Ardından [[character/2]] ona gemiyi verir ve onu [[station/79]] istasyonuna gönderir.", false],
		[0, "", "Oyunun ilerleyen bölümlerinde [[character/2]], istasyonun salonunda kendi maden matkabının planını satar.", false],
	],
	"station/79": [
		[0, "", "[[station/79]], [[system/15]] sisteminde bir istasyon ve sistemin komutanı [[character/3]] adlı karakterin makamıdır.", false],
		[10, "", "[[step/9]] sırasında [[character/2]], [[character/0]] adlı pilotu, Terran uzayına ulaşmasına yardım edebilecek bir insan olan [[character/3]] ile buluşması için buraya gönderir.", false],
		[11, "", "[[character/3]], [[faction/3|Mido Konfederasyonu'nu]] anlatır ve yardımına karşılık ondan [[station/76]] istasyonunu kontrol etmesini ister.", false],
		[13, "", "[[station/76]] hakkındaki rapordan sonra [[character/3]], onu istasyona gelmesi beklenen bir Terran konvoyuyla temasa geçireceğine söz verir.", false],
		[15, "", "Konvoy [[step/14]] sırasında geldiğinde [[character/0]] adlı pilotu korsan sanır, gemisini etkisiz hâle getirir ve onu gemiye alır.", false],
	],
	"station/8": [
		[0, "", "[[station/8]], gizli [[system/1]] sisteminde bir Terran istasyonudur. Salonunda Nivelian ajan [[agent/1]] bir plan satar.", false],
	],
	"station/84": [
		[0, "", "[[station/84]], [[system/16]] sisteminde bir Terran istasyonudur. Salonunda Vossk ajan [[agent/8]] bir Vossk zırhı planı satar.", false],
	],
	"station/88": [
		[0, "", "[[station/88]], [[system/17]] sisteminde küçük bir Nivelian istasyonudur. Salonunda Vossk ajan [[agent/15]], [[system/21]] sisteminin koordinatlarını satar.", false],
	],
	"station/90": [
		[0, "", "[[station/90]], [[system/18]] sisteminin atlama kapısını taşır. Salonunda ajan [[agent/9]] bir kargo sıkıştırıcı planı satar.", false],
	],
	"station/91": [
		[28, "", "[[step/28]] sırasında [[station/91]] yakınında Void hareketliliği bildirilir. [[character/0]], Void ana gemisine bir sonda götürmek için burada çarpışa çarpışa bir solucan deliğine ilerler.", false],
		[31, "", "Void bölgesinden dönen [[character/0]], burada [[character/1]] adlı dostundan onu [[station/98]] istasyonuna davet eden bir çağrı alır.", false],
	],
	"station/98": [
		[15, "", "[[station/98]], [[system/19]] sisteminde bir Terran istasyonudur. [[character/0]] adlı pilotu tutuklayan kruvazör onu buraya getirir ve pilot, istasyonun başında eski dostu [[character/1]] adlı subayı bulur.", false],
		[16, "", "Konuşmaları sırasında Void avcı gemileri istasyona saldırır ve [[character/0]] onları püskürtmeye yardım eder.", false],
		[18, "", "[[character/1]] ona Void'ler hakkında bilgi verir ve onu Deep Science için işe alır.", false],
		[32, "", "[[step/31]] sırasında [[character/1]], [[character/0]] adlı pilotun gemisine erken uyarı sistemini taktırır ve ona [[character/20]] adlı bilim insanından söz eder.", false],
		[44, "", "Zaferden sonra [[character/0]] ile [[character/1]] istasyonda kutlama yapar ve [[character/6]] de onlara katılır.", false],
		[45, "", "Ertesi sabah [[character/6]] gitmiştir; geride bir not ve Deep Science'tan son bir ödeme bırakmıştır.", false],
	],
	"step/0": [
		[0, "", "[[character/0]], başlarına konan ödülü almak için bir [[faction/8|korsan]] çetesini bir asteroit kuşağında kovalar. Tüm korsan gemilerini bulup yok etmeniz gerekir.", false],
		[1, "", "Korsanların işi bitince Keith, Amiral Smith'in özel bir görev için kendisini görmek istediği Eden Prime'a rota çizer. Hiper sürücü çalışmaya başlarken son bir atış gemisine hasar verir. Sürücü arızalanır, yaşam desteği ağır hasar alır ve otopilot baygın pilotu en yakın istasyon olan [[station/78]] istasyonuna doğru götürür.", false],
	],
	"step/1": [
		[1, "", "Otopilot, Keith'in hasarlı gemisini, pilotu baygın hâlde içindeyken [[station/78]] istasyonunun yörüngesine getirmiştir.", false],
		[2, "", "Keith, [[faction/2]] cevher tüccarı [[character/2]] tarafından işletilen küçük bir maden istasyonunda uyanır. Gunant gemiyi parçalarına ayırmış ve kurtarma hakkıyla sahiplenmiştir. Galaksinin öbür ucundaki Eden Prime'a ulaşma fikrine güler ve Keith'in, artık [[system/15]] sisteminde bile görülen düşmanca varlıklar olan Void'leri hiç duymamış olmasına şaşırır.", false],
		[2, "", "Keith'in ne parası ne de gemisi vardır; bu yüzden silahsız bir gemiyle cevher kazarak Gunant için çalışmak zorundadır.", false],
	],
	"step/10": [
		[10, "", "Keith, [[character/3]] ile buluşmak için [[station/79]] istasyonuna uçar.", false],
		[11, "", "Norris, [[system/15]] sisteminin yakın zamanda keşfedilmiş bir bölgede bulunduğunu açıklar. Nivelian İç Savaşı sırasında Terran ve Nivelian sürgünleri buraya yerleşmiş ve bağımsız bir konfederasyon kurmuştur. Terranlar bunu kabul eder, ama Nivelianlar sistemde hâlâ hak iddia ettiği için sistemin kıyılarında çatışmalar sürer.", false],
		[11, "", "Norris, bir iyilik karşılığında Keith'i Terran Uzay Filosu ile temasa geçirmeyi önerir: [[station/76]] istasyonuyla bağlantı kesilmiştir ve nedenini deneyimli bir pilotun bulması gerekir.", false],
	],
	"step/11": [
		[11, "", "Keith, sessizliğin nedenini araştırmak için [[station/76]] istasyonuna uçar. İstasyon sağlam görünmektedir, çatışma izi yoktur; bu yüzden kenetlenir.", false],
		[12, "", "İçeride Keith, uzun zaman önce tanıdığı kötü şöhretli satıcı [[character/4]] ile karşılaşır. Mkkt bir parti nöro-alg getirmiştir ve tüm mürettebat iletişim sistemlerini çalıştıramayacak kadar sarhoştur. Keith ilk fırsatta oradan ayrılır.", false],
	],
	"step/12": [
		[12, "", "Keith rapor vermek için [[station/79]] istasyonuna döner.", false],
		[13, "", "Norris dehşete düşer ve satıcının icabına bakacağına söz verir. Kernstal'a doğru ilerleyen bir Terran askeri konvoyu, Keith'e filoyla temas kurma fırsatı verecektir. Norris, konvoy gelene kadar Keith'in Uzay Salonu'nda ücretli işler almasını önerir (bkz. [[guide/lounge]]).", false],
	],
	"step/13": [
		[13, "", "Konvoyu beklerken Keith'in Uzay Salonu'ndan iki serbest görev tamamlaması gerekir (bkz. [[guide/jobs]]).", false],
		[14, "", "Norris, Terran konvoyunun sisteme girdiğini ve [[station/79]] istasyonuna doğru ilerlediğini bildirir. Keith onu karşılamaya çıkar.", false],
	],
	"step/14": [
		[14, "", "Keith, [[station/79]] yakınında Terran konvoyunu ve birkaç korsanı bulur. Korsanları uzaklaştırmak için harekete geçer.", false],
		[15, "", "Eski korsan gemisi yüzünden Keith baskıncılardan biri sanılır. Konvoy EMP silahlarıyla gemisini etkisiz hâle getirir ve onu tutuklar. Keith, Terran uzayındaki [[station/98]] istasyonuna giden bir Terran kruvazörüne alınır.", false],
	],
	"step/15": [
		[15, "", "Keith, konvoyun tutsağı olarak [[station/98]] istasyonuna varır.", false],
		[16, "", "Sorumlu subay, Keith'in eski dostu ve artık Yıldızlararası Güvenlik Ajansı'nın şefi olan [[character/1]] adlı kişidir. Hata için özür diler. Yörüngede Void avcı gemileri belirip istasyon alarm verince kavuşmaları yarıda kalır.", false],
	],
	"step/16": [
		[16, "", "Brent, Keith'ten [[station/98]] istasyonuna saldıran [[faction/9|Void]] gemilerini püskürtmesine yardım etmesini ister (bkz. [[world/voids]]).", false],
		[17, "", "Void'ler barışçıl niyetler taşıdıklarını iddia eden bir mesaj yayınlar, ama yine de saldırırlar. Keith onları geri püskürtür; Brent de bildiği her şeyi bir kadeh şarap eşliğinde anlatacağına söz verir.", false],
	],
	"step/17": [
		[17, "", "Keith, Brent'in Void'ler hakkında bildiklerini dinlemek için [[station/98]] istasyonuna kenetlenir.", false],
		[18, "", "Void'ler son birkaç haftadır ortaya çıkmaktadır. Bir tür solucan deliğinden gelir, karşılarına çıkan her şeye saldırır ve cevher peşinde gibi görünürler; [[faction/1]] sistemleri bile baskına uğrar. Brent bir kriz ekibine başkanlık etmektedir ve ekibin bilim insanları Deep Science'ın yönettiği gizli bir araştırma istasyonunda toplanmaktadır. Keith'ten onlar için uçmasını ister.", false],
		[18, "", "İstasyonun sistemi standart yıldız haritalarında yer almaz; bu yüzden Keith'in koordinatları almak için [[system/11]] sistemindeki [[station/56]] istasyonunda Tğm. Thomas Boyle ([[character/5]]) ile buluşması gerekir. Brent ayrıca Keith'in gemisinin yeni olmadığını itiraf eder: yeni karışıklıkları önlemek için yalnızca yeniden boyanmıştır.", false],
	],
	"step/18": [
		[18, "", "Keith, Boyle ile buluşmak için [[station/56]] istasyonuna uçar.", false],
		[19, "", "Boyle hiç gelmemiştir. Brent, korsanların onu [[station/55]] yakınında kaçırdığını ve beş milyon kredi fidye istediğini bildirir. Brent ödemeye hazırdır, ama Keith kaçıranların parayı alınca Boyle'u öldüreceğini düşünür ve bunun yerine Kappa'ya yönelir.", false],
	],
	"step/19": [
		[19, "", "Keith, kaçıranları aramak için [[station/55]] istasyonuna uçar.", false],
		[20, "", "Kappa'nın tarayıcıları kaçıranların gemisinin yerini saptar. Brent istasyon hangarına EMP bombaları bıraktırmıştır; böylece Keith, kaçıranlar fidyeyi getirdiğini sanırken gemiyi etkisiz hâle getirebilecektir.", false],
	],
	"step/2": [
		[2, "", "Gunant, Keith'e eski ve defalarca onarılmış bir gemi verir: [[ship/0]]. Bu eski korsan gemisinde bir maden lazeri vardır, silah yoktur. Keith'in [[station/78]] yakınındaki asteroitlerden en az on ton cevher kazması gerekir (bkz. [[guide/mining]]).", false],
		[3, "", "Cevher yüklenince Gunant, yükün kontrol edilmesi için ona kenetlenmesini söyler. Silahı olmayan Keith'in oyuna uymaktan başka seçeneği yoktur.", false],
	],
	"step/20": [
		[20, "", "Keith'in [[station/55]] istasyonuna kenetlenmesi ve EMP bombalarını gemisine takması gerekir.", false],
		[21, "", "Bombalar takılınca Keith hemen yola çıkar.", false],
	],
	"step/21": [
		[21, "", "Bir ara nokta, yalnız olmayabilecek kaçıranların gemisini işaretler. Keith'in gemiyi yok etmek yerine bir EMP bombasıyla etkisiz hâle getirmesi ve varsa eskortunun icabına bakması gerekir.", false],
		[22, "", "Kaçıranlar, bomba sistemlerini çökertene kadar fidyenin geldiğini sanır. Brent, Boyle'u kurtarmak için bir ekip gönderir.", false],
	],
	"step/22": [
		[22, "", "Keith, kurtarılan bilim insanıyla görüşmek için [[station/55]] istasyonuna kenetlenir.", false],
		[23, "", "Boyle ona teşekkür eder. Kendi gemisi kaybolduğu için Keith onu götürmeyi önerir; Boyle da araştırma istasyonunun bulunduğu [[system/6]] sisteminin koordinatlarını Keith'in seyir bilgisayarına aktarır.", false],
	],
	"step/23": [
		[23, "", "Keith, Boyle'u Dr. Paolini'nin kendilerini beklediği [[system/6]] sistemindeki [[station/10]] istasyonuna getirir.", false],
		[24, "", "Keith, Deep Science projesini yöneten Dr. Carla Paolini ([[character/6]]) ile tanışır. Carla, Void gemilerinin enkazından başlayarak Void teknolojisini öğrenmek ister. Deep Science, gemisini donatması için Keith'e 20.000 kredi öder; bir çekici ışın şarttır.", false],
		[24, "", "Carla, son zamanlarda Void'lerin görüldüğü [[system/9]] sistemindeki [[station/48]] istasyonuna onunla birlikte uçmakta ısrar eder. Keith itiraz eder, ama sonunda razı olur.", false],
	],
	"step/24": [
		[24, "", "[[station/48]] yakınında Carla, Void'leri olabildiğince yakından görmek ister. Void'ler gelecekten geldiklerini ve galaksideki uygarlıklardan geriye kalan tek şey olduklarını duyurur. Keith'in onlarla savaşması ve gemilerinin kalıntılarını bir çekici ışınla toplaması gerekir.", false],
		[25, "", "Yeterince enkaz yüklenince Carla geri dönmek ister, ama birden bir şey gemiyi yakalar.", false],
	],
	"step/25": [
		[25, "", "Keith ve Carla, [[station/48]] istasyonundan çok uzakta, ikisinin de tanımadığı bir uzay bölgesinde kendilerine gelir.", false],
		[26, "", "Yakınlarda avcı gemileri fırlatan devasa bir Void ana gemisi durmaktadır. Keith, bir solucan deliğinden geçip Void'lerin ana bölgesine geldiklerini anlar. O solucan deliği kaybolmuştur, ama bu tür geçitler çöküp başka bir yerde yeniden beliriyor gibidir; bu yüzden eve dönmek için bir başkasına ulaşması gerekir.", false],
	],
	"step/26": [
		[26, "", "Solucan deliği onları [[station/48]] yakınına geri getirir, ama Void avcı gemileri de peşlerinden gelmiştir. Keith'in, gemiyi [[station/10]] istasyonuna kadar izleyemesinler diye onları yok etmesi gerekir.", false],
		[27, "", "Takipçilerden kurtulan ikili, dinlenmeye fazlasıyla ihtiyaç duyarak Thynome'a döner.", false],
	],
	"step/27": [
		[27, "", "Keith, [[station/10]] istasyonuna kenetlenir.", false],
		[28, "", "İki gün sonra Carla ondan geri dönmesini ister. Ekibi, ana gemiye ateşlendiğinde onu analiz edip sonuçları Keith'in gemisine gönderen bir sonda yapmıştır. Carla enkazı incelemek için geride kalır ve başka bir solucan deliği bulması için onu az önce Void'lerin görüldüğü [[system/18]] sistemine gönderir.", false],
		[28, "", "Keith tek bir koşulla kabul eder: sağ dönerse Carla ona bir randevu borçlu olacaktır. Carla kabul eder.", false],
	],
	"step/28": [
		[28, "", "[[station/91]] yakınında Void avcı gemileri gelir ve Keith'in solucan deliği çökmeden ona ulaşması gerekir. Void'ler, kendilerini yok etmenin onun kendi geleceğini de yok edeceği konusunda uyarır.", false],
		[29, "", "Keith solucan deliğine ulaşır ve içinden geçerek Void uzayına girer.", false],
	],
	"step/29": [
		[29, "", "Ana geminin yakınında Keith'in ona kilitlenmesi, böylece sondayı fırlatması, ardından sonda analizini tamamlayana kadar dayanması gerekir.", false],
		[30, "", "Bekleme sırasında Void'ler yeniden yayın yapar: insanlar onları ve onlarla birlikte kendi geleceklerini yok etmeden önce konuşmanın bir yolunu bulmaları gerektiğini söylerler. Keith veri aktarımı tamamlanana kadar dayanır ve oradan ayrılır.", false],
	],
	"step/3": [
		[3, "", "Keith, ilk cevher yükünü teslim etmek için [[station/78]] istasyonuna kenetlenir.", false],
		[4, "", "Gunant oldukça memnundur, ancak Keith'i bu kez tüm kargo ambarını doldurması için yeniden gönderir. Uslu durursa bir gün gemiyi kendisine bırakabileceğini söyleyerek şaka yapar.", false],
	],
	"step/30": [
		[30, "", "Solucan deliğinden geri dönen Keith, [[station/91]] yakınında bekler.", false],
		[31, "", "Brent arar ve Thynome'a dönmeden önce [[system/19]] sistemindeki [[station/98]] istasyonuna uğramasını ister; bir sürpriz vaat eder. Sonda verileri oradan Carla'ya gönderilebilir.", false],
	],
	"step/31": [
		[31, "", "Keith, Brent'i görmek için [[station/98]] istasyonuna kenetlenir.", false],
		[32, "", "Brent'in ekibi yıldız haritası için bir erken uyarı sistemi geliştirmiştir. Sistem, Void'lerin solucan deliği açmak üzere olduğu yerleri gösterir ve Keith'in seyir bilgisayarı bunu alabilecek şekilde değiştirilir. Brent ondan bu yerlere uçmasını ve yerel kuvvetlere destek olmasını ister; ona 30.000 kredi öder.", false],
		[32, "", "Brent ayrıca Deep Science için çalışan ve [[character/20]] adını taşıyan bir [[faction/7|Grey]] bilim insanının Keith'i görmek istediğini ekler.", false],
	],
	"step/32": [
		[32, "", "Keith, [[character/20]] ile buluşmak için [[station/10]] istasyonuna döner.", false],
		[33, "", "Khador, Void enkazını incelemiştir. Void'lerin solucan deliklerinin sırrının, yalnızca Void bölgesinde bulunan belirli kristallerin yapısında yattığına inanır. Bir gemiyi uzayın herhangi bir noktasına anında taşıyacak bir sürücü geliştirmektedir ve Keith'ten bu kristallerden en az 50 tane getirmesini ister.", false],
		[33, "", "Keith'in bir kez daha bir solucan deliğine girmesi gerekir; bu kez birini bulmak için Brent'in erken uyarı sistemini kullanacaktır.", false],
	],
	"step/33": [
		[33, "", "Keith'in Void bölgesinde 50 adet [[item/164]] toplaması ve bunları [[station/10]] istasyonuna teslim etmesi gerekir.", false],
		[34, "", "Khador çok sevinir ve Keith kendine bir tane yapabilsin diye ona [[item/85]] planının bir kopyasını verir (bkz. [[guide/blueprints]]). Böyle bir sürücü Void'lerin ana bölgesine bile ulaşabilir.", false],
		[34, "", "Carla gelir, ama randevu için fazla meşguldür. Keith'e Brent ile bir plan hazırladıklarını söyler ve onu [[system/2]] sistemindeki [[station/30]] istasyonuna, Brent'in yanına gönderir.", false],
	],
	"step/34": [
		[34, "", "Keith, Brent'in planını dinlemek için [[station/30]] istasyonuna uçar.", false],
		[35, "", "Sonda verileri, solucan deliklerinin kaynağının ana gemi olduğunu gösterir. Şimdiye kadar hiçbir silah ona zarar verememiştir; bu yüzden plan, Nivelian nükleer patlayıcılarıyla yüklü sağlam bir yük gemisini doğrudan kalbine uçurmaktır.", false],
		[35, "", "Bu iş için en uygunu bir Vossk K'Sarr yük gemisidir. Brent, gizli bir esir takasının parçası olarak, [[system/5]] sistemindeki [[station/29]] istasyonunun komutanı [[character/7]] aracılığıyla bir tane edinmeyi ayarlamıştır. Errkt, pilotla yüz yüze görüşmekte ısrar eder.", false],
	],
	"step/35": [
		[35, "", "Keith, [[station/29]] istasyonunda [[character/7]] ile buluşmak için [[faction/1]] topraklarına uçar.", false],
		[36, "", "Keith'in geçmişini araştırmış olan Errkt, bir Vossk gemisini yalnızca bir Vossk'un gereği gibi uçurabileceğini savunur. Görev başarısız olmamalıdır; bu yüzden yük gemisini kendisi uçuracaktır. Ancak önce Keith'in, [[station/27]] gezegeni yakınında bir avcı pilotu olarak becerisini kanıtlaması gerekir.", false],
	],
	"step/36": [
		[36, "", "Errkt, [[station/27]] yakınındaki bir korsan sığınağında bir yarışma önerir: en çok korsanı düşüren kazanır.", false],
		[37, "", "Keith kazanır. Errkt onu yetenekli bir pilot olarak kabul eder ve kararlaştırılan buluşma noktasına getireceği yük gemisine eskortluk etme onurunu ona verir. Keith rapor vermek için Brent'i arar.", false],
	],
	"step/37": [
		[37, "", "Keith, Errkt ile görüşmeleri hakkında rapor vermek için [[station/27]] üzerinden Brent ile temas kurar.", false],
		[38, "", "Vossk İmparatorluğu desteğini onaylamıştır ve Brent, Errkt'i pilot olarak kabul eder. Yeni bir sorun çıkmıştır: Nivelianlarla savaş hâlindeki [[faction/3|Mido Konfederasyonu]] gemileri, Nivelian patlayıcılarını taşıyan konvoyu ele geçirmiştir. Konvoy [[system/4]] sisteminde, [[station/22]] yakınında görülmüştür ve Keith onu durdurmayı kabul eder.", false],
	],
	"step/38": [
		[38, "", "Keith, [[station/22]] yakınında çalınan konvoyu ve ona eşlik eden Mido avcı gemilerini bulur. Konvoy gemilerine zarar vermeden eskortu yok etmesi gerekir.", false],
		[39, "", "Konvoy yeniden kontrol altına alınınca Brent, onu [[station/30]] istasyonuna kadar götürmeleri için yerel güvenlik kuvvetlerine teslim eder ve Keith'ten de oraya dönmesini ister.", false],
	],
	"step/39": [
		[39, "", "Keith son brifing için [[station/30]] istasyonuna kenetlenir.", false],
		[40, "", "Patlayıcılar Vossk yük gemisine yüklenir ve pilot yine Errkt'tir. Void'ler bir sonraki kez göründüğünde Keith ve Errkt oraya uçacaktır. Errkt ilk solucan deliğine yönelecek, Keith de onu koruyup peşinden gidecektir. Brent en yakın istasyondan takviye kuvvet isteyecektir.", false],
		[40, "", "Errkt'in çarpmadan kısa süre önce bir kaçış kapsülüyle gemiden ayrılması planlanır. Keith'in ana gemi yok edilmeden önce solucan deliğinden geri dönmesi gerekir, yoksa eve dönüş yolu kalmayacaktır.", false],
	],
	"step/4": [
		[4, "", "Keith, ambar dolana kadar kazmak için asteroitlere döner.", false],
		[5, "", "O kazı yaparken bir korsan gemisi yaklaşır. Silahsız olan Keith'e istasyona kaçması ve ateşten kaçınması söylenir.", false],
	],
	"step/40": [
		[40, "", "Keith, erken uyarı sistemini kullanarak Void saldırısı altındaki bir yörüngeye uçar. Errkt yük gemisiyle gelip ilk solucan deliğine yönelir ve Tğm. [[character/8]] da birliğiyle onlara katılır. Keith'in yük gemisini solucan deliğinden geçene kadar koruması gerekir.", false],
		[41, "", "Yük gemisinin zırhı ağır hasar alır, ama Errkt solucan deliğine ulaşır ve Keith de peşinden geçer.", false],
	],
	"step/41": [
		[41, "", "Baffour'un birliği solucan deliğinden zamanında geçememiştir; Keith ve Errkt yalnızdır. Yük gemisi ana gemiyle çarpışma rotasındadır ve Keith'in yolundaki Void avcı gemilerini temizlemesi gerekir.", false],
		[42, "", "Yük gemisi yaklaşırken Errkt, kaçış kapsülünün vurulduğunu bildirir. Yük gemisinde kalmayı seçer ve Keith'e hâlâ vakit varken oradan ayrılmasını emreder. Keith veda eder ve geri döner.", false],
	],
	"step/42": [
		[42, "", "Errkt'in yük gemisi hedefine ilerlerken Keith'in oradan uzaklaşması gerekir.", false],
		[43, "", "Brent, bölgenin her yerindeki solucan deliklerinin çöktüğünü bildirir: plan işe yaramıştır. Keith, Errkt'in hayatta kalmadığını söyler; Brent de Vossk İmparatorluğu'na sunacağı raporda onu onurlandıracağına söz verir. [[station/98]] istasyonunda bir içki için buluşmak üzere anlaşırlar.", false],
	],
	"step/43": [
		[43, "", "Keith kutlama yapmak için [[station/98]] istasyonunda Brent'e katılır.", false],
		[44, "", "Birkaç kadehten sonra Carla, Keith'e borçlu olduğu randevu için gece elbisesiyle gelir. Brent nazikçe ikisini yalnız bırakır.", false],
	],
	"step/44": [
		[44, "", "Keith, Carla ile geçirdiği gecenin ardından [[station/98]] istasyonunda akşamdan kalma uyanır.", false],
		[45, "", "Carla gitmiştir. Bıraktığı not, yerini açıklamayacağı başka bir gizli projeye geçtiğini ve Deep Science'ın Keith'e son olarak 40.000 kredi ödediğini söyler. Keith baştan beri kullanıldığından şüphelenir ve bara geri döner.", false],
	],
	"step/45": [
		[45, "", "Hikâye tamamlandı. Void ana gemisi yok edilmiş, solucan delikleri kapanmıştır ve [[character/0]] dilediği yere gitmekte özgürdür. Galakside uçmaya, ticaret yapmaya, madencilik yapmaya ve görev almaya devam edebilirsiniz; tüm hikâyenin özeti için bkz. [[world/history]].", false],
	],
	"step/5": [
		[5, "", "Keith'in korsandan kaçıp [[station/78]] istasyonuna güvenle kenetlenmesi gerekir.", false],
		[6, "", "Gunant, istasyonuna yönelik korsan baskınlarının giderek kötüleştiğini itiraf eder. Keith, silah verilirse bu işi halletmeyi önerir. Gunant istasyonun yakınındaki korsan sığınağına bir saldırı denemeye karar verir ve Keith'in bir silah ile zırh takabilmesi için küçük hangarını açar.", false],
	],
	"step/6": [
		[6, "", "Keith'in istasyon hangarında [[ship/0]] adlı gemisine bir silah ve bir zırh plakası takması gerekir (bkz. [[guide/fitting]]).", false],
		[7, "", "Gunant seçimi onaylar. Önlem olarak Keith'in silahlarını kendi kalkanlarını delemeyecek şekilde ayarlamıştır. İkisi dışarıda buluşmak üzere anlaşır.", false],
	],
	"step/7": [
		[7, "", "Gunant sığınağa giden rotayı ara noktalar olarak aktarır. Keith'in bu rotayı izlemesi ve oradaki korsan gemilerini yok etmesi gerekir; Gunant da yanında uçar (bkz. [[guide/combat]]).", false],
		[8, "", "Sığınakta beklenenden çok daha fazla korsan vardır. Gunant geri çekilmek ister, ama Keith savaşmayı sürdürür ve kazanır. Böyle dövüşmeyi nerede öğrendiği sorulunca Keith, Amiral Smith'in emrinde Uzay Filosu'nda hizmet ettiğini söyler. Keith çok genç göründüğü için Gunant bunu tuhaf bulur.", false],
	],
	"step/8": [
		[8, "", "Savaş kazanılınca Keith ve Gunant [[station/78]] istasyonuna döner.", false],
		[9, "", "Gunant hayatını kurtardığı için Keith'e teşekkür eder ve Amiral Smith'in [[station/5]] üzerindeki mezarından söz eder. Keith şaşkına döner: amiral 3612 civarında yaşlılıktan ölmüştür. Ardından Gunant ona içinde bulundukları yılın 3624 olduğunu söyler; bu yılın Void'lerle hatırlanacağını düşünmektedir.", false],
	],
	"step/9": [
		[9, "", "Haberle sarsılan Keith, Gunant ile hesaplaşmak için yeniden [[station/78]] istasyonuna kenetlenir.", false],
		[10, "", "Keith, asteroit kuşağında vurulmasından bu yana yaklaşık 35 yıl geçtiğini anlar. Gunant bir hiper sürücü arızasından şüphelenir, çünkü bu tür sürücüler yıllardır benzer olaylarla ilişkilendirilmektedir.", false],
		[10, "", "Korsanlara karşı kazanılan zafere teşekkür olarak Gunant, sistemdeki gezegenler arasında yolculuk için daha güçlü bir sürücüyle donatılmış [[ship/0]] adlı gemiyi Keith'e verir. Kendi yaptığı bir prototip olan maden lazerini ise kendine saklar. Keith sonunda adını söyler ve [[faction/0]] uzayına dönmesine yardım edebilecek, [[station/79]] istasyonundaki insan komutan Yüzbaşı [[character/3]] ile buluşmaya yola çıkar. Bundan sonra [[chart]] üzerinden sistem içinde yolculuk yapılabilir.", false],
	],
	"system/0": [
		[0, "", "[[system/0]], haritanın sol kenarında bir Nivelian sistemidir. Koordinatlarını [[station/18]] istasyonundaki [[agent/12]] adlı ajandan satın alana kadar yıldız haritasında gizlidir. [[station/0]] istasyonundaki kapısı onu [[system/2]] ve [[system/8]] sistemlerine bağlar.", false],
		[0, "", "Suteo'nun istasyonları Nivelian uzayının en gelişmişleri arasındadır; [[station/2]] ve [[station/4]] en yüksek teknoloji seviyesindedir. Ajan [[agent/0]], [[station/3]] istasyonunda bir plan satar.", false],
	],
	"system/1": [
		[0, "", "[[system/1]], haritanın sol alt köşesinde bir Terran sistemidir. Koordinatlarını [[station/26]] istasyonundaki [[agent/13]] adlı ajandan satın alana kadar gizlidir. [[station/5]] istasyonundaki kapısı onu [[system/8]] ve [[system/18]] sistemlerine bağlar.", false],
		[0, "", "İstasyonları gelişmiştir; [[station/7]] en yüksek teknoloji seviyesindedir. Ajan [[agent/1]], [[station/8]] istasyonunda bir plan satar.", false],
		[9, "", "[[character/2]] adlı tüccara göre, [[character/0]] adlı pilotun eski komutanı Amiral Smith, [[station/5]] üzerinde gömülüdür.", false],
	],
	"system/10": [
		[0, "", "[[system/10]], haritanın sağ tarafında, \"Dangerous\" (Tehlikeli) olarak derecelendirilmiş bir Vossk sistemidir. Koordinatlarını [[agent/14]] adlı ajandan satın alana kadar gizlidir ve hiç kapı bağlantısı yoktur: ona yalnızca atlama motoru olan bir gemi ulaşabilir. Beş istasyonunun hepsi en yüksek teknoloji seviyelerindedir.", false],
		[0, "", "Ajan [[agent/5]], [[station/54]] istasyonunda bir plan satar.", false],
	],
	"system/11": [
		[0, "", "[[system/11]], haritanın üst ortasında, \"Average\" (Orta) olarak derecelendirilmiş bir Terran sistemidir. Yalnızca üç istasyonu vardır. [[station/55]] istasyonundaki kapısı onu [[system/7]], [[system/9]], [[system/14]] ve [[system/16]] sistemlerine bağlar.", false],
		[18, "", "[[character/0]], bir Deep Science subayıyla buluşmak üzere [[station/56]] istasyonuna gönderilir.", false],
		[19, "", "Subay [[character/5]], [[station/55]] yakınında korsanlar tarafından kaçırılmıştır.", false],
		[22, "", "[[character/0]], [[step/21]] sırasında onu EMP bombalarıyla kurtarır.", false],
	],
	"system/12": [
		[0, "", "[[system/12]], haritanın sağ tarafında, yalnızca iki istasyonu olan ve \"Average\" (Orta) olarak derecelendirilmiş küçük bir Vossk sistemidir. [[station/60]] istasyonundaki kapısı onu [[system/3]], [[system/5]], [[system/13]] ve [[system/14]] sistemlerine bağlar; böylece Vossk uzayını Terran doğusuna bağlar.", false],
		[0, "", "Multipod ajan [[agent/6]], [[station/61]] istasyonunda bir plan satar.", false],
	],
	"system/13": [
		[0, "", "[[system/13]], haritanın sağ kenarında, \"Risky\" (Riskli) olarak derecelendirilmiş bir Terran sistemidir. [[station/65]] istasyonundaki kapısı onu [[system/12]] ve [[system/16]] sistemlerine bağlar.", false],
		[0, "", "Cyborg ajan [[agent/14]], [[station/65]] istasyonunda koordinat satar.", false],
	],
	"system/14": [
		[0, "", "[[system/14]], haritanın merkezine yakın bir Terran sistemi ve galaksideki iki \"Safe\" (Güvenli) sistemden biridir. [[station/70]] istasyonundaki kapısı onu [[system/3]], [[system/11]], [[system/12]] ve [[system/19]] sistemlerine bağlar. İstasyonları çoğunlukla düşük teknolojilidir.", false],
		[0, "", "Ajan [[agent/7]], [[station/72]] istasyonunda bir plan satar.", false],
	],
	"system/15": [
		[0, "", "[[system/15]], haritanın en üstünde, \"Dangerous\" (Tehlikeli) olarak derecelendirilmiş bir Midorian sistemidir. Kapı bağlantısı yoktur; bu yüzden bir gemi bu sisteme yalnızca bir atlama motoruyla girebilir ya da ondan çıkabilir. Beş istasyonunun hepsi küçük ve düşük teknolojilidir. [[step/16]] öncesinde gemi satıcıları kapalıdır ve gelip giden gemi azdır.", false],
		[0, "", "Hikâye burada, [[station/78]] istasyonunda başlar.", false],
		[11, "", "Sistem, Nivelian İç Savaşı sırasında Terran ve Nivelian sürgünlerince kurulan [[faction/3|Mido Konfederasyonu'nun]] toprağıdır. Nivelianlar sistemde hâlâ hak iddia eder ve kıyılarında çatışmalar sürer.", false],
		[15, "", "[[character/0]], [[step/14]] sonrasında bir Terran kruvazöründe tutsak olarak sistemden ayrılır. Daha sonra geri dönmek için bir atlama motoru gerekir.", false],
		[0, "", "[[character/2]], [[station/78]] istasyonunun salonunda bir plan satar.", false],
	],
	"system/16": [
		[0, "", "[[system/16]], haritanın sağ tarafında, \"Risky\" (Riskli) olarak derecelendirilmiş bir Terran sistemidir. [[station/80]] istasyonundaki kapısı onu [[system/11]] ve [[system/13]] sistemlerine bağlar.", false],
		[0, "", "Vossk ajan [[agent/8]], [[station/84]] istasyonunda bir plan satar.", false],
	],
	"system/17": [
		[0, "", "[[system/17]], haritanın sol üstünde, \"Risky\" (Riskli) olarak derecelendirilmiş bir Nivelian sistemi ve [[system/15]] sistemine en yakın sistemdir. [[station/85]] istasyonundaki kapısı onu [[system/2]], [[system/9]] ve [[system/4]] sistemlerine bağlar; [[system/4]] sistemine giden tek kapı rotası budur.", false],
		[0, "", "Vossk ajan [[agent/15]], [[station/88]] istasyonunda koordinat satar.", false],
	],
	"system/18": [
		[0, "", "[[system/18]], haritanın alt kısmında, \"Risky\" (Riskli) olarak derecelendirilmiş bir Terran sistemidir. [[station/90]] istasyonundaki kapısı onu [[system/1]] ve [[system/8]] sistemlerine bağlar.", false],
		[0, "", "Ajan [[agent/9]], [[station/90]] istasyonunda bir plan satar.", false],
		[28, "", "[[step/28]] sırasında [[character/0]], [[station/91]] yakınında Void hareketliliği bildirilince bir solucan deliğine süzülmek için buraya gelir.", false],
	],
	"system/19": [
		[0, "", "[[system/19]], haritanın merkezinde, \"Safe\" (Güvenli) olarak derecelendirilmiş bir Terran sistemidir. [[station/95]] istasyonundaki kapısı onu [[system/3]], [[system/8]], [[system/9]] ve [[system/14]] sistemlerine bağlar.", false],
		[15, "", "[[station/98]], Terran kruvazörünün tutuklanan [[character/0]] adlı pilotu getirdiği ve onun eski dostu [[character/1]] ile yeniden buluştuğu istasyondur.", false],
		[16, "", "Bu güvenli sistem bile nasibini alır: [[step/16]] sırasında bir Void filosu [[station/98]] istasyonuna saldırır. [[character/1]] karargâhını orada tutar.", false],
	],
	"system/2": [
		[0, "", "[[system/2]], haritanın sol tarafında bir Nivelian sistemi ve Nivelian uzayının kavşağıdır. [[station/30]] istasyonundaki kapısı onu [[system/0]], [[system/8]], [[system/9]] ve [[system/17]] sistemlerine bağlar. Orta teknoloji seviyesinde dört istasyonu vardır.", false],
		[34, "", "[[step/33]] sırasında [[character/6]], [[character/0]] adlı pilotu, [[character/1]] adlı dostunun yeni bir planla beklediği [[station/30]] istasyonuna gönderir. Void'lere karşı son hazırlıklar da orada yapılır.", false],
	],
	"system/20": [
		[0, "", "[[system/20]], haritanın sağ altında, \"Dangerous\" (Tehlikeli) olarak derecelendirilmiş bir Vossk sistemidir. [[station/62]] istasyonundaki kapısı onu [[system/5]] ve [[system/21]] sistemlerine bağlar; böylece [[system/21]] sistemine giden tek kapı rotası olur.", false],
		[0, "", "Bir Terran olan ajan [[agent/10]], küçük [[station/59]] istasyonunda bir plan satar.", false],
	],
	"system/21": [
		[0, "", "[[system/21]], haritanın en uçtaki sağ alt köşesinde, \"Dangerous\" (Tehlikeli) olarak derecelendirilmiş bir Vossk sistemidir. Koordinatlarını [[agent/15]] adlı ajandan satın alana kadar gizlidir. [[station/12]] istasyonundaki kapısı onu yalnızca [[system/20]] sistemine bağlar. İstasyonlarının hepsi ilkeldir; teknoloji seviyeleri 3 ya da daha düşüktür.", false],
	],
	"system/3": [
		[0, "", "[[system/3]], haritanın merkezine en yakın Vossk sistemi ve Vossk uzayının ana girişidir. [[station/15]] istasyonundaki kapısı onu [[system/5]], [[system/12]], [[system/8]], [[system/14]] ve [[system/19]] sistemlerine bağlar. \"Average\" (Orta) olarak derecelendirilmiştir.", false],
		[0, "", "[[station/18]] istasyonundaki ajan [[agent/12]], gizli [[system/0]] sisteminin koordinatlarını satar.", false],
	],
	"system/4": [
		[0, "", "[[system/4]], haritanın sol üst köşesinde, \"Dangerous\" (Tehlikeli) olarak derecelendirilmiş bir Midorian sistemidir. Bir çıkmazdır: [[station/20]] istasyonundaki kapısı yalnızca [[system/17]] sistemine ulaşır. İstasyonları ilkel [[station/21]] ile iyi donanımlı [[station/22]] arasında değişir.", false],
		[0, "", "Ajan [[agent/2]], [[station/20]] istasyonunun salonunda bir plan satar.", false],
		[38, "", "[[step/38]] sırasında Nivelian patlayıcılarını taşıyan çalıntı bir konvoyun izi bu sistemde, [[station/22]] yakınında bulunur.", false],
	],
	"system/5": [
		[0, "", "[[system/5]], haritanın sağ altında, \"Risky\" (Riskli) olarak derecelendirilmiş bir Vossk sistemidir. [[station/25]] istasyonundaki kapısı onu [[system/3]], [[system/12]] ve [[system/20]] sistemlerine bağlar. Ajan [[agent/13]], [[station/26]] istasyonunda koordinat satar.", false],
		[35, "", "Sistem, Vossk komutanı [[character/7]] adlı karakterin [[station/29]] istasyonundaki üssüdür; [[character/0]] onunla [[step/35]] sırasında orada buluşur.", false],
		[36, "", "Yarışmaları [[station/27]] yakınında gerçekleşir.", false],
	],
	"system/6": [
		[0, "", "[[system/6]], haritanın sağ üstünde, \"Dangerous\" (Tehlikeli) olarak derecelendirilmiş bir Terran sistemidir. Standart yıldız haritalarında görünmez ve koordinatlarını yalnızca hikâye açığa çıkarır. Tek bir istasyonu vardır: kapısı onu yalnızca [[system/7]] sistemine bağlayan [[station/10]].", false],
		[23, "", "Sistem, Deep Science'ın gizli araştırma istasyonunu saklar. [[character/5]] adlı bilim insanı, koordinatları [[step/22]] sırasında [[character/0]] adlı pilota verir ve Void'lere karşı mücadelenin büyük bölümü orada planlanır.", false],
	],
	"system/7": [
		[0, "", "[[system/7]], haritanın sağ üstünde, \"Risky\" (Riskli) olarak derecelendirilmiş bir Terran sistemidir. [[station/35]] istasyonundaki kapısı onu [[system/11]] sistemine ve gizli [[system/6]] sistemine bağlar; böylece gizli sisteme giden tek kapı rotası olur. En gelişmiş istasyonu [[station/37]] istasyonudur.", false],
	],
	"system/8": [
		[0, "", "[[system/8]], haritanın sol alt çeyreğinde bir Terran sistemi ve galaksinin en iyi bağlantılı sistemidir. [[station/40]] istasyonundaki kapısı onu altı sisteme bağlar: [[system/0]], [[system/1]], [[system/2]], [[system/3]], [[system/18]] ve [[system/19]]. \"Average\" (Orta) olarak derecelendirilmiştir.", false],
		[0, "", "Ajan [[agent/4]], [[station/43]] istasyonunda bir plan satar.", false],
	],
	"system/9": [
		[0, "", "[[system/9]], haritanın üst ortasında, \"Average\" (Orta) olarak derecelendirilmiş bir Nivelian sistemidir. [[station/45]] istasyonundaki kapısı onu [[system/2]], [[system/11]], [[system/17]] ve [[system/19]] sistemlerine bağlar.", false],
		[24, "", "[[station/48]] yakınında Void hareketliliği bildirilir; [[character/0]] ile [[character/6]] de [[step/24]] sırasında enkaz toplamak için oraya gider.", false],
	],
	"world/galaxy": [
		[0, "Genel bakış", "Oyun, 22 yıldız sisteminden oluşan tek bir galakside geçer. Her sistem bir fraksiyona aittir, bir güvenlik derecesi taşır ve bir ile beş arasında uzay istasyonu barındırır. Her istasyon bir gezegenin yörüngesindedir ve her birinin kendi dükkânı, hangarı ve uzay salonu vardır. Sistemler düz bir harita üzerine dağılmıştır ve aralarındaki yolculuk bir atlama kapısı ağı üzerinden yapılır.", false],
		[0, "", "Haritadaki sistemlerin sahibi dört halktır. [[faction/0|Terranlar]] onunu, [[faction/1]] altısını, [[faction/2|Nivelianlar]] dördünü ve [[faction/3|Midorianlar]] ikisini elinde tutar. [[faction/4|Multipodlar]], [[faction/5|Cyborglar]], [[faction/6|Bobolianlar]] ve [[faction/7]] gibi daha küçük ırkların üyeleri, kendi toprakları olmadan onların arasında yaşar. [[faction/8|Korsanlar]] her sistemde dolaşır ve en başından beri [[faction/9|Void'ler]] adlı düşmanca bir güç hakkında söylentiler vardır.", false],
		[0, "Yerleşim", "Nivelian ve Midorian sistemleri haritanın sol üst kısmında, [[system/15]], [[system/4]], [[system/17]] ve [[system/2]] sistemlerinin çevresinde yer alır. Terran uzayı haritanın ortası, sağ tarafı ve alt kısmı boyunca uzanır; kalbinde [[system/19]] ve [[system/14]] sistemleri vardır. Vossk sistemleri sağ altta ayrı bir blok oluşturur; [[system/3]] sisteminden başlar ve en uç köşede [[system/21]] sistemiyle biter.", false],
		[0, "", "Kapı rotaları merkezi kayırır. [[system/8]] sistemi altı kapı bağlantısıyla diğer tüm sistemlerden fazlasına sahiptir; [[system/19]], [[system/14]], [[system/3]] ve [[system/11]] ise her biri dört ya da beş sisteme bağlanır. [[system/4]], [[system/6]] ve [[system/21]] gibi kenardaki sistemler tek bağlantılı çıkmazlardır.", false],
		[0, "Yolculuk", "Bir sistemin içinde geminin olağan sürücüsü onu bir istasyonun yörüngesinden diğerine taşır. Bir sistemden ayrılmak için gemi, sistemin istasyonlarından birinde bulunan ve yalnızca bağlantılı sistemlere ulaşan atlama kapısından geçer. Daha uzun yolculuklar kapı atlamalarından oluşan zincirlerdir. Kapı ağını atlayıp bilinen herhangi bir sisteme doğrudan ulaşmanın tek yolu bir atlama motorudur; bkz. [[guide/navigation]].", false],
		[33, "", "Oyundaki tek atlama motoru, hikâye sırasında [[character/20]] tarafından tasarlanan [[item/85]] sürücüsüdür. Bir plandan üretilir ve gereken malzemeler arasında [[item/164]] de vardır.", false],
		[0, "Güvenlik", "Her sistem \"Safe\" (Güvenli), \"Average\" (Orta), \"Risky\" (Riskli) ya da \"Dangerous\" (Tehlikeli) olarak derecelendirilir. Derece, vardığınızda bir istasyonun yakınında baskıncıların ne sıklıkla pusuda beklediğini belirler. \"Dangerous\" bir sistemde ziyaretlerin çoğunda ortaya çıkarlar; \"Safe\" bir sistemde nadirdirler. Baskıncılar genellikle korsandır, ama bazen fraksiyonun rakip ırkının gemileridir. Daha güvenli sistemler ise istasyonlarının çevresinde daha fazla yerel devriye gemisi bulundurur.", false],
		[0, "Fraksiyonlar ve itibar", "İtibarınız iki ölçekte tutulur: biri Terranlar ile Vossklar arasında, diğeri Nivelianlar ile Midorianlar arasında. Bir çiftin bir tarafının gözüne girmek, diğer tarafın gözünden düşmenize yol açar. Bir fraksiyondaki itibarınız fazla düşerse gemileri sizi görür görmez saldırır ve istasyonları sizi geri çevirir. Korsanlar ve Void'ler her zaman düşmandır. Uzay salonundaki bir diplomat, ücret karşılığında itibarınızı düzeltebilir.", false],
		[0, "Gizli sistemler", "Her sistem başta yıldız haritasında görünmez. [[system/0]], [[system/1]], [[system/10]] ve [[system/21]] sistemleri, koordinatlarını bir uzay salonundaki bir ajandan satın alana kadar gizli kalır; bkz. [[guide/lounge]]. Bir sistem daha, [[system/6]], standart yıldız haritalarında yer almaz ve onu yalnızca hikâye açığa çıkarır.", false],
		[23, "", "[[system/6]] sisteminin koordinatları size [[step/22]] sırasında [[character/5]] aracılığıyla ulaşır. Sistemde tek bir istasyon vardır: Deep Science kuruluşunun gizli araştırma üssü olan [[station/10]].", false],
		[0, "", "İki sistemin hiç kapı bağlantısı yoktur: [[system/15]] ve [[system/10]]. Bir gemi bu sistemlere yalnızca bir atlama motoruyla ulaşabilir ya da onlardan ayrılabilir.", false],
		[0, "Yalıtılmış bir başlangıç", "Hikâye, haritanın en üstünde, galaksinin geri kalanına kapı bağlantısı olmayan ücra bir sistem olan [[system/15]] sisteminde başlar. Ticareti zayıftır, istasyonlarının teknoloji seviyesi düşüktür ve gemi satıcıları hikâyenin ilk bölümü boyunca kapalı kalır. Başlarda sistemden çıkmanın tek yolu hikâyenin sunduğu yoldur.", false],
		[11, "", "[[system/15]] sistemi, Nivelian İç Savaşı sırasında yeni haritalanan bu bölgeye yerleşen Terran ve Nivelian mülteciler ile kanun kaçaklarından oluşan [[faction/3|Mido Konfederasyonu'nun]] yurdudur. Konfederasyon bağımsızlığını ilan etmiştir. Terranlar bunu kabul eder; Nivelianlar ise sistemde hâlâ hak iddia eder ve bu da sistemin kenarlarındaki çatışmaları sürdürür.", false],
		[15, "", "[[step/14]] sırasında [[station/79]] yakınındaki konvoy onu etkisiz hâle getirip tutukladıktan sonra [[character/0]], [[system/15]] sisteminden bir Terran kruvazörüyle ayrılır. Terran uzayının derinliklerindeki [[system/19]] sisteminde, [[station/98]] istasyonuna varır.", false],
		[9, "Zaman boşluğu", "[[character/0]], [[system/15]] sisteminde uyandığında yalnızca kısa bir süre geçtiğini sanır. Gerçekte hasarlı hiper sürücüsü onu galaksinin öbür ucuna ve yaklaşık 35 yıl ileriye fırlatmıştır. Tanıdığı galaksi değişmiştir: eski dostları yaşlanmış ya da ölmüştür, şimdi bulunduğu bölge de dahil yeni bölgelere bu arada yerleşilmiştir.", false],
		[10, "", "Onunkiyle aynı türden arızalı hiper sürücüler daha önce de zaman ve uzayda benzer sıçramalara yol açmıştır.", false],
		[18, "Haritanın ötesi", "Void'ler haritadaki sistemlere bir tür solucan deliği aracılığıyla girer. Terran, Nivelian ve Vossk uzayına aynı şekilde baskın düzenler ve cevher peşinde gibi görünürler. Bkz. [[world/voids]].", false],
		[25, "", "Bir solucan deliği, haritalanmış galaksinin dışına, yıldız haritasında yeri olmayan Void'lerin kendi bölgesine açılır. Solucan delikleri bir süre bir istasyonun yakınında açık kalır, sonra çöker ve başka bir yerde belirir.", false],
		[34, "", "[[item/85]] takılı bir gemi doğrudan Void bölgesine de atlayabilir.", false],
		[32, "", "[[step/31]] itibarıyla bir erken uyarı sistemi, bir sonraki solucan deliğinin nerede açılacağını yıldız haritasında gösterir.", false],
		[42, "", "[[step/41]] sırasında Void ana gemisi yok edildiğinde bölgedeki solucan delikleri çöker ve baskınlar durur.", false],
	],
	"world/history": [
		[0, "", "Galakside aralarında [[faction/0|Terranlar]], [[faction/2|Nivelianlar]] ve [[faction/1|Vossklar]] bulunan birkaç halk yaşar. İstasyonları arasındaki uzay [[faction/8|korsanların]] belasıyla doludur. Bu sayfa hikâyeyi özetler; her bölüm, kaydınız oraya ulaştığında görünür.", false],
		[0, "Birinci perde: mahsur", "Terran ödül avcısı [[character/0]], bir asteroit kuşağında bir korsan çetesini yok eder ([[step/0]]).", false],
		[1, "", "Eski komutanı Amiral Smith ile buluşmak için sıçrarken son bir atış hiper sürücüsüne hasar verir. Pilotu baygın hâldeki gemi sürüklenerek [[station/78]] istasyonuna ulaşır.", false],
		[2, "", "Nivelian cevher tüccarı [[character/2]] enkazı kurtarır, gemiye el koyar ve Keith'i kendisi için cevher kazmaya zorlar.", false],
		[8, "", "Keith, yakındaki bir korsan sığınağını yok etmesinde Gunant'a yardım eder ([[step/7]]).", false],
		[9, "", "Ardından Keith, yılın 3624 olduğunu ve Amiral Smith'in çoktan öldüğünü öğrenir.", false],
		[10, "", "Bir hiper sürücü arızası Keith'i 35 yıl ileriye ve galaksinin ücra bir köşesine taşımıştır. Gunant ona [[ship/0]] adlı gemiyi verir ve onu [[station/79]] istasyonundaki [[character/3]] ile görüşmeye gönderir.", false],
		[11, "", "[[system/15]] sistemi, Nivelian İç Savaşı sırasında Terran ve Nivelian sürgünlerince kurulan [[faction/3|Mido Konfederasyonu]] topraklarındadır.", false],
		[12, "", "Keith, sessizliğe gömülen [[station/76]] istasyonunun mürettebatının satıcı [[character/4]] tarafından uyuşturulup sersemletildiğini keşfeder ([[step/11]]).", false],
		[15, "", "Sistemden geçen bir Terran konvoyu Keith'i korsan sanır, gemisini etkisiz hâle getirir ve onu [[station/98]] istasyonuna götürür ([[step/14]]).", false],
		[16, "İkinci perde: Void tehdidi", "Orada, artık güvenlik şefi olan eski dostu [[character/1]] ile karşılaşır; tam o sırada [[faction/9|Void'ler]] istasyona saldırır.", false],
		[18, "", "Void'ler cevher peşinde solucan delikleri aracılığıyla yıldız sistemlerine baskın düzenler. Brent, Keith'i onları inceleyen gizli araştırma kuruluşu Deep Science adına uçmak üzere işe alır ([[step/17]]).", false],
		[19, "", "Keith'e araştırma istasyonuna kadar rehberlik edecek olan bilim insanı [[character/5]], korsanlar tarafından kaçırılır.", false],
		[23, "", "Keith, kaçıranların gemisini EMP bombalarıyla etkisiz hâle getirir, bilim insanını kurtarır ve [[system/6]] sisteminin koordinatlarını alır ([[step/21]], [[step/22]]).", false],
		[24, "Üçüncü perde: Deep Science", "Keith, [[station/10]] istasyonunda proje lideri [[character/6]] ile tanışır ve Deep Science için çalışmaya başlar.", false],
		[25, "", "Keith ve Carla, [[station/48]] yakınında Void enkazı toplarken bir solucan deliği gemilerini yutar ([[step/24]]).", false],
		[26, "", "Kendilerini Void'lerin ana bölgesinde, devasa bir ana geminin yanında bulurlar ve başka bir solucan deliğinden kaçarlar.", false],
		[30, "", "Keith, [[station/91]] yakınındaki bir solucan deliğinden Void bölgesine geri döner ve ana gemiye bir sonda fırlatır ([[step/29]]).", false],
		[32, "", "Brent, Keith'e Void'lerin bir sonraki saldırısının nerede olacağını gösteren bir erken uyarı sistemi verir.", false],
		[34, "", "Grey bilim insanı [[character/20]], yeni bir anlık sürücü için Keith'e Void kristalleri toplatır ve ona sürücünün planını verir ([[step/33]]).", false],
		[35, "Dördüncü perde: saldırı", "Sonda, solucan deliklerini ana geminin oluşturduğunu gösterir. Brent ve Carla, ana gemiyi Nivelian patlayıcılarıyla dolu bir yük gemisiyle yok etmeyi planlar; gemiyi Vossk komutanı [[character/7]] sağlayacaktır.", false],
		[37, "", "Errkt yük gemisini bizzat uçurmakta ısrar eder; Keith de ona eskortluk etme hakkını kazanır ([[step/36]]).", false],
		[39, "", "Mido gemileri patlayıcıları taşıyan konvoyu ele geçirince Keith konvoyu geri alır ([[step/38]]).", false],
		[42, "", "Keith, komutası [[character/8]] adlı subayda olan takviye kuvvetlerle birlikte Errkt'e bir solucan deliğinden geçerken eşlik eder. Errkt yük gemisini ana gemiye çarptırır ve saldırıda hayatını kaybeder ([[step/41]]).", false],
		[43, "", "Tüm solucan delikleri çöker ve Void baskınları sona erer.", false],
		[45, "Son söz", "Keith, Brent ile kutlama yapar ve sonunda bir geceyi Carla ile geçirir. Carla ertesi sabah başka bir gizli proje için ayrılır ve Keith galakside dilediği gibi dolaşmakta özgür kalır.", false],
	],
	"world/khador": [
		[32, "", "Deep Science için çalışan Grey bilim insanı Khador'un kendi sayfası vardır: bkz. [[character/20]].", false],
	],
	"world/voids": [
		[0, "", "[[faction/9|Void'ler]] hikâyenin ana tehdididir. Bu sayfa onlar hakkında öğrenilenleri toplar; kaydınız ilerledikçe daha fazlası görünür.", false],
		[2, "İlk haberler", "Keith, Void'leri ilk kez [[character/2]] adlı tüccardan duyar: ücra [[system/15]] sisteminde bile zaman zaman ortaya çıkan düşmanca varlıklar.", false],
		[9, "", "Mido sisteminde yaşayanlar, 3624 yılının Void'lerin yılı olarak hatırlanacağını düşünür.", false],
		[16, "", "Void avcı gemileri, Terran uzayındaki [[station/98]] istasyonuna saldırır ([[step/15]]).", false],
		[17, "", "Saldırı sırasında Void'ler barış için geldiklerini iddia eden bir mesaj yayınlar, ancak ateş etmeyi sürdürürler.", false],
		[18, "Bilinenler", "Void'ler birkaç hafta önce görünmeye başladı. Yerleşik sistemlere solucan delikleri aracılığıyla girer, karşılarına çıkan her şeye saldırır ve cevher peşinde gibi görünürler. [[faction/1]] sistemleri bile baskına uğrar. Nereden geldiklerini ya da ne istediklerini kimse bilmez.", false],
		[24, "", "[[station/48]] yakınında, gelecekten geldiklerini ve galaksideki uygarlıklardan geriye kalan tek şey olduklarını duyururlar.", false],
		[26, "Ana bölge", "Solucan delikleri, devasa bir ana geminin avcı gemileri fırlattığı uzak bir ana bölgeye açılır. Solucan delikleri kısa bir süre açık kalır, sonra çöker ve başka bir yerde yeniden belirir.", false],
		[28, "", "Void'ler, kendilerini yok etmenin insanlığın geleceğini de yok edeceği konusunda uyarır.", false],
		[30, "", "İnsanlar onları ve onlarla birlikte kendi geleceklerini yok etmeden önce iletişim kurmanın bir yolunu bulmaları gerektiğini tekrarlarlar. Bu iddianın doğru olup olmadığı hiçbir zaman netleşmez.", false],
		[32, "", "[[character/1]] liderliğindeki ekibin geliştirdiği bir erken uyarı sistemi, Void'lerin bir sonraki solucan deliğini nerede açacağını önceden bildirir.", false],
		[33, "", "Grey bilim insanı [[character/20]], yalnızca Void bölgesinde bulunan kristallerin, yani [[item/164]] adlı maddenin, solucan deliklerinin sırrını taşıdığına inanır.", false],
		[35, "Baskınların sonu", "Ana gemiye fırlatılan sonda, solucan deliklerinin kaynağının bu gemi olduğunu gösterir. Bilinen hiçbir silah ona zarar verememiştir.", false],
		[42, "", "[[character/7]] tarafından uçurulan ve Nivelian nükleer patlayıcılarıyla yüklü bir Vossk yük gemisi ana gemiyi yok eder ([[step/41]]).", false],
		[43, "", "Ardından bölge genelinde solucan delikleri çöker ve Void baskınları, en azından şimdilik, sona erer.", false],
	],
}
