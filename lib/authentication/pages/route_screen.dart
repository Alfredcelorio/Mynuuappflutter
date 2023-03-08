import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project1/authentication/blocs/authentication_bloc.dart';
import 'package:project1/authentication/pages/login_screen.dart';
import 'package:project1/authentication/pages/upload_logo_screen.dart';
import 'package:project1/common/models/user_system.dart';
import 'package:project1/common/pages/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../../common/services/landing_service.dart';
import '../../common/style/mynuu_colors.dart';

class RouteScreen extends StatelessWidget {
  const RouteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authenticationBloc = context.read<AuthenticationBLoc>();
    final CloudFirestoreService databaseService = CloudFirestoreService();
    return StreamBuilder<FirebaseUser?>(
      stream: authenticationBloc.onAuthStateChanged,
      builder: (_, AsyncSnapshot<FirebaseUser?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final FirebaseUser? user = snapshot.data;
          if (user == null || user.uid.isEmpty) {
            return Provider.value(
              value: authenticationBloc,
              child: const LoginScreen(),
            );
          }
          return buildLandingScreen(user, authenticationBloc);
        } else {
          return buildLoading();
        }
      },
    );
  }

  Widget buildLoading() {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            color: mynuuPrimary,
          ),
        ),
      ),
    );
  }

  Widget buildLandingScreen(
      FirebaseUser user, AuthenticationBLoc authenticationBloc) {
    final PageController controller = PageController();
    return FutureBuilder<bool>(
      future: authenticationBloc.initializeRestaurant(user.uid, user.email),
      builder: (context, snapshot) {
        final result = snapshot.data;
        if (result == null) {
          EasyLoading.show(status: '');
        }
        EasyLoading.dismiss();
        print(authenticationBloc.currentRestaurant);
        final currentLogo = authenticationBloc.currentRestaurant?.logo ?? '';
        return ValueListenableBuilder(
          valueListenable: authenticationBloc.skipToUploadLogo,
          builder: (context, bool skipToUploadLogo, _) {
            final mediaSize = MediaQuery.of(context).size;
            const value = 500;
            // TamaÃ±os ajustables de widgets
            final isIpad = (mediaSize.width < value);
            return Provider.value(
              value: user,
              child: currentLogo.isNotEmpty || skipToUploadLogo
                  ? PageView(controller: controller, children: [
                      HomeScreen(
                          firebaseUser: user,
                          idR: authenticationBloc.currentRestaurant?.id ?? '',
                          shortUrl:
                              authenticationBloc.currentRestaurant!.shortUrl!,
                          valuePage: 0),
                      if (isIpad)
                        HomeScreen(
                            firebaseUser: user,
                            idR: authenticationBloc.currentRestaurant?.id ?? '',
                            shortUrl:
                                authenticationBloc.currentRestaurant!.shortUrl!,
                            valuePage: 1)
                    ])
                  : Provider.value(
                      value: authenticationBloc,
                      child: const UploadLogoScreen(),
                    ),
            );
          },
        );
      },
    );
  }
}
