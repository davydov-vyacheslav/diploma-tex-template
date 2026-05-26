# Шаблон магістерської роботи — Overleaf + Markdown

## Структура проєкту

```
├── thesis_info.tex   ★ ТІЛЬКИ ЦЕЙ ФАЙЛ ЗАПОВНЮВАТИ
├── main.tex          — структура (не чіпати)
├── unithesis.sty     — стиль    (не чіпати)
├── references.bib    — додавати джерела
├── latexmkrc         — конфігурація збірки
├── .vscode/
│   └── settings.json — налаштування VSCode (LaTeX Workshop)
├── tools/
│   └── check.sh      — перевірка перед компіляцією
├── images/           — кидати рисунки (.png .pdf .jpg)
├── snippets/         — складний LaTeX (lstlisting, tikz)
└── chapters/
    ├── 00_intro.md        вступ (вільна частина)
    ├── 01_chapter.md      розділ 1
    ├── 02_chapter.md      розділ 2
    ├── 03_chapter.md      розділ 3
    ├── 00_conclusions.md  висновки
    └── appendix_a.md      додаток А
```

---

## Перед першою компіляцією — заповніть `thesis_info.tex` і запустіть перевірку

```bash
bash tools/check.sh
```

Скрипт перевіряє:

- усі placeholder-и в `thesis_info.tex` замінено,
- усі ключові файли/директорії на місці,
- немає невикористаних зображень у `images/`,
- немає невикористаних сніпетів у `snippets/`,
- немає невикористаних розділів у `chapters/` (тих, які не підключені у `main.tex`).

Поки скрипт показує `FAIL` — компіляція згенерує сирий PDF з порожніми/placeholder-полями. Працює локально (Linux/macOS/WSL); на Overleaf запустіть у термінал-сервері або заповніть `thesis_info.tex` вручну за списком нижче.

---

## Налаштування Overleaf (ОБОВ'ЯЗКОВО перед першою компіляцією)

```
Меню (☰) → Compiler          → pdfLaTeX   ← НЕ LuaLaTeX
Меню (☰) → Bibliography tool → Biber      ← НЕ BibTeX
```

Після цього натисніть **Recompile** — PDF готовий.
Якщо зміст, бібліографія чи статистика реферату не оновились — натисніть **Recompile** ще раз. **Статистика (кількість рис./табл./джерел/додатків) рахується автоматично і з'являється тільки після другої компіляції.**

---

## Робота у VSCode

### Розширення

Встановіть обидва:

- **LaTeX Workshop** (James Yu) — основне розширення: збірка, перегляд PDF, SyncTeX.
- **LaTeX Utilities** — доповнення: вставка зображень, підрахунок слів, форматування.

### Конфігурація `.vscode/settings.json`

Файл вже є у проєкті. Він налаштовує `latexmk` як єдиний інструмент збірки — Biber і мультипрохід `latexmk` робить сам відповідно до `latexmkrc`.

### Кореневий файл для `.md` і `.tex`

Щоб LaTeX Workshop завжди будував від `main.tex` незалежно від того, який файл відкритий, додайте першим рядком у кожен `chapters/*.md` та допоміжний `.tex`:

```latex
% !TEX root = ../main.tex
```

### Гарячі клавіші

| Дія | Клавіші |
|-----|---------|
| Зібрати проєкт | `Ctrl+Alt+B` |
| Переглянути PDF | `Ctrl+Alt+V` |
| SyncTeX: редактор → PDF | `Ctrl+Alt+J` |
| SyncTeX: PDF → редактор | `Ctrl+Click` у PDF |
| Відкрити термінал | `` Ctrl+` `` |

### LaTeX Utilities — корисне для цього проєкту

- **Вставка зображення** — скопіює файл у `images/` і згенерує блок `\includegraphics` автоматично.
- **Підрахунок слів** — працює на поточному файлі.
- **Форматування** — інтеграція з `latexindent` для `.tex`-файлів.

### Запуск перевірки з терміналу VSCode

```bash
bash tools/check.sh
```

Відкрийте термінал через `` Ctrl+` `` — виходити з VSCode не потрібно.

---

## Локальна збірка

```bash
bash tools/check.sh        # необов'язково, але рекомендовано
latexmk -pdf main.tex      # все інше latexmk зробить сам
```

`latexmk` сам визначить, скільки разів треба перекомпілювати, та коли запустити `biber`.

---

## Що і де писати

### `thesis_info.tex` — заповнюєте ОДИН раз

```latex
\renewcommand{\ThesisTitle}{Назва вашої роботи}
\renewcommand{\ThesisAuthor}{Шевченко Іван Михайлович}
\renewcommand{\ThesisMeta}{розробити метод...}
\renewcommand{\ThesisObject}{процес аналізу...}
% і т.д.
```

> ℹ️ **Статистика** (кількість рисунків, таблиць, джерел, додатків) **автоматична** — нічого не вписуйте. У рефераті після першої компіляції побачите `?` — це нормально, на другій компіляції все підставиться.

Якщо залишити поле незміненим — `tools/check.sh` покаже:
```
✗ placeholder не замінено: "Вкажіть назву роботи"
```

