import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const pilihanWarna = <Color>[
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

const kunciMode = 'mode_gelap';
const kunciWarna = 'warna_tema';

ThemeMode modeTema = ThemeMode.light;
Color warnaTema = Colors.indigo;

ThemeData buatTema(Color warna, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: warna,
    brightness: brightness,
    appBarTheme: const AppBarTheme(
      centerTitle: true,
    ),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  final modeGelap = prefs.getBool(kunciMode) ?? false;
  final nilaiWarna = prefs.getInt(kunciWarna) ?? 0;

  modeTema = modeGelap ? ThemeMode.dark : ThemeMode.light;
  warnaTema = pilihanWarna[nilaiWarna.clamp(0, pilihanWarna.length - 1)];

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void ubahMode(ThemeMode mode) {
    setState(() {
      modeTema = mode;
    });
    _simpanMode(mode);
  }

  void ubahWarna(Color warna) {
    setState(() {
      warnaTema = warna;
    });
    _simpanWarna(warna);
  }

  Future<void> _simpanMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      kunciMode,
      mode == ThemeMode.dark,
    );
  }

  Future<void> _simpanWarna(Color warna) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      kunciWarna,
      pilihanWarna.indexOf(warna),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan Mandiri Pertemuan 6',
      debugShowCheckedModeBanner: false,
      theme: buatTema(warnaTema, Brightness.light),
      darkTheme: buatTema(warnaTema, Brightness.dark),
      themeMode: modeTema,
      initialRoute: '/',
      routes: {
        '/': (_) => ShellPage(
              modeTema: modeTema,
              warnaTema: warnaTema,
              onModeChanged: ubahMode,
              onWarnaChanged: ubahWarna,
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final arg = settings.arguments;

          if (arg is Item) {
            return PageRouteBuilder<void>(
              settings: settings,
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) {
                return DetailPage(item: arg);
              },
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
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
  }
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
    'Framework untuk membangun aplikasi mobile '
        'dengan satu basis kode.',
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
        'menemukan arah.',
  ),
];

class ShellPage extends StatefulWidget {
  final ThemeMode modeTema;
  final Color warnaTema;
  final ValueChanged<ThemeMode> onModeChanged;
  final ValueChanged<Color> onWarnaChanged;

  const ShellPage({
    super.key,
    required this.modeTema,
    required this.warnaTema,
    required this.onModeChanged,
    required this.onWarnaChanged,
  });

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  void pilihTab(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final judul = [
      'Beranda',
      'Animasi',
      'Pengaturan',
    ];

    final halaman = [
      BerandaTab(onItemSelected: (item) {
        Navigator.pushNamed(
          context,
          '/detail',
          arguments: item,
        );
      }),
      const AnimasiTab(),
      PengaturanTab(
        modeTema: widget.modeTema,
        warnaTema: widget.warnaTema,
        onModeChanged: widget.onModeChanged,
        onWarnaChanged: widget.onWarnaChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(judul[_index]),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.dashboard,
                      size: 42,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Praktikum 6',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Text('Menu Navigasi'),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Beranda'),
                selected: _index == 0,
                onTap: () {
                  pilihTab(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.animation),
                title: const Text('Animasi'),
                selected: _index == 1,
                onTap: () {
                  pilihTab(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Pengaturan'),
                selected: _index == 2,
                onTap: () {
                  pilihTab(2);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _index,
        children: halaman,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: pilihTab,
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
  final ValueChanged<Item> onItemSelected;

  const BerandaTab({
    super.key,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Galeri Item',
          style: tema.textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'Pilih item untuk melihat halaman detail '
          'dengan transisi FadeTransition.',
        ),
        const SizedBox(height: 16),
        for (final item in daftarItem)
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: item.warna,
                child: Icon(
                  item.ikon,
                  color: Colors.white,
                ),
              ),
              title: Text(item.nama),
              subtitle: Text(item.deskripsi),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onItemSelected(item),
            ),
          ),
      ],
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
              CircleAvatar(
                radius: 60,
                backgroundColor: item.warna,
                child: Icon(
                  item.ikon,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                item.nama,
                style: tema.textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              Text(
                item.deskripsi,
                textAlign: TextAlign.center,
                style: tema.textTheme.bodyLarge,
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
          'AnimatedContainer',
          style: tema.textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: _besar ? 200 : 100,
            height: 90,
            decoration: BoxDecoration(
              color: warna.primary,
              borderRadius: BorderRadius.circular(
                _besar ? 45 : 8,
              ),
            ),
            alignment: Alignment.center,
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
          'AnimatedSwitcher',
          style: tema.textTheme.titleLarge,
        ),
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
              style: tema.textTheme.displayLarge,
            ),
          ),
        ),
        Center(
          child: FilledButton(
            onPressed: () {
              setState(() {
                _hitung++;
              });
            },
            child: const Text('Tambah Angka'),
          ),
        ),
        const Divider(height: 32),
        Text(
          'AnimationController',
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
        Center(
          child: AnimatedBuilder(
            animation: _putar,
            builder: (context, child) {
              return FilledButton(
                onPressed: () {
                  if (_putar.isAnimating) {
                    _putar.stop();
                  } else {
                    _putar.repeat();
                  }
                },
                child: Text(
                  _putar.isAnimating ? 'Berhenti' : 'Putar Kembali',
                ),
              );
            },
          ),
        ),
        const Divider(height: 32),
        Text(
          'AnimatedOpacity',
          style: tema.textTheme.titleLarge,
        ),
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
                'Kartu ini dapat diredupkan.',
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
  final ThemeMode modeTema;
  final Color warnaTema;
  final ValueChanged<ThemeMode> onModeChanged;
  final ValueChanged<Color> onWarnaChanged;

  const PengaturanTab({
    super.key,
    required this.modeTema,
    required this.warnaTema,
    required this.onModeChanged,
    required this.onWarnaChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Pengaturan Tema',
          style: tema.textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Mode gelap'),
          value: modeTema == ThemeMode.dark,
          onChanged: (value) {
            onModeChanged(
              value ? ThemeMode.dark : ThemeMode.light,
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Warna Tema',
          style: tema.textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final warna in pilihanWarna)
              GestureDetector(
                onTap: () => onWarnaChanged(warna),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: warna,
                  child: warnaTema == warna
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
            child: Text(
              'Mode dan warna tema akan disimpan '
              'untuk digunakan saat aplikasi dibuka kembali.',
              style: tema.textTheme.bodyMedium,
            ),
          ),
        ),
      ],
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
              const SizedBox(height: 20),
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
