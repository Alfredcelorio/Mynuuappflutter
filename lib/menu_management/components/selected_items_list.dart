import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:project1/common/models/selected_item.dart';
import 'package:project1/common/services/providers.dart';
import 'package:project1/menu_management/blocs/table_layout_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SelectedItemsList extends StatelessWidget {
  final String guestId;

  const SelectedItemsList({
    Key? key,
    required this.guestId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final providerR = context.read<Providers>();
    TableLayoutBloc bloc = context.read<TableLayoutBloc>();

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
                  'Selected Items',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Metropolis',
                    color: Color.fromRGBO(218, 218, 218, 1),
                    fontSize: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 11),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: FutureBuilder<List<SelectedItem>>(
            future: bloc.getGuestSelectedProducts(guestId),
            builder: (context, snapshot) {
              final items = snapshot.data;

              if (snapshot.connectionState == ConnectionState.waiting) {
                EasyLoading.show(status: '');
                return const Center();
              }

              if (snapshot.connectionState == ConnectionState.done) {
                EasyLoading.dismiss();
              }

              if (items == null) {
                return const Center(
                  child: Text(
                    "No selected items yet",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              if ((items.isEmpty)) {
                return const Center(
                  child: Text(
                    "No products yet",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              var total = 0.0;

              for (var element in items) {
                total += element.quantity * int.parse(element.price);
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      bottom: 5,
                    ),
                    child: Row(
                      children: [
                        const Text(
                          "Subtotal: ",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Metropolis',
                            color: Color.fromRGBO(218, 218, 218, 1),
                            fontSize: 26,
                          ),
                        ),
                        Text(
                          total.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Metropolis',
                            color: Color.fromRGBO(218, 218, 218, 1),
                            fontSize: 26,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildTableBody(
                    items,
                    context,
                  )
                ],
              );
            },
          ),
        ),
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
                                  const BorderRadius.all(Radius.circular(10)),
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
                  color: const Color.fromRGBO(190, 190, 190, 1),
                ),
                Image.asset(
                  'assets/icons/ig.png',
                  height: 20,
                  width: 20,
                  color: const Color.fromRGBO(190, 190, 190, 1),
                ),
                Image.asset(
                  'assets/icons/fb.png',
                  height: 20,
                  width: 20,
                  color: const Color.fromRGBO(190, 190, 190, 1),
                ),
                Image.asset(
                  'assets/icons/twitter.png',
                  height: 20,
                  width: 20,
                  color: const Color.fromRGBO(190, 190, 190, 1),
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

  Widget _buildTableBody(List<SelectedItem> prods, BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: _buildTableRows(
        prods,
        context,
      ),
    );
  }

  List<TableRow> _buildTableRows(
      List<SelectedItem> prods, BuildContext context) {
    List<TableRow> rows = [];
    for (var prod in prods) {
      rows.add(
        _buildTableRow(context, prod),
      );
    }
    return rows;
  }

  TableRow _buildTableRow(BuildContext context, SelectedItem prod) {
    return TableRow(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A).withOpacity(.5),
        borderRadius: BorderRadius.circular(10),
      ),
      children: [
        TableRowInkWell(
          child: Card(
            color: const Color.fromRGBO(255, 255, 255, 0.05),
            child: SizedBox(
              height: 140,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 40.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 30.w,
                                child: Text(
                                  prod.name.toUpperCase(),
                                  style: const TextStyle(
                                    overflow: TextOverflow.clip,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Metropolis',
                                    color: Color.fromRGBO(242, 242, 242, 1),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Text(
                                "* ${prod.quantity.toString()}",
                                style: const TextStyle(
                                  overflow: TextOverflow.clip,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Metropolis',
                                  color: Color.fromRGBO(242, 242, 242, 1),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          if (prod.description.length < 140)
                            Text(
                              prod.description.toUpperCase(),
                              style: const TextStyle(
                                  overflow: TextOverflow.clip,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Metropolis',
                                  color: Color.fromRGBO(242, 242, 242, 1),
                                  fontSize: 10),
                            ),
                          if (prod.description.length > 140)
                            Expanded(
                              flex: 1,
                              child: SingleChildScrollView(
                                child: Text(
                                  prod.description.toUpperCase(),
                                  style: const TextStyle(
                                      overflow: TextOverflow.clip,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Metropolis',
                                      color: Color.fromRGBO(242, 242, 242, 1),
                                      fontSize: 10),
                                ),
                              ),
                            ),
                          Text(
                            '\$${int.parse(prod.price) * prod.quantity}',
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
