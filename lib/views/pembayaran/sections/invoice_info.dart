import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/checkout_controller.dart';
import 'package:mobile_supportyou/utils/date_formatter.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class InvoiceInfo extends StatelessWidget {
  final Map<String, dynamic> data;
  final CheckoutController controller;

  const InvoiceInfo({
    super.key,
    required this.data,
    required this.controller,
  });

  String _getStatusText() {
    final status = data['status'] ?? '';
    final statusBayar = data['status_bayar'] ?? '';
    
    if (status == 'pending' && statusBayar == 'belum_lunas') {
      return 'MENUNGGU PEMBAYARAN';
    } else if (statusBayar == 'lunas' && status == 'selesai') {
      return 'PESANAN SELESAI';
    } else if (statusBayar == 'lunas' && status != 'selesai') {
      return 'PEMBAYARAN DITERIMA';
    } else if (status == 'expired') {
      return 'TRANSAKSI KADALUARSA';
    } else if (status == 'dibatalkan') {
      return 'TRANSAKSI DIBATALKAN';
    }
    return 'MENUNGGU PEMBAYARAN';
  }

  IconData _getStatusIcon() {
    final status = data['status'] ?? '';
    final statusBayar = data['status_bayar'] ?? '';
    
    if (status == 'pending' && statusBayar == 'belum_lunas') {
      return Icons.access_time;
    } else if (statusBayar == 'lunas' && status == 'selesai') {
      return Icons.check_circle;
    } else if (statusBayar == 'lunas' && status != 'selesai') {
      return Icons.pending;
    } else if (status == 'expired') {
      return Icons.timer_off;
    } else if (status == 'dibatalkan') {
      return Icons.cancel;
    }
    return Icons.access_time;
  }

  Color _getStatusColor() {
    final status = data['status'] ?? '';
    final statusBayar = data['status_bayar'] ?? '';
    
    if (status == 'pending' && statusBayar == 'belum_lunas') {
      return warning;
    } else if (statusBayar == 'lunas' && status == 'selesai') {
      return success;
    } else if (statusBayar == 'lunas' && status != 'selesai') {
      return primary;
    } else if (status == 'expired') {
      return danger;
    } else if (status == 'dibatalkan') {
      return danger;
    }
    return warning;
  }

  @override
  Widget build(BuildContext context) {
    final totalBayar = data['total_bayar'] ?? 0;
    final noInvoice = data['no_invoice'] ?? '-';
    final waktuTransaksi = data['waktu_transaksi'];
    final statusText = _getStatusText();
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();
    final formattedDate = DateFormatter.formatDateWithMonthNameAndTime(waktuTransaksi);
    
    return Container(
      margin: const EdgeInsets.all(16),
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
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF182234),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/logo/supportyou-logo-co.png',
                            width: 120,
                            height: 40,
                            fit: BoxFit.contain,
                            color: theme,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                'SUPPORTYOU',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: theme,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Platform Pelatihan Online Terpercaya',
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusIcon,
                                size: 14,
                                color: theme,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                statusText,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: theme,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 12, color: theme.withValues(alpha: 0.5)),
                            const SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Divider(color: theme.withValues(alpha: 0.1), thickness: 1),
                const SizedBox(height: 12),
                Text(
                  'Nomor Invoice',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  noInvoice,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'TOTAL HARUS DIBAYAR',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: textTheme,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  Formatter.formatCurrency(totalBayar),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}