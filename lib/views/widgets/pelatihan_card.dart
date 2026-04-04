import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/config/theme.dart';
import 'package:mobile_supportyou/utils/value_formatter.dart';
import 'package:mobile_supportyou/models/pelatihan_model.dart';
import 'package:mobile_supportyou/views/pelatihan_screen/screen.dart';

class PelatihanCard extends StatelessWidget {
  final Pelatihan pelatihan;
  final VoidCallback? onPress;

  const PelatihanCard({
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
        onTap: () => Get.to(() => PelatihanScreen(slug: pelatihan.id.toString())),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
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
    
            // Judul pelatihan
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                pelatihan.nama,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
    
            const Spacer(),
    
            // 🔹 Waktu + Tempat / Type Pelatihan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, size: 16),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      pelatihan.waktu ?? '-',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
// 🔹 Tempat hanya muncul jika offline
if (pelatihan.typePelatihan == "online") 
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
    child: Row(
      children: [
        const Icon(Icons.place, size: 16),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            'Online',
            style: Theme.of(context).textTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  ),
            const SizedBox(height: 4,),
            // Penyelenggara
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
                    Formatter.formatCurrency(pelatihan.hargaFinal ?? pelatihan.harga),
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