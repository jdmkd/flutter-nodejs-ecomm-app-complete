import 'dart:developer';

import 'package:ecotte_admin/screens/dashboard/provider/dash_board_provider.dart';
import 'package:ecotte_admin/utility/extensions.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/product.dart';
import 'add_product_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants.dart';

class ProductListSection extends StatelessWidget {
  const ProductListSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "All Products",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: defaultPadding),
              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  if (dataProvider.isLoadingProducts) {
                    return Center(child: CircularProgressIndicator());
                    // return;
                  }
                  if (dataProvider.products.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }
                  return Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth:
                              1000, // ensures DataTable always scrolls on small screens
                        ),
                        child: DataTable(
                          columnSpacing: 20,
                          horizontalMargin: 16,
                          columns: const [
                            DataColumn(label: Text("Product Name")),
                            DataColumn(label: Text("Category")),
                            DataColumn(label: Text("Sub Category")),
                            DataColumn(label: Text("Price")),
                            DataColumn(label: Text("Edit")),
                            DataColumn(label: Text("Delete")),
                          ],
                          rows: List.generate(
                            dataProvider.products.length,
                            (index) => productDataRow(
                              dataProvider.products[index],
                              edit: () {
                                showAddProductForm(
                                  context,
                                  dataProvider.products[index],
                                );
                              },
                              delete: () {
                                context.dashBoardProvider.deleteProduct(
                                    dataProvider.products[index]);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

DataRow productDataRow(Product productInfo,
    {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                productInfo.images?.first.url ?? '',
                height: 40,
                width: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 40);
                },
              ),
            ),
            const SizedBox(width: defaultPadding / 2),
            SizedBox(
              width: 150,
              child: Text(
                productInfo.name ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(productInfo.proCategoryId?.name ?? '')),
      DataCell(Text(productInfo.proSubCategoryId?.name ?? '')),
      DataCell(Text('₹${productInfo.price}')),
      DataCell(
        IconButton(
          onPressed: () => edit?.call(),
          icon: const Icon(Icons.edit, color: Colors.white),
        ),
      ),
      DataCell(
        IconButton(
          onPressed: () => delete?.call(),
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ),
    ],
  );
}

// DataRow productDataRow(Product productInfo,
//     {Function? edit, Function? delete}) {
//   return DataRow(
//     cells: [
//       DataCell(
//         Row(
//           children: [
//             Image.network(
//               productInfo.images?.first.url ?? '',
//               height: 40,
//               width: 40,
//               errorBuilder: (BuildContext context, Object exception,
//                   StackTrace? stackTrace) {
//                 return Icon(Icons.error);
//               },
//             ),
//             SizedBox(width: defaultPadding),
//             SizedBox(
//               width: 200, // Adjust this width as needed
//               child: Text(
//                 productInfo.name ?? '',
//                 overflow: TextOverflow.ellipsis,
//                 maxLines: 1,
//               ),
//             ),
//           ],
//         ),
//       ),
//       DataCell(Text(productInfo.proCategoryId?.name ?? '')),
//       DataCell(Text(productInfo.proSubCategoryId?.name ?? '')),
//       DataCell(
//         Text('${productInfo.price}'),
//       ),
//       DataCell(IconButton(
//           onPressed: () {
//             if (edit != null) edit();
//           },
//           icon: Icon(
//             Icons.edit,
//             color: Colors.white,
//           ))),
//       DataCell(IconButton(
//           onPressed: () {
//             if (delete != null) delete();
//           },
//           icon: Icon(
//             Icons.delete,
//             color: Colors.red,
//           ))),
//     ],
//   );
// }
