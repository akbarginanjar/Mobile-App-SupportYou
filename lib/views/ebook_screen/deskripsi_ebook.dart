import 'package:flutter/material.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';

class EbookDeskripsi extends StatelessWidget {
  final Ebook ebook;
  const EbookDeskripsi({super.key, required this.ebook});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        ebook.deskripsi ?? 'Tidak ada deskripsi',
        style: Theme.of(context).textTheme.bodySmall
      ),
    );
  }
}
