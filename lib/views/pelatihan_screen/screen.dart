import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/pelatihan_controller.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class PelatihanScreen extends StatelessWidget {
  final String slug; // sebenarnya id
  const PelatihanScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PelatihanController());
    controller.loadDetailPelatihan(slug); // panggil sekali

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Detail Pelatihan',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingDetail.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final pelatihan = controller.detailPelatihan.value;
        if (pelatihan == null) {
          return const Center(child: Text('Data tidak ditemukan'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: pelatihan.cover != null
                      ? Image.network(
                          pelatihan.cover!,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/image/pelatihan_placeholder.jpg',
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/image/pelatihan_placeholder.jpg',
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Judul
              Text(pelatihan.nama,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),

              // Waktu + Tempat (hanya offline)
              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 18),
                  const SizedBox(width: 6),
                  Text(pelatihan.waktu ?? '-',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              if (pelatihan.typePelatihan == "offline") ...[
                Row(
                  children: [
                    const Icon(Icons.place, size: 18),
                    const SizedBox(width: 6),
                    Text(pelatihan.tempat ?? '-',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ],
              const SizedBox(height: 10),

              // Harga
              Text(
                Formatter.formatCurrency(
                    pelatihan.hargaFinal ?? pelatihan.harga),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 10),

              // Apa yang Akan Kamu Dapatkan
              _buildSection(
                context,
                icon: Icons.workspace_premium,
                title: "Apa yang Akan Kamu Dapatkan?",
                body: pelatihan.deskripsi,
              ),

              // Siapa yang Cocok Ikut?
              _buildSection(
                context,
                icon: Icons.group,
                title: "Siapa yang Cocok Ikut?",
                body:
                    "Marketing junior, brand owner, fresh graduate yang ingin mengembangkan karir di bidang ini.",
              ),

              // Experience
              _buildSection(
                context,
                icon: Icons.school,
                title: "Experience yang Akan Kamu Dapatkan",
                body:
                    "Workshop interaktif, studi kasus nyata, akses ke template siap pakai, serta sesi mentoring.",
              ),

              // Pembicara
              _buildSection(
                context,
                icon: Icons.mic,
                title: "Pembicara & Kredibilitas",
                body:
                    "Andi Wijaya – Head of Digital Marketing, Unilever Indonesia. "
                    "10+ tahun pengalaman, telah melatih ratusan marketer, mantan digital lead di Tokopedia.",
              ),

              _buildTestimonialsSection(context),

              const SizedBox(height: 100),
            ],
          ),
        );
      }),

      // Bottom bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: aksi tambah ke keranjang
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_shopping_cart,
                        color: Theme.of(context).colorScheme.secondary),
                    const SizedBox(width: 6),
                    Text(
                      'Keranjang',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color:
                                Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: aksi daftar sekarang
                },
                child: Text(
                  'Daftar Sekarang',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required IconData icon,
      required String title,
      required String body}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
  Widget _buildTestimonialsSection(BuildContext context) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surface,
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul section
        Row(
          children: [
            const Icon(Icons.reviews),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Apa Kata Peserta Sebelumnya",
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: null,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Testimonial 1
        Row(
          children: List.generate(
            5,
            (index) => const Icon(Icons.star,
                color: Colors.amber, size: 18),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "“Materi sangat aplikatif, langsung bisa dipraktekan!”",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          "Sarah Dewi – Marketing Manager",
          style: Theme.of(context).textTheme.bodySmall,
        ),

        const SizedBox(height: 12),

        // Testimonial 2
        Row(
          children: List.generate(
            5,
            (index) => const Icon(Icons.star,
                color: Colors.amber, size: 18),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "“Dapet insight baru soal customer acquisition.”",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          "Rizki Fadillah – Brand Owner",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
  );
}
}