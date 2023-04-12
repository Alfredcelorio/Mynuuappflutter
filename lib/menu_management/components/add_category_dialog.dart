import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/common/models/category.dart';
import 'package:project1/common/models/menu.dart';
import 'package:project1/common/models/user_system.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddOrUpdateCategoryDialog extends StatefulWidget {
  final ProductCategory? category;
  const AddOrUpdateCategoryDialog({
    Key? key,
    this.category,
  }) : super(key: key);

  @override
  State<AddOrUpdateCategoryDialog> createState() =>
      _AddOrUpdateCategoryDialogState();
}

class _AddOrUpdateCategoryDialogState extends State<AddOrUpdateCategoryDialog> {
  TextEditingController nameC = TextEditingController();

  String? selectedMenuId;
  final fontFamily = GoogleFonts.georama().fontFamily;

  @override
  void initState() {
    if (widget.category != null) {
      nameC.text = widget.category?.name ?? '';
      selectedMenuId = widget.category?.menuId ?? '';
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
          children: [
            _buildModalTitle(context),
            Padding(
              padding: EdgeInsets.all(2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sub category name:",
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
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            // if (widget.category != null)
            buildMenuGroupPicker(),
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

  Widget buildMenuGroupPicker() {
    final bloc = context.read<TableLayoutBloc>();
    return ExpansionTile(
      backgroundColor: Colors.black,
      iconColor: Colors.white,
      collapsedBackgroundColor: Colors.black,
      collapsedIconColor: mynuuDarkGrey,
      initiallyExpanded: true,
      title: Text(
        "Menu:",
        style: TextStyle(
          fontFamily: fontFamily,
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
      children: [
        FutureBuilder<List<Menu>>(
            future: bloc.getMenusByRestaurantId(),
            builder: (context, snapshot) {
              final data = snapshot.data;
              if (data == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: mynuuPrimary,
                  ),
                );
              }
              return Column(
                children: data.map(
                  (menu) {
                    return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedMenuId = menu.id;
                          });
                        },
                        child: Container(
                          color: mynuuBackgroundModal,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                              vertical: 6.0,
                            ),
                            child: Text(
                              '·  ' + menu.name.toString(),
                              style: TextStyle(
                                fontFamily: fontFamily,
                                color: menu.id == selectedMenuId
                                    ? mynuuYellow
                                    : Colors.white,
                                fontWeight: menu.id == selectedMenuId
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              );
            })
      ],
    );
  }

  Widget _buildModalTitle(BuildContext context) {
    return Container(
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
              "Add new sub category",
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
                    onPressed: updateOrCreateCategory,
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

  void updateOrCreateCategory() async {
    final bloc = context.read<TableLayoutBloc>();
    final finalCategory = ProductCategory(
      id: widget.category?.id ?? '',
      name: nameC.text,
      status: widget.category?.status ?? true,
      restaurantId: context.read<FirebaseUser>().uid,
      menuId: selectedMenuId ?? '',
      position: 0,
    );
    await EasyLoading.show(status: '');
    if (widget.category != null) {
      await bloc.updateCategory(
        finalCategory,
        selectedMenuId,
      );
    } else {
      await bloc.addCategory(finalCategory);
    }
    await EasyLoading.dismiss();
    Navigator.pop(context);
  }
}
