// lib/views/checkout_screen/screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/checkout_controller.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/models/payment_model.dart';
import 'package:mobile_supportyou/utils/image_helper.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class CheckoutScreen extends StatelessWidget {
  final Pelatihan pelatihan;
  
  const CheckoutScreen({
    super.key,
    required this.pelatihan,
  });

  @override
  Widget build(BuildContext context) {
    print('═══════════════════════════════════════════════════════════');
    print('📱 CheckoutScreen opened');
    print('Pelatihan: ${pelatihan.nama}');
    print('═══════════════════════════════════════════════════════════');
    
    final controller = Get.put(CheckoutController(pelatihan: pelatihan));
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primary,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          print('⏳ Loading state: true');
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memuat data checkout...'),
                SizedBox(height: 8),
                Text(
                  'Mohon tunggu',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        }
        
        print('✅ Data loaded, building UI');
        print('Payment methods count: ${controller.paymentMethods.length}');
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Info Card
              _buildProductCard(context, controller),
              
              // Payment Method Section
              _buildPaymentSection(context, controller),
              
              // Voucher Section (Coming Soon)
              _buildVoucherSection(context),
              
              // Order Summary
              _buildOrderSummary(context, controller),
              
              const SizedBox(height: 100),
            ],
          ),
        );
      }),
      
      // Bottom Button
      bottomNavigationBar: _buildBottomButton(context, controller),
    );
  }
  
  Widget _buildProductCard(BuildContext context, CheckoutController controller) {
    final String imageUrl = ImageHelper.getFullImageUrl(controller.pelatihan.cover);
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 80,
              height: 80,
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Error loading image: $error');
                        return Image.asset(
                          'assets/image/pelatihan_placeholder.jpg',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      'assets/image/pelatihan_placeholder.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Product Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.pelatihan.nama,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  Formatter.formatCurrency(controller.pelatihan.hargaFinal ?? controller.pelatihan.harga),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPaymentSection(BuildContext context, CheckoutController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Metode Pembayaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          // Payment Method Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<PaymentMethod>(
                isExpanded: true,
                hint: Text(
                  'Pilih Metode Pembayaran',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
                value: controller.selectedPaymentMethod.value,
                items: controller.paymentMethods.expand((group) {
                  return group.items.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Row(
                        children: [
                          if (method.imageUrl != null)
                            Image.network(
                              method.imageUrl!,
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.payment,
                                  size: 24,
                                  color: Colors.grey[600],
                                );
                              },
                            ),
                          if (method.imageUrl != null) const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              method.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList();
                }).toList(),
                onChanged: (value) {
                  print('Payment method selected: ${value?.name}');
                  controller.selectedPaymentMethod.value = value;
                },
              ),
            ),
          ),
          // Show error if no payment methods
          if (controller.paymentMethods.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tidak ada metode pembayaran yang tersedia',
                        style: TextStyle(color: Colors.red[700], fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildVoucherSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Pilih Voucher',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Chip(
            label: Text('Coming Soon'),
            backgroundColor: Colors.grey,
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrderSummary(BuildContext context, CheckoutController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Belanja',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          // Total Harga
          _buildSummaryRow(
            context,
            'Total Harga (1 Pelatihan)',
            Formatter.formatCurrency(controller.pelatihan.hargaFinal ?? controller.pelatihan.harga),
          ),
          const SizedBox(height: 12),
          // Biaya Layanan
          Obx(() => _buildSummaryRow(
            context,
            'Biaya Layanan',
            Formatter.formatCurrency(controller.serviceFee.value),
          )),
          const SizedBox(height: 12),
          // Biaya Aplikasi
          Obx(() => _buildSummaryRow(
            context,
            'Biaya Aplikasi',
            Formatter.formatCurrency(controller.appFee.value),
          )),
          // Diskon (if applied)
          Obx(() => controller.discount.value > 0
              ? Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      context,
                      'Diskon',
                      '- ${Formatter.formatCurrency(controller.discount.value)}',
                      isDiscount: true,
                    ),
                  ],
                )
              : const SizedBox.shrink()),
          const Divider(height: 24),
          // Total Bayar
          Obx(() => _buildSummaryRow(
            context,
            'Total Bayar',
            Formatter.formatCurrency(controller.totalPrice.value),
            isTotal: true,
          )),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
    bool isDiscount = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black87 : Colors.grey[600],
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            fontSize: isTotal ? 14 : 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? Colors.red : (isTotal ? primary : Colors.grey[700]),
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            fontSize: isTotal ? 16 : 13,
          ),
        ),
      ],
    );
  }
  
  Widget _buildBottomButton(BuildContext context, CheckoutController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Obx(() => ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
            disabledBackgroundColor: Colors.grey[400],
          ),
          onPressed: controller.isLoading.value || controller.selectedPaymentMethod.value == null
              ? null
              : () {
                  print('🛒 Buy Now button pressed');
                  controller.processCheckout();
                },
          child: Text(
            controller.isProcessing.value ? 'Memproses...' : 'Beli Sekarang',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        )),
      ),
    );
  }
}