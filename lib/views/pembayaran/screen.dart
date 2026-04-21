// lib/views/pembayaran/screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/transaksi_controller.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';
import 'package:mobile_supportyou/views/main_screen/screen.dart';

class PembayaranScreen extends StatelessWidget {
  final int? idTransaksi;
  
  const PembayaranScreen({
    super.key,
    required this.idTransaksi,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TransaksiController());
    controller.getInvoice(idTransaksi);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Detail Pembayaran',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primary,
        actions: [
          IconButton(
            onPressed: () => controller.getInvoice(idTransaksi),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.isError.value || controller.invoiceData.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Gagal memuat detail pembayaran',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.getInvoice(idTransaksi),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Muat Ulang',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        
        final data = controller.invoiceData.value!;
        final status = data['status'] ?? '';
        final statusBayar = data['status_bayar'] ?? '';
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Countdown Timer atau Status Message
              _buildStatusHeader(context, controller, data),
              
              // Payment Info (hanya untuk yang belum lunas dan status pending)
              if (statusBayar == 'belum_lunas' && status == 'pending')
                _buildPaymentInfo(context, data, controller),
              
              // Check Payment Status Button (hanya untuk yang belum lunas dan status pending)
              if (statusBayar == 'belum_lunas' && status == 'pending')
                _buildCheckStatusButton(context, controller, idTransaksi),
              
              // Payment Success Info
              if (statusBayar == 'lunas')
                _buildPaymentSuccessInfo(context),
              
              // Invoice Info
              _buildInvoiceInfo(context, data, controller),
              
              // Product Info
              _buildProductInfo(context, data),
              
              // Order Summary
              _buildOrderSummary(context, data),
              
              // Action Buttons
              _buildActionButtons(context, data, controller),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
  
  Widget _buildStatusHeader(BuildContext context, TransaksiController controller, Map<String, dynamic> data) {
    final status = data['status'] ?? '';
    final statusBayar = data['status_bayar'] ?? '';
    
    // Status Expired
    if (status == 'expired') {
      return Container(
        width: double.infinity,
        color: Colors.orange[50],
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.timer_off, size: 48, color: Colors.orange[700]),
            const SizedBox(height: 8),
            Text(
              'Transaksi Kadaluarsa',
              style: TextStyle(
                color: Colors.orange[700],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pesanan telah melewati batas waktu pembayaran',
              style: TextStyle(color: Colors.orange[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    // Status Dibatalkan
    if (status == 'dibatalkan') {
      return Container(
        width: double.infinity,
        color: Colors.red[50],
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.cancel, size: 48, color: Colors.red[700]),
            const SizedBox(height: 8),
            Text(
              'Transaksi Dibatalkan',
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pesanan telah dibatalkan',
              style: TextStyle(color: Colors.red[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    // Countdown Timer untuk pending payment
    if (statusBayar == 'belum_lunas' && status == 'pending') {
      return Container(
        width: double.infinity,
        color: Colors.red[50],
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Batas waktu bayar',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, color: Colors.red, size: 24),
                const SizedBox(width: 8),
                Obx(() => Text(
                  controller.countdown.value.isEmpty ? 'Menghitung...' : controller.countdown.value,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            ),
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
  
  Widget _buildPaymentInfo(BuildContext context, Map<String, dynamic> data, TransaksiController controller) {
    final paymentInfo = data['payment_info'];
    final metodeBayar = data['metode_bayar'];
    
    if (metodeBayar == 'payment_gateway' && paymentInfo != null && paymentInfo['payment_type'] == 'bank_transfer') {
      final vaNumbers = paymentInfo['payment_detail']?['va_numbers'];
      final vaNumber = vaNumbers != null && vaNumbers.isNotEmpty ? vaNumbers[0]['va_number'] : '-';
      final bankCode = paymentInfo['payment_code']?.toUpperCase() ?? '-';
      
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
            Text(
              'Virtual Account',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Silahkan transfer ke Virtual Account berikut',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            
            // 🔥 Menggunakan ListTile dengan ukuran lebih kecil
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  // Bank Code (kiri)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      bankCode,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // VA Number (tengah - flexibel)
                  Expanded(
                    child: Text(
                      vaNumber,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      softWrap: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Tombol Salin (kanan)
                  OutlinedButton(
                    onPressed: () => controller.copyToClipboard(vaNumber),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      minimumSize: const Size(60, 32),
                    ),
                    child: Text(
                      'SALIN',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
  
  Widget _buildCheckStatusButton(BuildContext context, TransaksiController controller, int? idTransaksi) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => controller.getInvoice(idTransaksi),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Cek Status Pembayaran',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
  
  Widget _buildPaymentSuccessInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.green[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 48),
          const SizedBox(height: 8),
          Text(
            'Pembayaran Berhasil',
            style: TextStyle(
              color: Colors.green[800],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Pesanan Anda sedang diproses',
            style: TextStyle(color: Colors.green[600]),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInvoiceInfo(BuildContext context, Map<String, dynamic> data, TransaksiController controller) {
    // Cek apakah toko ada dan memiliki nama yang valid
    final bool hasToko = data['toko'] != null && 
                         data['toko'] is Map && 
                         (data['toko']['nama_lengkap'] != null || data['toko']['nama'] != null);
    
    final String? penjual = hasToko 
        ? (data['toko']['nama_lengkap'] ?? data['toko']['nama']).toString()
        : null;
    
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
          Text(
            'INVOICE',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['no_invoice'] ?? '-',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => controller.copyToClipboard(data['no_invoice'] ?? '-'),
                icon: Icon(Icons.copy, size: 18, color: primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL TAGIHAN',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  Formatter.formatCurrency(data['total_bayar'] ?? 0),
                  style: TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          
          // DITERBITKAN ATAS NAMA (hanya jika ada)
          if (hasToko && penjual != null && penjual.isNotEmpty && penjual != 'null') ...[
            const SizedBox(height: 16),
            Text(
              'DITERBITKAN ATAS NAMA',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              penjual,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ],
          
          const SizedBox(height: 16),
          
          Text(
            'UNTUK',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          _buildInfoRow(context, 'Pembeli', data['customer']?['nama']),
          _buildInfoRow(context, 'Tanggal Pembelian', data['waktu_transaksi']),
          _buildInfoRow(context, 'No. Telepon', data['customer']?['no_hp']),
          _buildInfoRow(context, 'Alamat Pembelian', data['customer']?['data_pengiriman']?['alamat'] ?? '-'),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(BuildContext context, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            ': ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductInfo(BuildContext context, Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
          Text(
            'INFO PELATIHAN',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'PELATIHAN',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'QTY',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'HARGA',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'TOTAL',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey[300]),
          
          ...(data['item'] as List?)?.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      item['nama'] ?? '-',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${item['qty']}',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      Formatter.formatCurrency(item['harga'] ?? 0),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      Formatter.formatCurrency(item['total_harga'] ?? 0),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }).toList() ?? [],
        ],
      ),
    );
  }
  
  Widget _buildOrderSummary(BuildContext context, Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          Text(
            'RINGKASAN BELANJA',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(context, 'TOTAL HARGA', Formatter.formatCurrency(data['total_harga'] ?? 0)),
          const SizedBox(height: 8),
          _buildSummaryRow(context, 'BIAYA LAYANAN', Formatter.formatCurrency(data['biaya_layanan'] ?? 0)),
          const SizedBox(height: 8),
          _buildSummaryRow(context, 'BIAYA APLIKASI', Formatter.formatCurrency(data['biaya_aplikasi'] ?? 0)),
          const SizedBox(height: 8),
          _buildSummaryRow(context, 'BIAYA TRANSAKSI', Formatter.formatCurrency(data['biaya_pg'] ?? 0)),
          
          Divider(color: Colors.grey[300], height: 24),
          
          _buildSummaryRow(context, 'TOTAL BELANJA', Formatter.formatCurrency(data['total_bayar'] ?? 0), isBold: true),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(BuildContext context, String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons(BuildContext context, Map<String, dynamic> data, TransaksiController controller) {
    final status = data['status'] ?? '';
    final statusBayar = data['status_bayar'] ?? '';
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Tombol Batalkan Pesanan (hanya untuk status pending)
          if (status == 'pending' && statusBayar == 'belum_lunas')
            ElevatedButton(
              onPressed: () {
                _showCancelDialog(context, controller, data['no_invoice']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(
                'Batalkan Pesanan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Get.offAll(() => const MainScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(
              'Lihat Pesanan Saya',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showCancelDialog(BuildContext context, TransaksiController controller, String noInvoice) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Batalkan Pesanan',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          'Apakah Anda yakin ingin membatalkan pesanan ini?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Tidak',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await controller.batalkanPesanan(noInvoice);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(
              'Ya, Batalkan',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}