import 'package:flutter/material.dart';

class AddCustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final bool isOutlined;

  const AddCustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(text, style: const TextStyle(color: Colors.black87)),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: isLoading
          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
          : Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}