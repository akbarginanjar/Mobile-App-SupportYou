// lib/views/detail_ebook_dibeli/screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/utils/base.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/ebook_dibeli_model.dart';
import 'package:mobile_supportyou/utils/date_formatter.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';
import 'package:mobile_supportyou/utils/image_helper.dart';

class DetailEbookDibeliScreen extends StatelessWidget {
  final EbookDibeli ebook;
  
  const DetailEbookDibeliScreen({super.key, required this.ebook});

  Future<void> _downloadEbook() async {
    if (ebook.fileEbook == null || ebook.fileEbook!.isEmpty) {
      Get.snackbar(
        'Info',
        'File ebook belum tersedia',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final url = '${Base.url}${ebook.fileEbook}';
      final Uri uri = Uri.parse(url);
      final bool success = await launchUrl(uri, mode: LaunchMode.externalApplication);
      
      if (!success) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      Get.dialog(
        AlertDialog(
          title: const Text('Tidak bisa membuka file'),
          content: Text('Silakan coba lagi nanti:\n\n$e'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Tutup'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          ebook.nama,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildDownloadCard(),
            const SizedBox(height: 12),
            _buildInfoCard(),
            const SizedBox(height: 12),
            _buildDeskripsiCard(),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    final coverUrl = ImageHelper.getFullImageUrl(ebook.cover);
    final isFree = ebook.isFree;
    final mitraNama = ebook.mitra?.nama ?? '-';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: 100,
                  height: 120,
                  child: coverUrl.isNotEmpty
                      ? Image.network(
                          coverUrl,
                          width: 100,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 100,
                              height: 120,
                              color: Colors.grey[200],
                              child: Icon(Icons.menu_book, size: 40, color: Colors.grey[400]),
                            );
                          },
                        )
                      : Container(
                          width: 100,
                          height: 120,
                          color: Colors.grey[200],
                          child: Icon(Icons.menu_book, size: 40, color: Colors.grey[400]),
                        ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ebook.nama,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
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
                            ebook.penulis ?? 'Penulis tidak tersedia',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: info.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.menu_book, size: 14, color: info),
                              const SizedBox(width: 4),
                              Text(
                                'E-BOOK',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: info,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isFree ? success.withValues(alpha: 0.1) : warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isFree ? Icons.check_circle : Icons.attach_money,
                                size: 14,
                                color: isFree ? success : warning,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isFree ? 'GRATIS' : 'BERBAYAR',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: isFree ? success : warning,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.business_outlined, size: 14, color: primary),
                              const SizedBox(width: 4),
                              Text(
                                mitraNama,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildDownloadCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Download E-Book',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _downloadEbook,
              icon: Icon(Icons.download, size: 20, color: Colors.white),
              label: const Text(
                'Download File',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'File tersedia dalam format PDF',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Informasi E-Book',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _infoRow('Harga', Formatter.formatCurrency(ebook.hargaFinal ?? ebook.harga)),
          const SizedBox(height: 12),
          _infoRow('Penerbit', ebook.penerbit ?? '-'),
          const SizedBox(height: 12),
          _infoRow('Tahun Terbit', ebook.tahunTerbit?.toString() ?? '-'),
          const SizedBox(height: 12),
          _infoRow('Jumlah Halaman', '${ebook.jumlahHalaman ?? 0} halaman'),
          const SizedBox(height: 12),
          _infoRow('ISBN', ebook.isbn ?? '-'),
          const SizedBox(height: 12),
          _infoRow('Status Publikasi', ebook.isPublished ? 'Published' : 'Draft'),
        ],
      ),
    );
  }
  
  Widget _buildDeskripsiCard() {
    if (ebook.deskripsi == null || ebook.deskripsi!.isEmpty) {
      return const SizedBox.shrink();
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          const Text(
            'Tentang E-Book',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            ebook.deskripsi ?? '',
            style: const TextStyle(fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }
  
  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}