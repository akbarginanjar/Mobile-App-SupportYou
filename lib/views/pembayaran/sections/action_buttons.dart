import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/main_controller.dart';
import 'package:mobile_supportyou/views/main_screen/screen.dart';
import 'package:mobile_supportyou/views/pembayaran/widgets/komplain_dialog.dart';
import 'package:mobile_supportyou/views/pembayaran/widgets/ulasan_dialog.dart';
import 'package:mobile_supportyou/services/ulasan_service.dart';
import 'package:mobile_supportyou/utils/date_formatter.dart';

class ActionButtons extends StatelessWidget {
  final Map<String, dynamic> data;
  final String? refundStatus;
  final int transaksiId;
  final String produkNama;
  final VoidCallback onCancel;

  const ActionButtons({
    super.key,
    required this.data,
    required this.refundStatus,
    required this.transaksiId,
    required this.produkNama,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final status = data['status'] ?? '';
    final statusBayar = data['status_bayar'] ?? '';
    final UlasanService ulasanService = UlasanService();
    final bool hasUlasan = ulasanService.hasUlasan(transaksiId);
    final Map<String, dynamic>? ulasanData = ulasanService.getUlasan(transaksiId);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (status == 'pending' && statusBayar == 'belum_lunas')
            ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: danger,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 48),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Batalkan Pesanan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: theme,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          
          if (status == 'selesai' && statusBayar == 'lunas' && refundStatus != 'pending')
            if (hasUlasan && ulasanData != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.black, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Ulasan Anda',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: List.generate(5, (index) {
                        final starNumber = index + 1;
                        return Icon(
                          starNumber <= (ulasanData['rating'] ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          size: 18,
                          color: Colors.amber,
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      ulasanData['komentar'] ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: textTheme.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormatter.formatDateWithMonthName(ulasanData['created_at']),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: textTheme.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await Get.dialog(
                          UlasanDialog(
                            transaksiId: transaksiId,
                            produkNama: produkNama,
                          ),
                          barrierDismissible: false,
                        );
                        if (result == true) {
                          Get.snackbar(
                            'Terima Kasih',
                            'Ulasan Anda sangat membantu',
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: success,
                            colorText: Colors.white,
                          );
                        }
                      },
                      icon: Icon(Icons.star_rate_rounded, color: theme),
                      label: Text(
                        'Beri Ulasan',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: theme,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),

          if (status == 'selesai' && statusBayar == 'lunas' && refundStatus != 'pending' && !hasUlasan)
            const SizedBox(height: 12),
          
          if (status == 'selesai' && statusBayar == 'lunas' && refundStatus != 'pending')
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.dialog(
                        KomplainDialog(
                          transaksiId: transaksiId,
                          transaksiNoInvoice: data['no_invoice'] ?? '-',
                          produkNama: produkNama,
                        ),
                        barrierDismissible: false,
                      );
                    },
                    icon: Icon(Icons.report_problem_outlined, color: theme),
                    label: Text(
                      'Komplain',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: theme,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: warning,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

          if ((status == 'selesai' && statusBayar == 'lunas' && refundStatus != 'pending') || (status == 'pending' && statusBayar == 'belum_lunas'))
            const SizedBox(height: 12),
          
          ElevatedButton.icon(
            onPressed: () {
              if (Get.isRegistered<MainController>()) {
                Get.find<MainController>().changeIndex(1);
                Get.offAll(() => const MainScreen());
              } else {
                Get.put(MainController());
                Get.offAll(() => const MainScreen());
                Future.delayed(const Duration(milliseconds: 100), () {
                  if (Get.isRegistered<MainController>()) {
                    Get.find<MainController>().changeIndex(1);
                  }
                });
              }
            },
            icon: Icon(Icons.history, color: theme),
            label: Text(
              'Lihat Pesanan Lain',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: theme,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: const Size(double.infinity, 48),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}