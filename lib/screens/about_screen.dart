import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';
import '../widgets/tab_page.dart';

/// About tab — mission/vision pillars and the growth roadmap.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final p = context.nx;
    final roadmap = strings.tObjects('about.roadmap');

    return NxTabPage(
      eyebrow: strings.t('about.eyebrow'),
      title: strings.t('about.title'),
      subtitle: strings.t('about.subtitle'),
      background: p.surfaceAlt,
      children: [
        NxContainer(
          child: Column(
            children: [
              NxReveal(
                child: _PillarCard(
                  icon: Icons.gps_fixed,
                  title: strings.t('about.missionTitle'),
                  text: strings.t('about.missionText'),
                ),
              ),
              const SizedBox(height: 16),
              NxReveal(
                delay: const Duration(milliseconds: 100),
                child: _PillarCard(
                  icon: Icons.visibility_outlined,
                  title: strings.t('about.visionTitle'),
                  text: strings.t('about.visionText'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 48),
        NxContainer(
          child: NxSectionHeader(
            eyebrow: strings.t('about.journeyEyebrow'),
            title: strings.t('about.journeyTitle'),
          ),
        ),
        const SizedBox(height: 28),
        NxContainer(
          child: Column(
            children: [
              for (var i = 0; i < roadmap.length; i++) ...[
                NxReveal(
                  delay: Duration(milliseconds: (i % 2) * 100),
                  child: RoadmapCard(
                    index: i,
                    title: roadmap[i]['title'] as String? ?? '',
                    description: roadmap[i]['description'] as String? ?? '',
                  ),
                ),
                if (i != roadmap.length - 1) const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PillarCard extends StatelessWidget {
  const _PillarCard({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return NxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NxIconTile(icon: icon, size: 56, iconSize: 28),
          const SizedBox(height: 18),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
