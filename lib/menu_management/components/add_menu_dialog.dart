import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/common/models/menu.dart';
import 'package:project1/common/models/user_system.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddOrUpdateMenuDialog extends StatefulWidget {
  final Menu? menu;
  const AddOrUpdateMenuDialog({
    Key? key,
    this.menu,
  }) : super(key: key);

  @override
  State<AddOrUpdateMenuDialog> createState() => _AddOrUpdateMenuDialogState();
}

class _AddOrUpdateMenuDialogState extends State<AddOrUpdateMenuDialog> {
  TextEditingController nameC = TextEditingController();

  final fontFamily = GoogleFonts.georama().fontFamily;

  @override
  void initState() {
    if (widget.menu != null) {
      nameC.text = widget.menu!.name;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: 80.w,
        decoration: BoxDecoration(
          color: mynuuBackgroundModal,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: Text(
                      "Add new Menu Group",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 2.w),
                      child: const Icon(
                        Icons.clear,
                        color: Color(0xff5c5d5e),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Menu name:",
                    style: TextStyle(
                      fontFamily: fontFamily,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextFormField(
                controller: nameC,
                cursorColor: Colors.white,
                cursorWidth: 1,
                autofocus: true,
                maxLines: null,
                style: TextStyle(
                  fontFamily: fontFamily,
                  color: Colors.grey,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [buildSaveAction(context), buildCancelAction(context)],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCancelAction(BuildContext context) {
    return SizedBox(
      width: 80,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
            side: const BorderSide(
              color: mynuuRed,
              width: 1,
            ),
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

  Widget buildSaveAction(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: ValueListenableBuilder<bool>(
        valueListenable: context.read<TableLayoutBloc>().loading,
        builder: (context, bool loading, _) {
          return loading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : SizedBox(
                  width: 80,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: const BorderSide(
                          color: mynuuYellow,
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: updateOrCreateMenu,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 14,
                        color: mynuuYellow,
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }

  void updateOrCreateMenu() async {
    final bloc = context.read<TableLayoutBloc>();
    final finalMenu = Menu(
      id: widget.menu?.id ?? '',
      name: nameC.text,
      restaurantId: context.read<FirebaseUser>().uid,
    );
    await EasyLoading.show(status: '');
    if (widget.menu != null) {
      await bloc.updateMenu(finalMenu);
    } else {
      await bloc.addMenu(finalMenu);
    }
    await EasyLoading.dismiss();
    Navigator.of(context).pop(true);
  }
}
