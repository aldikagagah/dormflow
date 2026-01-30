/// Advanced UI animation widgets for micro-interactions
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

/// Animated scale button with press effect
class ScaleButton extends StatefulWidget {

  const ScaleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.scaleValue = 0.95,
    this.duration = const Duration(milliseconds: 100),
    this.enabled = true,
  });
  final Widget child;
  final VoidCallback? onPressed;
  final double scaleValue;
  final Duration duration;
  final bool enabled;

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.scaleValue)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.enabled) _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    if (widget.enabled) widget.onPressed?.call();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AppAnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Fade slide transition for list items
class FadeSlideTransition extends StatefulWidget {

  const FadeSlideTransition({
    super.key,
    required this.child,
    this.index = 0,
    this.delay = const Duration(milliseconds: 50),
    this.duration = const Duration(milliseconds: 400),
    this.offset = const Offset(0, 20),
    this.animate = true,
  });
  final Widget child;
  final int index;
  final Duration delay;
  final Duration duration;
  final Offset offset;
  final bool animate;

  @override
  State<FadeSlideTransition> createState() => _FadeSlideTransitionState();
}

class _FadeSlideTransitionState extends State<FadeSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.animate) {
      Future.delayed(widget.delay * widget.index, () {
        if (mounted) _controller.forward();
      });
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppAnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _fadeAnimation.value,
        child: Transform.translate(
          offset: _slideAnimation.value,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Pulse animation for notifications/badges
class PulseAnimation extends StatefulWidget {

  const PulseAnimation({
    super.key,
    required this.child,
    this.animate = true,
    this.duration = const Duration(milliseconds: 1500),
  });
  final Widget child;
  final bool animate;
  final Duration duration;

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulseAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _controller.repeat(reverse: true);
    } else if (!widget.animate && oldWidget.animate) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.animate) return widget.child;

    return AppAnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Transform.scale(
        scale: _animation.value,
        child: widget.child,
      ),
    );
  }
}

/// Bouncing dots loading indicator
class BouncingDotsLoading extends StatefulWidget {

  const BouncingDotsLoading({
    super.key,
    this.color = AppTheme.primary,
    this.size = 10,
  });
  final Color color;
  final double size;

  @override
  State<BouncingDotsLoading> createState() => _BouncingDotsLoadingState();
}

class _BouncingDotsLoadingState extends State<BouncingDotsLoading>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      );
    });

    _animations = _controllers.map((controller) {
      return Tween<double>(begin: 0, end: -10).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      );
    }).toList();

    // Start animations with delay
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _controllers[i].repeat(reverse: true);
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AppAnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _animations[index].value),
            child: Container(
              width: widget.size,
              height: widget.size,
              margin: EdgeInsets.symmetric(horizontal: widget.size / 4),
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }
}

/// Skeleton loading card
class SkeletonCard extends StatelessWidget {

  const SkeletonCard({
    super.key,
    this.height = 100,
    this.width,
    this.borderRadius,
  });
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppTheme.neutral100,
        borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: const _ShimmerOverlay(),
    );
  }
}

/// Skeleton list tile
class SkeletonListTile extends StatelessWidget {

  const SkeletonListTile({
    super.key,
    this.hasLeading = true,
    this.hasTrailing = false,
  });
  final bool hasLeading;
  final bool hasTrailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      ),
      child: Row(
        children: [
          if (hasLeading) ...[
            const SkeletonCircle(size: 48),
            const SizedBox(width: AppTheme.spacingMd),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: MediaQuery.of(context).size.width * 0.4),
                const SizedBox(height: 8),
                SkeletonLine(width: MediaQuery.of(context).size.width * 0.25),
              ],
            ),
          ),
          if (hasTrailing)
            const SkeletonCircle(size: 32),
        ],
      ),
    );
  }
}

/// Skeleton circle
class SkeletonCircle extends StatelessWidget {

  const SkeletonCircle({super.key, this.size = 40});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppTheme.neutral200,
        shape: BoxShape.circle,
      ),
      child: const _ShimmerOverlay(isCircle: true),
    );
  }
}

/// Skeleton line
class SkeletonLine extends StatelessWidget {

  const SkeletonLine({
    super.key,
    this.width = 100,
    this.height = 12,
  });
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.neutral200,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: const _ShimmerOverlay(),
    );
  }
}

