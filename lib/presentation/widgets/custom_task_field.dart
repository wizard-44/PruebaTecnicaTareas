import 'package:flutter/material.dart';

class CustomTaskField extends StatelessWidget {
  final bool isTopField;
  final bool isBottomField;
  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int maxLines;
  final String initialValue;
  final Function(String)? onSaved;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;

  const CustomTaskField({
    super.key,
    this.isTopField = false,
    this.isBottomField = false,
    this.label,
    this.hint,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.initialValue = '',
    this.onSaved,
    this.onFieldSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: _boxDecoration(context),
      child: TextFormField(
        initialValue: initialValue,
        maxLines: maxLines,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 15, color: Colors.black54),
        onChanged: onSaved,
        onFieldSubmitted: onFieldSubmitted,
        validator: validator,
        decoration: _inputDecoration(context),
      ),
    );
  }

  BoxDecoration _boxDecoration(BuildContext context) {
    const borderRadius = Radius.circular(15);
    return BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: isTopField ? borderRadius : Radius.zero,
        topRight: isTopField ? borderRadius : Radius.zero,
        bottomLeft: isBottomField ? borderRadius : Radius.zero,
        bottomRight: isBottomField ? borderRadius : Radius.zero,
      ),
      boxShadow: [
        if (isBottomField)
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
      ],
    );
  }

  InputDecoration _inputDecoration(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final borderStyle = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.black),
      borderRadius: BorderRadius.circular(2),
    );

    return InputDecoration(
      floatingLabelBehavior: maxLines > 1
          ? FloatingLabelBehavior.always
          : FloatingLabelBehavior.auto,
      floatingLabelStyle: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
      border: borderStyle,
      enabledBorder: borderStyle,
      focusedBorder: borderStyle,
      errorBorder: borderStyle.copyWith(
          borderSide: const BorderSide(color: Color.fromARGB(0, 15, 15, 15))),
      focusedErrorBorder: borderStyle.copyWith(
          borderSide: const BorderSide(color: Color.fromARGB(0, 16, 16, 16))),
      isDense: true,
      label: label != null ? Text(label!) : null,
      hintText: hint,
      errorText: errorMessage,
      focusColor: colors.primary,
    );
  }
}
