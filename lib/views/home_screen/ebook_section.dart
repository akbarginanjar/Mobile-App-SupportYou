import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/ebook_controller.dart';
import 'package:mobile_supportyou/views/widgets/produk_card.dart';
import 'package:mobile_supportyou/views/widgets/produk_skeleton.dart';
import 'package:mobile_supportyou/views/semua_ebook_screen/screen.dart';

class EbookSection extends StatelessWidget {
  const EbookSection({super.key});

  @override
  Widget build(BuildContext context) {
    final EbookController controller = Get.put(EbookController());

    // Memanggil loadEbookHome() untuk home
    controller.loadEbookHome();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Section - konsisten dengan PelatihanSection
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'E-Book',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const SemuaEbookScreen());
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

        // Body list ebook
        Obx(() {
          if (controller.isLoadingHome.value && controller.ebookListHome.isEmpty) {
            return SizedBox(
              height: 270, // Sama dengan PelatihanSection
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    width: 200, // Sama dengan lebar card Pelatihan
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

          if (controller.ebookListHome.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada e-book',
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
            height: 270, // Sama dengan PelatihanSection
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              itemCount: controller.ebookListHome.length,
              itemBuilder: (context, index) {
                final ebook = controller.ebookListHome[index];
                return Container(
                  width: 200, // Sama dengan lebar card Pelatihan
                  margin: EdgeInsets.only(
                    left: index == 0 ? 0 : 8,
                    right: index == controller.ebookListHome.length - 1 ? 16 : 0,
                  ),
                  child: ProdukCard.forEbook(ebook: ebook),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}