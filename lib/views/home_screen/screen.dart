import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/views/widgets/search_field.dart';
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
                    child: SearchField(
                      controller: search,
                      hintText: 'Cari produk...',
                      onSearch: () {
                        // Get.to(SearchProduk(search: search.text));
                      },
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
                  const KategoriSection(),
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