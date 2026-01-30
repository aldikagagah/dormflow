/// Interactive card widgets with modern UI effects
library;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import 'animation_widgets.dart' show AppAnimatedBuilder;

/// Interactive card with hover and press effects
class InteractiveCard extends StatefulWidget {

  const InteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.borderRadius,
    this.backgroundColor,
    this.boxShadow,
    this.enabled = true,
  });
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final List<BoxShadow>? boxShadow;
  final bool enabled;

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enabled && widget.onTap != null) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    if (widget.enabled) widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AppAnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shadows = widget.boxShadow ?? AppTheme.shadowSm;
        final scaledShadows = shadows.map((s) => BoxShadow(
          color: s.color,
          offset: s.offset * _elevationAnimation.value,
          blurRadius: s.blurRadius * _elevationAnimation.value,
          spreadRadius: s.spreadRadius * _elevationAnimation.value,
        )).toList();

        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onLongPress: widget.enabled ? widget.onLongPress : null,
            child: Container(
              margin: widget.margin,
              padding: widget.padding ?? const EdgeInsets.all(AppTheme.spacingMd),
              decoration: BoxDecoration(
                color: widget.backgroundColor ?? AppTheme.surface,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusLg),
                boxShadow: scaledShadows,
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

/// Slidable action card for swipe actions
class SlidableCard extends StatefulWidget {

  const SlidableCard({
    super.key,
    required this.child,
    required this.actions,
    this.actionWidth = 80,
  });
  final Widget child;
  final List<SlidableAction> actions;
  final double actionWidth;

  @override
  State<SlidableCard> createState() => _SlidableCardState();
}

class _SlidableCardState extends State<SlidableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0;

  double get _swipeThreshold => widget.actionWidth * widget.actions.length;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent = (_dragExtent + details.delta.dx).clamp(-_swipeThreshold, 0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_dragExtent.abs() > _swipeThreshold / 2) {
      setState(() => _dragExtent = -_swipeThreshold);
    } else {
      setState(() => _dragExtent = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background actions
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: widget.actions.map((action) {
              return GestureDetector(
                onTap: () {
                  setState(() => _dragExtent = 0);
                  action.onTap?.call();
                },
                child: Container(
                  width: widget.actionWidth,
                  color: action.backgroundColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(action.icon, color: action.foregroundColor, size: 24),
                      if (action.label != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          action.label!,
                          style: TextStyle(
                            color: action.foregroundColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Foreground card
        GestureDetector(
          onHorizontalDragUpdate: _handleDragUpdate,
          onHorizontalDragEnd: _handleDragEnd,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            transform: Matrix4.translationValues(_dragExtent, 0, 0),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}

/// Slidable action config
class SlidableAction {

  const SlidableAction({
    required this.icon,
    this.label,
    this.backgroundColor = AppTheme.error,
    this.foregroundColor = Colors.white,
    this.onTap,
  });
  final IconData icon;
  final String? label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback? onTap;
}

/// Expandable card that reveals more content
class ExpandableCard extends StatefulWidget {

  const ExpandableCard({
    super.key,
    required this.header,
    required this.expandedContent,
    this.initiallyExpanded = false,
    this.duration = const Duration(milliseconds: 300),
    this.padding,
  });
  final Widget header;
  final Widget expandedContent;
  final bool initiallyExpanded;
  final Duration duration;
  final EdgeInsetsGeometry? padding;

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      value: _isExpanded ? 1.0 : 0.0,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _rotationAnimation = Tween<double>(begin: 0, end: 0.5).animate(_expandAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Expanded(child: widget.header),
                RotationTransition(
                  turns: _rotationAnimation,
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppTheme.neutral500,
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacingMd),
                const Divider(height: 1),
                const SizedBox(height: AppTheme.spacingMd),
                widget.expandedContent,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Gradient card with animated border
class GradientBorderCard extends StatefulWidget {

  const GradientBorderCard({
    super.key,
    required this.child,
    this.gradientColors = const [AppTheme.primary, AppTheme.secondary],
    this.borderWidth = 2,
    this.padding,
    this.borderRadius,
    this.animate = false,
  });
  final Widget child;
  final List<Color> gradientColors;
  final double borderWidth;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool animate;

  @override
  State<GradientBorderCard> createState() => _GradientBorderCardState();
}

class _GradientBorderCardState extends State<GradientBorderCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final radius = widget.borderRadius ?? BorderRadius.circular(AppTheme.radiusLg);

    return AppAnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: widget.gradientColors,
              transform: widget.animate
                  ? GradientRotation(_controller.value * 6.28)
                  : null,
            ),
          ),
          child: Container(
            margin: EdgeInsets.all(widget.borderWidth),
            padding: widget.padding ?? const EdgeInsets.all(AppTheme.spacingMd),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(
                (radius.topLeft.x - widget.borderWidth).clamp(0, double.infinity),
              ),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Stats card with animated value
class StatsCard extends StatelessWidget {

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    this.color = AppTheme.primary,
    this.onTap,
    this.animate = true,
  });
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return InteractiveCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: AppTheme.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.bodySm),
                const SizedBox(height: 4),
                if (animate)
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, progress, child) {
                      return Opacity(
                        opacity: progress,
                        child: Transform.translate(
                          offset: Offset(0, 10 * (1 - progress)),
                          child: Text(value, style: AppTheme.headingMd),
                        ),
                      );
                    },
                  )
                else
                  Text(value, style: AppTheme.headingMd),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: AppTheme.labelSm),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
