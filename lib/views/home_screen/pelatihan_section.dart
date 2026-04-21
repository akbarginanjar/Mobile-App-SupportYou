import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/pelatihan_controller.dart';
import 'package:mobile_supportyou/views/widgets/produk_card.dart';
import 'package:mobile_supportyou/views/widgets/produk_skeleton.dart';
import 'package:mobile_supportyou/views/widgets/pelatihan_card.dart';
import 'package:mobile_supportyou/views/semua_pelatihan_screen/screen.dart';

class PelatihanSection extends StatelessWidget {
  const PelatihanSection({super.key});

  @override
  Widget build(BuildContext context) {
    final PelatihanController controller = Get.put(PelatihanController());

    // Memanggil loadPelatihanHome() untuk home
    controller.loadPelatihanHome();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pelatihan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const SemuaPelatihanScreen());
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

        // Body list pelatihan
        Obx(() {
          if (controller.isLoadingHome.value && controller.pelatihanListHome.isEmpty) {
            return SizedBox(
              height: 270, // Ditambah untuk ruang shadow
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8), // Tambah padding vertical
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    width: 200,
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
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada pelatihan',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return SizedBox(
            height: 270, // Ditambah dari 250 menjadi 270 untuk ruang shadow
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8), // Tambah padding vertical
              itemCount: controller.pelatihanListHome.length,
              itemBuilder: (context, index) {
                final pelatihan = controller.pelatihanListHome[index];
                return Container(
                  width: 200,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 8,
                    right: index == controller.pelatihanListHome.length - 1 ? 16 : 0,
                  ),
                  child: ProdukCard.forPelatihan(pelatihan: pelatihan)
                );
              },
            ),
          );
        }),
      ],
    );
  }
}