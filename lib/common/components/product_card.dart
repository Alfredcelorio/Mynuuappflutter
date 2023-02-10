import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project1/common/models/product.dart';
import 'package:project1/common/models/restaurant.dart';
import 'package:project1/common/services/providers.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
    required this.shortUrl,
    required this.productIndex,
    required this.r,
  }) : super(key: key);

  final Product product;
  final String shortUrl;
  final int productIndex;
  final Restaurant r;
  @override
  Widget build(BuildContext context) {
    final providerR = context.watch<Providers>();
    return Padding(
      padding: EdgeInsets.only(left: 1.w, right: 1.w),
      child: InkWell(
        onTap: () {
          providerR.changeR(r);
          GoRouter.of(context).push(
            '/$shortUrl/menu/${product.categoryId}/${product.id}/$productIndex',
            extra: {
              "comesFromDirectLink": false,
            },
          );
        },
        child: SizedBox(
          width: 185,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: buildProductImage()),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16,
                  top: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductImage() {
    return kIsWeb
        ? Image.network(
            product.image,
            width: 185,
            height: 282,
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            width: 185,
            height: 282,
            fit: BoxFit.cover,
            imageUrl: product.image,
            errorWidget: (context, url, error) {
              return Center(
                  child: Text(
                error.toString(),
                style: const TextStyle(color: Colors.red),
              ));
            },
            placeholder: (context, url) {
              return buildLoadingImageSkeleton();
            },
          );
  }

  Widget buildLoadingImageSkeleton() {
    return Shimmer.fromColors(
      baseColor: mynuuBlack,
      highlightColor: Colors.grey,
      child: SizedBox(
        width: 185,
        height: 282,
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}
