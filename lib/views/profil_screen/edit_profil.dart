// lib/views/profil_screen/edit_profil.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/controllers/edit_profil_controller.dart';

class EditProfilScreen extends StatelessWidget {
  const EditProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EditProfilController controller = Get.put(EditProfilController());
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Edit Profil',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: primary,
        actions: [
          TextButton(
            onPressed: () => controller.updateProfile(),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildAvatarSection(context, controller),
                const SizedBox(height: 24),
                
                _buildTextField(
                  context,
                  controller: controller.namaLengkapController,
                  label: 'Nama Lengkap',
                  icon: Icons.person_outline,
                  hint: 'Masukkan nama lengkap',
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  context,
                  controller: controller.emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  hint: 'Masukkan email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  context,
                  controller: controller.noHpController,
                  label: 'No WhatsApp',
                  icon: Icons.phone_android_outlined,
                  hint: 'Masukkan nomor WhatsApp',
                  keyboardType: TextInputType.phone,
                ),
                
                const SizedBox(height: 32),
                
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 20, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Perubahan akan langsung tersimpan dan diperbarui di halaman profil',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 80),
              ],
            ),
          ),
          
          // Loading overlay
          if (controller.isLoading.value)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildAvatarSection(BuildContext context, EditProfilController controller) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.snackbar(
              'Info',
              'Fitur ganti foto profil akan segera hadir',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                controller.namaLengkapController.text.isNotEmpty 
                    ? controller.namaLengkapController.text[0].toUpperCase() 
                    : 'U',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Foto Profil',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        InkWell(
          onTap: () {
            Get.snackbar(
              'Info',
              'Fitur ganti foto profil akan segera hadir',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          child: Text(
            'Klik untuk ubah foto',
            style: TextStyle(
              fontSize: 10,
              color: primary,
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
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
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey[500]),
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
        ),
      ],
    );
  }
}