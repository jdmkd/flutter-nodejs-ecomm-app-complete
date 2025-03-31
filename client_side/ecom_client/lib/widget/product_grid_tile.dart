import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../screen/product_favorite_screen/provider/favorite_provider.dart';
import '../utility/extensions.dart';
import '../utility/utility_extention.dart';

class ProductGridTile extends StatelessWidget {
  final Product product;
  final int index;
  final bool isPriceOff;

  const ProductGridTile({
    super.key,
    required this.product,
    required this.index,
    required this.isPriceOff,
  });

  @override
  Widget build(BuildContext context) {
    double discountPercentage = context.dataProvider
        .calculateDiscountPercentage(
            product.price ?? 0, product.offerPrice ?? 0);

    // Product Image Fallback
    String imageUrl = product.images != null && product.images!.isNotEmpty
        ? product.images![0].url?.replaceAll('localhost', '192.168.141.74') ??
            ''
        : 'https://dummyimage.com/300x400/aaaaaa/ffffff&text=Loading...';

    return Card(
      elevation: 0,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),

      color: Colors.white,

      // margin: EdgeInsets.all(5.4),
      margin: EdgeInsets.zero,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Offer Badge & Favorite Icon
          Stack(
            children: [
              Container(
                height: 140, // Optimized for better display
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) => Image.network(
                      'https://dummyimage.com/300x400/aaaaaa/ffffff&text=Loading...',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Discount Badge
              if (discountPercentage != 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "${discountPercentage.toInt()}% OFF",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

              // Favorite Icon
              Positioned(
                top: 8,
                right: 8,
                child: Consumer<FavoriteProvider>(
                  builder: (context, favoriteProvider, child) {
                    bool isFavorite =
                        favoriteProvider.checkIsItemFavorite(product.sId ?? '');
                    return GestureDetector(
                      onTap: () {
                        context.favoriteProvider
                            .updateToFavoriteList(product.sId ?? '');
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 16, // Matched with discount text size
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Product Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: 40, // Fixed height for two lines (around 18px per line)
              child: Text(
                product.name ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),

          // Rating & Reviews
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 16),
                const SizedBox(width: 4),
                Text(
                  "4.5", // Placeholder rating
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(width: 5),
                Text(
                  "(1.5K Reviews)", // Placeholder reviews
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // Pricing Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (product.offerPrice != null &&
                    product.offerPrice != product.price)
                  Text(
                    "₹${product.price}",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                const SizedBox(width: 5),
                Text(
                  "₹${product.offerPrice != 0 ? product.offerPrice : product.price}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // Delivery & Stock Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "In Stock", // Placeholder stock status
              style: const TextStyle(fontSize: 12, color: Colors.green),
            ),
          ),
          const SizedBox(height: 5),

          // const Spacer(), // Pushes button to the bottom
          Expanded(
              child: SizedBox()), // Keeps button at bottom without overflow

          // Buy Now Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // Buy Now Button
                // ElevatedButton.icon(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.orange,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     minimumSize: const Size(double.infinity, 40),
                //   ),
                //   onPressed: () {
                //     // Implement Buy Now functionality
                //   },
                //   icon: const Icon(Icons.shopping_bag, color: Colors.white),
                //   label: const Text(
                //     "Buy Now",
                //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                //   ),
                // ),
                // const SizedBox(height: 3), // Space between buttons

                // Add to Cart Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  onPressed: () {
                    // Implement Add to Cart functionality
                  },
                  icon:
                      const Icon(Icons.add_shopping_cart, color: Colors.white),
                  label: const Text(
                    "Add to Cart",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
