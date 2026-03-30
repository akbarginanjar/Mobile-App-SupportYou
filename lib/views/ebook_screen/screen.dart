import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/ebook_controller.dart';
import 'package:mobile_supportyou/views/ebook_screen/deskripsi_ebook.dart';
import 'package:mobile_supportyou/views/ebook_screen/ebook_spesifikasi.dart';
import 'package:mobile_supportyou/views/ebook_screen/ebook_info.dart';
import 'package:mobile_supportyou/views/ebook_screen/ebook_skeleton.dart';

class EbookScreen extends StatefulWidget {
  final String slug;
  const EbookScreen({super.key, required this.slug});

  @override
  State<EbookScreen> createState() => _EbookScreenState();
}

class _EbookScreenState extends State<EbookScreen> {
  final controller = Get.put(EbookController());

  @override
  void initState() {
    super.initState();
    controller.loadDetailEbook(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primary),
        title: Text(
          'Detail E-Book',
          style: GoogleFonts.montserrat(color: textTheme),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const EbookSkeleton();
        }

        final ebook = controller.detailEbook.value;
        if (ebook == null) {
          return const Center(child: Text('Data tidak ditemukan'));
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover
              Image.network(
                ebook.cover ?? '',
                height: 350,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              // Info penerbit
              EbookInfo(ebook: ebook),

              // Spesifikasi
              EbookSpesifikasi(ebook: ebook),

              // Deskripsi
              EbookDeskripsi(ebook: ebook),

              // Ulasan
              const SizedBox(height: 80),
            ],
          ),
        );
      }),
    );
  }
}
