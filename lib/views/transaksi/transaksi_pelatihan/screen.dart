// lib/views/transaksi/transaksi_pelatihan/screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/transaksi_pelatihan_controller.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_pelatihan/tab_views/pending_tabview.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_pelatihan/tab_views/selesai_tabview.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_pelatihan/tab_views/expired_tabview.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_pelatihan/tab_views/dibatalkan_tabview.dart';

class TransaksiPelatihanScreen extends StatefulWidget {
  const TransaksiPelatihanScreen({super.key});

  @override
  State<TransaksiPelatihanScreen> createState() => _TransaksiPelatihanScreenState();
}

class _TransaksiPelatihanScreenState extends State<TransaksiPelatihanScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TransaksiPelatihanController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(TransaksiPelatihanController());
    _tabController = TabController(length: 4, vsync: this);
    
    // Refresh saat tab berubah
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _refreshCurrentTab();
      }
    });
  }

  void _refreshCurrentTab() {
    switch (_tabController.index) {
      case 0:
        _controller.loadPending();
        break;
      case 1:
        _controller.loadSelesai();
        break;
      case 2:
        _controller.loadExpired();
        break;
      case 3:
        _controller.loadDibatalkan();
        break;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          controller: _tabController,
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
      body: TabBarView(
        controller: _tabController,
        children: const [
          PendingTabView(),
          SelesaiTabView(),
          ExpiredTabView(),
          DibatalkanTabView(),
        ],
      ),
    );
  }
}