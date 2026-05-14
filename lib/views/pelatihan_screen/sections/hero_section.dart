import 'package:flutter/material.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/utils/image_helper.dart';

class HeroSection extends StatelessWidget {
  final Pelatihan pelatihan;
  final String coverImageUrl;

  const HeroSection({
    super.key,
    required this.pelatihan,
    required this.coverImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          child: coverImageUrl.isNotEmpty
              ? Image.network(
                  coverImageUrl,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/image/pelatihan_placeholder.jpg',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                    );
                  },
                )
              : Image.asset(
                  'assets/image/pelatihan_placeholder.jpg',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
        ),
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.5),
              ],
            ),
          ),
        ),
      ],
    );
  }
}