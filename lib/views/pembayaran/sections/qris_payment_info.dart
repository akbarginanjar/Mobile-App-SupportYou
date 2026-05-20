import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/utils/qr_saver.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class QrisPaymentInfo extends StatelessWidget {
  final Map<String, dynamic> data;
  final int totalFromController;

  const QrisPaymentInfo({
    super.key, 
    required this.data,
    required this.totalFromController,
  });

  @override
  Widget build(BuildContext context) {
    final paymentInfo = data['payment_info'];
    final qrisUrl = paymentInfo?['payment_detail']?['qris_url'];
    final totalBayar = totalFromController;
    
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QRIS',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Silakan scan QR Code (QRIS) berikut',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textTheme,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: textTheme.withValues(alpha: 0.1)),
              ),
              child: qrisUrl != null && qrisUrl.isNotEmpty
                  ? Image.network(
                      qrisUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 200,
                          color: textTheme.withValues(alpha: 0.1),
                          child: const Icon(
                            Icons.qr_code,
                            size: 80,
                            color: Colors.grey,
                          ),
                        );
                      },
                    )
                  : Container(
                      width: 200,
                      height: 200,
                      color: textTheme.withValues(alpha: 0.1),
                      child: const Icon(
                        Icons.qr_code,
                        size: 80,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          if (qrisUrl != null && qrisUrl.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => QRSaver.saveToGallery(qrisUrl),
                icon: const Icon(Icons.download, size: 20),
                label: Text('Simpan QR Code'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: theme,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}