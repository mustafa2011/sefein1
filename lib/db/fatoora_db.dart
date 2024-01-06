import 'dart:io';

import '/models/customers.dart';
import '/models/groups.dart';
import '/models/invoice.dart';
import '/models/product.dart';
import '/models/purchase.dart';
import '/models/vouchers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '/models/settings_ext.dart';
import '/models/settings.dart';

// final year = DateTime.now().year;
// final lastFebDay = year % 4 == 0 ? 29 : 28;
final currentYear = DateTime.now().year;
final lastFebDay = currentYear % 4 == 0 ? 29 : 28;

class FatooraDB {
  static final FatooraDB instance = FatooraDB.init();

  static Database? _database;

  FatooraDB.init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb('fatoora.db');
    return _database!;
  }

  Future<Database> initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    // final path = join(dbPath, filePath);
    Directory? appDirectory;

    if (Platform.isAndroid) {
      appDirectory = await getExternalStorageDirectory();
    } else {
      appDirectory = await getApplicationDocumentsDirectory();
    }
    String dbFilePath = '${appDirectory!.path}/Fatoora/Database/$filePath';
    String oldDbFilePath = '${appDirectory.path}/Fatoora/OldDatabase/$filePath';

    final oldDbpath = '$dbPath/$filePath';
    bool isOldDbExist = await File(oldDbpath).exists();
    bool isOldDbExistInFolder = await File(oldDbFilePath).exists();

    if (isOldDbExist && !isOldDbExistInFolder) {
      await File(oldDbpath).copy(oldDbFilePath);
    }

    return await openDatabase(dbFilePath,
        version: 1, onCreate: _createDB, onUpgrade: _updateDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const intType = 'INTEGER';
    const textNotNull = 'TEXT NOT NULL';
    const text = 'TEXT';
    const boolType = 'INTEGER NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const numType = 'NUMERIC NOT NULL';

    // Create settings table
    await db.execute('''
CREATE TABLE $tableSettings ( 
  ${SettingFields.id} $idType, 
  ${SettingFields.name} $textNotNull,
  ${SettingFields.email} $textNotNull,
  ${SettingFields.password} $textNotNull,
  ${SettingFields.cellphone} $textNotNull,
  ${SettingFields.seller} $textNotNull,
  ${SettingFields.buildingNo} $text,
  ${SettingFields.streetName} $text,
  ${SettingFields.district} $text,
  ${SettingFields.city} $text,
  ${SettingFields.country} $text,
  ${SettingFields.postalCode} $text,
  ${SettingFields.additionalNo} $text,
  ${SettingFields.vatNumber} $textNotNull,
  ${SettingFields.sheetId} $textNotNull,
  ${SettingFields.workOffline} $boolType,
  ${SettingFields.activationCode} $text,
  ${SettingFields.startDateTime} $textNotNull,
  ${SettingFields.logo} $text,
  ${SettingFields.terms} $text,
  ${SettingFields.logoWidth} $intType,
  ${SettingFields.logoHeight} $intType
  )
''');

    // Create settings_ext table
    await db.execute('''
CREATE TABLE $tableSettingsExt ( 
  ${SettingExtFields.id} $idType, 
  ${SettingExtFields.terms1} $text,
  ${SettingExtFields.terms2} $text,
  ${SettingExtFields.terms3} $text,
  ${SettingExtFields.terms4} $text,
  ${SettingExtFields.terms5} $text
  )
''');

    // Create groups table
    await db.execute('''
CREATE TABLE $tableGroups ( 
  ${GroupFields.id} $idType, 
  ${GroupFields.type} $textNotNull,
  ${GroupFields.name} $textNotNull
  )
''');
    // Create vouchers table
    await db.execute('''
CREATE TABLE $tableVouchers ( 
  ${VoucherFields.id} $idType, 
  ${VoucherFields.date} $textNotNull,
  ${VoucherFields.type} $textNotNull,
  ${VoucherFields.name} $textNotNull,
  ${VoucherFields.desc} $text,
  ${VoucherFields.voucherTo} $textNotNull,
  ${VoucherFields.amount} $numType
  )
''');

    // Create products table
    await db.execute('''
CREATE TABLE $tableProducts ( 
  ${ProductFields.id} $idType, 
  ${ProductFields.productName} $textNotNull,
  ${ProductFields.price} $numType
  )
''');

    // Create customers table
    await db.execute('''
CREATE TABLE $tableCustomers ( 
  ${CustomerFields.id} $idType, 
  ${CustomerFields.name} $textNotNull,
  ${CustomerFields.buildingNo} $text,
  ${CustomerFields.streetName} $text,
  ${CustomerFields.district} $text,
  ${CustomerFields.city} $text,
  ${CustomerFields.country} $text,
  ${CustomerFields.postalCode} $text,
  ${CustomerFields.additionalNo} $text,
  ${CustomerFields.vatNumber} $textNotNull,
  ${CustomerFields.contactNumber} $text
  )
''');

    // Create invoices table
    await db.execute('''
CREATE TABLE $tableInvoices ( 
  ${InvoiceFields.id} $idType, 
  ${InvoiceFields.invoiceNo} $textNotNull, 
  ${InvoiceFields.date} $textNotNull,
  ${InvoiceFields.supplyDate} $text,
  ${InvoiceFields.sellerId} $intType,
  ${InvoiceFields.total} $numType,
  ${InvoiceFields.totalVat} $numType,
  ${InvoiceFields.posted} $boolType,
  ${InvoiceFields.payerId} $intType,
  ${InvoiceFields.noOfLines} $integerType,
  ${InvoiceFields.project} $text,
  ${InvoiceFields.paymentMethod} $text
  )
''');

    // Create purchases table
    await db.execute('''
CREATE TABLE $tablePurchases ( 
  ${PurchaseFields.id} $idType, 
  ${PurchaseFields.date} $textNotNull,
  ${PurchaseFields.vendor} $textNotNull,
  ${PurchaseFields.vendorInvoiceNo} $text,
  ${PurchaseFields.vendorVatNumber} $textNotNull,
  ${PurchaseFields.total} $numType,
  ${PurchaseFields.totalVat} $numType
  )
''');

    // Create invoiceLines table
    await db.execute('''
CREATE TABLE $tableInvoiceLines ( 
  ${InvoiceLinesFields.id} $idType, 
  ${InvoiceLinesFields.recId} $integerType, 
  ${InvoiceLinesFields.productName} $textNotNull,
  ${InvoiceLinesFields.price} $numType,
  ${InvoiceLinesFields.qty} $integerType
  )
''');

    _versionUpdate2(db);
  }

  Future _updateDB(Database db, int oldVersion, int newVersion) async {
    // if (oldVersion < 2) {
    //   _versionUpdate2(db);
    // }
    // if (oldVersion < 3) {
    //   _versionUpdate3(db);
    // }
    // if (oldVersion < 4) {
    //   _versionUpdate4(db);
    // }
  }

  static Future<void> _versionUpdate2(Database db) async {
    // Add new column to purchases table
    await db.execute("ALTER TABLE purchases ADD COLUMN vendorInvoiceNo TEXT");
    await db.rawUpdate("UPDATE purchases SET vendorInvoiceNo = ''");
  }

  Future<int> getDbVersion() async {
    const filePath = 'fatoora.db';
    // final dbPath = await getDatabasesPath();
    // final path = join(dbPath, 'fatoora.db');
    Directory? appDirectory;

    if (Platform.isAndroid) {
      appDirectory = await getExternalStorageDirectory();
    } else {
      appDirectory = await getApplicationDocumentsDirectory();
    }
    String dbFilePath = '${appDirectory!.path}/Fatoora/Database/$filePath';
    Database db = await openDatabase(dbFilePath);
    return db.getVersion();
  }

  /// Table settings CRUD operations
  Future<Setting> createSetting(Setting setting) async {
    final db = await instance.database;
    final id = await db.insert(tableSettings, setting.toJson());

    if (id > 0) {
      return setting.copy(id: id);
    } else {
      throw Exception('Record NOT created');
    }
  }

  Future<SettingExt> createSettingExt(SettingExt setting) async {
    final db = await instance.database;
    final id = await db.insert(tableSettingsExt, setting.toJson());

    if (id > 0) {
      return setting.copy(id: id);
    } else {
      throw Exception('Record NOT created');
    }
  }

  Future<Setting> getSettingById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableSettings,
      columns: SettingFields.values,
      where: '${SettingFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Setting.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found in the local database');
    }
  }

  Future<List<Setting>> getAllSettings() async {
    final db = await instance.database;

    const orderBy = '${SettingFields.id} ASC';
    final result = await db.query(tableSettings, orderBy: orderBy);

    return result.map((json) => Setting.fromJson(json)).toList();
  }

  Future<List<SettingExt>> getAllSettingsExt() async {
    final db = await instance.database;

    const orderBy = '${SettingFields.id} ASC';
    final result = await db.query(tableSettingsExt, orderBy: orderBy);

    return result.map((json) => SettingExt.fromJson(json)).toList();
  }

  Future<Setting> getSellerById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableSettings,
      columns: SettingFields.values,
      where: '${SettingFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Setting.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found in the local database');
    }
  }

  Future<SettingExt> getSellerExtById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableSettingsExt,
      columns: SettingExtFields.values,
      where: '${SettingExtFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return SettingExt.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found in the local database');
    }
  }

  Future<int> updateSetting(Setting setting) async {
    final db = await instance.database;

    return db.update(
      tableSettings,
      setting.toJson(),
      where: '${SettingFields.id} = ?',
      whereArgs: [setting.id],
    );
  }

  Future<int> updateSettingExt(SettingExt setting) async {
    final db = await instance.database;

    return db.update(
      tableSettingsExt,
      setting.toJson(),
      where: '${SettingExtFields.id} = ?',
      whereArgs: [setting.id],
    );
  }

  Future<int> deleteSetting(Setting setting) async {
    final db = await instance.database;

    return await db.delete(
      tableSettings,
      where: '${SettingFields.id} = ?',
      whereArgs: [setting.id],
    );
  }

  /// End table settings CRUD operations

  /// Table products CRUD operations
  Future<Product> createProduct(Product product) async {
    final db = await instance.database;
    final id = await db.insert(tableProducts, product.toJson());

    if (id > 0) {
      return product.copy(id: id);
    } else {
      throw Exception('Record NOT created');
    }
  }

  Future<int?> getProductsCount() async {
    //database connection
    Database db = await database;
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableProducts'));
    return count;
  }

  Future<Product> getProductById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableProducts,
      columns: ProductFields.getProductsFields(),
      where: '${ProductFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Product.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found in the local database');
    }
  }

  Future<List<Product>> getAllProducts() async {
    final db = await instance.database;

    const orderBy = '${ProductFields.id} ASC';
    final result = await db.query(tableProducts, orderBy: orderBy);

    return result.map((json) => Product.fromJson(json)).toList();
  }

  Future<int> updateProduct(Product product) async {
    final db = await instance.database;

    return db.update(
      tableProducts,
      product.toJson(),
      where: '${ProductFields.id} = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(Product product) async {
    final db = await instance.database;

    return await db.delete(
      tableProducts,
      where: '${ProductFields.id} = ?',
      whereArgs: [product.id],
    );
  }

  Future<int?> deleteProductSequence() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db
        .rawQuery("DELETE FROM sqlite_sequence where name= 'products'"));
    return count;
  }

  /// End table products CRUD operations

  /// Table customers CRUD operations
  Future<Customer> createCustomer(Customer customer) async {
    final db = await instance.database;
    final id = await db.insert(tableCustomers, customer.toJson());

    if (id > 0) {
      return customer.copy(id: id);
    } else {
      throw Exception('Record NOT created');
    }
  }

  Future<int?> getCustomerCount() async {
    //database connection
    Database db = await database;
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableCustomers'));
    return count;
  }

  Future<bool?> isFirstCustomerExist() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT * FROM $tableCustomers WHERE id=1'));

    return count != null ? true : false;
  }

  Future<Customer> getCustomerById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableCustomers,
      columns: CustomerFields.getCustomerFields(),
      where: '${CustomerFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Customer.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found in the local database');
    }
  }

  Future<String> getCustomerNameById(int id) async {
    Customer customer = await getCustomerById(id);
    return customer.name;
  }

  Future<String> getCustomerVatNumberById(int id) async {
    Customer customer = await getCustomerById(id);
    return customer.vatNumber;
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await instance.database;

    const orderBy = '${CustomerFields.id} ASC';
    final result = await db.query(tableCustomers, orderBy: orderBy);

    return result.map((json) => Customer.fromJson(json)).toList();
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await instance.database;

    return db.update(
      tableCustomers,
      customer.toJson(),
      where: '${CustomerFields.id} = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int> deleteCustomer(Customer customer) async {
    final db = await instance.database;

    return await db.delete(
      tableCustomers,
      where: '${CustomerFields.id} = ?',
      whereArgs: [customer.id],
    );
  }

  Future<int?> deleteCustomerSequence() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db
        .rawQuery("DELETE FROM sqlite_sequence where name= 'customers'"));
    return count;
  }

  /// End table customers CRUD operations

  /// Table Invoices CRUD operations
  Future<Invoice> createInvoice(Invoice invoice) async {
    final db = await instance.database;
    final id = await db.insert(tableInvoices, invoice.toJson());

    if (id > 0) {
      return invoice.copy(id: id);
    } else {
      throw Exception('Record NOT created');
    }
  }

  Future<Voucher> createVoucher(Voucher voucher) async {
    final db = await instance.database;
    final id = await db.insert(tableVouchers, voucher.toJson());

    if (id > 0) {
      return voucher.copy(id: id);
    } else {
      throw Exception('Record NOT created');
    }
  }

  Future<Group> createGroup(Group group) async {
    final db = await instance.database;
    final id = await db.insert(tableGroups, group.toJson());

    if (id > 0) {
      return group.copy(id: id);
    } else {
      throw Exception('Record NOT created');
    }
  }

  Future<int?> getInvoicesCount(int year) async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $tableInvoices "
        "WHERE ${InvoiceFields.date} >= '$year-01-01' AND ${InvoiceFields.date} <= '$year-12-31 23:59'"));
    return count;
  }

  Future<int?> getNewInvoiceId() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT seq FROM sqlite_sequence where name= '$tableInvoices'"));
    return count ?? 0;
  }

  Future<int?> getNewVoucherId() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT seq FROM sqlite_sequence where name= '$tableVouchers'"));
    return count ?? 0;
  }

  Future<int?> getNewGroupId() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT seq FROM sqlite_sequence where name= '$tableGroups'"));
    return count ?? 0;
  }

  Future<int?> deleteAllInvoices() async {
    Database db = await database;
    int? count =
        Sqflite.firstIntValue(await db.rawQuery('DELETE FROM $tableInvoices'));
    return count;
  }

  Future<int?> deleteAllInvoiceLines() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(
        await db.rawQuery('DELETE FROM $tableInvoiceLines'));
    return count;
  }

  Future<int?> deleteInvoiceSequence() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db
        .rawQuery("DELETE FROM sqlite_sequence where name= 'invoices'"));
    return count;
  }

  Future<int?> deleteInvoiceLinesSequence() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db
        .rawQuery("DELETE FROM sqlite_sequence where name= 'invoice_lines'"));
    return count;
  }

  Future<num?> getInvoicesTotal() async {
    Database db = await database;
    var sum = (await db.rawQuery(
        'SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices'));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-01-01' AND ${InvoiceFields.date} <= '$year-12-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getJanTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-01-01' AND ${InvoiceFields.date} <= '$year-01-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getFebTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-02-01' AND ${InvoiceFields.date} <= '$year-02-$lastFebDay 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getMarTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-03-01' AND ${InvoiceFields.date} <= '$year-03-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getAprTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-04-01' AND ${InvoiceFields.date} <= '$year-04-30 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getMayTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-05-01' AND ${InvoiceFields.date} <= '$year-05-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getJunTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-06-01' AND ${InvoiceFields.date} <= '$year-06-30 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getJulTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-07-01' AND ${InvoiceFields.date} <= '$year-07-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getAugTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-08-01' AND ${InvoiceFields.date} <= '$year-08-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getSepTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-09-01' AND ${InvoiceFields.date} <= '$year-09-30 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getOctTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-10-01' AND ${InvoiceFields.date} <= '$year-10-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getNovTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-11-01' AND ${InvoiceFields.date} <= '$year-11-30 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getDecTotalSales(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices  "
        "WHERE ${InvoiceFields.date} >= '$year-12-01' AND ${InvoiceFields.date} <= '$year-12-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getTotalCreditNotes() async {
    Database db = await database;
    var sum = (await db.rawQuery(
        'SELECT SUM(${InvoiceFields.total}) AS ttl FROM $tableInvoices WHERE ${InvoiceFields.total} < 0'));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<Invoice> getInvoiceById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableInvoices,
      columns: InvoiceFields.getInvoiceFields(),
      where: '${InvoiceFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Invoice.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found in the local database');
    }
  }

  Future<Voucher> getVoucherById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableVouchers,
      columns: VoucherFields.getVoucherFields(),
      where: '${VoucherFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Voucher.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found in the local database');
    }
  }

  Future<List<Invoice>> getAllInvoices() async {
    final db = await instance.database;

    const orderBy = '${InvoiceFields.id} DESC';
    final result = await db.query(tableInvoices, orderBy: orderBy);

    return result.map((json) => Invoice.fromJson(json)).toList();
  }

  Future<List<Voucher>> getAllVouchers(String type) async {
    final db = await instance.database;

    final result = await db.rawQuery("SELECT * FROM $tableVouchers "
        "WHERE ${VoucherFields.type} = '$type' ORDER BY ${VoucherFields.date}");

    return result.map((json) => Voucher.fromJson(json)).toList();
  }

  Future<List<Group>> getAllGroups(String type) async {
    final db = await instance.database;

    final result = await db.rawQuery("SELECT * FROM $tableGroups "
        "WHERE ${GroupFields.type} = '$type' ORDER BY ${GroupFields.name}");

    return result.map((json) => Group.fromJson(json)).toList();
  }

  Future<int?> deleteAllGroups(String type) async {
    final db = await instance.database;
    int? count =
        Sqflite.firstIntValue(await db.rawQuery("DELETE FROM $tableGroups "
            "WHERE ${GroupFields.type} = '$type'"));
    return count;
  }

  Future<List<Invoice1>> getAllInvoicesBetweenTwoDates(
      String dateFrom, String dateTo) async {
    final db = await instance.database;

    final result = await db.rawQuery(
        "SELECT invoices.*, customers.name FROM $tableInvoices "
        "INNER JOIN customers ON customers.id = invoices.payerId "
        "WHERE ${InvoiceFields.date} >= '$dateFrom' AND ${InvoiceFields.date} <= '$dateTo 23:59' "
        "ORDER BY date");
    return result.map((json) => Invoice1.fromJson(json)).toList();
  }

  Future<List<Purchase>> getAllPurchasesBetweenTwoDates(
      String dateFrom, String dateTo) async {
    final db = await instance.database;

    final result = await db.rawQuery("SELECT * FROM $tablePurchases "
        "WHERE ${PurchaseFields.date} >= '$dateFrom' AND ${PurchaseFields.date} <= '$dateTo 23:59' "
        "ORDER BY date");
    return result.map((json) => Purchase.fromJson(json)).toList();
  }

  Future<int> updateInvoice(Invoice invoice) async {
    final db = await instance.database;

    return db.update(
      tableInvoices,
      invoice.toJson(),
      where: '${InvoiceFields.id} = ?',
      whereArgs: [invoice.id],
    );
  }

  Future<int> updateVoucher(Voucher voucher) async {
    final db = await instance.database;

    return db.update(
      tableVouchers,
      voucher.toJson(),
      where: '${VoucherFields.id} = ?',
      whereArgs: [voucher.id],
    );
  }

  Future<int> deleteInvoice(Invoice invoice) async {
    final db = await instance.database;

    deleteInvoiceLines(invoice.id!);

    return await db.delete(
      tableInvoices,
      where: '${InvoiceFields.id} = ?',
      whereArgs: [invoice.id],
    );
  }

  Future<int> deleteVoucher(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableVouchers,
      where: '${VoucherFields.id} = ?',
      whereArgs: [id],
    );
  }

  /// End table invoices CRUD operations

  /// Table Purchases CRUD operations
  Future<Purchase> createPurchase(Purchase purchase) async {
    final db = await instance.database;
    final id = await db.insert(tablePurchases, purchase.toJson());

    if (id > 0) {
      return purchase.copy(id: id);
    } else {
      throw Exception('Record NOT created');
    }
  }

  Future<int?> getPurchasesCount(int year) async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM $tablePurchases "
        "WHERE ${InvoiceFields.date} >= '$year-01-01' AND ${InvoiceFields.date} <= '$year-12-31 23:59'"));
    return count;
  }

  Future<int?> getNewPurchaseId() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db
        .rawQuery('SELECT id FROM $tablePurchases ORDER BY id DESC limit 1'));
    return count ?? 0;
  }

  Future<int?> deleteAllPurchases() async {
    Database db = await database;
    int? count =
        Sqflite.firstIntValue(await db.rawQuery('DELETE FROM $tablePurchases'));
    return count;
  }

  Future<int?> deletePurchaseSequence() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db
        .rawQuery("DELETE FROM sqlite_sequence where name= 'purchases'"));
    return count;
  }

  Future<num?> getTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases  "
        "WHERE ${PurchaseFields.date} >= '$year-01-01' AND ${PurchaseFields.date} <= '$year-12-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getJanTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases "
        "WHERE ${PurchaseFields.date} >= '$year-01-01' AND ${PurchaseFields.date} <= '$year-01-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getFebTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases  "
        "WHERE ${PurchaseFields.date} >= '$year-02-01' AND ${PurchaseFields.date} <= '$year-02-$lastFebDay 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getMarTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases  "
        "WHERE ${PurchaseFields.date} >= '$year-03-01' AND ${PurchaseFields.date} <= '$year-03-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getAprTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases  "
        "WHERE ${PurchaseFields.date} >= '$year-04-01' AND ${PurchaseFields.date} <= '$year-04-30 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getMayTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases  "
        "WHERE ${PurchaseFields.date} >= '$year-05-01' AND ${PurchaseFields.date} <= '$year-05-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getJunTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases  "
        "WHERE ${PurchaseFields.date} >= '$year-06-01' AND ${PurchaseFields.date} <= '$year-06-30 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getJulTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases  "
        "WHERE ${PurchaseFields.date} >= '$year-07-01' AND ${PurchaseFields.date} <= '$year-07-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getAugTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases  "
        "WHERE ${PurchaseFields.date} >= '$year-08-01' AND ${PurchaseFields.date} <= '$year-08-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getSepTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases  "
        "WHERE ${PurchaseFields.date} >= '$year-09-01' AND ${PurchaseFields.date} <= '$year-09-30 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getOctTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases  "
        "WHERE ${PurchaseFields.date} >= '$year-10-01' AND ${PurchaseFields.date} <= '$year-10-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getNovTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases  "
        "WHERE ${PurchaseFields.date} >= '$year-11-01' AND ${PurchaseFields.date} <= '$year-11-30 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<num?> getDecTotalPurchases(int year) async {
    Database db = await database;
    var sum = (await db.rawQuery(
        "SELECT SUM(${PurchaseFields.total}) AS ttl FROM $tablePurchases  "
        "WHERE ${PurchaseFields.date} >= '$year-12-01' AND ${PurchaseFields.date} <= '$year-12-31 23:59'"));
    return sum[0]['ttl'] == null ? 0 : num.parse('${sum[0]['ttl']}');
  }

  Future<Purchase> getPurchaseById(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tablePurchases,
      columns: PurchaseFields.getPurchaseFields(),
      where: '${PurchaseFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Purchase.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found in the local database');
    }
  }

  Future<List<Purchase>> getAllPurchases() async {
    final db = await instance.database;

    const orderBy = '${PurchaseFields.id} DESC';
    final result = await db.query(tablePurchases, orderBy: orderBy);

    return result.map((json) => Purchase.fromJson(json)).toList();
  }

  Future<int> updatePurchase(Purchase invoice) async {
    final db = await instance.database;

    return db.update(
      tablePurchases,
      invoice.toJson(),
      where: '${PurchaseFields.id} = ?',
      whereArgs: [invoice.id],
    );
  }

  Future<int> deletePurchaseById(int id) async {
    final db = await instance.database;

    return await db.delete(
      tablePurchases,
      where: '${PurchaseFields.id} = ?',
      whereArgs: [id],
    );
  }

  /// End table invoices CRUD operations

  /// Table InvoiceLines CRUD operations
  Future<InvoiceLines> createInvoiceLines(
      InvoiceLines invoiceLines, int recId) async {
    final db = await instance.database;
    final id = await db.insert(tableInvoiceLines, invoiceLines.toJson());

    if (id > 0) {
      return invoiceLines.copy(id: id, recId: recId);
    } else {
      throw Exception('Record NOT created');
    }
  }

  Future<List<InvoiceLines>> getInvoiceLinesById(int recId) async {
    final db = await instance.database;

    final maps = await db.query(
      tableInvoiceLines,
      columns: InvoiceLinesFields.getInvoiceLinesFields(),
      where: '${InvoiceLinesFields.recId} = ?',
      orderBy: InvoiceLinesFields.id,
      whereArgs: [recId],
    );

    if (maps.isNotEmpty) {
      return maps.map((json) => InvoiceLines.fromJson(json)).toList();
    } else {
      throw Exception('ID $recId not found in the local database');
    }
  }

  Future<List<InvoiceLines>> getAllInvoiceLines() async {
    final db = await instance.database;

    const orderBy = '${InvoiceLinesFields.recId}, ${InvoiceLinesFields.id} ASC';
    final result = await db.query(tableInvoiceLines, orderBy: orderBy);

    return result.map((json) => InvoiceLines.fromJson(json)).toList();
  }

  Future<int> updateInvoiceLines(InvoiceLines invoiceLines) async {
    final db = await instance.database;

    return db.update(
      tableInvoiceLines,
      invoiceLines.toJson(),
      where: '${InvoiceLinesFields.id} = ?',
      whereArgs: [invoiceLines.id],
    );
  }

  Future deleteInvoiceLines(int recId) async {
    final db = await instance.database;

    return await db
        .rawQuery('DELETE FROM $tableInvoiceLines WHERE recId=$recId');
  }

  /// End table invoiceLines CRUD operations

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
