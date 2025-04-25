import 'package:intl/intl.dart';

extension IntExtensions on int {
  String formatCurrency({String symbol = 'Rp', bool withSymbol = true}) {
    final format = NumberFormat.currency(
      locale: 'id_ID',
      symbol: withSymbol ? '$symbol ' : '',
      decimalDigits: 0,
    );
    return format.format(this);
  }
}
