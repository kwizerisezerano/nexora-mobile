import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_settings.dart';
import 'l10n/app_strings.dart';
import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/home_screen.dart';
import 'screens/portfolio_screen.dart';
import 'screens/services_screen.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStrings.load();
  final settings = await AppSettings.restore();
  runApp(NexoraApp(settings: settings));
}

class NexoraApp extends StatefulWidget {
  const NexoraApp({super.key, this.settings});

  /// Pre-resolved settings (theme + locale already restored from storage).
  /// When omitted — e.g. in widget tests — in-memory defaults are used.
  final AppSettings? settings;

  @override
  State<NexoraApp> createState() => _NexoraAppState();
}

class _NexoraAppState extends State<NexoraApp> {
  late final AppSettings _settings = widget.settings ?? AppSettings();

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      notifier: _settings,
      child: AnimatedBuilder(
        animation: _settings,
        builder: (context, _) {
          return MaterialApp(
            title: 'Nexora Technologies',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: _settings.themeMode,
            locale: _settings.locale,
            supportedLocales: AppStrings.supportedLocales,
            localizationsDelegates: const [
              AppStringsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const AppShell(),
          );
        },
      ),
    );
  }
}

/// Top-level navigation shell: the app bar plus a bottom tab bar, mirroring the
/// website's single-page sections as separate mobile tabs.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _goTo(int tab) {
    if (tab == _index) return;
    setState(() => _index = tab);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final p = context.nx;

    final screens = [
      HomeScreen(onNavigate: _goTo),
      ServicesScreen(onNavigate: _goTo),
      const AboutScreen(),
      PortfolioScreen(onNavigate: _goTo),
      const ContactScreen(),
    ];

    return PopScope(
      // On Android, back returns to the Home tab before it can exit the app.
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop || _index == 0) return;
        setState(() => _index = 0);
      },
      child: Scaffold(
        body: IndexedStack(index: _index, children: screens),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: p.card,
            border: Border(top: BorderSide(color: p.divider)),
          ),
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: _goTo,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: strings.t('nav.home'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.laptop_mac_outlined),
                selectedIcon: const Icon(Icons.laptop_mac),
                label: strings.t('nav.services'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.info_outline),
                selectedIcon: const Icon(Icons.info),
                label: strings.t('nav.about'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.grid_view_outlined),
                selectedIcon: const Icon(Icons.grid_view),
                label: strings.t('nav.portfolio'),
              ),
              NavigationDestination(
                icon: const Icon(Icons.mail_outline),
                selectedIcon: const Icon(Icons.mail),
                label: strings.t('nav.contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
