import 'package:flutter/material.dart';


enum AppTextVariant {
  
  displayLarge,

  
  displayMedium,

  
  displaySmall,

  
  headlineLarge,

  
  headlineMedium,

  
  headlineSmall,

  
  titleLarge,

  
  titleMedium,

  
  titleSmall,

  
  bodyLarge,

  
  bodyMedium,

  
  bodySmall,

  
  labelLarge,

  
  labelMedium,

  
  labelSmall,
}









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

  
  final String text;

  
  final AppTextVariant variant;

  
  
  final bool bold;

  
  final Color? color;

  
  final double? fontSize;

  
  final FontWeight? fontWeight;

  
  final TextAlign? align;

  
  final int? maxLines;

  
  final TextOverflow? overflow;

  
  final double? height;

  
  final double? letterSpacing;

  
  final TextDecoration? decoration;

  
  final bool? softWrap;

  

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
