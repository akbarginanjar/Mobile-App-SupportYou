import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/controllers/profil_controller.dart';

class ProfilHeader extends StatelessWidget {
  final ProfilController controller;

  const ProfilHeader({super.key, required this.controller});

  String getFullImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return 'https://api-supportyou.kehosting.in/$path';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Obx(() {
            final photoUrl = controller.userPhoto.value;
            final name = controller.userName.value;
            final initial = (name.isNotEmpty && name != 'Pengguna') ? name[0].toUpperCase() : 'U';

            return Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: photoUrl.isNotEmpty
                    ? Image.network(
                        getFullImageUrl(photoUrl),
                        fit: BoxFit.cover,
                        cacheWidth: 200,
                        cacheHeight: 200,
                        key: ValueKey(photoUrl),
                        errorBuilder: (context, error, stackTrace) => _buildInitialAvatar(initial),
                      )
                    : _buildInitialAvatar(initial),
              ),
            );
          }),
          const SizedBox(height: 12),
          Obx(() => Text(
                controller.userName.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              )),
          const SizedBox(height: 4),
          Obx(() => Text(
                controller.userEmail.value,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 14,
                ),
              )),
          const SizedBox(height: 4),
          Obx(() => Text(
                controller.userPhone.value,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInitialAvatar(String initial) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2196f3),
          ),
        ),
      ),
    );
  }
}