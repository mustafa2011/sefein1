import 'dart:convert';
import '/apis/constants/utils.dart';
import '/apis/qr_tag/qr_encoder.dart';
import '/db/fatoora_db.dart';
import '/models/customers.dart';
import '/models/invoice.dart';
import '/models/product.dart';
import '/models/purchase.dart';
import '/models/settings.dart';
import '/screens/invoices_page.dart';
import '/widgets/app_colors.dart';
import '/widgets/buttons.dart';
import '/widgets/loading.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:developer';
import 'dart:io';
import 'package:qr_code_scanner/qr_code_scanner.dart' as sc;

import '../apis/pdf_invoice_api.dart';
import '../models/settings_ext.dart';
import 'edit_product_page.dart';

class AddEditInvoiceAndroidPage extends StatefulWidget {
  final bool? isCreditNote;
  final bool? isPurchases;
  final dynamic product;
  final Invoice? invoice;
  final Purchase? purchase;

  const AddEditInvoiceAndroidPage({
    super.key,
    this.isCreditNote = false,
    this.isPurchases,
    this.product,
    this.invoice,
    this.purchase,
  });

  @override
  State<AddEditInvoiceAndroidPage> createState() =>
      _AddEditInvoiceAndroidPageState();
}

class _AddEditInvoiceAndroidPageState extends State<AddEditInvoiceAndroidPage> {
  List<String> payMethod = ['كاش', 'شبكة', 'حوالة', 'آجل'];
  String? selectedPayMethod = Utils.defPayMethod;
  sc.Barcode? qResult;
  sc.QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool scanned = false;
  bool showDetails = false;

  TextEditingController textQRCode = TextEditingController();

  final _key1 = GlobalKey<FormState>();
  final _key2 = GlobalKey<FormState>();
  late int recId;
  late int newId; // This id for new invoice id in cloud database
  late int id; // this is existing invoice id will be retrieved from widget
  late final Customer payer;
  late final Setting seller;
  late final SettingExt sellerExt;
  late final Setting vendor;
  late final Setting vendorVatNumber;
  late final String project;
  late final String date;
  late final String supplyDate;
  late List<InvoiceLines> items = [];
  late List<InvoiceLines> lines = [];
  late List<Invoice> dailyInvoices = [];
  late List<String> customers = [];
  late String invoiceNo;
  int counter = 0;
  bool isSimplifiedTaxInvoice = true;
  bool isEstimate = Utils.isEstimate;
  bool isDemo = false;

  final TextEditingController _productName = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _priceWithoutVat = TextEditingController();
  final TextEditingController _payer = TextEditingController();
  final TextEditingController _payerVatNumber = TextEditingController();
  final TextEditingController _vendor = TextEditingController();
  final TextEditingController _vendorInvoiceNo = TextEditingController();
  final TextEditingController _vendorVatNumber = TextEditingController();
  final TextEditingController _totalPurchases = TextEditingController();
  final TextEditingController _vatPurchases = TextEditingController();
  final TextEditingController _project = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _supplyDate = TextEditingController();
  final TextEditingController _supplyTime = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  num total = 0.0;
  int cardQty = 1;

  bool noProductFount = true;
  bool isManualInvoice = Platform.isAndroid ? false : true;
  bool isLoading = false;
  List<Product> products = [];
  int workOffline = 1;
  int curPayerId = 1;
  String curProject = '';
  String curDate = Utils.formatShortDate(DateTime.now());
  String curTime = Utils.formatTime(DateTime.now());
  String curSupplyDate = Utils.formatShortDate(DateTime.now());
  String curSupplyTime = Utils.formatTime(DateTime.now());
  bool printBinded = false;
  String sellerAddress = '';
  String payerAddress = '';

  // drg.DragoBluePrinter bluetooth = drg.DragoBluePrinter.instance;

  @override
  void initState() {
    super.initState();
    getInvoice();
    focusNode.requestFocus();
    // Binding three type ot bluetooth printers
    if (Utils.isQ2) {
      // getDragonBluetooth();
    }
  }

  bool drgConnected = false;