### `chapters/*.md` — пишете весь текст тут

```markdown
# Назва розділу          → \chapter{}
## Назва підрозділу      → \section{}
### Назва пункту         → \subsection{}

**жирний**, *курсив*, звичайний текст

- маркований список
1. нумерований список

[@goodfellow2016]   → посилання на джерело
```

### Формули — як LaTeX

```markdown
Inline: $E = mc^2$

Блочна:
\begin{equation}
  f(x) = \frac{1}{\sigma\sqrt{2\pi}} e^{-\frac{(x-\mu)^2}{2\sigma^2}}
  \label{eq:gauss}
\end{equation}

Посилання: формула~\ref{eq:gauss}
```

### Рисунок

```latex
\begin{figure}[H]
  \centering
  \includegraphics[width=0.8\linewidth]{images/my_figure.png}
  \caption{Підпис під рисунком}
  \label{fig:myname}
\end{figure}

Посилання: рис.~\ref{fig:myname}
```

### Таблиця (Markdown)

Caption йде ОКРЕМИМ рядком після таблиці і ОБОВ'ЯЗКОВО містить `\label{}`:

```markdown
| Метод    | Точність, % |
|----------|-------------|
| ResNet   | 91.3        |
| **Наш**  | **96.2**    |

: Порівняння методів\label{tbl:results}
```

> ⚠️ **`{#tbl:label}` (синтаксис Pandoc) НЕ ПРАЦЮЄ** з пакетом `markdown`. Треба `\label{tbl:label}` всередині caption.

> ⚠️ Посилання на таблиці/рисунки/формули: завжди `\ref{label}` або `\eqref{label}`, **не** `[-@label]`.

### Лістинг коду

Простий код у самій `.md` (тільки латиниця у коментарях!):

````markdown
```python
def hello():
    # English comments only in code blocks (pdfLaTeX requirement)
    print("Hello, world!")
```
````

Лістинг з підписом і посиланням — у файлі `snippets/listing_xxx.tex`:

```latex
\begin{lstlisting}[language=Python, caption={Опис}, label={lst:xxx}]
...code...
\end{lstlisting}
```

І в `.md`: `\snippet{listing_xxx.tex}`.

**Шрифт лістингу** — 10pt, **довгі рядки автоматично переносяться** з маркером `↪` червоного кольору.

### Складний LaTeX (TikZ, pgfplots) — теж у `snippets/`

```markdown
\snippet{figure_pipeline.tex}
```

### Джерело до списку літератури

1. Google Scholar → знайдіть роботу → **Cite** → **BibTeX**.
2. Скопіюйте запис у `references.bib`.
3. Вставте `[@ключ]` у текст — все інше автоматично.

---

## Як зробити log читабельнішим

Лог `build/main.log` може бути на 3000+ рядків. Кілька способів його зменшити:

### 1. У стилі (вже застосовано)

- `\hbadness=10000` / `\vbadness=10000` — приховує underfull-warnings нижче критичного рівня (їх було ~20).
- `silence` package + `\WarningFilter{markdown}{The 'hybrid' option ...}` — приховує deprecation про `hybrid`.
- `\RequirePackage[nohyperlinks]{acronym}` — прибирає 14 `Hyper reference acro:XXX undefined`.

### 2. У `latexmkrc` (вже застосовано)

```perl
$silent = 1;
$pdflatex = 'pdflatex -file-line-error ...';
```

`$silent = 1` робить вивід `latexmk` коротшим (повний log все ще пишеться у файл). `-file-line-error` — точніший формат помилок.

### 3. Через `texfot` (ставиться разом з TeX Live)

```bash
texfot latexmk -pdf main.tex
```

`texfot` фільтрує lengthy log, показує лише warnings та errors.

### 4. Якщо треба читати log вручну

```bash
# Тільки помилки, warnings та overfull/underfull
awk '/^!|Warning|Overfull|Underfull/' build/main.log

# Тільки рядки навколо першої помилки
grep -n '^!' build/main.log | head -1
```

### 5. Додавати свої фільтри

Якщо з'являється нове набридливе попередження, у `unithesis.sty` додайте:

```latex
\WarningFilter{ім'я-пакету}{початок-тексту-warning}
```

Використовуйте обережно — попередження зазвичай попереджають про щось важливе.

---

## Типові помилки

| Помилка | Причина | Рішення |
|---------|---------|---------|
| `placeholder не замінено: "..."` | Не заповнили `thesis_info.tex` | `bash tools/check.sh` → виправте |
| `Reference 'tbl:xxx' undefined` | Caption без `\label{}` | `: Caption\label{tbl:xxx}` (не `{#tbl:xxx}`) |
| У рефераті стоять `?` замість чисел | Перший прохід LaTeX | Перекомпілюйте ще раз |
| `Invalid UTF-8 byte` у лістингу | Кирилиця у блоці коду | Тільки англійська у коментарях коду |
| Список літератури порожній | Biber не запустився | Recompile / `latexmk` запустить сам |
| Зміст не оновився | Потрібен ще один прохід | Recompile |
| `Overfull \hbox` у tikz | Рисунок ширший за поле тексту | Обгорніть у `\resizebox{\linewidth}{!}{...}` |