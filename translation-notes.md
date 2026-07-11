# Translation notes

Context for the locale revision. The English root locale was reworked so the four
turbine tiers form a **size progression modeled on vanilla Factorio**, rather than
the old ad-hoc "windmill / generator / turbine" scheme:

| key                   | old EN        | new EN               | vanilla anchor        |
|-----------------------|---------------|----------------------|-----------------------|
| texugo-wind-turbine   | Windmill      | Wooden wind turbine  | Wooden chest          |
| texugo-wind-turbine2  | Wind generator| Medium wind turbine  | Medium electric pole  |
| texugo-wind-turbine3  | Wind turbine  | Big wind turbine     | Big electric pole     |
| texugo-wind-turbine4  | Giant …       | Giant wind turbine   | (no vanilla analog)   |

Translators should reuse the size adjectives exactly as the official vanilla locale
renders them (Wooden chest / Medium electric pole / Big electric pole), adjusted for
the gender of the local word for "turbine". "Giant" has no vanilla tier, so pick a
term consistent with the language's own "big/large" word.

All official terms cited in these notes were pulled directly from the deployed base
game locale files (Factorio 2.1.9, `base.cfg` per language), not from web searches or
the wiki — those sometimes give inconsistent terms, or terms that have changed over
the course of development.

English is the source language. German and French were human-translated; the remaining
locales were machine-translated with an earlier engine. The revised strings in this
pass are a machine translation by Claude Opus 4.8. The notes below record only
programmatic bugs found in the earlier strings and choices that a non-native but
proficient reviewer would want explained — routine rewording to track the reworked
English is not itemized.

A later pass added brand-new locales that had no prior version — **bg, ca, da, eo, hr,
id, pt-PT, ro, sk, sl, sr** — machine-translated by Claude Opus 4.8 directly onto the
vanilla anchors. Their notes explain only non-obvious choices, since there were no
pre-existing strings to debug. Candidates were limited to languages whose vanilla
`base.cfg` supplies the size adjectives and that could be rendered at near-native
quality. Base locale data now lives at `../factorio-locale/base/locale`. English notes
use US spelling, matching Factorio's own development dialect.

---

## bg (Bulgarian)

Noun: *вятърна турбина* (fem.), adjective precedes. Anchors: Дървен→**Дървена** /
Средноголям→**Средноголяма** / Голям→**Голяма**; Giant → **Гигантска**.
Tiers: Дървена / Средноголяма / Голяма / Гигантска вятърна турбина.

- New locale. Vanilla's medium pole is **Средноголям** ("medium-large"), not a plain
  "medium"; kept verbatim (feminine **Средноголяма**) so the ladder matches what
  Bulgarian players see in-game, even though it reads as *medium-large* sitting just
  below **Голяма**.

---

## ca (Catalan)

Noun: *turbina eòlica* (fem.), adjective follows. Anchors: de fusta / mitjà→**mitjana**
/ gran; Giant → **geganta**. Tiers: Turbina eòlica de fusta / mitjana / gran / geganta.

- New locale. *gran* ("big") is gender-invariant; *mitjà*→**mitjana** and
  *gegant*→**geganta** take the feminine to agree with *turbina*.

---

## cs (Czech)

Noun: *turbína* (feminine). Anchors: Dřevěná / Střední / Velký→**Velká**.
Tiers: Dřevěná / Střední / Velká / Obří větrná turbína.

- **CLASSICAL: `antický` → `klasický`.** `antický` means "of classical antiquity /
  antique" (Greco-Roman), not the intended "original/default" sense.
- **`turbine4` name: imperative `Aktivujte…` → infinitive `Povolit…`.** A setting name
  is a label, not a 2nd-person command.
- **`entity-description`: `se měnil` → `kolísá v čase`.** Old form was past tense and
  agreed with an implicit masculine subject; `kolísá` is present and idiomatic for power.
- **`turbine4` desc: `počítače nižší třídy` ("lower-class computers") → `slabší
  počítače`.**

---

## da (Danish)

Noun: *vindturbine* (common gender). "Wooden" compounds (vanilla `Trækiste`), so tier 1
is a single compound while the others read adjective + noun. Anchors:
Træ-→**Trævindturbine** / Mellem→**Mellemstor** / Stor; Giant → **Kæmpe**.
Tiers: Trævindturbine / Mellemstor / Stor / Kæmpe vindturbine.

