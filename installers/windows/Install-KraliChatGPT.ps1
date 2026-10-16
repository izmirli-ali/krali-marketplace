[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$RepositoryArchive = "https://github.com/izmirli-ali/krali-marketplace/archive/refs/heads/main.zip"
$PluginName = "krali-marka-arastirma"
$MarketplaceName = "krali"
$ExpectedAppId = "asdk_app_sites_5ad64395c15481918a00addd7e14076a"

function Write-Step {
    param([string]$Message)
    Write-Host "`n[KRALI] $Message" -ForegroundColor Cyan
}

function Write-JsonUtf8 {
    param(
        [Parameter(Mandatory = $true)] [string]$Path,
        [Parameter(Mandatory = $true)] $Value
    )

    $json = $Value | ConvertTo-Json -Depth 30
    $utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $json + [Environment]::NewLine, $utf8WithoutBom)
}

function Ensure-Property {
    param(
        [Parameter(Mandatory = $true)] $Object,
        [Parameter(Mandatory = $true)] [string]$Name,
        [Parameter(Mandatory = $true)] $Value
    )

    if ($null -eq $Object.PSObject.Properties[$Name]) {
        $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $Value
    } else {
        $Object.$Name = $Value
    }
}

$userProfile = [Environment]::GetFolderPath("UserProfile")
if ([string]::IsNullOrWhiteSpace($userProfile)) {
    throw "Windows kullanici profili bulunamadi."
}

$codexPluginsRoot = Join-Path $userProfile ".codex\plugins"
$pluginDestination = Join-Path $codexPluginsRoot $PluginName
$marketplaceDirectory = Join-Path $userProfile ".agents\plugins"
$marketplacePath = Join-Path $marketplaceDirectory "marketplace.json"
$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$tempRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("krali-chatgpt-" + [Guid]::NewGuid().ToString("N"))
$zipPath = Join-Path $tempRoot "krali-marketplace.zip"
$extractPath = Join-Path $tempRoot "archive"

try {
    Write-Step "Guncel ChatGPT eklenti paketi indiriliyor..."
    New-Item -ItemType Directory -Path $tempRoot -Force | Out-Null
    Invoke-WebRequest -Uri $RepositoryArchive -OutFile $zipPath -UseBasicParsing
    Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

    $downloadedPlugin = Get-ChildItem -Path $extractPath -Directory |
        Select-Object -First 1 |
        ForEach-Object { Join-Path $_.FullName "plugins\$PluginName" }

    if (-not $downloadedPlugin -or -not (Test-Path (Join-Path $downloadedPlugin "plugin.json"))) {
        throw "Indirilen pakette plugin.json bulunamadi. Kurulum durduruldu."
    }

    $appBindingPath = Join-Path $downloadedPlugin ".app.json"
    if (-not (Test-Path $appBindingPath)) {
        throw "Indirilen pakette ChatGPT App baglantisi bulunamadi. Kurulum durduruldu."
    }

    $appBindingText = Get-Content -Raw -Path $appBindingPath
    if ($appBindingText -notmatch [Regex]::Escape($ExpectedAppId)) {
        throw "Beklenen KRALI ChatGPT App kimligi dogrulanamadi. Kurulum durduruldu."
    }

    Write-Step "Eklenti kullaniciya ozel ChatGPT alanina kuruluyor..."
    New-Item -ItemType Directory -Path $codexPluginsRoot -Force | Out-Null

    if (Test-Path $pluginDestination) {
        $pluginBackup = "$pluginDestination.backup-$timestamp"
        Move-Item -Path $pluginDestination -Destination $pluginBackup
        Write-Host "Onceki surum yedeklendi: $pluginBackup" -ForegroundColor DarkGray
    }

    Copy-Item -Path $downloadedPlugin -Destination $pluginDestination -Recurse -Force

    Write-Step "ChatGPT kisisel eklenti listesi guncelleniyor..."
    New-Item -ItemType Directory -Path $marketplaceDirectory -Force | Out-Null

    if (Test-Path $marketplacePath) {
        Copy-Item -Path $marketplacePath -Destination "$marketplacePath.backup-$timestamp" -Force
        try {
            $marketplace = Get-Content -Raw -Path $marketplacePath | ConvertFrom-Json
        } catch {
            throw "Mevcut marketplace.json okunamadi. Dosya degistirilmedi; yedegi olusturuldu."
        }
    } else {
        $marketplace = [PSCustomObject]@{
            name = $MarketplaceName
            interface = [PSCustomObject]@{
                displayName = "KRALI"
            }
            plugins = @()
        }
    }

    if ($null -eq $marketplace) {
        throw "Kisisel marketplace dosyasi bos veya gecersiz."
    }

    if ($null -eq $marketplace.PSObject.Properties["plugins"]) {
        $marketplace | Add-Member -NotePropertyName "plugins" -NotePropertyValue @()
    }

    $existingPlugins = @($marketplace.plugins | Where-Object { $_.name -ne $PluginName })
    $kraliEntry = [PSCustomObject]@{
        name = $PluginName
        source = [PSCustomObject]@{
            source = "local"
            path = "./.codex/plugins/$PluginName"
        }
        policy = [PSCustomObject]@{
            installation = "AVAILABLE"
            authentication = "ON_INSTALL"
        }
        category = "Marketing"
    }

    Ensure-Property -Object $marketplace -Name "plugins" -Value @($existingPlugins + $kraliEntry)
    Write-JsonUtf8 -Path $marketplacePath -Value $marketplace

    Write-Step "Kurulum tamamlandi."
    Write-Host "1. ChatGPT masaustu uygulamasini tamamen kapatip yeniden acin." -ForegroundColor Green
    Write-Host "2. Eklentiler dizininde kisisel kaynak altinda KRALI'yi bulun." -ForegroundColor Green
    Write-Host "3. KRALI Marka Arastirma icin Yukle secenegini kullanin." -ForegroundColor Green
    Write-Host "`nBu pencereyi kapatmak icin Enter'a basin."
    [void](Read-Host)
} catch {
    Write-Host "`n[KRALI] Kurulum tamamlanamadi:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host "`nMevcut ChatGPT eklentileri bilerek silinmedi. Enter'a basin."
    [void](Read-Host)
    exit 1
} finally {
    if (Test-Path $tempRoot) {
        Remove-Item -Path $tempRoot -Recurse -Force -ErrorAction SilentlyContinue
    }
}
