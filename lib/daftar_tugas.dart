import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'tugas_kuliah.dart';
import 'tugas_provider.dart';

String _namaFilter(FilterTugas f) => switch (f) {
      FilterTugas.semua => 'Semua',
      FilterTugas.aktif => 'Aktif',
      FilterTugas.selesai => 'Selesai',
    };

class DaftarTugas extends StatefulWidget {
  const DaftarTugas({super.key});

  @override
  State<DaftarTugas> createState() => _DaftarTugasState();
}

class _DaftarTugasState extends State<DaftarTugas> {
  FilterTugas _filter = FilterTugas.semua; // state lokal

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;
    final semua = context.watch<TugasProvider>().daftar; // state bersama
    final tampil = saring(semua, _filter);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planner Tugas Kuliah'),
        actions: [
          IconButton(
            tooltip: 'Statistik',
            onPressed: () => context.push('/statistik'),
            icon: const BadgeAktif(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tambah'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                children: [
                  for (final f in FilterTugas.values)
                    FilterChip(
                      label: Text(_namaFilter(f)),
                      selected: _filter == f,
                      onSelected: (_) => setState(() => _filter = f),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: tampil.isEmpty
                ? const Center(child: Text('Tidak ada tugas'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 88),
                    itemCount: tampil.length,
                    itemBuilder: (context, i) {
                      final t = tampil[i];
                      final terlambat = t.terlambatPer(DateTime.now());
                      return ListTile(
                        key: ValueKey(t.id),
                        leading: Checkbox(
                          value: t.selesai,
                          onChanged: (_) =>
                              context.read<TugasProvider>().tandaiSelesai(t.id),
                        ),
                        title: Text(
                          t.judul,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: t.selesai
                              ? const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                )
                              : null,
                        ),
                        subtitle: Text(
                          '${t.mataKuliah} · ${formatTanggal(t.tenggat)}'
                          '${terlambat ? ' · Terlambat' : ''}',
                          style: terlambat ? TextStyle(color: warna.error) : null,
                        ),
                        trailing: IconButton(
                          tooltip: 'Hapus',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () =>
                              context.read<TugasProvider>().hapus(t.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class BadgeAktif extends StatelessWidget {
  const BadgeAktif({super.key});

  @override
  Widget build(BuildContext context) {
    final aktif = context.select<TugasProvider, int>((p) => p.jumlahAktif);
    return Badge(
      isLabelVisible: aktif > 0,
      label: Text('$aktif'),
      child: const Icon(Icons.bar_chart),
    );
  }
}