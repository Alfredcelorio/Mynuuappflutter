import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project1/common/models/category.dart';
import 'package:project1/common/models/product.dart';
import 'package:project1/common/models/user_system.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/common/utils/debounce.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:project1/menu_management/components/add_category_dialog.dart';
import 'package:project1/menu_management/components/add_menu_dialog.dart';
import 'package:project1/menu_management/components/add_product_dialog.dart';
import 'package:project1/menu_management/components/deactivate_action_sheet.dart';
import 'package:project1/menu_management/components/product_options_sheet.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../authentication/blocs/authentication_bloc.dart';

class TabsLayout extends StatefulWidget {
  final int? previousTab;
  final int? initalTab;
  const TabsLayout({Key? key, this.previousTab, this.initalTab})
      : super(key: key);

  @override
  State<TabsLayout> createState() => _TabsLayoutState();
}

class _TabsLayoutState extends State<TabsLayout> {
  late final TableLayoutBloc bloc = context.read<TableLayoutBloc>();
  TextEditingController searchC = TextEditingController();

  List<Product> filteredProducts = [];

  late final userSession = context.read<FirebaseUser>();

  int? tabBarIndex;

  final Debounce _debounce = Debounce(
    const Duration(
      milliseconds: 100,
    ),
  );

  List<Product> _productList = <Product>[];

  final borderColor = const Color(0xFF646464);

  final fontFamily = GoogleFonts.georama().fontFamily;

  @override
  void initState() {
    tabBarIndex = widget.initalTab ?? 0;
    super.initState();
  }

