import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:google_fonts/google_fonts.dart';

loadingPage() {
  Get.dialog(
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.2),
    const Center(
      child: SizedBox(
        height: 115,
        child: Card(
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                CircularProgressIndicator(strokeWidth: 3),
                SizedBox(height: 15),
                Text('Loading...', style: TextStyle(fontSize: 10)),
              ],
            ),
          ),
        ),
      ), // Menampilkan indikator loading
    ),
  );
}

noInternet() {
  Get.dialog(
    barrierColor: Colors.black.withOpacity(0.2),
    Center(
      child: SizedBox(
        width: 300,
        height: 195,
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.wifi, color: textTheme),
                    const SizedBox(width: 10),
                    Text(
                      'Tidak ada internet',
                      style: TextStyle(
                        color: textTheme,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  'Silahkan periksa kembali koneksi internet anda.',
                  style: TextStyle(color: textTheme, fontSize: 14),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primary),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text(
                    'OKE',
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ), // Menampilkan indikator loading
    ),
  );
}

// Fungsi untuk menampilkan pesan alert
showErrorDialog(String message) {
  Get.dialog(
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.2),
    AlertDialog(
      title: const Text('Login Gagal!'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          },
          child: const Text('OKE'),
        ),
      ],
    ),
  );
}
