import '../widgets/widget.dart';
import '/models/product.dart';

// import '/widgets/product_card_widget.dart';
import '/db/fatoora_db.dart';
import '/models/settings.dart';

import '/widgets/loading.dart';
import '/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/widgets/app_colors.dart';
import 'edit_product_page.dart';
import 'home_page.dart';
// import 'product_detail_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  FatooraDB db = FatooraDB.instance;
  late int uid;
  bool isLoading = false;
  List<Product> products = [];
  late List<Setting> user;
  bool noProductFount = false;
  int workOffline = 0;

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

  Future getProductsList() async {
    try {
      setState(() => isLoading = true);

      List<Setting> setting;
      setting = await FatooraDB.instance.getAllSettings();
      if (setting.isNotEmpty) {
        setState(() {
          workOffline = setting[0].workOffline;
        });
      }
      if (workOffline == 1) {
        await FatooraDB.instance.getAllProducts().then((list) {
          products = list;
        });
      }
      if (products.isEmpty) {
        setState(() {
          noProductFount = true;
        });
      }

      setState(() => isLoading = false);
    } on Exception catch (e) {
      messageBox(e.toString());
    }
  }

  Future refreshDashboard() async {
    getProductsList();
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

  _textTitle() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.only(right: 20),
      child: const Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppButtons(
              icon: Icons.store,
              iconSize: 40,
              radius: 40,
              iconColor: AppColor.secondary),
          Text(
            'المنتجات',
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
            child: noProductFount
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لا توجد لديك أي منتجات',
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'قم بإضافة منتجات جديدة كما يمكنك الادخال اليدوي للفواتير بشكل مباشر',
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
                    : TableProduct(
                        product: products,
                      )),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppButtons(
                                    icon: Icons.add,
                                    textPositionDown: false,
                                    text: "إضافة منتج",
                                    onTap: () => Get.to(
                                        () => const AddEditProductPage()),
                                  ),
                                  //TotalSummary(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
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
          ),
        ),
      );
}
