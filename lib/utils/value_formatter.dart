import 'package:intl/intl.dart';

class Formatter {
  static String formatCurrency(int? value) {
    if (value == null) return '-';
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
}
