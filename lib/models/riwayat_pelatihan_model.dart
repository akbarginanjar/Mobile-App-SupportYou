import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/utils/base.dart';

class PelatihanDibeli {
  final int id;
  final String nama;
  final String slug;
  final String? deskripsi;
  final int harga;
  final int? hargaFinal;
  final String? _tempat;
  final String? _waktu;
  final String? cover;
  final String type;
  final String? _typePelatihan;
  final int? maxPeserta;
  final Mitra? mitra;
  final String status;
  final String? _startTime;
  final String? _endTime;
  final String? _meetingLink;
  final String? linkGmaps;
  final List<RincianTransaksi> rincianTransaksi;
  final List<Attachment> attachments;
  final Batch? selectedBatch;

  String? get tempat => selectedBatch?.tempat ?? _tempat;
  String? get waktu {
    if (selectedBatch != null && selectedBatch!.tanggalMulai != null) {
      String date = selectedBatch!.tanggalMulai!;
      if (selectedBatch!.jamMulai != null) date += ' ${selectedBatch!.jamMulai}';
      return date;
    }
    return _waktu;
  }
  String? get typePelatihan => selectedBatch != null ? (selectedBatch!.tempat != null ? 'offline' : 'online') : _typePelatihan;
  String? get startTime {
    if (selectedBatch != null && selectedBatch!.tanggalMulai != null) {
      return '${selectedBatch!.tanggalMulai} ${selectedBatch!.jamMulai ?? ''}';
    }
    return _startTime;
  }
  String? get endTime {
    if (selectedBatch != null && selectedBatch!.tanggalSelesai != null) {
      return '${selectedBatch!.tanggalSelesai} ${selectedBatch!.jamSelesai ?? ''}';
    }
    return _endTime;
  }
  String? get meetingLink {
    if (selectedBatch != null && selectedBatch!.meetingLink != null) {
      return selectedBatch!.meetingLink;
    }
    return _meetingLink;
  }

  PelatihanDibeli({
    required this.id,
    required this.nama,
    required this.slug,
    this.deskripsi,
    required this.harga,
    this.hargaFinal,
    String? tempat,
    String? waktu,
    this.cover,
    required this.type,
    String? typePelatihan,
    this.maxPeserta,
    this.mitra,
    required this.status,
    String? startTime,
    String? endTime,
    String? meetingLink,
    this.linkGmaps,
    this.rincianTransaksi = const [],
    this.attachments = const [],
    this.selectedBatch,
  })  : _tempat = tempat,
        _waktu = waktu,
        _typePelatihan = typePelatihan,
        _startTime = startTime,
        _endTime = endTime,
        _meetingLink = meetingLink;

  String get coverUrl {
    if (cover != null && cover!.isNotEmpty) return '${Base.url}$cover';
    return '';
  }
  String get kodeAkses => rincianTransaksi.isNotEmpty ? rincianTransaksi.first.kodeAkses : '-';
  String get qrUrl => rincianTransaksi.isNotEmpty && rincianTransaksi.first.qrUrl != null ? rincianTransaksi.first.qrUrl! : '';

  factory PelatihanDibeli.fromJson(Map<String, dynamic> json) {
    Batch? selectedBatch;
    if (json['selected_batch'] != null) {
      selectedBatch = Batch.fromJson(json['selected_batch']);
    } else if (json['rincian_transaksi'] != null && json['rincian_transaksi'].isNotEmpty) {
      final rincian = json['rincian_transaksi'][0];
      if (rincian['batch'] != null) selectedBatch = Batch.fromJson(rincian['batch']);
    }
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
      rincianTransaksi: (json['rincian_transaksi'] as List?)?.map((e) => RincianTransaksi.fromJson(e)).toList() ?? [],
      attachments: (json['attachments'] as List?)?.map((e) => Attachment.fromJson(e)).toList() ?? [],
      selectedBatch: selectedBatch,
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
  RincianTransaksi({required this.id, required this.pelatihanId, required this.kodeAkses, this.qrCode, required this.transaksiId, this.qrUrl});
  factory RincianTransaksi.fromJson(Map<String, dynamic> json) => RincianTransaksi(
    id: json['id'] ?? 0,
    pelatihanId: json['pelatihan_id'] ?? 0,
    kodeAkses: json['kode_akses'] ?? '',
    qrCode: json['qr_code'],
    transaksiId: json['transaksi_id'] ?? 0,
    qrUrl: json['qr_url'],
  );
}

class Attachment {
  final int id;
  final int pelatihanId;
  final String path;
  final bool isMain;
  Attachment({required this.id, required this.pelatihanId, required this.path, required this.isMain});
  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
    id: json['id'] ?? 0,
    pelatihanId: json['pelatihan_id'] ?? 0,
    path: json['path'] ?? '',
    isMain: json['is_main'] ?? false,
  );
  String get url => '${Base.url}$path';
}