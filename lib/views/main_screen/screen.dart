import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/main_controller.dart';
import 'package:mobile_supportyou/views/home_screen/screen.dart';
import 'package:mobile_supportyou/views/profil_screen/screen.dart';
import 'package:mobile_supportyou/views/transaksi/screen.dart';

import 'package:get_storage/get_storage.dart';
import 'package:mobile_supportyou/views/login_nohp_screen/screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const PilihTransaksiScreen(),
    const Center(child: Text("Halaman Keranjang")),
    const ProfilScreen(),
    //     Center(
    //   child: SizedBox(
    //     width: 200,
    //     child: ElevatedButton(
    //       onPressed: () {
    //         final box = GetStorage();
    //         box.erase(); // hapus semua data login
    //         Get.offAll(() => LoginNoHpScreen()); // arahkan ke login
    //       },
    //       child: const Text("Logout"),
    //     ),
    //   ),
    // ),

  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      builder: (value) {
        return Scaffold(
          body: _screens[value.index],
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0,
            iconSize: 25,
            type: BottomNavigationBarType.fixed,
            backgroundColor: theme,
            onTap: (v) {
              value.changeIndex(v);
            },
            currentIndex: value.index,
            enableFeedback: true,
            selectedItemColor: primary,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  value.index == 0 ? Icons.home : Icons.home_outlined,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  value.index == 1 ? Icons.shopping_bag : Icons.shopping_bag_outlined,
                ),
                label: 'Pesanan',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  value.index == 2 ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                ),
                label: 'Keranjang',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  value.index == 3 ? Icons.person : Icons.person_outline,
                ),
                label: 'Profil',
              ),
            ],
          ),
        );
      },
    );
  }
}