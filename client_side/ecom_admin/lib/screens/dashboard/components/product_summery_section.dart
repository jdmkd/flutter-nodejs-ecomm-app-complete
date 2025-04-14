import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/product_summery_info.dart';
import '../../../utility/constants.dart';
import 'product_summery_card.dart';

class ProductSummerySection extends StatelessWidget {
  const ProductSummerySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        int totalProduct =
            dataProvider.calculateProductWithQuantity(quantity: null);
        int outOfStockProduct =
            dataProvider.calculateProductWithQuantity(quantity: 0);
        int limitedStockProduct =
            dataProvider.calculateProductWithQuantity(quantity: 1);
        int otherStockProduct =
            totalProduct - outOfStockProduct - limitedStockProduct;

        List<ProductSummeryInfo> productSummeryItems = [
          ProductSummeryInfo(
            title: "All Products",
            productsCount: totalProduct,
            svgSrc: "assets/icons/Product.svg",
            color: primaryColor,
            percentage: 100,
          ),
          ProductSummeryInfo(
            title: "Out of Stock",
            productsCount: outOfStockProduct,
            svgSrc: "assets/icons/Product2.svg",
            color: const Color(0xFFEA3829),
            percentage: totalProduct != 0
                ? (outOfStockProduct / totalProduct) * 100
                : 0,
          ),
          ProductSummeryInfo(
            title: "Limited Stock",
            productsCount: limitedStockProduct,
            svgSrc: "assets/icons/Product3.svg",
            color: const Color(0xFFECBE23),
            percentage: totalProduct != 0
                ? (limitedStockProduct / totalProduct) * 100
                : 0,
          ),
          ProductSummeryInfo(
            title: "Other Stock",
            productsCount: otherStockProduct,
            svgSrc: "assets/icons/Product4.svg",
            color: const Color(0xFF47e228),
            percentage: totalProduct != 0
                ? (otherStockProduct / totalProduct) * 100
                : 0,
          ),
        ];

        return LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            int crossAxisCount = (width < 600)
                ? 2
                : // 2 cards on mobile
                (width < 900)
                    ? 2
                    : (width < 1200)
                        ? 3
                        : 4;

            double aspectRatio = (width < 600)
                ? 0.9
                : // Smaller cards
                (width < 900)
                    ? 1.1
                    : (width < 1200)
                        ? 1.3
                        : 1.4;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 1.0, vertical: 8.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: productSummeryItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: screenSize.width < 1200 ? 1.1 : 1.4,
                  // childAspectRatio: aspectRatio,
                ),
                itemBuilder: (context, index) => ProductSummeryCard(
                  info: productSummeryItems[index],
                  onTap: (productType) {
                    dataProvider.filterProductsByQuantity(productType ?? '');
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
