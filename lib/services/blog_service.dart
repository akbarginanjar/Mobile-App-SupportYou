// lib/services/blog_service.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mobile_supportyou/models/blog_model.dart';

class BlogService {
  List<Blog> _allBlogs = [];
  bool _isLoaded = false;

  Future<List<Blog>> _loadBlogsFromAsset() async {
    if (_isLoaded) return _allBlogs;

    try {
      final String jsonString = await rootBundle.loadString('assets/json/blogs.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> blogList = jsonData['blogs'] ?? [];
      _allBlogs = blogList.map((e) => Blog.fromJson(e)).toList();
      _isLoaded = true;
    } catch (e) {
      _allBlogs = [];
    }

    return _allBlogs;
  }

  Future<List<Blog>> getBlogs({
    int start = 0,
    int length = 10,
    String? search,
    String? category,
  }) async {
    await _loadBlogsFromAsset();

    List<Blog> filtered = List.from(_allBlogs);

    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase();
      filtered = filtered.where((blog) {
        return blog.title.toLowerCase().contains(query) ||
            blog.content.toLowerCase().contains(query);
      }).toList();
    }

    if (category != null && category.isNotEmpty && category != 'Semua') {
      filtered = filtered.where((blog) => blog.category == category).toList();
    }

    final end = (start + length) < filtered.length ? start + length : filtered.length;
    return filtered.sublist(start, end);
  }

  Future<int> getTotalBlogs({
    String? search,
    String? category,
  }) async {
    await _loadBlogsFromAsset();

    List<Blog> filtered = List.from(_allBlogs);

    if (search != null && search.isNotEmpty) {
      final query = search.toLowerCase();
      filtered = filtered.where((blog) {
        return blog.title.toLowerCase().contains(query) ||
            blog.content.toLowerCase().contains(query);
      }).toList();
    }

    if (category != null && category.isNotEmpty && category != 'Semua') {
      filtered = filtered.where((blog) => blog.category == category).toList();
    }

    return filtered.length;
  }

  Future<Blog?> getBlogBySlug(String slug) async {
    await _loadBlogsFromAsset();
    try {
      return _allBlogs.firstWhere((blog) => blog.slug == slug);
    } catch (e) {
      return null;
    }
  }

  Future<List<Blog>> getRelatedBlogs(String slug, {int limit = 3}) async {
    await _loadBlogsFromAsset();

    final currentBlog = await getBlogBySlug(slug);
    if (currentBlog == null) return [];

    final related = _allBlogs.where((blog) {
      return blog.id != currentBlog.id && blog.category == currentBlog.category;
    }).toList();

    related.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (related.length > limit) {
      return related.sublist(0, limit);
    }
    return related;
  }

  List<String> getAllCategories() {
    return ['Semua', 'Teknologi', 'Bisnis', 'Pendidikan', 'Karir', 'Inspirasi'];
  }
}