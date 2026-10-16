# KRALİ Dağıtım — Yönetici Rehberi

## Mimari

- Ana uygulama ve sunucu kaynakları özel depoda tutulur.
- Bu dağıtım deposu yalnızca eklenti manifestlerini, çalışma talimatını ve canlı MCP adresini içerir.
- Araştırma verileri ve sahiplik anahtarları GitHub'a konulmaz.

## Sürüm yayınlama

1. `plugin.json` ve `.codex-plugin/plugin.json` içindeki sürümü aynı semantik sürüme yükseltin.
2. Değişiklikleri `main` dalına gönderin.
3. Çalışanlara güncelleme komutlarını iletin.

## Çalışan güncelleme komutları

```sh
codex plugin marketplace upgrade krali
codex plugin add krali-marka-arastirma@krali
```

## Sistemi durdurma

GitHub deposunu silmek yalnızca yeni kurulum ve güncellemeleri durdurur. Kurulu istemcileri durdurmak için canlı sistemdeki sahip yetkili merkezi duraklatma aracını kullanın. İstemciler araştırmaya başlamadan önce `system_status` çağırmak zorundadır.

## Kaynak gizliliği

Çalışanlar dağıtım paketindeki manifestleri ve çalışma talimatını görebilir. Ana Site, sunucu, veritabanı, kalite kapısı ve yönetim kodları bu depoda yer almaz.
