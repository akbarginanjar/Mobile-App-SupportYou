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
    controller.loadEbookHome();

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
                        const SizedBox(width: 8),
                        Text(
                          'Ebook Terlaris',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ebook pilihan untuk peningkatan literasi Anda',
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
                  Get.to(() => const SemuaEbookScreen());
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
          if (controller.isLoadingHome.value && controller.ebookListHome.isEmpty) {
            return SizedBox(
              height: 280,
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

          if (controller.ebookListHome.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 48,
                      color: textTheme.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Belum ada e-book',
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
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
              itemCount: controller.ebookListHome.length,
              itemBuilder: (context, index) {
                final ebook = controller.ebookListHome[index];
                return Container(
                  width: 260,
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