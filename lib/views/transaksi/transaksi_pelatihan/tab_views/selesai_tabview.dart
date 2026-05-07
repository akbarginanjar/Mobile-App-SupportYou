// lib/views/transaksi/transaksi_pelatihan/tab_views/pending_tabview.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/transaksi_pelatihan_controller.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_pelatihan/card/screen.dart';

class SelesaiTabView extends StatefulWidget {
  const SelesaiTabView({super.key});

  @override
  State<SelesaiTabView> createState() => _SelesaiTabViewState();
}

class _SelesaiTabViewState extends State<SelesaiTabView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final TransaksiPelatihanController controller = Get.find<TransaksiPelatihanController>();
    
    return Obx(() {
      if (controller.isLoadingSelesai.value && controller.transaksiSelesai.isEmpty) {
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
      
      if (controller.errorSelesai.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              const Text(
                'Gagal memuat transaksi',
              ),
              const SizedBox(height: 8),
              Text(
                controller.errorSelesai.value,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.loadSelesai(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }
      
      if (controller.transaksiSelesai.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_empty, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                "Tidak ada transaksi selesai",
              ),
            ],
          ),
        );
      }
      
      return RefreshIndicator(
        onRefresh: () => controller.loadSelesai(),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.transaksiSelesai.length,
          itemBuilder: (context, index) {
            final transaksi = controller.transaksiSelesai[index];
            return TransaksiCard(transaksi: transaksi);
          },
        ),
      );
    });
  }
}