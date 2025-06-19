import 'package:ecom_client/screen/product_list_screen/product_list_refreshable.dart';

import 'package:flutter/material.dart';
import 'components/custom_app_bar.dart';
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: CustomAppBar(),
        body: SafeArea(
          child: ProductListRefreshable(), // Use the new refreshable screen
        ),
      ),
    );
  }
}
