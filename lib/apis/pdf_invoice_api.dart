import 'dart:convert';
import 'dart:io';

// import 'package:fatoora/apis/qr_tag/hashed_xml.dart';
// import 'package:fatoora/apis/qr_tag/key_buf.dart';
// import 'package:fatoora/apis/qr_tag/signature_buf.dart';

import '/apis/pdf_api.dart';
import '/apis/qr_tag/invoice_date.dart';
import '/apis/qr_tag/invoice_tax_amount.dart';
import '/apis/qr_tag/invoice_total_amount.dart';
import '/apis/qr_tag/qr_encoder.dart';
import '/apis/qr_tag/seller.dart';
import '/apis/qr_tag/tax_number.dart';
import '/db/fatoora_db.dart';
import '/models/customers.dart';
import '/models/invoice.dart';
import '/models/settings.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '/models/settings_ext.dart';
import 'constants/utils.dart';

class PdfInvoiceApi {
  static Future<File> generate(
      Invoice invoice,
      Customer customer,
      Setting seller,
      SettingExt sellerExt,
      List<InvoiceLines> invoiceLines,
      String title,
      String subTitle,
      bool isEstimate,
      bool isDemo) async {
    var myTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/fonts/Cairo-Regular.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/fonts/Cairo-Bold.ttf")),
      // base: Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
      // bold: Font.ttf(await rootBundle.load("assets/fonts/arialbd.ttf")),
    );
    final pdf = Document(
      theme: myTheme,
    );
    // final myFont = await rootBundle.load("assets/fonts/arial.ttf");

