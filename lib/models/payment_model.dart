// lib/models/payment_model.dart
class PaymentMethod {
  final String name;
  final String? code;
  final String? imageUrl;
  final String? number;
  final String? description;
  final String? type;
  final int? fee;
  
  PaymentMethod({
    required this.name,
    this.code,
    this.imageUrl,
    this.number,
    this.description,
    this.type,
    this.fee,
  });
}

class PaymentGroup {
  final String group;
  final List<PaymentMethod> items;
  
  PaymentGroup({
    required this.group,
    required this.items,
  });
}

class TransactionFee {
  final String code;
  final String name;
  final int nominal;
  
  TransactionFee({
    required this.code,
    required this.name,
    required this.nominal,
  });
}