# Kebijakan keamanan

## Pelaporan

Jangan memublikasikan password, token, API key, URL terminal privat, atau bukti yang masih mengandung rahasia pada Issues publik. Laporkan potensi kerentanan melalui kanal privat yang disediakan pemilik repository/organisasi GitHub, bersama detail dampak dan langkah reproduksi yang aman.

## Area sensitif

- Domain terminal publik dapat diakses dari internet dan menggunakan username/password.
- Shell memiliki hak root di dalam container.
- ttyd memberi akses terminal interaktif dan file system container.
- Railway Volume yang dipasang di `/data` dapat menyimpan file pengguna.
- Log dan screenshot dapat secara tidak sengaja mengungkap data sensitif.

## Jika kredensial bocor

1. Segera ganti `TERMINAL_PASSWORD` melalui Railway Variables.
2. Restart atau redeploy service dan pastikan kredensial lama tidak lagi berfungsi.
3. Periksa log dan akses yang tidak dikenal.
4. Hapus rahasia dari lokasi publik dan tinjau riwayat Git; menghapus satu commit tidak selalu membersihkan semua salinan.
