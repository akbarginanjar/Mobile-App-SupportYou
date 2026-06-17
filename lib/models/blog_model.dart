// lib/models/blog_model.dart
import 'package:mobile_supportyou/utils/base.dart';

class Blog {
  final int id;
  final String title;
  final String slug;
  final String content;
  final String? imageUrl;
  final String category;
  final String createdAt;
  final String author;

  Blog({
    required this.id,
    required this.title,
    required this.slug,
    required this.content,
    this.imageUrl,
    required this.category,
    required this.createdAt,
    required this.author,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['image_url'],
      category: json['category'] ?? 'Umum',
      createdAt: json['created_at'] ?? '',
      author: json['author'] ?? 'Admin',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'content': content,
      'image_url': imageUrl,
      'category': category,
      'created_at': createdAt,
      'author': author,
    };
  }
}