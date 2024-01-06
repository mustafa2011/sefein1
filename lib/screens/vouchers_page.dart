import 'dart:io';

import '/apis/excel_vouchers.dart';
import '/apis/pdf_vouchers_reports.dart';

import '../apis/constants/utils.dart';
import '../models/vouchers.dart';
import '/db/fatoora_db.dart';
import '/models/settings.dart';
import '/widgets/loading.dart';
import '/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/widgets/app_colors.dart';
import 'edit_voucher_page.dart';
import 'home_page.dart';

class VouchersPage extends StatefulWidget {
  final String? transactionType;

  const VouchersPage({super.key, this.transactionType = 'RECEIPT'});

  @override
  State<VouchersPage> createState() => _VouchersPageState();
}

class _VouchersPageState extends State<VouchersPage> {
  FatooraDB db = FatooraDB.instance;
  late int uid;
  bool isLoading = false;
  bool isLoading1 = false;
  bool isSearched = false;
  List<Voucher> tableList = [];

  late List<Setting> user;
  String? transType;
  final ScrollController _scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  final TextEditingController _dateFrom = TextEditingController();
  final TextEditingController _dateTo = TextEditingController();
  final TextEditingController _searchDateFrom = TextEditingController();
  final TextEditingController _searchDateTo = TextEditingController();
  final TextEditingController _searchName = TextEditingController();
  final TextEditingController _searchDesc = TextEditingController();
  final ScrollController _horizontal = ScrollController();
  num totalCash = 0;
  num totalNetwork = 0;
  num totalTransfer = 0;
  num totalCredit = 0;

  @override
  void initState() {
    super.initState();
    transType = widget.transactionType;
    getTransactionList();
  }

  @override
  void dispose() {
    super.dispose();
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

  void messageBoxYN(String? message, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('رسالة'),
          content: Text(message!),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text("نعم"),
              onPressed: () async {
                await FatooraDB.instance.deleteVoucher(id);
                getTransactionList();
                Get.back();
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

  void _selectDateFrom() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2055));
    if (picked != null) {
      setState(() =>
          _searchDateFrom.text = Utils.formatShortDate(picked).toString());
    }
  }

