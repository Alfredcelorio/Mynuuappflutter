import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project1/authentication/blocs/authentication_bloc.dart';
import 'package:project1/common/components/custom_dialog.dart';
import 'package:project1/common/models/user_system.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:project1/menu_management/pages/coming_soon_screen.dart';
import 'package:project1/menu_management/pages/guests_table_screen.dart';
import 'package:project1/menu_management/pages/screen_writeNfc.dart';
import 'package:project1/menu_management/pages/tabslayout.dart';
import 'package:project1/menu_management/pages/trash.dart';
import 'package:project1/profile_management/pages/edit_landing_screen.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../common/services/providers.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int currentPage = 0;
  late List<Widget> pages;
  late final TableLayoutBloc bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    final providerFirebaseUser = context.read<FirebaseUser>();
    final providerR = context.read<Providers>();
    providerFirebaseUser.uid = providerR.r.id;
    print("fireuser: ${providerFirebaseUser.uid}");
    bloc = TableLayoutBloc(
      providerFirebaseUser,
    );
    pages = [
      const TabsLayout(),
      const Trash(),
      const GuestsTableScreen(),
      const ComingSoonScreen(),
      const EditLandingScreen(),
      const ClassNfcPlugin()
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerR = context.read<Providers>();
    final authProvider = context.read<AuthenticationBLoc>();
    final String role = authProvider.idsR.value.first['rol'] as String;
    if (role == 'Staff') {
      currentPage = 2;
    }
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context, role),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          icon: Image.asset(
            'assets/icons/hamburguer.png',
          ),
        ),
        title: Image.asset(
          'assets/logo-2.png',
          width: 100,
        ),
        actions: [
          _buildPopupMenuButton(context, role),
        ],
      ),
      backgroundColor: Colors.black,
      body: Provider.value(
        value: bloc,
        child: pages[currentPage],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, String role) {
    return Drawer(
      backgroundColor: const Color(0xFF1F1F1F),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              if (role != 'Staff')
                ListTile(
                  title: const Text(
                    'Landing Page',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      currentPage = 4;
                    });
                  },
                ),
              // if (role != 'Staff')
              //   const Divider(
              //     color: Colors.white,
              //   ),
              // if (role != 'Staff')
              //   ListTile(
              //     title: const Text(
              //       'Users',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 18,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //     onTap: () {
              //       Navigator.pop(context);
              //       setState(() {
              //         currentPage = 3;
              //       });
              //     },
              //   ),
              if (role != 'Staff')
                const Divider(
                  color: Colors.white,
                ),
              ListTile(
                title: const Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
              const Divider(
                color: Colors.white,
              ),
              ListTile(
                title: const Text(
                  'Guests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    currentPage = 2;
                  });
                },
              ),
              if (role != 'Staff')
                const Divider(
                  color: Colors.white,
                ),
              if (role != 'Staff')
                ListTile(
                  title: const Text(
                    'Activate card',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      currentPage = 5;
                    });
                  },
                ),
              if (role != 'Staff')
                const Divider(
                  color: Colors.white,
                ),
              // if (role != 'Staff')
              //   ListTile(
              //     title: const Text(
              //       'Table number',
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 18,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //     onTap: () {
              //       Navigator.pop(context);
              //       setState(() {
              //         currentPage = 3;
              //       });
              //     },
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupMenuButton(BuildContext context, String role) {
    return PopupMenuButton(
      onSelected: (value) async {
        if (value == 0 && currentPage != 0) {
          setState(() {
            currentPage = 0;
          });
        }

        if (value == 1 && currentPage != 1) {
          setState(() {
            currentPage = 1;
          });
        }
        if (value == 2) {
          EasyLoading.show(status: '');
          final bloc = context.read<AuthenticationBLoc>();
          bloc.signOut();
          bloc.skipToUploadLogo.value = false;
          EasyLoading.dismiss();
          Navigator.pop(context);
        }

        if (value == 3 && currentPage != 3) {
          final bool? didRequestSignOut = await PlatformAlertDialog(
            title: 'Delete Account',
            content:
                'Are you sure you want to delete your account? This action cannot be undone.',
            cancelActionText: 'Cancel',
            defaultActionText: 'Delete',
          ).show(context);
          if (didRequestSignOut == true) {
            _deleteAccount(context);
          }
        }
      },
      color: const Color(0xff242527),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.w)),
      icon: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xB31E1E1E),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Icon(
            Icons.settings_outlined,
            color: Colors.white.withOpacity(.7),
            size: 24,
          ),
        ),
      ),
      itemBuilder: (context) {
        return [
          if (role != 'Staff')
            const PopupMenuItem(
              value: 0,
              child: Text(
                "Table",
                style: TextStyle(color: Colors.white),
              ),
            ),
          const PopupMenuItem(
            value: 1,
            child: Text(
              "Trash",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const PopupMenuItem(
            value: 2,
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const PopupMenuItem(
            value: 3,
            child: Text(
              "Delete account",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ];
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    try {
      EasyLoading.show(status: '');
      await bloc.deleteProfile();
      await FirebaseAuth.instance.currentUser?.delete();
      EasyLoading.dismiss();
      Navigator.pop(context);
    } on PlatformException catch (_) {
      EasyLoading.dismiss();
      await PlatformAlertDialog(
        title: 'There was an error',
        content: 'Please try again later',
        defaultActionText: 'Ok',
      ).show(context);
    }
  }
}
