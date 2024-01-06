import '/apis/pdf_api.dart';
import '/models/vouchers.dart';
import 'constants/utils.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelVoucher {
  static Future<void> generateExcelVouchers(
      {required List<Voucher> vouchers, required String voucherType}) async {
    final Workbook workbook = Workbook();
    workbook.isRightToLeft = true;
    final Style numberStyle = workbook.styles.add('numberStyle');
    numberStyle.numberFormat = '"#,##0.00';
    numberStyle.hAlign = HAlignType.right;
    final Style boldStyle = workbook.styles.add('boldStyle');
    boldStyle.bold = true;
    boldStyle.numberFormat = '"#,##0.00';
    final Style bodyStyle = workbook.styles.add('bodyStyle');
    bodyStyle.hAlign = HAlignType.right;
    final Style headerStyle1 = workbook.styles.add('headerStyle1');
    // headerStyle.backColor = '#829193';
    headerStyle1.fontSize = 14;
    headerStyle1.bold = true;
    final Style topLineStyle = workbook.styles.add('topLineStyle');
    topLineStyle.borders.top.lineStyle = LineStyle.thin;
    topLineStyle.numberFormat = '"#,##0.00';
    topLineStyle.hAlign = HAlignType.right;

    final Style totalStyle = workbook.styles.add('totalStyle');
    totalStyle.fontSize = 11;
    totalStyle.borders.top.lineStyle = LineStyle.thin;
    totalStyle.numberFormat = '"#,##0.00';
    totalStyle.bold = true;
    final Style headerStyle2 = workbook.styles.add('headerStyle2');
    // headerStyle.backColor = '#829193'
    headerStyle2.fontSize = 11;
    headerStyle2.borders.top.lineStyle = LineStyle.thin;
    headerStyle2.borders.bottom.lineStyle = LineStyle.thin;
    headerStyle2.bold = true;
    final Worksheet sheet = workbook.worksheets[0];
    sheet.isRightToLeft = true;
    sheet.setColumnWidthInPixels(1, 50);
    sheet.setColumnWidthInPixels(2, 50);
    sheet.setColumnWidthInPixels(3, 100);
    sheet.setColumnWidthInPixels(4, 120);
    sheet.setColumnWidthInPixels(5, 150);
    sheet.setColumnWidthInPixels(6, 70);

    sheet.getRangeByName('A1').setText(strTitle(voucherType));
    sheet.getRangeByName('A1').cellStyle = headerStyle1;
    sheet.getRangeByName('B1:B4').cellStyle = bodyStyle;
    sheet.getRangeByName('A2:A3').cellStyle = boldStyle;
    sheet.getRangeByName('A5:F5').cellStyle = headerStyle2;
    sheet.getRangeByName('A5').setText('مسلسل');
    sheet.getRangeByName('B5').setText('رقم السند');
    sheet.getRangeByName('C5').setText('التاريخ');
    sheet.getRangeByName('D5').setText(strName(voucherType));
    sheet.getRangeByName('E5').setText('الشرح');
    sheet.getRangeByName('F5').setText('المبلغ');
    int length = vouchers.length;
    sheet.getRangeByName('A6:F${length + 10}').cellStyle = numberStyle;
    for (int i = 0; i < length; i++) {
      sheet.getRangeByName('A${i + 6}').setText((i + 1).toString());
      sheet.getRangeByName('B${i + 6}').setText((vouchers[i].id.toString()));
      sheet
          .getRangeByName('C${i + 6}')
          .setText(vouchers[i].date.substring(0, 10));
      sheet.getRangeByName('D${i + 6}').setValue(
          voucherType == 'RECEIPT' || voucherType == 'PAYMENT'
              ? vouchers[i].voucherTo
              : vouchers[i].name);
      sheet.getRangeByName('E${i + 6}').setValue(vouchers[i].desc);
      sheet.getRangeByName('F${i + 6}').setValue(vouchers[i].amount);
    }
    sheet.getRangeByName('A${length + 6}:E${length + 6}').cellStyle =
        topLineStyle;
    double total = 0;
    for (int i = 0; i < length; i++) {
      total = total + vouchers[i].amount;
    }
    sheet.getRangeByName('A${length + 6}:F${length + 6}').cellStyle =
        totalStyle;
    sheet.getRangeByName('A${length + 6}').setText('الإجمالي الكلي');
    sheet.getRangeByName('F${length + 6}').setValue(total);
    final List<int> bytes = workbook.saveAsStream();

    await PdfApi.saveExcelReport(
        name: Utils.formatShortDate(DateTime.now()) + '[$voucherType].xlsx',
        bytes: bytes);
    workbook.dispose();
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

  static String strTitle(String voucherType) {
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
    return vouType;
  }
}
