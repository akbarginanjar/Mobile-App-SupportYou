// lib/views/checkout_screen/voucher.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/payment_model.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class VoucherScreen extends StatelessWidget {
  final List<Discount> discounts;
  final Discount? selectedDiscount;
  final int originalPrice;
  
  const VoucherScreen({
    super.key,
    required this.discounts,
    this.selectedDiscount,
    required this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Pilih Voucher',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Option without discount
          Container(
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
            child: RadioListTile<Discount?>(
              title: const Text(
                'Tidak menggunakan voucher',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                'Kembali ke harga normal',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              value: null,
              groupValue: selectedDiscount,
              onChanged: (value) {
                Get.back(result: value);
              },
              activeColor: primary,
            ),
          ),
          
          // Available discounts
          ...discounts.map((discount) {
            final discountAmount = discount.calculateDiscount(originalPrice);
            final priceAfterDiscount = originalPrice - discountAmount;
            
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
              child: RadioListTile<Discount?>(
                title: Text(
                  discount.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: discount.type == 'percentage' 
                            ? Colors.green[50] 
                            : Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        discount.type == 'percentage' 
                            ? '${discount.value}% OFF' 
                            : 'Potongan ${discount.getFormattedValue()}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: discount.type == 'percentage' 
                              ? Colors.green[700] 
                              : Colors.blue[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Harga asli: ${Formatter.formatCurrency(originalPrice)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Setelah diskon: ${Formatter.formatCurrency(priceAfterDiscount)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                      ),
                    ),
                    if (discount.ownedBy == 'member' && discount.member != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Khusus member: ${discount.member['nama_lengkap']}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
                value: discount,
                groupValue: selectedDiscount,
                onChanged: (value) {
                  Get.back(result: value);
                },
                activeColor: primary,
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}