import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/controllers/pelatihan_controller.dart';
import 'package:mobile_supportyou/views/widgets/pelatihan_card_vertical.dart';

class PelatihanSection extends StatelessWidget {
  final String title;

  const PelatihanSection({
    super.key,
    this.title = "Pelatihan",
  });

  @override
  Widget build(BuildContext context) {
    final PelatihanController controller = Get.put(PelatihanController());

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
                title,
                style: Theme.of(context).textTheme.titleMedium),
              TextButton(
                onPressed: (){},
                child: Row(
                  children: [
                    const Text('Lihat semua'),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Body list pelatihan
        Obx(() {
          if (controller.isLoading.value && controller.pelatihanList.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.pelatihanList.isEmpty) {
            return const Center(child: Text('Belum ada pelatihan'));
          }

          return SizedBox(
            height: 291,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.pelatihanList.length,
              itemBuilder: (context, index) {
                final pelatihan = controller.pelatihanList[index];
                return Container(
                  width: 190,
                  margin: EdgeInsets.only(left: index == 0 ? 8 : 8),
                  child: PelatihanCardVertical(
                    pelatihan: pelatihan,
                    onPress: () {
                      // TODO: navigasi ke detail pelatihan
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
