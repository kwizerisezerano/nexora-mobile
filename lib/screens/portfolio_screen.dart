import 'package:flutter/material.dart';

import '../l10n/app_strings.dart';
import '../core/site.dart';
import '../theme/app_theme.dart';
import '../core/utils.dart';
import '../widgets/cards.dart';
import '../widgets/common.dart';
import '../widgets/tab_page.dart';

/// Portfolio tab — six real projects with the same action semantics as the
/// website (external visit, case study, or demo request).
class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key, required this.onNavigate});

  final void Function(int tab) onNavigate;

  static const _icons = [
    Icons.savings_outlined,
    Icons.volunteer_activism_outlined,
    Icons.dashboard_customize_outlined,
    Icons.school_outlined,
    Icons.palette_outlined,
    Icons.monitor_heart_outlined,
  ];

  static const _actions = [
    ProjectAction.demo,
    ProjectAction.visit,
    ProjectAction.demo,
    ProjectAction.demo,
    ProjectAction.visit,
    ProjectAction.caseStudy,
  ];

  void _onProject(BuildContext context, int index, Map<String, dynamic> project) {
    switch (_actions[index]) {
      case ProjectAction.visit:
        openExternal(index == 1 ? Site.gecoRwanda : Site.elVerbuena);
      case ProjectAction.caseStudy:
        _showCaseStudy(context, project, () {
          Navigator.of(context).pop();
          onNavigate(4);
        });
      case ProjectAction.demo:
        onNavigate(4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final projects = strings.tObjects('portfolio.projects');

    String actionLabel(ProjectAction action) => switch (action) {
          ProjectAction.visit => strings.t('portfolio.visitSite'),
          ProjectAction.caseStudy => strings.t('portfolio.caseStudy'),
          ProjectAction.demo => strings.t('portfolio.requestDemo'),
        };

    return NxTabPage(
      eyebrow: strings.t('portfolio.eyebrow'),
      title: strings.t('portfolio.title'),
      subtitle: strings.t('portfolio.subtitle'),
      children: [
        NxContainer(
          child: Column(
            children: [
              for (var i = 0; i < projects.length; i++) ...[
                NxReveal(
                  delay: Duration(milliseconds: (i % 3) * 90),
                  child: ProjectCard(
                    title: projects[i]['title'] as String? ?? '',
                    subtitle: projects[i]['subtitle'] as String? ?? '',
                    description: projects[i]['description'] as String? ?? '',
                    category: projects[i]['category'] as String? ?? '',
                    icon: _icons[i % _icons.length],
                    action: _actions[i % _actions.length],
                    actionLabel: actionLabel(_actions[i % _actions.length]),
                    onTap: () => _onProject(context, i, projects[i]),
                  ),
                ),
                if (i != projects.length - 1) const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

void _showCaseStudy(
  BuildContext context,
  Map<String, dynamic> project,
  VoidCallback onContact,
) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.nx.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    isScrollControlled: true,
    builder: (context) {
      final p = context.nx;
      final strings = AppStrings.of(context);
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: p.divider,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const NxIconTile(
                  icon: Icons.monitor_heart_outlined, size: 54, iconSize: 27),
              const SizedBox(height: 18),
              Text(
                project['title'] as String? ?? '',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                project['subtitle'] as String? ?? '',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.brandAccent,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                project['description'] as String? ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              NxButton.primary(
                label: strings.t('portfolio.requestDemo'),
                icon: Icons.arrow_outward,
                expand: true,
                onPressed: onContact,
              ),
            ],
          ),
        ),
      );
    },
  );
}
