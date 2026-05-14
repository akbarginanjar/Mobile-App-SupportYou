import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';

class IncludedSection extends StatelessWidget {
  const IncludedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<IncludedItem> items = [
      IncludedItem(icon: Icons.verified_outlined, label: 'Sertifikat resmi'),
      IncludedItem(icon: Icons.video_call_outlined, label: 'Sesi live online'),
      IncludedItem(icon: Icons.question_answer_outlined, label: 'Sesi tanya jawab'),
      IncludedItem(icon: Icons.support_agent_outlined, label: 'Dukungan mentor profesional'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_outlined, size: 18, color: primary),
              const SizedBox(width: 8),
              Text(
                'TERMASUK DALAM PELATIHAN',
                style: TextStyle(
                  fontSize: 12,
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
        Icon(item.icon, size: 16, color: Colors.green[600]),
        const SizedBox(width: 8),
        Text(
          item.label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class IncludedItem {
  final IconData icon;
  final String label;

  IncludedItem({required this.icon, required this.label});
}