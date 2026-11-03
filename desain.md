---
name: pad-smartmap-design
description: Sistem desain "PAD SmartMap" untuk aplikasi GIS pajak daerah (PBB-P2) Bapenda Kabupaten Lampung Utara, pilot Kecamatan Kotabumi Selatan. Berisi dua shell, yaitu dasbor web (sidebar + header, untuk Verifikator/Eksekutif) dan aplikasi mobile surveyor lapangan (header + bottom nav 4 tab). Gunakan skill ini setiap kali membuat, mengubah, atau memperluas halaman/komponen untuk PAD SmartMap, SISMIOP, atau aplikasi geospasial pemerintah daerah bergaya serupa. Contoh layar mencakup Dashboard Eksekutif, Peta Potensi GIS, Data Objek Pajak, Verifikasi & Tindak Lanjut, Laporan & Rekapitulasi, Tugas Survei, Peta Lapangan, Form Survei, Kamera Geotag, Pratinjau Foto, Konfirmasi Kirim, dan Riwayat Sinkronisasi. Pakai juga bila pengguna menyebut NOP, SPPT, NJOP, ZNT, BAP, Bapenda, surveyor, geotag, RTK/GNSS, poligon persil, atau "gaya PAD SmartMap", walau tidak menyebut nama skill ini.
---

# PAD SmartMap, Sistem Desain GIS Pajak Daerah

Skill ini menangkap bahasa visual, token, pola komponen, dan konvensi konten dari seluruh layar PAD SmartMap, supaya halaman baru terasa seperti bagian dari produk yang sama.

## 1. Karakter & Prinsip

- **Mood**: instansi pemerintah yang modern, tepercaya, dan tenang. Biru navy tua + biru langit + hijau mint untuk "valid". Latar putih kebiruan, bukan abu-abu mati dan bukan neon.
- **Dua shell**:
  - **Web dashboard** (`shell-type: web_dashboard`) untuk Verifikator dan Eksekutif Bapenda. Sidebar kiri 288px tetap, header atas 64px tetap, konten padat (tabel, split-screen, peta).
  - **Mobile tab** (`shell-type: mobile_tab`) untuk surveyor lapangan. Satu kolom (±390px), header 80px, bottom nav 80px, tombol besar yang mudah dijangkau satu tangan.
- **Bahasa UI: Bahasa Indonesia** (`<html lang="id">`). Istilah teknis baku tetap dipakai: *NOP, SPPT, NJOP, ZNT, PBB-P2, SISMIOP, BAP, RTK Fix, GNSS, Geotag, Poligon, Payload, Checksum*.
- **Data adalah pahlawan**: angka penting (luas, Rupiah, NOP, koordinat) selalu menonjol dan rapi. NOP, koordinat, hash, dan nomor berkas memakai `font-mono`.
- **Kepercayaan & jejak audit terlihat**: badge `verified`, status sinkronisasi, hash SHA-256, stempel waktu WIB, dan pakta integritas hadir di hampir tiap layar.
- **Tanpa border keras**: pemisahan lewat perubahan warna surface (`surface-container-*`) dan shadow tipis. Border hanya `border-outline-variant/20–30` pada HUD melayang di atas peta, atau `border-l-4 border-secondary` pada callout.
- **Satu tipografi**: Plus Jakarta Sans untuk semuanya.
- **Aturan bisnis yang harus tercermin di UI**:
  - **BR-02**: hasil survei lapangan bersifat faktual teknis dan **tidak otomatis mengubah ketetapan SPPT**. Rekonsiliasi wajib diverifikasi Tim Penilai Bapenda. Jangan membuat tombol atau teks yang menyiratkan perubahan SPPT otomatis dari sisi surveyor.
  - **PRD 8.2**: bedakan jelas **Realisasi Kas Resmi** dan **Proyeksi Indikatif GIS** (label dan tampilan terpisah).
  - **SOP validasi** maksimal 2x24 jam kerja.
  - **Mode offline**: data survei disimpan terenkripsi lokal (AES-256), lalu dikirim otomatis saat tersambung.

## 2. Stack Teknis

HTML tunggal per layar, Tailwind via CDN, Google Fonts, Material Symbols Outlined, JavaScript vanilla inline (tanpa framework).

### Head dasbor web

```html
<html lang="id"><head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<meta name="shell-type" content="web_dashboard"/>
<link href="https://fonts.googleapis.com" rel="preconnect"/>
<link href="https://fonts.gstatic.com" rel="preconnect" crossorigin/>
<link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap" rel="stylesheet"/>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet"/>
<style>
@layer base{
  html,body{margin:0;padding:0;}
  body{overscroll-behavior:none;}
  main>:first-child{margin-top:0!important;}
  main>:last-child{margin-bottom:0!important;}
}
::-webkit-scrollbar{display:none;}
</style>
<script src="https://cdn.tailwindcss.com"></script>
<script id="tailwind-config">/* lihat bagian 3 */</script>
</head>
<body class="bg-surface font-body-md text-body-md text-on-surface antialiased">
```

### Head mobile

