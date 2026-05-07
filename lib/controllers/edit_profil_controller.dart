// lib/controllers/edit_profil_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_supportyou/services/profil_service.dart';
import 'package:mobile_supportyou/views/profil_screen/screen.dart';

class EditProfilController extends GetxController {
  final ProfilService _profilService = ProfilService();
  final GetStorage _storage = GetStorage();
  
  // TextEditingControllers
  final namaLengkapController = TextEditingController();
  final emailController = TextEditingController();
  final noHpController = TextEditingController();
  
  // Password Controllers
  final passwordLamaController = TextEditingController();
  final passwordBaruController = TextEditingController();
  final konfirmasiPasswordBaruController = TextEditingController();
  
  // Observables
  final isLoading = false.obs;
  final isLoadingPassword = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }
  
  void loadUserData() {
    namaLengkapController.text = _storage.read('nama_lengkap') ?? '';
    emailController.text = _storage.read('email') ?? '';
    noHpController.text = _storage.read('no_hp') ?? '';
  }
  
  Future<void> updateProfile() async {
    // Validasi
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
      // 🔥 PANGGIL API UPDATE PROFIL
      final result = await _profilService.updateProfile(
        namaLengkap: namaLengkapController.text,
        email: emailController.text,
        noHp: noHpController.text,
      );
      
      if (result != null && (result['status'] == true || result['message'] != null)) {
        // Update local storage dengan data baru
        _storage.write('nama_lengkap', namaLengkapController.text);
        _storage.write('email', emailController.text);
        _storage.write('no_hp', noHpController.text);
        
        // Update juga di user_data
        final userData = _storage.read('user_data');
        if (userData != null && userData is Map) {
          userData['nama_lengkap'] = namaLengkapController.text;
          userData['email'] = emailController.text;
          userData['no_hp'] = noHpController.text;
          
          // Update juga di dalam karyawan jika ada
          if (userData['karyawan'] != null && userData['karyawan'] is Map) {
            userData['karyawan']['nama_lengkap'] = namaLengkapController.text;
            userData['karyawan']['email'] = emailController.text;
            userData['karyawan']['no_hp'] = noHpController.text;
          }
          _storage.write('user_data', userData);
        }
        
        EasyLoading.showSuccess('Profil berhasil diperbarui');
        
        // Kembali ke halaman profil dan refresh data
        Get.back(result: true);
      } else {
        EasyLoading.showError(result?['message'] ?? 'Gagal memperbarui profil');
      }
      
    } catch (e) {
      EasyLoading.showError('Gagal memperbarui profil: ${e.toString()}');
      debugPrint('Error update profile: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> updatePassword() async {
    // Validasi
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
        
        // Clear form
        passwordLamaController.clear();
        passwordBaruController.clear();
        konfirmasiPasswordBaruController.clear();
        
        Get.back(result: true);
      } else {
        EasyLoading.showError(result?['message'] ?? 'Gagal mengubah password');
      }
      
    } catch (e) {
      EasyLoading.showError('Gagal mengubah password: ${e.toString()}');
      debugPrint('Error update password: $e');
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