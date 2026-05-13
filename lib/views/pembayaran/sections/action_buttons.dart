import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/main_controller.dart';
import 'package:mobile_supportyou/views/main_screen/screen.dart';
import 'package:mobile_supportyou/views/pembayaran/widgets/komplain_dialog.dart';

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
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (status == 'pending' && statusBayar == 'belum_lunas')
            ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                minimumSize: const Size(double.infinity, 48),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Batalkan Pesanan',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          
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
                    icon: const Icon(Icons.report_problem_outlined, color: Colors.white),
                    label: Text(
                      'Komplain',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

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
            icon: const Icon(Icons.history, color: Colors.white),
            label: Text(
              'Lihat Pesanan Lain',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
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