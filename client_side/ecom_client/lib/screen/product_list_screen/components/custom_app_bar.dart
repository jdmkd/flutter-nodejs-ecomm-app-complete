import 'package:ecom_client/utility/extensions.dart';
import 'package:flutter/material.dart';
import '../../../widget/custom_search_bar.dart';
import '../../auth_screen/my_profile_screen/my_profile_screen.dart';
import '../../profile_screen/profile_screen.dart';
import './sub_category_selector.dart';
import '../../../models/sub_category.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final List<SubCategory> subcategories;
  final int selectedSubCategoryIndex;
  final ValueChanged<int> onSubCategorySelected;

  const CustomAppBar({
    super.key,
    required this.subcategories,
    required this.selectedSubCategoryIndex,
    required this.onSubCategorySelected,
  });

  @override
  Size get preferredSize => subcategories.isNotEmpty
      ? const Size.fromHeight(123)
      : const Size.fromHeight(70);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.only(top: 8),
          color: Colors.white,
          width: double.infinity,
          height: widget.preferredSize.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Container(
                  height: 44,

                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.black45),
                      const SizedBox(width: 8),
                      Expanded(
                        child: CustomSearchBar(
                          controller: TextEditingController(),
                          onChanged: (val) {
                            context.dataProvider.filterProducts(val);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Progress bar below search bar
              Container(
                decoration: BoxDecoration(
                  border: const Border(
                    bottom: BorderSide(
                      color: Color(0xFFE0E0E0), // Light grey
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 2, left: 0, right: 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 6,
                    child: Consumer<DataProvider>(
                      builder: (context, dataProvider, child) {
                        if (!dataProvider.isLoading) {
                          return const SizedBox.shrink();
                        }
                        return AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFFEC6813,
                                    ).withOpacity(0.25),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CustomPaint(
                                painter: _AnimatedGradientBarPainter(
                                  _controller.value,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: const Border(
                                bottom: BorderSide(
                                  color: Color(0xFFE0E0E0), // Light grey
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              if (widget.subcategories.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 0, right: 0),
                  child: SizedBox(
                    height: 58,
                    child: SubCategorySelector(
                      subcategories: widget.subcategories,
                      selectedIndex: widget.selectedSubCategoryIndex,
                      onSelected: widget.onSubCategorySelected,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Reuse the painter from app_refreshable.dart
class _AnimatedGradientBarPainter extends CustomPainter {
  final double animationValue;
  _AnimatedGradientBarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFFEC6813), Color(0xFFFFA726), Color(0xFFEC6813)],
      stops: [
        (0.0 + animationValue) % 1.0,
        (0.5 + animationValue) % 1.0,
        (1.0 + animationValue) % 1.0,
      ],
    );
    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(4)), paint);
  }

  @override
  bool shouldRepaint(covariant _AnimatedGradientBarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
