extends RefCounted
## Writes the reference as a small website: an index page, its reader script
## and style, a content file of pages for each language (languages.js lists
## them), and images/ with the pictures from the player's imported art,
## enlarged without blurring, plus renders of ships and stations when the
## game could draw them (WikiSnapshots). It opens straight from the folder,
## with no server. The pages and pictures are the player's own imported
## content, so the folder is theirs to keep; nothing is sent anywhere.
const EngineLanguage := preload("res://src/presentation/engine_language.gd")
const Portrait := preload("res://src/presentation/portrait.gd")
const Catalogue := preload("res://src/content/catalogue.gd")
## Pixel art is written this many times larger, so browsers need not scale it.
const ENLARGE := 4
## The project's source and the game in the browser, linked from the header.
const SOURCE_URL := "https://github.com/TheWWWorm/galaxian2me"
const PLAY_URL := "https://galaxian2me.wwworm.com/"

static func write(catalog, directory: String, languages: Array = [], renders := {}) -> Error:
	var made := DirAccess.make_dir_recursive_absolute(directory.path_join("images"))
	if made != OK: return made
	var application_icon: Texture2D = load("res://icon.svg")
	if application_icon != null:
		var icon_pixels := application_icon.get_image()
		icon_pixels.resize(64, 64, Image.INTERPOLATE_LANCZOS)
		var icon_error := icon_pixels.save_png(directory.path_join("app-icon.png"))
		if icon_error != OK: return icon_error
	renders = renders.duplicate()
	# Pictures are the same in every language: written once, shared.
	var pictures := {}
	var icons := {}
	var media := {}
	var sprites := {}
	for key: String in catalog.ordered:
		var icon := picture(catalog.icon(key), catalog, directory, pictures)
		if not icon.is_empty(): icons[key] = icon
		# A picture drawn by an earlier export into this folder is kept, so an
		# export without a renderer still shows the models.
		var drawn := "images/render-%s.png" % key.replace("/", "-")
		if not renders.has(key) and FileAccess.file_exists(directory.path_join(drawn)): renders[key] = drawn
		var shown: Dictionary = catalog.media(key)
		var image: String = renders.get(key, picture(shown, catalog, directory, pictures))
		if not image.is_empty(): media[key] = image
		# Under a ship's model, the game's own sprite of it.
		if renders.has(key) and shown.has("ship"):
			var sprite := picture({"ship": shown.ship}, catalog, directory, pictures)
			if not sprite.is_empty(): sprites[key] = sprite
	# The galaxy map, drawn by the reader: position, faction and gate links.
	var systems: Array = []
	for id in catalog.cat.system_count():
		var s: Dictionary = catalog.cat.system(id)
		systems.append([int(s.x), int(s.y), int(s.faction), s.get("links", []).map(func(l): return int(l))])
	var codes: Array = [catalog.language]
	for code in languages:
		if code in EngineLanguage.codes() and not code in codes: codes.append(code)
	var files := {"index.html": INDEX.replace("%PLAY%", PLAY_URL).replace("%SOURCE%", SOURCE_URL), "wiki.css": STYLE, "wiki.js": READER}
	var listed: Array = []
	for code: String in codes:
		var edition = catalog if code == catalog.language else catalog.get_script().new(catalog.library, catalog.limit, code)
		files["content-%s.js" % code] = "(window.GOF2_WIKI_LANGS=window.GOF2_WIKI_LANGS||{})[%s]=%s;\n" % [JSON.stringify(code), JSON.stringify(bundle(edition, icons, media, systems, sprites))]
		listed.append([code, EngineLanguage.native_name(code)])
	files["languages.js"] = "window.GOF2_WIKI_LANGUAGES=%s;\n" % JSON.stringify({"first": catalog.language, "list": listed, "label": catalog.translate("Language")})
	for name: String in files:
		var file := FileAccess.open(directory.path_join(name), FileAccess.WRITE)
		if file == null: return FileAccess.get_open_error()
		file.store_string(files[name]); file.close()
	return OK