Sama, dengan perbedaan berikut:

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover"/>
<meta name="shell-type" content="mobile_tab"/>
<style>
@layer base{
  html,body{width:100vw;margin:0;padding:0;}
  body{overscroll-behavior:none;}
  .pb-safe{padding-bottom:env(safe-area-inset-bottom,0px);}
  .pt-safe{padding-top:env(safe-area-inset-top,0px);}
  main>:first-child{margin-top:0!important;}
  main>:last-child{margin-bottom:0!important;}
}
::-webkit-scrollbar{display:none;}
body{min-height:max(884px,100dvh);}
</style>
<!-- body -->
<body class="bg-surface font-body-md text-body-md text-on-surface flex flex-col min-h-screen">
```

Pasang `<link>` Material Symbols **sekali saja** (versi sumber menduplikasinya berkali-kali).

Ikon: `<span class="material-symbols-outlined text-[20px]">verified</span>`. Ikon terisi: `style="font-variation-settings: 'FILL' 1;"` (status penting, tombol utama, ikon sukses).

> Bila artefak dipublikasikan sebagai halaman hosted: CDN Tailwind dan Google Fonts diizinkan, tetapi **gambar remote diblokir**. Gunakan blok gradien/ikon sebagai placeholder foto (lihat bagian 8), jangan URL gambar eksternal, dan jangan bergantung pada `localStorage` untuk data penting.

## 3. Token (Tailwind config)

Salin utuh. Konfigurasi sama untuk web dan mobile.

```js
tailwind.config = { darkMode: "class", theme: { extend: {
  colors: {
    "primary":"#001428","on-primary":"#ffffff","primary-container":"#0f2942","on-primary-container":"#7991af",
    "primary-fixed":"#d1e4ff","primary-fixed-dim":"#b0c9e8","on-primary-fixed":"#011d35","on-primary-fixed-variant":"#314863",
    "secondary":"#006398","on-secondary":"#ffffff","secondary-container":"#5bb8fe","on-secondary-container":"#00476e",
    "secondary-fixed":"#cce5ff","secondary-fixed-dim":"#93ccff","on-secondary-fixed":"#001d31","on-secondary-fixed-variant":"#004b73",
    "tertiary":"#00170d","on-tertiary":"#ffffff","tertiary-container":"#002e1d","on-tertiary-container":"#21a173",
    "tertiary-fixed":"#85f8c4","tertiary-fixed-dim":"#68dba9","on-tertiary-fixed":"#002114","on-tertiary-fixed-variant":"#005137",
    "error":"#ba1a1a","on-error":"#ffffff","error-container":"#ffdad6","on-error-container":"#93000a",
    "surface":"#faf8ff","background":"#faf8ff","on-background":"#131b2e","surface-bright":"#faf8ff","surface-dim":"#d2d9f4",
    "surface-container-lowest":"#ffffff","surface-container-low":"#f2f3ff","surface-container":"#eaedff",
    "surface-container-high":"#e2e7ff","surface-container-highest":"#dae2fd","surface-variant":"#dae2fd","surface-tint":"#49607c",
    "on-surface":"#131b2e","on-surface-variant":"#43474d","outline":"#74777e","outline-variant":"#c3c6ce",
    "inverse-surface":"#283044","inverse-on-surface":"#eef0ff","inverse-primary":"#b0c9e8"
  },
  borderRadius: { DEFAULT:"0.25rem", lg:"0.5rem", xl:"0.75rem", full:"9999px" },
  spacing: { "space-xs":"0.25rem","space-sm":"0.5rem","space-md":"1rem","space-lg":"1.5rem","space-xl":"2.5rem",
             "margin":"1rem","gutter":"1rem","gutter-desktop":"1.5rem","margin-desktop":"2rem" },
  fontFamily: { /* semua nama di bawah → ["Plus Jakarta Sans"] */
    "body-md":["Plus Jakarta Sans"],"body-lg":["Plus Jakarta Sans"],"body-sm":["Plus Jakarta Sans"],
    "label-lg":["Plus Jakarta Sans"],"label-md":["Plus Jakarta Sans"],"label-sm":["Plus Jakarta Sans"],
    "title-md":["Plus Jakarta Sans"],"headline-sm":["Plus Jakarta Sans"],"headline-md":["Plus Jakarta Sans"],
    "headline-lg":["Plus Jakarta Sans"],"headline-lg-mobile":["Plus Jakarta Sans"],"display-lg":["Plus Jakarta Sans"] },
  fontSize: {
    "body-sm":["12px",{lineHeight:"16px",fontWeight:"400"}], "body-md":["14px",{lineHeight:"20px",fontWeight:"400"}], "body-lg":["16px",{lineHeight:"24px",fontWeight:"400"}],
    "label-sm":["11px",{lineHeight:"14px",fontWeight:"600"}], "label-md":["12px",{lineHeight:"16px",fontWeight:"600"}], "label-lg":["14px",{lineHeight:"20px",fontWeight:"600"}],
    "title-md":["16px",{lineHeight:"22px",fontWeight:"600"}],
    "headline-sm":["18px",{lineHeight:"24px",fontWeight:"600"}], "headline-md":["22px",{lineHeight:"28px",fontWeight:"600"}],
    "headline-lg":["28px",{lineHeight:"36px",fontWeight:"700"}], "headline-lg-mobile":["24px",{lineHeight:"32px",fontWeight:"700"}],
    "display-lg":["36px",{lineHeight:"44px",fontWeight:"700"}]
  }
}}};
```

Saat menulis ulang, **tulis semua 12 nama fontFamily secara eksplisit** (jangan disingkat dengan komentar seperti di atas).

### Peran warna

| Peran | Token |
|---|---|
| Latar halaman | `bg-surface` |
| Kartu, input terang, sidebar, header | `bg-surface-container-lowest` (putih) |
| Blok lembut di dalam kartu, field input | `bg-surface-container-low` |
| Chip netral, panel info | `bg-surface-container` |
| Tombol tonal, hover, badge netral | `bg-surface-container-high` / `-highest` |
| Teks utama / sekunder / tersier | `text-on-surface` / `text-on-surface-variant` / `text-outline` |
| Judul & angka penting, tombol utama | `text-primary` / `bg-primary text-on-primary` |
| Hover tombol utama, nav aktif | `bg-primary-container` |
| Aksen interaktif (link, ikon section, CTA sekunder) | `text-secondary`, `bg-secondary text-on-secondary` |
| Status **valid / sukses / terkirim** | `bg-tertiary-fixed text-on-tertiary-fixed` (ikon `check_circle`, `verified`, `done_all`) |
| Status **menunggu / sedang proses / info** | `bg-secondary-fixed text-on-secondary-fixed` |
| Status **masalah / perbaikan / duplikat / kritis** | `bg-error-container text-on-error-container`, kuat: `bg-error text-on-error` |
| Status netral / draf / offline | `bg-surface-container-high text-on-surface-variant` |
| Panel gelap (telemetri GNSS, bar aksi massal, toast) | `bg-primary-container text-on-primary` / `bg-primary` |

### Warna peta (hex langsung, hanya untuk SVG/legenda peta)

| Status persil | Isi | Garis |
|---|---|---|
| Terverifikasi | `#10b981` (opacity .32–.38) | `#059669` |
| Menunggu | `#f59e0b` (.35–.45) | `#d97706` |
| Perbaikan | `#f97316` (.45) | `#ea580c` |
| Duplikat / anomali | `#a855f7` (.45), garis putus `4,2` | `#9333ea` |
| **Persil terpilih** | `#0284c7` (.6) | `#001428`, putus `6,3`, tebal 3.5, plus marker pusat berdenyut |
| Poligon sedang diukur (mobile) | `#5bb8fe` (.28) | `#006398` tebal 3 |
| Overlap/anomali (mobile) | pola arsir `#ba1a1a` | `#ba1a1a` |

