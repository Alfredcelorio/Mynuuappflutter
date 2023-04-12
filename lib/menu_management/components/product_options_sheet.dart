import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/common/models/category.dart';
import 'package:project1/common/models/product.dart';
import 'package:project1/common/models/user_system.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'add_product_dialog.dart';

class ProductOptionsSheet extends StatelessWidget {
  const ProductOptionsSheet({
    Key? key,
    required this.product,
    required this.currentCategoryId,
    required this.categories,
  }) : super(key: key);

  final Product product;
  final String currentCategoryId;
  final List<ProductCategory>? categories;
  @override
  Widget build(BuildContext context) {
    final fontFamily = GoogleFonts.georama().fontFamily;
    return Container(
      width: double.infinity,
      color: mynuuBackgroundModal,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 24),
            SizedBox(
              width: 80.w,
              child: Text(
                'Which action do you want to perform?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 80.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  final bloc = context.read<TableLayoutBloc>();
                  final userSession = context.read<FirebaseUser>();
                  final value = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return MultiProvider(
                        providers: [
                          Provider.value(value: userSession),
                          Provider.value(value: bloc),
                        ],
                        child: AddOrEditProductDialog(
                          category: currentCategoryId,
                          availableCategories: categories,
                          product: product,
                        ),
                      );
                    },
                  );
                  if (value == 'update') {
                    showToast('Changes saved');
                  }
                },
                child: Text(
                  'Edit',
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 14,
                    color: mynuuGreen,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 80.w,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  product.deleted = true;
                  context.read<TableLayoutBloc>().softDeleteProduct(product);
                },
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 14,
                    color: mynuuRed,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromRGBO(254, 253, 253, 0.1),
        textColor: Color.fromRGBO(254, 253, 253, 1));
  }
}
