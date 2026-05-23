// lib/views/transaksi/transaksi_ebook/tab_views/expired_tabview.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/transaksi_ebook_controller.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_ebook/card/screen.dart';

class ExpiredTabView extends StatefulWidget {
  const ExpiredTabView({super.key});

  @override
  State<ExpiredTabView> createState() => _ExpiredTabViewState();
}

class _ExpiredTabViewState extends State<ExpiredTabView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final TransaksiEbookController controller = Get.find<TransaksiEbookController>();
    
    return Obx(() {
      if (controller.isLoadingExpired.value && controller.transaksiExpired.isEmpty) {
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
      
      if (controller.errorExpired.value.isNotEmpty) {
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
                controller.errorExpired.value,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => controller.loadExpired(),
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
      
      if (controller.transaksiExpired.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_empty, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                "Tidak ada transaksi expired",
              ),
            ],
          ),
        );
      }
      
      return RefreshIndicator(
        onRefresh: () => controller.loadExpired(),
        child: ListView.builder(
          padding: const EdgeInsets.all(12),
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: controller.transaksiExpired.length,
          itemBuilder: (context, index) {
            final transaksi = controller.transaksiExpired[index];
            return TransaksiEbookCard(transaksi: transaksi);
          },
        ),
      );
    });
  }
}