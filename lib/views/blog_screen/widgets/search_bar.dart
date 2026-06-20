// lib/views/blog_screen/widgets/search_bar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/blog_controller.dart';

class BlogSearchBar extends StatelessWidget {
  final BlogController controller;

  const BlogSearchBar({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onSubmitted: (value) => controller.searchBlogs(value),
          onChanged: (value) {
            if (value.isEmpty) {
              controller.searchBlogs('');
            }
          },
          decoration: InputDecoration(
            hintText: 'Cari blog...',
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[400],
              size: 20,
            ),
            suffixIcon: Obx(() {
              if (controller.searchQuery.value.isNotEmpty) {
                return IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: () {
                    controller.clearSearch();
                  },
                );
              }
              return const SizedBox.shrink();
            }),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ),
    );
  }
}