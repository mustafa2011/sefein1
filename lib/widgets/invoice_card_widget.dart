import 'dart:io';

import '/apis/constants/utils.dart';
import '/models/invoice.dart';
import '/models/purchase.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';

/*final _lightColors = [
  // Colors.amber.shade300,
  // Colors.lightGreen.shade300,
  // Colors.lightBlue.shade300,
  Colors.orange.shade100,
  // Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100,
  // Colors.redAccent.shade100
];*/

class InvoiceCardWidget extends StatelessWidget {
  const InvoiceCardWidget({
    super.key,
    required this.invoice,
    required this.index,
  });

  final Invoice invoice;
  final int index;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    // final color = _lightColors[index % _lightColors.length];
    bool isCreditNote = false;
    String title = 'فاتورة';

    final date = invoice.date;
    final minHeight = getMinHeight(index);
    isCreditNote = invoice.invoiceNo.substring(
                invoice.invoiceNo.length - 2, invoice.invoiceNo.length) ==
            'CR'
        ? true
        : false;
    title = isCreditNote ? 'إشعار دائن' : 'فاتورة';
    return Card(
      color: isCreditNote
          ? Colors.red.shade100
          : invoice.posted == 1
              ? Colors.grey.shade400
              : Colors.green.shade100,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColor.primary),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$title: ',
                  style: const TextStyle(color: AppColor.primary, fontSize: 12),
                ),
                Text(
                  invoice.invoiceNo,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                isCreditNote
                    ? Container()
                    : Platform.isWindows || Platform.isLinux
                        ? Checkbox(
                            value: invoice.posted == 1 ? true : false,
                            onChanged: null,
                          )
                        : Container()
              ],
            ),
            Text(
              Utils.formatNoCurrency(invoice.total),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 1) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}

class PurchaseCardWidget extends StatelessWidget {
  const PurchaseCardWidget({
    super.key,
    required this.purchase,
    required this.index,
  });

  final Purchase purchase;
  final int index;

  @override
  Widget build(BuildContext context) {
    String title = 'فاتورة';

    final date = purchase.date;
    final minHeight = getMinHeight(index);
    return Card(
      color: Colors.green.shade100,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            Text(
              date,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColor.primary),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$title: ',
                  style: const TextStyle(color: AppColor.primary, fontSize: 12),
                ),
                Text(
                  '${purchase.id}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
            Text(
              Utils.formatNoCurrency(purchase.total),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 1) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
