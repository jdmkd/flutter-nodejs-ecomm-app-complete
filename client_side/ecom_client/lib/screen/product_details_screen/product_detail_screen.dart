import 'dart:developer';

import 'package:ecom_client/utility/extensions.dart';
import 'provider/product_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widget/carousel_slider.dart';
import '../../../../widget/page_wrapper.dart';
import '../../models/product.dart';
import '../../widget/horizondal_list.dart';
import 'components/product_rating_section.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product? product;

  const ProductDetailScreen(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the product is null
    if (product == null) {
      return Scaffold(
        body: Center(
          child: Text(
            "Product not available",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      );
    }

    // product!.images?.forEach((image) {
    //   print("image ==>");
    //   print(image.url?.replaceAll('localhost', '192.168.141.74') ?? ''); // Replace 'imageUrl' with the correct property name
    //   // product.images != null && product.images!.isNotEmpty
    //   //     ? product.images![0].url?.replaceAll('localhost', '192.168.141.74') ?? ''
    //   //     : 'https://dummyimage.com/300x400/aaaaaa/ffffff&text=Loading...'
    // });

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: PageWrapper(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //? product image section
                Container(
                  height: height * 0.35,
                  width: width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E6E8),
                    // borderRadius: const BorderRadius.only(
                    //   bottomRight: Radius.circular(200),
                    //   bottomLeft: Radius.circular(200),
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: Offset(0, 2),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: CarouselSlider(items: product!.images ?? []),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //? product name
                      Text(
                        '${product!.name}',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      //? product rating section
                      const ProductRatingSection(),

                      const SizedBox(height: 10),
                      //? product rate , offer , stock section
                      Row(
                        children: [
                          Text(
                            product!.offerPrice != null
                                ? "\₹${product!.offerPrice}"
                                : "\₹${product!.price}",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 3),
                          Visibility(
                            visible: product!.offerPrice != product!.price,
                            child: Text(
                              "\₹₹${product!.price}",
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            product!.quantity != 0
                                ? "Available stock : ${product!.quantity}"
                                : "Not available",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          )
                        ],
                      ),

                      const SizedBox(height: 20),

                      product!.proVariantId!.isNotEmpty
                          ? Text(
                              'Available ${product!.proVariantTypeId?.type}',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            )
                          : const SizedBox(),
                      Consumer<ProductDetailProvider>(
                        builder: (context, proDetailProvider, child) {
                          return HorizontalList(
                            items: product!.proVariantId ?? [],
                            itemToString: (val) => val,
                            selected: proDetailProvider.selectedVariant,
                            onSelect: (val) {
                              proDetailProvider.selectedVariant = val;
                              proDetailProvider.updateUI();
                            },
                          );
                        },
                      ),
                      //? product description
                      Text(
                        "About",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text("${product!.description}"),
                      const SizedBox(height: 20),
                      //? add to cart button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: product!.quantity != 0
                              ? () {
                                  context
                                      .read<ProductDetailProvider>()
                                      .addToCart(product!);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: product!.quantity != 0
                                ? Colors.blue
                                : Colors.grey,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text("Add to cart",
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
