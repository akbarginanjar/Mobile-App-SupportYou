import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/checkout_controller.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/utils/image_helper.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';
import 'package:mobile_supportyou/views/pembayaran/screen.dart';

class CheckoutScreen extends StatelessWidget {
  final Pelatihan pelatihan;
  
  const CheckoutScreen({
    super.key,
    required this.pelatihan,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('═══════════════════════════════════════════════════════════');
    debugPrint('📱 CheckoutScreen opened');
    debugPrint('Pelatihan: ${pelatihan.nama}');
    debugPrint('═══════════════════════════════════════════════════════════');
    
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
                SizedBox(height: 8),
                Text(
                  'Mohon tunggu',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        }
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductCard(context, controller),
              _buildPaymentMethodButton(context, controller),
              _buildDiscountButton(context, controller),
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
    final String imageUrl = ImageHelper.getFullImageUrl(controller.pelatihan.cover);
    final pelatihan = controller.pelatihan;
    
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/image/pelatihan_placeholder.jpg',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/image/pelatihan_placeholder.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: pelatihan.typePelatihan == "offline" 
                              ? [Colors.orange, Colors.deepOrange] 
                              : [Colors.blue, Colors.lightBlue],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            pelatihan.typePelatihan == "offline" 
                                ? Icons.location_on 
                                : Icons.video_library,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            pelatihan.typePelatihan == "offline" ? "OFFLINE" : "ONLINE",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pelatihan.nama,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Formatter.formatCurrency(pelatihan.hargaFinal ?? pelatihan.harga),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const Divider(height: 24),
          
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  context,
                  icon: Icons.calendar_today,
                  label: "Waktu",
                  value: pelatihan.waktu != null 
                      ? _formatDate(pelatihan.waktu!) 
                      : "TBA",
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildDetailItem(
                  context,
                  icon: Icons.people_outline,
                  label: "Kuota",
                  value: pelatihan.maxPeserta != null 
                      ? "${pelatihan.maxPeserta} Peserta" 
                      : "Tidak terbatas",
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          if (pelatihan.typePelatihan == "offline") ...[
            _buildDetailItem(
              context,
              icon: Icons.location_on,
              label: "Lokasi",
              value: pelatihan.tempat ?? "Lokasi belum ditentukan",
              fullWidth: true,
            ),
          ] else ...[
            _buildDetailItem(
              context,
              icon: Icons.wifi,
              label: "Platform",
              value: "Zoom Meeting / Google Meet",
              fullWidth: true,
            ),
          ],
          
          const SizedBox(height: 12),
          
          _buildDetailItem(
            context,
            icon: Icons.business_outlined,
            label: "Penyelenggara",
            value: pelatihan.mitra?.nama ?? "Belum ada nama",
            fullWidth: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildDetailItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    bool fullWidth = false,
  }) {
    if (fullWidth) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: primary),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
  
  String _formatDate(String dateTimeString) {
    try {
      final DateTime dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return dateTimeString;
    }
  }
  
  Widget _buildPaymentMethodButton(BuildContext context, CheckoutController controller) {
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
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
                          ? textTheme
                          : Colors.black87,
                      fontWeight: controller.selectedPaymentMethod.value == null 
                          ? FontWeight.normal 
                          : FontWeight.w500,
                    ),
                  )),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDiscountButton(BuildContext context, CheckoutController controller) {
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
          const Text(
            'Voucher Diskon',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
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
                            ? textTheme
                            : Colors.green[700],
                        fontWeight: controller.selectedDiscount.value == null 
                            ? FontWeight.normal 
                            : FontWeight.w500,
                      ),
                    ),
                  )),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          if (controller.selectedDiscount.value != null) ...[
            const SizedBox(height: 8),
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
            'Ringkasan Belanja',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          
          _buildSummaryRow(
            context,
            'Harga Pelatihan',
            Formatter.formatCurrency(basePrice),
          ),
          const SizedBox(height: 12),
          
          _buildSummaryRow(
            context,
            'Biaya Layanan',
            Formatter.formatCurrency(controller.serviceFee.value),
          ),
          const SizedBox(height: 12),
          
          _buildSummaryRow(
            context,
            'Biaya Aplikasi',
            Formatter.formatCurrency(controller.appFee.value),
          ),
          const SizedBox(height: 12),
          
          Obx(() {
            if (controller.paymentGatewayFee.value > 0) {
              String feeLabel = 'Biaya Layanan';
              if (controller.paymentGatewayFeeType.value == 'percentage') {
                feeLabel = 'Biaya Biaya Layanan (${controller.paymentGatewayFeeValue.value}%)';
              }
              return Column(
                children: [
                  _buildSummaryRow(
                    context,
                    feeLabel,
                    Formatter.formatCurrency(controller.paymentGatewayFee.value),
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
          
          Obx(() => controller.discountAmount.value > 0
              ? Column(
                  children: [
                    _buildSummaryRow(
                      context,
                      'Diskon (${controller.selectedDiscount.value?.name ?? ''})',
                      '- ${Formatter.formatCurrency(controller.discountAmount.value)}',
                      isDiscount: true,
                    ),
                    const SizedBox(height: 8),
                  ],
                )
              : const SizedBox.shrink()),
          
          const Divider(height: 24),
          
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
            color: isTotal ? Colors.black87 : (isDiscount ? Colors.red : textTheme),
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            fontSize: isTotal ? 14 : 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isDiscount ? Colors.red : (isTotal ? primary : textTheme),
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
            foregroundColor: theme,
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