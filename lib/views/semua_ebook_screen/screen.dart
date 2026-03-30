import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/ebook_controller.dart';
import 'package:mobile_supportyou/views/widgets/ebook_card.dart';

class SemuaEbookScreen extends StatefulWidget {
  const SemuaEbookScreen({super.key});

  @override
  State<SemuaEbookScreen> createState() => _SemuaEbookScreenState();
}

class _SemuaEbookScreenState extends State<SemuaEbookScreen> {
  final EbookController controller = Get.put(EbookController());
  final ScrollController _scrollController = ScrollController();
  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 🔹 gunakan fungsi khusus untuk semua e-book
    controller.loadEbookAll();

    // 👇 listener untuk lazy load
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
    super.dispose(); 
  }

  Future<void> onRefresh() async {
    await controller.loadEbookAll();
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
              'Semua E-Book',
              style: GoogleFonts.poppins(
                color: textTheme,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Koleksi e-book tersedia',
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
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: theme,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: search,
                      decoration: InputDecoration(
                        hintText: 'Cari e-book...',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: textTheme,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.search, color: theme, size: 24),
                      onPressed: () {
                        // 🔹 panggil fungsi search di controller
                        controller.searchEbookAll(search.text);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: controller.isLoadingAll.value && controller.ebookListAll.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: 0.68,
                  ),
                  // 👇 tambahkan slot ekstra untuk indikator loading bawah
                  itemCount: controller.ebookListAll.length +
                      (controller.isMoreLoadingAll.value ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < controller.ebookListAll.length) {
                      final ebook = controller.ebookListAll[index];
                      return EbookCardVertical(
                        ebook: ebook,
                        onPress: () {
                          // TODO: navigasi ke detail ebook
                        },
                      );
                    } else {
                      // 👇 indikator loading bawah
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
        );
      }),
    );
  }
}