## One language's pages, list and labels.
static func bundle(edition, icons: Dictionary, media: Dictionary, systems: Array, sprites := {}) -> Dictionary:
	var index: Array = []
	var pages := {}
	for key: String in edition.ordered:
		var entry: Dictionary = edition.entries[key]
		var row := {"key": key, "title": entry.title, "category": entry.category, "subtitle": entry.subtitle}
		if icons.has(key): row["icon"] = icons[key]
		index.append(row)
		pages[key] = edition.page(key)
	return {"language": edition.language, "title": edition.translate("Reference"),
		"search": edition.translate("Search the reference"), "play": EngineLanguage.text_in(edition.language, "Play in your browser"), "browse": edition.translate("Browse"),
		"contents": edition.translate("Contents"), "all": edition.all_sections(), "map": edition.translate("Galaxy map"),
		"categories": edition.CATEGORIES.map(func(name): return [name, edition.category_name(name)]),
		"index": index, "pages": pages, "media": media, "sprites": sprites, "systems": systems}

## Saves a page's picture once and returns its path in the site, or "" when
## it has none the browser can show (models and maps are drawn otherwise).
static func picture(shown: Dictionary, catalog, directory: String, written: Dictionary) -> String:
	var library = catalog.library
	var name := ""
	var pixels: Image = null
	if shown.has("item"):
		name = "item-%d" % int(shown.item)
		if not written.has("images/%s.png" % name): pixels = item_image(library, int(shown.item))
	elif shown.has("ship"):
		name = "ship-%d" % int(shown.ship)
		if not written.has("images/%s.png" % name): pixels = cell(library.image("ships"), int(shown.ship), library.data.ship_parts.size())
	elif shown.has("portrait") and not shown.portrait.is_empty():
		name = "face-" + "-".join(shown.portrait.map(func(layer): return str(int(layer))))
		if not written.has("images/%s.png" % name): pixels = face_image(library, shown.portrait)
	elif shown.has("medal"):
		name = "medal-%d" % int(shown.medal)
		var sheet: Image = library.image("medals")
		if sheet != null and not written.has("images/%s.png" % name): pixels = sheet.get_region(Rect2i(int(shown.medal) * 31, 0, 31, mini(15, sheet.get_height())))
	elif shown.has("image"):
		name = str(shown.image).replace("/", "-")
		if not written.has("images/%s.png" % name): pixels = library.image(str(shown.image))
	if name.is_empty(): return ""
	var path := "images/%s.png" % name
	if written.has(path): return path
	if pixels == null: return ""
	pixels = pixels.duplicate(); pixels.convert(Image.FORMAT_RGBA8)
	pixels.resize(pixels.get_width() * ENLARGE, pixels.get_height() * ENLARGE, Image.INTERPOLATE_NEAREST)
	if pixels.save_png(directory.path_join(path)) != OK: return ""
	written[path] = true
	return path

## One cell of a sheet laid out in equal columns.
static func cell(sheet: Image, index: int, columns: int) -> Image:
	if sheet == null or columns <= 0: return null
	var width := sheet.get_width() / columns
	if width <= 0 or index < 0 or index >= columns: return null
	return sheet.get_region(Rect2i(index * width, 0, width, sheet.get_height()))

## An item's icon over the frame of its kind, as the hangar lists draw it
## (Common.item_icon).
static func item_image(library, id: int) -> Image:
	var icon := cell(library.image("items"), id, library.data.items.size())
	if icon == null: return null
	icon.convert(Image.FORMAT_RGBA8)
	var frames: Image = library.image("item_types")
	var kind := int(library.data.items[id].get("attributes", {}).get(str(Catalogue.A_CATEGORY), -1))
	var frame := cell(frames, kind, 5) if kind >= 0 and kind < 5 else null
	if frame == null: return icon
	frame.convert(Image.FORMAT_RGBA8)
	if frame.get_size() != icon.get_size(): icon.resize(frame.get_width(), frame.get_height(), Image.INTERPOLATE_NEAREST)
	frame.blend_rect(icon, Rect2i(Vector2i.ZERO, icon.get_size()), Vector2i.ZERO)
	return frame

