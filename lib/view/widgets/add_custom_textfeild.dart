import 'package:flutter/material.dart';

class AddCustomTextfeild extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final int? maxLength;

  const AddCustomTextfeild({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
        counterText: '',
      ),
      validator: validator,
    );
  }
}