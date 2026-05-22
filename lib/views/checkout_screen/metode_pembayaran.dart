// lib/views/checkout_screen/metode_pembayaran.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/payment_model.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class MetodePembayaranScreen extends StatelessWidget {
  final List<PaymentGroup> paymentGroups;
  final PaymentMethod? selectedMethod;
  final int pelatihanHarga;
  
  const MetodePembayaranScreen({
    super.key,
    required this.paymentGroups,
    this.selectedMethod,
    required this.pelatihanHarga,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Pilih Metode Pembayaran',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: paymentGroups.length,
        itemBuilder: (context, index) {
          final group = paymentGroups[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.05),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    group.group,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ),
                ...group.items.map((method) {
                  return RadioListTile<PaymentMethod>(
                    title: Row(
                      children: [
                        if (method.imageUrl != null)
                          Image.network(
                            method.imageUrl!,
                            width: 30,
                            height: 30,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.payment, size: 30, color: Colors.grey[600]);
                            },
                          ),
                        if (method.imageUrl != null) const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                              if (method.fee != null && method.fee! > 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Icon(Icons.info_outline, size: 12, color: Colors.grey[500]),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          _getFeeText(method, pelatihanHarga),
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    subtitle: method.number != null || method.description != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (method.number != null)
                                  Text(
                                    'No. Rekening: ${method.number}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                if (method.description != null)
                                  Text(
                                    method.description!,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                              ],
                            ),
                          )
                        : null,
                    value: method,
                    groupValue: selectedMethod,
                    onChanged: (value) {
                      Get.back(result: value);
                    },
                    activeColor: primary,
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getFeeText(PaymentMethod method, int pelatihanHarga) {
    if (method.feeType == 'percentage') {
      final feeAmount = (pelatihanHarga * (method.feeValue ?? 0) / 100).floor();
      return 'Biaya tambahan + ${method.feeValue}% (${Formatter.formatCurrency(feeAmount)})';
    } else {
      return 'Biaya tambahan + ${Formatter.formatCurrency(method.feeValue ?? 0)}';
    }
  }
}