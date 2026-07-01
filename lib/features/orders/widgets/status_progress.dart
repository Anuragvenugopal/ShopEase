import 'package:flutter/material.dart';

class StatusProgress extends StatelessWidget {
  final int currentStep;

  const StatusProgress({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final List<String> steps = ['Ordered', 'Process', 'Shipped', 'Delivered'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= currentStep;
        final isLast = index == steps.length - 1;

        return Expanded(
          child: Row(
            children: [
              // Step Dot
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: isCompleted ? theme.colorScheme.secondary : theme.dividerColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: isCompleted
                    ? const Icon(Icons.check, size: 12, color: Colors.white)
                    : null,
              ),

              // Connecting Line
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 3,
                    color: index < currentStep ? theme.colorScheme.secondary : theme.dividerColor,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}