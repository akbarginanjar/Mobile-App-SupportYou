import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';
import 'package:mobile_supportyou/utils/image_helper.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';
import 'package:mobile_supportyou/views/pelatihan_screen/screen.dart';
import 'package:mobile_supportyou/views/ebook_screen/screen.dart';

class ProdukCard extends StatelessWidget {
  final Pelatihan? pelatihan;
  final Ebook? ebook;
  final bool isPelatihan;

  const ProdukCard.forPelatihan({
    super.key,
    required this.pelatihan,
  })  : ebook = null,
        isPelatihan = true;

  const ProdukCard.forEbook({
    super.key,
    required this.ebook,
  })  : pelatihan = null,
        isPelatihan = false;

  String get _nama => isPelatihan ? pelatihan!.nama : ebook!.nama;
  int get _id => isPelatihan ? pelatihan!.id : ebook!.id;
  String? get _cover => isPelatihan ? pelatihan!.cover : ebook!.cover;
  String? get _typePelatihan => isPelatihan ? pelatihan!.typePelatihan : null;
  Mitra? get _mitra => isPelatihan ? pelatihan!.mitra : null;
  String? get _penulis => isPelatihan ? null : ebook!.penulis;
  String? get _level => isPelatihan ? (pelatihan!.level ?? 'Menengah') : null;
  double? get _rating => isPelatihan ? pelatihan!.rating : null;
  int? get _ratingCount => isPelatihan ? pelatihan!.ratingCount : null;
  
  int get _displayPrice {
    if (isPelatihan) {
      return pelatihan!.displayPrice;
    }
    return ebook!.harga ?? 0;
  }
  
  int? get _originalPrice {
    if (isPelatihan) {
      return pelatihan!.originalPrice;
    }
    return null;
  }

  void _onTap() {
    if (isPelatihan) {
      Get.to(() => PelatihanScreen(slug: _id.toString()));
    } else {
      Get.to(() => EbookScreen(slug: _id.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = ImageHelper.getFullImageUrl(_cover);
    final String typeText = _typePelatihan?.toUpperCase() ?? '';
    final String levelText = _level ?? 'Menengah';
    final double ratingValue = _rating ?? 0;
    final int ratingCountValue = _ratingCount ?? 0;
    final bool hasDiscount = _originalPrice != null && _originalPrice! > _displayPrice;
    
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: theme,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: textTheme.withValues(alpha: 0.06),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: _onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                children: [
                  imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 140,
                            color: primary.withValues(alpha: 0.1),
                            child: Icon(Icons.image, size: 40, color: primary.withValues(alpha: 0.3)),
                          ),
                        )
                      : Container(
                          height: 140,
                          color: primary.withValues(alpha: 0.1),
                          child: Icon(Icons.image, size: 40, color: primary.withValues(alpha: 0.3)),
                        ),
                  if (isPelatihan && typeText.isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: typeText == 'ONLINE' ? Colors.blue : Colors.orange,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              typeText == 'ONLINE' ? Icons.wifi : Icons.location_on,
                              size: 10,
                              color: theme,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              typeText,
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nama,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        isPelatihan ? Icons.business : Icons.person,
                        size: 12,
                        color: textTheme.withValues(alpha: 0.45),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          isPelatihan 
                              ? (_mitra?.nama ?? 'SupportYou Education')
                              : (_penulis ?? 'Penulis tidak tersedia'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            color: textTheme.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isPelatihan) ...[
                    const SizedBox(height: 6),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        Text(
                          levelText,
                          style: TextStyle(
                            fontSize: 11,
                            color: textTheme.withValues(alpha: 0.6),
                          ),
                        ),
                        Container(
                          width: 3,
                          height: 3,
                          decoration: BoxDecoration(
                            color: textTheme.withValues(alpha: 0.4),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          typeText,
                          style: TextStyle(
                            fontSize: 11,
                            color: textTheme.withValues(alpha: 0.6),
                          ),
                        ),
                        if (ratingCountValue > 0) ...[
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: textTheme.withValues(alpha: 0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 12,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                ratingValue.toStringAsFixed(0),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: textTheme.withValues(alpha: 0.7),
                                ),
                              ),
                              Text(
                                ' ($ratingCountValue ulasan)',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: textTheme.withValues(alpha: 0.45),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasDiscount)
                              Text(
                                Formatter.formatCurrency(_originalPrice),
                                style: TextStyle(
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                  color: textTheme.withValues(alpha: 0.4),
                                ),
                              ),
                            Text(
                              Formatter.formatCurrency(_displayPrice),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}