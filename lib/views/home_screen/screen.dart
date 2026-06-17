import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/home_controller.dart';
import 'package:mobile_supportyou/controllers/profil_controller.dart';
import 'package:mobile_supportyou/controllers/main_controller.dart';
import 'package:mobile_supportyou/views/home_screen/hero_section.dart';
import 'package:mobile_supportyou/views/home_screen/kategori.dart';
import 'package:mobile_supportyou/views/home_screen/pelatihan_section.dart';
import 'package:mobile_supportyou/views/home_screen/ebook_section.dart';
import 'package:mobile_supportyou/views/home_screen/blog_section.dart';
import 'package:mobile_supportyou/views/search_screen/screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'https://api-supportyou.kehosting.in/$path';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final profilController = Get.isRegistered<ProfilController>()
        ? Get.find<ProfilController>()
        : Get.put(ProfilController());
    final mainController = Get.find<MainController>();
    
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
                Obx(() {
                  final photoUrl = profilController.userPhoto.value;
                  final name = profilController.userName.value;
                  final initial = (name.isNotEmpty && name != 'Pengguna') ? name[0].toUpperCase() : 'U';
                  
                  return GestureDetector(
                    onTap: () {
                      mainController.changeIndex(2);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: primary.withValues(alpha: 0.1),
                        backgroundImage: photoUrl.isNotEmpty
                            ? NetworkImage(getFullImageUrl(photoUrl))
                            : null,
                        child: photoUrl.isEmpty
                            ? Text(
                                initial,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primary,
                                ),
                              )
                            : null,
                      ),
                    ),
                  );
                }),
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
                const HeroSection(),
                const SizedBox(height: 16),
                const KategoriSection(),
                const SizedBox(height: 20),
                const PelatihanSection(),
                const SizedBox(height: 20),
                const EbookSection(),
                const SizedBox(height: 16),
                const BlogSection(),
                const SizedBox(height: 16),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}