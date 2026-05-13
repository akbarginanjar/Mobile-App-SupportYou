// lib/controllers/checkout_controller.dart
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/models/payment_model.dart';
import 'package:mobile_supportyou/services/payment_service.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';
import 'package:mobile_supportyou/views/checkout_screen/metode_pembayaran.dart';
import 'package:mobile_supportyou/views/checkout_screen/voucher.dart';
import 'package:mobile_supportyou/views/pembayaran/screen.dart';

class CheckoutController extends GetxController {
  final Pelatihan pelatihan;
  final PaymentService _paymentService = PaymentService();
  final GetStorage _storage = GetStorage();
  
  CheckoutController({required this.pelatihan});
  
  // ==================== CHECKOUT PROPERTIES ====================
  final isLoading = true.obs;
  final isProcessing = false.obs;
  
  // Payment Methods
  final paymentGroups = <PaymentGroup>[].obs;
  final selectedPaymentMethod = Rx<PaymentMethod?>(null);
  
  // Transaction Fees
  final serviceFee = 0.obs;
  final appFee = 0.obs;
  
  // Discounts
  final availableDiscounts = <Discount>[].obs;
  final selectedDiscount = Rx<Discount?>(null);
  final discountAmount = 0.obs;
  
  // Total Price
  final totalPrice = 0.obs;
  
  // User data
  final konsumenMemberId = 0.obs;
  final konsumenMemberAlamatId = 0.obs;
  
  // ==================== TRANSAKSI/INVOICE PROPERTIES ====================
  final isInvoiceLoading = true.obs;
  final isInvoiceError = false.obs;
  final invoiceData = Rx<Map<String, dynamic>?>(null);
  
  // Countdown timer
  final countdown = ''.obs;
  Timer? _timer;
  
  // ==================== LIFECYCLE ====================
  @override
  void onInit() {
    super.onInit();
    _loadUserDataFromStorage();
    loadCheckoutData();
  }
  
  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
  
  // ==================== USER DATA METHODS ====================
  void _loadUserDataFromStorage() {
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('👤 LOADING USER DATA FROM STORAGE');
    debugPrint('All storage keys: ${_storage.getKeys()}');
    
    final memberId = _storage.read('member_id');
    if (memberId != null) {
      konsumenMemberId.value = memberId is int ? memberId : int.tryParse(memberId.toString()) ?? 0;
      debugPrint('✅ Member ID from "member_id": ${konsumenMemberId.value}');
    }
    
    if (konsumenMemberId.value == 0) {
      final userData = _storage.read('user_data');
      if (userData != null && userData is Map) {
        if (userData['member_id'] != null) {
          konsumenMemberId.value = userData['member_id'] is int 
              ? userData['member_id'] 
              : int.tryParse(userData['member_id'].toString()) ?? 0;
          debugPrint('✅ Member ID from user_data: ${konsumenMemberId.value}');
        }
        else if (userData['karyawan'] != null && userData['karyawan']['id'] != null) {
          konsumenMemberId.value = userData['karyawan']['id'];
          debugPrint('✅ Member ID from user_data.karyawan: ${konsumenMemberId.value}');
        }
      }
    }
    
    if (konsumenMemberId.value == 0) {
      final userId = _storage.read('id');
      if (userId != null) {
        konsumenMemberId.value = userId is int ? userId : int.tryParse(userId.toString()) ?? 0;
        debugPrint('⚠️ WARNING: Using user ID as fallback: ${konsumenMemberId.value}');
      }
    }
    
    final defaultAddressId = _storage.read('default_address_id');
    if (defaultAddressId != null) {
      konsumenMemberAlamatId.value = defaultAddressId is int 
          ? defaultAddressId 
          : int.tryParse(defaultAddressId.toString()) ?? 15;
      debugPrint('✅ Address ID from "default_address_id": ${konsumenMemberAlamatId.value}');
    }
    
    if (konsumenMemberAlamatId.value == 0) {
      konsumenMemberAlamatId.value = 15;
      debugPrint('⚠️ Using default address ID: ${konsumenMemberAlamatId.value}');
    }
    
    debugPrint('✅ FINAL konsumen_member_id: ${konsumenMemberId.value}');
    debugPrint('✅ FINAL konsumen_member_alamat_id: ${konsumenMemberAlamatId.value}');
    debugPrint('═══════════════════════════════════════════════════════════');
  }
  
