# KRALİ Dağıtım — Yönetici Rehberi

## Mimari

- Ana uygulama ve sunucu kaynakları özel depoda tutulur.
- Bu dağıtım deposu yalnızca eklenti manifestlerini, çalışma talimatını ve doğrulanmış Site App kimliğini içerir.
- Bağlantı, çalışan parolası veya ortak API anahtarı yerine ChatGPT'nin App kimlik bağlamını kullanır.
- Araştırma verileri ve sahiplik anahtarları GitHub'a konulmaz.

## Sürüm yayınlama

1. `plugin.json` ve `.codex-plugin/plugin.json` içindeki sürümü aynı semantik sürüme yükseltin.
2. Değişiklikleri `main` dalına gönderin.
3. Çalışanlara güncelleme komutlarını iletin.

## Çalışan güncelleme komutları

Çalışanlara deponun ZIP paketini veya yalnızca `installers/windows` klasörünü iletin. Çalışan `KRALI-Kurulum.bat` dosyasını çift tıklar. Kurucu güncel ince paketi bu GitHub deposundan indirir; Codex CLI gerektirmez.

Kurulumdan veya güncellemeden sonra çalışan ChatGPT masaüstü uygulamasını yeniden başlatır. İlk kurulumda Eklentiler dizinindeki kişisel kaynaktan **KRALİ Marka Araştırma** eklentisini yükler.

## Sistemi durdurma

GitHub deposunu silmek yalnızca yeni kurulum ve güncellemeleri durdurur. Kurulu istemcileri durdurmak için canlı sistemdeki sahip yetkili merkezi duraklatma aracını kullanın. İstemciler araştırmaya başlamadan önce `system_status` çağırmak zorundadır.

## Kaynak gizliliği

Çalışanlar dağıtım paketindeki manifestleri ve çalışma talimatını görebilir. Ana Site, sunucu, veritabanı, kalite kapısı ve yönetim kodları bu depoda yer almaz.
