# Sumber, atribusi, dan lisensi

Dokumen ini mencatat sumber teknis serta cakupan lisensi untuk **Ubuntu Personal Railway**.

## Sumber teknis

- [Ubuntu Docker Official Image](https://hub.docker.com/_/ubuntu): image dasar Ubuntu.
- [Ubuntu Design Resources](https://design.ubuntu.com/resources): sumber resmi logo Ubuntu Circle of Friends.
- [Canonical design resource manifest](https://github.com/canonical/design.ubuntu.com/blob/main/_data/downloads.yaml): mencantumkan aset logo resmi Ubuntu, termasuk `https://assets.ubuntu.com/v1/ce518a18-CoF-2022_solid+O.svg`.
- [ttyd](https://github.com/tsl0922/ttyd): terminal berbasis web; repository ini menggunakan binary rilis upstream versi 1.7.7.
- [Docker documentation](https://docs.docker.com/): build image dan eksekusi container.
- [Railway documentation](https://docs.railway.com/): deployment, variables, networking, dan volumes.
- [GitHub Actions documentation](https://docs.github.com/en/actions): workflow build dan smoke test.

## Aset gambar

- Logo Ubuntu di header ditautkan langsung ke SVG resmi Ubuntu/Canonical. Logo dipakai untuk mengidentifikasi sistem dasar, bukan menyiratkan dukungan resmi untuk proyek ini.
- `docs/hero.id.svg`, `docs/hero.en.svg`, `docs/architecture.svg`, dan `docs/architecture.en.svg` adalah ilustrasi dokumentasi orisinal, bukan screenshot asli dari Railway atau Ubuntu.
- Merek dan nama produk pihak ketiga tetap milik pemiliknya masing-masing.

## Lisensi

File [LICENSE](../LICENSE) melisensikan materi proyek yang tercakup dengan MIT. Lisensi ini tidak mengganti atau memperluas lisensi Ubuntu, ttyd, dependensi sistem, Railway, atau komponen pihak ketiga lainnya. Tinjau lisensi upstream sebelum mendistribusikan ulang image atau komponen tersebut.
