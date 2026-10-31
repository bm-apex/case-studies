# Case Studies redesign: shared brief for every version file

Apex Mind is a subscription sales-workforce company (Pune). `../5.0.html` is the full site prototype; its
Case Studies page is the source of truth for content and structure. Each `vN-*.html` file in this folder is a
standalone redesign of that page (listing + full case-study pages) in a different visual style.

## Files and data
- Your output is ONE standalone HTML file in `test-ui-casestudy/`. Edit no other file.
- Never copy or edit the data by hand. Put these two lines just before your page `<script>`:
  ```
  <!-- DATA:START -->
  <!-- DATA:END -->
  ```
  then run `sh build-data.sh <your-file>.html` (Git Bash, from `test-ui-casestudy/`). It inlines
  `src/casestudy-data.js` between the markers. Pass only your own file name.
- The data block declares these globals. Do NOT redeclare any of them:
  `esc, FOOT, GROUPS, CASES, INSIGHTS, META, MIXC, DET, mn, OVERALL, SITE, siteHref, VIDEOS, videoEmbed, videoCaption`.
- Shapes:
  - `CASES[i]`: `{g, n (client name), s (short code), id?, d? (detail object), head (story headline), tags[], m: [[value,label]] (up to 4 result tiles, may be empty), loc, featured? (MITSDE only)}`. Cases without `d` (the combined online-universities card) have no detail page.
  - `META[s]`: `{loc, prog?, fee?, mix:{elite?,prime?,alpha?}}` (mix values are %).
  - `d`: `{id, s, name, tags, headline, sub, snap: [[label,text]] x4, tiles: [[value,label]] (may be empty), chIntro, ch: [[title,text]], apIntro, ap: [[title,text]], insight:{t, x, src?}, why: [text]}`.
  - `GROUPS[i]`: `{id, name, c, s}`; `c`/`s` are CSS custom-property names (e.g. `"--prime"`). Your `:root` must define
    `--elite --prime --alpha --brand-2 --gold-text` plus `--elite-soft --prime-soft --alpha-soft --sunk --gold-soft`.
  - `MIXC = {elite:["Elite","--elite"], prime:["Prime","--prime"], alpha:["Alpha","--alpha"]}`.
  - `INSIGHTS`: `[[iconKey, title, text]]` x6 (icon keys: clock, users, trophy, phone, check, chart: draw your own inline SVGs).
  - `OVERALL`: `[[value,label]]` x6. `FOOT`: footnote string. `mn(v)` turns a leading "-" into a true minus. `esc(s)` HTML-escapes: escape every data string you render.
  - `SITE`: header, footer, closing-banner and note copy (read the end of `src/casestudy-data.js`). `siteHref("#about")` -> `../5.0.html#about`.
  - `VIDEOS[id].src`, `videoEmbed(id,title)` (player markup or `""`), `videoCaption(id)` (speaker line or `""`). `VIDEOS.reel` is for the listing page.

## Required structure (from the website content document, mirrors 5.0.html)
- **Header**: ApexMind wordmark (links to `SITE.home`), menu `SITE.nav` via `siteHref` (Case Studies = this page, `href="#"`, `aria-current="page"`), gold "Book an appointment" button (`SITE.book`). Below ~900px collapse the menu behind an accessible menu button.
- **Listing** (`#` / empty hash): eyebrow "Case studies", h1 `SITE.intro.h`, sub `SITE.intro.p`; six `OVERALL` tiles; filter tabs "All" + each group (`g.name` without `"Education · "`) as `<button aria-pressed>`; case cards. Each card: client name, **gold location badge**, tags, story headline, programmes and average annual fee (when `META` has them), up to four result tiles (`c.m`), **team deployment bar** (Elite/Prime/Alpha %, with legend), "Read the full case study" button only when `c.d`. **MITSDE (`featured`) is a full-width featured card.** Then `FOOT + " " + SITE.permission`, and `SITE.draft` as a small dashed draft note. A **video testimonial slot** for `VIDEOS.reel`. The insights band (`SITE.insightsHead` + `INSIGHTS`). Closing banner (`SITE.closing.h`, `SITE.closing.p`, buttons "Book an appointment" -> `SITE.book` and "Build your team" -> `SITE.build`). Footer.
- **Case page** (`#case/<id>`): back link "← All case studies" · hero (category = group name, location badge, client name as h1, `d.headline`, `d.sub`, tags) · facts panel (location highlighted, programmes, average annual fee, team deployment bar with % labels) · four snapshot cards (`d.snap`) · results (`d.tiles` through `mn()`; if empty show `SITE.noResults`) + `SITE.growthNote` · The challenge (`d.chIntro` + `d.ch`) · How Apex Mind helped as numbered steps (`d.apIntro` + `d.ap`) · Insight (`d.insight`, with `src` small when present) · **video testimonial slot** for that case id · Why it worked (`d.why`) · More case studies (every other case with `d`: name + `d.headline.split(":")[0]`) · closing banner (`SITE.closing.h`, `SITE.closing.pCase`) · footer.
- **Footer**: wordmark, `SITE.tagline`, `SITE.org` + `SITE.address`; columns `SITE.cols` (links via `siteHref`); "Reach us": email, phone, LinkedIn; legal row `SITE.legal` + `SITE.policies` + a link "All styles" -> `index.html`.
- **Router**: listen to `hashchange`; `#case/<id>` renders the case page, anything else the listing; scroll to top; on case pages focus `<main>`; set `document.title`.
- **Testing hooks (required)**: the container is `<main id="view" tabindex="-1">`; render functions are top-level `function list()` and `function detail(c)` returning HTML strings; any post-render wiring is a top-level `function afterRender(c)` (c undefined for the listing). The reviewer calls `view.innerHTML = detail(CASES.find(x => x.id === "aoe")); afterRender(CASES.find(...))` directly.

