import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/pelatihan_controller.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/utils/image_helper.dart';
import 'package:mobile_supportyou/views/checkout_screen/screen.dart';
import 'package:mobile_supportyou/views/pelatihan_screen/sections/hero_section.dart';
import 'package:mobile_supportyou/views/pelatihan_screen/sections/info_section.dart';
import 'package:mobile_supportyou/views/pelatihan_screen/sections/price_section.dart';
import 'package:mobile_supportyou/views/pelatihan_screen/sections/included_section.dart';
import 'package:mobile_supportyou/views/pelatihan_screen/sections/schedule_section.dart';
import 'package:mobile_supportyou/views/pelatihan_screen/sections/curriculum_section.dart';
import 'package:mobile_supportyou/views/pelatihan_screen/sections/description_section.dart';
import 'package:mobile_supportyou/views/pelatihan_screen/sections/speaker_section.dart';
import 'package:mobile_supportyou/views/pelatihan_screen/sections/testimonial_section.dart';

class PelatihanScreen extends StatelessWidget {
  final String slug;
  const PelatihanScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PelatihanController());
    controller.loadDetailPelatihan(slug);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Detail Pelatihan',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primary,
      ),
      body: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final pelatihan = controller.detailPelatihan.value;
        if (pelatihan == null) {
          return const Center(child: Text('Data tidak ditemukan'));
        }

        final targetSection = pelatihan.sections.firstWhere(
          (section) => section.type == 'target',
          orElse: () => Section(title: '', content: '', type: ''),
        );
        
        final experienceSection = pelatihan.sections.firstWhere(
          (section) => section.type == 'experience',
          orElse: () => Section(title: '', content: '', type: ''),
        );

        final String coverImageUrl = ImageHelper.getFullImageUrl(pelatihan.cover);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroSection(
                pelatihan: pelatihan,
                coverImageUrl: coverImageUrl,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: InfoSection(
                  nama: pelatihan.nama,
                  deskripsi: pelatihan.deskripsi,
                  typePelatihan: pelatihan.typePelatihan ?? 'online',
                  waktu: pelatihan.waktu,
                  tempat: pelatihan.tempat,
                  maxPeserta: pelatihan.maxPeserta ?? 0,
                  speakerName: pelatihan.speaker?.name ?? 'SupportYou',
                  speakerPosition: pelatihan.speaker?.position,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PriceSection(
                  hargaFinal: pelatihan.hargaFinal ?? pelatihan.harga,
                  hargaAsli: pelatihan.harga,
                ),
              ),
              const SizedBox(height: 12),
              if (pelatihan.batches.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ScheduleSection(
                    startTime: pelatihan.startTime,
                    endTime: pelatihan.endTime,
                    batches: pelatihan.batches,
                  ),
                ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const IncludedSection(),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    if (experienceSection.content.isNotEmpty)
                      DescriptionSection(
                        icon: Icons.school_outlined,
                        title: "Yang akan kamu pelajari",
                        content: experienceSection.content,
                      ),
                    if (pelatihan.deskripsi != null && pelatihan.deskripsi!.isNotEmpty)
                      DescriptionSection(
                        icon: Icons.description_outlined,
                        title: "Tentang Pelatihan",
                        content: pelatihan.deskripsi!,
                      ),
                    if (targetSection.content.isNotEmpty)
                      DescriptionSection(
                        icon: Icons.people_outline,
                        title: "Target Peserta",
                        content: targetSection.content,
                      ),
                    CurriculumSection(sections: pelatihan.sections),
                    if (pelatihan.speaker != null)
                      SpeakerSection(speaker: pelatihan.speaker!),
                    if (pelatihan.testimonials.isNotEmpty)
                      TestimonialSection(testimonials: pelatihan.testimonials),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final pelatihan = controller.detailPelatihan.value;
        if (pelatihan == null) return const SizedBox.shrink();

        if (controller.hasAccess.value) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: null,
                icon: const Icon(Icons.flash_on, size: 20),
                label: const Text(
                  'Sudah Memiliki Akses',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () {
                Get.to(() => CheckoutScreen(pelatihan: pelatihan));
              },
              icon: const Icon(Icons.flash_on, size: 20),
              label: const Text(
                'Daftar Sekarang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
} 