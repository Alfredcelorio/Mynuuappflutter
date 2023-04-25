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
import 'package:project1/menu_management/pages/guest_likedItem_preview.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LikeItemsClass extends StatelessWidget {
  const LikeItemsClass({Key? key}) : super(key: key);

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
        body: BodyLikesItems());
  }
}

class BodyLikesItems extends StatelessWidget {
  TextEditingController searchController = TextEditingController();
  BodyLikesItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likeProvider = context.watch<LikesProvider>();
    final providerR = context.read<Providers>();
    return ListView(
      padding: const EdgeInsets.only(top: 5),
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/icons/stars.png',
                  height: 28,
                  width: 28,
                ),
                const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Favorites',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Metropolis',
                          color: Color.fromRGBO(218, 218, 218, 1),
                          fontSize: 32),
                    )),
              ],
            )),
        const SizedBox(height: 11),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            height: 35,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 255, 255, 0.12),
            ),
            child: TextFormField(
              controller: searchController,
              textAlign: TextAlign.end,
              cursorColor: Colors.white,
              maxLines: 1,
              style: const TextStyle(color: Colors.white),
              onChanged: (v) {
                likeProvider.notify();
              },
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                    color: Color.fromRGBO(205, 211, 214, 1),
                  ),
                ),
                hintText: "Search Here",
                hintStyle: const TextStyle(
                    fontFamily: 'Metropolis',
                    color: Color.fromRGBO(205, 211, 214, 1)),
                contentPadding: EdgeInsets.only(bottom: 1.w, left: 3.w),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        if (likeProvider.prods.isEmpty)
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Center(
                child: Text(
                  'No liked items yet',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Metropolis',
                      color: Color.fromRGBO(218, 218, 218, 1),
                      fontSize: 20),
                ),
              )),
        if (likeProvider.prods.isNotEmpty)
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: _buildTableBody(
                  likeProvider.prods.reversed.toList(), context)),
        const SizedBox(height: 40),
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

  Widget _buildTableBody(List<Product> prods, BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _buildTableRows(
        prods
            .where(
              (element) =>
                  element.name.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      ) ||
                  element.description.toLowerCase().contains(
                        searchController.text.toLowerCase(),
                      ),
            )
            .toList(),
        context,
      ),
    );
  }

  TableRow _buildSpacerRow() {
    return const TableRow(
      children: [
        SizedBox(
          height: 0,
        ),
      ],
    );
  }

  List<TableRow> _buildTableRows(List<Product> prods, BuildContext context) {
    List<TableRow> rows = [];
    for (var prod in prods) {
      rows.add(
        _buildTableRow(context, prod),
      );
    }
    return rows;
  }

  TableRow _buildTableRow(BuildContext context, Product prod) {
    final providerR = context.read<Providers>();
    final likeProvider = context.watch<LikesProvider>();
    return TableRow(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A).withOpacity(.5),
          borderRadius: BorderRadius.circular(10),
        ),
        children: [
          TableRowInkWell(
              onTap: () async {
                await likeProvider.getNameCategory(prod.categoryId);
                likeProvider.changeProduct(prod);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LikeItemPreviewClass(),
                  ),
                );
              },
              child: Card(
                color: Color.fromRGBO(255, 255, 255, 0.05),
                child: SizedBox(
                  height: 140,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 40.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/icons/heart.png',
                                  height: 20,
                                  width: 20,
                                  color: Color.fromRGBO(226, 226, 226, 1),
                                ),
                                Text(
                                  prod.name.toUpperCase(),
                                  style: const TextStyle(
                                      overflow: TextOverflow.clip,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Metropolis',
                                      color: Color.fromRGBO(242, 242, 242, 1),
                                      fontSize: 13),
                                ),
                                Text(
                                  prod.description.toUpperCase(),
                                  style: const TextStyle(
                                      overflow: TextOverflow.clip,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Metropolis',
                                      color: Color.fromRGBO(242, 242, 242, 1),
                                      fontSize: 10),
                                ),
                                Text(
                                  '\$${prod.price.toString()}',
                                  style: const TextStyle(
                                      overflow: TextOverflow.clip,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Metropolis',
                                      color: Color.fromRGBO(205, 211, 214, 1),
                                      fontSize: 24),
                                )
                              ],
                            ),
                          ),
                          kIsWeb
                              ? Image.network(
                                  prod.image,
                                  width: 50,
                                  height: 50,
                                )
                              : CachedNetworkImage(
                                  width: 25.w,
                                  height: 95.w,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  imageUrl: prod.image,
                                  errorWidget: (context, url, error) {
                                    return Center(
                                      child: Text(
                                        error.toString(),
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    );
                                  },
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
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
                        ],
                      )),
                ),
              )),
        ]);
  }
}
