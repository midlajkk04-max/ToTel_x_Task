import 'package:flutter/material.dart';

class LoginCustomTextfeild extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final int? maxLength;
  final String? Function(String?)? validator;

  const LoginCustomTextfeild({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}