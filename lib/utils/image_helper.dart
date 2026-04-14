// lib/utils/image_helper.dart
import 'package:mobile_supportyou/utils/base.dart';

class ImageHelper {
  static String getFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return '';
    }
    
    // Jika sudah URL lengkap
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return imagePath;
    }
    
    // Jika path dimulai dengan /, hapus / pertama
    String cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    
    // Gabungkan dengan base URL
    return '${Base.url}$cleanPath';
  }
}