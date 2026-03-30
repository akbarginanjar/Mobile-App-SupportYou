import 'package:flutter/material.dart';

class EbookSkeleton extends StatelessWidget {
  const EbookSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }
}