- New locale. Vanilla's medium pole is bare **Mellem** ("middle"); used **Mellemstor**
  ("medium-sized"), the natural Danish size adjective, since *Mellem vindturbine* would
  read as "middle turbine" rather than a size.

---

## de (German)

Human-translated. Noun standardized on *Windturbine* (fem.); the old file mixed
`Windmühle` / `Wind Generator` / `Windrad`, which can't express a size ladder.
Anchors: `Holzkiste`→**Hölzern** (adjective form, not a `Holz-` compound, for
parallelism) / Mittelgroß / Groß; Giant → **Riesig** (natural step above `Groß`; old
`gigantisch` was fine but off the vanilla-adjacent register).
Tiers: Hölzerne / Mittelgroße / Große / Riesige Windturbine.

- **`wind-power` desc: typo `Energieprodukion` → `Energieproduktion`.** (Only genuine
  bug; the rest of the German was sound.)

---

## el (Greek)

Noun standardized on *ανεμογεννήτρια* (fem.). The Greek base locale distinguishes
electric poles by **noun**, not by a size adjective, so only "Wooden" has a usable
adjective anchor (`Ξύλινο`→**Ξύλινη**); Medium/Big fall back to **Μεσαία** / **Μεγάλη**;
Giant keeps **Γιγάντια**. Tiers: Ξύλινη / Μεσαία / Μεγάλη / Γιγάντια ανεμογεννήτρια.

- **`turbine4` desc: `ανεμοστρόβιλος` was flat wrong** — it means "whirlwind / tornado",
  not a wind turbine. The line was rewritten without the erroneous noun.
- **Terminology unified `στρόβιλος` → `ανεμογεννήτρια`.** The settings used generic
  `στροβίλου`/`στροβίλων` inconsistently with the entity names (`turbine4` name,
  `expensive-recipes` desc).
- **Gender: `Ανθεκτικός` / `Πολύ ανθεκτικός` → `Ανθεκτική` / `Πολύ ανθεκτική`.** The
  durability tags were masculine while the noun is feminine (the old file even paired
  masculine `Ανθεκτικός` with a feminine tier name).
- **CLASSICAL orthography: `κλασσικός` → `κλασικός`** (standard modern single-sigma;
  meaning was already correct).

---

## eo (Esperanto)

Noun: *venta turbino* (no gender). Anchors: Ligna / Meza / Granda; Giant → **Giganta**.
Tiers: Ligna / Meza / Granda / Giganta venta turbino.

- New locale. Each size word takes the nominative adjective ending *-a* agreeing with
  *turbino*; nothing irregular.

---

## es-ES (Spanish, Spain)

Noun: *turbina eólica* (fem.), adjective follows. Anchors: de madera / mediana / grande.
Tiers: Turbina eólica de madera / mediana / grande / gigante.

- **Broken escape `\Duradera` → `\nDuradera`** (turbine3) — the tag would otherwise
  render glued to the previous line with a stray backslash.
- **Copy-paste bug: `SURFACE` description duplicated the `CLASSICAL` text.** Replaced
  with the correct `Cada superficie tiene su propia fuerza de viento (aleatoria)`.
- **Latin-American vocabulary in an es-ES (Spain) locale:** `computadoras` →
  `ordenadores`; `costos` → `costes`.
- **`alerts`: `Modo viento` → `Modo de viento`** (the noun phrase needs the `de`).

---

## fi (Finnish)

Noun standardized on *tuuliturbiini*. Anchors: Keskisuuri / Suuri; "wooden" is the
compound `Puu-` in vanilla, but **Puinen** (adjective) is used to parallel the other
tiers; Giant keeps **Jättimäinen**. Tiers: Puinen / Keskisuuri / Suuri / Jättimäinen
tuuliturbiini.

- **Untranslated English "Giant" left in two settings** (`Ota Giant-turbiini…`, `Salli
  Giant-tuuliturbiinin…`) → `jättimäinen` + unified noun `tuuliturbiini`.
- **`entity-description` tense: `vaihteli` (past) → `vaihtelee` (present).**
- **`turbine4` desc: `halvemmissa` ("cheaper") → `heikkotehoisissa`
  ("low-performance")** — what "low-end" actually means.

---

## fr (French)

