extends RefCounted
## Reference prose in Indonesian. Each block is [story step it appears from,
## section heading or "", text, list item]. See src/wiki/prose.gd.
const PAGES := {
	"guide/basics": {"title": "Memulai", "subtitle": "Panduan", "category": "guide", "from": 0},
	"guide/blueprints": {"title": "Cetak biru dan produksi", "subtitle": "Panduan", "category": "guide", "from": 0},
	"guide/combat": {"title": "Pertempuran", "subtitle": "Panduan", "category": "guide", "from": 0},
	"guide/fitting": {"title": "Kapal dan pemasangan", "subtitle": "Panduan", "category": "guide", "from": 0},
	"guide/flight": {"title": "Terbang", "subtitle": "Panduan", "category": "guide", "from": 0},
	"guide/jobs": {"title": "Pekerjaan lepas", "subtitle": "Panduan", "category": "guide", "from": 0},
	"guide/lounge": {"title": "Lounge Luar Angkasa", "subtitle": "Panduan", "category": "guide", "from": 0},
	"guide/medals": {"title": "Medali", "subtitle": "Panduan", "category": "guide", "from": 0},
	"guide/mining": {"title": "Menambang", "subtitle": "Panduan", "category": "guide", "from": 0},
	"guide/navigation": {"title": "Navigasi", "subtitle": "Panduan", "category": "guide", "from": 0},
	"guide/trading": {"title": "Berdagang", "subtitle": "Panduan", "category": "guide", "from": 0},
	"step/0": {"title": "Hadiah buronan di sabuk asteroid"},
	"step/1": {"title": "Ditemukan terapung"},
	"step/10": {"title": "Bertemu sang komandan"},
	"step/11": {"title": "Stasiun yang membisu"},
	"step/12": {"title": "Melapor kepada komandan"},
	"step/13": {"title": "Menunggu konvoi"},
	"step/14": {"title": "Konvoi Terran"},
	"step/15": {"title": "Ditahan"},
	"step/16": {"title": "Mempertahankan stasiun"},
	"step/17": {"title": "Kisah para Void"},
	"step/18": {"title": "Bertemu seorang ilmuwan"},
	"step/19": {"title": "Penculikan"},
	"step/2": {"title": "Penambangan bijih pertama"},
	"step/20": {"title": "Memasang bom"},
	"step/21": {"title": "Melumpuhkan para penculik"},
	"step/22": {"title": "Ilmuwan yang diselamatkan"},
	"step/23": {"title": "Stasiun riset rahasia"},
	"step/24": {"title": "Mengumpulkan puing Void"},
	"step/25": {"title": "Tersesat di ruang angkasa asing"},
	"step/26": {"title": "Melepaskan diri dari pengejar"},
	"step/27": {"title": "Tugas baru"},
	"step/28": {"title": "Kembali menembus lubang cacing"},
	"step/29": {"title": "Meluncurkan wahana"},
	"step/3": {"title": "Mengantar bijih"},
	"step/30": {"title": "Panggilan dari kawan lama"},
	"step/31": {"title": "Kejutan yang dijanjikan"},
	"step/32": {"title": "Ilmuwan Grey"},
	"step/33": {"title": "Kristal dari Void"},
	"step/34": {"title": "Rencana kemenangan"},
	"step/35": {"title": "Bertemu komandan Vossk"},
	"step/36": {"title": "Adu kemampuan pilot"},
	"step/37": {"title": "Menghubungi markas besar"},
	"step/38": {"title": "Merebut kembali konvoi"},
	"step/39": {"title": "Persiapan terakhir"},
	"step/4": {"title": "Ruang kargo penuh"},
	"step/40": {"title": "Pengawalan ke lubang cacing"},
	"step/41": {"title": "Serangan ke kapal induk"},
	"step/42": {"title": "Lolos dari ruang Void"},
	"step/43": {"title": "Perayaan"},
	"step/44": {"title": "Keesokan paginya"},
	"step/45": {"title": "Epilog"},
	"step/5": {"title": "Melarikan diri ke stasiun"},
	"step/6": {"title": "Mempersenjatai kapal"},
	"step/7": {"title": "Sarang bajak laut"},
	"step/8": {"title": "Setelah pertempuran"},
	"step/9": {"title": "Menyelesaikan urusan"},
	"world/galaxy": {"title": "Galaksi", "subtitle": "Latar", "category": "world", "from": 0},
	"world/history": {"title": "Sejarah", "subtitle": "Latar", "category": "world", "from": 0},
	"world/voids": {"title": "Para Void", "subtitle": "Latar", "category": "world", "from": 0},
}
const BLOCKS := {
	"agent/0": [
		[0, "", "[[agent/0]] adalah agen Nivelian di lounge stasiun [[station/3]] dalam sistem tersembunyi [[system/0]]. Ia menjual cetak biru laser [[item/11]].", false],
	],
	"agent/1": [
		[0, "", "[[agent/1]] adalah agen Nivelian di lounge stasiun [[station/8]] dalam sistem tersembunyi [[system/1]]. Ia menjual cetak biru blaster [[item/15]], senjata yang menurutnya langka.", false],
	],
	"agent/10": [
		[0, "", "[[agent/10]] adalah agen Terran yang tinggal di tengah bangsa Vossk, di lounge stasiun [[station/59]] dalam sistem [[system/20]]. Ia menjual cetak biru perangkat selubung [[item/96]].", false],
	],
	"agent/11": [
		[0, "", "[[agent/11]] adalah pedagang bijih [[character/2]], yang muncul di lounge-nya sendiri di stasiun [[station/78]] dalam sistem [[system/15]]. Ia menjual cetak biru [[item/90]], laser tambang buatannya sendiri, dengan harga jauh di atas agen lain mana pun. Karena [[system/15]] tidak memiliki sambungan gerbang, untuk menemuinya belakangan dalam permainan diperlukan mesin lompat.", false],
		[10, "", "Ia menyapa [[character/0]] sebagai si penjelajah waktu dan kini telah mulai memproduksi bor yang dulu ia simpan sendiri.", false],
	],
	"agent/12": [
		[0, "", "[[agent/12]] adalah agen Vossk di lounge stasiun [[station/18]] dalam sistem [[system/3]]. Ia menjual koordinat sistem tersembunyi [[system/0]] sambil memuji banyaknya stasiun canggih di sana.", false],
	],
	"agent/13": [
		[0, "", "[[agent/13]] adalah agen Bobolian di lounge stasiun [[station/26]] dalam sistem [[system/5]]. Ia menjual koordinat sistem tersembunyi [[system/1]].", false],
	],
	"agent/14": [
		[0, "", "[[agent/14]] adalah agen Cyborg di lounge stasiun [[station/65]] dalam sistem [[system/13]]. Ia menjual koordinat [[system/10]] tetapi mengaku tidak tahu cara ke sana. Tanpa mesin lompat koordinat itu tidak berguna, karena sistem tersebut tidak memiliki sambungan gerbang.", false],
	],
	"agent/15": [
		[0, "", "[[agent/15]] adalah agen Vossk di lounge stasiun [[station/88]] dalam sistem [[system/17]]. Ia menjual koordinat sistem tersembunyi [[system/21]], yang ia sebut kampung halamannya. Setelah diketahui, sistem itu dapat dicapai lewat gerbang dari [[system/20]].", false],
	],
	"agent/2": [
		[0, "", "[[agent/2]] adalah agen Midorian di lounge stasiun [[station/20]] dalam sistem [[system/4]]. Ia menjual cetak biru [[item/25]], cetak biru senjata termurah yang ditawarkan agen selain roket milik [[agent/4]].", false],
	],
	"agent/3": [
		[0, "", "[[agent/3]] adalah agen Terran di lounge stasiun [[station/10]] dalam sistem [[system/6]]. Ia menjual cetak biru [[item/27]], sebuah mass driver bertembakan cepat.", false],
	],
	"agent/4": [
		[0, "", "[[agent/4]] adalah agen Terran di lounge stasiun [[station/43]] dalam sistem [[system/8]]. Ia menjual cetak biru [[item/33]], cetak biru termurah yang ditawarkan agen mana pun.", false],
	],
	"agent/5": [
		[0, "", "[[agent/5]] adalah agen Vossk di lounge stasiun [[station/54]] dalam sistem [[system/10]], sistem yang hanya dapat dicapai dengan mesin lompat. Ia menjual cetak biru torpedo pemandu [[item/37]], yang tidak tersedia di toko mana pun.", false],
	],
	"agent/6": [
		[0, "", "[[agent/6]] adalah satu-satunya Multipod dalam permainan. Ia duduk di lounge stasiun [[station/61]] dalam sistem [[system/12]] dan menjual cetak biru senjata nuklir [[item/46]].", false],
	],
	"agent/7": [
		[0, "", "[[agent/7]] adalah agen Terran di lounge stasiun [[station/72]] dalam sistem [[system/14]]. Ia menjual cetak biru [[item/54]], sebuah perisai yang kuat.", false],
	],
	"agent/8": [
		[0, "", "[[agent/8]] adalah agen Vossk di lounge stasiun [[station/84]] dalam sistem [[system/16]]. Ia menjual cetak biru [[item/59]], pelat zirah Vossk yang tidak pernah dijual di toko. Inilah cetak biru termahal yang dijual agen, setelah bor milik [[agent/11]].", false],
	],
	"agent/9": [
		[0, "", "[[agent/9]] adalah agen Terran di lounge stasiun [[station/90]] dalam sistem [[system/18]]. Ia menjual cetak biru [[item/67]], kompresor kargo yang ia sarankan kepada setiap pedagang.", false],
	],
	"character/0": [
		[0, "", "[[character/0]] adalah tokoh utama dan karakter yang Anda mainkan. Ia seorang pilot tempur [[faction/0]] yang mencari nafkah dengan memburu [[faction/8|bajak laut]] demi hadiah atas kepala mereka. Ia percaya diri, sarkastis, dan mudah terpancing untuk bertarung.", false],
		[1, "Terdampar", "Dalam perjalanan ke Eden Prime, tempat Laksamana Smith menyiapkan misi khusus untuknya, hyperdrive-nya rusak dalam serangan bajak laut. Autopilot membawanya, dalam keadaan pingsan, ke stasiun [[station/78]].", false],
		[2, "", "Di sana ia diselamatkan oleh pedagang bijih [[character/2]], yang mengklaim kapalnya sebagai barang sitaan dan mempekerjakannya sebagai penambang.", false],
		[8, "", "Keith adalah veteran Armada Luar Angkasa Terran, tempat ia bertugas di bawah Laksamana Smith.", false],
		[9, "", "Ia mengetahui bahwa sang laksamana telah meninggal karena usia tua dan bahwa sekarang tahun 3624.", false],
		[10, "", "Sekitar 35 tahun telah berlalu sejak kecelakaannya, tampaknya karena kerusakan hyperdrive, tetapi Keith sama sekali tidak menua. Terdampar di sistem terpencil [[system/15]], ia memulai lagi dengan [[ship/0]], hadiah dari Gunant.", false],
		[16, "Perang melawan Void", "Setelah salah ditangkap, ia bertemu kembali dengan kawan lamanya [[character/1]] di stasiun [[station/98]] dan menjalani pertempuran pertamanya melawan [[faction/9|para Void]].", false],
		[18, "", "Brent merekrutnya sebagai pilot untuk organisasi riset Deep Science, yang menyelidiki para Void.", false],
		[24, "", "Di stasiun [[station/10]] ia bertemu [[character/6]], pemimpin proyek itu, dan segera tertarik kepadanya.", false],
		[26, "", "Ia dan Carla terseret melalui lubang cacing Void ke sektor asal para Void dan menemukan jalan pulang.", false],
		[36, "", "Komandan Vossk [[character/7]] mengetahui pengabdian Keith dahulu di Novaterra.", false],
		[43, "", "Keith mengawal kapal barang yang menghancurkan kapal induk Void dan mengakhiri serbuan, meskipun Errkt gugur dalam serangan itu.", false],
		[45, "Sesudahnya", "Imbalannya adalah satu malam bersama Carla, yang kemudian menghilang ke proyek rahasia lain dan meninggalkan pembayaran terakhir untuknya. Dengan tugasnya selesai, Keith bebas menjelajahi galaksi.", false],
	],
	"character/1": [
		[16, "", "[[character/1]] adalah kawan lama Keith dari masa sebelum kecelakaannya. Selama 35 tahun yang hilang dari hidup Keith, Brent naik pangkat menjadi Letnan Komandan dan kepala Badan Keamanan Antarbintang. Ia ramah, banyak bicara, dan gemar bercerita panjang tentang kehidupannya.", false],
		[18, "Krisis Void", "Sebagai kepala keamanan, ia memimpin tim krisis yang mengoordinasikan tanggapan terhadap [[faction/9|para Void]]. Ia merekrut Keith untuk Deep Science dan memastikan Keith dibayar dengan baik. Kapal Keith dicat ulang atas perintahnya.", false],
		[19, "", "Ketika ilmuwan [[character/5]] diculik, Brent mendukung rencana penyelamatan Keith dan menyediakan bom EMP di stasiun [[station/55]].", false],
		[32, "", "Timnya mengembangkan sistem peringatan dini yang menunjukkan di mana para Void akan membuka lubang cacing berikutnya.", false],
		[35, "", "Bersama [[character/6]] ia menyusun rencana untuk menghancurkan kapal induk Void dengan kapal barang penuh bahan peledak, dan mengatur kesepakatan dengan komandan Vossk [[character/7]].", false],
		[43, "Sesudahnya", "Setelah kapal induk hancur, Brent merayakan kemenangan bersama Keith di stasiun [[station/98]].", false],
	],
	"character/2": [
		[2, "", "[[character/2]] adalah pedagang bijih [[faction/2]] yang mengelola stasiun tambang kecil [[station/78]] di sistem [[system/15]]. Ia menemukan bangkai kapal [[character/0]], menyelamatkan pilotnya, dan mengklaim kapal itu sebagai barang sitaan. Kasar namun praktis, ia menyuruh Keith melunasi utangnya dengan menambang bijih menggunakan [[ship/0]], kapal tua yang ia tambal sendiri.", false],
		[8, "", "Setelah Keith membantunya menghancurkan sarang bajak laut di dekat stasiunnya, Gunant mulai menghormatinya.", false],
		[10, "", "Sebagai ungkapan terima kasih, ia memberikan [[ship/0]] kepada Keith dengan penggerak yang lebih baik, dan mengutusnya kepada kawannya [[character/3]]. Gunant sendiri adalah anggota [[faction/3|Konfederasi Mido]]. Ia merancang laser tambangnya sendiri, dan sebagai agen [[agent/11]] ia menjual cetak biru salah satunya, [[item/90]].", false],
	],
	"character/20": [
		[32, "", "[[character/20]] adalah seorang ilmuwan dari bangsa [[faction/7|Grey]] yang bekerja untuk Deep Science. Ia ingin bertemu [[character/0]] di stasiun [[station/10]].", false],
		[33, "", "Khador berbicara dengan sopan santun yang berlebihan. Setelah meneliti puing Void, ia meyakini bahwa kristal yang hanya ditemukan di sektor Void menyimpan rahasia lubang cacing para Void. Ia telah bertahun-tahun mengembangkan penggerak yang dapat membawa kapal seketika ke titik mana pun di ruang angkasa, dan meminta Keith mengumpulkan 50 [[item/164]] untuk itu.", false],
		[34, "", "Ketika Keith menyerahkan kristal-kristal itu, Khador menghadiahinya salinan cetak biru penggerak yang menyandang namanya, [[item/85]].", false],
	],
	"character/3": [
		[10, "", "[[character/3]] adalah seorang kapten manusia yang bergabung dengan [[faction/3|Konfederasi Mido]] dan kini memimpin stasiun [[station/79]]. [[character/2]] merekomendasikannya kepada Keith sebagai orang yang dapat membantunya kembali ke wilayah Terran.", false],
		[11, "", "Norris menyambut Keith dan menjelaskan sejarah sistem [[system/15]]. Ia menawarkan untuk menghubungkan Keith dengan Armada Luar Angkasa Terran jika Keith terlebih dahulu menyelidiki kebisuan stasiun [[station/76]].", false],
		[13, "", "Ia mengatur agar Keith bertemu sebuah konvoi Terran yang melintasi sistem, dan menyarankannya mengambil pekerjaan lepas selagi menunggu.", false],
	],
	"character/4": [
		[12, "", "[[character/4]] adalah pedagang terkenal yang Keith kenal dulu sekali. Keith menemukannya di stasiun [[station/76]], tempat ia memasok seluruh awak dengan neuro-alga, sejenis narkoba dengan efek samping yang tidak menyenangkan. Mkkt mengingat Keith dan penasaran mengapa ia tidak menua.", false],
		[13, "", "Setelah mendengar laporan Keith, [[character/3]] berjanji akan menindaknya.", false],
	],
	"character/5": [
		[18, "", "Tommy adalah Letnan Thomas Boyle, seorang ilmuwan yang bekerja untuk Deep Science. [[character/1]] mengatur agar ia menemui Keith di stasiun [[station/56]] dan memandunya ke stasiun riset rahasia organisasi itu.", false],
		[19, "", "Boyle diculik oleh bajak laut di dekat stasiun [[station/55]] sebelum pertemuan, dan mereka menuntut tebusan untuknya.", false],
		[23, "", "Setelah Keith melumpuhkan kapal para penculik, Boyle berhasil diselamatkan. Ia memberi Keith koordinat sistem [[system/6]] dan ikut bersamanya ke stasiun [[station/10]].", false],
	],
	"character/6": [
		[23, "", "Dr. Paolini adalah ilmuwan Deep Science yang menanti Keith dan Boyle di stasiun [[station/10]].", false],
		[24, "", "Dr. Carla Paolini memimpin proyek Deep Science tentang [[faction/9|para Void]]. Ia tegas dan pekerja keras, dan bersikeras melihat para Void dengan mata kepalanya sendiri, sehingga ia ikut terbang bersama [[character/0]] dalam misi pengumpulan puing pertamanya. Keith tertarik kepadanya sejak pertemuan pertama.", false],
		[26, "", "Ia dan Keith terseret melalui lubang cacing ke sektor asal para Void dan nyaris tidak lolos bersama-sama.", false],
		[28, "", "Timnya membuat wahana untuk menganalisis kapal induk Void. Ia setuju berkencan dengan Keith jika Keith kembali hidup-hidup dari misinya.", false],
		[34, "", "Terlalu sibuk dengan risetnya untuk menepati kencan, ia menyusun rencana bersama [[character/1]] untuk menyerang kapal induk.", false],
		[44, "Sesudahnya", "Setelah kemenangan, ia menyusul Keith dan Brent di stasiun [[station/98]] untuk kencan yang lama tertunda.", false],
		[45, "", "Keesokan paginya ia sudah pergi, meninggalkan sepucuk catatan: ia berangkat ke proyek rahasia lain dan meminta Keith tidak mencarinya.", false],
	],
	"character/7": [
		[35, "", "[[character/7]] adalah seorang komandan [[faction/1]] yang memimpin stasiun [[station/29]] di sistem [[system/5]]. Ia memasok kapal barang K'Sarr untuk serangan ke kapal induk Void, sebagai imbalan atas tahanan.", false],
		[36, "", "Bangga dan kaku, ia meyakini bahwa hanya seorang Vossk yang dapat menerbangkan kapal Vossk dengan benar dan bersikeras menerbangkan kapal barang itu sendiri. Ia menguji kemampuan Keith sebelum menerimanya sebagai pengawal.", false],
		[37, "", "Setelah Keith mengalahkannya dalam adu kemampuan di sarang bajak laut, Errkt memperlakukannya dengan hormat.", false],
		[40, "", "Menjelang misi ia tenang dan menyendiri, yang ditafsirkan Brent sebagai tekad.", false],
		[42, "Kematian", "Errkt menerbangkan kapal barang melewati lubang cacing dan menabrakkannya ke kapal induk. Ketika kapsul penyelamatnya hancur, ia menolak berbalik dan tewas dalam ledakan, setelah menyuruh Keith menyelamatkan diri.", false],
		[43, "", "Brent berjanji akan melaporkan pengorbanannya kepada Kekaisaran Vossk.", false],
	],
	"character/8": [
		[40, "", "Letnan [[character/8]] memimpin regu bala bantuan yang bergabung dengan Keith untuk melindungi kapal barang Vossk dalam perjalanannya ke lubang cacing.", false],
		[41, "", "Regunya tidak sempat menembus lubang cacing sebelum tertutup, sehingga Keith dan [[character/7]] menghadapi para Void berdua saja.", false],
	],
	"chart": [
		[0, "", "Peta galaksi mencantumkan setiap sistem beserta faksinya, peringkat keamanannya, jumlah stasiunnya, dan posisinya di peta. Posisi diberikan sebagai dua angka dari 0 sampai 100: angka pertama dihitung dari tepi kiri peta bintang, angka kedua dari tepi atas. Sistem dengan angka yang mirip letaknya berdekatan.", false],
		[0, "", "Di dalam permainan, buka peta bintang dari stasiun atau saat terbang. Garis putus-putus menghubungkan sistem Anda saat ini dengan setiap sistem yang dijangkau gerbang lompatnya; rute gerbang lainnya tampil sebagai garis tipis. Bintang yang dapat Anda capai saat ini tampak terang, sisanya diredupkan. Penanda menunjukkan sistem misi cerita dan pekerjaan Anda saat ini, dan garis putus-putus berwarna menunjukkan rute gerbang terpendek ke sana. Garis emas pudar menelusuri beberapa perjalanan terakhir Anda.", false],
		[0, "", "Pilih sebuah sistem untuk melihat faksinya, peringkat keamanannya, dan jaraknya. Perbesar untuk melihat stasiun-stasiunnya, tingkat teknologinya, serta penanda stasiun yang pernah Anda kunjungi, sasaran misi, dan gerbang lompat. Sistem tersembunyi tidak muncul sampai Anda mengetahui koordinatnya; lihat [[world/galaxy]].", false],
		[32, "", "Setelah Anda memiliki sistem peringatan dini dari [[step/31]], peta bintang juga menandai sistem dan stasiun tempat lubang cacing Void berikutnya akan terbuka.", false],
	],
	"faction/0": [
		[0, "", "Bangsa Terran adalah manusia, dan [[character/0]] salah satunya. Mereka menguasai sepuluh sistem, lebih banyak daripada faksi lain mana pun, tersebar di tengah, sisi kanan, dan bagian bawah peta, dengan [[system/19]] dan [[system/14]] sebagai intinya. Wilayah Terran adalah bagian galaksi yang paling aman: kedua sistemnya yang berperingkat Aman sama-sama milik Terran.", false],
		[0, "", "Stasiun Terran menjual pilihan kapal dan perlengkapan yang paling luas. Pedagang kapal di luar wilayah Vossk menawarkan beragam jenis kapal. Saingan tradisional bangsa Terran adalah [[faction/1]]: reputasi yang diperoleh di mata yang satu hilang di mata yang lain.", false],
		[16, "", "Armada Luar Angkasa Terran masih merupakan pasukan tempat [[character/0]] dulu bertugas, tetapi 35 tahun telah berlalu. Ketika akhirnya ia bertemu konvoi Terran, mereka mengira kapal lamanya yang buatan bajak laut itu sebagai musuh dan menangkapnya.", false],
		[18, "", "Bangsa Terran memimpin pertahanan melawan para Void. [[character/1]], kini kepala Badan Keamanan Antarbintang, memimpin tim krisis, dan kelompok riset Deep Science menangani masalah itu dari sebuah stasiun rahasia.", false],
	],
	"faction/1": [
		[0, "", "Bangsa Vossk adalah bangsa alien yang terorganisasi sebagai kekaisaran. Mereka menguasai enam sistem di kanan bawah peta, dari [[system/3]] dan [[system/12]] hingga [[system/21]] yang terpencil. Empat di antaranya berperingkat Berbahaya atau Berisiko. [[system/10]] sama sekali tidak memiliki sambungan gerbang.", false],
		[0, "", "Pedagang kapal Vossk hanya menjual satu jenis kapal, [[ship/9]], model yang disesuaikan untuk ras lain. Stasiun Vossk juga menyediakan senjata dan perlengkapan yang tidak ada di tempat lain. Bangsa Vossk adalah saingan tradisional [[faction/0|bangsa Terran]], sehingga kapal-kapal mereka dapat ikut menjadi perampok di wilayah Terran, dan sebaliknya.", false],
		[18, "", "Hubungan antara bangsa Terran dan Kekaisaran Vossk tetap dingin dan sulit ditebak, tetapi serbuan Void juga menghantam sistem-sistem Vossk.", false],
		[36, "", "Dalam cerita, bangsa Vossk tampil sebagai bangsa yang bangga dan menjunjung kehormatan. Komandan mereka, [[character/7]], bersikeras menerbangkan sendiri kapal pembawa bom dan menguji [[character/0]] lewat adu kemampuan sebelum menerimanya sebagai pengawal.", false],
		[42, "", "[[character/7]] mengorbankan nyawanya untuk menghancurkan kapal induk Void, dan bangsa Terran berjanji melaporkan jasanya kepada Kekaisaran Vossk.", false],
	],
	"faction/2": [
		[0, "", "Bangsa Nivelian adalah bangsa alien yang menguasai empat sistem di sisi kiri peta: [[system/2]], [[system/9]], [[system/17]], dan [[system/0]] yang tersembunyi. Stasiun mereka beragam, dari pos kecil hingga beberapa yang tercanggih di galaksi. Saingan mereka adalah [[faction/3|bangsa Midorian]].", false],
		[2, "", "Orang pertama yang ditemui [[character/0]] adalah seorang Nivelian, pedagang bijih [[character/2]]. [[character/0]] berpandangan rendah terhadap tata krama Nivelian, sedangkan [[character/2]] bersikeras bahwa ia pengusaha yang jujur.", false],
		[11, "", "Sebuah perang saudara Nivelian melahirkan [[faction/3|Konfederasi Mido]]. Bangsa Nivelian tidak pernah menerima kemerdekaannya dan masih mengklaim sistem [[system/15]].", false],
		[35, "", "Rencana melawan kapal induk Void bergantung pada bahan peledak nuklir Nivelian.", false],
	],
	"faction/3": [
		[0, "", "Bangsa Midorian adalah rakyat [[faction/3|Konfederasi Mido]]. Mereka menguasai dua sistem di kiri atas peta, [[system/15]] dan [[system/4]], keduanya berperingkat Berbahaya. Stasiun mereka sebagian besar kecil dan berteknologi rendah. Saingan mereka adalah [[faction/2|bangsa Nivelian]].", false],
		[11, "", "Konfederasi didirikan oleh pengungsi dan pelanggar hukum Terran dan Nivelian semasa Perang Saudara Nivelian. Konfederasi membatasi kontak dengan sistem lain seminimal mungkin. [[character/3]], komandan stasiun [[station/79]], adalah salah satu anggotanya, demikian pula [[character/2]].", false],
		[38, "", "Konfederasi bukan sahabat bangsa Nivelian. Kapal-kapalnya merampas konvoi pembawa bahan peledak Nivelian yang ditujukan untuk kapal induk Void, dan [[character/0]] harus merebutnya kembali di dekat stasiun [[station/22]].", false],
	],
	"faction/4": [
		[0, "", "Multipod adalah ras kecil tanpa sistem sendiri. Satu-satunya Multipod yang Anda temui adalah agen [[agent/6]], yang menjual cetak biru di lounge stasiun [[station/61]] dalam sistem [[system/12]].", false],
	],
	"faction/5": [
		[0, "", "Cyborg tidak memiliki wilayah. Satu-satunya Cyborg dalam permainan adalah agen [[agent/14]] di lounge stasiun [[station/65]], yang memperdagangkan koordinat sebuah sistem tersembunyi.", false],
	],
	"faction/6": [
		[0, "", "Bobolian adalah ras kecil tanpa sistem sendiri. Agen [[agent/13]], seorang Bobolian, duduk di lounge stasiun [[station/26]] di wilayah Vossk dan menjual koordinat sebuah sistem tersembunyi.", false],
	],
	"faction/7": [
		[0, "", "Grey adalah ras tanpa sistem, stasiun, maupun kapal sendiri. Mereka tidak berperan dalam perdagangan atau pertempuran.", false],
		[32, "", "Satu-satunya Grey dalam cerita adalah [[character/20]], seorang ilmuwan yang bekerja bersama Deep Science.", false],
		[33, "", "Ia meneliti sisa-sisa kapal Void dan mengembangkan jenis penggerak baru dari temuannya.", false],
	],
	"faction/8": [
		[0, "", "Bajak laut adalah pelanggar hukum dari segala ras. Mereka tidak memiliki sistem tetapi muncul di mana-mana, dan selalu bermusuhan. Seberapa sering mereka menunggu di dekat stasiun bergantung pada peringkat keamanan sistem. Banyak pekerjaan lepas meminta Anda memburu mereka, dan bangkai kapal mereka dapat dijarah muatannya.", false],
		[0, "", "Cerita dibuka dengan [[character/0]] yang mengejar sekawanan bajak laut demi hadiah atas kepala mereka.", false],
		[2, "", "[[ship/0]], kapal yang dipinjamkan [[character/2]] kepada [[character/0]], dahulu adalah kapal bajak laut.", false],
		[16, "", "Inilah sebabnya bangsa Terran kemudian mengira ia bajak laut.", false],
		[19, "", "Bajak laut juga menculik [[character/5]] di dekat stasiun [[station/55]] dan menuntut tebusan.", false],
	],
	"faction/9": [
		[0, "", "Void adalah kekuatan bermusuhan yang menyerang tanpa peringatan. Mereka tidak memiliki sistem di peta, dan kapal-kapal mereka menembaki siapa saja. Pesawat tempur mereka, [[ship/8]], adalah kapal berzirah paling tebal dalam permainan. Lihat [[world/voids]].", false],
		[2, "", "Di [[system/15]], para Void hanya dikenal lewat desas-desus dan penampakan yang langka.", false],
		[16, "", "Satu skuadron Void menyerang stasiun [[station/98]] saat [[character/0]] berada di sana. Pesan radio mereka menyatakan niat damai sambil terus menembak.", false],
		[18, "", "Para Void datang melalui lubang cacing yang terbuka sebentar di dekat stasiun. Mereka menyerbu sistem Terran, Nivelian, dan Vossk tanpa pandang bulu dan tampaknya mengincar bijih. Tidak ada yang tahu dari mana mereka berasal.", false],
		[24, "", "Di stasiun [[station/48]] mereka menyiarkan klaim yang lebih aneh: bahwa mereka datang dari masa depan dan merupakan sisa terakhir peradaban-peradaban galaksi.", false],
		[26, "", "Sebuah lubang cacing mengarah ke sektor mereka sendiri, tempat sebuah kapal induk raksasa meluncurkan pesawat-pesawat tempur mereka.", false],
		[35, "", "Kapal induk itu tampaknya menjadi sumber lubang cacing.", false],
		[42, "", "Hancurnya kapal induk di [[step/41]] meruntuhkan lubang-lubang cacing dan mengakhiri serbuan, setidaknya untuk sementara.", false],
	],
	"guide/basics": [
		[0, "Pembukaan", "Permainan baru dimulai di luar angkasa, bukan di stasiun. [[character/0]] sedang mengejar sekawanan bajak laut melintasi ladang asteroid, dan penerbangan pertama berupa pertempuran singkat yang mengajarkan cara mengemudi, membidik, dan menembak. Selama berlangsung, hanya bidikan dan penanda kapal yang ditampilkan. Hancurkan para bajak laut dan biarkan adegannya berjalan; cerita kemudian berlanjut dengan sendirinya.", false],
		[2, "", "Setelah pembukaan, Anda terbangun di stasiun [[station/78]], stasiun tambang kecil yang dikelola [[character/2]]. Ia meminjamkan [[ship/0]], kapal tanpa senjata dengan laser tambang, dan tahap-tahap pertama mengajarkan penambangan, autopilot, dan cara berlabuh. Senjata, peta, dan bagian stasiun lainnya terbuka seiring cerita berjalan.", false],
		[0, "Berlabuh", "Untuk berlabuh, tahan bidikan di atas stasiun sampai terkunci, lalu tekan Tembak: autopilot mengambil alih dan menerbangkan Anda masuk. Anda juga dapat terbang masuk sendiri; kapal berlabuh begitu menyentuh lambung stasiun. Saat berlabuh, sebagian besar urusan administrasi diselesaikan. Lambung, zirah, dan perisai Anda dipulihkan tanpa biaya, kiriman dan penumpang diserahkan, barang hasil cetak biru yang sudah jadi diambil, medali baru diberikan, dan permainan menyimpan dirinya sendiri.", false],
		[0, "Layar stasiun", "Stasiun tempat Anda berlabuh menawarkan enam bagian: Hangar, Lounge Luar Angkasa, Peta, Missions, Status, dan Game Options. Di awal cerita sebagian di antaranya terkunci dan ditandai gembok. Hangar terbuka di [[step/5]], Peta di [[step/9]], serta Lounge Luar Angkasa dan Missions di [[step/13]]. Status dan Game Options selalu tersedia.", false],
		[0, "", "Hangar berisi Shop (membeli dan menjual barang serta perlengkapan), Kapal (memasang dan melepas perlengkapan), Kapal (pedagang kapal, di stasiun yang memilikinya), dan Cetak biru (produksi). Lounge Luar Angkasa adalah tempat klien, pedagang, dan pilot sewaan menunggu. Peta menampilkan galaksi dan memungkinkan Anda memilih tujuan. Missions mencantumkan sasaran cerita saat ini dan pekerjaan lepas yang Anda ambil. Status menampilkan catatan pilot Anda, reputasi Anda di mata empat ras besar, dan medali Anda. Bilah atas menunjukkan Tec Level stasiun, yang menentukan apa saja yang dapat disediakan tokonya.", false],
		[0, "Meninggalkan stasiun", "Tekan Depart untuk meluncur. Setiap penerbangan dibuka dengan beberapa detik tayangan kapal Anda meninggalkan stasiun, disertai keterangan sistem dan sebuah kiat; tombol apa pun, klik, atau ketukan akan melewatinya. Jika Anda memilih tujuan di Peta sebelum berangkat, autopilot langsung mengarah ke sana begitu peluncuran selesai. Anda tidak dapat berangkat dengan muatan melebihi daya tampung ruang kargo, jadi jual atau pasang kelebihannya terlebih dahulu.", false],
		[0, "Menyimpan", "Permainan menyimpan secara otomatis setiap kali selesai berlabuh, setelah imbalan dan tahap cerita berikutnya diselesaikan. Anda juga dapat menyimpan secara manual ke salah satu dari tiga slot melalui Game Options saat berlabuh, dan memuat slot mana pun atau simpanan otomatis dari sana atau dari layar judul. Di luar versi peramban, Game Options juga dapat mengekspor simpanan ke berkas dan mengimpornya kembali. Simpanan terikat pada data game yang dipakai saat membuatnya.", false],
		[0, "", "Jika kapal Anda hancur, penerbangan berakhir dan Anda melanjutkan dari stasiun simpanan otomatis terakhir, atau memulai dari awal jika tidak ada. Semua yang diperoleh sejak berlabuh terakhir akan hilang, jadi sesekali berlabuhlah selama perjalanan panjang.", false],
		[0, "Tingkat pilot", "Pilot Anda memiliki tingkat yang ditampilkan di layar Status. Pengalaman diperoleh dari menghancurkan musuh, pekerjaan lepas (masing-masing bernilai dua poin), inti yang ditambang, setiap lima puluh ton bijih yang ditambang, dan setiap dua pilot pendamping yang disewa. Tingkat naik satu setiap kali pengalaman melampaui 1,3 kali angka pada kenaikan sebelumnya, dan diperiksa saat Anda berlabuh. Tingkat yang lebih tinggi membuat musuh lebih tangguh, tetapi juga menaikkan imbalan pekerjaan lepas dan bayaran pilot sewaan.", false],
	],
	"guide/blueprints": [
		[0, "Cetak biru", "Sebagian senjata dan perlengkapan terbaik tidak pernah dijual di toko. Barang-barang itu dibuat dari cetak biru. Cetak biru mencantumkan barang yang dibutuhkan beserta jumlahnya. Cetak biru dibeli dari agen-agen bernama di Lounge Luar Angkasa, yang muncul setelah cerita melewati [[step/16]]; setiap agen menjual satu cetak biru, sekali saja.", false],
		[34, "", "Cetak biru mesin lompat [[item/85]] tidak dijual oleh siapa pun: cerita menyerahkannya di [[step/34]].", false],
		[0, "Produksi", "Produksi berlangsung di tab Cetak biru di Hangar. Pilih cetak biru dan serahkan bahan-bahan dari ruang kargo Anda. Anda dapat menyerahkannya sebagian demi sebagian dalam beberapa kunjungan. Stasiun tempat Anda pertama kali menyerahkan bahan menjadi stasiun produksi untuk batch itu. Bahan yang diserahkan di stasiun lain dikirim ke sana dengan biaya 10 kredit per ton, jadi sebaiknya bawa semuanya ke tempat yang sama.", false],
		[0, "Barang jadi", "Saat bahan terakhir masuk, batch selesai. Senjata sekunder dibuat sepuluh sekaligus; selainnya satu per satu. Jika Anda menyelesaikannya di stasiun produksi, barangnya langsung masuk ke ruang kargo Anda, meskipun melebihi kapasitas. Jika tidak, barangnya menunggu di stasiun produksi dan diserahkan saat Anda berikutnya berlabuh di sana. Cetak biru tidak pernah habis: setelah satu batch selesai, Anda dapat memulai batch berikutnya.", false],
		[0, "Medali", "Memiliki cetak biru dihitung untuk [[medal/13]], dan menyelesaikan berbagai cetak biru dihitung untuk [[medal/14]].", false],
	],
	"guide/combat": [
		[0, "Senjata primer", "Senjata primer adalah senjata yang terpasang menghadap ke depan: laser, blaster, meriam otomatis, dan senjata termo. Masing-masing memiliki kerusakan, laju tembak, jangkauan, dan kecepatan proyektil sendiri, dan semua senjata primer yang terpasang menembak bersamaan. Beberapa blaster, seperti [[item/16]], adalah senjata EMP yang menguras energi kapal alih-alih lambungnya. Tembak otomatis membuat senjata terus menembak target tanpa menahan tombol.", false],
		[0, "Perisai, zirah, dan lambung", "Kerusakan pertama-tama menguras perisai, lalu pelat zirah, dan baru kemudian lambung itu sendiri. Perisai terisi penuh kembali selama waktu isi ulangnya; zirah dan lambung tidak. Robot perbaikan perlahan memulihkan lambung dan zirah selama terbang. Berlabuh memulihkan semuanya tanpa biaya. Saat lambung habis, kapal hancur.", false],
		[0, "EMP", "Setiap kapal memiliki cadangan energi. Senjata EMP mengurasnya, dan kapal yang energinya habis menjadi lumpuh: kapal itu terapung tak berdaya sampai energinya terkumpul kembali. Kapal yang lumpuh dapat dirampas muatannya dengan sinar traktor, dan beberapa pekerjaan mengharuskan sebuah kapal dilumpuhkan, bukan dihancurkan. Perlengkapan pelindung EMP, seperti [[item/60]], memiliki angka pertahanan EMP.", false],
		[0, "Senjata sekunder", "Senjata sekunder menembak dari slot sekunder dan menghabiskan amunisi, yang menumpuk di slot tersebut. Roket terbang lurus. Torpedo berbelok mengikuti kuncian radar sesaat setelah diluncurkan. Bom EMP dan nuklir meledak di suatu area dan mengenai semua yang ada dalam jangkauan ledakannya, makin lemah ke arah tepi; bom EMP tidak memengaruhi asteroid, sedangkan nuklir menghancurkannya. Pilih peluncur yang akan dipakai dari menu Aksi; sebelum Anda memilih, tombol Senjata sekunder menembakkan peluncur pertama yang berisi.", false],
		[0, "Turet", "Lambung yang lebih besar memiliki slot turet. Dengan turet terpasang, tombol Pandangan belakang beralih ke tampilan turet: kapal mempertahankan arahnya sementara Anda memutar turet dan menembakkannya, sehingga Anda dapat membalas kapal yang membuntuti dari belakang.", false],
		[0, "Pilot pendamping", "Mulai [[step/16]], pilot sewaan dapat ditemui di Lounge Luar Angkasa. Satu kontrak mencakup satu sampai tiga kapal untuk sepuluh menit penerbangan, dan mereka terbang bersama Anda ke mana pun sampai kontrak habis. Beri mereka perintah dari menu Aksi: tembak sesuka hati, serang target Anda, amankan titik misi berikutnya, atau beralih antara laser dan blaster EMP mereka. Lihat [[guide/lounge]].", false],
		[0, "Bajak laut", "Bajak laut menyerbu stasiun, lebih sering di sistem berbahaya, dan menghadang pilot yang membawa kiriman atau penumpang. Banyak pekerjaan lepas berkisar pada memerangi mereka. Menembak bajak laut tidak membuat siapa pun marah; justru sedikit meningkatkan reputasi Anda di mata ras yang menguasai sistem itu.", false],
		[0, "Reputasi", "Reputasi Anda dicatat pada dua skala, masing-masing dari -100 sampai 100: satu antara ras [[faction/0]] dan [[faction/1]], satu lagi antara ras [[faction/2]] dan [[faction/3]]. Merugikan satu ras menggeser skala ke arah saingannya: melumpuhkan atau merampok salah satu kapalnya mengurangi 2 poin, menghancurkannya mengurangi 5. Menyelesaikan pekerjaan lepas menggeser skala 2 poin ke arah ras klien. Begitu skala melewati 60 ke salah satu arah, ras di pihak yang kalah menjadi bermusuhan, dan kapal-kapalnya langsung menyerang Anda.", false],
		[0, "", "Ras yang bermusuhan mengirim seorang diplomat ke Lounge Luar Angkasa, yang menawarkan untuk mengembalikan skala ke nol dengan bayaran yang makin besar seiring jauhnya pergeseran: paling banyak 16.000 kredit. Status menampilkan kedua skala. Mendorong skala melewati 60 juga menghasilkan [[medal/28]].", false],
		[0, "Tembakan kawan", "Kapal-kapal ras penguasa sistem hanya menoleransi tembakan nyasar sampai batas tertentu. Begitu Anda menghabiskan sepertiga lambung atau energi sebuah kapal setempat, kapal itu membalas dan memperingatkan Anda lewat radio. Pada dua pertiga lambungnya, atau saat Anda melumpuhkannya, semua kapal ras itu di sistem tersebut berbalik menyerang Anda. Kapal ras lain tidak sepeka itu, tetapi menghancurkan kapal selalu mengurangi reputasi.", false],
	],
	"guide/fitting": [
		[0, "Lambung", "Lambung kapal menentukan zirahnya (kekuatan lambung itu sendiri), ruang kargonya, kelincahannya, dan slot-slotnya: senjata primer, senjata sekunder, turet, dan perlengkapan. Lambung yang lebih baik terutama berarti lebih banyak slot. Halaman kapal membandingkan setiap lambung.", false],
		[0, "Slot dan layar Kapal", "Barang dibeli ke ruang kargo lalu dipasang di layar Kapal di Hangar. Setiap slot menampung satu barang dari kategorinya; memasang barang di slot yang terisi akan mengembalikan barang lama ke ruang kargo. Setiap jenis perlengkapan hanya dapat dipasang sekali, kecuali jenis yang dapat ditumpuk, seperti unit kompresi kargo, kabin, dan pelindung EMP, yang dapat dipasang beberapa sekaligus, masing-masing di slotnya sendiri. Amunisi sekunder sejenis berbagi satu slot. Barang yang terpasang juga dapat langsung dijual dari slotnya dengan harga stasiun.", false],
		[0, "Jenis perlengkapan", "Perisai menyerap kerusakan dan terisi ulang. Pelat zirah menambah kekuatan lambung. Pelindung EMP menangkal pengurasan energi. Kompresi kargo memperbesar ruang kargo. Sinar traktor menarik muatan dari bangkai dan kapal yang lumpuh; tanpanya, tidak ada yang dapat dikumpulkan di luar angkasa. Booster memberi semburan kecepatan. Robot perbaikan memperbaiki kapal selama terbang. Nosel kemudi meningkatkan kelincahan. Pemindai mempersingkat waktu mengunci target, dan yang lebih baik menampilkan muatan target. Laser tambang mengebor asteroid. Kabin mengangkut penumpang. Selubung menyembunyikan kapal untuk sementara. Mesin lompat bepergian tanpa gerbang.", false],
		[0, "Membeli lambung", "Stasiun yang memiliki pedagang menampilkan tab Kapal di Hangar dengan hingga lima lambung untuk dijual. Pedagang [[faction/1]] hanya menawarkan lambung ras mereka sendiri, [[ship/9]]. Pedagang memotong harga daftar sebesar Tec Level stasiunnya dalam persen, sehingga stasiun berteknologi tinggi menjual lambung lebih murah. Lambung lama Anda diterima sebagai tukar tambah seharga empat perlima dari harga daftarnya. Semua yang terpasang dipindahkan ke ruang kargo, jadi pastikan muat atau jual sebagian sebelum berangkat. Anda tidak dapat berganti lambung selama ada penumpang di dalam, dan kabin tidak dapat dilepas selama sedang dipakai.", false],
		[5, "Senjata pertama", "Saat hanggar di stasiun [[station/78]] pertama kali terbuka, raknya berisi sebuah laser, sebuah meriam otomatis, dan sebuah pelat zirah secara cuma-cuma. Pasang satu senjata dan pelat itu sebelum berangkat ke misi berikutnya.", false],
		[0, "Lambung langka", "Beberapa lambung tidak pernah ditawarkan pedagang biasa. Pilot yang telah memenangkan semua medali dalam tingkat emas ditawari sebuah purwarupa, [[ship/8]], di stasiun [[station/10]]; lihat [[guide/medals]].", false],
	],
	"guide/flight": [
		[0, "Mengemudi", "Kapal selalu terbang ke depan. Anda membeloknya ke kiri dan ke kanan serta menaikkan dan menurunkan hidungnya; saat dilepas, kapal meratakan sayapnya sendiri. Seberapa cepat kapal berbelok bergantung pada kelincahan lambung dan nosel kemudi yang terpasang. Di Options, Kontrol, Respons kemudi dapat diatur ke Langsung, yang langsung berbelok dengan kecepatan penuh, atau Halus, yang masuk dan keluar belokan secara bertahap. Dengan kemudi mouse, tombol kiri dan kanan dapat menggeser kapal ke samping alih-alih membeloknya.", false],
		[0, "Pengatur dorongan", "Tambah dorongan dan Kurangi dorongan mengubah dorongan per seperempat, dan menahan tombolnya terus mengubahnya. Kapal butuh sekitar satu detik untuk mantap pada kecepatan baru. Autopilot dan booster selalu terbang dengan dorongan penuh, dan mengurangi dorongan selama boost akan mengakhirinya.", false],
		[0, "Booster", "Dengan booster terpasang, tombol Booster memberi semburan kecepatan tambahan. Semburan berlangsung selama durasi booster dan diikuti waktu isi ulang sebelum semburan berikutnya; HUD menunjukkan apakah booster siap. Booster yang lebih baik lebih cepat, lebih lama, atau lebih cepat terisi ulang. Boost berguna untuk kabur dari pertempuran dan untuk menempuh jarak jauh di dalam sistem.", false],
		[0, "Autopilot", "Tombol Autopilot menyerahkan kemudi kepada komputer kapal, dan menekannya lagi mengambilnya kembali. Autopilot terbang ke objek yang terkunci, atau jika tidak ada, ke tujuan yang dipilih di Peta: gerbang lompat bila tujuannya di sistem lain, atau planet tujuan bila di sistem ini. Daftar Autopilot menawarkan pilihan yang ada di tempat Anda berada: tujuan yang diprogram, gerbang lompat, stasiun ini, ladang asteroid, dan titik misi berikutnya. Terbang ke stasiun yang terkunci berakhir dengan berlabuh.", false],
		[0, "Kecepatan waktu", "Tombol Kecepatan waktu mempercepat jalannya penerbangan. Kecepatan ganda selalu tersedia selama terbang. Empat dan delapan kali hanya ditawarkan saat autopilot yang terbang, tidak ada musuh di dekat, dan tidak ada hal lain yang sedang berlangsung, seperti menambang, berlabuh, atau melompat.", false],
		[0, "Membidik sasaran", "Untuk mengunci sebuah objek, tahan objek itu di bawah bidikan sampai pemindaian selesai. Pemindai yang terpasang menentukan lamanya, dari beberapa detik dengan model dasar hingga kurang dari dua detik dengan yang terbaik. Target berikutnya berganti-ganti di antara objek di sekitar tanpa harus membidiknya. Stasiun, gerbang lompat, dan bintang yang menandai planet lain terkunci dengan sekali tekan. Fungsi Tembak bergantung pada objek yang terkunci: pada kapal ia menembak, pada stasiun ia berlabuh, pada gerbang ia melompat, pada bintang ia terbang ke planet itu, dan pada asteroid ia mulai menambang. Pemindai yang lebih baik juga menampilkan muatan kapal yang terkunci.", false],
		[0, "Penanda dan radar", "Kapal ditandai dengan bingkai di layar, dan panah di tepi layar menunjuk ke target, stasiun, dan ancaman terdekat yang berada di luar pandangan. Musuh ditandai merah, kawan hijau, kapal netral kuning, dan titik misi biru; opsi Warna ramah buta warna di Options, Antarmuka menggantinya menjadi musuh jingga dan kawan biru. Kapal yang dekat dengan Anda menampilkan dua bilah kecil di samping bingkainya: lambungnya dan, berwarna biru, energi EMP-nya. Tampilan terbang Diperluas menambahkan pelat dengan angka pasti dan layar radar bundar; tampilan Asli mempertahankan panel sudut milik game itu sendiri.", false],
		[0, "Melihat sekeliling", "Pandangan belakang memutar kamera untuk melihat ke belakang kapal. Jika turet terpasang, tombol yang sama beralih ke tampilan turet: kapal mempertahankan arahnya sementara Anda memutar turet dan menembakkannya. Anda juga dapat melihat sekeliling kapal tanpa mengemudi dengan menahan Alt dan menggerakkan mouse, dengan stik kanan gamepad, atau dengan menyeret jari di area layar yang kosong.", false],
		[0, "Selubung", "Perangkat selubung menyembunyikan kapal Anda dari kapal lain selama durasinya, dan siapa pun yang memburu Anda langsung kehilangan jejak. Tekan tombol Perangkat selubung lagi untuk mematikannya lebih awal. Setelah dipakai, perangkat itu perlu waktu isi ulang sebelum dapat bekerja lagi.", false],
		[0, "Berlabuh dan bepergian", "Kunci stasiun dan tekan Tembak, atau terbang saja masuk ke dalamnya, untuk berlabuh. Stasiun lain di sistem tampak sebagai bintang terang; kunci salah satunya dan tekan Tembak untuk terbang ke planet itu. Sebagian besar sistem memiliki gerbang lompat di dekat salah satu stasiunnya untuk bepergian ke sistem lain; lihat [[guide/navigation]]. Selama pertempuran pekerjaan lepas berlangsung di sebuah stasiun, Anda tidak dapat berlabuh, bepergian, atau melompat pergi sampai pertempuran itu dimenangkan atau kalah.", false],
	],
	"guide/help": [
		[0, "Keyboard", "Berikut tombol bawaannya. Semua aksi terbang dapat diatur ulang di Options, Kontrol, Keyboard, tempat Pulihkan tombol bawaan membatalkan perubahan.", false],
		[0, "", "Belok kiri / Belok kanan: panah Kiri dan Kanan, atau A dan D.", true],
		[0, "", "Hidung naik / Hidung turun: panah Atas dan Bawah.", true],
		[0, "", "Tambah dorongan / Kurangi dorongan: W dan S.", true],
		[0, "", "Tembak / pakai: Spasi atau Ctrl. Menembakkan senjata, atau berlabuh, melompat, bepergian, atau menambang saat stasiun, gerbang, bintang, atau asteroid terkunci.", true],
		[0, "", "Senjata sekunder: E.", true],
		[0, "", "Booster: Shift.", true],
		[0, "", "Autopilot: Q. Daftar autopilot: R. Dengan Tahan autopilot untuk daftar dinyalakan, menahan Q selama setengah detik membuka daftar.", true],
		[0, "", "Target berikutnya: Tab.", true],
		[0, "", "Tembak otomatis: F.", true],
		[0, "", "Pandangan belakang: C. Dengan turet terpasang, tombol ini beralih ke tampilan turet.", true],
		[0, "", "Aksi / mesin lompat: M. Membuka menu Aksi: pilihan senjata sekunder, selubung, perintah untuk pilot pendamping, dan mesin lompat.", true],
		[0, "", "Peta rute: N.", true],
		[0, "", "Perangkat selubung: V.", true],
		[0, "", "Kecepatan waktu: T.", true],
		[0, "", "Mode foto: P. Membekukan penerbangan dan menyembunyikan antarmuka; seret atau gunakan tombol panah untuk memutar kamera, dan roda atau + dan - untuk memperbesar.", true],
		[0, "", "Menu jeda: Escape. F11 beralih ke layar penuh di sistem desktop.", true],
		[0, "", "Di menu, tombol panah berpindah antarentri, Enter memilih, dan Escape kembali.", true],
		[0, "Mouse", "Dengan Kemudi mouse dinyalakan, menggerakkan mouse akan mengemudikan kapal. Selama terbang, penunjuk dikunci, sehingga kapal berbelok saat Anda menggerakkannya; Kunci penunjuk saat terbang dapat dimatikan, dan menu serta jeda selalu melepaskan penunjuk. Tombol kiri menembak, tombol kanan meluncurkan senjata sekunder, dan menahan Alt sambil menggerakkan mouse akan melihat sekeliling kapal. Selama mouse mengemudi, tombol kiri dan kanan menggeser kapal ke samping; Tombol kiri / kanan di Options, Kontrol dapat membuatnya selalu menggeser atau selalu berbelok. Sensitivitas mouse menentukan seberapa jauh kapal berbelok untuk setiap gerakan.", false],
		[0, "Gamepad", "Stik kiri mengemudi dan stik kanan melihat sekeliling kapal. RT atau RB menembak, LB meluncurkan senjata sekunder, A melakukan boost, Y menyalakan atau mematikan autopilot, X memilih target berikutnya, menekan stik kanan memberi pandangan belakang atau tampilan turet, Back membuka menu Aksi, dan Start menjeda. Di menu, D-pad berpindah, A memilih, dan B kembali. Options, Kontrol, Gamepad mengatur zona mati stik dan getaran.", false],
		[0, "Sentuh", "Di layar sentuh, kontrol muncul di layar saat Kontrol sentuh diatur ke Otomatis atau Nyala. Stik di satu sisi digunakan untuk mengemudi; secara bawaan stik itu muncul di bawah ibu jari Anda di mana pun ibu jari menyentuh sisi itu, dan Stik tetap di tempat membuatnya diam di tempat. Kemudi dari mana saja memungkinkan jari di bagian layar mana pun yang kosong untuk mengemudi. Tombol di sisi lainnya meliputi Tembak / pakai, Sekunder, Boost, Autopilot, Target, Pandangan belakang, Aksi, Jeda, dan, selama pesan radio, Radio berikutnya. Sebuah penggeser mengatur dorongan, dan tombol Lebih cepat mempercepat waktu.", false],
		[0, "", "Ketuk Tembak dua kali dengan cepat untuk menyalakan tembakan otomatis; satu ketukan menghentikannya. Menyeret jari di area layar yang kosong akan melihat sekeliling kapal, dan melepaskannya kembali melihat ke depan. Tata letak kidal menukar sisinya, Ukuran kontrol sentuh mengatur skala kontrol, dan Atur penempatan kontrol memungkinkan Anda memindahkan masing-masing kontrol. Ponsel dan tablet juga dapat mengemudi dengan memiringkan perangkat: nyalakan Kemudi dengan memiringkan, pegang perangkat seperti saat bermain, lalu kalibrasi.", false],
		[0, "Options", "Options dapat dibuka dari layar judul, menu jeda, dan Game Options di stasiun. Options memiliki lima halaman. Audio mengatur volume musik dan suara. Tampilan mencakup jendela, laju bingkai, rasio aspek, serta preset dan detail grafis. Kontrol mencakup kemudi, mouse, gamepad, sentuh, dan pengaturan tombol keyboard. Antarmuka mencakup ukuran antarmuka, tampilan terbang Asli atau Diperluas, ukuran dan keburaman HUD, jendela bantuan, urutan peluncuran dan masuk stasiun, layar radar, label, ukuran teks, serta pengaturan aksesibilitas seperti warna ramah buta warna, pengurangan kedipan, guncangan layar, dan durasi pesan. Game mengatur bahasa mesin dan memungkinkan Anda mengimpor berkas game lain atau mengelola mod.", false],
		[0, "Help", "Help, yang dapat dibuka dari tempat yang sama, menampilkan topik bantuan dan kiat pemuatan milik game, daftar pengaturan tombol saat ini, dan tabel yang menerjemahkan tombol ponsel yang disebut dalam teks game menjadi tombol keyboard, tombol gamepad, dan kontrol sentuh yang digunakan di sini.", false],
	],
	"guide/jobs": [
		[0, "Mencari pekerjaan", "Pekerjaan lepas ditawarkan oleh para tamu di Lounge Luar Angkasa. Seorang klien menjelaskan pekerjaan dan bayarannya. Sebelum menerima pekerjaan di tempat lain, Anda dapat menanyakan lokasinya dan seberapa sulit pekerjaan itu; Anda juga dapat meminta tawarannya diulang atau menolaknya. Anda hanya dapat memegang satu pekerjaan dalam satu waktu, dan layar Missions menampilkannya beserta tujuannya dan berapa lompatan gerbang jauhnya.", false],
		[0, "Jenis pekerjaan", "Ada tiga belas jenis. Sampai [[step/16]], dan dalam salinan game tanpa kampanye lengkap, hanya lima yang ditawarkan: [[job/11]], [[job/0]], [[job/7]], [[job/4]], dan [[job/12]]. Sesudahnya seluruh jenis muncul: [[job/1]], [[job/2]], [[job/3]], [[job/5]], [[job/6]], [[job/9]], dan [[job/10]], serta pembeli yang menginginkan barang ([[job/8]]).", false],
		[0, "Kesulitan dan imbalan", "Pekerjaan awal memiliki tingkat kesulitan satu atau dua; yang belakangan hingga sembilan. Imbalan dasar sebuah pekerjaan adalah 1.500 kredit ditambah hingga 5.500 lagi sesuai kesulitan. Angka ini kemudian dinaikkan menurut jarak ke tujuan (berlipat dua pada 1.200 km), dan ditambah 200 kredit per tingkat pilot. Pembersihan sampah dibayar 30 persen lebih rendah, pengawalan 20 persen lebih tinggi, pemulihan barang dan penyelamatan dibayar dua kali lipat, dan pekerjaan penumpang membayar dasar yang lebih kecil ditambah bagian untuk setiap penumpang. Imbalan dibulatkan ke kelipatan lima puluh kredit.", false],
		[0, "Menjalankan pekerjaan", "Pekerjaan kurir dan penumpang diselesaikan dengan berlabuh di tujuan sambil membawa kiriman atau penumpangnya. Pekerjaan pembelian diselesaikan dengan berlabuh kembali di stasiun pembeli dengan barang di ruang kargo. Semua pekerjaan lainnya berupa pertempuran di stasiun tujuan, yang disiapkan saat Anda tiba di sana; selama pertempuran berlangsung, Anda tidak dapat berlabuh, bepergian, atau melompat pergi. Kontainer dan sandera yang diselamatkan kemudian harus dibawa kembali ke stasiun tempat Anda mengambil pekerjaan itu. Saat pekerjaan selesai, imbalan langsung dibayar, reputasi Anda di mata ras klien meningkat, dan pekerjaan itu dihitung untuk [[medal/16]].", false],
		[0, "Kegagalan", "Pertempuran gagal jika syaratnya tidak terpenuhi: semua kapal yang Anda lindungi hancur, kontainer hilang, waktu habis, atau saingan Anda menembak lebih banyak. Pekerjaan yang gagal dibatalkan tanpa bayaran. Anda juga dapat meninggalkan pekerjaan dari layar Missions; kiriman yang dibawa akan diambil kembali. Jika kapal Anda hancur, Anda melanjutkan dari simpanan otomatis terakhir.", false],
	],
	"guide/lounge": [
		[0, "Tamu", "Setiap stasiun memiliki Lounge Luar Angkasa, yang terbuka mulai [[step/13]]. Tiga sampai lima tamu duduk di sana, dan mereka berganti setiap kali Anda berlabuh. Sebagian besar berasal dari ras penguasa sistem, tetapi sebagian datang dari mana saja. Bicaralah dengan seorang tamu untuk mengetahui keinginannya; setiap jawaban dan keputusan dihitung untuk salah satu medali percakapan.", false],
		[0, "Jawaban", "OK menerima tawaran, No, thanks menolaknya, dan How was that again? mengulanginya. Untuk pekerjaan di tempat lain Anda dapat bertanya Can you show it on the map? untuk mengetahui tujuannya dan Will it be difficult? untuk mendengar seberapa sulit pekerjaannya. Pedagang mempersilakan Anda melihat barangnya terlebih dahulu. Menolak tawaran, meminta pengulangan, dan menerima tanpa bertanya masing-masing dihitung untuk [[medal/32]], [[medal/33]], [[medal/34]], dan [[medal/35]]; berbicara dengan tamu yang memiliki tawaran dihitung untuk [[medal/26]].", false],
		[0, "Klien dan tukang ngobrol", "Banyak tamu menawarkan pekerjaan lepas; lihat [[guide/jobs]]. Yang lain hanya mengobrol dan menyampaikan desas-desus, yang kadang menyebut stasiun atau bijih yang patut diketahui.", false],
		[0, "Pedagang dan pembeli", "Pedagang menjual satu lot saja: sebuah perlengkapan atau beberapa unit komoditas, dengan harga antara 40 hingga 160 persen dari harga biasanya. Mulai [[step/16]], pembeli juga muncul, meminta sejumlah barang dibawa ke stasiun yang sama; lihat [[job/8]].", false],
		[0, "Pilot sewaan", "Mulai [[step/16]], satu tamu di setiap lounge dapat menawarkan pilot pendamping: satu sampai tiga pilot dengan bayaran 700 hingga 1.999 kredit per pilot, untuk sepuluh menit penerbangan. Pilot [[faction/1]] tidak pernah dapat disewa. Anda hanya dapat memiliki satu kelompok dalam satu waktu. Pilot yang memiliki semua medali justru mendapatkan pengagum, yang membayar untuk ikut terbang.", false],
		[0, "Agen", "Setelah cerita melewati [[step/16]], agen-agen bernama menunggu di stasiun tertentu dan masing-masing membuat satu kesepakatan. Kebanyakan menjual cetak biru; empat menjual koordinat sistem tersembunyi, yang kemudian muncul di peta. Setiap agen pergi setelah kesepakatan. Para agen tercantum di halaman mereka masing-masing.", false],
		[0, "Diplomat", "Ketika salah satu dari empat ras besar telah menjadi bermusuhan, salah satu diplomatnya duduk di setiap lounge. Dengan bayaran yang makin besar seiring jatuhnya reputasi Anda, hingga 16.000 kredit, diplomat itu mengembalikan skala reputasi tersebut ke nol.", false],
	],
	"guide/medals": [
		[0, "Tingkatan", "Sebagian besar medali memiliki tiga tingkatan: perunggu, perak, dan emas. Setiap tingkatan memiliki targetnya sendiri, dan mencapai tingkatan yang lebih tinggi menggantikan medali yang lebih rendah. Beberapa medali hanya memiliki satu tingkatan. Halaman medali menampilkan target untuk setiap tingkatan.", false],
		[0, "Kapan medali diberikan", "Catatan Anda diperiksa saat Anda mendekati stasiun, sebelum dok memperbaiki kapal Anda, dan medali baru atau yang naik tingkat diumumkan setelah Anda berlabuh. Tidak ada yang diberikan selama terbang, jadi target yang dicapai di luar angkasa baru dihitung pada saat berlabuh berikutnya. Layar Status mencantumkan setiap medali yang Anda miliki, tingkatannya, dan alasan pemberiannya.", false],
		[0, "Yang pertama dan yang terakhir", "[[medal/0]] sudah dimiliki sejak awal permainan. [[medal/36]] diberikan secara otomatis setelah semua medali lain dimiliki.", false],
		[0, "Hadiah", "Memiliki semua medali mengubah cara pilot di Lounge Luar Angkasa memperlakukan Anda: para pengagum membayar Anda untuk ikut terbang sebagai pilot pendamping, alih-alih menarik bayaran. Memiliki semua medali dalam tingkat emas membuat Anda ditawari [[ship/8]], purwarupa yang dijual di stasiun [[station/10]]. Di layar Status, [[character/0]] memakai kacamata gelap setelah memiliki semua medali, dan kacamata emas setelah semua medali berwarna emas.", false],
	],
	"guide/mining": [
		[0, "Asteroid", "Ruang di sekitar setiap stasiun berisi asteroid di dua ladang: satu dekat stasiun dan satu lagi lebih jauh, yang dapat Anda tuju melalui daftar Autopilot. Bijih yang ada di sebuah ladang bergantung pada seberapa dekat sistem itu dengan sistem asal tiap bijih, sehingga tidak semua bijih dapat ditemukan di mana-mana. Asteroid juga dapat ditembak hingga hancur; kadang ini menyisakan sedikit bijih yang melayang bebas, dan asteroid yang dihancurkan dihitung untuk [[medal/29]].", false],
		[0, "Mulai menambang", "Menambang membutuhkan laser tambang dan ruang kosong di ruang kargo. Kunci sebuah asteroid dengan menahannya di bawah bidikan, lalu tekan Tembak. Kapal terbang mendekati batu itu dan bor mulai bekerja; kemudi terkunci sampai Anda selesai. HUD menampilkan bijih dan kelas asteroid setelah terkunci.", false],
		[0, "Bor", "Sebuah pengukur menampilkan lapisan batuan asteroid yang bertumpuk, masing-masing lebih sempit daripada lapisan sebelumnya. Bor bergeser ke satu sisi dan berganti arah secara acak setiap setengah detik hingga dua setengah detik. Kemudikan ke kiri dan ke kanan untuk menjaganya tetap di area hijau lapisan saat ini. Lapisan pertama membutuhkan enam detik pengeboran, dan setiap lapisan yang lebih dalam membutuhkan waktu sekitar seperenam lebih singkat daripada sebelumnya. Bijih terus bertambah selama Anda tetap di area hijau, dan lebih cepat di lapisan yang lebih dalam.", false],
		[0, "Zona merah", "Waktu yang dihabiskan di luar area hijau dihitung sebagai kerusakan, dan zona merah pada pengukur pun melebar. Setelah total dua setengah detik di zona merah, asteroid pecah dan semua hasil pengeboran darinya hilang. Tekan Tembak kapan saja untuk berhenti dan menyimpan bijih yang sudah terkumpul. Setiap asteroid hanya dapat ditambang sekali.", false],
		[0, "Kelas dan inti", "Asteroid yang lebih besar memiliki lebih banyak lapisan, dari dua sampai tujuh. Yang terbesar, kelas A, memiliki ketujuh lapisan, dan menembus semuanya menghasilkan sebuah inti selain bijih. Inti jauh lebih berharga daripada bijih dan dihitung untuk [[medal/3]] dan [[medal/7]]. Bijih dihitung untuk [[medal/2]] dan [[medal/6]].", false],
		[0, "Laser tambang", "Laser tambang memiliki dua angka. Hasilnya membuat bor bergeser lebih lambat dan dapat dikemudikan lebih halus, sehingga lebih mudah tetap di area hijau. Kecepatannya menaikkan laju bertambahnya bijih. Laser-laser itu berkisar dari [[item/86]] hingga [[item/89]]; [[item/90]] dibuat dari cetak biru.", false],
		[0, "Kargo", "Bijih dan inti langsung masuk ke ruang kargo, dan Anda hanya menyimpan sebanyak ruang yang tersedia. Saat ruang kargo penuh, HUD memberitahukannya dan Anda harus menjual atau membongkar muatan di stasiun. Unit kompresi kargo memperbesar ruang kargo sebesar bagian tertentu dari kapasitas lambung, dan beberapa unit dapat dipasang sekaligus. Lambung yang lebih besar paling membantu.", false],
	],
	"guide/navigation": [
		[0, "Peta galaksi", "Bagian Peta di stasiun, dan tombol Peta rute saat terbang, menampilkan galaksi: setiap sistem yang dikenal di tempatnya, sambungan gerbang di antaranya, ras yang berkuasa, dan tingkat keamanan sistem. Memilih sebuah sistem akan memperbesarnya dan menampilkan stasiun-stasiunnya; memilih sebuah stasiun di sana menjadikannya tujuan Anda. Peta juga menampilkan jarak ke sebuah sistem dalam kilometer, menandai stasiun yang pernah Anda kunjungi, dan menunjukkan di mana cerita dan pekerjaan Anda saat ini berlanjut. Kotak pencarian menemukan stasiun yang dikenal berdasarkan nama. Halaman [[chart]] mencantumkan semua sistem.", false],
		[0, "", "Di awal cerita Anda tertahan di orbit stasiun pertama. Peta terbuka di [[step/9]], dan sesudahnya Anda dapat terbang ke planet-planet lain di sistem itu.", false],
		[0, "Sistem dan keamanan", "Setiap sistem dikuasai salah satu dari empat ras besar dan memiliki peringkat keamanan: Aman, Sedang, Berisiko, atau Berbahaya. Serangan bajak laut dan musuh jauh lebih sering terjadi di sistem berbahaya, sedangkan sistem aman umumnya tenang. Sebagian besar sistem memiliki beberapa stasiun, masing-masing mengorbit planetnya sendiri, dengan toko, lounge, dan Tec Level sendiri.", false],
		[0, "Gerbang lompat", "Perjalanan antarsistem melewati gerbang lompat. Sebuah sistem memiliki paling banyak satu gerbang, yang terletak di ruang salah satu stasiunnya, dan hanya terhubung ke sistem-sistem tetangga. Untuk melompat, pilih tujuan di sistem tetangga pada Peta, terbanglah ke gerbang (autopilot akan membawa Anda), kunci gerbang itu, lalu tekan Tembak setelah berada di dalam zonanya. Perjalanan yang lebih jauh ditempuh satu gerbang demi satu gerbang; layar Missions menunjukkan berapa lompatan gerbang yang diperlukan menuju suatu tujuan melalui sistem-sistem yang Anda kenal.", false],
		[0, "Sistem tersembunyi", "Lima sistem awalnya tidak ada di peta: [[system/0]], [[system/1]], [[system/6]], [[system/10]], dan [[system/21]]. Sistem tersembunyi muncul setelah Anda pernah ke sana atau membeli koordinatnya. Empat agen di Lounge Luar Angkasa menjualnya: [[agent/12]] untuk [[system/0]], [[agent/13]] untuk [[system/1]], [[agent/14]] untuk [[system/10]], dan [[agent/15]] untuk [[system/21]]. Agen bernama baru muncul setelah cerita melewati [[step/16]]. [[system/10]] sama sekali tidak memiliki sambungan gerbang dan hanya dapat dicapai dengan mesin lompat.", false],
		[23, "", "Jalan menuju [[system/6]] diberikan oleh cerita di [[step/22]].", false],
		[0, "Mesin lompat", "Mesin lompat membawa kapal langsung ke sebuah stasiun di sistem mana pun yang dikenal, tanpa gerbang. Satu-satunya adalah [[item/85]], yang tidak pernah dijual di toko dan harus dibuat dari cetak birunya. Gunakan melalui menu Aksi saat terbang. Lompatan tidak memerlukan bahan bakar maupun biaya. Mesin ini tidak dapat dipakai selama pertempuran pekerjaan lepas berlangsung di stasiun Anda, meskipun pekerjaan kurir dan penumpang tidak menghalanginya.", false],
		[34, "", "Cerita memberi Anda cetak biru [[item/85]] di [[step/34]], dengan sebagian bahannya sudah diserahkan.", false],
		[0, "Jarak", "Jarak antarsistem dinyatakan dalam kilometer, diukur dari letak sistem-sistem di peta. Jarak penting untuk perdagangan, karena harga naik seiring jarak dari asal sebuah barang, dan untuk pekerjaan lepas, yang imbalannya bertambah seiring jarak ke tujuan.", false],
	],
	"guide/tips": [
		[0, "", "Baca halaman sebuah barang sebelum perjalanan dagang: halaman itu menyebutkan sistem tempat barang paling murah dan arah harganya makin mahal.", true],
		[0, "", "Stasiun membeli dan menjual dengan harga yang sama, jadi muatan baru menghasilkan uang setelah dibawa menjauh dari asalnya.", true],
		[0, "", "Saat menambang, tanggapi setiap perubahan arah geser secepatnya. Waktu di zona merah terakumulasi sepanjang pengeboran, jadi tergelincir sebentar beberapa kali sama mahalnya dengan sekali tergelincir lama.", true],
		[0, "", "Jika bor sudah lama berada di zona merah, hentikan dengan Tembak dan simpan yang sudah didapat daripada kehilangan seluruh hasil.", true],
		[0, "", "Carilah asteroid terbesar jika Anda menginginkan inti: hanya batu kelas A yang memilikinya, dan hanya jika Anda menembus ketujuh lapisannya.", true],
		[0, "", "Pasang sinar traktor sejak awal. Tanpanya, muatan bangkai dan kapal yang lumpuh sama sekali tidak dapat dikumpulkan.", true],
		[0, "", "Pemindai yang lebih baik sepadan harganya dalam pertempuran: ia mengunci target lebih cepat, dan yang terbaik menampilkan muatan sebuah kapal sebelum Anda menyerangnya.", true],
		[0, "", "Berlabuh memperbaiki kapal Anda secara gratis, jadi ada baiknya singgah di stasiun di sela pertempuran daripada terus maju dengan lambung rusak.", true],
		[0, "", "Berlabuhlah secara teratur dalam perjalanan panjang. Hanya berlabuh yang tuntas yang membuat simpanan otomatis, dan kapal yang hancur mengembalikan Anda ke simpanan terakhir.", true],
		[0, "", "Perhatikan reputasi Anda di layar Status. Tembakan nyasar ke kapal setempat terus bertambah, dan seluruh ras dapat berbalik memusuhi Anda.", true],
		[0, "", "Tanyakan kepada klien di mana pekerjaannya dan seberapa sulit sebelum Anda menerimanya, kecuali Anda sedang mengumpulkan medali karena tidak bertanya.", true],
		[0, "", "Kosongkan ruang kargo sebelum menerima pekerjaan kurir, dan pasang kabin sebelum pekerjaan penumpang: keduanya tidak dapat diterima tanpa ruang yang cukup.", true],
		[0, "", "Untuk pekerjaan pemulihan barang dan penyelamatan, bawalah senjata EMP, pemindai yang menampilkan muatan, sinar traktor, dan sedikit ruang kargo kosong.", true],
		[0, "", "Bawa semua bahan sebuah cetak biru ke stasiun tempat Anda memulainya, maka Anda terhindar dari biaya pengiriman.", true],
		[0, "", "Sewa pilot pendamping tepat sebelum pertempuran sulit: kontrak mereka hanya berjalan mundur selama Anda terbang.", true],
	],
	"guide/trading": [
		[0, "Cara harga ditentukan", "Setiap barang memiliki harga terendah dan tertinggi serta sistem asal. Di sistem asalnya barang dijual dengan harga terendah; makin jauh sebuah stasiun dari asal, makin tinggi harganya, hingga mencapai harga tertinggi pada jarak tertentu. Selain itu, setiap stasiun menambahkan variasi tetapnya sendiri hingga sekitar lima persen ke atas atau ke bawah. Halaman barang menunjukkan di mana sebuah barang paling murah dan ke arah mana harganya makin mahal.", false],
		[0, "Membeli dan menjual", "Stasiun membeli dengan harga yang sama dengan harga jualnya, jadi keuntungan hanya datang dari memindahkan barang: beli di dekat asal barang dan jual jauh darinya. Barang yang Anda jual ditambahkan ke rak stasiun. Shop juga mengingat harga terendah dan tertinggi yang pernah Anda lihat untuk setiap barang, beserta sistemnya, dan menampilkannya di samping barang tersebut. Sebagian muatan tidak dapat dijual, seperti kiriman kurir dan kontainer yang Anda bawa untuk klien.", false],
		[0, "Isi toko", "Setiap stasiun memiliki Tec Level. Raknya berisi barang dengan tingkat tersebut atau di bawahnya; stasiun bertingkat empat ke atas tidak menyediakan barang di bawah separuh tingkatnya sendiri. Setiap barang juga memiliki peluang untuk ada di rak tertentu, sehingga isi rak berbeda dari kunjungan ke kunjungan. Beberapa barang selalu ada di rak stasiun tertentu. Sebagian barang hanya dijual di sistem [[faction/1]], dan produk cetak biru sama sekali tidak pernah dijual.", false],
		[0, "", "Komoditas tersedia dalam jumlah lebih banyak, dan jauh lebih banyak di dekat asalnya. Senjata dan perlengkapan biasanya tersedia satu sampai tiga buah, sedangkan roket, torpedo, dan bom tersedia dalam jumlah lebih besar. Rak diisi ulang setiap kali Anda berlabuh, kecuali di tiga stasiun terakhir yang Anda kunjungi, yang raknya tetap seperti saat Anda tinggalkan.", false],
		[0, "Minuman keras", "Setiap sistem memiliki minuman khasnya sendiri yang hanya dijual di sistem itu, seperti [[item/132]] di [[system/0]] atau [[item/146]] di [[system/14]]. Minuman adalah barang dagangan biasa. Membelinya dari toko dihitung untuk [[medal/8]]; memiliki berbagai jenis yang dibeli dari pedagang Lounge atau diambil dari bangkai kapal dihitung untuk [[medal/9]].", false],
		[0, "Sumber lain", "Pedagang di Lounge Luar Angkasa menawarkan satu lot dengan harga antara 40 hingga 160 persen dari harga biasa, jadi tawaran mereka layak dibandingkan. Kapal membawa muatan yang dapat diambil dengan sinar traktor saat kapal itu hancur atau lumpuh, dan bijih dapat ditambang. Pembeli di Lounge meminta sejumlah barang tertentu dan membayarnya jauh di atas nilainya; lihat [[job/8]].", false],
	],
	"home": [
		[0, "", "Rujukan ini membahas Galaxy on Fire 2, permainan luar angkasa tentang perdagangan, penambangan, pertempuran, dan penjelajahan. Anda terbang sebagai [[character/0]], pilot veteran yang terdampar jauh dari rumah, melintasi 22 sistem bintang yang dikuasai manusia dan ras-ras alien. Di sela misi cerita Anda dapat mengambil pekerjaan lepas, menambang asteroid, memperdagangkan barang, membuat perlengkapan dari cetak biru, dan membeli kapal yang makin baik.", false],
		[0, "", "Halaman-halaman ini disusun dari game yang Anda impor. Nama, angka, harga, dan dialog berasal dari game itu, sedangkan penjelasan di sampingnya ditulis khusus untuk rujukan ini. Detail cerita yang melampaui titik simpanan Anda tetap tersembunyi sampai Anda mencapainya. Tempat yang baik untuk memulai adalah [[world/galaxy]], [[chart]], dan [[guide/basics]].", false],
	],
	"intro/agents": [
		[0, "", "Agen adalah pedagang yang duduk di lounge luar angkasa tertentu dan menjual sesuatu yang tidak bisa dibeli di toko: cetak biru langka atau koordinat sistem tersembunyi. Mereka muncul mulai [[step/17]], dan masing-masing hanya menjual sekali. Bicaralah dengan mereka di lounge stasiun mereka untuk melihat tawarannya; lihat [[guide/lounge]].", false],
	],
	"intro/blueprints": [
		[0, "", "Barang cetak biru tidak pernah dijual di toko. Masing-masing dibuat dari resep berupa sejumlah barang setelah Anda memiliki cetak birunya, yang biasanya dibeli dari agen di Lounge Luar Angkasa. Cara kerja produksi dijelaskan di [[guide/blueprints]].", false],
	],
	"intro/characters": [
		[0, "", "Inilah orang-orang yang ditemui [[character/0]] dalam perjalanannya: pedagang, perwira, ilmuwan, dan kenalan yang lebih ganjil. Setiap biografi bertambah seiring cerita berjalan, jadi Anda hanya mengetahui tentang seorang karakter sebanyak yang telah diketahui Keith sendiri.", false],
	],
	"intro/equipment": [
		[0, "", "Perlengkapan mengisi slot perlengkapan kapal: perisai dan pelat zirah untuk perlindungan, kompresor kargo, sinar traktor untuk mengumpulkan kontainer, booster, nosel kemudi, pemindai, laser tambang, kabin penumpang, selubung, robot perbaikan, dan mesin lompat. Setiap perlengkapan menempati satu slot, jadi jumlah slot membatasi seberapa lengkap sebuah kapal. Harga berbeda menurut sistem, dan toko hanya menyediakan barang hingga tingkat teknologi stasiunnya. Beberapa perlengkapan terbaik dibuat dari cetak biru, dan beberapa dibuat oleh bangsa [[faction/1|Vossk]] dan hanya dijual di sistem mereka.", false],
	],
	"intro/factions": [
		[0, "", "Sepuluh faksi muncul dalam permainan. Empat di antaranya memiliki sistem dan stasiun: bangsa Terran, Vossk, Nivelian, dan Midorian. Faksi lainnya tidak memiliki wilayah dan hanya Anda temui sebagai individu atau sebagai musuh. Reputasi Anda di mata empat kekuatan besar itu dicatat pada dua skala, Terran lawan Vossk dan Nivelian lawan Midorian; lihat [[world/galaxy]].", false],
	],
	"intro/goods": [
		[0, "", "Barang adalah segala sesuatu yang diangkut di ruang kargo untuk diperdagangkan. Komoditas dan minuman dibeli murah di satu sistem dan dijual mahal di sistem lain (lihat [[guide/trading]]); setiap sistem memiliki minuman khasnya sendiri. Bijih dibor dari asteroid, dan menembus semua lapisan asteroid kelas A menghasilkan inti yang jauh lebih berharga (lihat [[guide/mining]]). Komoditas, bijih, dan inti juga menjadi bahan untuk membuat barang dari cetak biru. Beberapa barang, seperti [[item/116]] dan [[item/131]], hanya muncul melalui pekerjaan atau cerita dan tidak dapat dibeli.", false],
	],
	"intro/guide": [
		[0, "", "Halaman-halaman ini menjelaskan cara bermain: terbang dan bertempur, menambang dan berdagang, layar stasiun, pekerjaan lepas, produksi, dan medali. Angka yang disebut di sini mengikuti aturan mesin game; tabel di halaman barang, kapal, dan medali berasal dari data game Anda sendiri. Mulailah dengan [[guide/basics]] dan [[guide/help]].", false],
	],
	"intro/jobs": [
		[0, "", "Pekerjaan lepas adalah pekerjaan sampingan yang ditawarkan klien di Lounge Luar Angkasa, mulai dari mengangkut kiriman hingga memburu penjahat buronan. Pekerjaan ini menghasilkan kredit, reputasi di mata ras klien, dan pengalaman. Ada tiga belas jenis; cara penawaran dan pembayarannya dijelaskan di [[guide/jobs]].", false],
	],
	"intro/medals": [
		[0, "", "Medali menghargai catatan seorang pilot: bertempur, menambang, berdagang, bepergian, bahkan cara Anda berbicara dengan orang di Lounge Luar Angkasa. Sebagian besar memiliki tingkatan perunggu, perak, dan emas. Medali diperiksa setiap kali Anda berlabuh; lihat [[guide/medals]].", false],
	],
	"intro/ships": [
		[0, "", "Kapal berbeda dalam zirah, ruang kargo, kelincahan, dan jumlah slot yang ditawarkan: slot primer untuk senjata yang menghadap ke depan, slot sekunder untuk roket, torpedo, dan bom, slot turet opsional, dan slot perlengkapan untuk semua yang lain. Harganya naik tajam, dari di bawah 20.000 kredit untuk lambung terkecil hingga beberapa juta untuk pesawat tempur terbaik. Pedagang di luar sistem [[faction/1|Vossk]] menampilkan hingga lima lambung setiap kunjungan; pedagang [[faction/1|Vossk]] hanya menjual [[ship/9]]. Pedagang memotong harga daftar sebesar tingkat teknologi stasiunnya dalam persen dan membayar empat perlima dari harga daftar untuk lambung lama Anda. [[ship/0]] dan [[ship/10]] tidak pernah dijual. Lihat [[guide/fitting]] tentang cara memperlengkapi kapal.", false],
	],
	"intro/stations": [
		[0, "", "Setiap stasiun memiliki toko, hanggar, pedagang kapal, dan lounge luar angkasa. Tingkat teknologinya, dari 1 sampai 10, menentukan seberapa canggih barang dan perlengkapan di raknya, dan pedagangnya memotong harga daftar kapal sebanyak itu pula dalam persen. Persediaan berubah dari kunjungan ke kunjungan. Stasiun yang disebut dalam cerita atau menampung seorang agen memiliki deskripsi singkat di sini.", false],
	],
	"intro/story": [
		[0, "", "Cerita ini mengikuti [[character/0]], seorang pilot Terran yang perburuan bajak lautnya berakhir kacau, melalui 45 tahap. Setiap halaman tahap memuat tugasnya dan, setelah Anda menyelesaikannya, apa yang terjadi. Halaman hanya mengungkap sejauh yang telah dicapai simpanan Anda; [[world/history]] menceritakan kisah sejauh ini dalam satu tempat.", false],
	],
	"intro/systems": [
		[0, "", "Galaksi ini memiliki 22 sistem bintang. Masing-masing dimiliki satu faksi, memiliki peringkat keamanan yang menentukan seberapa sering perampok muncul, dan berisi hingga lima stasiun, salah satunya membawa gerbang lompat. Sambungan gerbang menentukan sistem mana saja yang dapat Anda tempuh; beberapa sistem tersembunyi atau sama sekali tidak memiliki sambungan. Lihat [[world/galaxy]] dan [[chart]].", false],
	],
	"intro/weapons": [
		[0, "", "Senjata terbagi menjadi dua kelompok. Senjata primer (laser, blaster, meriam otomatis, dan senjata termal) menembak tanpa amunisi dari slot depan; perbedaannya terletak pada kerusakan per tembakan, laju tembak, dan jangkauan. Senjata sekunder (roket, torpedo, bom EMP, dan nuklir) dibeli per buah dan ditembakkan dari slot sekunder. Turet membutuhkan slotnya sendiri dan dapat menembak ke segala arah. Beberapa senjata menguras energi kapal sebagai ganti, atau sekaligus, merusaknya; kapal yang kehabisan energi lumpuh untuk sementara. Beberapa senjata terbaik tidak pernah dijual di toko dan harus dibuat dari cetak biru (lihat [[guide/blueprints]]). Banyak model dibuat oleh bangsa [[faction/1|Vossk]] dan hanya tersedia di sistem mereka. Lihat [[guide/combat]] untuk taktik.", false],
	],
	"intro/world": [
		[0, "", "Halaman-halaman ini menggambarkan latar permainan: galaksi dan tata letaknya, sejarahnya, serta kekuatan-kekuatan yang membentuknya. Halaman ini melengkapi halaman sistem, stasiun, dan faksi dengan gambaran yang lebih luas.", false],
	],
	"item/0": [
		[0, "", "[[item/0]] adalah laser tingkat pemula: kerusakan 3 per tembakan setiap 0,4 dtk, dengan jangkauan 2.000 unit yang sama dengan semua laser awal. Ini laser terlemah dalam permainan, tetapi murah dan hampir setiap toko menyediakannya. [[item/1]] dan [[item/2]] mempertahankan laju tembak yang sama dan menambah kerusakan.", false],
		[6, "", "Laser ini salah satu dari tiga barang yang ditawarkan [[character/2]] secara cuma-cuma di hanggarnya di stasiun [[station/78]] sebelum penyerbuan sarang bajak laut, bersama [[item/22]] dan [[item/55]].", false],
	],
	"item/1": [
		[0, "", "[[item/1]] adalah tingkat kedua dari jajaran Nirai. Laser ini menembak secepat [[item/0]] (setiap 0,4 dtk) tetapi memberi kerusakan 5 per tembakan alih-alih 3, dengan jangkauan yang sama. Ini peningkatan murah sampai [[item/2]] terjangkau.", false],
	],
	"item/10": [
		[0, "", "[[item/10]] memberi kerusakan 34 setiap 1,4 dtk dengan jangkauan 2.600. Per tembakan lebih keras dan jangkauannya lebih jauh daripada [[item/9]], dengan laju tembak sedikit lebih lambat. Inilah laser terkuat yang dijual di toko.", false],
	],
	"item/11": [
		[0, "", "[[item/11]] adalah laser terkuat dalam permainan: kerusakan 45 setiap 1,5 dtk dengan jangkauan 2.600, tembakan tunggal terberat di antara semua senjata primer. Laser ini tidak pernah dijual dalam keadaan jadi. Cetak birunya berasal dari [[agent/0]] di stasiun [[station/3]], dan pembuatannya menghabiskan sebuah [[item/9]] beserta [[item/155]] dan beberapa komoditas.", false],
	],
	"item/116": [
		[0, "", "Secure container adalah kiriman tersegel yang hanya muncul melalui pekerjaan lepas. Menerima pekerjaan [[job/0]] memuat sejumlah kontainer yang disepakati ke ruang kargo Anda, tempat kontainer itu memakan ruang; kontainer tidak dapat dijual dan diserahkan di tujuan. Kontainer ini juga mewakili barang curian dalam pekerjaan [[job/3]], yang kapal pembawanya harus dilumpuhkan, bukan dihancurkan.", false],
	],
	"item/117": [
		[0, "", "Secure cabin adalah muatan khusus yang hanya muncul melalui pekerjaan lepas, yaitu dalam pekerjaan [[job/5]] yang meminta Anda membebaskan seorang tawanan dari salah satu dari beberapa kapal lalu membawanya kembali. Seperti [[item/116]], kabin ini tidak dapat dibeli atau dijual.", false],
	],
	"item/12": [
		[0, "", "[[item/12]] adalah blaster [[faction/1|Vossk]] dasar: kerusakan 11 setiap 0,6 dtk dengan jangkauan 1.500. Jangkauan blaster lebih pendek daripada laser, tetapi kerusakannya dari waktu ke waktu lebih besar; bahkan model pertama ini sedikit mengungguli laser Nirai terbaik. Blaster ini juga diperlukan untuk membuat [[item/15]]. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/13": [
		[0, "", "[[item/13]] adalah blaster [[faction/1|Vossk]] yang memberi kerusakan 12 setiap 0,5 dtk dengan jangkauan 1.500, peningkatan nyata dari [[item/12]] dalam laju tembak dan kerusakan. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/131": [
		[0, "", "[[item/131]] adalah puing pesawat tempur [[faction/9|Void]]. Setiap kapal [[faction/9|Void]] musuh yang dihancurkan menjatuhkan kontainer berisi satu sampai tiga buah, yang hanya dapat dikumpulkan dengan sinar traktor (lihat [[item/68]]). Harganya tetap 199 kredit, dan mengumpulkannya dihitung untuk medali [[medal/21]].", false],
		[24, "", "[[character/6]] membutuhkan sisa-sisa seperti ini untuk penelitiannya dan mengutus [[character/0]] mengumpulkannya di dekat stasiun [[station/48]].", false],
		[25, "", "Selama [[character/0]] membawanya pulang, sisa-sisa itu tidak dapat dijual.", false],
		[28, "", "Sisa-sisa itu diserahkan kepada tim [[character/6]] setibanya di stasiun [[station/10]].", false],
	],
	"item/14": [
		[0, "", "[[item/14]] adalah blaster [[faction/1|Vossk]] yang menembak setiap 0,4 dtk dengan kerusakan 10. Kerusakannya dari waktu ke waktu sedikit lebih besar daripada [[item/13]], tetapi jangkauannya yang 1.000 pendek, jadi cocok bagi pilot yang suka mendekati sasarannya. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/15": [
		[0, "", "[[item/15]] adalah blaster [[faction/1|Vossk]] terbaik: kerusakan 10 setiap 0,3 dtk dengan jangkauan 1.500. Blaster ini memadukan laju tembak blaster yang lebih cepat dengan jangkauan [[item/12]]. Blaster ini tidak pernah dijual dalam keadaan jadi. Cetak birunya berasal dari [[agent/1]] di stasiun [[station/8]], dan pembuatannya menghabiskan sebuah [[item/12]] dan sebuah [[item/166]] beserta beberapa komoditas.", false],
	],
	"item/154": [
		[0, "", "[[item/154]] adalah bijih biasa yang paling berharga. Ladang asteroid cenderung berisi bijih yang sistem asalnya berdekatan, dan asal bijih ini adalah [[system/9]], tempat harganya juga paling murah. Bijih ini dibutuhkan dalam jumlah banyak untuk membuat [[item/27]]. Mengebor tembus asteroid [[item/154]] kelas A menghasilkan [[item/165]].", false],
	],
	"item/155": [
		[0, "", "[[item/155]] adalah bijih berharga menengah yang sistem asalnya [[system/21]], tempat harganya paling murah. Bijih ini menjadi bahan [[item/11]] dan [[item/90]]. Intinya adalah [[item/166]].", false],
	],
	"item/156": [
		[0, "", "[[item/156]] adalah bijih termurah, berasal dari [[system/0]]. Nilainya yang rendah membuatnya kurang menguntungkan untuk dijual, tetapi bijih ini menjadi bahan pelat zirah [[item/59]]. Intinya adalah [[item/167]].", false],
	],
	"item/157": [
		[0, "", "[[item/157]] adalah bijih berharga menengah yang sistem asalnya [[system/7]]. Bersama intinya, [[item/168]], bijih ini dibutuhkan untuk membuat pelat zirah [[item/59]].", false],
	],
	"item/158": [
		[0, "", "[[item/158]] adalah bijih berharga menengah yang sistem asalnya [[system/4]]. Bijih ini salah satu yang dibutuhkan untuk [[item/85]]. Intinya adalah [[item/169]].", false],
	],
	"item/159": [
		[0, "", "[[item/159]] adalah bijih berharga menengah yang sistem asalnya [[system/18]]. Tidak ada cetak biru yang memakainya, jadi bijih ini ditambang hanya untuk dijual atau untuk medali bijih. Intinya adalah [[item/170]].", false],
	],
	"item/16": [
		[0, "", "[[item/16]] adalah blaster EMP pertama. Blaster ini tidak merusak lambung atau zirah; sebaliknya setiap tembakan menguras 3 poin energi kapal, dan kapal yang energinya mencapai nol lumpuh untuk sementara. Senjata EMP diperlukan saat sasaran harus dihentikan, bukan dihancurkan. Model ini menembak setiap 0,3 dtk tetapi jangkauannya hanya 1.200 unit. [[item/17]] dan [[item/18]] berjangkauan lebih jauh dan menguras lebih banyak per tembakan.", false],
	],
	"item/160": [
		[0, "", "[[item/160]] adalah bijih berharga rendah yang sistem asalnya [[system/13]]. Bijih ini salah satu yang dibutuhkan untuk [[item/85]]. Intinya adalah [[item/171]].", false],
	],
	"item/161": [
		[0, "", "[[item/161]] adalah bijih berharga menengah yang sistem asalnya [[system/19]]. Tidak ada cetak biru yang memakainya. Intinya adalah [[item/172]].", false],
	],
	"item/162": [
		[0, "", "[[item/162]] adalah bijih berharga menengah yang sistem asalnya [[system/14]]. Tidak ada cetak biru yang memakainya. Intinya adalah [[item/173]].", false],
	],
	"item/163": [
		[0, "", "[[item/163]] adalah bijih berharga menengah yang sistem asalnya [[system/5]]. Bijih ini bahan utama [[item/54]], yang membutuhkan 80 t, dan juga dibutuhkan untuk [[item/85]]. Intinya adalah [[item/174]].", false],
	],
	"item/164": [
		[0, "", "[[item/164]] adalah bijih yang tidak pernah ditemukan di ladang asteroid sistem-sistem berpenghuni. Tidak seperti bijih lain, asteroid kristal tidak meninggalkan apa pun saat ditembak hancur, jadi kristalnya harus dibor. Kristal ini bahan kunci [[item/85]], yang membutuhkan 50 buah.", false],
		[25, "", "Setiap asteroid di ruang asal [[faction/9|para Void]], yang dicapai melalui lubang cacing mereka, terbuat dari kristal ini.", false],
		[33, "", "[[character/20]] meminta [[character/0]] membawakannya setidaknya 50 kristal, yang ia yakini menyimpan rahasia lubang cacing [[faction/9|para Void]].", false],
	],
	"item/165": [
		[0, "", "Inti ini adalah pusat langka dari asteroid [[item/154]] kelas A. Inti ini didapat dengan mengebor tembus ketujuh lapisan asteroid tersebut, dan sesekali terlepas saat asteroid kelas A ditembak hancur. Harganya beberapa kali lipat harga bijihnya, termurah di [[system/9]]. Inilah inti paling berharga selain [[item/175]].", false],
	],
	"item/166": [
		[0, "", "Inti ini adalah pusat langka dari asteroid [[item/155]] kelas A. Inti ini didapat dengan mengebor tembus ketujuh lapisan asteroid tersebut, dan sesekali terlepas saat asteroid kelas A ditembak hancur. Harganya beberapa kali lipat harga bijihnya, termurah di [[system/21]]. Inti ini dibutuhkan untuk membuat [[item/15]] dan, sepuluh sekaligus, [[item/90]].", false],
	],
	"item/167": [
		[0, "", "Inti ini adalah pusat langka dari asteroid [[item/156]] kelas A. Inti ini didapat dengan mengebor tembus ketujuh lapisan asteroid tersebut, dan sesekali terlepas saat asteroid kelas A ditembak hancur. Harganya beberapa kali lipat harga bijihnya, termurah di [[system/0]]. Inilah inti yang paling rendah nilainya.", false],
	],
	"item/168": [
		[0, "", "Inti ini adalah pusat langka dari asteroid [[item/157]] kelas A. Inti ini didapat dengan mengebor tembus ketujuh lapisan asteroid tersebut, dan sesekali terlepas saat asteroid kelas A ditembak hancur. Harganya beberapa kali lipat harga bijihnya, termurah di [[system/7]]. Lima belas buah dibutuhkan untuk membuat [[item/59]].", false],
	],
	"item/169": [
		[0, "", "Inti ini adalah pusat langka dari asteroid [[item/158]] kelas A. Inti ini didapat dengan mengebor tembus ketujuh lapisan asteroid tersebut, dan sesekali terlepas saat asteroid kelas A ditembak hancur. Harganya beberapa kali lipat harga bijihnya, termurah di [[system/4]].", false],
	],
	"item/17": [
		[0, "", "[[item/17]] menguras 5 energi per tembakan setiap 0,5 dtk dan berjangkauan 2.000 unit, jauh lebih jauh daripada [[item/16]]. Blaster ini tidak merusak lambung. Laju pengurasan energinya kira-kira sama dengan Mk I, tetapi dapat dilakukan dari jarak yang lebih aman.", false],
	],
	"item/170": [
		[0, "", "Inti ini adalah pusat langka dari asteroid [[item/159]] kelas A. Inti ini didapat dengan mengebor tembus ketujuh lapisan asteroid tersebut, dan sesekali terlepas saat asteroid kelas A ditembak hancur. Harganya beberapa kali lipat harga bijihnya, termurah di [[system/18]].", false],
	],
	"item/171": [
		[0, "", "Inti ini adalah pusat langka dari asteroid [[item/160]] kelas A. Inti ini didapat dengan mengebor tembus ketujuh lapisan asteroid tersebut, dan sesekali terlepas saat asteroid kelas A ditembak hancur. Harganya beberapa kali lipat harga bijihnya, termurah di [[system/13]].", false],
	],
	"item/172": [
		[0, "", "Inti ini adalah pusat langka dari asteroid [[item/161]] kelas A. Inti ini didapat dengan mengebor tembus ketujuh lapisan asteroid tersebut, dan sesekali terlepas saat asteroid kelas A ditembak hancur. Harganya beberapa kali lipat harga bijihnya, termurah di [[system/19]].", false],
	],
	"item/173": [
		[0, "", "Inti ini adalah pusat langka dari asteroid [[item/162]] kelas A. Inti ini didapat dengan mengebor tembus ketujuh lapisan asteroid tersebut, dan sesekali terlepas saat asteroid kelas A ditembak hancur. Harganya beberapa kali lipat harga bijihnya, termurah di [[system/14]].", false],
	],
	"item/174": [
		[0, "", "Inti ini adalah pusat langka dari asteroid [[item/163]] kelas A. Inti ini didapat dengan mengebor tembus ketujuh lapisan asteroid tersebut, dan sesekali terlepas saat asteroid kelas A ditembak hancur. Harganya beberapa kali lipat harga bijihnya, termurah di [[system/5]].", false],
	],
	"item/175": [
		[0, "", "[[item/175]] adalah inti dari asteroid [[item/164]] kelas A. Karena asteroid kristal tidak meninggalkan apa pun saat ditembak hancur, satu-satunya cara mendapatkannya adalah mengebor tembus ketujuh lapisannya. Harganya tetap 5.000 kredit, lebih dari lima kali harga terbaik inti lain mana pun.", false],
		[25, "", "Inti ini hanya dapat ditemukan di ruang asal [[faction/9|para Void]].", false],
	],
	"item/18": [
		[0, "", "[[item/18]] adalah blaster EMP terkuat: 8 energi per tembakan setiap 0,5 dtk dengan jangkauan 2.000, sehingga melumpuhkan kapal jauh lebih cepat daripada [[item/17]]. Seperti blaster EMP lainnya, blaster ini tidak merusak lambung.", false],
	],
	"item/19": [
		[0, "", "[[item/19]] memberi kerusakan 15 setiap 0,3 dtk dengan jangkauan 1.400. Kerusakannya dari waktu ke waktu jauh lebih besar daripada laser mana pun. [[item/20]] dan [[item/21]] menembak lebih cepat tetapi jangkauannya hanya 1.000 unit.", false],
	],
	"item/2": [
		[0, "", "[[item/2]] adalah laser Nirai teratas: kerusakan 7 setiap 0,4 dtk. Setiap tembakannya lebih lemah daripada laser Berger, tetapi karena menembak sekitar dua kali lebih sering, total kerusakannya dari waktu ke waktu melebihi semua laser Berger, termasuk [[item/8]]. Hanya laser sinar M6 ([[item/9]] dan penerusnya) yang jelas mengunggulinya.", false],
	],
	"item/20": [
		[0, "", "[[item/20]] menembak setiap 0,2 dtk dengan kerusakan 13. Dari waktu ke waktu kerusakannya melebihi [[item/19]], tetapi jangkauannya hanya 1.000 unit, jadi paling efektif pada jarak dekat.", false],
	],
	"item/21": [
		[0, "", "[[item/21]] memberi kerusakan 14 setiap 0,2 dtk, kerusakan dari waktu ke waktu tertinggi di antara semua senjata depan. Seperti [[item/20]], jangkauannya hanya 1.000 unit. Blaster ini juga yang paling langka di toko.", false],
	],
	"item/22": [
		[0, "", "[[item/22]] adalah senjata terlemah dalam permainan: kerusakan 2 setiap 0,4 dtk dengan jangkauan 1.000. Meriam otomatis menembakkan peluru kecil dengan cepat; pukulannya ringan, tetapi beberapa model menembak sangat cepat. Model pertama ini hanya pengganti sementara.", false],
		[6, "", "Meriam ini salah satu dari tiga barang yang ditawarkan [[character/2]] secara cuma-cuma di hanggarnya di stasiun [[station/78]] sebelum penyerbuan sarang bajak laut, bersama [[item/0]] dan [[item/55]].", false],
	],
	"item/23": [
		[0, "", "[[item/23]] menggandakan kerusakan [[item/22]] menjadi 4 per tembakan dan menembak sedikit lebih cepat (setiap 0,3 dtk), masih dengan jangkauan 1.000. Ini senjata awal yang murah.", false],
	],
	"item/24": [
		[0, "", "[[item/24]] memberi kerusakan 6 setiap 0,3 dtk dengan jangkauan 1.200. Ini meriam otomatis kelas menengah yang solid dan setara kerusakannya dari waktu ke waktu dengan [[item/25]], yang berjangkauan lebih jauh.", false],
	],
	"item/25": [
		[0, "", "[[item/25]] memberi kerusakan 8 setiap 0,4 dtk dan berjangkauan 1.400 unit, jangkauan terjauh di antara semua meriam otomatis. Dari waktu ke waktu kerusakannya sama dengan [[item/24]]. Meriam ini tidak pernah dijual dalam keadaan jadi. Cetak birunya berasal dari [[agent/2]] di stasiun [[station/20]], dan meriam ini dibuat hanya dari komoditas, tanpa bijih.", false],
	],
	"item/26": [
		[0, "", "[[item/26]] menembak setiap 0,2 dtk dengan kerusakan 5 dan jangkauan 1.000. Tembakannya yang cepat memberinya kerusakan dari waktu ke waktu yang lebih besar daripada railgun, dengan mengorbankan jangkauan.", false],
	],
	"item/27": [
		[0, "", "[[item/27]] menembak setiap 0,1 dtk, laju tembak tercepat di antara semua meriam otomatis, dengan kerusakan 6 per peluru. Kerusakannya dari waktu ke waktu mendekati blaster terbaik, tetapi jangkauannya yang 900 adalah yang terpendek di antara semua senjata. Meriam ini tidak pernah dijual dalam keadaan jadi. Cetak birunya berasal dari [[agent/3]] di stasiun [[station/10]], dan pembuatannya antara lain membutuhkan [[item/154]].", false],
	],
	"item/28": [
		[0, "", "[[item/28]] adalah senjata termal pertama. Senjata termal menembakkan tembakan ringan dengan cepat pada jangkauan 1.000; yang ini memberi kerusakan 3 setiap 0,3 dtk. Meskipun tingkat teknologinya tinggi, kerusakannya dari waktu ke waktu lebih lemah daripada kebanyakan blaster dan meriam otomatis kelas menengah.", false],
	],
	"item/29": [
		[0, "", "[[item/29]] memberi kerusakan 4 setiap 0,2 dtk dengan jangkauan 1.000, dua kali kerusakan dari waktu ke waktu [[item/28]].", false],
	],
	"item/3": [
		[0, "", "[[item/3]] adalah laser [[faction/1|Vossk]] yang memberi kerusakan 7 setiap 0,5 dtk. Per tembakan setara dengan [[item/2]] tetapi menembak sedikit lebih lambat, sehingga sedikit tertinggal dari waktu ke waktu. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
		[0, "", "[[ship/10]] milik [[character/0]] membawa dua laser ini dalam adegan pembuka.", false],
	],
	"item/30": [
		[0, "", "[[item/30]] menembak setiap 0,1 dtk dengan kerusakan 3, yang tercepat di antara senjata termal. Dari waktu ke waktu kerusakannya lebih besar daripada [[item/29]], tetapi lebih kecil daripada blaster teratas seperti [[item/21]].", false],
	],
	"item/31": [
		[0, "", "[[item/31]] adalah roket [[faction/1|Vossk]] dasar dan amunisi sekunder termurah: kerusakan 60 per tembakan, satu peluncuran setiap 1,2 dtk, jangkauan 1.200. Roket terbang lurus dan tidak mengikuti sasarannya, jadi paling efektif pada jarak dekat. Roket atau torpedo apa pun yang mengenai asteroid akan menghancurkannya. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/32": [
		[0, "", "[[item/32]] adalah roket tanpa pemandu yang umum: kerusakan 70 per tembakan, peluncuran setiap 0,9 dtk, dan jangkauan 1.200. Roket ini memukul lebih keras dan meluncur lebih cepat daripada [[item/31]] dan dijual di banyak tempat.", false],
	],
	"item/33": [
		[0, "", "[[item/33]] memberi kerusakan 72 dan juga menguras 34 energi, sehingga dapat sekaligus merusak dan membantu melumpuhkan sasaran. Isi ulangnya lambat (2 dtk) dan jangkauannya 1.000 unit. Roket ini tidak pernah dijual dalam keadaan jadi. Cetak birunya berasal dari [[agent/4]] di stasiun [[station/43]], dan satu batch hanya membutuhkan beberapa komoditas murah.", false],
	],
	"item/34": [
		[0, "", "[[item/34]] dirancang untuk melumpuhkan, bukan menghancurkan: roket ini menguras 45 energi dan hanya memberi kerusakan 10 per tembakan, dengan satu peluncuran setiap detik. [[item/35]] menguras lebih banyak dan memberi kerusakan lebih besar.", false],
	],
	"item/35": [
		[0, "", "[[item/35]] menguras 60 energi dan memberi kerusakan 30 per tembakan, meluncur setiap detik dengan jangkauan 1.000. Roket ini melumpuhkan kapal lebih cepat daripada [[item/34]] sambil tetap menggerus lambungnya.", false],
	],
	"item/36": [
		[0, "", "[[item/36]] adalah torpedo dasar. Torpedo terbang lurus selama 1,5 dtk pertama lalu mengejar sasarannya. [[item/36]] memberi kerusakan 70 dengan jangkauan 3.000 unit, tetapi lambat dan hanya meluncur setiap 3 dtk. [[item/38]] menggandakan kerusakannya.", false],
	],
	"item/37": [
		[0, "", "[[item/37]] adalah torpedo tercepat: memberi kerusakan 100, menguras 50 energi, dan berjangkauan 4.000 unit. Torpedo ini meluncur setiap 4 dtk. Torpedo ini tidak pernah dijual dalam keadaan jadi. Cetak birunya berasal dari [[agent/5]] di stasiun [[station/54]], dan satu batch hanya membutuhkan beberapa komoditas.", false],
	],
	"item/38": [
		[0, "", "[[item/38]] adalah torpedo dengan pukulan terkeras, kerusakan 140 per tembakan dan jangkauan 4.000. Torpedo ini lambat saat terbang dan meluncur setiap 4 dtk. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/39": [
		[0, "", "[[item/39]] adalah torpedo pemandu untuk melumpuhkan kapal: menguras 100 energi dan tidak memberi kerusakan. Dengan jangkauan 5.000, torpedo ini cara murah untuk menghentikan sasaran dari jauh. [[item/40]] menambahkan kerusakan 120 pada pengurasan energi yang sama.", false],
	],
	"item/4": [
		[0, "", "[[item/4]] adalah laser [[faction/1|Vossk]] yang lebih kuat: kerusakan 10 setiap 0,6 dtk. Kerusakannya dari waktu ke waktu hampir persis sama dengan [[item/2]], dengan tembakan yang lebih berat tetapi lebih jarang daripada [[item/3]]. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/40": [
		[0, "", "[[item/40]] memadukan kerusakan 120 dengan pengurasan 100 poin energi dalam satu torpedo pemandu, dengan jangkauan 5.000 dan satu peluncuran setiap 5 dtk. Harganya lebih dari dua kali lipat [[item/39]].", false],
	],
	"item/41": [
		[0, "", "[[item/41]] adalah bom EMP terkecil. Bom diluncurkan dengan sekali tekan dan diledakkan dengan tekanan kedua; ledakannya menguras energi setiap kapal dalam radiusnya, lebih kuat di dekat pusat, dan tidak memengaruhi kapal yang meluncurkannya. Asteroid tidak terpengaruh. Model ini menguras hingga 80 energi dalam radius 22.000. [[item/42]] dan [[item/43]] lebih kuat dan lebih luas.", false],
		[20, "", "Pasukan keamanan [[faction/0|Terran]] menitipkan sepuluh bom ini di stasiun [[station/55]] secara cuma-cuma, agar [[character/0]] dapat melumpuhkan kapal para penculik tanpa menghancurkannya.", false],
	],
	"item/42": [
		[0, "", "[[item/42]] menguras hingga 150 energi dalam radius 30.000, hampir dua kali kekuatan [[item/41]] dengan ledakan yang jauh lebih luas.", false],
	],
	"item/43": [
		[0, "", "[[item/43]] adalah bom EMP terkuat: menguras hingga 300 energi dalam radius 37.000. Isi ulangnya sedikit lebih cepat daripada [[item/42]] tetapi harganya hampir dua kali lipat.", false],
	],
	"item/44": [
		[0, "", "[[item/44]] adalah bom nuklir terkecil. Seperti bom EMP, bom ini diluncurkan lalu diledakkan dengan tekanan kedua, tetapi ledakannya memberi kerusakan nyata: hingga 200 dalam radius 20.000, makin kecil ke arah tepi. Bom ini juga menghancurkan asteroid. Kapal yang meluncurkannya tidak terkena.", false],
	],
	"item/45": [
		[0, "", "[[item/45]] memberi kerusakan hingga 560 dalam radius 30.000, hampir tiga kali kekuatan [[item/44]] dengan ledakan yang lebih luas.", false],
	],
	"item/46": [
		[0, "", "[[item/46]] adalah senjata paling merusak dalam permainan: kerusakan hingga 950 dalam radius 40.000. Bom ini tidak pernah dijual dalam keadaan jadi. Cetak birunya berasal dari [[agent/6]] di stasiun [[station/61]], dan pembuatannya antara lain membutuhkan barang radioaktif dan bahan peledak di samping komoditas lain.", false],
	],
	"item/47": [
		[0, "", "[[item/47]] adalah turet dasar. Turet menempati slotnya sendiri, yang hanya dimiliki sebagian lambung, dan dapat berputar penuh, sehingga dapat mengenai sasaran di samping atau di belakang kapal; selama Anda membidikkannya, kapal terbang sendiri. Model ini memberi kerusakan 6 setiap 0,3 dtk dengan jangkauan 2.000 dan berputar lambat (kelincahan 40).", false],
	],
	"item/48": [
		[0, "", "[[item/48]] memberi kerusakan 10 setiap 0,2 dtk dengan jangkauan 2.500 dan berputar lebih cepat daripada [[item/47]] (kelincahan 60). Harganya lebih dari tiga kali lipat.", false],
	],
	"item/49": [
		[0, "", "[[item/49]] adalah turet terbaik: kerusakan 12 setiap 0,1 dtk dengan jangkauan 3.000, dengan putaran tercepat (kelincahan 100). Turet ini juga sangat mahal, sekitar dua kali harga [[item/48]]. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/5": [
		[0, "", "[[item/5]] membuka jajaran laser Berger, yang mengorbankan laju tembak demi tembakan yang lebih berat dan jangkauan sedikit lebih jauh (2.200). Laser ini memberi kerusakan 8 setiap 0,9 dtk, lebih kecil dari waktu ke waktu daripada [[item/2]] yang lebih murah. Keunggulannya adalah jangkauan yang lebih jauh.", false],
	],
	"item/50": [
		[0, "", "[[item/50]] adalah perisai dasar. Perisai menyerap kerusakan yang masuk sebelum zirah dan lambung terkena, dan terisi kembali dengan sendirinya selama waktu isinya. Targe hanya menampung 50 poin, tetapi terisi penuh dalam 20 dtk, lebih cepat daripada perisai lain mana pun.", false],
	],
	"item/51": [
		[0, "", "[[item/51]] menampung 80 poin tetapi membutuhkan 46 dtk untuk terisi penuh. Perisai ini menyerap lebih banyak daripada [[item/50]] dalam satu pertempuran, tetapi pulih jauh lebih lambat di antara serangan.", false],
	],
	"item/52": [
		[0, "", "[[item/52]] adalah perisai [[faction/1|Vossk]] yang menampung 120 poin dan terisi kembali dalam 58 dtk. Perisai ini menyerap jauh lebih banyak daripada [[item/51]], tetapi [[item/53]] menampung lebih banyak dan terisi lebih cepat. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/53": [
		[0, "", "[[item/53]] menampung 150 poin dan terisi kembali dalam 45 dtk, sehingga mengungguli [[item/52]] dalam kedua hal. Inilah perisai terbaik yang dijual di toko.", false],
	],
	"item/54": [
		[0, "", "[[item/54]] adalah perisai terkuat: 220 poin, terisi kembali dalam 60 dtk. Perisai ini tidak pernah dijual dalam keadaan jadi. Cetak birunya berasal dari [[agent/7]] di stasiun [[station/72]], dan pembuatannya membutuhkan [[item/163]] dalam jumlah besar beserta elektronik, nanoteknologi, dan mikrocip.", false],
	],
	"item/55": [
		[0, "", "[[item/55]] adalah pelat zirah dasar. Pelat menambahkan poinnya ke zirah kapal; setelah perisai, pelat menerima kerusakan sebelum lambung, dan tidak seperti perisai, pelat tidak terisi kembali. E2 menambahkan 40 poin, bagian yang besar untuk kapal pemula ringan seperti [[ship/32]], yang memiliki 100 poin sendiri.", false],
		[6, "", "Pelat ini salah satu dari tiga barang yang ditawarkan [[character/2]] secara cuma-cuma di hanggarnya di stasiun [[station/78]] sebelum penyerbuan sarang bajak laut, bersama [[item/0]] dan [[item/22]].", false],
	],
	"item/56": [
		[0, "", "[[item/56]] menambahkan 80 poin zirah, dua kali [[item/55]], dengan harga yang wajar.", false],
	],
	"item/57": [
		[0, "", "[[item/57]] menambahkan 110 poin zirah. Inilah pelat terbaik yang dijual di luar sistem [[faction/1|Vossk]].", false],
	],
	"item/58": [
		[0, "", "[[item/58]] adalah pelat [[faction/1|Vossk]] yang menambahkan 160 poin zirah, jauh lebih banyak daripada [[item/57]]. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/59": [
		[0, "", "[[item/59]] adalah pelat zirah terbaik: menambahkan 250 poin, sebanyak zirah dasar [[ship/9]] dan lebih banyak daripada lambung lain mana pun kecuali [[ship/8]]. Pelat ini tidak pernah dijual dalam keadaan jadi. Cetak birunya berasal dari [[agent/8]] di stasiun [[station/84]], dan pembuatannya membutuhkan [[item/157]], [[item/168]], dan [[item/156]] beserta komoditas.", false],
	],
	"item/6": [
		[0, "", "[[item/6]] memberi kerusakan 9 setiap 0,8 dtk dengan jangkauan 2.200. Ini peningkatan kecil dari [[item/5]], dan harganya hampir tidak berbeda antarsistem.", false],
	],
	"item/60": [
		[0, "", "[[item/60]] adalah yang terlemah dari tiga modul pelindung EMP, dengan pertahanan EMP 20. Tidak satu pun dari ketiganya memiliki harga, dan tidak ada toko yang menyediakannya.", false],
	],
	"item/61": [
		[0, "", "[[item/61]] adalah modul pelindung EMP tingkat menengah, dengan pertahanan EMP 40, dua kali [[item/60]]. Seperti modul sejenisnya, modul ini tidak memiliki harga dan tidak disediakan toko.", false],
	],
	"item/62": [
		[0, "", "[[item/62]] adalah modul pelindung EMP terkuat, dengan pertahanan EMP 60. Seperti [[item/60]] dan [[item/61]], modul ini tidak memiliki harga dan tidak disediakan toko.", false],
	],
	"item/63": [
		[0, "", "[[item/63]] adalah kompresor kargo dasar. Kompresor memperbesar ruang kargo sebesar persentase kapasitas lambung itu sendiri; yang ini menambah 15 %. Harganya murah dan bermanfaat bagi pedagang maupun penambang.", false],
	],
	"item/64": [
		[0, "", "[[item/64]] memperbesar ruang kargo sebesar 25 %, peningkatan nyata dari [[item/63]] dengan harga murah.", false],
	],
	"item/65": [
		[0, "", "[[item/65]] memperbesar ruang kargo sebesar 40 %. Pada kapal barang besar, tambahannya setara dengan seluruh ruang kargo sebuah kapal kecil.", false],
	],
	"item/66": [
		[0, "", "[[item/66]] memperbesar ruang kargo sebesar 75 %, terbesar di antara kompresor yang dijual di toko.", false],
	],
	"item/67": [
		[0, "", "[[item/67]] menggandakan ruang kargo, menambah 100 % kapasitas lambung: dengan kompresor ini [[ship/36]] dapat mengangkut 700 t. Kompresor ini tidak pernah dijual dalam keadaan jadi. Cetak birunya berasal dari [[agent/9]] di stasiun [[station/90]], dan kompresor ini dibuat hanya dari komoditas.", false],
	],
	"item/68": [
		[0, "", "[[item/68]] adalah sinar traktor dasar. Tanpa sinar traktor, tidak ada kontainer melayang yang dapat dikumpulkan; menabrakkan kapal ke kontainer tidak berpengaruh apa-apa. Dengan Retractor, Anda menahan kontainer di bawah bidikan selama 4 dtk, lalu kontainer itu tertarik masuk. [[item/69]] membutuhkan waktu lebih singkat, dan [[item/70]] bekerja secara otomatis.", false],
		[24, "", "[[character/6]] meminta [[character/0]] memasang sinar traktor sebelum ekspedisi pertama melawan [[faction/9|para Void]], agar ia dapat mengumpulkan sisa-sisa kapal mereka. Sampai saat itu, toko berpeluang besar menyediakan Retractor di samping barang biasanya.", false],
	],
	"item/69": [
		[0, "", "[[item/69]] bekerja seperti [[item/68]], tetapi hanya membutuhkan sasaran di bawah bidikan selama 3 dtk sebelum menarik kontainer masuk.", false],
	],
	"item/7": [
		[0, "", "[[item/7]] memberi kerusakan 10 setiap 0,8 dtk dengan jangkauan 2.200. Dari waktu ke waktu laser ini setara dengan [[item/1]], jadi nilainya terletak pada tembakan yang lebih jarang tetapi lebih berat dari jarak jauh.", false],
	],
	"item/70": [
		[0, "", "[[item/70]] adalah sinar traktor otomatis: sinar ini mengumpulkan kontainer apa pun di pandangan depan tanpa perlu dibidik dan ditahan, sehingga menghemat banyak waktu saat menjarah medan pertempuran. Harganya jauh lebih mahal daripada [[item/69]].", false],
	],
	"item/71": [
		[0, "", "[[item/71]] adalah booster dasar. Booster memberi semburan kecepatan tambahan yang singkat, lalu membutuhkan waktu isi ulang. Booster ini menambah kecepatan 60 % selama 3 dtk dan terisi ulang dalam 8 dtk.", false],
	],
	"item/72": [
		[0, "", "[[item/72]] tercatat memberi kecepatan tambahan 80 % selama 4,4 dtk, dengan isi ulang 10 dtk. Saat terbang, semburannya mencapai kecepatan puncak yang sama dengan [[item/71]]; tambahannya adalah semburan yang lebih lama.", false],
	],
	"item/73": [
		[0, "", "[[item/73]] memberi tambahan lebih dari dua kali lipat booster yang lebih murah: kecepatan tambahan 160 % selama 5,6 dtk, terisi ulang dalam 12 dtk.", false],
	],
	"item/74": [
		[0, "", "[[item/74]] adalah booster terkuat: kecepatan tambahan 200 % selama 6 dtk. Booster ini membutuhkan isi ulang terlama, 16 dtk. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/75": [
		[0, "", "[[item/75]] adalah satu-satunya robot perbaikan dalam permainan dan dipasang di slot perlengkapan. Selama Anda terbang, robot ini memulihkan satu poin lambung setiap 0,6 dtk dan satu poin pelat zirah setiap detik, sehingga kerusakan berangsur hilang di sela pertempuran tanpa perlu berlabuh. Harganya murah dan disediakan sebagian besar toko.", false],
	],
	"item/76": [
		[0, "", "[[item/76]] adalah nosel kemudi dasar. Nosel menambahkan angkanya ke kelincahan kapal, sehingga kapal berbelok lebih cepat. Nosel ini menambah 20, tambahan kecil bagi pesawat tempur yang lincah tetapi terasa pada kapal barang yang lamban.", false],
	],
	"item/77": [
		[0, "", "[[item/77]] menambah kelincahan 40, dua kali [[item/76]], dengan harga murah.", false],
	],
	"item/78": [
		[0, "", "[[item/78]] adalah nosel [[faction/1|Vossk]] yang menambah kelincahan 70. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/79": [
		[0, "", "[[item/79]] adalah nosel [[faction/1|Vossk]] yang menambah kelincahan 100, cukup untuk membuat kapal barang berat berbelok seperti pesawat tempur yang lincah. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/8": [
		[0, "", "[[item/8]] adalah laser Berger terakhir dan terkuat: kerusakan 12 per tembakan setiap 0,9 dtk dengan jangkauan 2.200. Inilah laser konvensional dengan tembakan terkuat, tetapi [[item/2]] yang lebih cepat tetap memberi kerusakan lebih besar dari waktu ke waktu. Laser sinar M6 sesudahnya ([[item/9]] dan seterusnya) memukul lebih dari dua kali lebih keras per tembakan.", false],
	],
	"item/80": [
		[0, "", "[[item/80]] adalah nosel kemudi terbaik, menambah kelincahan 130. Nosel ini menaikkan [[ship/36]], lambung yang paling lamban berbelok, dari 45 menjadi 175, lebih tinggi daripada pesawat tempur mana pun tanpa nosel. Nosel ini langka di toko.", false],
	],
	"item/81": [
		[0, "", "[[item/81]] adalah pemindai dasar. Pemindai menentukan berapa lama waktu yang diperlukan untuk mengunci sasaran seperti kapal, stasiun, atau asteroid; Quickscan membutuhkan 4 dtk. [[item/82]] mengunci lebih cepat dan juga menampilkan muatan kapal lain.", false],
		[2, "", "Kapal tambang milik [[character/2]], [[ship/0]], sudah dilengkapi satu pemindai ini.", false],
	],
	"item/82": [
		[0, "", "[[item/82]] mengunci dalam 3 dtk dan menampilkan muatan kapal sasaran, yang membantu saat berburu jarahan.", false],
	],
	"item/83": [
		[0, "", "[[item/83]] mengunci dalam 1,8 dtk, waktu kunci yang hanya disamai oleh [[item/84]], dan juga menampilkan muatan sasaran.", false],
	],
	"item/84": [
		[0, "", "[[item/84]] mengunci secepat [[item/83]] dan menampilkan muatan, serta menandai asteroid kelas A, satu-satunya asteroid yang dapat menghasilkan inti (lihat [[guide/mining]]). Inilah pemindai pilihan para penambang.", false],
	],
	"item/85": [
		[0, "", "[[item/85]] adalah satu-satunya mesin lompat dalam permainan. Dengan mesin ini terpasang, Anda dapat bepergian dari peta bintang langsung ke sebuah stasiun di sistem lain tanpa melewati gerbang lompat. Mesin ini tidak dapat digunakan selama beberapa misi. Mesin ini tidak pernah dijual dalam keadaan jadi, dan tidak ada agen yang menjual cetak birunya. Pembuatannya membutuhkan [[item/164]], [[item/158]], [[item/160]], dan [[item/163]] beserta komoditas dalam jumlah besar.", false],
		[33, "", "Penemunya, [[character/20]], meminta [[character/0]] membawakan 50 [[item/164]] untuk penelitiannya tentang penggerak yang dapat mencapai tempat mana pun di ruang angkasa.", false],
		[34, "", "Sebagai imbalan atas kristal-kristal itu, [[character/20]] memberi [[character/0]] salinan cetak birunya. Ke-50 kristal yang diserahkan dihitung untuk penggerak itu, jadi hanya bahan sisanya yang perlu dipasok.", false],
	],
	"item/86": [
		[0, "", "[[item/86]] adalah laser tambang dasar. Laser tambang diperlukan untuk mengebor bijih dari asteroid. Hasilnya menentukan seberapa mantap bor mempertahankan arahnya, dan setiap model juga memiliki kecepatan pengeborannya sendiri (lihat [[guide/mining]]). Laser ini memiliki hasil 30 dan sulit dijaga tetap di jalur pada lapisan dalam.", false],
	],
	"item/87": [
		[0, "", "[[item/87]] memiliki hasil 50. Laser ini jelas lebih mantap daripada [[item/86]], meskipun mengebor sedikit lebih lambat.", false],
	],
	"item/88": [
		[0, "", "[[item/88]] adalah laser tambang [[faction/1|Vossk]] dengan hasil 80, bor paling mantap yang dijual di toko. Kekurangannya, laser ini paling lambat mengekstrak bijih. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/89": [
		[0, "", "[[item/89]] memiliki hasil 60, kurang mantap dibandingkan [[item/88]], tetapi mengekstrak bijih jauh lebih cepat daripada laser lain yang dijual di toko. Laser ini cocok bagi penambang yang mampu menjaga bor tetap di jalur sendiri.", false],
	],
	"item/9": [
		[0, "", "[[item/9]] adalah laser sinar M6 yang pertama. Laser jenis ini jarang menembak tetapi memukul sangat keras: kerusakan 27 setiap 1,2 dtk, dengan jangkauan 2.400, lebih jauh daripada laser mana pun sebelumnya. Bidikan yang akurat penting, karena tembakan yang meleset membuang waktu isi ulang yang lama. Laser ini juga menjadi komponen dasar untuk membuat [[item/11]].", false],
	],
	"item/90": [
		[0, "", "[[item/90]] adalah laser tambang terbaik: hasil 100 dan pengeboran tercepat di antara semua model. Laser ini tidak pernah dijual dalam keadaan jadi. Cetak birunya berasal dari [[agent/11]] di stasiun [[station/78]], dan pembuatannya membutuhkan nanoteknologi, pasokan mekanis, dan hidraulik dalam jumlah besar, ditambah [[item/155]] dan sepuluh [[item/166]].", false],
		[2, "", "Laser pada kapal tambang pertama [[character/0]] adalah purwarupa bor ini yang dibuat sendiri oleh [[character/2]].", false],
		[10, "", "Saat [[character/2]] memberikan [[ship/0]] kepada [[character/0]], ia menyimpan purwarupa itu, satu-satunya yang ia miliki, dan menyarankan kunjungan di kemudian hari, ketika mungkin ia sudah membuat lebih banyak.", false],
	],
	"item/91": [
		[0, "", "[[item/91]] menampung 3 penumpang. Kabin diperlukan untuk pekerjaan [[job/11]], dan kapasitas beberapa kabin dijumlahkan. [[item/92]] dan [[item/93]] menampung lebih banyak.", false],
	],
	"item/92": [
		[0, "", "[[item/92]] menampung 5 penumpang, dua lebih banyak daripada [[item/91]].", false],
	],
	"item/93": [
		[0, "", "[[item/93]] menampung 10 penumpang, dua kali [[item/92]], sehingga membuka pekerjaan penumpang yang lebih besar.", false],
	],
	"item/94": [
		[0, "", "[[item/94]] adalah selubung dasar. Selama selubung aktif, kapal lain tidak dapat melihat Anda. Selubung ini menyembunyikan kapal selama 15 dtk lalu membutuhkan 18 dtk untuk terisi ulang. Waktu dalam keadaan terselubung dihitung untuk medali [[medal/19]].", false],
	],
	"item/95": [
		[0, "", "[[item/95]] adalah selubung [[faction/1|Vossk]] yang menyembunyikan kapal selama 28 dtk dan terisi ulang dalam 32 dtk, hampir dua kali perlindungan [[item/94]]. Hanya toko di sistem [[faction/1|Vossk]] yang menyediakannya.", false],
	],
	"item/96": [
		[0, "", "[[item/96]] adalah selubung terbaik: menyembunyikan kapal selama 46 dtk dan terisi ulang hanya dalam 40 dtk, sehingga dapat aktif lebih sering daripada tidak. Selubung ini tidak pernah dijual dalam keadaan jadi. Cetak birunya berasal dari [[agent/10]] di stasiun [[station/59]].", false],
	],
	"job/0": [
		[0, "", "Pekerjaan kurir meminta Anda membawa satu muatan kontainer kiriman tersegel ke stasiun lain. Kontainer dimuat ke ruang kargo Anda saat Anda menerima pekerjaan, jadi Anda butuh ruang kosong yang cukup; kontainer itu tidak dapat dijual. Pekerjaan selesai saat Anda berlabuh di tujuan dengan kiriman itu di kapal. Bajak laut kadang menghadang para kurir. Kiriman yang diantar dihitung untuk [[medal/5]].", false],
	],
	"job/1": [
		[0, "", "Dalam pekerjaan pertahanan, sebuah stasiun akan segera diserang, dan Anda disewa untuk membantu pesawat tempurnya sendiri mengusir para penyerbu. Penyerangnya biasanya bajak laut, jika tidak, kapal-kapal ras saingan. Terbanglah ke stasiun dan hancurkan setiap penyerang; kapal yang dihancurkan pesawat tempur sekutu juga dihitung. Pekerjaan yang lebih sulit mendatangkan lebih banyak penyerang.", false],
	],
	"job/10": [
		[0, "", "Dalam pekerjaan pencegatan, konvoi dua atau tiga kapal barang bermuatan ilegal berada jauh dari sebuah stasiun, dijaga pesawat-pesawat tempur. Ikuti titik-titik arah dan hancurkan kapal-kapal barang itu. Para penjaganya menunggu di sepanjang jalan dan di sekitar konvoi.", false],
	],
	"job/11": [
		[0, "", "Pekerjaan penumpang meminta Anda membawa sekelompok orang ke stasiun lain. Anda membutuhkan kabin yang cukup untuk mereka semua saat menerima pekerjaan; selama mereka di kapal, kabin tidak dapat dilepas dan lambung tidak dapat diganti. Berlabuhlah di tujuan untuk mengantar mereka. Imbalan dasarnya lebih rendah, tetapi setiap penumpang menambahnya. Penumpang yang diantar dihitung untuk [[medal/18]].", false],
	],
	"job/12": [
		[0, "", "Tantangan adalah lomba menembak yang ditawarkan pilot lain di Lounge Luar Angkasa. Anda berdua terbang dari stasiun yang sama menuju sekelompok bajak laut yang tersebar di sepanjang sebuah rute, dan siapa yang menembak jatuh lebih banyak, dialah pemenangnya. Saingan Anda tidak dapat dihancurkan dan tembakannya sekuat senjata Anda sendiri. Anda hanya dibayar jika menghancurkan lebih banyak; jumlah bajak laut selalu ganjil, jadi tidak pernah ada hasil seri.", false],
	],
	"job/2": [
		[0, "", "Pekerjaan perlindungan mengutus Anda menjaga kapal-kapal tambang yang bekerja di ladang asteroid dekat sebuah stasiun. Para penyerbu datang dan menuju stasiun serta para penambang. Hancurkan mereka semua sebelum mereka dapat memusnahkan para penambang; jika semua kapal tambang hilang, pekerjaan gagal.", false],
	],
	"job/3": [
		[0, "", "Dalam pekerjaan pemulihan barang, barang curian dibawa oleh salah satu dari sekelompok kapal bajak laut di dekat sebuah stasiun. Anda harus merebut kembali kontainernya tanpa menghancurkannya: lumpuhkan kapal pembawanya dengan senjata EMP dan tarik kontainernya dengan sinar traktor. Pemindai yang menampilkan muatan membantu menemukan kapal yang tepat. Kontainer hilang jika kapal pembawanya hancur atau ruang kargo Anda tidak muat. Setelah mendapatkannya, kembalilah ke stasiun tempat Anda mengambil pekerjaan itu untuk dibayar. Pemulihan barang dibayar dua kali lipat.", false],
	],
	"job/4": [
		[0, "", "Perburuan bajak laut berarti membersihkan sarang bajak laut di dekat sebuah stasiun. Para bajak laut menunggu di ladang asteroid atau di sepanjang rute dua atau tiga titik arah, dan baru bergerak saat melihat Anda. Ikuti titik-titik arah dan hancurkan setiap bajak laut. Kesulitan yang lebih tinggi berarti lebih banyak bajak laut.", false],
	],
	"job/5": [
		[0, "", "Pekerjaan penyelamatan adalah misi pembebasan: seorang sandera ditahan di salah satu dari sekelompok kapal di dekat sebuah stasiun. Seperti pada pekerjaan pemulihan barang, lumpuhkan kapal penculik dengan EMP dan gunakan sinar traktor untuk membawa sandera ke kapal Anda; menghancurkan kapal itu mengakhiri pekerjaan. Lalu bawa sandera kembali ke stasiun tempat Anda menerima pekerjaan. Penyelamatan dibayar dua kali lipat.", false],
	],
	"job/6": [
		[0, "", "Pekerjaan buronan menyebut seorang penjahat berbahaya yang terlihat di dekat sebuah stasiun. Sasaran menunggu di titik yang jauh dan baru bereaksi saat Anda terlihat. Sasaran itu jauh lebih tangguh daripada bajak laut biasa, dan makin tangguh seiring kesulitan pekerjaan dan tingkat pilot Anda. Hancurkan untuk mendapatkan hadiahnya.", false],
	],
	"job/7": [
		[0, "", "Pembersihan sampah meminta Anda membersihkan gumpalan sampah antariksa di dekat sebuah stasiun dalam waktu sekitar dua menit. Setiap kepingan harus dihancurkan sebelum waktu habis; pada kesulitan yang lebih tinggi beberapa bajak laut ikut bergabung. Bayarannya lebih kecil daripada kebanyakan pekerjaan, tetapi cepat, dan sampah yang dihancurkan dihitung untuk [[medal/10]].", false],
	],
	"job/8": [
		[0, "", "Pekerjaan pembelian datang dari pembeli di Lounge Luar Angkasa yang menginginkan sejumlah barang tertentu. Dapatkan barangnya, dari toko, pedagang, atau penambangan, lalu berlabuh kembali di stasiun pembeli dengan barang di ruang kargo. Barang diserahkan dan Anda dibayar separuh imbalan pekerjaan biasa ditambah tiga kali nilai rata-rata barang, sehingga pembeli biasanya membayar jauh lebih mahal daripada toko mana pun. Pembeli muncul mulai [[step/16]].", false],
	],
	"job/9": [
		[0, "", "Pekerjaan pengawalan meminta Anda melindungi konvoi lima kapal barang di dekat sebuah stasiun. Saat kapal-kapal barang terus melaju, para penyerang yang menunggu di sepanjang rute mereka mendekat. Hancurkan semua penyerang. Jika semua kapal barang hilang, pekerjaan gagal. Pengawalan dibayar seperlima lebih tinggi daripada kebanyakan pekerjaan.", false],
	],
	"medal/0": [
		[0, "", "[[character/0]] memiliki medali ini sejak awal permainan, atas pengabdiannya di masa lalu. Tidak ada yang perlu dilakukan untuk mendapatkannya.", false],
	],
	"medal/1": [
		[0, "", "Diberikan karena mencapai stasiun dengan sisa lambung yang sangat sedikit. Pemeriksaan dilakukan saat Anda mendekat, sebelum dok memperbaiki kapal, dan memakai kekuatan lambung itu sendiri, bukan pelat zirah. Makin kecil bagian yang tersisa, makin tinggi tingkatannya.", false],
	],
	"medal/10": [
		[0, "", "Diberikan karena menghancurkan sampah antariksa, seperti yang ada dalam pekerjaan [[job/7]]. Setiap kepingan yang Anda tembak dihitung.", false],
	],
	"medal/11": [
		[0, "", "Diberikan untuk jumlah stasiun berbeda tempat Anda pernah berlabuh.", false],
	],
	"medal/12": [
		[0, "", "Diberikan untuk jumlah sistem berbeda yang pernah Anda kunjungi. Sistem tersembunyi dihitung setelah Anda mencapainya.", false],
	],
	"medal/13": [
		[0, "", "Diberikan untuk jumlah cetak biru yang Anda miliki. Cetak biru dibeli dari agen di Lounge Luar Angkasa; lihat [[guide/blueprints]].", false],
	],
	"medal/14": [
		[0, "", "Diberikan untuk jumlah cetak biru berbeda yang pernah Anda selesaikan setidaknya sekali. Membuat barang yang sama lagi tidak menambahnya.", false],
	],
	"medal/15": [
		[0, "", "Diberikan untuk lamanya waktu bermain Anda, dalam jam. Game menghitung waktu yang dihabiskan untuk terbang.", false],
	],
	"medal/16": [
		[0, "", "Diberikan untuk jumlah pekerjaan lepas yang diselesaikan. Pekerjaan yang gagal atau ditinggalkan tidak dihitung.", false],
	],
	"medal/17": [
		[0, "", "Diberikan untuk berapa kali Anda bepergian melalui gerbang lompat. Lompatan dengan mesin lompat tidak dihitung.", false],
	],
	"medal/18": [
		[0, "", "Diberikan untuk jumlah penumpang yang diantar dalam pekerjaan [[job/11]]. Ruang kabin yang lebih banyak berarti kelompok yang lebih besar.", false],
	],
	"medal/19": [
		[0, "", "Diberikan untuk total menit dalam keadaan terselubung. Pasang perangkat selubung dan gunakan setiap kali sudah terisi.", false],
	],
	"medal/2": [
		[0, "", "Diberikan karena menambang berbagai jenis bijih. Setiap jenis dihitung sekali, berapa pun banyaknya yang Anda tambang. Karena ladang berisi bijih yang asalnya berdekatan, Anda perlu menambang di beberapa bagian galaksi.", false],
	],
	"medal/20": [
		[0, "", "Diberikan untuk jumlah bom EMP dan nuklir yang diluncurkan.", false],
	],
	"medal/21": [
		[0, "", "Diberikan untuk jumlah ton [[item/131]] yang dikumpulkan dengan sinar traktor dari bangkai dan kapal yang lumpuh.", false],
	],
	"medal/22": [
		[0, "", "Medali satu tingkatan karena terbang tanpa senjata sama sekali, atau tanpa perlengkapan sama sekali, yang diperiksa saat Anda berlabuh berikutnya. Medali ini tidak dapat diperoleh di awal cerita: sampai [[step/8]] kapal selalu dianggap bersenjata.", false],
	],
	"medal/23": [
		[0, "", "Diberikan untuk jumlah senjata primer yang terpasang sekaligus, diperiksa saat Anda berlabuh. Tingkatan yang lebih tinggi membutuhkan lambung dengan banyak slot primer. Seperti [[medal/22]], medali ini baru dihitung mulai [[step/8]].", false],
	],
	"medal/24": [
		[0, "", "Diberikan untuk jumlah ton muatan yang diambil dari bangkai dan kapal yang lumpuh dengan sinar traktor.", false],
	],
	"medal/25": [
		[0, "", "Diberikan untuk jumlah kredit terbanyak yang pernah Anda miliki sekaligus. Membelanjakan uang sesudahnya tidak menguranginya.", false],
	],
	"medal/26": [
		[0, "", "Diberikan karena berbicara dengan tamu di Lounge Luar Angkasa yang memiliki tawaran. Setiap tamu dihitung sekali, saat pertama kali Anda berbicara dengannya.", false],
	],
	"medal/27": [
		[0, "", "Diberikan untuk jumlah pilot pendamping yang Anda sewa di Lounge Luar Angkasa, menghitung setiap pilot dalam setiap kelompok.", false],
	],
	"medal/28": [
		[0, "", "Medali satu tingkatan karena membuat salah satu dari empat ras besar memusuhi Anda, dengan mendorong salah satu dari dua skala reputasi melewati 60 ke salah satu arah. Lihat [[guide/combat]].", false],
	],
	"medal/29": [
		[0, "", "Diberikan untuk jumlah asteroid yang dihancurkan dengan senjata Anda. Asteroid yang pecah karena penambangan tidak dihitung.", false],
	],
	"medal/3": [
		[0, "", "Diberikan karena menambang berbagai jenis inti. Inti hanya didapat dengan mengebor ketujuh lapisan asteroid kelas A, jadi medali ini menuntut kesabaran dan laser tambang yang baik selain perjalanan.", false],
	],
	"medal/30": [
		[0, "", "Medali satu tingkatan yang diberikan karena menamatkan cerita.", false],
	],
	"medal/31": [
		[0, "", "Diberikan untuk ruang kargo kosong terbanyak yang pernah Anda miliki sekaligus. Lambung besar dengan unit kompresi kargo dan ruang kargo yang kosong meraih tingkatan yang lebih tinggi.", false],
	],
	"medal/32": [
		[0, "", "Diberikan untuk jumlah tawaran yang Anda tolak dengan No, thanks di Lounge Luar Angkasa.", false],
	],
	"medal/33": [
		[0, "", "Diberikan untuk berapa kali Anda meminta tamu di Lounge Luar Angkasa mengulangi tawaran dengan How was that again?", false],
	],
	"medal/34": [
		[0, "", "Diberikan karena menerima pekerjaan di stasiun lain tanpa terlebih dahulu menanyakan kepada klien apakah pekerjaan itu sulit.", false],
	],
	"medal/35": [
		[0, "", "Diberikan karena menerima pekerjaan di stasiun lain tanpa terlebih dahulu meminta klien menunjukkan tujuannya di peta.", false],
	],
	"medal/36": [
		[0, "", "Diberikan secara otomatis setelah Anda memiliki semua medali lain, dalam tingkatan apa pun. Memiliki semuanya juga memberi hadiah lain; lihat [[guide/medals]].", false],
	],
	"medal/4": [
		[0, "", "Diberikan untuk jumlah kapal yang Anda hancurkan, dihitung sepanjang permainan. Bajak laut, musuh, dan sasaran pekerjaan semuanya dihitung.", false],
	],
	"medal/5": [
		[0, "", "Diberikan untuk jumlah ton kiriman yang diantar dalam pekerjaan [[job/0]]. Muatan kurir yang besar bernilai lebih banyak, jadi ruang kargo yang besar membantu.", false],
	],
	"medal/6": [
		[0, "", "Diberikan untuk total ton bijih yang ditambang sepanjang permainan.", false],
	],
	"medal/7": [
		[0, "", "Diberikan untuk jumlah inti yang ditambang sepanjang permainan. Setiap asteroid kelas A yang dibor sampai habis memberi satu inti.", false],
	],
	"medal/8": [
		[0, "", "Diberikan untuk jumlah ton minuman keras yang dibeli dari toko stasiun. Minuman khas setiap sistem dihitung.", false],
	],
	"medal/9": [
		[0, "", "Diberikan karena memiliki berbagai jenis minuman keras. Jenisnya dihitung saat Anda membelinya dari pedagang di Lounge Luar Angkasa atau mengambilnya dari bangkai kapal dengan sinar traktor.", false],
	],
	"ship/0": [
		[0, "", "[[ship/0]] adalah lambung terlemah dalam tabel kapal: zirah 95, ruang kargo 25 t, satu slot primer dan satu slot sekunder, serta tiga slot perlengkapan. Kelincahannya yang 140 cukup baik untuk kapal pemula, tetapi [[ship/32]], lambung termurah yang dijual, memiliki slot yang sama dengan zirah, ruang kargo, dan kelincahan lebih besar. Tidak ada pedagang yang pernah menawarkan [[ship/0]]; kapal ini hanya sampai ke tangan pemain melalui cerita.", false],
		[2, "", "[[character/2]] memiliki bekas kapal [[faction/8|bajak laut]] yang penuh tambalan ini dan menempatkan [[character/0]] di dalamnya di stasiun [[station/78]], dicat dengan warna bajak laut dan dilengkapi laser tambang serta [[item/81]] tetapi tanpa senjata. Laser itu purwarupa buatannya sendiri, rancangan yang kelak ia jual sebagai [[item/90]].", false],
		[10, "", "Setelah penyerbuan sarang bajak laut, [[character/2]] memberikan kapal itu untuk selamanya kepada [[character/0]], dengan penggerak yang lebih kuat untuk perjalanan antarplanet di sistem itu, tetapi menyimpan laser purwarupanya. Keith terus menerbangkannya setelah mencapai wilayah [[faction/0|Terran]].", false],
		[18, "", "Di stasiun [[station/98]], [[character/1]] menyuruh lambungnya dicat ulang dengan warna [[faction/0|Terran]] agar patroli berhenti mengiranya kapal bajak laut.", false],
	],
	"ship/1": [
		[0, "", "[[ship/1]] adalah lambung termurah dengan empat slot sekunder, dan juga memiliki slot turet, dua senjata primer, dan tujuh slot perlengkapan. Zirah (192) dan ruang kargonya (65 t) kokoh. Kelincahannya yang 106 lamban, jadi kapal ini paling baik bertempur dengan torpedo dan turet. Dengan sedikit tambahan uang, [[ship/9]] menawarkan zirah dan kelincahan yang jauh lebih baik tetapi tanpa turet dan hanya dua slot sekunder.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/10": [
		[0, "", "[[ship/10]] adalah kapal milik [[character/0]] sendiri dalam adegan pembuka, dipersenjatai dua laser [[item/3]]. Kapal ini memadukan zirah yang kokoh (200) dan ruang kargo 100 t dengan empat slot sekunder dan kelincahan 150, sehingga jauh lebih lincah daripada [[ship/11]], lambung yang harga daftarnya paling mendekati. Kelemahannya adalah sedikitnya slot perlengkapan: hanya lima. Pedagang biasa tidak pernah menawarkannya.", false],
		[2, "", "Kerusakan hyperdrive membawa [[character/0]] ke stasiun [[station/78]], tempat [[character/2]] mengambil bangkainya dan mempretelinya untuk suku cadang. Kapal itu tidak pernah kembali ke tangannya.", false],
	],
	"ship/11": [
		[0, "", "[[ship/11]] adalah kapal barang berat yang lengkap: ruang kargo 180 t, zirah 210, slot turet, dua slot primer dan dua slot sekunder, dan delapan slot perlengkapan. Kelincahannya yang 75 buruk. Dibandingkan [[ship/7]] yang lebih murah, kapal ini mengorbankan ruang kargo 60 t demi satu slot sekunder dan satu slot perlengkapan tambahan.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/12": [
		[0, "", "[[ship/12]] adalah pesawat tempur yang dirancang di sekitar senjata sekundernya: tiga slot sekunder, dua senjata primer, enam slot perlengkapan, zirah 175, dan kelincahan 132. Ruang kargonya yang 30 t sangat kecil, sehingga kurang cocok untuk berdagang atau menambang. [[ship/30]] lebih mahal dan menawarkan zirah lebih tipis serta slot sekunder kurang satu.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/16": [
		[0, "", "[[ship/16]] adalah pesawat tempur yang mengandalkan misil, dengan empat slot sekunder, dua senjata primer, sepuluh slot perlengkapan, zirah 180, dan kelincahan 120. Ruang kargonya yang 45 t kecil. [[ship/21]] yang lebih mahal menambahkan dua senjata primer lagi dan satu slot perlengkapan.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/17": [
		[0, "", "[[ship/17]] membawa empat senjata primer, dua slot sekunder, dan sepuluh slot perlengkapan. Untuk kapal seharga itu, zirahnya (145), ruang kargonya (65 t), dan kelincahannya (95) lemah, sehingga kapal ini mengandalkan perlengkapannya, terutama perisai dan pelat zirah. [[ship/19]] yang lebih murah memiliki zirah dan ruang kargo lebih besar dengan slot perlengkapan kurang satu.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/18": [
		[0, "", "[[ship/18]] adalah kapal kecil yang lincah (kelincahan 145) dengan delapan slot perlengkapan; tidak ada lambung yang lebih murah dengan slot sebanyak itu. Zirahnya yang 115 dan ruang kargonya yang 28 t tergolong buruk, dan kapal ini hanya memiliki dua slot primer dan dua slot sekunder. Kapal ini cocok bagi pilot yang mengandalkan perisai, selubung, dan perlengkapan lain daripada zirah.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/19": [
		[0, "", "[[ship/19]] adalah kapal meriam berat dengan empat slot primer, dua slot sekunder, sembilan slot perlengkapan, zirah 225, dan ruang kargo 105 t. Kelincahannya yang 90 lamban. Inilah satu-satunya kapal dengan empat senjata depan dan ruang kargo lebih dari 100 t.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/2": [
		[0, "", "[[ship/2]] adalah kapal serbaguna yang lincah di antara lambung-lambung murah: zirah 155, ruang kargo 52 t, satu slot primer dan dua slot sekunder, empat slot perlengkapan, dan kelincahan 150. Kapal ini setara dengan [[ship/35]] dalam segala hal kecuali ruang kargo, yang 12 t lebih besar. Pilot yang menginginkan senjata kedua sebaiknya melirik [[ship/5]] atau [[ship/6]].", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/20": [
		[0, "", "[[ship/20]] adalah pesawat tempur ringan yang menjejalkan enam slot perlengkapan ke dalam lambung kecil yang gesit (kelincahan 155). Kapal ini membawa dua senjata primer tetapi hanya satu slot sekunder, zirah 125, dan ruang kargo 25 t, terkecil dalam tabel bersama [[ship/0]]. Kapal ini cocok bagi pilot yang ingin segera memasang perisai, booster, dan perlengkapan lain dan tidak berniat mengangkut muatan.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/21": [
		[0, "", "[[ship/21]] adalah lambung termurah dengan empat slot primer dan empat slot sekunder. Kapal ini juga memiliki sebelas slot perlengkapan, zirah 195, dan ruang kargo 70 t. Kelincahannya yang 100 rata-rata. Inilah kapal tempur lengkap satu tingkat di bawah [[ship/29]].", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/22": [
		[0, "", "[[ship/22]] memiliki ruang kargo terbesar di antara kapal seharga lebih dari satu juta kredit (130 t), bersama tiga slot primer dan tiga slot sekunder, sembilan slot perlengkapan, dan kelincahan 118. Zirahnya yang 160 rendah untuk harganya. Kapal ini cocok bagi pilot yang berdagang dan bertempur dengan kapal yang sama.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/23": [
		[0, "", "[[ship/23]] adalah lambung termurah dengan slot turet, dan zirahnya yang 205 adalah yang tertinggi di antara kapal di bawah 100.000 kredit. Kapal ini juga memiliki dua slot primer dan dua slot sekunder, lima slot perlengkapan, ruang kargo 55 t, dan kelincahan 128, sehingga menjadi kapal serbaguna kelas menengah yang kokoh. Keterbatasan utamanya adalah sedikitnya slot perlengkapan.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/24": [
		[0, "", "[[ship/24]] adalah kapal dagang bersenjata: tiga senjata primer, dua slot sekunder, sebuah turet, delapan slot perlengkapan, dan ruang kargo 95 t. Zirahnya yang 170 rata-rata, sedangkan kelincahannya yang 125 baik untuk kapal yang mengangkut sebanyak itu. Kapal ini sama baiknya untuk berdagang, menambang, dan bertempur.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/25": [
		[0, "", "[[ship/25]] adalah kapal pembawa misil: empat slot sekunder, delapan slot perlengkapan, dan kelincahan 130, tetapi hanya satu senjata primer. Zirahnya yang 124 dan ruang kargonya yang 52 t lemah untuk harganya, sehingga kapal ini bergantung pada torpedo dan perisai. [[ship/1]] menawarkan jumlah slot sekunder yang sama ditambah turet dengan sepertiga harganya, meskipun slot perlengkapannya lebih sedikit.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/26": [
		[0, "", "[[ship/26]] adalah lambung termurah dengan tujuh slot perlengkapan. Selain itu, kapal ini serbaguna dengan kemampuan rata-rata: zirah 152, ruang kargo 64 t, dua slot primer dan dua slot sekunder, dan kelincahan 108. Kapal ini cocok bagi pilot yang menginginkan perlengkapan lengkap sebelum mampu membeli kapal yang lebih berat.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/27": [
		[0, "", "[[ship/27]] adalah lambung termurah dengan tiga slot primer. Slot-slot itu dipadukan dengan zirah 176, dua slot sekunder, enam slot perlengkapan, dan ruang kargo 50 t. Kelincahannya yang 113 agak lamban, jadi kapal ini lebih cocok untuk adu tembak daripada mengungguli musuh dalam bermanuver.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/28": [
		[0, "", "[[ship/28]] adalah kapal serbaguna paling lengkap yang dijual: tiga slot primer dan empat slot sekunder, sebuah turet, dua belas slot perlengkapan, dan ruang kargo 110 t. Tidak ada kapal lain yang dapat dibeli dengan turet dan slot perlengkapan sebanyak itu. Zirahnya yang 195 baik dan kelincahannya yang 92 lamban. [[ship/29]] bertempur lebih baik tetapi mengangkut jauh lebih sedikit.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/29": [
		[0, "", "[[ship/29]] adalah kapal termahal yang dijual pedagang biasa dan pesawat tempur terbaik mereka: empat slot primer dan empat slot sekunder, dua belas slot perlengkapan, zirah 240, dan kelincahan 118. Ruang kargonya yang 75 t sederhana, dan kapal ini tidak memiliki turet. Hanya [[ship/8]] yang mengunggulinya dalam pertempuran.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/3": [
		[0, "", "[[ship/3]] adalah kapal serbaguna awal yang seimbang: dua slot primer dan dua slot sekunder, lima slot perlengkapan, zirah 135, dan ruang kargo 55 t. Kelincahannya yang 112 tergolong lamban untuk kapal kecil. Harganya kira-kira sama dengan [[ship/6]], yang berbelok jauh lebih cepat tetapi zirahnya lebih tipis, ruang kargonya lebih kecil, dan slot sekundernya kurang satu.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/30": [
		[0, "", "[[ship/30]] adalah pesawat tempur yang serba sedang: zirah 165, ruang kargo 45 t, dua slot primer dan dua slot sekunder, enam slot perlengkapan, dan kelincahan 128. Untuk harganya, kapal ini tidak memiliki keunggulan khusus; [[ship/12]] yang lebih murah memiliki zirah lebih tebal dan slot sekunder tambahan, dan [[ship/23]] menambahkan turet.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/31": [
		[0, "", "[[ship/31]] adalah kapal barang ringan dengan ruang kargo 110 t, slot turet, dua senjata primer, dan enam slot perlengkapan. Zirahnya (156), satu slot sekundernya, dan kelincahannya yang 102 tergolong biasa. Kapal ini bersaing dengan [[ship/33]] yang lebih murah, yang ruang kargonya sedikit lebih kecil dan senjatanya kurang satu tetapi zirahnya lebih tebal dan kelincahannya lebih baik.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/32": [
		[0, "", "[[ship/32]] adalah lambung termurah yang dijual pedagang mana pun dan biasanya menjadi pembelian pertama. Kapal ini kecil dan berpelindung tipis (zirah 100, ruang kargo 30 t, satu slot primer dan satu slot sekunder, tiga slot perlengkapan), tetapi dengan kelincahan 160 hanya [[ship/4]] yang berbelok lebih cepat. Dibandingkan [[ship/0]], kapal ini menambah sedikit zirah dan ruang kargo serta lebih lincah. [[ship/35]] berharga sekitar 8.000 kredit lebih mahal dan membawa zirah yang jauh lebih baik, slot sekunder kedua, dan slot perlengkapan keempat.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/33": [
		[0, "", "[[ship/33]] adalah lambung termurah dengan ruang kargo lebih dari 100 t (108 t), ditambah slot turet, zirah 176, dan enam slot perlengkapan. Dengan hanya satu senjata primer dan kelincahan 112, kapal ini lebih merupakan kapal dagang yang mampu membela diri daripada pesawat tempur. [[ship/31]] adalah saingan dekatnya dengan senjata kedua dan ruang kargo sedikit lebih besar, tetapi lebih lemah dan lebih lamban.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/34": [
		[0, "", "[[ship/34]] adalah kapal meriam dengan empat slot primer, satu slot sekunder, enam slot perlengkapan, ruang kargo 60 t, dan kelincahan 130. Dibandingkan [[ship/4]] yang lebih murah, kapal ini mengorbankan zirah (135 lawan 170) dan kelincahan demi ruang kargo yang lebih besar dan satu slot perlengkapan tambahan.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/35": [
		[0, "", "[[ship/35]] adalah pesawat tempur ringan di urutan bawah daftar harga. Untuk harganya, kapal ini menawarkan zirah yang baik (155), satu slot primer dan dua slot sekunder, empat slot perlengkapan, dan kelincahan tinggi 150, tetapi hanya ruang kargo 40 t. [[ship/2]] hampir sama dengan tambahan ruang kargo 12 t dengan harga beberapa ribu kredit lebih mahal, sedangkan [[ship/5]] mengorbankan kelincahan demi zirah, ruang kargo, dan senjata kedua.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/36": [
		[0, "", "[[ship/36]] adalah kapal barang terbesar dalam permainan, dengan ruang kargo 350 t. Kapal ini sama sekali tidak memiliki slot primer dan harus mengandalkan empat slot sekunder dan sebuah turet untuk pertahanan. Tujuh slot perlengkapan dan zirah 200 tergolong baik, tetapi kelincahannya yang 45 adalah yang terendah dalam tabel. [[ship/7]] mengangkut lebih sedikit tetapi tetap memiliki dua senjata depan dan berbelok lebih baik.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/4": [
		[0, "", "[[ship/4]] adalah lambung termurah dengan empat slot primer, dan dengan kelincahan 162 kapal ini adalah yang paling lincah dalam permainan. Zirahnya yang 170 baik untuk harganya. Konsekuensinya adalah ruang kargo 38 t, satu slot sekunder saja, dan lima slot perlengkapan, sehingga kapal ini murni untuk pertempuran jarak dekat. [[ship/34]] juga membawa empat senjata, dengan ruang kargo dan slot perlengkapan lebih banyak tetapi zirah dan kelincahan lebih rendah.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/5": [
		[0, "", "[[ship/5]] adalah lambung termurah dengan dua slot primer, dan zirahnya yang 170 tergolong tinggi untuk harganya. Ruang kargo 60 t membuatnya berguna juga untuk berdagang dan menambang di awal. Kekurangannya adalah satu slot sekunder saja, hanya empat slot perlengkapan, dan kelincahan lamban 115. Pilot yang lebih mengutamakan kelincahan daripada zirah memilih [[ship/2]] atau [[ship/35]] dengan harga serupa.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/6": [
		[0, "", "[[ship/6]] adalah pesawat tempur ringan dan cepat dengan dua slot primer, satu slot sekunder, lima slot perlengkapan, dan kelincahan 148. Zirahnya yang 105 sangat tipis; hanya [[ship/0]] dan [[ship/32]] yang lebih rendah, jadi kapal ini mengandalkan kecepatan, bukan ketangguhan. Dengan harga yang hampir sama, [[ship/3]] menawarkan zirah lebih tebal, ruang kargo lebih besar, dan slot sekunder kedua, dengan mengorbankan kelincahan.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/7": [
		[0, "", "[[ship/7]] adalah kapal barang berat dengan ruang kargo 240 t, zirah 220, slot turet, dua senjata primer, satu slot sekunder, dan tujuh slot perlengkapan. Dengan kelincahan 65, kapal ini lamban berbelok. Dibandingkan [[ship/36]], kapal ini mengorbankan ruang kargo 110 t demi senjata depan dan kelincahan yang lebih baik; [[ship/11]] yang lebih mahal menambahkan satu slot perlengkapan dan slot sekunder kedua.", false],
		[0, "", "Pedagang mana pun di luar sistem [[faction/1|Vossk]] dapat menyediakannya.", false],
	],
	"ship/8": [
		[0, "", "[[ship/8]] adalah pesawat tempur [[faction/9|Void]] yang dipulihkan dan kapal terkuat dalam permainan. Zirahnya yang 450 hampir dua kali lipat lambung lain mana pun, kapal ini memiliki empat slot primer dan empat slot sekunder serta lima belas slot perlengkapan, dan kelincahannya yang 155 termasuk yang terbaik. Satu-satunya kelemahan adalah ruang kargo 30 t. Harga daftarnya yang lebih dari delapan juta kredit hampir dua kali lipat [[ship/29]].", false],
		[0, "", "Pedagang biasa tidak menjualnya. Kapal ini hanya ditawarkan di stasiun [[station/10]], sebagai purwarupa, setelah pemain memiliki semua medali dalam tingkat emas (lihat [[guide/medals]]).", false],
	],
	"ship/9": [
		[0, "", "[[ship/9]] adalah satu-satunya kapal yang dijual pedagang [[faction/1|Vossk]], dan mereka tidak menjual yang lain. Zirahnya yang 250 adalah yang tertinggi di antara semua lambung kecuali [[ship/8]], dan kapal ini memadukannya dengan kelincahan tinggi 152, dua slot primer dan dua slot sekunder, tujuh slot perlengkapan, dan ruang kargo 65 t. Untuk harganya, inilah pesawat tempur paling tangguh yang tersedia, meskipun tidak memiliki turet dan slot tambahan seperti [[ship/1]].", false],
		[36, "", "[[character/7]] menjelaskan bahwa kapal [[faction/1|Vossk]] biasanya hanya diterbangkan oleh ras mereka sendiri; kapal ini pengecualiannya, rancangan yang disesuaikan agar dapat dijual kepada ras lain.", false],
	],
	"station/0": [
		[0, "", "[[station/0]] membawa gerbang lompat [[system/0]]. Masa menunggu di [[step/13]] tercatat di bawah stasiun ini, tetapi tahap itu diselesaikan dengan menuntaskan pekerjaan lounge di mana saja, dan tidak ada yang terjadi di sini.", false],
	],
	"station/10": [
		[0, "", "[[station/10]] adalah satu-satunya stasiun di [[system/6]] dan membawa gerbang lompatnya. Pekerjaan lepas tidak pernah mengirim Anda ke sini. Agen [[agent/3]] menjual cetak biru di lounge-nya, dan begitu semua medali berwarna emas, stasiun ini menawarkan purwarupa [[ship/8]].", false],
		[23, "", "Stasiun ini adalah pangkalan riset rahasia Deep Science yang dipimpin oleh [[character/6]]. [[character/0]] tiba di sana bersama [[character/5]] di [[step/23]] dan kembali beberapa kali: untuk merencanakan ekspedisi ke para Void, untuk menemui [[character/20]], dan untuk menyerahkan kristal-kristalnya.", false],
	],
	"station/18": [
		[0, "", "[[station/18]] adalah stasiun Vossk sederhana di [[system/3]]. Agen [[agent/12]] menjual koordinat [[system/0]] di lounge-nya.", false],
	],
	"station/20": [
		[0, "", "[[station/20]] membawa gerbang lompat [[system/4]]. Agen Midorian [[agent/2]] menjual cetak biru senjata di lounge-nya.", false],
	],
	"station/22": [
		[0, "", "[[station/22]] adalah stasiun paling canggih di [[system/4]].", false],
		[38, "", "Di [[step/38]] konvoi pembawa bahan peledak Nivelian terlihat di dekat stasiun ini dengan pengawalan pesawat tempur Midorian. [[character/0]] harus mengusir para pengawal tanpa menghancurkan konvoi.", false],
	],
	"station/26": [
		[0, "", "[[station/26]] adalah stasiun Vossk berteknologi tertinggi di [[system/5]]. Agen Bobolian [[agent/13]] menjual koordinat [[system/1]] di lounge-nya.", false],
	],
	"station/27": [
		[36, "", "Di dekat [[station/27]], [[character/7]] dan [[character/0]] menyerbu sarang bajak laut di [[step/36]]; siapa yang menghancurkan lebih banyak bajak laut, dialah pemenangnya.", false],
		[37, "", "[[character/0]] menang dan mendapatkan hak untuk mengawal kapal barang Vossk. Dari sini ia melapor kepada [[character/1]].", false],
	],
	"station/29": [
		[35, "", "[[station/29]] adalah stasiun komandan Vossk [[character/7]], yang telah setuju menyediakan kapal barang K'Sarr untuk serangan terhadap para Void. [[character/0]] menemuinya di sini di [[step/35]].", false],
		[36, "", "[[character/7]] menolak membiarkan siapa pun selain seorang Vossk menerbangkan kapal barang itu dan menantang [[character/0]] untuk membuktikan dirinya sebagai pilot pengawal.", false],
	],
	"station/3": [
		[0, "", "[[station/3]] adalah stasiun Nivelian berteknologi tinggi di sistem tersembunyi [[system/0]]. Lounge-nya menjadi tempat agen [[agent/0]], yang menjual cetak biru senjata.", false],
	],
	"station/30": [
		[34, "", "[[character/1]] menunggu di stasiun [[station/30]] di [[step/34]] dengan rencana melawan kapal induk Void.", false],
		[35, "", "Rencananya adalah menerbangkan kapal barang berat penuh bahan peledak nuklir Nivelian ke dalam kapal induk.", false],
		[39, "", "Bahan peledak yang berhasil direbut kembali tiba di sini dan dimuat ke kapal barang Vossk. Di [[step/39]] [[character/1]] menjelaskan operasi terakhir.", false],
	],
	"station/43": [
		[0, "", "[[station/43]] adalah stasiun Terran kecil di [[system/8]]. Agen [[agent/4]] menjual cetak biru roket murah di lounge-nya.", false],
	],
	"station/48": [
		[24, "", "Kapal-kapal Void terlihat di dekat stasiun [[station/48]]. Di [[step/24]] [[character/0]] membawa [[character/6]] ke sini untuk mengamati mereka dan mengumpulkan puing dengan sinar traktor.", false],
		[25, "", "Di akhir pengumpulan puing, sebuah lubang cacing menelan kapal [[character/0]] bersama [[character/6]] di dalamnya.", false],
		[27, "", "Ketika mereka kembali melalui lubang cacing lain, pesawat tempur Void membuntuti mereka, dan [[character/0]] harus menghancurkannya di sini sebelum kembali ke stasiun [[station/10]].", false],
	],
	"station/54": [
		[0, "", "[[station/54]] adalah stasiun Vossk berteknologi tertinggi di [[system/10]], sistem yang hanya dapat dicapai dengan mesin lompat. Agen Vossk [[agent/5]] menjual cetak biru misil di lounge-nya.", false],
	],
	"station/55": [
		[0, "", "[[station/55]] membawa gerbang lompat [[system/11]].", false],
		[19, "", "Bajak laut yang menyandera [[character/5]] untuk tebusan ditemukan di dekat stasiun ini. Deep Science menitipkan bom EMP di hanggarnya untuk [[character/0]].", false],
		[22, "", "Setelah penyelamatan, [[character/0]] menemui perwira yang telah dibebaskan itu di stasiun dan menerima koordinat [[system/6]].", false],
	],
	"station/56": [
		[18, "", "[[station/56]] adalah titik pertemuan tempat [[character/0]] seharusnya menjemput seorang perwira Deep Science di [[step/18]].", false],
		[19, "", "Perwira itu tidak pernah datang. Sebaliknya, pesan dari [[character/1]] melaporkan bahwa bajak laut telah menculiknya.", false],
	],
	"station/59": [
		[0, "", "[[station/59]] adalah stasiun kecil di sistem Vossk [[system/20]]. Lounge-nya menjadi tempat seorang Terran, agen [[agent/10]], yang menjual cetak biru perangkat selubung.", false],
	],
	"station/61": [
		[0, "", "[[station/61]] adalah salah satu dari hanya dua stasiun di [[system/12]]. Agen Multipod [[agent/6]] menjual cetak biru senjata nuklir di lounge-nya.", false],
	],
	"station/65": [
		[0, "", "[[station/65]] membawa gerbang lompat [[system/13]]. Agen Cyborg [[agent/14]] menjual koordinat [[system/10]] di lounge-nya.", false],
	],
	"station/72": [
		[0, "", "[[station/72]] adalah stasiun Terran kecil di sistem aman [[system/14]]. Agen [[agent/7]] menjual cetak biru perisai di lounge-nya.", false],
	],
	"station/76": [
		[11, "", "[[station/76]] adalah stasiun di [[system/15]] yang tidak lagi menjawab panggilan. Di [[step/11]] [[character/3]] mengutus [[character/0]] untuk mencari tahu sebabnya.", false],
		[12, "", "Stasiun itu tidak rusak. Awaknya hanya tidak dalam keadaan mampu bekerja, gara-gara satu muatan neuro-alga yang dibawa pedagang [[character/4]], kenalan lama [[character/0]].", false],
	],
	"station/78": [
		[0, "", "[[station/78]] adalah stasiun tambang kecil milik pedagang bijih Nivelian [[character/2]] di [[system/15]]. Cerita dimulai di orbitnya.", false],
		[1, "", "Kapal [[character/0]] yang rusak terapung ke sini dengan autopilot, dan [[character/2]] menariknya masuk berikut pilotnya.", false],
		[2, "", "[[character/2]] mempreteli bangkai kapal itu dan menyuruh [[character/0]] menambang bijih di asteroid sekitar dengan [[ship/0]].", false],
		[8, "", "Setelah lolos dari serangan bajak laut, [[character/0]] memasang senjata pertamanya dan membantu [[character/2]] menghancurkan sarang bajak laut di dekat stasiun.", false],
		[10, "", "[[character/2]] kemudian memberinya kapal itu dan mengutusnya ke stasiun [[station/79]].", false],
		[0, "", "Belakangan dalam permainan, [[character/2]] menjual cetak biru bor tambangnya di lounge stasiun ini.", false],
	],
	"station/79": [
		[0, "", "[[station/79]] adalah stasiun di [[system/15]] dan kedudukan komandannya, [[character/3]].", false],
		[10, "", "[[character/2]] mengutus [[character/0]] ke sini di [[step/9]] untuk menemui [[character/3]], seorang manusia yang mungkin dapat membantunya mencapai wilayah Terran.", false],
		[11, "", "[[character/3]] menjelaskan tentang [[faction/3|Konfederasi Mido]] dan memintanya memeriksa stasiun [[station/76]] sebagai imbalan atas bantuannya.", false],
		[13, "", "Setelah laporan dari stasiun [[station/76]], [[character/3]] berjanji menghubungkannya dengan konvoi Terran yang dijadwalkan tiba di stasiun.", false],
		[15, "", "Ketika konvoi tiba di [[step/14]], mereka mengira [[character/0]] bajak laut, melumpuhkan kapalnya, dan membawanya naik ke kapal mereka.", false],
	],
	"station/8": [
		[0, "", "[[station/8]] adalah stasiun Terran di sistem tersembunyi [[system/1]]. Agen Nivelian [[agent/1]] menjual cetak biru di lounge-nya.", false],
	],
	"station/84": [
		[0, "", "[[station/84]] adalah stasiun Terran di [[system/16]]. Agen Vossk [[agent/8]] menjual cetak biru zirah Vossk di lounge-nya.", false],
	],
	"station/88": [
		[0, "", "[[station/88]] adalah stasiun Nivelian kecil di [[system/17]]. Agen Vossk [[agent/15]] menjual koordinat [[system/21]] di lounge-nya.", false],
	],
	"station/90": [
		[0, "", "[[station/90]] membawa gerbang lompat [[system/18]]. Agen [[agent/9]] menjual cetak biru kompresor kargo di lounge-nya.", false],
	],
	"station/91": [
		[28, "", "Aktivitas Void dilaporkan di dekat stasiun [[station/91]] di [[step/28]]. [[character/0]] bertempur menembus jalan ke sebuah lubang cacing di sini untuk membawa wahana ke kapal induk Void.", false],
		[31, "", "Sekembalinya dari sektor Void, [[character/0]] menerima panggilan dari [[character/1]] di sini, yang mengundangnya ke stasiun [[station/98]].", false],
	],
	"station/98": [
		[15, "", "[[station/98]] adalah stasiun Terran di [[system/19]]. Kapal penjelajah yang menangkap [[character/0]] membawanya ke sini, dan ia mendapati kawan lamanya [[character/1]] sebagai pemimpinnya.", false],
		[16, "", "Pesawat tempur Void menyerang stasiun di tengah percakapan mereka, dan [[character/0]] membantu mengusirnya.", false],
		[18, "", "[[character/1]] memberinya penjelasan tentang para Void dan merekrutnya untuk Deep Science.", false],
		[32, "", "Di [[step/31]] [[character/1]] memasang sistem peringatan dini pada kapal [[character/0]] dan menceritakan tentang [[character/20]].", false],
		[44, "", "Setelah kemenangan, [[character/0]] dan [[character/1]] merayakannya di stasiun ini, dan [[character/6]] bergabung dengan mereka.", false],
		[45, "", "Keesokan paginya [[character/6]] sudah pergi, meninggalkan sepucuk catatan dan pembayaran terakhir dari Deep Science.", false],
	],
	"step/0": [
		[0, "", "[[character/0]] mengejar sekawanan [[faction/8|bajak laut]] melintasi sabuk asteroid demi hadiah atas kepala mereka. Anda harus menemukan dan menghancurkan setiap kapal bajak laut.", false],
		[1, "", "Setelah para bajak laut beres, Keith mengarahkan kapalnya ke Eden Prime, tempat Laksamana Smith ingin menemuinya untuk sebuah tugas khusus. Saat hyperdrive menyala, sebuah tembakan perpisahan merusak kapalnya. Penggeraknya gagal, sistem penunjang hidup lumpuh, dan autopilot membawa pilot yang pingsan itu menuju stasiun terdekat, [[station/78]].", false],
	],
	"step/1": [
		[1, "", "Autopilot telah membawa kapal Keith yang rusak ke orbit stasiun [[station/78]], dengan pilotnya tak sadarkan diri di dalam.", false],
		[2, "", "Keith terbangun di sebuah stasiun tambang kecil milik [[character/2]], seorang pedagang bijih [[faction/2]]. Gunant telah membongkar kapal itu dan mengklaimnya sebagai hak penyelamat. Ia menertawakan gagasan untuk mencapai Eden Prime, yang terletak di ujung lain galaksi, dan heran bahwa Keith belum pernah mendengar tentang para Void, makhluk bermusuhan yang kini muncul bahkan di sistem [[system/15]].", false],
		[2, "", "Keith tidak punya uang maupun kapal, jadi ia harus bekerja untuk Gunant dengan menambang bijih menggunakan kapal tanpa senjata.", false],
	],
	"step/10": [
		[10, "", "Keith terbang ke stasiun [[station/79]] untuk menemui [[character/3]].", false],
		[11, "", "Norris menjelaskan bahwa [[system/15]] terletak di sektor yang baru ditemukan. Orang-orang buangan Terran dan Nivelian menetap di sana semasa Perang Saudara Nivelian dan mendirikan konfederasi merdeka. Bangsa Terran menerimanya, tetapi bangsa Nivelian masih mengklaim sistem itu, sehingga terjadi pertempuran di wilayah pinggirannya.", false],
		[11, "", "Norris menawarkan untuk menghubungkan Keith dengan Armada Luar Angkasa Terran sebagai imbalan atas sebuah bantuan: kontak dengan stasiun [[station/76]] telah terputus, dan seorang pilot berpengalaman harus mencari tahu sebabnya.", false],
	],
	"step/11": [
		[11, "", "Keith terbang ke stasiun [[station/76]] untuk menyelidiki kebisuannya. Stasiun itu tampak utuh, tanpa tanda-tanda pertempuran, jadi ia berlabuh.", false],
		[12, "", "Di dalam, Keith bertemu [[character/4]], pedagang terkenal yang ia kenal dulu sekali. Mkkt telah membawa masuk satu muatan neuro-alga, dan seluruh awak terlalu mabuk untuk mengoperasikan komunikasi. Keith pergi secepat mungkin.", false],
	],
	"step/12": [
		[12, "", "Keith kembali ke stasiun [[station/79]] untuk melapor.", false],
		[13, "", "Norris terkejut dan berjanji akan menindak pedagang itu. Sebuah konvoi militer Terran sedang menuju Kernstal dan akan memberi Keith kesempatan untuk menghubungi armada. Sampai konvoi tiba, Norris menyarankan Keith mengambil pekerjaan berbayar di Lounge Luar Angkasa (lihat [[guide/lounge]]).", false],
	],
	"step/13": [
		[13, "", "Sambil menunggu konvoi, Keith harus menyelesaikan dua pekerjaan lepas dari Lounge Luar Angkasa (lihat [[guide/jobs]]).", false],
		[14, "", "Norris melaporkan bahwa konvoi Terran telah memasuki sistem dan sedang menuju stasiun [[station/79]]. Keith berangkat untuk menyambutnya.", false],
	],
	"step/14": [
		[14, "", "Di dekat stasiun [[station/79]] Keith menemukan konvoi Terran dan beberapa bajak laut. Ia mendekat untuk mengusir para bajak laut.", false],
		[15, "", "Karena terbang dengan bekas kapal bajak laut, Keith dikira salah satu perampok. Konvoi melumpuhkan kapalnya dengan senjata EMP dan menangkapnya. Ia dibawa naik ke sebuah kapal penjelajah Terran yang menuju stasiun [[station/98]] di wilayah Terran.", false],
	],
	"step/15": [
		[15, "", "Keith tiba di stasiun [[station/98]] sebagai tahanan konvoi.", false],
		[16, "", "Perwira yang bertanggung jawab adalah [[character/1]], kawan lama Keith yang kini menjabat kepala Badan Keamanan Antarbintang. Ia meminta maaf atas kekeliruan itu. Reuni mereka terputus ketika pesawat tempur Void muncul di orbit dan stasiun membunyikan tanda bahaya.", false],
	],
	"step/16": [
		[16, "", "Brent meminta Keith membantu mengusir kapal-kapal [[faction/9|Void]] yang menyerang stasiun [[station/98]] (lihat [[world/voids]]).", false],
		[17, "", "Para Void menyiarkan pesan yang menyatakan niat damai, tetapi tetap saja menyerang. Keith memukul mundur mereka, dan Brent berjanji akan menceritakan semua yang ia ketahui sambil minum segelas anggur.", false],
	],
	"step/17": [
		[17, "", "Keith berlabuh di stasiun [[station/98]] untuk mendengar apa yang Brent ketahui tentang para Void.", false],
		[18, "", "Para Void mulai muncul dalam beberapa minggu terakhir. Mereka datang melalui semacam lubang cacing, menyerang apa pun yang mereka temui, dan tampaknya mengincar bijih; bahkan sistem milik [[faction/1]] pun diserbu. Brent memimpin tim krisis, dan para ilmuwannya berkumpul di stasiun riset rahasia yang dikelola Deep Science. Ia meminta Keith terbang untuk mereka.", false],
		[18, "", "Sistem tempat stasiun itu berada tidak tercantum di peta bintang standar, jadi Keith harus menemui Letnan Thomas Boyle ([[character/5]]) di stasiun [[station/56]] dalam sistem [[system/11]] untuk mendapatkan koordinatnya. Brent juga mengakui bahwa kapal Keith bukan kapal baru: kapal itu hanya dicat ulang agar tidak terjadi salah paham lagi.", false],
	],
	"step/18": [
		[18, "", "Keith terbang ke stasiun [[station/56]] untuk menemui Boyle.", false],
		[19, "", "Boyle tidak pernah tiba. Brent melaporkan bahwa bajak laut telah menculiknya di dekat stasiun [[station/55]] dan menuntut tebusan lima juta kredit. Brent siap membayar, tetapi Keith menduga para penculik akan membunuh Boyle setelah dibayar, sehingga ia malah menuju Kappa.", false],
	],
	"step/19": [
		[19, "", "Keith terbang ke stasiun [[station/55]] untuk mencari para penculik.", false],
		[20, "", "Pemindai Kappa menemukan kapal para penculik. Brent telah menitipkan bom EMP di hanggar stasiun, agar Keith dapat melumpuhkan kapal itu sementara para penculik mengira ia datang membawa tebusan.", false],
	],
	"step/2": [
		[2, "", "Gunant memberi Keith sebuah kapal tua yang sudah berkali-kali diperbaiki, [[ship/0]], bekas kapal bajak laut yang dilengkapi laser tambang tanpa senjata. Keith harus menambang setidaknya sepuluh ton bijih dari asteroid di dekat stasiun [[station/78]] (lihat [[guide/mining]]).", false],
		[3, "", "Setelah bijih termuat, Gunant menyuruhnya berlabuh agar muatannya diperiksa. Tanpa senjata, Keith tidak punya pilihan selain menurut.", false],
	],
	"step/20": [
		[20, "", "Keith harus berlabuh di stasiun [[station/55]] dan memasang bom EMP pada kapalnya.", false],
		[21, "", "Setelah bom terpasang, Keith segera berangkat.", false],
	],
	"step/21": [
		[21, "", "Sebuah titik arah menandai kapal para penculik, yang mungkin tidak sendirian. Keith harus melumpuhkannya dengan bom EMP alih-alih menghancurkannya, dan menghadapi kapal pengawal yang ada.", false],
		[22, "", "Para penculik mengira tebusan telah tiba sampai bom itu mematikan sistem mereka. Brent mengirim satu regu untuk menjemput Boyle.", false],
	],
	"step/22": [
		[22, "", "Keith berlabuh di stasiun [[station/55]] untuk menemui ilmuwan yang telah diselamatkan.", false],
		[23, "", "Boyle berterima kasih kepadanya. Kapalnya sendiri telah hilang, jadi Keith menawarinya tumpangan, dan Boyle mengirimkan koordinat sistem [[system/6]], tempat stasiun riset berada, ke komputer navigasi Keith.", false],
	],
	"step/23": [
		[23, "", "Keith mengantar Boyle ke stasiun [[station/10]] di sistem [[system/6]], tempat Dr. Paolini menanti mereka.", false],
		[24, "", "Keith bertemu Dr. Carla Paolini ([[character/6]]), pemimpin proyek Deep Science. Ia ingin mempelajari teknologi Void, dimulai dari puing kapal-kapal Void. Deep Science membayar Keith 20.000 kredit untuk memperlengkapi kapalnya, dan sinar traktor mutlak diperlukan.", false],
		[24, "", "Carla bersikeras ikut terbang bersamanya ke stasiun [[station/48]] di sistem [[system/9]], tempat para Void baru-baru ini terlihat. Keith keberatan, tetapi akhirnya mengalah.", false],
	],
	"step/24": [
		[24, "", "Di stasiun [[station/48]] Carla ingin melihat para Void sedekat mungkin. Para Void mengumumkan bahwa mereka datang dari masa depan dan merupakan sisa terakhir peradaban-peradaban galaksi. Keith harus melawan mereka dan mengumpulkan sisa-sisa kapal mereka dengan sinar traktor.", false],
		[25, "", "Setelah cukup banyak puing termuat, Carla meminta kembali, tetapi tiba-tiba sesuatu mencengkeram kapal.", false],
	],
	"step/25": [
		[25, "", "Keith dan Carla siuman jauh dari stasiun [[station/48]], di wilayah ruang angkasa yang tidak dikenal keduanya.", false],
		[26, "", "Sebuah kapal induk Void raksasa berada di dekat mereka, meluncurkan pesawat-pesawat tempur. Keith menyimpulkan bahwa mereka telah melewati lubang cacing ke sektor asal para Void. Lubang cacing itu sudah lenyap, tetapi bukaan semacam itu tampaknya runtuh lalu muncul kembali di tempat lain, jadi ia harus mencapai lubang yang lain untuk pulang.", false],
	],
	"step/26": [
		[26, "", "Lubang cacing membawa mereka kembali ke stasiun [[station/48]], tetapi pesawat tempur Void ikut menyusul. Keith harus menghancurkan mereka agar tidak bisa membuntuti kapal sampai ke stasiun [[station/10]].", false],
		[27, "", "Setelah para pengejar lenyap, keduanya kembali ke Thynome dengan sangat membutuhkan istirahat.", false],
	],
	"step/27": [
		[27, "", "Keith berlabuh di stasiun [[station/10]].", false],
		[28, "", "Dua hari kemudian Carla memintanya kembali ke sana. Timnya telah membuat sebuah wahana yang, bila ditembakkan ke kapal induk, akan menganalisisnya dan mengirim hasilnya ke kapal Keith. Carla tetap tinggal untuk meneliti puing dan mengutus Keith ke sistem [[system/18]], tempat para Void baru saja dilaporkan, untuk menemukan lubang cacing lain.", false],
		[28, "", "Keith setuju dengan satu syarat: jika ia kembali hidup-hidup, Carla berutang satu kencan kepadanya. Carla menerimanya.", false],
	],
	"step/28": [
		[28, "", "Di dekat stasiun [[station/91]] pesawat tempur Void berdatangan, dan Keith harus mencapai lubang cacing sebelum runtuh. Para Void memperingatkan bahwa menghancurkan mereka akan menghancurkan masa depannya sendiri.", false],
		[29, "", "Keith mencapai lubang cacing dan menembusnya ke ruang Void.", false],
	],
	"step/29": [
		[29, "", "Di dekat kapal induk Keith harus mengunci sasaran padanya, yang meluncurkan wahana, lalu bertahan selama wahana menyelesaikan analisisnya.", false],
		[30, "", "Selama menunggu, para Void kembali menyiarkan pesan bahwa mereka harus menemukan cara untuk berbicara sebelum manusia menghancurkan mereka dan, bersama itu, masa depan manusia sendiri. Keith bertahan hingga pengiriman data selesai, lalu pergi.", false],
	],
	"step/3": [
		[3, "", "Keith berlabuh di stasiun [[station/78]] untuk menyerahkan muatan bijih pertamanya.", false],
		[4, "", "Gunant cukup puas, tetapi menyuruh Keith keluar lagi, kali ini untuk memenuhi seluruh ruang kargo. Ia bergurau bahwa suatu hari Keith boleh memiliki kapal itu jika berkelakuan baik.", false],
	],
	"step/30": [
		[30, "", "Setelah kembali melewati lubang cacing, Keith menunggu di dekat stasiun [[station/91]].", false],
		[31, "", "Brent menelepon dan memintanya singgah di stasiun [[station/98]] dalam sistem [[system/19]] sebelum kembali ke Thynome, dengan menjanjikan sebuah kejutan. Data wahana dapat dikirim ke Carla dari sana.", false],
	],
	"step/31": [
		[31, "", "Keith berlabuh di stasiun [[station/98]] untuk menemui Brent.", false],
		[32, "", "Tim Brent telah mengembangkan sistem peringatan dini untuk peta bintang. Sistem itu menunjukkan di mana para Void akan membuka lubang cacing, dan komputer navigasi Keith dimodifikasi agar dapat menerimanya. Brent ingin ia terbang ke tempat-tempat itu dan mendukung pasukan setempat, dan membayarnya 30.000 kredit.", false],
		[32, "", "Brent menambahkan bahwa seorang [[faction/7|Grey]] bernama [[character/20]], yang bekerja untuk Deep Science, ingin bertemu Keith.", false],
	],
	"step/32": [
		[32, "", "Keith kembali ke stasiun [[station/10]] untuk menemui [[character/20]].", false],
		[33, "", "Khador telah meneliti puing Void. Ia meyakini bahwa rahasia lubang cacing para Void terletak pada struktur kristal tertentu yang hanya ditemukan di sektor Void. Ia sedang mengembangkan penggerak yang dapat membawa kapal seketika ke titik mana pun di ruang angkasa, dan meminta Keith membawakannya setidaknya 50 kristal tersebut.", false],
		[33, "", "Keith harus memasuki lubang cacing sekali lagi, kali ini dengan memakai sistem peringatan dini Brent untuk menemukannya.", false],
	],
	"step/33": [
		[33, "", "Keith harus mengumpulkan 50 [[item/164]] di sektor Void dan mengantarkannya ke stasiun [[station/10]].", false],
		[34, "", "Khador sangat gembira dan memberi Keith salinan cetak birunya untuk [[item/85]], agar Keith dapat membuatnya sendiri (lihat [[guide/blueprints]]). Penggerak seperti itu bahkan dapat mencapai sektor asal para Void.", false],
		[34, "", "Carla muncul, terlalu sibuk untuk kencan mereka. Ia memberi tahu Keith bahwa ia dan Brent telah menyusun rencana, lalu mengutusnya kepada Brent di stasiun [[station/30]] dalam sistem [[system/2]].", false],
	],
	"step/34": [
		[34, "", "Keith terbang ke stasiun [[station/30]] untuk mendengar rencana Brent.", false],
		[35, "", "Data wahana menunjukkan bahwa kapal induk adalah sumber lubang cacing. Sejauh ini tidak ada senjata yang mampu melukainya, jadi rencananya adalah menerbangkan kapal barang yang kokoh, sarat bahan peledak nuklir Nivelian, ke jantungnya.", false],
		[35, "", "Kapal barang Vossk K'Sarr paling cocok untuk tugas itu. Brent telah mengatur untuk mendapatkannya dari [[character/7]], komandan stasiun [[station/29]] di sistem [[system/5]], sebagai bagian dari pertukaran tahanan rahasia. Errkt bersikeras menemui pilotnya secara langsung.", false],
	],
	"step/35": [
		[35, "", "Keith terbang ke wilayah [[faction/1]] untuk menemui [[character/7]] di stasiun [[station/29]].", false],
		[36, "", "Errkt, yang telah memeriksa catatan Keith, berpendapat bahwa hanya seorang Vossk yang dapat menerbangkan kapal Vossk dengan benar. Karena misi ini tidak boleh gagal, ia akan menerbangkan kapal barang itu sendiri. Namun, Keith terlebih dahulu harus membuktikan kemampuannya sebagai pilot tempur di dekat planet [[station/27]].", false],
	],
	"step/36": [
		[36, "", "Errkt mengusulkan sebuah adu kemampuan di sarang bajak laut dekat [[station/27]]: siapa yang menembak jatuh lebih banyak bajak laut, dialah pemenangnya.", false],
		[37, "", "Keith menang. Errkt mengakuinya sebagai pilot yang cakap dan memberinya kehormatan untuk mengawal kapal barang, yang akan ia bawa ke titik pertemuan yang disepakati. Keith menghubungi Brent untuk melapor.", false],
	],
	"step/37": [
		[37, "", "Keith menghubungi Brent dari [[station/27]] untuk melaporkan pembicaraannya dengan Errkt.", false],
		[38, "", "Kekaisaran Vossk telah menegaskan dukungannya, dan Brent menerima Errkt sebagai pilot. Muncul masalah baru: kapal-kapal [[faction/3|Konfederasi Mido]], yang sedang berperang dengan bangsa Nivelian, telah merampas konvoi pembawa bahan peledak Nivelian. Konvoi itu terlihat di sistem [[system/4]] dekat stasiun [[station/22]], dan Keith setuju untuk mencegatnya.", false],
	],
	"step/38": [
		[38, "", "Di dekat stasiun [[station/22]] Keith menemukan konvoi curian itu dengan pengawalan pesawat tempur Mido. Ia harus menghancurkan para pengawal tanpa merusak kapal-kapal konvoi.", false],
		[39, "", "Setelah konvoi kembali terkendali, Brent menyerahkannya kepada pasukan keamanan setempat untuk perjalanan ke stasiun [[station/30]] dan meminta Keith juga kembali ke sana.", false],
	],
	"step/39": [
		[39, "", "Keith berlabuh di stasiun [[station/30]] untuk pengarahan terakhir.", false],
		[40, "", "Bahan peledak dimuat ke kapal barang Vossk, dan Errkt tetap menjadi pilotnya. Saat para Void muncul lagi, Keith dan Errkt akan terbang ke sana. Errkt akan menuju lubang cacing pertama, sementara Keith melindunginya lalu menyusul. Brent akan meminta bala bantuan dari stasiun terdekat.", false],
		[40, "", "Errkt harus melontarkan diri dengan kapsul penyelamat sesaat sebelum tabrakan. Keith harus kembali melewati lubang cacing sebelum kapal induk hancur, atau tidak akan ada jalan pulang.", false],
	],
	"step/4": [
		[4, "", "Keith kembali ke asteroid untuk menambang hingga ruang kargo penuh.", false],
		[5, "", "Saat ia menambang, sebuah kapal bajak laut mendekat. Karena tidak bersenjata, Keith diminta lari ke stasiun sambil menghindari tembakannya.", false],
	],
	"step/40": [
		[40, "", "Dengan sistem peringatan dini, Keith terbang ke sebuah orbit yang sedang diserang para Void. Errkt tiba bersama kapal barang dan menuju lubang cacing pertama, dan Letnan [[character/8]] bergabung bersama regunya. Keith harus melindungi kapal barang itu sampai berhasil menembus lubang cacing.", false],
		[41, "", "Zirah kapal barang rusak parah, tetapi Errkt berhasil mencapai lubang cacing, dan Keith menyusulnya.", false],
	],
	"step/41": [
		[41, "", "Regu Baffour tidak sempat menembus lubang cacing, jadi Keith dan Errkt hanya berdua. Kapal barang berada di jalur tabrakan dengan kapal induk, dan Keith harus menyingkirkan pesawat tempur Void yang menghalangi jalannya.", false],
		[42, "", "Saat kapal barang semakin dekat, Errkt melaporkan bahwa kapsul penyelamatnya terkena tembakan. Ia memilih tetap bersama kapal barang dan memerintahkan Keith pergi selagi masih ada waktu. Keith mengucapkan selamat tinggal dan berbalik.", false],
	],
	"step/42": [
		[42, "", "Keith harus menjauh saat kapal barang Errkt melaju ke sasarannya.", false],
		[43, "", "Brent melaporkan bahwa lubang-lubang cacing di seluruh sektor telah runtuh: rencananya berhasil. Keith memberitahunya bahwa Errkt tidak selamat, dan Brent berjanji akan menghormatinya dalam laporannya kepada Kekaisaran Vossk. Mereka sepakat bertemu untuk minum di stasiun [[station/98]].", false],
	],
	"step/43": [
		[43, "", "Keith menyusul Brent di stasiun [[station/98]] untuk merayakan.", false],
		[44, "", "Setelah beberapa gelas, Carla datang dengan gaun malam untuk menunaikan kencan yang ia janjikan kepada Keith. Brent dengan bijak meninggalkan mereka berdua.", false],
	],
	"step/44": [
		[44, "", "Keith terbangun di stasiun [[station/98]] dengan pengar setelah malamnya bersama Carla.", false],
		[45, "", "Carla sudah pergi. Catatannya menjelaskan bahwa ia telah beralih ke proyek rahasia lain di tempat yang tidak akan ia ungkapkan, dan bahwa Deep Science membayar Keith 40.000 kredit sebagai pembayaran terakhir. Keith curiga dirinya telah dimanfaatkan sejak awal, lalu kembali ke bar.", false],
	],
	"step/45": [
		[45, "", "Cerita telah selesai. Kapal induk Void telah hancur, lubang-lubang cacing telah tertutup, dan [[character/0]] bebas pergi ke mana pun ia mau. Anda dapat terus terbang, berdagang, menambang, dan mengambil pekerjaan di seluruh galaksi; lihat [[world/history]] untuk ringkasan seluruh cerita.", false],
	],
	"step/5": [
		[5, "", "Keith harus mengungguli bajak laut itu dan berlabuh dengan selamat di stasiun [[station/78]].", false],
		[6, "", "Gunant mengakui bahwa serangan bajak laut ke stasiunnya makin parah. Keith menawarkan diri untuk mengatasinya jika ia diberi senjata. Gunant memutuskan untuk mencoba menyerang sarang bajak laut di dekat stasiun dan membuka hanggar kecilnya agar Keith dapat memasang senjata dan zirah.", false],
	],
	"step/6": [
		[6, "", "Di hanggar stasiun Keith harus melengkapi [[ship/0]] dengan sebuah senjata dan sebuah pelat zirah (lihat [[guide/fitting]]).", false],
		[7, "", "Gunant menyetujui pilihannya. Sebagai tindakan pencegahan, ia telah mengatur senjata Keith agar tidak dapat menembus perisainya sendiri. Keduanya sepakat bertemu di luar.", false],
	],
	"step/7": [
		[7, "", "Gunant mengirimkan rute ke sarang itu dalam bentuk titik arah. Keith harus mengikutinya dan menghancurkan kapal-kapal bajak laut di sana, dengan Gunant terbang di sampingnya (lihat [[guide/combat]]).", false],
		[8, "", "Sarang itu berisi jauh lebih banyak bajak laut daripada perkiraan. Gunant ingin mundur, tetapi Keith terus bertempur dan menang. Ditanya di mana ia belajar bertarung seperti itu, Keith menjawab bahwa ia pernah bertugas di Armada Luar Angkasa di bawah Laksamana Smith. Gunant merasa aneh, karena Keith tampak terlalu muda.", false],
	],
	"step/8": [
		[8, "", "Setelah memenangkan pertempuran, Keith dan Gunant kembali ke stasiun [[station/78]].", false],
		[9, "", "Gunant berterima kasih kepada Keith karena telah menyelamatkan nyawanya dan menyebut makam Laksamana Smith di stasiun [[station/5]]. Keith tercengang: sang laksamana meninggal karena usia tua sekitar tahun 3612. Gunant lalu memberitahunya bahwa sekarang tahun 3624, tahun yang menurutnya akan dikenang karena para Void.", false],
	],
	"step/9": [
		[9, "", "Terguncang oleh kabar itu, Keith kembali berlabuh di stasiun [[station/78]] untuk menyelesaikan urusan dengan Gunant.", false],
		[10, "", "Keith menyadari bahwa sekitar 35 tahun telah berlalu sejak ia tertembak di sabuk asteroid. Gunant menduga hyperdrive-nya rusak, karena jenis penggerak itu sudah bertahun-tahun dikaitkan dengan kejadian serupa.", false],
		[10, "", "Sebagai ucapan terima kasih atas kemenangan melawan bajak laut, Gunant memberikan [[ship/0]] kepada Keith, dilengkapi penggerak yang lebih kuat untuk perjalanan antarplanet di sistem itu. Laser tambangnya ia simpan, karena itu purwarupa buatannya sendiri. Keith akhirnya menyebutkan namanya dan berangkat menemui Kapten [[character/3]], seorang komandan manusia di stasiun [[station/79]] yang dapat membantunya mencapai wilayah [[faction/0]]. Mulai sekarang [[chart]] memungkinkan perjalanan di dalam sistem.", false],
	],
	"system/0": [
		[0, "", "[[system/0]] adalah sistem Nivelian di tepi kiri peta. Sistem ini tersembunyi di peta bintang sampai Anda membeli koordinatnya dari [[agent/12]] di stasiun [[station/18]]. Gerbangnya di [[station/0]] menghubungkannya dengan [[system/2]] dan [[system/8]].", false],
		[0, "", "Stasiun-stasiun Suteo termasuk yang paling canggih di wilayah Nivelian, dengan [[station/2]] dan [[station/4]] di tingkat teknologi tertinggi. Agen [[agent/0]] menjual cetak biru di stasiun [[station/3]].", false],
	],
	"system/1": [
		[0, "", "[[system/1]] adalah sistem Terran di sudut kiri bawah peta. Sistem ini tersembunyi sampai Anda membeli koordinatnya dari [[agent/13]] di stasiun [[station/26]]. Gerbangnya di [[station/5]] menghubungkannya dengan [[system/8]] dan [[system/18]].", false],
		[0, "", "Stasiun-stasiunnya berkembang baik, dengan [[station/7]] di tingkat teknologi tertinggi. Agen [[agent/1]] menjual cetak biru di stasiun [[station/8]].", false],
		[9, "", "Menurut [[character/2]], Laksamana Smith, mantan komandan [[character/0]], dimakamkan di [[station/5]].", false],
	],
	"system/10": [
		[0, "", "[[system/10]] adalah sistem Vossk di sisi kanan peta, berperingkat Berbahaya. Sistem ini tersembunyi sampai Anda membeli koordinatnya dari [[agent/14]], dan sama sekali tidak memiliki sambungan gerbang: hanya kapal bermesin lompat yang dapat mencapainya. Kelima stasiunnya berada di tingkat teknologi tertinggi.", false],
		[0, "", "Agen [[agent/5]] menjual cetak biru di stasiun [[station/54]].", false],
	],
	"system/11": [
		[0, "", "[[system/11]] adalah sistem Terran di tengah atas peta, berperingkat Sedang. Sistem ini hanya memiliki tiga stasiun. Gerbangnya di [[station/55]] menghubungkannya dengan [[system/7]], [[system/9]], [[system/14]], dan [[system/16]].", false],
		[18, "", "[[character/0]] diutus ke stasiun [[station/56]] untuk menemui seorang perwira Deep Science.", false],
		[19, "", "Perwira itu, [[character/5]], telah diculik bajak laut di dekat stasiun [[station/55]].", false],
		[22, "", "[[character/0]] membebaskannya dengan bom EMP di [[step/21]].", false],
	],
	"system/12": [
		[0, "", "[[system/12]] adalah sistem Vossk kecil dengan hanya dua stasiun, di sisi kanan peta dan berperingkat Sedang. Gerbangnya di [[station/60]] menghubungkannya dengan [[system/3]], [[system/5]], [[system/13]], dan [[system/14]], sehingga sistem ini menyambungkan wilayah Vossk dengan wilayah Terran di timur.", false],
		[0, "", "Agen Multipod [[agent/6]] menjual cetak biru di stasiun [[station/61]].", false],
	],
	"system/13": [
		[0, "", "[[system/13]] adalah sistem Terran di tepi kanan peta, berperingkat Berisiko. Gerbangnya di [[station/65]] menghubungkannya dengan [[system/12]] dan [[system/16]].", false],
		[0, "", "Agen Cyborg [[agent/14]] menjual koordinat di stasiun [[station/65]].", false],
	],
	"system/14": [
		[0, "", "[[system/14]] adalah sistem Terran di dekat tengah peta dan salah satu dari dua sistem berperingkat Aman di galaksi. Gerbangnya di [[station/70]] menghubungkannya dengan [[system/3]], [[system/11]], [[system/12]], dan [[system/19]]. Stasiun-stasiunnya sebagian besar berteknologi rendah.", false],
		[0, "", "Agen [[agent/7]] menjual cetak biru di stasiun [[station/72]].", false],
	],
	"system/15": [
		[0, "", "[[system/15]] adalah sistem Midorian di bagian atas peta, berperingkat Berbahaya. Sistem ini tidak memiliki sambungan gerbang, sehingga kapal hanya dapat masuk atau keluar dengan mesin lompat. Kelima stasiunnya kecil dan berteknologi rendah. Sampai [[step/16]] pedagang kapalnya tetap tutup dan hanya sedikit kapal yang datang dan pergi.", false],
		[0, "", "Cerita dimulai di sini, di stasiun [[station/78]].", false],
		[11, "", "Sistem ini adalah wilayah [[faction/3|Konfederasi Mido]], yang didirikan oleh orang-orang buangan Terran dan Nivelian semasa Perang Saudara Nivelian. Bangsa Nivelian masih mengklaimnya, dan terjadi pertempuran di wilayah pinggirannya.", false],
		[15, "", "[[character/0]] meninggalkan sistem ini sebagai tahanan di kapal penjelajah Terran setelah [[step/14]]. Untuk kembali ke sini nanti diperlukan mesin lompat.", false],
		[0, "", "[[character/2]] menjual cetak biru di lounge stasiun [[station/78]].", false],
	],
	"system/16": [
		[0, "", "[[system/16]] adalah sistem Terran di sisi kanan peta, berperingkat Berisiko. Gerbangnya di [[station/80]] menghubungkannya dengan [[system/11]] dan [[system/13]].", false],
		[0, "", "Agen Vossk [[agent/8]] menjual cetak biru di stasiun [[station/84]].", false],
	],
	"system/17": [
		[0, "", "[[system/17]] adalah sistem Nivelian di kiri atas peta, berperingkat Berisiko, dan sistem terdekat dengan [[system/15]]. Gerbangnya di [[station/85]] menghubungkannya dengan [[system/2]], [[system/9]], dan [[system/4]]; inilah satu-satunya rute gerbang menuju [[system/4]].", false],
		[0, "", "Agen Vossk [[agent/15]] menjual koordinat di stasiun [[station/88]].", false],
	],
	"system/18": [
		[0, "", "[[system/18]] adalah sistem Terran di bagian bawah peta, berperingkat Berisiko. Gerbangnya di [[station/90]] menghubungkannya dengan [[system/1]] dan [[system/8]].", false],
		[0, "", "Agen [[agent/9]] menjual cetak biru di stasiun [[station/90]].", false],
		[28, "", "Di [[step/28]] [[character/0]] datang ke sini setelah ada laporan aktivitas Void di dekat stasiun [[station/91]], untuk menyelinap ke dalam lubang cacing.", false],
	],
	"system/19": [
		[0, "", "[[system/19]] adalah sistem Terran di tengah peta, berperingkat Aman. Gerbangnya di [[station/95]] menghubungkannya dengan [[system/3]], [[system/8]], [[system/9]], dan [[system/14]].", false],
		[15, "", "Ke stasiun [[station/98]] inilah kapal penjelajah Terran membawa [[character/0]] setelah ia ditangkap, dan di sana ia bertemu kembali dengan kawan lamanya [[character/1]].", false],
		[16, "", "Bahkan sistem yang aman ini tidak luput: satu skuadron Void menyerang stasiun [[station/98]] di [[step/16]]. [[character/1]] berkantor pusat di sana.", false],
	],
	"system/2": [
		[0, "", "[[system/2]] adalah sistem Nivelian di sisi kiri peta dan persimpangan wilayah Nivelian. Gerbangnya di [[station/30]] menghubungkannya dengan [[system/0]], [[system/8]], [[system/9]], dan [[system/17]]. Sistem ini memiliki empat stasiun dengan tingkat teknologi menengah.", false],
		[34, "", "Di [[step/33]] [[character/6]] mengutus [[character/0]] ke stasiun [[station/30]], tempat [[character/1]] menunggu dengan rencana baru. Persiapan terakhir melawan para Void juga berlangsung di sana.", false],
	],
	"system/20": [
		[0, "", "[[system/20]] adalah sistem Vossk di kanan bawah peta, berperingkat Berbahaya. Gerbangnya di [[station/62]] menghubungkannya dengan [[system/5]] dan [[system/21]], sehingga menjadi satu-satunya rute gerbang menuju [[system/21]].", false],
		[0, "", "Seorang Terran, agen [[agent/10]], menjual cetak biru di stasiun kecil [[station/59]].", false],
	],
	"system/21": [
		[0, "", "[[system/21]] adalah sistem Vossk di sudut kanan bawah terjauh peta, berperingkat Berbahaya. Sistem ini tersembunyi sampai Anda membeli koordinatnya dari [[agent/15]]. Gerbangnya di [[station/12]] hanya menghubungkannya dengan [[system/20]]. Semua stasiunnya primitif, dengan tingkat teknologi 3 atau lebih rendah.", false],
	],
	"system/3": [
		[0, "", "[[system/3]] adalah sistem Vossk yang paling dekat dengan tengah peta dan pintu masuk utama ke wilayah Vossk. Gerbangnya di [[station/15]] menghubungkannya dengan [[system/5]], [[system/12]], [[system/8]], [[system/14]], dan [[system/19]]. Peringkatnya Sedang.", false],
		[0, "", "Agen [[agent/12]] di stasiun [[station/18]] menjual koordinat sistem tersembunyi [[system/0]].", false],
	],
	"system/4": [
		[0, "", "[[system/4]] adalah sistem Midorian di sudut kiri atas peta, berperingkat Berbahaya. Sistem ini jalan buntu: gerbangnya di [[station/20]] hanya menjangkau [[system/17]]. Stasiun-stasiunnya beragam, dari [[station/21]] yang primitif hingga [[station/22]] yang lengkap.", false],
		[0, "", "Agen [[agent/2]] menjual cetak biru di lounge stasiun [[station/20]].", false],
		[38, "", "Di [[step/38]] sebuah konvoi curian yang membawa bahan peledak Nivelian dilacak ke sistem ini, di dekat stasiun [[station/22]].", false],
	],
	"system/5": [
		[0, "", "[[system/5]] adalah sistem Vossk di kanan bawah peta, berperingkat Berisiko. Gerbangnya di [[station/25]] menghubungkannya dengan [[system/3]], [[system/12]], dan [[system/20]]. Agen [[agent/13]] menjual koordinat di stasiun [[station/26]].", false],
		[35, "", "Sistem ini adalah pangkalan komandan Vossk [[character/7]] di stasiun [[station/29]], tempat [[character/0]] menemuinya di [[step/35]].", false],
		[36, "", "Adu kemampuan mereka berlangsung di dekat [[station/27]].", false],
	],
	"system/6": [
		[0, "", "[[system/6]] adalah sistem Terran di kanan atas peta, berperingkat Berbahaya. Sistem ini tidak tercantum di peta bintang standar, dan hanya cerita yang mengungkap koordinatnya. Isinya hanya satu stasiun, [[station/10]], yang gerbangnya menghubungkannya dengan [[system/7]] saja.", false],
		[23, "", "Sistem ini menyembunyikan stasiun riset rahasia Deep Science. [[character/5]] memberi [[character/0]] koordinatnya di [[step/22]], dan sebagian besar perjuangan melawan para Void direncanakan di sana.", false],
	],
	"system/7": [
		[0, "", "[[system/7]] adalah sistem Terran di kanan atas peta, berperingkat Berisiko. Gerbangnya di [[station/35]] menghubungkannya dengan [[system/11]] dan dengan [[system/6]] yang tersembunyi, sehingga menjadi satu-satunya rute gerbang menuju sistem tersembunyi itu. [[station/37]] adalah stasiunnya yang paling canggih.", false],
	],
	"system/8": [
		[0, "", "[[system/8]] adalah sistem Terran di seperempat kiri bawah peta dan sistem dengan sambungan terbanyak di galaksi. Gerbangnya di [[station/40]] menghubungkannya dengan enam sistem: [[system/0]], [[system/1]], [[system/2]], [[system/3]], [[system/18]], dan [[system/19]]. Peringkatnya Sedang.", false],
		[0, "", "Agen [[agent/4]] menjual cetak biru di stasiun [[station/43]].", false],
	],
	"system/9": [
		[0, "", "[[system/9]] adalah sistem Nivelian di tengah atas peta, berperingkat Sedang. Gerbangnya di [[station/45]] menghubungkannya dengan [[system/2]], [[system/11]], [[system/17]], dan [[system/19]].", false],
		[24, "", "Aktivitas Void dilaporkan di dekat stasiun [[station/48]], dan [[character/0]] serta [[character/6]] pergi ke sana di [[step/24]] untuk mengumpulkan puing.", false],
	],
	"world/galaxy": [
		[0, "Ikhtisar", "Permainan ini berlangsung di sebuah galaksi yang terdiri atas 22 sistem bintang. Setiap sistem dimiliki satu faksi, memiliki peringkat keamanan, dan berisi satu hingga lima stasiun luar angkasa. Setiap stasiun mengorbit sebuah planet, dan masing-masing memiliki toko, hanggar, dan lounge luar angkasa sendiri. Sistem-sistem itu tersebar di sebuah peta datar, dan perjalanan di antaranya melewati jaringan gerbang lompat.", false],
		[0, "", "Empat bangsa menguasai sistem-sistem yang terpetakan. [[faction/0|Bangsa Terran]] memiliki sepuluh, [[faction/1]] enam, [[faction/2|bangsa Nivelian]] empat, dan [[faction/3|bangsa Midorian]] dua. Anggota ras-ras yang lebih kecil, seperti [[faction/4|Multipod]], [[faction/5|Cyborg]], [[faction/6|Bobolian]], dan [[faction/7]], hidup di tengah mereka tanpa wilayah sendiri. [[faction/8|Bajak laut]] berkeliaran di setiap sistem, dan sejak awal beredar desas-desus tentang kekuatan bermusuhan yang disebut [[faction/9|Void]].", false],
		[0, "Tata letak", "Sistem Nivelian dan Midorian terletak di kiri atas peta, di sekitar [[system/15]], [[system/4]], [[system/17]], dan [[system/2]]. Wilayah Terran membentang di tengah, sisi kanan, dan bagian bawah peta, dengan [[system/19]] dan [[system/14]] sebagai pusatnya. Sistem Vossk membentuk blok tersendiri di kanan bawah, mulai dari [[system/3]] dan berakhir di sudut terjauh pada [[system/21]].", false],
		[0, "", "Rute gerbang cenderung terpusat di tengah. [[system/8]] memiliki enam sambungan gerbang, lebih banyak daripada sistem lain mana pun, sedangkan [[system/19]], [[system/14]], [[system/3]], dan [[system/11]] masing-masing terhubung dengan empat atau lima sistem. Sistem di tepi, seperti [[system/4]], [[system/6]], dan [[system/21]], adalah jalan buntu dengan satu sambungan saja.", false],
		[0, "Perjalanan", "Di dalam sebuah sistem, penggerak biasa kapal membawanya dari orbit satu stasiun ke stasiun lain. Untuk meninggalkan sistem, kapal terbang melewati gerbang lompatnya, yang berada di salah satu stasiun sistem itu dan hanya menjangkau sistem-sistem yang terhubung dengannya. Perjalanan yang lebih jauh berupa rangkaian lompatan gerbang. Mesin lompat adalah satu-satunya cara untuk melewati jaringan gerbang dan langsung mencapai sistem mana pun yang dikenal; lihat [[guide/navigation]].", false],
		[33, "", "Satu-satunya mesin lompat dalam permainan adalah [[item/85]], yang dirancang oleh [[character/20]] di sepanjang cerita. Mesin ini dibuat dari cetak biru dan antara lain membutuhkan [[item/164]].", false],
		[0, "Keamanan", "Setiap sistem diberi peringkat Aman, Sedang, Berisiko, atau Berbahaya. Peringkat ini menentukan seberapa sering perampok menunggu di dekat stasiun saat Anda tiba. Di sistem Berbahaya mereka muncul hampir setiap kunjungan; di sistem Aman mereka jarang ada. Perampok biasanya bajak laut, tetapi kadang kapal-kapal dari ras saingan faksi tersebut. Sebaliknya, sistem yang lebih aman menempatkan lebih banyak kapal patroli setempat di sekitar stasiunnya.", false],
		[0, "Faksi dan reputasi", "Reputasi Anda dicatat pada dua skala: satu antara bangsa Terran dan Vossk, satu lagi antara bangsa Nivelian dan Midorian. Simpati dari satu pihak dalam pasangan itu mengurangi simpati pihak lainnya. Jika reputasi Anda di mata suatu faksi turun terlalu rendah, kapal-kapalnya langsung menyerang Anda dan stasiun-stasiunnya menolak Anda. Bajak laut dan Void selalu bermusuhan. Seorang diplomat di lounge luar angkasa dapat memulihkan reputasi Anda dengan bayaran.", false],
		[0, "Sistem tersembunyi", "Tidak semua sistem langsung muncul di peta bintang. [[system/0]], [[system/1]], [[system/10]], dan [[system/21]] tetap tersembunyi sampai Anda membeli koordinatnya dari seorang agen di lounge luar angkasa; lihat [[guide/lounge]]. Satu sistem lagi, [[system/6]], tidak tercantum di peta bintang standar dan hanya diungkap oleh cerita.", false],
		[23, "", "Koordinat [[system/6]] sampai kepada Anda melalui [[character/5]] di [[step/22]]. Sistem itu hanya berisi satu stasiun, [[station/10]], pangkalan riset rahasia organisasi Deep Science.", false],
		[0, "", "Dua sistem sama sekali tidak memiliki sambungan gerbang: [[system/15]] dan [[system/10]]. Kapal hanya dapat mencapai atau meninggalkannya dengan mesin lompat.", false],
		[0, "Awal yang terpencil", "Cerita dimulai di [[system/15]], sistem terpencil di bagian atas peta tanpa sambungan gerbang ke bagian galaksi lainnya. Perdagangannya lesu, stasiunnya berteknologi rendah, dan pedagang kapalnya tetap tutup selama bagian awal cerita. Pada awalnya, satu-satunya jalan keluar dari sistem itu adalah jalan yang disediakan cerita.", false],
		[11, "", "[[system/15]] adalah tanah air [[faction/3|Konfederasi Mido]], sekelompok pengungsi dan pelanggar hukum Terran dan Nivelian yang menetap di sektor yang baru dipetakan ini semasa Perang Saudara Nivelian. Konfederasi menyatakan diri merdeka. Bangsa Terran menerimanya; bangsa Nivelian masih mengklaim sistem itu, sehingga pertempuran terus berlangsung di wilayah tepinya.", false],
		[15, "", "[[character/0]] meninggalkan [[system/15]] di atas kapal penjelajah Terran setelah konvoi di dekat [[station/79]] melumpuhkan dan menangkapnya di [[step/14]]. Ia tiba di stasiun [[station/98]] dalam sistem [[system/19]], jauh di dalam wilayah Terran.", false],
		[9, "Lompatan waktu", "Saat [[character/0]] terbangun di [[system/15]], ia mengira baru sebentar waktu berlalu. Sebenarnya hyperdrive-nya yang rusak telah melemparkannya melintasi galaksi dan sekitar 35 tahun ke masa depan. Galaksi yang ia kenal telah berubah: kawan-kawan lama sudah menua atau meninggal, dan sektor-sektor baru, termasuk tempatnya kini berada, telah dihuni sementara itu.", false],
		[10, "", "Hyperdrive rusak dari jenis yang sama pernah menyebabkan lompatan serupa melintasi ruang dan waktu.", false],
		[18, "Di luar peta", "Para Void memasuki sistem-sistem yang terpetakan melalui semacam lubang cacing. Mereka menyerbu wilayah Terran, Nivelian, dan Vossk tanpa pandang bulu dan tampaknya mengincar bijih. Lihat [[world/voids]].", false],
		[25, "", "Sebuah lubang cacing mengarah keluar dari galaksi terpetakan ke sektor milik para Void sendiri, yang tidak tercantum di peta bintang. Lubang cacing terbuka di dekat sebuah stasiun untuk sementara waktu, lalu runtuh dan muncul di tempat lain.", false],
		[34, "", "Dengan [[item/85]] terpasang, kapal juga dapat melompat langsung ke sektor Void.", false],
		[32, "", "Mulai [[step/31]], sistem peringatan dini menunjukkan di peta bintang tempat lubang cacing berikutnya akan terbuka.", false],
		[42, "", "Ketika kapal induk Void dihancurkan di [[step/41]], lubang-lubang cacing di seluruh sektor runtuh dan serbuan pun berhenti.", false],
	],
	"world/history": [
		[0, "", "Galaksi ini dihuni beberapa bangsa, di antaranya [[faction/0|bangsa Terran]], [[faction/2|bangsa Nivelian]], dan [[faction/1|bangsa Vossk]]. Ruang di antara stasiun-stasiun mereka diganggu oleh [[faction/8|bajak laut]]. Halaman ini merangkum ceritanya; setiap bagian muncul setelah simpanan Anda mencapainya.", false],
		[0, "Babak pertama: terdampar", "Pemburu hadiah Terran [[character/0]] menghancurkan sekelompok bajak laut di sebuah sabuk asteroid ([[step/0]]).", false],
		[1, "", "Sebuah tembakan terakhir merusak hyperdrive-nya saat ia melompat pergi untuk menemui mantan komandannya, Laksamana Smith. Kapalnya terapung dengan pilot tak sadarkan diri hingga ke stasiun [[station/78]].", false],
		[2, "", "Pedagang bijih Nivelian [[character/2]] menyelamatkan bangkai kapal itu, menyimpan kapalnya, dan menyuruh Keith menambang bijih untuknya.", false],
		[8, "", "Keith membantu Gunant menghancurkan sarang bajak laut di dekat sana ([[step/7]]).", false],
		[9, "", "Sesudahnya Keith mengetahui bahwa saat itu tahun 3624 dan Laksamana Smith sudah lama meninggal.", false],
		[10, "", "Kerusakan hyperdrive telah membawa Keith 35 tahun ke masa depan dan ke sudut galaksi yang terpencil. Gunant memberinya kapal [[ship/0]] dan mengutusnya kepada [[character/3]] di stasiun [[station/79]].", false],
		[11, "", "Sistem [[system/15]] adalah milik [[faction/3|Konfederasi Mido]], yang didirikan oleh orang-orang buangan Terran dan Nivelian semasa Perang Saudara Nivelian.", false],
		[12, "", "Keith mendapati bahwa stasiun yang membisu, [[station/76]], telah dibuat teler oleh pedagang [[character/4]] ([[step/11]]).", false],
		[15, "", "Ketika sebuah konvoi Terran melintas, mereka mengira Keith bajak laut, melumpuhkan kapalnya, dan membawanya ke stasiun [[station/98]] ([[step/14]]).", false],
		[16, "Babak kedua: ancaman Void", "Di sana ia bertemu kawan lamanya [[character/1]], yang kini menjabat kepala keamanan, tepat ketika [[faction/9|para Void]] menyerang stasiun.", false],
		[18, "", "Para Void menyerbu sistem bintang melalui lubang cacing untuk mencari bijih. Brent merekrut Keith agar terbang untuk Deep Science, sebuah organisasi riset rahasia yang meneliti mereka ([[step/17]]).", false],
		[19, "", "Ilmuwan [[character/5]], yang seharusnya memandu Keith ke stasiun riset, diculik oleh bajak laut.", false],
		[23, "", "Keith melumpuhkan kapal para penculik dengan bom EMP, menyelamatkan sang ilmuwan, dan menerima koordinat sistem [[system/6]] ([[step/21]], [[step/22]]).", false],
		[24, "Babak ketiga: Deep Science", "Di stasiun [[station/10]] Keith bertemu pemimpin proyek [[character/6]] dan mulai bekerja untuk Deep Science.", false],
		[25, "", "Keith dan Carla mengumpulkan puing Void di stasiun [[station/48]], tetapi sebuah lubang cacing menelan kapal mereka ([[step/24]]).", false],
		[26, "", "Mereka mendapati diri berada di sektor asal para Void, di samping sebuah kapal induk raksasa, lalu meloloskan diri melalui lubang cacing lain.", false],
		[30, "", "Keith kembali ke sektor Void melalui lubang cacing di dekat stasiun [[station/91]] dan meluncurkan wahana ke arah kapal induk ([[step/29]]).", false],
		[32, "", "Brent memberi Keith sistem peringatan dini yang menunjukkan di mana para Void akan menyerang berikutnya.", false],
		[34, "", "Ilmuwan Grey [[character/20]] meminta Keith mengumpulkan kristal Void untuk penggerak instan yang baru dan memberinya cetak birunya ([[step/33]]).", false],
		[35, "Babak keempat: serangan", "Wahana itu menunjukkan bahwa kapal induklah yang menciptakan lubang cacing. Brent dan Carla berencana menghancurkannya dengan kapal barang berisi bahan peledak Nivelian, yang dipasok oleh komandan Vossk [[character/7]].", false],
		[37, "", "Errkt bersikeras menerbangkan sendiri kapal barang itu, dan Keith memenangkan hak untuk mengawalnya ([[step/36]]).", false],
		[39, "", "Keith merebut kembali konvoi pembawa bahan peledak setelah kapal-kapal Mido merampasnya ([[step/38]]).", false],
		[42, "", "Dengan bala bantuan di bawah pimpinan [[character/8]], Keith mengawal Errkt menembus lubang cacing. Errkt menabrakkan kapal barang itu ke kapal induk dan gugur dalam serangan tersebut ([[step/41]]).", false],
		[43, "", "Semua lubang cacing runtuh dan serbuan para Void pun berakhir.", false],
		[45, "Epilog", "Keith merayakannya bersama Brent dan akhirnya melewatkan satu malam bersama Carla. Keesokan paginya Carla berangkat untuk proyek rahasia lain, dan Keith bebas menjelajahi galaksi.", false],
	],
	"world/voids": [
		[0, "", "[[faction/9|Para Void]] adalah ancaman utama dalam cerita. Halaman ini menghimpun apa yang diketahui tentang mereka; lebih banyak muncul seiring kemajuan simpanan Anda.", false],
		[2, "Kabar pertama", "Keith pertama kali mendengar tentang para Void dari [[character/2]]: makhluk-makhluk bermusuhan yang sesekali muncul bahkan di sistem terpencil [[system/15]].", false],
		[9, "", "Penduduk sistem Mido memperkirakan tahun 3624 akan dikenang sebagai tahun para Void.", false],
		[16, "", "Pesawat tempur Void menyerang stasiun [[station/98]] di wilayah Terran ([[step/15]]).", false],
		[17, "", "Selama serangan itu para Void menyiarkan pesan bahwa mereka datang dengan damai, tetapi mereka terus menembak.", false],
		[18, "Yang diketahui", "Para Void mulai muncul beberapa minggu sebelumnya. Mereka memasuki sistem berpenghuni melalui lubang cacing, menyerang apa pun yang mereka temui, dan tampaknya mengincar bijih. Bahkan sistem milik [[faction/1]] pun diserbu. Tidak ada yang tahu dari mana mereka berasal atau apa yang mereka inginkan.", false],
		[24, "", "Di stasiun [[station/48]] mereka mengumumkan bahwa mereka datang dari masa depan dan merupakan sisa terakhir peradaban-peradaban galaksi.", false],
		[26, "Sektor asal", "Lubang cacing mereka mengarah ke sektor asal yang jauh, tempat sebuah kapal induk raksasa meluncurkan pesawat tempur. Lubang cacing itu terbuka sebentar, lalu runtuh dan muncul kembali di tempat lain.", false],
		[28, "", "Para Void memperingatkan bahwa menghancurkan mereka berarti menghancurkan masa depan umat manusia.", false],
		[30, "", "Mereka berulang kali menyatakan harus menemukan cara berkomunikasi sebelum manusia menghancurkan mereka, dan bersama itu masa depan manusia sendiri. Benar tidaknya klaim ini tidak pernah terjawab.", false],
		[32, "", "Sistem peringatan dini yang dikembangkan tim [[character/1]] meramalkan di mana para Void akan membuka lubang cacing berikutnya.", false],
		[33, "", "Ilmuwan Grey [[character/20]] meyakini bahwa kristal yang hanya ditemukan di sektor Void, [[item/164]], menyimpan rahasia lubang cacing mereka.", false],
		[35, "Akhir serbuan", "Wahana yang diluncurkan ke kapal induk menunjukkan bahwa kapal itulah sumber lubang cacing. Belum ada senjata yang dikenal mampu merusaknya.", false],
		[42, "", "Sebuah kapal barang Vossk berisi bahan peledak nuklir Nivelian, yang diterbangkan oleh [[character/7]], menghancurkan kapal induk ([[step/41]]).", false],
		[43, "", "Sesudahnya lubang-lubang cacing runtuh di seluruh sektor dan serbuan para Void berhenti, setidaknya untuk sementara.", false],
	],
}
