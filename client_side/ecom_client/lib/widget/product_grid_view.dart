import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../screen/product_details_screen/product_detail_screen.dart';
import '../utility/animation/open_container_wrapper.dart';
import 'product_grid_tile.dart';

class ProductGridView extends StatelessWidget {
  const ProductGridView({super.key, required this.items});

  final List<Product> items;

  @override
  Widget build(BuildContext context) {
    // Ensure system UI mode allows status bar visibility
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Set status bar color and brightness
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Make it transparent or set a color
        statusBarIconBrightness: Brightness.dark, // Change to light if needed
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(0),
      child: GridView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 9 / 14,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          Product product = items[index];
          return ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 250,
              maxHeight: 350,
            ), // Ensures uniform height

            child: OpenContainerWrapper(
              nextScreen: ProductDetailScreen(product),
              child: ProductGridTile(
                product: product,
                index: index,
                isPriceOff:
                    product.offerPrice != null &&
                    product.offerPrice != product.price,
              ),
            ),
          );
        },
      ),
    );
  }
}
