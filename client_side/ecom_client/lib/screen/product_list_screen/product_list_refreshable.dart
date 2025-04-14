import 'dart:developer';

import 'package:ecom_client/screen/product_list_screen/components/sub_category_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/data/data_provider.dart';
import '../../../../widget/product_grid_view.dart';
import 'components/category_selector.dart';
import 'components/poster_section.dart';

class ProductListRefreshable extends StatefulWidget {
  const ProductListRefreshable({super.key});

  @override
  State<ProductListRefreshable> createState() => _ProductListRefreshableState();
}

class _ProductListRefreshableState extends State<ProductListRefreshable> {
  Future<void> _refreshData() async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await dataProvider.getAllProduct(); // Fetch latest data from API or DB
    log("dataProvider.products ==> ");
    print(dataProvider.products);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(), // Enables pull-to-refresh even when content is short
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Text with modern font style
              Text(
                "Hello,",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
              ),
              Text(
                "Let's get something!",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 10),

              // Poster Section with rounded borders
              const PosterSection(),
              const SizedBox(height: 10),

              // Categories Section with modern design
              Text(
                "Top Categories",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 10),

              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  return CategorySelector(
                    categories: dataProvider.categories,
                  );
                },
              ),

              const SizedBox(height: 10),

              // Categories Section with modern design
              Text(
                "Top Sub Categories",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 10),

              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  log("dataProvider.subCategories ==> ${dataProvider.subCategories}");
                  return SubCategorySelector(
                    subcategories: dataProvider.subCategories,
                  );
                },
              ),
              const SizedBox(height: 20),

              // Product Grid Section
              Text(
                "Popular Products",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 10),

              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  return Column(
                    children: [
                      ProductGridView(items: dataProvider.products),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
