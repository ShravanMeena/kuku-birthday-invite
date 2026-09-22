#!/bin/bash
# Kuku ki photos ko optimize karke website me laga deta hai.
#
#   1. Apni photos `photos/memories/` me daal do (koi bhi naam, .jpg/.png/.heic/.webp)
#   2. Ye chala do:  ./add-photos.sh
#
# Photos 800px tak chhoti hoti hain, WebP me convert hoti hain, aur index.html
# ka CONFIG.memories apne aap bhar jata hai. Dobara chala sakte ho — safe hai.

set -eo pipefail
cd "$(dirname "$0")"

SRC="photos/memories"
[ -d "$SRC" ] || { echo "❌ $SRC folder nahi mila"; exit 1; }

if ! command -v magick >/dev/null 2>&1 && ! command -v convert >/dev/null 2>&1; then
  echo "❌ ImageMagick chahiye.  brew install imagemagick"
  exit 1
fi
MAGICK=$(command -v magick || command -v convert)

# originals dhoondo (jo humne banayi hain unhe chhod do)
SRCS=()
while IFS= read -r f; do SRCS+=("$f"); done < <(find "$SRC" -maxdepth 1 -type f \
  \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.heic' -o -iname '*.webp' \) \
  ! -name 'kuku-*.webp' | sort)

if [ ${#SRCS[@]:-0} -eq 0 ]; then
  echo "❌ $SRC me koi photo nahi mili."
  echo "   Apni photos wahan daalo phir ye script dobara chalao."
  exit 1
fi

echo "📸 ${#SRCS[@]} photo(s) mili — optimize kar raha hoon…"
rm -f "$SRC"/kuku-*.webp
PATHS=()
i=1
for f in "${SRCS[@]}"; do
  out="$SRC/kuku-$i.webp"
  # square crop, centre se — polaroid cards 1:1 hain
  "$MAGICK" "$f" -auto-orient -resize 800x800^ -gravity center -extent 800x800 \
            -quality 66 -define webp:method=6 "$out"
  printf '   %-34s → %s (%s)\n' "$(basename "$f")" "$(basename "$out")" "$(du -h "$out" | cut -f1)"
  PATHS+=("$out")
  i=$((i+1))
done

python3 - "${PATHS[@]}" <<'PY'
import re, sys
paths = sys.argv[1:]
html = open("index.html").read()

m = re.search(r'(  memories: \[\n)(.*?)(\n  \])', html, re.S)
if not m:
    print("❌ index.html me CONFIG.memories nahi mila"); sys.exit(1)

rows = [r for r in m.group(2).split("\n") if r.strip().startswith("{")]
# purane caption/emoji/colour reuse karo, extra photos ke liye defaults
DEF = [("The Queen","\\u{1F451}","#d4638c","#5e3180"), ("Dance floor","\\u{1F483}","#c4a05c","#7a2650"),
       ("Always glowing","\\u{1F338}","#e5a3bf","#a33a6b"), ("Cheers to us","\\u{1F942}","#6b3a8f","#2a0f30"),
       ("That smile","\\u2728","#e08daf","#4f1b3e"), ("Forever 33","\\u{1F380}","#ddc68f","#a8742a")]
def field(row, key):
    f = re.search(key + r':"((?:[^"\\]|\\.)*)"', row)
    return f.group(1) if f else None

out = []
for i, p in enumerate(paths):
    if i < len(rows):
        cap = field(rows[i], "caption") or DEF[i % 6][0]
        emo = field(rows[i], "emoji")   or DEF[i % 6][1]
        c1  = field(rows[i], "c1")      or DEF[i % 6][2]
        c2  = field(rows[i], "c2")      or DEF[i % 6][3]
    else:
        cap, emo, c1, c2 = DEF[i % 6]
    out.append(f'    {{ caption:"{cap}", img:"{p}", emoji:"{emo}", c1:"{c1}", c2:"{c2}" }}')

html = html[:m.start(2)] + ",\n".join(out) + html[m.end(2):]
open("index.html", "w").write(html)
print(f"✅ index.html update ho gaya — {len(paths)} photo(s) lag gayi")
PY

echo
echo "🎉 Ho gaya. Browser refresh karo: http://localhost:8777"
echo "   Caption badalne ke liye index.html me CONFIG.memories dekho."