  String searchText = "";
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthenticationBLoc>();
    final String role = authProvider.idsR.value.first['rol'] as String;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF171717),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: StreamBuilder<List<ProductCategory>>(
          stream: bloc.streamCategories(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              // return const Center(
              //   child: CircularProgressIndicator(color: Colors.white),
              // );
              EasyLoading.show(status: '');
              return Center();
            }
            EasyLoading.dismiss();
            final categories = snapshot.data ?? [];

            categories.sort(
              (a, b) => (a.position).compareTo(b.position),
            );

            return DefaultTabController(
              length: categories.length,
              initialIndex: widget.initalTab ?? 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      buildBackIconButton(context),
                      Expanded(
                        child: buildSearchOptions(context),
                      ),
                    ],
                  ),
                  if (searchC.text.isEmpty)
                    buildCategoriesTabBar(
                      context,
                      categories: categories,
                    ),
                  if (categories.isNotEmpty && searchC.text.isEmpty)
                    buildProductList(
                      context,
                      categoryId: categories[tabBarIndex!].id,
                      categories: categories,
                    ),
                  if (searchC.text.isNotEmpty)
                    _buildFilteredProductsTable(categories, context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildBackIconButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_back,
            color: borderColor,
          ),
        ),
      ),
    );
  }

  Widget _buildFilteredProductsTable(
      List<ProductCategory> categories, BuildContext context) {
    final authProvider = context.read<AuthenticationBLoc>();
    final String role = authProvider.idsR.value.first['rol'] as String;
    List<String> filteredCategories = [];
    for (final pro in filteredProducts) {
      if (!filteredCategories.contains(pro.categoryId)) {
        filteredCategories.add(pro.categoryId);
      }
    }
    return Expanded(
      child: ListView(
        children: [
          buildTableHeader(),
          ...categories
              .where(
                (element) => filteredCategories.contains(element.id),
              )
              .map(
                (category) => ListTileTheme(
                  dense: true,
                  child: ExpansionTile(
                    iconColor: Colors.white,
                    collapsedBackgroundColor: Colors.black,
                    collapsedIconColor: Colors.white,
                    title: Text(
                      category.name,
                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    ),
                    initiallyExpanded: true,
                    children: filteredProducts
                        .where((element) => element.categoryId == category.id)
                        .map(
                          (product) => buildTableRow(
                              product: product,
                              onRowTap: () {
                                if (role != 'Staff') {
                                  openProductOptionsDialog(
                                    context,
                                    categories: categories,
                                    categoryId: category.id,
                                    pro: product,
                                  );
                                }
                              }),
                        )
                        .toList(),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget buildTableHeader() {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            tableHeader("Pictures", isHeader: true),
            tableHeader("Name", isHeader: true),
            tableHeader("Description", isHeader: true),
            tableHeader("Price", isHeader: true),
            tableHeader("Access", isHeader: true),
          ],
        ),
      ],
    );
  }

  Widget buildCategoriesTabBar(
    BuildContext context, {
    required List<ProductCategory> categories,
  }) {
    return SizedBox(
      height: 36,
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              onTap: (v) {
                setState(() {
                  searchC.clear();
                  tabBarIndex = v;
                });
              },
              isScrollable: true,
              indicator: const BoxDecoration(
                color: Colors.black,
              ),
              tabs: categories.map((e) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.name.toString(),
                      style: categories[tabBarIndex!].id == e.id
                          ? TextStyle(
                              fontFamily: fontFamily,
                              color: mynuuYellow,
                              fontSize: 16,
                            )
                          : TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 16,
                            ),
                    ),
                    categories[tabBarIndex!].id == e.id
                        ? buildCategoryHeaderOptions(context, e)
                        : const SizedBox()
                  ],
                );
              }).toList(),
            ),
          ),
          buildAddNewCategory(context)
        ],
      ),
    );
  }

  Widget buildAddNewCategory(BuildContext context) {
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      onSelected: (value) async {
        if (value == 0) {
          final result = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return MultiProvider(
                providers: [
                  Provider.value(value: userSession),
                  Provider.value(value: bloc),
                ],
                child: const AddOrUpdateMenuDialog(),
              );
            },
          );
          if (result != null) {
            showToast('Menu created');
          }
        }

        if (value == 1) {
          final value = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return MultiProvider(
                providers: [
                  Provider.value(value: userSession),
                  Provider.value(value: bloc),
                ],
                child: const AddOrUpdateCategoryDialog(),
              );
            },
          );
          if (value == 'create') {
            showToast('Category created');
          }
        }
      },
      color: const Color(0xFF1A1A1A),
      icon: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
          ),
        ),
        child: Icon(
          Icons.add,
          size: 16,
          color: borderColor,
        ),
      ),
      itemBuilder: (context) {
        return const [
          PopupMenuItem(
            value: 0,
            child: Text(
              "Menu Group",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          PopupMenuItem(
            value: 1,
            child: Text(
              "Sub Category",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ];
      },
    );
  }

  Widget buildCategoryHeaderOptions(
      BuildContext context, ProductCategory category) {
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
      onSelected: (value) async {
        if (value == 0) {
          final value = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return MultiProvider(
                providers: [
                  Provider.value(value: userSession),
                  Provider.value(value: bloc),
                ],
                child: AddOrUpdateCategoryDialog(
                  category: category,
                ),
              );
            },
          );
          print(value);
          if (value == 'update') {
            showToast('Changes saved');
          }
        }

        if (value == 1) {
          await bloc.deleteCategory(category.id);
          showToast('Category deleted');
        }
      },
      position: PopupMenuPosition.under,
      color: const Color(0xff1A1A1A),
      icon: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Icon(
            Icons.more_vert,
            size: 16,
            color: borderColor,
          )),
      itemBuilder: (context) {
        return const [
          PopupMenuItem<int>(
            value: 0,
            child: Text(
              "Edit",
              style: TextStyle(color: Colors.white),
            ),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Text(
              "Delete",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ];
      },
    );
  }

  Widget buildProductList(
    BuildContext context, {
    required String categoryId,
    required List<ProductCategory> categories,
  }) {
    final authProvider = context.read<AuthenticationBLoc>();
    final String role = authProvider.idsR.value.first['rol'] as String;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 2.w, bottom: 2.w),
        child: StreamBuilder<List<Product>>(
          stream: bloc.streamProductByCategory(
              categoryId), // .getProductsByCategory(categoryId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              EasyLoading.show(status: '');
              return Center();
            }
            EasyLoading.dismiss();
            _productList = snapshot.data!;

            if (_productList.isEmpty) {
              return Column(
                children: [
                  buildAddNewEntry(
                    context,
                    categoryId: categoryId,
                    categories: categories,
                  ),
                  // const Center(
                  //   key: ValueKey('new_entry'),
                  //   child: Text(
                  //     "Add new item",
                  //     style: TextStyle(color: Colors.white),
                  //   ),
                  // )
                ],
              );
            }

            _productList.sort((a, b) =>
                (a.positionInCategory).compareTo(b.positionInCategory));

            return ReorderableListView(
                header: buildTableHeader(),
                onReorder: (int oldIndex, int newIndex) {
                  // In order to avoid moving the object under the plus button
                  if (newIndex > _productList.length) return;

                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final Product item = _productList.removeAt(oldIndex);
                  _productList.insert(newIndex, item);

                  // Update position for all products
                  int i = 0;
                  for (var product in _productList) {
                    product.positionInCategory = i;
                    i++;
                  }

                  // Update products in firestore and update UI
                  bloc
                      .updateProducts(_productList)
                      .then((value) => setState(() {
                            _productList = _productList;
                          }));
                },
                children: [
                  ..._productList
                      .map(
                        (pro) => buildTableRow(
                            product: pro,
                            onRowTap: () {
                              if (role != 'Staff') {
                                openProductOptionsDialog(
                                  context,
                                  categories: categories,
                                  categoryId: categoryId,
                                  pro: pro,
                                );
                              }
                            }),
                      )
                      .toList(),
                  buildAddNewEntry(
                    context,
                    categoryId: categoryId,
                    categories: categories,
                  ),
                ]);
          },
        ),
      ),
    );
  }

  Padding buildTableRow({
    required product,
    required VoidCallback onRowTap,
  }) {
    return Padding(
      key: ValueKey(product),
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.2),
          borderRadius: BorderRadius.circular(6),
        ),
        child: InkWell(
          onTap: onRowTap,
          child: Row(
            children: [
              Expanded(
                child: _buildProductImage(product.image),
              ),
              Expanded(
                child: tableHeader(
                  product.name,
                ),
              ),
              Expanded(
                child: tableHeader(product.description),
              ),
              Expanded(
                child: tableHeader("\$${product.price}"),
              ),
              Expanded(
                child: _buildAccessStatus(context, product),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccessStatus(BuildContext context, Product pro) {
    final authProvider = context.read<AuthenticationBLoc>();
    final String role = authProvider.idsR.value.first['rol'] as String;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: role != 'Staff'
          ? GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => MultiProvider(
                    providers: [
                      Provider.value(value: userSession),
                      Provider.value(value: bloc),
                    ],
                    child: DeactivateActionSheet(
                      productResult: pro,
                      refresh: () => setState(() {
                        searchC.clear();
                      }),
                    ),
                  ),
                );
              },
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  border: Border.all(
                    color: mynuuYellow,
                  ),
                ),
                child: Icon(
                  Icons.circle,
                  color: pro.enabled ? Colors.green : Colors.red,
                  size: 3.w,
                ),
              ),
            )
          : Text(
              '--',
              style: TextStyle(color: Colors.white),
            ),
    );
  }

  Widget _buildProductImage(String imageUrl) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(6),
        bottomLeft: Radius.circular(6),
      ),
      child: Container(
        color: const Color(0xFFFAE7DD),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 56,
            maxWidth: 48,
          ),
          child: CachedNetworkImage(
            fit: BoxFit.contain,
            imageUrl: imageUrl,
            errorWidget: (context, url, error) {
              return Center(
                  child: Text(
                error.toString(),
                style: const TextStyle(color: Colors.red),
              ));
            },
            placeholder: (context, url) {
              return const Center(
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void openProductOptionsDialog(
    BuildContext context, {
    required Product pro,
    required List<ProductCategory> categories,
    required String categoryId,
  }) {
    print("dialog");
    showModalBottomSheet(
      context: context,
      builder: (context) => MultiProvider(
        providers: [
          Provider.value(value: userSession),
          Provider.value(value: bloc),
        ],
        child: ProductOptionsSheet(
          product: pro,
          categories: categories,
          currentCategoryId: categoryId,
        ),
      ),
    );
  }

  Widget buildAddNewEntry(
    BuildContext context, {
    required String categoryId,
    required List<ProductCategory> categories,
  }) {
    return Center(
      key: const ValueKey('buildAddNewEntry'),
      child: GestureDetector(
        onTap: () async {
          final value = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return MultiProvider(
                providers: [
                  Provider.value(value: userSession),
                  Provider.value(value: bloc),
                ],
                child: AddOrEditProductDialog(
                  category: categoryId,
                  availableCategories: categories,
                ),
              );
            },
          );
          if (value == 'create') {
            showToast('Item created');
          }
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
              border: Border.all(
                color: mynuuYellow,
              ),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 5.w,
                backgroundColor: mynuuBackground,
                child: const Icon(
                  Icons.add_circle_outline,
                  color: mynuuYellow,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                'Add New Item',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 50.w,
        height: 5.h,
        child: TextFormField(
          controller: searchC,
          cursorColor: Colors.white,
          maxLines: 1,
          style: TextStyle(color: borderColor, fontFamily: fontFamily),
          onChanged: (v) {
            _debounce(() {
              search();
              setState(() {});
            });
          },
          decoration: InputDecoration(
            prefixIcon: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: borderColor,
              ),
            ),
            hintText: "Search text",
            hintStyle: const TextStyle(
              color: Color(0xffb5b6b8),
            ),
            contentPadding: EdgeInsets.only(top: 1.w, left: 3.w),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget tableHeader(
    String data, {
    bool isHeader = false,
  }) {
    var text = Text(
      data.toString(),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: isHeader ? 12 : 10,
        fontWeight: isHeader ? FontWeight.bold : FontWeight.w300,
        fontFamily: fontFamily,
        color: Colors.white,
      ),
    );
    return isHeader
        ? Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: text,
          )
        : text;
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromRGBO(254, 253, 253, 0.1),
        textColor: Color.fromRGBO(254, 253, 253, 1));
  }

  void search() async {
    final searchText = searchC.text;
    if (searchText.isNotEmpty) {
      final userSession = context.read<FirebaseUser>();
      filteredProducts = await bloc.searchProducts(userSession.uid, searchText);
    }
  }
}
