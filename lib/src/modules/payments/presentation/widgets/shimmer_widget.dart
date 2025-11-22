import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:base_project/src/core/core.dart';

/// Widget de Shimmer para efeito de loading
class ShimmerWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const ShimmerWidget({super.key, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase,
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppSpacing.radiusSm),
        ),
      ),
    );
  }
}

/// Shimmer para Card de Summary
class SummaryCardShimmer extends StatelessWidget {
  const SummaryCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerWidget(width: 100, height: 12),
            const SizedBox(height: AppSpacing.sm),
            const ShimmerWidget(width: 140, height: 28),
          ],
        ),
      ),
    );
  }
}

/// Shimmer para Item de Transaction
class TransactionItemShimmer extends StatelessWidget {
  const TransactionItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerWidget(width: 80, height: 14),
                const SizedBox(height: AppSpacing.xs),
                const ShimmerWidget(width: 120, height: 12),
              ],
            ),
          ),
          const ShimmerWidget(width: 60, height: 16),
        ],
      ),
    );
  }
}

/// Shimmer para Item de Schedule
class ScheduleItemShimmer extends StatelessWidget {
  const ScheduleItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          const ShimmerWidget(
            width: 60,
            height: 60,
            borderRadius: BorderRadius.all(
              Radius.circular(AppSpacing.radiusSm),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerWidget(width: 100, height: 14),
                const SizedBox(height: AppSpacing.xs),
                const ShimmerWidget(width: 150, height: 12),
              ],
            ),
          ),
          const ShimmerWidget(width: 70, height: 16),
        ],
      ),
    );
  }
}
