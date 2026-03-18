import 'dart:io';
import 'package:get/get.dart';
import 'dart:async';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_supportyou/utils/base.dart';

class AuthService extends GetConnect {
  final box = GetStorage();
  
    /// Request OTP dengan nomor HP
  Future<Response> loginNoHp(Map<String, dynamic> body) async {
    final header = {
      'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
      'device': 'mobile',
    };

    try {
      EasyLoading.show(status: 'Mengirim OTP...');
      final response = await post(
        '${Base.url}/v1/otp/request',
        body,
        headers: header,
      );
      EasyLoading.dismiss();

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      Get.snackbar('Masalah Koneksi', 'Jaringan lemah, silahkan perbaiki jaringan anda!');
    } on SocketException {
      EasyLoading.dismiss();
      Get.snackbar('Masalah Koneksi', 'Data dalam keadaan mati, silahkan nyalakan data anda!');
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Masalah Koneksi', e.message);
    } catch (e, stackTrace) {
      EasyLoading.dismiss();
      Get.snackbar(e.toString(), stackTrace.toString());
    }

    return Response(statusCode: 400, body: {"message": "Request OTP gagal"});
  }

  /// Verifikasi OTP
  Future<Response> otpVerifikasi(Map<String, dynamic> body) async {
    final header = {
      'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
      'device': 'mobile',
    };

    try {
      EasyLoading.show(status: 'Verifikasi OTP...');
      final response = await post(
        '${Base.url}/v1/otp/verify',
        body,
        headers: header,
      );
      EasyLoading.dismiss();

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Simpan token dan data user
        box.write('tokens', response.body['tokens']);
        box.write('id', response.body['data']['id']);
        box.write('no_hp', response.body['data']['no_hp']);
        box.write('email', response.body['data']['email']);
        box.write('nama_lengkap', response.body['data']['nama_lengkap']);
      }

      return response;
    } on TimeoutException {
      EasyLoading.dismiss();
      Get.snackbar('Masalah Koneksi', 'Jaringan lemah, silahkan perbaiki jaringan anda!');
    } on SocketException {
      EasyLoading.dismiss();
      Get.snackbar('Masalah Koneksi', 'Data dalam keadaan mati, silahkan nyalakan data anda!');
    } on HttpException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Masalah Koneksi', e.message);
    } catch (e, stackTrace) {
      EasyLoading.dismiss();
      Get.snackbar(e.toString(), stackTrace.toString());
    }

    return Response(statusCode: 400, body: {"message": "Verifikasi OTP gagal"});
  }

  Future<Response> login({required String email, required String password}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        var body = {
          "email": email,
          "password": password,
        };

        EasyLoading.show(status: 'Loading...');

        final Response conn = await post(
          '${Base.url}/v1/auth/user-login',
          body,
          headers: {
            'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
            'device': 'mobile',
          },
        );

        print("Status Code: ${conn.statusCode}");
        print("Response Body: ${conn.body}");

        if (conn.statusCode == 200) {
          EasyLoading.showSuccess('Login Berhasil!');
          box.write('tokens', conn.body['tokens']);
          box.write('id', conn.body['data']['id']);
          box.write('email', conn.body['data']['email']);
          box.write('no_hp', conn.body['data']['no_hp']);
          box.write('nama_lengkap', conn.body['data']['nama_lengkap']);
        } else if (conn.statusCode == 400) {
          EasyLoading.showError('Bad Request: ${conn.body}');
        } else {
          EasyLoading.dismiss();
          Get.snackbar("Login Gagal", "${conn.body}");
        }
      }
    } on TimeoutException {
      Get.snackbar('Masalah Koneksi', 'Jaringan lemah, silahkan perbaiki jaringan anda!');
    } on SocketException {
      Get.snackbar('Masalah Koneksi', 'Data dalam keadaan mati, silahkan nyalakan data anda!');
    } on HttpException catch (e) {
      Get.snackbar('Masalah Koneksi', e.message);
    } on Error catch (e) {
      Get.snackbar(e.toString(), e.stackTrace.toString());
    }

    return Response(statusCode: 400, body: {"message": "Login gagal"});
  }
}