Basemap vektor: latar `#e5ecf4` (web) / `#eaedff` (mobile) + grid putus-putus `#94a3b8`; sungai `#b9e2fe`; jalan = garis lebar `#cbd5e1` + isi putih; label jalan KAPITAL `#475569` font-bold tracking.

### Tipografi

| Penggunaan | Kelas |
|---|---|
| Judul halaman web | `font-headline-lg text-headline-lg text-primary font-bold tracking-tight` (atau `headline-md` pada halaman antrean/verifikasi) |
| Judul halaman mobile | `font-headline-lg-mobile text-headline-lg-mobile` |
| Judul kartu/section | `font-title-md text-title-md text-primary font-bold` |
| Angka KPI besar | `font-display-lg text-display-lg font-bold tracking-tight` |
| Teks isi | `font-body-md text-body-md` / keterangan `font-body-sm text-body-sm text-on-surface-variant` |
| Label/chip/badge | `font-label-sm text-label-sm` / `label-md`; kapital kecil: `uppercase tracking-wider text-outline` |
| NOP, koordinat, hash, ID berkas, luas | `font-mono` |

Tambahan umum: `tabular-nums` untuk deret angka, `truncate` pada nama panjang, ukuran mikro `text-[10px]`/`text-[11px]` untuk metadata.

### Spacing & radius

Pakai token spacing (`p-space-md`, `gap-space-sm`, `px-space-lg`, `px-margin`) sebagai default; nilai Tailwind biasa (`p-3`, `gap-2.5`, `py-2.5`) boleh untuk penyetelan halus. Radius: kartu `rounded-xl`, input/tombol/chip persegi `rounded-lg`, pil/badge `rounded-full`, sub-blok kecil `rounded`/`rounded-md`.

## 4. Shell Web Dashboard

Urutan: `<aside>` fixed → `<div class="pl-72">` berisi `<header>` fixed + `<main class="w-full pt-16 bg-surface min-h-screen">`.

### Sidebar

`fixed left-0 top-0 h-full w-72 bg-surface-container-lowest shadow-[0_1px_8px_rgba(0,0,0,0.04)] z-50 flex flex-col justify-between`

1. **Brand** (`h-16 px-space-md flex items-center gap-space-sm`): logo `h-8`, lalu "PAD SmartMap" (`title-md font-bold text-primary`) dan "Kotabumi Selatan, Lampura" (`label-sm text-on-surface-variant`).
2. Label kelompok: `Menu Navigasi GIS` (`label-sm uppercase tracking-wider text-outline`).
3. **Nav** (5 item tetap, urutan jangan diubah):
   Dashboard Eksekutif (`dashboard`), Peta Potensi GIS (`map`), Data Objek Pajak (`table_chart`), Verifikasi & Tindak Lanjut (`verified`, dengan badge hitung merah `bg-error text-on-error rounded-full px-1.5 py-0.5`), Laporan & Rekapitulasi (`description`).
   - Item biasa: `flex items-center gap-space-sm px-space-md py-space-sm rounded-lg text-on-surface-variant font-label-lg text-label-lg hover:bg-surface-container-high hover:text-on-surface transition-all`
   - Item aktif (+ `aria-current="page"`): `bg-primary-container text-on-primary font-bold shadow-sm` (ganti kelas warna teks, hapus hover).
   - Pasang `data-path` pada tiap `<a>` dan `data-active-classes` pada `<nav>`.
4. **Kartu footer**: `p-space-md m-space-sm bg-surface-container-low rounded-xl`, judul "Sistem Validasi Resmi" (ikon `verified_user`, `text-secondary uppercase`) dan teks "Integrasi SISMIOP & Geospasial Bapenda Lampung Utara."

### Header

`fixed top-0 left-72 right-0 h-16 bg-surface/90 backdrop-blur-xl shadow-[0_1px_8px_rgba(0,0,0,0.04)] z-40 flex items-center justify-between px-space-lg`

- Kiri: breadcrumb "Sistem › Kotabumi Selatan", pemisah vertikal `h-4 w-px`, pil wilayah (`bg-surface-container rounded-full`, ikon `location_city`, "Kec. Kotabumi Selatan", badge `PILOT PROJECT` `bg-secondary text-on-secondary text-[10px] uppercase`).
- Kanan: pencarian `w-72 h-9` ("Cari NOP / Nama WP / Lokasi...", ikon `search`), tombol notifikasi (`notifications`, titik merah `bg-error` di pojok), pemisah, avatar `w-8 h-8 rounded-full` + nama pengguna ("Rahmat Hidayat, S.STP" / "Verifikator Bapenda").

### Pola isi halaman web

