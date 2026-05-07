// lib/views/profil_screen/ganti_password.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/edit_profil_controller.dart';

class GantiPasswordScreen extends StatelessWidget {
  const GantiPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditProfilController());
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Ganti Password',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primary,
        actions: [
          TextButton(
            onPressed: () => controller.updatePassword(),
            child: Text(
              'Simpan',
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: Obx(() => Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header icon
                Container(
                  margin: const EdgeInsets.only(bottom: 24, top: 20),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.lock_reset,
                    size: 40,
                    color: Colors.orange[700],
                  ),
                ),
                
                Text(
                  'Ubah Password',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masukkan password lama dan password baru Anda',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Password Lama
                _buildPasswordField(
                  context,
                  controller: controller.passwordLamaController,
                  label: 'Password Lama',
                  icon: Icons.lock_outline,
                  hint: 'Masukkan password lama',
                ),
                const SizedBox(height: 16),
                
                // Password Baru
                _buildPasswordField(
                  context,
                  controller: controller.passwordBaruController,
                  label: 'Password Baru',
                  icon: Icons.lock_outline,
                  hint: 'Masukkan password baru (min. 6 karakter)',
                ),
                const SizedBox(height: 16),
                
                // Konfirmasi Password Baru
                _buildPasswordField(
                  context,
                  controller: controller.konfirmasiPasswordBaruController,
                  label: 'Konfirmasi Password Baru',
                  icon: Icons.lock_outline,
                  hint: 'Konfirmasi password baru',
                ),
                
                const SizedBox(height: 32),
                
                // Password rules
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Persyaratan Password:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Minimal 6 karakter',
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 14, color: Colors.grey[500]),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Gunakan kombinasi huruf dan angka untuk keamanan',
                              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
              ],
            ),
          ),
          
          // Loading overlay
          if (controller.isLoadingPassword.value)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      )),
    );
  }
  
  Widget _buildPasswordField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
  }) {
    final obscureText = true.obs;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => TextFormField(
          controller: controller,
          obscureText: obscureText.value,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey[500]),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText.value ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: Colors.grey[500],
              ),
              onPressed: () => obscureText.toggle(),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primary, width: 1.5),
            ),
          ),
        )),
      ],
    );
  }
}