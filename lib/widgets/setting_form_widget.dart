import 'dart:convert';
import 'dart:io';
import '/models/address.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '/apis/constants/utils.dart';
import '/widgets/app_colors.dart';
import 'package:flutter/material.dart';

class SettingFormWidget extends StatelessWidget {
  final String? name;
  final String? email;
  final String? password;
  final String? cellphone;
  final String? seller;
  final String? buildingNo;
  final String? streetName;
  final String? district;
  final String? city;
  final String? country;
  final String? postalCode;
  final String? additionalNo;
  final String? vatNumber;
  final Address? sellerAddress;
  final String? sheetId;
  final int? workOffline;
  final String? activationCode;
  final String? startDateTime;
  final String? logo;
  final String? terms;
  final String? terms1;
  final String? terms2;
  final String? terms3;
  final String? terms4;
  final String? terms5;
  final int? logoWidth;
  final int? logoHeight;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedEmail;
  final ValueChanged<String> onChangedPassword;
  final ValueChanged<String> onChangedCellphone;
  final ValueChanged<String> onChangedSeller;
  final ValueChanged<String> onChangedBuildingNo;
  final ValueChanged<String> onChangedStreetName;
  final ValueChanged<String> onChangedDistrict;
  final ValueChanged<String> onChangedCity;
  final ValueChanged<String> onChangedCountry;
  final ValueChanged<String> onChangedPostalCode;
  final ValueChanged<String> onChangedAdditionalNo;
  final ValueChanged<String> onChangedVatNumber;
  final ValueChanged<String> onChangedSheetId;
  final ValueChanged<bool> onChangedWorkOffline;
  final ValueChanged<String> onChangedActivationCode;
  final ValueChanged<String> onChangedLogo;
  final ValueChanged<String> onChangedTerms;
  final ValueChanged<String> onChangedTerms1;
  final ValueChanged<String> onChangedTerms2;
  final ValueChanged<String> onChangedTerms3;
  final ValueChanged<String> onChangedTerms4;
  final ValueChanged<String> onChangedTerms5;
  final ValueChanged<String> onChangedLogoWidth;
  final ValueChanged<String> onChangedLogoHeight;

