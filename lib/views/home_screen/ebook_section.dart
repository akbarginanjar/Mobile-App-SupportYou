import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/controllers/ebook_controller.dart';
import 'package:mobile_supportyou/views/semua_ebook_screen/screen.dart';
import 'package:mobile_supportyou/views/widgets/ebook_card.dart';

class EbookSection extends StatelessWidget {
  const EbookSection({super.key});

  @override
  Widget build(BuildContext context) {
    final EbookController controller = Get.put(EbookController());

    // 🔹 Pastikan memanggil loadEbookHome() untuk home
    controller.loadEbookHome();

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
                'E-Book',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const SemuaEbookScreen());
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

        // Body list ebook
        Obx(() {
          if (controller.isLoadingHome.value && controller.ebookListHome.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.ebookListHome.isEmpty) {
            return const Center(child: Text('Belum ada ebook'));
          }

          return SizedBox(
            height: 291,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.ebookListHome.length,
              itemBuilder: (context, index) {
                final ebook = controller.ebookListHome[index];
                return Container(
                  width: 190,
                  margin: const EdgeInsets.only(left: 8),
                  child: EbookCardVertical(
                    ebook: ebook,
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
