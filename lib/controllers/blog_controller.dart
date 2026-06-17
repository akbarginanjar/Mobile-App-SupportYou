// lib/controllers/blog_controller.dart
import 'package:get/get.dart';
import 'package:mobile_supportyou/models/blog_model.dart';
import 'package:mobile_supportyou/services/blog_service.dart';

class BlogController extends GetxController {
  final BlogService _blogService = BlogService();

  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final blogList = <Blog>[].obs;
  var currentStart = 0;
  var hasMoreData = true;
  final searchQuery = ''.obs;
  final selectedCategory = 'Semua'.obs;
  final categories = <String>[].obs;

  final isLoadingDetail = false.obs;
  final detailBlog = Rx<Blog?>(null);
  final relatedBlogs = <Blog>[].obs;

  @override
  void onInit() {
    super.onInit();
    categories.assignAll(_blogService.getAllCategories());
    loadBlogs();
  }

  Future<void> loadBlogs({bool reset = true}) async {
    if (reset) {
      currentStart = 0;
      hasMoreData = true;
      blogList.clear();
      isLoading.value = true;
    }

    try {
      final result = await _blogService.getBlogs(
        start: currentStart,
        length: 10,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        category: selectedCategory.value != 'Semua' ? selectedCategory.value : null,
      );

      if (result.isEmpty) {
        hasMoreData = false;
      } else {
        if (reset) {
          blogList.assignAll(result);
        } else {
          blogList.addAll(result);
        }
        currentStart += result.length;
        hasMoreData = result.length >= 10;
      }
    } catch (e) {
      print('Error loading blogs: $e');
    } finally {
      if (reset) {
        isLoading.value = false;
      }
    }
  }

  Future<void> loadMoreBlogs() async {
    if (!isMoreLoading.value && hasMoreData) {
      isMoreLoading.value = true;
      await loadBlogs(reset: false);
      isMoreLoading.value = false;
    }
  }

  Future<void> searchBlogs(String query) async {
    searchQuery.value = query;
    await loadBlogs();
  }

  Future<void> filterByCategory(String category) async {
    selectedCategory.value = category;
    await loadBlogs();
  }

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

  void clearSearch() {
    searchQuery.value = '';
    selectedCategory.value = 'Semua';
    loadBlogs();
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