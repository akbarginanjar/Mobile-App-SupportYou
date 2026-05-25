import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class EbookPriceSection extends StatelessWidget {
  final int harga;

  const EbookPriceSection({super.key, required this.harga});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textTheme.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: textTheme.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Harga E-Book',
                style: TextStyle(
                  fontSize: 11,
                  color: textTheme.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Formatter.formatCurrency(harga),
                style: TextStyle(
                  color: primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: success.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_outlined,
                  size: 14,
                  color: success,
                ),
                const SizedBox(width: 4),
                Text(
                  'Garansi uang kembali 7 hari',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: success,
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