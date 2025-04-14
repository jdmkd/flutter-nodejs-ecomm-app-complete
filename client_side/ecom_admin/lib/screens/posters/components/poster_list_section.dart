import 'package:ecom_admin/utility/extensions.dart';

import '../../../core/data/data_provider.dart';
import 'add_poster_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/poster.dart';
import '../../../utility/constants.dart';

class PosterListSection extends StatelessWidget {
  const PosterListSection({Key? key}) : super(key: key);

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
                "All Posters",
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
                            DataColumn(label: Text("Category Name")),
                            DataColumn(label: Text("Edit")),
                            DataColumn(label: Text("Delete")),
                          ],
                          rows: List.generate(
                            dataProvider.posters.length,
                            (index) => posterDataRow(
                              dataProvider.posters[index],
                              edit: () {
                                showAddPosterForm(
                                    context, dataProvider.posters[index]);
                              },
                              delete: () {
                                context.posterProvider
                                    .deletePoster(dataProvider.posters[index]);
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

DataRow posterDataRow(Poster poster, {Function? edit, Function? delete}) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                poster.imageUrl ?? '',
                height: 32,
                width: 32,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
            ),
            const SizedBox(width: defaultPadding),
            SizedBox(
              width: 150,
              child: Text(
                poster.posterName ?? '',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
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
