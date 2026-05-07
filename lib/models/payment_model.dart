// lib/models/payment_model.dart
import 'package:mobile_supportyou/utils/value_formatter.dart';

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

class Discount {
  final int id;
  final String name;
  final String ownedBy;
  final dynamic member;
  final String type;
  final int value;
  
  Discount({
    required this.id,
    required this.name,
    required this.ownedBy,
    this.member,
    required this.type,
    required this.value,
  });
  
  factory Discount.fromJson(Map<String, dynamic> json) {
    return Discount(
      id: json['id'],
      name: json['name'],
      ownedBy: json['owned_by'],
      member: json['member'],
      type: json['type'],
      value: json['value'],
    );
  }
  
  int calculateDiscount(int price) {
    if (type == 'percentage') {
      return (price * value / 100).floor();
    } else {
      return value; // nominal
    }
  }
  
  String getFormattedValue() {
    if (type == 'percentage') {
      return '$value%';
    } else {
      return Formatter.formatCurrency(value);
    }
  }
}