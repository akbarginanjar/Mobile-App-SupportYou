// lib/services/auth_service.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_supportyou/utils/base.dart';
import 'package:mobile_supportyou/config/theme.dart';

class AuthService extends GetConnect {
  final GetStorage box = GetStorage();

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

      print('═══════════════════════════════════════════════════════════');
      print('🔐 LOGIN RESPONSE');
      print('Status Code: ${conn.statusCode}');
      print('Response Body: ${conn.body}');
      print('═══════════════════════════════════════════════════════════');

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
        String msg = "Terjadi kesalahan";
        if (conn.body is List) {
          msg = (conn.body as List).join("\n");
        } else if (conn.body is Map) {
          msg = conn.body['message'] ?? "Data tidak valid";
        }
        Get.defaultDialog(
          title: "Gagal",
          titleStyle: TextStyle(
            color: Theme.of(Get.context!).colorScheme.error,
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
          buttonColor: Theme.of(Get.context!).colorScheme.error,
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

  Future<Response> requestForgotPassword(String email) async {
    try {
      EasyLoading.show(status: 'Mengirim link reset password...');
      final body = {"email": email};
      final response = await post('${Base.url}/v1/auth/request-forgot-password', body, headers: _headers);
      EasyLoading.dismiss();
      
      print('═══════════════════════════════════════════════════════════');
      print('🔐 FORGOT PASSWORD RESPONSE');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      print('═══════════════════════════════════════════════════════════');
      
      return response;
    } catch (e) {
      EasyLoading.dismiss();
      _handleError(e);
      return const Response(statusCode: 500, body: {"message": "Gagal mengirim link reset password"});
    }
  }

  /// Helper simpan session - DIPERBAIKI
  void _saveSession(dynamic responseBody) {
    print('═══════════════════════════════════════════════════════════');
    print('💾 SAVING SESSION DATA');
    print('Response body structure: ${responseBody.keys}');
    
    // Simpan tokens
    if (responseBody['tokens'] != null) {
      box.write('tokens', responseBody['tokens']);
      print('✅ Tokens saved');
    }
    
    // Simpan data user
    if (responseBody['data'] != null && responseBody['data'] is Map) {
      final userData = responseBody['data'];
      
      // 🔥 AMBIL NAMA LENGKAP (prioritas dari karyawan)
      String namaLengkap = userData['nama_lengkap'] ?? '';
      
      // Jika nama_lengkap kosong, ambil dari karyawan
      if (namaLengkap.isEmpty && userData['karyawan'] != null) {
        final karyawan = userData['karyawan'];
        namaLengkap = karyawan['nama_lengkap'] ?? '';
        print('📌 Nama lengkap dari karyawan: $namaLengkap');
      }
      
      // Simpan basic user info
      box.write('id', userData['id']);
      box.write('no_hp', userData['no_hp'] ?? '');
      box.write('email', userData['email'] ?? '');
      box.write('nama_lengkap', namaLengkap); // 🔥 PASTIKAN INI TERISI
      box.write('username', userData['username'] ?? '');
      
      // 🔥 PENTING: Simpan member_id
      int memberId = 0;
      
      // 1. Cek langsung di userData
      if (userData['member_id'] != null) {
        memberId = userData['member_id'];
        print('📌 Member ID found in userData: $memberId');
      }
      // 2. Cek di dalam object karyawan
      else if (userData['karyawan'] != null && userData['karyawan']['id'] != null) {
        memberId = userData['karyawan']['id'];
        print('📌 Member ID found in karyawan: $memberId');
      }
      // 3. Fallback ke user id
      else {
        memberId = userData['id'];
        print('⚠️ No member_id found, using user ID as fallback: $memberId');
      }
      
      box.write('member_id', memberId);
      print('✅ Member ID saved to storage: $memberId');
      
      // Simpan full user data
      box.write('user_data', userData);
    }
    
    // Debug: Tampilkan semua keys yang tersimpan
    print('📋 All stored keys: ${box.getKeys()}');
    print('📋 nama_lengkap value: ${box.read('nama_lengkap')}');
    print('📋 email value: ${box.read('email')}');
    print('📋 no_hp value: ${box.read('no_hp')}');
    print('📋 member_id value: ${box.read('member_id')}');
    print('═══════════════════════════════════════════════════════════');
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
  
  /// Method untuk mendapatkan member_id yang tersimpan
  int getCurrentMemberId() {
    return box.read('member_id') ?? 0;
  }
  
  /// Method untuk mendapatkan user ID
  int getCurrentUserId() {
    return box.read('id') ?? 0;
  }
}