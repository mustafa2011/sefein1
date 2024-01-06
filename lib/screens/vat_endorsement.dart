// import 'dart:io';

import '/apis/constants/utils.dart';
import '/models/product.dart';

import '/db/fatoora_db.dart';
import '/models/settings.dart';

import '/widgets/loading.dart';
import '/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/widgets/app_colors.dart';
import 'home_page.dart';

class VatEndorsementPage extends StatefulWidget {
  const VatEndorsementPage({super.key});

  @override
  State<VatEndorsementPage> createState() => _VatEndorsementPageState();
}

class _VatEndorsementPageState extends State<VatEndorsementPage> {
  FatooraDB db = FatooraDB.instance;
  late int uid;
  bool isLoading = false;
  bool isMonthly = false;
  List<Product> products = [];
  late List<Setting> user;
  int selectedYear = DateTime.now().year;
  num? totalSales = 0.0;
  num? firstQuarterSales = 0.0;
  num? secondQuarterSales = 0.0;
  num? thirdQuarterSales = 0.0;
  num? forthQuarterSales = 0.0;
  num? janSales = 0.0;
  num? febSales = 0.0;
  num? marSales = 0.0;
  num? aprSales = 0.0;
  num? maySales = 0.0;
  num? junSales = 0.0;
  num? julSales = 0.0;
  num? augSales = 0.0;
  num? sepSales = 0.0;
  num? octSales = 0.0;
  num? novSales = 0.0;
  num? decSales = 0.0;

  num? totalPurchases = 0.0;
  num? firstQuarterPurchases = 0.0;
  num? secondQuarterPurchases = 0.0;
  num? thirdQuarterPurchases = 0.0;
  num? forthQuarterPurchases = 0.0;
  num? janPurchases = 0.0;
  num? febPurchases = 0.0;
  num? marPurchases = 0.0;
  num? aprPurchases = 0.0;
  num? mayPurchases = 0.0;
  num? junPurchases = 0.0;
  num? julPurchases = 0.0;
  num? augPurchases = 0.0;
  num? sepPurchases = 0.0;
  num? octPurchases = 0.0;
  num? novPurchases = 0.0;
  num? decPurchases = 0.0;

  int workOffline = 0;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = selectedYear.toString();
    getVatEndorsementCalculation();
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

  Future getVatEndorsementCalculation() async {
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
        totalSales = await FatooraDB.instance.getTotalSales(selectedYear) ?? 0;
        janSales = await FatooraDB.instance.getJanTotalSales(selectedYear) ?? 0;
        febSales = await FatooraDB.instance.getFebTotalSales(selectedYear) ?? 0;
        marSales = await FatooraDB.instance.getMarTotalSales(selectedYear) ?? 0;
        aprSales = await FatooraDB.instance.getAprTotalSales(selectedYear) ?? 0;
        maySales = await FatooraDB.instance.getMayTotalSales(selectedYear) ?? 0;
        junSales = await FatooraDB.instance.getJunTotalSales(selectedYear) ?? 0;
        julSales = await FatooraDB.instance.getJulTotalSales(selectedYear) ?? 0;
        augSales = await FatooraDB.instance.getAugTotalSales(selectedYear) ?? 0;
        sepSales = await FatooraDB.instance.getSepTotalSales(selectedYear) ?? 0;
        octSales = await FatooraDB.instance.getOctTotalSales(selectedYear) ?? 0;
        novSales = await FatooraDB.instance.getNovTotalSales(selectedYear) ?? 0;
        decSales = await FatooraDB.instance.getDecTotalSales(selectedYear) ?? 0;

        firstQuarterSales = janSales! + febSales! + marSales!;
        secondQuarterSales = aprSales! + maySales! + junSales!;
        thirdQuarterSales = julSales! + augSales! + sepSales!;
        forthQuarterSales = octSales! + novSales! + decSales!;

        totalPurchases =
            await FatooraDB.instance.getTotalPurchases(selectedYear) ?? 0;
        janPurchases =
            await FatooraDB.instance.getJanTotalPurchases(selectedYear) ?? 0;
        febPurchases =
            await FatooraDB.instance.getFebTotalPurchases(selectedYear) ?? 0;
        marPurchases =
            await FatooraDB.instance.getMarTotalPurchases(selectedYear) ?? 0;
        aprPurchases =
            await FatooraDB.instance.getAprTotalPurchases(selectedYear) ?? 0;
        mayPurchases =
            await FatooraDB.instance.getMayTotalPurchases(selectedYear) ?? 0;
        junPurchases =
            await FatooraDB.instance.getJunTotalPurchases(selectedYear) ?? 0;
        julPurchases =
            await FatooraDB.instance.getJulTotalPurchases(selectedYear) ?? 0;
        augPurchases =
            await FatooraDB.instance.getAugTotalPurchases(selectedYear) ?? 0;
        sepPurchases =
            await FatooraDB.instance.getSepTotalPurchases(selectedYear) ?? 0;
        octPurchases =
            await FatooraDB.instance.getOctTotalPurchases(selectedYear) ?? 0;
        novPurchases =
            await FatooraDB.instance.getNovTotalPurchases(selectedYear) ?? 0;
        decPurchases =
            await FatooraDB.instance.getDecTotalPurchases(selectedYear) ?? 0;

        firstQuarterPurchases = janPurchases! + febPurchases! + marPurchases!;
        secondQuarterPurchases = aprPurchases! + mayPurchases! + junPurchases!;
        thirdQuarterPurchases = julPurchases! + augPurchases! + sepPurchases!;
        forthQuarterPurchases = octPurchases! + novPurchases! + decPurchases!;
      }

