import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/views/widgets/search_field.dart';
import 'package:mobile_supportyou/controllers/home_controller.dart';
import 'package:mobile_supportyou/views/home_screen/carousel.dart';
import 'package:mobile_supportyou/views/home_screen/ebook_section.dart';
import 'package:mobile_supportyou/views/home_screen/kategori.dart';
import 'package:mobile_supportyou/views/home_screen/pelatihan_section.dart';
import 'package:mobile_supportyou/views/search_screen/screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    
    return Scaffold(
      body: RefreshIndicator(
        color: primary,
        backgroundColor: theme,
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
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
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const SearchScreen(autoFocus: true));
                    },
                    child: Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: theme.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: textTheme.withValues(alpha: 0.1)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, size: 20, color: textTheme.withValues(alpha: 0.5)),
                          const SizedBox(width: 12),
                          Text(
                            'Cari pelatihan...',
                            style: TextStyle(
                              fontSize: 14,
                              color: textTheme.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
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