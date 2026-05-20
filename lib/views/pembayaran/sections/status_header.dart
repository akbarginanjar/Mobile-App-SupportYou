import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/checkout_controller.dart';

class StatusHeader extends StatelessWidget {
  final Map<String, dynamic> data;
  final String? refundStatus;
  final CheckoutController controller;

  const StatusHeader({
    super.key,
    required this.data,
    required this.refundStatus,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final status = data['status'] ?? '';
    final statusBayar = data['status_bayar'] ?? '';
    
    if (refundStatus == 'pending') {
      return Container(
        width: double.infinity,
        color: warning.withValues(alpha: 0.1),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.pending_actions, size: 48, color: warning),
            const SizedBox(height: 8),
            Text(
              'Pengajuan Refund',
              style: TextStyle(
                color: warning,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'pending',
              style: TextStyle(
                color: warning,
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
        color: warning.withValues(alpha: 0.1),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.timer_off, size: 48, color: warning),
            const SizedBox(height: 8),
            Text(
              'Transaksi Kadaluarsa',
              style: TextStyle(
                color: warning,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pesanan telah melewati batas waktu pembayaran',
              style: TextStyle(color: warning, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    if (status == 'dibatalkan') {
      return Container(
        width: double.infinity,
        color: danger.withValues(alpha: 0.1),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.cancel, size: 48, color: danger),
            const SizedBox(height: 8),
            Text(
              'Transaksi Dibatalkan',
              style: TextStyle(
                color: danger,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pesanan telah dibatalkan',
              style: TextStyle(color: danger, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    if (statusBayar == 'belum_lunas' && status == 'pending') {
      return Container(
        width: double.infinity,
        color: danger.withValues(alpha: 0.1),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Batas waktu bayar',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textTheme,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer, color: danger, size: 24),
                const SizedBox(width: 8),
                Obx(() => Text(
                  controller.countdown.value.isEmpty ? 'Menghitung...' : controller.countdown.value,
                  style: TextStyle(
                    color: danger,
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
        color: success.withValues(alpha: 0.1),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.check_circle, size: 48, color: success),
            const SizedBox(height: 8),
            Text(
              'Pesanan Selesai',
              style: TextStyle(
                color: success,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Terima kasih telah menggunakan layanan kami',
              style: TextStyle(color: success, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    if (statusBayar == 'lunas' && status != 'selesai') {
      return Container(
        width: double.infinity,
        color: primary.withValues(alpha: 0.1),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.pending, size: 48, color: primary),
            const SizedBox(height: 8),
            Text(
              'Pembayaran Diterima',
              style: TextStyle(
                color: primary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pesanan Anda sedang diproses',
              style: TextStyle(color: primary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    
    return const SizedBox.shrink();
  }
}