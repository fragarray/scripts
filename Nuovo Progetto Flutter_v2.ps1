# crea_flutter_progetto.ps1

Write-Host "Creazione nuovo progetto Flutter per VSCode o Android Studio"

# 1. Nome del progetto
$projectName = Read-Host "Inserisci il nome del progetto"

if ([string]::IsNullOrWhiteSpace($projectName)) {
    Write-Host "Errore: il nome del progetto non può essere vuoto."
    exit
}

# 2. Selezione piattaforme
Write-Host "`nSeleziona le piattaforme da abilitare (y/n):"
$android = Read-Host "Android?"
$ios = Read-Host "iOS?"
$linux = Read-Host "Linux?"
$macos = Read-Host "macOS?"
$windows = Read-Host "Windows?"
$web = Read-Host "Web (Chrome)?"

# 3. Creazione progetto Flutter base
Write-Host "`nCreazione progetto..."
flutter create $projectName
if ($LASTEXITCODE -ne 0) {
    Write-Host "Errore nella creazione del progetto Flutter."
    exit
}

Set-Location $projectName

# 4. Rimozione delle piattaforme non desiderate
$platformDirs = @{
    "android" = $android
    "ios" = $ios
    "linux" = $linux
    "macos" = $macos
    "windows" = $windows
    "web" = $web
}

foreach ($platform in $platformDirs.Keys) {
    if ($platformDirs[$platform] -ne "y") {
        $path = Join-Path -Path (Get-Location) -ChildPath $platform
        if (Test-Path $path) {
            Remove-Item -Recurse -Force -Path $path
        }
    }
}

# 5. Configurazione VSCode
New-Item -ItemType Directory -Path ".vscode" -Force | Out-Null

$launchJsonContent = @"
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter",
      "request": "launch",
      "type": "dart"
    }
  ]
}
"@

Set-Content ".vscode/launch.json" -Value $launchJsonContent

Write-Host "`nProgetto '$projectName' creato con successo."

# 6. Apertura IDE
$ideChoice = Read-Host "`nVuoi aprire il progetto con VSCode o Android Studio? (vscode/androidstudio/nessuno)"

switch ($ideChoice.ToLower()) {
    "vscode" {
        if (Get-Command code -ErrorAction SilentlyContinue) {
            code .
        } else {
            Write-Host "Il comando 'code' non è disponibile. Apri VSCode manualmente."
        }
    }
    "androidstudio" {
        if (Get-Command studio64.exe -ErrorAction SilentlyContinue) {
            & "studio64.exe" .
        } elseif (Get-Command studio.bat -ErrorAction SilentlyContinue) {
            & "studio.bat" .
        } else {
            Write-Host "Android Studio non trovato nel PATH. Aprilo manualmente."
        }
    }
    default {
        Write-Host "Puoi aprire il progetto manualmente con l'IDE che preferisci."
    }
}
