import 'package:admin_app_complt_app/screens/dashboard/provider/dash_board_provider.dart';
import 'package:admin_app_complt_app/utility/extensions.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/product.dart';
import 'add_product_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utility/constants.dart';

class ProductListSection extends StatelessWidget {
  const ProductListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
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
          SizedBox(height: defaultPadding),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: constraints.maxWidth),
                  child: Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      return DataTable(
                        columnSpacing: defaultPadding,
                        columns: [
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
                                  context, dataProvider.products[index]);
                            },
                            delete: () {
                              final dashBoardProvider =
                                  context.read<DashBoardProvider>();
                              dashBoardProvider
                                  .deleteProduct(dataProvider.products[index]);
                            },
                          ),
                        ),
                      );
                    },
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

DataRow productDataRow(Product productInfo,
    {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Image.network(
              productInfo.images?.first.url ?? '',
              height: 30,
              width: 30,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.image_not_supported,
                    size: 30, color: Colors.grey);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(productInfo.name ?? ''),
            ),
          ],
        ),
      ),
      DataCell(Text(productInfo.proCategoryId?.name ?? 'N/A')),
      DataCell(Text(productInfo.proSubCategoryId?.name ?? 'N/A')),
      DataCell(Text('${productInfo.price ?? 0}')),
      DataCell(
        IconButton(
          onPressed: edit != null ? () => edit() : null,
          icon: Icon(Icons.edit, color: Colors.white),
        ),
      ),
      DataCell(
        IconButton(
          onPressed: delete != null ? () => delete() : null,
          icon: Icon(Icons.delete, color: Colors.red),
        ),
      ),
    ],
  );
}
