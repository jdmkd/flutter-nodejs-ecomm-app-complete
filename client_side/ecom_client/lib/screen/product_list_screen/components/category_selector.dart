import '../../product_by_category_screen/product_by_category_screen.dart';
import '../../../utility/animation/open_container_wrapper.dart';
import 'package:flutter/material.dart';
import '../../../models/category.dart';

class CategorySelector extends StatelessWidget {
  final List<Category> categories;

  const CategorySelector({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.isSelected;
          return OpenContainerWrapper(
            nextScreen: ProductByCategoryScreen(selectedCategory: category),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4,0,4,0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    // No decoration, no border radius, no shadow, no background
                    child: category.image != null && category.image!.isNotEmpty
                        ? Image.network(category.image!, fit: BoxFit.cover)
                        : const Icon(Icons.image, color: Colors.grey, size: 28),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category.name ?? '',
                    style: TextStyle(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.black87,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
