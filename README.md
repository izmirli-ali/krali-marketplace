# KRALİ Marketplace

This repository contains the thin Codex distribution package for KRALİ Marka Araştırma. It does not contain the application, database, research records, owner controls, or server source code.

The package connects Codex to the centrally hosted MCP endpoint:

`https://krali-arastirma-gate.neon-siren-7953.chatgpt.site/mcp`

## Install

```sh
codex plugin marketplace add izmirli-ali/krali-marketplace --ref main
codex plugin add krali-marka-arastirma@krali
```

Restart Codex after installation.

## Update

```sh
codex plugin marketplace upgrade krali
codex plugin add krali-marka-arastirma@krali
```

Restart Codex after updating.

## Remove

```sh
codex plugin remove krali-marka-arastirma@krali
codex plugin marketplace remove krali
```

## Central shutdown

The repository controls distribution and updates. The live service's owner-only pause control is the authoritative shutdown mechanism for already installed clients.
