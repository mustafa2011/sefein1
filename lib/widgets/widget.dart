import '/models/purchase.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import '../apis/constants/utils.dart';
import '../models/customers.dart';
import '../models/invoice.dart';
import '../models/product.dart';
import '../screens/customer_detail_page.dart';
import '../screens/home_page.dart';
import '../screens/invoice_detail_page.dart';
import '../screens/product_detail_page.dart';
import 'app_colors.dart';
import 'package:get/get.dart';

const width = 100.0;
const height = 54.0;
const buttonStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    fontFamily: "Arial");
const headerStyle =
    TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: "Cairo");
const rowStyle =
    TextStyle(fontSize: 12, fontWeight: FontWeight.normal, fontFamily: "Cairo");

class NewButton extends StatelessWidget {
  final double? fontSize;
  final IconData? icon;
  final Function()? onTap;
  final Function()? onTapCancel;
  final Function(TapDownDetails)? onTapDown;
  final Function(TapUpDetails)? onTapUp;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? textColor;
  final String? text;
  final double? size;
  final double? iconSize;
  final bool? textPositionDown;
  final double? radius;
  final double? padding;
  final double? space;
  final bool? tapped;

  const NewButton({
    super.key,
    this.backgroundColor = AppColor.primary,
    this.textColor = AppColor.primary,
    this.text,
    this.size = 40,
    this.iconSize = 0,
    this.fontSize = 12,
    this.icon,
    this.iconColor = AppColor.background,
    this.onTap,
    this.onTapCancel,
    this.onTapDown,
    this.onTapUp,
    this.textPositionDown = false,
    this.radius = 25.0,
    this.padding = 10.0,
    this.space = 0.0,
    this.tapped = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius!),
      child: Material(
        child: InkWell(
          highlightColor: AppColor.secondary,
          splashColor: AppColor.secondary,
          onTap: onTap,
          onTapCancel: onTapCancel,
          child: Ink(
            padding: EdgeInsets.all(padding!),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius!),
              color: backgroundColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      text ?? '',
                      style: TextStyle(
                          fontSize: fontSize,
                          color: iconColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: space ?? 0,
                    ),
                  ],
                ),
                Icon(
                  icon,
                  color: iconColor,
                  size: iconSize,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewTab extends StatelessWidget {
  final double? fontSize;
  final IconData? icon;
  final Function()? onTap;
  final Color? backgroundColor;
  final Color? textColor;
  final String? text;
  final double? radius;
  final double? padding;

  const NewTab({
    super.key,
    this.backgroundColor = AppColor.background,
    this.textColor = AppColor.primary,
    this.text,
    this.fontSize = 12,
    this.icon,
    this.onTap,
    this.radius = 10,
    this.padding = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                left: padding!,
                right: padding!,
                bottom: padding!,
                top: padding! * 1),
            margin: EdgeInsets.only(left: padding! * 0.3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius!),
              color: backgroundColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text ?? '',
                  style: TextStyle(
                      fontSize: fontSize,
                      color: textColor,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewForm extends StatelessWidget {
  final Widget child;
  final Widget? action;
  final Widget? tab;
  final String? title;
  final IconData? icon;
  final Function()? onIconTab;
  final bool? isLoading;

  const NewForm({
    super.key,
    required this.child,
    this.action,
    this.tab,
    this.title,
    this.icon,
    this.onIconTab,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(top: 30),
        color: AppColor.secondary,
        child: Stack(
          children: [
            titleBar(width),
            tabBar(width),
            bottomBar(width),
            body(width, height),
            Center(
              child: isLoading! ? const CircularProgressIndicator() : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget titleBar(double width) => Container(
        width: width,
        height: 150,
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 100),
        margin: const EdgeInsets.only(top: 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: AppColor.primary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? '',
              style: const TextStyle(
                  fontSize: 20,
                  color: AppColor.secondary,
                  fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: onIconTab,
              child: Icon(
                icon,
                color: AppColor.secondary,
                size: 40,
              ),
            ),
          ],
        ),
      );

  Widget bottomBar(double width) => Positioned(
      left: 0,
      bottom: 0,
      child: Container(
          width: width,
          height: 70,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: AppColor.background,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              actionBar(width),
              NewButton(
                icon: Icons.home,
                iconSize: 25,
                onTap: () => Get.to(() => const HomePage()),
              )
            ],
          )));

  Widget actionBar(double width) => SizedBox(
        width: width - 70,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            Row(
              children: [
                action ?? const Text(''),
              ],
            ),
          ],
        ),
      );

  Widget tabBar(double width) => Positioned(
        right: 10,
        top: 57,
        child: SizedBox(
          width: width - 20,
          height: 50,
          child: tab,
        ),
      );

  Widget body(double width, double height) => Positioned(
        top: 105,
        child: SingleChildScrollView(
          child: Container(
              width: width - 20,
              height: height - 225,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 10, top: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.background,
              ),
              child: child),
        ),
      );
}

class NewFrame extends StatelessWidget {
  const NewFrame({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        // color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: InputDecorator(
        decoration: InputDecoration(
          label: Text(title,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          border: OutlineInputBorder(
            gapPadding: 3.0,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: child,
      ),
    );
  }
}

class TableInvoice extends StatelessWidget {
  const TableInvoice({super.key, this.invoice});

  final List<Invoice>? invoice;

  @override
  Widget build(BuildContext context) {
    double leftHandSideColumnWidth = MediaQuery.of(context).size.width;
    double rightHandSideColumnWidth = 100.0;
    return HorizontalDataTable.rtl(
      leftHandSideColumnWidth: leftHandSideColumnWidth,
      rightHandSideColumnWidth: rightHandSideColumnWidth,
      isFixedHeader: true,
      headerWidgets: _getTitleWidget(leftHandSideColumnWidth),
      isFixedFooter: false,
      footerWidgets: _getTitleWidget(leftHandSideColumnWidth),
      leftSideItemBuilder: _generateLeftHandSideColumnRow,
      rightSideItemBuilder: _generateFirstColumnRow,
      itemCount: invoice!.length,
      rowSeparatorWidget: const Divider(
        color: Colors.black38,
        height: 1.0,
        thickness: 0.0,
      ),
      leftHandSideColBackgroundColor: Colors.white,
      rightHandSideColBackgroundColor: AppColor.background,
      // const Color(0xFFFFFFFF),
      itemExtent: 55,
    );
  }

  List<Widget> _getTitleWidget(double leftHandSideColumnWidth) {
    return [
      _getTitleItemWidget('رقم الفاتورة', width),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getTitleItemWidget('التاريخ', width),
          _getTitleItemWidget('الوقت', width),
          _getTitleItemWidget('الصافي', width),
          _getTitleItemWidget('الضريبة', leftHandSideColumnWidth),
        ],
      ),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: height,
      color: AppColor.background,
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      alignment: Alignment.centerRight,
      child: Text(
        label,
        style: headerStyle,
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(invoice![index].invoiceNo, style: buttonStyle),
        onPressed: () => Get.to(() => InvoiceDetailPage(
              invoiceId: invoice![index].id!,
              noOfLines: invoice![index].noOfLines,
            )),
      ),
    );
  }

  Widget _generateLeftHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        // Invoice date
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerRight,
          child: Text(
            Utils.formatShortDate(DateTime.parse(invoice![index].date)),
            style: rowStyle,
          ),
        ),
        // Invoice time
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerRight,
          child: Text(
            Utils.formatTime(DateTime.parse(invoice![index].date)),
            style: rowStyle,
          ),
        ),
        // Invoice total
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerRight,
          child: Text(
            Utils.formatPrice(invoice![index].total),
            style: rowStyle,
          ),
        ),
        // Invoice VAT
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerRight,
          child: Text(
            Utils.formatPrice(invoice![index].totalVat),
            style: rowStyle,
          ),
        ),
      ],
    );
  }
}