## Video testimonial slot
A 16:9 frame with `data-video="<id>"`. If `videoEmbed(id, title)` returns markup, place it in the frame (style `iframe, video {width:100%; height:100%; border:0}`). Otherwise a designed placeholder in the page's style: inline-SVG play icon, the label "Video testimonial", the line "Hear from <client> in their own words. Coming soon." (listing reel: "Hear from our partners in their own words. Coming soon."), and a small "Placeholder" tag. Below the frame, `videoCaption(id)` when non-empty.

## Content rules (hard)
- Never show how many clients or case studies there are: no counts on filters, no "12 stories", no "Case 3 of 12", no numbered client lists, no result counts in search.
- Never show the number of sales experts deployed per client.
- Say "sales expert", never "counsellor".
- Do not invent figures, quotes, testimonials, names or charts that imply data the page does not have. Team-mix percentages and the listed result tiles are the only quantitative data.
- AI-flavoured UI must be honest: a keyword search may look like a prompt bar, but say it searches the case studies; a summary assembled from the data is a "Case brief", not "AI-generated".

## Quality bar
- Semantic HTML, visible `:focus-visible`, 44px touch targets, text contrast >= 4.5:1 (3:1 for large text), inline SVG icons (no emoji).
- Responsive from 375px to 1440px with no horizontal page scroll (test logic mentally: grids collapse, long client names wrap).
- `prefers-reduced-motion: reduce` turns off all animation, tilt and canvas motion (render a static frame).
- Motion is subtle and cheap: animate transform/opacity only; pause any canvas loop when the tab is hidden or the canvas is off-screen; cap devicePixelRatio at 2.
- Fonts from Google Fonts only. Avoid Inter, Roboto, Space Grotesk, Plus Jakarta Sans, Fraunces, Geist (the design linter flags them as overused). No external JS or CDN libraries: 3D comes from CSS transforms or `<canvas>` 2D projection. The file must work opened directly from disk (`file://`).
- Brand: deep purple #3D2766, gold #C9A43A; Elite green #2F7D5B, Prime purple #5B3F96, Alpha gold #A17C15. Stay recognisably Apex Mind; avoid the stock "AI purple-to-cyan neon gradient" look.
- Write code that reads like `v2-bento-dark.html` in this folder (compact CSS, template-literal render functions, short comments only where useful). Read that file for patterns before starting.

## Before you finish
1. `sh build-data.sh <your-file>.html`
2. Lint: `"C:/Users/ApexMind/.claude/plugins/cache/impeccable/impeccable/4.8.0/skills/impeccable/scripts/impeccable" detect <your-file>.html` and fix real issues.
3. There is no Node or Python here, so re-read your script for: balanced backticks and `${}`, every function defined, no redeclared data globals, no `const` used before definition. Do not use the browser pane (other builders share it); the reviewer will test in the browser.
4. Report: the file name, the design system (palette, fonts, signature 3D/AI elements), and anything you could not do.
