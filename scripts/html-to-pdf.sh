#!/usr/bin/env bash
# explain 스킬 — 자체 완결형 HTML 가이드북을 PDF로 변환한다.
#
# 사용법: html-to-pdf.sh <input.html> <output.pdf>
#
# 동작: 설치된 Chromium 계열 브라우저(Chrome/Chromium/Edge/Brave)를 찾아
#   headless --print-to-pdf 로 렌더한다. 템플릿이 CDN의 marked.js/highlight.js 로
#   본문을 그려내므로 변환 시 네트워크 연결이 필요하며, --virtual-time-budget 으로
#   스크립트가 렌더를 끝낼 시간을 준다.
#
# 브라우저를 못 찾으면 3번 종료코드로 끝난다. 이때는 HTML을 브라우저에서 열어
#   '인쇄 → PDF로 저장'으로 대체하면 된다(@media print 스타일이 이미 적용돼 있다).

set -euo pipefail

IN="${1:?사용법: html-to-pdf.sh <input.html> <output.pdf>}"
OUT="${2:?사용법: html-to-pdf.sh <input.html> <output.pdf>}"

# file:// 에 넘길 절대경로
ABS_IN="$(cd "$(dirname "$IN")" && pwd)/$(basename "$IN")"

find_browser() {
  local mac=(
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    "/Applications/Chromium.app/Contents/MacOS/Chromium"
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
    "/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
  )
  local c
  for c in "${mac[@]}"; do
    [ -x "$c" ] && { printf '%s' "$c"; return 0; }
  done
  for c in google-chrome google-chrome-stable chromium chromium-browser microsoft-edge brave-browser; do
    if command -v "$c" >/dev/null 2>&1; then command -v "$c"; return 0; fi
  done
  return 1
}

if ! BROWSER="$(find_browser)"; then
  echo "ERROR: Chrome/Chromium/Edge/Brave 를 찾지 못했습니다. PDF 변환을 건너뜁니다." >&2
  echo "대안: '$IN' 을 브라우저로 열고 '인쇄 → PDF로 저장'을 선택하세요(인쇄 스타일 적용됨)." >&2
  exit 3
fi

"$BROWSER" \
  --headless=new --disable-gpu --no-sandbox \
  --no-pdf-header-footer \
  --virtual-time-budget=15000 --run-all-compositor-stages-before-draw \
  --print-to-pdf="$OUT" "file://$ABS_IN" >/dev/null 2>&1

if [ -s "$OUT" ]; then
  echo "PDF 생성 완료: $OUT"
else
  echo "ERROR: PDF가 생성되지 않았습니다. 브라우저 변환에 실패했을 수 있습니다('$BROWSER')." >&2
  exit 4
fi
