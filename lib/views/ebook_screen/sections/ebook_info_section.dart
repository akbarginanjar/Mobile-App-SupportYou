import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';

class EbookInfoSection extends StatelessWidget {
  final Ebook ebook;

  const EbookInfoSection({super.key, required this.ebook});

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
          Text(
            'Informasi Ebook',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 16),
          if (ebook.penulis != null && ebook.penulis!.isNotEmpty) ...[
            _buildInfoRow(
              icon: Icons.person_outline,
              label: 'Penulis',
              value: ebook.penulis!,
            ),
            _buildDivider(),
          ],
          if (ebook.penerbit != null && ebook.penerbit!.isNotEmpty) ...[
            _buildInfoRow(
              icon: Icons.business_outlined,
              label: 'Penerbit',
              value: ebook.penerbit!,
            ),
            _buildDivider(),
          ],
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.calendar_today,
                  label: 'Tahun Terbit',
                  value: ebook.tahunTerbit?.toString() ?? '-',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.description_outlined,
                  label: 'Jumlah Halaman',
                  value: ebook.jumlahHalaman != null ? '${ebook.jumlahHalaman} halaman' : '-',
                ),
              ),
            ],
          ),
          if (ebook.isbn != null && ebook.isbn!.isNotEmpty) ...[
            _buildDivider(),
            _buildInfoRow(
              icon: Icons.numbers,
              label: 'ISBN',
              value: ebook.isbn!,
            ),
          ],
          _buildDivider(),
          _buildInfoRow(
            icon: Icons.language,
            label: 'Bahasa',
            value: 'Indonesia',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: textTheme.withValues(alpha: 0.5)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: textTheme.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: textTheme.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 1,
      color: textTheme.withValues(alpha: 0.08),
    );
  }
}