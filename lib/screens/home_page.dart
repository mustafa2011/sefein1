import 'dart:io';

import 'products_page.dart';
import 'vouchers_page.dart';

import '/apis/constants/utils.dart';
import '/models/settings.dart';
import '/db/fatoora_db.dart';
import '/models/product.dart';
import '/widgets/loading.dart';
import '/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/widgets/app_colors.dart';

import 'reports_page.dart';
import 'customers_page.dart';

import 'invoices_page.dart';
import 'vat_endorsement.dart';

// import 'register_page.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FatooraDB db = FatooraDB.instance;
  late int uid;
  int workOffline = 1;
  bool isLoading = false;
  List<Product> products = [];
  int? productsCount;
  int? customersCount;
  int? invoicesCount;
  int? purchasesCount;
  num? totalSales;
  num? totalPurchases;
  num? totalVAT;
  dynamic vat;
  bool existLocalUser = false;
  bool validLicense = false;
  String strVersion = 'نسخة تجريبية';
  int? dbVersion;
  int selectedYear = DateTime.now().year;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    //db.close();
    super.initState();
    checkAuthentication();
    _controller.text = selectedYear.toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future checkAuthentication() async {
    try {
      setState(() => isLoading = true);
      dbVersion = await db.getDbVersion();
      var userSetting = await db.getAllSettings();
      if (userSetting.isNotEmpty) {
        setState(() => existLocalUser = true);
        uid = userSetting[0].id as int;
        productsCount = await db.getProductsCount() ?? 0;
        customersCount = await db.getCustomerCount() ?? 0;
        invoicesCount = await db.getInvoicesCount(selectedYear) ?? 0;
        purchasesCount = await db.getPurchasesCount(selectedYear) ?? 0;
        totalSales = await db.getTotalSales(selectedYear) ?? 0.0;
        totalVAT = totalSales! - (totalSales! / 1.15);
        totalPurchases = await db.getTotalPurchases(selectedYear) ?? 0.0;

        setState(() => validLicense = true);
        setState(() => strVersion = Utils.defLanguage == 'Arabic'
            ? 'النسخة الأصلية'
            : 'Original Version');
      }
      setState(() => isLoading = false);
    } on Exception catch (e) {
      messageBox(e.toString());
    }
  }

  Future<int> offLine() async {
    int result = 0;
    List<Setting> setting;
    setting = await FatooraDB.instance.getAllSettings();
    if (setting.isNotEmpty) {
      result = setting[0].workOffline;
    }
    return result;
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
            body: existLocalUser
                ? validLicense
                    ? Container(
                        height: h,
                        width: w,
                        color: AppColor.background,
                        child: Stack(
                          children: [
                            buildHeader(),
                            buildBody(h * 0.30),
                            buildBottomMenu(),
                          ],
                        ),
                      )
                    : const SettingsPage()
                : Container() //const Register(),
            );
  }

  Widget buildHeader() => Container(
        height: MediaQuery.of(context).size.height * 0.30,
        color: AppColor.secondary,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * 0.45,
              color: AppColor.primary,
            ),
            _mainBackground(),
            _textTitle(),
          ],
        ),
      );

  _mainBackground() {
    return Positioned(
        top: 0,
        right: 0,
        left: 70,
        bottom: 0,
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage("assets/images/header_page.png"),
              ),
            )));
  }

  _textTitle() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الواضح فاتورة',
            style: TextStyle(
              fontSize: 35,
              color: AppColor.secondary,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "رقم المستخدم: $uid",
                style: const TextStyle(
                    color: AppColor.secondary, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    '$strVersion\nالإصدار $dbVersion',
                    style: const TextStyle(
                        color: AppColor.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          ),
          Text(
            'رقم الدعم الفني: ${Utils.defSupportNumber}',
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildBody(double h) => Positioned(
        top: h,
        left: 0,
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'احصائيات عام ',
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColor.primary,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: 70,
                  child: TextFormField(
                      onTap: () {
                        var textValue = _controller.text;
                        _controller.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: textValue.length,
                        );
                      },
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      controller: _controller,
                      onChanged: (val) {
                        setState(() => selectedYear = int.parse(val));
                      }),
                ),
              ],
            ),
            Container(
              color: AppColor.background,
              padding: const EdgeInsets.all(5),
              height: Platform.isAndroid
                  ? MediaQuery.of(context).size.height * 0.60
                  : MediaQuery.of(context).size.height * 0.59,
              // change to 0.45 if you show endorsement button
              width: MediaQuery.of(context).size.width,
              child: makeWindowsDashboard(),
            ),
          ],
        ),
      );

  Widget makeDashboardItem(
      String result, String title, String result1, String title1) {
    return Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const SizedBox(width: 0),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: AppColor.secondary,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 6.0,
                            color: Colors.grey,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      )),
                  title1 == ''
                      ? const SizedBox(height: 0)
                      : const SizedBox(height: 20),
                  title1 == ''
                      ? Container()
                      : Text(title1,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: AppColor.secondary,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 6.0,
                                color: Colors.grey,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          )),
                ],
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(result,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: AppColor.primary,
                        fontWeight: FontWeight.w800,
                        shadows: [
                          Shadow(
                            blurRadius: 6.0,
                            color: Colors.grey,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      )),
                  title1 == ''
                      ? const SizedBox(height: 0)
                      : const SizedBox(height: 20),
                  result1 == ''
                      ? Container()
                      : Text(result1,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: AppColor.primary,
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(
                                blurRadius: 6.0,
                                color: Colors.grey,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          )),
                ],
              ),
            ),
            const SizedBox(width: 0),
          ],
        ));
  }

  Widget makeWindowsDashboard() {
    final titles = Utils.isProVersion
        ? <String>[
            'عدد المنتجات',
            'عدد العملاء',
            'عدد فواتير المبيعات',
            'عدد فواتير المشتريات',
            'إجمالي المبيعات',
            'إجمالي ضريبة المبيعات',
            'إجمالي المشتريات',
            'إجمالي ضريبة المشتريات',
          ]
        : <String>[
            'عدد المنتجات',
            'عدد فواتير المبيعات',
            'عدد فواتير المشتريات',
            'إجمالي المبيعات',
            'إجمالي ضريبة المبيعات',
            'إجمالي المشتريات',
            'إجمالي ضريبة المشتريات',
          ];
    final data = Utils.isProVersion
        ? <String>[
            '$productsCount',
            '$customersCount',
            '$invoicesCount',
            '$purchasesCount',
            '${Utils.format(totalSales!)}',
            '${Utils.format(totalVAT!)}',
            '${Utils.format(totalPurchases!)}',
            '${Utils.format(totalPurchases! - totalPurchases! / 1.15)}',
          ]
        : <String>[
            '$productsCount',
            '$invoicesCount',
            '$purchasesCount',
            '${Utils.format(totalSales!)}',
            '${Utils.format(totalVAT!)}',
            '${Utils.format(totalPurchases!)}',
            '${Utils.format(totalPurchases! - totalPurchases! / 1.15)}',
          ];

    return Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.all(20),
          child: ListView.builder(
            itemCount: titles.length,
            itemBuilder: (BuildContext context, int index) => Column(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(titles[index]),
                      Text(data[index]),
                    ]),
              ),
              const Divider(),
            ]),
          ),
        ));
  }

  Widget buildBottomMenu() => Positioned(
        left: 0,
        bottom: 5,
        child: Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          color: AppColor.background,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton(
                tooltip: 'القائمة الرئيسية',
                color: AppColor.secondary,
                padding: EdgeInsets.all(Platform.isAndroid ? 2 : 0),
                icon: AppButtons(
                  backgroundColor: AppColor.secondary,
                  iconColor: AppColor.primary,
                  icon: Icons.menu,
                  iconSize: Platform.isAndroid ? 24 : 20,
                  radius: 24,
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: AppButtons(
                      icon: Icons.store,
                      textPositionDown: false,
                      text: "منتجات",
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: AppButtons(
                      icon: Icons.person_pin_rounded,
                      textPositionDown: false,
                      text: "عملاء",
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: AppButtons(
                      icon: Icons.money, // .point_of_sale,
                      textPositionDown: false,
                      text: "فواتير",
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: AppButtons(
                      icon: Icons.task, // .point_of_sale,
                      textPositionDown: false,
                      text: "أخرى",
                    ),
                  ),
                  const PopupMenuItem<int>(
                    enabled: false,
                    height: 20,
                    child: Divider(thickness: 2),
                  ),
                  const PopupMenuItem<int>(
                    value: 4,
                    child: AppButtons(
                      icon: Icons.handshake_outlined, // .point_of_sale,
                      textPositionDown: false,
                      text: "الإقرارات الضريبية",
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 5,
                    child: AppButtons(
                      icon: Icons.find_in_page_rounded, // .point_of_sale,
                      textPositionDown: false,
                      text: "التقارير",
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      Get.to(() => const ProductsPage());
                      break;
                    case 1:
                      Get.to(() => const CustomersPage());
                      break;
                    case 2:
                      Get.to(() => const InvoicesPage());
                      break;
                    case 3:
                      Get.to(
                          () => const VouchersPage(transactionType: 'RECEIPT'));
                      break;
                    case 4:
                      Get.to(() => const VatEndorsementPage());
                      break;
                    case 5:
                      Get.to(() => const ReportsPage());
                      break;
                    default:
                      break;
                  }
                },
              ),
              Row(
                children: [
                  AppButtons(
                    backgroundColor: AppColor.secondary,
                    iconColor: AppColor.primary,
                    icon: Icons.settings,
                    iconSize: 24,
                    radius: 24,
                    onTap: () => Get.to(() => const SettingsPage()),
                  ),
                  const SizedBox(width: 3),
                  AppButtons(
                    backgroundColor: AppColor.secondary,
                    iconColor: AppColor.primary,
                    icon: Icons.refresh,
                    iconSize: 24,
                    radius: 24,
                    onTap: () => checkAuthentication(),
                  ),
                ],
              )
            ],
          ),
          // )
        ),
      );

  Widget buildRefreshButton() => Positioned(
        left: 10,
        top: 50,
        child: AppButtons(
          icon: Icons.refresh,
          iconSize: 24,
          radius: 24,
          onTap: () => checkAuthentication(),
        ),
      );
}
