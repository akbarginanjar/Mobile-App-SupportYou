import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_supportyou/config/theme.dart';

class InfoSection extends StatelessWidget {
  final String nama;
  final String? deskripsi;
  final String typePelatihan;
  final String? waktu;
  final String? tempat;
  final int maxPeserta;
  final String speakerName;
  final String? speakerPosition;
  final int ratingCount;
  final double rating;

  const InfoSection({
    super.key,
    required this.nama,
    this.deskripsi,
    required this.typePelatihan,
    required this.waktu,
    required this.tempat,
    required this.maxPeserta,
    required this.speakerName,
    this.speakerPosition,
    this.ratingCount = 0,
    this.rating = 0,
  });

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null || dateTimeString.isEmpty) return 'Belum ditentukan';
    try {
      final DateTime dateTime = DateTime.parse(dateTimeString);
      return DateFormat('EEEE, d MMMM y HH:mm', 'id').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }

  String _getDuration() {
    if (waktu == null || waktu!.isEmpty) return 'Belum ditentukan';
    try {
      final DateTime startTime = DateTime.parse(waktu!);
      final DateTime endTime = startTime.add(const Duration(hours: 2));
      final difference = endTime.difference(startTime);
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      if (hours > 0 && minutes > 0) {
        return '+ $hours Jam $minutes Menit';
      } else if (hours > 0) {
        return '+ $hours Jam';
      } else {
        return '+ $minutes Menit';
      }
    } catch (e) {
      return '± 2 Jam';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (deskripsi != null && deskripsi!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        deskripsi!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Row(
                children: [
                  ...List.generate(5, (index) {
                    if (index < rating.floor()) {
                      return const Icon(Icons.star, color: Colors.amber, size: 16);
                    } else if (index < rating.ceil() && rating % 1 != 0) {
                      return const Icon(Icons.star_half, color: Colors.amber, size: 16);
                    } else {
                      return const Icon(Icons.star_border, color: Colors.amber, size: 16);
                    }
                  }),
                ],
              ),
              const SizedBox(width: 8),
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '($ratingCount ulasan)',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$maxPeserta peserta',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildInfoChip(Icons.timeline, 'Semua Level'),
              _buildInfoChip(Icons.access_time, _getDuration()),
              _buildInfoChip(
                typePelatihan == 'offline' ? Icons.location_on : Icons.video_library,
                typePelatihan == 'offline' ? 'Offline' : 'Live Online',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dibuat oleh',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      speakerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (speakerPosition != null && speakerPosition!.isNotEmpty)
                      Text(
                        speakerPosition!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}