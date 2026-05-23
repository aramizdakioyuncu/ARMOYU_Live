<h1 align="center">ARMOYU Live</h1>

<p align="center">
	Desktop client for the ARMOYU community, built with Flutter and GetX.
</p>

<p align="center">
	<img src="https://img.shields.io/badge/Flutter-3.4%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
	<img src="https://img.shields.io/badge/GetX-State%20Management-7C3AED?style=for-the-badge" alt="GetX" />
	<img src="https://img.shields.io/badge/Platform-Windows%20Desktop-111827?style=for-the-badge" alt="Windows Desktop" />
	<img src="https://img.shields.io/badge/License-MIT-10B981?style=for-the-badge" alt="MIT License" />
</p>

> Turkish documentation is available below this English section.

## Overview

ARMOYU Live is a desktop-first Flutter client for the ARMOYU community. It combines group management, messaging, discovery pages, voice-room interactions, and account settings in one polished interface.

## Highlights

- Reactive state management with GetX
- Desktop-oriented custom window behavior
- Login flow with remember-me and auto-login support
- Home, explore, and group navigation flows
- Messaging, direct messages, and group rooms
- Voice and video communication components
- Settings screen and account management
- Turkish UI with multilingual infrastructure

## Tech Stack

| Layer | Packages |
| --- | --- |
| UI & State | Flutter, GetX |
| Windowing | `window_manager` |
| Realtime | `socket_io_client`, `flutter_webrtc` |
| Media | `media_kit`, `audioplayers`, `record` |
| Persistence | `shared_preferences` |
| Assets | `cached_network_image` |

## Requirements

- Flutter SDK `>=3.4.4`
- Windows desktop environment
- Access to ARMOYU services

## Quick Start

```bash
flutter pub get
flutter run -d windows
```

To see available devices:

```bash
flutter devices
```

## Project Structure

```text
lib/
	main.dart                App entry point and window initialization
	app/
		utils/                 App config and routing
		modules/               Screens and feature modules
		widgets/               Shared UI components
		services/              Socket, media, and platform services
```

## Notes

- The app is designed for desktop behavior.
- Windows uses custom window settings.
- Some screens may require ARMOYU services to be available.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

<h1 align="center">ARMOYU Live</h1>

<p align="center">
	ARMOYU topluluğu için geliştirilmiş Flutter tabanlı masaüstü istemcisi.
</p>

> Türkçe dokümantasyon, bu İngilizce bölümün aşağısındadır.

## Genel Bakış

ARMOYU Live; grup yönetimi, mesajlaşma, keşfet sayfaları, sesli oda etkileşimleri ve kullanıcı hesabı ayarlarını tek bir masaüstü odaklı arayüzde birleştirir.

## Öne Çıkanlar

- GetX tabanlı reaktif state management
- Masaüstü odaklı özel pencere yapısı
- Giriş ekranı, oturum hatırlama ve otomatik giriş desteği
- Ana sayfa, keşfet ve grup gezinme akışları
- Mesajlaşma, direkt mesajlar ve grup odaları
- Sesli / görüntülü iletişim bileşenleri
- Ayarlar ekranı ve kullanıcı hesap yönetimi
- Türkçe arayüz ve çoklu dil altyapısı

## Teknoloji Yığını

| Katman | Paketler |
| --- | --- |
| UI & State | Flutter, GetX |
| Pencere Yönetimi | `window_manager` |
| Gerçek Zamanlı İletişim | `socket_io_client`, `flutter_webrtc` |
| Medya | `media_kit`, `audioplayers`, `record` |
| Kalıcılık | `shared_preferences` |
| Görsel Varlıklar | `cached_network_image` |

## Gereksinimler

- Flutter SDK `>=3.4.4`
- Windows masaüstü ortamı
- ARMOYU servislerine erişim

## Hızlı Başlangıç

```bash
flutter pub get
flutter run -d windows
```

Mevcut cihazları görmek için:

```bash
flutter devices
```

## Proje Yapısı

```text
lib/
	main.dart                Uygulama başlangıcı ve pencere kurulumu
	app/
		utils/                 Uygulama konfigürasyonu ve yönlendirme
		modules/               Ekranlar ve özellik modülleri
		widgets/               Ortak arayüz bileşenleri
		services/              Socket, medya ve platform servisleri
```

## Notlar

- Uygulama masaüstü davranışına göre tasarlanmıştır.
- Windows tarafında özel pencere ayarları kullanılır.
- Bazı ekranlar ARMOYU servisleri aktif olmadan tam çalışmayabilir.

## Lisans

Bu proje MIT Lisansı ile lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.
