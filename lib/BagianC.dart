import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum 6 Animasi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const HalamanAnimasi(),
    );
  }
}

class HalamanAnimasi extends StatelessWidget {
  const HalamanAnimasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animasi',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: const AnimasiTab(),
    );
  }
}

class AnimasiTab extends StatefulWidget {
  const AnimasiTab({super.key});

  @override
  State<AnimasiTab> createState() => _AnimasiTabState();
}

class _AnimasiTabState extends State<AnimasiTab>
    with SingleTickerProviderStateMixin {
  bool _besar = false;
  int _hitung = 0;

  late final AnimationController _putar;

  @override
  void initState() {
    super.initState();

    _putar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _putar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '1. AnimatedContainer',
          style: tema.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Tekan tombol untuk mengubah ukuran, warna, '
          'dan bentuk kotak.',
          style: tema.textTheme.bodyMedium,
        ),
        const SizedBox(height: 20),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _besar ? 200 : 100,
            height: 100,
            decoration: BoxDecoration(
              color: _besar ? warna.primary : warna.tertiary,
              borderRadius: BorderRadius.circular(
                _besar ? 50 : 8,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.animation,
              color: warna.onPrimary,
              size: 36,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: FilledButton(
            onPressed: () {
              setState(() {
                _besar = !_besar;
              });
            },
            child: const Text('Ubah Bentuk'),
          ),
        ),
        const Divider(height: 40),
        Text(
          '2. AnimatedSwitcher',
          style: tema.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Tambahkan angka untuk melihat animasi '
          'pergantian konten.',
          style: tema.textTheme.bodyMedium,
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Text(
              '$_hitung',
              key: ValueKey<int>(_hitung),
              style: tema.textTheme.displayLarge?.copyWith(
                color: warna.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: FilledButton.icon(
            onPressed: () {
              setState(() {
                _hitung++;
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Tambah Angka'),
          ),
        ),
        const Divider(height: 40),
        Text(
          '3. AnimationController',
          style: tema.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          'Ikon berputar secara berulang. '
          'Kamu dapat menghentikan dan menjalankannya kembali.',
          style: tema.textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        Center(
          child: RotationTransition(
            turns: _putar,
            child: Icon(
              Icons.settings,
              size: 80,
              color: warna.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: AnimatedBuilder(
            animation: _putar,
            builder: (context, child) {
              return FilledButton.icon(
                onPressed: () {
                  if (_putar.isAnimating) {
                    _putar.stop();
                  } else {
                    _putar.repeat();
                  }
                },
                icon: Icon(
                  _putar.isAnimating ? Icons.pause : Icons.play_arrow,
                ),
                label: Text(
                  _putar.isAnimating ? 'Berhenti' : 'Putar Kembali',
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Coba ketiga animasi di atas dan amati '
              'perbedaan cara kerjanya.',
              style: tema.textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
