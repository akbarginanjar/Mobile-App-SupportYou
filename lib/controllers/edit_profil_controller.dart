// lib/controllers/edit_profil_controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_supportyou/services/profil_service.dart';
import 'package:mobile_supportyou/controllers/profil_controller.dart';

class EditProfilController extends GetxController {
  final ProfilService _profilService = ProfilService();
  final GetStorage _storage = GetStorage();
  final ImagePicker _imagePicker = ImagePicker();

  final namaLengkapController = TextEditingController();
  final emailController = TextEditingController();
  final noHpController = TextEditingController();

  final passwordLamaController = TextEditingController();
  final passwordBaruController = TextEditingController();
  final konfirmasiPasswordBaruController = TextEditingController();

  final profileImage = Rx<File?>(null);
  final currentPhotoUrl = Rx<String?>(null);

  final isLoading = false.obs;
  final isLoadingPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadUserPhoto();
  }

  void loadUserData() {
    namaLengkapController.text = _storage.read('nama_lengkap') ?? '';
    emailController.text = _storage.read('email') ?? '';
    noHpController.text = _storage.read('no_hp') ?? '';
  }

  void loadUserPhoto() {
    final photo = _storage.read('photo_url');
    if (photo != null && photo is String && photo.isNotEmpty) {
      currentPhotoUrl.value = photo;
    } else {
      final userData = _storage.read('user_data');
      if (userData != null && userData is Map) {
        final photoFromData = userData['photo'] ?? userData['karyawan']?['photo'];
        if (photoFromData != null && photoFromData is String && photoFromData.isNotEmpty) {
          currentPhotoUrl.value = photoFromData;
          _storage.write('photo_url', photoFromData);
        }
      }
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }
  }

  Future<void> updateProfile() async {
    if (namaLengkapController.text.isEmpty) {
      EasyLoading.showError('Nama lengkap tidak boleh kosong');
      return;
    }
    if (emailController.text.isEmpty) {
      EasyLoading.showError('Email tidak boleh kosong');
      return;
    }
    if (!GetUtils.isEmail(emailController.text)) {
      EasyLoading.showError('Email tidak valid');
      return;
    }
    if (noHpController.text.isEmpty) {
      EasyLoading.showError('Nomor HP tidak boleh kosong');
      return;
    }

    isLoading.value = true;
    try {
      if (profileImage.value != null) {
        final uploadResult = await _profilService.uploadPhoto(profileImage.value!);
        if (uploadResult == null) {
          EasyLoading.showError('Gagal mengupload foto');
          return;
        }
        debugPrint('✅ Upload photo success: $uploadResult');
        await Future.delayed(const Duration(milliseconds: 500));
        final profilController = Get.find<ProfilController>();
        await profilController.syncUserDataFromServer();
        currentPhotoUrl.value = profilController.userPhoto.value;
        debugPrint('🖼️ Updated photo URL: ${currentPhotoUrl.value}');
      }

      final result = await _profilService.updateProfile(
        namaLengkap: namaLengkapController.text,
        email: emailController.text,
        noHp: noHpController.text,
      );

      if (result != null && (result['status'] == true || result['message'] != null)) {
        _storage.write('nama_lengkap', namaLengkapController.text);
        _storage.write('email', emailController.text);
        _storage.write('no_hp', noHpController.text);

        final userData = _storage.read('user_data');
        if (userData != null && userData is Map) {
          userData['nama_lengkap'] = namaLengkapController.text;
          userData['email'] = emailController.text;
          userData['no_hp'] = noHpController.text;
          if (userData['karyawan'] != null && userData['karyawan'] is Map) {
            userData['karyawan']['nama_lengkap'] = namaLengkapController.text;
            userData['karyawan']['email'] = emailController.text;
            userData['karyawan']['no_hp'] = noHpController.text;
          }
          _storage.write('user_data', userData);
        }

        EasyLoading.showSuccess('Profil berhasil diperbarui');
        Get.back(result: true);
      } else {
        EasyLoading.showError(result?['message'] ?? 'Gagal memperbarui profil');
      }
    } catch (e) {
      EasyLoading.showError('Gagal memperbarui profil: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePassword() async {
    if (passwordLamaController.text.isEmpty) {
      EasyLoading.showError('Password lama tidak boleh kosong');
      return;
    }
    if (passwordBaruController.text.isEmpty) {
      EasyLoading.showError('Password baru tidak boleh kosong');
      return;
    }
    if (passwordBaruController.text.length < 6) {
      EasyLoading.showError('Password baru minimal 6 karakter');
      return;
    }
    if (konfirmasiPasswordBaruController.text != passwordBaruController.text) {
      EasyLoading.showError('Konfirmasi password baru tidak cocok');
      return;
    }

    isLoadingPassword.value = true;
    try {
      final result = await _profilService.changePassword(
        currentPassword: passwordLamaController.text,
        newPassword: passwordBaruController.text,
      );
      if (result != null && (result['status'] == true || result['message'] != null)) {
        EasyLoading.showSuccess('Password berhasil diubah');
        passwordLamaController.clear();
        passwordBaruController.clear();
        konfirmasiPasswordBaruController.clear();
        Get.back(result: true);
      } else {
        EasyLoading.showError(result?['message'] ?? 'Gagal mengubah password');
      }
    } catch (e) {
      EasyLoading.showError('Gagal mengubah password: ${e.toString()}');
    } finally {
      isLoadingPassword.value = false;
    }
  }

  @override
  void onClose() {
    namaLengkapController.dispose();
    emailController.dispose();
    noHpController.dispose();
    passwordLamaController.dispose();
    passwordBaruController.dispose();
    konfirmasiPasswordBaruController.dispose();
    super.onClose();
  }
}