- **Bar judul halaman**: breadcrumb kecil kapital (`text-secondary font-bold` untuk modul, titik pemisah `•`), `h1`, deskripsi `body-sm`, tombol aksi di kanan. Latar boleh `bg-surface-container-low` (halaman verifikasi) atau langsung di atas `bg-surface`.
- **Padding konten**: `px-space-lg py-space-md` (atau `px-space-md sm:px-space-lg lg:px-margin-desktop`); dasbor eksekutif membatasi `max-w-[1720px] mx-auto`; jarak vertikal antar blok `gap-space-md`/`gap-space-lg`.
- **Halaman peta penuh**: `main > div.h-[calc(100vh-4rem)] relative overflow-hidden`.

## 5. Shell Mobile (Surveyor)

Urutan: `<header>` fixed → `<main class="flex flex-col relative w-full pt-20 pb-20 bg-surface">` → `<nav>` fixed bawah.

### Header mobile

`fixed top-0 inset-x-0 z-50 bg-surface/90 backdrop-blur-xl shadow-[0_1px_8px_rgba(0,0,0,0.04)] pt-safe`, isi `h-20 px-margin flex items-center justify-between`:
- Kiri (3 baris): `PAD SMARTMAP` (ikon `domain` + `label-sm uppercase tracking-wider text-secondary`) → **judul layar** (`title-md text-primary`) → dua chip: wilayah (`bg-surface-container-high`, ikon `location_city`) dan `GNSS Aktif` (`bg-tertiary-fixed text-on-tertiary-fixed` + titik `animate-pulse`).
- Kanan: nama surveyor ("Dimas Setiawan", `label-md font-semibold`) + status "● Online" (`bg-tertiary-fixed-dim`), avatar `w-8 h-8 rounded-full bg-primary` ikon `person`.
- **Ganti judul layar sesuai halaman** (mis. "Riwayat Sinkronisasi", "Form Survei"). Jangan menyalin "Form Survei" ke semua halaman.

### Bottom nav

`fixed bottom-0 inset-x-0 z-50 pb-safe bg-surface/90 backdrop-blur-xl shadow-[0_-1px_8px_rgba(0,0,0,0.04)]`, isi `flex justify-around items-center h-20 px-space-xs`. Empat tab tetap: **Tugas** (`assignment`), **Peta** (`map`), **Form** (`edit_document`), **Sinkron** (`sync`). Tiap tab `flex flex-col items-center justify-center gap-1 min-w-[64px] h-14`, ikon `text-[24px]`, label `label-sm`. Tab aktif: `text-secondary font-semibold` + `aria-current="page"`. Tab lain: `text-on-surface-variant hover:text-on-surface`.

### Aturan mobile

- Konten dalam `px-margin`, kartu `bg-surface-container-lowest rounded-xl shadow-sm p-space-md`, jarak `gap-space-md`/`pt-space-md`.
- Target sentuh minimal `h-11`; tombol utama `h-12`. Beri `active:scale-95` atau `active:scale-[0.98]` pada tombol.
- Tombol aksi menempel (sticky) di atas bottom nav: `sticky bottom-0 bg-surface/95 backdrop-blur-md pt-3 pb-4 px-margin shadow-[0_-4px_16px_rgba(15,41,66,0.08)]`.
- Pola dua tombol: sekunder tonal `flex-1` (mis. "Simpan Draf") + primer `flex-[1.8]` (mis. "Kirim Verifikasi").

## 6. Katalog Komponen

### Kartu & section

```html
<div class="bg-surface-container-lowest rounded-xl shadow-sm p-space-md flex flex-col gap-space-md">
  <div class="flex items-center justify-between">
    <div class="flex items-center gap-2">
      <span class="material-symbols-outlined text-secondary text-[20px]">fact_check</span>
      <span class="font-title-md text-title-md text-primary font-bold">Judul Section</span>
    </div>
    <span class="px-2 py-0.5 rounded-full bg-surface-container text-on-surface-variant font-label-sm text-label-sm font-semibold">Keterangan</span>
  </div>
  <!-- isi -->
</div>
```

Header kartu yang menonjol: strip `px-space-md py-space-sm bg-surface-container-low` di atas isi (mis. tabel komparasi). Kartu terpilih: tambah `shadow-md` dan strip aksen kiri `absolute left-0 top-3 bottom-3 w-1.5 bg-secondary rounded-r-full`.

### Badge & chip status

`inline-flex items-center gap-1 px-2 py-0.5 rounded-full font-label-sm text-label-sm font-semibold` + pasangan warna dari tabel peran. Contoh baku:

| Teks | Warna |
|---|---|
| Terverifikasi / Valid / Cocok / Terkirim 100% | `bg-tertiary-fixed text-on-tertiary-fixed` (+ `check_circle`) |
| Menunggu Verif / Tertunda / Mengunggah / Sedang Ditinjau | `bg-secondary-fixed text-on-secondary-fixed` |
| Perlu Perbaikan / Duplikat / Anomali / Prioritas Tinggi | `bg-error-container text-on-error-container` (+ `warning`, `flag`) |
| Offline / Draf / Prioritas Sedang | `bg-surface-container-high text-on-surface-variant` |

Badge hitung (jumlah antrean) `px-2 py-0.5 rounded-full font-bold`: merah `bg-error text-on-error` untuk perlu tindakan, `bg-secondary-fixed` untuk aktif, `bg-surface-container-high` untuk riwayat. Titik status: `w-2 h-2 rounded-full` + `animate-pulse` bila live, `animate-ping` bila kritis/sedang berjalan.

### Tombol

