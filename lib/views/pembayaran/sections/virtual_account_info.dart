import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/checkout_controller.dart';

class VirtualAccountInfo extends StatelessWidget {
  final Map<String, dynamic> data;
  final CheckoutController controller;

  const VirtualAccountInfo({
    super.key,
    required this.data,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final paymentInfo = data['payment_info'];
    final vaNumbers = paymentInfo?['payment_detail']?['va_numbers'];
    final vaNumber = vaNumbers != null && vaNumbers.isNotEmpty ? vaNumbers[0]['va_number'] : '-';
    final bankCode = paymentInfo?['payment_code']?.toUpperCase() ?? '-';

    return Container(
      margin: const EdgeInsets.all(16),
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
            'Virtual Account',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Silakan transfer ke Virtual Account berikut',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textTheme,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Text(
              bankCode,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: textTheme,
                fontSize: 14,
              ),
            ),
            title: Text(
              vaNumber,
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            trailing: OutlinedButton(
              onPressed: () => controller.copyToClipboard(vaNumber),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('SALIN', style: TextStyle(color: primary)),
            ),
          ),
        ],
      ),
    );
  }
}