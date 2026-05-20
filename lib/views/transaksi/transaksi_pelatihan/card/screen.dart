import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/transaksi_model.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/utils/date_formatter.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';
import 'package:mobile_supportyou/views/pembayaran/screen.dart';

class TransaksiCard extends StatelessWidget {
  final Transaksi transaksi;

  const TransaksiCard({super.key, required this.transaksi});

  Color _getStatusColor() {
    switch (transaksi.status) {
      case 'pending':
        return warning;
      case 'dibatalkan':
        return danger;
      case 'expired':
        return Colors.grey;
      case 'selesai':
        return success;
      default:
        return primary;
    }
  }

  Pelatihan _createPelatihanFromTransaksi() {
    final item = transaksi.item.isNotEmpty ? transaksi.item[0] : null;
    
    return Pelatihan(
      id: item?.pelatihanId ?? 0,
      nama: item?.nama ?? 'Pelatihan',
      slug: '',
      deskripsi: null,
      harga: item?.harga ?? 0,
      hargaFinal: item?.harga,
      tempat: null,
      waktu: transaksi.waktuTransaksi,
      cover: null,
      type: transaksi.transactionType == 'pelatihan' ? 'pelatihan' : 'ebook',
      typePelatihan: null,
      maxPeserta: null,
      mitra: null,
      sections: [],
      testimonials: [],
      speaker: null,
      penulis: null,
      penerbit: null,
      tahunTerbit: null,
      jumlahHalaman: null,
      isbn: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final formattedDate = DateFormatter.formatDateWithDayAndTime(transaksi.waktuTransaksi);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: theme,
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          final pelatihan = _createPelatihanFromTransaksi();
          Get.to(
            () => PembayaranScreen(
              idTransaksi: transaksi.id,
              pelatihan: pelatihan,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  transaksi.status,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              Text(
                transaksi.noInvoice,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: textTheme,
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tanggal Transaksi",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: textTheme,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: textTheme,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Nominal",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: textTheme,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Formatter.formatCurrency(transaksi.totalBayar),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: textTheme.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Produk",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: textTheme,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaksi.item.isNotEmpty ? transaksi.item[0].nama : '-',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: textTheme,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (transaksi.item.isNotEmpty)
                      Text(
                        'x${transaksi.item[0].qty}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: textTheme,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}