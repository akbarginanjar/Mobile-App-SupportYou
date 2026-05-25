import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';

class EbookDescriptionSection extends StatelessWidget {
  final String deskripsi;

  const EbookDescriptionSection({super.key, required this.deskripsi});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.description_outlined, size: 16, color: primary),
              ),
              const SizedBox(width: 10),
              Text(
                'Tentang Ebook',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            deskripsi,
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: textTheme.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}