import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_supportyou/models/transaksi_model.dart';
import 'package:mobile_supportyou/services/profil_service.dart';
import 'package:mobile_supportyou/views/login_screen/screen.dart';

class ProfilController extends GetxController {
  final ProfilService _profilService = ProfilService();
  final GetStorage _storage = GetStorage();

  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  final userPhoto = ''.obs;

  final isLoadingTransactions = false.obs;
  final transactions = <Transaksi>[].obs;

  final totalPelatihanCount = 0.obs;
  final totalEbookCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    syncUserDataFromServer();
    loadTransactionHistory();
  }

  void loadUserData() {
    String name = _storage.read('nama_lengkap') ?? '';
    String email = _storage.read('email') ?? '';
    String phone = _storage.read('no_hp') ?? '';
    String photo = _storage.read('photo_url') ?? '';

    if (name.isEmpty) {
      final userData = _storage.read('user_data');
      if (userData != null && userData is Map) {
        name = userData['nama_lengkap'] ?? '';
        email = userData['email'] ?? email;
        phone = userData['no_hp'] ?? phone;
        photo = userData['photo'] ?? photo;
        if (name.isEmpty && userData['karyawan'] != null) {
          final karyawan = userData['karyawan'] as Map;
          name = karyawan['nama_lengkap'] ?? '';
          email = karyawan['email'] ?? email;
          phone = karyawan['no_hp'] ?? phone;
          photo = karyawan['photo'] ?? photo;
        }
      }
    }

    userName.value = name.isEmpty ? 'Pengguna' : name;
    userEmail.value = email.isEmpty ? 'Email tidak tersedia' : email;
    userPhone.value = phone.isEmpty ? 'Nomor tidak tersedia' : phone;
    userPhoto.value = photo;
  }

  Future<void> syncUserDataFromServer() async {
    debugPrint('📡 Syncing user data from server...');
    try {
      final userData = await _profilService.getUserDetail();
      if (userData != null) {
        final name = userData['nama_lengkap'] ?? '';
        final email = userData['email'] ?? '';
        final phone = userData['no_hp'] ?? '';
        final photo = userData['photo'] ?? '';

        debugPrint('📸 Photo from server: $photo');

        if (name.isNotEmpty) {
          _storage.write('nama_lengkap', name);
          _storage.write('email', email);
          _storage.write('no_hp', phone);
          if (photo.isNotEmpty) {
            _storage.write('photo_url', photo);
          }

          userName.value = name;
          userEmail.value = email;
          userPhone.value = phone;
          userPhoto.value = photo;

          final userDataStorage = _storage.read('user_data');
          if (userDataStorage != null && userDataStorage is Map) {
            userDataStorage['nama_lengkap'] = name;
            userDataStorage['email'] = email;
            userDataStorage['no_hp'] = phone;
            userDataStorage['photo'] = photo;
            if (userDataStorage['karyawan'] != null) {
              userDataStorage['karyawan']['nama_lengkap'] = name;
              userDataStorage['karyawan']['email'] = email;
              userDataStorage['karyawan']['no_hp'] = phone;
              userDataStorage['karyawan']['photo'] = photo;
            }
            _storage.write('user_data', userDataStorage);
          }
        }
      } else {
        debugPrint('⚠️ No user data from server');
      }
    } catch (e) {
      debugPrint('❌ Error syncing user data: $e');
    }
  }

  Future<void> loadTransactionHistory() async {
    try {
      isLoadingTransactions.value = true;
      final pendingTransactions = await _profilService.getTransactions(status: 'pending');
      transactions.assignAll(pendingTransactions);
      _calculateStats();
    } catch (e) {
      debugPrint('❌ Error loading transactions: $e');
      transactions.clear();
    } finally {
      isLoadingTransactions.value = false;
    }
  }

  void _calculateStats() {
    int pelatihanCount = 0;
    int ebookCount = 0;
    for (var trans in transactions) {
      if (trans.transactionType == 'pelatihan') pelatihanCount++;
      else if (trans.transactionType == 'ebook') ebookCount++;
    }
    totalPelatihanCount.value = pelatihanCount;
    totalEbookCount.value = ebookCount;
  }

  void logout() {
    _storage.erase();
    Get.offAll(() => const LoginScreen());
  }

  Future<void> refreshData() async {
    await syncUserDataFromServer();
    loadUserData();
    await loadTransactionHistory();
  }
}