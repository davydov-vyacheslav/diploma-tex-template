# Шаблон магістерської роботи — Overleaf + Markdown

## Структура проєкту

```
.
├── .github/
│   └── workflows/
│       └── build.yaml        — GitHub Actions: збірка і публікація PDF
├── .vscode/
│   ├── extensions.json       — рекомендовані розширення VSCode
│   └── settings.json         — налаштування LaTeX Workshop
├── assets/
│   ├── code/                 — вихідний код (.py, .js тощо)
│   ├── images/               — рисунки (.png .pdf .jpg)
│   └── snippets/             — складний LaTeX (lstlisting, tikz, tables)
├── chapters/
│   ├── 00_intro.md           — вступ
│   ├── 01_chapter.md         — розділ 1
│   ├── 02_chapter.md         — розділ 2
│   ├── 03_chapter.md         — розділ 3
│   ├── 00_conclusions.md     — висновки
│   └── appendix_a.md         — додаток А
├── tools/
│   └── check.sh              — перевірка перед компіляцією
├── thesis_info.tex  ★        — ТІЛЬКИ ЦЕЙ ФАЙЛ ЗАПОВНЮВАТИ
├── main.tex                  — структура (не чіпати)
├── unithesis.sty             — стиль (не чіпати)
├── references.bib            — джерела
└── latexmkrc                 — конфігурація збірки
```

---

## Встановлення LaTeX

**macOS**
```bash
brew install mactex-no-gui
```

**Linux (Ubuntu/Debian)**
```bash
sudo apt install texlive-full
```