| Jenis | Kelas |
|---|---|
| Primer | `px-4 py-2.5 rounded-lg bg-primary text-on-primary hover:bg-primary-container font-label-md text-label-md shadow-sm flex items-center gap-1.5` |
| Sekunder aksen | `bg-secondary text-on-secondary hover:bg-on-secondary-container` |
| Tonal | `bg-surface-container-high text-on-surface hover:bg-surface-container-highest` |
| Putih (di atas latar abu) | `bg-surface-container-lowest text-on-surface hover:bg-surface-container-high shadow-sm` |
| Destruktif | `bg-error text-on-error hover:opacity-90` |
| Ikon | `p-1.5 rounded-md hover:bg-surface-container text-on-surface-variant hover:text-primary` |
| Link kecil | `text-secondary font-bold hover:underline` dengan ikon `arrow_forward text-[14px]` |

Semua tombol: `type="button"`, ikon `text-[18px]` di kiri teks, `transition-colors`/`transition-all`.

### Form

- Input/select/textarea: `bg-surface-container-low rounded-lg text-on-surface font-body-sm placeholder:text-outline focus:outline-none focus:ring-2 focus:ring-secondary/30 transition-all`, tinggi `h-9`/`h-10`, tanpa border.
- Ikon di dalam input: `absolute left-3 top-1/2 -translate-y-1/2 text-outline text-[18px]` dengan input `pl-9`.
- Field kunci/read-only (NOP, SLA): sama seperti input + `readonly`, NOP `font-mono`.
- Label: `font-label-sm text-label-sm text-on-surface-variant font-semibold`.
- Kartu opsi radio (keputusan Bapenda): `<label>` dengan `<input class="peer sr-only">` di dalamnya, `p-3.5 rounded-xl bg-surface-container-low hover:bg-surface-container cursor-pointer`; bulatan indikator berubah `peer-checked:bg-secondary`. Sematkan badge kecil (Rekomendasi / Perlu Perbaikan / Penilaian Ahli).
- Segmented/pilihan grid mobile: kartu `p-2.5 rounded-lg`; terpilih `bg-primary text-on-primary` (ikon `FILL 1`, sub-teks `text-secondary-fixed`), tidak terpilih `bg-surface-container-low`.
- Stepper angka: tombol `w-9 h-9 rounded-lg` (kurang: putih, tambah: `bg-primary`), nilai `font-mono headline-md`.
- Input angka besar (luas): `font-headline-md font-mono font-bold text-right bg-transparent`, satuan `m²` di kanan.
- Pernyataan/persetujuan: `<label class="flex items-start gap-3 p-3 rounded-lg bg-surface-container-low">` + checkbox `w-5 h-5 accent-secondary`.

### Tabel data (web)

- Pembungkus `rounded-xl bg-surface-container-lowest shadow-sm overflow-hidden`, isi `overflow-x-auto`.
- `thead`: `bg-surface-container-low` (atau `bg-surface-container`), teks `label-sm uppercase tracking-wider`, kolom kunci boleh diberi `bg-primary-fixed/20 text-primary`.
- Baris: `hover:bg-surface-container-low/70 transition-colors`; pembeda baris dengan `divide-y divide-surface-container-high` atau selang-seling `bg-surface-container-low/40`. Baris dengan masalah: `bg-error-container/30`; baris terpilih: `bg-secondary-fixed/10`.
- Sel NOP: NOP `font-mono font-bold text-primary` + kategori kecil berikon di bawahnya. Sel WP: nama `font-bold`, alamat `body-sm truncate max-w-xs`.
- Sel Rupiah: `font-mono font-bold text-primary text-right` + badge buku/potensi di bawah.
- Deviasi: tampilkan nilai SISMIOP vs fisik berdampingan; selisih bermakna ditebalkan merah (`text-error font-semibold`) dengan badge `+140 m² (+58,3%)`.
- Footer paginasi: `p-4 bg-surface-container-low/50`, "Menampilkan **1 - 10** dari **14.820** objek pajak", pemilih baris per halaman, tombol halaman `w-8 h-8 rounded-md` (aktif `bg-primary text-on-primary font-bold`).
- Tabel komparasi "Basis SISMIOP vs Hasil Lapangan": 4 kolom (Parameter, Eksisting, Hasil Lapangan `bg-primary-fixed/20`, Deviasi & Evaluasi rata kanan).

### Kartu KPI

`bg-surface-container-lowest p-space-lg rounded-xl shadow-sm hover:shadow-md relative overflow-hidden`: ikon besar transparan di pojok (`absolute right-0 top-0 translate-x-2 -translate-y-2 opacity-5 text-[100px]`), label kapital `label-sm text-outline font-bold` + ikon dalam kotak `p-1.5 rounded-lg bg-secondary-fixed`, angka `display-lg`, tren `label-sm text-secondary font-semibold`, dan footer `bg-surface-container-low rounded-lg px-space-sm py-1.5` berisi metrik pendamping. Grid: `grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-space-md`.

### Progress bar

Track `w-full h-2 rounded-full bg-surface-container overflow-hidden`; isi `bg-secondary` (utama), `bg-secondary-container` (sedang), `bg-error` (masalah), `bg-outline` (rendah). Multi-segmen memakai `flex` dengan lebar persen. Tipis: `h-1` / `h-1.5`.

### Split-screen antrean + detail (Verifikasi)

`grid grid-cols-1 lg:grid-cols-12 gap-space-lg items-start`: kiri `lg:col-span-4` (konsol filter + daftar kartu tugas `max-h-[820px] overflow-y-auto` + ringkasan target harian), kanan `lg:col-span-8` (banner kasus → matriks komparasi → callout estimasi → galeri bukti → formulir keputusan → jejak audit). Di atasnya tab status berbentuk tombol `rounded-xl` (aktif `bg-primary text-on-primary`, lain `bg-surface-container-lowest shadow-sm`) dengan badge hitung.

Kartu tugas: baris atas (badge prioritas + badge jenis kiri, waktu `label-sm text-outline` kanan), nama objek `title-md font-bold`, NOP `font-mono`, kotak perubahan `bg-surface-container rounded-lg p-2`, baris bawah surveyor (`person_pin_circle`) dan status.

