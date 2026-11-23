import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';
import '../widgets/tab_page.dart';

/// Services tab — featured capability card mirroring the website `Services`.
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key, required this.onNavigate});

  final void Function(int tab) onNavigate;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return NxTabPage(
      eyebrow: strings.t('services.eyebrow'),
      title: strings.t('services.title'),
      subtitle: strings.t('services.subtitle'),
      children: [
        NxContainer(
          child: NxReveal(
            child: _FeaturedService(
              strings: strings,
              onStart: () => onNavigate(4),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedService extends StatelessWidget {
  const _FeaturedService({required this.strings, required this.onStart});

  final AppStrings strings;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    final capabilities = strings.tList('services.capabilities');

    return NxCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: p.surfaceAlt,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(19)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const NxIconTile(
                    icon: Icons.laptop_mac_outlined, size: 56, iconSize: 28),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 10,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      strings.t('services.name'),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    NxPill(text: strings.t('services.badge'), leadingDot: true),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  strings.t('services.description'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 22),
                NxButton.primary(
                  label: strings.t('services.ctaPrimary'),
                  icon: Icons.arrow_outward,
                  expand: true,
                  onPressed: onStart,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NxEyebrow(text: strings.t('services.whatWeBuild')),
                const SizedBox(height: 20),
                for (var i = 0; i < capabilities.length; i++) ...[
                  CapabilityItem(text: capabilities[i]),
                  if (i != capabilities.length - 1) const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
