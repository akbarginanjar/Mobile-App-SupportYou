import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/controllers/pelatihan_controller.dart';

class PelatihanScreen extends StatelessWidget {
  final PelatihanController controller = Get.put(PelatihanController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.pelatihanList.isEmpty) {
        return const Center(child: Text('Belum ada pelatihan'));
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pelatihan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.pelatihanList.length,
              itemBuilder: (context, index) {
                final p = controller.pelatihanList[index];
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 10),
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (p.cover != null)
                        Image.network(
                          p.cover!,
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                        else
                        Container(
                          height: 120,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            p.nama,
                            style: Theme.of(context).textTheme.titleSmall,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}