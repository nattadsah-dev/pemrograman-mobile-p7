enum FilterTugas { semua, aktif, selesai }

class TugasKuliah {
  const TugasKuliah({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.tenggat,
    this.selesai = false,
  });

  final int id;
  final String judul;
  final String mataKuliah;
  final DateTime tenggat;
  final bool selesai;

  TugasKuliah copyWith({bool? selesai}) => TugasKuliah(
        id: id,
        judul: judul,
        mataKuliah: mataKuliah,
        tenggat: tenggat,
        selesai: selesai ?? this.selesai,
      );

  /// Terlambat = belum selesai dan tanggal tenggat sudah lewat (per hari).
  bool terlambatPer(DateTime sekarang) {
    final hari = DateTime(sekarang.year, sekarang.month, sekarang.day);
    return !selesai && tenggat.isBefore(hari);
  }
}

List<TugasKuliah> saring(List<TugasKuliah> daftar, FilterTugas filter) {
  return switch (filter) {
    FilterTugas.semua => daftar,
    FilterTugas.aktif => daftar.where((t) => !t.selesai).toList(),
    FilterTugas.selesai => daftar.where((t) => t.selesai).toList(),
  };
}

String formatTanggal(DateTime d) {
  const bulan = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];
  return '${d.day} ${bulan[d.month - 1]} ${d.year}';
}