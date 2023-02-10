import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project1/common/blocs/home_bloc.dart';
import 'package:project1/common/models/restaurant.dart';
import 'package:project1/common/models/user_system.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:project1/profile_management/pages/edit_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantLogo extends StatefulWidget {
  const RestaurantLogo({
    Key? key,
    required this.backgroundColor,
    required this.restaurant,
  }) : super(key: key);

  final Color backgroundColor;
  final Restaurant restaurant;

  @override
  State<RestaurantLogo> createState() => _RestaurantLogoState();
}

class _RestaurantLogoState extends State<RestaurantLogo> {
  late final userSession = context.read<FirebaseUser>();
  late final homeBloc = context.read<HomeBloc>();

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    const value = 400;
    print(mediaSize.width);
    // TamaÃ±os ajustables de widgets
    final isIpad = (mediaSize.width < value);
    final valuePadding = mediaSize.width < value ? 0.0 : 80.0;
    return Container(
      color: widget.backgroundColor,
      child: GestureDetector(
        onTap: () async {
          // Manage edit logo.
          if (!kIsWeb) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Provider.value(
                  value: userSession,
                  child: const EditProfileScreen(),
                ),
              ),
            );
            setState(() {});
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(kIsWeb ? 100 : 80),
                  child: kIsWeb
                      ? Image.network(
                          widget.restaurant.logo,
                          width: isIpad ? 180 : 300,
                          height: isIpad ? 180 : 300,
                        )
                      : CachedNetworkImage(
                          width: isIpad ? 150 : 300,
                          height: isIpad ? 150 : 300,
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
