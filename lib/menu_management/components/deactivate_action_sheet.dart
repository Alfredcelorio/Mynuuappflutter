import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/common/models/product.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DeactivateActionSheet extends StatelessWidget {
  DeactivateActionSheet({
    Key? key,
    required this.productResult,
    required this.refresh,
  }) : super(key: key);

  final Product productResult;
  final VoidCallback refresh;

  final fontFamily = GoogleFonts.georama().fontFamily;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: mynuuBackgroundModal,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            SizedBox(
              width: 80.w,
              child: Text(
                'Are you sure you want to take out this menu item?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            if (productResult.enabled)
              const SizedBox(
                height: 40,
              ),
            if (productResult.enabled)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF151515),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            deactivateProduct(context);
                          },
                          child: Text(
                            'Deactivate until further notice',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 12,
            ),
            if (productResult.enabled)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF151515),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            deactivateProduct(context);
                          },
                          child: Text(
                            'Deactivate until tomorrow',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (productResult.enabled)
              const SizedBox(
                height: 12,
              ),
            const SizedBox(
              height: 12,
            ),
            if (!productResult.enabled) buildConfirmButton(context),
            buildCancelButton(context),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: 80.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
          deactivateProduct(context);
        },
        child: Text(
          'Confirm',
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            color: mynuuGreen,
          ),
        ),
      ),
    );
  }

  Widget buildCancelButton(BuildContext context) {
    return SizedBox(
      width: 80.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        child: Text(
          'Cancel',
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 14,
            color: mynuuRed,
          ),
        ),
      ),
    );
  }

  void deactivateProduct(BuildContext context) async {
    final succesfull =
        await context.read<TableLayoutBloc>().changeProductStatus(
              productResult,
            );
    if (succesfull) {
      refresh();
    }
  }
}
