import 'package:flutter/material.dart';

/// Brand + neutral palette derived from the Nexora Technologies website
/// (Tailwind `brand` and `slate` scales). Brand green is the mandatory
/// primary accent `#28a745`.
class NxColors {
  NxColors._();

  // Brand green
  static const brand50 = Color(0xFFF0FDF4);
  static const brand100 = Color(0xFFDCFCE7);
  static const brand200 = Color(0xFFBBF7D0);
  static const brand300 = Color(0xFF86EFAC);
  static const brand400 = Color(0xFF4ADE80);
  static const brand500 = Color(0xFF28A745);
  static const brand600 = Color(0xFF1E7E34);
  static const brand700 = Color(0xFF166534);
  static const brand800 = Color(0xFF14532D);
  static const brand900 = Color(0xFF0B3A21);

  // Slate neutrals
  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate900 = Color(0xFF0F172A);
  static const slate950 = Color(0xFF020617);

  // Accents
  static const amber400 = Color(0xFFFBBF24);
  static const teal300 = Color(0xFF5EEAD4);
  static const teal400 = Color(0xFF2DD4BF);
  static const rose300 = Color(0xFFFDA4AF);
  static const white = Color(0xFFFFFFFF);
  static const white06 = Color(0x0FFFFFFF);
  static const white18 = Color(0x2EFFFFFF);

  // Translucent tokens (explicit ARGB to stay version-safe)
  static const brand500_18 = Color(0x2E28A745); // ~18%
  static const brand500_30 = Color(0x4D28A745);
  static const brand500_38 = Color(0x6128A745); // ~38%
  static const brand500_15 = Color(0x2628A745);
  static const brand500_06 = Color(0x1028A745);

  static const shadowSoft1 = Color(0x0A0F172A);
  static const shadowSoft2 = Color(0x1F0F172A);
  static const shadowLift = Color(0x470F172A);
  static const shadowGlow = Color(0x7328A745);
}

/// Semantic colors resolved per brightness so screens can read
/// `context.nx.card`, `context.nx.heading`, etc.
class NxPalette {
  const NxPalette({
    required this.bg,
    required this.surfaceAlt,
    required this.card,
    required this.cardBorder,
    required this.heading,
    required this.body,
    required this.muted,
    required this.faint,
    required this.tileGradient,
    required this.tileFg,
    required this.tileBorder,
    required this.chipBg,
    required this.chipFg,
    required this.chipBorder,
    required this.divider,
    required this.navBg,
    required this.gridLine,
  });

  final Color bg;
  final Color surfaceAlt;
  final Color card;
  final Color cardBorder;
  final Color heading;
  final Color body;
  final Color muted;
  final Color faint;
  final List<Color> tileGradient;
  final Color tileFg;
  final Color tileBorder;
  final Color chipBg;
  final Color chipFg;
  final Color chipBorder;
  final Color divider;
  final Color navBg;
  final Color gridLine;

  static const light = NxPalette(
    bg: NxColors.white,
    surfaceAlt: NxColors.slate50,
    card: NxColors.white,
    cardBorder: NxColors.slate200,
    heading: NxColors.slate900,
    body: NxColors.slate600,
    muted: NxColors.slate500,
    faint: NxColors.slate400,
    tileGradient: [NxColors.brand50, Color(0xFFE8FBEF)],
    tileFg: NxColors.brand600,
    tileBorder: NxColors.brand500_18,
    chipBg: NxColors.brand50,
    chipFg: NxColors.brand700,
    chipBorder: NxColors.brand100,
    divider: NxColors.slate200,
    navBg: Color(0xF2FFFFFF),
    gridLine: Color(0x0E0F172A),
  );

  static const dark = NxPalette(
    bg: NxColors.slate950,
    surfaceAlt: NxColors.slate900,
    card: NxColors.slate900,
    cardBorder: NxColors.slate800,
    heading: NxColors.slate100,
    body: NxColors.slate300,
    muted: NxColors.slate400,
    faint: NxColors.slate500,
    tileGradient: [NxColors.brand500_18, NxColors.brand500_06],
    tileFg: NxColors.brand400,
    tileBorder: NxColors.brand500_30,
    chipBg: NxColors.brand500_15,
    chipFg: NxColors.brand300,
    chipBorder: NxColors.brand500_30,
    divider: NxColors.slate800,
    navBg: Color(0xF2020617),
    gridLine: Color(0x1A94A3B8),
  );
}

