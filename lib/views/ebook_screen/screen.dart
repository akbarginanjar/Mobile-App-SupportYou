import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/ebook_controller.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class EbookScreen extends StatefulWidget {
  final String slug; // sebenarnya id
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Detail E-Book',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover full width dengan shadow
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
                  child: Image.network(
                    ebook.cover ?? 'https://removal.ai/wp-content/uploads/2021/02/no-img.png',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Judul
              Text(
                ebook.nama ?? '-',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),

              // Harga
              Text(
                Formatter.formatCurrency(ebook.harga),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),

              // Divider
              const SizedBox(height: 10),
              Divider(color: Colors.grey[300]),
              const SizedBox(height: 10),

              // Info dengan label manual lebih tebal
              Text("Penulis: ${ebook.penulis ?? '-'}",
                  style: Theme.of(context).textTheme.bodyMedium),
              Text("Penerbit: ${ebook.penerbit ?? '-'}",
                  style: Theme.of(context).textTheme.bodyMedium),
              Text("Tahun Terbit: ${ebook.tahunTerbit ?? '-'}",
                  style: Theme.of(context).textTheme.bodyMedium),
              Text("Jumlah Halaman: ${ebook.jumlahHalaman ?? '-'} halaman",
                  style: Theme.of(context).textTheme.bodyMedium),
              Text("ISBN: ${ebook.isbn ?? '-'}",
                  style: Theme.of(context).textTheme.bodyMedium),
              Text("Type: ${ebook.type ?? '-'}",
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              // Deskripsi
              Text(
                "Deskripsi",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 5),
              Text(
                ebook.deskripsi ?? 'Tidak ada deskripsi',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 100), // ruang agar tidak ketutup bottom bar
            ],
          ),
        );
      }),

      // 🔹 Bottom bar dengan 2 tombol
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
                  side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: aksi tambah ke keranjang
                },
                child: Text(
                  'Tambah ke Keranjang',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // TODO: aksi beli sekarang
                },
                child: Text(
                  'Beli Sekarang',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
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
}
