import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';
import 'package:mobile_supportyou/utils/image_helper.dart';

class EbookHeroSection extends StatelessWidget {
  final Ebook ebook;

  const EbookHeroSection({super.key, required this.ebook});

  @override
  Widget build(BuildContext context) {
    final String coverImageUrl = ImageHelper.getFullImageUrl(ebook.cover);

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 280,
          child: coverImageUrl.isNotEmpty
              ? Image.network(
                  coverImageUrl,
                  width: double.infinity,
                  height: 280,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 280,
                      color: primary.withValues(alpha: 0.1),
                      child: Icon(
                        Icons.menu_book,
                        size: 64,
                        color: primary.withValues(alpha: 0.3),
                      ),
                    );
                  },
                )
              : Container(
                  width: double.infinity,
                  height: 280,
                  color: primary.withValues(alpha: 0.1),
                  child: Icon(
                    Icons.menu_book,
                    size: 64,
                    color: primary.withValues(alpha: 0.3),
                  ),
                ),
        ),
        Container(
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.menu_book,
                  size: 14,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Text(
                  "E-BOOK",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: theme,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ebook.nama,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                ebook.deskripsi,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.withValues(alpha: 0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}