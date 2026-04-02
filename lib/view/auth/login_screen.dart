import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totel_x_task/view/widgets/login_custom_textfeild.dart';
import 'package:totel_x_task/view/widgets/login_custtom_button.dart';
import '../../controllers/auth_controller.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/6195/6195702.png',
                    height: 160,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.phone_android,
                      size: 100,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Enter Phone Number',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
                const SizedBox(height: 16),
                LoginCustomTextfeild(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: 'Enter 10-digit number',
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (val) {
                    if (val == null || val.length != 10) {
                      return 'Please enter valid 10-digit number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                const Text(
                  'By continuing, you agree to Totalx Terms & Privacy Policy.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                Consumer<AuthController>(
                  builder: (context, ctrl, _) {
                    if (ctrl.error != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(ctrl.error!, style: const TextStyle(color: Colors.red)),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Consumer<AuthController>(
                  builder: (context, ctrl, _) {
                    return LoginCusttomButton(
                      text: 'Get OTP',
                      isLoading: ctrl.state == AuthState.loading,
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) return;
                        await ctrl.sendOtp(_phoneController.text.trim());
                        if (ctrl.state == AuthState.otpSent && context.mounted) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OtpScreen(phone: _phoneController.text.trim()),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}