## A portrait's face parts layered as Portrait.make lays them, on black.
static func face_image(library, face: Array) -> Image:
	var size := Vector2i(Portrait.FRAME)
	var out := Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)
	out.fill(Color(0, 0, 0, 1))
	var set := int(face[0])
	for i in range(1, face.size()):
		var variant := int(face[i])
		if variant < 0: continue
		var part: Texture2D = library.face("%d_%d_%d" % [set, i - 1, variant])
		if part == null: continue
		var pixels := part.get_image()
		if pixels == null: continue
		pixels = pixels.duplicate(); pixels.convert(Image.FORMAT_RGBA8)
		out.blend_rect(pixels, Rect2i(Vector2i.ZERO, pixels.get_size()), Vector2i(1, 1))
	return out

const INDEX := """<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="apple-mobile-web-app-capable" content="yes">
<title>Galaxy on Fire 2</title>
<link rel="icon" type="image/png" href="app-icon.png">
<link rel="apple-touch-icon" href="app-icon.png">
<link rel="stylesheet" href="wiki.css">
</head>
<body>
<header><a class="brand" href="#home"><span>GoF2</span> <b id="title"></b></a><input id="search" type="search" autocomplete="off"><select id="language"></select><nav id="links"><a id="play" href="%PLAY%"></a><a id="source" href="%SOURCE%">GitHub</a></nav><button id="browse" type="button"></button></header>
<main><nav id="side"><select id="categories"></select><ul id="results"></ul><p id="count"></p></nav>
<div id="sheet"><article id="page" tabindex="-1"></article><aside id="media"></aside></div></main>
<script src="languages.js"></script>
<script src="wiki.js"></script>
</body>
</html>
"""

