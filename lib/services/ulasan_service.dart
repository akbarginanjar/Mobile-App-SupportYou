import 'package:get_storage/get_storage.dart';

class UlasanService {
  final GetStorage _storage = GetStorage();
  static const String _keyPrefix = 'ulasan_';

  void saveUlasan(int transaksiId, int rating, String komentar) {
    final key = '$_keyPrefix$transaksiId';
    _storage.write(key, {
      'rating': rating,
      'komentar': komentar,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Map<String, dynamic>? getUlasan(int transaksiId) {
    final key = '$_keyPrefix$transaksiId';
    return _storage.read(key);
  }

  bool hasUlasan(int transaksiId) {
    final key = '$_keyPrefix$transaksiId';
    return _storage.read(key) != null;
  }

  void deleteUlasan(int transaksiId) {
    final key = '$_keyPrefix$transaksiId';
    _storage.remove(key);
  }
}