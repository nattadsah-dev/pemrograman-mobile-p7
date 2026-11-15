# Planner Tugas Kuliah (Tugas Rutin 7)

Nama: ____  | NIM: ____  | Mata kuliah: Pemrograman Mobile, Pertemuan 7

Aplikasi Flutter untuk mencatat tugas kuliah, dengan state lokal (setState)
dan state bersama (Provider), serta navigasi go_router 3 halaman.

## Diagram Letak State

```
ChangeNotifierProvider<TugasProvider>     ← STATE BERSAMA: List<TugasKuliah>
└─ MaterialApp.router (go_router)            tambah() · tandaiSelesai() · hapus()
   ├─ "/"          DaftarTugas (Stateful)
   │   ├─ _filter                           ← STATE LOKAL (setState)
   │   ├─ FilterChip x3
   │   ├─ ListTile x N                      → read: tandaiSelesai / hapus
   │   └─ BadgeAktif (select jumlahAktif)   ← membaca state bersama
   ├─ "/tambah"    FormTambah (Stateful)
   │   ├─ TextEditingController x2          ← STATE LOKAL (initState/dispose)
   │   ├─ _tenggat                          ← STATE LOKAL
   │   └─ Simpan                            → read: tambah()
   └─ "/statistik" Statistik (Stateless)    ← watch state bersama
```

## Alasan Pilihan State

| State | Jenis | Alasan |
|---|---|---|
| `_filter` (Semua/Aktif/Selesai) | Lokal (`setState`) | Hanya dipakai satu halaman dan hanya memengaruhi tampilan. Halaman lain tidak perlu tahu, dan boleh kembali ke "Semua" saat halaman dibuka lagi. |
| `TextEditingController` dan `_tenggat` di form | Lokal | Umurnya terikat pada widget form. Dibuat di `initState` dan di-`dispose` agar tidak terjadi kebocoran memori. |
| `List<TugasKuliah>` | Bersama (Provider) | Dipakai tiga halaman (daftar, form, statistik) dan harus bertahan saat berpindah halaman, jadi tidak bisa disimpan di satu widget. |
| Jumlah tugas aktif (badge) | Turunan state bersama | Dibaca dengan `context.select`, sehingga badge hanya dibangun ulang saat jumlah aktif berubah. |

## Mengapa Provider, Bukan Cubit

Provider dengan `ChangeNotifier` lebih ringkas (tanpa package state tambahan
dan tanpa kelas state terpisah) dan sudah cukup untuk satu daftar dengan tiga
operasi. Cubit lebih cocok kalau alur state-nya lebih kompleks atau perlu
riwayat perubahan yang jelas.

## Rute

| Rute | Halaman |
|---|---|
| `/` | Daftar tugas + FilterChip |
| `/tambah` | Form tambah tugas |
| `/statistik` | Total, selesai, persentase |

## Unit Test

`flutter test` menjalankan 7 test logika: tambah, tandaiSelesai, hapus,
persentase, filter, tugas terlambat, dan notifikasi listener.

## Cara Menjalankan

```bash
flutter pub get
flutter test
flutter run -d chrome
```
