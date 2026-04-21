// lib/views/home_screen/kategori_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/kategori_controller.dart';
import 'package:mobile_supportyou/views/kategori_pelatihan_screen/screen.dart';

class KategoriSection extends StatelessWidget {
  const KategoriSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KategoriController());
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kategori",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigasi ke halaman semua kategori
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "Lihat Semua",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14,
                      color: primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        Obx(() {
          if (controller.isLoading.value) {
            return SizedBox(
              height: 170,
              child: Center(
                child: CircularProgressIndicator(
                  color: primary,
                ),
              ),
            );
          }
          
          if (controller.kategoriList.isEmpty) {
            return const SizedBox(
              height: 170,
              child: Center(
                child: Text('Tidak ada kategori'),
              ),
            );
          }
          
          // Filter hanya kategori yang statusnya true
          final activeCategories = controller.kategoriList.where((k) => k.status).toList();
          
          if (activeCategories.isEmpty) {
            return const SizedBox(
              height: 170,
              child: Center(
                child: Text('Tidak ada kategori aktif'),
              ),
            );
          }
          
          return SizedBox(
            height: 170,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: activeCategories.length,
              itemBuilder: (context, index) {
                final kategori = activeCategories[index];
                return Container(
                  width: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Get.to(() => PelatihanByKategoriScreen(
                        kategoriId: kategori.id,
                        kategoriNama: kategori.namaKategori,
                      ));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          // Background Image
                          Image.network(
                            kategori.foto,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 170,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 140,
                                height: 170,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                          // Dark Overlay
                          Container(
                            width: 140,
                            height: 170,
                            color: Colors.black.withOpacity(0.4),
                          ),
                          // Text Title
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                kategori.namaKategori,
                                textAlign: TextAlign.center,
                                softWrap: true,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 4,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}