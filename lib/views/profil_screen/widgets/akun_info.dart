// lib/views/profil_screen/widgets/akun_info.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/profil_controller.dart';

class AkunInfo extends StatelessWidget {
  final ProfilController controller;
  
  const AkunInfo({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Icon(Icons.account_circle_outlined, color: primary, size: 22),
              const SizedBox(width: 8),
              Text(
                'Akun Saya',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          
          // Email
          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: controller.userEmail,
          ),
          
          const SizedBox(height: 16),
          
          // Phone
          _buildInfoRow(
            icon: Icons.phone_android_outlined,
            label: 'No Whatsapp',
            value: controller.userPhone,
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required RxString value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 2),
              Obx(() => Text(
                value.value.isEmpty ? '-' : value.value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )),
            ],
          ),
        ),
      ],
    );
  }
}