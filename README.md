# Ubuntu Personal Railway

Container Ubuntu serbaguna dengan terminal web yang dilindungi username/password. Dirancang untuk deploy dari GitHub ke Railway dan diakses melalui domain Railway atau custom domain milikmu. Saat masuk terminal, banner sistem bergaya neofetch/fastfetch muncul otomatis.

> **Bukan VPS penuh.** Railway menjalankan container aplikasi. Repo ini menyediakan terminal shell berbasis browser, bukan desktop Ubuntu/GUI dan bukan jaminan akses SSH tradisional.

## Fitur

- Ubuntu 26.04
- Terminal browser menggunakan `ttyd`
- Autentikasi username/password melalui Railway Variables
- Banner sistem otomatis saat login: logo bergaya Ubuntu, OS, kernel, uptime, CPU, RAM, disk, shell, dan timezone
- `fastfetch` digunakan jika tersedia; skrip Bash fallback tetap menampilkan informasi sistem
- Tool CLI umum: Git, curl, Python 3, pip, venv, compiler/build tools, dan utilitas shell
- Direktori kerja `/data` (Volume persisten opsional)
- Zona waktu default `Asia/Jakarta`
- Tidak memasukkan API key atau token provider tertentu secara hardcode

## Variabel Railway

Buka **Railway → project → service → Variables**, lalu tambahkan:

| Variable | Wajib? | Nilai |
|---|---:|---|
| `TERMINAL_USER` | Ya | Username login terminal, tanpa karakter titik dua (`:`) |
| `TERMINAL_PASSWORD` | Ya | Password unik minimal 16 karakter; 24–40 karakter disarankan |
| `TZ` | Opsional | `Asia/Jakarta` |
| `PORT` | Otomatis | Biarkan Railway menyediakannya |

Jangan commit password asli ke GitHub, README, atau file `.env` yang di-commit. Jika password pernah bocor, ganti di Railway Variables lalu restart/redeploy service.

## Deploy ke Railway

1. Buka [Railway](https://railway.com/) dan pilih **New Project → Deploy from GitHub Repo**.
2. Pilih repository ini dan pastikan Railway membangun menggunakan `Dockerfile` di root.
3. Buka service → **Variables**. Isi `TERMINAL_USER` dan `TERMINAL_PASSWORD`. Atur `TZ=Asia/Jakarta` bila diperlukan.
4. Buka **Settings → Networking → Generate Domain** untuk membuat domain `*.up.railway.app`.
5. Buka domain tersebut. Browser akan meminta username dan password.

## Banner otomatis

Tidak perlu mengetik `neofetch` atau perintah lain. Skrip `/etc/profile.d/00-system-banner.sh` dipanggil otomatis oleh Bash saat terminal login interaktif dibuka. Skrip menjalankan `fastfetch` bila terpasang, atau menampilkan banner fallback dengan data aktual yang terlihat dari container.

Informasi CPU dan RAM berasal dari sistem/container yang terlihat oleh proses, bukan jaminan kuota paket Railway. Kapasitas disk ditampilkan untuk filesystem yang menaungi `/data`.

## Penyimpanan dan Volume

Tanpa Volume, file yang tersimpan di filesystem container tidak dijamin bertahan setelah container dibuat ulang atau redeploy.

Untuk menyimpan file penting lintas redeploy, buka **Settings → Volumes → Add Volume** dan tetapkan **Mount Path** ke `/data`. Simpan file terminal di direktori `/data` agar menggunakan Volume tersebut.

## Keamanan dan batasan

- Terminal ini dapat diakses dari internet melalui domain Railway, jadi gunakan password panjang dan unik.
- Shell berjalan sebagai root di dalam container.
- Jangan membagikan URL beserta password; rotasi password jika ada dugaan kebocoran.
- Ini bukan mesin untuk menjalankan desktop GUI, systemd penuh, Docker-in-Docker, atau semua perilaku VPS tradisional.
- Penggunaan resource dan biaya mengikuti paket serta pemakaian Railway.
- Keberhasilan build dan runtime tetap perlu diperiksa pada **Deploy Logs** Railway.

## Troubleshooting

**Deployment langsung berhenti:** pastikan `TERMINAL_USER` terisi dan `TERMINAL_PASSWORD` memiliki minimal 16 karakter, lalu periksa Deploy Logs.

**Domain terbuka tetapi terminal tidak muncul:** periksa Deploy Logs, pastikan service berjalan, dan gunakan domain yang terhubung ke port aplikasi. Railway biasanya menyediakan variable `PORT` secara otomatis.

**Banner tidak terlihat:** buka sesi terminal baru dan pastikan shell yang dijalankan adalah Bash login interaktif.

**File hilang setelah redeploy:** pastikan Railway Volume terpasang tepat di `/data` dan simpan file di direktori itu.

**Ingin mengubah password:** ubah `TERMINAL_PASSWORD` di Railway Variables, lalu restart/redeploy service.

## Struktur repository

```text
.
├── Dockerfile
├── entrypoint.sh
├── system-banner.sh
├── .dockerignore
├── .gitignore
├── .env.example
└── README.md
```
