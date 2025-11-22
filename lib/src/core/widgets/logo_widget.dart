import 'package:flutter/material.dart';
import 'package:base_project/src/core/core.dart';

/// Widget reutilizável para exibir a logo da PayMobi
class PayMobiLogo extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final bool showFallback;

  const PayMobiLogo({
    super.key,
    this.height,
    this.width,
    this.color,
    this.showFallback = true,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      '.github/assets/paymobi-logo.png',
      height: height,
      width: width,
      color: color,
      fit: BoxFit.contain,
      errorBuilder:
          showFallback
              ? (context, error, stackTrace) {
                return _LogoFallback(
                  height: height,
                  width: width,
                  color: color,
                );
              }
              : null,
    );
  }
}

/// Widget de fallback quando a logo não pode ser carregada
class _LogoFallback extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;

  const _LogoFallback({this.height, this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      child: Text(
        'PAYMOBI',
        style: AppTextStyles.headlineLarge.copyWith(
          color: color ?? AppColors.primaryGreen,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

/// Widget reutilizável para loading indicator
class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final double size;
  final double strokeWidth;

  const LoadingIndicator({
    super.key,
    this.color,
    this.size = 40,
    this.strokeWidth = 4,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primaryGreen,
        ),
      ),
    );
  }
}

/// Widget reutilizável para pulsing effect
class PulsingWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  const PulsingWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.minScale = 0.95,
    this.maxScale = 1.05,
  });

  @override
  State<PulsingWidget> createState() => _PulsingWidgetState();
}

class _PulsingWidgetState extends State<PulsingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
