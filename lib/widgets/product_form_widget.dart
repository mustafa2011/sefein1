import 'package:flutter/material.dart';

import 'app_colors.dart';

class ProductFormWidget extends StatelessWidget {
  final num price;
  final String? productName;
  final ValueChanged<num> onChangedPrice;
  final ValueChanged<String> onChangedProductName;

  const ProductFormWidget({
    super.key,
    this.price = 0.0,
    this.productName = '',
    required this.onChangedPrice,
    required this.onChangedProductName,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildProductName(),
              const SizedBox(height: 4),
              buildPrice(),
            ],
          ),
        ),
      );

  Widget buildProductName() => TextFormField(
        initialValue: productName,
        keyboardType: TextInputType.name,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        decoration: const InputDecoration(
          labelText: 'اسم المنتج',
        ),
        validator: (productName) => productName != null && productName.isEmpty
            ? 'يجب إدخال اسم الصنف'
            : null,
        onChanged: onChangedProductName,
      );

  Widget buildPrice() => TextFormField(
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        initialValue: price.toString(),
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: AppColor.primary,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        decoration: const InputDecoration(
          labelText: 'سعر المنتج',
        ),
        validator: (price) =>
            price == null || price == '' ? 'يجب إدخال سعر الصنف' : null,
        onChanged: (price) => onChangedPrice(num.parse(price)),
      );
}
