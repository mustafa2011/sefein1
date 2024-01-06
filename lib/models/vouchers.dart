const String tableVouchers = 'vouchers';

class VoucherFields {
  static const String id = 'id';
  static const String date = 'date';
  static const String type = 'type';

  /// values: [PAYMENT], [RECEIPT], [EXPENSE], [DAMAGE].
  static const String name = 'name';
  static const String desc = 'desc';
  static const String voucherTo = 'voucherTo';
  static const String amount = 'amount';

  static List<String> getVoucherFields() =>
      [id, date, type, name, desc, voucherTo, amount];
}

class Voucher {
  final int? id;
  final String date;
  final String type;
  final String name;
  final String desc;
  final String voucherTo;
  final num amount;

  const Voucher({
    this.id,
    required this.date,
    this.type = '',
    this.name = '',
    this.desc = '',
    this.voucherTo = '',
    this.amount = 0.0,
  });

  Voucher copy({
    int? id,
    String? date,
    String? type,
    String? name,
    String? desc,
    String? voucherTo,
    num? amount,
  }) =>
      Voucher(
        id: id ?? this.id,
        date: date ?? this.date,
        type: type ?? this.type,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        voucherTo: voucherTo ?? this.voucherTo,
        amount: amount ?? this.amount,
      );

  factory Voucher.fromJson(dynamic json) {
    return Voucher(
      id: json[VoucherFields.id] as int,
      date: json[VoucherFields.date] as String,
      type: json[VoucherFields.type] as String,
      name: json[VoucherFields.name] as String,
      desc: json[VoucherFields.desc] as String,
      voucherTo: json[VoucherFields.voucherTo] as String,
      amount: json[VoucherFields.amount] as num,
    );
  }

  Map<String, dynamic> toJson() => {
        VoucherFields.id: id,
        VoucherFields.date: date,
        VoucherFields.type: type,
        VoucherFields.name: name,
        VoucherFields.desc: desc,
        VoucherFields.voucherTo: voucherTo,
        VoucherFields.amount: amount,
      };
}
