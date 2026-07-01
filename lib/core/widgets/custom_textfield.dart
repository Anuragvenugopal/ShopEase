import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool showClearButton;

  const CustomTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.onChanged,
    this.onFieldSubmitted,
    this.showClearButton = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    if (widget.controller != null) {
      widget.controller!.addListener(_handleTextChange);
    }
  }

  void _handleTextChange() {
    if (widget.controller != null) {
      setState(() {
        _showClear = widget.controller!.text.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.removeListener(_handleTextChange);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      validator: widget.validator,
      enabled: widget.enabled,
      onChanged: (val) {
        if (widget.onChanged != null) widget.onChanged!(val);
        setState(() {
          _showClear = val.isNotEmpty;
        });
      },
      onFieldSubmitted: widget.onFieldSubmitted,
      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon != null 
            ? Icon(widget.prefixIcon, size: 22, color: theme.colorScheme.onSurface.withOpacity(0.6))
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 22,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : (widget.showClearButton && _showClear)
                ? IconButton(
                    icon: Icon(Icons.close_rounded, size: 22, color: theme.colorScheme.onSurface.withOpacity(0.6)),
                    onPressed: () {
                      widget.controller?.clear();
                      if (widget.onChanged != null) widget.onChanged!('');
                      setState(() {
                        _showClear = false;
                      });
                    },
                  )
                : widget.suffixIcon,
      ),
    );
  }
}
