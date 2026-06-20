// lib/views/blog_screen/screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/blog_controller.dart';
import 'package:mobile_supportyou/views/blog_screen/widgets/blog_card.dart';
import 'package:mobile_supportyou/views/blog_screen/widgets/search_bar.dart';
import 'package:mobile_supportyou/views/blog_screen/widgets/category_filter.dart';
import 'package:mobile_supportyou/views/blog_detail_screen/screen.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BlogController controller = Get.put(BlogController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Blog',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primary,
      ),
      body: Column(
        children: [
          BlogSearchBar(controller: controller),
          const SizedBox(height: 8),
          CategoryFilter(controller: controller),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.blogList.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Memuat blog...'),
                    ],
                  ),
                );
              }

              if (controller.blogList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum ada blog',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Coba ubah kata kunci pencarian atau filter',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.loadBlogs(),
                color: primary,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
                      controller.loadMoreBlogs();
                    }
                    return true;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.blogList.length + (controller.hasMoreData ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= controller.blogList.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final blog = controller.blogList[index];
                      return BlogCard(
                        blog: blog,
                        onTap: () {
                          Get.to(() => BlogDetailScreen(slug: blog.slug));
                        },
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}