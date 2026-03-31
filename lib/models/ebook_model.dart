import 'package:mobile_supportyou/utils/base.dart';

class Ebook {
  final int id;
  final String nama;
  final String slug;
  final String deskripsi;
  final int? harga;
  final String? cover;
  final String? penulis;
  final String? penerbit;
  final int? tahunTerbit;
  final int? jumlahHalaman;
  final String? isbn;
  final bool isFree;
  final bool isPublished;
  final String? type; 

  Ebook({
    required this.id,
    required this.nama,
    required this.slug,
    required this.deskripsi,
    this.harga,
    this.cover,
    this.penulis,
    this.penerbit,
    this.tahunTerbit,
    this.jumlahHalaman,
    this.isbn,
    required this.isFree,
    required this.isPublished,
    this.type,
  });

  factory Ebook.fromJson(Map<String, dynamic> json) {
    String? gambar;
    if (json['attachments'] != null && json['attachments'].isNotEmpty) {
      final path = json['attachments'][0]['path'];
      gambar = "${Base.url}/$path";
    } else if (json['cover'] != null) {
      gambar = "${Base.url}/${json['cover']}";
    }

    return Ebook(
      id: json['id'],
      nama: json['nama'] ?? '',
      slug: json['slug'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      harga: json['harga'],
      cover: gambar,
      penulis: json['penulis'],
      penerbit: json['penerbit'],
      tahunTerbit: json['tahun_terbit'],
      jumlahHalaman: json['jumlah_halaman'],
      isbn: json['isbn'],
      isFree: json['is_free'] ?? false,
      isPublished: json['is_published'] ?? false,
      type: json['type'],
    );
  }
}
