// lib/controllers/checkout_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/models/payment_model.dart';
import 'package:mobile_supportyou/services/payment_service.dart';

class CheckoutController extends GetxController {
  final Pelatihan pelatihan;
  final PaymentService _paymentService = PaymentService();
  
  CheckoutController({required this.pelatihan});
  
  final isLoading = true.obs;
  final isProcessing = false.obs;
  
  // Payment Methods
  final paymentMethods = <PaymentGroup>[].obs;
  final selectedPaymentMethod = Rx<PaymentMethod?>(null);
  
  // Transaction Fees
  final serviceFee = 0.obs;
  final appFee = 0.obs;
  
  // Discount
  final discount = 0.obs;
  
  // Total Price
  final totalPrice = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    print('═══════════════════════════════════════════════════════════');
    print('🚀 CheckoutController initialized');
    print('Pelatihan ID: ${pelatihan.id}');
    print('Pelatihan Nama: ${pelatihan.nama}');
    print('Harga: ${pelatihan.harga}');
    print('═══════════════════════════════════════════════════════════');
    loadCheckoutData();
  }
  
  Future<void> loadCheckoutData() async {
    print('🔄 Loading checkout data...');
    isLoading.value = true;
    try {
      await Future.wait([
        loadPaymentMethods(),
        loadTransactionFees(),
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
      print('🔄 Loading state set to false');
    }
  }
  
  Future<void> loadPaymentMethods() async {
    print('🔄 Loading payment methods from API...');
    try {
      final response = await _paymentService.getPaymentMethods();
      print('Raw response: $response');
      
      if (response != null && response['status'] == true) {
        print('✅ Payment methods API response status: true');
        
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
        
        paymentMethods.value = groups;
        print('✅ Total payment groups loaded: ${groups.length}');
      } else {
        print('❌ Invalid response format or status false');
        throw Exception('Invalid response from server');
      }
    } catch (e) {
      print('❌ Error loading payment methods: $e');
      rethrow;
    }
  }
  
  Future<void> loadTransactionFees() async {
    print('🔄 Loading transaction fees from API...');
    try {
      final response = await _paymentService.getTransactionFees();
      print('Raw response: $response');
      
      if (response is List) {
        for (var fee in response) {
          if (fee['code'] == 'biaya-layanan') {
            serviceFee.value = fee['nominal'];
            print('✅ Service fee set to: ${serviceFee.value}');
          } else if (fee['code'] == 'biaya-aplikasi') {
            appFee.value = fee['nominal'];
            print('✅ App fee set to: ${appFee.value}');
          }
        }
      } else {
        print('⚠️ Transaction fees response is not a List, using default values');
      }
    } catch (e) {
      print('❌ Error loading transaction fees: $e');
    }
  }
  
  void calculateTotalPrice() {
    final basePrice = pelatihan.hargaFinal ?? pelatihan.harga;
    final total = basePrice + serviceFee.value + appFee.value - discount.value;
    totalPrice.value = total;
    
    print('═══════════════════════════════════════════════════════════');
    print('💰 PRICE CALCULATION');
    print('Base Price: ${pelatihan.harga}');
    print('Final Price: ${pelatihan.hargaFinal ?? pelatihan.harga}');
    print('Service Fee: ${serviceFee.value}');
    print('App Fee: ${appFee.value}');
    print('Discount: ${discount.value}');
    print('Total Price: ${totalPrice.value}');
    print('═══════════════════════════════════════════════════════════');
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
        'discount': discount.value,
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