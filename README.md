# KRALİ Marketplace

This repository contains the thin Codex distribution package for KRALİ Marka Araştırma. It does not contain the application, database, research records, owner controls, or server source code.

The package connects Codex to the centrally hosted, verified Site App:

`asdk_app_sites_5ad64395c15481918a00addd7e14076a`

The App binding lets the Site receive the signed-in ChatGPT identity. The package contains no shared API key or employee password.

## ChatGPT desktop install (Windows, no Codex CLI)

Download the repository ZIP, extract it, open `installers/windows`, and double-click `KRALI-Kurulum.bat`.

The installer downloads the current thin package from this repository, copies it into the signed-in Windows user's personal ChatGPT plugin area, and adds KRALI to the personal marketplace without deleting other marketplace entries. Restart ChatGPT desktop, open the Plugins Directory, choose the personal source, and install KRALI Marka Araştırma.

Running the same installer again updates the local package. The installer preserves timestamped backups of an existing KRALI package and personal marketplace file.

## Developer install with Codex CLI

```sh
codex plugin marketplace add izmirli-ali/krali-marketplace --ref main
codex plugin add krali-marka-arastirma@krali
```

Restart the ChatGPT desktop app after installation.

## Update

```sh
codex plugin marketplace upgrade krali
codex plugin add krali-marka-arastirma@krali
```

Restart the ChatGPT desktop app after updating.

## Remove

```sh
codex plugin remove krali-marka-arastirma@krali
codex plugin marketplace remove krali
```

## Central shutdown

The repository controls distribution and updates. The live service's owner-only pause control is the authoritative shutdown mechanism for already installed clients.
