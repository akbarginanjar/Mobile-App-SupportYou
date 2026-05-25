import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';

class EbookIncludedSection extends StatelessWidget {
  const EbookIncludedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<IncludedItem> items = [
      const IncludedItem(icon: Icons.picture_as_pdf, label: 'File PDF ebook'),
      const IncludedItem(icon: Icons.timeline, label: 'Akses seumur hidup'),
      const IncludedItem(icon: Icons.download, label: 'Download langsung'),
      const IncludedItem(icon: Icons.devices, label: 'Baca di semua perangkat'),
    ];

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
              Icon(Icons.check_circle_outline, size: 18, color: primary),
              const SizedBox(width: 8),
              Text(
                'TERMASUK DALAM PEMBELIAN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: items.map((item) => _buildIncludedItem(item)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildIncludedItem(IncludedItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(item.icon, size: 16, color: success),
        const SizedBox(width: 8),
        Text(
          item.label,
          style: TextStyle(
            fontSize: 12,
            color: textTheme.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

class IncludedItem {
  final IconData icon;
  final String label;

  const IncludedItem({required this.icon, required this.label});
}