Human-translated. Noun: *éolienne* (fem.). French adjective placement is not uniform,
so each size term sits where it naturally reads. Anchors: `Coffre en bois`→**en bois**
(follows noun); `Grand`→**Grande** (precedes noun); there is **no vanilla "medium"
adjective** (`Poteau électrique` is the unmarked default), so Medium falls back to
**moyenne**; Giant keeps **géante**. Tiers: Éolienne en bois / Éolienne moyenne / Grande
éolienne / Éolienne géante — `Grande` must lead, since `Éolienne grande` is ungrammatical.

- **`entity-description` tense: `varié` (past participle) → `varie` (present).** (Only
  genuine bug; the rest was English-cascade rewording.)

---

## hr (Croatian)

Noun: *vjetroturbina* (fem., a single compound). Anchors: Drvena / Srednji→**Srednja** /
Veliki→**Velika**; Giant → **Divovska**.
Tiers: Drvena / Srednja / Velika / Divovska vjetroturbina.

- New locale. Vanilla poles are masculine (*Srednji*/*Veliki stup*), so the anchor
  adjectives were re-inflected to the feminine to agree with *vjetroturbina*.

---

## hu (Hungarian)

Noun: *szélturbina* (no grammatical gender). Anchors: Fa / Közepes / Nagy; Giant keeps
**Óriás**. Tiers: Fa / Közepes / Nagy / Óriás szélturbina.

- No programmatic bugs. Changes were noun unification (`turbina` → `szélturbina` in the
  `turbine4` name) and routine English-cascade rewording.

---

## id (Indonesian)

Noun: *turbin angin* (no gender; modifiers follow). Anchors: kayu / Sedang→sedang /
Besar→besar; Giant → **raksasa**. Tiers: Turbin angin kayu / sedang / besar / raksasa.

- New locale. *kayu* ("wood") follows the noun attributively, matching vanilla *Peti
  kayu*. Vanilla title-cases the pole sizes (*Sedang*/*Besar*); lower-cased here since
  they sit mid-name.

---

## it (Italian)

Noun: *turbina eolica* (fem.), adjective follows. Anchors: di legno / media / grande.
Tiers: Turbina eolica di legno / media / grande / gigante.

- **`turbine4` name capitalization:** `Turbina eolica gigante` mid-sentence →
  lowercase common noun.
- **`SURFACE+PRESSURE` opening had drifted to `intensità del vento`** while SURFACE used
  `forza del vento`; unified on `forza del vento`.

---

## ja (Japanese)

Noun standardized on *風力タービン*; the old file used four unrelated nouns (風車 /
風力発電機 / 風力タービン / 大型風力原動機). Anchors: 木製 / 中型 / 大型; Giant uses
**巨大** so it stays distinct from Big's 大型 (the old file reused 大型 for tier 4 →
collision). Tiers: 木製 / 中型 / 大型 / 巨大風力タービン.

- **`wind-power` desc: garbage Latin prefix** — `Eneエネルギー生産乗数`; the stray `Ene`
  was removed. Also `KW` → `kW`.
- **Missing durability tags.** English tiers 3–4 end in `\nDurable` / `\nVery durable`;
  the Japanese omitted them. Added `\n頑丈` / `\n非常に頑丈`.

---

## ko (Korean)

Noun: *풍력 터빈* (no grammatical gender). Anchors: 나무 / 중형 / 대형; Giant keeps
**거대한**. Tiers: 나무 / 중형 / 대형 / 거대한 풍력 터빈.

- **Broken escape `\매우` → `\n매우`** (turbine4) — the "Very durable" tag would render
  glued to the previous line.
- **Durability tags unified:** adjectival `튼튼한` and noun phrase `매우 내구성` →
  `튼튼함` / `매우 튼튼함`.
- **Transliterated "Giant":** `자이언트 터빈 활성화` → `거대한 풍력 터빈 활성화`.
- **`entity-description`: `다양합니다` → `변동합니다`.** `다양하다` means "to be diverse
  / of many kinds", the wrong sense of "vary"; `변동하다` = "to fluctuate".
- **Terminology: `풍속` (wind *speed*) → `바람 강도` (wind *strength*)** in the
  `wind-mode` name, matching the English "wind strength" and the `wind-power` name.
- **CLASSICAL: `전통적인` ("traditional") → `클래식`.**
- **`alerts`: imperative → statement.** `설정하세요` ("please set") fires *after* the
  mode changes → `설정되었습니다` ("has been set").

