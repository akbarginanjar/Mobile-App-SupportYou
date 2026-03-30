import 'package:flutter/material.dart';
import 'package:mobile_supportyou/models/ebook_model.dart';

class EbookSpesifikasi extends StatelessWidget {
  final Ebook ebook;
  const EbookSpesifikasi({super.key, required this.ebook});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(title: Text("Penulis: ${ebook.penulis ?? '-'}")),
        ListTile(title: Text("Penerbit: ${ebook.penerbit ?? '-'}")),
      ],
    );
  }
}
