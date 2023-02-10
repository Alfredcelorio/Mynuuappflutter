import 'package:flutter/material.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ProductsHorizontalListSkeleton extends StatelessWidget {
  const ProductsHorizontalListSkeleton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      child: Padding(
        padding: EdgeInsets.only(bottom: 4.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Container(
                color: Colors.black,
                height: 20,
                width: 100,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                padding: const EdgeInsets.only(left: 20),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      width: 250,
                      height: 185,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      baseColor: mynuuBlack,
      highlightColor: Colors.grey,
    );
  }
}