### Callout / banner

- Info: `bg-surface-container p-space-md rounded-xl` + ikon `text-secondary` (mis. kebijakan BR-02 dengan ikon `policy`).
- Peringatan sistem: `rounded-xl bg-gradient-to-r from-error/10 via-surface-container-low to-surface-container-lowest p-4`, ikon dalam kotak `bg-error-container text-error`, tombol `bg-error`.
- Strip akurat: `border-l-4 border-secondary bg-surface-container-low`.
- Estimasi uang: `rounded-xl bg-surface-container`, ikon `calculate`, angka `font-mono font-bold text-secondary`, selisih `text-on-tertiary-container font-semibold`.

### Timeline jejak audit

Baris `flex items-start gap-space-sm`; ikon bulat `w-7 h-7 rounded-full` (`bg-secondary-fixed`, `bg-surface-container-high`, `bg-primary-fixed`), judul `label-md font-bold` + waktu `label-sm text-outline` di kanan, deskripsi `body-sm text-on-surface-variant` dengan nama tebal. Sertakan hash/stempel bila relevan ("Hash MD5: 9a38f...77e").

### Bar aksi massal (web)

`fixed bottom-6 left-1/2 -translate-x-1/2 bg-primary text-on-primary px-5 py-3 rounded-xl shadow-2xl z-50 flex items-center gap-space-md`: titik hijau berdenyut + "N Objek Pajak Terpilih", pemisah, tombol aksi (`bg-secondary` utama, `bg-primary-container` sekunder), tombol tutup. Tampil hanya bila ada pilihan (toggle `opacity-0 pointer-events-none translate-y-10`).

### Drawer inspektur persil (web, di atas peta)

`absolute top-0 right-0 bottom-0 w-full sm:w-[420px] bg-surface-container-lowest shadow-2xl z-20 flex flex-col overflow-y-auto transition-transform duration-300`. Header sticky (`bg-surface-container-low`): badge status, "Identifikasi Objek Pajak", NOP `font-mono`, tombol tutup. Isi berurutan: callout validasi → profil subjek & objek (Luas Bumi vs Luas Bangunan berdampingan) → NJOP & potensi PBB → koordinat resmi (+ Salin) → dokumentasi foto 2 kolom → kartu surveyor. Footer sticky: tombol utama "Buka Formulir Verifikasi" + dua tombol sekunder. Tutup dengan `translate-x-full`, tab pembuka muncul di tepi kanan.

### HUD peta (web)

Semua melayang di atas peta dengan `bg-surface-container-lowest/95 backdrop-blur-md rounded-xl shadow-md border border-outline-variant/30`:
- Bilah kontrol atas: pencarian NOP (tombol "Cari" di dalam input, `pr-24`), chip filter layer (aktif `bg-primary text-on-primary`; lain `bg-surface-container` dengan titik warna status + jumlah), pengalih basemap **Vektor GIS / Citra Satelit** (segmented `bg-surface-container p-0.5 rounded-lg`).
- Toolset kiri atas: zoom +/−, pusatkan, GPS, ukur jarak, hitung luas, layer, cetak (tombol `w-9 h-9`).
- Legenda kiri bawah: `w-80`, grid 2 kolom status + jumlah persil, footer ZNT + "Akurasi Lapangan".
- Penanda wilayah: pil `rounded-full border-2` berwarna status + jumlah persil.
- Penanda posisi live: lingkaran `bg-secondary` + cincin `animate-ping`.

### Komponen peta mobile

- **HUD telemetri atas**: kartu putih translusen, titik berdenyut + "RTK Fix (±0.48m)" + badge `SUB-METER`, chip satelit (`18/24 Sat`) dan ketinggian, baris koordinat `font-mono`. Banner "Mode Ukur Aktif" `bg-primary-container text-on-primary` + tombol Reset.
- **Kanvas peta**: `h-[520px]`, SVG viewBox `0 0 390 520`; poligon aktif dengan lencana dimensi sisi (`rect #001428` + teks putih, mis. `30.0 m`), lencana luas di tengah, penanda sudut P1–P4 (lingkaran putih bergaris `#006398` + label kotak gelap), posisi surveyor dengan kerucut arah dan denyut. Kontrol kanan atas berupa kolom tombol `w-10 h-10 rounded-xl` (kompas, layer, tambah foto, zoom, lokasi saya = `bg-primary`).
- **Bottom sheet inspeksi**: `rounded-xl shadow-xl p-4` dengan pegangan `w-10 h-1 bg-outline-variant`, NOP, status "Dalam Ukur", perbandingan Luas SPPT vs GPS (+persen), status titik sudut (P1–P4 kotak `bg-primary`, aktif `bg-secondary ring-2`), dua tombol (Snap Titik Baru / Kunci Poligon) dan CTA lebar "Lanjut ke Formulir Survei Objek" dengan badge `Geo Data Siap`.

### Kamera geotag (mobile)

Viewfinder `aspect-[9/15] rounded-xl overflow-hidden shadow-xl` dengan lapisan gradien navy (`from-primary via-transparent to-primary/80`), grid sepertiga `opacity-20`, pil status RTK (`RTK FIX ±0.32m | 21/24 | HDOP 0.7`), bilah koordinat/ketinggian/arah, carousel titik sudut (P1 Kunci ✓, P3 Bidik aktif `bg-secondary`, P4 Antrean), reticle sudut ala CAD `border-tertiary-fixed` + inklinometer "Pitch/Roll" + label klasifikasi objek, pratinjau watermark (BAPENDA LAMPUNG UTARA, NOP, titik, geo ±m, waktu WIB, nama surveyor), preset zoom 0.5×/1.0×/2.0× (aktif `bg-secondary`), dan **shutter** `72px` `bg-tertiary-fixed` dengan cincin `animate-ping`. Efek kilat: overlay `bg-surface` yang opacity-nya dianimasikan. Di bawahnya lembar validasi (3 chip: GNSS Terkunci, Patok Jelas, Tilt < 2°) dan dua tombol (Simpan Koordinat Saja / Ambil Foto & Kunci Titik).

