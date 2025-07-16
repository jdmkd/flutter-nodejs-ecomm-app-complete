import 'package:ecom_client/utility/extensions.dart';
import 'package:flutter/services.dart';
import 'provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widget/product_grid_view.dart';
import '../../utility/app_color.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Explicitly enable system UI overlays
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    // Ensure the status bar is visible
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // Adjust color as needed
        statusBarIconBrightness:
            Brightness.dark, // Use Brightness.light for light theme
      ),
    );

    Future.delayed(Duration.zero, () {
      context.favoriteProvider.loadFavoriteItems();
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Favorites",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: RefreshIndicator(
          onRefresh: () async {
            context.favoriteProvider.loadFavoriteItems();
          },
          child: Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              if (favoriteProvider.favoriteProduct.isEmpty) {
                return _buildEmptyFavorites();
              }
              return Padding(
                padding: const EdgeInsets.all(10),
                child: ProductGridView(items: favoriteProvider.favoriteProduct),
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget _buildEmptyFavorites() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // https://img.freepik.com/premium-vector/modern-flat-design-concept-no-favorites-empty-favorites-popup-design_637684-95.jpg?w=740
          // Image.network(
          //   // 'https://img.freepik.com/premium-vector/modern-flat-design-concept-no-favorites-empty-favorites-popup-design_637684-95.jpg?w=740', // Add an image for better UI
          //   'https://img.freepik.com/premium-vector/modern-flat%E2%80%A6orites-empty-favorites-popup-design_637684-95.jpg',
          //   height: 300,
          //   // width: 740,
          //   fit: BoxFit.contain,
          // ),
          const SizedBox(height: 20),
          const Text(
            "No favorites yet!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "You can add an item to your favourites by clicking ♥ icon.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
