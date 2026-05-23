// lib/models/ebook_dibeli_model.dart (tambahkan field isPublished)
import 'package:mobile_supportyou/utils/base.dart';

class EbookDibeli {
  final int id;
  final String nama;
  final String slug;
  final String? deskripsi;
  final int harga;
  final int? hargaFinal;
  final String? cover;
  final String type;
  final String? penulis;
  final String? penerbit;
  final int? tahunTerbit;
  final int? jumlahHalaman;
  final String? isbn;
  final String? fileEbook;
  final bool isFree;
  final bool isPublished;
  final MitraEbook? mitra;
  final List<AttachmentEbook> attachments;
  
  EbookDibeli({
    required this.id,
    required this.nama,
    required this.slug,
    this.deskripsi,
    required this.harga,
    this.hargaFinal,
    this.cover,
    required this.type,
    this.penulis,
    this.penerbit,
    this.tahunTerbit,
    this.jumlahHalaman,
    this.isbn,
    this.fileEbook,
    required this.isFree,
    required this.isPublished,
    this.mitra,
    this.attachments = const [],
  });
  
  String get coverUrl {
    if (cover != null && cover!.isNotEmpty) {
      return '${Base.url}$cover';
    }
    return '';
  }
  
  String get fileUrl {
    if (fileEbook != null && fileEbook!.isNotEmpty) {
      return '${Base.url}$fileEbook';
    }
    return '';
  }
  
  factory EbookDibeli.fromJson(Map<String, dynamic> json) {
    return EbookDibeli(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      slug: json['slug'] ?? '',
      deskripsi: json['deskripsi'],
      harga: json['harga'] ?? 0,
      hargaFinal: json['harga_final'],
      cover: json['cover'],
      type: json['type'] ?? 'ebook',
      penulis: json['penulis'],
      penerbit: json['penerbit'],
      tahunTerbit: json['tahun_terbit'],
      jumlahHalaman: json['jumlah_halaman'],
      isbn: json['isbn'],
      fileEbook: json['file_ebook'],
      isFree: json['is_free'] ?? false,
      isPublished: json['is_published'] ?? false,
      mitra: json['mitra'] != null ? MitraEbook.fromJson(json['mitra']) : null,
      attachments: (json['attachments'] as List?)
          ?.map((e) => AttachmentEbook.fromJson(e))
          .toList() ?? [],
    );
  }
}

class MitraEbook {
  final int id;
  final String nama;
  
  MitraEbook({
    required this.id,
    required this.nama,
  });

  factory MitraEbook.fromJson(Map<String, dynamic> json) {
    return MitraEbook(
      id: json['id'] ?? 0,
      nama: json['nama_lengkap'] ?? json['nama'] ?? '-',
    );
  }
}

class AttachmentEbook {
  final int id;
  final int pelatihanId;
  final String path;
  final bool isMain;
  
  AttachmentEbook({
    required this.id,
    required this.pelatihanId,
    required this.path,
    required this.isMain,
  });
  
  factory AttachmentEbook.fromJson(Map<String, dynamic> json) {
    return AttachmentEbook(
      id: json['id'] ?? 0,
      pelatihanId: json['pelatihan_id'] ?? 0,
      path: json['path'] ?? '',
      isMain: json['is_main'] ?? false,
    );
  }
  
  String get url => '${Base.url}$path';
}