  const SettingFormWidget({
    super.key,
    this.name = '',
    this.email = '',
    this.password = '',
    this.cellphone = '',
    this.seller = '',
    this.buildingNo = '',
    this.streetName = '',
    this.district = '',
    this.city = 'الرياض',
    this.country = 'المملكة العربية السعوية',
    this.postalCode = '',
    this.additionalNo = '',
    this.vatNumber = '',
    this.sellerAddress,
    this.sheetId = '',
    this.workOffline = 0,
    this.activationCode = '',
    this.startDateTime,
    this.logo = '',
    this.terms = '',
    this.terms1 = '',
    this.terms2 = '',
    this.terms3 = '',
    this.terms4 = '',
    this.terms5 = '',
    this.logoWidth = 75,
    this.logoHeight = 75,
    required this.onChangedName,
    required this.onChangedEmail,
    required this.onChangedPassword,
    required this.onChangedCellphone,
    required this.onChangedSeller,
    required this.onChangedBuildingNo,
    required this.onChangedStreetName,
    required this.onChangedDistrict,
    required this.onChangedCity,
    required this.onChangedCountry,
    required this.onChangedPostalCode,
    required this.onChangedAdditionalNo,
    required this.onChangedVatNumber,
    required this.onChangedSheetId,
    required this.onChangedWorkOffline,
    required this.onChangedActivationCode,
    required this.onChangedLogo,
    required this.onChangedTerms,
    required this.onChangedTerms1,
    required this.onChangedTerms2,
    required this.onChangedTerms3,
    required this.onChangedTerms4,
    required this.onChangedTerms5,
    required this.onChangedLogoWidth,
    required this.onChangedLogoHeight,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: buildName()),
                      const SizedBox(width: 20),
                      Expanded(child: buildPassword()),
                    ],
                  ),
                  buildSeller(),
                  Row(
                    children: [
                      Expanded(child: buildEmail()),
                      const SizedBox(width: 20),
                      Expanded(child: buildCellphone()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: buildVatNumber()),
                      const SizedBox(width: 20),
                      Expanded(child: buildBuildingNo()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: buildStreetName()),
                      const SizedBox(width: 20),
                      Expanded(child: buildDistrict()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: buildCity()),
                      const SizedBox(width: 20),
                      Expanded(child: buildCountry()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: buildPostalCode()),
                      const SizedBox(width: 20),
                      Expanded(child: buildAdditionalNo()),
                    ],
                  ),
                  // buildSheetId(),
                  Row(
                    children: [
                      Expanded(child: buildActivationCode()),
                    ],
                  ),
                  buildTerms(),
                  buildTerms1(),
                  buildTerms2(),
                  buildTerms3(),
                  buildTerms4(),
                  buildTerms5(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'شعار الشركة',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'لتغيير الشعار انقر ',
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(
                                Icons.menu,
                                color: AppColor.primary,
                              ),
                              Text(
                                ' أعلى اليسار',
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 70, child: buildLogoWidth()),
                              const SizedBox(width: 10),
                              SizedBox(width: 70, child: buildLogoHeight()),
                            ],
                          ),
                          buildLogo(),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'للدعم الفني تواصل واتساب ${Utils.defFullSupportNumber}',
                        style: const TextStyle(
                          color: AppColor.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildTerms() => TextFormField(
        maxLines: 1,
        initialValue: terms,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'شروط وأحكام (تظهر بأسفل الفاتورة)',
        ),
        onChanged: onChangedTerms,
      );

  Widget buildTerms1() => TextFormField(
        maxLines: 1,
        initialValue: terms1,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'شرط إضافي',
        ),
        onChanged: onChangedTerms1,
      );

  Widget buildTerms2() => TextFormField(
        maxLines: 1,
        initialValue: terms2,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'شرط إضافي',
        ),
        onChanged: onChangedTerms2,
      );

  Widget buildTerms3() => TextFormField(
        maxLines: 1,
        initialValue: terms3,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'شرط إضافي',
        ),
        onChanged: onChangedTerms3,
      );

  Widget buildTerms4() => TextFormField(
        maxLines: 1,
        initialValue: terms4,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'شرط إضافي',
        ),
        onChanged: onChangedTerms4,
      );

  Widget buildTerms5() => TextFormField(
        maxLines: 1,
        initialValue: terms5,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'شرط إضافي',
        ),
        onChanged: onChangedTerms5,
      );

  Widget buildName() => TextFormField(
        maxLines: 1,
        initialValue: name,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'اسم المستخدم *',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'يجب أدخال الاسم' : null,
        onChanged: onChangedName,
      );

  Widget buildEmail() => TextFormField(
        maxLines: 1,
        initialValue: email,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'الايميل *',
        ),
        validator: (email) =>
            email != null && email.isEmpty ? 'يجب أدخال الايميل' : null,
        onChanged: onChangedEmail,
      );

  Widget buildPassword() => TextFormField(
        maxLines: 1,
        initialValue: password,
        obscureText: true,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'كلمة المرور *',
        ),
        validator: (password) => password != null && password.isEmpty
            ? 'يجب أدخال كلمة المرور'
            : null,
        onChanged: onChangedPassword,
      );

  Widget buildCellphone() => TextFormField(
        maxLines: 1,
        initialValue: cellphone,
        keyboardType: TextInputType.phone,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'رقم الجوال *',
        ),
        validator: (cellphone) => cellphone != null && cellphone.isEmpty
            ? 'يجب أدخال رقم الجوال'
            : null,
        onChanged: onChangedCellphone,
      );

  Widget buildSeller() => TextFormField(
        maxLines: 1,
        initialValue: seller,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'اسم الشركة (البائع بالفاتورة) *',
        ),
        validator: (seller) =>
            seller != null && seller.isEmpty ? 'يجب أدخال اسم الشركة' : null,
        onChanged: onChangedSeller,
      );

  Widget buildBuildingNo() => TextFormField(
        maxLines: 1,
        initialValue: buildingNo,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'رقم المبنى',
        ),
        onChanged: onChangedBuildingNo,
      );

  Widget buildStreetName() => TextFormField(
        maxLines: 1,
        initialValue: streetName,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'الشارع',
        ),
        onChanged: onChangedStreetName,
      );

  Widget buildDistrict() => TextFormField(
        maxLines: 1,
        initialValue: district,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'الحي',
        ),
        onChanged: onChangedDistrict,
      );

  Widget buildCity() => TextFormField(
        maxLines: 1,
        initialValue: city,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'المدينة',
        ),
        onChanged: onChangedCity,
      );

  Widget buildCountry() => TextFormField(
        maxLines: 1,
        initialValue: country,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'البلد',
        ),
        onChanged: onChangedCountry,
      );

  Widget buildPostalCode() => TextFormField(
        maxLines: 1,
        initialValue: postalCode,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'الرمز البريدي',
        ),
        onChanged: onChangedPostalCode,
      );

  Widget buildAdditionalNo() => TextFormField(
        maxLines: 1,
        initialValue: additionalNo,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'الرقم الإضافي للعنوان',
        ),
        onChanged: onChangedAdditionalNo,
      );

  Widget buildVatNumber() => TextFormField(
        maxLines: 1,
        initialValue: vatNumber,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'الرقم االضريبي/المميز *',
          hintText: '300005555500003',
        ),
        validator: (vatNumber) => vatNumber != null && vatNumber.isEmpty
            ? 'يجب أدخال الرقم الضريبي'
            : vatNumber!.length != 15
                ? 'يجب أدخال 15 رقم تنتهي ب00003'
                : null,
        onChanged: onChangedVatNumber,
      );

  static Future<String> getLogoFile() async {
    final byteData = await rootBundle.load('assets/images/logo.png');

    final file = File('${(await getTemporaryDirectory()).path}/logo.png');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    final byte = file.readAsBytesSync();
    var base64 = base64Encode(byte);

    return base64;
  }

  Widget buildLogo() => logo != ''
      ? Image.memory(
          base64Decode(logo!),
          height: logoHeight!.toDouble(),
          width: logoWidth!.toDouble(),
          fit: BoxFit.fill,
        )
      : Image(
          image: const AssetImage('assets/images/logo.png'),
          height: logoHeight!.toDouble(),
          width: logoWidth!.toDouble(),
          fit: BoxFit.fill,
        );

  Widget buildTextLogo() => TextFormField(
        initialValue: logo,
        onChanged: onChangedLogo,
      );

  Widget buildLogoWidth() => TextFormField(
        maxLines: 1,
        initialValue: logoWidth.toString(),
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'عرض الشعار',
        ),
        onChanged: onChangedLogoWidth,
      );

  Widget buildLogoHeight() => TextFormField(
        maxLines: 1,
        initialValue: logoHeight.toString(),
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'ارتفاع الشعار',
        ),
        onChanged: onChangedLogoHeight,
      );

  Widget buildSheetId() => TextFormField(
        minLines: 1,
        maxLines: 2,
        initialValue: sheetId,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'معرف ملف قاعدة البيانات',
        ),
        // validator: (sheetId) => sheetId != null && sheetId.isEmpty
        //     ? 'يجب أدخال معرف ملف قاعدة البيانات'
        //     : null,
        onChanged: onChangedSheetId,
      );

  Widget buildActivationCode() => TextFormField(
        minLines: 1,
        maxLines: 2,
        initialValue: activationCode,
        keyboardType: TextInputType.text,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'كود التفعيل',
          // hintText: 'مدة النسخة التجريبية 3 أيام بعدها يطلب كود التفعيل لتحميل النصخة الأصلية'
        ),
        // validator: (sheetId) => sheetId != null && sheetId.isEmpty
        //     ? 'يجب أدخال معرف ملف قاعدة البيانات'
        //     : null,
        onChanged: onChangedActivationCode,
      );

  Widget buildWorkOffline() => Switch(
        value: workOffline == 1 ? true : false,
        onChanged: onChangedWorkOffline,
      );
}

