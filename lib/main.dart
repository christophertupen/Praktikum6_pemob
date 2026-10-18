import 'package:flutter/material.dart';

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

const pilihanWarna = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
  );
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        themeMode,
        seedColor,
      ]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Praktikum 6',
          debugShowCheckedModeBanner: false,
          theme: buatTema(
            seedColor.value,
            Brightness.light,
          ),
          darkTheme: buatTema(
            seedColor.value,
            Brightness.dark,
          ),
          themeMode: themeMode.value,
          home: const HalamanTema(),
        );
      },
    );
  }
}

class HalamanTema extends StatelessWidget {
  const HalamanTema({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 6 - Tema'),
      ),
      body: const PengaturanTab(),
    );
  }
}

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return ListenableBuilder(
      listenable: Listenable.merge([
        themeMode,
        seedColor,
      ]),
      builder: (context, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Pengaturan Tampilan',
              style: tema.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Ubah tema dan warna aplikasi untuk melihat '
              'bagaimana Flutter menyesuaikan tampilannya.',
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Mode gelap'),
              subtitle: Text(
                themeMode.value == ThemeMode.dark
                    ? 'Tema gelap aktif'
                    : 'Tema terang aktif',
              ),
              value: themeMode.value == ThemeMode.dark,
              onChanged: (value) {
                themeMode.value = value ? ThemeMode.dark : ThemeMode.light;
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Warna Tema',
              style: tema.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final warnaPilihan in pilihanWarna)
                  GestureDetector(
                    onTap: () {
                      seedColor.value = warnaPilihan;
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: warnaPilihan,
                      child: seedColor.value == warnaPilihan
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.palette,
                      size: 36,
                      color: warna.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pratinjau Tema',
                      style: tema.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Warna dan gaya komponen mengikuti tema '
                      'yang sedang dipilih.',
                      style: tema.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        themeMode.value = themeMode.value == ThemeMode.dark
                            ? ThemeMode.light
                            : ThemeMode.dark;
                      },
                      icon: const Icon(Icons.brightness_6),
                      label: const Text('Ganti Mode'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Warna aktif: ${warna.primary}',
              style: tema.textTheme.bodySmall,
            ),
          ],
        );
      },
    );
  }
}