**Windows** — встановіть [TeX Live](https://tug.org/texlive/windows.html) або [MiKTeX](https://miktex.org/download).
MiKTeX зручніший для початківців (доставляє пакети на льоту), TeX Live — надійніший для відтворюваної збірки.

Після встановлення перевірте:
```powershell
latexmk --version
biber --version
```

---

## Перед першою компіляцією — заповніть `thesis_info.tex` і запустіть перевірку

```bash
bash tools/check.sh
```

Скрипт перевіряє:

- усі placeholder-и в `thesis_info.tex` замінено,
- усі ключові файли/директорії на місці,
- немає невикористаних зображень у `assets/images/`,
- немає невикористаних сніпетів у `assets/snippets/`,
- немає невикористаних розділів у `chapters/` (тих, які не підключені у `main.tex`).

Поки скрипт показує `FAIL` — компіляція згенерує сирий PDF з порожніми/placeholder-полями. Працює локально (Linux/macOS/WSL); на Overleaf запустіть у термінал-сервері або заповніть `thesis_info.tex` вручну.

---

## Налаштування Overleaf (ОБОВ'ЯЗКОВО перед першою компіляцією)

```
Меню (☰) → Compiler          → pdfLaTeX   ← НЕ LuaLaTeX
Меню (☰) → Bibliography tool → Biber      ← НЕ BibTeX
```

Після цього натисніть **Recompile** — PDF готовий.
Якщо зміст, бібліографія чи статистика реферату не оновились — натисніть **Recompile** ще раз. **Статистика (кількість рис./табл./джерел/додатків) рахується автоматично і з'являється тільки після другої компіляції.**

---

## Локальна збірка

```bash
bash tools/check.sh        # необов'язково, але рекомендовано
latexmk -pdf main.tex      # все інше latexmk зробить сам
```

`latexmk` сам визначить, скільки разів треба перекомпілювати, та коли запустити `biber`.

Для фільтрації довгого логу:
```bash
texfot latexmk -pdf main.tex          # показує лише warnings та errors
awk '/^!|Warning|Overfull|Underfull/' build/main.log   # вручну
```

---

## Робота у VSCode

### Розширення

`.vscode/extensions.json` вже є у проєкті — VSCode запропонує встановити їх автоматично при відкритті папки. Потрібні два:

- **LaTeX Workshop** (`james-yu.latex-workshop`) — збірка, перегляд PDF, SyncTeX.
- **LaTeX Utilities** (`tecosaur.latex-utilities`) — вставка зображень, підрахунок слів, форматування.

### Конфігурація

`.vscode/settings.json` вже є у проєкті — налаштовує `latexmk` як єдиний інструмент збірки. Biber і мультипрохід `latexmk` робить сам відповідно до `latexmkrc`. Конфіг однаковий на всіх платформах (macOS/Linux/Windows).

### Кореневий файл для `.md` і `.tex`

Щоб LaTeX Workshop завжди будував від `main.tex` незалежно від того, який файл відкритий, додайте першим рядком у кожен `chapters/*.md` та допоміжний `.tex`:

```
% !TEX root = ../main.tex
```

### Гарячі клавіші

| Дія | Клавіші |
|-----|---------|
| Зібрати проєкт | `Ctrl+Alt+B` |
| Зібрати з будь-якого файлу (включаючи `.md`) | `Ctrl+Shift+B` |
| Переглянути PDF | `Ctrl+Alt+V` |
| SyncTeX: редактор → PDF | `Ctrl+Alt+J` |
| SyncTeX: PDF → редактор | `Ctrl+Click` у PDF |
| Відкрити термінал | `` Ctrl+` `` |

> `Ctrl+Shift+B` працює через `.vscode/tasks.json` і запускає `latexmk` незалежно від типу відкритого файлу.

### LaTeX Utilities — корисне для цього проєкту

- **Вставка зображення** — скопіює файл у `assets/images/` і згенерує блок `\includegraphics` автоматично.
- **Підрахунок слів** — працює на поточному файлі.
- **Форматування** — інтеграція з `latexindent` для `.tex`-файлів.

---

## GitHub Actions — автоматична збірка PDF

`.github/workflows/build.yaml` збирає PDF при кожному пуші у `main` і прикріплює його як артефакт.

**Скачати PDF:** Actions → останній run → Artifacts → `thesis`.

**Публікація по тегу** (постійне посилання для наукового керівника):
```bash
git tag v1.0 && git push --tags
```
PDF прикріпляється до GitHub Release і доступний за посиланням:
```
https://github.com/<user>/<repo>/releases/latest/download/main.pdf
```

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

Для набору і перевірки формул: https://editor.codecogs.com — генерує LaTeX-код з візуального редактора. Для перенесення формул зі скриншотів: [Mathpix Snip](https://mathpix.com).

### Рисунок

```latex
\begin{figure}[H]
  \centering
  \includegraphics[width=0.8\linewidth]{assets/images/my_figure.png}
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

Для складних таблиць (`\multirow`, `\multicolumn`, `tabularx`) — генеруйте код на [latex-tables.com](https://www.latex-tables.com), потім збережіть у `assets/snippets/table_xxx.tex`.

### Лістинг коду

Простий код у самій `.md` (тільки латиниця у коментарях!):

````markdown
```python
def hello():
    # English comments only in code blocks (pdfLaTeX requirement)
    print("Hello, world!")
```
````

Лістинг з підписом і посиланням — у файлі `assets/snippets/listing_xxx.tex`:

```latex
\begin{lstlisting}[language=Python, caption={Опис}, label={lst:xxx}]
...code...
\end{lstlisting}
```

І в `.md`: `\snippet{listing_xxx.tex}`.

**Шрифт лістингу** — 10pt, **довгі рядки автоматично переносяться** з маркером `↪` червоного кольору.

### Складний LaTeX (TikZ, pgfplots, tabularx) — у `assets/snippets/`

```markdown
\snippet{figure_pipeline.tex}
\snippet{table_results.tex}
```

### Джерело до списку літератури

1. Google Scholar → знайдіть роботу → **Cite** → **BibTeX**.
2. Скопіюйте запис у `references.bib`.
3. Вставте `[@ключ]` у текст — все інше автоматично.

---

## Як зробити log читабельнішим

### 1. У стилі (вже застосовано)

- `\hbadness=10000` / `\vbadness=10000` — приховує underfull-warnings нижче критичного рівня.
- `\WarningFilter{markdown}{...}` — приховує deprecation про `hybrid`.
- `\RequirePackage[nohyperlinks]{acronym}` — прибирає `Hyper reference acro:XXX undefined`.

### 2. У `latexmkrc` (вже застосовано)

```perl
$silent = 1;
$pdflatex = 'pdflatex -file-line-error ...';
```

### 3. Через `texfot`

```bash
texfot latexmk -pdf main.tex
```

### 4. Вручну

```bash
awk '/^!|Warning|Overfull|Underfull/' build/main.log
grep -n '^!' build/main.log | head -1
```

### 5. Додавати свої фільтри

```latex
\WarningFilter{ім'я-пакету}{початок-тексту-warning}
```

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