// lib/controllers/checkout_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/models/payment_model.dart';
import 'package:mobile_supportyou/services/payment_service.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';
import 'package:mobile_supportyou/views/checkout_screen/metode_pembayaran.dart';
import 'package:mobile_supportyou/views/checkout_screen/voucher.dart';

class CheckoutController extends GetxController {
  final Pelatihan pelatihan;
  final PaymentService _paymentService = PaymentService();
  
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
  
  @override
  void onInit() {
    super.onInit();
    loadCheckoutData();
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
    } catch (e) {
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
      } else {
        throw Exception('Invalid response from server');
      }
    } catch (e) {
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
          } else if (fee['code'] == 'biaya-aplikasi') {
            appFee.value = fee['nominal'];
          }
        }
      }
    } catch (e) {
      // Use default values (0)
    }
  }
  
  Future<void> loadAvailableDiscounts() async {
    try {
      final response = await _paymentService.getAvailableDiscounts();
      
      if (response is List) {
        availableDiscounts.value = response.map((json) => Discount.fromJson(json)).toList();
      }
    } catch (e) {
      // No discounts available
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
    } else if (result == null) {
      selectedDiscount.value = null;
      discountAmount.value = 0;
    }
    calculateTotalPrice();
  }
  
  void calculateTotalPrice() {
    final basePrice = pelatihan.hargaFinal ?? pelatihan.harga;
    final total = basePrice + serviceFee.value + appFee.value - discountAmount.value;
    totalPrice.value = total;
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
    if (selectedPaymentMethod.value == null) {
      Get.snackbar(
        'Peringatan',
        'Silakan pilih metode pembayaran terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    
    isProcessing.value = true;
    
    try {
      final checkoutData = {
        'pelatihan_id': pelatihan.id,
        'pelatihan_nama': pelatihan.nama,
        'payment_method_code': selectedPaymentMethod.value?.code,
        'payment_method_name': selectedPaymentMethod.value?.name,
        'total_price': totalPrice.value,
        'service_fee': serviceFee.value,
        'app_fee': appFee.value,
        'discount_id': selectedDiscount.value?.id,
        'discount_name': selectedDiscount.value?.name,
        'discount_amount': discountAmount.value,
        'original_price': pelatihan.harga,
        'final_price': pelatihan.hargaFinal ?? pelatihan.harga,
      };
      
      final response = await _paymentService.createCheckout(checkoutData);
      
      if (response['status'] == true) {
        Get.snackbar(
          'Sukses',
          'Pesanan berhasil dibuat',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
      } else {
        throw Exception(response['message'] ?? 'Gagal memproses pesanan');
      }
      
    } catch (e) {
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
    }
  }
}