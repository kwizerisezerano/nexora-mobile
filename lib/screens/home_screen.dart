import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../l10n/app_strings.dart';
import '../theme/app_theme.dart';
import '../widgets/app_footer.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';
import '../widgets/navbar.dart';

/// Landing tab: hero + dashboard visual, stats, testimonials, CTA band and
/// footer — a mobile-stacked equivalent of the website home page.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onNavigate});

  /// Switches the shell tab (1=Services, 2=About, 3=Portfolio, 4=Contact).
  final void Function(int tab) onNavigate;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final p = context.nx;

    return CustomScrollView(
      slivers: [
        const NxSliverAppBar(),
        SliverList(
          delegate: SliverChildListDelegate([
            _Hero(onNavigate: onNavigate),
            const SizedBox(height: 8),
            NxContainer(
              child: NxReveal(
                child: StatBand(
                  stats: [
                    StatItem('50+', strings.t('stats.projects')),
                    StatItem('30+', strings.t('stats.clients')),
                    StatItem('5+', strings.t('stats.years')),
                    StatItem('24/7', strings.t('stats.support')),
                  ],
                  note: strings.t('stats.note'),
                ),
              ),
            ),
            const SizedBox(height: 40),
            _Testimonials(strings: strings, surface: p.surfaceAlt),
            _CtaBand(
              strings: strings,
              onPrimary: () => onNavigate(4),
              onSecondary: () => onNavigate(1),
            ),
            AppFooter(onNavigate: onNavigate),
          ]),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onNavigate});

  final void Function(int tab) onNavigate;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final p = context.nx;
    final titleStyle = Theme.of(context).textTheme.displayMedium;

    return Stack(
      children: [
        const Positioned.fill(child: GridOverlay()),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 36, 20, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NxReveal(
                child: NxPill(
                  text: strings.t('hero.badge'),
                  leading: const PulseDot(size: 8),
                  uppercase: true,
                  fontSize: 10.5,
                  letterSpacing: 1.2,
                  textColor: context.brandLabel,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
              const SizedBox(height: 22),
              NxReveal(
                delay: const Duration(milliseconds: 80),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('${strings.t('hero.titleStart')} ', style: titleStyle),
                    NxGradientText(
                      strings.t('hero.titleAccent'),
                      style: titleStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              NxReveal(
                delay: const Duration(milliseconds: 160),
                child: Text(
                  strings.t('hero.subtitle'),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: p.body),
                ),
              ),
              const SizedBox(height: 26),
              NxReveal(
                delay: const Duration(milliseconds: 240),
                child: Column(
                  children: [
                    NxButton.primary(
                      label: strings.t('hero.ctaPrimary'),
                      icon: Icons.arrow_outward,
                      expand: true,
                      onPressed: () => onNavigate(4),
                    ),
                    const SizedBox(height: 12),
                    NxButton.ghost(
                      label: strings.t('hero.ctaSecondary'),
                      icon: Icons.explore_outlined,
                      expand: true,
                      onPressed: () => onNavigate(1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              NxReveal(
                delay: const Duration(milliseconds: 320),
                child: _TrustRow(strings: strings),
              ),
              const SizedBox(height: 34),
              NxReveal(
                delay: const Duration(milliseconds: 280),
                child: _DashboardPanel(strings: strings),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrustRow extends StatelessWidget {
  const _TrustRow({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: context.brandAccent,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 13, color: context.nx.muted),
            ),
          ],
        );

    return Wrap(
      spacing: 20,
      runSpacing: 12,
      children: [
        item(Icons.verified_user_outlined, strings.t('hero.trust1')),
        item(Icons.map_outlined, strings.t('hero.trust2')),
        item(Icons.headset_mic_outlined, strings.t('hero.trust3')),
      ],
    );
  }
}

/// Window-chrome mock dashboard echoing the website hero panel.
class _DashboardPanel extends StatelessWidget {
  const _DashboardPanel({required this.strings});

  final AppStrings strings;

  static const _chart = [42, 58, 36, 74, 62, 88, 70];

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    final days = strings.tList('hero.days');

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 26),
          child: NxCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const NxDot(size: 11, color: NxColors.rose300),
                    const SizedBox(width: 7),
                    const NxDot(size: 11, color: NxColors.amber400),
                    const SizedBox(width: 7),
                    const NxDot(size: 11, color: NxColors.brand400),
                    const SizedBox(width: 12),
                    Text(
                      'operations.nexora',
                      style: GoogleFonts.inter(fontSize: 11.5, color: p.faint),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: p.surfaceAlt,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: p.cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings
                                      .t('hero.panel.liveOverview')
                                      .toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.1,
                                    color: p.faint,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  strings.t('hero.panel.systemHealth'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall,
                                ),
                              ],
                            ),
                          ),
                          NxPill(
                            text: strings.t('hero.panel.online'),
                            leadingDot: true,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          _MiniStat(
                            value: '12',
                            label: strings.t('hero.panel.deployments'),
                          ),
                          const SizedBox(width: 10),
                          _MiniStat(
                            value: '99.9%',
                            label: strings.t('hero.panel.uptime'),
                          ),
                          const SizedBox(width: 10),
                          _MiniStat(
                            value: '48',
                            label: strings.t('hero.panel.tasksDone'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 108,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            for (final h in _chart)
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 3),
                                  child: Container(
                                    height: 108 * h / 100,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xB328A745),
                                          NxColors.brand400,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(6),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          for (final d in days)
                            Expanded(
                              child: Text(
                                d,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: p.faint,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 2,
          bottom: 0,
          child: _VelocityChip(label: strings.t('hero.panel.velocity')),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: p.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: p.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: GoogleFonts.sora(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: p.heading,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(fontSize: 10.5, color: p.muted),
            ),
          ],
        ),
      ),
    );
  }
}

class _VelocityChip extends StatelessWidget {
  const _VelocityChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 18, 10),
      decoration: BoxDecoration(
        color: p.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.cardBorder),
        boxShadow: context.shadowLift,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const NxIconTile(icon: Icons.trending_up, size: 38, iconSize: 19),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '+128%',
                style: GoogleFonts.sora(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: p.heading,
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 10.5, color: p.muted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Testimonials extends StatelessWidget {
  const _Testimonials({required this.strings, required this.surface});

  final AppStrings strings;
  final Color surface;

  static const _names = [
    'TontineHub',
    'GECO Rwanda',
    'Tontine MIS (TMIS)',
    'Menya-Tech',
    'El Verbuena',
  ];

  @override
  Widget build(BuildContext context) {
    final items = strings.tObjects('testimonials.items');
    return Container(
      color: surface,
      padding: const EdgeInsets.symmetric(vertical: 56),
      child: NxContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NxReveal(
              child: NxSectionHeader(
                eyebrow: strings.t('testimonials.eyebrow'),
                title: strings.t('testimonials.title'),
                subtitle: strings.t('testimonials.subtitle'),
              ),
            ),
            const SizedBox(height: 32),
            for (var i = 0; i < items.length; i++) ...[
              NxReveal(
                delay: Duration(milliseconds: (i % 3) * 100),
                child: TestimonialCard(
                  name: i < _names.length ? _names[i] : '',
                  role: items[i]['role'] as String? ?? '',
                  text: items[i]['text'] as String? ?? '',
                ),
              ),
              if (i != items.length - 1) const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

/// Always-dark call-to-action band (website `CtaBand`).
class _CtaBand extends StatelessWidget {
  const _CtaBand({
    required this.strings,
    required this.onPrimary,
    required this.onSecondary,
  });

  final AppStrings strings;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  @override
  Widget build(BuildContext context) {
    return MeshBackground(
      dark: true,
      child: Stack(
        children: [
          const Positioned.fill(child: GridOverlay(opacity: 0.16)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
            child: Column(
              children: [
                NxReveal(
                  child: NxPill(
                    text: strings.t('cta.badge'),
                    leading: const Icon(Icons.auto_awesome,
                        size: 14, color: NxColors.brand300),
                    onDark: true,
                    uppercase: true,
                    fontSize: 10.5,
                    letterSpacing: 1.2,
                    textColor: NxColors.brand300,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                ),
                const SizedBox(height: 22),
                NxReveal(
                  delay: const Duration(milliseconds: 80),
                  child: Text(
                    strings.t('cta.title'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.sora(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      letterSpacing: -0.6,
                      color: NxColors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                NxReveal(
                  delay: const Duration(milliseconds: 160),
                  child: Text(
                    strings.t('cta.subtitle'),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15.5,
                      height: 1.6,
                      color: NxColors.slate300,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                NxReveal(
                  delay: const Duration(milliseconds: 240),
                  child: Column(
                    children: [
                      NxButton.primary(
                        label: strings.t('cta.ctaPrimary'),
                        icon: Icons.arrow_outward,
                        expand: true,
                        onPressed: onPrimary,
                      ),
                      const SizedBox(height: 12),
                      NxButton.ghost(
                        label: strings.t('cta.ctaSecondary'),
                        icon: Icons.explore_outlined,
                        expand: true,
                        onDark: true,
                        onPressed: onSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
