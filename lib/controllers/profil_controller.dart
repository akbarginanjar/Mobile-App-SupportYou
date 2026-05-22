// lib/controllers/profil_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_supportyou/models/transaksi_model.dart';
import 'package:mobile_supportyou/services/profil_service.dart';
import 'package:mobile_supportyou/views/login_screen/screen.dart';

class ProfilController extends GetxController {
  final ProfilService _profilService = ProfilService();
  final GetStorage _storage = GetStorage();
  
  // User Data
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhone = ''.obs;
  
  // Transactions
  final isLoadingTransactions = false.obs;
  final transactions = <Transaksi>[].obs;
  
  // Stats
  final totalPelatihanCount = 0.obs;
  final totalEbookCount = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadUserData();           // Load dari storage dulu (cepat)
    syncUserDataFromServer(); // Sync data terbaru dari server
    loadTransactionHistory();
  }
  
  void loadUserData() {
    // Debug: Tampilkan semua isi storage
    debugPrint('📦 ALL STORAGE KEYS: ${_storage.getKeys()}');
    
    // Ambil data dari storage
    String name = _storage.read('nama_lengkap') ?? '';
    String email = _storage.read('email') ?? '';
    String phone = _storage.read('no_hp') ?? '';
    
    debugPrint('📦 Raw from storage - name: "$name", email: "$email", phone: "$phone"');
    
    // Jika nama_lengkap kosong, coba dari user_data
    if (name.isEmpty) {
      final userData = _storage.read('user_data');
      if (userData != null && userData is Map) {
        name = userData['nama_lengkap'] ?? '';
        email = userData['email'] ?? email;
        phone = userData['no_hp'] ?? phone;
        debugPrint('📦 Data from user_data: nama_lengkap=$name');
        
        // Jika masih kosong, coba dari karyawan
        if (name.isEmpty && userData['karyawan'] != null) {
          final karyawan = userData['karyawan'] as Map;
          name = karyawan['nama_lengkap'] ?? '';
          email = karyawan['email'] ?? email;
          phone = karyawan['no_hp'] ?? phone;
          debugPrint('📦 Data from karyawan: nama_lengkap=$name');
        }
      }
    }
    
    // Set nilai
    userName.value = name.isEmpty ? 'Pengguna' : name;
    userEmail.value = email.isEmpty ? 'Email tidak tersedia' : email;
    userPhone.value = phone.isEmpty ? 'Nomor tidak tersedia' : phone;
    
    debugPrint('📱 Final User Data from Storage:');
    debugPrint('Name: ${userName.value}');
    debugPrint('Email: ${userEmail.value}');
    debugPrint('Phone: ${userPhone.value}');
    debugPrint('Member ID: ${_storage.read('member_id')}');
  }
  
  /// 🔥 SYNC DATA DARI SERVER (ambil data terbaru dari API)
  Future<void> syncUserDataFromServer() async {
    try {
      final userData = await _profilService.getUserDetail();
      if (userData != null) {
        final name = userData['nama_lengkap'] ?? '';
        final email = userData['email'] ?? '';
        final phone = userData['no_hp'] ?? '';
        
        if (name.isNotEmpty) {
          // Update storage dengan data terbaru dari server
          _storage.write('nama_lengkap', name);
          _storage.write('email', email);
          _storage.write('no_hp', phone);
          
          // Update observable
          userName.value = name;
          userEmail.value = email;
          userPhone.value = phone;
          
          // Update juga di user_data
          final userDataStorage = _storage.read('user_data');
          if (userDataStorage != null && userDataStorage is Map) {
            userDataStorage['nama_lengkap'] = name;
            userDataStorage['email'] = email;
            userDataStorage['no_hp'] = phone;
            if (userDataStorage['karyawan'] != null && userDataStorage['karyawan'] is Map) {
              userDataStorage['karyawan']['nama_lengkap'] = name;
              userDataStorage['karyawan']['email'] = email;
              userDataStorage['karyawan']['no_hp'] = phone;
            }
            _storage.write('user_data', userDataStorage);
          }
          
          debugPrint('✅ User data synced from server: $name');
        }
      }
    } catch (e) {
      debugPrint('❌ Error syncing user data from server: $e');
    }
  }
  
  Future<void> loadTransactionHistory() async {
    try {
      isLoadingTransactions.value = true;
      
      final pendingTransactions = await _profilService.getTransactions(status: 'pending');
      transactions.assignAll(pendingTransactions);
      _calculateStats();
      
      debugPrint('✅ Loaded ${transactions.length} transactions');
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
      if (trans.transactionType == 'pelatihan') {
        pelatihanCount++;
      } else if (trans.transactionType == 'ebook') {
        ebookCount++;
      }
    }
    
    totalPelatihanCount.value = pelatihanCount;
    totalEbookCount.value = ebookCount;
  }
  
  void logout() {
    // Hapus semua data dari storage
    _storage.remove('tokens');
    _storage.remove('member_id');
    _storage.remove('id');
    _storage.remove('email');
    _storage.remove('no_hp');
    _storage.remove('nama_lengkap');
    _storage.remove('user_data');
    _storage.remove('default_address');
    _storage.remove('default_address_id');
    
    // Navigate ke login screen
    Get.offAll(() => const LoginScreen());
  }
  
  void editProfile() {
    // Fungsi ini sudah tidak digunakan karena tombol edit profil
    // sekarang mengarah ke halaman EditProfilScreen
    Get.snackbar(
      'Info',
      'Fitur edit profil akan segera hadir',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }
  
  Future<void> refreshData() async {
    // Refresh semua data: sync dari server + reload transaksi
    await syncUserDataFromServer();
    loadUserData();
    await loadTransactionHistory();
  }
}