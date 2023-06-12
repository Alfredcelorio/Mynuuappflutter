import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project1/common/services/providers.dart';
import 'package:project1/menu_management/components/selected_items_list.dart';
import 'package:provider/provider.dart';

class GuestSelectedItems extends StatelessWidget {
  final String guestId;

  const GuestSelectedItems({super.key, required this.guestId});

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
                padding: const EdgeInsets.only(left: 5),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.chevron_left_sharp,
                      size: 35, color: Color.fromRGBO(255, 255, 255, 0.7)),
                )),
            Padding(
              padding: const EdgeInsets.only(right: 20),
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
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
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
      body: SelectedItemsList(guestId: guestId),
    );
  }
}
