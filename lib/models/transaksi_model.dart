// lib/models/transaksi_model.dart
class Transaksi {
  final int id;
  final dynamic toko;
  final String transactionType;
  final String noInvoice;
  final String waktuTransaksi;
  final String metodeBayar;
  final int uangMasuk;
  final int ongkir;
  final int totalBayar;
  final String statusBayar;
  final String status;
  final dynamic kodeBayar;
  final dynamic kodeBayarDetail;
  final dynamic kodeUnik;
  final dynamic shipmentOption;
  final String expireTime;
  final dynamic processOrderExpireTime;
  final int biayaLayanan;
  final int biayaAplikasi;
  final int biayaPg;
  final int biayaTransportasi;
  final dynamic member;
  final List<ItemTransaksi> item;
  final CustomerTransaksi customer;
  final List<dynamic> refunds;
  final List<dynamic> ulasan;
  final dynamic paymentInfo;
  final dynamic buktiTf;

  Transaksi({
    required this.id,
    this.toko,
    required this.transactionType,
    required this.noInvoice,
    required this.waktuTransaksi,
    required this.metodeBayar,
    required this.uangMasuk,
    required this.ongkir,
    required this.totalBayar,
    required this.statusBayar,
    required this.status,
    this.kodeBayar,
    this.kodeBayarDetail,
    this.kodeUnik,
    this.shipmentOption,
    required this.expireTime,
    this.processOrderExpireTime,
    required this.biayaLayanan,
    required this.biayaAplikasi,
    required this.biayaPg,
    required this.biayaTransportasi,
    this.member,
    required this.item,
    required this.customer,
    required this.refunds,
    required this.ulasan,
    this.paymentInfo,
    this.buktiTf,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'],
      toko: json['toko'],
      transactionType: json['transaction_type'] ?? '',
      noInvoice: json['no_invoice'] ?? '',
      waktuTransaksi: json['waktu_transaksi'] ?? '',
      metodeBayar: json['metode_bayar'] ?? '',
      uangMasuk: json['uang_masuk'] ?? 0,
      ongkir: json['ongkir'] ?? 0,
      totalBayar: json['total_bayar'] ?? 0,
      statusBayar: json['status_bayar'] ?? '',
      status: json['status'] ?? '',
      kodeBayar: json['kode_bayar'],
      kodeBayarDetail: json['kode_bayar_detail'],
      kodeUnik: json['kode_unik'],
      shipmentOption: json['shipment_option'],
      expireTime: json['expire_time'] ?? '',
      processOrderExpireTime: json['process_order_expire_time'],
      biayaLayanan: json['biaya_layanan'] ?? 0,
      biayaAplikasi: json['biaya_aplikasi'] ?? 0,
      biayaPg: json['biaya_pg'] ?? 0,
      biayaTransportasi: json['biaya_transportasi'] ?? 0,
      member: json['member'],
      item: (json['item'] as List?)?.map((e) => ItemTransaksi.fromJson(e)).toList() ?? [],
      customer: CustomerTransaksi.fromJson(json['customer'] ?? {}),
      refunds: json['refunds'] ?? [],
      ulasan: json['ulasan'] ?? [],
      paymentInfo: json['payment_info'],
      buktiTf: json['bukti_tf'],
    );
  }
}

class ItemTransaksi {
  final int id;
  final int pelatihanId;
  final String nama;
  final int qty;
  final int harga;
  final int totalHarga;
  final dynamic diskon;

  ItemTransaksi({
    required this.id,
    required this.pelatihanId,
    required this.nama,
    required this.qty,
    required this.harga,
    required this.totalHarga,
    this.diskon,
  });

  factory ItemTransaksi.fromJson(Map<String, dynamic> json) {
    return ItemTransaksi(
      id: json['id'],
      pelatihanId: json['pelatihan_id'] ?? 0,
      nama: json['nama'] ?? '',
      qty: json['qty'] ?? 0,
      harga: json['harga'] ?? 0,
      totalHarga: json['total_harga'] ?? 0,
      diskon: json['diskon'],
    );
  }
}

class CustomerTransaksi {
  final String nama;
  final String email;
  final String noHp;
  final String? jenisKelamin;
  final dynamic dataPengiriman;
  final String? linkGmaps;

  CustomerTransaksi({
    required this.nama,
    required this.email,
    required this.noHp,
    this.jenisKelamin,
    this.dataPengiriman,
    this.linkGmaps,
  });

  factory CustomerTransaksi.fromJson(Map<String, dynamic> json) {
    return CustomerTransaksi(
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
      noHp: json['no_hp'] ?? '',
      jenisKelamin: json['jenis_kelamin'],
      dataPengiriman: json['data_pengiriman'],
      linkGmaps: json['link_gmaps'],
    );
  }
}