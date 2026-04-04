import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/auth_controller.dart';
import 'package:mobile_supportyou/views/widgets/button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController authController = Get.put(AuthController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _showPassword = true;
  bool _showKonfirmasiPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar SupportYou'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Buat Akun',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Lengkapi form untuk mendaftar sebagai affiliator',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 30),

                // --- Nama Lengkap ---
                _buildLabel('Nama Lengkap'),
                TextFormField(
                  controller: authController.namaLengkapController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan nama lengkap',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (v) => v!.isEmpty ? 'Nama tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),

                // --- Username (TAMBAHAN SESUAI PAYLOAD) ---
                _buildLabel('Username'),
                TextFormField(
                  controller: authController.usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan username',
                    prefixIcon: Icon(Icons.alternate_email),
                  ),
                  validator: (v) => v!.isEmpty ? 'Username tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),

                // --- Nomor HP ---
                _buildLabel('Nomor HP / WhatsApp'),
                TextFormField(
                  controller: authController.phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '08123xxx',
                    prefixIcon: Icon(Icons.phone_android),
                  ),
                  validator: (v) => v!.length < 10 ? 'Nomor HP tidak valid' : null,
                ),
                const SizedBox(height: 16),

                // --- Email ---
                _buildLabel('Email'),
                TextFormField(
                  controller: authController.emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'contoh@mail.com',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) => !GetUtils.isEmail(v!) ? 'Email tidak valid' : null,
                ),
                const SizedBox(height: 16),

                // --- Password ---
                _buildLabel('Password'),
                TextFormField(
                  controller: authController.passwordController,
                  obscureText: _showPassword,
                  decoration: InputDecoration(
                    hintText: '******',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _showPassword = !_showPassword),
                    ),
                  ),
                  validator: (v) => v!.length < 6 ? 'Minimal 6 karakter' : null,
                ),
                const SizedBox(height: 16),

                // --- Konfirmasi Password ---
                _buildLabel('Konfirmasi Password'),
                TextFormField(
                  controller: authController.konfirmasiPasswordController,
                  obscureText: _showKonfirmasiPassword,
                  decoration: InputDecoration(
                    hintText: '******',
                    prefixIcon: const Icon(Icons.lock_reset),
                    suffixIcon: IconButton(
                      icon: Icon(_showKonfirmasiPassword ? Icons.visibility : Icons.visibility_off),
                      onPressed: () => setState(() => _showKonfirmasiPassword = !_showKonfirmasiPassword),
                    ),
                  ),
                  validator: (v) {
                    if (v != authController.passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 35),

                // --- Tombol Daftar ---
                Obx(() => DefaultButton(
                  text: authController.isLoading.value ? 'Mendaftarkan...' : 'Daftar',
                  press: authController.isLoading.value 
                    ? () {} 
                    : () {
                        if (_formKey.currentState!.validate()) {
                          authController.register();
                        }
                      },
                  color: primary,
                )),

                const SizedBox(height: 20),

                // --- Footer Login ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sudah punya akun?', style: Theme.of(context).textTheme.bodyMedium),
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'Login',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget untuk label agar kode lebih bersih
  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}