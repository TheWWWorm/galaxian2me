extends SceneTree
## Engine text follows the supplied game's language on Auto and a chosen one
## otherwise; every catalog loads, and the CJK languages draw with their
## bundled glyphs. Installed content, when there is any, is read for its
## language as well. Needs no player files and changes none.
const EngineLanguage := preload("res://src/presentation/engine_language.gd")
const Library := preload("res://src/content/library.gd")
var failures := 0

func expect(ok: bool, why: String) -> void:
	if not ok:
		failures += 1
		push_error(why)

func _initialize() -> void:
	call_deferred("run")

func run() -> void:
	var russian := ["Начать новую игру", "Загрузить игру", "Настройки", "Вы уверены, что хотите выйти?"]
	var english := ["Start new game", "Load game", "Are you sure you want to quit? Your progress is lost.", "Fly to the station and dock with the hangar."]
	expect(EngineLanguage.content_language("ru", russian) == "ru", "A ru folder with Russian text reads as Russian")
	expect(EngineLanguage.content_language("en", russian) == "ru", "Russian text under an en folder reads as Russian")
	expect(EngineLanguage.content_language("ru", english) == "en", "English text under a ru folder reads as English")
	expect(EngineLanguage.content_language("en", ["Розпочати нову гру", "Налаштування", "Ви впевнені, що хочете вийти?", "Їжа і є"]) == "uk", "Ukrainian letters read as Ukrainian")
	expect(EngineLanguage.content_language("en", ["Neues Spiel starten", "Die Station ist nicht mit dir verbunden und der Laderaum ist voll."]) == "de", "German text under an en folder reads as German")
	expect(EngineLanguage.content_language("en", ["新しいゲームを始める", "設定"]) == "ja", "Kana read as Japanese")
	expect(EngineLanguage.content_language("en", ["开始新游戏", "设置"]) == "zh", "Han without kana reads as Chinese")
	expect(EngineLanguage.content_language("en", ["새 게임 시작", "설정"]) == "ko", "Hangul reads as Korean")
	expect(EngineLanguage.content_language("ru", ["GoF2", "- 1 -", "S.T.R.E.A.M."]).is_empty(), "Latin text with no telling words under a ru folder is unknown")
	expect(EngineLanguage.resolve(EngineLanguage.AUTO, "") == EngineLanguage.resolve(EngineLanguage.AUTO, OS.get_locale()), "An unknown game language falls back to the system language")
	expect(EngineLanguage.resolve(EngineLanguage.AUTO, "ru") == "ru", "Auto follows the game")
	expect(EngineLanguage.resolve("de", "ru") == "de", "A chosen language wins over the game's")
	expect(EngineLanguage.resolve("xx", "ru") == "ru", "An unknown setting is Auto")
	expect(EngineLanguage.supported("pt_BR") == "pt" and EngineLanguage.supported("zh-Hans") == "zh" and EngineLanguage.supported("nl").is_empty(), "Regional locales find their language")
	for id in Library.installed():
		var lib := Library.new()
		if not lib.open(id): continue
		var found := EngineLanguage.content_language(lib.language, Array(lib.strings))
		var cyrillic := str(lib.text(3)).unicode_at(0) >= 0x400
		expect(found == ("ru" if cyrillic else "en"), "%s (%s folder) reads as %s" % [id.left(8), lib.language, found])
	for code in EngineLanguage.codes():
		EngineLanguage.apply(code)
		expect(EngineLanguage.current == code and TranslationServer.get_locale() == code, "%s applies" % code)
		var sample := EngineLanguage.translate("Engine language")
		expect((sample == "Engine language") == (code == "en"), "%s translates engine text" % code)
		expect(EngineLanguage.text_in(code, "Engine language") == sample, "%s text_in matches the active catalog" % code)
		if EngineLanguage.FONTS.has(code):
			var font: Font = EngineLanguage.cjk_font(code)
			expect(font != null, "%s has its bundled font" % code)
			if font != null:
				for character in sample + EngineLanguage.native_name(code):
					if character.unicode_at(0) >= 0x1100: expect(font.has_char(character.unicode_at(0)), "%s font draws %s" % [code, character])
		expect(ThemeDB.fallback_font.fallbacks.size() == EngineLanguage.FONTS.size(), "%s keeps every CJK font as a fallback" % code)
	EngineLanguage.apply("en")
	expect(EngineLanguage.translate("Engine language") == "Engine language", "English is the source text")
	print("ENGINE_LANGUAGE ", failures, " failures")
	quit(1 if failures else 0)
