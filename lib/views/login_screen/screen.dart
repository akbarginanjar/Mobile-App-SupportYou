import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/auth_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            SizedBox(
              height: 150,
              child: Image.asset('assets/logo/supportyou-logo-icon.png'),
            ),
            const SizedBox(height: 20),
            Text(
              'Masuk ke SupportYou',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 30),

            // Input Email
            TextFormField(
              controller: authController.emailController,
              decoration: const InputDecoration(
                hintText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 15),

            // Input Password dengan toggle
            Obx(() => TextFormField(
                  controller: authController.passwordController,
                  obscureText: authController.isLoading.value, // bisa diganti toggle show/hide
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                )),
            const SizedBox(height: 20),

            // Tombol Login
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  authController.login();
                },
                child: const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}