class TablePurchase extends StatelessWidget {
  const TablePurchase({super.key, this.purchase});

  final List<Purchase>? purchase;

  @override
  Widget build(BuildContext context) {
    double leftHandSideColumnWidth = MediaQuery.of(context).size.width;
    double rightHandSideColumnWidth = 100.0;
    return HorizontalDataTable.rtl(
      leftHandSideColumnWidth: leftHandSideColumnWidth,
      rightHandSideColumnWidth: rightHandSideColumnWidth,
      isFixedHeader: true,
      headerWidgets: _getTitleWidget(leftHandSideColumnWidth),
      isFixedFooter: false,
      footerWidgets: _getTitleWidget(leftHandSideColumnWidth),
      leftSideItemBuilder: _generateLeftHandSideColumnRow,
      rightSideItemBuilder: _generateFirstColumnRow,
      itemCount: purchase!.length,
      rowSeparatorWidget: const Divider(
        color: Colors.black38,
        height: 1.0,
        thickness: 0.0,
      ),
      leftHandSideColBackgroundColor: Colors.white,
      rightHandSideColBackgroundColor: AppColor.background,
      // const Color(0xFFFFFFFF),
      itemExtent: 55,
    );
  }

  List<Widget> _getTitleWidget(double leftHandSideColumnWidth) {
    return [
      _getTitleItemWidget('رقم الفاتورة', width),
      _getTitleItemWidget('التاريخ', width),
      _getTitleItemWidget('الوقت', width),
      _getTitleItemWidget('الصافي', width),
      _getTitleItemWidget('الضريبة', leftHandSideColumnWidth),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: height,
      color: AppColor.background,
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      alignment: Alignment.centerRight,
      child: Text(
        label,
        style: headerStyle,
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(purchase![index].id.toString(), style: buttonStyle),
        onPressed: () => Get.to(() => InvoiceDetailPage(
              invoiceId: purchase![index].id!,
              noOfLines: 0,
            )),
      ),
    );
  }

