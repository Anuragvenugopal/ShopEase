import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double fontSize;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 54,
    this.fontSize = 16.0,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultBgColor = widget.isOutlined
        ? Colors.transparent
        : (widget.backgroundColor ?? theme.colorScheme.primary);

    final defaultTextColor = widget.textColor ??
        (widget.isOutlined
            ? theme.colorScheme.primary
            : (isDark ? theme.colorScheme.onPrimary : Colors.white));

    return GestureDetector(
      onTapDown: (_) => widget.onPressed != null && !widget.isLoading ? _animationController.forward() : null,
      onTapUp: (_) => widget.onPressed != null && !widget.isLoading ? _animationController.reverse() : null,
      onTapCancel: () => widget.onPressed != null && !widget.isLoading ? _animationController.reverse() : null,
      onTap: widget.onPressed != null && !widget.isLoading ? widget.onPressed : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: widget.width ?? double.infinity,
          height: widget.height,
          child: widget.isOutlined
              ? OutlinedButton(
                  onPressed: widget.onPressed != null && !widget.isLoading ? widget.onPressed : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: defaultTextColor,
                    side: BorderSide(
                      color: widget.onPressed == null
                          ? theme.disabledColor
                          : (widget.backgroundColor ?? theme.colorScheme.primary),
                      width: 1.5,
                    ),
                    padding: widget.width != null ? EdgeInsets.zero : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _buildChild(defaultTextColor, theme),
                )
              : ElevatedButton(
                  onPressed: widget.onPressed != null && !widget.isLoading ? widget.onPressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultBgColor,
                    foregroundColor: defaultTextColor,
                    disabledBackgroundColor: theme.disabledColor.withOpacity(0.12),
                    disabledForegroundColor: theme.disabledColor.withOpacity(0.38),
                    shadowColor: Colors.transparent,
                    padding: widget.width != null ? EdgeInsets.zero : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _buildChild(defaultTextColor, theme),
                ),
        ),
      ),
    );
  }

  Widget _buildChild(Color textColor, ThemeData theme) {
    if (widget.isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, size: 20, color: textColor),
          const SizedBox(width: 8),
          Text(
            widget.text,
            style: theme.textTheme.labelLarge?.copyWith(
              color: textColor,
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Text(
      widget.text,
      style: theme.textTheme.labelLarge?.copyWith(
        color: textColor,
        fontSize: widget.fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}