import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tugas_provider.dart';

class Statistik extends StatelessWidget {
  const Statistik({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<TugasProvider>();
    final teks = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text('Total tugas'),
              trailing: Text('${p.total}', style: teks.titleLarge),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text('Selesai'),
              trailing: Text('${p.jumlahSelesai}', style: teks.titleLarge),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.pending_actions),
              title: const Text('Belum selesai'),
              trailing: Text('${p.jumlahAktif}', style: teks.titleLarge),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Persentase selesai: ${p.persen.toStringAsFixed(0)}%',
            style: teks.titleMedium,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: p.persen / 100, minHeight: 12),
        ],
      ),
    );
  }
}