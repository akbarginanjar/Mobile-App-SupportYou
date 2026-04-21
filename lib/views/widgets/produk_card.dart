// lib/views/widgets/produk_card.dart
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

  // Constructor untuk Pelatihan
  ProdukCard.forPelatihan({
    super.key,
    required Pelatihan pelatihan,
  })  : pelatihan = pelatihan,
        ebook = null,
        isPelatihan = true;

  // Constructor untuk Ebook
  ProdukCard.forEbook({
    super.key,
    required Ebook ebook,
  })  : ebook = ebook,
        pelatihan = null,
        isPelatihan = false;

  String get _nama => isPelatihan ? pelatihan!.nama : ebook!.nama;
  int get _id => isPelatihan ? pelatihan!.id : ebook!.id;
  int get _harga => isPelatihan ? pelatihan!.harga : (ebook!.harga ?? 0);
  int? get _hargaFinal => isPelatihan ? pelatihan!.hargaFinal : null;
  String? get _cover => isPelatihan ? pelatihan!.cover : ebook!.cover;
  String get _type => isPelatihan ? pelatihan!.type : (ebook!.type ?? 'ebook');
  String? get _typePelatihan => isPelatihan ? pelatihan!.typePelatihan : null;
  String? get _waktu => isPelatihan ? pelatihan!.waktu : null;
  Mitra? get _mitra => isPelatihan ? pelatihan!.mitra : null;
  String? get _penulis => isPelatihan ? pelatihan!.penulis : ebook!.penulis;
  int? get _jumlahHalaman => isPelatihan ? pelatihan!.jumlahHalaman : ebook!.jumlahHalaman;

  void _onTap() {
    if (isPelatihan) {
      // Navigasi ke PelatihanScreen untuk pelatihan
      Get.to(() => PelatihanScreen(slug: _id.toString()));
    } else {
      // Navigasi ke EbookScreen untuk ebook
      Get.to(() => EbookScreen(slug: _id.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Gunakan ImageHelper untuk mendapatkan URL lengkap
    final String imageUrl = ImageHelper.getFullImageUrl(_cover);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Cover image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Stack(
                children: [
                  // Jika URL valid, tampilkan dari network, jika tidak tampilkan placeholder
                  imageUrl.isNotEmpty
                      ? Image.network(
                          imageUrl,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/image/pelatihan_placeholder.jpg',
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/image/pelatihan_placeholder.jpg',
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                  
                  // Badge
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: !isPelatihan
                            ? const LinearGradient(
                                colors: [Colors.purple, Colors.deepPurple],
                              )
                            : LinearGradient(
                                colors: _typePelatihan?.toLowerCase() == "online"
                                    ? [Colors.blue, Colors.lightBlue]
                                    : [Colors.orange, Colors.deepOrange],
                              ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            !isPelatihan
                                ? Icons.menu_book
                                : (_typePelatihan?.toLowerCase() == "online"
                                    ? Icons.wifi
                                    : Icons.location_on),
                            size: 10,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            !isPelatihan
                                ? "E-BOOK"
                                : (_typePelatihan?.toLowerCase() == "online" ? "ONLINE" : "OFFLINE"),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Judul
                    SizedBox(
                      height: 32,
                      child: Text(
                        _nama,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Info baris 1 (Penyelenggara untuk Pelatihan / Penulis untuk Ebook)
                    if (isPelatihan && _mitra != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.business_outlined,
                            size: 10,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              _mitra?.nama ?? 'Belum ada nama',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 9,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    if (!isPelatihan && _penulis != null) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 10,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              _penulis!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontSize: 9,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                    
                    // Info baris 2 (Waktu untuk Pelatihan / Jumlah Halaman untuk Ebook)
                    Row(
                      children: [
                        Icon(
                          isPelatihan ? Icons.calendar_today : Icons.description_outlined,
                          size: 10,
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            isPelatihan
                                ? (_waktu ?? '-')
                                : (_jumlahHalaman != null ? '${_jumlahHalaman} halaman' : '-'),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 9,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Harga dan Tombol
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_hargaFinal != null && _hargaFinal! < _harga) ...[
                                Text(
                                  Formatter.formatCurrency(_harga),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 9,
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                              Text(
                                Formatter.formatCurrency(_hargaFinal ?? _harga),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [primary, primary.withValues(alpha: 0.8)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: primary.withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}