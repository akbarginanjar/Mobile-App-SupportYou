import 'package:mobile_supportyou/utils/base.dart';

class Asosiasi {
  final int id;
  final String nama;
  final String? logoPath;

  Asosiasi({
    required this.id,
    required this.nama,
    this.logoPath,
  });

  factory Asosiasi.fromJson(Map<String, dynamic> json) {
    return Asosiasi(
      id: json['id'],
      nama: json['nama'] ?? '',
      logoPath: json['logo_path'],
    );
  }
}

class Pelatihan {
  final int id;
  final int? asosiasiId;
  final String nama;
  final String slug;
  final String deskripsi;
  final int? harga;
  final String? cover;
  final bool isFree;
  final int? mitraId;
  final String? typePelatihan;
  final String? shareAplikasi;
  final int? hargaFinal;
  final bool isPublished;
  final String? type;
  final String? penulis;
  final String? penerbit;
  final int? tahunTerbit;
  final int? jumlahHalaman;
  final String? isbn;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Asosiasi? asosiasi;

  // 🔹 Tambahan field
  final String? linkGmaps;
  final String? tempat;
  final String? waktu;
  final String? meetingLink;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? maxPeserta;

  Pelatihan({
    required this.id,
    this.asosiasiId,
    required this.nama,
    required this.slug,
    required this.deskripsi,
    this.harga,
    this.cover,
    required this.isFree,
    this.mitraId,
    this.typePelatihan,
    this.shareAplikasi,
    this.hargaFinal,
    required this.isPublished,
    this.type,
    this.penulis,
    this.penerbit,
    this.tahunTerbit,
    this.jumlahHalaman,
    this.isbn,
    this.createdAt,
    this.updatedAt,
    this.asosiasi,
    this.linkGmaps,
    this.tempat,
    this.waktu,
    this.meetingLink,
    this.startTime,
    this.endTime,
    this.maxPeserta,
  });

  factory Pelatihan.fromJson(Map<String, dynamic> json) {
    String? gambar;
    if (json['attachments'] != null && json['attachments'].isNotEmpty) {
      final path = json['attachments'][0]['path'];
      gambar = "${Base.url}/$path";
    } else if (json['cover'] != null) {
      gambar = "${Base.url}/${json['cover']}";
    }

    return Pelatihan(
      id: json['id'],
      asosiasiId: json['asosiasi_id'],
      nama: json['nama'] ?? '',
      slug: json['slug'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      harga: json['harga'],
      cover: gambar,
      isFree: json['is_free'] ?? false,
      mitraId: json['mitra_id'],
      typePelatihan: json['type_pelatihan'],
      shareAplikasi: json['share_aplikasi'],
      hargaFinal: json['harga_final'],
      isPublished: json['is_published'] ?? false,
      type: json['type'],
      penulis: json['penulis'],
      penerbit: json['penerbit'],
      tahunTerbit: json['tahun_terbit'],
      jumlahHalaman: json['jumlah_halaman'],
      isbn: json['isbn'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      asosiasi: json['asosiasi'] != null
          ? Asosiasi.fromJson(json['asosiasi'])
          : null,

      // 🔹 Field tambahan
      linkGmaps: json['link_gmaps'],
      tempat: json['tempat'],
      waktu: json['waktu'],
      meetingLink: json['meeting_link'],
      startTime: json['start_time'] != null
          ? DateTime.tryParse(json['start_time'])
          : null,
      endTime: json['end_time'] != null
          ? DateTime.tryParse(json['end_time'])
          : null,
      maxPeserta: json['max_peserta'],
    );
  }
}