  Future getInvoice() async {
    FatooraDB db = FatooraDB.instance;
    try {
      setState(() => isLoading = true);

      var user = await db.getAllSettings();
      // var user1 = await db.getAllSettingsExt();

      int uid = user[0].id as int;
      seller = await db.getSellerById(uid);
      sellerExt = await db.getSellerExtById(uid);

      int? purchasesCount =
          await FatooraDB.instance.getPurchasesCount(currentYear);
      int? invoicesCount =
          await FatooraDB.instance.getInvoicesCount(currentYear);
      int? countCustomers = await FatooraDB.instance.getCustomerCount();
      bool? checkFirstPayer = await FatooraDB.instance.isFirstCustomerExist();

      Customer newPayer = const Customer(
          id: 1, name: 'عميل نقدي', vatNumber: '000000000000000');

      if (!checkFirstPayer!) {
        await FatooraDB.instance.createCustomer(newPayer);
      }
      if (widget.invoice != null) {
        curPayerId = widget.invoice!.payerId!;
        if (curPayerId != 1) {
          setState(() => isSimplifiedTaxInvoice = false);
        }
        curProject = widget.invoice!.project;
        curDate = widget.invoice!.date.substring(0, 10);
        curTime = widget.invoice!.date.substring(11, 16);
        curSupplyDate = widget.invoice!.supplyDate.substring(0, 10);
        curSupplyTime = widget.invoice!.supplyDate.substring(11, 16);
        selectedPayMethod = widget.invoice!.paymentMethod;
      }

      id = widget.isPurchases == true
          ? widget.purchase == null
              ? purchasesCount == 0
                  ? 1
                  : (await db.getNewPurchaseId())! + 1
              : widget.purchase!.id!
          : widget.invoice != null
              ? widget.invoice!.id!
              : invoicesCount == 0
                  ? 1
                  : (await db.getNewInvoiceId())! + 1;
      payer = countCustomers == 0
          ? newPayer
          : await FatooraDB.instance.getCustomerById(curPayerId);
      if (widget.isPurchases == false) {
        _payer.text = '${payer.id}-${payer.name}';
        _payerVatNumber.text = payer.vatNumber;
        _project.text = curProject;
        _date.text = curDate;
        _time.text = curTime;
        _supplyDate.text = curSupplyDate;
        _supplyTime.text = curSupplyTime;
      } else {
        if (widget.purchase == null) {
          _vendor.text = '';
          _vendorInvoiceNo.text = '';
          _vendorVatNumber.text = '';
          _date.text = Utils.formatShortDate(DateTime.now());
          _time.text = Utils.formatTime(DateTime.now());
          _totalPurchases.text = '';
          _vatPurchases.text = '';
        } else {
          Purchase purchase = await FatooraDB.instance.getPurchaseById(id);
          _vendor.text = purchase.vendor;
          _vendorInvoiceNo.text = purchase.vendorInvoiceNo;
          _vendorVatNumber.text = purchase.vendorVatNumber;
          _date.text = purchase.date.substring(0, 10);
          _time.text = purchase.date.substring(11, 16);
          _totalPurchases.text = Utils.formatNoCurrency(purchase.total);
          _vatPurchases.text = Utils.formatNoCurrency(purchase.totalVat);
        }
      }

      List<Customer> list = await FatooraDB.instance.getAllCustomers();
      customers.clear();
      for (int i = 0; i < list.length; i++) {
        customers.add("${list[i].id}-${list[i].name}");
      }

      recId = id;

      /// to generate a unique invoice no declare the user who create this invoice
      invoiceNo = widget.isCreditNote! ? '$uid-$recId-CR' : '$uid-$recId';

      ///  Initialize Invoice lines
      if (widget.invoice != null) {
        items = await db.getInvoiceLinesById(recId);
        for (int i = 0; i < items.length; i++) {
          total = total + (items[i].qty * items[i].price);
        }
      }

      /// Initialize products list offLine/onLine
      if (workOffline == 1) {
        await db.getAllProducts().then((list) {
          products = list;
        });
        if (products.isEmpty) {
          noProductFount = true;
        } else {
          noProductFount = false;
        }
      }

      /// Initialize invoice form controller header
      _price.text = '0.00';
      _priceWithoutVat.text = '0.00';
      _qty.text = '1';

      sellerAddress += seller.buildingNo;
      sellerAddress += seller.buildingNo.isNotEmpty ? ' ' : '';
      sellerAddress += seller.streetName.isNotEmpty ? seller.streetName : '';
      sellerAddress += seller.district.isNotEmpty ? '-${seller.district}' : '';
      sellerAddress += seller.city.isNotEmpty ? '-${seller.city}' : '';
      sellerAddress += seller.country.isNotEmpty ? '-${seller.country}' : '';

      payerAddress += payer.buildingNo;
      payerAddress += payer.buildingNo.isNotEmpty ? ' ' : '';
      payerAddress += payer.streetName.isNotEmpty ? payer.streetName : '';
      payerAddress += payer.district.isNotEmpty ? '-${payer.district}' : '';
      payerAddress += payer.city.isNotEmpty ? '-${payer.city}' : '';
      payerAddress += payer.country.isNotEmpty ? '-${payer.country}' : '';

      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      messageBox(e.toString());
    }
  }

