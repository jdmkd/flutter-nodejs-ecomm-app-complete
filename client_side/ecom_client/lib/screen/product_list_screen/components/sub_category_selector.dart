import 'dart:developer';

import 'package:ecotte/models/sub_category.dart';
import 'package:ecotte/screen/product_by_subcategory_screen/product_by_subcategory_screen.dart';
import '../../product_by_category_screen/product_by_category_screen.dart';
import '../../../utility/animation/open_container_wrapper.dart';
import 'package:flutter/material.dart';

class SubCategorySelector extends StatelessWidget {
  final List<SubCategory> subcategories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const SubCategorySelector({
    super.key,
    required this.subcategories,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0), // Subtle grey
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: subcategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemBuilder: (context, index) {
              final subcategory = subcategories[index];
              final isSelected = index == selectedIndex;
              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onSelected(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        margin: isSelected
                            ? const EdgeInsets.only(bottom: 1)
                            : null,
                        decoration: null,
                        child: Center(
                          child: Icon(
                            Icons.widgets,
                            color: isSelected
                                ? Colors.indigoAccent[400]
                                : Colors.black45,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Container(
                        padding: EdgeInsets.zero,
                        child: Text(
                          subcategory.name ?? '',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.indigoAccent[400]
                                : Colors.black87,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.only(top: 1),
                        height: 2,
                        width: isSelected
                            ? (subcategory.name?.length ?? 4) * 7.0 + 8
                            : 0,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.indigoAccent[400]
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