---

## nl (Dutch)

Noun: *windturbine* (common gender). Entity names recapitalized (tiers 3–4 were
lower-case). Anchors: Houten / Gemiddelde / Grote; Giant keeps **Gigantische**.
Tiers: Houten / Gemiddelde / Grote / Gigantische windturbine.

- **Stray English `The` in `expensive-recipes` desc** (`The De bouw…`) removed.
- **`entity-description` tense: `varieerde` (past) → `varieert` (present).**

---

## no (Norwegian)

Noun: *vindturbin* (common gender). "Wooden" genuinely compounds (vanilla `Trekiste`),
so tier 1 is a single compound while the others read adjective + noun. Anchors:
Tre-→**Trevindturbin** / Middels / Stor; Giant keeps **Gigantisk**. Tiers: Trevindturbin
/ Middels / Stor / Gigantisk vindturbin.

- **"low-end" mistranslated as its opposite:** `for avanserte datamaskiner` ("for
  *advanced* computers") → `for datamaskiner med lav ytelse`.
- **Transliterated "Giant":** `Aktiver Giant-turbinen` → `Aktiver den gigantiske
  vindturbinen`.
- **`entity-description` tense: `varierte` (past) → `varierer` (present).**
- **`SURFACE` value: `flate` → `overflate`** (the SURFACE+PRESSURE value and both
  descriptions already used `overflate`).

---

## pl (Polish)

Noun: *turbina wiatrowa* (fem.), adjective precedes. Anchors: Drewniana / Średnia / Duża;
Giant keeps **Gigantyczna**. Tiers: Drewniana / Średnia / Duża / Gigantyczna turbina
wiatrowa.

- **Untranslated English durability tags** `\nDurable` / `\nVery durable` →
  `Wytrzymała` / `Bardzo wytrzymała` (feminine).

---

## pt-BR (Portuguese, Brazil)

Noun: *turbina eólica* (fem.), adjective follows. Anchors: de madeira / média / grande.
Tiers: Turbina eólica de madeira / média / grande / gigante.

- **Stray English `is` in every `entity-description`** (`Média de longo prazo is 45 kW`)
  → `é`.
- **Broken escape `\Durável` → `\nDurável`** (turbine3).
- **`entity-description` tense: `variou` (preterite) → `varia` (present).**
- **`turbine4` desc: `baixo custo` ("low-*cost*") → `baixo desempenho`
  ("low-*performance*")** for "low-end".
- **`SURFACE+PRESSURE` opening had drifted to `força eólica`** while SURFACE used `força
  de vento`; unified on `força do vento`.

---

## pt-PT (Portuguese, Portugal)

Noun: *turbina eólica* (fem.), adjective follows. Anchors: de madeira / médio→**média** /
grande; Giant → **gigante**. Tiers: Turbina eólica de madeira / média / grande / gigante.

- New locale, kept distinct from pt-BR by European vocabulary and orthography:
  *predefinição* (not *padrão*) for "default", *de gama baixa* for "low-end", and the
  current-agreement forms *fator*/*ativar*. (Vanilla's own pt-PT still uses pre-agreement
  *eléctrico*, but that word does not appear in these strings.)

---

## ro (Romanian)

Noun: *turbină eoliană* (fem.), adjective follows. Anchors: din lemn / mediu→**medie** /
mare; Giant → **gigantică**. Tiers: Turbină eoliană din lemn / medie / mare / gigantică.

- New locale. *mare* ("big") is gender-invariant; *mediu*→**medie** and
  *gigantic*→**gigantică** take the feminine.

---

## ru (Russian)

Noun: *ветряная турбина* (fem.), adjective precedes. Anchors: Деревянная / Средняя /
Большая; Giant keeps **Гигантская**. Tiers: Деревянная / Средняя / Большая / Гигантская
ветряная турбина.

- **Gender on durability tags: `Прочный` / `Очень прочный` (masc.) → `Прочная` / `Очень
  прочная` (fem.).**
- **`entity-description` capitalization:** lines began lower-case then capitalized the
  verb mid-sentence (`, Изменяется`) → `Максимум …, изменяется …`.
- **`turbine4` name:** `гигантскую турбину` → `гигантскую ветряную турбину` (noun
  unified).

---

## sk (Slovak)

Noun: *veterná turbína* (fem.), adjective precedes. Anchors: Drevená / Stredný→**Stredná**
/ Veľký→**Veľká**; Giant → **Obria**. Tiers: Drevená / Stredná / Veľká / Obria veterná
turbína.

- New locale, closely parallel to the Czech file. Vanilla pole adjectives are masculine
  (*Stredný*/*Veľký stĺp*); re-inflected to feminine for *turbína*. **Obria** is the
  feminine of *obrí* ("giant").

