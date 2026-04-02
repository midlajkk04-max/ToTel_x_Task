import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:totel_x_task/view/widgets/otp_custom_button.dart';
import 'package:totel_x_task/view/widgets/otp_textfeild.dart';
import '../../controllers/auth_controller.dart';
import '../home/home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _secondsLeft = 59;
  Timer? _timer;

  String get _otp => _controllers.map((c) => c.text).join();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = 59;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/512/3064/3064155.png',
                  height: 140,
                  errorBuilder: (_, __, ___) => const Icon(Icons.lock_outline, size: 80, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 24),
              const Text('OTP Verification', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'Enter the verification code we just sent to your\nnumber +91 ******${widget.phone.substring(widget.phone.length - 2)}.',
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return OtpTextField(
                    controller: _controllers[i],
                    focusNode: _focusNodes[i],
                    nextFocus: i < 5 ? _focusNodes[i + 1] : null,
                    prevFocus: i > 0 ? _focusNodes[i - 1] : null,
                  );
                }),
              ),
              const SizedBox(height: 12),
              Center(child: Text('$_secondsLeft Sec', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500))),
              const SizedBox(height: 8),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Didn't get OTP? ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(
                      onTap: _secondsLeft == 0
                          ? () {
                              context.read<AuthController>().sendOtp(widget.phone);
                              _startTimer();
                            }
                          : null,
                      child: Text(
                        'Resend',
                        style: TextStyle(color: _secondsLeft == 0 ? Colors.blue : Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Consumer<AuthController>(
                builder: (context, ctrl, _) {
                  if (ctrl.error != null) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Center(child: Text(ctrl.error!, style: const TextStyle(color: Colors.red))),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Consumer<AuthController>(
                builder: (context, ctrl, _) {
                  return OtpCustomButton(
                    text: 'Verify',
                    isLoading: ctrl.state == AuthState.loading,
                    onPressed: () async {
                      if (_otp.length != 6) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter 6-digit OTP')));
                        return;
                      }
                      await ctrl.verifyOtp(widget.phone, _otp);
                      if (ctrl.state == AuthState.verified && context.mounted) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}