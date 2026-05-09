import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/checkout_controller.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class InvoiceInfo extends StatelessWidget {
  final Map<String, dynamic> data;
  final CheckoutController controller;

  const InvoiceInfo({
    super.key,
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
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
}