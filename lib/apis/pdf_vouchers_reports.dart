import '/apis/pdf_api.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import '/models/vouchers.dart';
import 'constants/utils.dart';

class PdfVouchersReport {
  static Future<void> generateVouchersReport(
      {required List<Voucher> vouchers, required String voucherType}) async {
    var myTheme = ThemeData.withFont(
      base: Font.ttf(await rootBundle.load("assets/fonts/arial.ttf")),
      bold: Font.ttf(await rootBundle.load("assets/fonts/arialbd.ttf")),
    );
    var cairoBoldFont =
        Font.ttf(await rootBundle.load("assets/fonts/Cairo-Bold.ttf"));
    final pdf = Document(theme: myTheme);
    String vouType = '';
    switch (voucherType) {
      case 'RECEIPT':
        vouType = 'تقرير سندات القبض';
        break;
      case 'PAYMENT':
        vouType = 'تقرير سندات الصرف';
        break;
      case 'EXPENSE':
        vouType = 'تقرير المصروفات';
        break;
      case 'DAMAGE':
        vouType = 'تقرير التوالف';
        break;
      default:
        null;
    }
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => <Widget>[
              Column(children: [
                buildTitle(vouType, cairoBoldFont),
                Divider(),
                buildHeader(voucherType),
                Divider(),
                buildBody(vouchers, voucherType),
                buildTotal(vouchers),
              ]),
            ],
        footer: (context) {
          return Container(
              alignment: Alignment.center,
              child: Text("صفحة ${context.pagesCount}/${context.pageNumber}: ",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: PdfColors.black)));
        }));

    await PdfApi.savePreviewDailyReport(
        name: Utils.formatShortDate(DateTime.now()) + '[$voucherType].pdf',
        pdf: pdf);
  }

  static Widget buildTitle(String voucherType, Font font) => Center(
        child: Column(children: [
          Text(voucherType,
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold, font: font)),
        ]),
      );

  static Widget buildHeader(String voucherType) => Container(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            width: 65,
            child: buildNormalText(text: 'المبلغ', fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 1),
          Container(
            width: 120,
            child: buildNormalText(text: 'الشرح', fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 1),
        ]),
        Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Container(
            width: 120,
            child: buildNormalText(
                text: strName(voucherType), fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 2),
          Container(
            width: 66,
            child:
                buildNormalText(text: 'التاريخ', fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 2),
          Container(
            width: 40,
            child:
                buildNormalText(text: 'رقم السند', fontWeight: FontWeight.bold),
          ),
          Container(
            width: 40,
            child: buildNormalText(text: 'م.', fontWeight: FontWeight.bold),
          ),
        ])),
      ]));

  static Widget buildBody(List<Voucher> vouchers, String voucherType) {
    return ListView.builder(
        itemCount: vouchers.length,
        itemBuilder: (Context context, int index) {
          return Container(
              height: 40,
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 65,
                              child: buildNormalText(
                                  text: Utils.formatNoCurrency(
                                      vouchers[index].amount)),
                            ),
                            SizedBox(width: 1),
                            Container(
                              width: 140,
                              child: buildNormalText(
                                  text: vouchers[index].desc,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 1),
                          ]),
                      Container(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                            Container(
                              width: 100,
                              child: buildNormalText(
                                  text: voucherType == 'RECEIPT' ||
                                          voucherType == 'PAYMENT'
                                      ? vouchers[index].voucherTo
                                      : vouchers[index].name,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 2),
                            Container(
                              width: 66,
                              child: buildNormalText(
                                  text: vouchers[index].date.substring(0, 10)),
                            ),
                            SizedBox(width: 2),
                            Container(
                              width: 40,
                              child: buildNormalText(
                                  text: vouchers[index].id.toString()),
                              // .substring(0, 1)),
                            ),
                            Container(
                              width: 40,
                              child:
                                  buildNormalText(text: (index + 1).toString()),
                              // .substring(0, 1)),
                            ),
                          ])),
                    ]),
                (index + 1) == vouchers.length
                    ? Divider()
                    : Divider(thickness: 0.5, color: PdfColors.grey300),
              ]));
        });
  }

  static Widget buildTotal(List<Voucher> vouchers) {
    double total = 0;
    int length = vouchers.length;
    for (int i = 0; i < length; i++) {
      total = total + (vouchers[i].amount);
    }
    return Column(children: [
      Container(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            width: 65,
            child: buildNormalText(
                text: Utils.formatNoCurrency(total),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 2),
        ]),
        Container(
          width: 102,
          child: buildNormalText(text: 'الإجمالي', fontWeight: FontWeight.bold),
        ),
      ])),
    ]);
  }

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

  static buildNormalText(
      {required String text,
      TextAlign align = TextAlign.left,
      FontWeight fontWeight = FontWeight.normal}) {
    final style = TextStyle(fontWeight: fontWeight, fontSize: 10);
    return Text(text,
        textDirection: TextDirection.rtl, style: style, textAlign: align);
  }

  static String strName(String voucherType) {
    String result = '';
    switch (voucherType) {
      case 'RECEIPT':
        result = 'استلمنا من';
        break;
      case 'PAYMENT':
        result = 'صرفنا إلى';
        break;
      case 'EXPENSE':
        result = 'نوع المصروف';
        break;
      case 'DAMAGE':
        result = 'نوع التالف';
        break;
    }
    return result;
  }
}
