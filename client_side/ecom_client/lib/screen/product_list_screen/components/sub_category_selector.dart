import 'dart:developer';

import 'package:ecom_client/models/sub_category.dart';
import 'package:ecom_client/screen/product_by_subcategory_screen/product_by_subcategory_screen.dart';

import '../../product_by_category_screen/product_by_category_screen.dart';
import '../../../utility/animation/open_container_wrapper.dart';
import 'package:flutter/material.dart';

class SubCategorySelector extends StatelessWidget {
  final List<SubCategory> subcategories;

  const SubCategorySelector({
    super.key,
    required this.subcategories,
  });

  @override
  Widget build(BuildContext context) {
    for (var sub in subcategories) {
      print('--- SubCategory ---');
      print('ID: ${sub.sId}');
      print('Name: ${sub.name}');
      // print('Image: ${sub.image}');
      print('Category ID: ${sub.categoryId?.sId}');
      print('Category Name: ${sub.categoryId?.name}');
      print('Created At: ${sub.createdAt}');
      print('Updated At: ${sub.updatedAt}');
      // print('Is Selected: ${sub.isSelected}');
    }
    return SizedBox(
      height: 100, // Increased height for better visuals
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: subcategories.length,
        itemBuilder: (context, index) {
          final subcategory = subcategories[index];
          log("subcategory ==>${subcategory}");
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: OpenContainerWrapper(
              nextScreen:
                  ProductBySubCategoryScreen(selectedSubCategory: subcategory),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 100,
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  // color: subcategory.isSelected
                  //     ? const Color(0xFFf16b26)
                  //     : const Color(0xFFE5E6E8),
                  borderRadius: BorderRadius.circular(1),
                  // boxShadow: subcategory.isSelected
                  //     ? [
                  //         BoxShadow(
                  //             blurRadius: 10,
                  //             color: Colors.orangeAccent.withOpacity(0.5),
                  //             spreadRadius: 2)
                  //       ]
                  //     : [],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        // child: Image.network(
                        //   subcategory.image!,
                        //   width: 70,
                        //   height: 70,
                        //   fit: BoxFit.contain,
                        //   errorBuilder: (context, error, stackTrace) {
                        //     return const Icon(Icons.error, color: Colors.grey);
                        //   },
                        // ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subcategory.name ?? '',
                      style: TextStyle(
                        // color: subcategory.isSelected
                        //     ? Colors.white
                        //     : Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
