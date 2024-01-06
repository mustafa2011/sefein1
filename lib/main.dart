import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '/screens/home_page.dart';
import '/widgets/app_colors.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory? docDir;
  /*
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  if (Platform.isAndroid) {
    docDir = await getExternalStorageDirectory();
  } else {
    docDir = await getApplicationDocumentsDirectory();
  }
  */
  docDir = await getExternalStorageDirectory();

  final newDir = Directory("${docDir?.path}/Fatoora");
  if (!(await newDir.exists())) {
    newDir.create();
  }

  final yearDir = Directory('${newDir.path}/${DateTime.now().year.toString()}');
  if (!(await yearDir.exists())) {
    await yearDir.create();
  }

  final dailyDir = Directory("${docDir?.path}/Fatoora/Reports");
  if (!(await dailyDir.exists())) {
    dailyDir.create();
  }

  final dbDir = Directory("${docDir?.path}/Fatoora/Database");
  if (!(await dbDir.exists())) {
    dbDir.create();
  }
  final oldDbDir = Directory("${docDir?.path}/Fatoora/OldDatabase");
  if (!(await oldDbDir.exists())) {
    oldDbDir.create();
  }

  final estimatesDir = Directory("${yearDir.path}/estimates");
  if (!(await estimatesDir.exists())) {
    estimatesDir.create();
  }

  final invoicesDir = Directory("${yearDir.path}/invoices");
  if (!(await invoicesDir.exists())) {
    invoicesDir.create();
  }

  final receiptsDir = Directory("${yearDir.path}/RECEIPT");
  if (!(await receiptsDir.exists())) {
    receiptsDir.create();
  }

  final paymentsDir = Directory("${yearDir.path}/PAYMENT");
  if (!(await paymentsDir.exists())) {
    paymentsDir.create();
  }

  final estDir01 = Directory("${estimatesDir.path}/01");
  final estDir02 = Directory("${estimatesDir.path}/02");
  final estDir03 = Directory("${estimatesDir.path}/03");
  final estDir04 = Directory("${estimatesDir.path}/04");
  final estDir05 = Directory("${estimatesDir.path}/05");
  final estDir06 = Directory("${estimatesDir.path}/06");
  final estDir07 = Directory("${estimatesDir.path}/07");
  final estDir08 = Directory("${estimatesDir.path}/08");
  final estDir09 = Directory("${estimatesDir.path}/09");
  final estDir10 = Directory("${estimatesDir.path}/10");
  final estDir11 = Directory("${estimatesDir.path}/11");
  final estDir12 = Directory("${estimatesDir.path}/12");

  if (!(await estDir01.exists())) {
    estDir01.create();
  }
  if (!(await estDir02.exists())) {
    estDir02.create();
  }
  if (!(await estDir03.exists())) {
    estDir03.create();
  }
  if (!(await estDir04.exists())) {
    estDir04.create();
  }
  if (!(await estDir05.exists())) {
    estDir05.create();
  }
  if (!(await estDir06.exists())) {
    estDir06.create();
  }
  if (!(await estDir07.exists())) {
    estDir07.create();
  }
  if (!(await estDir08.exists())) {
    estDir08.create();
  }
  if (!(await estDir09.exists())) {
    estDir09.create();
  }
  if (!(await estDir10.exists())) {
    estDir10.create();
  }
  if (!(await estDir11.exists())) {
    estDir11.create();
  }
  if (!(await estDir12.exists())) {
    estDir12.create();
  }

  final invDir01 = Directory("${invoicesDir.path}/01");
  final invDir02 = Directory("${invoicesDir.path}/02");
  final invDir03 = Directory("${invoicesDir.path}/03");
  final invDir04 = Directory("${invoicesDir.path}/04");
  final invDir05 = Directory("${invoicesDir.path}/05");
  final invDir06 = Directory("${invoicesDir.path}/06");
  final invDir07 = Directory("${invoicesDir.path}/07");
  final invDir08 = Directory("${invoicesDir.path}/08");
  final invDir09 = Directory("${invoicesDir.path}/09");
  final invDir10 = Directory("${invoicesDir.path}/10");
  final invDir11 = Directory("${invoicesDir.path}/11");
  final invDir12 = Directory("${invoicesDir.path}/12");

  if (!(await invDir01.exists())) {
    invDir01.create();
  }
  if (!(await invDir02.exists())) {
    invDir02.create();
  }
  if (!(await invDir03.exists())) {
    invDir03.create();
  }
  if (!(await invDir04.exists())) {
    invDir04.create();
  }
  if (!(await invDir05.exists())) {
    invDir05.create();
  }
  if (!(await invDir06.exists())) {
    invDir06.create();
  }
  if (!(await invDir07.exists())) {
    invDir07.create();
  }
  if (!(await invDir08.exists())) {
    invDir08.create();
  }
  if (!(await invDir09.exists())) {
    invDir09.create();
  }
  if (!(await invDir10.exists())) {
    invDir10.create();
  }
  if (!(await invDir11.exists())) {
    invDir11.create();
  }
  if (!(await invDir12.exists())) {
    invDir12.create();
  }

  final recDir01 = Directory("${receiptsDir.path}/01");
  final recDir02 = Directory("${receiptsDir.path}/02");
  final recDir03 = Directory("${receiptsDir.path}/03");
  final recDir04 = Directory("${receiptsDir.path}/04");
  final recDir05 = Directory("${receiptsDir.path}/05");
  final recDir06 = Directory("${receiptsDir.path}/06");
  final recDir07 = Directory("${receiptsDir.path}/07");
  final recDir08 = Directory("${receiptsDir.path}/08");
  final recDir09 = Directory("${receiptsDir.path}/09");
  final recDir10 = Directory("${receiptsDir.path}/10");
  final recDir11 = Directory("${receiptsDir.path}/11");
  final recDir12 = Directory("${receiptsDir.path}/12");

  if (!(await recDir01.exists())) {
    recDir01.create();
  }
  if (!(await recDir02.exists())) {
    recDir02.create();
  }
  if (!(await recDir03.exists())) {
    recDir03.create();
  }
  if (!(await recDir04.exists())) {
    recDir04.create();
  }
  if (!(await recDir05.exists())) {
    recDir05.create();
  }
  if (!(await recDir06.exists())) {
    recDir06.create();
  }
  if (!(await recDir07.exists())) {
    recDir07.create();
  }
  if (!(await recDir08.exists())) {
    recDir08.create();
  }
  if (!(await recDir09.exists())) {
    recDir09.create();
  }
  if (!(await recDir10.exists())) {
    recDir10.create();
  }
  if (!(await recDir11.exists())) {
    recDir11.create();
  }
  if (!(await recDir12.exists())) {
    recDir12.create();
  }

  final payDir01 = Directory("${paymentsDir.path}/01");
  final payDir02 = Directory("${paymentsDir.path}/02");
  final payDir03 = Directory("${paymentsDir.path}/03");
  final payDir04 = Directory("${paymentsDir.path}/04");
  final payDir05 = Directory("${paymentsDir.path}/05");
  final payDir06 = Directory("${paymentsDir.path}/06");
  final payDir07 = Directory("${paymentsDir.path}/07");
  final payDir08 = Directory("${paymentsDir.path}/08");
  final payDir09 = Directory("${paymentsDir.path}/09");
  final payDir10 = Directory("${paymentsDir.path}/10");
  final payDir11 = Directory("${paymentsDir.path}/11");
  final payDir12 = Directory("${paymentsDir.path}/12");

  if (!(await payDir01.exists())) {
    payDir01.create();
  }
  if (!(await payDir02.exists())) {
    payDir02.create();
  }
  if (!(await payDir03.exists())) {
    payDir03.create();
  }
  if (!(await payDir04.exists())) {
    payDir04.create();
  }
  if (!(await payDir05.exists())) {
    payDir05.create();
  }
  if (!(await payDir06.exists())) {
    payDir06.create();
  }
  if (!(await payDir07.exists())) {
    payDir07.create();
  }
  if (!(await payDir08.exists())) {
    payDir08.create();
  }
  if (!(await payDir09.exists())) {
    payDir09.create();
  }
  if (!(await payDir10.exists())) {
    payDir10.create();
  }
  if (!(await payDir11.exists())) {
    payDir11.create();
  }
  if (!(await payDir12.exists())) {
    payDir12.create();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FATOORA',
      theme: ThemeData(
        fontFamily: 'Cairo',
        primarySwatch: Colors.orange,
        primaryColor: AppColor.primary,
        primaryColorLight: AppColor.secondary,
        scaffoldBackgroundColor: AppColor.background,
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const HomePage(),
    );
  }
}
