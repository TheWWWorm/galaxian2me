extends RefCounted
## Reference prose in Vietnamese. Each block is [story step it appears from,
## section heading or "", text, list item]. See src/wiki/prose.gd.
const PAGES := {
	"guide/basics": {"title": "Bắt đầu", "subtitle": "Hướng dẫn", "category": "guide", "from": 0},
	"guide/blueprints": {"title": "Bản thiết kế và sản xuất", "subtitle": "Hướng dẫn", "category": "guide", "from": 0},
	"guide/combat": {"title": "Chiến đấu", "subtitle": "Hướng dẫn", "category": "guide", "from": 0},
	"guide/fitting": {"title": "Tàu và trang bị", "subtitle": "Hướng dẫn", "category": "guide", "from": 0},
	"guide/flight": {"title": "Bay", "subtitle": "Hướng dẫn", "category": "guide", "from": 0},
	"guide/jobs": {"title": "Công việc tự do", "subtitle": "Hướng dẫn", "category": "guide", "from": 0},
	"guide/lounge": {"title": "Phòng chờ", "subtitle": "Hướng dẫn", "category": "guide", "from": 0},
	"guide/medals": {"title": "Huy chương", "subtitle": "Hướng dẫn", "category": "guide", "from": 0},
	"guide/mining": {"title": "Khai thác", "subtitle": "Hướng dẫn", "category": "guide", "from": 0},
	"guide/navigation": {"title": "Định hướng", "subtitle": "Hướng dẫn", "category": "guide", "from": 0},
	"guide/trading": {"title": "Thương mại", "subtitle": "Hướng dẫn", "category": "guide", "from": 0},
	"step/0": {"title": "Truy nã trong vành đai tiểu hành tinh"},
	"step/1": {"title": "Trôi dạt giữa không gian"},
	"step/10": {"title": "Gặp chỉ huy"},
	"step/11": {"title": "Trạm im lặng"},
	"step/12": {"title": "Báo cáo với chỉ huy"},
	"step/13": {"title": "Chờ đoàn tàu"},
	"step/14": {"title": "Đoàn tàu Terran"},
	"step/15": {"title": "Bị bắt giữ"},
	"step/16": {"title": "Bảo vệ trạm"},
	"step/17": {"title": "Câu chuyện về Void"},
	"step/18": {"title": "Hẹn gặp nhà khoa học"},
	"step/19": {"title": "Vụ bắt cóc"},
	"step/2": {"title": "Chuyến khai thác quặng đầu tiên"},
	"step/20": {"title": "Lắp bom"},
	"step/21": {"title": "Vô hiệu hóa bọn bắt cóc"},
	"step/22": {"title": "Nhà khoa học được giải cứu"},
	"step/23": {"title": "Trạm nghiên cứu bí mật"},
	"step/24": {"title": "Thu hồi xác tàu Void"},
	"step/25": {"title": "Lạc giữa vùng không gian lạ"},
	"step/26": {"title": "Cắt đuôi kẻ truy đuổi"},
	"step/27": {"title": "Nhiệm vụ mới"},
	"step/28": {"title": "Lại vào lỗ sâu"},
	"step/29": {"title": "Phóng tàu thăm dò"},
	"step/3": {"title": "Giao quặng"},
	"step/30": {"title": "Cuộc gọi từ người bạn cũ"},
	"step/31": {"title": "Bất ngờ đã hứa"},
	"step/32": {"title": "Nhà khoa học Grey"},
	"step/33": {"title": "Tinh thể từ Vùng Void"},
	"step/34": {"title": "Kế hoạch chiến thắng"},
	"step/35": {"title": "Gặp chỉ huy Vossk"},
	"step/36": {"title": "Cuộc so tài phi công"},
	"step/37": {"title": "Gọi về sở chỉ huy"},
	"step/38": {"title": "Giành lại đoàn tàu"},
	"step/39": {"title": "Chuẩn bị cuối cùng"},
	"step/4": {"title": "Đầy khoang hàng"},
	"step/40": {"title": "Hộ tống đến lỗ sâu"},
	"step/41": {"title": "Tấn công tàu mẹ"},
	"step/42": {"title": "Thoát khỏi Vùng Void"},
	"step/43": {"title": "Ăn mừng"},
	"step/44": {"title": "Sáng hôm sau"},
	"step/45": {"title": "Phần kết"},
	"step/5": {"title": "Chạy trốn về trạm"},
	"step/6": {"title": "Vũ trang cho tàu"},
	"step/7": {"title": "Sào huyệt hải tặc"},
	"step/8": {"title": "Sau trận chiến"},
	"step/9": {"title": "Thanh toán sòng phẳng"},
	"world/galaxy": {"title": "Thiên hà", "subtitle": "Bối cảnh", "category": "world", "from": 0},
	"world/history": {"title": "Lịch sử", "subtitle": "Bối cảnh", "category": "world", "from": 0},
	"world/khador": {"title": "Khador", "subtitle": "Nhân vật", "category": "characters", "from": 32},
	"world/voids": {"title": "Void", "subtitle": "Bối cảnh", "category": "world", "from": 0},
}
const BLOCKS := {
	"agent/0": [
		[0, "", "[[agent/0]] là một đặc vụ Nivelian trong phòng chờ của [[station/3]] thuộc hệ sao ẩn [[system/0]]. Ông bán bản thiết kế laser [[item/11]].", false],
	],
	"agent/1": [
		[0, "", "[[agent/1]] là một đặc vụ Nivelian trong phòng chờ của [[station/8]] thuộc hệ sao ẩn [[system/1]]. Ông bán bản thiết kế blaster [[item/15]], một vũ khí mà ông mô tả là hiếm.", false],
	],
	"agent/10": [
		[0, "", "[[agent/10]] là một đặc vụ Terran sống giữa người Vossk, trong phòng chờ của [[station/59]] thuộc [[system/20]]. Ông bán bản thiết kế thiết bị tàng hình [[item/96]].", false],
	],
	"agent/11": [
		[0, "", "[[agent/11]] chính là thương nhân quặng [[character/2]], người xuất hiện trong phòng chờ của chính mình tại [[station/78]] thuộc [[system/15]]. Ông bán bản thiết kế [[item/90]], tia laser khai thác của riêng ông, với giá cao hơn hẳn bất kỳ đặc vụ nào khác. Vì [[system/15]] không có liên kết cổng, muốn gặp ông về sau trong trò chơi cần có động cơ nhảy.", false],
		[10, "", "Ông chào [[character/0]] là kẻ du hành thời gian và đã bắt đầu sản xuất mũi khoan mà trước kia ông giữ cho riêng mình.", false],
	],
	"agent/12": [
		[0, "", "[[agent/12]] là một đặc vụ Vossk trong phòng chờ của [[station/18]] thuộc [[system/3]]. Ông bán tọa độ của hệ sao ẩn [[system/0]], ca ngợi nhiều trạm tiên tiến ở đó.", false],
	],
	"agent/13": [
		[0, "", "[[agent/13]] là một đặc vụ Bobolian trong phòng chờ của [[station/26]] thuộc [[system/5]]. Ông bán tọa độ của hệ sao ẩn [[system/1]].", false],
	],
	"agent/14": [
		[0, "", "[[agent/14]] là một đặc vụ Cyborg trong phòng chờ của [[station/65]] thuộc [[system/13]]. Ông bán tọa độ của [[system/10]] nhưng thừa nhận không biết làm cách nào để đến đó. Không có động cơ nhảy thì tọa độ này vô dụng, vì hệ sao không có liên kết cổng.", false],
	],
	"agent/15": [
		[0, "", "[[agent/15]] là một đặc vụ Vossk trong phòng chờ của [[station/88]] thuộc [[system/17]]. Ông bán tọa độ của hệ sao ẩn [[system/21]], nơi ông gọi là quê nhà. Khi đã biết tọa độ, có thể đến hệ sao này qua cổng từ [[system/20]].", false],
	],
	"agent/2": [
		[0, "", "[[agent/2]] là một đặc vụ Midorian trong phòng chờ của [[station/20]] thuộc [[system/4]]. Ông bán bản thiết kế [[item/25]], bản thiết kế vũ khí rẻ nhất do đặc vụ bán, ngoài rocket của [[agent/4]].", false],
	],
	"agent/3": [
		[0, "", "[[agent/3]] là một đặc vụ Terran trong phòng chờ của [[station/10]] thuộc [[system/6]]. Ông bán bản thiết kế [[item/27]], một súng gia tốc khối lượng bắn nhanh.", false],
	],
	"agent/4": [
		[0, "", "[[agent/4]] là một đặc vụ Terran trong phòng chờ của [[station/43]] thuộc [[system/8]]. Ông bán bản thiết kế [[item/33]], bản thiết kế rẻ nhất mà đặc vụ nào chào bán.", false],
	],
	"agent/5": [
		[0, "", "[[agent/5]] là một đặc vụ Vossk trong phòng chờ của [[station/54]] thuộc [[system/10]], một hệ sao chỉ có thể đến bằng động cơ nhảy. Ông bán bản thiết kế ngư lôi tự dẫn [[item/37]], thứ không cửa hàng nào có bán.", false],
	],
	"agent/6": [
		[0, "", "[[agent/6]] là Multipod duy nhất trong trò chơi. Ông ngồi trong phòng chờ của [[station/61]] thuộc [[system/12]] và bán bản thiết kế vũ khí hạt nhân [[item/46]].", false],
	],
	"agent/7": [
		[0, "", "[[agent/7]] là một đặc vụ Terran trong phòng chờ của [[station/72]] thuộc [[system/14]]. Ông bán bản thiết kế [[item/54]], một loại khiên mạnh.", false],
	],
	"agent/8": [
		[0, "", "[[agent/8]] là một đặc vụ Vossk trong phòng chờ của [[station/84]] thuộc [[system/16]]. Ông bán bản thiết kế [[item/59]], một tấm giáp Vossk chưa bao giờ được bán ở cửa hàng. Đây là bản thiết kế đắt nhất mà đặc vụ bán, chỉ sau mũi khoan của [[agent/11]].", false],
	],
	"agent/9": [
		[0, "", "[[agent/9]] là một đặc vụ Terran trong phòng chờ của [[station/90]] thuộc [[system/18]]. Ông bán bản thiết kế [[item/67]], một máy nén hàng hóa mà ông giới thiệu cho mọi thương nhân.", false],
	],
	"character/0": [
		[0, "", "[[character/0]] là nhân vật chính và là nhân vật bạn điều khiển. Anh là một phi công chiến đấu người [[faction/0]], kiếm sống bằng nghề săn [[faction/8|hải tặc]] để lĩnh tiền thưởng. Anh tự tin, hay mỉa mai và sẵn sàng lao vào cuộc chiến.", false],
		[1, "Mắc kẹt", "Trên đường đến Eden Prime, nơi Đô đốc Smith có một nhiệm vụ đặc biệt dành cho anh, động cơ siêu không gian của anh bị hư hại trong một cuộc tấn công của hải tặc. Chế độ lái tự động đưa anh trong tình trạng bất tỉnh đến [[station/78]].", false],
		[2, "", "Tại đó anh được thương nhân quặng [[character/2]] cứu, người đã đòi con tàu của anh làm đồ trục vớt và bắt anh làm thợ mỏ.", false],
		[8, "", "Keith là cựu binh của Hạm đội Không gian Terran, nơi anh từng phục vụ dưới quyền Đô đốc Smith.", false],
		[9, "", "Anh biết được rằng vị đô đốc đã qua đời vì tuổi già và bây giờ đã là năm 3624.", false],
		[10, "", "Khoảng 35 năm đã trôi qua kể từ tai nạn, có vẻ do lỗi của động cơ siêu không gian, vậy mà Keith không hề già đi. Mắc kẹt ở hệ sao xa xôi [[system/15]], anh làm lại từ đầu với [[ship/0]], món quà của Gunant.", false],
		[16, "Cuộc chiến với Void", "Sau một lần bị bắt nhầm, anh gặp lại người bạn cũ [[character/1]] tại [[station/98]] và đánh trận đầu tiên chống lại [[faction/9|Void]].", false],
		[18, "", "Brent tuyển anh làm phi công cho tổ chức nghiên cứu Deep Science, nơi đang điều tra về Void.", false],
		[24, "", "Tại [[station/10]], anh gặp [[character/6]], người đứng đầu dự án, và sớm bị cô thu hút.", false],
		[26, "", "Anh và Carla bị kéo qua một lỗ sâu của Void vào khu vực quê nhà của chúng và tìm được đường trở về.", false],
		[36, "", "Chỉ huy Vossk [[character/7]] biết về quá khứ phục vụ của Keith tại Novaterra.", false],
		[43, "", "Keith hộ tống chiếc tàu chở hàng đã phá hủy tàu mẹ Void và chấm dứt các cuộc đột kích, dù Errkt hy sinh trong cuộc tấn công.", false],
		[45, "Về sau", "Phần thưởng của anh là một đêm bên Carla, người sau đó biến mất để tham gia một dự án bí mật khác và để lại cho anh khoản thanh toán cuối cùng. Xong việc, Keith được tự do ngao du khắp thiên hà.", false],
	],
	"character/1": [
		[16, "", "[[character/1]] là bạn cũ của Keith từ trước tai nạn. Trong 35 năm Keith bị mất, Brent đã thăng lên Trung tá Hải quân và trở thành giám đốc Cơ quan An ninh Liên sao. Anh thân thiện, nói nhiều và thích kể những câu chuyện riêng dài dòng.", false],
		[18, "Cuộc khủng hoảng Void", "Với tư cách người đứng đầu an ninh, anh chủ trì nhóm xử lý khủng hoảng điều phối việc đối phó với [[faction/9|Void]]. Anh tuyển Keith cho Deep Science và bảo đảm anh được trả công hậu hĩnh. Tàu của Keith được sơn lại theo lệnh của anh.", false],
		[19, "", "Khi nhà khoa học [[character/5]] bị bắt cóc, Brent ủng hộ kế hoạch giải cứu của Keith và cung cấp bom EMP tại [[station/55]].", false],
		[32, "", "Nhóm của anh phát triển hệ thống cảnh báo sớm cho biết nơi Void sẽ mở lỗ sâu tiếp theo.", false],
		[35, "", "Cùng với [[character/6]], anh vạch ra kế hoạch phá hủy tàu mẹ Void bằng một tàu chở hàng chất đầy thuốc nổ, và dàn xếp thỏa thuận với chỉ huy Vossk [[character/7]].", false],
		[43, "Về sau", "Sau khi tàu mẹ bị phá hủy, Brent cùng Keith ăn mừng chiến thắng tại [[station/98]].", false],
	],
	"character/2": [
		[2, "", "[[character/2]] là một thương nhân quặng người [[faction/2]], điều hành một trạm khai thác nhỏ tại [[station/78]] trong hệ sao [[system/15]]. Ông tìm thấy xác tàu của [[character/0]], cứu viên phi công và đòi con tàu làm đồ trục vớt. Cộc cằn và thực tế, ông bắt Keith trả nợ bằng cách khai thác quặng trên [[ship/0]], một con tàu cũ do chính ông chắp vá.", false],
		[8, "", "Khi Keith giúp ông tiêu diệt một sào huyệt hải tặc gần trạm, Gunant bắt đầu nể trọng anh.", false],
		[10, "", "Để tỏ lòng biết ơn, ông tặng [[ship/0]] cho Keith kèm một động cơ tốt hơn, và gửi anh đến gặp người bạn [[character/3]]. Bản thân Gunant là thành viên của [[faction/3|Liên minh Mido]]. Ông tự thiết kế tia laser khai thác, và với tư cách đặc vụ [[agent/11]], ông bán bản thiết kế của một trong số đó, [[item/90]].", false],
	],
	"character/20": [
		[32, "", "[[character/20]] là một nhà khoa học người [[faction/7|Grey]] làm việc cho Deep Science. Ông đề nghị gặp [[character/0]] tại [[station/10]].", false],
		[33, "", "Khador nói năng hết sức lịch thiệp, cầu kỳ. Sau khi nghiên cứu xác tàu Void, ông tin rằng những tinh thể chỉ có ở khu vực Void nắm giữ bí mật về các lỗ sâu của chúng. Ông đã dành nhiều năm phát triển một loại động cơ có thể đưa con tàu đến bất kỳ điểm nào trong không gian ngay tức thì, và nhờ Keith thu thập 50 [[item/164]] cho nó.", false],
		[34, "", "Khi Keith giao các tinh thể, Khador thưởng cho anh một bản sao bản thiết kế của loại động cơ mang tên ông, [[item/85]].", false],
	],
	"character/3": [
		[10, "", "[[character/3]] là một đại úy loài người đã gia nhập [[faction/3|Liên minh Mido]] và nay chỉ huy [[station/79]]. [[character/2]] giới thiệu ông với Keith như một người có thể giúp anh trở về vùng không gian Terran.", false],
		[11, "", "Norris chào đón Keith và giải thích lịch sử của hệ sao [[system/15]]. Ông đề nghị giúp Keith liên lạc với Hạm đội Không gian Terran nếu trước hết Keith điều tra sự im lặng tại [[station/76]].", false],
		[13, "", "Ông sắp xếp để Keith gặp một đoàn tàu Terran đi qua hệ sao, và gợi ý anh nhận công việc tự do trong lúc chờ đợi.", false],
	],
	"character/4": [
		[12, "", "[[character/4]] là một tay buôn khét tiếng mà Keith quen từ lâu. Keith tìm thấy hắn tại [[station/76]], nơi hắn đã cung cấp cho toàn bộ thủy thủ đoàn tảo thần kinh, một loại ma túy có tác dụng phụ khó chịu. Mkkt nhớ ra Keith và tò mò không hiểu sao anh không già đi.", false],
		[13, "", "Nghe báo cáo của Keith, [[character/3]] hứa sẽ xử lý hắn.", false],
	],
	"character/5": [
		[18, "", "Tommy là Trung úy Thomas Boyle, một nhà khoa học làm việc cho Deep Science. [[character/1]] sắp xếp để anh ta gặp Keith tại [[station/56]] và dẫn Keith đến trạm nghiên cứu bí mật của tổ chức.", false],
		[19, "", "Boyle bị hải tặc bắt cóc gần [[station/55]] trước cuộc gặp, và chúng đòi tiền chuộc.", false],
		[23, "", "Sau khi Keith vô hiệu hóa tàu của bọn bắt cóc, Boyle được giải cứu. Anh ta trao cho Keith tọa độ của hệ sao [[system/6]] và cùng anh đến [[station/10]].", false],
	],
	"character/6": [
		[23, "", "Tiến sĩ Paolini là nhà khoa học của Deep Science đang chờ Keith và Boyle tại [[station/10]].", false],
		[24, "", "Tiến sĩ Carla Paolini đứng đầu dự án nghiên cứu [[faction/9|Void]] của Deep Science. Cô quyết đoán, chăm chỉ và nhất quyết tận mắt chứng kiến Void, nên đã bay cùng [[character/0]] trong nhiệm vụ trục vớt đầu tiên của anh. Keith bị cô thu hút ngay từ lần gặp đầu tiên.", false],
		[26, "", "Cô và Keith bị kéo qua một lỗ sâu vào khu vực quê nhà của Void và cùng nhau thoát hiểm trong gang tấc.", false],
		[28, "", "Nhóm của cô chế tạo một tàu thăm dò để phân tích tàu mẹ Void. Cô đồng ý hẹn hò với Keith nếu anh còn sống trở về sau nhiệm vụ.", false],
		[34, "", "Quá bận rộn với nghiên cứu nên không thể giữ hẹn, cô cùng [[character/1]] vạch ra kế hoạch tấn công tàu mẹ.", false],
		[44, "Về sau", "Sau chiến thắng, cô đến gặp Keith và Brent tại [[station/98]] cho buổi hẹn hò bị trì hoãn bấy lâu.", false],
		[45, "", "Sáng hôm sau cô đã đi, chỉ để lại một mẩu giấy: cô đã rời đi để tham gia một dự án bí mật khác và nhờ Keith đừng tìm cô.", false],
	],
	"character/7": [
		[35, "", "[[character/7]] là một chỉ huy người [[faction/1]] phụ trách [[station/29]] trong hệ sao [[system/5]]. Ông cung cấp tàu chở hàng K'Sarr cho cuộc tấn công tàu mẹ Void, để đổi lấy tù nhân.", false],
		[36, "", "Kiêu hãnh và trịnh trọng, ông tin rằng chỉ người Vossk mới lái được tàu Vossk cho ra hồn và nhất quyết tự mình lái tàu chở hàng. Ông thử thách tài năng của Keith trước khi chấp nhận anh làm người hộ tống.", false],
		[37, "", "Sau khi Keith đánh bại ông trong một cuộc so tài tại sào huyệt hải tặc, Errkt đối xử với anh bằng sự tôn trọng.", false],
		[40, "", "Trước nhiệm vụ, ông điềm tĩnh và trầm lặng, điều mà Brent hiểu là sự quyết tâm.", false],
		[42, "Hy sinh", "Errkt lái tàu chở hàng qua lỗ sâu và lao vào tàu mẹ. Khi khoang cứu sinh bị phá hủy, ông từ chối quay lại và hy sinh trong vụ nổ, sau khi đã bảo Keith rời đi an toàn.", false],
		[43, "", "Brent hứa sẽ báo cáo sự hy sinh của ông lên Đế chế Vossk.", false],
	],
	"character/8": [
		[40, "", "Trung úy [[character/8]] chỉ huy phi đội tiếp viện cùng Keith bảo vệ tàu chở hàng Vossk trên đường đến lỗ sâu.", false],
		[41, "", "Phi đội của anh không kịp qua lỗ sâu trước khi nó đóng lại, nên Keith và [[character/7]] phải một mình đối mặt với Void.", false],
	],
	"chart": [
		[0, "", "Bản đồ thiên hà liệt kê mọi hệ sao cùng phe, mức an ninh, số trạm và vị trí trên bản đồ. Vị trí được cho bằng hai số từ 0 đến 100: số thứ nhất tính từ mép trái bản đồ sao, số thứ hai tính từ mép trên. Các hệ sao có số gần nhau thì nằm gần nhau.", false],
		[0, "", "Trong trò chơi, hãy mở bản đồ sao từ trạm hoặc khi đang bay. Một đường nét đứt nối hệ sao hiện tại của bạn với mọi hệ sao mà cổng nhảy của nó dẫn tới; các tuyến cổng khác hiện dưới dạng đường mảnh. Những ngôi sao bạn có thể đến ngay bây giờ thì sáng, số còn lại bị làm mờ. Các dấu hiệu chỉ hệ sao của nhiệm vụ cốt truyện và của công việc hiện tại, và một đường nét đứt có màu chỉ tuyến cổng ngắn nhất đến đó. Một đường vàng nhạt vẽ lại vài chuyến đi gần nhất của bạn.", false],
		[0, "", "Chọn một hệ sao để xem phe, mức an ninh và khoảng cách. Phóng to để xem các trạm, cấp công nghệ của chúng, cùng dấu hiệu cho trạm bạn đã ghé, mục tiêu nhiệm vụ và cổng nhảy. Hệ sao ẩn không xuất hiện cho đến khi bạn biết tọa độ của chúng; xem [[world/galaxy]].", false],
		[32, "", "Khi bạn đã có hệ thống cảnh báo sớm từ [[step/31]], bản đồ sao còn đánh dấu hệ sao và trạm nơi lỗ sâu Void tiếp theo sẽ mở ra.", false],
	],
	"faction/0": [
		[0, "", "Người Terran là loài người, và [[character/0]] là một trong số họ. Họ nắm mười hệ sao, nhiều hơn bất kỳ phe nào khác, trải khắp trung tâm, phía bên phải và phía dưới bản đồ, với [[system/19]] và [[system/14]] là trung tâm. Vùng không gian Terran là phần an toàn nhất của thiên hà: cả hai hệ sao An toàn đều thuộc Terran.", false],
		[0, "", "Các trạm Terran bán nhiều loại tàu và trang bị nhất. Người bán tàu bên ngoài vùng không gian Vossk có nhiều loại tàu để lựa chọn. Đối thủ truyền thống của người Terran là [[faction/1]]: uy tín có được với bên này sẽ mất đi ở bên kia.", false],
		[16, "", "Hạm đội Không gian Terran vẫn là lực lượng [[character/0]] từng phục vụ, nhưng 35 năm đã trôi qua. Khi cuối cùng anh gặp một đoàn tàu Terran, họ nhầm con tàu cũ do hải tặc đóng của anh là tàu địch và bắt giữ anh.", false],
		[18, "", "Người Terran dẫn đầu cuộc phòng thủ chống lại Void. [[character/1]], nay là người đứng đầu Cơ quan An ninh Liên sao, chủ trì một nhóm xử lý khủng hoảng, và nhóm nghiên cứu Deep Science giải quyết vấn đề từ một trạm bí mật.", false],
	],
	"faction/1": [
		[0, "", "Người Vossk là một dân tộc ngoài hành tinh được tổ chức thành một đế chế. Họ nắm sáu hệ sao ở góc dưới bên phải bản đồ, từ [[system/3]] và [[system/12]] xuống đến [[system/21]] xa xôi. Bốn trong số đó được xếp hạng Nguy hiểm hoặc Rủi ro. [[system/10]] hoàn toàn không có liên kết cổng.", false],
		[0, "", "Người bán tàu Vossk chỉ bán một loại tàu, [[ship/9]], một mẫu đã được điều chỉnh cho các chủng tộc khác. Các trạm Vossk cũng bán vũ khí và trang bị không có ở nơi nào khác. Người Vossk là đối thủ truyền thống của [[faction/0|người Terran]], nên tàu của họ có thể tham gia cùng kẻ cướp trong vùng không gian Terran và ngược lại.", false],
		[18, "", "Quan hệ giữa người Terran và Đế chế Vossk vẫn lạnh nhạt và khó đoán, nhưng các cuộc đột kích của Void cũng giáng xuống các hệ sao Vossk.", false],
		[36, "", "Trong cốt truyện, người Vossk tỏ ra kiêu hãnh và trọng danh dự. Chỉ huy của họ, [[character/7]], nhất quyết tự mình lái tàu chở bom và thử thách [[character/0]] bằng một cuộc so tài trước khi chấp nhận anh làm người hộ tống.", false],
		[42, "", "[[character/7]] hy sinh mạng sống để phá hủy tàu mẹ Void, và người Terran hứa sẽ báo cáo chiến công của ông lên Đế chế Vossk.", false],
	],
	"faction/2": [
		[0, "", "Người Nivelian là một dân tộc ngoài hành tinh nắm bốn hệ sao ở phía bên trái bản đồ: [[system/2]], [[system/9]], [[system/17]] và [[system/0]] bị ẩn. Các trạm của họ trải từ những tiền đồn nhỏ đến một số trạm tiên tiến nhất thiên hà. Đối thủ của họ là [[faction/3|người Midorian]].", false],
		[2, "", "Người đầu tiên [[character/0]] gặp là một người Nivelian, thương nhân quặng [[character/2]]. [[character/0]] chẳng mấy coi trọng cách cư xử của người Nivelian, trong khi [[character/2]] khăng khăng mình là một doanh nhân trung thực.", false],
		[11, "", "Một cuộc nội chiến Nivelian đã khai sinh ra [[faction/3|Liên minh Mido]]. Người Nivelian chưa bao giờ chấp nhận nền độc lập của nó và vẫn đòi chủ quyền hệ sao [[system/15]].", false],
		[35, "", "Kế hoạch chống lại tàu mẹ Void dựa vào thuốc nổ hạt nhân Nivelian.", false],
	],
	"faction/3": [
		[0, "", "Người Midorian là cư dân của [[faction/3|Liên minh Mido]]. Họ nắm hai hệ sao ở góc trên bên trái bản đồ, [[system/15]] và [[system/4]], cả hai đều được xếp hạng Nguy hiểm. Các trạm của họ phần lớn nhỏ và có công nghệ thấp. Đối thủ của họ là [[faction/2|người Nivelian]].", false],
		[11, "", "Liên minh được thành lập bởi những người tị nạn và kẻ ngoài vòng pháp luật gốc Terran và Nivelian trong cuộc Nội chiến Nivelian. Liên minh hạn chế tối đa liên lạc với các hệ sao khác. [[character/3]], chỉ huy của [[station/79]], là một thành viên, và [[character/2]] cũng vậy.", false],
		[38, "", "Liên minh không hề thân thiện với người Nivelian. Tàu của họ chiếm giữ đoàn tàu chở thuốc nổ Nivelian dành cho tàu mẹ Void, và [[character/0]] phải giành lại nó gần [[station/22]].", false],
	],
	"faction/4": [
		[0, "", "Multipod là một chủng tộc nhỏ không có hệ sao riêng. Multipod duy nhất bạn gặp là đặc vụ [[agent/6]], người bán một bản thiết kế trong phòng chờ của [[station/61]] tại [[system/12]].", false],
	],
	"faction/5": [
		[0, "", "Cyborg không có lãnh thổ. Cyborg duy nhất trong trò chơi là đặc vụ [[agent/14]] trong phòng chờ của [[station/65]], người buôn bán tọa độ của một hệ sao ẩn.", false],
	],
	"faction/6": [
		[0, "", "Người Bobolian là một chủng tộc nhỏ không có hệ sao riêng. Đặc vụ [[agent/13]], một người Bobolian, ngồi trong phòng chờ của [[station/26]] trong vùng không gian Vossk và bán tọa độ của một hệ sao ẩn.", false],
	],
	"faction/7": [
		[0, "", "Người Grey là một chủng tộc không có hệ sao, trạm hay tàu riêng. Họ không tham gia vào thương mại hay chiến đấu.", false],
		[32, "", "Người Grey duy nhất trong cốt truyện là [[character/20]], một nhà khoa học làm việc với Deep Science; xem [[world/khador]].", false],
		[33, "", "Ông nghiên cứu xác tàu Void và từ đó phát triển một loại động cơ mới.", false],
	],
	"faction/8": [
		[0, "", "Hải tặc là những kẻ ngoài vòng pháp luật thuộc mọi chủng tộc. Chúng không nắm hệ sao nào nhưng xuất hiện ở khắp nơi, và luôn thù địch. Tần suất chúng phục kích gần trạm phụ thuộc vào mức an ninh của hệ sao. Nhiều công việc tự do yêu cầu bạn săn lùng chúng, và xác tàu của chúng có thể bị cướp lấy hàng hóa.", false],
		[0, "", "Cốt truyện mở đầu bằng cảnh [[character/0]] truy đuổi một băng hải tặc để lĩnh tiền thưởng.", false],
		[2, "", "[[ship/0]], con tàu [[character/2]] cho [[character/0]] mượn, vốn là một tàu hải tặc.", false],
		[16, "", "Đây là lý do người Terran về sau nhầm anh là hải tặc.", false],
		[19, "", "Hải tặc cũng bắt cóc [[character/5]] gần [[station/55]] và đòi tiền chuộc.", false],
	],
	"faction/9": [
		[0, "", "Void là một thế lực thù địch tấn công không báo trước. Chúng không nắm hệ sao nào trên bản đồ, và tàu của chúng nổ súng vào tất cả mọi người. Chiến đấu cơ của chúng, [[ship/8]], là thân tàu được bọc giáp dày nhất trong trò chơi. Xem [[world/voids]].", false],
		[2, "", "Ở [[system/15]], Void chỉ được biết đến qua tin đồn và những lần hiếm hoi bị trông thấy.", false],
		[16, "", "Một phi đội Void tấn công [[station/98]] khi [[character/0]] đang ở đó. Các thông điệp vô tuyến của chúng khẳng định ý định hòa bình trong khi vẫn nổ súng.", false],
		[18, "", "Void đến qua các lỗ sâu mở ra gần trạm trong thời gian ngắn. Chúng đột kích các hệ sao Terran, Nivelian và Vossk như nhau và dường như đang tìm quặng. Không ai biết chúng đến từ đâu.", false],
		[24, "", "Tại [[station/48]], chúng phát đi một lời khẳng định còn kỳ lạ hơn: rằng chúng đến từ tương lai và là tất cả những gì còn lại của các nền văn minh trong thiên hà.", false],
		[26, "", "Một lỗ sâu dẫn đến khu vực riêng của chúng, nơi một con tàu mẹ khổng lồ phóng ra các chiến đấu cơ.", false],
		[35, "", "Tàu mẹ dường như là nguồn gốc của các lỗ sâu.", false],
		[42, "", "Việc phá hủy tàu mẹ trong [[step/41]] làm các lỗ sâu sụp đổ và chấm dứt các cuộc đột kích, ít nhất là trong lúc này.", false],
	],
	"guide/basics": [
		[0, "Màn mở đầu", "Một trò chơi mới bắt đầu ngoài không gian chứ không phải ở trạm. [[character/0]] đang truy đuổi một băng hải tặc qua một bãi tiểu hành tinh, và chuyến bay đầu tiên là một trận đánh ngắn dạy cách lái, ngắm và bắn. Trong lúc đó chỉ có tâm ngắm và dấu hiệu tàu được hiển thị. Hãy tiêu diệt bọn hải tặc và để cảnh diễn ra; sau đó cốt truyện tự tiếp tục.", false],
		[2, "", "Sau màn mở đầu, bạn tỉnh dậy tại [[station/78]], một trạm khai thác nhỏ do [[character/2]] điều hành. Ông cho bạn mượn [[ship/0]], một con tàu không vũ trang có tia laser khai thác, và các bước đầu tiên dạy cách khai thác, dùng lái tự động và cập cảng. Vũ khí, bản đồ và các phần còn lại của trạm sẽ mở dần khi cốt truyện tiến triển.", false],
		[0, "Cập cảng", "Để cập cảng, hãy giữ tâm ngắm trên một trạm cho đến khi khóa mục tiêu, rồi nhấn Bắn: lái tự động sẽ tiếp quản và đưa bạn vào. Bạn cũng có thể tự bay vào trạm; tàu cập cảng ngay khi chạm vào vỏ trạm. Cập cảng là lúc phần lớn sổ sách được xử lý. Thân tàu, giáp và khiên của bạn được phục hồi miễn phí, hàng giao và hành khách được bàn giao, hàng sản xuất từ bản thiết kế đã hoàn thành được nhận, huy chương mới được trao và trò chơi tự động lưu.", false],
		[0, "Các màn hình trạm", "Một trạm đã cập cảng có sáu mục: Hangar, Phòng chờ, Bản đồ, Nhiệm vụ (Missions), Trạng thái (Status) và Tùy chọn trò chơi (Game Options). Đầu cốt truyện, một số mục bị khóa và hiển thị kèm ổ khóa. Hangar mở từ [[step/5]], Bản đồ từ [[step/9]], còn Phòng chờ và Nhiệm vụ từ [[step/13]]. Trạng thái và Tùy chọn trò chơi luôn sẵn có.", false],
		[0, "", "Hangar gồm Cửa hàng (Shop: mua bán hàng hóa và trang bị), Tàu (lắp và tháo trang bị), mục Tàu của người bán tàu (Ships, ở những trạm có người bán) và Bản thiết kế (sản xuất). Phòng chờ là nơi khách hàng, thương nhân và phi công đánh thuê ngồi chờ. Bản đồ hiển thị thiên hà và cho phép chọn điểm đến. Nhiệm vụ liệt kê mục tiêu cốt truyện hiện tại và công việc tự do bạn đã nhận. Trạng thái hiển thị hồ sơ phi công, uy tín của bạn với bốn chủng tộc lớn và các huy chương. Thanh trên cùng hiển thị cấp công nghệ của trạm (Tec Level), quyết định cửa hàng có thể bày bán những gì.", false],
		[0, "Rời trạm", "Nhấn Khởi hành (Depart) để xuất phát. Mỗi chuyến bay mở đầu bằng vài giây xem tàu của bạn rời đi, kèm thông tin hệ sao và một mẹo; nhấn phím bất kỳ, nhấp hoặc chạm để bỏ qua. Nếu bạn đã chọn điểm đến trên Bản đồ trước khi rời đi, lái tự động sẽ đặt hướng đến đó ngay khi xuất phát xong. Bạn không thể rời đi khi chở nhiều hàng hơn sức chứa của khoang hàng, vì vậy hãy bán hoặc lắp phần dư trước.", false],
		[0, "Lưu trò chơi", "Trò chơi tự động lưu sau mỗi lần cập cảng hoàn tất, khi phần thưởng và bước cốt truyện tiếp theo đã được xử lý xong. Bạn cũng có thể tự lưu vào một trong ba ô lưu từ Tùy chọn trò chơi khi đang ở trạm, và tải bất kỳ ô nào hoặc bản tự động lưu từ đó hoặc từ màn hình tiêu đề. Ngoài phiên bản trình duyệt, Tùy chọn trò chơi còn có thể xuất bản lưu ra tệp và nhập lại. Bản lưu gắn với dữ liệu trò chơi đã tạo ra nó.", false],
		[0, "", "Nếu tàu của bạn bị phá hủy, chuyến bay kết thúc và bạn tiếp tục từ trạm của bản tự động lưu gần nhất, hoặc bắt đầu lại nếu chưa có. Mọi thứ kiếm được kể từ lần cập cảng đó sẽ mất, vì vậy hãy thỉnh thoảng cập cảng trong những chuyến đi dài.", false],
		[0, "Cấp phi công", "Phi công của bạn có một cấp độ, hiển thị trên màn hình Trạng thái. Kinh nghiệm đến từ số tàu hạ được, công việc tự do (mỗi việc hai điểm), lõi khai thác được, mỗi năm mươi tấn quặng khai thác và mỗi hai phi công hộ tống được thuê. Cấp độ tăng thêm một mỗi khi kinh nghiệm vượt quá 1,3 lần mức của lần tăng cấp trước, và được kiểm tra khi bạn cập cảng. Cấp càng cao thì kẻ địch càng mạnh, nhưng phần thưởng công việc tự do và phí thuê phi công cũng tăng theo.", false],
	],
	"guide/blueprints": [
		[0, "Bản thiết kế", "Một số vũ khí và trang bị tốt nhất không bao giờ được bán ở cửa hàng. Thay vào đó chúng được chế tạo từ bản thiết kế. Một bản thiết kế liệt kê các loại hàng hóa cần thiết và số lượng. Bản thiết kế được mua từ các đặc vụ có tên trong Phòng chờ, những người xuất hiện khi cốt truyện đã qua [[step/16]]; mỗi đặc vụ bán một bản thiết kế, một lần.", false],
		[34, "", "Bản thiết kế động cơ nhảy [[item/85]] không được ai bán: cốt truyện trao nó cho bạn trong [[step/34]].", false],
		[0, "Sản xuất", "Việc sản xuất diễn ra ở thẻ Bản thiết kế trong Hangar. Chọn một bản thiết kế và giao các thành phần từ khoang hàng. Bạn có thể giao từng phần qua nhiều lần ghé. Trạm nơi bạn giao lần đầu tiên sẽ trở thành trạm sản xuất cho mẻ đó. Thành phần giao tại bất kỳ trạm nào khác sẽ được chuyển đến đó với giá 10 credit mỗi tấn, vì vậy nên mang mọi thứ đến cùng một nơi.", false],
		[0, "Thành phẩm", "Khi thành phần cuối cùng được giao, mẻ hàng hoàn thành. Vũ khí phụ được làm mười cái một lần; mọi thứ khác một cái một lần. Nếu bạn hoàn tất tại trạm sản xuất, hàng đi thẳng vào khoang hàng, ngay cả khi điều đó làm khoang bị quá tải. Nếu không, hàng sẽ chờ ở trạm sản xuất và được giao vào lần tới bạn cập cảng ở đó. Bản thiết kế không bao giờ bị dùng hết: khi một mẻ đã xong, bạn có thể bắt đầu mẻ tiếp theo.", false],
		[0, "Huy chương", "Sở hữu bản thiết kế được tính cho [[medal/13]], và hoàn thành các bản thiết kế khác nhau được tính cho [[medal/14]].", false],
	],
	"guide/combat": [
		[0, "Vũ khí chính", "Vũ khí chính là các loại súng cố định bắn về phía trước: laser, blaster, pháo tự động và vũ khí nhiệt. Mỗi loại có sát thương, tốc độ bắn, tầm bắn và tốc độ đạn riêng, và mọi vũ khí chính được lắp sẽ bắn cùng lúc. Một số blaster, như [[item/16]], là vũ khí EMP làm cạn năng lượng của tàu thay vì thân tàu. Tự động bắn giữ cho súng bắn vào mục tiêu mà không cần giữ nút.", false],
		[0, "Khiên, giáp và thân tàu", "Sát thương trước tiên làm cạn khiên, sau đó đến tấm giáp, và chỉ khi đó mới đến thân tàu. Khiên tự nạp đầy hoàn toàn sau thời gian nạp lại; giáp và thân tàu thì không. Robot sửa chữa từ từ vá lại cả thân tàu lẫn giáp trong khi bay. Cập cảng phục hồi mọi thứ miễn phí. Khi thân tàu cạn, con tàu bị phá hủy.", false],
		[0, "EMP", "Mỗi con tàu có một nguồn dự trữ năng lượng. Vũ khí EMP làm cạn nó, và tàu cạn năng lượng sẽ bị vô hiệu hóa: nó trôi vô định cho đến khi năng lượng được tích lại. Tàu bị vô hiệu hóa có thể bị cướp hàng bằng chùm tia kéo, và một số công việc yêu cầu vô hiệu hóa tàu thay vì phá hủy. Trang bị chống EMP, như [[item/60]], có chỉ số phòng thủ EMP.", false],
		[0, "Vũ khí phụ", "Vũ khí phụ được bắn từ các ô vũ khí phụ và tiêu hao đạn dược, vốn được xếp chồng trong ô. Rocket bay thẳng. Ngư lôi đổi hướng theo mục tiêu khóa radar ngay sau khi phóng. Bom EMP và bom hạt nhân nổ trên một vùng và đánh trúng mọi thứ trong phạm vi vụ nổ, yếu dần về phía rìa; bom EMP không ảnh hưởng đến tiểu hành tinh, còn bom hạt nhân thì phá vỡ chúng. Chọn bệ phóng muốn dùng từ menu Hành động; cho đến khi bạn chọn, phím Vũ khí phụ sẽ bắn bệ phóng đầu tiên có đạn.", false],
		[0, "Tháp pháo", "Các thân tàu lớn hơn có ô tháp pháo. Khi đã lắp tháp pháo, phím Nhìn sau sẽ chuyển sang góc nhìn tháp pháo: tàu giữ nguyên hướng bay trong khi bạn xoay tháp pháo và bắn, giúp bạn phản công những con tàu bám đuôi.", false],
		[0, "Phi công hộ tống", "Từ [[step/16]] trở đi, bạn có thể gặp phi công đánh thuê trong Phòng chờ. Một hợp đồng gồm từ một đến ba tàu cho mười phút bay, và họ bay cùng bạn đến bất cứ đâu cho đến khi hết hạn. Ra lệnh cho họ từ menu Hành động: tự do khai hỏa, tấn công mục tiêu của bạn, bảo vệ điểm mốc nhiệm vụ tiếp theo, hoặc chuyển đổi giữa laser và blaster EMP của họ. Xem [[guide/lounge]].", false],
		[0, "Hải tặc", "Hải tặc đột kích các trạm, thường xuyên hơn ở hệ sao nguy hiểm, và rình rập những phi công chở hàng hoặc chở khách. Nhiều công việc tự do xoay quanh việc chiến đấu với chúng. Bắn hải tặc không làm ai phật lòng; nó còn cải thiện chút ít uy tín của bạn với chủng tộc cai quản hệ sao.", false],
		[0, "Uy tín", "Uy tín của bạn được tính trên hai thang, mỗi thang từ -100 đến 100: một giữa chủng tộc [[faction/0]] và [[faction/1]], một giữa chủng tộc [[faction/2]] và [[faction/3]]. Gây hại cho một chủng tộc sẽ đẩy thang về phía đối thủ của họ: vô hiệu hóa hoặc cướp một con tàu của họ mất 2 điểm, hạ một tàu mất 5 điểm. Hoàn thành một công việc tự do đẩy thang 2 điểm về phía chủng tộc của khách hàng. Khi một thang vượt quá 60 theo bất kỳ hướng nào, chủng tộc ở phía bất lợi sẽ trở nên thù địch, và tàu của họ tấn công bạn ngay khi nhìn thấy.", false],
		[0, "", "Một chủng tộc thù địch sẽ cử một nhà ngoại giao đến các Phòng chờ, đề nghị đưa thang về không với một khoản phí tăng theo mức độ lệch: tối đa 16.000 credit. Trạng thái hiển thị cả hai thang. Đẩy một thang vượt quá 60 cũng mang lại [[medal/28]].", false],
		[0, "Bắn nhầm phe ta", "Tàu của chủng tộc sở tại chỉ chịu đựng đạn lạc đến một mức nhất định. Khi bạn đã làm mất một phần ba thân tàu hoặc năng lượng của một tàu địa phương, nó sẽ phản công và cảnh báo bạn qua vô tuyến. Khi mất hai phần ba thân tàu, hoặc khi bạn vô hiệu hóa nó, mọi tàu của chủng tộc đó trong hệ sao sẽ quay sang tấn công bạn. Tàu của các chủng tộc khác ít nhạy cảm hơn, nhưng hạ một tàu luôn làm mất uy tín.", false],
	],
	"guide/fitting": [
		[0, "Thân tàu", "Thân tàu quyết định giáp (độ bền của chính thân tàu), khoang hàng, độ linh hoạt và các ô: vũ khí chính, vũ khí phụ, tháp pháo và trang bị. Thân tàu tốt hơn chủ yếu nghĩa là có nhiều ô hơn. Các trang tàu so sánh mọi loại thân tàu.", false],
		[0, "Ô và màn hình Tàu", "Vật phẩm được mua vào khoang hàng rồi lắp trên màn hình Tàu trong Hangar. Mỗi ô nhận một vật phẩm thuộc loại của nó; lắp vào một ô đã có đồ sẽ đưa vật phẩm cũ trở lại khoang hàng. Mỗi loại trang bị chỉ lắp được một lần, trừ các loại có thể xếp chồng, như bộ nén hàng hóa, cabin và trang bị chống EMP, có thể lắp nhiều cái, mỗi cái một ô riêng. Đạn dược vũ khí phụ cùng loại dùng chung một ô. Vật phẩm đã lắp cũng có thể được bán thẳng từ ô của nó theo giá của trạm.", false],
		[0, "Các loại trang bị", "Khiên hấp thụ sát thương và tự nạp lại. Tấm giáp tăng độ bền cho thân tàu. Trang bị chống EMP bảo vệ khỏi bị hút cạn năng lượng. Bộ nén hàng hóa mở rộng khoang hàng. Chùm tia kéo kéo hàng hóa từ xác tàu và tàu bị vô hiệu hóa; không có nó, không thể thu gom gì ngoài không gian. Bộ tăng tốc cho những đợt bứt tốc. Robot sửa chữa vá tàu trong khi bay. Vòi lái cải thiện độ linh hoạt. Máy quét rút ngắn thời gian khóa mục tiêu, và loại tốt hơn còn hiển thị hàng hóa của mục tiêu. Laser khai thác khoan tiểu hành tinh. Cabin chở hành khách. Thiết bị tàng hình che giấu tàu trong một thời gian. Động cơ nhảy di chuyển mà không cần cổng.", false],
		[0, "Mua thân tàu", "Các trạm có người bán tàu hiển thị thẻ Tàu (Ships) trong Hangar với tối đa năm thân tàu được rao bán. Người bán [[faction/1]] chỉ bán thân tàu của chủng tộc mình, [[ship/9]]. Người bán giảm giá niêm yết theo phần trăm bằng cấp công nghệ của trạm, nên các trạm công nghệ cao bán thân tàu rẻ hơn. Thân tàu cũ của bạn được nhận đổi với giá bằng bốn phần năm giá niêm yết. Mọi thứ đã lắp sẽ được chuyển vào khoang hàng, vì vậy hãy kiểm tra xem có vừa không hoặc bán bớt trước khi rời đi. Bạn không thể đổi thân tàu khi có hành khách trên tàu, và không thể tháo cabin khi chúng đang được sử dụng.", false],
		[5, "Vũ khí đầu tiên", "Khi hangar tại [[station/78]] mở lần đầu, kệ hàng có sẵn một laser, một pháo tự động và một tấm giáp miễn phí. Hãy lắp một khẩu súng và tấm giáp trước khi lên đường làm nhiệm vụ tiếp theo.", false],
		[0, "Thân tàu hiếm", "Một số thân tàu không bao giờ được người bán thông thường rao bán. Phi công đã giành mọi huy chương ở hạng vàng sẽ được chào bán một nguyên mẫu, [[ship/8]], tại [[station/10]]; xem [[guide/medals]].", false],
	],
	"guide/flight": [
		[0, "Lái", "Tàu luôn bay về phía trước. Bạn xoay nó sang trái, sang phải và ngóc mũi lên hay chúc xuống; khi buông tay, tàu tự cân bằng cánh. Tốc độ xoay phụ thuộc vào độ linh hoạt của thân tàu và vòi lái được lắp thêm. Trong Tùy chọn, Điều khiển, Phản hồi lái có thể là Trực tiếp, quay hết tốc ngay lập tức, hoặc Mượt, tăng và giảm dần khi vào và ra khỏi vòng quay. Khi lái bằng chuột, phím trái và phải có thể làm tàu dạt ngang thay vì xoay.", false],
		[0, "Ga", "Tăng lực đẩy và Giảm lực đẩy thay đổi mức ga theo từng nấc một phần tư, và giữ phím sẽ tiếp tục chuyển nấc. Tàu cần khoảng một giây để ổn định ở tốc độ mới. Lái tự động và bộ tăng tốc luôn bay hết ga, và giảm ga trong khi tăng tốc sẽ kết thúc lượt tăng tốc.", false],
		[0, "Bộ tăng tốc", "Khi đã lắp bộ tăng tốc, phím Tăng tốc cho một đợt bứt tốc. Mỗi đợt kéo dài theo thời lượng của bộ tăng tốc, sau đó cần một khoảng thời gian nạp lại trước lượt kế tiếp; HUD cho biết khi nào nó sẵn sàng. Bộ tăng tốc tốt hơn thì nhanh hơn, kéo dài hơn hoặc nạp lại sớm hơn. Tăng tốc hữu ích để thoát khỏi trận đánh và để vượt những quãng đường dài trong một hệ sao.", false],
		[0, "Lái tự động", "Phím Lái tự động giao quyền lái cho máy tính của tàu, và nhấn lần nữa để lấy lại. Nó bay đến vật thể đang được khóa, hoặc nếu không thì đến điểm đến đã chọn trên Bản đồ: cổng nhảy khi điểm đến ở hệ sao khác, hoặc hành tinh của điểm đến nếu ở hệ sao này. Danh sách lái tự động đưa ra những lựa chọn có sẵn tại nơi bạn đang ở: điểm đến đã lập trình, cổng nhảy, trạm này, bãi tiểu hành tinh và điểm mốc nhiệm vụ tiếp theo. Bay đến một trạm đang được khóa sẽ kết thúc bằng việc cập cảng.", false],
		[0, "Tốc độ thời gian", "Phím Tốc độ thời gian làm chuyến bay diễn ra nhanh hơn. Tốc độ gấp đôi luôn khả dụng khi bạn bay. Gấp bốn và gấp tám chỉ được cung cấp khi lái tự động đang bay, không có kẻ địch ở gần và không có việc gì khác đang diễn ra, như khai thác, cập cảng hay nhảy.", false],
		[0, "Nhắm mục tiêu", "Để khóa một vật thể, hãy giữ nó dưới tâm ngắm cho đến khi quét xong. Máy quét được lắp quyết định thời gian này, từ vài giây với loại cơ bản đến dưới hai giây với loại tốt nhất. Mục tiêu tiếp theo chuyển lần lượt qua các vật thể gần đó mà không cần ngắm vào chúng. Trạm, cổng nhảy và các ngôi sao đánh dấu hành tinh khác được khóa chỉ bằng một lần nhấn. Tác dụng của Bắn phụ thuộc vào vật thể được khóa: với tàu thì bắn, với trạm thì cập cảng, với cổng thì nhảy, với ngôi sao thì di chuyển đến hành tinh đó, và với tiểu hành tinh thì bắt đầu khai thác. Máy quét tốt hơn còn hiển thị hàng hóa của tàu đang được khóa.", false],
		[0, "Dấu hiệu và radar", "Tàu có khung đánh dấu trên màn hình, và mũi tên ở mép màn hình chỉ về mục tiêu, trạm và các mối đe dọa gần đó nằm ngoài tầm nhìn. Kẻ địch được đánh dấu màu đỏ, đồng minh màu xanh lục, tàu trung lập màu vàng và điểm mốc nhiệm vụ màu xanh lam; tùy chọn cho người mù màu trong Tùy chọn, Giao diện đổi chúng thành kẻ địch màu cam và đồng minh màu xanh lam. Tàu ở gần bạn có hai thanh nhỏ cạnh khung đánh dấu: thân tàu và, màu xanh lam, năng lượng EMP. Màn hình bay Mở rộng thêm các bảng hiển thị số liệu chính xác và màn radar tròn; màn hình Bản gốc giữ các bảng góc của chính trò chơi.", false],
		[0, "Nhìn xung quanh", "Nhìn sau xoay camera nhìn về phía sau tàu. Nếu đã lắp tháp pháo, cùng phím đó sẽ chuyển sang góc nhìn tháp pháo: tàu giữ nguyên hướng bay trong khi bạn xoay tháp pháo và bắn. Bạn cũng có thể nhìn quanh tàu mà không cần lái bằng cách giữ Alt và di chuột, dùng cần phải của tay cầm, hoặc kéo ngón tay trên vùng màn hình trống.", false],
		[0, "Tàng hình", "Thiết bị tàng hình che giấu tàu của bạn khỏi các tàu khác trong suốt thời lượng của nó, và bất kỳ ai đang săn đuổi bạn sẽ mất dấu ngay lập tức. Nhấn phím Thiết bị tàng hình lần nữa để tắt sớm. Sau khi dùng, thiết bị cần thời gian nạp lại trước khi hoạt động trở lại.", false],
		[0, "Cập cảng và di chuyển", "Khóa trạm rồi nhấn Bắn, hoặc đơn giản là bay vào trạm, để cập cảng. Các trạm khác trong hệ sao hiện ra như những ngôi sao sáng; khóa một ngôi sao và nhấn Bắn để di chuyển đến hành tinh đó. Hầu hết hệ sao có một cổng nhảy, gần một trong các trạm, để đi đến hệ sao khác; xem [[guide/navigation]]. Trong khi một trận đánh của công việc tự do đang diễn ra tại trạm, bạn không thể cập cảng, di chuyển hay nhảy đi cho đến khi thắng hoặc thua.", false],
	],
	"guide/help": [
		[0, "Bàn phím", "Đây là các phím mặc định. Mọi hành động khi bay đều có thể gán lại phím trong Tùy chọn, Điều khiển, Bàn phím, nơi Khôi phục phím mặc định sẽ hoàn tác các thay đổi.", false],
		[0, "", "Rẽ trái / Rẽ phải: phím mũi tên Trái và Phải, hoặc A và D.", true],
		[0, "", "Ngóc lên / Chúc xuống: phím mũi tên Lên và Xuống.", true],
		[0, "", "Tăng lực đẩy / Giảm lực đẩy: W và S.", true],
		[0, "", "Bắn / dùng: Space hoặc Ctrl. Bắn súng, hoặc cập cảng, nhảy, di chuyển hay khai thác khi một trạm, cổng, ngôi sao hoặc tiểu hành tinh đang được khóa.", true],
		[0, "", "Vũ khí phụ: E.", true],
		[0, "", "Bộ tăng tốc: Shift.", true],
		[0, "", "Lái tự động: Q. Danh sách lái tự động: R. Khi bật Giữ lái tự động để mở danh sách, giữ Q nửa giây sẽ mở danh sách.", true],
		[0, "", "Mục tiêu tiếp theo: Tab.", true],
		[0, "", "Tự động bắn: F.", true],
		[0, "", "Nhìn sau: C. Khi đã lắp tháp pháo, phím này chuyển sang góc nhìn tháp pháo.", true],
		[0, "", "Hành động / động cơ nhảy: M. Mở menu Hành động: chọn vũ khí phụ, tàng hình, ra lệnh cho phi công hộ tống và động cơ nhảy.", true],
		[0, "", "Bản đồ lộ trình: N.", true],
		[0, "", "Thiết bị tàng hình: V.", true],
		[0, "", "Tốc độ thời gian: T.", true],
		[0, "", "Chế độ chụp ảnh: P. Dừng chuyến bay và ẩn giao diện; kéo hoặc dùng phím mũi tên để xoay camera, con lăn hoặc + và - để thu phóng.", true],
		[0, "", "Menu tạm dừng: Escape. F11 bật/tắt toàn màn hình trên máy tính.", true],
		[0, "", "Trong menu, phím mũi tên di chuyển giữa các mục, Enter để chọn và Escape để quay lại.", true],
		[0, "Chuột", "Khi bật Lái bằng chuột, di chuột sẽ lái tàu. Trong lúc bay, con trỏ bị khóa, nên tàu xoay theo chuyển động của chuột; có thể tắt Khóa con trỏ khi bay, và menu cũng như tạm dừng luôn giải phóng con trỏ. Nút trái bắn, nút phải phóng vũ khí phụ, và giữ Alt trong khi di chuột để nhìn quanh tàu. Khi chuột đang lái, phím trái và phải làm tàu dạt ngang; Phím trái / phải trong Tùy chọn, Điều khiển có thể đặt chúng thành Luôn dạt ngang hoặc Luôn xoay. Độ nhạy chuột quyết định tàu xoay bao nhiêu cho mỗi chuyển động.", false],
		[0, "Tay cầm", "Cần trái để lái và cần phải để nhìn quanh tàu. RT hoặc RB để bắn, LB phóng vũ khí phụ, A tăng tốc, Y bật/tắt lái tự động, X chọn mục tiêu tiếp theo, nhấn cần phải để chuyển sang góc nhìn sau hoặc tháp pháo, Back mở menu Hành động và Start để tạm dừng. Trong menu, D-pad để di chuyển, A để chọn và B để quay lại. Tùy chọn, Điều khiển, Tay cầm đặt vùng chết của cần và độ rung.", false],
		[0, "Cảm ứng", "Trên màn hình cảm ứng, các nút điều khiển hiện lên màn hình khi Điều khiển cảm ứng được đặt là Tự động hoặc Bật. Một cần điều khiển ở một bên dùng để lái; theo mặc định nó đến chỗ ngón cái của bạn ở bất cứ đâu ngón tay chạm trên nửa màn hình đó, còn Cần cố định giữ nó tại chỗ. Lái từ bất cứ đâu cho phép ngón tay đặt lên bất kỳ vùng trống nào của màn hình để lái. Các nút ở phía bên kia gồm Bắn / dùng, Phụ, Tăng tốc, Lái tự động, Mục tiêu, Nhìn sau, Hành động, Tạm dừng và, khi có tin nhắn vô tuyến, Đài tiếp theo. Một thanh trượt đặt mức ga, và nút Nhanh hơn tăng tốc thời gian.", false],
		[0, "", "Chạm nhanh hai lần vào Bắn để bật bắn tự động; một lần chạm sẽ dừng. Kéo ngón tay trên vùng màn hình trống để nhìn quanh tàu, thả ra để nhìn thẳng phía trước trở lại. Bố cục tay trái đổi bên các nút, Kích thước điều khiển cảm ứng co giãn các nút, và Điều chỉnh vị trí điều khiển cho phép di chuyển từng nút. Điện thoại và máy tính bảng còn có thể lái bằng cách nghiêng: bật Lái bằng nghiêng máy, cầm thiết bị như khi chơi rồi hiệu chỉnh.", false],
		[0, "Tùy chọn", "Có thể vào Tùy chọn từ màn hình tiêu đề, menu tạm dừng và Tùy chọn trò chơi tại trạm. Tùy chọn có năm trang. Âm thanh đặt âm lượng nhạc và hiệu ứng. Hiển thị gồm cửa sổ, tốc độ khung hình, tỷ lệ khung hình cùng các thiết lập sẵn và chi tiết đồ họa. Điều khiển gồm lái, chuột, tay cầm, cảm ứng và gán phím bàn phím. Giao diện gồm kích thước giao diện, màn hình bay Bản gốc hoặc Mở rộng, kích thước và độ đục HUD, cửa sổ trợ giúp, cảnh xuất phát và hoạt cảnh vào trạm, màn radar, nhãn, cỡ chữ và các cài đặt trợ năng như màu thân thiện với người mù màu, giảm nhấp nháy, rung màn hình và thời gian thông báo. Trò chơi đặt ngôn ngữ engine và cho phép nhập một tệp trò chơi khác hoặc quản lý mod.", false],
		[0, "Trợ giúp", "Trợ giúp, vào được từ cùng những nơi đó, hiển thị các chủ đề trợ giúp và mẹo khi tải của chính trò chơi, danh sách các phím đang được gán, và một bảng chuyển các phím điện thoại được nhắc đến trong văn bản trò chơi sang phím, nút và điều khiển cảm ứng dùng ở đây.", false],
	],
	"guide/jobs": [
		[0, "Tìm việc", "Công việc tự do do khách trong Phòng chờ đưa ra. Khách hàng mô tả công việc và khoản thanh toán. Trước khi nhận một công việc ở nơi khác, bạn có thể hỏi nó ở đâu và khó đến mức nào; bạn cũng có thể đề nghị nghe lại lời đề nghị hoặc từ chối. Bạn chỉ có thể nhận một công việc mỗi lúc, và màn hình Nhiệm vụ hiển thị nó cùng điểm đến và số lần nhảy cổng cần thiết.", false],
		[0, "Các loại công việc", "Có mười ba loại. Cho đến [[step/16]], và trong các bản trò chơi không có đầy đủ chiến dịch, chỉ năm loại được đưa ra: [[job/11]], [[job/0]], [[job/7]], [[job/4]] và [[job/12]]. Sau đó toàn bộ các loại xuất hiện: [[job/1]], [[job/2]], [[job/3]], [[job/5]], [[job/6]], [[job/9]] và [[job/10]], cùng những người mua cần hàng hóa ([[job/8]]).", false],
		[0, "Độ khó và phần thưởng", "Các công việc ban đầu có độ khó một hoặc hai; về sau có thể lên đến chín. Phần thưởng cơ bản của một công việc là 1.500 credit cộng thêm tối đa 5.500 theo độ khó. Sau đó nó được tăng theo khoảng cách đến đích (gấp đôi ở 1.200 km), và cộng thêm 200 credit cho mỗi cấp phi công. Dọn rác vũ trụ trả ít hơn 30 phần trăm, hộ tống trả nhiều hơn 20 phần trăm, thu hồi và trục vớt trả gấp đôi, còn chở khách trả mức cơ bản thấp hơn cộng thêm một khoản cho mỗi hành khách. Phần thưởng được làm tròn đến năm mươi credit.", false],
		[0, "Thực hiện công việc", "Công việc chuyển phát và chở khách được hoàn thành bằng cách cập cảng tại điểm đến với hàng hoặc hành khách trên tàu. Công việc mua hàng được hoàn thành bằng cách cập cảng lại tại trạm của người mua với hàng trong khoang. Tất cả các công việc khác là trận đánh tại trạm đích, được thiết lập khi bạn đến đó; trong khi trận đánh diễn ra, bạn không thể cập cảng, di chuyển hay nhảy đi. Các thùng hàng thu hồi được và con tin sau đó phải được đưa về trạm nơi bạn nhận việc. Khi công việc hoàn tất, phần thưởng được trả ngay, uy tín của bạn với chủng tộc của khách hàng được cải thiện và công việc được tính cho [[medal/16]].", false],
		[0, "Thất bại", "Một trận đánh thất bại nếu điều kiện của nó không còn: mọi con tàu bạn bảo vệ đều bị phá hủy, thùng hàng bị mất, hết thời gian hoặc đối thủ bắn hạ nhiều hơn bạn. Công việc thất bại bị hủy mà không được trả tiền. Bạn cũng có thể bỏ một công việc từ màn hình Nhiệm vụ; hàng chuyển phát sẽ bị thu lại. Nếu tàu của bạn bị phá hủy, bạn tiếp tục từ bản tự động lưu gần nhất.", false],
	],
	"guide/lounge": [
		[0, "Khách", "Mỗi trạm đều có một Phòng chờ, mở từ [[step/13]]. Có từ ba đến năm vị khách ngồi ở đó, và họ thay đổi mỗi lần bạn cập cảng. Phần lớn thuộc chủng tộc cai quản hệ sao, nhưng một số đến từ bất cứ đâu. Hãy nói chuyện với một vị khách để biết họ muốn gì; mỗi câu trả lời và quyết định đều được tính cho một trong các huy chương giao tiếp.", false],
		[0, "Câu trả lời", "OK chấp nhận lời đề nghị, No, thanks từ chối nó và How was that again? lặp lại nó. Với công việc ở nơi khác, bạn có thể hỏi Can you show it on the map? để biết điểm đến và Will it be difficult? để biết nó khó đến đâu. Thương nhân cho bạn xem hàng trước. Từ chối lời đề nghị, đề nghị nhắc lại và chấp nhận mà không hỏi được tính lần lượt cho [[medal/32]], [[medal/33]], [[medal/34]] và [[medal/35]]; nói chuyện với những vị khách có lời đề nghị được tính cho [[medal/26]].", false],
		[0, "Khách hàng và người tán gẫu", "Nhiều vị khách đưa ra công việc tự do; xem [[guide/jobs]]. Những người khác chỉ trò chuyện và truyền tin đồn, đôi khi nhắc đến những trạm hoặc loại quặng đáng biết.", false],
		[0, "Thương nhân và người mua", "Thương nhân bán một lô duy nhất: một món trang bị hoặc vài đơn vị hàng hóa, với giá từ 40 đến 160 phần trăm giá thông thường. Từ [[step/16]] trở đi, người mua cũng xuất hiện, yêu cầu mang một số lượng của một mặt hàng đến chính trạm đó; xem [[job/8]].", false],
		[0, "Phi công đánh thuê", "Từ [[step/16]] trở đi, mỗi phòng chờ có thể có một vị khách đề nghị phi công hộ tống: một đến ba phi công với mức phí từ 700 đến 1.999 credit mỗi người, cho mười phút bay. Phi công [[faction/1]] không bao giờ nhận thuê. Bạn chỉ có thể có một nhóm mỗi lúc. Phi công sở hữu mọi huy chương sẽ gặp người hâm mộ thay vào đó, những người trả tiền để được bay cùng.", false],
		[0, "Đặc vụ", "Khi cốt truyện đã qua [[step/16]], các đặc vụ có tên chờ ở một số trạm nhất định và mỗi người thực hiện một giao dịch. Phần lớn bán bản thiết kế; bốn người bán tọa độ của một hệ sao ẩn, hệ sao này sau đó sẽ xuất hiện trên bản đồ. Mỗi đặc vụ rời đi sau giao dịch. Các đặc vụ được liệt kê trên trang riêng của họ.", false],
		[0, "Nhà ngoại giao", "Khi một trong bốn chủng tộc lớn đã trở nên thù địch, một nhà ngoại giao của họ sẽ ngồi trong mỗi phòng chờ. Với một khoản phí tăng theo mức độ uy tín của bạn đã giảm, tối đa 16.000 credit, nhà ngoại giao sẽ đưa thang uy tín đó về không.", false],
	],
	"guide/medals": [
		[0, "Các hạng", "Hầu hết huy chương có ba hạng: đồng, bạc và vàng. Mỗi hạng có chỉ tiêu riêng, và đạt hạng cao hơn sẽ thay thế huy chương hạng thấp hơn. Một vài huy chương chỉ có một hạng. Trang huy chương hiển thị chỉ tiêu của từng hạng.", false],
		[0, "Khi nào huy chương được trao", "Thành tích của bạn được kiểm tra khi bạn tiến đến trạm, trước khi trạm sửa chữa tàu, và huy chương mới hoặc được nâng hạng sẽ được công bố khi bạn đã cập cảng. Không có gì được trao khi đang bay, nên chỉ tiêu đạt được ngoài không gian chỉ được tính vào lần cập cảng tiếp theo. Màn hình Trạng thái liệt kê mọi huy chương bạn có, hạng của nó và lý do được trao.", false],
		[0, "Đầu tiên và cuối cùng", "[[medal/0]] có ngay từ đầu trò chơi. [[medal/36]] được trao tự động khi bạn đã có tất cả các huy chương khác.", false],
		[0, "Phần thưởng", "Sở hữu mọi huy chương thay đổi cách phi công trong Phòng chờ đối xử với bạn: người hâm mộ trả tiền cho bạn để được bay cùng với tư cách phi công hộ tống thay vì đòi phí. Sở hữu mọi huy chương hạng vàng mang lại lời chào bán [[ship/8]], một nguyên mẫu được bán tại [[station/10]]. Trên màn hình Trạng thái, [[character/0]] đeo kính râm khi có mọi huy chương, và kính vàng khi mọi huy chương đều là vàng.", false],
	],
	"guide/mining": [
		[0, "Tiểu hành tinh", "Vùng không gian của mỗi trạm có tiểu hành tinh ở hai bãi: một gần trạm và một ở xa hơn, nơi Danh sách lái tự động có thể đưa bạn đến. Bãi chứa loại quặng nào phụ thuộc vào khoảng cách từ hệ sao đến hệ sao quê nhà của từng loại quặng, nên không phải loại quặng nào cũng tìm thấy ở mọi nơi. Tiểu hành tinh cũng có thể bị bắn vỡ; việc này đôi khi để lại một ít quặng trôi tự do, và các tiểu hành tinh bị phá hủy được tính cho [[medal/29]].", false],
		[0, "Bắt đầu khai thác", "Khai thác cần tia laser khai thác và chỗ trống trong khoang hàng. Khóa một tiểu hành tinh bằng cách giữ nó dưới tâm ngắm, rồi nhấn Bắn. Tàu bay đến khối đá và mũi khoan bắt đầu hoạt động; bạn không thể bay cho đến khi khai thác xong. HUD hiển thị quặng và hạng của tiểu hành tinh khi nó đã được khóa.", false],
		[0, "Mũi khoan", "Một thước đo hiển thị các lớp đá của tiểu hành tinh xếp chồng lên nhau, mỗi lớp hẹp hơn lớp trước. Mũi khoan trôi về một bên và đổi hướng ngẫu nhiên sau mỗi khoảng từ nửa giây đến hai giây rưỡi. Lái sang trái và phải để giữ nó trong vùng xanh của lớp hiện tại. Lớp đầu tiên mất sáu giây khoan, và mỗi lớp sâu hơn mất ít hơn lớp trước khoảng một phần sáu thời gian. Quặng tích lũy suốt thời gian bạn ở trong vùng xanh, và nhanh hơn ở các lớp sâu hơn.", false],
		[0, "Vùng đỏ", "Thời gian ở ngoài vùng xanh được tính là hư hại và các vùng đỏ trên thước đo sẽ lớn dần. Sau tổng cộng hai giây rưỡi trong vùng đỏ, tiểu hành tinh vỡ tan và mọi thứ khoan được từ nó đều mất. Nhấn Bắn bất cứ lúc nào để dừng và giữ lại số quặng đã thu được. Mỗi tiểu hành tinh chỉ có thể khai thác một lần.", false],
		[0, "Hạng và lõi", "Tiểu hành tinh càng lớn càng có nhiều lớp, từ hai đến bảy. Loại lớn nhất, hạng A, có đủ bảy lớp, và khoan xuyên qua tất cả sẽ cho một lõi cùng với quặng. Lõi đáng giá hơn quặng rất nhiều và được tính cho [[medal/3]] và [[medal/7]]. Quặng được tính cho [[medal/2]] và [[medal/6]].", false],
		[0, "Laser khai thác", "Một tia laser khai thác có hai chỉ số. Hiệu suất làm mũi khoan trôi chậm hơn và lái tinh hơn, giúp giữ nó trong vùng xanh dễ dàng hơn. Tốc độ làm tăng tốc độ tích lũy quặng. Các loại laser trải từ [[item/86]] đến [[item/89]]; [[item/90]] được chế tạo từ bản thiết kế.", false],
		[0, "Khoang hàng", "Quặng và lõi đi thẳng vào khoang hàng, và bạn chỉ giữ được chừng nào còn chỗ. Khi khoang hàng đầy, HUD sẽ báo và bạn phải bán hoặc dỡ hàng tại trạm. Bộ nén hàng hóa mở rộng khoang hàng thêm một phần sức chứa của thân tàu, và có thể lắp nhiều bộ cùng lúc. Một thân tàu lớn hơn là cách hiệu quả nhất.", false],
	],
	"guide/navigation": [
		[0, "Bản đồ thiên hà", "Mục Bản đồ của trạm và phím Bản đồ lộ trình khi bay hiển thị thiên hà: mọi hệ sao đã biết ở đúng vị trí, các liên kết cổng giữa chúng, chủng tộc cai quản và mức an ninh của hệ sao. Chọn một hệ sao sẽ phóng to vào đó và hiển thị các trạm; chọn một trạm ở đó sẽ đặt nó làm điểm đến. Bản đồ cũng hiển thị khoảng cách đến một hệ sao tính bằng kilômét, đánh dấu các trạm bạn đã ghé và cho biết nơi cốt truyện và công việc hiện tại tiếp diễn. Ô tìm kiếm giúp tìm các trạm đã biết theo tên. Trang [[chart]] liệt kê mọi hệ sao.", false],
		[0, "", "Đầu cốt truyện, bạn bị giữ trong quỹ đạo của trạm đầu tiên. Bản đồ mở từ [[step/9]], sau đó bạn có thể bay đến các hành tinh khác trong hệ sao.", false],
		[0, "Hệ sao và an ninh", "Mỗi hệ sao do một trong bốn chủng tộc lớn cai quản và có một mức an ninh: An toàn, Trung bình, Rủi ro hoặc Nguy hiểm. Các cuộc đột kích của hải tặc và kẻ địch thường xuyên hơn nhiều ở hệ sao nguy hiểm, trong khi hệ sao an toàn phần lớn yên bình. Hầu hết hệ sao có nhiều trạm, mỗi trạm quay quanh hành tinh riêng, với cửa hàng, phòng chờ và cấp công nghệ riêng.", false],
		[0, "Cổng nhảy", "Việc di chuyển giữa các hệ sao đi qua cổng nhảy. Một hệ sao có tối đa một cổng, nằm trong vùng không gian của một trong các trạm, và chỉ nối với các hệ sao lân cận. Để nhảy, hãy chọn điểm đến ở một hệ sao lân cận trên Bản đồ, bay đến cổng (lái tự động sẽ đưa bạn đến), khóa nó và nhấn Bắn khi đã vào trong vùng của cổng. Những hành trình dài hơn được thực hiện qua từng cổng một; màn hình Nhiệm vụ cho biết một điểm đến cần bao nhiêu lần nhảy cổng qua các hệ sao bạn đã biết.", false],
		[0, "Hệ sao ẩn", "Năm hệ sao lúc đầu không có trên bản đồ: [[system/0]], [[system/1]], [[system/6]], [[system/10]] và [[system/21]]. Một hệ sao ẩn sẽ xuất hiện khi bạn đã đến đó hoặc đã mua tọa độ của nó. Bốn đặc vụ trong Phòng chờ bán tọa độ: [[agent/12]] cho [[system/0]], [[agent/13]] cho [[system/1]], [[agent/14]] cho [[system/10]] và [[agent/15]] cho [[system/21]]. Các đặc vụ có tên chỉ xuất hiện khi cốt truyện đã qua [[step/16]]. [[system/10]] hoàn toàn không có liên kết cổng và chỉ có thể đến bằng động cơ nhảy.", false],
		[23, "", "Đường đến [[system/6]] được cốt truyện trao cho bạn trong [[step/22]].", false],
		[0, "Động cơ nhảy", "Động cơ nhảy đưa tàu thẳng đến một trạm ở bất kỳ hệ sao đã biết nào mà không cần cổng. Chỉ có một loại là [[item/85]], không bao giờ được bán ở cửa hàng và phải được chế tạo từ bản thiết kế. Hãy dùng nó từ menu Hành động khi bay. Mỗi lần nhảy không tốn nhiên liệu cũng không mất phí. Không thể dùng nó khi một trận đánh của công việc tự do đang diễn ra tại trạm của bạn, nhưng công việc chuyển phát và chở khách thì không ngăn cản nó.", false],
		[34, "", "Cốt truyện trao cho bạn bản thiết kế [[item/85]] trong [[step/34]], với một phần thành phần đã được giao sẵn.", false],
		[0, "Khoảng cách", "Khoảng cách giữa các hệ sao được tính bằng kilômét, đo từ vị trí của các hệ sao trên bản đồ. Khoảng cách quan trọng đối với thương mại, vì giá tăng theo khoảng cách từ nơi xuất xứ của mặt hàng, và đối với công việc tự do, vì phần thưởng tăng theo khoảng cách đến đích.", false],
	],
	"guide/tips": [
		[0, "", "Hãy đọc trang của một mặt hàng trước chuyến buôn: nó cho biết hệ sao nơi mặt hàng rẻ nhất và hướng mà giá đắt dần lên.", true],
		[0, "", "Các trạm mua và bán cùng một giá, nên một chuyến hàng chỉ sinh lời khi đã được chở xa khỏi nơi xuất xứ.", true],
		[0, "", "Khi khai thác, hãy phản ứng ngay với mỗi lần mũi khoan đổi hướng trôi. Thời gian trong vùng đỏ được cộng dồn trong suốt lần khoan, nên nhiều lần trượt ngắn cũng tốn kém như một lần trượt dài.", true],
		[0, "", "Nếu mũi khoan đã ở trong vùng đỏ khá lâu, hãy dừng nó bằng Bắn và giữ lấy những gì đã có thay vì mất trắng cả mẻ.", true],
		[0, "", "Hãy tìm những tiểu hành tinh lớn nhất khi bạn muốn lấy lõi: chỉ đá hạng A mới có lõi, và chỉ khi bạn khoan qua được cả bảy lớp.", true],
		[0, "", "Hãy lắp chùm tia kéo sớm. Không có nó, hoàn toàn không thể thu gom hàng hóa từ xác tàu và tàu bị vô hiệu hóa.", true],
		[0, "", "Một máy quét tốt hơn sẽ đáng đồng tiền trong chiến đấu: nó khóa mục tiêu nhanh hơn, và loại tốt nhất còn cho biết một con tàu đang chở gì trước khi bạn tấn công.", true],
		[0, "", "Cập cảng sửa tàu miễn phí, vì vậy đáng để ghé trạm giữa các trận đánh thay vì tiếp tục với thân tàu hư hỏng.", true],
		[0, "", "Hãy cập cảng thường xuyên trong những hành trình dài. Chỉ một lần cập cảng hoàn tất mới tạo bản tự động lưu, và tàu bị phá hủy sẽ đưa bạn về bản lưu gần nhất.", true],
		[0, "", "Hãy theo dõi uy tín của bạn trên màn hình Trạng thái. Đạn lạc trúng tàu địa phương sẽ cộng dồn, và cả một chủng tộc có thể trở nên thù địch.", true],
		[0, "", "Hãy hỏi khách hàng công việc ở đâu và khó đến mức nào trước khi nhận, trừ khi bạn đang sưu tầm các huy chương dành cho việc không hỏi.", true],
		[0, "", "Hãy dọn chỗ trong khoang hàng trước khi nhận công việc chuyển phát, và lắp cabin trước khi nhận công việc chở khách: không thể nhận việc nào nếu thiếu chỗ.", true],
		[0, "", "Với công việc thu hồi và trục vớt, hãy mang theo vũ khí EMP, máy quét hiển thị hàng hóa, chùm tia kéo và một ít chỗ trống trong khoang hàng.", true],
		[0, "", "Hãy mang mọi thành phần của một bản thiết kế đến trạm nơi bạn bắt đầu sản xuất, như vậy bạn sẽ tránh được phí vận chuyển.", true],
		[0, "", "Hãy thuê phi công hộ tống ngay trước một trận đánh khó: hợp đồng của họ chỉ đếm ngược khi bạn đang bay.", true],
	],
	"guide/trading": [
		[0, "Cách định giá", "Mỗi mặt hàng có một mức giá thấp nhất, một mức giá cao nhất và một hệ sao quê nhà, tức nơi xuất xứ. Tại nơi xuất xứ, mặt hàng được bán với giá thấp nhất; trạm càng xa nơi xuất xứ thì giá càng cao, cho đến mức giá cao nhất ở một khoảng cách nhất định. Ngoài ra, mỗi trạm còn cộng thêm một mức chênh lệch cố định riêng, lên hoặc xuống tối đa khoảng năm phần trăm. Trang mặt hàng cho biết nơi mặt hàng rẻ nhất và đắt dần theo hướng nào.", false],
		[0, "Mua và bán", "Một trạm mua vào đúng bằng giá bán ra, nên lợi nhuận chỉ đến từ việc vận chuyển hàng: mua gần nơi xuất xứ của mặt hàng và bán ở xa nơi đó. Hàng bạn bán sẽ được thêm vào kệ của trạm. Cửa hàng cũng ghi nhớ mức giá thấp nhất và cao nhất bạn từng thấy cho mỗi mặt hàng, ở hệ sao nào, và hiển thị chúng cạnh mặt hàng. Một số hàng hóa không thể bán, như hàng chuyển phát và các thùng hàng bạn đang chở cho khách.", false],
		[0, "Cửa hàng bán những gì", "Mỗi trạm có một cấp công nghệ. Kệ hàng của trạm chứa các mặt hàng ở cấp đó trở xuống; các trạm từ cấp bốn trở lên bỏ qua những mặt hàng dưới một nửa cấp của mình. Mỗi mặt hàng cũng có một xác suất có mặt trên một kệ nhất định, nên kệ hàng khác nhau giữa các lần ghé. Một vài mặt hàng luôn có trên kệ tại một trạm cụ thể. Một số hàng hóa chỉ được bán ở các hệ sao [[faction/1]], và sản phẩm từ bản thiết kế thì không bao giờ được bán.", false],
		[0, "", "Hàng hóa thông thường có số lượng lớn hơn, và lớn hơn nhiều khi ở gần nơi xuất xứ. Vũ khí và trang bị thường chỉ có từ một đến ba cái mỗi lần, trong khi rocket, ngư lôi và bom có theo lô lớn hơn. Kệ hàng được bổ sung mỗi lần bạn cập cảng, trừ ba trạm bạn ghé gần nhất, nơi kệ hàng được giữ nguyên như khi bạn rời đi.", false],
		[0, "Rượu", "Mỗi hệ sao có loại đồ uống địa phương riêng, chỉ được bán trong hệ sao đó, như [[item/132]] ở [[system/0]] hay [[item/146]] ở [[system/14]]. Đồ uống là hàng hóa thông thường. Mua chúng từ cửa hàng được tính cho [[medal/8]]; sở hữu nhiều loại khác nhau mua từ thương nhân trong Phòng chờ hoặc thu hồi từ xác tàu được tính cho [[medal/9]].", false],
		[0, "Các nguồn khác", "Thương nhân trong Phòng chờ bán từng lô riêng lẻ với giá từ 40 đến 160 phần trăm giá thông thường, nên các món hời của họ đáng để so sánh. Tàu chở hàng hóa có thể được lấy bằng chùm tia kéo khi chúng bị phá hủy hoặc vô hiệu hóa, và quặng thì có thể khai thác. Người mua trong Phòng chờ yêu cầu một số lượng của một mặt hàng cụ thể và trả cao hơn hẳn giá trị của nó; xem [[job/8]].", false],
	],
	"home": [
		[0, "", "Phần Tham khảo này nói về Galaxy on Fire 2, một trò chơi không gian về buôn bán, khai thác, chiến đấu và khám phá. Bạn vào vai [[character/0]], một phi công kỳ cựu bị mắc kẹt xa nhà, bay qua 22 hệ sao do loài người và các chủng tộc ngoài hành tinh nắm giữ. Giữa các nhiệm vụ cốt truyện, bạn có thể nhận công việc tự do, khai thác tiểu hành tinh, buôn bán hàng hóa, chế tạo trang bị từ bản thiết kế và mua những con tàu ngày càng tốt hơn.", false],
		[0, "", "Các trang được xây dựng từ trò chơi bạn đã nhập. Tên, số liệu, giá cả và hội thoại đều lấy từ đó, còn phần giải thích đi kèm được viết riêng cho phần Tham khảo này. Các chi tiết cốt truyện vượt quá điểm bản lưu của bạn đã đạt tới sẽ được ẩn cho đến khi bạn đến đó. Những nơi nên bắt đầu là [[world/galaxy]], [[chart]] và [[guide/basics]].", false],
	],
	"intro/agents": [
		[0, "", "Đặc vụ là những thương nhân ngồi trong một số phòng chờ nhất định và bán thứ bạn không thể mua ở cửa hàng: một bản thiết kế hiếm hoặc tọa độ của một hệ sao ẩn. Họ xuất hiện từ [[step/17]] trở đi, và mỗi người chỉ bán một lần. Hãy nói chuyện với họ trong phòng chờ của trạm để xem lời đề nghị; xem [[guide/lounge]].", false],
	],
	"intro/blueprints": [
		[0, "", "Vật phẩm từ bản thiết kế không bao giờ được bán ở cửa hàng. Mỗi vật phẩm được chế tạo theo công thức từ các loại hàng hóa khi bạn đã sở hữu bản thiết kế của nó, thường được mua từ một đặc vụ trong Phòng chờ. Cách sản xuất hoạt động được giải thích trong [[guide/blueprints]].", false],
	],
	"intro/characters": [
		[0, "", "Đây là những người [[character/0]] gặp trên hành trình của mình: thương nhân, sĩ quan, nhà khoa học và những người bạn đồng hành kỳ lạ hơn. Mỗi tiểu sử được bổ sung khi cốt truyện tiến triển, nên bạn chỉ biết về một nhân vật những gì chính Keith đã biết.", false],
	],
	"intro/equipment": [
		[0, "", "Trang bị lấp đầy các ô trang bị của tàu: khiên và tấm giáp để bảo vệ, bộ nén hàng hóa, chùm tia kéo để thu gom thùng hàng, bộ tăng tốc, vòi lái, máy quét, laser khai thác, cabin hành khách, thiết bị tàng hình, robot sửa chữa và động cơ nhảy. Mỗi món chiếm một ô, nên số ô giới hạn mức độ hoàn thiện của một con tàu. Giá thay đổi theo hệ sao, và cửa hàng chỉ bán vật phẩm đến cấp công nghệ của trạm. Một số món tốt nhất được chế tạo từ bản thiết kế, và vài món do người [[faction/1|Vossk]] sản xuất và chỉ bán trong các hệ sao của họ.", false],
	],
	"intro/factions": [
		[0, "", "Có mười phe xuất hiện trong trò chơi. Bốn trong số đó sở hữu hệ sao và trạm: người Terran, người Vossk, người Nivelian và người Midorian. Các phe khác không có lãnh thổ và chỉ gặp bạn với tư cách cá nhân hoặc kẻ thù. Uy tín của bạn với bốn cường quốc được tính trên hai thang, Terran đối với Vossk và Nivelian đối với Midorian; xem [[world/galaxy]].", false],
	],
	"intro/goods": [
		[0, "", "Hàng hóa là mọi thứ được chở trong khoang để buôn bán. Hàng thông thường và đồ uống được mua rẻ ở một hệ sao và bán đắt ở hệ sao khác (xem [[guide/trading]]); mỗi hệ sao có loại đồ uống riêng. Quặng được khoan từ tiểu hành tinh, và khoan xuyên qua mọi lớp của một tiểu hành tinh hạng A sẽ cho một lõi có giá trị cao hơn nhiều (xem [[guide/mining]]). Hàng thông thường, quặng và lõi cũng là thành phần để chế tạo vật phẩm từ bản thiết kế. Một vài loại hàng, như [[item/116]] và [[item/131]], chỉ xuất hiện qua công việc hoặc cốt truyện và không thể mua.", false],
	],
	"intro/guide": [
		[0, "", "Các trang này giải thích cách chơi: bay và chiến đấu, khai thác và buôn bán, các màn hình trạm, công việc tự do, sản xuất và huy chương. Số liệu nêu ở đây tuân theo quy tắc của engine; các bảng trên trang vật phẩm, tàu và huy chương lấy từ dữ liệu trò chơi của chính bạn. Hãy bắt đầu với [[guide/basics]] và [[guide/help]].", false],
	],
	"intro/jobs": [
		[0, "", "Công việc tự do là việc làm thêm do khách hàng trong Phòng chờ đưa ra, từ chở hàng đến săn tội phạm bị truy nã. Chúng mang lại credit, uy tín với chủng tộc của khách hàng và kinh nghiệm. Có mười ba loại; cách chúng được đưa ra và trả công được giải thích trong [[guide/jobs]].", false],
	],
	"intro/medals": [
		[0, "", "Huy chương ghi nhận thành tích của phi công: chiến đấu, khai thác, buôn bán, du hành và thậm chí cả cách bạn trò chuyện với mọi người trong Phòng chờ. Hầu hết có các hạng đồng, bạc và vàng. Chúng được kiểm tra mỗi khi bạn cập cảng; xem [[guide/medals]].", false],
	],
	"intro/ships": [
		[0, "", "Các con tàu khác nhau về giáp, sức chứa hàng, độ linh hoạt và số ô gắn: ô vũ khí chính cho súng bắn thẳng, ô vũ khí phụ cho rocket, ngư lôi và bom, một ô tháp pháo tùy chọn, và ô trang bị cho mọi thứ khác. Giá tăng rất mạnh, từ dưới 20.000 credit cho những thân tàu nhỏ nhất đến vài triệu cho những chiến đấu cơ tốt nhất. Người bán bên ngoài các hệ sao [[faction/1|Vossk]] bày tối đa năm thân tàu mỗi lần ghé; người bán [[faction/1|Vossk]] chỉ bán [[ship/9]]. Người bán giảm giá niêm yết theo phần trăm bằng cấp công nghệ của trạm và trả bốn phần năm giá niêm yết cho thân tàu cũ của bạn. [[ship/0]] và [[ship/10]] không bao giờ được bán. Xem [[guide/fitting]] để biết cách trang bị cho tàu.", false],
	],
	"intro/stations": [
		[0, "", "Mỗi trạm đều có cửa hàng, hangar, người bán tàu và phòng chờ. Cấp công nghệ của trạm, từ 1 đến 10, quyết định hàng hóa và trang bị trên kệ có thể tiên tiến đến đâu, và người bán tàu của trạm giảm giá niêm yết của tàu đúng bằng chừng ấy phần trăm. Hàng trong kho thay đổi sau mỗi lần ghé. Các trạm được nhắc đến trong cốt truyện hoặc có đặc vụ sẽ có một mô tả ngắn ở đây.", false],
	],
	"intro/story": [
		[0, "", "Cốt truyện theo chân [[character/0]], một phi công Terran có cuộc săn hải tặc gặp sự cố nghiêm trọng, qua 45 bước. Mỗi trang bước cho biết nhiệm vụ và, khi bạn đã hoàn thành, những gì đã xảy ra. Các trang chỉ tiết lộ đến đúng mức bản lưu của bạn đã đạt tới; [[world/history]] kể lại cốt truyện cho đến hiện tại ở cùng một nơi.", false],
	],
	"intro/systems": [
		[0, "", "Thiên hà có 22 hệ sao. Mỗi hệ sao thuộc về một phe, có một mức an ninh quyết định tần suất kẻ cướp xuất hiện, và chứa tối đa năm trạm, một trong số đó có cổng nhảy. Liên kết cổng quyết định bạn có thể di chuyển giữa những hệ sao nào; một vài hệ sao bị ẩn hoặc hoàn toàn không có liên kết. Xem [[world/galaxy]] và [[chart]].", false],
	],
	"intro/weapons": [
		[0, "", "Vũ khí chia thành hai nhóm. Vũ khí chính (laser, blaster, pháo tự động và súng nhiệt) bắn không cần đạn từ các ô phía trước; chúng khác nhau về sát thương mỗi phát, tốc độ bắn và tầm bắn. Vũ khí phụ (rocket, ngư lôi, bom EMP và bom hạt nhân) được mua theo từng quả và bắn từ các ô vũ khí phụ. Tháp pháo cần ô riêng và có thể bắn theo mọi hướng. Một số vũ khí làm cạn năng lượng của tàu thay vì, hoặc cùng với, gây sát thương; tàu hết năng lượng sẽ bị vô hiệu hóa một lúc. Nhiều vũ khí tốt nhất không bao giờ được bán ở cửa hàng và phải chế tạo từ bản thiết kế (xem [[guide/blueprints]]). Nhiều mẫu do người [[faction/1|Vossk]] sản xuất và chỉ có bán trong các hệ sao của họ. Xem [[guide/combat]] để biết chiến thuật.", false],
	],
	"intro/world": [
		[0, "", "Các trang này mô tả bối cảnh của trò chơi: thiên hà và bố cục của nó, lịch sử, và những thế lực định hình nó. Chúng bổ sung bức tranh toàn cảnh cho các trang về hệ sao, trạm và phe.", false],
	],
	"item/0": [
		[0, "", "[[item/0]] là laser cấp nhập môn: 3 sát thương mỗi phát, mỗi 0,4 giây, với tầm bắn 2.000 đơn vị như mọi laser đời đầu. Đây là laser yếu nhất trong trò chơi, nhưng nó rẻ và gần như cửa hàng nào cũng có. [[item/1]] và [[item/2]] giữ nguyên tốc độ bắn và tăng sát thương.", false],
		[6, "", "Đây là một trong ba món [[character/2]] cho miễn phí trong hangar của ông tại [[station/78]] trước cuộc đột kích sào huyệt hải tặc, cùng với [[item/22]] và [[item/55]].", false],
	],
	"item/1": [
		[0, "", "[[item/1]] là nấc thứ hai của dòng Nirai. Nó bắn nhanh như [[item/0]] (mỗi 0,4 giây) nhưng gây 5 sát thương mỗi phát thay vì 3, với cùng tầm bắn. Đây là một nâng cấp giá rẻ cho đến khi đủ tiền mua [[item/2]].", false],
	],
	"item/10": [
		[0, "", "[[item/10]] gây 34 sát thương mỗi 1,4 giây với tầm bắn 2.600. Nó đánh mạnh hơn mỗi phát và bắn xa hơn [[item/9]], với tốc độ bắn chậm hơn một chút. Đây là laser mạnh nhất được bán ở cửa hàng.", false],
	],
	"item/11": [
		[0, "", "[[item/11]] là laser mạnh nhất trong trò chơi: 45 sát thương mỗi 1,5 giây với tầm bắn 2.600, phát bắn đơn nặng nhất trong mọi súng chính. Nó không bao giờ được bán sẵn. Bản thiết kế của nó đến từ [[agent/0]] tại [[station/3]], và việc chế tạo tiêu tốn một [[item/9]] cùng với [[item/155]] và một số hàng hóa thông thường.", false],
	],
	"item/116": [
		[0, "", "Thùng hàng an toàn là hàng niêm phong chỉ xuất hiện qua công việc tự do. Nhận một công việc [[job/0]] sẽ chất số lượng đã thỏa thuận vào khoang hàng của bạn, nơi chúng chiếm chỗ; chúng không thể bán và được bàn giao tại điểm đến. Chúng cũng đại diện cho hàng bị đánh cắp trong các công việc [[job/3]], nơi con tàu chở chúng phải bị vô hiệu hóa thay vì phá hủy.", false],
	],
	"item/117": [
		[0, "", "Cabin an toàn là hàng đặc biệt chỉ xuất hiện qua công việc tự do, trong các công việc [[job/5]] yêu cầu bạn giải thoát một tù nhân khỏi một trong số các con tàu và đưa họ trở về. Giống như [[item/116]], nó không thể mua hay bán.", false],
	],
	"item/12": [
		[0, "", "[[item/12]] là blaster [[faction/1|Vossk]] cơ bản: 11 sát thương mỗi 0,6 giây với tầm bắn 1.500. Blaster bắn không xa bằng laser nhưng gây nhiều sát thương theo thời gian hơn; ngay cả mẫu đầu tiên này cũng nhỉnh hơn laser Nirai tốt nhất. Nó cũng cần thiết để chế tạo [[item/15]]. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/13": [
		[0, "", "[[item/13]] là một blaster [[faction/1|Vossk]] gây 12 sát thương mỗi 0,5 giây với tầm bắn 1.500, một bước tiến rõ rệt so với [[item/12]] về tốc độ bắn và sát thương. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/131": [
		[0, "", "[[item/131]] là xác của các chiến đấu cơ [[faction/9|Void]]. Mỗi tàu [[faction/9|Void]] thù địch bị phá hủy để lại một thùng hàng chứa từ một đến ba mảnh, chỉ có thể thu gom bằng chùm tia kéo (xem [[item/68]]). Chúng được bán với giá cố định 199 credit, và việc thu gom chúng được tính cho huy chương [[medal/21]].", false],
		[24, "", "[[character/6]] cần những mảnh xác này cho nghiên cứu của mình và cử [[character/0]] đi thu gom chúng gần [[station/48]].", false],
		[25, "", "Trong khi [[character/0]] đang chở chúng về, những mảnh xác này không thể bán.", false],
		[28, "", "Chúng được bàn giao cho nhóm của [[character/6]] khi đến [[station/10]].", false],
	],
	"item/14": [
		[0, "", "[[item/14]] là một blaster [[faction/1|Vossk]] bắn mỗi 0,4 giây với 10 sát thương. Nó gây sát thương theo thời gian nhiều hơn [[item/13]] một chút, nhưng tầm bắn 1.000 là ngắn, nên phù hợp với phi công áp sát mục tiêu. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/15": [
		[0, "", "[[item/15]] là blaster [[faction/1|Vossk]] tốt nhất: 10 sát thương mỗi 0,3 giây với tầm bắn 1.500. Nó kết hợp tốc độ bắn của các blaster nhanh hơn với tầm bắn của [[item/12]]. Nó không bao giờ được bán sẵn. Bản thiết kế của nó đến từ [[agent/1]] tại [[station/8]], và việc chế tạo tiêu tốn một [[item/12]] và một [[item/166]] cùng với một số hàng hóa thông thường.", false],
	],
	"item/154": [
		[0, "", "[[item/154]] là loại quặng thông thường có giá trị nhất. Các bãi tiểu hành tinh ưu tiên những loại quặng có hệ sao quê nhà ở gần, và quê nhà của nó là [[system/9]], cũng là nơi nó rẻ nhất. Cần một lượng lớn nó để chế tạo [[item/27]]. Khoan xuyên qua một tiểu hành tinh [[item/154]] hạng A sẽ cho một [[item/165]].", false],
	],
	"item/155": [
		[0, "", "[[item/155]] là một loại quặng giá trung bình có hệ sao quê nhà là [[system/21]], nơi nó được bán rẻ nhất. Nó là thành phần của [[item/11]] và của [[item/90]]. Lõi của nó là [[item/166]].", false],
	],
	"item/156": [
		[0, "", "[[item/156]] là loại quặng rẻ nhất, có quê nhà ở [[system/0]]. Giá trị thấp khiến nó là hàng kém lời để bán, nhưng nó là thành phần của tấm giáp [[item/59]]. Lõi của nó là [[item/167]].", false],
	],
	"item/157": [
		[0, "", "[[item/157]] là một loại quặng giá trung bình có hệ sao quê nhà là [[system/7]]. Cùng với lõi của nó, [[item/168]], nó cần thiết để chế tạo tấm giáp [[item/59]].", false],
	],
	"item/158": [
		[0, "", "[[item/158]] là một loại quặng giá trung bình có hệ sao quê nhà là [[system/4]]. Nó là một trong các loại quặng cần cho [[item/85]]. Lõi của nó là [[item/169]].", false],
	],
	"item/159": [
		[0, "", "[[item/159]] là một loại quặng giá trung bình có hệ sao quê nhà là [[system/18]]. Không bản thiết kế nào dùng đến nó, nên nó chỉ được khai thác để bán hoặc để giành huy chương quặng. Lõi của nó là [[item/170]].", false],
	],
	"item/16": [
		[0, "", "[[item/16]] là blaster EMP đầu tiên. Nó không gây sát thương cho thân tàu hay giáp; thay vào đó mỗi phát trúng làm cạn 3 điểm năng lượng của tàu, và tàu có năng lượng về không sẽ bị vô hiệu hóa một lúc. Súng EMP cần thiết khi phải chặn đứng mục tiêu thay vì phá hủy. Mẫu này bắn mỗi 0,3 giây nhưng tầm bắn chỉ 1.200 đơn vị. [[item/17]] và [[item/18]] bắn xa hơn và hút nhiều năng lượng hơn mỗi phát.", false],
	],
	"item/160": [
		[0, "", "[[item/160]] là một loại quặng giá thấp có hệ sao quê nhà là [[system/13]]. Nó là một trong các loại quặng cần cho [[item/85]]. Lõi của nó là [[item/171]].", false],
	],
	"item/161": [
		[0, "", "[[item/161]] là một loại quặng giá trung bình có hệ sao quê nhà là [[system/19]]. Không bản thiết kế nào dùng đến nó. Lõi của nó là [[item/172]].", false],
	],
	"item/162": [
		[0, "", "[[item/162]] là một loại quặng giá trung bình có hệ sao quê nhà là [[system/14]]. Không bản thiết kế nào dùng đến nó. Lõi của nó là [[item/173]].", false],
	],
	"item/163": [
		[0, "", "[[item/163]] là một loại quặng giá trung bình có hệ sao quê nhà là [[system/5]]. Nó là thành phần chính của [[item/54]], loại cần 80 t quặng này, và cũng cần cho [[item/85]]. Lõi của nó là [[item/174]].", false],
	],
	"item/164": [
		[0, "", "[[item/164]] là một loại quặng không bao giờ xuất hiện trong các bãi tiểu hành tinh của những hệ sao có người ở. Khác với các loại quặng khác, tiểu hành tinh tinh thể không để lại gì khi bị bắn vỡ, nên phải khoan để lấy tinh thể. Chúng là thành phần then chốt của [[item/85]], loại cần 50 tinh thể.", false],
		[25, "", "Mọi tiểu hành tinh trong vùng không gian quê nhà của [[faction/9|Void]], nơi đến được qua các lỗ sâu của chúng, đều được tạo thành từ những tinh thể này.", false],
		[33, "", "[[character/20]] nhờ [[character/0]] mang về cho ông ít nhất 50 tinh thể, thứ ông tin là nắm giữ bí mật về các lỗ sâu của [[faction/9|Void]].", false],
	],
	"item/165": [
		[0, "", "Lõi này là phần trung tâm hiếm có của một tiểu hành tinh [[item/154]] hạng A. Có thể lấy được bằng cách khoan xuyên qua cả bảy lớp của tiểu hành tinh đó, và thỉnh thoảng một lõi rơi ra khi tiểu hành tinh hạng A bị bắn vỡ. Nó bán được gấp nhiều lần giá quặng, rẻ nhất ở [[system/9]]. Đây là lõi có giá trị nhất ngoài [[item/175]].", false],
	],
	"item/166": [
		[0, "", "Lõi này là phần trung tâm hiếm có của một tiểu hành tinh [[item/155]] hạng A. Có thể lấy được bằng cách khoan xuyên qua cả bảy lớp của tiểu hành tinh đó, và thỉnh thoảng một lõi rơi ra khi tiểu hành tinh hạng A bị bắn vỡ. Nó bán được gấp nhiều lần giá quặng, rẻ nhất ở [[system/21]]. Nó cần thiết để chế tạo [[item/15]] và, mười lõi một lần, [[item/90]].", false],
	],
	"item/167": [
		[0, "", "Lõi này là phần trung tâm hiếm có của một tiểu hành tinh [[item/156]] hạng A. Có thể lấy được bằng cách khoan xuyên qua cả bảy lớp của tiểu hành tinh đó, và thỉnh thoảng một lõi rơi ra khi tiểu hành tinh hạng A bị bắn vỡ. Nó bán được gấp nhiều lần giá quặng, rẻ nhất ở [[system/0]]. Đây là lõi có giá trị thấp nhất.", false],
	],
	"item/168": [
		[0, "", "Lõi này là phần trung tâm hiếm có của một tiểu hành tinh [[item/157]] hạng A. Có thể lấy được bằng cách khoan xuyên qua cả bảy lớp của tiểu hành tinh đó, và thỉnh thoảng một lõi rơi ra khi tiểu hành tinh hạng A bị bắn vỡ. Nó bán được gấp nhiều lần giá quặng, rẻ nhất ở [[system/7]]. Cần mười lăm lõi này để chế tạo [[item/59]].", false],
	],
	"item/169": [
		[0, "", "Lõi này là phần trung tâm hiếm có của một tiểu hành tinh [[item/158]] hạng A. Có thể lấy được bằng cách khoan xuyên qua cả bảy lớp của tiểu hành tinh đó, và thỉnh thoảng một lõi rơi ra khi tiểu hành tinh hạng A bị bắn vỡ. Nó bán được gấp nhiều lần giá quặng, rẻ nhất ở [[system/4]].", false],
	],
	"item/17": [
		[0, "", "[[item/17]] hút 5 năng lượng mỗi phát trúng, mỗi 0,5 giây, và có tầm bắn 2.000 đơn vị, xa hơn nhiều so với [[item/16]]. Nó không gây sát thương thân tàu. Nó hút năng lượng với tốc độ gần bằng Mk I nhưng có thể làm điều đó từ khoảng cách an toàn hơn.", false],
	],
	"item/170": [
		[0, "", "Lõi này là phần trung tâm hiếm có của một tiểu hành tinh [[item/159]] hạng A. Có thể lấy được bằng cách khoan xuyên qua cả bảy lớp của tiểu hành tinh đó, và thỉnh thoảng một lõi rơi ra khi tiểu hành tinh hạng A bị bắn vỡ. Nó bán được gấp nhiều lần giá quặng, rẻ nhất ở [[system/18]].", false],
	],
	"item/171": [
		[0, "", "Lõi này là phần trung tâm hiếm có của một tiểu hành tinh [[item/160]] hạng A. Có thể lấy được bằng cách khoan xuyên qua cả bảy lớp của tiểu hành tinh đó, và thỉnh thoảng một lõi rơi ra khi tiểu hành tinh hạng A bị bắn vỡ. Nó bán được gấp nhiều lần giá quặng, rẻ nhất ở [[system/13]].", false],
	],
	"item/172": [
		[0, "", "Lõi này là phần trung tâm hiếm có của một tiểu hành tinh [[item/161]] hạng A. Có thể lấy được bằng cách khoan xuyên qua cả bảy lớp của tiểu hành tinh đó, và thỉnh thoảng một lõi rơi ra khi tiểu hành tinh hạng A bị bắn vỡ. Nó bán được gấp nhiều lần giá quặng, rẻ nhất ở [[system/19]].", false],
	],
	"item/173": [
		[0, "", "Lõi này là phần trung tâm hiếm có của một tiểu hành tinh [[item/162]] hạng A. Có thể lấy được bằng cách khoan xuyên qua cả bảy lớp của tiểu hành tinh đó, và thỉnh thoảng một lõi rơi ra khi tiểu hành tinh hạng A bị bắn vỡ. Nó bán được gấp nhiều lần giá quặng, rẻ nhất ở [[system/14]].", false],
	],
	"item/174": [
		[0, "", "Lõi này là phần trung tâm hiếm có của một tiểu hành tinh [[item/163]] hạng A. Có thể lấy được bằng cách khoan xuyên qua cả bảy lớp của tiểu hành tinh đó, và thỉnh thoảng một lõi rơi ra khi tiểu hành tinh hạng A bị bắn vỡ. Nó bán được gấp nhiều lần giá quặng, rẻ nhất ở [[system/5]].", false],
	],
	"item/175": [
		[0, "", "[[item/175]] là lõi của một tiểu hành tinh [[item/164]] hạng A. Vì tiểu hành tinh tinh thể không để lại gì khi bị bắn vỡ, cách duy nhất để có nó là khoan xuyên qua cả bảy lớp. Nó được bán với giá cố định 5.000 credit, cao hơn năm lần giá tốt nhất của bất kỳ lõi nào khác.", false],
		[25, "", "Chỉ có thể tìm thấy nó trong vùng không gian quê nhà của [[faction/9|Void]].", false],
	],
	"item/18": [
		[0, "", "[[item/18]] là blaster EMP mạnh nhất: 8 năng lượng mỗi phát trúng, mỗi 0,5 giây, với tầm bắn 2.000, vô hiệu hóa tàu nhanh hơn rõ rệt so với [[item/17]]. Giống các blaster EMP khác, nó không gây sát thương thân tàu.", false],
	],
	"item/19": [
		[0, "", "[[item/19]] gây 15 sát thương mỗi 0,3 giây với tầm bắn 1.400. Nó gây sát thương theo thời gian mạnh hơn hẳn bất kỳ laser nào. [[item/20]] và [[item/21]] bắn nhanh hơn nhưng tầm bắn chỉ 1.000 đơn vị.", false],
	],
	"item/2": [
		[0, "", "[[item/2]] là laser Nirai cao cấp nhất: 7 sát thương mỗi 0,4 giây. Mỗi phát yếu hơn của các laser Berger, nhưng vì bắn nhanh gấp khoảng đôi, nó gây sát thương theo thời gian nhiều hơn bất kỳ loại nào trong số đó, kể cả [[item/8]]. Chỉ các laser chùm M6 ([[item/9]] và các mẫu kế tiếp) mới vượt trội rõ rệt so với nó.", false],
	],
	"item/20": [
		[0, "", "[[item/20]] bắn mỗi 0,2 giây với 13 sát thương. Về sát thương theo thời gian, nó vượt [[item/19]], nhưng tầm bắn chỉ 1.000 đơn vị, nên hiệu quả nhất ở cự ly gần.", false],
	],
	"item/21": [
		[0, "", "[[item/21]] gây 14 sát thương mỗi 0,2 giây, sát thương theo thời gian cao nhất trong mọi súng bắn thẳng. Giống [[item/20]], tầm bắn của nó chỉ 1.000 đơn vị. Đây cũng là blaster hiếm nhất ở các cửa hàng.", false],
	],
	"item/22": [
		[0, "", "[[item/22]] là khẩu súng yếu nhất trong trò chơi: 2 sát thương mỗi 0,4 giây với tầm bắn 1.000. Pháo tự động bắn những viên đạn nhỏ và nhanh; chúng gây sát thương nhẹ nhưng một số mẫu bắn rất nhanh. Mẫu đầu tiên này chỉ là giải pháp tạm thời.", false],
		[6, "", "Đây là một trong ba món [[character/2]] cho miễn phí trong hangar của ông tại [[station/78]] trước cuộc đột kích sào huyệt hải tặc, cùng với [[item/0]] và [[item/55]].", false],
	],
	"item/23": [
		[0, "", "[[item/23]] tăng gấp đôi sát thương của [[item/22]] lên 4 mỗi phát và bắn nhanh hơn một chút (mỗi 0,3 giây), vẫn với tầm bắn 1.000. Đây là một vũ khí giá rẻ cho giai đoạn đầu.", false],
	],
	"item/24": [
		[0, "", "[[item/24]] gây 6 sát thương mỗi 0,3 giây với tầm bắn 1.200. Đây là một pháo tự động tầm trung vững chắc và có sát thương theo thời gian ngang bằng [[item/25]], loại bắn xa hơn.", false],
	],
	"item/25": [
		[0, "", "[[item/25]] gây 8 sát thương mỗi 0,4 giây và có tầm bắn 1.400 đơn vị, xa nhất trong mọi pháo tự động. Về sát thương theo thời gian, nó ngang bằng [[item/24]]. Nó không bao giờ được bán sẵn. Bản thiết kế của nó đến từ [[agent/2]] tại [[station/20]], và nó được chế tạo chỉ từ hàng hóa thông thường, không cần quặng.", false],
	],
	"item/26": [
		[0, "", "[[item/26]] bắn mỗi 0,2 giây với 5 sát thương ở tầm bắn 1.000. Tốc độ bắn nhanh giúp nó có sát thương theo thời gian cao hơn các súng ray, đổi lại tầm bắn ngắn hơn.", false],
	],
	"item/27": [
		[0, "", "[[item/27]] bắn mỗi 0,1 giây, tốc độ bắn nhanh nhất trong mọi pháo tự động, với 6 sát thương mỗi viên. Sát thương theo thời gian của nó gần bằng các blaster tốt nhất, nhưng tầm bắn 900 là ngắn nhất trong mọi loại súng. Nó không bao giờ được bán sẵn. Bản thiết kế của nó đến từ [[agent/3]] tại [[station/10]], và việc chế tạo cần [[item/154]] cùng các hàng hóa khác.", false],
	],
	"item/28": [
		[0, "", "[[item/28]] là súng nhiệt đầu tiên. Súng nhiệt bắn những phát nhẹ, liên tục với tầm bắn 1.000; khẩu này gây 3 sát thương mỗi 0,3 giây. Dù có cấp công nghệ cao, nó yếu hơn về sát thương theo thời gian so với hầu hết blaster và pháo tự động tầm trung.", false],
	],
	"item/29": [
		[0, "", "[[item/29]] gây 4 sát thương mỗi 0,2 giây với tầm bắn 1.000, gấp đôi sát thương theo thời gian của [[item/28]].", false],
	],
	"item/3": [
		[0, "", "[[item/3]] là một laser [[faction/1|Vossk]] gây 7 sát thương mỗi 0,5 giây. Mỗi phát ngang bằng [[item/2]] nhưng bắn chậm hơn một chút, nên tụt lại đôi chút về sát thương theo thời gian. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
		[0, "", "[[ship/10]] của [[character/0]] mang hai khẩu này trong cảnh mở đầu.", false],
	],
	"item/30": [
		[0, "", "[[item/30]] bắn mỗi 0,1 giây với 3 sát thương, nhanh nhất trong các súng nhiệt. Về sát thương theo thời gian, nó cao hơn [[item/29]], nhưng thấp hơn các blaster hàng đầu như [[item/21]].", false],
	],
	"item/31": [
		[0, "", "[[item/31]] là rocket [[faction/1|Vossk]] cơ bản và là loại đạn vũ khí phụ rẻ nhất: 60 sát thương mỗi phát trúng, mỗi 1,2 giây phóng một quả, tầm bắn 1.200. Rocket bay thẳng và không bám theo mục tiêu, nên hiệu quả nhất ở cự ly gần. Bất kỳ rocket hay ngư lôi nào trúng tiểu hành tinh đều làm nó vỡ tan. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/32": [
		[0, "", "[[item/32]] là rocket không điều khiển phổ biến: 70 sát thương mỗi phát trúng, mỗi 0,9 giây phóng một quả và tầm bắn 1.200. Nó đánh mạnh hơn và phóng nhanh hơn [[item/31]] và được bán rộng rãi.", false],
	],
	"item/33": [
		[0, "", "[[item/33]] gây 72 sát thương và đồng thời hút 34 năng lượng, nên vừa có thể gây sát thương vừa góp phần vô hiệu hóa mục tiêu. Nó nạp lại chậm (2 giây) và có tầm bắn 1.000 đơn vị. Nó không bao giờ được bán sẵn. Bản thiết kế của nó đến từ [[agent/4]] tại [[station/43]], và mỗi mẻ chỉ cần vài loại hàng hóa thông thường giá rẻ.", false],
	],
	"item/34": [
		[0, "", "[[item/34]] dùng để vô hiệu hóa hơn là phá hủy: nó hút 45 năng lượng và chỉ gây 10 sát thương mỗi phát trúng, mỗi giây phóng một quả. [[item/35]] hút nhiều hơn và gây nhiều sát thương hơn.", false],
	],
	"item/35": [
		[0, "", "[[item/35]] hút 60 năng lượng và gây 30 sát thương mỗi phát trúng, mỗi giây phóng một quả với tầm bắn 1.000. Nó vô hiệu hóa tàu nhanh hơn [[item/34]] mà vẫn bào mòn thân tàu.", false],
	],
	"item/36": [
		[0, "", "[[item/36]] là ngư lôi cơ bản. Ngư lôi bay thẳng trong 1,5 giây đầu rồi tự dẫn về phía mục tiêu. [[item/36]] gây 70 sát thương với tầm bắn 3.000 đơn vị, nhưng nó chậm và chỉ phóng được mỗi 3 giây. [[item/38]] có sát thương gấp đôi.", false],
	],
	"item/37": [
		[0, "", "[[item/37]] là ngư lôi nhanh nhất: nó gây 100 sát thương, hút 50 năng lượng và có tầm bắn 4.000 đơn vị. Nó phóng mỗi 4 giây. Nó không bao giờ được bán sẵn. Bản thiết kế của nó đến từ [[agent/5]] tại [[station/54]], và mỗi mẻ chỉ cần vài loại hàng hóa thông thường.", false],
	],
	"item/38": [
		[0, "", "[[item/38]] là ngư lôi có sức công phá mạnh nhất, với 140 sát thương mỗi phát trúng và tầm bắn 4.000. Nó bay chậm và phóng mỗi 4 giây. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/39": [
		[0, "", "[[item/39]] là ngư lôi tự dẫn dùng để vô hiệu hóa tàu: nó hút 100 năng lượng và không gây sát thương. Với tầm bắn 5.000, đây là cách rẻ tiền để chặn đứng mục tiêu từ xa. [[item/40]] thêm 120 sát thương với cùng mức hút năng lượng.", false],
	],
	"item/4": [
		[0, "", "[[item/4]] là laser [[faction/1|Vossk]] mạnh hơn: 10 sát thương mỗi 0,6 giây. Sát thương theo thời gian của nó gần như đúng bằng [[item/2]], với những phát bắn nặng hơn nhưng thưa hơn [[item/3]]. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/40": [
		[0, "", "[[item/40]] kết hợp 120 sát thương với 100 điểm hút năng lượng trong một quả ngư lôi tự dẫn, tầm bắn 5.000 và phóng mỗi 5 giây. Nó đắt hơn gấp đôi [[item/39]].", false],
	],
	"item/41": [
		[0, "", "[[item/41]] là bom EMP nhỏ nhất. Bom được phóng bằng một lần nhấn và kích nổ bằng lần nhấn thứ hai; vụ nổ hút năng lượng của mọi con tàu trong bán kính của nó, mạnh hơn ở gần tâm, và không ảnh hưởng đến tàu đã phóng nó. Tiểu hành tinh không bị ảnh hưởng. Mẫu này hút tối đa 80 năng lượng trong bán kính 22.000. [[item/42]] và [[item/43]] mạnh hơn và rộng hơn.", false],
		[20, "", "Lực lượng an ninh [[faction/0|Terran]] để sẵn mười quả bom này tại [[station/55]] miễn phí, để [[character/0]] có thể vô hiệu hóa tàu của bọn bắt cóc mà không phá hủy nó.", false],
	],
	"item/42": [
		[0, "", "[[item/42]] hút tối đa 150 năng lượng trong bán kính 30.000, gần gấp đôi sức mạnh của [[item/41]] và có vụ nổ rộng hơn nhiều.", false],
	],
	"item/43": [
		[0, "", "[[item/43]] là bom EMP mạnh nhất: nó hút tối đa 300 năng lượng trong bán kính 37.000. Nó nạp lại nhanh hơn [[item/42]] một chút nhưng đắt gần gấp đôi.", false],
	],
	"item/44": [
		[0, "", "[[item/44]] là bom hạt nhân nhỏ nhất. Giống bom EMP, nó được phóng rồi kích nổ bằng lần nhấn thứ hai, nhưng vụ nổ của nó gây sát thương thực sự: tối đa 200 trong bán kính 20.000, giảm dần về phía rìa. Nó cũng phá vỡ tiểu hành tinh. Tàu phóng bom không bị ảnh hưởng.", false],
	],
	"item/45": [
		[0, "", "[[item/45]] gây tối đa 560 sát thương trong bán kính 30.000, gần gấp ba sức mạnh của [[item/44]] với vụ nổ rộng hơn.", false],
	],
	"item/46": [
		[0, "", "[[item/46]] là vũ khí có sức hủy diệt lớn nhất trong trò chơi: tối đa 950 sát thương trong bán kính 40.000. Nó không bao giờ được bán sẵn. Bản thiết kế của nó đến từ [[agent/6]] tại [[station/61]], và việc chế tạo cần hàng phóng xạ và chất nổ cùng các hàng hóa thông thường khác.", false],
	],
	"item/47": [
		[0, "", "[[item/47]] là tháp pháo cơ bản. Tháp pháo nằm trong ô riêng mà chỉ một số thân tàu có, và có thể xoay trọn vòng, nên có thể bắn trúng mục tiêu bên cạnh hoặc phía sau tàu; trong khi bạn ngắm, tàu tự bay tiếp. Mẫu này gây 6 sát thương mỗi 0,3 giây với tầm bắn 2.000 và xoay chậm (độ linh hoạt 40).", false],
	],
	"item/48": [
		[0, "", "[[item/48]] gây 10 sát thương mỗi 0,2 giây với tầm bắn 2.500 và xoay nhanh hơn [[item/47]] (độ linh hoạt 60). Nó đắt hơn gấp ba lần.", false],
	],
	"item/49": [
		[0, "", "[[item/49]] là tháp pháo tốt nhất: 12 sát thương mỗi 0,1 giây với tầm bắn 3.000, có tốc độ xoay nhanh nhất (độ linh hoạt 100). Nó cũng rất đắt, khoảng gấp đôi [[item/48]]. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/5": [
		[0, "", "[[item/5]] mở đầu dòng laser Berger, vốn đánh đổi tốc độ bắn lấy những phát nặng hơn và tầm bắn xa hơn một chút (2.200). Nó gây 8 sát thương mỗi 0,9 giây, ít sát thương theo thời gian hơn [[item/2]] rẻ hơn. Lợi thế của nó là tầm bắn xa hơn.", false],
	],
	"item/50": [
		[0, "", "[[item/50]] là khiên cơ bản. Khiên hấp thụ sát thương trước khi giáp và thân tàu bị ảnh hưởng, và tự nạp lại trong thời gian nạp của nó. Targe chỉ chứa 50 điểm, nhưng nạp đầy hoàn toàn trong 20 giây, nhanh hơn mọi khiên khác.", false],
	],
	"item/51": [
		[0, "", "[[item/51]] chứa 80 điểm nhưng cần 46 giây để nạp đầy hoàn toàn. Nó hấp thụ nhiều hơn [[item/50]] trong một trận đánh nhưng hồi phục chậm hơn nhiều giữa các đợt tấn công.", false],
	],
	"item/52": [
		[0, "", "[[item/52]] là một khiên [[faction/1|Vossk]] chứa 120 điểm và nạp đầy trong 58 giây. Nó hấp thụ nhiều hơn hẳn [[item/51]], nhưng [[item/53]] chứa nhiều hơn và nạp nhanh hơn. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/53": [
		[0, "", "[[item/53]] chứa 150 điểm và nạp đầy trong 45 giây, nên vượt [[item/52]] ở cả hai mặt. Đây là khiên tốt nhất được bán ở cửa hàng.", false],
	],
	"item/54": [
		[0, "", "[[item/54]] là khiên mạnh nhất: 220 điểm, nạp đầy trong 60 giây. Nó không bao giờ được bán sẵn. Bản thiết kế của nó đến từ [[agent/7]] tại [[station/72]], và việc chế tạo cần một lượng lớn [[item/163]] cùng với linh kiện điện tử, công nghệ nano và vi mạch.", false],
	],
	"item/55": [
		[0, "", "[[item/55]] là tấm giáp cơ bản. Tấm giáp cộng điểm của nó vào giáp của tàu; sau khiên, nó chịu sát thương trước thân tàu, và khác với khiên, nó không tự nạp lại. E2 thêm 40 điểm, một tỷ lệ lớn đối với tàu khởi đầu hạng nhẹ như [[ship/32]], vốn có 100 điểm của riêng mình.", false],
		[6, "", "Đây là một trong ba món [[character/2]] cho miễn phí trong hangar của ông tại [[station/78]] trước cuộc đột kích sào huyệt hải tặc, cùng với [[item/0]] và [[item/22]].", false],
	],
	"item/56": [
		[0, "", "[[item/56]] thêm 80 điểm giáp, gấp đôi [[item/55]], với giá phải chăng.", false],
	],
	"item/57": [
		[0, "", "[[item/57]] thêm 110 điểm giáp. Đây là tấm giáp tốt nhất được bán bên ngoài các hệ sao [[faction/1|Vossk]].", false],
	],
	"item/58": [
		[0, "", "[[item/58]] là một tấm giáp [[faction/1|Vossk]] thêm 160 điểm giáp, nhiều hơn hẳn [[item/57]]. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/59": [
		[0, "", "[[item/59]] là tấm giáp tốt nhất: nó thêm 250 điểm, bằng giáp gốc của [[ship/9]] và nhiều hơn giáp gốc của mọi thân tàu khác trừ [[ship/8]]. Nó không bao giờ được bán sẵn. Bản thiết kế của nó đến từ [[agent/8]] tại [[station/84]], và việc chế tạo cần [[item/157]], [[item/168]] và [[item/156]] cùng với hàng hóa thông thường.", false],
	],
	"item/6": [
		[0, "", "[[item/6]] gây 9 sát thương mỗi 0,8 giây với tầm bắn 2.200. Đây là một bước tiến khiêm tốn so với [[item/5]], và giá của nó hầu như không thay đổi giữa các hệ sao.", false],
	],
	"item/60": [
		[0, "", "[[item/60]] là mô-đun chống EMP yếu nhất trong ba loại, với chỉ số phòng thủ EMP 20. Không loại nào trong ba loại có giá, và không cửa hàng nào bán chúng.", false],
	],
	"item/61": [
		[0, "", "[[item/61]] là mô-đun chống EMP hạng trung, với chỉ số phòng thủ EMP 40, gấp đôi [[item/60]]. Giống các loại cùng dòng, nó không có giá và không được cửa hàng bán.", false],
	],
	"item/62": [
		[0, "", "[[item/62]] là mô-đun chống EMP mạnh nhất, với chỉ số phòng thủ EMP 60. Giống [[item/60]] và [[item/61]], nó không có giá và không được cửa hàng bán.", false],
	],
	"item/63": [
		[0, "", "[[item/63]] là bộ nén hàng hóa cơ bản. Bộ nén mở rộng khoang hàng thêm một tỷ lệ phần trăm sức chứa của chính thân tàu; bộ này thêm 15 %. Nó rẻ và đáng giá cho bất kỳ thương nhân hay thợ mỏ nào.", false],
	],
	"item/64": [
		[0, "", "[[item/64]] mở rộng khoang hàng thêm 25 %, một bước tiến rõ rệt so với [[item/63]] với giá thấp.", false],
	],
	"item/65": [
		[0, "", "[[item/65]] mở rộng khoang hàng thêm 40 %. Trên một tàu chở hàng lớn, nó thêm chỗ bằng cả sức chứa của một con tàu nhỏ.", false],
	],
	"item/66": [
		[0, "", "[[item/66]] mở rộng khoang hàng thêm 75 %, nhiều nhất trong các bộ nén được bán ở cửa hàng.", false],
	],
	"item/67": [
		[0, "", "[[item/67]] tăng gấp đôi khoang hàng, thêm 100 % sức chứa của thân tàu: một [[ship/36]] chở được 700 t khi lắp nó. Nó không bao giờ được bán sẵn. Bản thiết kế của nó đến từ [[agent/9]] tại [[station/90]], và nó được chế tạo chỉ từ hàng hóa thông thường.", false],
	],
	"item/68": [
		[0, "", "[[item/68]] là chùm tia kéo cơ bản. Không có chùm tia kéo thì không thể thu gom thùng hàng trôi nổi nào; bay vào nó cũng chẳng có tác dụng gì. Với Retractor, bạn giữ thùng hàng dưới tâm ngắm trong 4 giây, sau đó nó được kéo vào. [[item/69]] cần ít thời gian hơn, còn [[item/70]] hoạt động tự động.", false],
		[24, "", "[[character/6]] yêu cầu [[character/0]] lắp chùm tia kéo trước chuyến thám hiểm đầu tiên chống lại [[faction/9|Void]], để anh có thể thu gom xác tàu của chúng. Cho đến lúc đó, các cửa hàng có khả năng cao bán Retractor ngoài các mặt hàng thông thường.", false],
	],
	"item/69": [
		[0, "", "[[item/69]] hoạt động như [[item/68]] nhưng chỉ cần giữ mục tiêu dưới tâm ngắm trong 3 giây trước khi kéo thùng hàng vào.", false],
	],
	"item/7": [
		[0, "", "[[item/7]] gây 10 sát thương mỗi 0,8 giây với tầm bắn 2.200. Về sát thương theo thời gian, nó ngang bằng [[item/1]], nên giá trị của nó nằm ở những đòn ít hơn nhưng nặng hơn ở tầm xa.", false],
	],
	"item/70": [
		[0, "", "[[item/70]] là chùm tia kéo tự động: nó thu gom mọi thùng hàng trong tầm nhìn phía trước mà không cần ngắm và giữ, giúp tiết kiệm nhiều thời gian khi thu nhặt chiến lợi phẩm trên chiến trường. Nó đắt hơn [[item/69]] rất nhiều.", false],
	],
	"item/71": [
		[0, "", "[[item/71]] là bộ tăng tốc cơ bản. Bộ tăng tốc cho một đợt bứt tốc ngắn, rồi cần thời gian nạp lại. Bộ này tăng 60 % tốc độ trong 3 giây và nạp lại trong 8 giây.", false],
	],
	"item/72": [
		[0, "", "[[item/72]] được định mức tăng 80 % tốc độ trong 4,4 giây, nạp lại trong 10 giây. Khi bay, đợt bứt tốc của nó đạt cùng tốc độ tối đa như [[item/71]]; điều nó mang lại thêm là đợt bứt tốc dài hơn.", false],
	],
	"item/73": [
		[0, "", "[[item/73]] mang lại mức tăng hơn gấp đôi các bộ tăng tốc rẻ hơn: thêm 160 % tốc độ trong 5,6 giây, nạp lại trong 12 giây.", false],
	],
	"item/74": [
		[0, "", "[[item/74]] là bộ tăng tốc mạnh nhất: thêm 200 % tốc độ trong 6 giây. Nó cần thời gian nạp lại lâu nhất, 16 giây. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/75": [
		[0, "", "[[item/75]] là robot sửa chữa duy nhất trong trò chơi và được lắp vào một ô trang bị. Khi bạn bay, nó phục hồi một điểm thân tàu mỗi 0,6 giây và một điểm giáp bọc mỗi giây, nên hư hại tự hồi phục giữa các trận đánh mà không cần cập cảng. Nó rẻ và có bán ở hầu hết cửa hàng.", false],
	],
	"item/76": [
		[0, "", "[[item/76]] là vòi lái cơ bản. Vòi lái cộng chỉ số của nó vào độ linh hoạt của tàu, giúp tàu xoay nhanh hơn. Vòi này thêm 20, một mức tăng nhỏ đối với chiến đấu cơ nhanh nhẹn nhưng đáng kể trên một tàu chở hàng chậm chạp.", false],
	],
	"item/77": [
		[0, "", "[[item/77]] thêm 40 độ linh hoạt, gấp đôi [[item/76]], với giá thấp.", false],
	],
	"item/78": [
		[0, "", "[[item/78]] là một vòi lái [[faction/1|Vossk]] thêm 70 độ linh hoạt. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/79": [
		[0, "", "[[item/79]] là một vòi lái [[faction/1|Vossk]] thêm 100 độ linh hoạt, đủ để một tàu chở hàng hạng nặng xoay như một chiến đấu cơ nhanh nhẹn. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/8": [
		[0, "", "[[item/8]] là laser Berger cuối cùng và mạnh nhất: 12 sát thương mỗi phát, mỗi 0,9 giây, với tầm bắn 2.200. Đây là laser thông thường có sát thương mỗi phát cao nhất, nhưng [[item/2]] bắn nhanh hơn vẫn gây nhiều sát thương theo thời gian hơn. Các laser chùm M6 tiếp theo ([[item/9]] trở đi) đánh mạnh hơn gấp đôi mỗi phát.", false],
	],
	"item/80": [
		[0, "", "[[item/80]] là vòi lái tốt nhất, thêm 130 độ linh hoạt. Nó nâng [[ship/36]], thân tàu xoay chậm nhất, từ 45 lên 175, cao hơn bất kỳ chiến đấu cơ nào không lắp vòi lái. Nó hiếm có ở cửa hàng.", false],
	],
	"item/81": [
		[0, "", "[[item/81]] là máy quét cơ bản. Máy quét quyết định thời gian cần để khóa một mục tiêu như tàu, trạm hay tiểu hành tinh; Quickscan cần 4 giây. [[item/82]] khóa nhanh hơn và còn hiển thị những gì các tàu khác đang chở.", false],
		[2, "", "Tàu khai thác của [[character/2]], [[ship/0]], được lắp sẵn một máy này.", false],
	],
	"item/82": [
		[0, "", "[[item/82]] khóa mục tiêu trong 3 giây và hiển thị hàng hóa của tàu đang được nhắm, giúp ích khi săn chiến lợi phẩm.", false],
	],
	"item/83": [
		[0, "", "[[item/83]] khóa mục tiêu trong 1,8 giây, thời gian khóa mà chỉ [[item/84]] sánh được, và cũng hiển thị hàng hóa của mục tiêu.", false],
	],
	"item/84": [
		[0, "", "[[item/84]] khóa mục tiêu nhanh như [[item/83]] và hiển thị hàng hóa, ngoài ra còn đánh dấu tiểu hành tinh hạng A, loại duy nhất có thể cho lõi (xem [[guide/mining]]). Đây là máy quét được thợ mỏ ưa chuộng.", false],
	],
	"item/85": [
		[0, "", "[[item/85]] là động cơ nhảy duy nhất trong trò chơi. Khi lắp nó, bạn có thể di chuyển từ bản đồ sao thẳng đến một trạm ở hệ sao khác mà không cần đi qua cổng nhảy. Không thể dùng nó trong một số nhiệm vụ. Nó không bao giờ được bán sẵn, và không đặc vụ nào bán bản thiết kế của nó. Việc chế tạo cần [[item/164]], [[item/158]], [[item/160]] và [[item/163]] cùng với một lượng lớn hàng hóa thông thường.", false],
		[33, "", "Người phát minh ra nó, [[character/20]], nhờ [[character/0]] mang về 50 [[item/164]] cho công trình nghiên cứu một loại động cơ có thể đến bất kỳ nơi nào trong không gian.", false],
		[34, "", "Để đổi lấy các tinh thể, [[character/20]] tặng [[character/0]] một bản sao bản thiết kế. 50 tinh thể đã giao được tính vào động cơ, nên chỉ cần cung cấp các thành phần còn lại.", false],
	],
	"item/86": [
		[0, "", "[[item/86]] là laser khai thác cơ bản. Cần có laser khai thác để khoan quặng từ tiểu hành tinh. Hiệu suất quyết định mũi khoan giữ hướng ổn định đến đâu, và mỗi mẫu còn có tốc độ khoan riêng (xem [[guide/mining]]). Mẫu này có hiệu suất 30 và khó giữ hướng ở các lớp sâu.", false],
	],
	"item/87": [
		[0, "", "[[item/87]] có hiệu suất 50. Nó ổn định hơn rõ rệt so với [[item/86]], dù khoan chậm hơn một chút.", false],
	],
	"item/88": [
		[0, "", "[[item/88]] là một laser khai thác [[faction/1|Vossk]] có hiệu suất 80, mũi khoan ổn định nhất được bán ở cửa hàng. Nhược điểm là nó khai thác quặng chậm nhất. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/89": [
		[0, "", "[[item/89]] có hiệu suất 60, kém ổn định hơn [[item/88]], nhưng khai thác quặng nhanh hơn hẳn mọi laser khác được bán ở cửa hàng. Nó phù hợp với thợ mỏ tự giữ được hướng mũi khoan.", false],
	],
	"item/9": [
		[0, "", "[[item/9]] là laser chùm M6 đầu tiên. Những laser này bắn thưa nhưng rất mạnh: 27 sát thương mỗi 1,2 giây, với tầm bắn 2.400, xa hơn mọi laser trước đó. Ngắm chính xác là điều quan trọng, vì bắn trượt sẽ lãng phí một lần nạp lâu. Nó cũng là bộ phận gốc để chế tạo [[item/11]].", false],
	],
	"item/90": [
		[0, "", "[[item/90]] là laser khai thác tốt nhất: hiệu suất 100 và tốc độ khoan nhanh nhất trong mọi mẫu. Nó không bao giờ được bán sẵn. Bản thiết kế của nó đến từ [[agent/11]] tại [[station/78]], và việc chế tạo cần một lượng lớn công nghệ nano, vật tư cơ khí và thủy lực, cùng với [[item/155]] và mười [[item/166]].", false],
		[2, "", "Tia laser trên tàu khai thác đầu tiên của [[character/0]] là nguyên mẫu mũi khoan này do chính tay [[character/2]] chế tạo.", false],
		[10, "", "Khi [[character/2]] tặng [[character/0]] con tàu [[ship/0]], ông giữ lại nguyên mẫu, cái duy nhất ông có, và gợi ý anh ghé lại sau, khi ông có thể đã làm thêm được.", false],
	],
	"item/91": [
		[0, "", "[[item/91]] chứa được 3 hành khách. Cabin cần thiết cho các công việc [[job/11]], và chỗ của nhiều cabin được cộng dồn. [[item/92]] và [[item/93]] chứa được nhiều hơn.", false],
	],
	"item/92": [
		[0, "", "[[item/92]] chứa được 5 hành khách, nhiều hơn [[item/91]] hai người.", false],
	],
	"item/93": [
		[0, "", "[[item/93]] chứa được 10 hành khách, gấp đôi [[item/92]], mở ra những công việc chở khách lớn hơn.", false],
	],
	"item/94": [
		[0, "", "[[item/94]] là thiết bị tàng hình cơ bản. Khi thiết bị tàng hình hoạt động, các tàu khác không thể nhìn thấy bạn. Thiết bị này che giấu tàu trong 15 giây rồi cần 18 giây để nạp lại. Thời gian tàng hình được tính cho huy chương [[medal/19]].", false],
	],
	"item/95": [
		[0, "", "[[item/95]] là một thiết bị tàng hình [[faction/1|Vossk]] che giấu tàu trong 28 giây và nạp lại trong 32 giây, thời gian ẩn gần gấp đôi [[item/94]]. Chỉ cửa hàng ở các hệ sao [[faction/1|Vossk]] mới có bán.", false],
	],
	"item/96": [
		[0, "", "[[item/96]] là thiết bị tàng hình tốt nhất: nó che giấu tàu trong 46 giây và nạp lại chỉ trong 40 giây, nên có thể hoạt động phần lớn thời gian. Nó không bao giờ được bán sẵn. Bản thiết kế của nó đến từ [[agent/10]] tại [[station/59]].", false],
	],
	"job/0": [
		[0, "", "Công việc chuyển phát yêu cầu bạn chở một lô thùng hàng niêm phong đến một trạm khác. Các thùng hàng được chất vào khoang khi bạn nhận việc, nên bạn cần đủ chỗ trống; chúng không thể bán. Công việc hoàn thành khi bạn cập cảng tại điểm đến với hàng trên tàu. Hải tặc đôi khi phục kích người chuyển phát. Hàng đã giao được tính cho [[medal/5]].", false],
	],
	"job/1": [
		[0, "", "Trong công việc phòng thủ, một trạm sắp bị tấn công, và bạn được thuê để giúp các chiến đấu cơ của trạm đánh đuổi kẻ đột kích. Kẻ tấn công thường là hải tặc, nếu không thì là tàu của chủng tộc đối địch. Bay đến trạm và tiêu diệt mọi kẻ tấn công; số tàu do chiến đấu cơ đồng minh hạ cũng được tính. Công việc càng khó thì kẻ tấn công càng nhiều.", false],
	],
	"job/10": [
		[0, "", "Trong công việc chặn đánh, một đoàn gồm hai hoặc ba tàu chở hàng lậu nằm ở xa trạm, được chiến đấu cơ canh gác. Hãy đi theo các điểm mốc và tiêu diệt các tàu chở hàng. Lính gác của chúng chờ dọc đường và quanh đoàn tàu.", false],
	],
	"job/11": [
		[0, "", "Công việc chở khách yêu cầu bạn đưa một nhóm người đến trạm khác. Bạn cần cabin đủ chỗ cho tất cả họ khi nhận việc; khi họ ở trên tàu, không thể tháo cabin và không thể đổi thân tàu. Cập cảng tại điểm đến để đưa họ xuống. Phần thưởng cơ bản thấp hơn, nhưng mỗi hành khách đều được cộng thêm. Số hành khách đã đưa đến được tính cho [[medal/18]].", false],
	],
	"job/12": [
		[0, "", "Thách đấu là một cuộc so tài bắn súng do một phi công khác trong Phòng chờ đề nghị. Cả hai cùng bay từ một trạm đến chỗ một nhóm hải tặc rải dọc một lộ trình, và ai bắn hạ nhiều hơn sẽ thắng. Đối thủ không thể bị tiêu diệt và bắn mạnh ngang súng của bạn. Bạn chỉ được trả tiền nếu hạ được nhiều hơn; số hải tặc luôn là số lẻ, nên không bao giờ hòa.", false],
	],
	"job/2": [
		[0, "", "Công việc bảo vệ cử bạn canh gác các tàu khai thác đang làm việc ở một bãi tiểu hành tinh gần trạm. Kẻ đột kích kéo đến và nhắm vào trạm và các tàu khai thác. Hãy tiêu diệt tất cả chúng trước khi chúng xóa sổ các tàu khai thác; nếu mọi tàu khai thác đều bị mất, công việc thất bại.", false],
	],
	"job/3": [
		[0, "", "Trong công việc thu hồi, hàng bị đánh cắp đang được chở bởi một trong số các tàu hải tặc gần một trạm. Bạn phải lấy lại thùng hàng mà không phá hủy nó: vô hiệu hóa tàu chở bằng vũ khí EMP và kéo thùng hàng vào bằng chùm tia kéo. Máy quét hiển thị hàng hóa giúp bạn tìm đúng tàu. Thùng hàng sẽ mất nếu tàu chở bị phá hủy hoặc khoang hàng của bạn không còn chỗ. Khi đã lấy được, hãy quay về trạm nơi bạn nhận việc để được trả công. Thu hồi được trả gấp đôi.", false],
	],
	"job/4": [
		[0, "", "Săn hải tặc nghĩa là quét sạch một sào huyệt hải tặc gần trạm. Bọn hải tặc chờ trong bãi tiểu hành tinh hoặc dọc một lộ trình gồm hai hoặc ba điểm mốc, và chỉ hành động khi nhìn thấy bạn. Hãy đi theo các điểm mốc và tiêu diệt mọi tên hải tặc. Độ khó càng cao thì hải tặc càng đông.", false],
	],
	"job/5": [
		[0, "", "Công việc trục vớt là một cuộc giải cứu: một con tin bị giữ trên một trong số các tàu gần trạm. Như trong công việc thu hồi, hãy vô hiệu hóa tàu của kẻ bắt cóc bằng EMP và dùng chùm tia kéo để đưa con tin lên tàu; phá hủy con tàu đó sẽ chấm dứt công việc. Sau đó đưa con tin về trạm nơi bạn đã nhận việc. Trục vớt được trả gấp đôi.", false],
	],
	"job/6": [
		[0, "", "Công việc truy nã nêu tên một tên tội phạm nguy hiểm vừa bị phát hiện gần một trạm. Mục tiêu chờ ở một điểm xa và chỉ phản ứng khi bạn lọt vào tầm nhìn. Nó mạnh hơn nhiều so với hải tặc thông thường, và càng mạnh hơn theo độ khó của công việc và cấp phi công của bạn. Hãy tiêu diệt nó để lĩnh tiền thưởng.", false],
	],
	"job/7": [
		[0, "", "Dọn rác vũ trụ yêu cầu bạn dọn sạch một đám rác không gian gần trạm trong khoảng hai phút. Mọi mảnh rác phải bị phá hủy trước khi hết giờ; ở độ khó cao hơn sẽ có vài tên hải tặc tham gia. Công việc này trả ít hơn hầu hết các việc khác, nhưng nhanh gọn, và rác bị phá hủy được tính cho [[medal/10]].", false],
	],
	"job/8": [
		[0, "", "Công việc mua hàng đến từ một người mua trong Phòng chờ cần một số lượng của một mặt hàng cụ thể. Hãy kiếm hàng từ cửa hàng, thương nhân hoặc khai thác, rồi cập cảng lại tại trạm của người mua với hàng trong khoang. Hàng được bàn giao và bạn nhận một nửa phần thưởng công việc thông thường cộng thêm ba lần giá trị trung bình của hàng, nên người mua thường trả cao hơn hẳn bất kỳ cửa hàng nào. Người mua xuất hiện từ [[step/16]] trở đi.", false],
	],
	"job/9": [
		[0, "", "Công việc hộ tống yêu cầu bạn bảo vệ một đoàn năm tàu chở hàng gần một trạm. Khi các tàu chở hàng bay tiếp, những kẻ tấn công chờ sẵn dọc lộ trình sẽ áp sát. Hãy tiêu diệt mọi kẻ tấn công. Nếu mọi tàu chở hàng đều bị mất, công việc thất bại. Hộ tống được trả cao hơn một phần năm so với hầu hết công việc.", false],
	],
	"medal/0": [
		[0, "", "[[character/0]] có huy chương này ngay từ đầu trò chơi, nhờ thời gian phục vụ trước đây. Không cần làm gì để giành được nó.", false],
	],
	"medal/1": [
		[0, "", "Trao khi đến được một trạm với rất ít thân tàu còn lại. Việc kiểm tra diễn ra khi bạn tiến đến, trước khi trạm sửa tàu, và dùng độ bền của chính thân tàu, không tính tấm giáp. Phần còn lại càng thấp thì hạng càng cao.", false],
	],
	"medal/10": [
		[0, "", "Trao khi phá hủy rác không gian, như trong các công việc [[job/7]]. Mọi mảnh bạn bắn đều được tính.", false],
	],
	"medal/11": [
		[0, "", "Trao theo số trạm khác nhau bạn đã cập cảng.", false],
	],
	"medal/12": [
		[0, "", "Trao theo số hệ sao khác nhau bạn đã ghé thăm. Hệ sao ẩn được tính khi bạn đến được đó.", false],
	],
	"medal/13": [
		[0, "", "Trao theo số bản thiết kế bạn sở hữu. Bản thiết kế được mua từ đặc vụ trong Phòng chờ; xem [[guide/blueprints]].", false],
	],
	"medal/14": [
		[0, "", "Trao theo số bản thiết kế khác nhau bạn đã hoàn thành ít nhất một lần. Chế tạo lại cùng một vật phẩm không được cộng thêm.", false],
	],
	"medal/15": [
		[0, "", "Trao theo thời gian bạn đã chơi, tính bằng giờ. Trò chơi tính thời gian bay.", false],
	],
	"medal/16": [
		[0, "", "Trao theo số công việc tự do đã hoàn thành. Công việc thất bại và bị bỏ dở không được tính.", false],
	],
	"medal/17": [
		[0, "", "Trao theo số lần bạn đã đi qua cổng nhảy. Các cú nhảy bằng động cơ nhảy không được tính.", false],
	],
	"medal/18": [
		[0, "", "Trao theo số hành khách đã đưa đến trong các công việc [[job/11]]. Cabin càng rộng thì nhóm khách càng đông.", false],
	],
	"medal/19": [
		[0, "", "Trao theo tổng số phút ở trạng thái tàng hình. Hãy lắp thiết bị tàng hình và dùng nó mỗi khi đã nạp đầy.", false],
	],
	"medal/2": [
		[0, "", "Trao khi khai thác các loại quặng khác nhau. Mỗi loại chỉ được tính một lần, dù bạn khai thác bao nhiêu. Vì các bãi chứa những loại quặng có quê nhà ở gần đó, bạn sẽ cần khai thác ở nhiều vùng của thiên hà.", false],
	],
	"medal/20": [
		[0, "", "Trao theo số bom EMP và bom hạt nhân đã phóng.", false],
	],
	"medal/21": [
		[0, "", "Trao theo số tấn [[item/131]] thu gom bằng chùm tia kéo từ xác tàu và tàu bị vô hiệu hóa.", false],
	],
	"medal/22": [
		[0, "", "Huy chương một hạng dành cho việc bay mà hoàn toàn không lắp vũ khí, hoặc không lắp trang bị nào, được kiểm tra vào lần cập cảng tiếp theo. Không thể giành được nó ở đầu cốt truyện: cho đến [[step/8]], tàu luôn được coi là có vũ trang.", false],
	],
	"medal/23": [
		[0, "", "Trao theo số vũ khí chính được lắp cùng lúc, kiểm tra khi bạn cập cảng. Cần một thân tàu có nhiều ô vũ khí chính để đạt các hạng cao hơn. Giống như [[medal/22]], nó chỉ được tính từ [[step/8]] trở đi.", false],
	],
	"medal/24": [
		[0, "", "Trao theo số tấn hàng hóa lấy từ xác tàu và tàu bị vô hiệu hóa bằng chùm tia kéo.", false],
	],
	"medal/25": [
		[0, "", "Trao theo số credit nhiều nhất bạn từng có cùng một lúc. Tiêu tiền sau đó không làm mất nó.", false],
	],
	"medal/26": [
		[0, "", "Trao khi nói chuyện với những vị khách trong Phòng chờ có lời đề nghị. Mỗi vị khách được tính một lần, vào lần đầu bạn nói chuyện với họ.", false],
	],
	"medal/27": [
		[0, "", "Trao theo số phi công hộ tống bạn đã thuê trong Phòng chờ, tính từng phi công trong mỗi nhóm.", false],
	],
	"medal/28": [
		[0, "", "Huy chương một hạng dành cho việc khiến một trong bốn chủng tộc lớn quay lưng với bạn, bằng cách đẩy một trong hai thang uy tín vượt quá 60 theo bất kỳ hướng nào. Xem [[guide/combat]].", false],
	],
	"medal/29": [
		[0, "", "Trao theo số tiểu hành tinh bị vũ khí của bạn phá hủy. Tiểu hành tinh vỡ do khai thác không được tính.", false],
	],
	"medal/3": [
		[0, "", "Trao khi khai thác các loại lõi khác nhau. Lõi chỉ có được khi khoan qua cả bảy lớp của một tiểu hành tinh hạng A, nên việc này đòi hỏi kiên nhẫn, một tia laser khai thác tốt và đi lại nhiều.", false],
	],
	"medal/30": [
		[0, "", "Huy chương một hạng được trao khi hoàn thành cốt truyện.", false],
	],
	"medal/31": [
		[0, "", "Trao theo chỗ trống trong khoang hàng nhiều nhất bạn từng có cùng một lúc. Một thân tàu lớn với các bộ nén hàng hóa và khoang hàng trống sẽ đạt các hạng cao hơn.", false],
	],
	"medal/32": [
		[0, "", "Trao theo số lời đề nghị bạn đã từ chối bằng No, thanks trong Phòng chờ.", false],
	],
	"medal/33": [
		[0, "", "Trao theo số lần bạn đã đề nghị một vị khách trong Phòng chờ nhắc lại lời đề nghị bằng How was that again?", false],
	],
	"medal/34": [
		[0, "", "Trao khi nhận công việc ở trạm khác mà không hỏi khách hàng trước xem việc đó có khó không.", false],
	],
	"medal/35": [
		[0, "", "Trao khi nhận công việc ở trạm khác mà không đề nghị khách hàng chỉ điểm đến trên bản đồ trước.", false],
	],
	"medal/36": [
		[0, "", "Trao tự động khi bạn đã có tất cả các huy chương khác, ở bất kỳ hạng nào. Sở hữu tất cả chúng còn mang lại những phần thưởng khác; xem [[guide/medals]].", false],
	],
	"medal/4": [
		[0, "", "Trao theo số tàu bạn đã phá hủy, tính trong suốt trò chơi. Hải tặc, kẻ địch và mục tiêu công việc đều được tính.", false],
	],
	"medal/5": [
		[0, "", "Trao theo số tấn hàng đã giao trong các công việc [[job/0]]. Những lô hàng chuyển phát lớn được tính nhiều hơn, nên khoang hàng lớn sẽ có lợi.", false],
	],
	"medal/6": [
		[0, "", "Trao theo tổng số tấn quặng đã khai thác trong suốt trò chơi.", false],
	],
	"medal/7": [
		[0, "", "Trao theo số lõi đã khai thác trong suốt trò chơi. Mỗi tiểu hành tinh hạng A được khoan đến cùng cho một lõi.", false],
	],
	"medal/8": [
		[0, "", "Trao theo số tấn rượu mua từ cửa hàng của trạm. Đồ uống địa phương của mọi hệ sao đều được tính.", false],
	],
	"medal/9": [
		[0, "", "Trao khi sở hữu các loại rượu khác nhau. Các loại được tính khi bạn mua chúng từ thương nhân trong Phòng chờ hoặc thu gom từ xác tàu bằng chùm tia kéo.", false],
	],
	"ship/0": [
		[0, "", "[[ship/0]] là thân tàu yếu nhất trong bảng tàu: 95 giáp, khoang hàng 25 t, một ô vũ khí chính, một ô vũ khí phụ và ba ô trang bị. Độ linh hoạt 140 là khá đối với tàu khởi đầu, nhưng [[ship/32]], thân tàu rẻ nhất được bán, có cùng số ô gắn với nhiều giáp, sức chứa hàng và độ nhanh nhẹn hơn. Không người bán nào rao bán [[ship/0]]; người chơi chỉ có được nó qua cốt truyện.", false],
		[2, "", "[[character/2]] sở hữu con tàu hải tặc cũ được chắp vá này và cho [[character/0]] dùng nó tại [[station/78]], sơn màu [[faction/8|hải tặc]], được lắp laser khai thác và một [[item/81]] nhưng không có súng. Tia laser là nguyên mẫu của riêng ông, thiết kế mà về sau ông bán dưới tên [[item/90]].", false],
		[10, "", "Sau cuộc đột kích sào huyệt hải tặc, [[character/2]] tặng hẳn con tàu cho [[character/0]], kèm động cơ mạnh hơn để di chuyển giữa các hành tinh trong hệ sao, nhưng giữ lại tia laser nguyên mẫu. Anh tiếp tục lái nó sau khi đến vùng không gian [[faction/0|Terran]].", false],
		[18, "", "Tại [[station/98]], [[character/1]] cho sơn lại thân tàu theo màu [[faction/0|Terran]] để các đội tuần tra thôi nhầm nó là tàu hải tặc.", false],
	],
	"ship/1": [
		[0, "", "[[ship/1]] là thân tàu rẻ nhất có bốn ô vũ khí phụ, ngoài ra còn có ô tháp pháo, hai súng chính và bảy ô trang bị. Giáp (192) và khoang hàng (65 t) chắc chắn. Độ linh hoạt 106 là chậm, nên nó chiến đấu tốt nhất bằng ngư lôi và tháp pháo. Đắt hơn một chút, [[ship/9]] có nhiều giáp và độ nhanh nhẹn hơn hẳn nhưng không có tháp pháo và chỉ có hai ô vũ khí phụ.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/10": [
		[0, "", "[[ship/10]] là con tàu riêng của [[character/0]] trong cảnh mở đầu, được trang bị hai laser [[item/3]]. Nó kết hợp giáp chắc chắn (200) và khoang hàng 100 t với bốn ô vũ khí phụ và độ linh hoạt 150, khiến nó nhanh nhẹn hơn hẳn [[ship/11]], thân tàu có giá niêm yết gần nhất. Điểm yếu của nó là ít ô trang bị: chỉ năm ô. Người bán thông thường không bao giờ rao bán nó.", false],
		[2, "", "Một sự cố động cơ siêu không gian đưa [[character/0]] đến [[station/78]], nơi [[character/2]] trục vớt xác tàu và tháo lấy linh kiện. Nó không bao giờ trở về tay anh.", false],
	],
	"ship/11": [
		[0, "", "[[ship/11]] là một tàu chở hàng hạng nặng được trang bị tốt: khoang hàng 180 t, 210 giáp, ô tháp pháo, hai ô vũ khí chính và hai ô vũ khí phụ và tám ô trang bị. Độ linh hoạt 75 của nó kém. So với [[ship/7]] rẻ hơn, nó hy sinh 60 t sức chứa hàng để có thêm một ô vũ khí phụ và một ô trang bị.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/12": [
		[0, "", "[[ship/12]] là một chiến đấu cơ được xây dựng xoay quanh vũ khí phụ: ba ô vũ khí phụ, hai súng chính, sáu ô trang bị, 175 giáp và độ linh hoạt 132. Khoang hàng 30 t của nó rất nhỏ, nên không phù hợp lắm cho buôn bán hay khai thác. [[ship/30]] đắt hơn mà lại ít giáp hơn và ít hơn một ô vũ khí phụ.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/16": [
		[0, "", "[[ship/16]] là một chiến đấu cơ thiên về tên lửa với bốn ô vũ khí phụ, hai súng chính, mười ô trang bị, 180 giáp và độ linh hoạt 120. Khoang hàng 45 t của nó nhỏ. [[ship/21]] đắt hơn có thêm hai súng chính và một ô trang bị.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/17": [
		[0, "", "[[ship/17]] mang bốn súng chính, hai ô vũ khí phụ và mười ô trang bị. Đối với một con tàu ở mức giá này, giáp (145), khoang hàng (65 t) và độ linh hoạt (95) đều yếu, nên nó dựa vào trang bị, đặc biệt là khiên và giáp bọc. [[ship/19]] rẻ hơn có nhiều giáp và sức chứa hàng hơn nhưng ít hơn một ô trang bị.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/18": [
		[0, "", "[[ship/18]] là một con tàu nhỏ, nhanh nhẹn (độ linh hoạt 145) với tám ô trang bị; không thân tàu nào rẻ hơn có nhiều ô như vậy. Giáp 115 và khoang hàng 28 t của nó kém, và nó chỉ có hai ô vũ khí chính và hai ô vũ khí phụ. Nó phù hợp với phi công dựa vào khiên, thiết bị tàng hình và trang bị khác hơn là giáp.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/19": [
		[0, "", "[[ship/19]] là một pháo hạm hạng nặng với bốn ô vũ khí chính, hai ô vũ khí phụ, chín ô trang bị, 225 giáp và khoang hàng 105 t. Độ linh hoạt 90 là chậm. Đây là con tàu duy nhất có bốn súng bắn thẳng và khoang hàng trên 100 t.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/2": [
		[0, "", "[[ship/2]] là một tàu đa năng nhanh nhẹn trong số các thân tàu giá rẻ: 155 giáp, khoang hàng 52 t, một ô vũ khí chính và hai ô vũ khí phụ, bốn ô trang bị và độ linh hoạt 150. Nó ngang bằng [[ship/35]] ở mọi mặt trừ sức chứa hàng, nơi nó chở được nhiều hơn 12 t. Phi công muốn có khẩu súng thứ hai sẽ xem xét [[ship/5]] hoặc [[ship/6]] thay vào đó.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/20": [
		[0, "", "[[ship/20]] là một chiến đấu cơ hạng nhẹ gói sáu ô trang bị vào một thân tàu nhỏ, nhanh (độ linh hoạt 155). Nó mang hai súng chính nhưng chỉ một ô vũ khí phụ, 125 giáp và khoang hàng 25 t, ngang với [[ship/0]] là nhỏ nhất trong bảng. Nó phù hợp với phi công muốn có khiên, bộ tăng tốc và trang bị khác sớm và không định chở hàng.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/21": [
		[0, "", "[[ship/21]] là thân tàu rẻ nhất có bốn ô vũ khí chính và bốn ô vũ khí phụ. Nó còn có mười một ô trang bị, 195 giáp và khoang hàng 70 t. Độ linh hoạt 100 ở mức trung bình. Đây là một tàu chiến đấu hoàn chỉnh chỉ kém [[ship/29]] một bậc.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/22": [
		[0, "", "[[ship/22]] có khoang hàng lớn nhất trong các tàu giá trên một triệu credit (130 t), cùng với ba ô vũ khí chính và ba ô vũ khí phụ, chín ô trang bị và độ linh hoạt 118. Giáp 160 là thấp so với giá. Nó phù hợp với phi công vừa buôn bán vừa chiến đấu trên cùng một con tàu.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/23": [
		[0, "", "[[ship/23]] là thân tàu rẻ nhất có ô tháp pháo, và giáp 205 của nó cao nhất trong các tàu dưới 100.000 credit. Nó có thêm hai ô vũ khí chính và hai ô vũ khí phụ, năm ô trang bị, khoang hàng 55 t và độ linh hoạt 128, khiến nó trở thành một tàu đa năng tầm trung chắc chắn. Hạn chế chính là ít ô trang bị.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/24": [
		[0, "", "[[ship/24]] là một tàu buôn có vũ trang: ba súng chính, hai ô vũ khí phụ, một tháp pháo, tám ô trang bị và khoang hàng 95 t. Giáp 170 ở mức trung bình, trong khi độ linh hoạt 125 là tốt đối với một con tàu chở nhiều như vậy. Nó đáp ứng tốt như nhau cho buôn bán, khai thác và chiến đấu.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/25": [
		[0, "", "[[ship/25]] là một tàu mang tên lửa: bốn ô vũ khí phụ, tám ô trang bị và độ linh hoạt 130, nhưng chỉ một súng chính. Giáp 124 và khoang hàng 52 t là yếu so với giá, nên nó phụ thuộc vào ngư lôi và khiên. [[ship/1]] có cùng số ô vũ khí phụ cộng thêm tháp pháo với giá chỉ bằng một phần ba, nhưng ít ô trang bị hơn.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/26": [
		[0, "", "[[ship/26]] là thân tàu rẻ nhất có bảy ô trang bị. Ngoài ra nó là một tàu đa năng trung bình: 152 giáp, khoang hàng 64 t, hai ô vũ khí chính và hai ô vũ khí phụ và độ linh hoạt 108. Nó phù hợp với phi công muốn có đầy đủ trang bị trước khi đủ tiền mua một con tàu nặng hơn.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/27": [
		[0, "", "[[ship/27]] là thân tàu rẻ nhất có ba ô vũ khí chính. Nó kết hợp chúng với 176 giáp, hai ô vũ khí phụ, sáu ô trang bị và khoang hàng 50 t. Độ linh hoạt 113 thuộc loại chậm, nên nó đối đầu trực diện hơn là xoay vượt kẻ thù.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/28": [
		[0, "", "[[ship/28]] là tàu đa năng hoàn thiện nhất được bán: ba ô vũ khí chính và bốn ô vũ khí phụ, một tháp pháo, mười hai ô trang bị và khoang hàng 110 t. Không có con tàu nào khác có thể mua mà vừa có tháp pháo vừa có nhiều ô trang bị như vậy. Giáp 195 là tốt và độ linh hoạt 92 là chậm. [[ship/29]] chiến đấu tốt hơn nhưng chở ít hơn nhiều.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/29": [
		[0, "", "[[ship/29]] là con tàu đắt nhất mà người bán thông thường rao bán và là chiến đấu cơ tốt nhất của họ: bốn ô vũ khí chính và bốn ô vũ khí phụ, mười hai ô trang bị, 240 giáp và độ linh hoạt 118. Khoang hàng 75 t ở mức khiêm tốn, và nó không có tháp pháo. Chỉ [[ship/8]] vượt trội hơn nó trong chiến đấu.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/3": [
		[0, "", "[[ship/3]] là một tàu đa năng cân bằng cho giai đoạn đầu: hai ô vũ khí chính và hai ô vũ khí phụ, năm ô trang bị, 135 giáp và khoang hàng 55 t. Độ linh hoạt 112 là chậm đối với một con tàu nhỏ. Nó có giá gần bằng [[ship/6]], loại xoay nhanh hơn nhiều nhưng ít giáp hơn, sức chứa hàng nhỏ hơn và ít hơn một ô vũ khí phụ.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/30": [
		[0, "", "[[ship/30]] là một chiến đấu cơ tầm trung: 165 giáp, khoang hàng 45 t, hai ô vũ khí chính và hai ô vũ khí phụ, sáu ô trang bị và độ linh hoạt 128. Nó không có thế mạnh đặc biệt nào so với giá; [[ship/12]] rẻ hơn lại có nhiều giáp hơn và thêm một ô vũ khí phụ, còn [[ship/23]] có thêm tháp pháo.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/31": [
		[0, "", "[[ship/31]] là một tàu chở hàng hạng nhẹ với khoang hàng 110 t, ô tháp pháo, hai súng chính và sáu ô trang bị. Giáp (156), một ô vũ khí phụ duy nhất và độ linh hoạt 102 của nó ở mức khiêm tốn. Nó cạnh tranh với [[ship/33]] rẻ hơn, loại có sức chứa hàng ít hơn một chút và ít hơn một súng nhưng nhiều giáp hơn và điều khiển tốt hơn.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/32": [
		[0, "", "[[ship/32]] là thân tàu rẻ nhất mà người bán nào cũng có và thường là món mua đầu tiên. Nó nhỏ và được bảo vệ mỏng (100 giáp, khoang hàng 30 t, một ô vũ khí chính, một ô vũ khí phụ, ba ô trang bị), nhưng với độ linh hoạt 160, chỉ [[ship/4]] xoay nhanh hơn. So với [[ship/0]], nó có thêm chút giáp và sức chứa hàng và điều khiển tốt hơn. [[ship/35]] đắt hơn khoảng 8.000 credit và có giáp tốt hơn nhiều, ô vũ khí phụ thứ hai và ô trang bị thứ tư.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/33": [
		[0, "", "[[ship/33]] là thân tàu rẻ nhất có sức chứa hàng trên 100 t (108 t), và có thêm ô tháp pháo, 176 giáp và sáu ô trang bị. Chỉ với một súng chính và độ linh hoạt 112, nó là tàu buôn có thể tự vệ hơn là chiến đấu cơ. [[ship/31]] là đối thủ sát nút với khẩu súng thứ hai và khoang hàng lớn hơn một chút, nhưng yếu hơn và chậm hơn.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/34": [
		[0, "", "[[ship/34]] là một pháo hạm với bốn ô vũ khí chính, một ô vũ khí phụ, sáu ô trang bị, khoang hàng 60 t và độ linh hoạt 130. So với [[ship/4]] rẻ hơn, nó hy sinh giáp (135 so với 170) và độ nhanh nhẹn để có thêm sức chứa hàng và một ô trang bị.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/35": [
		[0, "", "[[ship/35]] là một chiến đấu cơ hạng nhẹ ở cuối bảng giá. Với số tiền bỏ ra, nó có giáp tốt (155), một ô vũ khí chính và hai ô vũ khí phụ, bốn ô trang bị và độ linh hoạt nhanh 150, nhưng khoang hàng chỉ 40 t. [[ship/2]] gần như là cùng một con tàu với thêm 12 t sức chứa hàng và đắt hơn vài nghìn credit, trong khi [[ship/5]] đánh đổi độ nhanh nhẹn để có thêm giáp, sức chứa hàng và khẩu súng thứ hai.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/36": [
		[0, "", "[[ship/36]] là tàu chở hàng lớn nhất trong trò chơi, với khoang hàng 350 t. Nó hoàn toàn không có ô vũ khí chính và phải dựa vào bốn ô vũ khí phụ cùng một tháp pháo để tự vệ. Bảy ô trang bị và 200 giáp là tốt, nhưng độ linh hoạt 45 là thấp nhất trong bảng. [[ship/7]] chở ít hơn nhưng vẫn có hai súng bắn thẳng và xoay tốt hơn.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/4": [
		[0, "", "[[ship/4]] là thân tàu rẻ nhất có bốn ô vũ khí chính, và với độ linh hoạt 162, đây là con tàu nhanh nhẹn nhất trong trò chơi. Giáp 170 là tốt so với giá. Cái giá phải trả là khoang hàng 38 t, chỉ một ô vũ khí phụ và năm ô trang bị, nên nó thuần túy là tàu không chiến. [[ship/34]] cũng mang bốn súng, với sức chứa hàng và ô trang bị nhiều hơn nhưng giáp và độ nhanh nhẹn kém hơn.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/5": [
		[0, "", "[[ship/5]] là thân tàu rẻ nhất có hai ô vũ khí chính, và 170 giáp là cao so với giá của nó. Khoang hàng 60 t cũng khiến nó hữu ích cho buôn bán và khai thác giai đoạn đầu. Nhược điểm là chỉ có một ô vũ khí phụ, bốn ô trang bị và độ linh hoạt chậm chạp 115. Phi công coi trọng sự nhanh nhẹn hơn giáp sẽ chọn [[ship/2]] hoặc [[ship/35]] với giá tương tự.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/6": [
		[0, "", "[[ship/6]] là một chiến đấu cơ nhẹ và nhanh với hai ô vũ khí chính, một ô vũ khí phụ, năm ô trang bị và độ linh hoạt 148. Giáp 105 của nó rất mỏng; chỉ [[ship/0]] và [[ship/32]] có ít hơn, nên nó dựa vào tốc độ hơn là độ bền. Với giá gần như tương đương, [[ship/3]] có nhiều giáp hơn, sức chứa hàng lớn hơn và ô vũ khí phụ thứ hai, đổi lại độ linh hoạt kém hơn.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/7": [
		[0, "", "[[ship/7]] là một tàu chở hàng hạng nặng với khoang hàng 240 t, 220 giáp, ô tháp pháo, hai súng chính, một ô vũ khí phụ và bảy ô trang bị. Với độ linh hoạt 65, nó xoay chậm. So với [[ship/36]], nó hy sinh 110 t sức chứa hàng để có súng bắn thẳng và điều khiển tốt hơn; [[ship/11]] đắt hơn có thêm một ô trang bị và ô vũ khí phụ thứ hai.", false],
		[0, "", "Bất kỳ người bán nào bên ngoài các hệ sao [[faction/1|Vossk]] đều có thể có nó.", false],
	],
	"ship/8": [
		[0, "", "[[ship/8]] là một chiến đấu cơ [[faction/9|Void]] được phục hồi và là con tàu mạnh nhất trong trò chơi. Giáp 450 của nó gần gấp đôi bất kỳ thân tàu nào khác, nó có bốn ô vũ khí chính và bốn ô vũ khí phụ cùng mười lăm ô trang bị, và độ linh hoạt 155 thuộc hàng tốt nhất. Điểm yếu duy nhất là khoang hàng 30 t. Giá niêm yết hơn tám triệu credit của nó gần gấp đôi [[ship/29]].", false],
		[0, "", "Người bán thông thường không bán nó. Nó chỉ được chào bán tại [[station/10]], dưới dạng nguyên mẫu, khi người chơi có mọi huy chương ở hạng vàng (xem [[guide/medals]]).", false],
	],
	"ship/9": [
		[0, "", "[[ship/9]] là con tàu duy nhất người bán [[faction/1|Vossk]] rao bán, và họ không bán gì khác. Giáp 250 của nó cao nhất trong mọi thân tàu, trừ [[ship/8]], và nó kết hợp điều này với độ linh hoạt nhanh 152, hai ô vũ khí chính và hai ô vũ khí phụ, bảy ô trang bị và khoang hàng 65 t. Ở mức giá của mình, đây là chiến đấu cơ bền bỉ nhất có thể mua, dù thiếu tháp pháo và các ô gắn bổ sung của [[ship/1]].", false],
		[36, "", "[[character/7]] giải thích rằng tàu [[faction/1|Vossk]] thường chỉ do chính chủng tộc của họ lái; con tàu này là ngoại lệ, một thiết kế đã được điều chỉnh để có thể bán cho các chủng tộc khác.", false],
	],
	"station/0": [
		[0, "", "[[station/0]] có cổng nhảy của [[system/0]]. Giai đoạn chờ đợi của [[step/13]] được xếp vào trạm này, nhưng bước đó được hoàn thành bằng cách làm xong công việc ở phòng chờ tại bất kỳ đâu, và không có gì xảy ra ở đây.", false],
	],
	"station/10": [
		[0, "", "[[station/10]] là trạm duy nhất của [[system/6]] và có cổng nhảy của hệ sao. Công việc tự do không bao giờ đưa bạn đến đây. Đặc vụ [[agent/3]] bán một bản thiết kế trong phòng chờ, và khi mọi huy chương đều là vàng, trạm sẽ bán một nguyên mẫu [[ship/8]].", false],
		[23, "", "Trạm là căn cứ nghiên cứu bí mật của Deep Science, do [[character/6]] đứng đầu. [[character/0]] đến đây cùng [[character/5]] trong [[step/23]] và quay lại nhiều lần: để lên kế hoạch thám hiểm đến chỗ Void, để gặp [[character/20]] và để giao tinh thể.", false],
	],
	"station/18": [
		[0, "", "[[station/18]] là một trạm Vossk khiêm tốn trong [[system/3]]. Đặc vụ [[agent/12]] bán tọa độ của [[system/0]] trong phòng chờ của trạm.", false],
	],
	"station/20": [
		[0, "", "[[station/20]] có cổng nhảy của [[system/4]]. Đặc vụ Midorian [[agent/2]] bán một bản thiết kế vũ khí trong phòng chờ của trạm.", false],
	],
	"station/22": [
		[0, "", "[[station/22]] là trạm tiên tiến nhất trong [[system/4]].", false],
		[38, "", "Trong [[step/38]], đoàn tàu chở thuốc nổ Nivelian bị phát hiện gần trạm dưới sự hộ tống của các chiến đấu cơ Midorian. [[character/0]] phải đánh đuổi tàu hộ tống mà không phá hủy đoàn tàu.", false],
	],
	"station/26": [
		[0, "", "[[station/26]] là một trạm Vossk công nghệ hàng đầu trong [[system/5]]. Đặc vụ Bobolian [[agent/13]] bán tọa độ của [[system/1]] trong phòng chờ của trạm.", false],
	],
	"station/27": [
		[36, "", "Gần [[station/27]], [[character/7]] và [[character/0]] đột kích một sào huyệt hải tặc trong [[step/36]]; ai tiêu diệt được nhiều hải tặc hơn sẽ thắng.", false],
		[37, "", "[[character/0]] thắng và giành quyền hộ tống tàu chở hàng Vossk. Từ đây anh báo cáo lại với [[character/1]].", false],
	],
	"station/29": [
		[35, "", "[[station/29]] là trạm của chỉ huy Vossk [[character/7]], người đã đồng ý cung cấp một tàu chở hàng K'Sarr cho cuộc tấn công Void. [[character/0]] gặp ông tại đây trong [[step/35]].", false],
		[36, "", "[[character/7]] không cho phép ai ngoài người Vossk lái tàu chở hàng và thách [[character/0]] chứng tỏ bản thân với tư cách phi công hộ tống.", false],
	],
	"station/3": [
		[0, "", "[[station/3]] là một trạm Nivelian công nghệ cao trong hệ sao ẩn [[system/0]]. Phòng chờ của trạm là nơi đặc vụ [[agent/0]] ngồi, người bán một bản thiết kế vũ khí.", false],
	],
	"station/30": [
		[34, "", "[[character/1]] chờ tại [[station/30]] trong [[step/34]] với một kế hoạch chống lại tàu mẹ Void.", false],
		[35, "", "Kế hoạch là lái một tàu chở hàng hạng nặng chất đầy thuốc nổ hạt nhân Nivelian lao vào tàu mẹ.", false],
		[39, "", "Số thuốc nổ giành lại được đưa đến đây và chất lên tàu chở hàng Vossk. Trong [[step/39]], [[character/1]] giải thích chiến dịch cuối cùng.", false],
	],
	"station/43": [
		[0, "", "[[station/43]] là một trạm Terran nhỏ trong [[system/8]]. Đặc vụ [[agent/4]] bán một bản thiết kế rocket giá rẻ trong phòng chờ của trạm.", false],
	],
	"station/48": [
		[24, "", "Người ta đã trông thấy tàu Void gần [[station/48]]. Trong [[step/24]], [[character/0]] đưa [[character/6]] đến đây để quan sát chúng và thu gom xác tàu bằng chùm tia kéo.", false],
		[25, "", "Cuối đợt trục vớt, một lỗ sâu nuốt chửng con tàu của [[character/0]] cùng [[character/6]] trên tàu.", false],
		[27, "", "Khi họ trở về qua một lỗ sâu khác, chiến đấu cơ Void bám theo, và [[character/0]] phải tiêu diệt chúng tại đây trước khi quay về [[station/10]].", false],
	],
	"station/54": [
		[0, "", "[[station/54]] là một trạm Vossk công nghệ hàng đầu trong [[system/10]], một hệ sao chỉ có thể đến bằng động cơ nhảy. Đặc vụ Vossk [[agent/5]] bán một bản thiết kế tên lửa trong phòng chờ của trạm.", false],
	],
	"station/55": [
		[0, "", "[[station/55]] có cổng nhảy của [[system/11]].", false],
		[19, "", "Bọn hải tặc giữ [[character/5]] để đòi tiền chuộc được tìm thấy gần trạm. Deep Science để sẵn bom EMP trong hangar của trạm cho [[character/0]].", false],
		[22, "", "Sau cuộc giải cứu, [[character/0]] gặp viên sĩ quan được giải thoát tại trạm và nhận tọa độ của [[system/6]].", false],
	],
	"station/56": [
		[18, "", "[[station/56]] là điểm hẹn nơi [[character/0]] lẽ ra sẽ đón một sĩ quan của Deep Science trong [[step/18]].", false],
		[19, "", "Viên sĩ quan không hề đến. Thay vào đó, một tin nhắn từ [[character/1]] báo rằng hải tặc đã bắt cóc anh ta.", false],
	],
	"station/59": [
		[0, "", "[[station/59]] là một trạm nhỏ trong hệ sao Vossk [[system/20]]. Phòng chờ của trạm có một người Terran, đặc vụ [[agent/10]], người bán bản thiết kế thiết bị tàng hình.", false],
	],
	"station/61": [
		[0, "", "[[station/61]] là một trong hai trạm duy nhất của [[system/12]]. Đặc vụ Multipod [[agent/6]] bán một bản thiết kế vũ khí hạt nhân trong phòng chờ của trạm.", false],
	],
	"station/65": [
		[0, "", "[[station/65]] có cổng nhảy của [[system/13]]. Đặc vụ Cyborg [[agent/14]] bán tọa độ của [[system/10]] trong phòng chờ của trạm.", false],
	],
	"station/72": [
		[0, "", "[[station/72]] là một trạm Terran nhỏ trong hệ sao an toàn [[system/14]]. Đặc vụ [[agent/7]] bán một bản thiết kế khiên trong phòng chờ của trạm.", false],
	],
	"station/76": [
		[11, "", "[[station/76]] là một trạm trong [[system/15]] đã ngừng trả lời liên lạc. Trong [[step/11]], [[character/3]] cử [[character/0]] đi tìm hiểu nguyên nhân.", false],
		[12, "", "Trạm không hề hấn gì. Thủy thủ đoàn chỉ đơn giản là không còn sức làm việc, nhờ một lô tảo thần kinh do tay buôn [[character/4]], người quen cũ của [[character/0]], mang đến.", false],
	],
	"station/78": [
		[0, "", "[[station/78]] là trạm khai thác nhỏ của thương nhân quặng người Nivelian [[character/2]] trong [[system/15]]. Cốt truyện bắt đầu trên quỹ đạo của trạm.", false],
		[1, "", "Con tàu hư hỏng của [[character/0]] trôi dạt đến đây nhờ lái tự động, và [[character/2]] thu nhận nó, cả tàu lẫn phi công.", false],
		[2, "", "[[character/2]] tháo dỡ xác tàu và bắt [[character/0]] khai thác quặng ở các tiểu hành tinh gần đó bằng [[ship/0]].", false],
		[8, "", "Sau khi thoát khỏi một cuộc đột kích của hải tặc, [[character/0]] lắp vũ khí đầu tiên và giúp [[character/2]] tiêu diệt sào huyệt hải tặc gần trạm.", false],
		[10, "", "[[character/2]] sau đó tặng anh con tàu và gửi anh đến [[station/79]].", false],
		[0, "", "Về sau trong trò chơi, [[character/2]] bán bản thiết kế mũi khoan khai thác của mình trong phòng chờ của trạm.", false],
	],
	"station/79": [
		[0, "", "[[station/79]] là một trạm trong [[system/15]] và là nơi đóng quân của chỉ huy hệ sao, [[character/3]].", false],
		[10, "", "[[character/2]] cử [[character/0]] đến đây trong [[step/9]] để gặp [[character/3]], một người thuộc loài người có thể giúp anh trở về vùng không gian Terran.", false],
		[11, "", "[[character/3]] giải thích về [[faction/3|Liên minh Mido]] và nhờ anh kiểm tra [[station/76]] để đổi lấy sự giúp đỡ.", false],
		[13, "", "Sau báo cáo từ [[station/76]], [[character/3]] hứa sẽ giúp anh liên lạc với một đoàn tàu Terran sắp đến trạm.", false],
		[15, "", "Khi đoàn tàu đến trong [[step/14]], họ nhầm [[character/0]] là hải tặc, vô hiệu hóa tàu của anh và đưa anh lên tàu.", false],
	],
	"station/8": [
		[0, "", "[[station/8]] là một trạm Terran trong hệ sao ẩn [[system/1]]. Đặc vụ Nivelian [[agent/1]] bán một bản thiết kế trong phòng chờ của trạm.", false],
	],
	"station/84": [
		[0, "", "[[station/84]] là một trạm Terran trong [[system/16]]. Đặc vụ Vossk [[agent/8]] bán bản thiết kế giáp Vossk trong phòng chờ của trạm.", false],
	],
	"station/88": [
		[0, "", "[[station/88]] là một trạm Nivelian nhỏ trong [[system/17]]. Đặc vụ Vossk [[agent/15]] bán tọa độ của [[system/21]] trong phòng chờ của trạm.", false],
	],
	"station/90": [
		[0, "", "[[station/90]] có cổng nhảy của [[system/18]]. Đặc vụ [[agent/9]] bán bản thiết kế máy nén hàng hóa trong phòng chờ của trạm.", false],
	],
	"station/91": [
		[28, "", "Có tin báo về hoạt động của Void gần [[station/91]] trong [[step/28]]. [[character/0]] chiến đấu mở đường đến một lỗ sâu ở đây để mang tàu thăm dò đến tàu mẹ Void.", false],
		[31, "", "Trở về từ khu vực Void, [[character/0]] nhận cuộc gọi từ [[character/1]] tại đây, mời anh đến [[station/98]].", false],
	],
	"station/98": [
		[15, "", "[[station/98]] là một trạm Terran trong [[system/19]]. Tuần dương hạm đã bắt giữ [[character/0]] đưa anh đến đây, và anh thấy người bạn cũ [[character/1]] đang phụ trách.", false],
		[16, "", "Chiến đấu cơ Void tấn công trạm trong lúc họ trò chuyện, và [[character/0]] giúp đánh đuổi chúng.", false],
		[18, "", "[[character/1]] kể cho anh về Void và tuyển anh cho Deep Science.", false],
		[32, "", "Trong [[step/31]], [[character/1]] lắp hệ thống cảnh báo sớm lên tàu của [[character/0]] và kể cho anh về [[character/20]].", false],
		[44, "", "Sau chiến thắng, [[character/0]] và [[character/1]] ăn mừng tại trạm, và [[character/6]] đến cùng họ.", false],
		[45, "", "Sáng hôm sau [[character/6]] đã đi, để lại một mẩu giấy và khoản thanh toán cuối cùng từ Deep Science.", false],
	],
	"step/0": [
		[0, "", "[[character/0]] truy đuổi một băng [[faction/8|hải tặc]] qua vành đai tiểu hành tinh để lĩnh tiền thưởng cho cái đầu của chúng. Bạn phải tìm và tiêu diệt mọi tàu hải tặc.", false],
		[1, "", "Xử lý xong bọn hải tặc, Keith đặt hướng đến Eden Prime, nơi Đô đốc Smith muốn gặp anh về một nhiệm vụ đặc biệt. Khi động cơ siêu không gian khởi động, một phát bắn cuối cùng làm hư hại con tàu. Động cơ hỏng, hệ thống duy trì sự sống bị tê liệt, và chế độ lái tự động đưa viên phi công bất tỉnh về phía trạm gần nhất, [[station/78]].", false],
	],
	"step/1": [
		[1, "", "Chế độ lái tự động đã đưa con tàu hư hỏng của Keith vào quỹ đạo quanh [[station/78]], với viên phi công bất tỉnh trên tàu.", false],
		[2, "", "Keith tỉnh dậy trên một trạm khai thác nhỏ do [[character/2]], một thương nhân quặng người [[faction/2]], điều hành. Gunant đã tháo rời con tàu và đòi quyền sở hữu nó theo luật trục vớt. Ông ta cười nhạo ý định đến Eden Prime, vốn nằm ở tận cùng bên kia thiên hà, và ngạc nhiên khi Keith chưa từng nghe nói về Void, những sinh vật thù địch nay xuất hiện ngay cả ở hệ sao [[system/15]].", false],
		[2, "", "Keith không có tiền cũng chẳng có tàu, nên phải làm việc cho Gunant bằng cách khai thác quặng trên một con tàu không vũ trang.", false],
	],
	"step/10": [
		[10, "", "Keith bay đến [[station/79]] để gặp [[character/3]].", false],
		[11, "", "Norris giải thích rằng [[system/15]] nằm trong một khu vực mới được phát hiện. Những người Terran và Nivelian lưu vong đã định cư ở đây trong cuộc Nội chiến Nivelian và lập nên một liên minh độc lập. Người Terran chấp nhận điều đó, nhưng người Nivelian vẫn đòi chủ quyền hệ sao, nên ở vùng rìa vẫn có giao tranh.", false],
		[11, "", "Norris đề nghị giúp Keith liên lạc với Hạm đội Không gian Terran để đổi lấy một việc: liên lạc với trạm [[station/76]] đã bị mất, và cần một phi công dày dạn kinh nghiệm tìm hiểu nguyên nhân.", false],
	],
	"step/11": [
		[11, "", "Keith bay đến [[station/76]] để điều tra sự im lặng của trạm. Trạm trông vẫn nguyên vẹn, không có dấu hiệu giao tranh, nên anh cập cảng.", false],
		[12, "", "Bên trong, Keith chạm trán [[character/4]], một tay buôn khét tiếng mà anh quen từ lâu. Mkkt đã mang đến một lô tảo thần kinh, và toàn bộ thủy thủ đoàn say thuốc đến mức không thể vận hành hệ thống liên lạc. Keith rời đi ngay khi có thể.", false],
	],
	"step/12": [
		[12, "", "Keith quay về [[station/79]] để báo cáo.", false],
		[13, "", "Norris kinh hoàng và hứa sẽ xử lý tay buôn. Một đoàn tàu quân sự Terran đang hướng đến Kernstal và sẽ cho Keith cơ hội liên lạc với hạm đội. Trong lúc chờ đoàn tàu, Norris gợi ý Keith nhận việc có trả tiền trong Phòng chờ (xem [[guide/lounge]]).", false],
	],
	"step/13": [
		[13, "", "Trong lúc chờ đoàn tàu, Keith phải hoàn thành hai công việc tự do từ Phòng chờ (xem [[guide/jobs]]).", false],
		[14, "", "Norris báo tin đoàn tàu Terran đã vào hệ sao và đang hướng về [[station/79]]. Keith lên đường đón nó.", false],
	],
	"step/14": [
		[14, "", "Gần [[station/79]], Keith thấy đoàn tàu Terran và vài tên hải tặc. Anh lao vào để đánh đuổi bọn hải tặc.", false],
		[15, "", "Vì đi con tàu vốn là tàu hải tặc, Keith bị nhầm là một trong những kẻ đột kích. Đoàn tàu vô hiệu hóa tàu của anh bằng vũ khí EMP và bắt giữ anh. Anh bị đưa lên một tuần dương hạm Terran hướng đến [[station/98]] trong vùng không gian Terran.", false],
	],
	"step/15": [
		[15, "", "Keith đến [[station/98]] với tư cách tù nhân của đoàn tàu.", false],
		[16, "", "Sĩ quan phụ trách là [[character/1]], một người bạn cũ của Keith, nay là giám đốc Cơ quan An ninh Liên sao. Anh xin lỗi vì sự nhầm lẫn. Cuộc hội ngộ bị cắt ngang khi chiến đấu cơ Void xuất hiện trên quỹ đạo và trạm phát báo động.", false],
	],
	"step/16": [
		[16, "", "Brent nhờ Keith giúp đánh đuổi các tàu [[faction/9|Void]] đang tấn công [[station/98]] (xem [[world/voids]]).", false],
		[17, "", "Void phát đi một thông điệp khẳng định ý định hòa bình, nhưng vẫn tấn công như thường. Keith đẩy lùi chúng, và Brent hứa sẽ kể cho anh mọi điều mình biết bên một ly rượu vang.", false],
	],
	"step/17": [
		[17, "", "Keith cập cảng tại [[station/98]] để nghe Brent kể những gì anh biết về Void.", false],
		[18, "", "Void đã xuất hiện trong vài tuần qua. Chúng đến qua một dạng lỗ sâu nào đó, tấn công bất cứ thứ gì gặp phải và dường như đang tìm quặng; ngay cả các hệ sao [[faction/1]] cũng bị đột kích. Brent chủ trì một nhóm xử lý khủng hoảng, và các nhà khoa học của nhóm đang tập hợp tại một trạm nghiên cứu bí mật do Deep Science điều hành. Anh đề nghị Keith bay cho họ.", false],
		[18, "", "Hệ sao của trạm không có trên các bản đồ sao thông thường, nên Keith phải gặp Trung úy Thomas Boyle ([[character/5]]) tại [[station/56]] trong hệ sao [[system/11]] để lấy tọa độ. Brent cũng thừa nhận rằng tàu của Keith không phải tàu mới: nó chỉ được sơn lại để tránh nhầm lẫn thêm.", false],
	],
	"step/18": [
		[18, "", "Keith bay đến [[station/56]] để gặp Boyle.", false],
		[19, "", "Boyle không hề đến. Brent báo tin hải tặc đã bắt cóc anh ta gần [[station/55]] và đòi tiền chuộc năm triệu credit. Brent sẵn sàng trả, nhưng Keith đoán rằng bọn bắt cóc sẽ giết Boyle khi nhận được tiền, nên anh hướng đến Kappa.", false],
	],
	"step/19": [
		[19, "", "Keith bay đến [[station/55]] để tìm bọn bắt cóc.", false],
		[20, "", "Máy quét của Kappa định vị được tàu của bọn bắt cóc. Brent đã cho để sẵn bom EMP trong hangar của trạm, để Keith có thể vô hiệu hóa con tàu trong khi bọn bắt cóc tưởng anh đang mang tiền chuộc đến.", false],
	],
	"step/2": [
		[2, "", "Gunant giao cho Keith một con tàu cũ đã sửa chữa nhiều lần, [[ship/0]], vốn là tàu hải tặc, được lắp tia laser khai thác và không có vũ khí. Keith phải khai thác ít nhất mười tấn quặng từ các tiểu hành tinh gần [[station/78]] (xem [[guide/mining]]).", false],
		[3, "", "Khi quặng đã lên tàu, Gunant bảo anh cập cảng để kiểm tra hàng. Không có vũ khí, Keith đành phải chiều theo.", false],
	],
	"step/20": [
		[20, "", "Keith phải cập cảng tại [[station/55]] và lắp bom EMP lên tàu.", false],
		[21, "", "Lắp xong bom, Keith lập tức lên đường.", false],
	],
	"step/21": [
		[21, "", "Một điểm mốc đánh dấu tàu của bọn bắt cóc, có thể nó không đi một mình. Keith phải vô hiệu hóa nó bằng bom EMP thay vì phá hủy, và xử lý mọi tàu hộ tống.", false],
		[22, "", "Bọn bắt cóc tưởng tiền chuộc đã đến cho tới khi quả bom làm tê liệt các hệ thống của chúng. Brent cử một đội đến giải cứu Boyle.", false],
	],
	"step/22": [
		[22, "", "Keith cập cảng tại [[station/55]] để gặp nhà khoa học vừa được giải cứu.", false],
		[23, "", "Boyle cảm ơn anh. Tàu của Boyle đã mất, nên Keith đề nghị cho đi nhờ, và Boyle chuyển tọa độ của hệ sao [[system/6]], nơi có trạm nghiên cứu, vào máy tính dẫn đường của Keith.", false],
	],
	"step/23": [
		[23, "", "Keith đưa Boyle đến [[station/10]] trong hệ sao [[system/6]], nơi Tiến sĩ Paolini đang chờ họ.", false],
		[24, "", "Keith gặp Tiến sĩ Carla Paolini ([[character/6]]), người đứng đầu dự án của Deep Science. Cô muốn tìm hiểu công nghệ của Void, bắt đầu từ xác các tàu Void. Deep Science trả cho Keith 20.000 credit để trang bị cho tàu, và một chùm tia kéo là thứ không thể thiếu.", false],
		[24, "", "Carla nhất quyết bay cùng anh đến [[station/48]] trong hệ sao [[system/9]], nơi gần đây có người trông thấy Void. Keith phản đối, nhưng rồi cũng chịu thua.", false],
	],
	"step/24": [
		[24, "", "Tại [[station/48]], Carla muốn quan sát Void ở cự ly gần nhất có thể. Void tuyên bố rằng chúng đến từ tương lai và là tất cả những gì còn lại của các nền văn minh trong thiên hà. Keith phải chiến đấu với chúng và thu gom xác tàu của chúng bằng chùm tia kéo.", false],
		[25, "", "Khi đã thu đủ xác tàu, Carla đề nghị quay về, nhưng đột nhiên có thứ gì đó tóm lấy con tàu.", false],
	],
	"step/25": [
		[25, "", "Keith và Carla tỉnh lại ở rất xa [[station/48]], trong một vùng không gian mà cả hai đều không biết.", false],
		[26, "", "Một con tàu mẹ Void khổng lồ nằm gần đó, đang phóng ra các chiến đấu cơ. Keith kết luận rằng họ đã đi qua một lỗ sâu vào khu vực quê nhà của Void. Lỗ sâu đó đã biến mất, nhưng những lối mở như vậy dường như sụp đổ rồi xuất hiện lại ở nơi khác, nên anh phải tìm đến một lỗ sâu khác để về nhà.", false],
	],
	"step/26": [
		[26, "", "Lỗ sâu đưa họ trở lại [[station/48]], nhưng chiến đấu cơ Void đã bám theo. Keith phải tiêu diệt chúng để chúng không thể lần theo con tàu đến [[station/10]].", false],
		[27, "", "Cắt đuôi được kẻ truy đuổi, hai người quay về Thynome, cả hai đều rất cần nghỉ ngơi.", false],
	],
	"step/27": [
		[27, "", "Keith cập cảng tại [[station/10]].", false],
		[28, "", "Hai ngày sau, Carla nhờ anh quay lại. Nhóm của cô đã chế tạo một tàu thăm dò; khi được bắn vào tàu mẹ, nó sẽ phân tích con tàu và gửi kết quả về tàu của Keith. Cô ở lại nghiên cứu xác tàu và cử anh đến hệ sao [[system/18]], nơi vừa có tin báo về Void, để tìm một lỗ sâu khác.", false],
		[28, "", "Keith đồng ý với một điều kiện: nếu anh còn sống trở về, Carla nợ anh một buổi hẹn hò. Cô chấp nhận.", false],
	],
	"step/28": [
		[28, "", "Gần [[station/91]], chiến đấu cơ Void kéo đến, và Keith phải tới được lỗ sâu trước khi nó sụp đổ. Void cảnh báo rằng tiêu diệt chúng sẽ hủy diệt chính tương lai của anh.", false],
		[29, "", "Keith tới được lỗ sâu và đi qua nó vào Vùng Void.", false],
	],
	"step/29": [
		[29, "", "Gần tàu mẹ, Keith phải khóa mục tiêu vào nó để phóng tàu thăm dò, rồi cầm cự trong khi tàu thăm dò hoàn tất việc phân tích.", false],
		[30, "", "Trong lúc chờ, Void lại phát thông điệp, nói rằng phải tìm cách đối thoại trước khi con người tiêu diệt chúng và cùng với đó là tương lai của chính con người. Keith cầm cự cho đến khi việc truyền dữ liệu hoàn tất rồi rời đi.", false],
	],
	"step/3": [
		[3, "", "Keith cập cảng tại [[station/78]] để giao mẻ quặng đầu tiên.", false],
		[4, "", "Gunant khá hài lòng nhưng lại cử Keith đi tiếp, lần này để lấp đầy toàn bộ khoang hàng. Ông ta đùa rằng nếu biết điều thì một ngày nào đó Keith có thể được giữ con tàu.", false],
	],
	"step/30": [
		[30, "", "Quay lại qua lỗ sâu, Keith chờ gần [[station/91]].", false],
		[31, "", "Brent gọi đến và nhờ anh ghé [[station/98]] trong hệ sao [[system/19]] trước khi về Thynome, hứa hẹn một điều bất ngờ. Dữ liệu tàu thăm dò có thể được gửi cho Carla từ đó.", false],
	],
	"step/31": [
		[31, "", "Keith cập cảng tại [[station/98]] để gặp Brent.", false],
		[32, "", "Nhóm của Brent đã phát triển một hệ thống cảnh báo sớm cho bản đồ sao. Nó cho biết nơi Void sắp mở lỗ sâu, và máy tính dẫn đường của Keith được cải tiến để nhận tín hiệu này. Brent muốn anh bay đến những nơi đó để hỗ trợ lực lượng địa phương, và trả cho anh 30.000 credit.", false],
		[32, "", "Brent nói thêm rằng một người [[faction/7|Grey]] tên là [[character/20]], làm việc cho Deep Science, đã đề nghị được gặp Keith.", false],
	],
	"step/32": [
		[32, "", "Keith quay về [[station/10]] để gặp [[character/20]].", false],
		[33, "", "Khador đã nghiên cứu xác tàu Void. Ông tin rằng bí mật về các lỗ sâu của Void nằm trong cấu trúc của một số tinh thể chỉ có ở khu vực Void. Ông đang phát triển một loại động cơ có thể đưa con tàu đến bất kỳ điểm nào trong không gian ngay tức thì, và nhờ Keith mang về cho ông ít nhất 50 tinh thể như vậy.", false],
		[33, "", "Keith phải vào lỗ sâu thêm một lần nữa, lần này dùng hệ thống cảnh báo sớm của Brent để tìm.", false],
	],
	"step/33": [
		[33, "", "Keith phải thu thập 50 [[item/164]] trong khu vực Void và giao chúng đến [[station/10]].", false],
		[34, "", "Khador rất vui mừng và tặng Keith một bản sao bản thiết kế [[item/85]] của mình, để Keith có thể tự chế tạo một cái (xem [[guide/blueprints]]). Loại động cơ này thậm chí có thể đến được khu vực quê nhà của Void.", false],
		[34, "", "Carla xuất hiện, quá bận để hẹn hò. Cô cho Keith biết cô và Brent đã vạch ra một kế hoạch và cử anh đến gặp Brent tại [[station/30]] trong hệ sao [[system/2]].", false],
	],
	"step/34": [
		[34, "", "Keith bay đến [[station/30]] để nghe kế hoạch của Brent.", false],
		[35, "", "Dữ liệu tàu thăm dò cho thấy tàu mẹ là nguồn gốc của các lỗ sâu. Đến nay chưa có vũ khí nào làm hại được nó, nên kế hoạch là lái một tàu chở hàng vững chắc chất đầy thuốc nổ hạt nhân Nivelian lao thẳng vào lõi của nó.", false],
		[35, "", "Một tàu chở hàng Vossk K'Sarr là phù hợp nhất cho nhiệm vụ. Brent đã sắp xếp để nhận một chiếc từ [[character/7]], chỉ huy của [[station/29]] trong hệ sao [[system/5]], như một phần của cuộc trao đổi tù nhân bí mật. Errkt nhất quyết muốn gặp trực tiếp viên phi công.", false],
	],
	"step/35": [
		[35, "", "Keith bay vào lãnh thổ [[faction/1]] để gặp [[character/7]] tại [[station/29]].", false],
		[36, "", "Errkt, người đã tìm hiểu lý lịch của Keith, cho rằng chỉ người Vossk mới lái được tàu Vossk cho ra hồn. Vì nhiệm vụ không được phép thất bại, ông sẽ tự mình lái tàu chở hàng. Tuy nhiên, trước hết Keith phải chứng minh tài năng phi công chiến đấu của mình gần hành tinh [[station/27]].", false],
	],
	"step/36": [
		[36, "", "Errkt đề xuất một cuộc so tài tại một sào huyệt hải tặc gần [[station/27]]: ai bắn hạ được nhiều hải tặc hơn sẽ thắng.", false],
		[37, "", "Keith thắng. Errkt công nhận anh là một phi công giỏi và trao cho anh vinh dự hộ tống tàu chở hàng, chiếc tàu ông sẽ đưa đến điểm hẹn đã thỏa thuận. Keith gọi cho Brent để báo cáo.", false],
	],
	"step/37": [
		[37, "", "Keith liên lạc với Brent từ [[station/27]] để báo cáo về cuộc gặp với Errkt.", false],
		[38, "", "Đế chế Vossk đã xác nhận sự ủng hộ, và Brent chấp nhận Errkt làm phi công. Một vấn đề mới nảy sinh: các tàu của [[faction/3|Liên minh Mido]], vốn đang có chiến tranh với người Nivelian, đã chiếm giữ đoàn tàu chở thuốc nổ Nivelian. Người ta phát hiện nó trong hệ sao [[system/4]] gần [[station/22]], và Keith đồng ý chặn đánh.", false],
	],
	"step/38": [
		[38, "", "Gần [[station/22]], Keith tìm thấy đoàn tàu bị đánh cắp cùng các chiến đấu cơ Mido hộ tống. Anh phải tiêu diệt tàu hộ tống mà không làm hư hại các tàu trong đoàn.", false],
		[39, "", "Khi đoàn tàu đã được kiểm soát trở lại, Brent giao nó cho lực lượng an ninh địa phương để đưa đến [[station/30]] và nhờ Keith cũng quay về đó.", false],
	],
	"step/39": [
		[39, "", "Keith cập cảng tại [[station/30]] để nghe giao nhiệm vụ lần cuối.", false],
		[40, "", "Thuốc nổ được chất lên tàu chở hàng Vossk, và Errkt vẫn là phi công. Lần tới khi Void xuất hiện, Keith và Errkt sẽ bay đến đó. Errkt sẽ hướng đến lỗ sâu đầu tiên, còn Keith sẽ yểm trợ và bám theo ông. Brent sẽ đề nghị trạm gần nhất gửi quân tiếp viện.", false],
		[40, "", "Errkt sẽ thoát ra bằng khoang cứu sinh ngay trước khi va chạm. Keith phải kịp quay lại qua lỗ sâu trước khi tàu mẹ bị phá hủy, nếu không sẽ không còn đường về.", false],
	],
	"step/4": [
		[4, "", "Keith quay lại bãi tiểu hành tinh để khai thác cho đến khi đầy khoang hàng.", false],
		[5, "", "Trong lúc anh đang khai thác, một tàu hải tặc tiến đến. Không có vũ khí, Keith được bảo phải chạy về trạm và né đạn của nó.", false],
	],
	"step/40": [
		[40, "", "Nhờ hệ thống cảnh báo sớm, Keith bay đến một quỹ đạo đang bị Void tấn công. Errkt đến cùng tàu chở hàng và hướng về lỗ sâu đầu tiên, còn Trung úy [[character/8]] tham gia cùng phi đội của mình. Keith phải bảo vệ tàu chở hàng cho đến khi nó đi qua.", false],
		[41, "", "Giáp của tàu chở hàng bị hư hại nặng, nhưng Errkt tới được lỗ sâu, và Keith theo ông đi qua.", false],
	],
	"step/41": [
		[41, "", "Phi đội của Baffour không kịp qua lỗ sâu, nên chỉ còn Keith và Errkt. Tàu chở hàng đang trên đường va chạm với tàu mẹ, và Keith phải dọn sạch các chiến đấu cơ Void trên đường đi của nó.", false],
		[42, "", "Khi tàu chở hàng đến gần, Errkt báo rằng khoang cứu sinh của ông đã bị bắn trúng. Ông chọn ở lại với tàu chở hàng và ra lệnh cho Keith rời đi khi vẫn còn kịp. Keith nói lời từ biệt và quay đầu.", false],
	],
	"step/42": [
		[42, "", "Keith phải thoát ra xa khi tàu chở hàng của Errkt lao về phía mục tiêu.", false],
		[43, "", "Brent báo tin các lỗ sâu trên khắp khu vực đã sụp đổ: kế hoạch đã thành công. Keith cho anh biết Errkt đã không sống sót, và Brent hứa sẽ vinh danh ông trong báo cáo gửi Đế chế Vossk. Họ hẹn gặp nhau uống một ly tại [[station/98]].", false],
	],
	"step/43": [
		[43, "", "Keith cùng Brent ăn mừng tại [[station/98]].", false],
		[44, "", "Sau vài ly, Carla đến trong bộ váy dạ hội để thực hiện buổi hẹn hò cô nợ Keith. Brent tế nhị để hai người ở lại riêng với nhau.", false],
	],
	"step/44": [
		[44, "", "Keith tỉnh dậy tại [[station/98]] với cơn đau đầu sau đêm say sưa bên Carla.", false],
		[45, "", "Carla đã đi. Mẩu giấy cô để lại giải thích rằng cô đã chuyển sang một dự án bí mật khác ở nơi cô không thể tiết lộ, và Deep Science trả cho Keith khoản cuối cùng 40.000 credit. Keith ngờ rằng mình đã bị lợi dụng từ đầu đến cuối, và quay lại quầy bar.", false],
	],
	"step/45": [
		[45, "", "Cốt truyện đã hoàn tất. Tàu mẹ Void đã bị phá hủy, các lỗ sâu đã đóng lại, và [[character/0]] được tự do đi bất cứ đâu anh muốn. Bạn có thể tiếp tục bay, buôn bán, khai thác và nhận việc khắp thiên hà; xem [[world/history]] để đọc tóm tắt toàn bộ cốt truyện.", false],
	],
	"step/5": [
		[5, "", "Keith phải chạy thoát khỏi tên hải tặc và cập cảng an toàn tại [[station/78]].", false],
		[6, "", "Gunant thừa nhận các cuộc đột kích của hải tặc vào trạm ngày càng tồi tệ. Keith đề nghị xử lý chúng nếu được trang bị vũ khí. Gunant quyết định thử tấn công sào huyệt hải tặc gần trạm và mở hangar nhỏ của mình để Keith lắp một vũ khí và giáp.", false],
	],
	"step/6": [
		[6, "", "Trong hangar của trạm, Keith phải lắp cho [[ship/0]] một vũ khí và một tấm giáp (xem [[guide/fitting]]).", false],
		[7, "", "Gunant tán thành lựa chọn đó. Để đề phòng, ông ta đã chỉnh vũ khí của Keith sao cho chúng không thể xuyên qua khiên của chính ông. Hai người hẹn gặp nhau bên ngoài.", false],
	],
	"step/7": [
		[7, "", "Gunant chuyển lộ trình đến sào huyệt dưới dạng các điểm mốc. Keith phải đi theo và tiêu diệt các tàu hải tặc ở đó, với Gunant bay cùng (xem [[guide/combat]]).", false],
		[8, "", "Sào huyệt có nhiều hải tặc hơn dự kiến rất nhiều. Gunant muốn rút lui, nhưng Keith tiếp tục chiến đấu và giành chiến thắng. Khi được hỏi đã học cách chiến đấu như vậy ở đâu, Keith nói anh từng phục vụ trong Hạm đội Không gian dưới quyền Đô đốc Smith. Gunant thấy điều đó thật lạ, vì Keith trông quá trẻ.", false],
	],
	"step/8": [
		[8, "", "Thắng trận, Keith và Gunant quay về [[station/78]].", false],
		[9, "", "Gunant cảm ơn Keith đã cứu mạng mình và nhắc đến ngôi mộ của Đô đốc Smith trên [[station/5]]. Keith sững sờ: vị đô đốc đã qua đời vì tuổi già vào khoảng năm 3612. Gunant sau đó cho anh biết năm hiện tại là 3624, một năm mà ông ta cho rằng sẽ được nhớ đến vì Void.", false],
	],
	"step/9": [
		[9, "", "Bàng hoàng trước tin tức, Keith lại cập cảng tại [[station/78]] để giải quyết mọi chuyện với Gunant.", false],
		[10, "", "Keith nhận ra rằng đã khoảng 35 năm trôi qua kể từ khi anh bị bắn trúng trong vành đai tiểu hành tinh. Gunant nghi ngờ đó là lỗi của động cơ siêu không gian, vì loại động cơ này đã dính líu đến những sự cố tương tự trong nhiều năm.", false],
		[10, "", "Để cảm ơn chiến thắng trước bọn hải tặc, Gunant tặng [[ship/0]] cho Keith, được lắp động cơ mạnh hơn để di chuyển giữa các hành tinh trong hệ sao. Ông ta giữ lại tia laser khai thác, một nguyên mẫu do chính ông chế tạo. Cuối cùng Keith cũng nói tên mình và lên đường gặp Đại úy [[character/3]], một chỉ huy loài người tại [[station/79]] có thể giúp anh trở về vùng không gian [[faction/0]]. Từ giờ [[chart]] cho phép di chuyển trong hệ sao.", false],
	],
	"system/0": [
		[0, "", "[[system/0]] là một hệ sao Nivelian ở mép trái bản đồ. Nó bị ẩn trên bản đồ sao cho đến khi bạn mua tọa độ từ [[agent/12]] tại [[station/18]]. Cổng của nó tại [[station/0]] nối với [[system/2]] và [[system/8]].", false],
		[0, "", "Các trạm của Suteo thuộc hàng tiên tiến nhất vùng không gian Nivelian, với [[station/2]] và [[station/4]] ở cấp công nghệ cao nhất. Đặc vụ [[agent/0]] bán một bản thiết kế tại [[station/3]].", false],
	],
	"system/1": [
		[0, "", "[[system/1]] là một hệ sao Terran ở góc dưới bên trái bản đồ. Nó bị ẩn cho đến khi bạn mua tọa độ từ [[agent/13]] tại [[station/26]]. Cổng của nó tại [[station/5]] nối với [[system/8]] và [[system/18]].", false],
		[0, "", "Các trạm ở đây phát triển tốt, với [[station/7]] ở cấp công nghệ cao nhất. Đặc vụ [[agent/1]] bán một bản thiết kế tại [[station/8]].", false],
		[9, "", "Theo lời [[character/2]], Đô đốc Smith, chỉ huy cũ của [[character/0]], được chôn cất trên [[station/5]].", false],
	],
	"system/10": [
		[0, "", "[[system/10]] là một hệ sao Vossk ở phía bên phải bản đồ, được xếp hạng Nguy hiểm. Nó bị ẩn cho đến khi bạn mua tọa độ từ [[agent/14]], và hoàn toàn không có liên kết cổng: chỉ tàu có động cơ nhảy mới đến được. Cả năm trạm của nó đều ở các cấp công nghệ cao nhất.", false],
		[0, "", "Đặc vụ [[agent/5]] bán một bản thiết kế tại [[station/54]].", false],
	],
	"system/11": [
		[0, "", "[[system/11]] là một hệ sao Terran ở phần trên trung tâm bản đồ, được xếp hạng Trung bình. Nó chỉ có ba trạm. Cổng của nó tại [[station/55]] nối với [[system/7]], [[system/9]], [[system/14]] và [[system/16]].", false],
		[18, "", "[[character/0]] được cử đến [[station/56]] để gặp một sĩ quan của Deep Science.", false],
		[19, "", "Viên sĩ quan đó, [[character/5]], đã bị hải tặc bắt cóc gần [[station/55]].", false],
		[22, "", "[[character/0]] giải thoát anh ta bằng bom EMP trong [[step/21]].", false],
	],
	"system/12": [
		[0, "", "[[system/12]] là một hệ sao Vossk nhỏ chỉ có hai trạm, ở phía bên phải bản đồ và được xếp hạng Trung bình. Cổng của nó tại [[station/60]] nối với [[system/3]], [[system/5]], [[system/13]] và [[system/14]], nên nó nối vùng không gian Vossk với miền đông của Terran.", false],
		[0, "", "Đặc vụ Multipod [[agent/6]] bán một bản thiết kế tại [[station/61]].", false],
	],
	"system/13": [
		[0, "", "[[system/13]] là một hệ sao Terran ở mép phải bản đồ, được xếp hạng Rủi ro. Cổng của nó tại [[station/65]] nối với [[system/12]] và [[system/16]].", false],
		[0, "", "Đặc vụ Cyborg [[agent/14]] bán tọa độ tại [[station/65]].", false],
	],
	"system/14": [
		[0, "", "[[system/14]] là một hệ sao Terran gần trung tâm bản đồ và là một trong hai hệ sao An toàn của thiên hà. Cổng của nó tại [[station/70]] nối với [[system/3]], [[system/11]], [[system/12]] và [[system/19]]. Các trạm ở đây phần lớn có công nghệ thấp.", false],
		[0, "", "Đặc vụ [[agent/7]] bán một bản thiết kế tại [[station/72]].", false],
	],
	"system/15": [
		[0, "", "[[system/15]] là một hệ sao Midorian ở đầu bản đồ, được xếp hạng Nguy hiểm. Nó không có liên kết cổng, nên tàu chỉ có thể vào hoặc rời khỏi nó bằng động cơ nhảy. Cả năm trạm của nó đều nhỏ và có công nghệ thấp. Cho đến [[step/16]], người bán tàu ở đây vẫn đóng cửa và ít tàu qua lại.", false],
		[0, "", "Cốt truyện bắt đầu tại đây, ở [[station/78]].", false],
		[11, "", "Hệ sao là lãnh thổ của [[faction/3|Liên minh Mido]], do những người Terran và Nivelian lưu vong thành lập trong cuộc Nội chiến Nivelian. Người Nivelian vẫn đòi chủ quyền nơi này, và ở vùng rìa vẫn có giao tranh.", false],
		[15, "", "[[character/0]] rời hệ sao với tư cách tù nhân trên một tuần dương hạm Terran sau [[step/14]]. Muốn quay lại sau này cần có động cơ nhảy.", false],
		[0, "", "[[character/2]] bán một bản thiết kế trong phòng chờ của [[station/78]].", false],
	],
	"system/16": [
		[0, "", "[[system/16]] là một hệ sao Terran ở phía bên phải bản đồ, được xếp hạng Rủi ro. Cổng của nó tại [[station/80]] nối với [[system/11]] và [[system/13]].", false],
		[0, "", "Đặc vụ Vossk [[agent/8]] bán một bản thiết kế tại [[station/84]].", false],
	],
	"system/17": [
		[0, "", "[[system/17]] là một hệ sao Nivelian ở góc trên bên trái bản đồ, được xếp hạng Rủi ro, và là hệ sao gần [[system/15]] nhất. Cổng của nó tại [[station/85]] nối với [[system/2]], [[system/9]] và [[system/4]]; đây là tuyến cổng duy nhất dẫn vào [[system/4]].", false],
		[0, "", "Đặc vụ Vossk [[agent/15]] bán tọa độ tại [[station/88]].", false],
	],
	"system/18": [
		[0, "", "[[system/18]] là một hệ sao Terran ở phía dưới bản đồ, được xếp hạng Rủi ro. Cổng của nó tại [[station/90]] nối với [[system/1]] và [[system/8]].", false],
		[0, "", "Đặc vụ [[agent/9]] bán một bản thiết kế tại [[station/90]].", false],
		[28, "", "Trong [[step/28]], [[character/0]] đến đây sau tin báo về hoạt động của Void gần [[station/91]], để lẻn vào một lỗ sâu.", false],
	],
	"system/19": [
		[0, "", "[[system/19]] là một hệ sao Terran ở trung tâm bản đồ, được xếp hạng An toàn. Cổng của nó tại [[station/95]] nối với [[system/3]], [[system/8]], [[system/9]] và [[system/14]].", false],
		[15, "", "[[station/98]] là nơi tuần dương hạm Terran đưa [[character/0]] đến sau khi bắt giữ anh, và là nơi anh gặp lại người bạn cũ [[character/1]].", false],
		[16, "", "Ngay cả hệ sao an toàn này cũng không thoát: một phi đội Void tấn công [[station/98]] trong [[step/16]]. [[character/1]] đặt sở chỉ huy của mình tại đây.", false],
	],
	"system/2": [
		[0, "", "[[system/2]] là một hệ sao Nivelian ở phía bên trái bản đồ và là ngã tư của vùng không gian Nivelian. Cổng của nó tại [[station/30]] nối với [[system/0]], [[system/8]], [[system/9]] và [[system/17]]. Hệ sao có bốn trạm với cấp công nghệ trung bình.", false],
		[34, "", "Trong [[step/33]], [[character/6]] cử [[character/0]] đến [[station/30]], nơi [[character/1]] đang chờ với một kế hoạch mới. Công tác chuẩn bị cuối cùng chống lại Void cũng diễn ra tại đây.", false],
	],
	"system/20": [
		[0, "", "[[system/20]] là một hệ sao Vossk ở góc dưới bên phải bản đồ, được xếp hạng Nguy hiểm. Cổng của nó tại [[station/62]] nối với [[system/5]] và [[system/21]], khiến nó trở thành tuyến cổng duy nhất dẫn vào [[system/21]].", false],
		[0, "", "Một người Terran, đặc vụ [[agent/10]], bán một bản thiết kế tại trạm nhỏ [[station/59]].", false],
	],
	"system/21": [
		[0, "", "[[system/21]] là một hệ sao Vossk ở tận góc dưới bên phải bản đồ, được xếp hạng Nguy hiểm. Nó bị ẩn cho đến khi bạn mua tọa độ từ [[agent/15]]. Cổng của nó tại [[station/12]] chỉ nối với [[system/20]]. Các trạm ở đây đều thô sơ, với cấp công nghệ từ 3 trở xuống.", false],
	],
	"system/3": [
		[0, "", "[[system/3]] là hệ sao Vossk gần trung tâm bản đồ nhất và là lối vào chính của vùng không gian Vossk. Cổng của nó tại [[station/15]] nối với [[system/5]], [[system/12]], [[system/8]], [[system/14]] và [[system/19]]. Hệ sao được xếp hạng Trung bình.", false],
		[0, "", "Đặc vụ [[agent/12]] tại [[station/18]] bán tọa độ của hệ sao ẩn [[system/0]].", false],
	],
	"system/4": [
		[0, "", "[[system/4]] là một hệ sao Midorian ở góc trên bên trái bản đồ, được xếp hạng Nguy hiểm. Đây là một ngõ cụt: cổng của nó tại [[station/20]] chỉ dẫn đến [[system/17]]. Các trạm ở đây trải từ [[station/21]] thô sơ đến [[station/22]] được trang bị tốt.", false],
		[0, "", "Đặc vụ [[agent/2]] bán một bản thiết kế trong phòng chờ của [[station/20]].", false],
		[38, "", "Trong [[step/38]], một đoàn tàu bị đánh cắp chở thuốc nổ Nivelian được lần ra ở hệ sao này, gần [[station/22]].", false],
	],
	"system/5": [
		[0, "", "[[system/5]] là một hệ sao Vossk ở góc dưới bên phải bản đồ, được xếp hạng Rủi ro. Cổng của nó tại [[station/25]] nối với [[system/3]], [[system/12]] và [[system/20]]. Đặc vụ [[agent/13]] bán tọa độ tại [[station/26]].", false],
		[35, "", "Hệ sao này là căn cứ của chỉ huy Vossk [[character/7]] tại [[station/29]], nơi [[character/0]] gặp ông trong [[step/35]].", false],
		[36, "", "Cuộc so tài của họ diễn ra gần [[station/27]].", false],
	],
	"system/6": [
		[0, "", "[[system/6]] là một hệ sao Terran ở góc trên bên phải bản đồ, được xếp hạng Nguy hiểm. Nó không có trên các bản đồ sao thông thường, và chỉ cốt truyện mới tiết lộ tọa độ của nó. Hệ sao chỉ có một trạm, [[station/10]], với cổng chỉ nối đến [[system/7]].", false],
		[23, "", "Hệ sao này che giấu trạm nghiên cứu bí mật của Deep Science. [[character/5]] trao cho [[character/0]] tọa độ của nó trong [[step/22]], và phần lớn cuộc đấu tranh chống lại Void được lên kế hoạch tại đây.", false],
	],
	"system/7": [
		[0, "", "[[system/7]] là một hệ sao Terran ở góc trên bên phải bản đồ, được xếp hạng Rủi ro. Cổng của nó tại [[station/35]] nối với [[system/11]] và với hệ sao ẩn [[system/6]], khiến nó trở thành tuyến cổng duy nhất dẫn vào hệ sao ẩn đó. [[station/37]] là trạm tiên tiến nhất của nó.", false],
	],
	"system/8": [
		[0, "", "[[system/8]] là một hệ sao Terran ở phần tư dưới bên trái bản đồ và là hệ sao có nhiều kết nối nhất thiên hà. Cổng của nó tại [[station/40]] nối với sáu hệ sao: [[system/0]], [[system/1]], [[system/2]], [[system/3]], [[system/18]] và [[system/19]]. Hệ sao được xếp hạng Trung bình.", false],
		[0, "", "Đặc vụ [[agent/4]] bán một bản thiết kế tại [[station/43]].", false],
	],
	"system/9": [
		[0, "", "[[system/9]] là một hệ sao Nivelian ở phần trên trung tâm bản đồ, được xếp hạng Trung bình. Cổng của nó tại [[station/45]] nối với [[system/2]], [[system/11]], [[system/17]] và [[system/19]].", false],
		[24, "", "Có tin báo về hoạt động của Void gần [[station/48]], và [[character/0]] cùng [[character/6]] đến đó trong [[step/24]] để thu gom xác tàu.", false],
	],
	"world/galaxy": [
		[0, "Tổng quan", "Trò chơi diễn ra trong một thiên hà duy nhất gồm 22 hệ sao. Mỗi hệ sao thuộc về một phe, có một mức an ninh và chứa từ một đến năm trạm không gian. Mỗi trạm quay quanh một hành tinh và có cửa hàng, hangar và phòng chờ riêng. Các hệ sao trải trên một bản đồ phẳng, và việc di chuyển giữa chúng đi qua một mạng lưới cổng nhảy.", false],
		[0, "", "Bốn dân tộc làm chủ các hệ sao đã được lập bản đồ. [[faction/0|Người Terran]] nắm mười hệ, [[faction/1]] sáu hệ, [[faction/2|người Nivelian]] bốn hệ và [[faction/3|người Midorian]] hai hệ. Thành viên của các chủng tộc nhỏ hơn, như [[faction/4|Multipod]], [[faction/5|Cyborg]], [[faction/6|người Bobolian]] và [[faction/7]], sống xen giữa họ mà không có lãnh thổ riêng. [[faction/8|Hải tặc]] lang thang ở mọi hệ sao, và ngay từ đầu đã có tin đồn về một thế lực thù địch gọi là [[faction/9|Void]].", false],
		[0, "Bố cục", "Các hệ sao Nivelian và Midorian nằm ở góc trên bên trái bản đồ, quanh [[system/15]], [[system/4]], [[system/17]] và [[system/2]]. Vùng không gian Terran trải dài qua trung tâm, phía bên phải và phía dưới bản đồ, với [[system/19]] và [[system/14]] là trung tâm. Các hệ sao Vossk tạo thành một khối riêng ở góc dưới bên phải, bắt đầu từ [[system/3]] và kết thúc ở góc xa nhất tại [[system/21]].", false],
		[0, "", "Các tuyến cổng tập trung ở trung tâm. [[system/8]] có sáu liên kết cổng, nhiều hơn bất kỳ hệ sao nào khác, còn [[system/19]], [[system/14]], [[system/3]] và [[system/11]] mỗi hệ nối với bốn hoặc năm hệ sao. Các hệ sao ở rìa, như [[system/4]], [[system/6]] và [[system/21]], là ngõ cụt chỉ có một liên kết.", false],
		[0, "Di chuyển", "Trong một hệ sao, động cơ thông thường của tàu đưa nó từ quỹ đạo của trạm này sang trạm khác. Để rời hệ sao, tàu phải bay qua cổng nhảy, vốn nằm ở một trong các trạm của hệ và chỉ dẫn đến các hệ sao được liên kết với nó. Những chuyến đi dài hơn là chuỗi các cú nhảy qua cổng. Động cơ nhảy là cách duy nhất để bỏ qua mạng lưới cổng và đến thẳng bất kỳ hệ sao đã biết nào; xem [[guide/navigation]].", false],
		[33, "", "Động cơ nhảy duy nhất trong trò chơi là [[item/85]], do [[character/20]] thiết kế trong quá trình cốt truyện. Nó được chế tạo từ bản thiết kế và cần [[item/164]], cùng một số thứ khác.", false],
		[0, "An ninh", "Mỗi hệ sao được xếp hạng An toàn, Trung bình, Rủi ro hoặc Nguy hiểm. Mức xếp hạng quyết định tần suất kẻ cướp phục kích gần trạm khi bạn đến. Ở hệ sao Nguy hiểm, chúng xuất hiện trong hầu hết các lần ghé; ở hệ sao An toàn thì hiếm khi gặp. Kẻ cướp thường là hải tặc, nhưng đôi khi là tàu của chủng tộc đối địch với phe sở tại. Ngược lại, các hệ sao an toàn hơn có nhiều tàu tuần tra địa phương quanh trạm hơn.", false],
		[0, "Các phe và uy tín", "Uy tín của bạn được tính trên hai thang: một giữa người Terran và người Vossk, một giữa người Nivelian và người Midorian. Được lòng một bên trong cặp đồng nghĩa với mất lòng bên kia. Nếu uy tín của bạn với một phe xuống quá thấp, tàu của họ sẽ tấn công bạn ngay khi nhìn thấy và các trạm của họ từ chối bạn. Hải tặc và Void luôn thù địch. Một nhà ngoại giao trong phòng chờ có thể khôi phục uy tín cho bạn với một khoản phí.", false],
		[0, "Hệ sao ẩn", "Không phải hệ sao nào cũng xuất hiện trên bản đồ sao ngay từ đầu. [[system/0]], [[system/1]], [[system/10]] và [[system/21]] bị ẩn cho đến khi bạn mua tọa độ của chúng từ một đặc vụ trong phòng chờ; xem [[guide/lounge]]. Thêm một hệ sao nữa, [[system/6]], không có trên các bản đồ sao thông thường và chỉ được cốt truyện tiết lộ.", false],
		[23, "", "Tọa độ của [[system/6]] đến tay bạn qua [[character/5]] trong [[step/22]]. Hệ sao này chỉ có một trạm, [[station/10]], căn cứ nghiên cứu bí mật của tổ chức Deep Science.", false],
		[0, "", "Hai hệ sao hoàn toàn không có liên kết cổng: [[system/15]] và [[system/10]]. Tàu chỉ có thể đến hoặc rời khỏi chúng bằng động cơ nhảy.", false],
		[0, "Khởi đầu biệt lập", "Cốt truyện mở đầu tại [[system/15]], một hệ sao xa xôi ở đầu bản đồ, không có kết nối cổng nào với phần còn lại của thiên hà. Thương mại ở đây nghèo nàn, các trạm có công nghệ thấp, và người bán tàu đóng cửa trong phần đầu của cốt truyện. Lúc đầu, cách duy nhất để rời hệ sao là con đường mà cốt truyện mở ra.", false],
		[11, "", "[[system/15]] là quê hương của [[faction/3|Liên minh Mido]], một nhóm người tị nạn và kẻ ngoài vòng pháp luật gốc Terran và Nivelian đã định cư tại khu vực mới được lập bản đồ này trong cuộc Nội chiến Nivelian. Liên minh tuyên bố độc lập. Người Terran chấp nhận điều này; người Nivelian vẫn đòi chủ quyền hệ sao, khiến giao tranh vẫn tiếp diễn ở vùng rìa.", false],
		[15, "", "[[character/0]] rời [[system/15]] trên một tuần dương hạm Terran sau khi đoàn tàu tại [[station/79]] vô hiệu hóa và bắt giữ anh trong [[step/14]]. Anh đến [[station/98]] trong [[system/19]], sâu trong vùng không gian Terran.", false],
		[9, "Khoảng trống thời gian", "Khi [[character/0]] tỉnh dậy ở [[system/15]], anh tưởng chỉ một thời gian ngắn đã trôi qua. Thực ra động cơ siêu không gian bị hỏng đã ném anh băng qua thiên hà và tới khoảng 35 năm sau trong tương lai. Thiên hà mà anh từng biết đã thay đổi: bạn cũ đã già đi hoặc qua đời, và các khu vực mới, trong đó có nơi anh đang ở, đã được định cư trong khoảng thời gian đó.", false],
		[10, "", "Những động cơ siêu không gian bị lỗi cùng loại với của anh từng gây ra những cú nhảy xuyên thời gian và không gian tương tự.", false],
		[18, "Bên ngoài bản đồ", "Void tiến vào các hệ sao đã được lập bản đồ qua một dạng lỗ sâu nào đó. Chúng đột kích cả vùng không gian Terran, Nivelian lẫn Vossk và dường như đang tìm quặng. Xem [[world/voids]].", false],
		[25, "", "Một lỗ sâu dẫn ra khỏi thiên hà đã được lập bản đồ, vào khu vực riêng của Void, nơi không có trên bản đồ sao. Các lỗ sâu mở ra gần một trạm trong một thời gian, rồi sụp đổ và xuất hiện ở nơi khác.", false],
		[34, "", "Khi lắp [[item/85]], tàu cũng có thể nhảy thẳng vào khu vực Void.", false],
		[32, "", "Từ [[step/31]] trở đi, một hệ thống cảnh báo sớm hiển thị trên bản đồ sao nơi lỗ sâu tiếp theo sẽ mở ra.", false],
		[42, "", "Khi tàu mẹ Void bị phá hủy trong [[step/41]], các lỗ sâu trên khắp khu vực sụp đổ và các cuộc đột kích chấm dứt.", false],
	],
	"world/history": [
		[0, "", "Thiên hà là nơi sinh sống của nhiều dân tộc, trong đó có [[faction/0|người Terran]], [[faction/2|người Nivelian]] và [[faction/1|người Vossk]]. Vùng không gian giữa các trạm của họ bị [[faction/8|hải tặc]] quấy nhiễu. Trang này tóm tắt cốt truyện; mỗi phần sẽ hiện ra khi bản lưu của bạn đạt tới.", false],
		[0, "Hồi một: mắc kẹt", "Thợ săn tiền thưởng người Terran [[character/0]] tiêu diệt một băng hải tặc trong vành đai tiểu hành tinh ([[step/0]]).", false],
		[1, "", "Một phát bắn cuối cùng làm hỏng động cơ siêu không gian khi anh nhảy đi để gặp chỉ huy cũ của mình, Đô đốc Smith. Con tàu trôi dạt cùng viên phi công bất tỉnh đến [[station/78]].", false],
		[2, "", "Thương nhân quặng người Nivelian [[character/2]] trục vớt xác tàu, giữ lấy con tàu và bắt Keith khai thác quặng cho mình.", false],
		[8, "", "Keith giúp Gunant tiêu diệt một sào huyệt hải tặc gần đó ([[step/7]]).", false],
		[9, "", "Sau đó Keith biết rằng bây giờ là năm 3624 và Đô đốc Smith đã qua đời từ lâu.", false],
		[10, "", "Một sự cố của động cơ siêu không gian đã đưa Keith tới tương lai 35 năm sau, đến một góc xa xôi của thiên hà. Gunant tặng anh con tàu [[ship/0]] và gửi anh đến gặp [[character/3]] tại [[station/79]].", false],
		[11, "", "Hệ sao [[system/15]] thuộc về [[faction/3|Liên minh Mido]], do những người Terran và Nivelian lưu vong thành lập trong cuộc Nội chiến Nivelian.", false],
		[12, "", "Keith phát hiện ra rằng trạm im lặng [[station/76]] đã bị tay buôn [[character/4]] làm cho cả trạm say thuốc mê man ([[step/11]]).", false],
		[15, "", "Khi một đoàn tàu Terran đi qua, họ nhầm Keith là hải tặc, vô hiệu hóa tàu của anh và đưa anh đến [[station/98]] ([[step/14]]).", false],
		[16, "Hồi hai: mối đe dọa Void", "Tại đó anh gặp lại người bạn cũ [[character/1]], nay là trưởng an ninh, đúng lúc [[faction/9|Void]] tấn công trạm.", false],
		[18, "", "Void đột kích các hệ sao qua lỗ sâu để tìm quặng. Brent tuyển Keith bay cho Deep Science, một tổ chức nghiên cứu bí mật chuyên tìm hiểu về chúng ([[step/17]]).", false],
		[19, "", "Nhà khoa học [[character/5]], người lẽ ra sẽ dẫn Keith đến trạm nghiên cứu, bị hải tặc bắt cóc.", false],
		[23, "", "Keith vô hiệu hóa tàu của bọn bắt cóc bằng bom EMP, giải cứu anh ta và nhận tọa độ của hệ sao [[system/6]] ([[step/21]], [[step/22]]).", false],
		[24, "Hồi ba: Deep Science", "Tại [[station/10]], Keith gặp trưởng dự án [[character/6]] và bắt đầu làm việc cho Deep Science.", false],
		[25, "", "Keith và Carla thu hồi xác tàu Void tại [[station/48]], nhưng một lỗ sâu nuốt chửng con tàu của họ ([[step/24]]).", false],
		[26, "", "Họ thấy mình đang ở khu vực quê nhà của Void, cạnh một con tàu mẹ khổng lồ, và trốn thoát qua một lỗ sâu khác.", false],
		[30, "", "Keith quay lại khu vực Void qua một lỗ sâu gần [[station/91]] và phóng một tàu thăm dò vào tàu mẹ ([[step/29]]).", false],
		[32, "", "Brent trao cho Keith một hệ thống cảnh báo sớm cho biết Void sẽ tấn công ở đâu tiếp theo.", false],
		[34, "", "Nhà khoa học người Grey [[character/20]] nhờ Keith thu thập tinh thể Void cho một loại động cơ tức thời mới và tặng anh bản thiết kế của nó ([[step/33]]).", false],
		[35, "Hồi bốn: đòn tấn công", "Tàu thăm dò cho thấy chính tàu mẹ tạo ra các lỗ sâu. Brent và Carla lên kế hoạch phá hủy nó bằng một tàu chở hàng chất đầy thuốc nổ Nivelian, do chỉ huy Vossk [[character/7]] cung cấp.", false],
		[37, "", "Errkt nhất quyết tự mình lái tàu chở hàng, và Keith giành được quyền hộ tống ông ([[step/36]]).", false],
		[39, "", "Keith giành lại đoàn tàu chở thuốc nổ sau khi tàu Mido chiếm giữ nó ([[step/38]]).", false],
		[42, "", "Cùng lực lượng tiếp viện do [[character/8]] chỉ huy, Keith hộ tống Errkt qua một lỗ sâu. Errkt lao tàu chở hàng vào tàu mẹ và hy sinh trong cuộc tấn công ([[step/41]]).", false],
		[43, "", "Mọi lỗ sâu sụp đổ và các cuộc đột kích của Void chấm dứt.", false],
		[45, "Phần kết", "Keith ăn mừng cùng Brent và cuối cùng cũng có một đêm bên Carla. Sáng hôm sau cô rời đi để tham gia một dự án bí mật khác, còn Keith được tự do ngao du khắp thiên hà.", false],
	],
	"world/khador": [
		[32, "", "Khador, một nhà khoa học người Grey làm việc cho Deep Science, có trang riêng: xem [[character/20]].", false],
	],
	"world/voids": [
		[0, "", "[[faction/9|Void]] là mối đe dọa trung tâm của cốt truyện. Trang này tập hợp những gì được biết về chúng; nội dung sẽ được bổ sung khi bản lưu của bạn tiến triển.", false],
		[2, "Những tin tức đầu tiên", "Keith nghe nói về Void lần đầu từ [[character/2]]: những sinh vật thù địch thỉnh thoảng xuất hiện, ngay cả ở hệ sao xa xôi [[system/15]].", false],
		[9, "", "Người dân hệ sao Mido cho rằng năm 3624 sẽ được nhớ đến như năm của Void.", false],
		[16, "", "Chiến đấu cơ Void tấn công [[station/98]] trong vùng không gian Terran ([[step/15]]).", false],
		[17, "", "Trong cuộc tấn công, Void phát đi một thông điệp khẳng định chúng đến trong hòa bình, nhưng vẫn tiếp tục nổ súng.", false],
		[18, "Những điều đã biết", "Void bắt đầu xuất hiện từ vài tuần trước. Chúng tiến vào các hệ sao có người ở qua lỗ sâu, tấn công mọi thứ gặp phải và dường như đang tìm quặng. Ngay cả các hệ sao [[faction/1]] cũng bị đột kích. Không ai biết chúng đến từ đâu hay chúng muốn gì.", false],
		[24, "", "Tại [[station/48]], chúng tuyên bố rằng mình đến từ tương lai và là tất cả những gì còn lại của các nền văn minh trong thiên hà.", false],
		[26, "Khu vực quê nhà", "Các lỗ sâu của chúng dẫn đến một khu vực quê nhà xa xôi, nơi một con tàu mẹ khổng lồ phóng ra các chiến đấu cơ. Các lỗ sâu mở ra trong thời gian ngắn, rồi sụp đổ và xuất hiện lại ở nơi khác.", false],
		[28, "", "Void cảnh báo rằng tiêu diệt chúng cũng sẽ hủy diệt tương lai của loài người.", false],
		[30, "", "Chúng nhắc lại rằng phải tìm được cách giao tiếp trước khi con người tiêu diệt chúng và cùng với đó là tương lai của chính con người. Lời khẳng định này đúng hay sai chưa bao giờ được làm rõ.", false],
		[32, "", "Một hệ thống cảnh báo sớm do nhóm của [[character/1]] phát triển dự đoán nơi Void sẽ mở lỗ sâu tiếp theo.", false],
		[33, "", "Nhà khoa học người Grey [[character/20]] tin rằng những tinh thể chỉ có ở khu vực Void, [[item/164]], nắm giữ bí mật về các lỗ sâu của chúng.", false],
		[35, "Hồi kết của các cuộc đột kích", "Tàu thăm dò được phóng vào tàu mẹ cho thấy nó chính là nguồn gốc của các lỗ sâu. Chưa có vũ khí nào được biết đến gây hư hại được cho nó.", false],
		[42, "", "Một tàu chở hàng Vossk chất đầy thuốc nổ hạt nhân Nivelian, do [[character/7]] điều khiển, phá hủy tàu mẹ ([[step/41]]).", false],
		[43, "", "Sau đó các lỗ sâu trên khắp khu vực sụp đổ và các cuộc đột kích của Void chấm dứt, ít nhất là trong lúc này.", false],
	],
}
