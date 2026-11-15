import 'package:flutter_test/flutter_test.dart';
import 'package:planner_kuliah/tugas_kuliah.dart';
import 'package:planner_kuliah/tugas_provider.dart';

void main() {
  late TugasProvider p;
  final tenggat = DateTime(2026, 12, 1);

  setUp(() => p = TugasProvider());

  test('tambah() menambah tugas baru dengan status belum selesai', () {
    p.tambah(judul: 'Laporan', mataKuliah: 'Jarkom', tenggat: tenggat);

    expect(p.total, 1);
    expect(p.daftar.first.judul, 'Laporan');
    expect(p.daftar.first.selesai, false);
  });

  test('tandaiSelesai() membalik status selesai', () {
    p.tambah(judul: 'Laporan', mataKuliah: 'Jarkom', tenggat: tenggat);
    final id = p.daftar.first.id;

    p.tandaiSelesai(id);
    expect(p.daftar.first.selesai, true);

    p.tandaiSelesai(id);
    expect(p.daftar.first.selesai, false);
  });

  test('hapus() membuang tugas; id yang tidak ada tidak mengubah apa pun', () {
    p.tambah(judul: 'A', mataKuliah: 'X', tenggat: tenggat);
    p.tambah(judul: 'B', mataKuliah: 'Y', tenggat: tenggat);
    final idA = p.daftar.first.id;

    p.hapus(idA);
    expect(p.total, 1);
    expect(p.daftar.first.judul, 'B');

    p.hapus(999);
    expect(p.total, 1);
  });

  test('persen bernilai 0 saat daftar kosong dan 50 saat 1 dari 2 selesai', () {
    expect(p.persen, 0);

    p.tambah(judul: 'A', mataKuliah: 'X', tenggat: tenggat);
    p.tambah(judul: 'B', mataKuliah: 'Y', tenggat: tenggat);
    p.tandaiSelesai(p.daftar.first.id);

    expect(p.jumlahSelesai, 1);
    expect(p.jumlahAktif, 1);
    expect(p.persen, 50);
  });

  test('saring() memisahkan tugas aktif dan selesai', () {
    p.tambah(judul: 'A', mataKuliah: 'X', tenggat: tenggat);
    p.tambah(judul: 'B', mataKuliah: 'Y', tenggat: tenggat);
    p.tandaiSelesai(p.daftar.first.id);

    expect(saring(p.daftar, FilterTugas.semua).length, 2);
    expect(saring(p.daftar, FilterTugas.aktif).map((t) => t.judul), ['B']);
    expect(saring(p.daftar, FilterTugas.selesai).map((t) => t.judul), ['A']);
  });

  test('terlambatPer() hanya true untuk tugas belum selesai yang lewat tenggat', () {
    final lewat = TugasKuliah(
      id: 1,
      judul: 'A',
      mataKuliah: 'X',
      tenggat: DateTime(2026, 11, 10),
    );
    final sekarang = DateTime(2026, 11, 15, 10);

    expect(lewat.terlambatPer(sekarang), true);
    expect(lewat.copyWith(selesai: true).terlambatPer(sekarang), false);
  });

  test('perubahan state memanggil notifyListeners', () {
    var dipanggil = 0;
    p.addListener(() => dipanggil++);

    p.tambah(judul: 'A', mataKuliah: 'X', tenggat: tenggat);
    p.tandaiSelesai(p.daftar.first.id);
    p.hapus(p.daftar.first.id);

    expect(dipanggil, 3);
  });
}