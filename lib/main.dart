import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/authentication/pages/route_screen.dart';
import 'package:project1/authentication/pages/web/phone_sign_in/otp_screen.dart';
import 'package:project1/authentication/pages/web/phone_sign_in/phone_number_screen.dart';
import 'package:project1/authentication/pages/web/phone_sign_in/sign_in_name_screen.dart';
import 'package:project1/common/pages/home_screen.dart';
import 'package:project1/common/pages/not_found_screen.dart';
import 'package:project1/common/pages/product_detail_carrousel.dart';
import 'package:project1/common/pages/web_router_screen.dart';
import 'package:project1/common/services/landing_service.dart';
import 'package:project1/common/services/likesProvider.dart';
import 'package:project1/common/services/nfc_plugin_provider.dart';
import 'package:project1/common/services/providers.dart';
import 'package:project1/common/services/push_notification_service.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/firebase_options.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:project1/menu_management/pages/guest_detail_screen.dart';
import 'package:project1/profile_management/pages/customLoading.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'authentication/blocs/authentication_bloc.dart';
import 'authentication/services/auth_service.dart';
import 'authentication/services/firebase_auth_service.dart';
import 'common/models/user_system.dart';
import 'common/pages/restaurant_resolving_wrapper.dart';
import 'common/services/apple_sign_in_available.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

List<String> recentSearches = [];
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.white),
  );
  final appleSignInAvailable = await AppleSignInAvailable.check();
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: "384273170550321",
      cookie: true,
      xfbml: true,
      version: "v13.0",
    );
  }
  runApp(Provider<AppleSignInAvailable>.value(
    value: appleSignInAvailable,
    child: const MyApp(),
  ));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..maskType = EasyLoadingMaskType.black
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = mynuuPrimary
    ..backgroundColor = const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8)
    ..indicatorColor = mynuuPrimary
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late PushNotificationProvider pushNotificationProvider;

  @override
  void initState() {
    pushNotificationProvider = PushNotificationProvider();
    pushNotificationProvider.messageStream.listen((guestId) {
      if (guestId.isNotEmpty) {
        _router.push('/menu/$guestId');
      }
    });
    super.initState();
  }

  final GoRouter _router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            kIsWeb ? const RouteScreen() : const RouteScreen(),
        routes: <GoRoute>[
          GoRoute(
              path: ':shortUrl',
              builder: (BuildContext context, GoRouterState state) {
                var shortUrl = state.params['shortUrl'] ?? '';
                return WebRouterScreen(
                  shortUrl: shortUrl,
                );
              }),
          GoRoute(
              path: ':shortUrl/signin/phone',
              builder: (BuildContext context, GoRouterState state) {
                var shortUrl = state.params['shortUrl'] ?? '';
                return RestaurantResolvingWrapper(
                  shortUrl: shortUrl,
                  widgedProvider: (user, restaurant) =>
                      PhoneNumberScreen(user: user, restaurant: restaurant),
                );
              }),
          GoRoute(
              path: ':shortUrl/signin/phone/otp',
              builder: (BuildContext context, GoRouterState state) {
                // return VerifyPhoneNumberScreen(phoneNumber: '+306974666101');

                var otpScreenArguments = state.extra as OtpScreenArguments?;
                if (otpScreenArguments != null) {
                  return OtpScreen(
                      restaurant: otpScreenArguments.restaurant,
                      phoneNumber: otpScreenArguments.phoneNumber);
                }
                return const NotFoundScreen();
              }),
          GoRoute(
              path: ':shortUrl/signin/phone/name',
              builder: (BuildContext context, GoRouterState state) {
                var otpScreenArguments =
                    state.extra as SignInNameScreenArguments?;

                if (otpScreenArguments == null) {
                  return const NotFoundScreen();
                }

                return SignInNameScreen(
                    user: otpScreenArguments.user,
                    restaurant: otpScreenArguments.restaurant);
              }),
          GoRoute(
              path: ':shortUrl/menu',
              builder: (BuildContext context, GoRouterState state) {
                var shortUrl = state.params['shortUrl'] ?? '';
                final extraParameter = state.extra as Map<String, dynamic>?;
                FirebaseUser? user;
                if (extraParameter != null) {
                  user = extraParameter["user"] as FirebaseUser?;
                }

                return HomeScreen(
                  shortUrl: shortUrl,
                  idR: '',
                  firebaseUser: user ?? FirebaseUser.notFound(),
                  valuePage: 0,
                );
              }),
          GoRoute(
              path: ':shortUrl/menu/:categoryId/:productId/:productIndex',
              builder: (BuildContext context, GoRouterState state) {
                var categoryId = state.params["categoryId"]!;
                var productId = state.params["productId"]!;
                var shortUrl = state.params["shortUrl"]!;
                var comesFromDirectLink = state.extra != null
                    ? state.extra as Map<String, bool>?
                    : null;
                return ProductDetailScreen(
                  proId: productId,
                  categoryID: categoryId,
                  restaurantShortUrl: shortUrl,
                  comesFromDirectLink: comesFromDirectLink == null,
                );
              }),
          GoRoute(
              path: 'menu/:guestId',
              builder: (BuildContext context, GoRouterState state) {
                var guestId = state.params["guestId"]!;
                return Provider(
                  create: (_) => TableLayoutBloc(
                    FirebaseUser.notFound(),
                  ),
                  child: GuestDetailScreen(
                    guestId: guestId,
                  ),
                );
              }),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      final AuthService authService = FirebaseAuthService();
      final cloudFirestoreService = CloudFirestoreService();
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Providers(),
          ),
          ChangeNotifierProvider(
            create: (context) => LikesProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => NfcPlugin(),
          ),
          Provider.value(
            value: cloudFirestoreService,
          ),
          Provider.value(value: authService),
          Provider.value(value: pushNotificationProvider),
          Provider(
            create: (_) => AuthenticationBLoc(
              auth: authService,
              databaseService: cloudFirestoreService,
              pushNotificationProvider: pushNotificationProvider,
            ),
          )
        ],
        child: FirebasePhoneAuthProvider(
          child: MaterialApp.router(
            title: "Mynuu",
            debugShowCheckedModeBanner: false,
            routeInformationProvider: _router.routeInformationProvider,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
            theme: mynuuTheme(),
            builder: EasyLoading.init(),
          ),
        ),
      );
    });
  }

  ThemeData? mynuuTheme() => ThemeData.dark().copyWith(
        textTheme: GoogleFonts.openSansTextTheme(),
        scaffoldBackgroundColor: mynuuBackground,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
        backgroundColor: mynuuBackground,
        primaryColor: mynuuPrimary,
        primaryColorDark: mynuuPrimary,
        primaryColorLight: mynuuPrimary,
        canvasColor: mynuuPrimary,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              //  backgroundColor: mynuuPrimary,
              ),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: mynuuBackground,
        ),
      );
}
