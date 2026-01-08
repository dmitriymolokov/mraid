# MRAID Creative Builder

Скрипты для сборки HTML креатива из шаблона и ресурсов.

## Использование

### На Windows (PowerShell)

```powershell
.\build.ps1
.\reset.ps1
```

Если возникает ошибка о политике выполнения скриптов, выполните:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### На macOS/Linux (Bash)

```bash
sh build.sh
sh reset.sh
```

Или сделайте скрипты исполняемыми:
```bash
chmod +x build.sh reset.sh
./build.sh
./reset.sh
```

## Необходимые файлы

- `title.txt` - заголовок креатива
- `body.txt` - текст креатива
- `logo.png` - логотип приложения
- `banner.png` - баннер креатива
- `template.html` - HTML шаблон

## Результат

После выполнения `build.sh` или `build.ps1` будет создан файл `creative.html` с встроенными изображениями в формате base64.
