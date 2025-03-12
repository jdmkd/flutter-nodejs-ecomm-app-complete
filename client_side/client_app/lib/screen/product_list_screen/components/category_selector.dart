import '../../product_by_category_screen/product_by_category_screen.dart';
import '../../../utility/animation/open_container_wrapper.dart';
import 'package:flutter/material.dart';
import '../../../models/category.dart';

class CategorySelector extends StatelessWidget {
  final List<Category> categories;

  const CategorySelector({
    super.key,
    required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Increased height for better visuals
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: OpenContainerWrapper(
              nextScreen: ProductByCategoryScreen(selectedCategory: category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 100,
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: category.isSelected
                      ? const Color(0xFFf16b26)
                      : const Color(0xFFE5E6E8),
                  borderRadius: BorderRadius.circular(1),
                  boxShadow: category.isSelected
                      ? [
                          BoxShadow(
                              blurRadius: 10,
                              color: Colors.orangeAccent.withOpacity(0.5),
                              spreadRadius: 2)
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          category.image ?? '',
                          width: 70,
                          height: 70,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.name ?? '',
                      style: TextStyle(
                        color:
                            category.isSelected ? Colors.white : Colors.black,
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
