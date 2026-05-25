import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/utils/date_formatter.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';
import 'package:mobile_supportyou/models/riwayat_pelatihan_model.dart';
import 'package:mobile_supportyou/models/ebook_dibeli_model.dart';
import 'package:mobile_supportyou/views/detail_pelatihan_dibeli/screen.dart';
import 'package:mobile_supportyou/views/detail_ebook_dibeli/screen.dart';

class RiwayatCard extends StatelessWidget {
  final PelatihanDibeli? pelatihan;
  final EbookDibeli? ebook;
  final bool isPelatihan;

  const RiwayatCard.forPelatihan({
    super.key,
    required this.pelatihan,
  })  : ebook = null,
        isPelatihan = true;

  const RiwayatCard.forEbook({
    super.key,
    required this.ebook,
  })  : pelatihan = null,
        isPelatihan = false;

  String get _nama => isPelatihan ? pelatihan!.nama : ebook!.nama;
  
  String? get _mitraNama => isPelatihan ? pelatihan!.mitra?.nama : null;
  String? get _penulis => isPelatihan ? null : ebook!.penulis;
  String? get _penerbit => isPelatihan ? null : ebook!.penerbit;
  int? get _tahunTerbit => isPelatihan ? null : ebook!.tahunTerbit;
  
  String? get _waktu => isPelatihan ? pelatihan!.waktu : null;
  String? get _tempat => isPelatihan ? pelatihan!.tempat : null;
  String? get _typePelatihan => isPelatihan ? pelatihan!.typePelatihan : null;
  
  int? get _jumlahHalaman => isPelatihan ? null : ebook!.jumlahHalaman;
  int get _harga => isPelatihan ? pelatihan!.harga : ebook!.harga;
  int? get _hargaFinal => isPelatihan ? pelatihan!.hargaFinal : null;

  String get _kodeAkses => isPelatihan ? pelatihan!.kodeAkses : '';

  void _onTap() {
    if (isPelatihan) {
      Get.to(() => DetailPelatihanDibeliScreen(pelatihan: pelatihan!));
    } else {
      Get.to(() => DetailEbookDibeliScreen(ebook: ebook!));
    }
  }

  void _copyKodeAkses() {
    if (isPelatihan && _kodeAkses.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _kodeAkses));
      Get.snackbar(
        'Berhasil',
        'Kode akses disalin',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: success,
        colorText: theme,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String typePelatihan = _typePelatihan ?? '';
    final bool isOnline = typePelatihan.toLowerCase() == "online";
    final String formattedDate = DateFormatter.formatDateWithDayAndTime(_waktu);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: textTheme.withValues(alpha: 0.05),
            blurRadius: 12,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isPelatihan
                              ? [primary.withValues(alpha: 0.15), primary.withValues(alpha: 0.05)]
                              : [info.withValues(alpha: 0.15), info.withValues(alpha: 0.05)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        isPelatihan ? Icons.school_rounded : Icons.menu_book_rounded,
                        size: 28,
                        color: isPelatihan ? primary : info,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _nama,
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(
                                isPelatihan ? Icons.business_center : Icons.person,
                                size: 14,
                                color: textTheme.withValues(alpha: 0.45),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  isPelatihan 
                                      ? (_mitraNama ?? 'SupportYou Education')
                                      : (_penulis ?? 'Penulis tidak tersedia'),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: textTheme.withValues(alpha: 0.65),
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: success.withValues(alpha: 0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: success,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Dibeli',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (isPelatihan) ...[
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isOnline ? primary.withValues(alpha: 0.1) : warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isOnline ? Icons.wifi : Icons.location_on,
                          size: 16,
                          color: isOnline ? primary : warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isOnline ? 'Kelas Online' : 'Kelas Offline',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isOnline ? primary : warning,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isOnline ? 'Zoom / Google Meet' : (_tempat ?? 'Lokasi tidak tersedia'),
                              style: TextStyle(
                                fontSize: 11,
                                color: textTheme.withValues(alpha: 0.55),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 14,
                        color: textTheme.withValues(alpha: 0.45),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: 11,
                          color: textTheme.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _copyKodeAkses,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: primary.withValues(alpha: 0.15),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.copy, size: 16, color: primary),
                          const SizedBox(width: 8),
                          Text(
                            'Kode Akses: $_kodeAkses',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.menu_book_rounded,
                          size: 16,
                          color: info,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ebook Digital',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: info,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _penerbit ?? 'Penerbit tidak tersedia',
                              style: TextStyle(
                                fontSize: 11,
                                color: textTheme.withValues(alpha: 0.55),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.book,
                        size: 14,
                        color: textTheme.withValues(alpha: 0.45),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_jumlahHalaman ?? 0} halaman',
                        style: TextStyle(
                          fontSize: 11,
                          color: textTheme.withValues(alpha: 0.55),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today,
                        size: 12,
                        color: textTheme.withValues(alpha: 0.45),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _tahunTerbit?.toString() ?? '-',
                        style: TextStyle(
                          fontSize: 11,
                          color: textTheme.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    Formatter.formatCurrency(_hargaFinal ?? _harga),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Divider(
                  height: 1,
                  color: textTheme.withValues(alpha: 0.08),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Lihat Detail',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}