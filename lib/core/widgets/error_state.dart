import 'package:flutter/material.dart';
import './custom_button.dart';

class ErrorState extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;
  final String title;

  const ErrorState({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    this.title = 'Oops! Something went wrong',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: theme.colorScheme.tertiary,
              ),
            ),
            const SizedBox(height: 24),

            
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: theme.colorScheme.onBackground,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            
            Text(
              errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            
            CustomButton(
              text: 'Retry Again',
              onPressed: onRetry,
              backgroundColor: theme.colorScheme.tertiary,
              textColor: Colors.white,
              width: 180,
              icon: Icons.refresh_rounded,
            ),
          ],
        ),
      ),
    );
  }
}