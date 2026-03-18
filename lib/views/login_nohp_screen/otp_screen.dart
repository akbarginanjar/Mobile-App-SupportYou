import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/views/widgets/button.dart';
import 'package:mobile_supportyou/controllers/auth_controller.dart';

class OtpInputScreen extends StatelessWidget {
  OtpInputScreen({super.key});

  final controller = Get.find<AuthController>(); // 🔥 PENTING

  @override
  Widget build(BuildContext context) {
    final String phone = Get.arguments;

    return Scaffold(
      appBar: AppBar(title: const Text('Verifikasi OTP')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kode OTP dikirim ke', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(
              phone,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            Obx(
              () => controller.countdown.value > 0
                  ? Text(
                      'Kirim ulang OTP dalam ${controller.countdown.value} detik',
                      style: TextStyle(color: Colors.grey),
                    )
                  : DefaultButtonSecond(
                      text: 'Kirim ulang OTP',
                      press: () {
                        controller.requestOtp();
                      },
                    ),
            ),
            const SizedBox(height: 10),

            TextField(
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: controller.updateOtp,
              decoration: const InputDecoration(labelText: 'Masukkan OTP'),
            ),

            const SizedBox(height: 10),
            DefaultButton(
              text: 'Verifikasi OTP',
              press: () {
                controller.otpVerifikasi();
              },
              color: primary,
            ),
          ],
        ),
      ),
    );
  }
}