class RegisterFormWidget extends StatelessWidget {
  final String? name;
  final String? email;
  final String? password;
  final String? cellphone;
  final String? seller;
  final String? buildingNo;
  final String? streetName;
  final String? district;
  final String? city;
  final String? country;
  final String? postalCode;
  final String? additionalNo;
  final String? vatNumber;
  final Address? sellerAddress;
  final String? sheetId;
  final int? workOffline;
  final String? activationCode;
  final String? startDateTime;
  final String? logo;
  final String? terms;
  final String? terms1;
  final String? terms2;
  final String? terms3;
  final String? terms4;
  final String? terms5;
  final int? logoWidth;
  final int? logoHeight;
  final ValueChanged<String> onChangedName;
  final ValueChanged<String> onChangedEmail;
  final ValueChanged<String> onChangedPassword;
  final ValueChanged<String> onChangedCellphone;
  final ValueChanged<String> onChangedSeller;
  final ValueChanged<String> onChangedBuildingNo;
  final ValueChanged<String> onChangedStreetName;
  final ValueChanged<String> onChangedDistrict;
  final ValueChanged<String> onChangedCity;
  final ValueChanged<String> onChangedCountry;
  final ValueChanged<String> onChangedPostalCode;
  final ValueChanged<String> onChangedAdditionalNo;
  final ValueChanged<String> onChangedVatNumber;
  final ValueChanged<String> onChangedSheetId;
  final ValueChanged<bool> onChangedWorkOffline;
  final ValueChanged<String> onChangedActivationCode;
  final ValueChanged<String> onChangedLogo;
  final ValueChanged<String> onChangedTerms;
  final ValueChanged<String> onChangedTerms1;
  final ValueChanged<String> onChangedTerms2;
  final ValueChanged<String> onChangedTerms3;
  final ValueChanged<String> onChangedTerms4;
  final ValueChanged<String> onChangedTerms5;
  final ValueChanged<String> onChangedLogoWidth;
  final ValueChanged<String> onChangedLogoHeight;

