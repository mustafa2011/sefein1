const String tablePurchases = 'purchases';

class PurchaseFields {
  static const String id = 'id';
  static const String date = 'date';
  static const String vendor = 'vendor';
  static const String vendorInvoiceNo = 'vendorInvoiceNo';
  static const String vendorVatNumber = 'vendorVatNumber';
  static const String total = 'total';
  static const String totalVat = 'totalVat';

  static List<String> getPurchaseFields() =>
      [id, date, vendor, vendorInvoiceNo, vendorVatNumber, total, totalVat];
}

class Purchase {
  final int? id;
  final String date;
  final String vendor;
  final String vendorInvoiceNo;
  final String vendorVatNumber;
  final num total;
  final num totalVat;

  Purchase({
    this.id,
    this.date = '',
    this.vendor = '',
    this.vendorInvoiceNo = '',
    this.vendorVatNumber = '',
    this.total = 0.0,
    this.totalVat = 0.0,
  });

  Purchase copy({
    int? id,
    String? date,
    String? vendor,
    String? vendorInvoiceNo,
    String? vendorVatNumber,
    num? total,
    num? totalVat,
  }) =>
      Purchase(
        id: id ?? this.id,
        date: date ?? this.date,
        vendor: vendor ?? this.vendor,
        vendorInvoiceNo: vendorInvoiceNo ?? this.vendorInvoiceNo,
        vendorVatNumber: vendorVatNumber ?? this.vendorVatNumber,
        total: total ?? this.total,
        totalVat: totalVat ?? this.totalVat,
      );

  factory Purchase.fromJson(dynamic json) {
    return Purchase(
      id: json[PurchaseFields.id] as int,
      date: json[PurchaseFields.date] as String,
      vendor: json[PurchaseFields.vendor] as String,
      vendorInvoiceNo: json[PurchaseFields.vendorInvoiceNo] as String,
      vendorVatNumber: json[PurchaseFields.vendorVatNumber] as String,
      total: json[PurchaseFields.total] as num,
      totalVat: json[PurchaseFields.totalVat] as num,
    );
  }

  Map<String, dynamic> toJson() => {
        PurchaseFields.id: id,
        PurchaseFields.date: date,
        PurchaseFields.vendor: vendor,
        PurchaseFields.vendorInvoiceNo: vendorInvoiceNo,
        PurchaseFields.vendorVatNumber: vendorVatNumber,
        PurchaseFields.total: total,
        PurchaseFields.totalVat: totalVat,
      };

  String toParams() => "?id=$id"
      "&date=$date"
      "&vendor=$vendor"
      "&vendorInvoiceNo=$vendorInvoiceNo"
      "&vendorVatNumber=$vendorVatNumber"
      "&total=$total"
      "&totalVat=$totalVat";
}
