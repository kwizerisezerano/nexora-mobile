import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Decorative mesh background (radial brand/teal glows) mirroring the
/// website's `.mesh` / `.mesh-dark` helpers.
class MeshBackground extends StatelessWidget {
  const MeshBackground({super.key, this.child, this.dark});

  final Widget? child;

  /// Forces the dark mesh variant (used by the CTA band, which stays dark in
  /// both themes). Defaults to the active theme brightness.
  final bool? dark;

  @override
  Widget build(BuildContext context) {
    final isDark = dark ?? context.isDark;
    return DecoratedBox(
      decoration: BoxDecoration(color: isDark ? NxColors.slate950 : context.nx.bg),
      child: CustomPaint(
        painter: _MeshPainter(dark: isDark),
        child: child,
      ),
    );
  }
}

class _MeshPainter extends CustomPainter {
  _MeshPainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final full = Offset.zero & size;
    if (dark) {
      _spot(canvas, full, size, 0.14, 0.08, 0.62, NxColors.brand500_38);
      _spot(canvas, full, size, 0.88, 0.22, 0.52, const Color(0x382DD4BF));
      _spot(canvas, full, size, 0.50, 1.10, 0.64, const Color(0x4D28A745));
    } else {
      _spot(canvas, full, size, 0.12, 0.06, 0.58, const Color(0x2928A745));
      _spot(canvas, full, size, 0.92, 0.10, 0.44, const Color(0x245EEAD4));
      _spot(canvas, full, size, 0.78, 0.96, 0.58, const Color(0x1F28A745));
    }
  }

  void _spot(Canvas canvas, Rect full, Size size, double cx, double cy,
      double radiusFactor, Color color) {
    final center = Offset(size.width * cx, size.height * cy);
    final radius = size.longestSide * radiusFactor;
    final shader = RadialGradient(
      colors: [color, color.withAlpha(0)],
    ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawRect(full, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant _MeshPainter old) => old.dark != dark;
}

/// Faint grid overlay used behind the hero.
class GridOverlay extends StatelessWidget {
  const GridOverlay({super.key, this.opacity = 0.7});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: opacity,
        child: CustomPaint(
          painter: _GridPainter(context.nx.gridLine),
          size: Size.infinite,
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const step = 56.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.color != color;
}

/// Staggered fade + slide-in used for section entrance (website `reveal`).
class NxReveal extends StatefulWidget {
  const NxReveal({super.key, required this.child, this.delay = Duration.zero});

  final Widget child;
  final Duration delay;

  @override
  State<NxReveal> createState() => _NxRevealState();
}

class _NxRevealState extends State<NxReveal>
    with SingleTickerProviderStateMixin {
  static const _animMs = 520;
  late final int _totalMs = widget.delay.inMilliseconds + _animMs;
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _totalMs),
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      widget.delay.inMilliseconds / _totalMs,
      1.0,
      curve: Curves.easeOutCubic,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      return widget.child;
    }
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) {
        final t = _animation.value;
        return Opacity(
          opacity: t,
          child: Transform.translate(offset: Offset(0, (1 - t) * 22), child: child),
        );
      },
    );
  }
}

/// Small colored circle used by pills, eyebrows and status indicators.
class NxDot extends StatelessWidget {
  const NxDot({super.key, this.size = 6, this.color = NxColors.brand500});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// Small uppercase label with a leading brand dot (website `.eyebrow`).
class NxEyebrow extends StatelessWidget {
  const NxEyebrow({super.key, required this.text, this.center = false});

  final String text;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: center ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        const NxDot(),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: context.brandAccent,
            ),
          ),
        ),
      ],
    );
  }
}

/// Eyebrow + title + subtitle used to head each section. Centered by default
/// (in-section headers); pass `center: false` for the left-aligned, app-style
/// page headers used at the top of each tab.
class NxSectionHeader extends StatelessWidget {
  const NxSectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.center = true,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    return Column(
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        NxEyebrow(text: eyebrow, center: center),
        const SizedBox(height: 14),
        Text(
          title,
          textAlign: center ? TextAlign.center : TextAlign.start,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 14),
          Text(
            subtitle!,
            textAlign: center ? TextAlign.center : TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: p.body),
          ),
        ],
      ],
    );
  }
}

/// Rounded gradient icon container (website `.icon-tile`).
class NxIconTile extends StatelessWidget {
  const NxIconTile({super.key, required this.icon, this.size = 52, this.iconSize = 24});

  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: NxGradients.tile(context.isDark),
        borderRadius: BorderRadius.circular(size * 0.28),
        border: Border.all(color: p.tileBorder),
      ),
      child: Icon(icon, size: iconSize, color: p.tileFg),
    );
  }
}

/// Bordered rounded square wrapping a small icon or widget (app-bar actions,
/// footer socials). Interactive boxes keep their visual size but expand their
/// tap target to at least [_minTapSize] to meet the Material 3 / iOS HIG
/// minimum, and expose a [semanticLabel] to screen readers.
class NxIconBox extends StatelessWidget {
  const NxIconBox({
    super.key,
    required this.child,
    this.size = 40,
    this.background,
    this.onTap,
    this.semanticLabel,
  });

  static const _minTapSize = 48.0;

