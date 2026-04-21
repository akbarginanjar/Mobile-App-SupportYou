// lib/controllers/checkout_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
  
  @override
  void onInit() {
    super.onInit();
    _loadUserDataFromStorage();
    loadCheckoutData();
  }
  
  void _loadUserDataFromStorage() {
    print('═══════════════════════════════════════════════════════════');
    print('👤 LOADING USER DATA FROM STORAGE');
    print('All storage keys: ${_storage.getKeys()}');
    
    final memberId = _storage.read('member_id');
    if (memberId != null) {
      konsumenMemberId.value = memberId is int ? memberId : int.tryParse(memberId.toString()) ?? 0;
      print('✅ Member ID from "member_id": ${konsumenMemberId.value}');
    }
    
    if (konsumenMemberId.value == 0) {
      final userData = _storage.read('user_data');
      if (userData != null && userData is Map) {
        if (userData['member_id'] != null) {
          konsumenMemberId.value = userData['member_id'] is int 
              ? userData['member_id'] 
              : int.tryParse(userData['member_id'].toString()) ?? 0;
          print('✅ Member ID from user_data: ${konsumenMemberId.value}');
        }
        else if (userData['karyawan'] != null && userData['karyawan']['id'] != null) {
          konsumenMemberId.value = userData['karyawan']['id'];
          print('✅ Member ID from user_data.karyawan: ${konsumenMemberId.value}');
        }
      }
    }
    
    if (konsumenMemberId.value == 0) {
      final userId = _storage.read('id');
      if (userId != null) {
        konsumenMemberId.value = userId is int ? userId : int.tryParse(userId.toString()) ?? 0;
        print('⚠️ WARNING: Using user ID as fallback: ${konsumenMemberId.value}');
      }
    }
    
    final defaultAddressId = _storage.read('default_address_id');
    if (defaultAddressId != null) {
      konsumenMemberAlamatId.value = defaultAddressId is int 
          ? defaultAddressId 
          : int.tryParse(defaultAddressId.toString()) ?? 15;
      print('✅ Address ID from "default_address_id": ${konsumenMemberAlamatId.value}');
    }
    
    if (konsumenMemberAlamatId.value == 0) {
      konsumenMemberAlamatId.value = 15;
      print('⚠️ Using default address ID: ${konsumenMemberAlamatId.value}');
    }
    
    print('✅ FINAL konsumen_member_id: ${konsumenMemberId.value}');
    print('✅ FINAL konsumen_member_alamat_id: ${konsumenMemberAlamatId.value}');
    print('═══════════════════════════════════════════════════════════');
  }
  
  Future<void> loadCheckoutData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadPaymentMethods(),
        loadTransactionFees(),
        loadAvailableDiscounts(),
      ]);
      calculateTotalPrice();
      print('✅ Checkout data loaded successfully');
    } catch (e) {
      print('❌ Error loading checkout data: $e');
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
              method = PaymentMethod(
                name: item['name'],
                code: item['code'].toString(),
                imageUrl: item['image_url'],
                number: item['number'],
                description: item['description'],
              );
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
          
          groups.add(PaymentGroup(group: groupName, items: items));
        }
        
        paymentGroups.value = groups;
        print('✅ Loaded ${groups.length} payment groups');
      } else {
        throw Exception('Invalid response from server');
      }
    } catch (e) {
      print('❌ Error loading payment methods: $e');
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
            print('✅ Service fee: ${serviceFee.value}');
          } else if (fee['code'] == 'biaya-aplikasi') {
            appFee.value = fee['nominal'];
            print('✅ App fee: ${appFee.value}');
          }
        }
      }
    } catch (e) {
      print('❌ Error loading transaction fees: $e');
    }
  }
  
  Future<void> loadAvailableDiscounts() async {
    try {
      final response = await _paymentService.getAvailableDiscounts();
      
      if (response is List) {
        availableDiscounts.value = response.map((json) => Discount.fromJson(json)).toList();
        print('✅ Loaded ${availableDiscounts.length} discounts');
      }
    } catch (e) {
      print('❌ Error loading discounts: $e');
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
      print('✅ Payment method selected: ${result.name}');
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
    
    if (result != null && result is Discount) {
      selectedDiscount.value = result;
      discountAmount.value = result.calculateDiscount(basePrice);
      print('✅ Discount selected: ${result.name}, amount: ${discountAmount.value}');
    } else if (result == null) {
      selectedDiscount.value = null;
      discountAmount.value = 0;
      print('✅ Discount removed');
    }
    calculateTotalPrice();
  }
  
  void calculateTotalPrice() {
    final basePrice = pelatihan.hargaFinal ?? pelatihan.harga;
    final total = basePrice + serviceFee.value + appFee.value - discountAmount.value;
    totalPrice.value = total;
    
    print('═══════════════════════════════════════════════════════════');
    print('💰 PRICE CALCULATION');
    print('Base Price: ${pelatihan.harga}');
    print('Final Price: ${pelatihan.hargaFinal ?? pelatihan.harga}');
    print('Service Fee: ${serviceFee.value}');
    print('App Fee: ${appFee.value}');
    print('Discount: ${discountAmount.value}');
    print('Total Price: ${totalPrice.value}');
    print('═══════════════════════════════════════════════════════════');
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
  
  Future<void> processCheckout() async {
    print('═══════════════════════════════════════════════════════════');
    print('🛒 PROCESSING CHECKOUT');
    print('═══════════════════════════════════════════════════════════');
    
    if (selectedPaymentMethod.value == null) {
      print('❌ No payment method selected');
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
      print('❌ Member ID is 0, cannot proceed');
      Get.snackbar(
        'Error',
        'Data member tidak ditemukan. Silakan login kembali.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    
    print('Selected payment method: ${selectedPaymentMethod.value?.name}');
    print('Payment code: ${selectedPaymentMethod.value?.code}');
    print('Member ID (konsumen_member_id): ${konsumenMemberId.value}');
    print('Address ID: ${konsumenMemberAlamatId.value}');
    
    isProcessing.value = true;
    
    try {
      final basePrice = pelatihan.hargaFinal ?? pelatihan.harga;
      
      final checkoutData = {
        'konsumen_member_id': konsumenMemberId.value,
        'konsumen_member_alamat_id': konsumenMemberAlamatId.value,
        'uang_masuk': basePrice,
        'ongkir': 0,
        'biaya_aplikasi': appFee.value,
        'biaya_layanan': serviceFee.value,
        'items': [
          {
            'pelatihan_id': pelatihan.id,
            'qty': 1,
            'harga': basePrice,
          }
        ],
        'metode_bayar': 'payment_gateway',
        'payment_code': selectedPaymentMethod.value?.code,
        'payment_type': selectedPaymentMethod.value?.type ?? 'bank_transfer',
        'transaction_type': 'pelatihan',
      };
      
      print('📦 Checkout Payload: ${jsonEncode(checkoutData)}');
      
      final response = await _paymentService.createCheckout(checkoutData);
      
      print('📦 Checkout Response: $response');
      
      if (response != null && response['id'] != null) {
        print('✅ Checkout successful!');
        print('Transaction ID: ${response['id']}');
        print('No Invoice: ${response['no_invoice']}');
        
        Get.snackbar(
          'Sukses',
          'Pesanan berhasil dibuat',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        Get.offAll(() => PembayaranScreen(
              idTransaksi: response['id'],
            ));
      } else {
        throw Exception(response['message'] ?? 'Gagal memproses pesanan');
      }
      
    } catch (e) {
      print('❌ Error processing checkout: $e');
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
      print('═══════════════════════════════════════════════════════════');
    }
  }
}