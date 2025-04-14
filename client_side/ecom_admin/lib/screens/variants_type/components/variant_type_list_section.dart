import 'package:ecom_admin/utility/extensions.dart';

import '../../../core/data/data_provider.dart';
import 'add_variant_type_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../utility/color_list.dart';
import '../../../utility/constants.dart';
import '../../../models/variant_type.dart';

class VariantsTypeListSection extends StatelessWidget {
  const VariantsTypeListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                "All Variants Type",
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
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          columnSpacing: defaultPadding,
                          columns: const [
                            DataColumn(label: Text("Variant Name")),
                            DataColumn(label: Text("Variant Type")),
                            DataColumn(label: Text("Added Date")),
                            DataColumn(label: Text("Edit")),
                            DataColumn(label: Text("Delete")),
                          ],
                          rows: List.generate(
                            dataProvider.variantTypes.length,
                            (index) => variantTypeDataRow(
                              dataProvider.variantTypes[index],
                              index + 1,
                              edit: () {
                                showAddVariantsTypeForm(
                                    context, dataProvider.variantTypes[index]);
                              },
                              delete: () {
                                context.variantTypeProvider.deleteVariantType(
                                    dataProvider.variantTypes[index]);
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

DataRow variantTypeDataRow(VariantType variantTypeInfo, int index,
    {Function? edit, Function? delete}) {
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
                variantTypeInfo.name ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      DataCell(
        SizedBox(
          width: 150,
          child: Text(
            variantTypeInfo.type ?? '',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      DataCell(Text(variantTypeInfo.createdAt ?? '')),
      DataCell(
        IconButton(
          onPressed: () {
            if (edit != null) edit();
          },
          icon: const Icon(Icons.edit, color: Colors.white),
        ),
      ),
      DataCell(
        IconButton(
          onPressed: () {
            if (delete != null) delete();
          },
          icon: const Icon(Icons.delete, color: Colors.red),
        ),
      ),
    ],
  );
}
