import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project1/common/models/product.dart';
import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

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
  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    const value = 400;
    // TamaÃ±os ajustables de widgets
    final isIpad = (mediaSize.width < value);
    final valuePadding = mediaSize.width < value ? 0.0 : 80.0;
    return Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isIpad)
                Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                      top: 8,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          product.name.toUpperCase(),
                          softWrap: true,
                          style: const TextStyle(
                            fontFamily: 'Metropolis',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isIpad) Expanded(child: buildProductImage()),
                  if (!isIpad)
                    SizedBox(
                      width: 200,
                      height: 300,
                      child: buildProductImage(),
                    )
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              buildProductInformation(context),
            ],
          ),
        ));
  }

  Widget buildProductInformation(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    const value = 400;
    // TamaÃ±os ajustables de widgets
    final isIpad = (mediaSize.width < value);
    final valuePadding = mediaSize.width < value ? 0.0 : 80.0;
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
        top: 8,
      ),
      child: Center(
        child: Column(
          crossAxisAlignment:
              isIpad ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isIpad)
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Text(
                  product.name.toUpperCase(),
                  softWrap: true,
                  style: const TextStyle(
                    fontFamily: 'Metropolis',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            const SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: ReadMoreText(
                product.description.toUpperCase(),
                trimLines: 1,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' ',
                trimExpandedText: '',
                colorClickableText: Colors.white,
                style: const TextStyle(
                    fontFamily: 'Metropolis',
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 10),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            if (!isIpad)
              const SizedBox(
                width: 250,
                child: Divider(
                  height: 10,
                  color: Colors.white,
                ),
              ),
            if (!isIpad)
              const SizedBox(
                height: 4,
              ),
            Row(
              mainAxisAlignment: isIpad
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                Text(
                  product.price.toStringAsFixed(1) + ' USD',
                  style: const TextStyle(
                    fontFamily: 'Metropolis',
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (!kIsWeb) buildShareButton(context)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductImage() {
    return kIsWeb
        ? Image.network(
            product.image,
            height: 300,
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            fit: BoxFit.cover,
            height: 580,
            imageUrl: product.image,
            errorWidget: (context, url, error) {
              return Center(
                child: Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.red),
                ),
              );
            },
            placeholder: (context, url) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            },
          );
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
