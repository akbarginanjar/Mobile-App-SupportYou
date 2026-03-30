import 'package:flutter/material.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';

class EbookInfo extends StatelessWidget {
  final Ebook ebook;
  const EbookInfo({super.key, required this.ebook});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(ebook.nama ?? 'Tanpa Judul'),
      subtitle: Text(ebook.penulis ?? ''),
    );
  }
}
