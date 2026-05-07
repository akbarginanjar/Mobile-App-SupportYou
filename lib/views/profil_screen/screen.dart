// lib/views/profil_screen/screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/views/profil_screen/widgets/profil_header.dart';
import 'package:mobile_supportyou/views/profil_screen/widgets/stats_card.dart';
import 'package:mobile_supportyou/views/profil_screen/widgets/riwayat_transaksi.dart';
import 'package:mobile_supportyou/views/profil_screen/widgets/akun_info.dart';
import 'package:mobile_supportyou/controllers/profil_controller.dart';
import 'package:mobile_supportyou/controllers/riwayat_pelatihan_controller.dart';
import 'package:mobile_supportyou/views/profil_screen/edit_profil.dart';
import 'package:mobile_supportyou/views/profil_screen/ganti_password.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfilController controller = Get.put(ProfilController());
    final RiwayatPelatihanController riwayatController = Get.put(RiwayatPelatihanController());
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
          await riwayatController.refreshData();
        },
        color: primary,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: primary,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primary,
                        primary.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: ProfilHeader(controller: controller),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.white),
                  onPressed: () async {
                    final result = await Get.to(() => const EditProfilScreen());
                    if (result == true) {
                      controller.refreshData();
                      riwayatController.refreshData();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout_outlined, color: Colors.white),
                  onPressed: () => _showLogoutDialog(controller),
                ),
              ],
            ),
            
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                StatsCard(controller: controller),
                const SizedBox(height: 16),
                AkunInfo(controller: controller),
                const SizedBox(height: 16),
                _buildMenuButtons(context),
                const SizedBox(height: 16),
                // 🔥 PERBAIKAN: Gunakan riwayatController, bukan controller
                RiwayatTransaksi(controller: riwayatController),
                const SizedBox(height: 80),
              ]),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMenuButtons(BuildContext context) {
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
        children: [
          _buildMenuItem(
            context,
            icon: Icons.person_outline,
            title: 'Edit Profil',
            subtitle: 'Ubah nama, email, dan nomor telepon',
            onTap: () async {
              final result = await Get.to(() => const EditProfilScreen());
              if (result == true) {
                Get.find<ProfilController>().refreshData();
                Get.find<RiwayatPelatihanController>().refreshData();
              }
            },
          ),
          const Divider(),
          _buildMenuItem(
            context,
            icon: Icons.lock_outline,
            title: 'Ganti Password',
            subtitle: 'Perbarui password akun Anda',
            onTap: () async {
              final result = await Get.to(() => const GantiPasswordScreen());
              if (result == true) {
                Get.snackbar(
                  'Berhasil',
                  'Password berhasil diubah',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
          ),
        ],
      ),
    );
  }
  
  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: primary, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
  
  void _showLogoutDialog(ProfilController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}