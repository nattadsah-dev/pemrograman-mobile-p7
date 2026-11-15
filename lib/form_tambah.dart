import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'tugas_kuliah.dart';
import 'tugas_provider.dart';

class FormTambah extends StatefulWidget {
  const FormTambah({super.key});

  @override
  State<FormTambah> createState() => _FormTambahState();
}

class _FormTambahState extends State<FormTambah> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judul;
  late final TextEditingController _mataKuliah;
  DateTime? _tenggat;
  bool _tanggalKosong = false;

  @override
  void initState() {
    super.initState();
    _judul = TextEditingController();
    _mataKuliah = TextEditingController();
  }

  @override
  void dispose() {
    _judul.dispose();
    _mataKuliah.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal() async {
    final sekarang = DateTime.now();
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tenggat ?? sekarang,
      firstDate: DateTime(sekarang.year - 1),
      lastDate: DateTime(sekarang.year + 3),
    );
    if (!mounted || hasil == null) return;
    setState(() {
      _tenggat = hasil;
      _tanggalKosong = false;
    });
  }

  void _simpan() {
    final valid = _formKey.currentState!.validate();
    final adaTanggal = _tenggat != null;
    setState(() => _tanggalKosong = !adaTanggal);
    if (!valid || !adaTanggal) return;

    context.read<TugasProvider>().tambah(
          judul: _judul.text,
          mataKuliah: _mataKuliah.text,
          tenggat: _tenggat!,
        );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final warna = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tugas')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judul,
              decoration: const InputDecoration(
                labelText: 'Judul tugas',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _mataKuliah,
              decoration: const InputDecoration(
                labelText: 'Mata kuliah',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Mata kuliah wajib diisi'
                  : null,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pilihTanggal,
              icon: const Icon(Icons.event),
              label: Text(
                _tenggat == null ? 'Pilih tenggat' : formatTanggal(_tenggat!),
              ),
            ),
            if (_tanggalKosong)
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 12),
                child: Text(
                  'Tenggat wajib dipilih',
                  style: TextStyle(color: warna.error),
                ),
              ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _simpan, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}