  const RegisterFormWidget(
      {super.key,
      this.name = '',
      this.email = '',
      this.password = '',
      this.cellphone = '',
      this.seller = '',
      this.buildingNo = '',
      this.streetName = '',
      this.district = '',
      this.city = 'الرياض',
      this.country = 'المملكة العربية السعوية',
      this.postalCode = '',
      this.additionalNo = '',
      this.vatNumber = '',
      this.sellerAddress,
      this.sheetId = '',
      this.workOffline = 0,
      this.activationCode = '',
      this.startDateTime,
      this.logo = '',
      this.terms = '',
      this.terms1 = '',
      this.terms2 = '',
      this.terms3 = '',
      this.terms4 = '',
      this.terms5 = '',
      this.logoWidth = 75,
      this.logoHeight = 75,
      required this.onChangedName,
      required this.onChangedEmail,
      required this.onChangedPassword,
      required this.onChangedCellphone,
      required this.onChangedSeller,
      required this.onChangedBuildingNo,
      required this.onChangedStreetName,
      required this.onChangedDistrict,
      required this.onChangedCity,
      required this.onChangedCountry,
      required this.onChangedPostalCode,
      required this.onChangedAdditionalNo,
      required this.onChangedVatNumber,
      required this.onChangedSheetId,
      required this.onChangedWorkOffline,
      required this.onChangedActivationCode,
      required this.onChangedLogo,
      required this.onChangedTerms,
      required this.onChangedTerms1,
      required this.onChangedTerms2,
      required this.onChangedTerms3,
      required this.onChangedTerms4,
      required this.onChangedTerms5,
      required this.onChangedLogoWidth,
      required this.onChangedLogoHeight});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'أنقر ',
                        style: TextStyle(
                            color: AppColor.button,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                      ),
                      Icon(Icons.menu),
                      Text(
                        ' أعلى اليسار للحفظ بعد التسجيل',
                        style: TextStyle(
                            color: AppColor.button,
                            fontSize: 12,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  Text(
                    'وللدعم الفني تواصل واتساب ${Utils.defFullSupportNumber}',
                    style: const TextStyle(
                        color: AppColor.button,
                        fontSize: 12,
                        fontWeight: FontWeight.normal),
                  ),
                  const Divider(
                      height: 10, thickness: 2, color: AppColor.secondary),
                  Row(
                    children: [
                      Expanded(child: buildName()),
                      const SizedBox(width: 20),
                      Expanded(child: buildPassword()),
                    ],
                  ),
                  buildSeller(),
                  Row(
                    children: [
                      Expanded(child: buildEmail()),
                      const SizedBox(width: 20),
                      Expanded(child: buildCellphone()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: buildVatNumber()),
                      const SizedBox(width: 20),
                      Expanded(child: buildBuildingNo()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: buildStreetName()),
                      const SizedBox(width: 20),
                      Expanded(child: buildDistrict()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: buildCity()),
                      const SizedBox(width: 20),
                      Expanded(child: buildCountry()),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: buildPostalCode()),
                      const SizedBox(width: 20),
                      Expanded(child: buildAdditionalNo()),
                    ],
                  ),
                  buildTerms(),
                  buildTerms1(),
                  buildTerms2(),
                  buildTerms3(),
                  buildTerms4(),
                  buildTerms5(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'شعار الشركة',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'لتغيير الشعار انقر ',
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Icon(
                                Icons.menu,
                                color: AppColor.primary,
                              ),
                              Text(
                                ' أعلى اليسار',
                                style: TextStyle(
                                  color: AppColor.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 70, child: buildLogoWidth()),
                              const SizedBox(width: 10),
                              SizedBox(width: 70, child: buildLogoHeight()),
                            ],
                          ),
                          buildLogo(),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'للدعم الفني تواصل واتساب ${Utils.defFullSupportNumber}',
                        style: const TextStyle(
                          color: AppColor.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildTerms() => TextFormField(
        maxLines: 2,
        initialValue: terms,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'شروط وأحكام (تظهر بأسفل الفاتورة)',
        ),
        onChanged: onChangedTerms,
      );

  Widget buildTerms1() => TextFormField(
        maxLines: 1,
        initialValue: terms1,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'شرط إضافي',
        ),
        onChanged: onChangedTerms1,
      );

