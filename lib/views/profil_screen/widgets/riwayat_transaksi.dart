import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/riwayat_pelatihan_controller.dart';
import 'package:mobile_supportyou/controllers/riwayat_ebook_controller.dart';
import 'package:mobile_supportyou/views/widgets/riwayat_card.dart';
import 'package:mobile_supportyou/views/semua_riwayat_screen/screen.dart';

class RiwayatTransaksi extends StatelessWidget {
  const RiwayatTransaksi({super.key});

  @override
  Widget build(BuildContext context) {
    final RiwayatPelatihanController pelatihanController = Get.put(RiwayatPelatihanController());
    final RiwayatEbookController ebookController = Get.put(RiwayatEbookController());
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: textTheme.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.history_outlined, color: primary, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Riwayat',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => const SemuaRiwayatScreen());
                },
                style: TextButton.styleFrom(foregroundColor: primary),
                child: const Text('Lihat Semua'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            final selectedTab = pelatihanController.currentTab.value;
            return Column(
              children: [
                Row(
                  children: [
                    _buildTabButton(
                      title: 'Pelatihan',
                      isActive: selectedTab == 0,
                      onTap: () => pelatihanController.changeTab(0),
                    ),
                    const SizedBox(width: 12),
                    _buildTabButton(
                      title: 'Ebook',
                      isActive: selectedTab == 1,
                      onTap: () => pelatihanController.changeTab(1),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                selectedTab == 0 ? _buildPelatihanList(pelatihanController) : _buildEbookList(ebookController),
              ],
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildTabButton({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          splashColor: isActive ? theme.withValues(alpha: 0.3) : primary.withValues(alpha: 0.2),
          highlightColor: isActive ? theme.withValues(alpha: 0.1) : primary.withValues(alpha: 0.1),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? primary : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isActive ? primary : textTheme.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? theme : textTheme.withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPelatihanList(RiwayatPelatihanController controller) {
    return Obx(() {
      if (controller.isLoading.value && controller.pelatihanList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        );
      }
      
      if (controller.pelatihanList.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.history_edu,
                  size: 48,
                  color: textTheme.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum ada pelatihan yang dibeli',
                  style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                    color: textTheme.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      
      final displayList = controller.pelatihanList.length > 2
          ? controller.pelatihanList.take(2).toList()
          : controller.pelatihanList.toList();
      
      return Column(
        children: displayList.map((item) {
          return RiwayatCard.forPelatihan(pelatihan: item);
        }).toList(),
      );
    });
  }
  
  Widget _buildEbookList(RiwayatEbookController controller) {
    return Obx(() {
      if (controller.isLoading.value && controller.ebookList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        );
      }
      
      if (controller.ebookList.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.menu_book,
                  size: 48,
                  color: textTheme.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum ada ebook yang dibeli',
                  style: Theme.of(Get.context!).textTheme.bodyMedium?.copyWith(
                    color: textTheme.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      
      final displayList = controller.ebookList.length > 2
          ? controller.ebookList.take(2).toList()
          : controller.ebookList.toList();
      
      return Column(
        children: displayList.map((item) {
          return RiwayatCard.forEbook(ebook: item);
        }).toList(),
      );
    });
  }
}