import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:project1/authentication/components/footer.dart';
import 'package:project1/common/models/guest.dart';
import 'package:project1/common/models/product.dart';
import 'package:project1/common/services/landing_service.dart';
import 'package:project1/common/services/likesProvider.dart';
import 'package:project1/common/services/providers.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LikeItemPreviewClass extends StatelessWidget {
  const LikeItemPreviewClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerR = context.read<Providers>();
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
          automaticallyImplyLeading: false, // Don't show the leading button
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.chevron_left_sharp,
                        size: 35, color: Color.fromRGBO(255, 255, 255, 0.7)),
                  )),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: ClipOval(
                  child: kIsWeb
                      ? Image.network(
                          providerR.r.logo,
                          width: 40,
                          height: 50,
                        )
                      : CachedNetworkImage(
                          width: 60,
                          height: 50,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          imageUrl: providerR.r.logo,
                          errorWidget: (context, url, error) {
                            return Center(
                              child: Text(
                                error.toString(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          },
                          imageBuilder: (context, imageProvider) => Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
        body: BodyLikeItemPreview());
  }
}

class BodyLikeItemPreview extends StatelessWidget {
  TextEditingController searchController = TextEditingController();
  BodyLikeItemPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likeProvider = context.watch<LikesProvider>();
    final providerR = context.read<Providers>();
    return ListView(
      padding: const EdgeInsets.only(top: 5),
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              likeProvider.nameCategory,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Metropolis',
                  color: Color.fromRGBO(218, 218, 218, 1),
                  fontSize: 32),
            )),
        const SizedBox(
          height: 10,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Card(
                color: Color.fromRGBO(255, 255, 255, 0.05),
                child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: SizedBox(
                      height: 65.w,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                kIsWeb
                                    ? Image.network(
                                        likeProvider.product!.image,
                                        width: 50,
                                        height: 20.w,
                                      )
                                    : CachedNetworkImage(
                                        width: 20.w,
                                        height: 20.w,
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                        imageUrl: likeProvider.product!.image,
                                        errorWidget: (context, url, error) {
                                          return Center(
                                            child: Text(
                                              error.toString(),
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                          );
                                        },
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                kIsWeb
                                    ? Image.network(
                                        likeProvider.product!.image,
                                        width: 50,
                                        height: 50,
                                      )
                                    : CachedNetworkImage(
                                        width: 20.w,
                                        height: 20.w,
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                        imageUrl: likeProvider.product!.image,
                                        errorWidget: (context, url, error) {
                                          return Center(
                                            child: Text(
                                              error.toString(),
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                          );
                                        },
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                kIsWeb
                                    ? Image.network(
                                        likeProvider.product!.image,
                                        width: 50,
                                        height: 50,
                                      )
                                    : CachedNetworkImage(
                                        width: 20.w,
                                        height: 20.w,
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.high,
                                        imageUrl: likeProvider.product!.image,
                                        errorWidget: (context, url, error) {
                                          return Center(
                                            child: Text(
                                              error.toString(),
                                              style: const TextStyle(
                                                  color: Colors.red),
                                            ),
                                          );
                                        },
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                            kIsWeb
                                ? Image.network(
                                    likeProvider.product!.image,
                                    width: 50,
                                    height: 50,
                                  )
                                : CachedNetworkImage(
                                    width: 55.w,
                                    height: 75.w,
                                    fit: BoxFit.cover,
                                    filterQuality: FilterQuality.high,
                                    imageUrl: likeProvider.product!.image,
                                    errorWidget: (context, url, error) {
                                      return Center(
                                        child: Text(
                                          error.toString(),
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      );
                                    },
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                          ]),
                    )))),
        const SizedBox(
          height: 15,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              likeProvider.product!.name,
              style: const TextStyle(
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Metropolis',
                  color: Color.fromRGBO(218, 218, 218, 1),
                  fontSize: 32),
            )),
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
                  fontSize: 16),
            )),
        const SizedBox(
          height: 15,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              likeProvider.product!.description,
              style: const TextStyle(
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Metropolis',
                  color: Color.fromRGBO(185, 185, 185, 1),
                  fontSize: 16),
            )),
        const SizedBox(
          height: 15,
        ),
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
                Text(
                  likeProvider.product!.brand!,
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(242, 242, 242, 1),
                      fontSize: 16),
                )
              ],
            )),
        const SizedBox(
          height: 7,
        ),
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
                Text(
                  likeProvider.product!.countryState!,
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(242, 242, 242, 1),
                      fontSize: 16),
                )
              ],
            )),
        const SizedBox(
          height: 7,
        ),
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
                Text(
                  likeProvider.product!.region!,
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(242, 242, 242, 1),
                      fontSize: 16),
                )
              ],
            )),
        const SizedBox(
          height: 7,
        ),
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
                Text(
                  likeProvider.product!.type!,
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(242, 242, 242, 1),
                      fontSize: 16),
                )
              ],
            )),
        const SizedBox(
          height: 7,
        ),
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
                Text(
                  likeProvider.product!.varietal!,
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(242, 242, 242, 1),
                      fontSize: 16),
                )
              ],
            )),
        const SizedBox(
          height: 7,
        ),
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
                Text(
                  likeProvider.product!.abv!,
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(242, 242, 242, 1),
                      fontSize: 16),
                )
              ],
            )),
        const SizedBox(
          height: 7,
        ),
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
                Text(
                  likeProvider.product!.taste!,
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(242, 242, 242, 1),
                      fontSize: 16),
                )
              ],
            )),
        const SizedBox(
          height: 12,
        ),
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
                Text(
                  likeProvider.product!.body!,
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(242, 242, 242, 1),
                      fontSize: 16),
                )
              ],
            )),
        const SizedBox(
          height: 7,
        ),
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
                Text(
                  likeProvider.product!.sku!,
                  style: const TextStyle(
                      overflow: TextOverflow.clip,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(242, 242, 242, 1),
                      fontSize: 16),
                )
              ],
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
                '\$${likeProvider.product!.price}',
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
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipOval(
                  child: kIsWeb
                      ? Image.network(
                          providerR.r.logo,
                          width: 50,
                          height: 50,
                        )
                      : CachedNetworkImage(
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          imageUrl: providerR.r.logo,
                          errorWidget: (context, url, error) {
                            return Center(
                              child: Text(
                                error.toString(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          },
                          imageBuilder: (context, imageProvider) => Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                ),
                Image.asset(
                  'assets/icons/oval.png',
                  height: 20,
                  width: 20,
                  color: Color.fromRGBO(190, 190, 190, 1),
                ),
                Image.asset(
                  'assets/icons/ig.png',
                  height: 20,
                  width: 20,
                  color: Color.fromRGBO(190, 190, 190, 1),
                ),
                Image.asset(
                  'assets/icons/fb.png',
                  height: 20,
                  width: 20,
                  color: Color.fromRGBO(190, 190, 190, 1),
                ),
                Image.asset(
                  'assets/icons/twitter.png',
                  height: 20,
                  width: 20,
                  color: Color.fromRGBO(190, 190, 190, 1),
                ),
              ],
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
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            width: 100.w,
            color: Colors.black,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
      ],
    );
  }
}
