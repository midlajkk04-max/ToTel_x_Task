import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddImagePicker extends StatefulWidget {
  final double radius;
  final ValueChanged<File?> onImagePicked;

  const AddImagePicker({super.key, this.radius = 50, required this.onImagePicked});

  @override
  State<AddImagePicker> createState() => _ImagePickerCircleState();
}

class _ImagePickerCircleState extends State<AddImagePicker> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
      widget.onImagePicked(_pickedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          CircleAvatar(
            radius: widget.radius,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: _pickedImage != null ? FileImage(_pickedImage!) : null,
            child: _pickedImage == null
                ? const Icon(Icons.person, size: 50, color: Colors.grey)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}