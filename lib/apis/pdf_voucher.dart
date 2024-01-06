import 'dart:convert';
import 'dart:io';
import '/apis/pdf_api.dart';
import '/models/settings.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '/models/vouchers.dart';
import 'constants/utils.dart';

class PdfVoucher {
  static Future<File> generate(
      String voucherId, Voucher voucher, Setting setting) async {
    var myTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/fonts/Cairo-Regular.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/fonts/Cairo-Bold.ttf")),
    );
    final pdf = Document(theme: myTheme);
    pdf.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) => Column(children: [
        buildHeader(voucher, setting),
        Divider(thickness: 1),
        buildVoucher(voucherId, voucher),
      ]),
      // footer: (context) => buildFooter(voucher),
    ));

    return PdfApi.savePreviewVoucher(
        name: '${voucher.type}-$voucherId.pdf',
        pdf: pdf,
        voucherType: voucher.type,
        voucherMonth: voucher.date.substring(5, 7),
        voucherYear: voucher.date.substring(0, 4));
  }

  static Widget buildHeader(Voucher voucher, Setting seller) {
    String strAddress = '';
    strAddress += seller.buildingNo.isEmpty ? '' : '${seller.buildingNo} ';
    strAddress += seller.streetName.isEmpty ? '' : '${seller.streetName} - ';
    strAddress += seller.district.isEmpty ? '' : '${seller.district} ';
    strAddress += seller.city.isEmpty ? '' : '\n ${seller.city} - ';
    strAddress += seller.country.isEmpty ? '' : seller.country;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildLogo(seller),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          SizedBox(width: 10),
          buildTitle(seller.seller),
          // SizedBox(height: 5),
          Text(strAddress,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12)),
          // SizedBox(height: 5),
          buildSimpleText(title: 'الرقم الضريبي:', value: seller.vatNumber),
          // SizedBox(height: 10),
        ]),
      ],
    );
  }

  static Widget buildLogo(Setting seller) => Container(
      width: seller.logoWidth.toDouble(),
      height: seller.logoHeight.toDouble(),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: MemoryImage(base64Decode(seller.logo)))));

  static Widget buildVoucher(String voucherId, Voucher voucher) {
    String strAmount = Utils.formatNoCurrency(voucher.amount);
    DateTime date = DateTime.parse(voucher.date);
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        buildTitle(voucher.type == 'RECEIPT' ? 'سند قبض' : 'سند صرف'),
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        // buildSimpleText(title: 'المبلغ:', value: strAmount),
        buildSimpleText(title: 'رقم السند:', value: voucherId),
        buildSimpleText(title: 'التاريخ:', value: Utils.formatShortDate(date)),
      ]),
      buildSimpleText(
          title: voucher.type == 'RECEIPT' ? 'استلمنا من ' : 'صرفنا إلى ',
          value: voucher.voucherTo),
      buildSimpleText(title: 'مبلغاً بالأرقام ', value: strAmount),
      buildSimpleText(
          title: 'وبالحروف فقط ', value: Utils.numToWord(strAmount)),
      // Text('وبالحروف فقط ${Utils.numToWord(strAmount)}', textDirection: TextDirection.rtl,),
      buildSimpleText(title: 'وذلك مقابل ', value: voucher.desc),
      Divider(thickness: 1),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        buildSignature(signedBy: 'المدير'),
        buildSignature(signedBy: 'المحاسب'),
        buildSignature(signedBy: 'المستلم'),
      ]),
    ]);
  }

  static buildSignature({required String signedBy}) => SizedBox(
      width: 120,
      child: Column(children: [
        Text(
          signedBy,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Divider(thickness: 0.5, color: PdfColors.grey300),
      ]));

  static Widget buildTitle(String title) => Text(
        title,
        textDirection: TextDirection.rtl,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      );

  static buildSimpleText({required String title, required String value}) {
    final styleTitle = TextStyle(fontWeight: FontWeight.bold, fontSize: 12);
    const styleValue = TextStyle(fontSize: 12);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(value,
            textDirection: TextDirection.rtl, style: styleValue, maxLines: 2),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(title, textDirection: TextDirection.rtl, style: styleTitle),
      ],
    );
  }

  static buildText(
      {required String title,
      required String value,
      double width = double.infinity,
      TextStyle? titleStyle,
      FontWeight fontWeight = FontWeight.bold,
      FontWeight fontWeight1 = FontWeight.normal,
      bool unite = false}) {
    final style = titleStyle ?? TextStyle(fontWeight: fontWeight, fontSize: 12);
    final style1 =
        titleStyle ?? TextStyle(fontWeight: fontWeight1, fontSize: 12);

    return Container(
      width: width,
      child: Row(
        children: [
          Text(value,
              textDirection: TextDirection.rtl, style: unite ? style : style1),
          Expanded(
              child:
                  Text(title, textDirection: TextDirection.rtl, style: style)),
        ],
      ),
    );
  }
}
