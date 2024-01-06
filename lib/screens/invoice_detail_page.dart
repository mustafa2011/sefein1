import 'dart:core';
import 'dart:io';

// import 'package:fatoora/apis/qr_tag/hashed_xml.dart';
// import 'package:fatoora/apis/qr_tag/key_buf.dart';
// import 'package:fatoora/apis/qr_tag/signature_buf.dart';

import '/apis/constants/utils.dart';
import '/apis/qr_tag/invoice_date.dart';
import '/apis/qr_tag/invoice_tax_amount.dart';
import '/apis/qr_tag/invoice_total_amount.dart';
import '/apis/qr_tag/qr_encoder.dart';
import '/apis/qr_tag/seller.dart';
import '/apis/qr_tag/tax_number.dart';
import '/db/fatoora_db.dart';
import '/models/customers.dart';
import '/models/invoice.dart';
import '/models/purchase.dart';
import '/models/settings.dart';
import '/screens/invoices_page.dart';
import '/widgets/app_colors.dart';
import '/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'edit_invoice_android_page.dart';
// import 'package:qr_flutter/qr_flutter.dart';

class InvoiceDetailPage extends StatefulWidget {
  final int invoiceId;
  final int noOfLines;

  const InvoiceDetailPage({
    super.key,
    required this.invoiceId,
    required this.noOfLines,
  });

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  late Invoice invoice;
  late Purchase purchase;
  int? id;
  String? invoiceNo;
  String? date;
  String? vendor;
  String? vendorInvoiceNo;
  String? vendorVatNumber;
  Setting? seller;
  Customer? payer;
  int? sellerId;
  String? vatNumber;
  num? total;
  num? totalVat;
  int? posted;
  int? payerId;
  late String qrString;
  late String qrString1;
  bool isLoading = false;
  bool isCreditNote = false;
  String pageTitle = '';

  @override
  void initState() {
    super.initState();

    refreshInvoice();
  }

  void messageBox(String? message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('رسالة'),
          content: Text(message!),
          actions: posted == 1
              ? <Widget>[
                  TextButton(
                    child: const Text("موافق"),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ]
              : <Widget>[
                  TextButton(
                    child: const Text("نعم"),
                    onPressed: () async {
                      if (widget.noOfLines != 0) {
                        // List<InvoiceLines> invoiceLines = [];
                        // invoiceLines = await FatooraDB.instance.getInvoiceLinesById(invoice.id!);
                        // var user = await FatooraDB.instance.getAllSettings();
                        // int uid = user[0].id as int;
                        // Setting seller = await FatooraDB.instance.getSellerById(uid);
                        // Customer payer = await FatooraDB.instance.getCustomerById(invoice.payerId!);
                        // await PdfInvoiceApi.generate(
                        //     invoice,
                        //     payer,
                        //     seller,
                        //     invoiceLines,
                        //     'فاتورة ملغاه',
                        //     'هذا المستند لا يعتد به');
                        //await FatooraDB.instance.deleteInvoiceLines(invoice.id!);
                        await FatooraDB.instance.deleteInvoice(invoice);
                        int? invoicesCount = await FatooraDB.instance
                            .getInvoicesCount(currentYear);
                        if (invoicesCount == 0) {
                          await FatooraDB.instance.deleteInvoiceSequence();
                          await FatooraDB.instance.deleteInvoiceLinesSequence();
                        }
                      } else {
                        await FatooraDB.instance
                            .deletePurchaseById(widget.invoiceId);
                        int? purchasesCount = await FatooraDB.instance
                            .getPurchasesCount(currentYear);
                        if (purchasesCount == 0) {
                          await FatooraDB.instance.deletePurchaseSequence();
                        }
                      }

                      Get.to(() => const InvoicesPage());
                    },
                  ),
                  TextButton(
                    child: const Text("لا"),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
        );
      },
    );
  }

