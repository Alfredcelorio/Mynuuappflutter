import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/common/models/category.dart';
import 'package:project1/common/models/menu.dart';
import 'package:project1/common/models/product.dart';
import 'package:project1/common/models/user_system.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/common/utils/utils.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddOrEditProductDialog extends StatefulWidget {
  final String category;
  final List<ProductCategory>? availableCategories;
  final Product? product;
  final String menuId;
  const AddOrEditProductDialog(
      {Key? key,
      required this.category,
      required this.availableCategories,
      this.product,
      required this.menuId})
      : super(key: key);

  @override
  State<AddOrEditProductDialog> createState() => _AddOrEditProductDialogState();
}

class _AddOrEditProductDialogState extends State<AddOrEditProductDialog> {
  final List<String> bottleTypes = ["bottles", "servings"];
  final List filters = ["chicken", "Seafood", "Chicken", "Salads"];
  File? mYimage;
  File? myImage2;
  String base64im = "";
  bool isSubmit = false;
  int? selectedFilter;

  late String selectedCategoryId;
  String? selectedMenuId;
  String? bottleType;

  TextEditingController itemnumberC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController descriptionC = TextEditingController();
  TextEditingController priceC = TextEditingController();
  TextEditingController stockC = TextEditingController();
  TextEditingController abv = TextEditingController();
  TextEditingController body = TextEditingController();
  TextEditingController region = TextEditingController();
  TextEditingController countryState = TextEditingController();
  TextEditingController sku = TextEditingController();
  TextEditingController taste = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController varietal = TextEditingController();
  TextEditingController brand = TextEditingController();

  TextEditingController quantity = TextEditingController();

  final fontFamily = GoogleFonts.georama().fontFamily;

