import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/views/search_screen/screen.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, primary.withValues(alpha: 0.8)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Tingkatkan Skill,\nRaih Karir Impianmu',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Platform Pelatihan Edukasi dengan mentor berpengalaman, kurikulum industri, dan bersertifikat.',
            style: TextStyle(
              fontSize: 14,
              color: theme.withValues(alpha: 0.9),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatItem('100+', 'Alumni'),
              const SizedBox(width: 16),
              _buildStatItem('5', 'Pelatihan Aktif'),
              const SizedBox(width: 16),
              _buildStatItem('50+', 'Mitra kami'),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const SearchScreen(autoFocus: true));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme,
              foregroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              elevation: 0,
            ),
            child: const Text(
              'Cari Sekarang',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: theme,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: theme.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}