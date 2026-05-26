#!/usr/bin/env bash
# ============================================================
#  tools/check.sh — preflight перевірка перед компіляцією
#
#  Що робить:
#   1. Шукає не заповнені placeholder-и в thesis_info.tex.
#   2. Шукає невикористані файли (зайвий мотлох):
#        • images/*.{png,pdf,jpg,jpeg}
#        • snippets/*.tex
#        • chapters/*.md (які не підключені у main.tex)
#   3. Перевіряє наявність ключових файлів.
#
#  Запуск:  bash tools/check.sh
#  Код виходу: 0 — все ОК, 1 — є помилки.
# ============================================================
set -u
LC_ALL=C.UTF-8

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# ── Кольорове виведення (якщо термінал підтримує) ──────────
if [ -t 1 ] && command -v tput >/dev/null 2>&1; then
    R="$(tput setaf 1)"; G="$(tput setaf 2)"; Y="$(tput setaf 3)"
    B="$(tput bold)"; N="$(tput sgr0)"
else
    R=""; G=""; Y=""; B=""; N=""
fi

ERRORS=0
WARNINGS=0

err()  { printf "%s✗%s %s\n"  "$R" "$N" "$*" >&2; ERRORS=$((ERRORS+1)); }
warn() { printf "%s⚠%s %s\n"  "$Y" "$N" "$*" >&2; WARNINGS=$((WARNINGS+1)); }
ok()   { printf "%s✓%s %s\n"  "$G" "$N" "$*"; }
hdr()  { printf "\n%s%s%s\n" "$B" "$*" "$N"; }

# ============================================================
# 1) Наявність ключових файлів
# ============================================================
hdr "[1/4] Перевірка структури проєкту"

required_files=(main.tex unithesis.sty thesis_info.tex references.bib)
required_dirs=(chapters images snippets)

for f in "${required_files[@]}"; do
    if [ -f "$f" ]; then
        ok "знайдено: $f"
    else
        err "відсутній файл: $f"
    fi
done

for d in "${required_dirs[@]}"; do
    if [ -d "$d" ]; then
        ok "знайдено директорію: $d/"
    else
        err "відсутня директорія: $d/"
    fi
done

# ============================================================
# 2) Placeholder-и у thesis_info.tex
# ============================================================
hdr "[2/4] Перевірка thesis_info.tex на placeholder-и"

if [ -f thesis_info.tex ]; then
    # Усі шаблонні рядки, які мають бути замінені
    placeholders=(
        "Вкажіть назву роботи"
        "Вкажіть прізвище ім'я по-батькові"
        "Вкажіть наукового керівника"
        "Вкажіть кафедру"
        "Вкажіть факультет"
        "Вкажіть університет"
        "Вкажіть спеціальність"
        "ВКАЖІТЬ КЛЮЧОВІ СЛОВА"
        "вкажіть мету роботи"
        "вкажіть об'єкт дослідження"
        "вкажіть предмет дослідження"
        "вкажіть методи дослідження"
        "вкажіть наукову новизну"
        "вкажіть практичне значення"
    )
    found_any=0
    for ph in "${placeholders[@]}"; do
        if grep -qF "$ph" thesis_info.tex; then
            err "placeholder не замінено: \"$ph\""
            found_any=1
        fi
    done
    [ "$found_any" -eq 0 ] && ok "усі поля заповнено"
fi

# ============================================================
# 3) Невикористані файли
# ============================================================
hdr "[3/4] Пошук невикористаних файлів"

# Усі джерела, де можуть бути посилання на матеріали
sources_all=()
[ -d chapters ] && while IFS= read -r -d '' f; do sources_all+=("$f"); done \
    < <(find chapters -type f \( -name '*.md' -o -name '*.tex' \) -print0)
[ -d snippets ] && while IFS= read -r -d '' f; do sources_all+=("$f"); done \
    < <(find snippets -type f -name '*.tex' -print0)
[ -f main.tex ] && sources_all+=("main.tex")

# 3a) Невикористані зображення -------------------------------
unused_imgs=0
if [ -d images ]; then
    shopt -s nullglob
    for img in images/*.png images/*.pdf images/*.jpg images/*.jpeg; do
        [ -e "$img" ] || continue
        name=$(basename "$img")
        # Шукаємо ім'я файлу (або без розширення) у будь-якому джерелі
        stem="${name%.*}"
        if ! grep -rqF -- "$name" "${sources_all[@]}" 2>/dev/null \
           && ! grep -rqE "includegraphics(\[[^]]*\])?\{[^}]*${stem}" \
                "${sources_all[@]}" 2>/dev/null; then
            warn "невикористане зображення: $img"
            unused_imgs=$((unused_imgs+1))
        fi
    done
    shopt -u nullglob
fi
[ "$unused_imgs" -eq 0 ] && ok "усі зображення використовуються"

# 3b) Невикористані сніпети ---------------------------------
unused_snips=0
if [ -d snippets ]; then
    shopt -s nullglob
    for sn in snippets/*.tex; do
        [ -e "$sn" ] || continue
        name=$(basename "$sn")
        # \snippet{name.tex} у будь-якому .md або main.tex
        if ! grep -rqE "\\\\snippet\{${name}\}" \
            chapters/ main.tex 2>/dev/null; then
            warn "невикористаний сніпет: $sn"
            unused_snips=$((unused_snips+1))
        fi
    done
    shopt -u nullglob
fi
[ "$unused_snips" -eq 0 ] && ok "усі сніпети використовуються"

# 3c) Невикористані chapter-файли ---------------------------
unused_chs=0
if [ -d chapters ]; then
    shopt -s nullglob
    for ch in chapters/*.md; do
        [ -e "$ch" ] || continue
        # Шукаємо посилання на цей шлях у main.tex
        if ! grep -qF "$ch" main.tex 2>/dev/null; then
            warn "невикористаний розділ: $ch"
            unused_chs=$((unused_chs+1))
        fi
    done
    shopt -u nullglob
fi
[ "$unused_chs" -eq 0 ] && ok "усі розділи підключено у main.tex"

# ============================================================
# 4) Підсумок
# ============================================================
hdr "[4/4] Підсумок"

if [ "$ERRORS" -gt 0 ]; then
    printf "%sFAIL%s: %d помилок(а), %d попереджень\n" \
        "$R$B" "$N" "$ERRORS" "$WARNINGS" >&2
    exit 1
fi

if [ "$WARNINGS" -gt 0 ]; then
    printf "%sOK з %d попередженнями%s\n" "$Y" "$WARNINGS" "$N"
else
    printf "%sВсе чисто.%s\n" "$G$B" "$N"
fi
exit 0