---

## sl (Slovenian)

Noun: *vetrna turbina* (fem.). Anchors: Lesena / Srednji→**Srednja** / Velik→**Velika**;
Giant → **Velikanska**. Tiers: Lesena / Srednja / Velika / Velikanska vetrna turbina.

- New locale. Vanilla pole adjectives (masc. *Srednji*/*Velik drog*) re-inflected to
  feminine. "Giant" → **Velikanska**, one clear step above **Velika**.

---

## sr (Serbian)

Noun: *ветротурбина* (fem.), Cyrillic. Anchors (Cyrillic base): Дрвени→**Дрвена** /
Средња / Велика; Giant → **Џиновска**.
Tiers: Дрвена / Средња / Велика / Џиновска ветротурбина.

- New locale, the Croatian file mirrored into Cyrillic. Vanilla names the pole with the
  colloquial *бандера*; only the size adjectives were borrowed (re-inflected feminine),
  while the noun itself is *ветротурбина*.

---

## sv-SE (Swedish)

Noun: *vindturbin* (common gender). "Wooden" compounds (vanilla `Träkista`), so tier 1
is a single compound. Anchors: Trä-→**Trävindturbin** / Medelstor / Stor; Giant uses
**Gigantisk** (old file had `Jätte vindkraftverk`). Tiers: Trävindturbin / Medelstor /
Stor / Gigantisk vindturbin.

- **`entity-description`: `varieras` (passive, "is varied") → `varierar` (active,
  "varies").**
- **Durability number agreement:** tier 4 plural `Mycket hållbara` → singular `Mycket
  hållbar` (tier 3 was already singular).
- **Transliterated "Giant":** `Aktivera Giant-turbinen` → `Aktivera den gigantiska
  vindturbinen`.
- **`turbine4` desc: `lågpris` ("low-*price*") → `lågpresterande` ("low-*performing*")**
  for "low-end".
- **`SURFACE+PRESSURE`: malformed noun `Energiutavkastning` → `Effekten`.**

---

## tr (Turkish)

Noun: *rüzgar türbini* (no grammatical gender; the size word precedes). Anchors: Tahta /
Büyük; there is **no vanilla "medium" adjective** (`Elektrik direği` is the unmarked
default), so Medium falls back to **Orta boy**; Giant keeps **Dev**. Tiers: Tahta / Orta
boy / Büyük / Dev rüzgar türbini.

- No programmatic bugs. Changes were noun unification (`türbini` → `rüzgar türbinini` in
  the `turbine4` name) and routine English-cascade rewording.

---

## uk (Ukrainian)

Noun: *вітрова турбіна* (fem.), adjective precedes. Entity names recapitalized (were
lower-case). Anchors (`uk/base.cfg`): Дерев'яна / Середня / Велика; Giant keeps
**Гігантська**. Tiers: Дерев'яна / Середня / Велика / Гігантська вітрова турбіна.

- **Stray Latin `V` before the tier-4 tag** (`\nVдуже…`) removed; the awkward
  `тривалого користування` ("of long-term use") tags → `Довговічна` / `Дуже довговічна`.
- **Stray Latin `E` at the start of `SURFACE+PRESSURE` desc** (`EКожна…`) removed.
- **`turbine4` name: imperative `Увімкніть` → infinitive `Увімкнути`** (label, not
  command); noun unified (`турбіну` → `вітрову турбіну`).
- **Setting labels capitalized:** `wind-power` name (`фактор→Фактор`), `wind-power` desc
  (`множник→Множник`) and `expensive-recipes` name (`вищі→Вищі`) began lower-case,
  unlike the other labels.

---

## zh-CN / zh-TW (Chinese, Simplified / Traditional)

No separate pass. Both Chinese locales were revised in the same commit that reworked the
English root locale, so they already reflect the new size-ladder scheme and wording.