  final Widget child;
  final double size;
  final Color? background;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background ?? context.nx.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.nx.cardBorder),
      ),
      child: child,
    );

    Widget result = box;
    if (onTap != null) {
      final target = size < _minTapSize ? _minTapSize : size;
      result = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: target,
            height: target,
            child: Center(child: box),
          ),
        ),
      );
    }

    if (semanticLabel == null) return result;
    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      child: result,
    );
  }
}

/// Pill/badge used for tags, status chips and section badges. Colours default to
/// the themed chip tokens; pass overrides for category or on-dark variants.
class NxPill extends StatelessWidget {
  const NxPill({
    super.key,
    required this.text,
    this.leading,
    this.leadingDot = false,
    this.uppercase = false,
    this.onDark = false,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.fontSize = 11,
    this.fontWeight = FontWeight.w700,
    this.letterSpacing = 0.2,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  final String text;

  /// Explicit leading widget (e.g. a pulse dot or icon). Takes precedence over
  /// [leadingDot].
  final Widget? leading;
  final bool leadingDot;
  final bool uppercase;
  final bool onDark;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double letterSpacing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    final background = backgroundColor ?? (onDark ? NxColors.white06 : p.chipBg);
    final borderColor = this.borderColor ?? (onDark ? NxColors.white18 : p.chipBorder);
    final color = textColor ?? (onDark ? NxColors.brand300 : p.chipFg);
    final leadingWidget = leading ?? (leadingDot ? const NxDot() : null);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leadingWidget != null) ...[
            leadingWidget,
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              uppercase ? text.toUpperCase() : text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight,
                letterSpacing: letterSpacing,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Green gradient-clipped text used on key headings (website `.text-gradient`).
class NxGradientText extends StatelessWidget {
  const NxGradientText(this.text, {super.key, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => NxGradients.text.createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(text, style: style),
    );
  }
}

/// Base surface card (website `.card`).
class NxCard extends StatelessWidget {
  const NxCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 20,
    this.onTap,
    this.highlight = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;

  /// When true, a brand-tinted border is drawn (website `card-hover` accent).
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    final decoration = BoxDecoration(
      color: p.card,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(
        color: highlight ? NxColors.brand200 : p.cardBorder,
        width: highlight ? 1.4 : 1,
      ),
      boxShadow: context.shadowSoft,
    );
    final content = Padding(padding: padding, child: child);
    if (onTap == null) {
      return DecoratedBox(decoration: decoration, child: content);
    }
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: decoration,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: content,
        ),
      ),
    );
  }
}

/// Filled brand button (`.btn-primary`) and outlined ghost button
/// (`.btn-ghost`) sharing one implementation.
class NxButton extends StatelessWidget {
  const NxButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = false,
    this.onDark = false,
  }) : variant = NxButtonVariant.primary;

  const NxButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = false,
    this.onDark = false,
  }) : variant = NxButtonVariant.ghost;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;
  final NxButtonVariant variant;

  /// Dark-surface variant (used on the always-dark CTA band).
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final p = context.nx;
    final radius = BorderRadius.circular(13);
    final isPrimary = variant == NxButtonVariant.primary;
    final foreground = isPrimary || onDark ? NxColors.white : p.heading;
    final iconColor = isPrimary || onDark ? NxColors.white : NxColors.brand600;

    final decoration = isPrimary
        ? BoxDecoration(
            gradient: NxGradients.brandButton,
            borderRadius: radius,
            boxShadow: const [
              BoxShadow(
                color: NxColors.shadowGlow,
                blurRadius: 26,
                spreadRadius: -12,
                offset: Offset(0, 12),
              ),
            ],
          )
        : BoxDecoration(
            color: onDark ? NxColors.white06 : p.card,
            borderRadius: radius,
            border: Border.all(color: onDark ? NxColors.white18 : p.cardBorder),
          );

    return Opacity(
      opacity: isPrimary && onPressed == null ? 0.6 : 1,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: decoration,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              child: Row(
                mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                        color: foreground,
                      ),
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(icon, size: 18, color: iconColor),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum NxButtonVariant { primary, ghost }

/// Standard horizontal page padding (website `.container-x`). Content is also
/// capped to a comfortable reading width and centered via [NxConstrained] so
/// screens never stretch edge-to-edge on tablets or wide windows.
class NxContainer extends StatelessWidget {
  const NxContainer({
    super.key,
    required this.child,
    this.padding,
    this.maxWidth = 640,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20),
      child: NxConstrained(maxWidth: maxWidth, child: child),
    );
  }
}

/// Centers [child] and caps its width at [maxWidth], stretching it to the
/// available width otherwise.
class NxConstrained extends StatelessWidget {
  const NxConstrained({super.key, required this.child, this.maxWidth = 640});

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SizedBox(width: double.infinity, child: child),
      ),
    );
  }
}

/// Small green dot with an expanding, fading ring (website `pulse-ring`).
class PulseDot extends StatefulWidget {
  const PulseDot({super.key, this.size = 8});

  final double size;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 3200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: (0.55 * (1 - t)).clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: 0.9 + t * 0.9,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: const BoxDecoration(
                      color: NxColors.brand500,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Container(
                width: widget.size,
                height: widget.size,
                decoration: const BoxDecoration(
                  color: NxColors.brand500,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