### Pratinjau geotag & bukti foto

- Carousel thumbnail 48px dengan label "FOTO n"; yang aktif `bg-primary-container` + cincin `ring-secondary-container` + centang.
- Foto utama `h-80 rounded-2xl` dengan **watermark** gradien navy di bawah: logo, "BAPENDA LAMPUNG UTARA", "PAD SMARTMAP • KEC. KOTABUMI SELATAN", badge `RTK-FIX 0.32m`, grid `font-mono` (NOP, POS, TITIK, ALT/AZI), surveyor, dan potongan SHA.
- Kartu metrik 2 kolom (Deviasi Kadastral BPN, Inklinasi Sensor) + form klasifikasi bukti dan catatan.
- Galeri bukti web: kartu foto `h-44 object-cover` + overlay gradien `from-primary/90 via-primary/20` berisi judul, GPS, waktu; badge "Foto n" di pojok.

### Sinkronisasi & antrean (mobile)

- Strip konektivitas: pil "Online • 4G LTE Bapenda APN" (`bg-tertiary-fixed`, titik `animate-ping`), latensi, "Auto-sync aktif (setiap 15 menit)", tombol lebar "Sinkronkan Semua Sekarang" `h-12 bg-primary` + badge `2 Tertunda (~3.4 MB)`.
- Buffer & cache: bar multi-segmen (Survei Baru / Tiles Peta / Indeks NOP), pita keamanan "AES-256 GCM • SHA-256 Valid" dan "BR-02 & BR-08 Compliant".
- Statistik harian: 3 kartu kecil (Terkirim Valid, Antrean Offline, Gagal Kirim).
- Kartu antrean: ID `#VRF-…` + ukuran, nama objek, NOP `font-mono`, badge status; **Mengunggah** memakai bar persen + kecepatan + estimasi; **Terkirim** menampilkan kode transmisi `TX-KBU-YYYYMMDD-####`, stempel waktu, checksum yang bisa disalin; **Terverifikasi Bapenda** menampilkan catatan auditor (kutipan); **Tertunda** menampilkan tombol "Unggah Sekarang".
- Log audit gateway: blok `font-mono text-[11px]` (sukses = `bg-primary-container`, lainnya `bg-surface-container-low`), bisa dilipat.
- Layar sukses kirim: lingkaran `bg-tertiary-fixed` ikon `verified` FILL 1 + `animate-ping`, judul "Survei Lapangan Berhasil Dikirim!", kartu tanda terima (nomor berkas, kode transmisi, waktu, SHA-256 + Salin, SLA verifikasi), ringkasan temuan, CTA "Lanjut ke Tugas Survei Berikutnya", sekunder "Lihat di Peta" dan "Tanda Terima PDF".

### Grafik & peta tematik (dasbor)

- Choropleth: kanvas `h-80 rounded-xl bg-surface-container-low`, poligon wilayah `#006398`/`#5bb8fe` dengan opacity berbeda sesuai capaian, lingkaran `#001428` berisi persen, legenda ambang (>75% Tinggi, 65–75% Sedang, <65% Kritis).
- Bar/line SVG: kolom realisasi `#001428` (bulan berjalan `#006398`, tanda `*`), garis target `#5bb8fe` bertitik; grid putus-putus `#dae2fd`; label sumbu `#74777e` 10–11px; legenda di atas; footer insight `bg-surface-container-low`.
- Tabel wilayah: titik warna + nama, jumlah NOP, ketetapan, realisasi, pil persen, tombol "Zoom Poligon".

## 7. Konvensi Konten

| Hal | Format |
|---|---|
| NOP | `18.03.010.002.014-0082.0` (`font-mono`); sebagian boleh dipotong: `18.03.010.002...` |
| Nomor kasus/berkas | `#VRF-2026-10-082` |
| Kode transmisi | `TX-KBU-20261018-9942` |
| Rupiah | `Rp 1.485.000` (titik ribuan); ringkas `Rp 4,85 M`, `Rp 1.48 Miliar`, `Rp 100 Jt` |
| Persentase | koma desimal pada dasbor (`68,4%`); `+58.3%` pada tabel komparasi juga diterima, tapi konsisten dalam satu layar |
| Luas | `450 m²`, `+140 m² (+58,3%)`; pasangan `B:` (bumi) / `G:` (bangunan) di tabel |
| Tanggal & waktu | `18 Okt 2026, 14:25 WIB`; relatif: `14 menit yang lalu`, `Hari ini, 15:02 WIB` |
| Koordinat | `-4.823914, 104.882190` (lat, lon, enam desimal); akurasi `±0.32 m` |
| Ukuran data | `2.57 MB`, `380 KB/s` |
| Buku PBB | `Buku 1`–`Buku 5` |
| Nama pengguna | Verifikator "Rahmat Hidayat, S.STP"; surveyor "Dimas Setiawan" (NIP & ID `DS-940812`) |
| Wilayah | Kec. Kotabumi Selatan; kelurahan/desa mis. Kota Alam, Tanjung Aman, Kelapa Tujuh, Mulang Maya, Curup Guruh Kagungan, Kotabumi Kulon |
| Jalan | Jl. Jenderal Sudirman, Jl. Alamsyah Ratu Perwiranegara (RPN), Jl. Soekarno-Hatta, Jl. Raden Intan |

Label tombol memakai kata kerja: "Kirim Keputusan Verifikasi", "Unduh Batch BAP", "Tarik Data Terbaru", "Cetak Berita Acara (BAP)", "Tugaskan Verifikasi ke Petugas Lapangan", "Konfirmasi & Kirim Berkas". Status berbentuk kata sifat/keadaan: "Terverifikasi", "Menunggu Persetujuan", "Dikembalikan", "Tindak Lanjut Aktif".

