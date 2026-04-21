// lib/views/semua_ebook_screen/screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/views/widgets/produk_skeleton.dart';
import 'package:mobile_supportyou/views/widgets/search_field.dart';
import 'package:mobile_supportyou/controllers/ebook_controller.dart';
import 'package:mobile_supportyou/views/widgets/produk_card.dart';

class SemuaEbookScreen extends StatefulWidget {
  const SemuaEbookScreen({super.key});

  @override
  State<SemuaEbookScreen> createState() => _SemuaEbookScreenState();
}

class _SemuaEbookScreenState extends State<SemuaEbookScreen> {
  final EbookController controller = Get.put(EbookController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.loadEbookAll();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.loadMoreEbookAll();
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
    await controller.loadEbookAll();
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
              'Semua E-Book',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Koleksi e-book tersedia',
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
              hintText: 'Cari e-book...',
              onSearch: () {
                controller.searchEbookAll(search.text);
              },
            ),
          ),
        ),
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: onRefresh,
          color: primary,
          child: controller.isLoadingAll.value && controller.ebookListAll.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primary),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Memuat e-book...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
              : controller.ebookListAll.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.menu_book_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada e-book',
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
                      itemCount: controller.ebookListAll.length +
                          (controller.isMoreLoadingAll.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < controller.ebookListAll.length) {
                          final ebook = controller.ebookListAll[index];
                          return ProdukCard.forEbook(ebook: ebook);
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