const STYLE := """:root{--bg:#050b16;--glass:rgba(9,24,46,.94);--card:#0d2340;--card-hi:#1f528e;--line:#2a5d96;--text:#e8f0f8;--dim:#8fa7bb;--faint:#5f7a92;--accent:#4aa3ff;--value:#ffd36a;--f0:#4aa3ff;--f1:#e06a3a;--f2:#6ac764;--f3:#c08cff;font-family:"Noto Sans",system-ui,-apple-system,"Segoe UI",sans-serif}
*{box-sizing:border-box}
html,body{margin:0;height:100%;color:var(--text);background:radial-gradient(ellipse at 50% -20%,#16345c 0,#0a1830 55%,var(--bg) 100%) fixed}
header{display:flex;gap:14px;align-items:center;padding:10px 18px;padding-top:max(10px,env(safe-area-inset-top));border-bottom:1px solid var(--line);background:var(--glass);position:sticky;top:0;z-index:2;min-height:60px}
.brand{color:var(--text);text-decoration:none;white-space:nowrap;letter-spacing:.14em;font-size:15px}
.brand span{color:var(--accent);font-weight:800;letter-spacing:.2em}
.brand b{font-weight:500;color:var(--dim);text-transform:uppercase}
#search{flex:1;min-width:0;max-width:520px;margin-left:auto;padding:9px 12px;border-radius:6px;border:1px solid var(--line);background:var(--card);color:var(--text);font:inherit}
#search:focus{outline:none;border-color:var(--accent);box-shadow:0 0 8px rgba(74,163,255,.35)}
#browse{display:none;padding:8px 12px;border-radius:6px;border:1px solid var(--line);background:var(--card);color:var(--text);font:inherit}
main{display:grid;grid-template-columns:320px 1fr;gap:16px;padding:16px;height:calc(100% - 60px)}
#side{display:flex;flex-direction:column;min-height:0;gap:8px}
#language,#categories{padding:8px 10px;border-radius:6px;border:1px solid var(--line);background:var(--card);color:var(--text);font:inherit}
#language{max-width:170px}
#results{list-style:none;margin:0;padding:4px;overflow:auto;flex:1;border:1px solid var(--line);border-radius:8px;background:rgba(13,35,64,.55)}
#results li.section{color:var(--accent);font-size:12px;letter-spacing:.12em;text-transform:uppercase;padding:10px 8px 4px}
#results a{display:flex;gap:10px;align-items:center;padding:6px 8px;color:var(--text);text-decoration:none;border:1px solid transparent;border-radius:6px;min-height:44px}
#results a:hover{background:rgba(31,82,142,.45);border-color:var(--line)}
#results a.current{background:var(--card-hi);border-color:#6cb4ff}
#links{display:flex;gap:14px;white-space:nowrap;font-size:14px}
#links a{color:var(--dim);text-decoration:none}
#links a:hover{color:var(--accent)}
#results .icon{width:52px;height:32px;flex:none;display:flex;align-items:center;justify-content:center}
#results .icon img{max-width:52px;max-height:32px;image-rendering:pixelated}
#results .icon i{width:12px;height:12px;border:2px solid var(--accent);border-radius:50%;opacity:.6}
#results small{display:block;color:var(--dim);font-size:12px}
#count{margin:0;color:var(--faint);font-size:13px}
#sheet{display:grid;grid-template-columns:minmax(0,860px) minmax(260px,440px);justify-content:center;gap:32px;min-height:0;overflow:auto;padding:22px 26px 60px;border:1px solid var(--line);border-radius:10px;background:rgba(9,24,46,.92);box-shadow:0 0 18px rgba(74,163,255,.12)}
#page{outline:none;line-height:1.6;font-size:16.5px;min-width:0}
#page h1{margin:0 0 2px;font-size:32px;color:var(--accent);font-weight:600}
#page h1+p em{font-style:normal;color:var(--dim);text-transform:uppercase;letter-spacing:.1em;font-size:13px}
#page h2{margin-top:30px;font-size:19px;color:var(--accent);font-weight:600;border-bottom:1px solid var(--line);padding-bottom:4px}
#page a{color:var(--accent);text-decoration-color:rgba(74,163,255,.4)}
#page table{border-collapse:collapse;margin:12px 0;width:100%;font-size:14.5px}
#page th,#page td{border:1px solid var(--line);padding:6px 9px;text-align:left;vertical-align:top}
#page tr:nth-child(odd) td{background:rgba(31,82,142,.18)}
#page th{color:var(--dim);font-weight:600}
#page em{color:var(--dim)}
#page figure.chart{display:none}
#media{position:sticky;top:0;align-self:start;display:flex;flex-direction:column;gap:8px}
#media .frame{border:1px solid var(--line);border-radius:8px;background:rgba(13,35,64,.6);padding:14px;display:flex;align-items:center;justify-content:center;min-height:180px}
#media img{max-width:100%;max-height:260px;image-rendering:pixelated;object-fit:contain}
#media img.sprite{max-height:90px;align-self:center}
#media img.render{image-rendering:auto;max-height:none;width:100%}
#media .frame:has(img.render){padding:0;overflow:hidden;background:radial-gradient(ellipse at 50% 35%,#1c3b66 0%,#0b1a33 55%,#050b16 100%)}
#media figure.chart{margin:0;width:100%}
figure.chart svg{display:block;width:100%;height:auto}
figure.chart line{stroke:var(--line);stroke-width:.4}
figure.chart circle{opacity:.95}
figure.chart circle.dim{opacity:.3}
figure.chart circle.here{stroke:var(--text);stroke-width:.6}
figure.chart text{fill:var(--dim);font-size:2.6px}
figure.chart text.here{fill:var(--text);font-size:3.6px}
figure.chart .f0{fill:var(--f0)}figure.chart .f1{fill:var(--f1)}figure.chart .f2{fill:var(--f2)}figure.chart .f3{fill:var(--f3)}
figure.chart figcaption{font-size:12px;color:var(--dim);padding:6px 0 0;text-align:center}
@media (max-width:1100px){#sheet{grid-template-columns:1fr}#media{position:static;order:-1}#media img{max-height:200px}}
@media (max-width:760px){
header{flex-wrap:wrap;min-height:112px;align-content:center;gap:8px 10px;padding:8px 12px;padding-top:max(8px,env(safe-area-inset-top))}
.brand{margin-right:auto}
#search{order:3;flex:1 0 100%;max-width:none;margin:0;padding:11px 14px;font-size:16px}
#language{max-width:42vw}
main{grid-template-columns:1fr;padding:8px;height:calc(100% - 112px)}
#side{display:none;position:fixed;inset:112px 0 0 0;z-index:3;background:var(--bg);padding:8px}
body.browsing #side{display:flex}
#browse{display:block}
.brand b{display:none}
#links{display:none}
#sheet{padding:16px}
}
"""

