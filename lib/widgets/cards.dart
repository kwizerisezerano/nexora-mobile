import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'common.dart';

class StatItem {
  const StatItem(this.value, this.label);

  final String value;
  final String label;
}

/// Compact statistics band with internal dividers (website `StatsBand`).
class StatBand extends StatelessWidget {
  const StatBand({super.key, required this.stats, this.note});

  final List<StatItem> stats;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    return Column(
      children: [
        NxCard(
          padding: const EdgeInsets.all(6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _cell(context, stats[0]),
                      _vDivider(p),
                      _cell(context, stats[1]),
                    ],
                  ),
                ),
                _hDivider(p),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _cell(context, stats[2]),
                      _vDivider(p),
                      _cell(context, stats[3]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (note != null) ...[
          const SizedBox(height: 16),
          Text(
            note!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _vDivider(NxPalette p) => Container(width: 1, color: p.divider);

  Widget _hDivider(NxPalette p) => Container(height: 1, color: p.divider);

  Widget _cell(BuildContext context, StatItem item) => Expanded(
        child: Container(
          color: context.nx.card,
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 8),
          child: Column(
            children: [
              NxGradientText(
                item.value,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 6),
              Text(
                item.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: context.nx.muted,
                ),
              ),
            ],
          ),
        ),
      );
}

enum ProjectAction { visit, caseStudy, demo }

/// Portfolio project card (website `ProjectCard`).
class ProjectCard extends StatelessWidget {
  const ProjectCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.category,
    required this.icon,
    required this.action,
    required this.actionLabel,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String description;
  final String category;
  final IconData icon;
  final ProjectAction action;
  final String actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    final actionIcon = switch (action) {
      ProjectAction.visit => Icons.north_east,
      ProjectAction.caseStudy => Icons.arrow_forward,
      ProjectAction.demo => Icons.arrow_forward,
    };

    return NxCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NxIconTile(icon: icon),
          const SizedBox(height: 16),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.brandAccent,
            ),
          ),
          const SizedBox(height: 10),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              NxPill(
                text: category,
                uppercase: true,
                fontSize: 10,
                letterSpacing: 0.6,
                backgroundColor: p.surfaceAlt,
                borderColor: p.cardBorder,
                textColor: p.muted,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              if (action == ProjectAction.visit)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const NxDot(),
                    const SizedBox(width: 6),
                    Text(
                      'LIVE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: context.brandLabel,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                actionLabel,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: context.brandAccent,
                ),
              ),
              const SizedBox(width: 4),
              Icon(actionIcon, size: 15, color: NxColors.brand500),
            ],
          ),
        ],
      ),
    );
  }
}

/// Client testimonial card (website `TestimonialCard`).
class TestimonialCard extends StatelessWidget {
  const TestimonialCard({
    super.key,
    required this.name,
    required this.role,
    required this.text,
    this.rating = 5,
  });

  final String name;
  final String role;
  final String text;
  final int rating;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    return NxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(
              rating,
              (_) => const Padding(
                padding: EdgeInsets.only(right: 2),
                child: Icon(Icons.star, size: 16, color: NxColors.amber400),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '“$text”',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 18),
          Container(height: 1, color: p.divider),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [NxColors.brand500, NxColors.brand700],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Text(
                  name.isEmpty ? '?' : name[0],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: NxColors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: p.heading,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: p.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Roadmap stage card with a large faded step number (website `RoadmapCard`).
class RoadmapCard extends StatelessWidget {
  const RoadmapCard({
    super.key,
    required this.index,
    required this.title,
    required this.description,
  });

  final int index;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final step = (index + 1).toString().padLeft(2, '0');
    return NxCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 1,
              color: context.isDark ? NxColors.brand500_30 : NxColors.brand200,
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// "What we build" capability row with a check badge (website Services list).
class CapabilityItem extends StatelessWidget {
  const CapabilityItem({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 1),
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: p.chipBg,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check, size: 14, color: p.chipFg),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: context.isDark ? NxColors.slate200 : NxColors.slate700,
            ),
          ),
        ),
      ],
    );
  }
}
