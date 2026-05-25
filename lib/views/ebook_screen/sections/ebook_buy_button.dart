import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/ebook_controller.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/views/checkout_screen/screen.dart';

class EbookBuyButton extends StatelessWidget {
  final EbookController controller;

  const EbookBuyButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingDetail.value || controller.detailEbook.value == null) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme,
            boxShadow: [
              BoxShadow(
                color: textTheme.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: textTheme.withValues(alpha: 0.3),
                foregroundColor: theme,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: null,
              child: Text(
                'Memuat...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme,
                ),
              ),
            ),
          ),
        );
      }

      final ebook = controller.detailEbook.value!;

      final pelatihan = Pelatihan(
        id: ebook.id,
        nama: ebook.nama,
        slug: ebook.slug,
        deskripsi: ebook.deskripsi,
        harga: ebook.harga ?? 0,
        hargaFinal: null,
        tempat: null,
        waktu: null,
        cover: ebook.cover,
        type: 'ebook',
        typePelatihan: null,
        maxPeserta: null,
        mitra: Mitra(
          id: 81,
          nama: 'SupportYou Education',
          memberId: 81,
        ),
        sections: [],
        testimonials: [],
        speaker: null,
        tokoMemberId: 81,
        penulis: ebook.penulis,
        penerbit: ebook.penerbit,
        tahunTerbit: ebook.tahunTerbit,
        jumlahHalaman: ebook.jumlahHalaman,
        isbn: ebook.isbn,
      );

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme,
          boxShadow: [
            BoxShadow(
              color: textTheme.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: theme,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: () {
              Get.to(() => CheckoutScreen(pelatihan: pelatihan));
            },
            child: Text(
              'Beli Sekarang',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme,
              ),
            ),
          ),
        ),
      );
    });
  }
}