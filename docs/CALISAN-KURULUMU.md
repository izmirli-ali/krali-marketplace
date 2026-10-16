# KRALİ Marka Araştırma — Çalışan Kurulumu

## Gerekenler

- macOS üzerinde güncel ChatGPT Codex masaüstü uygulaması
- Kişisel ChatGPT hesabıyla açık oturum
- İnceleme sırasında açık bir Instagram hesabı

## İlk kurulum

Terminal'i açın ve aşağıdaki iki komutu sırayla çalıştırın:

```sh
codex plugin marketplace add izmirli-ali/krali-marketplace --ref main
codex plugin add krali-marka-arastirma@krali
```

İşlem tamamlandığında Codex'i tamamen kapatıp yeniden açın.

Yeni bir sohbet açın ve şunu yazın:

> KRALİ Marka Araştırma ile yeni bir marka araştırması başlatmak istiyorum.

Sistem soruları aşamalı sorar. Instagram/Reels incelemesi gerektiğinde Work moduna geçin, yalnızca araştırmayla ilgili herkese açık sekmeleri açın ve tarayıcı erişimine izin verin.

## Güncelleme

Yönetici güncelleme duyurduğunda aşağıdaki iki komutu çalıştırın ve Codex'i yeniden başlatın:

```sh
codex plugin marketplace upgrade krali
codex plugin add krali-marka-arastirma@krali
```

## Gizlilik ve kullanım sınırları

- Yalnızca herkese açık marka, rakip ve referans içerikleri incelenir.
- DM, özel hesap, kişisel mesaj veya araştırma dışı sekme incelenmez.
- Beğeni, takip, yorum, kaydetme, paylaşma veya mesaj gönderme yapılmaz.
- Gözlenmeyen metrikler rapora eklenmez.
