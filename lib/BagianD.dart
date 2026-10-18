import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

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

class Item {
  final String nama;
  final IconData ikon;
  final Color warna;
  final String deskripsi;

  const Item(
    this.nama,
    this.ikon,
    this.warna,
    this.deskripsi,
  );
}

const daftarItem = [
  Item(
    'Flutter',
    Icons.flutter_dash,
    Colors.blue,
    'Framework untuk membangun aplikasi dari '
        'satu basis kode.',
  ),
  Item(
    'Musik',
    Icons.music_note,
    Colors.pink,
    'Sarana hiburan dan ekspresi melalui suara '
        'serta irama.',
  ),
  Item(
    'Kamera',
    Icons.camera_alt,
    Colors.orange,
    'Digunakan untuk mengambil foto dan '
        'mengabadikan momen.',
  ),
  Item(
    'Peta',
    Icons.map,
    Colors.green,
    'Membantu pengguna memahami lokasi dan '
        'menemukan arah perjalanan.',
  ),
];

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
          title: 'Praktikum 6 - Navigasi Tab',
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
          initialRoute: '/',
          routes: {
            '/': (_) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final arguments = settings.arguments;

              if (arguments is Item) {
                return MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => DetailPage(
                    item: arguments,
                  ),
                );
              }

              return MaterialPageRoute<void>(
                builder: (_) => const HalamanError(),
              );
            }

            return null;
          },
          onUnknownRoute: (_) {
            return MaterialPageRoute<void>(
              builder: (_) => const HalamanError(),
            );
          },
        );
      },
    );
  }
}

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  static const _halaman = [
    BerandaTab(),
    AnimasiTab(),
    PengaturanTab(),
  ];

  static const _judul = [
    'Beranda',
    'Animasi',
    'Pengaturan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_judul[_index]),
      ),
      body: IndexedStack(
        index: _index,
        children: _halaman,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) {
          setState(() {
            _index = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.animation),
            label: 'Animasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Selamat Datang!',
          style: tema.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih item untuk membuka halaman detail '
          'dengan animasi Hero.',
          style: tema.textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        for (final item in daftarItem)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: Hero(
                tag: 'ikon-${item.nama}',
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: item.warna,
                  child: Icon(
                    item.ikon,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              title: Text(item.nama),
              subtitle: Text(
                item.deskripsi,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(
                Icons.chevron_right,
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/detail',
                  arguments: item,
                );
              },
            ),
          ),
      ],
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
  bool _tampil = true;
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
        const SizedBox(height: 12),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _besar ? 200 : 100,
            height: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _besar ? warna.primary : warna.tertiary,
              borderRadius: BorderRadius.circular(
                _besar ? 45 : 8,
              ),
            ),
            child: Icon(
              Icons.animation,
              color: warna.onPrimary,
              size: 32,
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _besar = !_besar;
              });
            },
            child: const Text('Ubah Bentuk'),
          ),
        ),
        const Divider(height: 32),
        Text(
          '2. AnimatedSwitcher',
          style: tema.textTheme.titleLarge,
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
        const Divider(height: 32),
        Text(
          '3. AnimationController',
          style: tema.textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        Center(
          child: RotationTransition(
            turns: _putar,
            child: Icon(
              Icons.settings,
              size: 64,
              color: warna.primary,
            ),
          ),
        ),
        const SizedBox(height: 12),
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
        const Divider(height: 32),
        Text(
          '4. AnimatedOpacity',
          style: tema.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        AnimatedOpacity(
          opacity: _tampil ? 1 : 0.15,
          duration: const Duration(milliseconds: 400),
          child: Card(
            child: ListTile(
              leading: Icon(
                Icons.lightbulb,
                color: warna.primary,
              ),
              title: const Text('Kartu Animasi'),
              subtitle: const Text(
                'Opasitas kartu dapat diubah.',
              ),
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                _tampil = !_tampil;
              });
            },
            child: Text(
              _tampil ? 'Redupkan Kartu' : 'Terangkan Kartu',
            ),
          ),
        ),
      ],
    );
  }
}

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

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
              'Sesuaikan tampilan aplikasi sesuai '
              'preferensi kamu.',
              style: tema.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
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
              spacing: 16,
              runSpacing: 12,
              children: [
                for (final warna in pilihanWarna)
                  Semantics(
                    label: 'Pilih warna tema',
                    button: true,
                    child: GestureDetector(
                      onTap: () {
                        seedColor.value = warna;
                      },
                      child: CircleAvatar(
                        radius: 26,
                        backgroundColor: warna,
                        child: seedColor.value == warna
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                              )
                            : null,
                      ),
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
                      color: tema.colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Pratinjau Tema',
                      style: tema.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Perubahan tema diterapkan ke '
                      'seluruh aplikasi.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final Item item;

  const DetailPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.nama),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'ikon-${item.nama}',
                child: CircleAvatar(
                  radius: 64,
                  backgroundColor: item.warna,
                  child: Icon(
                    item.ikon,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                item.nama,
                style: tema.textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                item.deskripsi,
                style: tema.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HalamanError extends StatelessWidget {
  const HalamanError({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Tidak Ditemukan'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: tema.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                '404 - Halaman tidak ditemukan',
                style: tema.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                },
                child: const Text('Kembali ke Beranda'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
