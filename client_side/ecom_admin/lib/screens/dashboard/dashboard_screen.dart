import 'package:ecotte_admin/utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../utility/constants.dart';
import 'components/dash_board_header.dart';
import 'components/add_product_form.dart';
import 'components/order_details_section.dart';
import 'components/product_list_section.dart';
import 'components/product_summery_section.dart';
import 'package:provider/provider.dart';
import '../../core/data/data_provider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final dataProvider = Provider.of<DataProvider>(context, listen: false);
      await dataProvider.getAllProduct();
      await dataProvider.getAllOrders();
      await dataProvider.getAllCategory();
      await dataProvider.getAllSubCategory();
      await dataProvider.getAllBrands();
      await dataProvider.getAllVariantType();
      await dataProvider.getAllVariant();
      await dataProvider.getAllPosters();
      await dataProvider.getAllCoupons();
      await dataProvider.getAllNotifications();
    });
  }

  Future<void> _refreshDashboard(BuildContext context) async {
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    await Future.wait([
      dataProvider.getAllProduct(),
      dataProvider.getAllOrders(),
      dataProvider.getAllCategory(),
      dataProvider.getAllSubCategory(),
      dataProvider.getAllBrands(),
      dataProvider.getAllVariantType(),
      dataProvider.getAllVariant(),
      dataProvider.getAllPosters(),
      dataProvider.getAllCoupons(),
      dataProvider.getAllNotifications(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return RefreshIndicator(
            onRefresh: () => _refreshDashboard(context),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      "My Products",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
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
                        Expanded(flex: 2, child: OrderDetailsSection()),
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
            ),
          );
        },
      ),
    );
  }
}
