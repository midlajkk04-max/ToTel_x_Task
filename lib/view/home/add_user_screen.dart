import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totel_x_task/view/widgets/add_custom_button.dart';
import 'package:totel_x_task/view/widgets/add_custom_textfeild.dart';
import 'package:totel_x_task/view/widgets/add_image_picker.dart';
import '../../controllers/user_controller.dart';


class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  File? _pickedImage;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final success = await context.read<UserController>().addUser(
          name: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          age: int.parse(_ageController.text.trim()),
          image: _pickedImage,
        );

    setState(() => _isSubmitting = false);
    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add user. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Add A New User'), backgroundColor: Colors.white, elevation: 0.5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 8),
              AddImagePicker(radius: 50, onImagePicked: (file) => _pickedImage = file),
              const SizedBox(height: 24),
              AddCustomTextfeild(controller: _nameController, label: 'Name', validator: (val) => val == null || val.isEmpty ? 'Please enter name' : null),
              const SizedBox(height: 16),
              AddCustomTextfeild(
                controller: _phoneController,
                label: 'Phone Number',
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (val) => val == null || val.length != 10 ? 'Please enter a valid 10-digit number' : null,
              ),
              const SizedBox(height: 16),
              AddCustomTextfeild(
                controller: _ageController,
                label: 'Age',
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter age';
                  final age = int.tryParse(val);
                  if (age == null || age <= 0 || age > 120) return 'Please enter a valid age';
                  return null;
                },
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(child: AddCustomButton(text: 'Cancel', isOutlined: true, onPressed: () => Navigator.pop(context))),
                  const SizedBox(width: 16),
                  Expanded(child: AddCustomButton(text: 'Save', isLoading: _isSubmitting, onPressed: _submit)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}