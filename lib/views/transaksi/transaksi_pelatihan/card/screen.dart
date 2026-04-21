// lib/views/transaksi/transaksi_pelatihan/card/transaksi_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/transaksi_model.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';
import 'package:mobile_supportyou/views/pembayaran/screen.dart';

class TransaksiCard extends StatelessWidget {
  final Transaksi transaksi;

  const TransaksiCard({super.key, required this.transaksi});

  Color _getStatusColor() {
    switch (transaksi.status) {
      case 'pending':
        return const Color(0xFFF59E0B); // Orange
      case 'dibatalkan':
        return const Color(0xFFEF4444); // Red
      case 'expired':
        return const Color(0xFF6B7280); // Gray
      case 'selesai':
        return const Color(0xFF10B981); // Green
      default:
        return const Color(0xFF3B82F6); // Blue
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(
            () => PembayaranScreen(
              idTransaksi: transaksi.id,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Badge - langsung dari API
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  transaksi.status, // Langsung dari API
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // No Invoice
              Text(
                transaksi.noInvoice,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 12),
              
              // Row: Tanggal dan Nominal
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal Transaksi",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          transaksi.waktuTransaksi,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Nominal",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Formatter.formatCurrency(transaksi.totalBayar),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Produk Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Produk",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaksi.item.isNotEmpty ? transaksi.item[0].nama : '-',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (transaksi.item.isNotEmpty)
                      Text(
                        'x${transaksi.item[0].qty}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}