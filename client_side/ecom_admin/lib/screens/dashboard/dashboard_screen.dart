import 'package:ecom_admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import 'components/dash_board_header.dart';
import 'components/add_product_form.dart';
import 'components/order_details_section.dart';
import 'components/product_list_section.dart';
import 'components/product_summery_section.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      context.dataProvider;
      // context.dataProvider.getAllProduct(showSnack: false);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                DashBoardHeader(),
                Gap(defaultPadding),
                if (constraints.maxWidth > 800) // Desktop view
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "My Products",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: defaultPadding * 1.5,
                                      vertical: defaultPadding,
                                    ),
                                  ),
                                  onPressed: () {
                                    showAddProductForm(context, null);
                                  },
                                  icon: Icon(Icons.add),
                                  label: Text("Add New"),
                                ),
                                Gap(20),
                                IconButton(
                                    onPressed: () {
                                      context.dataProvider
                                          .getAllProduct(showSnack: true);
                                    },
                                    icon: Icon(Icons.refresh)),
                              ],
                            ),
                            Gap(defaultPadding),
                            ProductSummerySection(),
                            Gap(defaultPadding),
                            ProductListSection(),
                          ],
                        ),
                      ),
                      SizedBox(width: defaultPadding),
                      Expanded(
                        flex: 2,
                        child: OrderDetailsSection(),
                      ),
                    ],
                  )
                else // Mobile view
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "My Products",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ElevatedButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: defaultPadding * 1.5,
                                vertical: defaultPadding,
                              ),
                            ),
                            onPressed: () {
                              showAddProductForm(context, null);
                            },
                            icon: Icon(Icons.add),
                            label: Text("Add New"),
                          ),
                          Gap(20),
                          IconButton(
                              onPressed: () {
                                context.dataProvider
                                    .getAllProduct(showSnack: true);
                              },
                              icon: Icon(Icons.refresh)),
                        ],
                      ),
                      Gap(defaultPadding),
                      ProductSummerySection(),
                      Gap(defaultPadding),
                      ProductListSection(),
                      Gap(defaultPadding),
                      OrderDetailsSection(),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
