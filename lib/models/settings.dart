const String tableSettings = 'settings';

class SettingFields {
  // static const String vatNumber = 'vatNumber';
  static const String id = '_id';
  static const String name = 'name';
  static const String email = 'email';
  static const String password = 'password';
  static const String cellphone = 'cellphone';
  static const String seller = 'seller';
  static const String sheetId = 'sheetId';
  static const String workOffline = 'workOffline';
  static const String activationCode = 'activationCode';
  static const String startDateTime = 'startDateTime';
  static const String buildingNo = 'buildingNo';
  static const String streetName = 'streetName';
  static const String district = 'district';
  static const String city = 'city';
  static const String country = 'country';
  static const String postalCode = 'postalCode';
  static const String additionalNo = 'additionalNo';
  static const String vatNumber = 'vatNumber';
  static const String logo = 'logo';
  static const String terms = 'terms';
  static const String logoWidth = 'logoWidth';
  static const String logoHeight = 'logoHeight';

  static final List<String> values = [
    id,
    name,
    email,
    password,
    cellphone,
    seller,
    sheetId,
    workOffline,
    activationCode,
    startDateTime,
    buildingNo,
    streetName,
    district,
    city,
    country,
    postalCode,
    additionalNo,
    vatNumber,
    logo,
    terms,
    logoWidth,
    logoHeight
  ];
}

class Setting {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String cellphone;
  final String seller;
  final String sheetId;
  final int workOffline;
  final String activationCode;
  final String startDateTime;
  final String buildingNo;
  final String streetName;
  final String district;
  final String city;
  final String country;
  final String postalCode;
  final String additionalNo;
  final String vatNumber;
  final String logo;
  final String terms;
  final int logoWidth;
  final int logoHeight;

  const Setting({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.cellphone,
    required this.seller,
    this.sheetId = '',
    this.workOffline = 0,
    required this.activationCode,
    required this.startDateTime,
    this.buildingNo = '',
    this.streetName = '',
    this.district = '',
    this.city = 'الرياض',
    this.country = 'السعودية',
    this.postalCode = '',
    this.additionalNo = '',
    this.vatNumber = '',
    this.logo = '',
    this.terms = '',
    this.logoWidth = 75,
    this.logoHeight = 75,
  });

  Setting copy({
    int? id,
    String? name,
    String? email,
    String? password,
    String? cellphone,
    String? seller,
    String? sheetId,
    int? workOffline,
    String? activationCode,
    String? startDateTime,
    String? buildingNo,
    String? streetName,
    String? district,
    String? city,
    String? country,
    String? postalCode,
    String? additionalNo,
    String? vatNumber,
    String? logo,
    String? terms,
    int? logoWidth,
    int? logoHeight,
  }) =>
      Setting(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        cellphone: cellphone ?? this.cellphone,
        seller: seller ?? this.seller,
        sheetId: sheetId ?? this.sheetId,
        workOffline: workOffline ?? this.workOffline,
        activationCode: activationCode ?? this.activationCode,
        startDateTime: startDateTime ?? this.startDateTime,
        buildingNo: buildingNo ?? this.buildingNo,
        streetName: streetName ?? this.streetName,
        district: district ?? this.district,
        city: city ?? this.city,
        country: country ?? this.country,
        postalCode: postalCode ?? this.postalCode,
        additionalNo: additionalNo ?? this.additionalNo,
        vatNumber: vatNumber ?? this.vatNumber,
        logo: logo ?? this.logo,
        terms: terms ?? this.terms,
        logoWidth: logoWidth ?? this.logoWidth,
        logoHeight: logoHeight ?? this.logoHeight,
      );

  factory Setting.fromJson(dynamic json) {
    return Setting(
      id: json[SettingFields.id] as int,
      name: json[SettingFields.name] as String,
      email: json[SettingFields.email] as String,
      password: json[SettingFields.password] as String,
      cellphone: json[SettingFields.cellphone] as String,
      seller: json[SettingFields.seller] as String,
      sheetId: json[SettingFields.sheetId] as String,
      workOffline: json[SettingFields.workOffline] as int,
      activationCode: json[SettingFields.activationCode] as String,
      startDateTime: json[SettingFields.startDateTime] as String,
      buildingNo: json[SettingFields.buildingNo] as String,
      streetName: json[SettingFields.streetName] as String,
      district: json[SettingFields.district] as String,
      city: json[SettingFields.city] as String,
      country: json[SettingFields.country] as String,
      postalCode: json[SettingFields.postalCode] as String,
      additionalNo: json[SettingFields.additionalNo] as String,
      vatNumber: json[SettingFields.vatNumber] as String,
      logo: json[SettingFields.logo] as String,
      terms: json[SettingFields.terms] as String,
      logoWidth: json[SettingFields.logoWidth] as int,
      logoHeight: json[SettingFields.logoHeight] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        SettingFields.id: id,
        SettingFields.name: name,
        SettingFields.email: email,
        SettingFields.password: password,
        SettingFields.cellphone: cellphone,
        SettingFields.seller: seller,
        SettingFields.sheetId: sheetId,
        SettingFields.workOffline: workOffline,
        SettingFields.activationCode: activationCode,
        SettingFields.startDateTime: startDateTime,
        SettingFields.buildingNo: buildingNo,
        SettingFields.streetName: streetName,
        SettingFields.district: district,
        SettingFields.city: city,
        SettingFields.country: country,
        SettingFields.postalCode: postalCode,
        SettingFields.additionalNo: additionalNo,
        SettingFields.vatNumber: vatNumber,
        SettingFields.logo: logo,
        SettingFields.terms: terms,
        SettingFields.logoWidth: logoWidth,
        SettingFields.logoHeight: logoHeight,
      };
}
