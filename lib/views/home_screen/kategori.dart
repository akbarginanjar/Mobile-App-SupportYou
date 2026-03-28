import 'package:flutter/material.dart';

class KategoriScreen extends StatelessWidget {
  const KategoriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Kategori Kursus",
                style: Theme.of(context).textTheme.titleMedium
              ),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    const Text(
                      "Lihat Semua",
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded)
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 170,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Image.network(
                            "https://images.pexels.com/photos/3913025/pexels-photo-3913025.jpeg",
                            fit: BoxFit.cover,
                            width: 130,
                            height: 170,
                          ),
                          Container(
                            width: 130,
                            height: 170,
                            color: Colors.black.withOpacity(0.3),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: SizedBox(
                                width: 130,
                                child: const Text(
                                  "AI Generatif",
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Image.network(
                            "https://images.pexels.com/photos/2102416/pexels-photo-2102416.jpeg",
                            fit: BoxFit.cover,
                            width: 130,
                            height: 170,
                          ),
                          Container(
                            width: 130,
                            height: 170,
                            color: Colors.black.withOpacity(0.3),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: SizedBox(
                                width: 130,
                                child: const Text(
                                  "Sertifikasi TI",
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Image.network(
                            "https://images.pexels.com/photos/5380664/pexels-photo-5380664.jpeg",
                            fit: BoxFit.cover,
                            width: 130,
                            height: 170,
                          ),
                          Container(
                            width: 130,
                            height: 170,
                            color: Colors.black.withOpacity(0.3),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: SizedBox(
                                width: 130,
                                child: const Text(
                                  "Ilmu Data",
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Image.network(
                            "https://images.pexels.com/photos/5904086/pexels-photo-5904086.jpeg",
                            fit: BoxFit.cover,
                            width: 130,
                            height: 170,
                          ),
                          Container(
                            width: 130,
                            height: 170,
                            color: Colors.black.withOpacity(0.3),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: SizedBox(
                                width: 130,
                                child: const Text(
                                  "Desain UI/UX",
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Image.network(
                            "https://images.pexels.com/photos/6476254/pexels-photo-6476254.jpeg",
                            fit: BoxFit.cover,
                            width: 130,
                            height: 170,
                          ),
                          Container(
                            width: 130,
                            height: 170,
                            color: Colors.black.withOpacity(0.3),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: SizedBox(
                                width: 130,
                                child: const Text(
                                  "Pemasaran Digital",
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          Image.network(
                            "https://images.pexels.com/photos/5475752/pexels-photo-5475752.jpeg",
                            fit: BoxFit.cover,
                            width: 130,
                            height: 170,
                          ),
                          Container(
                            width: 130,
                            height: 170,
                            color: Colors.black.withOpacity(0.3),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: SizedBox(
                                width: 130,
                                child: const Text(
                                  "Keamanan Siber",
                                  textAlign: TextAlign.center,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}