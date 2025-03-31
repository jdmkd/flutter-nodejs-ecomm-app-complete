import '../../core/data/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/custom_app_bar.dart';
import '../../../../widget/product_grid_view.dart';
import 'components/category_selector.dart';
import 'components/poster_section.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
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
      ),
    );
  }
}
