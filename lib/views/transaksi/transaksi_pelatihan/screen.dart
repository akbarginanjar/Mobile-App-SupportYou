// lib/views/transaksi/transaksi_pelatihan/screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/transaksi_pelatihan_controller.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_pelatihan/tab_views/pending_tabview.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_pelatihan/tab_views/selesai_tabview.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_pelatihan/tab_views/expired_tabview.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_pelatihan/tab_views/dibatalkan_tabview.dart';

class TransaksiPelatihanScreen extends StatelessWidget {
  const TransaksiPelatihanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TransaksiPelatihanController());
    
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            'Transaksi Pelatihan',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          elevation: 0,
          backgroundColor: theme,
          foregroundColor: primary,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: primary,
            labelColor: primary,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Selesai'),
              Tab(text: 'Expired'),
              Tab(text: 'Dibatalkan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PendingTabView(),
            SelesaiTabView(),
            ExpiredTabView(),
            DibatalkanTabView(),
          ],
        ),
      ),
    );
  }
}