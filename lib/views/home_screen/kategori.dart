import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/kategori_controller.dart';
import 'package:mobile_supportyou/views/kategori_pelatihan_screen/screen.dart';

class KategoriSection extends StatelessWidget {
  const KategoriSection({super.key});

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('digital') || name.contains('marketing') || name.contains('e-commerce')) {
      return Icons.shopping_cart_rounded;
    } else if (name.contains('desain') || name.contains('kreatif')) {
      return Icons.design_services_rounded;
    } else if (name.contains('bisnis') || name.contains('kewirausahaan')) {
      return Icons.business_center_rounded;
    } else if (name.contains('pengembangan') || name.contains('diri')) {
      return Icons.psychology_rounded;
    } else if (name.contains('keuangan') || name.contains('investasi')) {
      return Icons.show_chart_rounded;
    }
    return Icons.category_rounded;
  }

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
                  child: FilterChip(
                    label: Text(
                      kategori.namaKategori,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: textTheme.withValues(alpha: 0.8),
                      ),
                    ),
                    avatar: Icon(
                      _getCategoryIcon(kategori.namaKategori),
                      size: 18,
                      color: primary,
                    ),
                    onSelected: (_) {
                      Get.to(() => PelatihanByKategoriScreen(
                        kategoriId: kategori.id,
                        kategoriNama: kategori.namaKategori,
                      ));
                    },
                    backgroundColor: theme,
                    selectedColor: primary.withValues(alpha: 0.1),
                    checkmarkColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: textTheme.withValues(alpha: 0.15),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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