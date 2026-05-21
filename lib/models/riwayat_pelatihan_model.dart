// lib/models/riwayat_pelatihan_model.dart
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/utils/base.dart';

class PelatihanDibeli {
  final int id;
  final String nama;
  final String slug;
  final String? deskripsi;
  final int harga;
  final int? hargaFinal;
  final String? tempat;
  final String? waktu;
  final String? cover;
  final String type;
  final String? typePelatihan;
  final int? maxPeserta;
  final Mitra? mitra;
  final String status;
  final String? startTime;
  final String? endTime;
  final String? meetingLink;
  final String? linkGmaps;
  final List<RincianTransaksi> rincianTransaksi;
  final List<Attachment> attachments;
  
  PelatihanDibeli({
    required this.id,
    required this.nama,
    required this.slug,
    this.deskripsi,
    required this.harga,
    this.hargaFinal,
    this.tempat,
    this.waktu,
    this.cover,
    required this.type,
    this.typePelatihan,
    this.maxPeserta,
    this.mitra,
    required this.status,
    this.startTime,
    this.endTime,
    this.meetingLink,
    this.linkGmaps,
    this.rincianTransaksi = const [],
    this.attachments = const [],
  });
  
  String get coverUrl {
    if (cover != null && cover!.isNotEmpty) {
      return '${Base.url}$cover';
    }
    return '';
  }
  
  String get kodeAkses {
    if (rincianTransaksi.isNotEmpty) {
      return rincianTransaksi.first.kodeAkses;
    }
    return '-';
  }
  
  String get qrUrl {
    if (rincianTransaksi.isNotEmpty && rincianTransaksi.first.qrUrl != null) {
      return rincianTransaksi.first.qrUrl!;
    }
    return '';
  }
  
  factory PelatihanDibeli.fromJson(Map<String, dynamic> json) {
    return PelatihanDibeli(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      slug: json['slug'] ?? '',
      deskripsi: json['deskripsi'],
      harga: json['harga'] ?? 0,
      hargaFinal: json['harga_final'],
      tempat: json['tempat'],
      waktu: json['waktu'],
      cover: json['cover'],
      type: json['type'] ?? 'pelatihan',
      typePelatihan: json['type_pelatihan'],
      maxPeserta: json['max_peserta'],
      mitra: json['mitra'] != null ? Mitra.fromJson(json['mitra']) : null,
      status: json['status'] ?? '',
      startTime: json['start_time'],
      endTime: json['end_time'],
      meetingLink: json['meeting_link'],
      linkGmaps: json['link_gmaps'],
      rincianTransaksi: (json['rincian_transaksi'] as List?)
          ?.map((e) => RincianTransaksi.fromJson(e))
          .toList() ?? [],
      attachments: (json['attachments'] as List?)
          ?.map((e) => Attachment.fromJson(e))
          .toList() ?? [],
    );
  }
}

class RincianTransaksi {
  final int id;
  final int pelatihanId;
  final String kodeAkses;
  final String? qrCode;
  final int transaksiId;
  final String? qrUrl;
  
  RincianTransaksi({
    required this.id,
    required this.pelatihanId,
    required this.kodeAkses,
    this.qrCode,
    required this.transaksiId,
    this.qrUrl,
  });
  
  factory RincianTransaksi.fromJson(Map<String, dynamic> json) {
    return RincianTransaksi(
      id: json['id'] ?? 0,
      pelatihanId: json['pelatihan_id'] ?? 0,
      kodeAkses: json['kode_akses'] ?? '',
      qrCode: json['qr_code'],
      transaksiId: json['transaksi_id'] ?? 0,
      qrUrl: json['qr_url'],
    );
  }
}

class Attachment {
  final int id;
  final int pelatihanId;
  final String path;
  final bool isMain;
  
  Attachment({
    required this.id,
    required this.pelatihanId,
    required this.path,
    required this.isMain,
  });
  
  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      id: json['id'] ?? 0,
      pelatihanId: json['pelatihan_id'] ?? 0,
      path: json['path'] ?? '',
      isMain: json['is_main'] ?? false,
    );
  }
  
  String get url => '${Base.url}$path';
}