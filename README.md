# Ubuntu Personal Railway + Hermes Agent

Container Ubuntu dengan terminal web yang dilindungi username/password, banner sistem otomatis seperti neofetch/fastfetch, dan Hermes Agent CLI. Saat konfigurasi Hermes selesai, Gateway dapat dimulai otomatis ketika service Railway start.

> **Bukan VPS penuh.** Railway menjalankan container aplikasi. Repo ini menyediakan terminal berbasis browser, bukan desktop Ubuntu/GUI atau jaminan akses SSH tradisional.

## Fitur

- Ubuntu 26.04
- Terminal browser menggunakan `ttyd` dan autentikasi username/password
- Banner otomatis saat login: logo Ubuntu, OS, kernel, uptime, CPU, RAM, disk, timezone dan status Hermes
- `fastfetch` dipakai bila tersedia; banner Bash fallback digunakan jika tidak tersedia
- Hermes Agent CLI dipasang saat image dibangun
- Hermes Gateway auto-start dengan restart loop jika `HERMES_HOME/config.yaml` sudah tersedia
- Zona waktu default `Asia/Jakarta`

## Variabel Railway

Buka **Railway → project → service → Variables** lalu isi:

| Variable | Wajib? | Nilai |
|---|---:|---|
| `TERMINAL_USER` | Ya | Username login terminal, tanpa karakter `: ` |
| `TERMINAL_PASSWORD` | Ya | Password unik acak minimal 16 karakter; 24–40 karakter disarankan |
| `TZ` | Opsional | `Asia/Jakarta` |
| `HERMES_HOME` | Opsional | Default `/opt/data` |
| `HERMES_AUTOSTART` | Opsional | `true` untuk auto-start Gateway (default), atau `false` untuk menonaktifkan |
| `PORT` | Otomatis | Biarkan Railway menyediakannya |

Jangan commit password, API key, atau token ke GitHub. Konfigurasikan provider dan token channel melalui CLI Hermes.

## Deploy ke Railway

1. Pastikan Railway membangun dari `Dockerfile` di root repository.
2. Pilih **Deploy from GitHub Repo** dan hubungkan repo ini.
3. Isi `TERMINAL_USER` dan `TERMINAL_PASSWORD` di Railway Variables.
4. Generate domain di **Settings → Networking**.
5. Buka domain lalu login memakai username/password tadi.

## Setup Hermes pertama kali

Dari terminal web, jalankan:

```bash
hermes --help
hermes setup
```

Ikuti wizard untuk provider/model serta API key. Untuk mengonfigurasi Telegram/Discord, jalankan:

```bash
hermes gateway setup
```

Setelah konfigurasi selesai, restart service Railway. Entrypoint akan memeriksa file `${HERMES_HOME}/config.yaml` dan mencoba menjalankan `hermes gateway` otomatis. Untuk mencoba menjalankan Gateway secara manual dari terminal gunakan:

```bash
start-hermes
```

Auto-start hanya berjalan jika file konfigurasi berada di `HERMES_HOME/config.yaml`. Pastikan hasil wizard Hermes memang tersimpan di lokasi tersebut.

## Banner otomatis

Tidak perlu mengetik `neofetch` atau perintah lain. Skrip `/etc/profile.d/00-system-banner.sh` dipanggil otomatis oleh Bash saat terminal login interaktif dibuka. Skrip menjalankan `fastfetch` bila terpasang, atau menampilkan banner fallback dengan data aktual dari container.

CPU dan RAM yang ditampilkan adalah nilai yang terlihat dari container, bukan jaminan kuota paket Railway. Kapasitas disk menunjukkan filesystem yang terpasang ke `/data`.

## Penyimpanan dan Volume

Filesystem container tanpa Volume tidak dijamin bertahan ketika container dibuat ulang atau redeploy.

- Untuk mempertahankan konfigurasi dan data Hermes, tambahkan Railway Volume dengan **Mount Path** `/opt/data`.
- Untuk mempertahankan file yang disimpan dari terminal, tambahkan Volume dengan **Mount Path** `/data`.
- Kedua direktori memiliki tujuan berbeda. Jangan mount path berbeda dari `HERMES_HOME` tanpa memperbarui variable tersebut.

## Keamanan dan batasan

- Terminal publik dilindungi username/password. Gunakan password panjang dan unik.
- Shell berjalan sebagai root di dalam container.
- Gateway berjalan hanya selama service/container hidup; ini bukan jaminan uptime VPS 24/7.
- Tanpa Volume yang benar, data konfigurasi atau file dapat hilang saat container dibuat ulang.
- Build dan runtime perlu diperiksa melalui Deploy Logs Railway; paket eksternal dan perilaku image dapat berubah.

## Troubleshooting

**Service langsung berhenti:** pastikan `TERMINAL_USER` terisi, `TERMINAL_PASSWORD` minimal 16 karakter, dan periksa Deploy Logs.

**Banner tidak terlihat:** buka sesi terminal baru dan pastikan shell yang dijalankan adalah Bash login interaktif.

**Hermes tidak otomatis jalan:** selesaikan `hermes setup` dan `hermes gateway setup`, pastikan `${HERMES_HOME}/config.yaml` ada, lalu restart service.

**Telegram/Discord tidak membalas:** periksa token, izin bot, konfigurasi channel, provider/model, dan runtime logs.

**File hilang setelah redeploy:** mount Volume pada `/opt/data` untuk Hermes dan/atau `/data` untuk file terminal.

## Struktur repository

```text
.
├── Dockerfile
├── entrypoint.sh
├── system-banner.sh
├── start-hermes
├── .dockerignore
├── .gitignore
├── .env.example
└── README.md
```
