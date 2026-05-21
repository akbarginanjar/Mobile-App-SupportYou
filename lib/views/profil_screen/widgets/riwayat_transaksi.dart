// lib/views/profil_screen/widgets/riwayat_transaksi.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/riwayat_pelatihan_controller.dart';
import 'package:mobile_supportyou/controllers/ebook_controller.dart';
import 'package:mobile_supportyou/models/riwayat_pelatihan_model.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';
import 'package:mobile_supportyou/utils/date_formatter.dart';

class RiwayatTransaksi extends StatelessWidget {
  final RiwayatPelatihanController pelatihanController;
  
  const RiwayatTransaksi({super.key, required this.pelatihanController});

  @override
  Widget build(BuildContext context) {
    final EbookController ebookController = Get.find<EbookController>();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                  Get.snackbar(
                    'Info',
                    'Fitur lihat semua transaksi akan segera hadir',
                    snackPosition: SnackPosition.BOTTOM,
                  );
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
                selectedTab == 0 ? _buildPelatihanList() : _buildEbookPlaceholder(),
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
          splashColor: isActive ? Colors.white.withValues(alpha: 0.3) : primary.withValues(alpha: 0.2),
          highlightColor: isActive ? Colors.white.withValues(alpha: 0.1) : primary.withValues(alpha: 0.1),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isActive ? primary : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isActive ? primary : Colors.grey[300]!,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : Colors.grey[600],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildPelatihanList() {
    return Obx(() {
      if (pelatihanController.isLoading.value && pelatihanController.pelatihanList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memuat riwayat...'),
              ],
            ),
          ),
        );
      }
      
      if (pelatihanController.pelatihanList.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                Icon(Icons.history_edu, size: 48, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'Belum ada pelatihan yang dibeli',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      }
      
      final displayList = pelatihanController.pelatihanList.length > 2
          ? pelatihanController.pelatihanList.take(2).toList()
          : pelatihanController.pelatihanList.toList();
      
      return Column(
        children: displayList.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Column(
            children: [
              _buildPelatihanItem(item),
              if (index != displayList.length - 1) const Divider(),
            ],
          );
        }).toList(),
      );
    });
  }
  
  Widget _buildPelatihanItem(PelatihanDibeli item) {
    final isOnline = item.typePelatihan == 'online';
    final formattedDate = DateFormatter.formatDateWithDayAndTime(item.waktu);
    
    return InkWell(
      onTap: () => pelatihanController.goToDetail(item),
      borderRadius: BorderRadius.circular(12),
      splashColor: primary.withValues(alpha: 0.1),
      highlightColor: primary.withValues(alpha: 0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nama,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              item.mitra?.nama ?? 'SupportYou Education',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: success.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, size: 14, color: success),
                      const SizedBox(width: 4),
                      Text(
                        'Dibeli',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: success,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isOnline ? primary.withValues(alpha: 0.1) : warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isOnline ? Icons.wifi : Icons.location_on,
                    size: 16,
                    color: isOnline ? primary : warning,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOnline ? 'Kelas Online' : 'Kelas Offline',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isOnline ? primary : warning,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isOnline ? 'Zoom / Google Meet' : (item.tempat ?? 'Lokasi tidak tersedia'),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 6),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: item.kodeAkses));
                Get.snackbar(
                  'Berhasil',
                  'Kode akses disalin',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: success,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      primary.withValues(alpha: 0.08),
                      primary.withValues(alpha: 0.03),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: primary.withValues(alpha: 0.15),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.copy, size: 16, color: primary),
                    const SizedBox(width: 8),
                    Text(
                      'Kode Akses: ${item.kodeAkses}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEbookPlaceholder() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              'Belum ada ebook yang dibeli',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Yuk, beli ebook pertama kamu sekarang!',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}