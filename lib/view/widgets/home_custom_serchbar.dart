import 'package:flutter/material.dart';

class HomeCustomSerchbar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const HomeCustomSerchbar({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search by name',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}