Gunakan data contoh yang masuk akal dan konsisten dalam satu halaman (NOP, nama WP, luas, dan Rupiah saling cocok). Kasus rujukan: Toko Sembako Makmur, H. Ahmad Subagio, NOP `18.03.010.002.014-0082.0`, bumi 450 m², bangunan 240 → 380 m² (+140 m²), potensi PBB `Rp 1.485.000` (+`Rp 620.000` dari SPPT 2025).

## 8. Micro-interaction (JS vanilla inline)

Semua prototipe memakai simulasi sederhana, tanpa backend:

- **Kirim dengan status bertahap**: tombol → spinner (`animate-spin` ikon `sync`/`refresh`) dan teks "Memproses…" + `disabled` + `opacity-75` → setelah 0.9–1.8 dtk ganti ikon `check_circle`/`done_all` dan teks sukses (kelas `bg-tertiary-container`/`bg-tertiary-fixed`) → kembali ke kondisi awal setelah 2.5–3 dtk. Simpan `innerHTML` asli dulu.
- **Salin hash**: `navigator.clipboard.writeText(...)`, ikon `content_copy → check`, teks "Salin → Tersalin!" selama 2.5 dtk.
- **Template catatan**: `<select onchange>` mengisi `<textarea>` dengan teks baku; opsi "Format Catatan Bebas" mengosongkan dan fokus.
- **Pengalih basemap / layer / filter chip**: tukar kelas aktif (`bg-primary text-on-primary` vs `bg-surface-container text-on-surface`), satelit lewat opacity `opacity-0 ↔ opacity-90`.
- **Drawer**: tambah/hapus `translate-x-full` + tampilkan/sembunyikan tab pembuka.
- **Klik poligon**: isi kolom cari dengan `data-nop` dan buka drawer. Poligon membawa atribut `data-nop`, `data-status`, `data-wp`.
- **Zoom simulasi**: `transform: scale()` pada viewport peta, batas 0.85–1.6, tombol pusatkan mereset ke 1.
- **Bar aksi massal**: hitung `.item-checkbox:checked`, perbarui `#selectedCount`, tampilkan/sembunyikan bar; "pilih semua" menyinkronkan semua kotak.
- **Kamera**: kilat layar (opacity .9 → 0 dalam 120 ms), reticle `scale(.92) → 1`, toast "Titik Sudut P3 Terkunci!" meluncur dari bawah (`translate-y-20 opacity-0` ↔ `translate-y-0 opacity-100`) 3.2 dtk.
- **Log lipat**: toggle `display` dan rotasi panah `-90deg`.
- **Uji sambungan**: tombol berganti "Menguji…" → "28 ms Stabil" → kembali.

Placeholder foto bila gambar remote tidak boleh dipakai: `div` `bg-gradient-to-br from-primary-container to-secondary` (atau `bg-surface-container`) dengan ikon `photo_camera`/`storefront` di tengah, lengkap dengan overlay watermark gradien yang sama.

## 9. Alur Kerja Saat Dipakai

1. Tentukan shell: pengguna Verifikator/Eksekutif → web; surveyor/lapangan → mobile.
2. Tulis head + Tailwind config (bagian 2–3), lalu kerangka shell (bagian 4 atau 5) dengan item nav yang benar dan tab aktif sesuai halaman.
3. Susun isi dari katalog komponen (bagian 6) memakai token, bukan hex bebas (hex hanya untuk SVG peta).
4. Isi dengan data dan format Indonesia (bagian 7) serta hormati aturan BR-02 dan pemisahan Realisasi vs Proyeksi.
5. Tambahkan micro-interaction yang relevan (bagian 8).
6. Periksa daftar berikut.

### Daftar periksa

- [ ] `lang="id"`, meta `shell-type`, viewport sesuai shell, Tailwind config lengkap (12 nama fontFamily).
- [ ] Sidebar/header (web) atau header/bottom nav (mobile) lengkap, tab/menu aktif benar, judul layar mobile diganti.
- [ ] Tidak ada border keras; pemisahan lewat surface + shadow tipis.
- [ ] NOP, koordinat, hash, ID memakai `font-mono`; angka penting menonjol.
- [ ] Warna status konsisten dengan tabel peran dan legenda peta.
- [ ] Tombol `type="button"`, target sentuh mobile ≥ 44px, ada state hover/active.
- [ ] Format Rupiah, tanggal WIB, luas m², koordinat sesuai bagian 7.
- [ ] Tidak ada teks yang menyiratkan survei mengubah SPPT secara otomatis.
- [ ] Layar mobile memberi ruang `pb-20` (+ aksi sticky) agar tidak tertutup bottom nav.
- [ ] Tidak memakai kelas Tailwind yang tidak valid (`py-0.2`, `w-18`, `animate-fade-in`, `divide-none`): gunakan `py-0.5`, `w-[72px]`, `animate-pulse`, atau hapus saja.

## 10. Catatan Ketidakkonsistenan Sumber (jangan ditiru)

- Judul header mobile di sumber selalu "Form Survei" walau layarnya berbeda.
- Nama kelurahan untuk NOP/kasus yang sama bervariasi (Kotabumi Kulon, Kota Alam, Cempedak) dan kode kecamatan pada NOP bervariasi (`010` vs `070`). Pilih satu set data per halaman dan pertahankan.
- Ukuran payload kasus #VRF-2026-10-082 muncul sebagai 2.57 MB dan 3.8 MB di layar berbeda; samakan dalam satu alur.
- Blok `<style>` dan `<link>` ikon diduplikasi; tulis sekali.
- Panel yang memakai `hidden` bersama `flex` pada elemen yang sama (mis. umpan balik sinkron) tidak akan tampil dengan benar; pisahkan pembungkus atau toggle kelas display dengan benar.
