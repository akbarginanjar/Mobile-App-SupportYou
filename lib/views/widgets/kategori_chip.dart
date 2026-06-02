import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/models/kategori_model.dart';

class KategoriChip extends StatelessWidget {
  final KategoriModel kategori;
  final VoidCallback onTap;
  final bool isSelected;

  const KategoriChip({
    super.key,
    required this.kategori,
    required this.onTap,
    this.isSelected = false,
  });

  IconData _getCategoryIcon(String categoryName) {
    final name = categoryName.toLowerCase();
    if (name.contains('digital') || name.contains('marketing') || name.contains('e-commerce')) {
      return Icons.shopping_cart_rounded;
    } else if (name.contains('desain') || name.contains('kreatif')) {
      return Icons.design_services_rounded;
    } else if (name.contains('bisnis') || name.contains('kewirausahaan')) {
      return Icons.business_center_rounded;
    } else if (name.contains('pengembangan') || name.contains('diri')) {
      return Icons.psychology_rounded;
    } else if (name.contains('keuangan') || name.contains('investasi')) {
      return Icons.show_chart_rounded;
    }
    return Icons.category_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        kategori.namaKategori,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: isSelected ? theme : textTheme.withValues(alpha: 0.8),
        ),
      ),
      avatar: Icon(
        _getCategoryIcon(kategori.namaKategori),
        size: 18,
        color: isSelected ? theme : primary,
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: theme,
      selectedColor: primary,
      showCheckmark: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          color: isSelected ? primary : textTheme.withValues(alpha: 0.15),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }
}