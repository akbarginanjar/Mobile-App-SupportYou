import 'package:flutter/material.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';

class PelatihanCardVertical extends StatelessWidget {
  final Pelatihan pelatihan;
  final VoidCallback? onPress;

  const PelatihanCardVertical({
    super.key,
    required this.pelatihan,
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPress,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: pelatihan.cover != null
                    ? Image.network(
                        pelatihan.cover!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/image/pelatihan_placeholder.jpg',
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/image/pelatihan_placeholder.jpg',
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            // Nama pelatihan
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                pelatihan.nama,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Spacer(),
            // Nama penyelenggara
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Text(
                pelatihan.asosiasi?.nama ?? '-',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            // Harga + icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Formatter.formatCurrency(pelatihan.harga),
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: primary),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: theme,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