/// Shimmer overlay effect
class _ShimmerOverlay extends StatefulWidget {

  const _ShimmerOverlay({this.isCircle = false});
  final bool isCircle;

  @override
  State<_ShimmerOverlay> createState() => _ShimmerOverlayState();
}

class _ShimmerOverlayState extends State<_ShimmerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppAnimatedBuilder(
      animation: _controller,
      builder: (context, child) => ClipRRect(
        borderRadius: widget.isCircle
            ? BorderRadius.circular(1000)
            : BorderRadius.zero,
        child: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withValues(alpha: 0.3),
                Colors.transparent,
              ],
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((s) => s.clamp(0.0, 1.0)).toList(),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: Container(color: Colors.white),
        ),
      ),
    );
  }
}

/// Success checkmark animation
class SuccessCheckmark extends StatefulWidget {

  const SuccessCheckmark({
    super.key,
    this.size = 80,
    this.color = AppTheme.success,
    this.duration = const Duration(milliseconds: 800),
    this.onComplete,
  });
  final double size;
  final Color color;
  final Duration duration;
  final VoidCallback? onComplete;

  @override
  State<SuccessCheckmark> createState() => _SuccessCheckmarkState();
}

class _SuccessCheckmarkState extends State<SuccessCheckmark>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) => widget.onComplete?.call());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppAnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: CustomPaint(
            painter: _CheckmarkPainter(
              progress: _checkAnimation.value,
              color: Colors.white,
              strokeWidth: widget.size * 0.08,
            ),
          ),
        ),
      ),
    );
  }
}

class _CheckmarkPainter extends CustomPainter {

  _CheckmarkPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });
  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.3;

    // Checkmark path points
    final startPoint = Offset(center.dx - radius * 0.5, center.dy);
    final midPoint = Offset(center.dx - radius * 0.1, center.dy + radius * 0.4);
    final endPoint = Offset(center.dx + radius * 0.5, center.dy - radius * 0.3);

    final path = Path();

    if (progress <= 0.5) {
      // First line
      final t = progress * 2;
      path.moveTo(startPoint.dx, startPoint.dy);
      path.lineTo(
        startPoint.dx + (midPoint.dx - startPoint.dx) * t,
        startPoint.dy + (midPoint.dy - startPoint.dy) * t,
      );
    } else {
      // First line complete
      path.moveTo(startPoint.dx, startPoint.dy);
      path.lineTo(midPoint.dx, midPoint.dy);

      // Second line
      final t = (progress - 0.5) * 2;
      path.lineTo(
        midPoint.dx + (endPoint.dx - midPoint.dx) * t,
        midPoint.dy + (endPoint.dy - midPoint.dy) * t,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CheckmarkPainter oldDelegate) =>
      progress != oldDelegate.progress;
}

/// Animated counter text
class AnimatedCounter extends StatelessWidget {

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 500),
    this.prefix = '',
    this.suffix = '',
  });
  final int value;
  final TextStyle? style;
  final Duration duration;
  final String prefix;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      builder: (context, value, child) {
        return Text(
          '$prefix$value$suffix',
          style: style ?? AppTheme.headingLg,
        );
      },
    );
  }
}

/// Rotating refresh icon
class RotatingRefreshIcon extends StatefulWidget {

  const RotatingRefreshIcon({
    super.key,
    this.isLoading = false,
    this.onTap,
    this.color,
    this.size = 24,
  });
  final bool isLoading;
  final VoidCallback? onTap;
  final Color? color;
  final double size;

  @override
  State<RotatingRefreshIcon> createState() => _RotatingRefreshIconState();
}

class _RotatingRefreshIconState extends State<RotatingRefreshIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(RotatingRefreshIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _controller.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onTap,
      child: AppAnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Transform.rotate(
          angle: _controller.value * 2 * math.pi,
          child: Icon(
            Icons.refresh_rounded,
            color: widget.color ?? AppTheme.neutral600,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}

/// Simple AppAnimatedBuilder without child requirement
class AppAnimatedBuilder extends AnimatedWidget {

  const AppAnimatedBuilder({
    super.key,
    required Animation<dynamic> animation,
    required this.builder,
  }) : super(listenable: animation);
  final Widget Function(BuildContext context, Widget? child) builder;

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}

