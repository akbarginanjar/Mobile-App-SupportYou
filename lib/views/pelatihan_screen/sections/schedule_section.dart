// lib/views/pelatihan_screen/sections/schedule_section.dart (perbarui)
import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/utils/date_formatter.dart';

class ScheduleSection extends StatefulWidget {
  final String? startTime;
  final String? endTime;
  final int? maxPeserta;
  final List<Batch> batches;
  final Function(Batch?) onBatchSelected;
  final Set<int> purchasedBatchIds;

  const ScheduleSection({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.maxPeserta,
    required this.batches,
    required this.onBatchSelected,
    this.purchasedBatchIds = const {},
  });

  @override
  State<ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends State<ScheduleSection> {
  Batch? _selectedBatch;
  List<ScheduleItem> _allSchedules = [];

  @override
  void initState() {
    super.initState();
    _buildScheduleList();
  }

  void _buildScheduleList() {
    _allSchedules.clear();

    if (widget.startTime != null && widget.startTime!.isNotEmpty) {
      _allSchedules.add(
        ScheduleItem(
          id: 0,
          isMain: true,
          name: 'Jadwal Utama',
          startTime: widget.startTime!,
          endTime: widget.endTime,
          maxPeserta: widget.maxPeserta ?? 0,
          isPurchased: false,
        ),
      );
    }

    final publishedBatches = widget.batches.where((b) => b.isPublished).toList();
    for (var batch in publishedBatches) {
      final isPurchased = widget.purchasedBatchIds.contains(batch.id);
      _allSchedules.add(
        ScheduleItem(
          id: batch.id,
          isMain: false,
          name: batch.namaBatch,
          startTime: batch.tanggalMulai != null && batch.jamMulai != null
              ? '${batch.tanggalMulai} ${batch.jamMulai}'
              : '',
          endTime: batch.tanggalSelesai != null && batch.jamSelesai != null
              ? '${batch.tanggalSelesai} ${batch.jamSelesai}'
              : null,
          maxPeserta: batch.maxPeserta,
          originalBatch: batch,
          isPurchased: isPurchased,
        ),
      );
    }
  }

  String _formatScheduleDate(String dateTimeString) {
    if (dateTimeString.isEmpty) return 'Belum ditentukan';
    try {
      final parts = dateTimeString.split(' ');
      if (parts.length >= 2) {
        return DateFormatter.formatDateWithMonthName(parts[0]);
      }
      return DateFormatter.formatDateWithMonthName(dateTimeString);
    } catch (e) {
      return dateTimeString;
    }
  }

  String _formatScheduleTime(String dateTimeString) {
    if (dateTimeString.isEmpty) return 'Belum ditentukan';
    try {
      final parts = dateTimeString.split(' ');
      if (parts.length >= 2) {
        final timeParts = parts[1].split(':');
        if (timeParts.length >= 2) {
          return '${timeParts[0]}:${timeParts[1]} WIB';
        }
      }
      return DateFormatter.formatTimeOnly(dateTimeString);
    } catch (e) {
      return dateTimeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_allSchedules.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today, size: 18, color: primary),
              const SizedBox(width: 8),
              Text(
                'Pilih Jadwal Pelatihan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_allSchedules.length} jadwal tersedia',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          ..._allSchedules.map((schedule) => _buildScheduleCard(schedule)),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleItem schedule) {
    final isSelected = schedule.isMain
        ? (_selectedBatch == null)
        : (_selectedBatch?.id == schedule.id);
    final isDisabled = schedule.isPurchased;

    final date = _formatScheduleDate(schedule.startTime);
    final time = _formatScheduleTime(schedule.startTime);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: isDisabled ? 0.5 : 1.0,
        child: InkWell(
          onTap: isDisabled
              ? null
              : () {
                  setState(() {
                    if (schedule.isMain) {
                      _selectedBatch = null;
                      widget.onBatchSelected(null);
                    } else {
                      _selectedBatch = schedule.originalBatch;
                      widget.onBatchSelected(schedule.originalBatch);
                    }
                  });
                },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? primary.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? primary : Colors.grey[200]!,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (schedule.isMain)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'UTAMA',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  color: primary,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            schedule.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? primary : Colors.black87,
                            ),
                          ),
                          if (isDisabled)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'SUDAH DIBELI',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            date,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.people_outline, size: 12, color: Colors.grey[600]),
                          const SizedBox(width: 6),
                          Text(
                            'Maksimal ${schedule.maxPeserta} peserta',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isSelected && !isDisabled)
                  Icon(
                    Icons.check_circle,
                    color: primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScheduleItem {
  final int id;
  final bool isMain;
  final String name;
  final String startTime;
  final String? endTime;
  final int maxPeserta;
  final Batch? originalBatch;
  final bool isPurchased;

  ScheduleItem({
    required this.id,
    required this.isMain,
    required this.name,
    required this.startTime,
    this.endTime,
    required this.maxPeserta,
    this.originalBatch,
    required this.isPurchased,
  });
}