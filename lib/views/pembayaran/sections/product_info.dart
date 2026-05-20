import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class ProductInfo extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProductInfo({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final items = data['item'] as List? ?? [];
    final item = items.isNotEmpty ? items[0] : null;
    final mitraNama = data['toko']?['nama_lengkap'] ?? '-';
    
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DETAIL PELATIHAN',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: textTheme,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.school_outlined,
                    color: primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item?['nama'] ?? '-',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        mitraNama,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textTheme,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item?['qty'] ?? 0}x Peserta',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textTheme,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  Formatter.formatCurrency(item?['harga'] ?? 0),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}