  // ==================== CHECKOUT METHODS ====================
  Future<void> loadCheckoutData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadPaymentMethods(),
        loadTransactionFees(),
        loadAvailableDiscounts(),
      ]);
      calculateTotalPrice();
      debugPrint('✅ Checkout data loaded successfully');
    } catch (e) {
      debugPrint('❌ Error loading checkout data: $e');
      Get.snackbar(
        'Error',
        'Gagal memuat data checkout: ${e.toString().replaceFirst('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadPaymentMethods() async {
    try {
      final response = await _paymentService.getPaymentMethods();
      
      if (response != null && response['status'] == true) {
        final List<PaymentGroup> groups = [];
        
        for (var groupData in response['data']) {
          final String groupName = groupData['group'];
          final List<PaymentMethod> items = [];
          
          for (var item in groupData['items']) {
            PaymentMethod method;
            
            if (groupName == "Manual Transfer") {
              continue;
            } else {
              method = PaymentMethod(
                name: item['name'],
                code: item['code'],
                imageUrl: item['image'],
                type: item['type'],
                fee: item['fee'] != null ? item['fee']['value'] : 0,
              );
            }
            items.add(method);
          }
          
          if (items.isNotEmpty) {
            groups.add(PaymentGroup(group: groupName, items: items));
          }
        }
        
        paymentGroups.value = groups;
        debugPrint('✅ Loaded ${groups.length} payment groups');
      } else {
        throw Exception('Invalid response from server');
      }
    } catch (e) {
      debugPrint('❌ Error loading payment methods: $e');
      rethrow;
    }
  }
  
  Future<void> loadTransactionFees() async {
    try {
      final response = await _paymentService.getTransactionFees();
      
      if (response is List) {
        for (var fee in response) {
          if (fee['code'] == 'biaya-layanan') {
            serviceFee.value = fee['nominal'];
            debugPrint('✅ Service fee: ${serviceFee.value}');
          } else if (fee['code'] == 'biaya-aplikasi') {
            appFee.value = fee['nominal'];
            debugPrint('✅ App fee: ${appFee.value}');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading transaction fees: $e');
    }
  }
  
  Future<void> loadAvailableDiscounts() async {
    try {
      final response = await _paymentService.getAvailableDiscounts();
      
      if (response is List) {
        availableDiscounts.value = response.map((json) => Discount.fromJson(json)).toList();
        debugPrint('✅ Loaded ${availableDiscounts.length} discounts');
      }
    } catch (e) {
      debugPrint('❌ Error loading discounts: $e');
    }
  }
  
  Future<void> selectPaymentMethod() async {
    if (paymentGroups.isEmpty) return;
    
    final result = await Get.to(() => MetodePembayaranScreen(
          paymentGroups: paymentGroups,
          selectedMethod: selectedPaymentMethod.value,
        ));
    
    if (result != null && result is PaymentMethod) {
      selectedPaymentMethod.value = result;
      debugPrint('✅ Payment method selected: ${result.name}');
    }
  }

  Future<void> selectDiscount() async {
    if (availableDiscounts.isEmpty) return;

    final basePrice = pelatihan.hargaFinal ?? pelatihan.harga;
    final result = await Get.to(() => VoucherScreen(
          discounts: availableDiscounts,
          selectedDiscount: selectedDiscount.value,
          originalPrice: basePrice,
        ));
    if (result != null) {
      if (result is Discount) {
        selectedDiscount.value = result;
        discountAmount.value = result.calculateDiscount(basePrice);
        debugPrint('✅ Discount selected: ${result.name}, amount: ${discountAmount.value}');
      } else if (result == 'none') {
        selectedDiscount.value = null;
        discountAmount.value = 0;
        debugPrint('✅ Discount removed');
      }
      calculateTotalPrice();
    } else {
      debugPrint('⚠️ User cancelled discount selection, no changes made');
    }
  }

  void calculateTotalPrice() {
    final basePrice = pelatihan.hargaFinal ?? pelatihan.harga;
    final total = basePrice + serviceFee.value + appFee.value - discountAmount.value;
    totalPrice.value = total;

    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('💰 PRICE CALCULATION');
    debugPrint('Base Price: ${pelatihan.harga}');
    debugPrint('Final Price: ${pelatihan.hargaFinal ?? pelatihan.harga}');
    debugPrint('Service Fee: ${serviceFee.value}');
    debugPrint('App Fee: ${appFee.value}');
    debugPrint('Discount: ${discountAmount.value}');
    debugPrint('Total Price: ${totalPrice.value}');
    debugPrint('═══════════════════════════════════════════════════════════');
  }
  
  String getSelectedPaymentMethodName() {
    return selectedPaymentMethod.value?.name ?? 'Pilih Metode Pembayaran';
  }
  
  String getSelectedDiscountText() {
    if (selectedDiscount.value == null) {
      return 'Pilih Voucher';
    }
    final discount = selectedDiscount.value!;
    if (discount.type == 'percentage') {
      return '${discount.name} (${discount.value}% OFF)';
    } else {
      return '${discount.name} (${discount.getFormattedValue()} OFF)';
    }
  }
  
  // Helper untuk menentukan metode_bayar
  String _getMetodeBayar(PaymentMethod? method) {
    if (method == null) return 'payment_gateway';
    
    // QRIS
    if (method.type == 'qris') {
      return 'payment_gateway';
    }
    
    // Default untuk Virtual Account dan lainnya
    return 'payment_gateway';
  }
  
  // Helper untuk menentukan payment_type
  String _getPaymentType(PaymentMethod? method) {
    if (method == null) return 'bank_transfer';
    
    // QRIS
    if (method.type == 'qris') {
      return 'qris';
    }
    
    // Default untuk Virtual Account
    return 'bank_transfer';
  }
  
  Future<void> processCheckout() async {
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('🛒 PROCESSING CHECKOUT');
    debugPrint('═══════════════════════════════════════════════════════════');
    
    if (selectedPaymentMethod.value == null) {
      debugPrint('❌ No payment method selected');
      Get.snackbar(
        'Peringatan',
        'Silakan pilih metode pembayaran terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    
    if (konsumenMemberId.value == 0) {
      debugPrint('❌ Member ID is 0, cannot proceed');
      Get.snackbar(
        'Error',
        'Data member tidak ditemukan. Silakan login kembali.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    final method = selectedPaymentMethod.value!;
    
    debugPrint('Selected payment method: ${method.name}');
    debugPrint('Payment code: ${method.code}');
    debugPrint('Payment type: ${method.type}');
    debugPrint('Member ID (konsumen_member_id): ${konsumenMemberId.value}');
    debugPrint('Address ID: ${konsumenMemberAlamatId.value}');
    debugPrint('Product type: ${pelatihan.type}');
    
    isProcessing.value = true;
    
    try {
      final basePrice = pelatihan.hargaFinal ?? pelatihan.harga;
      final uangMasuk = basePrice;
      final tokoMemberId = pelatihan.mitra?.memberId ?? pelatihan.tokoMemberId ?? 0;
      
      debugPrint('💰 Base Price: $basePrice');
      debugPrint('💰 Uang Masuk (gross_amount): $uangMasuk');
      debugPrint('💰 Toko Member ID: $tokoMemberId');
      debugPrint('💰 Discount Amount: ${discountAmount.value}');
      debugPrint('💰 Total Price: ${totalPrice.value}');
      
      String transactionType;
      Map<String, dynamic> itemData;
      
      if (pelatihan.type == 'ebook') {
        transactionType = 'barang';
        itemData = {
          'barang_id': pelatihan.id,
          'qty': 1,
          'harga': basePrice,
        };
        debugPrint('📦 Processing as EBOOK with transaction_type: $transactionType');
      } else {
        transactionType = 'pelatihan';
        itemData = {
          'pelatihan_id': pelatihan.id,
          'qty': 1,
          'harga': basePrice,
        };
        debugPrint('📦 Processing as PELATIHAN with transaction_type: $transactionType');
      }
      
      final metodeBayar = _getMetodeBayar(method);
      final paymentType = _getPaymentType(method);
      
      final checkoutData = {
        'konsumen_member_id': konsumenMemberId.value,
        'konsumen_member_alamat_id': konsumenMemberAlamatId.value,
        'toko_member_id': tokoMemberId,
        'uang_masuk': uangMasuk,
        'ongkir': 0,
        'biaya_layanan': serviceFee.value,
        'biaya_aplikasi': appFee.value,
        'items': [itemData],
        'metode_bayar': metodeBayar,
        'payment_code': method.code,
        'payment_type': paymentType,
        'transaction_type': transactionType,
      };
      
      if (selectedDiscount.value != null) {
        checkoutData['event_diskon_ids'] = [selectedDiscount.value!.id];
        debugPrint('📦 Added event_diskon_ids: [${selectedDiscount.value!.id}]');
      }
      
      debugPrint('📦 Checkout Payload: ${jsonEncode(checkoutData)}');
      
      final response = await _paymentService.createCheckout(checkoutData);
      
      debugPrint('📥 RESPONSE: Checkout');
      debugPrint('Body: $response');
      
      if (response != null && response['id'] != null) {
        debugPrint('✅ Checkout successful!');
        debugPrint('Transaction ID: ${response['id']}');
        debugPrint('No Invoice: ${response['no_invoice']}');
        
        Get.snackbar(
          'Sukses',
          'Pesanan berhasil dibuat',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        Get.to(() => PembayaranScreen(
              idTransaksi: response['id'],
              pelatihan: pelatihan,
              discountAmount: discountAmount.value.toDouble(),
              discountName: selectedDiscount.value?.name,
            ));
      } else {
        throw Exception(response?['message'] ?? 'Gagal memproses pesanan');
      }
      
    } catch (e) {
      debugPrint('❌ Error processing checkout: $e');
      Get.snackbar(
        'Error',
        'Gagal memproses pesanan: ${e.toString().replaceFirst('Exception: ', '')}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isProcessing.value = false;
      debugPrint('═══════════════════════════════════════════════════════════');
    }
  }
  
  // ==================== INVOICE/TRANSAKSI METHODS ====================
  
  Future<void> getInvoice(int? idTransaksi) async {
    if (idTransaksi == null) return;
    
    isInvoiceLoading.value = true;
    isInvoiceError.value = false;
    
    _timer?.cancel();
    countdown.value = '';
    
    try {
      final response = await _paymentService.getInvoice(idTransaksi);
      
      debugPrint('📥 getInvoice response: $response');
      
      if (response != null && response['id'] != null) {
        invoiceData.value = response;
        
        final status = response['status'];
        final statusBayar = response['status_bayar'];
        
        if (statusBayar == 'belum_lunas' && 
            status != 'dibatalkan' && 
            status != 'expired' &&
            response['expire_time'] != null) {
          startCountdown(response['expire_time']);
        }
      } else {
        isInvoiceError.value = true;
      }
    } catch (e) {
      debugPrint('Error getting invoice: $e');
      isInvoiceError.value = true;
    } finally {
      isInvoiceLoading.value = false;
    }
  }
  
  void startCountdown(String expireTime) {
    _timer?.cancel();
    
    final expireDateTime = DateTime.parse(expireTime);
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = expireDateTime.difference(now);
      
      if (difference.isNegative) {
        countdown.value = '00:00:00';
        timer.cancel();
        final currentId = invoiceData.value?['id'];
        if (currentId != null) {
          getInvoice(currentId);
        }
        return;
      }
      
      final days = difference.inDays;
      final hours = difference.inHours.remainder(24);
      final minutes = difference.inMinutes.remainder(60);
      final seconds = difference.inSeconds.remainder(60);
      
      if (days > 0) {
        countdown.value = '$days hari, $hours jam, $minutes menit, $seconds detik';
      } else {
        countdown.value = '$hours jam, $minutes menit, $seconds detik';
      }
    });
  }
  
  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Berhasil',
      'Berhasil disalin',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }
  
  Future<void> batalkanPesanan(String noInvoice) async {
    try {
      EasyLoading.show(status: 'Membatalkan pesanan...');

      final response = await _paymentService.batalkanPesanan(noInvoice);
    
      EasyLoading.dismiss();

      debugPrint('📥 Batalkan Pesanan Response: $response');
    
      if (response != null) {
        // 🔥 PERBAIKAN: Cek apakah ada message yang mengandung kata "berhasil"
        final message = response['message'] ?? '';
        final isSuccess = message.toLowerCase().contains('berhasil') || 
                          message.toLowerCase().contains('dibatalkan');
      
        if (isSuccess) {
          Get.snackbar(
            'Berhasil',
            message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: const Icon(Icons.check_circle, color: Colors.white, size: 24),
            duration: const Duration(seconds: 3),
          );
        
          final currentId = invoiceData.value?['id'];
          if (currentId != null) {
            await getInvoice(currentId);
          }
          update();
        } else {
          final errorMsg = response['message'] ?? response['error'] ?? 'Gagal membatalkan pesanan';
          Get.snackbar(
            'Gagal',
            errorMsg,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.error_outline, color: Colors.white, size: 24),
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        Get.snackbar(
          'Gagal',
          'Gagal membatalkan pesanan: Response kosong',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white, size: 24),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      debugPrint('❌ Error batalkan pesanan: $e');
      Get.snackbar(
        'Error',
        'Gagal membatalkan pesanan: ${e.toString().replaceFirst('Exception: ', '')}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error_outline, color: Colors.white, size: 24),
        duration: const Duration(seconds: 3),
      );
    }
  }
  
  // ==================== GETTER METHODS FOR UI ====================
  bool get isInvoiceDataLoading => isInvoiceLoading.value;
  bool get isInvoiceDataError => isInvoiceError.value;
  Map<String, dynamic>? get invoice => invoiceData.value;
}