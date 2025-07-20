import 'package:ecotte_admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart'; // Ensure provider is imported
import '../../core/data/data_provider.dart';
import '../../utility/constants.dart';
import 'components/add_category_form.dart';
import 'components/category_header.dart';
import 'components/category_list_section.dart';

class CategoryScreen extends StatelessWidget {
  Future<void> _refreshCategories(BuildContext context) async {
    await Provider.of<DataProvider>(context, listen: false).getAllCategory();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => _refreshCategories(context),
        child: SingleChildScrollView(
          primary: false,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start, // Fix alignment
            children: [
              CategoryHeader(),
              SizedBox(height: defaultPadding),
              Gap(defaultPadding),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Expanded(
                            //   child: Text(
                            //     "My Categories",
                            //     style: Theme.of(context).textTheme.titleMedium,
                            //   ),
                            // ),
                            ElevatedButton.icon(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: defaultPadding * 1.5,
                                  vertical: defaultPadding,
                                ),
                              ),
                              onPressed: () {
                                showAddCategoryForm(context, null);
                              },
                              icon: Icon(Icons.add),
                              label: Text("Add New"),
                            ),
                          ],
                        ),
                        Gap(defaultPadding),
                        CategoryListSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
