# latexmkrc — автоматична конфігурація збірки
# Просто запускайте: latexmk main.tex

# ── Компілятор і прапори ────────────────────────────────────
# -file-line-error → коротші повідомлення про помилки
# -synctex=1       → підтримка SyncTeX для редакторів
$pdflatex = 'pdflatex -shell-escape -file-line-error -synctex=1 '
          . '-interaction=nonstopmode %O %S';

# PDF режим (pdflatex)
$pdf_mode = 1;

# Biber замість BibTeX
$bibtex_use = 2;

# Всі тимчасові файли → папка build/
$out_dir = 'build';

# Markdown пакет теж кладе свої файли туди
$ENV{TEXMF_OUTPUT_DIRECTORY} = 'build';

# ── Preflight (валідація + пошук невикористаних файлів) ─────
# Розкоментуйте, щоб latexmk автоматично запускав tools/check.sh
# перед компіляцією. Якщо check.sh повертає != 0 — компіляція
# обривається. Працює на локальних машинах (НЕ Overleaf).
#
# BEGIN {
#     if (-x 'tools/check.sh') {
#         my $rc = system('bash tools/check.sh');
#         die "tools/check.sh виявив помилки — виправте і запустіть знову.\n"
#             if $rc != 0;
#     }
# }

# ── Чистіший вивід у консоль ────────────────────────────────
# Менше шуму від latexmk; повний log усе ще пишеться у build/main.log
$silent = 1;
