import 'package:flutter/foundation.dart';
import 'tugas_kuliah.dart';

class TugasProvider extends ChangeNotifier {
  TugasProvider ({List<TugasKuliah> awal = const []})
  : _daftar = List.of(awal),
    _idBerikut = awal.fold<int>(0, (m, t) => t.id > m ? t.id : m) + 1;
  
  final List<TugasKuliah> _daftar;
  int _idBerikut;

  List<TugasKuliah> get daftar => List.unmodifiable(_daftar);
  int get total => _daftar.length;
  int get jumlahSelesai => _daftar.where((t) => t.selesai).length;
  int get jumlahAktif => total - jumlahSelesai;
  double get persen => total == 0 ? 0 : jumlahSelesai / total * 100;

  void tambah ({
    required String judul,
    required String mataKuliah,
    required DateTime tenggat,
  }) {
    _daftar.add(TugasKuliah(
      id: _idBerikut++,
      judul: judul.trim(),
      mataKuliah: mataKuliah.trim(),
      tenggat: tenggat,
    ));
    notifyListeners();
  }

  void tandaiSelesai (int id) {
    final i = _daftar.indexWhere ((t) => t.id == id);
    if (i == -1) return;
    _daftar [i] = _daftar[i].copyWith(selesai: true);
    notifyListeners();
  }

  void hapus (int id) {
    final lama = _daftar.length;
    _daftar.removeWhere ((t) => t.id == id);
    if (_daftar.length < lama) notifyListeners();
  }
}