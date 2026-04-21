// lib/views/transaksi/transaksi_pelatihan/tab_views/pending_tabview.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/transaksi_pelatihan_controller.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_pelatihan/card/screen.dart';

class PendingTabView extends StatelessWidget {
  const PendingTabView({super.key});

  @override
  Widget build(BuildContext context) {
    // Gunakan Get.find, bukan Get.put (karena sudah diinisialisasi di screen.dart)
    final TransaksiPelatihanController controller = Get.find<TransaksiPelatihanController>();
    
    return Obx(() {
      // Loading state
      if (controller.isLoadingPending.value && controller.transaksiPending.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Memuat transaksi...'),
            ],
          ),
        );
      }
      
      // Error state
      if (controller.errorPending.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Gagal memuat transaksi',
              ),
              const SizedBox(height: 8),
              Text(
                controller.errorPending.value,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.loadPending(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Coba Lagi', style: TextStyle(color: textTheme),),
              ),
            ],
          ),
        );
      }
      
      // Empty state
      if (controller.transaksiPending.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_empty, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "Tidak ada transaksi pending",
              ),
            ],
          ),
        );
      }
      
      // Data state
      return RefreshIndicator(
        onRefresh: () => controller.loadPending(),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.transaksiPending.length,
          itemBuilder: (context, index) {
            final transaksi = controller.transaksiPending[index];
            return TransaksiCard(transaksi: transaksi);
          },
        ),
      );
    });
  }
} 