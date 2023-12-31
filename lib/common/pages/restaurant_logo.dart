import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project1/common/blocs/home_bloc.dart';
import 'package:project1/common/models/restaurant.dart';
import 'package:project1/common/models/user_system.dart';
import 'package:project1/common/services/providers.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/profile_management/pages/edit_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantLogo extends StatefulWidget {
  const RestaurantLogo({
    Key? key,
    required this.backgroundColor,
    required this.restaurant,
    required this.opt,
  }) : super(key: key);

  final Color backgroundColor;
  final Restaurant restaurant;
  final int opt;
  @override
  State<RestaurantLogo> createState() => _RestaurantLogoState();
}

class _RestaurantLogoState extends State<RestaurantLogo> {
  late final userSession = context.read<FirebaseUser>();
  late final homeBloc = context.read<HomeBloc>();
  late final restau = context.read<Providers>();
  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    const value = 500;
    // TamaÃ±os ajustables de widgets
    final isIpad = (mediaSize.width < value);
    final valuePadding = mediaSize.width < value ? 0.0 : 80.0;

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80), color: Colors.black),
      child: GestureDetector(
        onTap: () async {
          restau.changeR(widget.restaurant);
          // Manage edit logo.
          if (!kIsWeb && widget.opt == 1) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Provider.value(
                  value: userSession,
                  child: const EditProfileScreen(),
                ),
              ),
            );
          }
        },
        child: widget.restaurant.logo.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                    ),
                  ),
                ),
              )
            : Center(
                child: ClipOval(
                  child: kIsWeb
                      ? Image.network(
                          widget.restaurant.logo,
                          width: isIpad ? 180 : 300,
                          height: isIpad ? 180 : 300,
                        )
                      : CachedNetworkImage(
                          width: isIpad ? 150 : 400,
                          height: isIpad ? 150 : 400,
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                          imageUrl: widget.restaurant.logo,
                          errorWidget: (context, url, error) {
                            return Center(
                              child: Text(
                                error.toString(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            );
                          },
                          imageBuilder: (context, imageProvider) => Container(
                            height: 400,
                            width: 400,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) {
                            return buildLoadingLogoSkeleton();
                          },
                        ),
                ),
              ),
      ),
    );
  }

  Widget buildLoadingLogoSkeleton() {
    return Shimmer.fromColors(
      child: SizedBox(
        width: 150,
        height: 150,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
      ),
      baseColor: mynuuBlack,
      highlightColor: Colors.grey,
    );
  }
}
