# Ubuntu Personal Railway

Ubuntu 26.04 LTS container dengan terminal web yang dilindungi username/password. Dirancang untuk deploy dari GitHub ke Railway dan diakses melalui domain Railway atau custom domain milikmu.

> **Bukan VPS penuh.** Railway menjalankan container aplikasi. Repo ini menyediakan terminal shell berbasis browser, bukan desktop Ubuntu/GUI dan bukan jaminan akses SSH tradisional.

## Fitur

- Ubuntu 26.04 LTS (Resolute Raccoon)
- Terminal browser menggunakan `ttyd`
- HTTP Basic Authentication melalui Railway Variables
- Direktori kerja `/data` (Volume persisten opsional)
- `TZ=Asia/Jakarta` sebagai default
- Tidak menyimpan API key atau password di source code

## Variabel Railway

Buka **Railway → project → service → Variables**. Tambahkan:

| Variable | Wajib? | Nilai |
|---|---:|---|
| `TERMINAL_USER` | Ya | Username login terminal, tanpa karakter `:` |
| `TERMINAL_PASSWORD` | Ya | Password acak minimal 16 karakter; disarankan 24–40 karakter |
| `TZ` | Opsional | `Asia/Jakarta` |
| `PORT` | Jangan diisi manual | Railway menyediakan nilai port saat runtime |

Jangan masukkan password asli ke GitHub, README, atau file `.env` yang di-commit. Jika password pernah bocor, ganti di Railway Variables lalu redeploy.

## Deploy ke Railway

1. Buat repository GitHub baru, misalnya `ubuntu-personal-railway`.
2. Upload seluruh file repo ini ke root repository.
3. Masuk ke [Railway](https://railway.com/), pilih **New Project → Deploy from GitHub Repo**, lalu pilih repository tersebut.
4. Pastikan Railway membangun aplikasi menggunakan `Dockerfile` di root.
5. Buka service → **Variables**. Isi `TERMINAL_USER` dan `TERMINAL_PASSWORD`. Atur `TZ=Asia/Jakarta` bila diperlukan.
6. Buka **Settings → Networking → Generate Domain** untuk membuat domain `*.up.railway.app`.
7. Buka domain tersebut. Browser akan meminta username dan password.
8. (Opsional) Jika ingin file bertahan lintas redeploy, buka **Settings → Volumes → Add Volume** dan set **Mount Path** ke `/data`. Jika tidak menambahkan Volume, terminal tetap bisa dipakai, tetapi file di filesystem container tidak dijamin bertahan setelah container dibuat ulang.

## Memasang custom domain

1. Pastikan kamu memiliki domain sendiri.
2. Di service Railway, buka **Settings → Networking → Custom Domain** (nama menu dapat berubah).
3. Masukkan subdomain yang diinginkan, misalnya `terminal.domainkamu.com`.
4. Railway akan menampilkan DNS record yang diperlukan. Salin record itu persis ke panel DNS penyedia domain.
5. Tunggu DNS diverifikasi dan sertifikat HTTPS aktif, lalu buka `https://terminal.domainkamu.com`.

Jangan menebak record DNS. Gunakan nilai yang ditampilkan Railway untuk domain milikmu.

## Data dan batasan

- Tanpa Volume, terminal tetap berjalan tetapi file dan instalasi yang disimpan di filesystem container dapat hilang saat container dibuat ulang.
- Jika menambahkan Volume, simpan file penting di `/data`. Volume dipasang saat runtime, bukan saat build.
- Container ini memberi shell **root** di dalam container. Jangan membagikan URL beserta password; gunakan password kuat dan rotasi jika ada dugaan kebocoran.
- Domain publik membuat terminal dapat diakses dari internet, tetapi tetap dilindungi autentikasi. Jangan gunakan password yang dipakai di akun lain.
- Ini bukan mesin untuk menjalankan systemd penuh, Docker-in-Docker, desktop GUI, atau semua perilaku VPS tradisional.
- Penggunaan resource dan biaya mengikuti paket serta pemakaian Railway.

## Troubleshooting

### Deployment langsung berhenti
Periksa **Deploy Logs** dan pastikan `TERMINAL_USER` dan `TERMINAL_PASSWORD` tersedia. Password harus minimal 16 karakter.

### Domain terbuka tetapi terminal tidak muncul
Periksa **Deploy Logs**, pastikan service berjalan, dan gunakan domain yang terhubung ke port aplikasi. Railway biasanya mengisi `PORT` secara otomatis.

### File hilang setelah redeploy
Jika ingin file persisten, pastikan Railway Volume terpasang di mount path persis `/data` dan simpan file di sana. Tanpa Volume, kehilangan file saat redeploy bisa terjadi.

### Ingin mengubah password
Ubah `TERMINAL_PASSWORD` di Railway Variables, lalu redeploy/restart service. Gunakan password acak baru.

## Struktur repo

```text
.
├── Dockerfile
├── entrypoint.sh
├── .dockerignore
├── .gitignore
├── .env.example
└── README.md
```
