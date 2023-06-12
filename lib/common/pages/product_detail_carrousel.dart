import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/common/pages/restaurant_logo.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:project1/common/blocs/product_detail_carrousel_bloc.dart';
import 'package:project1/common/components/product_extended_card.dart';
import 'package:project1/common/models/product.dart';
import 'package:project1/common/style/mynuu_colors.dart';

import '../services/providers.dart';

class ProductDetailScreen extends StatefulWidget {
  final String proId;
  final String categoryID;
  final String restaurantShortUrl;
  final bool comesFromDirectLink;

  const ProductDetailScreen({
    Key? key,
    required this.proId,
    required this.categoryID,
    required this.restaurantShortUrl,
    this.comesFromDirectLink = false,
  }) : super(key: key);
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? currentProductId;
  final customGray = const Color(0xFF222222).withOpacity(.56);
  String imageName = " ";

  ProductDetailCarrouselBloc bloc = ProductDetailCarrouselBloc();

  late PageController controller;

  @override
  void initState() {
    currentProductId = widget.proId;
    controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final providerR = context.watch<Providers>();
    final mediaSize = MediaQuery.of(context).size;
    const value = 400;
    // TamaÃ±os ajustables de widgets
    final isIpad = (mediaSize.width < value);
    final valuePadding = mediaSize.width < value ? 0.0 : 80.0;
    return Provider.value(
        value: bloc,
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(
                left: 30.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      if (!widget.comesFromDirectLink) {
                        Navigator.of(context).pop();
                      } else {
                        GoRouter.of(context)
                            .push('/$widget.restaurantShortUrl/menu');
                      }
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.black,
          body: StreamBuilder<List<Product>>(
            stream: providerR.valuePage == 0
                ? bloc.streamProductByCategory(widget.categoryID)
                : bloc.streamProductEnableFalseByCategory(widget.categoryID),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _buildLoadingSkeletons();
              }
              final products = snapshot.data ?? [];

              final product =
                  products.firstWhere((element) => element.id == widget.proId);
              products.removeWhere((element) => element.id == widget.proId);
              products.insert(0, product);
              return Container(
                width: 100.w,
                child: PageView(
                  controller: controller,
                  children: products
                      .map(
                        (e) => ProductExtendedCard(
                          product: e,
                          categoryId: widget.categoryID,
                          restaurantShortUrl: widget.restaurantShortUrl,
                          comesFromDirectLink: widget.comesFromDirectLink,
                          length: products.length,
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        ));
  }

  Shimmer _buildLoadingSkeletons() {
    return Shimmer.fromColors(
      baseColor: mynuuBlack,
      highlightColor: Colors.grey,
      child: Center(
        child: CarouselSlider(
          items: [
            for (var i = 0; i < 5; i++)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
          ],
          options: CarouselOptions(
            enableInfiniteScroll: false,
            viewportFraction: .9,
            height: 750,
          ),
        ),
      ),
    );
  }
}
