import 'package:flutter/material.dart';
import 'package:project1/common/blocs/home_bloc.dart';
import 'package:project1/common/components/top_menu.dart';
import 'package:project1/common/models/menu.dart';
import 'package:provider/provider.dart';

class TopNavigationMenu extends StatelessWidget {
  const TopNavigationMenu({
    Key? key,
    required this.visible,
    required this.onClosed,
    required this.onMenuSelected,
    required this.userSessionId,
  }) : super(key: key);

  // function onClosed
  final bool visible;
  final VoidCallback onClosed;
  final void Function(Menu) onMenuSelected;
  final String userSessionId;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: visible ? MediaQuery.of(context).size.height : 0,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: const Duration(milliseconds: 500),
        child: MultiProvider(
          providers: [
            Provider.value(value: context.read<HomeBloc>()),
          ],
          child: TopMenu(
            onClose: onClosed,
            onMenuSelected: onMenuSelected,
            userSessionId: userSessionId,
          ),
        ),
      ),
    );
  }
}
