# Ubuntu Personal Railway

Container Ubuntu 26.04 serbaguna dengan terminal web berbasis browser yang dilindungi username/password. Repository ini ditujukan untuk deploy langsung dari GitHub ke Railway. Saat login, banner sistem muncul otomatis.

> **Bukan VPS penuh.** Railway menjalankan container aplikasi, bukan server virtual dengan akses host, desktop GUI, atau jaminan systemd penuh.

## Fitur

- Image dasar Ubuntu 26.04
- Terminal browser lewat `ttyd`, login username/password
- Mendukung AMD64 dan ARM64
- Bash login shell dengan banner sistem otomatis
- Informasi OS, kernel, arsitektur, uptime, CPU, RAM, disk, shell, dan timezone
- Tool CLI umum: Git, curl, Python 3, pip/venv, compiler/build tools, dan utilitas shell
- Direktori kerja `/data`, dengan dukungan Railway Volume opsional
- Zona waktu default `Asia/Jakarta`
- Kredensial terminal tidak ditampilkan pada log NOTICE ttyd; pemeriksaan origin WebSocket aktif

## Variabel Railway

Buka **Railway → Service → Variables**, lalu atur variabel berikut:

| Variabel | Wajib | Nilai |
|---|---:|---|
| `TERMINAL_USER` | Ya | Username login; tidak boleh mengandung karakter titik dua (`:`) |
| `TERMINAL_PASSWORD` | Ya | Password unik minimal 16 karakter; 24–40 karakter disarankan |
| `TZ` | Tidak | Default `Asia/Jakarta` |
| `PORT` | Otomatis | Biarkan Railway menyediakannya; jangan hardcode di Variables |

Contoh nilai non-rahasia tersedia di `.env.example`. File itu hanya template lokal; **jangan pernah menaruh password asli di GitHub**. Jika password pernah bocor, ganti `TERMINAL_PASSWORD` di Railway Variables dan restart/redeploy service.

## Deploy ke Railway

1. Buka project Railway atau buat project baru.
2. Pilih **New Project → Deploy from GitHub Repo** lalu pilih repository `ubuntu-railway`.
3. Pastikan Railway membangun dengan `Dockerfile` di root repository.
4. Tambahkan `TERMINAL_USER` dan `TERMINAL_PASSWORD` pada Variables.
5. Deploy service dan periksa **Build Logs**. Dockerfile menjalankan `bash -n` pada skrip entrypoint dan banner agar kesalahan sintaks terdeteksi saat build.
6. Buka **Settings → Networking → Generate Domain**.
7. Kunjungi domain tersebut. Browser akan meminta username dan password.

Aplikasi mendengarkan port dari variabel Railway `PORT` (fallback `8080` untuk penggunaan lokal). Jangan menimpa variabel `PORT` otomatis di Railway.

## Menggunakan terminal

Setelah domain aktif, buka URL dan login dengan `TERMINAL_USER` serta `TERMINAL_PASSWORD`. Shell berjalan sebagai root **di dalam container**, bukan sebagai root host Railway.

Contoh perintah:

```bash
cat /etc/os-release
python3 --version
git --version
pwd
date
```

Bash dijalankan sebagai login shell, jadi banner sistem muncul otomatis ketika sesi terminal baru dibuka. Tidak perlu menjalankan `neofetch` atau `fastfetch` secara manual.

## Volume persisten

Tanpa Volume, data pada filesystem container tidak dijamin bertahan setelah container dibuat ulang atau redeploy.

Untuk menjaga file terminal:

1. Buka **Railway → Service → Settings → Volumes → Add Volume**.
2. Tetapkan **Mount Path** ke `/data`.
3. Simpan file penting di `/data`.

Direktori kerja awal terminal adalah `/data`. File yang disimpan di luar mount point ini tidak otomatis persisten.

## Keamanan dan batasan

- Gunakan password acak, panjang, unik, dan hanya untuk terminal ini.
- ttyd dijalankan dengan `--debug 3` agar log NOTICE yang menyertakan field kredensial tidak ditampilkan; level ERROR/WARN tetap aktif.
- Opsi `--check-origin` membatasi koneksi WebSocket browser ke origin yang sama.
- Shell berjalan sebagai root di dalam container. Siapa pun yang memperoleh akses terminal memiliki hak istimewa tinggi di container.
- Jangan menyimpan API key, token bot, password, atau file rahasia di repository.
- Ini bukan VPS penuh: systemd, Docker-in-Docker, akses kernel host, dan semua daemon tradisional tidak dijamin tersedia.
- Paket sistem tambahan atau browser automation mungkin memerlukan instalasi dan dependensi ekstra.
- Build menggunakan base image distro dan binary ttyd yang diunduh saat build; build memerlukan akses jaringan dan ketersediaan sumber upstream.
- Periksa Build Logs dan Deploy Logs Railway untuk memverifikasi build dan runtime. Source code saja tidak membuktikan deployment sudah berhasil.

## Troubleshooting

**Deployment berhenti langsung:** pastikan `TERMINAL_USER` terisi, tidak mengandung `:`, dan `TERMINAL_PASSWORD` memiliki minimal 16 karakter. Periksa Deploy Logs.

**Build gagal mengunduh ttyd atau paket:** periksa akses build ke GitHub Releases dan repositori paket distro. Pastikan arsitektur build adalah AMD64 atau ARM64.

**Domain terbuka tetapi terminal tidak muncul:** pastikan deployment aktif, domain mengarah ke service yang tepat, dan aplikasi mendengarkan pada `PORT` Railway.

**Browser gagal membuka terminal/WebSocket:** coba buka domain HTTPS yang sama, jangan embed terminal dari origin lain, lalu periksa HTTP/runtime logs.

**Banner tidak terlihat:** buka sesi baru dan pastikan shell yang berjalan adalah Bash login interaktif.

**File hilang setelah redeploy:** pastikan Volume terpasang tepat di `/data` dan simpan file di direktori tersebut.

**Password perlu diganti:** ubah `TERMINAL_PASSWORD` di Railway Variables, lalu restart atau redeploy service.

## Struktur repository

```text
ubuntu-railway/
├── Dockerfile
├── entrypoint.sh
├── system-banner.sh
├── .dockerignore
├── .gitignore
├── .env.example
├── LICENSE
└── README.md
```