const READER := """// Reader for an exported Galaxy on Fire 2 reference. Pages are the
// exporter's escaped HTML; wiki:// links become in-page addresses, so Back
// and Forward work. Each language is its own content file, loaded when chosen.
(() => {
  const langs = window.GOF2_WIKI_LANGUAGES;
  const loaded = window.GOF2_WIKI_LANGS = window.GOF2_WIKI_LANGS || {};
  const page = document.getElementById('page');
  const media = document.getElementById('media');
  const results = document.getElementById('results');
  const search = document.getElementById('search');
  const categories = document.getElementById('categories');
  const language = document.getElementById('language');
  const count = document.getElementById('count');
  let data, byKey, label, order, category = 'all';
  const norm = s => s.toLowerCase().normalize('NFKD').replace(/[\\u0300-\\u036f]/g, '').replace(/ё/g, 'е');
  const score = (q, e) => {
    const t = norm(e.title), x = ' ' + norm(e.title + ' ' + e.subtitle).replace(/[^\\p{L}\\p{N}]+/gu, ' ');
    if (t === q) return 1000; if (t.startsWith(q)) return 800; if (t.includes(q)) return 600;
    return q.split(/\\s+/).every(w => x.includes(' ' + w)) ? 300 : -1;
  };
  const byTitle = (a, b) => a.title.localeCompare(b.title, data.language, {numeric: true});
  const current = () => decodeURIComponent(location.hash.slice(1)) || 'home';
  function row(e, q) {
    const li = document.createElement('li'), a = document.createElement('a'), icon = document.createElement('span'), text = document.createElement('span');
    a.href = '#' + e.key; icon.className = 'icon';
    if (e.icon) { const img = document.createElement('img'); img.src = e.icon; img.alt = ''; icon.append(img); } else icon.append(document.createElement('i'));
    text.textContent = e.title;
    const note = e.subtitle || (q || category === 'all' ? label.get(e.category) : '');
    if (note) { const s = document.createElement('small'); s.textContent = note; text.append(s); }
    if (e.key === current()) a.className = 'current';
    a.append(icon, text); li.append(a); return li;
  }
  function list() {
    const q = norm(search.value.trim());
    let rows = data.index.filter(e => e.category);
    if (q) rows = rows.map(e => [score(q, e), e]).filter(r => r[0] >= 0).sort((a, b) => b[0] - a[0] || byTitle(a[1], b[1])).map(r => r[1]);
    else {
      if (category !== 'all') rows = rows.filter(e => e.category === category);
      rows = [...rows].sort((a, b) => order.indexOf(a.category) - order.indexOf(b.category) || (a.category === 'story' ? 0 : byTitle(a, b)));
    }
    const items = []; let section = '';
    for (const e of rows) {
      if (!q && category === 'all' && e.category !== section) {
        section = e.category; const h = document.createElement('li'); h.className = 'section'; h.textContent = label.get(section); items.push(h);
      }
      items.push(row(e, q));
    }
    results.replaceChildren(...items);
    count.textContent = rows.length + ' / ' + data.index.filter(e => e.category).length;
    const here = results.querySelector('a.current'); if (here) here.scrollIntoView({block: 'nearest'});
  }
  // Every system at its map position with its jump gate links, coloured by
  // faction; the page's own system ringed and named.
  function chart(figure, faction) {
    const ns = 'http://www.w3.org/2000/svg', svg = document.createElementNS(ns, 'svg');
    const here = Number(figure.dataset.highlight);
    svg.setAttribute('viewBox', '10 5 100 85');
    data.systems.forEach(([x, y, f, links], id) => links.forEach(other => {
      if (other <= id) return;
      const [x2, y2] = data.systems[other], line = document.createElementNS(ns, 'line');
      line.setAttribute('x1', x); line.setAttribute('y1', y); line.setAttribute('x2', x2); line.setAttribute('y2', y2); svg.append(line);
    }));
    data.systems.forEach(([x, y, f], id) => {
      const a = document.createElementNS(ns, 'a'), dot = document.createElementNS(ns, 'circle'), name = document.createElementNS(ns, 'title'), text = document.createElementNS(ns, 'text');
      const title = (byKey.get('system/' + id) || {}).title || '';
      a.setAttribute('href', '#system/' + id);
      dot.setAttribute('class', 'f' + f + (id === here ? ' here' : '') + (faction >= 0 && f !== faction ? ' dim' : ''));
      dot.setAttribute('cx', x); dot.setAttribute('cy', y); dot.setAttribute('r', id === here ? 2.4 : 1.5);
      name.textContent = title; dot.append(name);
      text.setAttribute('x', x + 2.4); text.setAttribute('y', y + 1); text.textContent = title;
      if (id === here) text.setAttribute('class', 'here');
      a.append(dot, text); svg.append(a);
    });
    const caption = document.createElement('figcaption'); caption.textContent = data.map;
    const out = document.createElement('figure'); out.className = 'chart'; out.append(svg, caption); return out;
  }
  function show() {
    const key = current(), entry = byKey.get(key);
    page.innerHTML = (data.pages[key] || data.pages.home).replace(/wiki:\\/\\//g, '#');
    media.replaceChildren();
    const figure = page.querySelector('figure.chart'), src = data.media[key];
    if (src) {
      const frame = document.createElement('div'); frame.className = 'frame';
      const img = document.createElement('img'); img.src = src; img.alt = entry ? entry.title : ''; if (src.includes('/render-')) img.className = 'render';
      frame.append(img); media.append(frame);
      if (data.sprites && data.sprites[key]) { const sprite = document.createElement('img'); sprite.src = data.sprites[key]; sprite.alt = ''; sprite.className = 'sprite'; media.append(sprite); }
    }
    const faction = key.startsWith('faction/') ? Number(key.split('/')[1]) : -1;
    if (figure || ['home', 'chart', 'world/galaxy', 'world/history'].includes(key) || (faction >= 0 && faction < 4)) {
      const frame = document.createElement('div'); frame.className = 'frame';
      frame.append(chart(figure || {dataset: {highlight: -1}}, faction)); media.append(frame);
    }
    media.hidden = !media.childElementCount;
    document.title = (entry ? entry.title + ' · ' : '') + 'Galaxy on Fire 2 ' + data.title;
    document.body.classList.remove('browsing');
    list(); document.getElementById('sheet').scrollTop = 0; page.focus({preventScroll: true});
  }
  function load(code, then) {
    if (loaded[code]) return then(code);
    const script = document.createElement('script');
    script.src = 'content-' + code + '.js';
    script.onload = () => then(loaded[code] ? code : langs.first);
    script.onerror = () => code === langs.first ? null : load(langs.first, then);
    document.head.append(script);
  }
  function use(code) {
    load(code, found => {
      data = loaded[found]; language.value = found;
      try { localStorage.setItem('gof2-reference-language', found); } catch (e) {}
      byKey = new Map(data.index.map(e => [e.key, e]));
      label = new Map(data.categories); order = data.categories.map(c => c[0]);
      document.documentElement.lang = found;
      document.getElementById('title').textContent = data.title;
      search.placeholder = data.search; search.setAttribute('aria-label', data.search);
      document.getElementById('browse').textContent = data.browse;
      document.getElementById('play').textContent = data.play;
      const options = [];
      for (const [name, title] of [['all', data.all], ...data.categories]) {
        if (name !== 'all' && !data.index.some(e => e.category === name)) continue;
        const o = document.createElement('option'); o.value = name; o.textContent = title; options.push(o);
      }
      categories.replaceChildren(...options);
      if (!options.some(o => o.value === category)) category = 'all';
      categories.value = category;
      show();
    });
  }
  for (const [code, name] of langs.list) {
    const o = document.createElement('option'); o.value = code; o.textContent = name; language.append(o);
  }
  language.setAttribute('aria-label', langs.label); language.title = langs.label;
  language.hidden = langs.list.length < 2;
  language.onchange = () => use(language.value);
  categories.onchange = () => { category = categories.value; search.value = ''; list(); };
  search.addEventListener('input', () => { document.body.classList.add('browsing'); list(); });
  document.getElementById('browse').onclick = () => document.body.classList.toggle('browsing');
  window.addEventListener('hashchange', show);
  let stored = null;
  try { stored = localStorage.getItem('gof2-reference-language'); } catch (e) {}
  use(langs.list.some(l => l[0] === stored) ? stored : langs.first);
})();
"""
