import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

// import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
// import 'package:printing/printing.dart';

class PdfApi {
  static Future<File> savePreviewDocument(
      {required String name,
      required Document pdf,
      required bool isEstimate,
      required String invoiceMonth,
      required String invoiceYear}) async {
    final bytes = await pdf.save();
    File file;
    Directory? docDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    try {
      file = isEstimate
          ? file = File(
              '${docDir?.path}/Fatoora/$invoiceYear/Estimates/$invoiceMonth/$name')
          : file = File(
              '${docDir?.path}/Fatoora/$invoiceYear/Invoices/$invoiceMonth/$name');
      await file.writeAsBytes(bytes);
      /*
      await Printing.layoutPdf(
          format: PdfPageFormat.a4,
          onLayout: (PdfPageFormat format) => pdf.save());
      */
      openFile(file);
    } on Exception catch (e) {
      throw Exception(e);
    }
    return file;
  }

  static Future<File> savePreviewVoucher(
      {required String name,
      required Document pdf,
      required String voucherType,
      required String voucherMonth,
      required String voucherYear}) async {
    final bytes = await pdf.save();
    File file;
    Directory? docDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    try {
      file = File(
          '${docDir?.path}/Fatoora/$voucherYear/$voucherType/$voucherMonth/$name');
      await file.writeAsBytes(bytes);
      /*
      await Printing.layoutPdf(
          format: PdfPageFormat.a4,
          onLayout: (PdfPageFormat format) => pdf.save());
      */
      openFile(file);
    } on Exception catch (e) {
      throw Exception(e);
    }
    return file;
  }

  static Future<File> saveExcelReport(
      {required String name, required List<int> bytes}) async {
    File file;
    Directory? docDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    try {
      file = File('${docDir?.path}/Fatoora/Reports/$name');
      await file.writeAsBytes(bytes);
      await openFile(file);
    } on Exception catch (e) {
      throw Exception(e);
    }
    return file;
  }

  static Future<File> savePreviewDailyReport(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    File file;
    Directory? docDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    try {
      file = File('${docDir?.path}/Fatoora/Reports/$name');
      await file.writeAsBytes(bytes);
      /*
      await Printing.layoutPdf(
          format: PdfPageFormat.a4,
          onLayout: (PdfPageFormat format) => pdf.save());
*/
      await openFile(file);
    } on Exception catch (e) {
      throw Exception(e);
    }

    return file;
  }

  static Future<File> savePreviewVoucherReport(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    File file;
    Directory? docDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    try {
      file = File('${docDir?.path}/Fatoora/Reports/$name');
      await file.writeAsBytes(bytes);
      /*
      await Printing.layoutPdf(
          format: PdfPageFormat.a4,
          onLayout: (PdfPageFormat format) => pdf.save());
*/
      await openFile(file);
    } on Exception catch (e) {
      throw Exception(e);
    }

    return file;
  }

  static Future<File> savePreviewMonthlyReport(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    File file;
    Directory? docDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    try {
      file = File('${docDir?.path}/Fatoora/monthly/$name');
      await file.writeAsBytes(bytes);
      /*
      await Printing.layoutPdf(
          format: PdfPageFormat.a4,
          onLayout: (PdfPageFormat format) => pdf.save());
      */
      openFile(file);
    } on Exception catch (e) {
      throw Exception(e);
    }

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
