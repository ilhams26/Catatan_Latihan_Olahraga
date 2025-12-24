# FitJournal - Aplikasi Catatan Olahraga & Kesehatan

**Tugas Besar Pemrograman Mobile 1 - Kelompok 9**

FitJournal adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna melacak aktivitas olahraga harian, menghitung kalori, memantau BMI, dan bersaing secara sehat melalui fitur Leaderboard global. Aplikasi ini menerapkan konsep _Clean Architecture_ dengan pemisahan logika bisnis (Provider) dan antarmuka pengguna (UI).

---

## 👥 Anggota Kelompok (Contact Person)

| Nama                 | Peran                     | Kontak (Email/GitHub) |
| :------------------- | :------------------------ | :-------------------- |
| **M. Ilham Ghazali** | Ketua Tim / Backend Logic | [Isi GitHub/Email]    |
| **Tsabita Parisya**  | Tester & Documentation    | [Isi GitHub/Email]    |
| **Ai Siti**          | Tester & Documentation    | [Isi GitHub/Email]    |

---

## 🛠️ Tech Stack & Dependencies

Aplikasi ini dibangun menggunakan **Flutter SDK** dengan dependensi utama berikut (tercantum dalam `pubspec.yaml`):

- **State Management:** `provider` (^6.0.0) - Mengelola state aplikasi secara reaktif.
- **Networking:** `dio` (^5.0.0) - Menangani HTTP Request (GET/POST/PUT) ke REST API.
- **Local Storage:** `shared_preferences` (^2.2.0) - Menyimpan sesi login, tema, dan pengaturan lokal.
- **Utilities:**
  - `intl`: Format tanggal dan angka.
  - `uuid`: Generate ID unik.
  - `google_fonts`: Tipografi kustom.

---

## ⚙️ Setup & Instalasi

Pastikan Anda telah menginstal **Flutter SDK** dan **Git** di komputer Anda.

1.  **Clone Repository**

    ```bash
    git clone [https://github.com/username-anda/fitjournal.git](https://github.com/username-anda/fitjournal.git)
    cd fitjournal
    ```

2.  **Instal Dependensi**
    Jalankan perintah berikut di terminal untuk mengunduh semua paket yang dibutuhkan:

    ```bash
    flutter pub get
    ```

3.  **Setup MockAPI (Opsional)**
    Aplikasi ini menggunakan endpoint MockAPI publik. Jika ingin menggunakan database sendiri, ubah `baseUrl` di file `lib/services/api_service.dart`.

---

## ▶️ Cara Menjalankan Aplikasi (Run)

Hubungkan perangkat Android (via USB) atau jalankan Emulator, lalu ketik perintah berikut di terminal:

```bash
# Menjalankan dalam mode Debug
flutter run

# Atau jalankan tanpa mode debug
flutter run --release
```
