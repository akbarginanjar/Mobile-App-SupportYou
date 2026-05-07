// lib/services/riwayat_pelatihan_service.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/utils/base.dart';

class RiwayatPelatihanService extends GetConnect {
  final GetStorage _storage = GetStorage();
  
  String? _getToken() {
    try {
      final tokens = _storage.read('tokens');
      if (tokens != null && tokens is Map) {
        final token = tokens['token'] ?? tokens['access_token'];
        return token;
      } else if (tokens != null && tokens is String) {
        return tokens;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  int? _getMemberId() {
    return _storage.read('member_id');
  }
  
  Map<String, String> _getHeaders() {
    final token = _getToken();
    final headers = {
      'secret': 'aKndsan23928h98hKJbkjwlKHD9dsbjwiobqUJGHBDWHvkHSJQUBSQOPSAJHVwoihdapq',
      'device': 'mobile',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    if (token != null && token.isNotEmpty) {
      headers['author'] = 'Bearer $token';
    }
    
    return headers;
  }
  
  /// 🔥 Ambil daftar pelatihan yang sudah dibeli
  Future<List<PelatihanDibeli>> getPelatihanDibeli() async {
    final memberId = _getMemberId();
    
    if (memberId == null || memberId == 0) {
      debugPrint('❌ Member ID not found');
      return [];
    }
    
    final url = '${Base.url}v1/pelatihan/pelatihan-dibeli?konsumen_member_id=$memberId';
    
    debugPrint('📤 GET Pelatihan Dibeli: $url');
    
    try {
      final response = await get(url, headers: _getHeaders());
      
      debugPrint('📥 Response Status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final body = response.body;
        List result = [];
        
        if (body['data'] is List) {
          result = body['data'];
        }
        
        final pelatihanDibeli = result
            .whereType<Map<String, dynamic>>()
            .map((json) => PelatihanDibeli.fromJson(json))
            .toList();
        
        debugPrint('✅ Loaded ${pelatihanDibeli.length} purchased items');
        return pelatihanDibeli;
      } else {
        debugPrint('❌ HTTP Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('❌ Network Error: $e');
      return [];
    }
  }
}

/// 🔥 Model untuk pelatihan yang sudah dibeli
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
      mitra: json['mitra'] != null ? Mitra.fromJson(json['mitra']) : null,
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
      id: json['id'],
      pelatihanId: json['pelatihan_id'],
      kodeAkses: json['kode_akses'] ?? '',
      qrCode: json['qr_code'],
      transaksiId: json['transaksi_id'],
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
      id: json['id'],
      pelatihanId: json['pelatihan_id'],
      path: json['path'],
      isMain: json['is_main'] ?? false,
    );
  }
  
  String get url => '${Base.url}$path';
}