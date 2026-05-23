# ARMOYU Live

ARMOYU Live, ARMOYU topluluğu için hazırlanmış Flutter tabanlı masaüstü istemcisidir. Uygulama; grup yönetimi, mesajlaşma, sesli oda etkileşimleri, keşfet sayfaları ve kullanıcı hesabı ayarları gibi alanları tek bir modern arayüzde toplar.

## Özellikler

- GetX tabanlı reaktif state management
- Masaüstü odaklı özel pencere yapısı
- Giriş ekranı, oturum hatırlama ve otomatik giriş desteği
- Ana sayfa, keşfet ve grup gezinme akışları
- Mesajlaşma, direkt mesajlar ve grup odaları
- Sesli / görüntülü iletişim bileşenleri
- Ayarlar ekranı ve kullanıcı hesap yönetimi
- Türkçe arayüz ve çoklu dil altyapısı

## Kullanılan Teknolojiler

- Flutter
- GetX
- `window_manager`
- `socket_io_client`
- `flutter_webrtc`
- `media_kit`
- `shared_preferences`
- `cached_network_image`

## Gereksinimler

- Flutter SDK `>=3.4.4`
- Windows için masaüstü çalışma ortamı
- ARMOYU servislerine erişim

## Kurulum

```bash
flutter pub get
```

## Çalıştırma

```bash
flutter run -d windows
```

İsterseniz mevcut cihaz listesini görmek için:

```bash
flutter devices
```

## Proje Yapısı

- `lib/main.dart` uygulama başlangıcı ve pencere kurulumu
- `lib/app/utils/` uygulama konfigürasyonu ve rota yapısı
- `lib/app/modules/` ekranlar ve modüller
- `lib/app/widgets/` ortak arayüz bileşenleri
- `lib/app/services/` bağlantı, socket ve medya servisleri

## Dikkat Edilmesi Gerekenler

- Uygulama masaüstü davranışına göre tasarlanmıştır.
- Windows tarafında özel pencere ayarları kullanılır.
- Bazı ekranlar ARMOYU servisleri aktif olmadan tam çalışmayabilir.

## Lisans

Bu proje için henüz bir lisans tanımlanmamıştır.