  void messageBox(String? message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('رسالة'),
          content: Text(message!),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("موافق"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Center(
            child: Text(
              widget.isCreditNote!
                  ? 'إشعار دائن'
                  : widget.isPurchases!
                      ? 'فاتورة مشتريات'
                      : 'فاتورة مبيعات',
              style: const TextStyle(
                  color: AppColor.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          actions: [
            PopupMenuButton(
              tooltip: 'القائمة',
              icon: const Icon(Icons.menu),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: AppButtons(
                      icon:
                          widget.isPurchases == true ? Icons.save : Icons.print,
                      textPositionDown: false,
                      text: widget.isPurchases == true ? "حفظ" : "طباعة فاتورة",
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    height: widget.isPurchases == true
                        ? 0
                        : kMinInteractiveDimension,
                    child: widget.isPurchases == true
                        ? Container()
                        : const AppButtons(
                            icon: Icons.insert_drive_file,
                            textPositionDown: false,
                            text: "عرض سعر",
                          ),
                  ),
                  PopupMenuItem<int>(
                    enabled: false,
                    height: widget.isPurchases == true ? 0 : 20,
                    child: widget.isPurchases == true
                        ? Container()
                        : const Divider(thickness: 2),
                  ),
                  PopupMenuItem<int>(
                      value: 2,
                      height: widget.isPurchases == true
                          ? 0
                          : kMinInteractiveDimension,
                      child: widget.isPurchases == true
                          ? Container()
                          : AppButtons(
                              icon: isManualInvoice
                                  ? Icons.check_box_outlined
                                  : Icons.check_box_outline_blank_sharp,
                              textPositionDown: false,
                              text: "إدخال يدوي",
                            )),
                  PopupMenuItem<int>(
                      value: 3,
                      height: widget.isPurchases == true
                          ? 0
                          : kMinInteractiveDimension,
                      child: widget.isPurchases == true
                          ? Container()
                          : const AppButtons(
                              icon: Icons.add,
                              textPositionDown: false,
                              text: "إضافة منتج",
                            )),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 0:
                    previewInvoice();
                    break;
                  case 1:
                    widget.isPurchases == true ? null : previewEstimate();
                    break;
                  case 2:
                    widget.isPurchases == true
                        ? null
                        : setState(() => isManualInvoice = !isManualInvoice);
                    break;
                  case 3:
                    // addNewProduct();
                    Get.to(() => const AddEditProductPage());
                    break;
                  default:
                    break;
                }
              },
            ),
          ],
        ),
        body: isLoading
            ? const Loading()
            : widget.isPurchases!
                ? buildPurchaseInvoiceBody() // buildPurchaseInvoiceBody()
                : buildBody(),
      );

  Widget buildBody() => Stack(
        children: [
          /// Product card list

          Positioned(
            top: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.60,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Form(
                      key: _key1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Utils.isProVersion
                                    ? Row(
                                        children: [
                                          const Text(
                                            'نوع الفاتورة',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Switch(
                                            value: isSimplifiedTaxInvoice,
                                            onChanged: (bool value) {
                                              setState(() {
                                                isSimplifiedTaxInvoice =
                                                    !isSimplifiedTaxInvoice;
                                                isSimplifiedTaxInvoice
                                                    ? changeToCashCustomer()
                                                    : Container();
                                              });
                                            },
                                          ),
                                          isSimplifiedTaxInvoice
                                              ? const Text(
                                                  'منشأة/فرد',
                                                  style:
                                                      TextStyle(fontSize: 11),
                                                )
                                              : const Text(
                                                  'منشأة/منشأة',
                                                  style:
                                                      TextStyle(fontSize: 11),
                                                ),
                                        ],
                                      )
                                    : Container(),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: () => _selectDate(),
                                        child: Text('التاريخ: ${_date.text}')),
                                    InkWell(
                                        onTap: () => _selectTime(),
                                        child: Text(' ${_time.text}')),
                                  ],
                                ),
                              ]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Utils.isProVersion && !isSimplifiedTaxInvoice
                                  ? Row(
                                      children: [
                                        const Text('العميل: '),
                                        buildPayer(),
                                      ],
                                    )
                                  : Container(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('طريقة الدفع: '),
                                  buildPaymentMethod(),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                  onTap: () => _selectSupplyDate(),
                                  child: Text('التوريد: ${_supplyDate.text}')),
                              InkWell(
                                  onTap: () => _selectSupplyTime(),
                                  child: Text(' ${_supplyTime.text}')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        right: 10, left: 10, top: 0, bottom: 10),
                    child: Column(
                      children: [
                        const Divider(thickness: 2),
                        /*Container(
                                width: MediaQuery.of(context).size.width - 100,
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.grey,
                                ),
                                child: const Text(
                                  'إدخال بيانات سطور الفاتورة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white),
                                ),
                              ),*/
                        Row(children: [
                          Expanded(child: buildProductName()),
                          const SizedBox(width: 10),
                        ]),
                        Row(
                          children: [
                            Expanded(child: buildQty()),
                            const SizedBox(width: 10),
                            Expanded(child: buildPriceWithoutVat()),
                            const SizedBox(width: 5),
                            Expanded(child: buildPrice()),
                            const SizedBox(width: 5),
                            buildInsertButton(),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ListView header
          Positioned(
            // top: showDetails
            //     ? MediaQuery.of(context).size.height * 0.4
            //     : MediaQuery.of(context).size.height - 120,
            left: 0,
            right: 0,
            bottom: showDetails
                ? (MediaQuery.of(context).size.height * 0.4) + 40
                : 0,
            child: InkWell(
              onTap: () => setState(() => showDetails = !showDetails),
              child: Container(
                height: 40,
                color: Colors.grey,
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                        showDetails
                            ? Icons.keyboard_arrow_down_sharp
                            : Icons.keyboard_arrow_up_sharp,
                        color: Colors.white),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'الإجمالي',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.isCreditNote!
                              ? "- ${total.toStringAsFixed(2)}"
                              : total.toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: widget.isCreditNote!
                                  ? Colors.red
                                  : Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// ListView body
          Positioned(
            top: showDetails
                ? (MediaQuery.of(context).size.height * 0.4) + 40
                : MediaQuery.of(context).size.height,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(right: 0, left: 0),
              color: AppColor.background,
              child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ListView.builder(
                      controller: _scrollController,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: index % 2 == 1
                              ? AppColor.background
                              : Colors.white24,
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: isManualInvoice
                                        ? InkWell(
                                            onTap: () {
                                              _productName.text =
                                                  items[index].productName;
                                              _qty.text =
                                                  items[index].qty.toString();
                                              _price.text = items[index]
                                                  .price
                                                  .toStringAsFixed(2);
                                              setState(() {
                                                num lineTotal =
                                                    items[index].qty *
                                                        items[index].price;
                                                total = total - lineTotal;
                                                items.removeAt(index);
                                              });
                                            },
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  items[index].productName,
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                )))
                                        : Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              items[index].productName,
                                              textDirection: TextDirection.rtl,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            )),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            AppButtons(
                                              backgroundColor: Colors.grey,
                                              icon: Icons.add,
                                              padding: 2,
                                              onTap: () => _addQuantity(index),
                                            ),
                                            SizedBox(
                                                width: 30,
                                                child: Text(
                                                  "${items[index].qty}",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      // fontWeight: FontWeight.w900,
                                                      color: Colors.black),
                                                )),
                                            AppButtons(
                                              backgroundColor: Colors.grey,
                                              icon: Icons.remove,
                                              padding: 2,
                                              onTap: () =>
                                                  _removeQuantity(index),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                            child: Text(
                                          items[index].price.toStringAsFixed(2),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: widget.isCreditNote!
                                                  ? Colors.red
                                                  : Colors.black),
                                        )),
                                        const SizedBox(width: 5),
                                        Expanded(
                                            child: Text(
                                          (items[index].qty *
                                                  (items[index].price))
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: widget.isCreditNote!
                                                  ? Colors.red
                                                  : Colors.black),
                                        )),
                                      ],
                                    ),
                                  ),

