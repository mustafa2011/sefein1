import '/apis/excel_reports.dart';

import '../apis/constants/utils.dart';
import '../apis/pdf_reports.dart';
import '/db/fatoora_db.dart';

import '/widgets/loading.dart';
import '/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/widgets/app_colors.dart';
import 'home_page.dart';

class ReportsPage extends StatefulWidget {
  const ReportsPage({super.key});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  FatooraDB db = FatooraDB.instance;
  bool isLoading = false;
  final TextEditingController _dateFrom = TextEditingController();
  final TextEditingController _dateTo = TextEditingController();
  final TextEditingController _dateFrom1 = TextEditingController();
  final TextEditingController _dateTo1 = TextEditingController();
  bool isDemo = false;

  @override
  void initState() {
    super.initState();
    getStart();
  }

  getStart() async {
    setState(() {
      _dateFrom.text = Utils.formatShortDate(DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));
      _dateTo.text = Utils.formatShortDate(DateTime.now());
      _dateFrom1.text = Utils.formatShortDate(DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 1));
      _dateTo1.text = Utils.formatShortDate(DateTime.now());
    });
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
                        width: MediaQuery.of(context).size.width * 0.50,
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

  buildTopHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.only(right: 20),
      child: const Stack(
        children: [
          AppButtons(
            icon: Icons.find_in_page_rounded,
            iconSize: 40,
            radius: 40,
            iconColor: AppColor.secondary,
          ),
          Text(
            'التقارير',
            style: TextStyle(
              fontSize: 25,
              color: AppColor.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
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
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height * 0.72,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildCard(
                    'تقرير مبيعات اليوم',
                    Utils.formatShortDate(DateTime.now()),
                    Utils.formatShortDate(DateTime.now())),
                buildCard('تقرير مبيعات فترة', _dateFrom.text, _dateTo.text),
                buildCard('تقرير مشتريات فترة', _dateFrom1.text, _dateTo1.text),
              ],
            ),
          ),
        ),
      );

  Widget buildButtonsActions() => Positioned(
        left: 0,
        bottom: 0,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.10,
          width: MediaQuery.of(context).size.width,
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            color: AppColor.background,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                      onTap: () => getStart(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget buildCard(String reportTitle, String dateFrom, String dateTo) => Card(
        color: Colors.grey.shade400,
        child: Container(
          constraints: const BoxConstraints(minHeight: 50),
          padding: const EdgeInsets.all(10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reportTitle,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          color: AppColor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    reportTitle == 'تقرير مبيعات اليوم'
                        ? Text(dateFrom)
                        : reportTitle == 'تقرير مبيعات فترة'
                            ? Row(
                                children: [
                                  InkWell(
                                    onTap: _selectDateFrom,
                                    child: Text(dateFrom),
                                  ),
                                  const Text("  :  "),
                                  InkWell(
                                    onTap: _selectDateTo,
                                    child: Text(dateTo),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  InkWell(
                                    onTap: _selectDateFrom1,
                                    child: Text(dateFrom),
                                  ),
                                  const Text("  :  "),
                                  InkWell(
                                    onTap: _selectDateTo1,
                                    child: Text(dateTo),
                                  ),
                                ],
                              )
                  ]),
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.primary,
                      backgroundColor: AppColor.background,
                    ),
                    onPressed: () async => {
                      await PdfReport.generateDailyReport(
                          reportTitle: reportTitle,
                          dateFrom: dateFrom,
                          dateTo: dateTo,
                          invoices: reportTitle == 'تقرير مبيعات اليوم'
                              ? await FatooraDB.instance
                                  .getAllInvoicesBetweenTwoDates(
                                      _dateTo.text, _dateTo.text)
                              : await FatooraDB.instance
                                  .getAllInvoicesBetweenTwoDates(
                                      _dateFrom.text, _dateTo.text),
                          purchases: await FatooraDB.instance
                              .getAllPurchasesBetweenTwoDates(
                                  _dateFrom1.text, _dateTo1.text),
                          isDemo: isDemo),
                    },
                    child: const Text('طباعة PDF'),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColor.primary,
                      backgroundColor: AppColor.background,
                    ),
                    onPressed: () async {
                      await ExcelReport.generateExcelReport(
                          reportTitle: reportTitle,
                          dateFrom: dateFrom,
                          dateTo: dateTo,
                          invoices: reportTitle == 'تقرير مبيعات اليوم'
                              ? await FatooraDB.instance
                                  .getAllInvoicesBetweenTwoDates(
                                      _dateTo.text, _dateTo.text)
                              : await FatooraDB.instance
                                  .getAllInvoicesBetweenTwoDates(
                                      _dateFrom.text, _dateTo.text),
                          purchases: await FatooraDB.instance
                              .getAllPurchasesBetweenTwoDates(
                                  _dateFrom1.text, _dateTo1.text),
                          isDemo: isDemo);
                    },
                    child: const Text('إكسيل'),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  _selectDateFrom() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
        firstDate: DateTime(2021),
        lastDate: DateTime(2055));
    if (picked != null) {
      setState(() => _dateFrom.text = Utils.formatShortDate(picked).toString());
    }
  }

  _selectDateTo() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2055));
    if (picked != null) {
      setState(() => _dateTo.text = Utils.formatShortDate(picked).toString());
    }
  }

  _selectDateFrom1() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day - 1),
        firstDate: DateTime(2021),
        lastDate: DateTime(2055));
    if (picked != null) {
      setState(
          () => _dateFrom1.text = Utils.formatShortDate(picked).toString());
    }
  }

  _selectDateTo1() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime(2055));
    if (picked != null) {
      setState(() => _dateTo1.text = Utils.formatShortDate(picked).toString());
    }
  }
}
