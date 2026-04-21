import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/views/widgets/produk_skeleton.dart';
import 'package:mobile_supportyou/views/widgets/search_field.dart';
import 'package:mobile_supportyou/controllers/pelatihan_controller.dart';
import 'package:mobile_supportyou/views/widgets/produk_card.dart';

class SemuaPelatihanScreen extends StatefulWidget {
  const SemuaPelatihanScreen({super.key});

  @override
  State<SemuaPelatihanScreen> createState() => _SemuaPelatihanScreenState();
}

class _SemuaPelatihanScreenState extends State<SemuaPelatihanScreen> {
  final PelatihanController controller = Get.put(PelatihanController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadPelatihanAll();

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
    search.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    await controller.loadPelatihanAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primary),
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Semua Pelatihan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Koleksi pelatihan tersedia',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
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
          color: primary,
          child: controller.isLoadingAll.value && controller.pelatihanListAll.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primary),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Memuat pelatihan...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : controller.pelatihanListAll.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada pelatihan',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Coba kata kunci lain',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: controller.pelatihanListAll.length +
                          (controller.isMoreLoadingAll.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < controller.pelatihanListAll.length) {
                          final pelatihan = controller.pelatihanListAll[index];
                          return ProdukCard.forPelatihan(pelatihan: pelatihan);
                        } else {
                          return const ProdukSkeleton();
                        }
                      },
                    ),
        );
      }),
    );
  }
}