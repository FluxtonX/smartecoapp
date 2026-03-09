import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class DotIndicator extends StatelessWidget {
  final int totalDots;
  final int currentIndex;

  const DotIndicator({super.key, required this.totalDots, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalDots, (index) {
        bool isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.primaryLight,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
