# PowerShell скрипт для сборки креатива на Windows
$ErrorActionPreference = "Stop"

Write-Host "Сборка креатива..." -ForegroundColor Cyan
Write-Host "Скрипт может выполняться несколько секунд..." -ForegroundColor Cyan
Write-Host ""

$TITLE_FILE = "title.txt"
$BODY_FILE = "body.txt"
$LOGO_FILE = "logo.png"
$BANNER_FILE = "banner.png"
$TEMPLATE_FILE = "template.html"
$OUT_FILE = "creative.html"

# Проверяем наличие файлов
Write-Host "Шаг 1: Проверка наличия необходимых файлов..." -ForegroundColor Yellow
$files = @($TITLE_FILE, $BODY_FILE, $LOGO_FILE, $BANNER_FILE, $TEMPLATE_FILE)
foreach ($f in $files) {
    if (-not (Test-Path $f)) {
        Write-Host "🛑 Ошибка: нет файла: $f" -ForegroundColor Red
        exit 1
    }
}
Write-Host "✅ Все необходимые файлы найдены" -ForegroundColor Green
Write-Host ""

# Читаем текст
Write-Host "Шаг 2: Чтение текстовых файлов..." -ForegroundColor Yellow
$TITLE = Get-Content $TITLE_FILE -Raw
$BODY = Get-Content $BODY_FILE -Raw
Write-Host "✅ Текстовые данные загружены" -ForegroundColor Green
Write-Host ""

# Кодируем картинки в base64
Write-Host "Шаг 3: Кодирование изображений в base64..." -ForegroundColor Yellow
Write-Host "Кодирование логотипа..."
$LOGO_BYTES = [System.IO.File]::ReadAllBytes((Resolve-Path $LOGO_FILE))
$LOGO_B64 = [Convert]::ToBase64String($LOGO_BYTES)

Write-Host "Кодирование баннера..."
$BANNER_BYTES = [System.IO.File]::ReadAllBytes((Resolve-Path $BANNER_FILE))
$BANNER_B64 = [Convert]::ToBase64String($BANNER_BYTES)

Write-Host "✅ Изображения закодированы" -ForegroundColor Green
Write-Host ""

# Подставляем данные в шаблон и сохраняем итоговый HTML
Write-Host "Шаг 4: Создание итогового HTML файла..." -ForegroundColor Yellow
$TEMPLATE_CONTENT = Get-Content $TEMPLATE_FILE -Raw
$TEMPLATE_CONTENT = $TEMPLATE_CONTENT -replace '\{\{TITLE\}\}', $TITLE
$TEMPLATE_CONTENT = $TEMPLATE_CONTENT -replace '\{\{BODY\}\}', $BODY
$TEMPLATE_CONTENT = $TEMPLATE_CONTENT -replace '\{\{LOGO_BASE64\}\}', "data:image/png;base64,$LOGO_B64"
$TEMPLATE_CONTENT = $TEMPLATE_CONTENT -replace '\{\{BANNER_BASE64\}\}', "data:image/png;base64,$BANNER_B64"

[System.IO.File]::WriteAllText((Resolve-Path .).Path + "\$OUT_FILE", $TEMPLATE_CONTENT, [System.Text.Encoding]::UTF8)

Write-Host "✅ Файл креатива успешно создан: $OUT_FILE" -ForegroundColor Green
Write-Host ""
Write-Host "Открываю файл в браузере..." -ForegroundColor Cyan
Write-Host ""

Start-Process $OUT_FILE
