import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/views/widgets/produk_skeleton.dart';
import 'package:mobile_supportyou/views/widgets/search_field.dart';
import 'package:mobile_supportyou/controllers/pelatihan_controller.dart';
import 'package:mobile_supportyou/views/widgets/pelatihan_card.dart';

class SemuaPelatihanScreen extends StatefulWidget {
  const SemuaPelatihanScreen({super.key});

  @override
  State<SemuaPelatihanScreen> createState() => _SemuaPelatihanScreenState();
}

class _SemuaPelatihanScreenState extends State<SemuaPelatihanScreen> {
  final PelatihanController controller = Get.put(PelatihanController());
  final ScrollController _scrollController = ScrollController();
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 🔹 gunakan fungsi khusus untuk semua pelatihan
    controller.loadPelatihanAll();

    // 👇 listener untuk lazy load
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.loadMorePelatihanAll();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    await controller.loadPelatihanAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme,
        surfaceTintColor: theme,
        iconTheme: IconThemeData(color: primary),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Semua Pelatihan',
              style: GoogleFonts.poppins(
                color: textTheme,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Koleksi pelatihan tersedia',
              style: GoogleFonts.poppins(fontSize: 12),
            ),
          ],
        ),
        bottom: AppBar(
          elevation: 1,
          shadowColor: Colors.black45,
          surfaceTintColor: theme,
          backgroundColor: theme,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: SearchField(
              controller: search,
              hintText: 'Cari pelatihan...',
              onSearch: () {
                controller.searchPelatihanAll(search.text);
              },
            ),
          ),
        ),
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: controller.isLoadingAll.value && controller.pelatihanListAll.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: 0.66,
                  ),
                  // 👇 tambahkan slot ekstra untuk indikator loading bawah
                  itemCount: controller.pelatihanListAll.length +
                      (controller.isMoreLoadingAll.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < controller.pelatihanListAll.length) {
                      final pelatihan = controller.pelatihanListAll[index];
                      return PelatihanCard(
                        pelatihan: pelatihan,
                      );
                    } else {
                      // 👇 indikator loading bawah
                      return const ProdukSkeleton();
                    }
                  },
                ),
        );
      }),
    );
  }
}