import 'package:flutter/material.dart';
import '../services/auth_service.dart';

enum AuthState { idle, loading, otpSent, verified, error }

class AuthController extends ChangeNotifier {
  final AuthService _service = AuthService();

  AuthState _state = AuthState.idle;
  AuthState get state => _state;

  String? _error;
  String? get error => _error;

  Future<void> sendOtp(String phone) async {
    _state = AuthState.loading;
    _error = null;
    notifyListeners();

    final success = await _service.sendOtp(phone);
    _state = success ? AuthState.otpSent : AuthState.error;

    if (!success) _error = 'Failed to send OTP. Please try again.';
    notifyListeners();
  }

  Future<void> verifyOtp(String phone, String otp) async {
    _state = AuthState.loading;
    _error = null;
    notifyListeners();

    final success = await _service.verifyOtp(phone, otp);
    _state = success ? AuthState.verified : AuthState.error;

    if (!success) _error = 'The OTP entered is incorrect. Please try again.';
    notifyListeners();
  }

  void reset() {
    _state = AuthState.idle;
    _error = null;
    notifyListeners();
  }
}
