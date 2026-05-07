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
    if (responseBody['tokens'] != null) {
      box.write('tokens', responseBody['tokens']);
    }
    if (responseBody['data'] != null && responseBody['data'] is Map) {
      final userData = responseBody['data'];
      box.write('id', userData['id']);
      box.write('no_hp', userData['no_hp'] ?? '');
      box.write('email', userData['email'] ?? '');
      box.write('nama_lengkap', userData['nama_lengkap'] ?? '');
      box.write('member_id', userData['member_id'] ?? userData['id']);
      box.write('user_data', userData);
    } 
    else if (responseBody['user'] != null && responseBody['user'] is Map) {
      final userData = responseBody['user'];
      box.write('id', userData['id']);
      box.write('no_hp', userData['no_hp'] ?? userData['phone'] ?? '');
      box.write('email', userData['email'] ?? '');
      box.write('nama_lengkap', userData['nama_lengkap'] ?? userData['name'] ?? '');
      box.write('member_id', userData['member_id'] ?? userData['id']);
      box.write('user_data', userData);
    }
    else {
      if (responseBody['id'] != null) {
        box.write('id', responseBody['id']);
        box.write('no_hp', responseBody['no_hp'] ?? '');
        box.write('email', responseBody['email'] ?? '');
        box.write('nama_lengkap', responseBody['nama_lengkap'] ?? '');
        box.write('member_id', responseBody['member_id'] ?? responseBody['id']);
      }
    }
    print('═══════════════════════════════════════════════════════════');
    print('💾 SAVED USER DATA:');
    print('nama_lengkap: ${box.read('nama_lengkap')}');
    print('email: ${box.read('email')}');
    print('no_hp: ${box.read('no_hp')}');
    print('member_id: ${box.read('member_id')}');
    print('═══════════════════════════════════════════════════════════');
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
      } else {
        EasyLoading.showError(response.body['message'] ?? 'Login gagal');
      }
    } catch (e) {
      isLoading.value = false;
      EasyLoading.showError('Gagal menghubungi server');
      debugPrint(e.toString());
    }
  }

    /// --- REGISTER ---
  Future<void> register() async {
    isLoading.value = true;

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
        // 🔥 SIMPAN DATA USER KE STORAGE
        box.write('nama_lengkap', namaLengkapController.text);
        box.write('email', emailController.text);
        box.write('no_hp', phoneController.text);
        box.write('username', usernameController.text);
      
        EasyLoading.showSuccess('Registrasi Berhasil! Silakan login');
        Get.back(); // Kembali ke login screen
      } else {
        final body = response.body;
        if (body != null) {
          if (body['errors'] != null) {
            final errors = body['errors'];
            if (errors['email'] != null && errors['email'] is List) {
              EasyLoading.showError(errors['email'][0]);
              return;
            }
            if (errors['no_hp'] != null && errors['no_hp'] is List) {
              EasyLoading.showError(errors['no_hp'][0]);
              return;
            }
          }
          EasyLoading.showError(body['message'] ?? 'Registrasi gagal');
        } else {
          EasyLoading.showError('Registrasi gagal');
        }
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint(e.toString());
    }
  }
}