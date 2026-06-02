import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/kategori_controller.dart';
import 'package:mobile_supportyou/views/widgets/kategori_chip.dart';
import 'package:mobile_supportyou/views/search_screen/screen.dart';

class KategoriSection extends StatelessWidget {
  const KategoriSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(KategoriController());
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jelajahi Kategori',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Temukan pelatihan sesuai bidang karir yang kamu tuju',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textTheme.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (controller.isLoading.value) {
            return SizedBox(
              height: 50,
              child: Center(
                child: CircularProgressIndicator(
                  color: primary,
                ),
              ),
            );
          }
          
          final activeCategories = controller.kategoriList.where((k) => k.status).toList();
          
          if (activeCategories.isEmpty) {
            return const SizedBox.shrink();
          }
          
          return SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: activeCategories.length,
              itemBuilder: (context, index) {
                final kategori = activeCategories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: KategoriChip(
                    kategori: kategori,
                    onTap: () {
                      Get.to(() => SearchScreen(
                        initialKategoriId: kategori.id,
                        autoFocus: false,
                      ));
                    },
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