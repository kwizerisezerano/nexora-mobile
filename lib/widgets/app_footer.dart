import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../core/site.dart';
import '../theme/app_theme.dart';
import '../core/utils.dart';
import 'common.dart';
import 'nexora_logo.dart';

/// Website-style footer: brand, socials, service/company links and contact.
/// Sits at the end of the Home scroll.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key, required this.onNavigate});

  /// Switches the shell tab (1=Services, 2=About, 3=Portfolio, 4=Contact).
  final void Function(int tab) onNavigate;

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final p = context.nx;

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: p.divider)),
      ),
      child: MeshBackground(
        child: NxContainer(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 44),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NexoraLogo(height: 30, onWhiteChip: context.isDark),
              const SizedBox(height: 18),
              Text(
                strings.t('footer.tagline'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final social in Site.socials)
                    NxIconBox(
                      size: 42,
                      background: p.surfaceAlt,
                      semanticLabel: social.label,
                      onTap: social.label == 'WhatsApp'
                          ? () => openExternal(Site.whatsappUri)
                          : null,
                      child: Icon(social.icon, size: 19, color: p.muted),
                    ),
                ],
              ),
              const SizedBox(height: 34),
              _FooterColumn(
                title: strings.t('footer.servicesTitle'),
                children: [
                  for (final item in strings.tList('footer.services'))
                    _FooterLink(label: item, onTap: () => onNavigate(1)),
                ],
              ),
              const SizedBox(height: 30),
              _FooterColumn(
                title: strings.t('footer.companyTitle'),
                children: [
                  _FooterLink(label: strings.t('footer.companyAbout'), onTap: () => onNavigate(2)),
                  _FooterLink(label: strings.t('footer.companyServices'), onTap: () => onNavigate(1)),
                  _FooterLink(label: strings.t('footer.companyPortfolio'), onTap: () => onNavigate(3)),
                  _FooterLink(label: strings.t('footer.companyContact'), onTap: () => onNavigate(4)),
                ],
              ),
              const SizedBox(height: 30),
              _FooterColumn(
                title: strings.t('footer.connectTitle'),
                children: [
                  _IconLine(icon: Icons.location_on_outlined, text: strings.t('footer.location'), onTap: () => openExternal(Site.mapUri)),
                  _IconLine(icon: Icons.mail_outline, text: Site.email, onTap: () => openExternal(Site.emailUri)),
                  _IconLine(icon: Icons.schedule, text: strings.t('footer.hours')),
                ],
              ),
              const SizedBox(height: 34),
              Container(height: 1, color: p.divider),
              const SizedBox(height: 20),
              Text(
                strings.t('footer.copyright'),
                style: TextStyle(fontSize: 13, color: p.muted),
              ),
              const SizedBox(height: 6),
              Text(
                strings.t('footer.builtIn'),
                style: TextStyle(fontSize: 13, color: p.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
            color: context.nx.heading,
          ),
        ),
        const SizedBox(height: 14),
        ...children,
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          label,
          style: TextStyle(fontSize: 14, color: context.nx.body),
        ),
      ),
    );
  }
}

class _IconLine extends StatelessWidget {
  const _IconLine({required this.icon, required this.text, this.onTap});

  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 16, color: context.brandAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 14, color: p.body),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
