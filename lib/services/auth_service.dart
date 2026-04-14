import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_supportyou/utils/base.dart';
import 'package:mobile_supportyou/config/theme.dart';

class AuthService extends GetConnect {
  final box = GetStorage();

  // Header default
  Map<String, String> get _headers => {
        'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
        'device': 'mobile',
      };

  /// 1. Request OTP
  Future<Response> loginNoHp(Map<String, dynamic> body) async {
    try {
      EasyLoading.show(status: 'Mengirim OTP...');
      final response = await post('${Base.url}/v1/otp/request', body, headers: _headers);
      EasyLoading.dismiss();
      return response;
    } catch (e) {
      _handleError(e);
      return const Response(statusCode: 500, body: {"message": "Request OTP gagal"});
    }
  }

  /// 2. Verifikasi OTP
  Future<Response> otpVerifikasi(Map<String, dynamic> body) async {
    try {
      EasyLoading.show(status: 'Verifikasi OTP...');
      final response = await post('${Base.url}/v1/otp/verify', body, headers: _headers);
      EasyLoading.dismiss();

      if (response.statusCode == 200) {
        _saveSession(response.body);
      }
      return response;
    } catch (e) {
      _handleError(e);
      return const Response(statusCode: 500, body: {"message": "Verifikasi OTP gagal"});
    }
  }

  /// 3. Login Tradisional
  Future<Response> login({required String email, required String password}) async {
    try {
      var body = {"email": email, "password": password};
      EasyLoading.show(status: 'Loading...');
      final Response conn = await post('${Base.url}/v1/auth/user-login', body, headers: _headers);
      EasyLoading.dismiss();

      if (conn.statusCode == 200) {
        EasyLoading.showSuccess('Login Berhasil!');
        _saveSession(conn.body);
      } else {
        Get.snackbar("Login Gagal", conn.body['message'] ?? "Cek kembali akun anda");
      }
      return conn;
    } catch (e) {
      _handleError(e);
      return const Response(statusCode: 500, body: {"message": "Login gagal"});
    }
  }

  /// 4. Register Affiliator
  Future<Response> register(Map<String, dynamic> body) async {
    try {
      EasyLoading.show(status: 'Mendaftarkan...');
      final Response conn = await post(
        '${Base.url}/v1/affiliator/register',
        body,
        headers: _headers,
      );
      EasyLoading.dismiss();

      debugPrint("Register Status: ${conn.statusCode}");
      debugPrint("Register Body: ${conn.body}");

      if (conn.statusCode == 200 || conn.statusCode == 201) {
        EasyLoading.showSuccess('Pendaftaran Berhasil!');
      } else {
        // Ambil pesan error dari backend
        String msg = "Terjadi kesalahan";

        if (conn.body is List) {
          // API kirim array string error
          msg = (conn.body as List).join("\n");
        } else if (conn.body is Map) {
          msg = conn.body['message'] ?? "Data tidak valid";
        }
        Get.defaultDialog(
          title: "Gagal",
          titleStyle: TextStyle(
            color: Theme.of(Get.context!).colorScheme.error, // warna warning/error
            fontWeight: FontWeight.bold,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                msg,
                textAlign: TextAlign.center,
                style: Theme.of(Get.context!).textTheme.bodyMedium,
              ),
            ],
          ),
          textConfirm: "OKE",
          buttonColor: Theme.of(Get.context!).colorScheme.error, // warna warning/error
          confirmTextColor: Colors.white,
          onConfirm: () => Get.back(),
        );
      }
      return conn;
    } catch (e) {
      _handleError(e);
      return const Response(statusCode: 500, body: {"message": "Register gagal"});
    }
  }

  /// Helper simpan session
  void _saveSession(dynamic responseBody) {
    box.write('tokens', responseBody['tokens']);
    box.write('id', responseBody['data']['id']);
    box.write('no_hp', responseBody['data']['no_hp']);
    box.write('email', responseBody['data']['email']);
    box.write('nama_lengkap', responseBody['data']['nama_lengkap']);
  }

  void _handleError(dynamic e) {
    EasyLoading.dismiss();
    if (e is TimeoutException) {
      Get.snackbar('Koneksi', 'Waktu habis, coba lagi.');
    } else if (e is SocketException) {
      Get.snackbar('Koneksi', 'Tidak ada internet.');
    } else {
      Get.snackbar('Error', 'Terjadi kesalahan sistem.');
    }
  }
}