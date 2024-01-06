import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:number_to_word_arabic/number_to_word_arabic.dart';

const C = 'ريال';

class Utils {
  static formatPrice(num price) => price.toStringAsFixed(2);

  static formatPercent(double percent) => '%${percent.toStringAsFixed(0)}';

  static formatDate(DateTime date) =>
      DateFormat('yyyy-MM-dd HH:mm').format(date);

  static formatTime(DateTime date) => DateFormat('HH:mm').format(date);

  static formatShortDate(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  static format(num price) => NumberFormat("#,##0.00 $C").format(price);

  static formatNoCurrency(num price) => NumberFormat("#,##0.00").format(price);

  static formatNoCurrencyNoComma(num price) =>
      NumberFormat("#0.00").format(price);

  static formatTwoDigits(num price) => NumberFormat("00").format(price);

  static Image imageFromBase64String(String base64String) =>
      Image.memory(base64Decode(base64String), fit: BoxFit.fill);

  static bool isProVersion =
      true; // true: for pro version and false: for standard version
  static bool isHandScanner =
      false; // true: for devices connected to usb hand scanner
  static bool isSunmiV2 =
      false; // true: for sunmi printer false for other printer
  static bool isQ2 = false; // true: for IposPrinter printer
  static bool isGoojPtr = false; // true: for GOOJPTR printer
  static bool isPdf = true; // true to print Invoice as PDF file.
  static bool isEstimate =
      false; // true to print Estimate, false to print Invoice.
  static bool isStoreControl =
      false; // true to support store/warehouse control.

  /// Default settings
  static String defUserName = '';
  static String defUserPassword = '';
  static String defSellerName = '';
  static String defEmail = '';
  static String defCellphone = '';
  static String defBuildingNo = '';
  static String defStreetName = '';
  static String defDistrict = '';
  static String defCity = '';
  static String defCountry = '';
  static String defPostcode = '';
  static String defAdditionalNo = '';
  static String defVatNumber = '';
  static String defTerms = '';
  static String defSheetId = '1uA1Yib05DypFgGnv6r77KoqRwgbP3r9Oz1uXy_NpQG4';
  static String defSupportNumber = '0502300618';
  static String defPayMethod = 'شبكة';
  static String defLanguage = 'Arabic'; // 'Arabic' to use arabic user interface
  static String defFullSupportNumber = '966${defSupportNumber.substring(1)}';

  /*
  /// Default settings
  static String defUserName = 'مستخدم عام';
  static String defUserPassword = '123';
  static String defSellerName = 'الواضح تقنية معلومات';
  static String defEmail = 'mustafa2011@gmail.com';
  static String defCellphone = '0502300618';
  static String defBuildingNo = '46';
  static String defStreetName = 'شارع 13';
  static String defDistrict = 'حي الإسكان';
  static String defCity = 'الرياض';
  static String defCountry = 'السعودية';
  static String defPostcode = '1111';
  static String defAdditionalNo = '1234';
  static String defVatNumber = '300005555500003';
  static String defTerms = 'الأسعار بالريال وتشمل الضريبة';
  static String defSheetId = '1uA1Yib05DypFgGnv6r77KoqRwgbP3r9Oz1uXy_NpQG4';
  static String defSupportNumber ='0502300618';
  static String defFullSupportNumber ='966502300618';
  */

  static Uri whatsAppUri =
      Uri(scheme: 'https', host: 'wa.me', path: Utils.defFullSupportNumber);

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  static String numToWord(String number) {
    String newNumber = number; // formatNoCurrency(num.parse(number));
    String numInWord = '';
    num numberBeforeDot =
        num.parse(newNumber.split('.')[0].replaceAll(",", ""));
    num numberAfterDot = num.parse(newNumber.split('.')[1].replaceAll(",", ""));
    numInWord = Tafqeet.convert(numberBeforeDot.toString());
    numInWord += ' ريال';
    numInWord += numberAfterDot > 0 ? ' و' : '';
    numInWord +=
        numberAfterDot > 0 ? Tafqeet.convert(numberAfterDot.toString()) : '';
    numInWord += numberAfterDot > 0 ? ' هللة' : '';

    return numInWord;
  }
}
