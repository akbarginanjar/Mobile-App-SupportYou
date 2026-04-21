// lib/views/transaksi/transaksi_pelatihan/tab_views/dibatalkan_tabview.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/transaksi_pelatihan_controller.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_pelatihan/card/screen.dart';

class DibatalkanTabView extends StatelessWidget {
  const DibatalkanTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final TransaksiPelatihanController controller = Get.find<TransaksiPelatihanController>();
    
    return Obx(() {
      if (controller.isLoadingDibatalkan.value && controller.transaksiDibatalkan.isEmpty) {
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
      
      if (controller.errorDibatalkan.value.isNotEmpty) {
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
                controller.errorDibatalkan.value,
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.loadDibatalkan(),
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
      
      if (controller.transaksiDibatalkan.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cancel_outlined, size: 64),
              const SizedBox(height: 16),
              Text(
                "Tidak ada transaksi dibatalkan",
              ),
            ],
          ),
        );
      }
      
      return RefreshIndicator(
        onRefresh: () => controller.loadDibatalkan(),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.transaksiDibatalkan.length,
          itemBuilder: (context, index) {
            final transaksi = controller.transaksiDibatalkan[index];
            return TransaksiCard(transaksi: transaksi);
          },
        ),
      );
    });
  }
}