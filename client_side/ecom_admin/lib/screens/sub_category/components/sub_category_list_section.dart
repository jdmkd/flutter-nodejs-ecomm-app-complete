import 'package:ecom_admin/utility/extensions.dart';

import '../../../core/data/data_provider.dart';
import '../../../models/sub_category.dart';
import 'add_sub_category_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';
import '../../category/components/add_category_form.dart';

class SubCategoryListSection extends StatelessWidget {
  const SubCategoryListSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "All SubCategory",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: defaultPadding),
            Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: DataTable(
                        columnSpacing: defaultPadding,
                        columns: const [
                          DataColumn(label: Text("SubCategory Name")),
                          DataColumn(label: Text("Category")),
                          DataColumn(label: Text("Added Date")),
                          DataColumn(label: Text("Edit")),
                          DataColumn(label: Text("Delete")),
                        ],
                        rows: List.generate(
                          dataProvider.subCategories.length,
                          (index) => subCategoryDataRow(
                            dataProvider.subCategories[index],
                            index + 1,
                            edit: () {
                              showAddSubCategoryForm(
                                context,
                                dataProvider.subCategories[index],
                              );
                            },
                            delete: () {
                              context.subCategoryProvider.deleteSubCategory(
                                dataProvider.subCategories[index],
                              );
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
    });
  }
}

DataRow subCategoryDataRow(
  SubCategory subCatInfo,
  int index, {
  Function? edit,
  Function? delete,
}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Container(
              height: 32,
              width: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
              ),
              child: Text(
                index.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: defaultPadding),
            SizedBox(
              width: 150,
              child: Text(
                subCatInfo.name ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        SizedBox(
          width: 150,
          child: Text(
            subCatInfo.categoryId?.name ?? '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ),
      DataCell(Text(subCatInfo.createdAt ?? '')),
      DataCell(IconButton(
        onPressed: () {
          if (edit != null) edit();
        },
        icon: const Icon(Icons.edit, color: Colors.white),
      )),
      DataCell(IconButton(
        onPressed: () {
          if (delete != null) delete();
        },
        icon: const Icon(Icons.delete, color: Colors.red),
      )),
    ],
  );
}
