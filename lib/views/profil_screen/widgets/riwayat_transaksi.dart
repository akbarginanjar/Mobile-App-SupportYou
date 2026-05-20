import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/riwayat_pelatihan_controller.dart';
import 'package:mobile_supportyou/models/riwayat_pelatihan_model.dart';
import 'package:mobile_supportyou/utils/date_formatter.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';

class RiwayatTransaksi extends StatelessWidget {
  final RiwayatPelatihanController controller;
  
  const RiwayatTransaksi({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
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
                    'Riwayat Pelatihan',
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
          
          const Divider(height: 24),
          
          Obx(() {
            if (controller.isLoading.value && controller.pelatihanList.isEmpty) {
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
            
            if (controller.pelatihanList.isEmpty) {
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
            
            final displayList = controller.pelatihanList.length > 3 
                ? controller.pelatihanList.take(3).toList() 
                : controller.pelatihanList.toList();
            
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = displayList[index];
                return _buildTransactionItem(context, item);
              },
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildTransactionItem(BuildContext context, PelatihanDibeli item) {
    final isOnline = item.typePelatihan == 'online';
    final isOffline = item.typePelatihan == 'offline';
    final formattedDate = DateFormatter.formatDateWithDayAndTime(item.waktu);
    
    return InkWell(
      onTap: () {
        _showDetailDialog(context, item);
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.nama,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.mitra?.nama ?? 'Ahmad Fauzi',
              style: TextStyle(
                fontSize: 12,
                color: textTheme.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: textTheme.withValues(alpha: 0.5)),
                const SizedBox(width: 4),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 11, color: textTheme.withValues(alpha: 0.5)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isOnline 
                        ? primary.withValues(alpha: 0.1) 
                        : (isOffline 
                            ? warning.withValues(alpha: 0.1) 
                            : success.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isOnline ? 'ONLINE' : (isOffline ? 'OFFLINE' : 'PELATIHAN'),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isOnline 
                          ? primary 
                          : (isOffline ? warning : success),
                    ),
                  ),
                ),
              ],
            ),
            if (isOffline && item.tempat != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 12, color: textTheme.withValues(alpha: 0.5)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      item.tempat!,
                      style: TextStyle(fontSize: 11, color: textTheme.withValues(alpha: 0.5)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (isOnline) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.link, size: 12, color: textTheme.withValues(alpha: 0.5)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Link meeting akan dikirim via email',
                      style: TextStyle(fontSize: 11, color: textTheme.withValues(alpha: 0.5)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.vpn_key, size: 12, color: primary),
                  const SizedBox(width: 4),
                  Text(
                    'Kode Akses: ${item.kodeAkses}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _showDetailDialog(BuildContext context, PelatihanDibeli item) {
    final isOnline = item.typePelatihan == 'online';
    final isOffline = item.typePelatihan == 'offline';
    final formattedDate = DateFormatter.formatDateWithDayAndTime(item.waktu);
    
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          item.nama,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                _detailRow('Penyelenggara', item.mitra?.nama ?? '-'),
                const SizedBox(height: 8),
                _detailRow('Tanggal', formattedDate),
                const SizedBox(height: 8),
                if (isOffline && item.tempat != null)
                  _detailRow('Lokasi', item.tempat!),
                if (isOnline)
                  _detailRow('Platform', 'Zoom Meeting / Google Meet'),
                const SizedBox(height: 8),
                _detailRow('Total Bayar', Formatter.formatCurrency(item.hargaFinal ?? item.harga)),
                const Divider(),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Kode Akses',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.kodeAkses,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primary,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _copyToClipboard(item.kodeAkses);
                            },
                            icon: Icon(Icons.copy, color: primary, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
  
  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        const Text(':', style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
  
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    Get.back();
    Get.snackbar(
      'Berhasil',
      'Kode akses disalin',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}