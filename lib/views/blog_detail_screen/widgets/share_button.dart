// lib/views/blog_detail_screen/widgets/share_button.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/blog_model.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareButton extends StatelessWidget {
  final Blog blog;

  const ShareButton({
    super.key,
    required this.blog,
  });

  String get _shareUrl {
    return 'https://supportyou.biz.id/blog/${blog.slug}';
  }

  String get _shareText {
    return '${blog.title}\n\n${blog.content.substring(0, blog.content.length > 100 ? 100 : blog.content.length)}...\n\nBaca selengkapnya di: $_shareUrl';
  }

  Future<void> _copyLink() async {
    try {
      await Clipboard.setData(ClipboardData(text: _shareUrl));
      Get.snackbar(
        'Berhasil',
        'Link blog telah disalin',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: success,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal menyalin link',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: danger,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _shareViaWhatsApp() async {
    final String url = 'https://wa.me/?text=${Uri.encodeComponent(_shareText)}';
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar(
          'Gagal',
          'Tidak dapat membuka WhatsApp',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: danger,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal membuka WhatsApp',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: danger,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.share, color: primary),
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      onSelected: (value) {
        switch (value) {
          case 'copy':
            _copyLink();
            break;
          case 'whatsapp':
            _shareViaWhatsApp();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'copy',
          child: Row(
            children: [
              Icon(Icons.copy, size: 20),
              SizedBox(width: 12),
              Text('Salin Link'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'whatsapp',
          child: Row(
            children: [
              Icon(Icons.chat, size: 20),
              SizedBox(width: 12),
              Text('Bagikan ke WhatsApp'),
            ],
          ),
        ),
      ],
    );
  }
}