      setState(() => isLoading = false);
    } on Exception catch (e) {
      messageBox(e.toString());
    }
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
                  buildYear(),
                  buildBody(),
                  buildButtonsActions(),
                ],
              ),
            ),
          );
  }

  Widget buildYear() => Positioned(
        left: 40,
        top: 30,
        child: Row(
          children: [
            const Text('السنة : ',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            SizedBox(
              width: 50,
              child: TextField(
                onTap: () {
                  var textValue = _controller.text;
                  _controller.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: textValue.length,
                  );
                },
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: InputBorder.none),
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: const TextStyle(color: Colors.white),
                controller: _controller,
                onChanged: (val) => setState(() {
                  selectedYear = int.parse(val);
                }),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      );

  _textTitle() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.only(right: 20),
      child: const Stack(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppButtons(
              icon: Icons.payment,
              iconSize: 40,
              radius: 40,
              iconColor: AppColor.secondary),
          Text(
            'الإقرارات الضريبية',
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
        left: 5,
        right: 5,
        child: Container(
          color: AppColor.background,
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height * 0.76,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(children: [
              isMonthly ? buildSalesMonthly() : buildSalesQuarterly(),
              const SizedBox(height: 50),
              isMonthly ? buildPurchasesMonthly() : buildPurchasesQuarterly(),
            ]),
          ),
        ),
      );

  Widget buildSalesQuarterly() => Column(
        children: [
          const Divider(height: 2, color: AppColor.primary),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ضريبة المبيعات',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'المبلغ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'الضريبة',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 2, color: AppColor.primary),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار الربع الأول',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(firstQuarterSales! -
                          (firstQuarterSales! - firstQuarterSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          firstQuarterSales! - firstQuarterSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار الربع الثاني',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(secondQuarterSales! -
                          (secondQuarterSales! - secondQuarterSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          secondQuarterSales! - secondQuarterSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار الربع الثالث',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(thirdQuarterSales! -
                          (thirdQuarterSales! - thirdQuarterSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          thirdQuarterSales! - thirdQuarterSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار الربع الرابع',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(forthQuarterSales! -
                          (forthQuarterSales! - forthQuarterSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          forthQuarterSales! - forthQuarterSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(height: 2, color: AppColor.primary),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '  الإجمالي:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  SizedBox(
                    // color:Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          totalSales! - (totalSales! - totalSales! / 1.15)),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    // color:AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(totalSales! - totalSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 2, color: AppColor.primary),
        ],
      );

  Widget buildSalesMonthly() => Column(
        children: [
          const Divider(height: 2, color: AppColor.primary),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ضريبة المبيعات',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'المبلغ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'الضريبة',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 2, color: AppColor.primary),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر يناير',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          janSales! - (janSales! - janSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(janSales! - janSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر فبراير',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          febSales! - (febSales! - febSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(febSales! - febSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر مارس',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          marSales! - (marSales! - marSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(marSales! - marSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر ابريل',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          aprSales! - (aprSales! - aprSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(aprSales! - aprSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر مايو',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          maySales! - (maySales! - maySales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(maySales! - maySales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر يونيو',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          junSales! - (junSales! - junSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(junSales! - junSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر يوليو',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          julSales! - (julSales! - julSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(julSales! - julSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار ش. أغسطس',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          augSales! - (augSales! - augSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(augSales! - augSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر سبتمبر',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          sepSales! - (sepSales! - sepSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(sepSales! - sepSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر أكتوبر',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          octSales! - (octSales! - octSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(octSales! - octSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر نوفمبر',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          novSales! - (novSales! - novSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(novSales! - novSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر ديسمبر',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          decSales! - (decSales! - decSales! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(decSales! - decSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(height: 2, color: AppColor.primary),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '  الإجمالي:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  SizedBox(
                    // color:Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          totalSales! - (totalSales! - totalSales! / 1.15)),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    // color:AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(totalSales! - totalSales! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 2, color: AppColor.primary),
        ],
      );

  Widget buildPurchasesQuarterly() =>
      Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Column(
          children: [
            const Divider(height: 2, color: AppColor.primary),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ضريبة المشتريات',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        'المبلغ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 100,
                      child: Text(
                        'الضريبة',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 2, color: AppColor.primary),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  ' - اقرار الربع الأول',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                Row(
                  children: [
                    Container(
                      color: Colors.white,
                      width: 100,
                      child: Text(
                        Utils.formatNoCurrency(firstQuarterPurchases! -
                            (firstQuarterPurchases! -
                                firstQuarterPurchases! / 1.15)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      color: AppColor.secondary,
                      width: 100,
                      child: Text(
                        Utils.formatNoCurrency(firstQuarterPurchases! -
                            firstQuarterPurchases! / 1.15),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  ' - اقرار الربع الثاني',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                Row(
                  children: [
                    Container(
                      color: Colors.white,
                      width: 100,
                      child: Text(
                        Utils.formatNoCurrency(secondQuarterPurchases! -
                            (secondQuarterPurchases! -
                                secondQuarterPurchases! / 1.15)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      color: AppColor.secondary,
                      width: 100,
                      child: Text(
                        Utils.formatNoCurrency(secondQuarterPurchases! -
                            secondQuarterPurchases! / 1.15),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  ' - اقرار الربع الثالث',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                Row(
                  children: [
                    Container(
                      color: Colors.white,
                      width: 100,
                      child: Text(
                        Utils.formatNoCurrency(thirdQuarterPurchases! -
                            (thirdQuarterPurchases! -
                                thirdQuarterPurchases! / 1.15)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      color: AppColor.secondary,
                      width: 100,
                      child: Text(
                        Utils.formatNoCurrency(thirdQuarterPurchases! -
                            thirdQuarterPurchases! / 1.15),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  ' - اقرار الربع الرابع',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                Row(
                  children: [
                    Container(
                      color: Colors.white,
                      width: 100,
                      child: Text(
                        Utils.formatNoCurrency(forthQuarterPurchases! -
                            (forthQuarterPurchases! -
                                forthQuarterPurchases! / 1.15)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      color: AppColor.secondary,
                      width: 100,
                      child: Text(
                        Utils.formatNoCurrency(forthQuarterPurchases! -
                            forthQuarterPurchases! / 1.15),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Divider(height: 2, color: AppColor.primary),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '  الإجمالي:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    SizedBox(
                      // color:Colors.white,
                      width: 100,
                      child: Text(
                        Utils.formatNoCurrency(totalPurchases! -
                            (totalPurchases! - totalPurchases! / 1.15)),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      // color:AppColor.secondary,
                      width: 100,
                      child: Text(
                        Utils.formatNoCurrency(
                            totalPurchases! - totalPurchases! / 1.15),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 2, color: AppColor.primary),
          ],
        ),
      ]);

  Widget buildPurchasesMonthly() => Column(
        children: [
          const Divider(height: 2, color: AppColor.primary),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ضريبة المشتريات',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      'المبلغ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    width: 100,
                    child: Text(
                      'الضريبة',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 2, color: AppColor.primary),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر يناير',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(janPurchases! -
                          (janPurchases! - janPurchases! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          janPurchases! - janPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر فبراير',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(febPurchases! -
                          (febPurchases! - febPurchases! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          febPurchases! - febPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر مارس',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(marPurchases! -
                          (marPurchases! - marPurchases! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          marPurchases! - marPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر ابريل',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(aprPurchases! -
                          (aprPurchases! - aprPurchases! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          aprPurchases! - aprPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر مايو',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(mayPurchases! -
                          (mayPurchases! - mayPurchases! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          mayPurchases! - mayPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر يونيو',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(junPurchases! -
                          (junPurchases! - junPurchases! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          junPurchases! - junPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر يوليو',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(julPurchases! -
                          (julPurchases! - julPurchases! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          julPurchases! - julPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار ش. أغسطس',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(augPurchases! -
                          (augPurchases! - augPurchases! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          augPurchases! - augPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر سبتمبر',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(sepPurchases! -
                          (sepPurchases! - sepPurchases! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          sepPurchases! - sepPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر أكتوبر',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(octPurchases! -
                          (octPurchases! - octPurchases! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          octPurchases! - octPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر نوفمبر',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(novPurchases! -
                          (novPurchases! - novPurchases! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          novPurchases! - novPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                ' - اقرار شهر ديسمبر',
                style: TextStyle(fontWeight: FontWeight.normal),
              ),
              Row(
                children: [
                  Container(
                    color: Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(decPurchases! -
                          (decPurchases! - decPurchases! / 1.15)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    color: AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          decPurchases! - decPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Divider(height: 2, color: AppColor.primary),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '  الإجمالي:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  SizedBox(
                    // color:Colors.white,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(totalPurchases!),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    // color:AppColor.secondary,
                    width: 100,
                    child: Text(
                      Utils.formatNoCurrency(
                          totalPurchases! - totalPurchases! / 1.15),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 2, color: AppColor.primary),
        ],
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Switch(
                          value: isMonthly,
                          onChanged: (bool value) {
                            setState(() {
                              isMonthly = !isMonthly;
                            });
                          },
                        ),
                        isMonthly
                            ? const Text(
                                'اقرار شهري',
                                style: TextStyle(
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text(
                                'اقرار ربع سنوي',
                                style: TextStyle(
                                    color: AppColor.primary,
                                    fontWeight: FontWeight.bold),
                              ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                          onTap: () => getVatEndorsementCalculation(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
