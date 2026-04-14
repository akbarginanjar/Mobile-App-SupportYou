class Pelatihan {
  final int id;
  final String nama;
  final String slug;
  final String? deskripsi;
  final int harga;
  final int? hargaFinal;
  final String? tempat;
  final String? waktu;
  final String? cover;
  final String type; // 'pelatihan' atau 'ebook'
  final String? typePelatihan;
  final int? maxPeserta;
  final Mitra? mitra;
  final List<Section> sections;
  final List<Testimonial> testimonials;
  final Speaker? speaker;

  // Field khusus Ebook
  final String? penulis;
  final String? penerbit;
  final int? tahunTerbit;
  final int? jumlahHalaman;
  final String? isbn;

  Pelatihan({
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
    this.sections = const [],
    this.testimonials = const [],
    this.speaker,
    this.penulis,
    this.penerbit,
    this.tahunTerbit,
    this.jumlahHalaman,
    this.isbn,
  });

  factory Pelatihan.fromJson(Map<String, dynamic> json) {
    return Pelatihan(
      id: json['id'],
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
      // Mapping Object Mitra
      mitra: json['mitra'] != null ? Mitra.fromJson(json['mitra']) : null,
      // Mapping List Sections
      sections: (json['sections'] as List?)
              ?.map((e) => Section.fromJson(e))
              .toList() ?? [],
      // Mapping List Testimonials
      testimonials: (json['testimonials'] as List?)
              ?.map((e) => Testimonial.fromJson(e))
              .toList() ?? [],
      // Mapping Object Speaker
      speaker: json['speakers'] != null ? Speaker.fromJson(json['speakers']) : null,
      // Field Ebook
      penulis: json['penulis'],
      penerbit: json['penerbit'],
      tahunTerbit: json['tahun_terbit'],
      jumlahHalaman: json['jumlah_halaman'],
      isbn: json['isbn'],
    );
  }
}

class Mitra {
  final int id;
  final String nama;

  Mitra({required this.id, required this.nama});

  factory Mitra.fromJson(Map<String, dynamic> json) {
    return Mitra(
      id: json['id'],
      nama: json['nama_lengkap'] ?? json['nama'] ?? '-',
    );
  }
}

class Section {
  final String title;
  final String content;
  final String type;

  Section({required this.title, required this.content, required this.type});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class Testimonial {
  final String name;
  final String content;

  Testimonial({required this.name, required this.content});

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      name: json['name'] ?? 'Anonim',
      content: json['content'] ?? '',
    );
  }
}

class Speaker {
  final String name;
  final String? position;
  final String? bio;

  Speaker({required this.name, this.position, this.bio});

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      name: json['name'] ?? '',
      position: json['position'],
      bio: json['bio'],
    );
  }
}