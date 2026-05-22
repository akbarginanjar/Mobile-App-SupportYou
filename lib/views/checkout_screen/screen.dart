// lib/views/checkout_screen/screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/checkout_controller.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/utils/image_helper.dart';
import 'package:mobile_supportyou/utils/date_formatter.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class CheckoutScreen extends StatelessWidget {
  final Pelatihan pelatihan;
  
  const CheckoutScreen({
    super.key,
    required this.pelatihan,
  });

  @override
  Widget build(BuildContext context) {
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
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memuat data checkout...'),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductCard(context, controller),
              _buildVoucherSection(context, controller),
              _buildPaymentMethodSection(context, controller),
              _buildOrderSummary(context, controller),
              const SizedBox(height: 100),
            ],
          ),
        );
      }),
      
      bottomNavigationBar: _buildBottomButton(context, controller),
    );
  }
  
  Widget _buildProductCard(BuildContext context, CheckoutController controller) {
    final pelatihan = controller.pelatihan;
    final formattedDate = DateFormatter.formatDateWithDayAndTime(pelatihan.waktu);
    final isOnline = pelatihan.typePelatihan == 'online';
    
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Pelatihan yang Dipilih',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(
                    ImageHelper.getFullImageUrl(pelatihan.cover),
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: Icon(Icons.image, size: 40, color: Colors.grey[400]),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pelatihan.nama,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pelatihan.mitra?.nama ?? 'SupportYou Education',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Formatter.formatCurrency(pelatihan.hargaFinal ?? pelatihan.harga),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          isOnline ? Icons.wifi : Icons.location_on,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            isOnline ? 'Online' : (pelatihan.tempat ?? 'Offline'),
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildVoucherSection(BuildContext context, CheckoutController controller) {
    if (controller.availableDiscounts.isEmpty) {
      return const SizedBox.shrink();
    }
    
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
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    '2',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Kode Voucher',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          InkWell(
            onTap: () => controller.selectDiscount(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Expanded(
                    child: Text(
                      controller.getSelectedDiscountText(),
                      style: TextStyle(
                        color: controller.selectedDiscount.value == null 
                            ? Colors.grey[600]
                            : Colors.green[700],
                        fontWeight: controller.selectedDiscount.value == null 
                            ? FontWeight.normal 
                            : FontWeight.w500,
                      ),
                    ),
                  )),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
          if (controller.selectedDiscount.value != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_offer, size: 16, color: Colors.green[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Diskon ${controller.selectedDiscount.value?.getFormattedValue()} telah diterapkan',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildPaymentMethodSection(BuildContext context, CheckoutController controller) {
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
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          InkWell(
            onTap: () => controller.selectPaymentMethod(),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[50],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    controller.getSelectedPaymentMethodName(),
                    style: TextStyle(
                      color: controller.selectedPaymentMethod.value == null 
                          ? Colors.grey[600]
                          : Colors.black87,
                      fontWeight: controller.selectedPaymentMethod.value == null 
                          ? FontWeight.normal 
                          : FontWeight.w500,
                    ),
                  )),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrderSummary(BuildContext context, CheckoutController controller) {
    final basePrice = controller.pelatihan.hargaFinal ?? controller.pelatihan.harga;
    
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
            'Ringkasan Pembayaran',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Divider(height: 24),
          
          _buildSummaryRow(
            'Harga Pelatihan',
            Formatter.formatCurrency(basePrice),
          ),
          const SizedBox(height: 12),
          
          _buildSummaryRow(
            'Biaya Layanan',
            controller.serviceFee.value > 0 
                ? Formatter.formatCurrency(controller.serviceFee.value)
                : 'Gratis',
          ),
          const SizedBox(height: 12),
          
          _buildSummaryRow(
            'Biaya Aplikasi',
            controller.appFee.value > 0 
                ? Formatter.formatCurrency(controller.appFee.value)
                : 'Gratis',
          ),
          
          Obx(() {
            if (controller.paymentGatewayFee.value > 0) {
              return Column(
                children: [
                  const SizedBox(height: 12),
                  _buildSummaryRow(
                    'Biaya Layanan',
                    Formatter.formatCurrency(controller.paymentGatewayFee.value),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
          
          Obx(() => controller.discountAmount.value > 0
              ? Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      'Diskon',
                      '- ${Formatter.formatCurrency(controller.discountAmount.value)}',
                      isDiscount: true,
                    ),
                  ],
                )
              : const SizedBox.shrink()),
          
          const Divider(height: 24),
          
          Obx(() => _buildSummaryRow(
            'Total Pembayaran',
            Formatter.formatCurrency(controller.totalPrice.value),
            isTotal: true,
          )),
          
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Pembayaran aman & terenkripsi',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(
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
            color: isTotal ? Colors.black87 : (isDiscount ? Colors.red : Colors.grey[600]),
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            fontSize: isTotal ? 14 : 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? Colors.red : (isTotal ? primary : Colors.grey[800]),
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
        child: Obx(() => ElevatedButton.icon(
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
              : () => controller.processCheckout(),
          icon: Icon(
            Icons.lock_outline,
            size: 18,
            color: controller.isLoading.value || controller.selectedPaymentMethod.value == null
                ? Colors.grey[600]
                : Colors.white,
          ),
          label: Text(
            controller.isProcessing.value ? 'Memproses...' : 'Daftar Sekarang',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        )),
      ),
    );
  }
}