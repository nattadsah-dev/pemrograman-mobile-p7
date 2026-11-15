import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'daftar_tugas.dart';
import 'form_tambah.dart';
import 'statistik.dart';
import 'tugas_kuliah.dart';
import 'tugas_provider.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const DaftarTugas()),
    GoRoute(path: '/tambah', builder: (context, state) => const FormTambah()),
    GoRoute(path: '/statistik', builder: (context, state) => const Statistik()),
  ],
);

void main() {
  final sekarang = DateTime.now();
  runApp(
    ChangeNotifierProvider(
      create: (_) => TugasProvider(
        awal: [
          TugasKuliah(
            id: 1,
            judul: 'Laporan praktikum jaringan',
            mataKuliah: 'Jaringan Komputer',
            tenggat: sekarang.add(const Duration(days: 2)),
          ),
          TugasKuliah(
            id: 2,
            judul: 'Tugas Rutin 7',
            mataKuliah: 'Pemrograman Mobile',
            tenggat: sekarang.add(const Duration(days: 5)),
          ),
          TugasKuliah(
            id: 3,
            judul: 'Latihan soal DFA',
            mataKuliah: 'Teori Automata',
            tenggat: sekarang.subtract(const Duration(days: 1)),
          ),
          TugasKuliah(
            id: 4,
            judul: 'Rangkuman bab 3',
            mataKuliah: 'Rekayasa Perangkat Lunak',
            tenggat: sekarang.add(const Duration(days: 1)),
            selesai: true,
          ),
        ],
      ),
      child: const AplikasiPlanner(),
    ),
  );
}

class AplikasiPlanner extends StatelessWidget {
  const AplikasiPlanner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Planner Tugas Kuliah',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
    );
  }
}