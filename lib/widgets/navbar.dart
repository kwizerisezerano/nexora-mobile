import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_settings.dart';
import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import 'common.dart';
import 'nexora_logo.dart';

/// Pinned, branded app bar shared by every tab: the Nexora logo plus the
/// language and theme controls — the mobile equivalent of the website navbar.
/// Rendered as a sliver so it integrates with each screen's own scroll view.
class NxSliverAppBar extends StatelessWidget {
  const NxSliverAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = AppSettingsScope.of(context);
    final p = context.nx;

    return SliverAppBar(
      pinned: true,
      toolbarHeight: 60,
      titleSpacing: 20,
      backgroundColor: p.navBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      shape: Border(bottom: BorderSide(color: p.divider)),
      title: NexoraLogo(height: 28, onWhiteChip: context.isDark),
      actions: [
        _LanguageButton(settings: settings),
        const SizedBox(width: 4),
        _ThemeToggle(settings: settings),
        const SizedBox(width: 16),
      ],
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    final current = settings.locale.languageCode;

    return PopupMenuButton<Locale>(
      tooltip: AppStrings.of(context).t('nav.languageLabel'),
      offset: const Offset(0, 46),
      color: p.card,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: p.cardBorder),
      ),
      onSelected: settings.setLocale,
      itemBuilder: (context) => [
        for (final locale in AppStrings.supportedLocales)
          PopupMenuItem<Locale>(
            value: locale,
            height: 44,
            child: Row(
              children: [
                NxFlag(code: locale.languageCode, width: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppStrings.localeNames[locale.languageCode] ?? locale.languageCode,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: p.heading,
                    ),
                  ),
                ),
                if (locale.languageCode == current)
                  const Icon(Icons.check, size: 18, color: NxColors.brand500),
              ],
            ),
          ),
      ],
      child: NxIconBox(child: NxFlag(code: current, width: 22)),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle({required this.settings});

  final AppSettings settings;

  @override
  Widget build(BuildContext context) {
    final dark = context.isDark;
    final brightness = MediaQuery.of(context).platformBrightness;
    final label = AppStrings.of(context).t('nav.themeLabel');
    return Tooltip(
      message: label,
      child: NxIconBox(
        onTap: () => settings.toggleTheme(brightness),
        semanticLabel: label,
        child: Icon(
          dark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
          size: 20,
          color: context.nx.muted,
        ),
      ),
    );
  }
}

/// Country flag image (from flagcdn.com) used by the language switcher.
class NxFlag extends StatelessWidget {
  const NxFlag({super.key, required this.code, this.width = 22});

  final String code;
  final double width;

  @override
  Widget build(BuildContext context) {
    final country = AppStrings.localeFlags[code] ?? 'un';
    final height = width * 0.72;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Image.network(
        'https://flagcdn.com/w40/$country.png',
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          color: context.nx.divider,
          child: Text(
            code.toUpperCase(),
            style: TextStyle(fontSize: 8, color: context.nx.muted),
          ),
        ),
      ),
    );
  }
}
