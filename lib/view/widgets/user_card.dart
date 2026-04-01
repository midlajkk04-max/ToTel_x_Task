import 'dart:io';
import 'package:flutter/material.dart';
import '../../../models/user_model.dart';

class UserCard extends StatelessWidget {
  final UserModel user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.grey.shade200,
          backgroundImage: user.imagePath != null
              ? FileImage(File(user.imagePath!))
              : null,
          child: user.imagePath == null
              ? Text(
                  user.name.isNotEmpty
                      ? user.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                )
              : null,
        ),
        title: Text(
          user.name,
          style: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          'Age: ${user.age}',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        trailing: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: user.age > 60
                ? Colors.orange.shade50
                : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            user.ageCategory,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: user.age > 60
                  ? Colors.orange.shade700
                  : Colors.blue.shade700,
            ),
          ),
        ),
      ),
    );
  }
}