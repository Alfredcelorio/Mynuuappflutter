import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project1/common/models/product.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../services/likesProvider.dart';

class ProductExtendedCard extends StatelessWidget {
  ProductExtendedCard({
    Key? key,
    required this.product,
    required this.categoryId,
    required this.restaurantShortUrl,
    required this.length,
    this.comesFromDirectLink = false,
  }) : super(key: key);

  final Product product;
  final String? categoryId;
  final String restaurantShortUrl;
  final bool comesFromDirectLink;
  final int length;

  final customGray = const Color(0xFF222222).withOpacity(.56);

  String getProductServingType(List<dynamic>? inventory) {
    if (inventory == null) return "";
    if (inventory.isEmpty) return "";

    final serving = inventory[0];

    return "${serving["quantity"]} ${serving["typeBottles"]} left";
  }

  @override
  Widget build(BuildContext context) {
    // TamaÃ±os ajustables de widgets
    final likeProvider = context.watch<LikesProvider>();

    return ListView(padding: const EdgeInsets.only(top: 5), children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          likeProvider.nameCategory,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Metropolis',
            color: Color.fromRGBO(218, 218, 218, 1),
            fontSize: 32,
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Card(
          color: const Color.fromRGBO(255, 255, 255, 0.05),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: 65.w,
              child: Center(
                child: kIsWeb
                    ? Image.network(
                        product.image,
                        width: 50,
                        height: 50,
                      )
                    : CachedNetworkImage(
                        width: 45.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        imageUrl: product.image,
                        errorWidget: (context, url, error) {
                          return Center(
                            child: Text(
                              error.toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        },
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          product.name,
          style: const TextStyle(
            overflow: TextOverflow.clip,
            fontWeight: FontWeight.w600,
            fontFamily: 'Metropolis',
            color: Color.fromRGBO(218, 218, 218, 1),
            fontSize: 32,
          ),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          'product information'.toUpperCase(),
          style: const TextStyle(
            overflow: TextOverflow.clip,
            fontWeight: FontWeight.w700,
            fontFamily: 'Metropolis',
            color: Color.fromRGBO(218, 218, 218, 1),
            fontSize: 16,
          ),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          product.description,
          style: const TextStyle(
            overflow: TextOverflow.clip,
            fontWeight: FontWeight.w600,
            fontFamily: 'Metropolis',
            color: Color.fromRGBO(185, 185, 185, 1),
            fontSize: 16,
          ),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          getProductServingType(product.inventory),
          style: const TextStyle(
            overflow: TextOverflow.clip,
            fontWeight: FontWeight.w600,
            fontFamily: 'Metropolis',
            color: Color.fromRGBO(185, 185, 185, 1),
            fontSize: 16,
          ),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      if (product.brand!.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'brand'.toUpperCase(),
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(185, 185, 185, 1),
                      fontSize: 16),
                ),
                SizedBox(
                  width: 40.w,
                  child: Text(
                    product.brand!,
                    style: const TextStyle(
                        overflow: TextOverflow.clip,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Metropolis',
                        color: Color.fromRGBO(242, 242, 242, 1),
                        fontSize: 16),
                  ),
                ),
              ],
            )),
      if (product.brand!.isNotEmpty)
        const SizedBox(
          height: 7,
        ),
      if (product.countryState!.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'country/state'.toUpperCase(),
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(185, 185, 185, 1),
                      fontSize: 16),
                ),
                SizedBox(
                    width: 40.w,
                    child: Text(
                      product.countryState!,
                      style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Metropolis',
                          color: Color.fromRGBO(242, 242, 242, 1),
                          fontSize: 16),
                    ))
              ],
            )),
      if (product.countryState!.isNotEmpty)
        const SizedBox(
          height: 7,
        ),
      if (product.region!.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'region'.toUpperCase(),
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(185, 185, 185, 1),
                      fontSize: 16),
                ),
                SizedBox(
                    width: 50.w,
                    child: Text(
                      product.region!,
                      style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Metropolis',
                          color: Color.fromRGBO(242, 242, 242, 1),
                          fontSize: 16),
                    ))
              ],
            )),
      if (product.region!.isNotEmpty)
        const SizedBox(
          height: 7,
        ),
      if (product.type!.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'wine type'.toUpperCase(),
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(185, 185, 185, 1),
                      fontSize: 16),
                ),
                SizedBox(
                    width: 50.w,
                    child: Text(
                      product.type!,
                      style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Metropolis',
                          color: Color.fromRGBO(242, 242, 242, 1),
                          fontSize: 16),
                    ))
              ],
            )),
      if (product.type!.isNotEmpty)
        const SizedBox(
          height: 7,
        ),
      if (product.varietal!.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'varietal'.toUpperCase(),
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(185, 185, 185, 1),
                      fontSize: 16),
                ),
                SizedBox(
                    width: 50.w,
                    child: Text(
                      product.varietal!,
                      style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Metropolis',
                          color: Color.fromRGBO(242, 242, 242, 1),
                          fontSize: 16),
                    ))
              ],
            )),
      if (product.varietal!.isNotEmpty)
        const SizedBox(
          height: 7,
        ),
      if (product.abv!.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'abv'.toUpperCase(),
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(185, 185, 185, 1),
                      fontSize: 16),
                ),
                SizedBox(
                    width: 50.w,
                    child: Text(
                      product.abv!,
                      style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Metropolis',
                          color: Color.fromRGBO(242, 242, 242, 1),
                          fontSize: 16),
                    ))
              ],
            )),
      if (product.abv!.isNotEmpty)
        const SizedBox(
          height: 7,
        ),
      if (product.taste!.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'taste'.toUpperCase(),
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(185, 185, 185, 1),
                      fontSize: 16),
                ),
                SizedBox(
                    width: 50.w,
                    child: Text(
                      product.taste!,
                      style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Metropolis',
                          color: Color.fromRGBO(242, 242, 242, 1),
                          fontSize: 16),
                    ))
              ],
            )),
      if (product.taste!.isNotEmpty)
        const SizedBox(
          height: 12,
        ),
      if (product.body!.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'body'.toUpperCase(),
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(185, 185, 185, 1),
                      fontSize: 16),
                ),
                SizedBox(
                    width: 50.w,
                    child: Text(
                      product.body!,
                      style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Metropolis',
                          color: Color.fromRGBO(242, 242, 242, 1),
                          fontSize: 16),
                    ))
              ],
            )),
      if (product.body!.isNotEmpty)
        const SizedBox(
          height: 7,
        ),
      if (product.sku!.isNotEmpty)
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'sku'.toUpperCase(),
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(185, 185, 185, 1),
                      fontSize: 16),
                ),
                SizedBox(
                    width: 50.w,
                    child: Text(
                      product.sku!,
                      style: const TextStyle(
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Metropolis',
                          color: Color.fromRGBO(242, 242, 242, 1),
                          fontSize: 16),
                    ))
              ],
            )),
      if (product.sku!.isNotEmpty)
        const SizedBox(
          height: 7,
        ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [buildShareButton(context)],
          )),
      const SizedBox(
        height: 7,
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Divider(
          color: Color.fromRGBO(255, 254, 254, 0.459),
        ),
      ),
      const SizedBox(
        height: 15,
      ),
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Text(
              '\$${product.price}',
              style: const TextStyle(
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Metropolis',
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 48),
            ),
          )),
      const SizedBox(
        height: 15,
      ),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Divider(
          color: Color.fromRGBO(255, 254, 254, 0.459),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 10),
          width: 100.w,
          color: Colors.black,
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'POWERED BY',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Color.fromRGBO(189, 189, 189, 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                width: 40.w,
                child: Image.asset(
                  "assets/icons/mynuuu.png",
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }

  Widget buildShareButton(BuildContext context) {
    return SizedBox(
      height: 20,
      child: IconButton(
        onPressed: () async {
          Share.share(//"Check this cool product that I found: " +
              "https://menu.mynuutheapp.com/#/$restaurantShortUrl/menu/$categoryId/${product.id}");
        },
        icon: const Icon(
          CupertinoIcons.share,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
