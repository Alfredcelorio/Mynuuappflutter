import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project1/authentication/blocs/authentication_bloc.dart';
import 'package:project1/authentication/components/authentication_button.dart';
import 'package:project1/authentication/components/footer.dart';
import 'package:project1/authentication/pages/route_screen.dart';
import 'package:project1/common/components/custom_dialog.dart';
import 'package:project1/common/utils/utils.dart';
import 'package:provider/provider.dart';

class SelectedRestaurant extends StatefulWidget {
  const SelectedRestaurant({Key? key}) : super(key: key);

  @override
  State<SelectedRestaurant> createState() => _SelectedRestaurantState();
}

class _SelectedRestaurantState extends State<SelectedRestaurant> {
  late AuthenticationBLoc bloc = context.read<AuthenticationBLoc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            const Positioned(
              bottom: 0,
              child: Center(
                child: Footer(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
