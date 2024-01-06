import '../widgets/widget.dart';
import '/models/customers.dart';
import '/db/fatoora_db.dart';
import '/models/settings.dart';
import '/widgets/loading.dart';
import '/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/widgets/app_colors.dart';
import 'edit_customer_page.dart';
import 'home_page.dart';
// import 'customer_detail_page.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  FatooraDB db = FatooraDB.instance;
  late int uid;
  bool isLoading = false;
  List<Customer> customers = [];
  late List<Setting> user;
  bool noCustomerFount = false;
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

  Future getCustomersList() async {
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
        await FatooraDB.instance.getAllCustomers().then((list) {
          customers = list;
        });
      }
      if (customers.isEmpty) {
        setState(() {
          noCustomerFount = true;
        });
      }

      setState(() => isLoading = false);
    } on Exception catch (e) {
      messageBox(e.toString());
    }
  }

  Future refreshDashboard() async {
    getCustomersList();
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
              icon: Icons.person_pin_rounded,
              iconSize: 40,
              radius: 40,
              iconColor: AppColor.secondary),
          Text(
            'العملاء',
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
            child: noCustomerFount
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'لا يوجد لديك عملاء',
                        style: TextStyle(
                            fontSize: 20,
                            color: AppColor.primary,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'قم بإضافة عملاء جدد كما يمكنك الادخال اليدوي للفواتير بشكل مباشر',
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
                    : TableCustomer(
                        customer: customers,
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
                AppButtons(
                  icon: Icons.add,
                  textPositionDown: false,
                  text: "إضافة عميل",
                  onTap: () => Get.to(() => const AddEditCustomerPage()),
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
        ),
      );
}
