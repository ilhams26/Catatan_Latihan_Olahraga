# FitJournal (Catatan Olahraga)

**Tugas Besar Pemrograman Mobile 1 - Kelompok 9**

FitJournal (Package Name: `catatan_olahraga`) adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna melacak aktivitas olahraga harian, menghitung kalori, memantau BMI, dan bersaing secara sehat melalui fitur Leaderboard global. Aplikasi ini menerapkan konsep _Clean Architecture_ dengan pemisahan logika bisnis (Provider) dan antarmuka pengguna (UI).

---

## 👥 Anggota Kelompok

Berikut adalah daftar anggota kelompok yang berkontribusi dalam proyek ini:

| Nama                 | Peran                          | GitHub                                                               | WhatsApp           |
| :------------------- | :----------------------------- | :------------------------------------------------------------------- | :----------------- |
| **M. Ilham Ghazali** | Ketua Tim / UI & Backend Logic | [GitHub Ilham Ghazali](https://github.com/USERNAME_ILHAM)            | **0812-6539-8468** |
| **Tsabita Parisya**  | Tester & Documentation         | [GitHub tsaabitaparisya-art](https://github.com/tsaabitaparisya-art) | -                  |
| **Ai Siti**          | Tester & Documentation         | [GitHub aisitinp](https://github.com/aisitinp)                       | -                  |

_(Silakan klik link pada kolom GitHub untuk melihat profil kontributor)_

---

## Tech Stack & Dependencies

Aplikasi ini dibangun menggunakan **Flutter SDK** (Dart SDK `^3.9.0`) dengan dependensi utama berikut sesuai `pubspec.yaml`:

### Core Dependencies

- **State Management:** `provider` (^6.1.5+1) - Mengelola state aplikasi secara reaktif.
- **Networking:** `dio` (^5.9.0) - Menangani HTTP Request (GET/POST/PUT) ke REST API.
- **Local Storage:** `shared_preferences` (^2.5.3) - Menyimpan sesi login, tema, dan pengaturan lokal.

### Utilities & UI

- **Formatting:** `intl` (^0.20.2) - Format tanggal dan angka.
- **Unique ID:** `uuid` (^4.5.2) - Generate ID unik untuk data lokal.
- **Typography:** `google_fonts` (^6.0.0) - Menggunakan font kustom dari Google Fonts.
- **Icons:** `cupertino_icons` (^1.0.8) - Set ikon standar iOS/Flutter.

---

## Setup & Instalasi

Pastikan Anda telah menginstal **Flutter SDK** dan **Git** di komputer Anda.

1.  **Clone Repository**
    Buka terminal dan jalankan perintah berikut:

    ```bash
    git clone [https://github.com/USERNAME_GITHUB/NAMA_REPO.git](https://github.com/USERNAME_GITHUB/NAMA_REPO.git)
    cd catatan_olahraga
    ```

2.  **Instal Dependensi**
    Jalankan perintah ini untuk mengunduh semua paket yang tercantum di `pubspec.yaml`:

    ```bash
    flutter pub get
    ```

3.  **Setup API (Opsional)**
    Aplikasi ini menggunakan endpoint MockAPI. Jika ingin menggunakan database sendiri, ubah `baseUrl` di file `lib/services/api_service.dart`.

---

## ▶️ Cara Menjalankan Aplikasi (Run)

Hubungkan perangkat Android (via USB) atau jalankan Emulator, lalu ketik perintah berikut di terminal:

**Mode Debug (Pengembangan):**

```bash
flutter run
```
