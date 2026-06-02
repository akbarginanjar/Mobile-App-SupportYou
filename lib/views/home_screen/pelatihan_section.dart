import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/pelatihan_controller.dart';
import 'package:mobile_supportyou/views/widgets/produk_card.dart';
import 'package:mobile_supportyou/views/widgets/produk_skeleton.dart';
import 'package:mobile_supportyou/views/search_screen/screen.dart';

class PelatihanSection extends StatelessWidget {
  const PelatihanSection({super.key});

  @override
  Widget build(BuildContext context) {
    final PelatihanController controller = Get.put(PelatihanController());
    controller.loadPelatihanHome();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.whatshot_rounded,
                          size: 20,
                          color: danger,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Pelatihan Pilihan',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dikurasi khusus berdasarkan permintaan industri terkini',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textTheme.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const SearchScreen(autoFocus: false));
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lihat semua',
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
          if (controller.isLoadingHome.value && controller.pelatihanListHome.isEmpty) {
            return SizedBox(
              height: 315,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    width: 260,
                    margin: EdgeInsets.only(
                      left: index == 0 ? 0 : 8,
                      right: index == 2 ? 16 : 0,
                    ),
                    child: const ProdukSkeleton(),
                  );
                },
              ),
            );
          }

          if (controller.pelatihanListHome.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 48,
                      color: textTheme.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada pelatihan',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textTheme.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SizedBox(
            height: 315,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              itemCount: controller.pelatihanListHome.length,
              itemBuilder: (context, index) {
                final pelatihan = controller.pelatihanListHome[index];
                return Container(
                  width: 260,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 8,
                    right: index == controller.pelatihanListHome.length - 1 ? 16 : 0,
                  ),
                  child: ProdukCard.forPelatihan(pelatihan: pelatihan),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}