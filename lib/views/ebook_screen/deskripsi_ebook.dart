import 'package:flutter/material.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_supportyou/config/theme.dart';

class EbookDeskripsi extends StatelessWidget {
  final Ebook ebook;
  const EbookDeskripsi({super.key, required this.ebook});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        ebook.deskripsi ?? 'Tidak ada deskripsi',
        style: GoogleFonts.montserrat(color: textTheme, fontSize: 14),
      ),
    );
  }
}
