import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../utility/constants.dart';
import '../../../models/product_summery_info.dart';

class ProductSummeryCard extends StatelessWidget {
  const ProductSummeryCard({
    Key? key,
    required this.info,
    required this.onTap,
  }) : super(key: key);

  final ProductSummeryInfo info;
  final Function(String?) onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(info.title);
      },
      
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjust height dynamically

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row - Icon & More Options
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon with Background
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: info.color!.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SvgPicture.asset(
                    info.svgSrc!,
                    height: 32,
                    width: 32,
                    colorFilter: ColorFilter.mode(
                      info.color ?? Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // TODO: Implement menu action
                  },
                  child: Icon(Icons.more_vert, color: Colors.white54),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Title
            Text(
              info.title!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 6),

            // Progress Bar
            ProgressLine(
              color: info.color,
              percentage: info.percentage,
            ),
            SizedBox(height: 10),

            // Product Count
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${info.productsCount} Products",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final double? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 6,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: constraints.maxWidth * (percentage! / 100),
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