  @override
  void initState() {
    selectedCategoryId = widget.category;
    selectedMenuId = widget.menuId;
    if (widget.product != null) {
      itemnumberC.text = '123';
      nameC.text = widget.product?.name ?? '';
      stockC.text = '123';
      priceC.text = widget.product!.price.toString();
      descriptionC.text = widget.product?.description ?? '';
      selectedCategoryId = widget.product?.categoryId ?? '';
      selectedMenuId = widget.product?.menuId ?? '';
      abv.text = widget.product?.abv ?? '';
      body.text = widget.product?.body ?? '';
      region.text = widget.product?.region ?? '';
      countryState.text = widget.product?.countryState ?? '';
      sku.text = widget.product?.sku ?? '';
      taste.text = widget.product?.taste ?? '';
      type.text = widget.product?.type ?? '';
      varietal.text = widget.product?.varietal ?? '';
      brand.text = widget.product?.brand ?? '';

      final inventory = widget.product?.inventory;

      if (inventory != null) {
        quantity.text = inventory.isNotEmpty ? inventory[0]["quantity"] : '';
        bottleType = inventory.isNotEmpty ? inventory[0]["typeBottles"] : null;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: 90.w,
          decoration: const BoxDecoration(
            color: mynuuBackgroundModal,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildDialogHeader(context),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 18,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: buildPicturesField(),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildProductNameField(),
                            const SizedBox(height: 10),
                            buildPriceField(),
                            const SizedBox(height: 10),
                            buildDescriptionField(),
                            const SizedBox(height: 10),
                            buildProductBrandField(),
                            const SizedBox(height: 10),
                            buildProductBodyField(),
                            const SizedBox(height: 10),
                            buildProductRegionField(),
                            const SizedBox(height: 10),
                            buildProductCountryStateField(),
                            const SizedBox(height: 10),
                            buildProductSkuField(),
                            const SizedBox(height: 10),
                            buildProductTypeField(),
                            const SizedBox(height: 10),
                            buildProductAbvField(),
                            const SizedBox(height: 10),
                            buildProductVarietalField(),
                            const SizedBox(height: 10),
                            buildProductTasteField(),
                            const SizedBox(height: 10),
                            buildChangeImageButton(context)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                buildInventoryGroup(context),
                buildMenuGroupPicker(),
                buildProductCategoryPicker(),
                const Divider(
                  height: 1,
                ),
                buildSubmitAction(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildChangeImageButton(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        mYimage = await pickImage();
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_circle_outline,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                'Change Image',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: fontFamily,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuGroupPicker() {
    final bloc = context.read<TableLayoutBloc>();
    return ExpansionTile(
      initiallyExpanded: true,
      backgroundColor: Colors.black,
      iconColor: mynuuDarkGrey,
      collapsedBackgroundColor: Colors.black,
      collapsedIconColor: mynuuDarkGrey,
      title: Text(
        "MENU",
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
                child: CircularProgressIndicator(),
              );
            }
            return Column(
              children: data.map(
                (menu) {
                  return InkWell(
                    onTap: () {
                      setState(
                        () {
                          selectedMenuId = menu.id;
                        },
                      );
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
                          '·  ${menu.name}',
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
                  );
                },
              ).toList(),
            );
          },
        )
      ],
    );
  }

  Widget buildProductCategoryPicker() {
    return ExpansionTile(
      initiallyExpanded: true,
      backgroundColor: Colors.black,
      iconColor: mynuuDarkGrey,
      collapsedBackgroundColor: Colors.black,
      collapsedIconColor: mynuuDarkGrey,
      title: Text(
        "CATEGORIES",
        style: TextStyle(
          fontFamily: fontFamily,
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
      children: [
        Column(
          children: widget.availableCategories?.map(
                (category) {
                  return InkWell(
                    onTap: () {
                      setState(
                        () {
                          selectedCategoryId = category.id;
                        },
                      );
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
                          '·  ${category.name}',
                          style: TextStyle(
                            fontFamily: fontFamily,
                            color: category.id == selectedCategoryId
                                ? mynuuYellow
                                : Colors.white,
                            fontWeight: category.id == selectedCategoryId
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ).toList() ??
              [
                Text(
                  'No categories available',
                  style: TextStyle(
                    fontFamily: fontFamily,
                    color: Colors.white,
                    fontSize: 12,
                  ),
                )
              ],
        )
      ],
    );
  }

  Widget buildInventoryGroup(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      backgroundColor: Colors.black,
      iconColor: mynuuDarkGrey,
      collapsedBackgroundColor: Colors.black,
      collapsedIconColor: mynuuDarkGrey,
      title: Text(
        "INVENTORY",
        style: TextStyle(
          fontFamily: fontFamily,
          color: Colors.white,
          fontSize: 14.0,
        ),
      ),
      children: [
        Container(
          color: mynuuBackgroundModal,
          child: Padding(
            padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Text(
                        "Quantity:",
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: quantity,
                        cursorColor: Colors.white,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        style: TextStyle(
                          fontFamily: fontFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
                Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      "Serving Type:",
                      style: TextStyle(
                        fontFamily: fontFamily,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  DropdownButton(
                    value: bottleType,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: fontFamily,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    dropdownColor: Colors.black87,
                    iconSize: 5.w,
                    underline: const SizedBox.shrink(),
                    items: bottleTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        bottleType = value;
                      });
                    },
                  ),
                ]),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildSubmitAction(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(2.w),
      child: ValueListenableBuilder(
        valueListenable: context.read<TableLayoutBloc>().loading,
        builder: (context, bool loading, _) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: updateOrCreateProduct,
            child: const Text(
              'SUBMIT',
              style: TextStyle(
                fontSize: 14,
                color: mynuuGreen,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildDescriptionField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Description : ",
          style: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: descriptionC,
            style: TextStyle(
              fontFamily: fontFamily,
              color: Colors.white,
              fontSize: 12,
            ),
            maxLines: null,
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPriceField() {
    return Row(
      children: [
        Text(
          "Price : \$ ",
          style: TextStyle(
            fontFamily: fontFamily,
            color: mynuuYellow,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: priceC,
            style: TextStyle(
              fontFamily: fontFamily,
              color: mynuuYellow,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            cursorColor: Colors.white,
            cursorWidth: 1,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        )
      ],
    );
  }

  Widget buildProductNameField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name : ",
          style: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: nameC,
            cursorColor: Colors.white,
            style: TextStyle(
              fontFamily: fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        )
      ],
    );
  }

  Widget buildProductAbvField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Abv : ",
          style: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: abv,
            cursorColor: Colors.white,
            style: TextStyle(
              fontFamily: fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        )
      ],
    );
  }

  Widget buildProductBodyField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Body : ",
          style: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: body,
            cursorColor: Colors.white,
            style: TextStyle(
              fontFamily: fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        )
      ],
    );
  }

  Widget buildProductRegionField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Region : ",
          style: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: region,
            cursorColor: Colors.white,
            style: TextStyle(
              fontFamily: fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        )
      ],
    );
  }

  Widget buildProductCountryStateField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Country/state : ",
          style: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: countryState,
            cursorColor: Colors.white,
            style: TextStyle(
              fontFamily: fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        )
      ],
    );
  }

  Widget buildProductSkuField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sku : ",
          style: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: sku,
            cursorColor: Colors.white,
            style: TextStyle(
              fontFamily: fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        )
      ],
    );
  }

  Widget buildProductTasteField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Taste : ",
          style: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: taste,
            cursorColor: Colors.white,
            style: TextStyle(
              fontFamily: fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        )
      ],
    );
  }

  Widget buildProductVarietalField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Varietal : ",
          style: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: varietal,
            cursorColor: Colors.white,
            style: TextStyle(
              fontFamily: fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        )
      ],
    );
  }

  Widget buildProductTypeField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Type : ",
          style: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: type,
            cursorColor: Colors.white,
            style: TextStyle(
              fontFamily: fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        )
      ],
    );
  }

  Widget buildProductBrandField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Brand : ",
          style: TextStyle(
            fontFamily: fontFamily,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextFormField(
            controller: brand,
            cursorColor: Colors.white,
            style: TextStyle(
              fontFamily: fontFamily,
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
            maxLines: null,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        )
      ],
    );
  }

  Widget buildPicturesField() {
    return mYimage != null
        ? SizedBox(
            height: 160,
            width: 96,
            child: Image.file(
              mYimage!,
              fit: BoxFit.cover,
            ),
          )
        : widget.product != null
            ? kIsWeb
                ? Image.network(
                    widget.product!.image,
                    height: 140,
                    width: 96,
                    fit: BoxFit.cover,
                  )
                : CachedNetworkImage(
                    height: 140,
                    width: 96,
                    fit: BoxFit.cover,
                    imageUrl: widget.product!.image,
                    errorWidget: (context, url, error) {
                      return Center(
                        child: Text(
                          error.toString(),
                          style: TextStyle(
                              fontFamily: fontFamily, color: Colors.red),
                        ),
                      );
                    },
                    placeholder: (context, url) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    },
                  )
            : Container(
                height: 140.0,
                width: 96.0,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                  ),
                ),
              );
  }

  Widget buildDialogHeader(BuildContext context) {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.horizontal(
            left: Radius.circular(8),
            right: Radius.circular(8),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: Text(
              "INSERT ITEM",
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
                Icons.close_rounded,
                color: Color(0xff5c5d5e),
              ),
            ),
          )
        ],
      ),
    );
  }

  void updateOrCreateProduct() async {
    var msg = '';
    final bloc = context.read<TableLayoutBloc>();
    final finalProduct = Product(
        id: widget.product?.id ?? itemnumberC.text,
        name: nameC.text,
        image: widget.product?.image ?? 'noImage',
        description: descriptionC.text,
        categoryId: selectedCategoryId,
        enabled: true,
        price: priceC.text,
        views: 0,
        deleted: widget.product?.deleted ?? false,
        restaurantId: context.read<FirebaseUser>().uid,
        positionInCategory: widget.product?.positionInCategory ?? 0,
        menuId: selectedMenuId,
        abv: abv.text,
        body: body.text,
        brand: brand.text,
        countryState: countryState.text,
        region: region.text,
        sku: sku.text,
        taste: taste.text,
        type: type.text,
        varietal: varietal.text,
        inventory: [
          {"typeBottles": bottleType, "quantity": quantity.text}
        ]);
    await EasyLoading.show(status: '');
    if (widget.product != null) {
      await bloc.updateProduct(finalProduct, mYimage);
      msg = 'update';
    } else {
      await bloc.addProduct(finalProduct, mYimage);
      msg = 'create';
    }
    Navigator.of(context).pop(msg);
    await EasyLoading.dismiss();
  }
}
