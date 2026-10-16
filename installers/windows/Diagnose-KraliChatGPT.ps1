[CmdletBinding()]
param()

$ErrorActionPreference = "Continue"
Set-StrictMode -Version 2.0

$PluginName = "krali-marka-arastirma"
$userProfile = [Environment]::GetFolderPath("UserProfile")
$marketplacePath = Join-Path $userProfile ".agents\plugins\marketplace.json"
$pluginPath = Join-Path $userProfile ".codex\plugins\$PluginName"
$configPath = Join-Path $userProfile ".codex\config.toml"
$cacheRoot = Join-Path $userProfile ".codex\plugins\cache"
$lines = New-Object System.Collections.Generic.List[string]

function Add-Line {
    param([string]$Text = "")
    $script:lines.Add($Text)
    Write-Host $Text
}

function Add-Check {
    param(
        [string]$Name,
        [bool]$Passed,
        [string]$Detail
    )

    $status = if ($Passed) { "OK" } else { "EKSIK" }
    Add-Line ("[{0}] {1}: {2}" -f $status, $Name, $Detail)
}

Add-Line "KRALI ChatGPT Windows Teshis Raporu"
Add-Line ("Tarih: {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss zzz"))
Add-Line ("PowerShell: {0}" -f $PSVersionTable.PSVersion.ToString())

try {
    $os = Get-CimInstance Win32_OperatingSystem
    Add-Line ("Windows: {0} / build {1}" -f $os.Caption, $os.BuildNumber)
} catch {
    Add-Line "Windows surumu okunamadi."
}

Add-Line ""
Add-Line "1) ChatGPT uygulamasi"
try {
    $packages = @(Get-AppxPackage | Where-Object {
        $_.Name -match "ChatGPT|OpenAI|Codex" -or $_.PackageFullName -match "ChatGPT|OpenAI|Codex"
    })

    if ($packages.Count -eq 0) {
        Add-Check "Microsoft Store paketi" $false "ChatGPT/OpenAI adli AppX paketi bulunamadi"
    } else {
        foreach ($package in $packages) {
            Add-Check "Microsoft Store paketi" $true ("{0} surum {1}" -f $package.Name, $package.Version)
        }
    }
} catch {
    Add-Line ("[UYARI] AppX paketleri okunamadi: {0}" -f $_.Exception.Message)
}

try {
    $processes = @(Get-Process | Where-Object { $_.ProcessName -match "ChatGPT|OpenAI|Codex" })
    Add-Check "Calisan ChatGPT sureci" ($processes.Count -gt 0) (
        if ($processes.Count -gt 0) { ($processes.ProcessName -join ", ") } else { "calismiyor" }
    )
} catch {
    Add-Line ("[UYARI] Calisan surecler okunamadi: {0}" -f $_.Exception.Message)
}

Add-Line ""
Add-Line "2) Kisisel marketplace"
$marketplaceExists = Test-Path $marketplacePath
Add-Check "marketplace.json" $marketplaceExists "~/.agents/plugins/marketplace.json"

if ($marketplaceExists) {
    try {
        $marketplace = Get-Content -Raw -Path $marketplacePath | ConvertFrom-Json
        Add-Check "Marketplace JSON" $true "gecerli JSON"
        Add-Line ("Marketplace adi: {0}" -f $marketplace.name)

        $entry = @($marketplace.plugins | Where-Object { $_.name -eq $PluginName }) | Select-Object -First 1
        Add-Check "KRALI marketplace kaydi" ($null -ne $entry) (
            if ($null -ne $entry) { "bulundu" } else { "bulunamadi" }
        )

        if ($null -ne $entry) {
            Add-Line ("Kayit durumu: {0}" -f $entry.policy.installation)
            Add-Line ("Kaynak yolu: {0}" -f $entry.source.path)
            $relativePath = [string]$entry.source.path
            $relativePath = $relativePath -replace "^\./", ""
            $resolvedPath = Join-Path $userProfile ($relativePath -replace "/", "\")
            Add-Check "Marketplace hedefi" (Test-Path $resolvedPath) "kayitli kaynak yolu"
        }
    } catch {
        Add-Check "Marketplace JSON" $false $_.Exception.Message
    }
}

Add-Line ""
Add-Line "3) KRALI eklenti dosyalari"
$pluginExists = Test-Path $pluginPath
Add-Check "Eklenti klasoru" $pluginExists "~/.codex/plugins/krali-marka-arastirma"

foreach ($relativeFile in @("plugin.json", ".app.json", ".codex-plugin\plugin.json", "skills\krali-arastirma\SKILL.md")) {
    $filePath = Join-Path $pluginPath $relativeFile
    Add-Check $relativeFile (Test-Path $filePath) $relativeFile
}

if (Test-Path (Join-Path $pluginPath "plugin.json")) {
    try {
        $pluginManifest = Get-Content -Raw -Path (Join-Path $pluginPath "plugin.json") | ConvertFrom-Json
        Add-Line ("Eklenti surumu: {0}" -f $pluginManifest.version)
        Add-Line ("Eklenti adi: {0}" -f $pluginManifest.name)
    } catch {
        Add-Line ("[HATA] plugin.json okunamadi: {0}" -f $_.Exception.Message)
    }
}

Add-Line ""
Add-Line "4) Kurulu kopya ve etkinlestirme"
$cachedVersions = @()
if (Test-Path $cacheRoot) {
    $cachedVersions = @(Get-ChildItem -Path $cacheRoot -Directory -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -match "krali" -or $_.Name -eq $PluginName } |
        Select-Object -ExpandProperty FullName)
}
Add-Check "ChatGPT eklenti onbellegi" ($cachedVersions.Count -gt 0) (
    if ($cachedVersions.Count -gt 0) { "KRALI ile ilgili kayit bulundu" } else { "KRALI kaydi yok" }
)

$configExists = Test-Path $configPath
Add-Check "config.toml" $configExists "~/.codex/config.toml"
if ($configExists) {
    $kraliConfig = @(Select-String -Path $configPath -Pattern "krali" -SimpleMatch -ErrorAction SilentlyContinue)
    Add-Check "KRALI etkinlestirme kaydi" ($kraliConfig.Count -gt 0) (
        if ($kraliConfig.Count -gt 0) { "KRALI satiri bulundu" } else { "KRALI satiri yok" }
    )
}

Add-Line ""
Add-Line "Bu rapor sohbet, parola, cerez, tarayici gecmisi veya Instagram verisi okumaz."

$desktop = [Environment]::GetFolderPath("Desktop")
if ([string]::IsNullOrWhiteSpace($desktop) -or -not (Test-Path $desktop)) {
    $desktop = (Get-Location).Path
}
$reportPath = Join-Path $desktop "KRALI-Teshis.txt"
$utf8WithoutBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllLines($reportPath, $lines, $utf8WithoutBom)

Write-Host "`nRapor kaydedildi: $reportPath" -ForegroundColor Green
Write-Host "Bu dosyayi KRALI yoneticisine iletin. Kapatmak icin Enter'a basin."
[void](Read-Host)