    pdf.addPage(MultiPage(
        margin: const EdgeInsets.all(30),
        build: (context) => [
              buildHeader(
                  invoice, customer, seller, title, subTitle, isEstimate),
              SizedBox(height: 1 * PdfPageFormat.cm),
              buildInvoice(invoice, invoiceLines),
              // Divider(),
              buildTotal(invoice, seller),
              Divider(),
              buildTerms(seller, sellerExt),
            ],
        footer: (context) {
          return isDemo
              ? Column(children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    UrlLink(
                        destination:
                            'https://wa.me/${Utils.defFullSupportNumber}',
                        child: Row(children: [
                          Text("ارسل رسالة واتساب للدعم الفني",
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: PdfColors.blue))
                        ])),
                    SizedBox(width: 5),
                    Text("نسخة تجريبية",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: PdfColors.red)),
                  ]),
                  UrlLink(
                      destination:
                          'https://wa.me/${Utils.defFullSupportNumber}',
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(Utils.defSupportNumber,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.blue)),
                            SizedBox(width: 5),
                            Text("رقم الدعم الفني",
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: PdfColors.blue))
                          ])),
                ])
              : Container(
                  alignment: Alignment.center,
                  child: Text(
                      "صفحة ${context.pagesCount}/${context.pageNumber}: ",
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: PdfColors.black)));
        }));
    String prefix = isEstimate ? 'QTN' : 'INV';

    return PdfApi.savePreviewDocument(
        name: '$prefix-${invoice.invoiceNo}.pdf',
        pdf: pdf,
        isEstimate: isEstimate,
        invoiceMonth: invoice.date.substring(5, 7),
        invoiceYear: invoice.date.substring(0, 4));
    // return PdfApi.savePDF(name: '${invoice.invoiceNo}.pdf', pdf: pdf);
  }

  static Future<String> getCustomerName(int? id) async {
    Customer customer = await FatooraDB.instance.getCustomerById(id!);
    return customer.name;
  }

  static Widget buildTerms(Setting seller, SettingExt sellerExt) {
    // final terms = seller.terms.split('|').length;
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(
          seller.terms == '' ? '' : 'الشروط والأحكام',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        Text(
          seller.terms,
          textDirection: TextDirection.rtl,
          style: const TextStyle(fontSize: 10),
        ),
        sellerExt.terms1 == ''
            ? Container()
            : Text(
                sellerExt.terms1,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 10),
              ),
        sellerExt.terms2 == ''
            ? Container()
            : Text(
                sellerExt.terms2,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 10),
              ),
        sellerExt.terms3 == ''
            ? Container()
            : Text(
                sellerExt.terms3,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 10),
              ),
        sellerExt.terms4 == ''
            ? Container()
            : Text(
                sellerExt.terms4,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 10),
              ),
        sellerExt.terms5 == ''
            ? Container()
            : Text(
                sellerExt.terms5,
                textDirection: TextDirection.rtl,
                style: const TextStyle(fontSize: 10),
              ),
      ])
    ]);
  }

  static Widget buildHeader(Invoice invoice, Customer customer, Setting seller,
          String title, String subTitle, bool isEstimate) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            buildLogo(seller),
            buildTitle(invoice, title, subTitle),
          ]),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildInvoiceInfo(invoice, title, isEstimate),
              Container(),
              // buildCustomerAddress(invoice.customer),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                width: 260,
                color: PdfColors.grey300,
                child: Text('بيانات المورد',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
              ),
              buildSimpleText(title: 'اسم المورد:', value: seller.seller),
              buildSimpleText(title: 'الرقم الضريبي:', value: seller.vatNumber),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  buildSimpleText(
                      title: 'رقم المبنى:', value: seller.buildingNo),
                  buildSimpleText(title: 'الحي:', value: seller.district),
                  buildSimpleText(title: 'البلد:', value: seller.country),
                  buildSimpleText(
                      title: 'الرقم الإضافي للعنوان:',
                      value: seller.additionalNo),
                ]),
                SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  buildSimpleText(
                      title: 'رقم الاتصال:', value: seller.cellphone),
                  buildSimpleText(title: 'الشارع:', value: seller.streetName),
                  buildSimpleText(title: 'المدينة:', value: seller.city),
                  buildSimpleText(
                      title: 'الرمز البريدي:', value: seller.postalCode),
                ]),
              ]),
            ]),
            SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Container(
                width: 260,
                color: PdfColors.grey300,
                child: Text('بيانات العميل',
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
              ),
              buildSimpleText(title: 'اسم العميل:', value: customer.name),
              buildSimpleText(
                  title: 'الرقم الضريبي:', value: customer.vatNumber),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  buildSimpleText(
                      title: 'رقم المبنى:', value: customer.buildingNo),
                  buildSimpleText(title: 'الحي:', value: customer.district),
                  buildSimpleText(title: 'البلد:', value: customer.country),
                  buildSimpleText(
                      title: 'الرقم الإضافي للعنوان:',
                      value: customer.additionalNo),
                ]),
                SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  buildSimpleText(
                      title: 'رقم الاتصال:', value: customer.contactNumber),
                  buildSimpleText(title: 'الشارع:', value: customer.streetName),
                  buildSimpleText(title: 'المدينة:', value: customer.city),
                  buildSimpleText(
                      title: 'الرمز البريدي:', value: customer.postalCode),
                ]),
              ]),
            ]),
          ]),
        ],
      );

  static Widget buildCustomerAddress(Invoice invoice, Customer customer) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            customer.buildingNo,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // Text('customer.address', textDirection: TextDirection.rtl),
        ],
      );

  static Widget buildInvoiceInfo(
      Invoice invoice, String title, bool isEstimate) {
    final titles = <String>[
      title == 'إشعار دائن'
          ? 'رقم الإشعار'
          : isEstimate
              ? 'رقم العرض'
              : 'رقم الفاتورة',
      'التاريخ:',
      'تاريخ التوريد:',
    ];
    final data = <String>[
      invoice.invoiceNo,
      invoice.date,
      invoice.supplyDate,
    ];

    return Column(
      children: List.generate(titles.length, (index) {
        final value = data[index];
        final title = titles[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildLogo(Setting seller) => Container(
      width: seller.logoWidth.toDouble(),
      height: seller.logoHeight.toDouble(),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: MemoryImage(base64Decode(seller.logo)))));

  static Widget buildSupplierAddress(Setting seller) => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(seller.seller,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: "الرقم الضريبي", value: seller.vatNumber),
        ],
      );

  static Widget buildTitle(Invoice invoice, String title, String subTitle) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            subTitle,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // SizedBox(height: 0.8 * PdfPageFormat.cm),
        ],
      );

  static Widget buildInvoice(Invoice invoice, List<InvoiceLines> invoiceLines) {
    final data = invoiceLines.map((item) {
      final total = item.qty * item.price;
      return [
        '${Utils.format(total)}',
        '${Utils.formatPercent(0.15 * 100)}',
        '${Utils.format(item.price / 1.15)}',
        '${item.qty}',
        item.productName,
      ];
    }).toList();

    return Container(
        child: Column(children: [
      Container(
        padding: const EdgeInsets.all(2),
        color: PdfColors.grey300,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 2.5 * PdfPageFormat.cm,
              margin: const EdgeInsets.only(right: 2.25, left: 0),
              child: Column(children: [
                Text(
                  "الإجمالي",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.black),
                ),
                Text(
                  "Total",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.black),
                ),
              ]),
            ),
            Container(
              width: 2 * PdfPageFormat.cm,
              margin: const EdgeInsets.only(right: 2.25, left: 2.25),
              child: Column(children: [
                Text(
                  "الضريبة",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.black),
                ),
                Text(
                  "VAT",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.black),
                ),
              ]),
            ),
            Container(
              width: 2 * PdfPageFormat.cm,
              margin: const EdgeInsets.only(right: 2.25, left: 2.25),
              child: Column(children: [
                Text(
                  "السعر",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.black),
                ),
                Text(
                  "Price",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.black),
                ),
              ]),
            ),
            Container(
                width: 2 * PdfPageFormat.cm,
                margin: const EdgeInsets.only(right: 2.25, left: 2.25),
                child: Column(children: [
                  Text(
                    "الكمية",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: PdfColors.black),
                  ),
                  Text(
                    "Qty",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: PdfColors.black),
                  ),
                ])),
            Container(
                width: 9.5 * PdfPageFormat.cm,
                margin: const EdgeInsets.only(right: 0, left: 2.25),
                child: Column(children: [
                  Text(
                    "البيان",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: PdfColors.black),
                  ),
                  Text(
                    "Description",
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: PdfColors.black),
                  ),
                ])),
          ],
        ),
      ),
      ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Container(
              // padding: const EdgeInsets.all(4),
              color: index % 2 == 1 ? PdfColors.grey100 : PdfColors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 2.5 * PdfPageFormat.cm,
                    margin: const EdgeInsets.only(right: 2.25, left: 2.25),
                    child: buildPriceText(currency: '', value: data[index][0]),
                  ),
                  Container(
                    width: 1.5 * PdfPageFormat.cm,
                    margin: const EdgeInsets.only(right: 2.25, left: 2.25),
                    child: Text(
                      data[index][1],
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  Container(
                    width: 2.5 * PdfPageFormat.cm,
                    margin: const EdgeInsets.only(right: 2.25, left: 2.25),
                    child: buildPriceText(currency: '', value: data[index][2]),
                  ),
                  Container(
                    width: 2 * PdfPageFormat.cm,
                    margin: const EdgeInsets.only(right: 2.25, left: 2.25),
                    child: Text(
                      data[index][3],
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                  Container(
                    width: 9.5 * PdfPageFormat.cm,
                    margin: const EdgeInsets.only(right: 0, left: 2.25),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        data[index][4],
                        textDirection: TextDirection.rtl,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      Container(height: 1.5, color: PdfColors.black),
      Container(height: 5, color: PdfColors.white),
    ]));
  }

  static Widget buildTotal(Invoice invoice, Setting seller) {
    const vatPercent = 0.15;

    final netTotal = invoice.total / 1.15;
    final vat = invoice.totalVat;
    final total = invoice.total;
    final qrString = QRBarcodeEncoder.encode(
      Seller(seller.seller),
      TaxNumber(seller.vatNumber),
      InvoiceDate(invoice.date),
      InvoiceTotalAmount(invoice.total.toStringAsFixed(2)),
      InvoiceTaxAmount(invoice.totalVat.toStringAsFixed(2)),
      // HashedXml("."),
      // KeyBuf("."),
      // SignatureBuf("."),
    ).toString();

    return Container(
      // alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildText(
                  title: 'الإجمالي الصافي بدون الضريبة',
                  value: Utils.format(netTotal),
                  unite: true,
                ),
                buildText(
                  title:
                      'ضريبة القيمة المضافة ${Utils.formatPercent(vatPercent * 100)} ',
                  value: Utils.format(vat),
                  unite: true,
                ),
                Divider(),
                buildText(
                  title: 'المبلغ المستحق',
                  titleStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                  value: Utils.format(total),
                  unite: true,
                ),
                buildText(
                  title: 'طريقة الدفع',
                  titleStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                  value: invoice.paymentMethod,
                  unite: true,
                ),
              ],
            ),
          ),
          Spacer(flex: 3),
          Container(
            height: 100,
            width: 100,
            child: BarcodeWidget(
              barcode: Barcode.qrCode(),
              data: qrString,
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          buildSimpleText(
              title: 'جميع الأسعار تشمل ضريبة القيمة المضافة',
              value: Utils.formatPercent(0.15 * 100)),
          // SizedBox(height: 1 * PdfPageFormat.mm),
          // buildSimpleText(title: 'حسب العقد', value: invoice.supplier.paymentInfo),
        ],
      );

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final styleTitle = TextStyle(fontWeight: FontWeight.bold, fontSize: 10);
    const styleValue = TextStyle(fontSize: 10);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value, textDirection: TextDirection.rtl, style: styleValue),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(title, textDirection: TextDirection.rtl, style: styleTitle),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style =
        titleStyle ?? TextStyle(fontWeight: FontWeight.bold, fontSize: 10);

    return Container(
      width: width,
      child: Row(
        children: [
          Text(value,
              textDirection: TextDirection.rtl, style: unite ? style : null),
          Expanded(
              child:
                  Text(title, textDirection: TextDirection.rtl, style: style)),
        ],
      ),
    );
  }

  static buildPriceText({
    required String value,
    required String currency,
    double width = double.infinity,
    TextStyle? titleStyle,
  }) {
    final style = titleStyle ?? const TextStyle(fontSize: 10);

    return Container(
      width: width,
      child: Row(
        children: [
          Text(currency, textDirection: TextDirection.rtl, style: style),
          Expanded(
              child:
                  Text(value, textDirection: TextDirection.rtl, style: style)),
        ],
      ),
    );
  }
}
