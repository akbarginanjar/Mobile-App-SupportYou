import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class OrderSummary extends StatelessWidget {
  final Map<String, dynamic> data;

  const OrderSummary({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final items = data['item'] as List? ?? [];
    final item = items.isNotEmpty ? items[0] : null;
    
    final hargaPelatihan = item?['total_harga'] ?? item?['harga'] ?? 0;
    final biayaLayanan = data['biaya_layanan'] ?? 0;
    final biayaAplikasi = data['biaya_aplikasi'] ?? 0;
    final totalBayar = data['total_bayar'] ?? 0;
    
    final diskon = (hargaPelatihan + biayaLayanan + biayaAplikasi) - totalBayar;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            'RINGKASAN BELANJA',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildSummaryRow(context, 'HARGA PELATIHAN', Formatter.formatCurrency(hargaPelatihan)),
          const SizedBox(height: 8),
          
          _buildSummaryRow(context, 'BIAYA LAYANAN', Formatter.formatCurrency(biayaLayanan)),
          const SizedBox(height: 8),
          
          if (diskon > 0) ...[
            _buildSummaryRow(
              context, 
              'DISKON', 
              '- ${Formatter.formatCurrency(diskon)}',
              isDiscount: true,
            ),
            const SizedBox(height: 8),
          ],
          
          Divider(color: textTheme, thickness: 0.5),
          const SizedBox(height: 8),
          
          _buildSummaryRow(
            context, 
            'TOTAL BELANJA', 
            Formatter.formatCurrency(totalBayar), 
            isTotal: true,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSummaryRow(BuildContext context, String label, String value, {
    bool isTotal = false, 
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isDiscount ? danger : (isTotal ? textTheme : textTheme),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isDiscount ? danger : (isTotal ? primary : textTheme),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 13,
            ),
          ),
        ],
      ),
    );
  }
}