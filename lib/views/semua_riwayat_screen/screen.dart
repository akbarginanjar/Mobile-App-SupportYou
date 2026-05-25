import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/riwayat_pelatihan_controller.dart';
import 'package:mobile_supportyou/controllers/riwayat_ebook_controller.dart';
import 'package:mobile_supportyou/views/widgets/riwayat_card.dart';

class SemuaRiwayatScreen extends StatefulWidget {
  const SemuaRiwayatScreen({super.key});

  @override
  State<SemuaRiwayatScreen> createState() => _SemuaRiwayatScreenState();
}

class _SemuaRiwayatScreenState extends State<SemuaRiwayatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RiwayatPelatihanController pelatihanController = Get.put(RiwayatPelatihanController());
  final RiwayatEbookController ebookController = Get.put(RiwayatEbookController());
  final ScrollController _scrollControllerPelatihan = ScrollController();
  final ScrollController _scrollControllerEbook = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    _scrollControllerPelatihan.addListener(() {
      if (_scrollControllerPelatihan.position.pixels >=
          _scrollControllerPelatihan.position.maxScrollExtent - 200) {
        pelatihanController.loadMore();
      }
    });
    
    _scrollControllerEbook.addListener(() {
      if (_scrollControllerEbook.position.pixels >=
          _scrollControllerEbook.position.maxScrollExtent - 200) {
        ebookController.loadMore();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollControllerPelatihan.dispose();
    _scrollControllerEbook.dispose();
    super.dispose();
  }

  Future<void> _onRefreshPelatihan() async {
    await pelatihanController.refreshData();
  }

  Future<void> _onRefreshEbook() async {
    await ebookController.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme,
      appBar: AppBar(
        backgroundColor: theme,
        surfaceTintColor: theme,
        elevation: 0,
        iconTheme: IconThemeData(color: primary),
        centerTitle: false,
        title: Text(
          'Riwayat Saya',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primary,
          labelColor: primary,
          unselectedLabelColor: textTheme.withValues(alpha: 0.5),
          indicatorSize: TabBarIndicatorSize.label,
          tabs: const [
            Tab(text: 'Pelatihan'),
            Tab(text: 'Ebook'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPelatihanList(),
          _buildEbookList(),
        ],
      ),
    );
  }

  Widget _buildPelatihanList() {
    return RefreshIndicator(
      onRefresh: _onRefreshPelatihan,
      color: primary,
      child: Obx(() {
        if (pelatihanController.isLoading.value && pelatihanController.pelatihanList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                ),
                const SizedBox(height: 16),
                Text(
                  'Memuat riwayat pelatihan...',
                  style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                    color: textTheme.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          );
        }

        if (pelatihanController.pelatihanList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history_edu,
                  size: 64,
                  color: textTheme.withValues(alpha: 0.15),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada pelatihan yang dibeli',
                  style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                    color: textTheme.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yuk, beli pelatihan pertama kamu sekarang!',
                  style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                    color: textTheme.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollControllerPelatihan,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: pelatihanController.pelatihanList.length +
              (pelatihanController.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < pelatihanController.pelatihanList.length) {
              final item = pelatihanController.pelatihanList[index];
              return RiwayatCard.forPelatihan(pelatihan: item);
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
          },
        );
      }),
    );
  }

  Widget _buildEbookList() {
    return RefreshIndicator(
      onRefresh: _onRefreshEbook,
      color: primary,
      child: Obx(() {
        if (ebookController.isLoading.value && ebookController.ebookList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primary),
                ),
                const SizedBox(height: 16),
                Text(
                  'Memuat riwayat ebook...',
                  style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                    color: textTheme.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          );
        }

        if (ebookController.ebookList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.menu_book,
                  size: 64,
                  color: textTheme.withValues(alpha: 0.15),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada ebook yang dibeli',
                  style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                    color: textTheme.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Yuk, beli ebook pertama kamu sekarang!',
                  style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                    color: textTheme.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          controller: _scrollControllerEbook,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: ebookController.ebookList.length +
              (ebookController.isLoadingMore.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < ebookController.ebookList.length) {
              final item = ebookController.ebookList[index];
              return RiwayatCard.forEbook(ebook: item);
            } else {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            }
          },
        );
      }),
    );
  }
}