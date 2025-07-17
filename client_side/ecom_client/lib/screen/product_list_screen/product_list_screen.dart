import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show SystemChrome, SystemUiMode, SystemUiOverlay, SystemUiOverlayStyle;
import 'package:provider/provider.dart';
import '../../core/data/data_provider.dart';
import '../../../../widget/product_grid_view.dart';
import 'components/category_selector.dart';
import 'components/poster_section.dart';
import 'components/sub_category_selector.dart';
import 'app_refreshable.dart';
import 'components/custom_app_bar.dart';
import '../../models/sub_category.dart';
import '../../models/product.dart';
import '../../models/brand.dart';
import 'components/filter_bar.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  int selectedSubCategoryIndex = 0;
  List<Brand> selectedBrands = [];
  double? minPrice;
  double? maxPrice;
  String? sortOption;

  // Flipkart-style filter fields
  final List<String> _priceRanges = [
    'All',
    'Below ₹500',
    '₹500 - ₹1000',
    '₹1000 - ₹5000',
    'Above ₹5000',
  ];
  String? _selectedPriceRange;

  final List<String> _sortOptions = [
    'Popularity',
    'Price: Low to High',
    'Price: High to Low',
    'Newest First',
  ];
  String _selectedSortLabel = 'Sort';

  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  @override
  void dispose() {
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    return Selector<DataProvider, List<SubCategory>>(
      selector: (_, provider) => provider.subCategories,
      builder: (context, subCategories, child) {
        final List<SubCategory> displaySubCategories = [
          SubCategory(sId: 'all', name: 'All'),
          ...subCategories,
        ];
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              subcategories: displaySubCategories,
              selectedSubCategoryIndex: selectedSubCategoryIndex,
              onSubCategorySelected: (index) {
                setState(() {
                  selectedSubCategoryIndex = index;
                  // Reset filters when changing subcategory
                  selectedBrands = [];
                  minPrice = null;
                  maxPrice = null;
                  minPriceController.clear();
                  maxPriceController.clear();
                  sortOption = null;
                });
              },
            ),
            body: Consumer<DataProvider>(
              builder: (context, dataProvider, _) {
                print(
                  'ProductListScreen: products=${dataProvider.products.length}, subCategories=${dataProvider.subCategories.length}, posters=${dataProvider.posters.length}, isLoading=${dataProvider.isLoading}',
                );
                return RefreshIndicator(
                  onRefresh: () async {
                    await Provider.of<DataProvider>(
                      context,
                      listen: false,
                    ).fetchAllData();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 8,
                      ),
                      child: dataProvider.isLoading
                          ? SizedBox(
                              height:
                                  MediaQuery.of(context).size.height *
                                  0.5, // Adjust as needed for centering
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Show poster only for 'All' tab
                                if (selectedSubCategoryIndex == 0 &&
                                    dataProvider.posters.isNotEmpty)
                                  PosterSection(),
                                // Show filter bar only for subcategories (not 'All')
                                if (selectedSubCategoryIndex != 0)
                                  FilterBar(
                                    brandsForSubCat: dataProvider.brands
                                        .where(
                                          (b) =>
                                              b.subcategoryId?.sId ==
                                              displaySubCategories[selectedSubCategoryIndex]
                                                  .sId,
                                        )
                                        .toList(),
                                    selectedBrands: selectedBrands,
                                    minPrice: minPrice,
                                    maxPrice: maxPrice,
                                    sortOption: sortOption,
                                    priceRanges: _priceRanges,
                                    selectedPriceRange: _selectedPriceRange,
                                    sortOptions: _sortOptions,
                                    selectedSortLabel: _selectedSortLabel,
                                    onBrandsChanged: (brands) {
                                      setState(() {
                                        selectedBrands = brands;
                                      });
                                    },
                                    onMinPriceChanged: (min) {
                                      setState(() {
                                        minPrice = min;
                                      });
                                    },
                                    onMaxPriceChanged: (max) {
                                      setState(() {
                                        maxPrice = max;
                                      });
                                    },
                                    onSortOptionChanged: (option) {
                                      setState(() {
                                        sortOption = option;
                                        _selectedSortLabel = option ?? 'Sort';
                                      });
                                    },
                                    onPriceRangeChanged: (val) {
                                      setState(() {
                                        _selectedPriceRange = val;
                                        if (val == 'Below ₹500') {
                                          minPrice = null;
                                          maxPrice = 500;
                                        } else if (val == '₹500 - ₹1000') {
                                          minPrice = 500;
                                          maxPrice = 1000;
                                        } else if (val == '₹1000 - ₹5000') {
                                          minPrice = 1000;
                                          maxPrice = 5000;
                                        } else if (val == 'Above ₹5000') {
                                          minPrice = 5000;
                                          maxPrice = null;
                                        } else {
                                          minPrice = null;
                                          maxPrice = null;
                                        }
                                      });
                                    },
                                    onClearAll: () {
                                      setState(() {
                                        selectedBrands.clear();
                                        minPrice = null;
                                        maxPrice = null;
                                        sortOption = null;
                                        _selectedPriceRange = null;
                                        _selectedSortLabel = 'Sort';
                                      });
                                    },
                                  ),
                                Builder(
                                  builder: (context) {
                                    List<Product> productsToShow =
                                        dataProvider.products;
                                    if (displaySubCategories.isNotEmpty &&
                                        selectedSubCategoryIndex <
                                            displaySubCategories.length) {
                                      if (selectedSubCategoryIndex != 0) {
                                        final selectedSubCat =
                                            displaySubCategories[selectedSubCategoryIndex];
                                        productsToShow = dataProvider.products
                                            .where(
                                              (p) =>
                                                  p.proSubCategoryId?.sId ==
                                                  selectedSubCat.sId,
                                            )
                                            .toList();
                                        if (selectedBrands.isNotEmpty) {
                                          final brandIds = selectedBrands
                                              .map((b) => b.sId)
                                              .toSet();
                                          productsToShow = productsToShow
                                              .where(
                                                (p) => brandIds.contains(
                                                  p.proBrandId?.sId,
                                                ),
                                              )
                                              .toList();
                                        }
                                        if (minPrice != null) {
                                          productsToShow = productsToShow
                                              .where(
                                                (p) =>
                                                    (p.price ?? 0) >= minPrice!,
                                              )
                                              .toList();
                                        }
                                        if (maxPrice != null) {
                                          productsToShow = productsToShow
                                              .where(
                                                (p) =>
                                                    (p.price ?? 0) <= maxPrice!,
                                              )
                                              .toList();
                                        }
                                        if (sortOption != null) {
                                          if (sortOption ==
                                              'Price: Low to High') {
                                            productsToShow.sort(
                                              (a, b) => (a.price ?? 0)
                                                  .compareTo(b.price ?? 0),
                                            );
                                          } else if (sortOption ==
                                              'Price: High to Low') {
                                            productsToShow.sort(
                                              (a, b) => (b.price ?? 0)
                                                  .compareTo(a.price ?? 0),
                                            );
                                          } else if (sortOption ==
                                              'Name: A-Z') {
                                            productsToShow.sort(
                                              (a, b) => (a.name ?? '')
                                                  .compareTo(b.name ?? ''),
                                            );
                                          } else if (sortOption ==
                                              'Name: Z-A') {
                                            productsToShow.sort(
                                              (a, b) => (b.name ?? '')
                                                  .compareTo(a.name ?? ''),
                                            );
                                          }
                                        }
                                      }
                                    }
                                    if (productsToShow.isNotEmpty) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Popular Products",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.copyWith(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                          ),
                                          const SizedBox(height: 10),

                                          // product cards
                                          ProductGridView(
                                            items: productsToShow,
                                          ),
                                          const SizedBox(height: 20),
                                        ],
                                      );
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                              ],
                            ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