  Widget buildTerms2() => TextFormField(
        maxLines: 1,
        initialValue: terms2,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'شرط إضافي',
        ),
        onChanged: onChangedTerms2,
      );

  Widget buildTerms3() => TextFormField(
        maxLines: 1,
        initialValue: terms3,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'شرط إضافي',
        ),
        onChanged: onChangedTerms3,
      );

  Widget buildTerms4() => TextFormField(
        maxLines: 1,
        initialValue: terms4,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'شرط إضافي',
        ),
        onChanged: onChangedTerms4,
      );

  Widget buildTerms5() => TextFormField(
        maxLines: 1,
        initialValue: terms5,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'شرط إضافي',
        ),
        onChanged: onChangedTerms5,
      );

  Widget buildName() => TextFormField(
        maxLines: 1,
        initialValue: name,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'اسم المستخدم *',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'يجب أدخال الاسم' : null,
        onChanged: onChangedName,
      );

  Widget buildEmail() => TextFormField(
        maxLines: 1,
        initialValue: email,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'الايميل *',
        ),
        validator: (email) =>
            email != null && email.isEmpty ? 'يجب أدخال الايميل' : null,
        onChanged: onChangedEmail,
      );

  Widget buildPassword() => TextFormField(
        maxLines: 1,
        initialValue: password,
        obscureText: true,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'كلمة المرور *',
        ),
        validator: (password) => password != null && password.isEmpty
            ? 'يجب أدخال كلمة المرور'
            : null,
        onChanged: onChangedPassword,
      );

  Widget buildCellphone() => TextFormField(
        maxLines: 1,
        initialValue: cellphone,
        keyboardType: TextInputType.phone,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'رقم الجوال *',
        ),
        validator: (cellphone) => cellphone != null && cellphone.isEmpty
            ? 'يجب أدخال رقم الجوال'
            : null,
        onChanged: onChangedCellphone,
      );

  Widget buildSeller() => TextFormField(
        maxLines: 1,
        initialValue: seller,
        keyboardType: TextInputType.name,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'اسم الشركة (البائع بالفاتورة) *',
        ),
        validator: (seller) =>
            seller != null && seller.isEmpty ? 'يجب أدخال اسم الشركة' : null,
        onChanged: onChangedSeller,
      );

  Widget buildBuildingNo() => TextFormField(
        maxLines: 1,
        initialValue: buildingNo,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'رقم المبنى',
        ),
        onChanged: onChangedBuildingNo,
      );

  Widget buildStreetName() => TextFormField(
        maxLines: 1,
        initialValue: streetName,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'الشارع',
        ),
        onChanged: onChangedStreetName,
      );

  Widget buildDistrict() => TextFormField(
        maxLines: 1,
        initialValue: district,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'الحي',
        ),
        onChanged: onChangedDistrict,
      );

  Widget buildCity() => TextFormField(
        maxLines: 1,
        initialValue: city,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'المدينة',
        ),
        onChanged: onChangedCity,
      );

  Widget buildCountry() => TextFormField(
        maxLines: 1,
        initialValue: country,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'البلد',
        ),
        onChanged: onChangedCountry,
      );

  Widget buildPostalCode() => TextFormField(
        maxLines: 1,
        initialValue: postalCode,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'الرمز البريدي',
        ),
        onChanged: onChangedPostalCode,
      );

  Widget buildAdditionalNo() => TextFormField(
        maxLines: 1,
        initialValue: additionalNo,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'الرقم الإضافي للعنوان',
        ),
        onChanged: onChangedAdditionalNo,
      );

  Widget buildVatNumber() => TextFormField(
        maxLines: 1,
        initialValue: vatNumber,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'الرقم االضريبي/المميز *',
        ),
        validator: (vatNumber) => vatNumber != null && vatNumber.isEmpty
            ? 'يجب أدخال الرقم الضريبي'
            : vatNumber!.length != 15
                ? 'يجب أدخال 15 رقم تنتهي ب00003'
                : null,
        onChanged: onChangedVatNumber,
      );

  static Future<String> getLogoFile() async {
    final byteData = await rootBundle.load('assets/images/logo.png');

    final file = File('${(await getTemporaryDirectory()).path}/logo.png');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    final byte = file.readAsBytesSync();
    var base64 = base64Encode(byte);

    return base64;
  }

  Widget buildLogo() => logo != ''
      ? Image.memory(
          base64Decode(logo!),
          height: logoHeight!.toDouble(),
          width: logoWidth!.toDouble(),
          fit: BoxFit.fill,
        )
      : Image(
          image: const AssetImage('assets/images/logo.png'),
          height: logoHeight!.toDouble(),
          width: logoWidth!.toDouble(),
          fit: BoxFit.fill,
        );

  Widget buildTextLogo() => TextFormField(
        initialValue: logo,
        onChanged: onChangedLogo,
      );

  Widget buildLogoWidth() => TextFormField(
        maxLines: 1,
        initialValue: logoWidth.toString(),
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'عرض الشعار',
        ),
        onChanged: onChangedLogoWidth,
      );

  Widget buildLogoHeight() => TextFormField(
        maxLines: 1,
        initialValue: logoHeight.toString(),
        keyboardType: TextInputType.number,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'ارتفاع الشعار',
        ),
        onChanged: onChangedLogoHeight,
      );

  Widget buildSheetId() => TextFormField(
        minLines: 1,
        maxLines: 2,
        initialValue: sheetId,
        keyboardType: TextInputType.text,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        decoration: const InputDecoration(
          labelText: 'معرف ملف قاعدة البيانات',
        ),
        // validator: (sheetId) => sheetId != null && sheetId.isEmpty
        //     ? 'يجب أدخال معرف ملف قاعدة البيانات'
        //     : null,
        onChanged: onChangedSheetId,
      );

  Widget buildWorkOffline() => Switch(
        value: workOffline == 1 ? true : false,
        onChanged: onChangedWorkOffline,
      );
}