                                  ///Remove item from list
                                  AppButtons(
                                    backgroundColor: Colors.grey,
                                    padding: 2,
                                    icon: Icons.clear,
                                    onTap: () async {
                                      setState(() {
                                        num lineTotal = items[index].qty *
                                            items[index].price;
                                        total = total - lineTotal;
                                        items.removeAt(index);
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 5),
                                ],
                              ),
                              const SizedBox(height: 5),
                              const Divider(
                                thickness: 1,
                                height: 0,
                              ),
                            ],
                          ),
                        );
                      })),
            ),
          ),

          /// ListView footer
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(right: 5, left: 5),
              color: AppColor.background,
              // height: 40,
              child: showDetails
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButtons(
                          icon: widget.isPurchases == true
                              ? Icons.save
                              : Icons.print,
                          textPositionDown: false,
                          text: widget.isPurchases == true
                              ? "حفظ"
                              : "طباعة فاتورة",
                          onTap: () => previewInvoice(),
                        ),
                        hSpace(3),
                        widget.isPurchases == true
                            ? Container()
                            : AppButtons(
                                icon: Icons.insert_drive_file,
                                textPositionDown: false,
                                text: "عرض سعر",
                                onTap: () => widget.isPurchases == true
                                    ? null
                                    : previewEstimate(),
                              ),
                      ],
                    )
                  : Container(),
            ),
          ),
        ],
      );

  Widget hSpace(num count) => SizedBox(width: count * 5);

  Widget vSpace(num count) => SizedBox(height: count * 5);

  Widget buildButtonPost() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor:
              isManualInvoice ? AppColor.primary : AppColor.background,
          backgroundColor:
              isManualInvoice ? AppColor.background : AppColor.primary,
        ),
        onPressed: () async {
          String message =
              'لن يمكنك تعديل/حذف هذه الفاتورة بعد عملية الترحيل\nهل أنت متأكد من هذا الإجراء';
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('رسالة'),
                content: Text(message),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  TextButton(
                    child: const Text("نعم"),
                    onPressed: () async {
                      if (widget.invoice != null) {
                        Invoice invoice = Invoice(
                          id: id,
                          invoiceNo: invoiceNo,
                          date: Utils.formatDate(DateTime.now()),
                          sellerId: seller.id,
                          total: total,
                          totalVat: total - (total / 1.15),
                          posted: 1,
                          payerId: payer.id,
                          noOfLines: items.length,
                        );
                        await FatooraDB.instance.updateInvoice(invoice);
                        await FatooraDB.instance.deleteInvoiceLines(id);
                        for (int i = 0; i < items.length; i++) {
                          await FatooraDB.instance
                              .createInvoiceLines(items[i], items[i].recId);
                        }

                        Get.to(() => const InvoicesPage());
                      } else {
                        messageBox('يجب حفظ الفاتورة قبل الترحيل');
                      }
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
        },
        child: const Text('ترحيل'),
      ),
    );
  }

  Widget buildProductName() => TextFormField(
        minLines: 1,
        maxLines: 3,
        controller: _productName,
        focusNode: focusNode,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        decoration: const InputDecoration(
          labelText: 'اسم المنتج/الخدمة',
        ),
        validator: (invoiceName) => invoiceName != null && invoiceName.isEmpty
            ? 'يجب إدخال اسم المنتج/الخدمة'
            : null,
        // onChanged: (value) => productName,
      );

  Widget buildQty() => TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: _qty,
        autofocus: true,
        onTap: () {
          var textValue = _qty.text;
          _qty.selection = TextSelection(
            baseOffset: 0,
            extentOffset: textValue.length,
          );
        },
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        decoration: const InputDecoration(
          labelText: 'الكمية',
        ),
        validator: (qty) =>
            qty == null || qty == '' ? 'يجب إدخال الكمية' : null,
        // onChanged: (value) => qty,
      );

  Widget buildPrice() => TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: _price,
        autofocus: true,
        onTap: () {
          var textValue = _price.text;
          _price.selection = TextSelection(
            baseOffset: 0,
            extentOffset: textValue.length,
          );
        },
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        decoration: const InputDecoration(
          labelText: 'السعر مع الضريبة',
        ),
        validator: (price) =>
            price == null || price == '' ? 'يجب إدخال سعر المنتج' : null,
        onChanged: (value) => _priceWithoutVat.text =
            "${Utils.formatNoCurrency(num.parse(value) / 1.15)}",
      );

  Widget buildPriceWithoutVat() => TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: _priceWithoutVat,
        autofocus: true,
        onTap: () {
          var textValue = _priceWithoutVat.text;
          _priceWithoutVat.selection = TextSelection(
            baseOffset: 0,
            extentOffset: textValue.length,
          );
        },
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        decoration: const InputDecoration(
          labelText: 'السعر بدون ضريبة',
        ),
        validator: (price) =>
            price == null || price == '' ? 'يجب إدخال سعر المنتج' : null,
        onChanged: (value) =>
            _price.text = "${Utils.formatNoCurrency(num.parse(value) * 1.15)}",
      );

  Widget buildInsertButton() => IconButton(
        onPressed: () {
          String price = _price.text.replaceAll(',', '');
          if (_productName.text != '' &&
              int.parse(_qty.text) > 0 &&
              num.parse(price) >= 0) {
            setState(() {
              items.add(InvoiceLines(
                productName: num.parse(price) == 0
                    ? '${_productName.text}- مجاناً'
                    : _productName.text,
                qty: int.parse(_qty.text.toString()),
                price: num.parse(price),
                recId: recId,
              ));
              num lineTotal = int.parse(_qty.text) * num.parse(price);
              total = total + lineTotal;
              _productName.clear();
              _qty.text = '1';
              _price.text = '0.00';
              _priceWithoutVat.text = '0.00';
              focusNode.requestFocus();
            });
          }
        },
        icon: const Icon(
          Icons.add_shopping_cart_sharp,
          size: 40,
          color: AppColor.primary,
        ),
      );

  Widget buildPurchaseInvoiceBody() => Container(
        height: MediaQuery.of(context).size.height * 0.90,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _key2,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: buildVendor()),
                  const SizedBox(width: 20),
                  Expanded(child: buildVendorInvoiceNo()),
                ],
              ),
              buildVendorVatNumber(),
              Row(
                children: [
                  Expanded(child: buildDate()),
                  const SizedBox(width: 20),
                  Expanded(child: buildTime()),
                ],
              ),
              Row(
                children: [
                  Expanded(child: buildTotalPurchases()),
                  const SizedBox(width: 20),
                  Expanded(child: buildVatPurchases()),
                ],
              ),
              Center(
                child: Utils.isHandScanner
                    ? Container()
                    : Platform.isWindows
                        ? Container()
                        : ElevatedButton(
                            onPressed: () {
                              controller!.resumeCamera();
                            },
                            child: const Text('اعادة تشغيل القارئ'),
                          ),
              ),
              Expanded(
                  child: Utils.isHandScanner
                      ? _buildQRText()
                      : _buildQrView(context)),
            ],
          ),
        ),
      );

  Widget _buildQRText() => TextField(
        controller: textQRCode,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
        // readOnly: true,
        decoration: const InputDecoration(
          labelText: 'كود الكيو آر',
        ),
        onChanged:
            textQRCode.text.isNotEmpty ? _getQRData(textQRCode.text) : null,
      );

  _getQRData(String qrStr) {
    final qrString = QRBarcodeEncoder.toBase64Decode(qrStr);
    // String tagString = qrString.substring(0,2).toString();
    List<int> bytes = utf8.encode(qrString);
    int sellerLength = bytes[1].toInt();
    // print(sellerLength);
    int taxNumberLength = bytes[sellerLength + 3].toInt();
    int dateLength = bytes[sellerLength + taxNumberLength + 5].toInt();
    // print(dateLength);
    int totalLength =
        bytes[sellerLength + taxNumberLength + dateLength + 7].toInt();
    int vatLength =
        bytes[sellerLength + taxNumberLength + dateLength + totalLength + 9]
            .toInt();
    List<int> sellerBytes = [];
    List<int> taxNumberBytes = [];
    List<int> dateBytes = [];
    List<int> totalBytes = [];
    List<int> vatBytes = [];
    for (int i = 0; i < sellerLength; i++) {
      sellerBytes.add(bytes[i + 2]);
    }
    int j = sellerLength + 2;
    for (int i = j; i < j + taxNumberLength; i++) {
      taxNumberBytes.add(bytes[i + 2]);
    }
    int k = j + taxNumberLength + 2;
    for (int i = k; i < k + dateLength; i++) {
      dateBytes.add(bytes[i + 2]);
    }
    int l = k + dateLength + 2;
    for (int i = l; i < l + totalLength; i++) {
      totalBytes.add(bytes[i + 2]);
    }
    int m = l + totalLength + 2;
    for (int i = m; i < m + vatLength; i++) {
      vatBytes.add(bytes[i + 2]);
    }

    _vendor.text = (utf8.decode(sellerBytes));
    _vendorVatNumber.text = (utf8.decode(taxNumberBytes));
    _date.text = (utf8.decode(dateBytes)).substring(0, 10);
    _time.text = (utf8.decode(dateBytes)).substring(11, 16);
    _totalPurchases.text = (utf8.decode(totalBytes));
    _vatPurchases.text = (utf8.decode(vatBytes));

    textQRCode.text = "";
    focusNode.requestFocus();
  }

  Widget buildVendor() => TextFormField(
        controller: _vendor,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        decoration: const InputDecoration(
          labelText: 'اسم المورد',
        ),
        validator: (value) =>
            value != null && value.isEmpty ? 'يجب إدخال اسم المورد' : null,
      );

  Widget buildVendorInvoiceNo() => TextFormField(
        controller: _vendorInvoiceNo,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        decoration: const InputDecoration(
          labelText: 'فاتورة المورد',
        ),
      );

  Widget buildVendorVatNumber() => TextFormField(
        controller: _vendorVatNumber,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        decoration: const InputDecoration(
          labelText: 'الرقم الضريبي للمورد',
        ),
        validator: (value) => value != null && value.length != 15
            ? 'يجب إدخال الرقم الضريبي للمورد 15 رقم'
            : null,
      );

  Widget buildTotalPurchases() => TextFormField(
        controller: _totalPurchases,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        decoration: const InputDecoration(
          labelText: 'إجمالي الفاتورة',
        ),
        validator: (value) =>
            value!.isEmpty ? 'يجب إدخال إجمالي الفاتورة' : null,
        onChanged: (value) => _vatPurchases.text =
            "${Utils.formatNoCurrency(num.parse(_totalPurchases.text) - (num.parse(_totalPurchases.text) / 1.15))}",
      );

  Widget buildVatPurchases() => TextFormField(
        controller: _vatPurchases,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        decoration: const InputDecoration(
          labelText: 'ضريبة القيمة المضافة',
        ),
        readOnly: true,
      );

  Widget buildPayer() => DropdownButton<String>(
        value: _payer.text,
        // icon: const Visibility(visible: true, child: Icon(Icons.arrow_downward)),
        underline: Container(
          height: 2,
          // color: AppColor.secondary,
        ),
        onChanged: (String? newValue) async {
          int id = int.parse(newValue!.split("-")[0]);
          Customer changedPayer = await FatooraDB.instance.getCustomerById(id);
          setState(() {
            _payer.text = newValue;
            _payerVatNumber.text = changedPayer.vatNumber;
          });
        },
        items: customers.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'Cairo',
              ),
            ),
          );
        }).toList(),
      );

  Widget buildPaymentMethod() => DropdownButton<String>(
        value: selectedPayMethod,
        items: payMethod
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: AppColor.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ))
            .toList(),
        onChanged: (item) => setState(() {
          selectedPayMethod = item;
        }),
      );

  Widget buildPayerVatNumber() => Text(
        _payerVatNumber.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );

  Widget buildProject() => TextFormField(
        controller: _project,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        decoration: const InputDecoration(
          labelText: 'اسم المشروع',
        ),
        // onChanged: onChangedPayer,
      );

  _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2055));
    if (picked != null) {
      setState(() => _date.text = Utils.formatShortDate(picked).toString());
    }
  }

  _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _time.text = picked.toString().substring(10, 15));
    }
  }

  _selectSupplyDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2055));

    if (picked != null) {
      setState(() => _supplyDate.text = Utils.formatShortDate(picked));
    }
  }

  _selectSupplyTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _supplyTime.text = picked.toString().substring(10, 15));
    }
  }

  Widget buildDate() => InkWell(
        onTap: () => _selectDate(),
        child: IgnorePointer(
          child: TextFormField(
            controller: _date,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            decoration: const InputDecoration(
              labelText: 'تاريخ الفاتورة',
            ),
            // onChanged: onChangedPayer,
          ),
        ),
      );

  Widget buildTime() => InkWell(
        onTap: () => _selectTime(),
        child: IgnorePointer(
          child: TextFormField(
            controller: _time,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            decoration: const InputDecoration(
              labelText: 'وقت الفاتورة',
            ),
            // onChanged: onChangedPayer,
          ),
        ),
      );

  Widget buildSupplyDate() => InkWell(
        onTap: () => _selectSupplyDate(),
        child: IgnorePointer(
          child: TextFormField(
            controller: _supplyDate,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            decoration: const InputDecoration(
              labelText: 'تاريخ التوريد',
            ),
            // onChanged: onChangedPayer,
          ),
        ),
      );

  void previewInvoice() {
    setState(() {
      isEstimate = false;
    });
    addOrUpdateInvoice();
  }

  void previewEstimate() {
    setState(() {
      isEstimate = true;
    });
    addOrUpdateInvoice();
  }

  /// To add/update invoice to database
  void addOrUpdateInvoice() async {
    if (widget.isPurchases == false) {
      final isValid = Platform.isAndroid
          ? true
          : isManualInvoice
              ? _key1.currentState!.validate()
              : true;
      final hasLines = items.isNotEmpty ? true : false;

      if (!hasLines) {
        messageBox('يجب إدخال سطور للفاتورة');
      }

      if (isValid && hasLines) {
        final isUpdating = widget.invoice != null;
        setState(() {
          isLoading = true;
        });

        if (isUpdating) {
          await updateInvoice();
        } else {
          await addInvoice();
        }
        // if (!isPreview) {
        //   printTicket();
        // }
        setState(() {
          isLoading = false;
        });

        Get.to(() => const InvoicesPage());
      }
    } else {
      final isValid = _key2.currentState!.validate();
      if (isValid) {
        final isUpdating = widget.purchase != null;

        setState(() {
          isLoading = true;
        });
        if (isUpdating) {
          await updateInvoice();
        } else {
          await addInvoice();
        }

        setState(() {
          isLoading = false;
        });

        Get.to(() => const InvoicesPage());
      }
    }
  }

  Future updateInvoice() async {
    if (widget.isPurchases == false) {
      int payerId = int.parse(_payer.text.split("-")[0]);
      Customer currentPayer = await FatooraDB.instance.getCustomerById(payerId);
      Invoice invoice = Invoice(
        id: id,
        invoiceNo: invoiceNo,
        date: '${_date.text} ${_time.text}',
        supplyDate: '${_supplyDate.text} ${_supplyTime.text}',
        sellerId: seller.id,
        project: _project.text,
        total: total,
        totalVat: total - (total / 1.15),
        posted: 0,
        payerId: payerId,
        noOfLines: items.length,
        paymentMethod: selectedPayMethod!,
      );

      await FatooraDB.instance.updateInvoice(invoice);
      await FatooraDB.instance.deleteInvoiceLines(id);

      for (int i = 0; i < items.length; i++) {
        await FatooraDB.instance.createInvoiceLines(items[i], items[i].recId);
      }
      // if (isSimplifiedTaxInvoice) {
      await PdfInvoiceApi.generate(
          invoice,
          currentPayer,
          seller,
          sellerExt,
          items,
          isEstimate ? 'عرض أسعار' : 'فاتورة مبيعات ضريبية',
          invoice.project,
          isEstimate,
          isDemo);
      // }
    } else {
      String newTtl = _totalPurchases.text.replaceAll(',', '');
      num ttl = num.parse(newTtl);
      Purchase purchase = Purchase(
        id: id,
        date: '${_date.text} ${_time.text}',
        vendor: _vendor.text,
        vendorInvoiceNo: _vendorInvoiceNo.text,
        vendorVatNumber: _vendorVatNumber.text,
        total: ttl,
        totalVat: ttl - (ttl / 1.15),
      );
      await FatooraDB.instance.updatePurchase(purchase);
    }
  }

  Future addInvoice() async {
    if (widget.isPurchases == false) {
      int payerId = int.parse(_payer.text.split("-")[0]);
      Customer currentPayer = await FatooraDB.instance.getCustomerById(payerId);
      Invoice invoice = Invoice(
        invoiceNo: invoiceNo,
        date: '${_date.text} ${_time.text}',
        supplyDate: '${_supplyDate.text} ${_supplyTime.text}',
        sellerId: seller.id,
        project: _project.text,
        total: total,
        totalVat: total - (total / 1.15),
        posted: 0,
        payerId: payerId,
        noOfLines: items.length,
        paymentMethod: selectedPayMethod!,
      );
      await FatooraDB.instance.createInvoice(invoice);

      for (int i = 0; i < items.length; i++) {
        await FatooraDB.instance.createInvoiceLines(items[i], items[i].recId);
      }
      // if (isSimplifiedTaxInvoice) {
      await PdfInvoiceApi.generate(
          invoice,
          currentPayer,
          seller,
          sellerExt,
          items,
          isEstimate ? 'عرض أسعار' : 'فاتورة مبيعات ضريبية',
          invoice.project,
          isEstimate,
          isDemo);
      // }
    } else {
      num ttl = num.parse(_totalPurchases.text);
      Purchase purchase = Purchase(
        date: '${_date.text} ${_time.text}',
        vendor: _vendor.text,
        vendorInvoiceNo: _vendorInvoiceNo.text,
        vendorVatNumber: _vendorVatNumber.text,
        total: ttl,
        totalVat: ttl - (ttl / 1.15),
      );
      await FatooraDB.instance.createPurchase(purchase);
    }
  }

  _addQuantity(int index) {
    setState(() {
      {
        int newQty = items[index].qty;
        String productName = items[index].productName;
        num price = items[index].price;
        items.insert(
            index,
            InvoiceLines(
              // id: index,
              productName: productName,
              qty: newQty + 1,
              price: price,
              recId: recId,
            ));
        items.removeAt(index + 1);
      }
      total = 0;
      for (int i = 0; i < items.length; i++) {
        total = total + ((items[i].qty) * items[i].price);
      }
    });
  }

  _removeQuantity(int index) {
    setState(() {
      {
        int newQty = items[index].qty;
        String productName = items[index].productName;
        num price = items[index].price;
        if (newQty > 1) {
          items.insert(
              index,
              InvoiceLines(
                // id: index,
                productName: productName,
                qty: newQty - 1,
                price: price,
                recId: recId,
              ));
          items.removeAt(index + 1);
        }
      }
      total = 0;
      for (int i = 0; i < items.length; i++) {
        total = total + ((items[i].qty) * items[i].price);
      }
    });
  }

  /// Start and build QR code scanner
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid && widget.isPurchases == true) {
      if (!Utils.isHandScanner) {
        controller!.pauseCamera();
        controller!.resumeCamera();
      }
    }
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Platform.isAndroid
        ? sc.QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: sc.QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          )
        : Container();
  }

  void _onQRViewCreated(sc.QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    try {
      controller.scannedDataStream.listen((scanData) {
        qResult = scanData;
        final qrString = QRBarcodeEncoder.toBase64Decode(qResult!.code!);

        List<int> bytes = utf8.encode(qrString);
        int sellerLength = bytes[1].toInt();
        int taxNumberLength = bytes[sellerLength + 3].toInt();
        int dateLength = bytes[sellerLength + taxNumberLength + 5].toInt();
        int totalLength =
            bytes[sellerLength + taxNumberLength + dateLength + 7].toInt();
        int vatLength =
            bytes[sellerLength + taxNumberLength + dateLength + totalLength + 9]
                .toInt();
        List<int> sellerBytes = [];
        List<int> taxNumberBytes = [];
        List<int> dateBytes = [];
        List<int> totalBytes = [];
        List<int> vatBytes = [];
        for (int i = 0; i < sellerLength; i++) {
          sellerBytes.add(bytes[i + 2]);
        }
        int j = sellerLength + 2;
        for (int i = j; i < j + taxNumberLength; i++) {
          taxNumberBytes.add(bytes[i + 2]);
        }
        int k = j + taxNumberLength + 2;
        for (int i = k; i < k + dateLength; i++) {
          dateBytes.add(bytes[i + 2]);
        }
        int l = k + dateLength + 2;
        for (int i = l; i < l + totalLength; i++) {
          totalBytes.add(bytes[i + 2]);
        }
        int m = l + totalLength + 2;
        for (int i = m; i < m + vatLength; i++) {
          vatBytes.add(bytes[i + 2]);
        }

        _vendor.text = (utf8.decode(sellerBytes));
        _vendorVatNumber.text = (utf8.decode(taxNumberBytes));
        _date.text = (utf8.decode(dateBytes)).substring(1, 10);
        _time.text = (utf8.decode(dateBytes)).substring(11, 16);
        _totalPurchases.text = (utf8.decode(totalBytes));
        _vatPurchases.text = (utf8.decode(vatBytes));
        controller.stopCamera();
      });
    } catch (e) {
      controller.stopCamera();
      throw Exception(e);
    }
  }

  /*String timezone = (utf8.decode(dateBytes)).substring(11, 12);
  if (timezone == "T") {
  _time.text = (utf8.decode(dateBytes)).substring(12, 17);
  } else {
  _time.text = (utf8.decode(dateBytes)).substring(11, 16);
  }*/
  void _onPermissionSet(
      BuildContext context, sc.QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  changeToCashCustomer() {
    setState(() {
      _payer.text = "1-عميل نقدي";
    });
  }

  /// End of QR code scanner
}
