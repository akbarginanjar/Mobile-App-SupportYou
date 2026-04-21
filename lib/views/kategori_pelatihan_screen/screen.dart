// lib/views/pelatihan_by_kategori_screen/screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/pelatihan_controller.dart';
import 'package:mobile_supportyou/views/widgets/produk_card.dart';
import 'package:mobile_supportyou/views/widgets/produk_skeleton.dart';

class PelatihanByKategoriScreen extends StatefulWidget {
  final int kategoriId;
  final String kategoriNama;
  
  const PelatihanByKategoriScreen({
    super.key,
    required this.kategoriId,
    required this.kategoriNama,
  });

  @override
  State<PelatihanByKategoriScreen> createState() => _PelatihanByKategoriScreenState();
}

class _PelatihanByKategoriScreenState extends State<PelatihanByKategoriScreen> {
  final PelatihanController controller = Get.put(PelatihanController());
  
  @override
  void initState() {
    super.initState();
    controller.loadPelatihanByKategori(widget.kategoriId);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          widget.kategoriNama,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primary,
      ),
      body: Obx(() {
        if (controller.isLoadingKategori.value && controller.pelatihanByKategori.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.pelatihanByKategori.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.category_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada pelatihan di kategori ini',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }
        
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: controller.pelatihanByKategori.length,
          itemBuilder: (context, index) {
            final pelatihan = controller.pelatihanByKategori[index];
            return ProdukCard.forPelatihan(pelatihan: pelatihan);
          },
        );
      }),
    );
  }
}