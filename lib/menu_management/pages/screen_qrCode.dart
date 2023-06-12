import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';
import 'package:project1/common/services/providers.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ClassQrCode extends StatelessWidget {
  const ClassQrCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerR = context.watch<Providers>();
    return SizedBox(
      width: 100.w,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          QrImage(
            data: 'https://mn.mynuutheapp.com/${providerR.r.shortUrl}',
            version: QrVersions.auto,
            size: 250,
            backgroundColor: Colors.white,
            gapless: false,
          ),
        ],
      ),
    );
  }
}
