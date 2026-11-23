import 'package:flutter/material.dart';

import 'common.dart';
import 'navbar.dart';

/// Shared, scrollable skeleton for the content tabs (Services, About,
/// Portfolio, Contact): the pinned app bar, a left-aligned page header and the
/// tab body. The page ends cleanly at its own content — the website footer
/// lives on Home only, so tabs never scroll through empty space.
class NxTabPage extends StatelessWidget {
  const NxTabPage({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    required this.children,
    this.background,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: CustomScrollView(
        slivers: [
          const NxSliverAppBar(),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 8),
              NxContainer(
                child: NxReveal(
                  child: NxSectionHeader(
                    eyebrow: eyebrow,
                    title: title,
                    subtitle: subtitle,
                    center: false,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              ...children,
              const SizedBox(height: 40),
            ]),
          ),
        ],
      ),
    );
  }
}
