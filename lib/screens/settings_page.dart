import 'dart:io';

import '/apis/constants/utils.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/settings_ext.dart';
import '/db/fatoora_db.dart';
import '/models/settings.dart';
import '/widgets/app_colors.dart';
import '/widgets/loading.dart';
import '/widgets/setting_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late List<Setting> setting;
  late List<SettingExt> settingExt;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  int? uid;
  String name = '';
  String email = '';
  String password = '';
  String cellphone = '';
  String seller = '';
  String buildingNo = '';
  String streetName = '';
  String district = '';
  String city = '';
  String country = '';
  String postalCode = '';
  String additionalNo = '';
  String vatNumber = '';
  String logo = '';
  String terms = '';
  String terms1 = '';
  String terms2 = '';
  String terms3 = '';
  String terms4 = '';
  String terms5 = '';
  int logoWidth = 75;
  int logoHeight = 75;
  String sheetId = '';
  int workOffline = 1;
  String activationCode = '';
  String? startDateTime;

  @override
  void initState() {
    super.initState();
    getSetting();
  }

  Future getSetting() async {
    setState(() => isLoading = true);
    setting = await FatooraDB.instance.getAllSettings();
    settingExt = await FatooraDB.instance.getAllSettingsExt();

    setState(() {
      uid = setting[0].id as int;
      name = setting[0].name;
      email = setting[0].email;
      password = setting[0].password;
      cellphone = setting[0].cellphone;
      seller = setting[0].seller;
      buildingNo = setting[0].buildingNo;
      streetName = setting[0].streetName;
      district = setting[0].district;
      city = setting[0].city;
      country = setting[0].country;
      postalCode = setting[0].postalCode;
      additionalNo = setting[0].additionalNo;
      vatNumber = setting[0].vatNumber;
      logo = setting[0].logo;
      terms = setting[0].terms;
      terms1 = settingExt[0].terms1;
      terms2 = settingExt[0].terms2;
      terms3 = settingExt[0].terms3;
      terms4 = settingExt[0].terms4;
      terms5 = settingExt[0].terms5;
      logoWidth = setting[0].logoWidth;
      logoHeight = setting[0].logoHeight;
      sheetId = setting[0].sheetId;
      workOffline = setting[0].workOffline;
      startDateTime = setting[0].startDateTime;
      activationCode = setting[0].activationCode;
    });

    setState(() => isLoading = false);
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
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'شاشة الإعدادات :$uid',
            style: const TextStyle(
                color: AppColor.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18),
          ),
          actions: [
            PopupMenuButton(
              tooltip: 'القائمة',
              icon: const Icon(Icons.menu),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('حفظ الاعدادات',
                            style: TextStyle(
                                color: AppColor.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Icon(
                          Icons.save,
                          color: AppColor.primary,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('تغيير الشعار',
                            style: TextStyle(
                                color: AppColor.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Icon(
                          Icons.assistant_photo,
                          color: AppColor.primary,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem<int>(
                      height: 2, enabled: false, child: Divider(thickness: 2)),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('الصفحة الرئيسية',
                            style: TextStyle(
                                color: AppColor.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        Icon(
                          Icons.home,
                          color: AppColor.primary,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                ];
              },
              onSelected: (value) async {
                switch (value) {
                  case 0:
                    setState(() => isLoading = true);
                    await updateSetting();
                    setState(() => isLoading = false);
                    break;
                  case 1:
                    File? customImageFile;
                    if (Platform.isWindows) {
                      var image = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'png', 'jpeg'],
                      );
                      customImageFile = image != null
                          ? File(image.files.first.path.toString())
                          : File(
                              '${(await getTemporaryDirectory()).path}/logo.png');
                    } else {
                      var img = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      customImageFile = File(img!.path);
                    }
                    String imgString =
                        Utils.base64String(customImageFile.readAsBytesSync());
                    setState(() {
                      logo = imgString;
                    });
                    final byteData =
                        await rootBundle.load('assets/images/logo.png');

                    customImageFile = File(
                        '${(await getTemporaryDirectory()).path}/logo.png');
                    customImageFile.writeAsBytes(byteData.buffer.asUint8List(
                        byteData.offsetInBytes, byteData.lengthInBytes));
                    break;
                  case 2:
                    Get.to(() => const HomePage());
                    break;
                  default:
                    break;
                }
              },
            ),
          ],
          leading: Container(),
        ),
        body: isLoading
            ? const Loading()
            : Container(
                width: w,
                color: AppColor.background,
                child: Column(
                  children: [
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.all(10),
                      width: w,
                      child: isLoading
                          ? const Loading()
                          : Form(
                              key: _formKey,
                              child: SettingFormWidget(
                                name: name,
                                email: email,
                                password: password,
                                cellphone: cellphone,
                                seller: seller,
                                buildingNo: buildingNo,
                                streetName: streetName,
                                district: district,
                                city: city,
                                country: country,
                                postalCode: postalCode,
                                additionalNo: additionalNo,
                                vatNumber: vatNumber,
                                startDateTime: startDateTime,
                                activationCode: activationCode,
                                logo: logo,
                                terms: terms,
                                terms1: terms1,
                                terms2: terms2,
                                terms3: terms3,
                                terms4: terms4,
                                terms5: terms5,
                                logoWidth: logoWidth,
                                logoHeight: logoHeight,
                                workOffline: workOffline,
                                onChangedName: (name) =>
                                    setState(() => this.name = name),
                                onChangedEmail: (email) =>
                                    setState(() => this.email = email),
                                onChangedPassword: (password) =>
                                    setState(() => this.password = password),
                                onChangedCellphone: (cellphone) =>
                                    setState(() => this.cellphone = cellphone),
                                onChangedSeller: (seller) =>
                                    setState(() => this.seller = seller),
                                onChangedBuildingNo: (buildingNo) => setState(
                                    () => this.buildingNo = buildingNo),
                                onChangedStreetName: (streetName) => setState(
                                    () => this.streetName = streetName),
                                onChangedDistrict: (district) =>
                                    setState(() => this.district = district),
                                onChangedCity: (city) =>
                                    setState(() => this.city = city),
                                onChangedCountry: (country) =>
                                    setState(() => this.country = country),
                                onChangedPostalCode: (postalCode) => setState(
                                    () => this.postalCode = postalCode),
                                onChangedAdditionalNo: (additionalNo) =>
                                    setState(
                                        () => this.additionalNo = additionalNo),
                                onChangedVatNumber: (vatNumber) =>
                                    setState(() => this.vatNumber = vatNumber),
                                onChangedSheetId: (sheetId) =>
                                    setState(() => this.sheetId = sheetId),
                                onChangedActivationCode: (activationCode) =>
                                    setState(() =>
                                        this.activationCode = activationCode),
                                onChangedLogo: (logo) =>
                                    setState(() => this.logo = logo),
                                onChangedTerms: (terms) =>
                                    setState(() => this.terms = terms),
                                onChangedTerms1: (terms1) =>
                                    setState(() => this.terms1 = terms1),
                                onChangedTerms2: (terms2) =>
                                    setState(() => this.terms2 = terms2),
                                onChangedTerms3: (terms3) =>
                                    setState(() => this.terms3 = terms3),
                                onChangedTerms4: (terms4) =>
                                    setState(() => this.terms4 = terms4),
                                onChangedTerms5: (terms5) =>
                                    setState(() => this.terms5 = terms5),
                                onChangedLogoWidth: (logoWidth) => setState(
                                    () =>
                                        this.logoWidth = int.parse(logoWidth)),
                                onChangedLogoHeight: (logoHeight) => setState(
                                    () => this.logoHeight =
                                        int.parse(logoHeight)),
                                onChangedWorkOffline: (workOffline) {},
                              ),
                            ),
                    )),
                  ],
                ),
              ));
  }

  Future<File> getLogoFile(ByteData byteData) async {
    final byteData = await rootBundle.load('assets/images/logo.png');

    final file = File('${(await getTemporaryDirectory()).path}/logo.png');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  Future updateSetting() async {
    final isValid = _formKey.currentState!.validate();
    try {
      if (isValid) {
        var user = Setting(
          id: uid,
          name: name,
          email: email,
          password: password,
          cellphone: cellphone,
          seller: seller,
          buildingNo: buildingNo,
          streetName: streetName,
          district: district,
          city: city,
          country: country,
          postalCode: postalCode,
          additionalNo: additionalNo,
          vatNumber: vatNumber,
          logo: logo,
          terms: terms,
          logoWidth: logoWidth,
          logoHeight: logoHeight,
          sheetId: sheetId,
          workOffline: workOffline,
          activationCode: activationCode,
          startDateTime: startDateTime!,
        );
        var user1 = SettingExt(
          id: uid,
          terms1: terms1,
          terms2: terms2,
          terms3: terms3,
          terms4: terms4,
          terms5: terms5,
        );
        //Update local database
        await FatooraDB.instance.updateSetting(user);
        await FatooraDB.instance.updateSettingExt(user1);
        Get.to(() => const HomePage());
      }
    } on Exception catch (e) {
      messageBox("تأكد من وجود اتصال بالانترنت\n$e");
    }
  }
}
