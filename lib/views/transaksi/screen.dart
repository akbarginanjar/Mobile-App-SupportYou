import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_pelatihan/screen.dart';
import 'package:mobile_supportyou/views/transaksi/transaksi_ebook/screen.dart';

class PilihTransaksiScreen extends StatelessWidget {
  const PilihTransaksiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pilih Pesanan Anda',
          style: TextStyle(color: textTheme),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: primary),
        backgroundColor: theme,
        surfaceTintColor: theme,
        shape: Border(bottom: BorderSide(color: textTheme)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTransactionButton(
              icon: Icons.shopping_bag_outlined,
              text: 'Transaksi Pelatihan',
              onTap: () {
                Get.to(() => TransaksiPelatihanScreen());
              },
            ),
            const SizedBox(height: 10),
            _buildTransactionButton(
              icon: Icons.school_outlined,
              text: 'Transaksi E-Book',
              onTap: () {
                Get.to(() => TransaksiEbookScreen());
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return Card(
      color: theme,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Row(
            children: [
              Icon(icon, color: primary, size: 28),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textTheme,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: primary, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}