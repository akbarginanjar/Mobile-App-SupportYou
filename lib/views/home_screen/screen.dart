import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:skeletonizer/skeletonizer.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/home_controller.dart';
import 'package:mobile_supportyou/views/home_screen/carousel.dart';
import 'package:mobile_supportyou/views/home_screen/ebook_section.dart';
import 'package:mobile_supportyou/views/home_screen/kategori.dart';
import 'package:mobile_supportyou/views/home_screen/pelatihan_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    TextEditingController search = TextEditingController();
    return Scaffold(
      body: RefreshIndicator(
        color: primary,
        backgroundColor: theme,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          // GetProduk.to.refreshState();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: theme,
              surfaceTintColor: theme,
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: false,
              title: SizedBox(
                height: 110,
                width: 160,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Image.asset(
                    'assets/logo/supportyou-logo.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications_none, color: primary),
                  onPressed: () {
                    // Get.to(const NotifikasiScreen());
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border_rounded, color: primary),
                  onPressed: () {
                    // Get.to(WishlistProdukScreen());
                  },
                ),
                const SizedBox(width: 10),
              ],
              bottom: AppBar(
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
                              hintText: 'Cari produk...',
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
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                                borderSide: BorderSide(color: textTheme),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                ),
                                borderSide: BorderSide(color: textTheme),
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
                              // Get.to(SearchProduk(search: search.text));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 7),
                Carousel(  
                  listImage: [
                    "assets/banner/banner.png",
                    "assets/banner/banner2.png",
                    "assets/banner/banner1.png",
                    ]
                  ),
                  const SizedBox(height: 8.0,),
                  const KategoriScreen(),
                  const SizedBox(height: 20.0),
                  const PelatihanSection(),
                  const SizedBox(height: 20.0),
                  const EbookSection(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}