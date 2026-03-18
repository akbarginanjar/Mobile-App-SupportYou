import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_supportyou/services/auth_service.dart';
import 'package:mobile_supportyou/views/main_screen/screen.dart';
import 'package:mobile_supportyou/views/login_nohp_screen/otp_screen.dart';

class AuthController extends GetxController {
  final phoneController = TextEditingController();
  final otp = ''.obs;
  final countdown = 60.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startCountdown();
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
    super.onClose();
  }

  /// Request OTP
  Future<void> requestOtp() async {
    EasyLoading.show(status: 'Mengirim OTP...');

    try {
      final body = {"phone": phoneController.text, "action": "login"};
      final response = await AuthService().loginNoHp(body);

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        startCountdown();
        Get.to(() => OtpInputScreen(), arguments: phoneController.text);
      } else {
        EasyLoading.showError(response.body['message'] ?? 'Request OTP gagal');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Gagal menghubungi server');
      debugPrint(e.toString());
    }
  }

  /// Verifikasi OTP
  Future<void> otpVerifikasi() async {
    EasyLoading.show(status: 'Verifikasi OTP...');

    try {
      final body = {
        "phone": phoneController.text,
        "otp": otp.value,
        "action": "login",
      };
      final response = await AuthService().otpVerifikasi(body);

      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Login Berhasil!');
        final box = GetStorage();
        box.write('tokens', response.body['tokens']);
        box.write('id', response.body['data']['id']);
        box.write('no_hp', response.body['data']['no_hp']);
        box.write('email', response.body['data']['email']);
        box.write('nama_lengkap', response.body['data']['nama_lengkap']);

        Get.offAll(() => const MainScreen());
      } else {
        EasyLoading.showError(response.body['message'] ?? 'OTP salah');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Gagal menghubungi server');
      debugPrint(e.toString());
    }
  }


  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      EasyLoading.showError('Email dan Password wajib diisi');
      return;
    }

    isLoading.value = true;
    EasyLoading.show(status: 'Login...');

    try {
      final response = await AuthService().login(
        email: emailController.text,
        password: passwordController.text,
      );

      EasyLoading.dismiss();
      isLoading.value = false;

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Login Berhasil!');
        final box = GetStorage();
        box.write('tokens', response.body['tokens']);
        box.write('id', response.body['data']['id']);
        box.write('email', response.body['data']['email']);
        box.write('no_hp', response.body['data']['no_hp']);
        box.write('nama_lengkap', response.body['data']['nama_lengkap']);

        Get.offAll(() => const MainScreen());
      } else {
        EasyLoading.showError(response.body['message'] ?? 'Login gagal');
      }
    } catch (e) {
      EasyLoading.dismiss();
      isLoading.value = false;
      EasyLoading.showError('Gagal menghubungi server');
      debugPrint(e.toString());
    }
  }
}