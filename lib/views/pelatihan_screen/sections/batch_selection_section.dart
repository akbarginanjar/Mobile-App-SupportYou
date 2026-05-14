import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';

class BatchSelectionSection extends StatefulWidget {
  final List<Batch> batches;
  final Function(Batch?) onBatchSelected;

  const BatchSelectionSection({
    super.key,
    required this.batches,
    required this.onBatchSelected,
  });

  @override
  State<BatchSelectionSection> createState() => _BatchSelectionSectionState();
}

class _BatchSelectionSectionState extends State<BatchSelectionSection> {
  Batch? _selectedBatch;

  @override
  void initState() {
    super.initState();
    if (widget.batches.isNotEmpty) {
      _selectedBatch = widget.batches.first;
      widget.onBatchSelected(_selectedBatch);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.batches.isEmpty) {
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
                'Pilih jadwal batch di bawah',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih jadwal yang sesuai dengan Anda',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<Batch>(
            value: _selectedBatch,
            isExpanded: true,
            decoration: InputDecoration(
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
                borderSide: BorderSide(color: primary),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: widget.batches.map((batch) {
              return DropdownMenuItem(
                value: batch,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      batch.namaBatch,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      batch.formattedDateRange,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedBatch = value;
              });
              widget.onBatchSelected(_selectedBatch);
            },
          ),
          if (_selectedBatch != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${_selectedBatch!.formattedDateRange}, ${_selectedBatch!.formattedTimeRange}',
                      style: TextStyle(
                        fontSize: 12,
                        color: primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}