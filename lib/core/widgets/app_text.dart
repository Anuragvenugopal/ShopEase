import 'package:flutter/material.dart';

/// Semantic text style variants that map 1-to-1 to the app's [TextTheme].
enum AppTextVariant {
  /// [TextTheme.displayLarge] — hero titles (e.g., splash brand name)
  displayLarge,

  /// [TextTheme.displayMedium] — screen titles, large headings
  displayMedium,

  /// [TextTheme.displaySmall] — sub-titles
  displaySmall,

  /// [TextTheme.headlineLarge]
  headlineLarge,

  /// [TextTheme.headlineMedium]
  headlineMedium,

  /// [TextTheme.headlineSmall]
  headlineSmall,

  /// [TextTheme.titleLarge] — card / section titles
  titleLarge,

  /// [TextTheme.titleMedium] — section labels
  titleMedium,

  /// [TextTheme.titleSmall]
  titleSmall,

  /// [TextTheme.bodyLarge] — primary body copy
  bodyLarge,

  /// [TextTheme.bodyMedium] — secondary body copy (default)
  bodyMedium,

  /// [TextTheme.bodySmall] — captions, timestamps
  bodySmall,

  /// [TextTheme.labelLarge] — buttons, links
  labelLarge,

  /// [TextTheme.labelMedium]
  labelMedium,

  /// [TextTheme.labelSmall]
  labelSmall,
}

/// A unified, theme-aware text widget used throughout the ShopEase app.
///
/// Usage examples:
/// ```dart
/// AppText('Welcome Back', variant: AppTextVariant.displayMedium, bold: true)
/// AppText('Sign in to explore', variant: AppTextVariant.bodyMedium, align: TextAlign.center)
/// AppText('Forgot Password?', variant: AppTextVariant.labelLarge, color: Colors.blue)
/// ```
class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.variant = AppTextVariant.bodyMedium,
    this.bold = false,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.align,
    this.maxLines,
    this.overflow,
    this.height,
    this.letterSpacing,
    this.decoration,
    this.softWrap,
  });

  /// The text string to display.
  final String text;

  /// Which [TextTheme] style to use. Defaults to [AppTextVariant.bodyMedium].
  final AppTextVariant variant;

  /// Shorthand to set [FontWeight.bold]. Overridden by [fontWeight] when both
  /// are provided.
  final bool bold;

  /// Override the inherited/themed text colour.
  final Color? color;

  /// Override the font size from the theme style.
  final double? fontSize;

  /// Explicit font weight. Takes priority over [bold].
  final FontWeight? fontWeight;

  /// Text alignment.
  final TextAlign? align;

  /// Maximum number of lines before truncation.
  final int? maxLines;

  /// What to do when text overflows.
  final TextOverflow? overflow;

  /// Line-height multiplier applied via [TextStyle.height].
  final double? height;

  /// Extra letter spacing.
  final double? letterSpacing;

  /// Text decoration (e.g., underline).
  final TextDecoration? decoration;

  /// Whether the text should break at soft line breaks.
  final bool? softWrap;

  // ─── helpers ──────────────────────────────────────────────────────────────

  TextStyle? _baseStyle(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    switch (variant) {
      case AppTextVariant.displayLarge:
        return tt.displayLarge;
      case AppTextVariant.displayMedium:
        return tt.displayMedium;
      case AppTextVariant.displaySmall:
        return tt.displaySmall;
      case AppTextVariant.headlineLarge:
        return tt.headlineLarge;
      case AppTextVariant.headlineMedium:
        return tt.headlineMedium;
      case AppTextVariant.headlineSmall:
        return tt.headlineSmall;
      case AppTextVariant.titleLarge:
        return tt.titleLarge;
      case AppTextVariant.titleMedium:
        return tt.titleMedium;
      case AppTextVariant.titleSmall:
        return tt.titleSmall;
      case AppTextVariant.bodyLarge:
        return tt.bodyLarge;
      case AppTextVariant.bodyMedium:
        return tt.bodyMedium;
      case AppTextVariant.bodySmall:
        return tt.bodySmall;
      case AppTextVariant.labelLarge:
        return tt.labelLarge;
      case AppTextVariant.labelMedium:
        return tt.labelMedium;
      case AppTextVariant.labelSmall:
        return tt.labelSmall;
    }
  }

  @override
  Widget build(BuildContext context) {
    final resolvedWeight = fontWeight ?? (bold ? FontWeight.bold : null);

    final style = _baseStyle(context)?.copyWith(
      fontWeight: resolvedWeight,
      color: color,
      fontSize: fontSize,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
    );

    return Text(
      text,
      style: style,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}
