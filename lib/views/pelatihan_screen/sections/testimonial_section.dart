import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';

class TestimonialSection extends StatelessWidget {
  final List<Testimonial> testimonials;

  const TestimonialSection({
    super.key,
    required this.testimonials,
  });

  @override
  Widget build(BuildContext context) {
    if (testimonials.isEmpty) {
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
          Text(
            'Testimoni Peserta ${testimonials.length} ulasan',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: testimonials.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final testimonial = testimonials[index];
              return _buildTestimonialCard(context, testimonial);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(BuildContext context, Testimonial testimonial) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              Icons.star,
              color: Colors.amber[700],
              size: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          testimonial.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        if (testimonial.createdAt != null)
          Text(
            _formatDate(testimonial.createdAt!),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        const SizedBox(height: 8),
        Text(
          '"${testimonial.content}"',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('d MMM y', 'id').format(date);
    } catch (e) {
      return dateString;
    }
  }
}