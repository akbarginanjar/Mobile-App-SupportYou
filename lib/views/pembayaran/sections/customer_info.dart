import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/utils/date_formatter.dart';

class CustomerInfo extends StatelessWidget {
  final Map<String, dynamic> data;

  const CustomerInfo({super.key, required this.data});

  String _getMetodeBayar(String? metode) {
    if (metode == 'payment_gateway') {
      final paymentInfo = data['payment_info'];
      if (paymentInfo != null) {
        if (paymentInfo['payment_type'] == 'qris') {
          return 'QRIS';
        } else if (paymentInfo['payment_type'] == 'bank_transfer') {
          final bankCode = paymentInfo['payment_code']?.toUpperCase() ?? '';
          return 'Virtual Account - $bankCode';
        }
      }
      return 'Payment Gateway';
    }
    return metode ?? '-';
  }

  @override
  Widget build(BuildContext context) {
    final customer = data['customer'];
    final metodeBayar = _getMetodeBayar(data['metode_bayar']);
    final tanggalTransaksi = DateFormatter.formatDateWithDayAndTime(data['waktu_transaksi']);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: textTheme.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'INFORMASI PEMESAN',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: textTheme,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(context, 'Nama', customer?['nama'] ?? '-'),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Email', customer?['email'] ?? '-'),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'WhatsApp', customer?['no_hp'] ?? '-'),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Metode Bayar', metodeBayar),
          const SizedBox(height: 12),
          _buildInfoRow(context, 'Tanggal Transaksi', tanggalTransaksi),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textTheme,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}