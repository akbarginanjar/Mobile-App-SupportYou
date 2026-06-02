class Pelatihan {
  final int id;
  final String nama;
  final String slug;
  final String? deskripsi;
  final int harga;
  final int? hargaFinal;
  final String? tempat;
  final String? waktu;
  final String? startTime;
  final String? endTime;
  final String? cover;
  final String type;
  final String? typePelatihan;
  final int? maxPeserta;
  final Mitra? mitra;
  final List<Section> sections;
  final List<Testimonial> testimonials;
  final Speaker? speaker;
  final int? tokoMemberId;
  final String? penulis;
  final String? penerbit;
  final int? tahunTerbit;
  final int? jumlahHalaman;
  final String? isbn;
  final List<Batch> batches;
  final String? level;
  final double? rating;
  final int? ratingCount;
  final bool isDiskonAktif;
  final int? hargaCoret;
  final int? hargaSetelahDiskon;

  Pelatihan({
    required this.id,
    required this.nama,
    required this.slug,
    this.deskripsi,
    required this.harga,
    this.hargaFinal,
    this.tempat,
    this.waktu,
    this.startTime,
    this.endTime,
    this.cover,
    required this.type,
    this.typePelatihan,
    this.maxPeserta,
    this.mitra,
    this.sections = const [],
    this.testimonials = const [],
    this.speaker,
    this.tokoMemberId,
    this.penulis,
    this.penerbit,
    this.tahunTerbit,
    this.jumlahHalaman,
    this.isbn,
    this.batches = const [],
    this.level,
    this.rating,
    this.ratingCount,
    this.isDiskonAktif = false,
    this.hargaCoret,
    this.hargaSetelahDiskon,
  });

  int get displayPrice {
    if (isDiskonAktif && hargaSetelahDiskon != null) {
      return hargaSetelahDiskon!;
    }
    if (hargaFinal != null && hargaFinal! < harga) {
      return hargaFinal!;
    }
    return harga;
  }

  int? get originalPrice {
    if (isDiskonAktif && hargaCoret != null) {
      return hargaCoret;
    }
    if (hargaFinal != null && hargaFinal! < harga) {
      return harga;
    }
    return null;
  }

  factory Pelatihan.fromJson(Map<String, dynamic> json) {
    int? tokoMemberId;
    if (json['mitra'] != null) {
      tokoMemberId = json['mitra']['member_id'] ?? json['mitra']['id'];
    }
    
    return Pelatihan(
      id: json['id'],
      nama: json['nama'] ?? '',
      slug: json['slug'] ?? '',
      deskripsi: json['deskripsi'],
      harga: json['harga'] ?? 0,
      hargaFinal: json['harga_final'],
      tempat: json['tempat'],
      waktu: json['waktu'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      cover: json['cover'],
      type: json['type'] ?? 'pelatihan',
      typePelatihan: json['type_pelatihan'],
      maxPeserta: json['max_peserta'],
      mitra: json['mitra'] != null ? Mitra.fromJson(json['mitra']) : null,
      sections: (json['sections'] as List?)
              ?.map((e) => Section.fromJson(e))
              .toList() ?? [],
      testimonials: (json['testimonials'] as List?)
              ?.map((e) => Testimonial.fromJson(e))
              .toList() ?? [],
      speaker: json['speakers'] != null ? Speaker.fromJson(json['speakers']) : null,
      tokoMemberId: tokoMemberId,
      penulis: json['penulis'],
      penerbit: json['penerbit'],
      tahunTerbit: json['tahun_terbit'],
      jumlahHalaman: json['jumlah_halaman'],
      isbn: json['isbn'],
      batches: (json['batches'] as List?)
              ?.map((e) => Batch.fromJson(e))
              .toList() ?? [],
      level: json['level'],
      rating: json['rating'] != null 
          ? (json['rating'] is int 
              ? (json['rating'] as int).toDouble() 
              : (json['rating'] as num).toDouble())
          : null,
      ratingCount: json['rating_count'],
      isDiskonAktif: json['is_diskon_aktif'] ?? false,
      hargaCoret: json['harga_coret'],
      hargaSetelahDiskon: json['harga_setelah_diskon'],
    );
  }
}

class Mitra {
  final int id;
  final String nama;
  final int? memberId;
  
  Mitra({
    required this.id, 
    required this.nama,
    this.memberId,
  });

  factory Mitra.fromJson(Map<String, dynamic> json) {
    return Mitra(
      id: json['id'],
      nama: json['nama_lengkap'] ?? json['nama'] ?? '-',
      memberId: json['member_id'] ?? json['id'],
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
  final String? createdAt;

  Testimonial({required this.name, required this.content, this.createdAt});

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      name: json['name'] ?? 'Anonim',
      content: json['content'] ?? '',
      createdAt: json['created_at'],
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

class Batch {
  final int id;
  final String kodeBatch;
  final String namaBatch;
  final String? tanggalMulai;
  final String? tanggalSelesai;
  final String? jamMulai;
  final String? jamSelesai;
  final int maxPeserta;
  final String status;
  final String? meetingLink;
  final String? tempat;
  final int pesertaTerdaftar;
  final int sisaPeserta;
  final bool isPublished;

  Batch({
    required this.id,
    required this.kodeBatch,
    required this.namaBatch,
    this.tanggalMulai,
    this.tanggalSelesai,
    this.jamMulai,
    this.jamSelesai,
    required this.maxPeserta,
    required this.status,
    this.meetingLink,
    this.tempat,
    required this.pesertaTerdaftar,
    required this.sisaPeserta,
    this.isPublished = false,
  });

  factory Batch.fromJson(Map<String, dynamic> json) {
    return Batch(
      id: json['id'],
      kodeBatch: json['kode_batch'] ?? '',
      namaBatch: json['nama_batch'] ?? '',
      tanggalMulai: json['tanggal_mulai'],
      tanggalSelesai: json['tanggal_selesai'],
      jamMulai: json['jam_mulai'],
      jamSelesai: json['jam_selesai'],
      maxPeserta: json['max_peserta'] ?? 0,
      status: json['status'] ?? '',
      meetingLink: json['meeting_link'],
      tempat: json['tempat'],
      pesertaTerdaftar: json['peserta_terdaftar'] ?? 0,
      sisaPeserta: json['sisa_peserta'] ?? 0,
      isPublished: json['is_published'] ?? false,
    );
  }

  String get formattedDateRange {
    if (tanggalMulai == null || tanggalSelesai == null) return 'Belum ditentukan';
    final start = _formatDate(tanggalMulai!);
    final end = _formatDate(tanggalSelesai!);
    return '$start – $end';
  }

  String get formattedTimeRange {
    if (jamMulai == null || jamSelesai == null) return 'Belum ditentukan';
    return '${_formatTime(jamMulai!)} – ${_formatTime(jamSelesai!)} WIB';
  }

  String _formatDate(String date) {
    try {
      final parts = date.split('-');
      if (parts.length == 3) {
        return '${parts[2]} ${_getMonthName(int.parse(parts[1]))} ${parts[0]}';
      }
      return date;
    } catch (e) {
      return date;
    }
  }

  String _formatTime(String time) {
    try {
      final parts = time.split(':');
      if (parts.length >= 2) {
        return '${parts[0]}:${parts[1]}';
      }
      return time;
    } catch (e) {
      return time;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }
}