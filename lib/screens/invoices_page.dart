import 'dart:io';
import '../widgets/widget.dart';
import '/models/invoice.dart';
import '/models/product.dart';
import '/models/purchase.dart';

// import '/widgets/invoice_card_widget.dart';
import '/db/fatoora_db.dart';
import '/models/settings.dart';

import '/widgets/loading.dart';
import '/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/widgets/app_colors.dart';
import 'edit_invoice_android_page.dart';
import 'home_page.dart';
// import 'invoice_detail_page.dart';

class InvoicesPage extends StatefulWidget {
  const InvoicesPage({super.key});

  @override
  State<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  FatooraDB db = FatooraDB.instance;
  late int uid;
  bool isLoading = false;
  List<Invoice> invoices = [];
  List<Purchase> purchases = [];
  List<Product> products = [];
  late List<Setting> user;
  bool noInvoiceFount = false;
  bool showPurchase = false;

  @override
  void initState() {
    super.initState();
    refreshDashboard();
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

  Future getInvoicesList() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FatooraDB.instance.getAllInvoices().then((list) {
        invoices = list;
      });

      await FatooraDB.instance.getAllPurchases().then((list) {
        purchases = list;
      });

      setState(() {
        isLoading = false;
      });
    } on Exception catch (e) {
      messageBox(e.toString());
    }
  }

  Future refreshDashboard() async {
    setState(() => isLoading = true);
    int? invoicesCount = await FatooraDB.instance.getInvoicesCount(currentYear);
    int? purchasesCount =
        await FatooraDB.instance.getPurchasesCount(currentYear);
    if (showPurchase == false) {
      if (invoicesCount == 0) {
        setState(() {
          noInvoiceFount = true;
        });
      } else {
        getInvoicesList();
      }
    } else {
      if (purchasesCount == 0) {
        setState(() {
          noInvoiceFount = true;
        });
      } else {
        getInvoicesList();
      }
    }

    setState(() => isLoading = false);
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
                      _textTitle(),
                    ],
                  ),
                  buildBody(),
                  buildButtonsActions(),
                ],
              ),
            ),
          );
  }

  Widget buildSwitch() => Switch(
      value: showPurchase,
      onChanged: (value) {
        setState(() => showPurchase = value);
      });

  _textTitle() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.only(right: 20),
      child: Stack(
        children: [
          AppButtons(
            icon: showPurchase ? Icons.store : Icons.money,
            iconSize: 40,
            radius: 40,
            iconColor: AppColor.secondary,
            onTap: () => setState(() => showPurchase = !showPurchase),
          ),
          Text(
            showPurchase ? 'فواتير المشتريات' : 'فواتير المبيعات',
            style: const TextStyle(
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
          child: noInvoiceFount && !showPurchase
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لا توجد لديك أي فاتورة',
                      style: TextStyle(
                          fontSize: 20,
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'قم بإضافة فاتورة جديدة كما يمكنك الادخال اليدوي للمنتجات بشكل مباشر',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColor.secondary,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : isLoading
                  ? const Loading()
                  : showPurchase
                      ? TablePurchase(purchase: purchases)
                      : TableInvoice(invoice: invoices),
        ),
      );

  Widget hSpace(num count) => SizedBox(width: count * 5);

  Widget vSpace(num count) => SizedBox(height: count * 5);

  Widget buildButtonsActions() => Positioned(
        left: 0,
        bottom: 0,
        child: Container(
          padding:
              const EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
          width: MediaQuery.of(context).size.width,
          height: 60,
          color: AppColor.background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PopupMenuButton(
                tooltip: 'أضف فاتورة',
                color: AppColor.secondary,
                padding: EdgeInsets.all(Platform.isAndroid ? 2 : 0),
                icon: AppButtons(
                  backgroundColor: AppColor.secondary,
                  iconColor: AppColor.primary,
                  icon: Icons.add,
                  iconSize: Platform.isAndroid ? 24 : 20,
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: AppButtons(
                      icon: Icons.add,
                      textPositionDown: false,
                      text: "فاتورة مبيعات",
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: AppButtons(
                      icon: Icons.add,
                      textPositionDown: false,
                      text: "فاتورة مشتريات",
                    ),
                  ),
                ],
                onSelected: (value) {
                  switch (value) {
                    case 0:
                      Get.to(() =>
                          const AddEditInvoiceAndroidPage(isPurchases: false));
                      break;
                    case 1:
                      Get.to(() =>
                          const AddEditInvoiceAndroidPage(isPurchases: true));
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
                    onTap: () => refreshDashboard(),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
