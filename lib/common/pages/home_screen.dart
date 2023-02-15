import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project1/common/blocs/home_bloc.dart';
import 'package:project1/common/components/categories_list_view.dart';
import 'package:project1/common/components/product_horizontal_list_skeleton.dart';
import 'package:project1/common/components/products_horizontal_list_view.dart';
import 'package:project1/common/components/sliver_app_delegate.dart';
import 'package:project1/common/components/top_navigation_menu.dart';
import 'package:project1/common/models/category.dart';
import 'package:project1/common/models/menu.dart';
import 'package:project1/common/models/product.dart';
import 'package:project1/common/models/restaurant.dart';
import 'package:project1/common/models/user_system.dart';
import 'package:project1/common/pages/restaurant_logo.dart';
import 'package:project1/common/utils/debounce.dart';
import 'package:project1/main.dart';
import 'package:project1/menu_management/pages/admin_screen.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../services/providers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.shortUrl,
    required this.firebaseUser,
  }) : super(key: key);

  final String shortUrl;
  final FirebaseUser firebaseUser;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String regards = '';
  HomeBloc homeBloc = HomeBloc();

  bool isThereACategorySelected = false;
  ProductCategory? selectedCategory;
  bool searchMode = false;
  List<Product> filteredProducts = [];
  String filter = '';
  bool showSearchResults = false;
  Restaurant restaurant = Restaurant(
      email: '',
      id: '',
      landingImage: '',
      logo: '',
      ownerName: '',
      restaurantName: '');

  String restaurantId = '';

  bool isVisibleTopMenu = false;
  final Debounce _debounce = Debounce(
    const Duration(milliseconds: 100),
  );

  Menu? selectedMenu;

  @override
  void initState() {
    int time = DateTime.now().hour;
    if (time < 12) {
      regards = "Good Morning";
    } else if (time < 18) {
      regards = "Good Afternoon";
    } else {
      regards = "Good Evening";
    }
    restaurantId = widget.firebaseUser.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    const value = 500;
    print(mediaSize.width);
    // TamaÃ±os ajustables de widgets
    final isIpad = (mediaSize.width < value);
    final valuePadding = mediaSize.width < value ? 0.0 : 80.0;
    return StreamBuilder<Restaurant>(
        stream: widget.firebaseUser.uid == 'notFound'
            ? homeBloc.streamRestaurantByShortUrl(widget.shortUrl)
            : homeBloc.streamRestaurantById(widget.firebaseUser.uid),
        initialData: Restaurant.empty(),
        builder: (context, snapshot) {
          final restaurant = snapshot.data;
          if (restaurant == null) {
            return _buildLoadindIndicator();
          }
          restaurantId = restaurant.id;
          return Scaffold(
            backgroundColor: restaurant.guestCheckInColor,
            body: Padding(
              padding: EdgeInsets.fromLTRB(valuePadding,
                  mediaSize.width < value ? 0.0 : 40.0, valuePadding, 0.0),
              child: Stack(
                children: [
                  _buildMainBody(restaurant, context),
                  _buildTopNavigationMenu(restaurant, context)
                ],
              ),
            ),
          );
        });
  }

  Widget _buildTopNavigationMenu(Restaurant r, BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: widget.firebaseUser),
        Provider.value(value: homeBloc),
      ],
      child: TopNavigationMenu(
        visible: isVisibleTopMenu,
        onClosed: () {
          setState(
            () {
              isVisibleTopMenu = false;
            },
          );
        },
        onMenuSelected: (menu) {
          setState(
            () {
              restaurant = r;
              selectedMenu = menu;
              isVisibleTopMenu = false;
              searchByMenuId(menu.id);
            },
          );
        },
        userSessionId: restaurantId,
      ),
    );
  }

  Widget _buildLoadindIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }

  SafeArea _buildMainBody(Restaurant restaurant, BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    const value = 500;
    // TamaÃ±os ajustables de widgets
    final isIpad = (mediaSize.width < value);
    final valuePadding = mediaSize.width < value ? 0.0 : 80.0;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              minHeight: 0,
              maxHeight: kIsWeb ? 200 : 160.0,
              child: MultiProvider(
                providers: [
                  Provider.value(value: widget.firebaseUser),
                  Provider.value(value: homeBloc),
                ],
                child: RestaurantLogo(
                  backgroundColor: restaurant.guestCheckInColor,
                  restaurant: restaurant,
                  opt: 1,
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              minHeight: 80.0,
              maxHeight: 80.0,
              child: _buildHomeOptions(restaurant.guestCheckInColor, isIpad),
            ),
          ),
          // if (isIpad)
          //   SliverPersistentHeader(
          //     pinned: true,
          //     delegate: SliverAppBarDelegate(
          //       minHeight: 60.0,
          //       maxHeight: 60.0,
          //       child: Provider.value(
          //         value: homeBloc,
          //         child: CategoriesListView(
          //           backgroundColor: restaurant.guestCheckInColor,
          //           selectedCategory: selectedCategory,
          //           userSessionId: restaurantId,
          //           onCategorySelected: (category) {
          //             setState(() {
          //               if (selectedCategory?.id == category.id) {
          //                 isThereACategorySelected = false;
          //               } else {
          //                 isThereACategorySelected = true;
          //               }
          //               selectedCategory = category;
          //               if (!isThereACategorySelected) {
          //                 selectedCategory = null;
          //               }
          //               filteredProducts = [];
          //               showSearchResults = false;
          //             });
          //           },
          //         ),
          //       ),
          //     ),
          //   ),
          showSearchResults
              ? _buildSearchResults()
              : isThereACategorySelected
                  ? SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          buildStreamProductCategoryList(
                              selectedCategory!,
                              this.restaurant.email.isEmpty
                                  ? restaurant
                                  : this.restaurant),
                        ],
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          StreamBuilder<List<ProductCategory>>(
                            stream: homeBloc.streamCategories(
                              restaurantId,
                              limit: 10,
                            ),
                            builder: (BuildContext context, snapshot) {
                              var categories = snapshot.data ?? [];
                              categories.sort(
                                (a, b) => (a.position).compareTo(
                                  b.position,
                                ),
                              );
                              return Column(
                                children: categories
                                    .map(
                                      (category) =>
                                          buildStreamProductCategoryList(
                                              category,
                                              this.restaurant.email.isEmpty
                                                  ? restaurant
                                                  : this.restaurant),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (filteredProducts.isEmpty) {
      return _buildNoResults();
    }
    List<String> filteredCategories = [];

    for (final pro in filteredProducts) {
      if (!filteredCategories.contains(pro.categoryId)) {
        filteredCategories.add(pro.categoryId);
      }
    }
    return StreamBuilder<List<ProductCategory>>(
      stream: homeBloc.streamCategories(restaurantId),
      builder: (context, snapshot) {
        final categories = snapshot.data;
        if (categories == null) {
          return const SliverToBoxAdapter(
            child: ProductsHorizontalListSkeleton(),
          );
        }
        return SliverList(
          delegate: SliverChildListDelegate(
            [
              Column(
                children: categories
                    .where(
                      (element) => filteredCategories.contains(element.id),
                    )
                    .map(
                      (category) => ProductsHorizontalListView(
                        products: filteredProducts
                            .where(
                              (element) => element.categoryId == category.id,
                            )
                            .toList(),
                        category: category,
                        shortUrl: widget.shortUrl,
                        rest: restaurant,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNoResults() {
    return SliverToBoxAdapter(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 175,
            ),
            Text(
              '(0) Results',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeOptions(Color backgroundColor, dynamic isIpad) {
    final isIpadvalue = isIpad as bool;
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.only(
          left: searchMode ? 0 : 20,
          right: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildRegardSearchTextFieldSwitch(widget.firebaseUser),
            Row(
              children: [
                if (!isIpadvalue)
                  FloatingActionButton.extended(
                    label: const Text('Search'), // <-- Text
                    backgroundColor: const Color(0xFF1E1E1E),
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      if (searchMode) {
                        searchByKeyword();
                      } else {
                        setState(() {
                          searchMode = true;
                        });
                      }
                    },
                  ),
                if (!isIpadvalue) const SizedBox(width: 10),
                if (isIpadvalue)
                  CircleAvatar(
                    backgroundColor: const Color(0xFF1E1E1E),
                    child: IconButton(
                      onPressed: () {
                        if (searchMode) {
                          searchByKeyword();
                        } else {
                          setState(() {
                            searchMode = true;
                          });
                        }
                      },
                      icon: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                if (!isIpadvalue)
                  FloatingActionButton.extended(
                    label: const Text('Menu'), // <-- Text
                    backgroundColor: const Color(0xFF1E1E1E),
                    icon: Image.asset(
                      'assets/icons/hamburguer.png',
                    ),
                    onPressed: () {
                      setState(() {
                        isVisibleTopMenu = !isVisibleTopMenu;
                      });
                    },
                  ),
                const SizedBox(width: 10),
                if (isIpadvalue)
                  CircleAvatar(
                    backgroundColor: const Color(0xFF1E1E1E),
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisibleTopMenu = !isVisibleTopMenu;
                        });
                      },
                      icon: const Icon(
                        Icons.filter_list_sharp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                if (!kIsWeb) _buildAdminOptions(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminOptions() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 10),
        CircleAvatar(
          backgroundColor: const Color(0xFF1E1E1E),
          child: IconButton(
            onPressed: () async {
              final currentRestaurant =
                  await homeBloc.getRestaurantById(restaurantId);
              Share.share(
                  "https://menu.mynuutheapp.com/#/${currentRestaurant.shortUrl}");
            },
            icon: const Icon(
              CupertinoIcons.share,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // InkWell(
        //   onTap: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context2) => Provider.value(
        //           value: widget.firebaseUser,
        //           child: const AdminScreen(),
        //         ),
        //       ),
        //     );
        //   },
        //   child: CircleAvatar(
        //     backgroundColor: const Color(0xFF1E1E1E),
        //     child: Image.asset(
        //       'assets/icons/hamburguer.png',
        //     ),
        //   ),
        // )
      ],
    );
  }

  Widget _buildRegardSearchTextFieldSwitch(FirebaseUser firebaseUser) {
    return Expanded(
      child: searchMode
          ? Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TextField(
                autofocus: true,
                cursorColor: Colors.white,
                style: const TextStyle(
                  color: Colors.white,
                ),
                onChanged: (value) {
                  _debounce(() {
                    filter = value;
                    searchByKeyword();
                    setState(() {});
                  });
                },
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        () {
                          searchMode = false;
                          showSearchResults = false;
                          filter = '';
                          filteredProducts = [];
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  hintText: 'Search',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  border: InputBorder.none,
                ),
              ),
            )
          : Text(
              regards.toString(),
              style: const TextStyle(
                fontFamily: 'Metropolis',
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Widget buildStreamProductCategoryList(
      ProductCategory category, Restaurant valueR) {
    print('valor: ${valueR}');
    return StreamBuilder<List<Product>>(
      stream: homeBloc.streamProductByCategory(category.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const ProductsHorizontalListSkeleton();
        }
        final products = snapshot.data!;
        if (products.isEmpty) {
          return isThereACategorySelected
              ? Column(
                  children: const [
                    SizedBox(
                      height: 175,
                    ),
                    Text(
                      '(0) Products',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              : const SizedBox();
        }
        products.sort(
          (a, b) => (a.positionInCategory).compareTo(
            b.positionInCategory,
          ),
        );
        return ProductsHorizontalListView(
          products: products,
          category: category,
          shortUrl: widget.shortUrl,
          rest: valueR,
        );
      },
    );
  }

  void searchByKeyword() async {
    final searchText = filter;
    if (searchText.isNotEmpty) {
      filteredProducts =
          await homeBloc.searchProducts(restaurantId, searchText);
      if (!recentSearches.contains(filter)) {
        recentSearches.add(filter);
      }
      setState(() {
        showSearchResults = true;
        selectedCategory = null;
      });
    }
  }

  void searchByMenuId(String menuId) async {
    filteredProducts =
        await homeBloc.searchProductsByMenuId(restaurantId, menuId);
    setState(() {
      showSearchResults = true;
      selectedCategory = null;
    });
  }
}
