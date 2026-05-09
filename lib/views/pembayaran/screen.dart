import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/checkout_controller.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/models/payment_model.dart';
import 'package:mobile_supportyou/services/komplain_service.dart';
import 'package:mobile_supportyou/views/pembayaran/sections/status_header.dart';
import 'package:mobile_supportyou/views/pembayaran/sections/qris_payment_info.dart';
import 'package:mobile_supportyou/views/pembayaran/sections/virtual_account_info.dart';
import 'package:mobile_supportyou/views/pembayaran/sections/invoice_info.dart';
import 'package:mobile_supportyou/views/pembayaran/sections/product_info.dart';
import 'package:mobile_supportyou/views/pembayaran/sections/order_summary.dart';
import 'package:mobile_supportyou/views/pembayaran/sections/action_buttons.dart';

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

  Future<void> _syncRefundStatus() async {
    if (widget.idTransaksi == null) return;
    await _komplainService.syncRefundStatus(widget.idTransaksi!);
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
      _syncRefundStatus(); 
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
            onPressed: () {
              _controller.getInvoice(widget.idTransaksi);
            },
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
                  onPressed: () {
                    _controller.getInvoice(widget.idTransaksi);
                  },
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
        final items = data['item'] as List? ?? [];
        final item = items.isNotEmpty ? items[0] : null;
        
        final bool isExpired = (status == 'expired');
        final bool showPaymentInfo = (statusBayar == 'belum_lunas' && 
                                      status != 'dibatalkan' && 
                                      status != 'selesai' && 
                                      status != 'expired' && 
                                      refundStatus != 'pending');
        
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusHeader(
                data: data,
                refundStatus: refundStatus,
                controller: _controller,
              ),
              
              if (!isExpired && showPaymentInfo) ...[
                if (metodeBayar == 'payment_gateway' && paymentInfo != null) ...[
                  if (paymentInfo['payment_type'] == 'qris')
                    QrisPaymentInfo(data: data),
                  if (paymentInfo['payment_type'] == 'bank_transfer')
                    VirtualAccountInfo(data: data, controller: _controller),
                ],
                _buildCheckStatusButton(context),
              ],
              
              InvoiceInfo(data: data, controller: _controller),
              ProductInfo(data: data),
              OrderSummary(data: data),
              
              ActionButtons(
                data: data,
                refundStatus: refundStatus,
                transaksiId: transaksiId,
                produkNama: item?['nama'] ?? widget.pelatihan.nama,
                onCancel: () => _showCancelDialog(context, data['no_invoice']),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
  
  Widget _buildCheckStatusButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () => _controller.getInvoice(widget.idTransaksi),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
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