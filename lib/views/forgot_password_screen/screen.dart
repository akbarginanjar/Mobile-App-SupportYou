// lib/views/forgot_password_screen/screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/views/widgets/button.dart';
import 'package:mobile_supportyou/services/auth_service.dart';
import 'package:mobile_supportyou/views/login_screen/screen.dart';
import 'package:mobile_supportyou/views/register_screen/screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _requestResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.requestForgotPassword(_emailController.text);
      
      if (response.statusCode == 200) {
        Get.snackbar(
          'Berhasil',
          'Link reset password telah dikirim ke email Anda',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        Get.offAll(() => const LoginScreen());
      } else {
        String errorMessage = 'Gagal mengirim link reset password';
        if (response.body is Map && response.body['message'] != null) {
          errorMessage = response.body['message'];
        }
        if (response.body is Map && response.body['errors'] != null) {
          final errors = response.body['errors'];
          if (errors['email'] != null && errors['email'] is List) {
            errorMessage = errors['email'][0];
          }
        }
        Get.snackbar(
          'Gagal',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Center(
                    child: SizedBox(
                      height: 150,
                      child: Image.asset('assets/logo/supportyou-logo-icon.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'Reset Password',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masukkan email terdaftar kamu, kami akan mengirimkan link reset password.',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!GetUtils.isEmail(val)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'contoh@email.com',
                    prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 24),
                DefaultButton(
                  text: _isLoading ? 'Mengirim...' : 'Kirim Link Reset Password',
                  press: _isLoading ? null : _requestResetPassword,
                  color: primary,
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.offAll(() => const LoginScreen());
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 16, color: primary),
                        const SizedBox(width: 4),
                        Text(
                          'Kembali ke Login',
                          style: TextStyle(color: primary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun?',
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offAll(() => const RegisterScreen());
                      },
                      child: Text(
                        'Daftar Sekarang',
                        style: TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}