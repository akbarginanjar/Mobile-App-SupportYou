import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/checkout_controller.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/models/payment_model.dart';
import 'package:mobile_supportyou/services/komplain_service.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';
import 'package:mobile_supportyou/views/main_screen/screen.dart';
import 'package:mobile_supportyou/views/pembayaran/widgets/komplain_dialog.dart';

class PembayaranScreen extends StatefulWidget {
  final int? idTransaksi;
  final Pelatihan pelatihan;
  final double? discountAmount;
  final String? discountName;
  
  const PembayaranScreen({
    super.key,
    required this.idTransaksi,
    required this.pelatihan,
    this.discountAmount,
    this.discountName,
  });

  @override
  State<PembayaranScreen> createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> with AutomaticKeepAliveClientMixin {
  late CheckoutController _controller;
  final KomplainService _komplainService = KomplainService();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (Get.isRegistered<CheckoutController>()) {
      _controller = Get.find<CheckoutController>();
    } else {
      _controller = Get.put(CheckoutController(pelatihan: widget.pelatihan));
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.discountAmount != null && widget.discountAmount! > 0) {
        _controller.discountAmount.value = widget.discountAmount!.toInt();
        if (widget.discountName != null) {
          final discount = Discount(
            id: 0,
            name: widget.discountName!,
            ownedBy: 'user',
            member: null,
            type: 'nominal',
            value: widget.discountAmount!.toInt(),
          );
          _controller.selectedDiscount.value = discount;
        }
        _controller.calculateTotalPrice();
      }
      
      _controller.getInvoice(widget.idTransaksi);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primary),
          onPressed: () {
            Get.offAll(() => const MainScreen());
          },
        ),
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
            onPressed: () => _controller.getInvoice(widget.idTransaksi),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(() {
        final data = _controller.invoiceData.value;
        
        if (_controller.isInvoiceLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (_controller.isInvoiceError.value || data == null) {
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
                  onPressed: () => _controller.getInvoice(widget.idTransaksi),
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
        
        final status = data['status'] ?? '';
        final statusBayar = data['status_bayar'] ?? '';
        final metodeBayar = data['metode_bayar'] ?? '';
        final paymentInfo = data['payment_info'];
        final int transaksiId = data['id'] ?? 0;
        final refundStatus = _komplainService.getRefundStatus(transaksiId);
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusHeader(context, data, refundStatus),
              
              if (statusBayar == 'belum_lunas' && status != 'dibatalkan' && status != 'selesai' && refundStatus != 'pending') ...[
                if (metodeBayar == 'payment_gateway' && paymentInfo != null) ...[
                  if (paymentInfo['payment_type'] == 'qris')
                    _buildQrisPaymentInfo(context, data),
                  if (paymentInfo['payment_type'] == 'bank_transfer')
                    _buildVirtualAccountInfo(context, data),
                ],
                _buildCheckStatusButton(context),
              ],
              
              _buildInvoiceInfo(context, data),
              _buildProductInfo(context, data),
              _buildOrderSummary(context, data),
              _buildActionButtons(context, data, refundStatus),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
  
  Widget _buildStatusHeader(BuildContext context, Map<String, dynamic> data, String? refundStatus) {
    final status = data['status'] ?? '';
    final statusBayar = data['status_bayar'] ?? '';
    
    if (refundStatus == 'pending') {
      return Container(
        width: double.infinity,
        color: Colors.orange[50],
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.pending_actions, size: 48, color: Colors.orange[700]),
            const SizedBox(height: 8),
            Text(
              'Pengajuan Refund',
              style: TextStyle(
                color: Colors.orange[700],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'pending',
              style: TextStyle(
                color: Colors.orange[600],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
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
                  _controller.countdown.value.isEmpty ? 'Menghitung...' : _controller.countdown.value,
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
    
    if (statusBayar == 'lunas' && status == 'selesai') {
      return Container(
        width: double.infinity,
        color: Colors.green[50],
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.check_circle, size: 48, color: Colors.green[700]),
            const SizedBox(height: 8),
            Text(
              'Pesanan Selesai',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Terima kasih telah menggunakan layanan kami',
              style: TextStyle(color: Colors.green[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    if (statusBayar == 'lunas' && status != 'selesai') {
      return Container(
        width: double.infinity,
        color: Colors.blue[50],
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.pending, size: 48, color: Colors.blue[700]),
            const SizedBox(height: 8),
            Text(
              'Pembayaran Diterima',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pesanan Anda sedang diproses',
              style: TextStyle(color: Colors.blue[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
  
  Widget _buildQrisPaymentInfo(BuildContext context, Map<String, dynamic> data) {
    final paymentInfo = data['payment_info'];
    final qrisUrl = paymentInfo?['payment_detail']?['qris_url'];
    final totalBayar = data['total_bayar'] ?? 0;
    
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
            'QRIS',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Silakan scan QR Code (QRIS) berikut',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: qrisUrl != null && qrisUrl.isNotEmpty
                  ? Image.network(
                      qrisUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.qr_code,
                            size: 80,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.qr_code,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Total yang harus dibayar:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Formatter.formatCurrency(totalBayar),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVirtualAccountInfo(BuildContext context, Map<String, dynamic> data) {
    final paymentInfo = data['payment_info'];
    final vaNumbers = paymentInfo?['payment_detail']?['va_numbers'];
    final vaNumber = vaNumbers != null && vaNumbers.isNotEmpty ? vaNumbers[0]['va_number'] : '-';
    final bankCode = paymentInfo?['payment_code']?.toUpperCase() ?? '-';
    final totalBayar = data['total_bayar'] ?? 0;
    
    String bankName = '';
    Color bankColor = primary;
    
    switch (bankCode.toLowerCase()) {
      case 'bca':
        bankName = 'BCA';
        bankColor = const Color(0xFF0066AA);
        break;
      case 'bni':
        bankName = 'BNI';
        bankColor = const Color(0xFF0055A4);
        break;
      case 'bri':
        bankName = 'BRI';
        bankColor = const Color(0xFF0066CC);
        break;
      case 'mandiri':
        bankName = 'Mandiri';
        bankColor = const Color(0xFF0055A4);
        break;
      default:
        bankName = bankCode;
        bankColor = primary;
    }
    
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bankColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.account_balance, color: bankColor, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Bank $bankName',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Silakan transfer ke Virtual Account berikut',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: bankColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: bankColor.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Virtual Account',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: bankColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        bankName,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        vaNumber,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: bankColor,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => _controller.copyToClipboard(vaNumber),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: bankColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        minimumSize: const Size(60, 36),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.copy, size: 16, color: bankColor),
                          const SizedBox(width: 4),
                          Text(
                            'SALIN',
                            style: TextStyle(
                              color: bankColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, size: 20, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Total yang harus ditransfer:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Formatter.formatCurrency(totalBayar),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCheckStatusButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => _controller.getInvoice(widget.idTransaksi),
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
  
  Widget _buildInvoiceInfo(BuildContext context, Map<String, dynamic> data) {
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
                onPressed: () => _controller.copyToClipboard(data['no_invoice'] ?? '-'),
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
          
          if (hasToko && penjual != null && penjual.isNotEmpty && penjual != 'null') ...[
            const SizedBox(height: 16),
            Text(
              'DITERBITKAN ATAS NAMA',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            ': ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value ?? '-',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProductInfo(BuildContext context, Map<String, dynamic> data) {
    final items = data['item'] as List? ?? [];
    
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
            'INFO PRODUK',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'PRODUK',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'QTY',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'HARGA',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'TOTAL',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          Divider(color: Colors.grey[300]),
          
          for (final item in items)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      item['nama'] ?? '-',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${item['qty']}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      Formatter.formatCurrency(item['harga'] ?? 0),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
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
            ),
        ],
      ),
    );
  }
  
  Widget _buildOrderSummary(BuildContext context, Map<String, dynamic> data) {
    final items = data['item'] as List? ?? [];
    final item = items.isNotEmpty ? items[0] : null;
    
    final hargaPelatihan = item?['total_harga'] ?? item?['harga'] ?? 0;
    final biayaLayanan = data['biaya_layanan'] ?? 0;
    final biayaAplikasi = data['biaya_aplikasi'] ?? 0;
    final totalBayar = data['total_bayar'] ?? 0;
    
    final diskon = (hargaPelatihan + biayaLayanan + biayaAplikasi) - totalBayar;
    
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
            ),
          ),
          const SizedBox(height: 12),
          
          _buildSummaryRow(context, 'HARGA PELATIHAN', Formatter.formatCurrency(hargaPelatihan)),
          const SizedBox(height: 8),
          
          _buildSummaryRow(context, 'BIAYA LAYANAN', Formatter.formatCurrency(biayaLayanan)),
          const SizedBox(height: 8),
          
          _buildSummaryRow(context, 'BIAYA APLIKASI', Formatter.formatCurrency(biayaAplikasi)),
          const SizedBox(height: 8),
          
          const Divider(color: Colors.grey, thickness: 0.5),
          const SizedBox(height: 8),
          
          if (diskon > 0) ...[
            _buildSummaryRow(
              context, 
              'DISKON', 
              '- ${Formatter.formatCurrency(diskon)}',
              isDiscount: true,
            ),
            const SizedBox(height: 8),
          ],
          
          const Divider(color: Colors.grey, thickness: 0.5),
          const SizedBox(height: 8),
          
          _buildSummaryRow(
            context, 
            'TOTAL BELANJA', 
            Formatter.formatCurrency(totalBayar), 
            isTotal: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(BuildContext context, String label, String value, {
    bool isTotal = false, 
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDiscount ? Colors.red : (isTotal ? Colors.black87 : textTheme),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDiscount ? Colors.red : (isTotal ? primary : textTheme),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 13,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons(BuildContext context, Map<String, dynamic> data, String? refundStatus) {
    final status = data['status'] ?? '';
    final statusBayar = data['status_bayar'] ?? '';
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (status == 'pending' && statusBayar == 'belum_lunas')
            ElevatedButton(
              onPressed: () {
                _showCancelDialog(context, data['no_invoice']);
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
          
          if (status == 'selesai' && statusBayar == 'lunas' && refundStatus != 'pending')
            ElevatedButton.icon(
              onPressed: () {
                final items = data['item'] as List? ?? [];
                final item = items.isNotEmpty ? items[0] : null;
                
                Get.dialog(
                  KomplainDialog(
                    transaksiId: data['id'] ?? 0,
                    transaksiNoInvoice: data['no_invoice'] ?? '-',
                    produkNama: item?['nama'] ?? widget.pelatihan.nama,
                  ),
                  barrierDismissible: false,
                );
              },
              icon: const Icon(Icons.report_problem_outlined, color: Colors.white),
              label: Text(
                'Komplain',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
        ],
      ),
    );
  }
  
  void _showCancelDialog(BuildContext context, String noInvoice) {
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
              await _controller.batalkanPesanan(noInvoice);
              _controller.getInvoice(widget.idTransaksi);
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