  Future refreshInvoice() async {
    setState(() => isLoading = true);

    if (widget.noOfLines != 0) {
      invoice = await FatooraDB.instance.getInvoiceById(widget.invoiceId);
      id = invoice.id;
      invoiceNo = invoice.invoiceNo;
      date = invoice.date;
      sellerId = invoice.sellerId;
      seller = await FatooraDB.instance.getSellerById(sellerId!);
      total = invoice.total;
      totalVat = invoice.totalVat;
      posted = invoice.posted;
      payerId = invoice.payerId;
      payer = await FatooraDB.instance.getCustomerById(payerId!);
      isCreditNote =
          invoiceNo!.substring(invoiceNo!.length - 2, invoiceNo!.length) == 'CR'
              ? true
              : false;
      pageTitle = isCreditNote ? 'إشعار دائن' : 'فاتورة مبيعات';
    } else {
      purchase = await FatooraDB.instance.getPurchaseById(widget.invoiceId);
      id = purchase.id;
      date = purchase.date;
      vendor = purchase.vendor;
      vendorInvoiceNo = purchase.vendorInvoiceNo;
      vendorVatNumber = purchase.vendorVatNumber;
      total = purchase.total;
      totalVat = purchase.totalVat;
      pageTitle = 'فاتورة مشتريات';
    }
    qrString = QRBarcodeEncoder.encode(
      Seller(widget.noOfLines != 0 ? seller!.seller : vendor!),
      TaxNumber(widget.noOfLines != 0 ? seller!.vatNumber : vendorVatNumber!),
      InvoiceDate(date!),
      InvoiceTotalAmount(total!.toStringAsFixed(2)),
      InvoiceTaxAmount(totalVat!.toStringAsFixed(2)),
      // HashedXml("."),
      // KeyBuf("."),
      // SignatureBuf("."),
    ).toString();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          foregroundColor: AppColor.primary,
          title: Text(
            '$pageTitle رقم ${widget.noOfLines != 0 ? invoiceNo : id}',
            style: const TextStyle(
              color: AppColor.primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions:
              isCreditNote ? [Container()] : [editButton(), deleteButton()],
        ),
        body: isLoading
            ? const Loading()
            : Container(
                color: AppColor.background,
                padding: const EdgeInsets.all(12),
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Row(
                      children: [
                        const Text(
                          "التاريخ",
                          style: TextStyle(
                            color: AppColor.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            date!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                    Row(
                      children: [
                        Text(
                          widget.noOfLines != 0 ? 'البائع' : 'المورد',
                          style: const TextStyle(
                            color: AppColor.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            widget.noOfLines != 0 ? seller!.seller : vendor!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                    widget.noOfLines != 0
                        ? Container()
                        : Row(
                            children: [
                              const Text(
                                'فاتورة المورد',
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  vendorInvoiceNo!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const Divider(thickness: 2),
                    Row(
                      children: [
                        Text(
                          widget.noOfLines != 0
                              ? 'الرقم الضريبي للبائع'
                              : 'الرقم الضريبي للمورد',
                          style: const TextStyle(
                            color: AppColor.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            widget.noOfLines != 0
                                ? seller!.vatNumber
                                : vendorVatNumber!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                    Row(
                      children: [
                        Text(
                          "إجمالي ال$pageTitle",
                          style: const TextStyle(
                            color: AppColor.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          Utils.formatNoCurrency(total!),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(thickness: 2),
                    Row(
                      children: [
                        const Text(
                          "إجمالي الضريبة",
                          style: TextStyle(
                            color: AppColor.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            Utils.formatNoCurrency(totalVat!),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    widget.noOfLines != 0
                        ? Container()
                        : const Divider(thickness: 2),
                    widget.noOfLines != 0
                        ? Column(
                            children: [
                              const Divider(thickness: 2),
                              Row(
                                children: [
                                  const Text(
                                    'المشتري',
                                    style: TextStyle(
                                      color: AppColor.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      payer!.name,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(thickness: 2),
                              Row(
                                children: [
                                  const Text(
                                    "الرقم الضريبي للمشتري",
                                    style: TextStyle(
                                      color: AppColor.primary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                      payer!.vatNumber,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(thickness: 2),
                              isCreditNote
                                  ? Container()
                                  : Column(
                                      children: [
                                        Platform.isWindows || Platform.isLinux
                                            ? Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "مرحل",
                                                        style: TextStyle(
                                                          color:
                                                              AppColor.primary,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 20),
                                                      Checkbox(
                                                        value: posted == 1
                                                            ? true
                                                            : false,
                                                        onChanged: null,
                                                      ),
                                                      const SizedBox(width: 20),
                                                      posted == 1
                                                          ? isCreditNote
                                                              ? Container()
                                                              : ElevatedButton(
                                                                  onPressed: () =>
                                                                      Container(),
                                                                  child: const Text(
                                                                      'إشعار دائن'))
                                                          : Container(),
                                                    ],
                                                  ),
                                                  const Divider(thickness: 2),
                                                ],
                                              )
                                            : Container(),
                                        const SizedBox(height: 20),
                                        const Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            /*QrImage(
                                        data: qrString,
                                        size: 150.0,
                                        foregroundColor: AppColor.primary,
                                        // backgroundColor: Colors.white,
                                      ),*/
                                          ],
                                        ),
                                      ],
                                    ),
                            ],
                          )
                        : const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /*QrImage(
                          data: qrString,
                          size: 150.0,
                          foregroundColor: AppColor.primary,
                          // backgroundColor: Colors.white,
                        ),*/
                            ],
                          ),
                  ],
                ),
              ),
      );

  Widget editButton() => IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        {
          if (isLoading) return;
          if (widget.noOfLines != 0) {
            await Get.to(() => AddEditInvoiceAndroidPage(
                invoice: invoice, isCreditNote: false, isPurchases: false));
          } else {
            await Get.to(() => AddEditInvoiceAndroidPage(
                purchase: purchase, isCreditNote: false, isPurchases: true));
          }
          // refreshInvoice();
        }
      });

  Widget deleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          // await InvoicesDatabase.instance.delete(widget.invoiceId);
          if (posted == 1) {
            messageBox('الفاتورة مرحلة ولا يمكن تعديلها أو حذفها');
          } else {
            var result = messageBox(
                'سوف يتم حذف هذا الفاتورة من قواعد البيانات\n\nهل أنت متأكد من هذا الإجراء');
            return result;
          }
        },
      );
}
