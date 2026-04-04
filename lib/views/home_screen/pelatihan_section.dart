import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/controllers/pelatihan_controller.dart';
import 'package:mobile_supportyou/views/widgets/produk_skeleton.dart';
import 'package:mobile_supportyou/views/widgets/pelatihan_card.dart';
import 'package:mobile_supportyou/views/semua_pelatihan_screen/screen.dart';

class PelatihanSection extends StatelessWidget {
  const PelatihanSection({super.key});

  @override
  Widget build(BuildContext context) {
    final PelatihanController controller = Get.put(PelatihanController());

    // 🔹 Pastikan memanggil loadPelatihanHome() untuk home
    controller.loadPelatihanHome();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pelatihan',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const SemuaPelatihanScreen());
                },
                child: Row(
                  children: const [
                    Text('Lihat semua'),
                    Icon(Icons.arrow_forward_ios_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Body list pelatihan
        Obx(() {
          if (controller.isLoadingHome.value && controller.pelatihanListHome.isEmpty) {
            return Container(
              width: 230, 
              margin: const EdgeInsets.only(left: 8),
              child: ProdukSkeleton());
          }

          if (controller.pelatihanListHome.isEmpty) {
            return const Center(child: Text('Belum ada pelatihan'));
          }

          return SizedBox(
            height: 310,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.pelatihanListHome.length,
              itemBuilder: (context, index) {
                final pelatihan = controller.pelatihanListHome[index];
                return Container(
                  width: 230,
                  margin: const EdgeInsets.only(left: 8),
                  child: PelatihanCard(
                    pelatihan: pelatihan,
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