// lib/models/kategori_model.dart
class KategoriModel {
  final int id;
  final String namaKategori;
  final String slug;
  final String foto;
  final String deskripsi;
  final bool status;
  final String createdAt;
  final String updatedAt;

  KategoriModel({
    required this.id,
    required this.namaKategori,
    required this.slug,
    required this.foto,
    required this.deskripsi,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KategoriModel.fromJson(Map<String, dynamic> json) {
    return KategoriModel(
      id: json['id'],
      namaKategori: json['nama_kategori'] ?? '',
      slug: json['slug'] ?? '',
      foto: json['foto'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      status: json['status'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}