import 'dart:convert';

class ClientFields {
  static const String id = 'id';
  static const String name = 'name';
  static const String email = 'email';
  static const String password = 'password';
  static const String cellphone = 'cellphone';
  static const String seller = 'seller';
  static const String buildingNo = 'buildingNo';
  static const String streetName = 'streetName';
  static const String district = 'district';
  static const String city = 'city';
  static const String country = 'country';
  static const String postalCode = 'postalCode';
  static const String additionalNo = 'additionalNo';
  static const String vatNumber = 'vatNumber';
  static const String sheetId = 'sheetId';
  static const String workOffline = 'workOffline';
  static const String activationCode = 'activationCode';
  static const String startDateTime = 'startDateTime';
  static const String paidAmount = 'paidAmount';

  static List<String> getClientFields() => [
        id,
        name,
        email,
        password,
        cellphone,
        seller,
        buildingNo,
        streetName,
        district,
        city,
        country,
        postalCode,
        additionalNo,
        vatNumber,
        sheetId,
        workOffline,
        activationCode,
        startDateTime,
        paidAmount,
      ];
}

class Client {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String cellphone;
  final String seller;
  final String buildingNo;
  final String streetName;
  final String district;
  final String city;
  final String country;
  final String postalCode;
  final String additionalNo;
  final String vatNumber;
  final String sheetId;
  final int workOffline;
  final String activationCode;
  final String startDateTime;
  final int paidAmount;

  const Client({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.cellphone,
    required this.seller,
    this.buildingNo = '',
    this.streetName = '',
    this.district = '',
    this.city = 'الرياض',
    this.country = 'السعودية',
    this.postalCode = '',
    this.additionalNo = '',
    this.vatNumber = '',
    required this.sheetId,
    this.workOffline = 0,
    required this.activationCode,
    required this.startDateTime,
    this.paidAmount = 0,
  });

  Client copy({
    int? id,
    String? name,
    String? email,
    String? password,
    String? cellphone,
    String? seller,
    String? buildingNo,
    String? streetName,
    String? district,
    String? city,
    String? country,
    String? postalCode,
    String? additionalNo,
    String? vatNumber,
    String? sheetId,
    int? workOffline,
    String? activationCode,
    String? startDateTime,
    int? paidAmount,
  }) =>
      Client(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        password: password ?? this.password,
        cellphone: cellphone ?? this.cellphone,
        seller: seller ?? this.seller,
        buildingNo: buildingNo ?? this.buildingNo,
        streetName: streetName ?? this.streetName,
        district: district ?? this.district,
        city: city ?? this.city,
        country: country ?? this.country,
        postalCode: postalCode ?? this.postalCode,
        additionalNo: additionalNo ?? this.additionalNo,
        vatNumber: vatNumber ?? this.vatNumber,
        sheetId: sheetId ?? this.sheetId,
        workOffline: workOffline ?? this.workOffline,
        activationCode: activationCode ?? this.activationCode,
        startDateTime: startDateTime ?? this.startDateTime,
        paidAmount: paidAmount ?? this.paidAmount,
      );

  factory Client.fromJson(dynamic json) {
    return Client(
      id: jsonDecode(json[ClientFields.id]),
      name: json[ClientFields.name],
      email: json[ClientFields.email],
      password: json[ClientFields.password],
      cellphone: json[ClientFields.cellphone],
      seller: json[ClientFields.seller],
      buildingNo: json[ClientFields.buildingNo],
      streetName: json[ClientFields.streetName],
      district: json[ClientFields.district],
      city: json[ClientFields.city],
      country: json[ClientFields.country],
      postalCode: json[ClientFields.postalCode],
      additionalNo: json[ClientFields.additionalNo],
      vatNumber: json[ClientFields.vatNumber],
      sheetId: json[ClientFields.sheetId],
      workOffline: jsonDecode(json[ClientFields.workOffline]),
      activationCode: json[ClientFields.activationCode],
      startDateTime: json[ClientFields.startDateTime],
      paidAmount: jsonDecode(json[ClientFields.paidAmount]),
    );
  }

  Map<String, dynamic> toJson() => {
        ClientFields.id: id,
        ClientFields.name: name,
        ClientFields.email: email,
        ClientFields.password: password,
        ClientFields.cellphone: cellphone,
        ClientFields.seller: seller,
        ClientFields.buildingNo: buildingNo,
        ClientFields.streetName: streetName,
        ClientFields.district: district,
        ClientFields.city: city,
        ClientFields.country: country,
        ClientFields.postalCode: postalCode,
        ClientFields.additionalNo: additionalNo,
        ClientFields.vatNumber: vatNumber,
        ClientFields.sheetId: sheetId,
        ClientFields.workOffline: workOffline,
        ClientFields.activationCode: activationCode,
        ClientFields.startDateTime: startDateTime,
        ClientFields.paidAmount: paidAmount,
      };
}
