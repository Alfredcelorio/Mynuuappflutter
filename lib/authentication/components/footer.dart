import 'package:flutter/material.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:sizer/sizer.dart';

class Footer extends StatelessWidget {
  final Color backgroundColor;
  const Footer({
    Key? key,
    this.backgroundColor = mynuuBackground,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 10),
        width: 100.w,
        color: backgroundColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'POWERED BY',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            SizedBox(
              width: 30.w,
              child: Image.asset(
                "assets/logo-2.png",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
