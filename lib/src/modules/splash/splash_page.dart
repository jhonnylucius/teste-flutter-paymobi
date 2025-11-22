import 'package:flutter/material.dart';
import 'package:base_project/src/core/core.dart';
import 'package:base_project/src/modules/payments/presentation/presentation.dart';

/// Splash Screen com animação da logo
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(AppAnimations.splashDuration);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) => const PaymentsPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: AppAnimations.normal,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo com animação combinada de fade e scale
            FadeScaleAnimation(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutBack,
              child: PulsingWidget(
                duration: const Duration(milliseconds: 1500),
                minScale: 0.98,
                maxScale: 1.02,
                child: const PayMobiLogo(height: 100),
              ),
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Loading indicator com fade in
            FadeInAnimation(
              duration: const Duration(milliseconds: 400),
              delay: const Duration(milliseconds: 300),
              child: const LoadingIndicator(
                color: AppColors.primaryGreen,
                size: 30,
                strokeWidth: 3,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            // Texto com slide in animation
            SlideAnimation(
              duration: const Duration(milliseconds: 500),
              delay: const Duration(milliseconds: 400),
              begin: const Offset(0, 0.5),
              curve: Curves.easeOut,
              child: FadeInAnimation(
                duration: const Duration(milliseconds: 500),
                delay: const Duration(milliseconds: 400),
                child: Text(
                  'Carregando...',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
