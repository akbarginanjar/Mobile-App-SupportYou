import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_supportyou/services/auth_service.dart';
import 'package:mobile_supportyou/views/main_screen/screen.dart';
import 'package:mobile_supportyou/views/login_nohp_screen/otp_screen.dart';

class AuthController extends GetxController {
  final box = GetStorage();
  final AuthService _authService = AuthService();

  // Controllers untuk Login & OTP
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Controllers Tambahan untuk Register (Sesuai Payload)
  final namaLengkapController = TextEditingController();
  final usernameController = TextEditingController();
  final konfirmasiPasswordController = TextEditingController();

  // Observables
  final otp = ''.obs;
  final countdown = 60.obs;
  final isLoading = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
  }

  void startCountdown() {
    _timer?.cancel();
    countdown.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value <= 0) {
        timer.cancel();
      } else {
        countdown.value--;
      }
    });
  }

  void updateOtp(String value) {
    otp.value = value;
  }

  @override
  void onClose() {
    _timer?.cancel();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    namaLengkapController.dispose();
    usernameController.dispose();
    konfirmasiPasswordController.dispose();
    super.onClose();
  }

  /// --- SESSION HELPER ---
  void _saveSession(dynamic responseBody) {
    box.write('tokens', responseBody['tokens']);
    box.write('id', responseBody['data']['id']);
    box.write('no_hp', responseBody['data']['no_hp']);
    box.write('email', responseBody['data']['email']);
    box.write('nama_lengkap', responseBody['data']['nama_lengkap']);
  }

  /// --- REQUEST OTP ---
  Future<void> requestOtp() async {
    try {
      final body = {"phone": phoneController.text, "action": "login"};
      final response = await _authService.loginNoHp(body);

      if (response.statusCode == 200) {
        startCountdown();
        Get.to(() => OtpInputScreen(), arguments: phoneController.text);
      } else {
        EasyLoading.showError(response.body['message'] ?? 'Request OTP gagal');
      }
    } catch (e) {
      EasyLoading.showError('Gagal menghubungi server');
      debugPrint(e.toString());
    }
  }

  /// --- VERIFIKASI OTP ---
  Future<void> otpVerifikasi() async {
    try {
      final body = {
        "phone": phoneController.text,
        "otp": otp.value,
        "action": "login",
      };
      final response = await _authService.otpVerifikasi(body);

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Login Berhasil!');
        _saveSession(response.body);
        Get.offAll(() => const MainScreen());
      } else {
        EasyLoading.showError(response.body['message'] ?? 'OTP salah');
      }
    } catch (e) {
      EasyLoading.showError('Gagal menghubungi server');
      debugPrint(e.toString());
    }
  }

  /// --- LOGIN TRADISIONAL ---
  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      EasyLoading.showError('Email dan Password wajib diisi');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Login Berhasil!');
        _saveSession(response.body);
        Get.offAll(() => const MainScreen());
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.showError('Gagal menghubungi server');
      debugPrint(e.toString());
    }
  }

  /// --- REGISTER (NEW SESUAI PAYLOAD) ---
  Future<void> register() async {
    isLoading.value = true;
    
    // Susun payload sesuai permintaan backend kamu
    final Map<String, dynamic> payload = {
      "nama_lengkap": namaLengkapController.text,
      "email": emailController.text,
      "username": usernameController.text,
      "no_hp": phoneController.text,
      "provinsi_id": "",
      "kab_kota_id": "",
      "kecamatan_id": "",
      "kelurahan_id": "",
      "alamat": "",
      "password": passwordController.text,
      "konfirmasi_password": konfirmasiPasswordController.text,
      "request_otp": 1,
    };

    try {
      final response = await _authService.register(payload);
      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        EasyLoading.showSuccess('Registrasi Berhasil!');
        // Jika request_otp: 1 mengirim OTP, arahkan ke OtpScreen. 
        // Jika tidak, balik ke Login.
        Get.back(); 
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.showError('Gagal menghubungi server');
      debugPrint(e.toString());
    }
  }
}