  Widget _generateLeftHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        // Column date
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerRight,
          child: Text(
            Utils.formatShortDate(DateTime.parse(purchase![index].date)),
            style: rowStyle,
          ),
        ),
        // Column time
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerRight,
          child: Text(
            Utils.formatTime(DateTime.parse(purchase![index].date)),
            style: rowStyle,
          ),
        ),
        // Column total
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerRight,
          child: Text(
            Utils.formatPrice(purchase![index].total),
            style: rowStyle,
          ),
        ),
        // Column VAT
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerRight,
          child: Text(
            Utils.formatPrice(purchase![index].totalVat),
            style: rowStyle,
          ),
        ),
      ],
    );
  }
}

class TableProduct extends StatelessWidget {
  const TableProduct({super.key, this.product});

  final List<Product>? product;

  @override
  Widget build(BuildContext context) {
    double leftHandSideColumnWidth = MediaQuery.of(context).size.width;
    double rightHandSideColumnWidth = 100.0;
    return HorizontalDataTable.rtl(
      leftHandSideColumnWidth: leftHandSideColumnWidth,
      rightHandSideColumnWidth: rightHandSideColumnWidth,
      isFixedHeader: true,
      headerWidgets: _getTitleWidget(leftHandSideColumnWidth),
      isFixedFooter: false,
      footerWidgets: _getTitleWidget(leftHandSideColumnWidth),
      leftSideItemBuilder: _generateLeftHandSideColumnRow,
      rightSideItemBuilder: _generateFirstColumnRow,
      itemCount: product!.length,
      rowSeparatorWidget: const Divider(
        color: Colors.black38,
        height: 1.0,
        thickness: 0.0,
      ),
      leftHandSideColBackgroundColor: Colors.white,
      rightHandSideColBackgroundColor: AppColor.background,
      // const Color(0xFFFFFFFF),
      itemExtent: 55,
    );
  }

  List<Widget> _getTitleWidget(double leftHandSideColumnWidth) {
    return [
      _getTitleItemWidget('رقم المنتج', width),
      _getTitleItemWidget('اسم المنتج', width * 2),
      _getTitleItemWidget('السعر', leftHandSideColumnWidth),
      // _getTitleItemWidget('', width),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: height,
      color: AppColor.background,
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      alignment: Alignment.centerRight,
      child: Text(
        label,
        style: headerStyle,
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(product![index].id.toString(), style: buttonStyle),
        onPressed: () =>
            Get.to(() => ProductDetailPage(productId: product![index].id!)),
      ),
    );
  }

  Widget _generateLeftHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          width: width * 2,
          height: height,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerRight,
          child: Text(
            product![index].productName!,
            style: rowStyle,
          ),
        ),
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerRight,
          child: Text(
            '${Utils.formatPrice(product![index].price!)}',
            style: rowStyle,
          ),
        ),
        // Container(
        //   width: width,
        //   height: height,
        //   padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
        //   alignment: Alignment.centerRight,
        //   child: Text('',
        //     style: rowStyle,
        //   ),
        // ),
      ],
    );
  }
}

class TableCustomer extends StatelessWidget {
  const TableCustomer({super.key, this.customer});

  final List<Customer>? customer;

  @override
  Widget build(BuildContext context) {
    double leftHandSideColumnWidth = MediaQuery.of(context).size.width;
    double rightHandSideColumnWidth = 100.0;
    return HorizontalDataTable.rtl(
      leftHandSideColumnWidth: leftHandSideColumnWidth,
      rightHandSideColumnWidth: rightHandSideColumnWidth,
      isFixedHeader: true,
      headerWidgets: _getTitleWidget(leftHandSideColumnWidth),
      isFixedFooter: false,
      footerWidgets: _getTitleWidget(leftHandSideColumnWidth),
      leftSideItemBuilder: _generateLeftHandSideColumnRow,
      rightSideItemBuilder: _generateFirstColumnRow,
      itemCount: customer!.length,
      rowSeparatorWidget: const Divider(
        color: Colors.black38,
        height: 1.0,
        thickness: 0.0,
      ),
      leftHandSideColBackgroundColor: Colors.white,
      rightHandSideColBackgroundColor: AppColor.background,
      // const Color(0xFFFFFFFF),
      itemExtent: 55,
    );
  }

  List<Widget> _getTitleWidget(double leftHandSideColumnWidth) {
    return [
      _getTitleItemWidget('رقم العميل', width),
      _getTitleItemWidget('اسم العميل', width * 2),
      _getTitleItemWidget('الجوال', leftHandSideColumnWidth),
      // _getTitleItemWidget('الرقم الضريبي', width),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: height,
      color: AppColor.background,
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      alignment: Alignment.centerRight,
      child: Text(
        label,
        style: headerStyle,
      ),
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerRight,
      child: TextButton(
        child: Text(customer![index].id.toString(), style: buttonStyle),
        onPressed: () =>
            Get.to(() => CustomerDetailPage(customerId: customer![index].id!)),
      ),
    );
  }

  Widget _generateLeftHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        Container(
          width: width * 2,
          height: height,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerRight,
          child: Text(
            customer![index].name,
            style: rowStyle,
          ),
        ),
        Container(
          width: width,
          height: height,
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          alignment: Alignment.centerRight,
          child: Text(
            customer![index].contactNumber,
            style: rowStyle,
          ),
        ),
      ],
    );
  }
}
