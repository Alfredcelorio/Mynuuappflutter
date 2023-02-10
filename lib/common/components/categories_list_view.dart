import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project1/common/blocs/home_bloc.dart';
import 'package:project1/common/models/category.dart';
import 'package:project1/common/style/mynuu_colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({
    Key? key,
    required this.backgroundColor,
    required this.selectedCategory,
    required this.userSessionId,
    required this.onCategorySelected,
  }) : super(key: key);

  final Color backgroundColor;
  final ProductCategory? selectedCategory;
  final String userSessionId;
  final void Function(ProductCategory) onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          top: 4,
          bottom: 8,
        ),
        child: StreamBuilder<List<ProductCategory>>(
          stream: context.read<HomeBloc>().streamCategories(userSessionId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return _buildCategorySkeletons();
            }
            final categories = snapshot.data!;
            categories.sort(
              (a, b) => a.position.compareTo(
                b.position,
              ),
            );
            return SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: snapshot.data!
                    .map(
                      (index) => buildCategoryOption(index),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategorySkeletons() {
    return Shimmer.fromColors(
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
        ),
      ),
      baseColor: mynuuBlack,
      highlightColor: Colors.grey,
    );
  }

  Widget buildCategoryOption(ProductCategory index) {
    return InkWell(
      onTap: () => onCategorySelected(index),
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Center(
            child: Text(
              index.name.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Metropolis',
                color: Colors.white,
                fontSize: kIsWeb ? 22 : 14,
                fontWeight: selectedCategory?.id == index.id
                    ? FontWeight.bold
                    : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
