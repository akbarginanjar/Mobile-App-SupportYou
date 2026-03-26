class Pelatihan {
  final int id;
  final String nama;
  final String deskripsi;
  final String? cover;

  Pelatihan({
    required this.id,
    required this.nama,
    required this.deskripsi,
    this.cover,
  });

// di model Pelatihan
factory Pelatihan.fromJson(Map<String, dynamic> json) {
  String? gambar;
  if (json['attachments'] != null && json['attachments'].isNotEmpty) {
    gambar = "https://api-supportyou.kehosting.in/storage/${json['attachments'][0]['path']}";
  }
  return Pelatihan(
    id: json['id'],
    nama: json['nama'] ?? '',
    deskripsi: json['deskripsi'] ?? '',
    cover: gambar,
  );
}
}