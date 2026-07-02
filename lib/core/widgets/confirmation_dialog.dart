import 'package:flutter/material.dart';
import './custom_button.dart';

class ConfirmationDialog extends StatefulWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final bool isDangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.isDangerous = false,
  });

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();

  // Static helper to display dialog
  static Future<void> show(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    required VoidCallback onConfirm,
    bool isDangerous = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => ConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        isDangerous: isDangerous,
      ),
    );
  }

  // Static helper to show action bottom sheets
  static Future<T?> showActionBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    String? title,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 20,
          ),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF161F30) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pull indicator
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              if (title != null) ...[
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
              ],
              child,
            ],
          ),
        );
      },
    );
  }
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      alignment: const Alignment(0, -0.2),
      backgroundColor: isDark ? const Color(0xFF161F30) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning/Alert Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (widget.isDangerous ? theme.colorScheme.tertiary : theme.colorScheme.primary).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.isDangerous ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
                    color: widget.isDangerous ? theme.colorScheme.tertiary : theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            
            // Message Body
            Text(
              widget.content,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 18),
            
            // Buttons Row
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: widget.cancelText,
                    isOutlined: true,
                    height: 54,
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: widget.confirmText,
                    backgroundColor: widget.isDangerous ? theme.colorScheme.tertiary : theme.colorScheme.primary,
                    textColor: Colors.white,
                    isLoading: _isLoading,
                    height: 54,
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      // Short delay to show loading animation before completing onConfirm and popping
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        if (mounted) {
                          Navigator.pop(context);
                          widget.onConfirm();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