  void _selectDateTo() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2055));
    if (picked != null) {
      setState(
          () => _searchDateTo.text = Utils.formatShortDate(picked).toString());
    }
  }

  Widget hSpace(num count) => SizedBox(width: count * 5);

  Widget vSpace(num count) => SizedBox(height: count * 5);

  Widget buildDateTime() {
    return Row(
      children: [
        SizedBox(
            width: 120,
            child: TextFormField(
              controller: _searchDateFrom,
              readOnly: true,
              style: bodyStyle(),
              onTap: () => _selectDateFrom(),
              decoration: const InputDecoration(
                labelText: 'من تاريخ',
                suffixIcon: Icon(Icons.date_range),
              ),
            )),
        hSpace(2),
        SizedBox(
            width: 120,
            child: TextFormField(
              controller: _searchDateTo,
              readOnly: true,
              style: bodyStyle(),
              onTap: () => _selectDateTo(),
              decoration: const InputDecoration(
                labelText: 'إلى تاريخ',
                suffixIcon: Icon(Icons.date_range),
              ),
            )),
      ],
    );
  }

  Widget buildSearchText() => Row(
        children: [
          Expanded(
              child: TextFormField(
            controller: _searchName,
            style: bodyStyle(),
            decoration: InputDecoration(
                hintText: transType == 'RECEIPT'
                    ? 'استلمنا من'
                    : transType == 'PAYMENT'
                        ? 'صرفنا لـ'
                        : transType == 'EXPENSE'
                            ? 'نوع المصروف'
                            : transType == 'DAMAGE'
                                ? 'نوع التالف'
                                : ''),
          )),
          hSpace(2),
          Expanded(
              child: TextFormField(
            controller: _searchDesc,
            style: bodyStyle(),
            decoration: const InputDecoration(hintText: 'الشرح'),
          )),
        ],
      );

  void showSearchBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          alignment: Alignment.topCenter,
          titlePadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          title: Container(
              color: AppColor.secondary,
              height: 40,
              // padding: const EdgeInsets.all(0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(0)),
                        // backgroundColor: MaterialStateProperty.all(Colors.grey),
                        alignment: Alignment.centerRight),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.search,
                          color: AppColor.primary,
                          size: 30,
                        ),
                        Text('بحث',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColor.primary)),
                      ],
                    ),
                    onPressed: () async {
                      if (_searchDateFrom.text.isNotEmpty) {
                        filterSearchResults();
                        setState(() => isSearched = true);
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.all(0)),
                        alignment: Alignment.centerLeft),
                    child: const Icon(
                      Icons.cancel,
                      color: AppColor.primary,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              )),
          scrollable: true,
          content: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                buildDateTime(),
                buildSearchText(),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getTransactionList() async {
    try {
      setState(() {
        isLoading = true;
      });
      isSearched = false;
      _searchDateFrom.text = Utils.formatShortDate(DateTime.now());
      _searchDateTo.text = Utils.formatShortDate(DateTime.now());
      _searchName.text = '';
      _searchDesc.text = '';
      tableList.clear();
      await FatooraDB.instance.getAllVouchers(transType!).then((list) {
        tableList = list;
      });
      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      messageBox(e.toString());
    }
  }

  Future<void> filterSearchResults() async {
    List<Voucher> dummySearchList = [];
    dummySearchList.addAll(tableList);
    // if(query.isNotEmpty) {
    List<Voucher> dummyListData = [];
    for (var item in dummySearchList) {
      bool checkName = transType == 'RECEIPT' || transType == 'PAYMENT'
          ? item.voucherTo.contains(_searchName.text)
          : item.name.contains(_searchName.text);
      DateTime dt1 = DateTime.parse(_searchDateFrom.text);
      DateTime dt2 = DateTime.parse(_searchDateTo.text);
      dt2 = DateTime(dt2.year, dt2.month, dt2.day + 1);
      if (DateTime.parse(item.date).isBefore(dt2) &&
          DateTime.parse(item.date).isAfter(dt1) &&
          checkName &&
          item.desc.contains(_searchDesc.text)) {
        dummyListData.add(item);
      }
    }
    setState(() {
      tableList.clear();
      tableList.addAll(dummyListData);
    });
    return;
    // }
  }

  void generatePdf(List<Voucher> list) {
    PdfVouchersReport.generateVouchersReport(
        vouchers: list, voucherType: transType!);
  }

  void exportExcel(List<Voucher> list) {
    ExcelVoucher.generateExcelVouchers(vouchers: list, voucherType: transType!);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return isLoading
        ? const Loading()
        : Scaffold(
            body: Container(
              height: h,
              width: w,
              color: AppColor.secondary,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width * 0.70,
                        color: AppColor.primary,
                      ),
                      buildTopHeader(),
                    ],
                  ),
                  buildBody(),
                  buildButtonsActions(),
                ],
              ),
            ),
          );
  }

  Widget buildHeaderButton(String type, String label) => SizedBox(
        // height: Platform.isAndroid? 0 : 45,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(transType == type
                ? AppColor.background
                : Colors.grey), // AppColor.secondary),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColor.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          onPressed: () {
            setState(() {
              transType = type;
              getTransactionList();
            });
          },
        ),
      );

  buildTopHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 20),
      // padding: const EdgeInsets.only(right: 20),
      child: Stack(
        children: [
          const AppButtons(
              icon: Icons.task,
              iconSize: 40,
              radius: 40,
              iconColor: AppColor.primary),
          Container(
            padding: EdgeInsets.only(
                top: Platform.isAndroid ? 0 : 15,
                left: Platform.isAndroid ? 10 : 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    child: const Row(
                      children: [
                        Text('طباعة PDF',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )),
                        // hSpace(1),
                        // const Icon(Icons.picture_as_pdf, size: 30),
                      ],
                    ),
                    onPressed: () {
                      generatePdf(tableList);
                    }),
                hSpace(1),
                TextButton(
                    child: const Row(
                      children: [
                        Text('إكسيل',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )),
                        // hSpace(1),
                        // Icon(Icons.import_export, size: 30),
                      ],
                    ),
                    onPressed: () {
                      exportExcel(tableList);
                    }),
              ],
            ),
          ),
          Container(
              padding:
                  EdgeInsets.only(right: 10, top: Platform.isAndroid ? 40 : 55),
              child: Row(
                children: [
                  buildHeaderButton('RECEIPT', 'سندات القبض'),
                  const SizedBox(width: 2),
                  buildHeaderButton('PAYMENT', 'سندات الصرف'),
                  const SizedBox(width: 2),
                  buildHeaderButton('EXPENSE', 'مصروفات'),
                  const SizedBox(width: 2),
                  buildHeaderButton('DAMAGE', 'توالف'),
                ],
              )),
        ],
      ),
    );
  }

  Widget buildBody() => Positioned(
        top: 100,
        left: 10,
        right: 10,
        child: Container(
          color: AppColor.background,
          padding: const EdgeInsets.only(left: 20, right: 20),
          height: MediaQuery.of(context).size.height * 0.70,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                // color: Colors.grey,
                height: 40,
                padding: const EdgeInsets.only(right: 10),
                child: Platform.isWindows
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            SizedBox(
                                width: 80,
                                child: Text('مسلسل', style: headerStyle())),
                            SizedBox(
                                width: 100,
                                child: Row(children: [
                                  Text('التاريخ', style: headerStyle()),
                                ])),
                            SizedBox(
                                width: 120,
                                child: Text('المبلغ', style: headerStyle())),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text(
                                    transType == "RECEIPT"
                                        ? 'استلمنا من'
                                        : transType == "PAYMENT"
                                            ? 'صرفنا لـ'
                                            : transType == "EXPENSE"
                                                ? 'نوع المصروف'
                                                : transType == "DAMAGE"
                                                    ? 'نوع التالف'
                                                    : '',
                                    style: headerStyle())),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.25,
                                child: Text('الشرح', style: headerStyle())),
                          ]),
                          isSearched
                              ? TextButton(
                                  child: Row(
                                    children: [
                                      const Text('إزالة البحث',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: AppColor.primary)),
                                      hSpace(1),
                                      const Icon(
                                        Icons.filter_alt,
                                        color: AppColor.primary,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    if (isSearched) {
                                      getTransactionList();
                                      setState(() => isSearched = false);
                                    }
                                  })
                              : TextButton(
                                  child: Row(
                                    children: [
                                      const Text('بحث',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )),
                                      hSpace(1),
                                      const Icon(
                                        Icons.search,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    showSearchBox();
                                  }),
                        ],
                      )
                    : SingleChildScrollView(
                        controller: _horizontal,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              SizedBox(
                                  width: 80,
                                  child: Text('مسلسل', style: headerStyle())),
                              SizedBox(
                                  width: 100,
                                  child: Row(children: [
                                    Text('التاريخ', style: headerStyle()),
                                  ])),
                              SizedBox(
                                  width: 120,
                                  child: Text('المبلغ', style: headerStyle())),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text(
                                      transType == "RECEIPT"
                                          ? 'استلمنا من'
                                          : transType == "PAYMENT"
                                              ? 'صرفنا لـ'
                                              : transType == "EXPENSE"
                                                  ? 'نوع المصروف'
                                                  : transType == "DAMAGE"
                                                      ? 'نوع التالف'
                                                      : '',
                                      style: headerStyle())),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
                                  child: Text('الشرح', style: headerStyle())),
                            ]),
                            isSearched
                                ? TextButton(
                                    child: Row(
                                      children: [
                                        const Text('إزالة البحث',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: AppColor.primary)),
                                        hSpace(1),
                                        const Icon(
                                          Icons.filter_alt,
                                          color: AppColor.primary,
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      if (isSearched) {
                                        getTransactionList();
                                        setState(() => isSearched = false);
                                      }
                                    })
                                : TextButton(
                                    child: Row(
                                      children: [
                                        const Text('بحث',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            )),
                                        hSpace(1),
                                        const Icon(
                                          Icons.search,
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      showSearchBox();
                                    }),
                          ],
                        )),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.57,
                padding: const EdgeInsets.only(left: 5, right: 5),
                color: Colors.white,
                child: tableList.isEmpty
                    ? Center(child: Text("لا توجد حركات", style: titleStyle()))
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: tableList.length,
                        itemBuilder: (context, index) {
                          return Platform.isWindows
                              ? Container(
                                  // height: 150,
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  color: index % 2 == 1
                                      ? AppColor.background
                                      : Colors.white,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          // SizedBox(width: 30, child: Text(tableList[index].id.toString(), style: bodyStyle())),
                                          SizedBox(
                                              width: 80,
                                              child: Text(
                                                  // tableList[index].id!.toString(),
                                                  (index + 1).toString(),
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  textAlign: TextAlign.right,
                                                  style: bodyStyle())),
                                          SizedBox(
                                              width: 100,
                                              child: Text(
                                                  tableList[index]
                                                      .date
                                                      .split(' ')[0],
                                                  style: bodyStyle())),
                                          SizedBox(
                                              width: 120,
                                              child: Text(
                                                  Utils.formatNoCurrency(
                                                      tableList[index].amount),
                                                  style: bodyStyle())),
                                          transType == 'RECEIPT' ||
                                                  transType == 'PAYMENT'
                                              ? SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child:
                                                      Text(
                                                          tableList[index]
                                                              .voucherTo,
                                                          style: bodyStyle()))
                                              : SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child: Text(
                                                      tableList[index].name,
                                                      style: bodyStyle())),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.25,
                                              child: Text(tableList[index].desc,
                                                  style: bodyStyle())),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            iconSize: 20,
                                            onPressed: () async {
                                              Voucher voucher = await FatooraDB
                                                  .instance
                                                  .getVoucherById(
                                                      tableList[index].id!);
                                              Get.to(() => AddEditVoucherPage(
                                                  type: transType,
                                                  voucher: voucher));
                                            },
                                            icon:
                                                const Icon(Icons.edit_outlined),
                                          ),
                                          IconButton(
                                            iconSize: 20,
                                            onPressed: () {
                                              messageBoxYN(
                                                  'هل تريد الحذف بالفعل',
                                                  tableList[index].id!);
                                            },
                                            icon: const Icon(Icons.delete),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : SingleChildScrollView(
                                  controller: _horizontal,
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    // height: 150,
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    color: index % 2 == 1
                                        ? AppColor.background
                                        : Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            // SizedBox(width: 30, child: Text(tableList[index].id.toString(), style: bodyStyle())),
                                            SizedBox(
                                                width: 80,
                                                child: Text(
                                                    // tableList[index].id!.toString(),
                                                    (index + 1).toString(),
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    textAlign: TextAlign.right,
                                                    style: bodyStyle())),
                                            SizedBox(
                                                width: 100,
                                                child: Text(
                                                    tableList[index]
                                                        .date
                                                        .split(' ')[0],
                                                    style: bodyStyle())),
                                            SizedBox(
                                                width: 120,
                                                child: Text(
                                                    Utils.formatNoCurrency(
                                                        tableList[index]
                                                            .amount),
                                                    style: bodyStyle())),
                                            transType == 'RECEIPT' ||
                                                    transType == 'PAYMENT'
                                                ? SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                    child:
                                                        Text(
                                                            tableList[index]
                                                                .voucherTo,
                                                            style: bodyStyle()))
                                                : SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                    child: Text(
                                                        tableList[index].name,
                                                        style: bodyStyle())),
                                            SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25,
                                                child: Text(
                                                    tableList[index].desc,
                                                    style: bodyStyle())),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              iconSize: 20,
                                              onPressed: () async {
                                                Voucher voucher =
                                                    await FatooraDB.instance
                                                        .getVoucherById(
                                                            tableList[index]
                                                                .id!);
                                                Get.to(() => AddEditVoucherPage(
                                                    type: transType,
                                                    voucher: voucher));
                                              },
                                              icon: const Icon(
                                                  Icons.edit_outlined),
                                            ),
                                            IconButton(
                                              iconSize: 20,
                                              onPressed: () {
                                                messageBoxYN(
                                                    'هل تريد الحذف بالفعل',
                                                    tableList[index].id!);
                                              },
                                              icon: const Icon(Icons.delete),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ));
                        }),
              ),
              Row(
                children: [
                  Text('عدد الحركات: ${tableList.length}',
                      style: headerStyle()),
                ],
              ),
            ],
          ),
        ),
      );

  TextStyle bodyStyle() => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: "Cairo",
      );

  TextStyle headerStyle() => const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: "Cairo",
      );

  TextStyle titleStyle() => const TextStyle(
        fontSize: 20,
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontFamily: "Cairo",
      );

  TextStyle warningStyle() => const TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.bold,
        fontFamily: "Cairo",
      );

  Widget buildButtonsActions() => Positioned(
        left: 0,
        bottom: 0,
        child: Container(
          padding: const EdgeInsets.only(top: 5, left: 10, right: 10),
          width: MediaQuery.of(context).size.width,
          height: 60,
          color: AppColor.background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton(
                tooltip: 'أضف حركة',
                color: AppColor.secondary,
                padding: EdgeInsets.all(Platform.isAndroid ? 2 : 0),
                icon: AppButtons(
                  backgroundColor: AppColor.secondary,
                  iconColor: AppColor.primary,
                  icon: Icons.add,
                  iconSize: Platform.isAndroid ? 24 : 20,
                  radius: 24,
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: AppButtons(
                      icon: Icons.add,
                      textPositionDown: false,
                      text: "سند قبض",
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: AppButtons(
                      icon: Icons.add,
                      textPositionDown: false,
                      text: "سند صرف",
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: AppButtons(
                      icon: Icons.add,
                      textPositionDown: false,
                      text: "مصروف",
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: AppButtons(
                      icon: Icons.add,
                      textPositionDown: false,
                      text: "تالف",
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      Get.to(() => const AddEditVoucherPage(type: 'RECEIPT'));
                      break;
                    case 1:
                      Get.to(() => const AddEditVoucherPage(type: 'PAYMENT'));
                      break;
                    case 2:
                      Get.to(() => const AddEditVoucherPage(type: 'EXPENSE'));
                      break;
                    case 3:
                      Get.to(() => const AddEditVoucherPage(type: 'DAMAGE'));
                      break;
                    default:
                      break;
                  }
                },
              ),
              Row(
                children: [
                  AppButtons(
                    icon: Icons.home,
                    iconSize: 24,
                    radius: 24,
                    onTap: () => Get.to(() => const HomePage()),
                  ),
                  const SizedBox(width: 5),
                  AppButtons(
                    icon: Icons.refresh,
                    iconSize: 24,
                    radius: 24,
                    onTap: () => getTransactionList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildDateFrom() => InkWell(
        onTap: () => _selectDateFrom(),
        child: IgnorePointer(
          child: TextFormField(
            controller: _dateFrom,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            decoration: const InputDecoration(
              labelText: 'من تاريخ',
            ),
          ),
        ),
      );

  Widget buildDateTo() => InkWell(
        onTap: () => _selectDateTo(),
        child: IgnorePointer(
          child: TextFormField(
            controller: _dateTo,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: AppColor.primary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            decoration: const InputDecoration(
              labelText: 'إلى تاريخ',
            ),
          ),
        ),
      );

  Widget buildPostDate() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildDateFrom(),
          buildDateTo(),
        ],
      );
}