/// Convenience accessors for palette + gradients + shadows.
extension NxContext on BuildContext {
  NxPalette get nx =>
      Theme.of(this).brightness == Brightness.dark
          ? NxPalette.dark
          : NxPalette.light;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Brand accent used for links/labels (darker on light, lighter on dark).
  Color get brandAccent => isDark ? NxColors.brand400 : NxColors.brand600;

  /// Stronger brand accent for small uppercase labels.
  Color get brandLabel => isDark ? NxColors.brand300 : NxColors.brand700;

  List<BoxShadow> get shadowSoft => const [
        BoxShadow(color: NxColors.shadowSoft1, blurRadius: 2, offset: Offset(0, 1)),
        BoxShadow(
          color: NxColors.shadowSoft2,
          blurRadius: 24,
          spreadRadius: -12,
          offset: Offset(0, 8),
        ),
      ];

  List<BoxShadow> get shadowLift => const [
        BoxShadow(
          color: NxColors.shadowLift,
          blurRadius: 48,
          spreadRadius: -20,
          offset: Offset(0, 24),
        ),
      ];
}

/// Shared gradients used across the app (mirrors website CSS helpers).
class NxGradients {
  NxGradients._();

  static const text = LinearGradient(
    colors: [NxColors.brand600, NxColors.brand500, Color(0xFF34D399)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient tile(bool dark) => dark
      ? const LinearGradient(
          colors: [NxColors.brand500_18, NxColors.brand500_06],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
      : const LinearGradient(
          colors: [NxColors.brand50, Color(0xFFE8FBEF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );

  static const brandButton = LinearGradient(
    colors: [NxColors.brand500, NxColors.brand600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Light + dark [ThemeData] for the app.
class AppTheme {
  AppTheme._();

  static ThemeData light() => _base(Brightness.light, NxPalette.light);
  static ThemeData dark() => _base(Brightness.dark, NxPalette.dark);

  static ThemeData _base(Brightness brightness, NxPalette p) {
    final scheme = ColorScheme.fromSeed(
      seedColor: NxColors.brand500,
      brightness: brightness,
    ).copyWith(
      primary: NxColors.brand500,
      onPrimary: NxColors.white,
      secondary: NxColors.brand600,
      surface: p.bg,
      onSurface: p.heading,
    );

    final textTheme = _textTheme(p);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.bg,
      textTheme: textTheme,
      dividerColor: p.divider,
      appBarTheme: AppBarTheme(
        backgroundColor: p.bg,
        foregroundColor: p.heading,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: p.heading,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.card,
        elevation: 0,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: brightness == Brightness.dark
            ? NxColors.brand500_30
            : NxColors.brand500_15,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11.5,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected
                ? (brightness == Brightness.dark
                    ? NxColors.brand300
                    : NxColors.brand700)
                : p.muted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected
                ? (brightness == Brightness.dark
                    ? NxColors.brand300
                    : NxColors.brand600)
                : p.muted,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            brightness == Brightness.dark ? NxColors.slate800 : NxColors.slate900,
        contentTextStyle: const TextStyle(fontSize: 14, color: NxColors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightness == Brightness.dark ? NxColors.slate900 : NxColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: p.muted),
        border: _inputBorder(p.cardBorder),
        enabledBorder: _inputBorder(p.cardBorder),
        focusedBorder: _inputBorder(NxColors.brand400, width: 1.6),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  /// Typography uses the platform system font (San Francisco on iOS, Roboto on
  /// Android) so the app reads natively, like most popular apps. Hierarchy comes
  /// from size + weight only — no custom display face.
  static TextTheme _textTheme(NxPalette p) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, height: 1.05, letterSpacing: -0.5, color: p.heading),
      displayMedium: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, height: 1.08, letterSpacing: -0.4, color: p.heading),
      displaySmall: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, height: 1.1, letterSpacing: -0.4, color: p.heading),
      headlineMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, height: 1.15, letterSpacing: -0.3, color: p.heading),
      headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1.2, letterSpacing: -0.2, color: p.heading),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: p.heading),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: p.heading),
      bodyLarge: TextStyle(fontSize: 16, height: 1.6, color: p.body),
      bodyMedium: TextStyle(fontSize: 14, height: 1.6, color: p.body),
      bodySmall: TextStyle(fontSize: 13, height: 1.5, color: p.muted),
      labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.6, color: NxColors.brand600),
    );
  }
}
