import 'package:flutter/material.dart';
import 'package:project1/common/models/category.dart';
import 'package:project1/common/models/product.dart';
import 'package:project1/common/models/restaurant.dart';
import 'package:sizer/sizer.dart';

import 'product_card.dart';

class ProductsHorizontalListView extends StatelessWidget {
  const ProductsHorizontalListView(
      {Key? key,
      required this.products,
      required this.category,
      required this.shortUrl,
      required this.rest,
      required this.valuePage})
      : super(key: key);

  final List<Product> products;
  final ProductCategory category;
  final String shortUrl;
  final Restaurant rest;
  final int valuePage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 4.h,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: buildCategoryTitle(category.name),
          ),
          SizedBox(
            height: 350,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              children: [
                for (var i = 0; i < products.length; i++)
                  ProductCard(
                    product: products[i],
                    shortUrl: shortUrl,
                    productIndex: i,
                    r: rest,
                    valuePage: valuePage,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        left: 10,
        bottom: 10,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
