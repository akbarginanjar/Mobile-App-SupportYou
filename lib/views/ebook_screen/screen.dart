import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/ebook_controller.dart';
import 'package:mobile_supportyou/views/ebook_screen/sections/ebook_hero_section.dart';
import 'package:mobile_supportyou/views/ebook_screen/sections/ebook_info_section.dart';
import 'package:mobile_supportyou/views/ebook_screen/sections/ebook_price_section.dart';
import 'package:mobile_supportyou/views/ebook_screen/sections/ebook_included_section.dart';
import 'package:mobile_supportyou/views/ebook_screen/sections/ebook_description_section.dart';
import 'package:mobile_supportyou/views/ebook_screen/sections/ebook_buy_button.dart';

class EbookScreen extends StatelessWidget {
  final String slug;
  const EbookScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EbookController());
    controller.loadDetailEbook(slug);

    return Scaffold(
      backgroundColor: theme,
      appBar: AppBar(
        title: Text(
          'Detail E-Book',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        elevation: 0,
        backgroundColor: theme,
        foregroundColor: primary,
      ),
      body: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final ebook = controller.detailEbook.value;
        if (ebook == null) {
          return const Center(child: Text('Data tidak ditemukan'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EbookHeroSection(ebook: ebook),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: EbookPriceSection(
                  harga: ebook.harga ?? 0,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const EbookIncludedSection(),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: EbookInfoSection(ebook: ebook),
              ),
              const SizedBox(height: 12),
              if (ebook.deskripsi.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: EbookDescriptionSection(
                    deskripsi: ebook.deskripsi,
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
      bottomNavigationBar: EbookBuyButton(controller: controller),
    );
  }
}