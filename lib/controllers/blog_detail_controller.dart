// lib/controllers/blog_detail_controller.dart
import 'package:get/get.dart';
import 'package:mobile_supportyou/models/blog_model.dart';
import 'package:mobile_supportyou/services/blog_service.dart';

class BlogDetailController extends GetxController {
  final BlogService _blogService = BlogService();

  final isLoadingDetail = false.obs;
  final detailBlog = Rx<Blog?>(null);
  final relatedBlogs = <Blog>[].obs;

  Future<void> loadBlogDetail(String slug) async {
    try {
      isLoadingDetail.value = true;
      final blog = await _blogService.getBlogBySlug(slug);
      detailBlog.value = blog;

      if (blog != null) {
        final related = await _blogService.getRelatedBlogs(slug);
        relatedBlogs.assignAll(related);
      }
    } catch (e) {
      print('Error loading blog detail: $e');
      detailBlog.value = null;
      relatedBlogs.clear();
    } finally {
      isLoadingDetail.value = false;
    }
  }

  String formatDate(String dateTimeString) {
    try {
      final DateTime dateTime = DateTime.parse(dateTimeString);
      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year} • $hour:$minute';
    } catch (e) {
      return dateTimeString;
    }
  }
}
