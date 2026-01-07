#!/usr/bin/env bash
set -euo pipefail

TITLE_FILE="title.txt"
BODY_FILE="body.txt"
LOGO_FILE="logo.png"
BANNER_FILE="banner.png"
TEMPLATE_FILE="template.html"
OUT_FILE="creative.html"

# Проверяем наличие файлов
for f in "$TITLE_FILE" "$BODY_FILE" "$LOGO_FILE" "$BANNER_FILE" "$TEMPLATE_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "Нет файла: $f"
    exit 1
  fi
done

# Читаем текст
TITLE=$(cat "$TITLE_FILE")
BODY=$(cat "$BODY_FILE")

# Кодируем картинки в base64 (поддержка macOS/Linux)
if base64 --help 2>&1 | grep -q -- "-w"; then
  # GNU coreutils (Linux, Git Bash)
  LOGO_B64=$(base64 -w0 "$LOGO_FILE")
  BANNER_B64=$(base64 -w0 "$BANNER_FILE")
else
  # BSD base64 (macOS)
  LOGO_B64=$(base64 < "$LOGO_FILE" | tr -d '\n')
  BANNER_B64=$(base64 < "$BANNER_FILE" | tr -d '\n')
fi

# Подставляем данные в шаблон и сохраняем итоговый HTML (чистый shell)
TEMPLATE_CONTENT=$(<"$TEMPLATE_FILE")
TEMPLATE_CONTENT=${TEMPLATE_CONTENT//\{\{TITLE\}\}/$TITLE}
TEMPLATE_CONTENT=${TEMPLATE_CONTENT//\{\{BODY\}\}/$BODY}
TEMPLATE_CONTENT=${TEMPLATE_CONTENT//\{\{LOGO_BASE64\}\}/data:image/png;base64,$LOGO_B64}
TEMPLATE_CONTENT=${TEMPLATE_CONTENT//\{\{BANNER_BASE64\}\}/data:image/png;base64,$BANNER_B64}

printf '%s' "$TEMPLATE_CONTENT" > "$OUT_FILE"

echo "Файл креатива успешно создан: $OUT_FILE"
open $OUT_FILE