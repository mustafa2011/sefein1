const String tableInvoices = 'invoices';
const String tableInvoiceLines = 'invoice_lines';

class InvoiceFields {
  static const String id = 'id';
  static const String invoiceNo = 'invoiceNo';
  static const String date = 'date';
  static const String supplyDate = 'supplyDate';
  static const String sellerId = 'sellerId';
  static const String total = 'total';
  static const String totalVat = 'totalVat';
  static const String posted = 'posted';
  static const String payerId = 'payerId';
  static const String noOfLines = 'noOfLines';
  static const String project = 'project';
  static const String paymentMethod = 'paymentMethod';

  static List<String> getInvoiceFields() => [
        id,
        invoiceNo,
        date,
        supplyDate,
        sellerId,
        total,
        totalVat,
        posted,
        payerId,
        noOfLines,
        project,
        paymentMethod
      ];
}

class Invoice {
  final int? id;
  final String invoiceNo;
  final String date;
  final String supplyDate;
  final int? sellerId;
  final num total;
  final num totalVat;
  final int posted;
  final int? payerId;
  final int noOfLines;
  final String project;
  final String paymentMethod;

  Invoice({
    this.id,
    this.invoiceNo = '',
    this.date = '',
    this.supplyDate = '',
    this.sellerId,
    this.total = 0.0,
    this.totalVat = 0.0,
    this.posted = 0,
    this.payerId,
    this.noOfLines = 0,
    this.project = '',
    this.paymentMethod = '',
  }); //: date = date ?? DateTime.now();

  Invoice copy({
    int? id,
    String? invoiceNo,
    String? date,
    String? supplyDate,
    int? sellerId,
    num? total,
    num? totalVat,
    int? posted,
    int? payerId,
    int? noOfLines,
    String? project,
    String? paymentMethod,
  }) =>
      Invoice(
        id: id ?? this.id,
        invoiceNo: invoiceNo ?? this.invoiceNo,
        date: date ?? this.date,
        supplyDate: supplyDate ?? this.supplyDate,
        sellerId: sellerId ?? this.sellerId,
        total: total ?? this.total,
        totalVat: totalVat ?? this.totalVat,
        posted: posted ?? this.posted,
        payerId: payerId ?? this.payerId,
        noOfLines: noOfLines ?? this.noOfLines,
        project: project ?? this.project,
        paymentMethod: paymentMethod ?? this.paymentMethod,
      );

  factory Invoice.fromJson(dynamic json) {
    return Invoice(
      id: json[InvoiceFields.id] as int,
      invoiceNo: json[InvoiceFields.invoiceNo] as String,
      date: json[InvoiceFields.date] as String,
      supplyDate: json[InvoiceFields.supplyDate] as String,
      sellerId: json[InvoiceFields.sellerId] as int,
      total: json[InvoiceFields.total] as num,
      totalVat: json[InvoiceFields.totalVat] as num,
      posted: json[InvoiceFields.posted] as int,
      payerId: json[InvoiceFields.payerId] as int,
      noOfLines: json[InvoiceFields.noOfLines] as int,
      project: json[InvoiceFields.project] as String,
      paymentMethod: json[InvoiceFields.paymentMethod] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        InvoiceFields.id: id,
        InvoiceFields.invoiceNo: invoiceNo,
        InvoiceFields.date: date,
        InvoiceFields.supplyDate: supplyDate,
        InvoiceFields.sellerId: sellerId,
        InvoiceFields.total: total,
        InvoiceFields.totalVat: totalVat,
        InvoiceFields.posted: posted,
        InvoiceFields.payerId: payerId,
        InvoiceFields.noOfLines: noOfLines,
        InvoiceFields.project: project,
        InvoiceFields.paymentMethod: paymentMethod,
      };

  String toParams() => "?id=$id"
      "&invoiceNo=$invoiceNo"
      "&date=$date"
      "&supplyDate=$supplyDate"
      "&sellerId=$sellerId"
      "&total=$total"
      "&totalVat=$totalVat"
      "&posted=$posted"
      "&payerId=$payerId"
      "&noOfLines=$noOfLines"
      "&project=$project"
      "&paymentMethod=$paymentMethod";
}

class InvoiceLinesFields {
  static const String recId = 'recId';
  static const String id = 'id';
  static const String productName = 'productName';
  static const String price = 'price';
  static const String qty = 'qty';

  static List<String> getInvoiceLinesFields() =>
      [recId, id, productName, price, qty];
}

class InvoiceLines {
  final int? id;
  final int recId;
  final String productName;
  final num price;
  final int qty;

  InvoiceLines({
    this.id,
    required this.recId,
    required this.productName,
    required this.price,
    this.qty = 1,
  });

  InvoiceLines copy({
    int? id,
    int? recId,
    String? productName,
    num? price,
    int? qty,
  }) =>
      InvoiceLines(
        id: id ?? this.id,
        recId: recId ?? this.recId,
        productName: productName ?? this.productName,
        price: price ?? this.price,
        qty: qty ?? this.qty,
      );

  factory InvoiceLines.fromJson(dynamic json) {
    return InvoiceLines(
      id: json[InvoiceLinesFields.id] as int,
      recId: json[InvoiceLinesFields.recId] as int,
      productName: json[InvoiceLinesFields.productName],
      price: json[InvoiceLinesFields.price] as num,
      qty: json[InvoiceLinesFields.qty] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        InvoiceLinesFields.id: id,
        InvoiceLinesFields.recId: recId,
        InvoiceLinesFields.productName: productName,
        InvoiceLinesFields.price: price,
        InvoiceLinesFields.qty: qty,
      };

  String toParams() => "?id=$id"
      "&recId=$recId"
      "&productName=$productName"
      "&price=$price"
      "&qty=$qty";
}

class Invoice1 {
  final int? id;
  final String invoiceNo;
  final String date;
  final String supplyDate;
  final int? sellerId;
  final num total;
  final num totalVat;
  final int posted;
  final int? payerId;
  final int noOfLines;
  final String project;
  final String paymentMethod;
  final String name;

  Invoice1({
    this.id,
    this.invoiceNo = '',
    this.date = '',
    this.supplyDate = '',
    this.sellerId,
    this.total = 0.0,
    this.totalVat = 0.0,
    this.posted = 0,
    this.payerId,
    this.noOfLines = 0,
    this.project = '',
    this.paymentMethod = '',
    this.name = '',
  }); //: date = date ?? DateTime.now();
  factory Invoice1.fromJson(dynamic json) {
    return Invoice1(
      id: json['id'] as int,
      invoiceNo: json['invoiceNo'] as String,
      date: json['date'] as String,
      supplyDate: json['supplyDate'] as String,
      sellerId: json['sellerId'] as int,
      total: json['total'] as num,
      totalVat: json['totalVat'] as num,
      posted: json['posted'] as int,
      payerId: json['payerId'] as int,
      noOfLines: json['noOfLines'] as int,
      project: json['project'] as String,
      paymentMethod: json['paymentMethod'] as String,
      name: json['name'] as String,
    );
  }
}
