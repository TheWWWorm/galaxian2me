// Reader for an exported Galaxy on Fire 2 reference. Pages are the
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
  const norm = s => s.toLowerCase().normalize('NFKD').replace(/[\u0300-\u036f]/g, '').replace(/ё/g, 'е');
  const score = (q, e) => {
    const t = norm(e.title), x = ' ' + norm(e.title + ' ' + e.subtitle).replace(/[^\p{L}\p{N}]+/gu, ' ');
    if (t === q) return 1000; if (t.startsWith(q)) return 800; if (t.includes(q)) return 600;
    return q.split(/\s+/).every(w => x.includes(' ' + w)) ? 300 : -1;
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
    page.innerHTML = (data.pages[key] || data.pages.home).replace(/wiki:\/\//g, '#');
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
