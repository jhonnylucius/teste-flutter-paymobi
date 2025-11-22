import 'package:flutter/material.dart';
import 'package:base_project/src/core/core.dart';

/// Widget de estado vazio para quando não há dados
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: AppSpacing.giant, color: AppColors.grey400),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.emptyStateTitle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
