import '/apis/pdf_api.dart';
import '/models/invoice.dart';
import '/models/purchase.dart';
import 'constants/utils.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class ExcelReport {
  static Future<void> generateExcelReport(
      {required List<Invoice1> invoices,
      required String reportTitle,
      required String dateFrom,
      required String dateTo,
      required List<Purchase> purchases,
      required bool isDemo}) async {
    final Workbook workbook = Workbook();
    workbook.isRightToLeft = true;
    final Style numberStyle = workbook.styles.add('numberStyle');
    numberStyle.numberFormat = '#0.00';
    numberStyle.hAlign = HAlignType.right;
    final Style boldStyle = workbook.styles.add('boldStyle');
    boldStyle.bold = true;
    boldStyle.numberFormat = '#0.00';
    final Style bodyStyle = workbook.styles.add('bodyStyle');
    bodyStyle.hAlign = HAlignType.right;
    final Style headerStyle1 = workbook.styles.add('headerStyle1');
    // headerStyle.backColor = '#829193';
    headerStyle1.fontSize = 14;
    headerStyle1.bold = true;
    final Style topLineStyle = workbook.styles.add('topLineStyle');
    topLineStyle.borders.top.lineStyle = LineStyle.thin;
    topLineStyle.numberFormat = '#0.00';
    topLineStyle.hAlign = HAlignType.right;

    final Style totalStyle = workbook.styles.add('totalStyle');
    totalStyle.fontSize = 11;
    totalStyle.borders.top.lineStyle = LineStyle.thin;
    totalStyle.numberFormat = '#0.00';
    totalStyle.bold = true;
    final Style headerStyle2 = workbook.styles.add('headerStyle2');
    // headerStyle.backColor = '#829193'
    headerStyle2.fontSize = 11;
    headerStyle2.borders.top.lineStyle = LineStyle.thin;
    headerStyle2.borders.bottom.lineStyle = LineStyle.thin;
    headerStyle2.bold = true;
    final Worksheet sheet = workbook.worksheets[0];
    sheet.isRightToLeft = true;
    sheet.setColumnWidthInPixels(2, 100);
    sheet.setColumnWidthInPixels(3, 200);
    sheet.setColumnWidthInPixels(4, 100);

    sheet
        .getRangeByName('D1')
        .showColumns(reportTitle == 'تقرير مشتريات فترة' ? true : false);

    sheet.getRangeByName('A1').setText(reportTitle);
    sheet.getRangeByName('A1').cellStyle = headerStyle1;
    sheet.getRangeByName('B1:B4').cellStyle = bodyStyle;
    sheet.getRangeByName('A2:A3').cellStyle = boldStyle;
    sheet.getRangeByName('A5:G5').cellStyle = headerStyle2;

    sheet.getRangeByName('A2').setText(
        reportTitle == 'تقرير مبيعات اليوم' ? 'تاريخ اليوم' : 'من تاريخ');
    sheet.getRangeByName('B2').setText(dateFrom);
    sheet
        .getRangeByName('A3')
        .setText(reportTitle == 'تقرير مبيعات اليوم' ? '' : 'إلى تاريخ');
    sheet
        .getRangeByName('B3')
        .setText(reportTitle == 'تقرير مبيعات اليوم' ? '' : dateTo);
    sheet.getRangeByName('A5').setText('الفاتورة');
    sheet
        .getRangeByName('B5')
        .setText(reportTitle == 'تقرير مبيعات اليوم' ? '' : 'التاريخ');
    sheet
        .getRangeByName('C5')
        .setText(reportTitle == 'تقرير مشتريات فترة' ? 'المورد' : 'المشتري');
    sheet
        .getRangeByName('D5')
        .setText(reportTitle == 'تقرير مشتريات فترة' ? 'فاتورة المورد' : '');
    sheet.getRangeByName('E5').setText('المبلغ');
    sheet.getRangeByName('F5').setText('الضريبة');
    sheet.getRangeByName('G5').setText('الإجمالي');
    int length = reportTitle == 'تقرير مشتريات فترة'
        ? purchases.length
        : invoices.length;
    sheet.getRangeByName('A6:G${length + 10}').cellStyle = numberStyle;
    for (int i = 0; i < length; i++) {
      sheet.getRangeByName('A${i + 6}').setText(
          reportTitle == 'تقرير مشتريات فترة'
              ? purchases[i].id.toString()
              : '${invoices[i].invoiceNo} ${invoices[i].paymentMethod}');
      sheet
          .getRangeByName('B${i + 6}')
          .setText(reportTitle == 'تقرير مبيعات اليوم'
              ? ''
              : reportTitle == 'تقرير مشتريات فترة'
                  ? purchases[i].date.substring(0, 10)
                  : invoices[i].date.substring(0, 10));
      sheet.getRangeByName('C${i + 6}').setText(
          (reportTitle == 'تقرير مشتريات فترة'
              ? purchases[i].vendor
              : invoices[i].name));
      sheet.getRangeByName('D${i + 6}').setText(
          (reportTitle == 'تقرير مشتريات فترة'
              ? purchases[i].vendorInvoiceNo
              : ''));
      sheet.getRangeByName('E${i + 6}').setValue(
          (reportTitle == 'تقرير مشتريات فترة'
              ? purchases[i].total - purchases[i].totalVat
              : invoices[i].total - invoices[i].totalVat));
      sheet.getRangeByName('F${i + 6}').setValue(
          (reportTitle == 'تقرير مشتريات فترة'
              ? purchases[i].totalVat
              : invoices[i].totalVat));
      sheet.getRangeByName('G${i + 6}').setValue(
          (reportTitle == 'تقرير مشتريات فترة'
              ? purchases[i].total
              : invoices[i].total));
    }
    sheet.getRangeByName('A${length + 6}:E${length + 6}').cellStyle =
        topLineStyle;
    double total = 0;
    double totalCash = 0;
    double totalNetwork = 0;
    double totalTransfer = 0;
    double totalCredit = 0;
    double vat = 0;
    double vatCash = 0;
    double vatNetwork = 0;
    double vatTransfer = 0;
    double vatCredit = 0;
    for (int i = 0; i < length; i++) {
      total = total +
          (reportTitle == 'تقرير مشتريات فترة'
              ? purchases[i].total
              : invoices[i].total);
      if (reportTitle != 'تقرير مشتريات فترة') {
        totalCash = totalCash +
            (invoices[i].paymentMethod == 'كاش' ? invoices[i].total : 0);
        totalNetwork = totalNetwork +
            (invoices[i].paymentMethod == 'شبكة' ? invoices[i].total : 0);
        totalTransfer = totalTransfer +
            (invoices[i].paymentMethod == 'حوالة' ? invoices[i].total : 0);
        totalCredit = totalCredit +
            (invoices[i].paymentMethod == 'آجل' ? invoices[i].total : 0);
      }
      vat = vat +
          (reportTitle == 'تقرير مشتريات فترة'
              ? purchases[i].totalVat
              : invoices[i].totalVat);
      if (reportTitle != 'تقرير مشتريات فترة') {
        vatCash = vatCash +
            (invoices[i].paymentMethod == 'كاش' ? invoices[i].totalVat : 0);
        vatNetwork = vatNetwork +
            (invoices[i].paymentMethod == 'شبكة' ? invoices[i].totalVat : 0);
        vatTransfer = vatTransfer +
            (invoices[i].paymentMethod == 'حوالة' ? invoices[i].totalVat : 0);
        vatCredit = vatCredit +
            (invoices[i].paymentMethod == 'آجل' ? invoices[i].totalVat : 0);
      }
    }
    sheet.getRangeByName('A${length + 6}:G${length + 6}').cellStyle =
        totalStyle;
    sheet.getRangeByName('A${length + 6}').setText('الإجمالي الكلي');
    sheet.getRangeByName('G${length + 6}').setValue(total);
    sheet.getRangeByName('F${length + 6}').setValue(vat);
    sheet.getRangeByName('E${length + 6}').setValue(total - vat);

    sheet.getRangeByName('A${length + 7}:G${length + 7}').cellStyle =
        numberStyle;
    if (reportTitle != 'تقرير مشتريات فترة') {
      sheet
          .getRangeByName('A${length + 7}')
          .setText(reportTitle == 'تقرير مبيعات اليوم' ? '' : 'إجمالي الكاش');
      sheet
          .getRangeByName('G${length + 7}')
          .setValue(reportTitle == 'تقرير مبيعات اليوم' ? '' : totalCash);
      sheet
          .getRangeByName('F${length + 7}')
          .setValue(reportTitle == 'تقرير مبيعات اليوم' ? '' : vatCash);
      sheet.getRangeByName('E${length + 7}').setValue(
          reportTitle == 'تقرير مبيعات اليوم' ? '' : totalCash - vatCash);

      sheet.getRangeByName('A${length + 8}:E${length + 8}').cellStyle =
          numberStyle;
      sheet
          .getRangeByName('A${length + 8}')
          .setText(reportTitle == 'تقرير مبيعات اليوم' ? '' : 'إجمالي الشبكة');
      sheet
          .getRangeByName('G${length + 8}')
          .setValue(reportTitle == 'تقرير مبيعات اليوم' ? '' : totalNetwork);
      sheet
          .getRangeByName('F${length + 8}')
          .setValue(reportTitle == 'تقرير مبيعات اليوم' ? '' : vatNetwork);
      sheet.getRangeByName('E${length + 8}').setValue(
          reportTitle == 'تقرير مبيعات اليوم' ? '' : totalNetwork - vatNetwork);

      sheet.getRangeByName('A${length + 9}:E${length + 9}').cellStyle =
          numberStyle;
      sheet.getRangeByName('A${length + 9}').setText(
          reportTitle == 'تقرير مبيعات اليوم' ? '' : 'إجمالي الحوالات');
      sheet
          .getRangeByName('G${length + 9}')
          .setValue(reportTitle == 'تقرير مبيعات اليوم' ? '' : totalTransfer);
      sheet
          .getRangeByName('F${length + 9}')
          .setValue(reportTitle == 'تقرير مبيعات اليوم' ? '' : vatTransfer);
      sheet.getRangeByName('E${length + 9}').setValue(
          reportTitle == 'تقرير مبيعات اليوم'
              ? ''
              : totalTransfer - vatTransfer);

      sheet.getRangeByName('A${length + 10}:E${length + 10}').cellStyle =
          numberStyle;
      sheet
          .getRangeByName('A${length + 10}')
          .setText(reportTitle == 'تقرير مبيعات اليوم' ? '' : 'إجمالي الآجل');
      sheet
          .getRangeByName('G${length + 10}')
          .setValue(reportTitle == 'تقرير مبيعات اليوم' ? '' : totalCredit);
      sheet
          .getRangeByName('F${length + 10}')
          .setValue(reportTitle == 'تقرير مبيعات اليوم' ? '' : vatCredit);
      sheet.getRangeByName('E${length + 10}').setValue(
          reportTitle == 'تقرير مبيعات اليوم' ? '' : totalCredit - vatCredit);
    }

    final List<int> bytes = workbook.saveAsStream();

    final reportPrefix = reportTitle == 'تقرير مبيعات اليوم'
        ? 'R1'
        : reportTitle == 'تقرير مبيعات فترة'
            ? 'R2'
            : 'R3';
    await PdfApi.saveExcelReport(
        name: Utils.formatShortDate(DateTime.now()) + '[$reportPrefix].xlsx',
        bytes: bytes);
    // workbook.dispose();
  }
}
