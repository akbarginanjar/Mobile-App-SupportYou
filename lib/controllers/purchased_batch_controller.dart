// lib/controllers/purchased_batch_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_supportyou/models/riwayat_pelatihan_model.dart';
import 'package:mobile_supportyou/services/riwayat_pelatihan_service.dart';

class PurchasedBatchController extends GetxController {
  final RiwayatPelatihanService _riwayatService = RiwayatPelatihanService();

  final isLoading = false.obs;
  final purchasedBatchIds = <int, Set<int>>{}.obs;

  Future<void> loadPurchasedBatchesForPelatihan(int pelatihanId) async {
    if (pelatihanId == 0) return;

    isLoading.value = true;

    try {
      final List<PelatihanDibeli> purchasedPelatihan = await _riwayatService.getPelatihanDibeli();
      final Set<int> batchIds = {};

      for (var item in purchasedPelatihan) {
        if (item.id == pelatihanId && item.selectedBatch != null) {
          batchIds.add(item.selectedBatch!.id);
        }
      }

      purchasedBatchIds[pelatihanId] = batchIds;
    } catch (e) {
      debugPrint('Error loading purchased batches: $e');
      purchasedBatchIds[pelatihanId] = {};
    } finally {
      isLoading.value = false;
    }
  }

  Set<int> getPurchasedBatchIds(int pelatihanId) {
    return purchasedBatchIds[pelatihanId] ?? {};
  }

  void clear() {
    purchasedBatchIds.clear();
  }
}