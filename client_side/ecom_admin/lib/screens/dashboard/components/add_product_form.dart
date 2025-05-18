import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/brand.dart';
import '../../../models/category.dart';
import '../../../models/product.dart';
import '../../../models/sub_category.dart';
import '../../../models/variant_type.dart';

import '../../../utility/extensions.dart';
import '../../../utility/constants.dart';
import '../../../utility/snack_bar_helper.dart';

import '../../../widgets/multi_select_drop_down.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/product_image_card.dart';
import '../provider/dash_board_provider.dart';

class ProductSubmitForm extends StatefulWidget {
  final Product? product;

  // const ProductSubmitForm({super.key, this.product});
  const ProductSubmitForm({Key? key, this.product}) : super(key: key);

  @override
  State<ProductSubmitForm> createState() => _ProductSubmitFormState();
}

class _ProductSubmitFormState extends State<ProductSubmitForm>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      context.dataProvider;
      // context.dataProvider.getAllSubCategory(showSnack: false);
      _initialized = true;
    }
  }

  @override
  void initState() {
    super.initState();

    // This ensures it's called only once when the form loads
    if (widget.product != null) {
      context.dashBoardProvider.setDataForUpdateProduct(widget.product!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    log("🔁 AddProductForm rebuilt");
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600; // Customize breakpoint as needed
    var size = MediaQuery.of(context).size;

    context.dashBoardProvider.setDataForUpdateProduct(widget.product);

    return Form(
      key: context.dashBoardProvider.addProductFormKey,
      child: Container(
        width: size.width * 0.7,
        padding: EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<DashBoardProvider>(
                  builder: (context, dashProvider, child) {
                    log("dashProvider1 ==> ${dashProvider}");
                    return ProductImageCard(
                      labelText: 'Main Image',
                      imageFile: dashProvider.selectedMainImage,
                      imageUrlForUpdateImage:
                          widget.product?.images.safeElementAt(0)?.url,
                      onTap: () async {
                        dashProvider.pickImage(imageCardNumber: 1);
                      },
                      onRemoveImage: () {
                        dashProvider.selectedMainImage = null;
                        dashProvider.updateUI();
                      },
                    );
                  },
                ),
                Consumer<DashBoardProvider>(
                  builder: (context, dashProvider, child) {
                    return ProductImageCard(
                      labelText: 'Second image',
                      imageFile: dashProvider.selectedSecondImage,
                      imageUrlForUpdateImage:
                          widget.product?.images.safeElementAt(1)?.url,
                      onTap: () {
                        dashProvider.pickImage(imageCardNumber: 2);
                      },
                      onRemoveImage: () {
                        dashProvider.selectedSecondImage = null;
                        dashProvider.updateUI();
                      },
                    );
                  },
                ),
                Consumer<DashBoardProvider>(
                  builder: (context, dashProvider, child) {
                    return ProductImageCard(
                      labelText: 'Third image',
                      imageFile: dashProvider.selectedThirdImage,
                      imageUrlForUpdateImage:
                          widget.product?.images.safeElementAt(2)?.url,
                      onTap: () {
                        dashProvider.pickImage(imageCardNumber: 3);
                      },
                      onRemoveImage: () {
                        dashProvider.selectedThirdImage = null;
                        dashProvider.updateUI();
                      },
                    );
                  },
                ),
                Consumer<DashBoardProvider>(
                  builder: (context, dashProvider, child) {
                    return ProductImageCard(
                      labelText: 'Fourth image',
                      imageFile: dashProvider.selectedFourthImage,
                      imageUrlForUpdateImage:
                          widget.product?.images.safeElementAt(3)?.url,
                      onTap: () {
                        dashProvider.pickImage(imageCardNumber: 4);
                      },
                      onRemoveImage: () {
                        dashProvider.selectedFourthImage = null;
                        dashProvider.updateUI();
                      },
                    );
                  },
                ),
                Consumer<DashBoardProvider>(
                  builder: (context, dashProvider, child) {
                    return ProductImageCard(
                      labelText: 'Fifth image',
                      imageFile: dashProvider.selectedFifthImage,
                      imageUrlForUpdateImage:
                          widget.product?.images.safeElementAt(4)?.url,
                      onTap: () {
                        dashProvider.pickImage(imageCardNumber: 5);
                      },
                      onRemoveImage: () {
                        dashProvider.selectedFifthImage = null;
                        dashProvider.updateUI();
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: defaultPadding),
            CustomTextField(
              controller: context.dashBoardProvider.productNameCtrl,
              labelText: 'Product Name',
              onSave: (val) {},
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
              },
            ),
            SizedBox(height: defaultPadding),
            CustomTextField(
              controller: context.dashBoardProvider.productDescCtrl,
              labelText: 'Product Description',
              lineNumber: 3,
              onSave: (val) {},
            ),
            SizedBox(height: defaultPadding),
            if (isMobile) ...[
              // Show dropdowns in column (one by one)
              Consumer<DashBoardProvider>(
                builder: (context, dashProvider, child) {
                  return CustomDropdown(
                    key: ValueKey(dashProvider.selectedCategory?.sId),
                    initialValue: dashProvider.selectedCategory,
                    hintText: dashProvider.selectedCategory?.name ??
                        'Select category',
                    items: context.dataProvider.categories,
                    displayItem: (Category? category) => category?.name ?? '',
                    onChanged: (newValue) {
                      if (newValue != null) {
                        context.dashBoardProvider.filterSubcategory(newValue);
                        // dashProvider.updateUI();
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  );
                },
              ),
              Consumer<DashBoardProvider>(
                builder: (context, dashProvider, child) {
                  return CustomDropdown(
                    key: ValueKey(dashProvider.selectedSubCategory?.sId),
                    hintText: dashProvider.selectedSubCategory?.name ??
                        'Sub category',
                    items: dashProvider.subCategoriesByCategory,
                    initialValue: dashProvider.selectedSubCategory,
                    displayItem: (SubCategory? subCategory) =>
                        subCategory?.name ?? '',
                    onChanged: (newValue) {
                      if (newValue != null) {
                        context.dashBoardProvider.filterBrand(newValue);
                        // dashProvider.updateUI();
                      }
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select sub category';
                      }
                      return null;
                    },
                  );
                },
              ),
              Consumer<DashBoardProvider>(
                builder: (context, dashProvider, child) {
                  return CustomDropdown(
                      key: ValueKey(dashProvider.selectedBrand?.sId),
                      initialValue: dashProvider.selectedBrand,
                      items: dashProvider.brandsBySubCategory,
                      hintText:
                          dashProvider.selectedBrand?.name ?? 'Select Brand',
                      displayItem: (Brand? brand) => brand?.name ?? '',
                      onChanged: (newValue) {
                        if (newValue != null) {
                          dashProvider.selectedBrand = newValue;
                          // dashProvider.updateUI();
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select brand';
                        }
                        return null;
                      });
                },
              ),
            ] else ...[
              // Row layout for large screen
              Row(
                children: [
                  Expanded(
                    child: Consumer<DashBoardProvider>(
                      builder: (context, dashProvider, child) {
                        return CustomDropdown(
                          key: ValueKey(dashProvider.selectedCategory?.sId),
                          initialValue: dashProvider.selectedCategory,
                          hintText: dashProvider.selectedCategory?.name ??
                              'Select category',
                          items: context.dataProvider.categories,
                          displayItem: (Category? category) =>
                              category?.name ?? '',
                          onChanged: (newValue) {
                            if (newValue != null) {
                              context.dashBoardProvider
                                  .filterSubcategory(newValue);
                              // dashProvider.updateUI();
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a category';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Consumer<DashBoardProvider>(
                      builder: (context, dashProvider, child) {
                        return CustomDropdown(
                          key: ValueKey(dashProvider.selectedSubCategory?.sId),
                          hintText: dashProvider.selectedSubCategory?.name ??
                              'Sub category',
                          items: dashProvider.subCategoriesByCategory,
                          initialValue: dashProvider.selectedSubCategory,
                          displayItem: (SubCategory? subCategory) =>
                              subCategory?.name ?? '',
                          onChanged: (newValue) {
                            if (newValue != null) {
                              context.dashBoardProvider.filterBrand(newValue);
                              // dashProvider.updateUI();
                            }
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select sub category';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Consumer<DashBoardProvider>(
                      builder: (context, dashProvider, child) {
                        return CustomDropdown(
                            key: ValueKey(dashProvider.selectedBrand?.sId),
                            initialValue: dashProvider.selectedBrand,
                            items: dashProvider.brandsBySubCategory,
                            hintText: dashProvider.selectedBrand?.name ??
                                'Select Brand',
                            displayItem: (Brand? brand) => brand?.name ?? '',
                            onChanged: (newValue) {
                              if (newValue != null) {
                                dashProvider.selectedBrand = newValue;
                                // dashProvider.updateUI();
                              }
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Please select brand';
                              }
                              return null;
                            });
                      },
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: defaultPadding),
            isMobile
                ? Column(
                    children: [
                      CustomTextField(
                        controller: context.dashBoardProvider.productPriceCtrl,
                        labelText: 'Price',
                        inputType: TextInputType.number,
                        onSave: (val) {},
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter price';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      CustomTextField(
                        controller:
                            context.dashBoardProvider.productOffPriceCtrl,
                        labelText: 'Offer price',
                        inputType: TextInputType.number,
                        onSave: (val) {},
                      ),
                      SizedBox(height: 12),
                      CustomTextField(
                        controller: context.dashBoardProvider.productQntCtrl,
                        labelText: 'Quantity',
                        inputType: TextInputType.number,
                        onSave: (val) {},
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter quantity';
                          }
                          return null;
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller:
                              context.dashBoardProvider.productPriceCtrl,
                          labelText: 'Price',
                          inputType: TextInputType.number,
                          onSave: (val) {},
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter price';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller:
                              context.dashBoardProvider.productOffPriceCtrl,
                          labelText: 'Offer price',
                          inputType: TextInputType.number,
                          onSave: (val) {},
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          controller: context.dashBoardProvider.productQntCtrl,
                          labelText: 'Quantity',
                          inputType: TextInputType.number,
                          onSave: (val) {},
                          validator: (value) {
                            if (value == null) {
                              return 'Please enter quantity';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
            SizedBox(width: defaultPadding),
            isMobile
                ? Column(
                    children: [
                      Consumer<DashBoardProvider>(
                        builder: (context, dashProvider, child) {
                          return CustomDropdown(
                            key:
                                ValueKey(dashProvider.selectedVariantType?.sId),
                            initialValue: dashProvider.selectedVariantType,
                            items: context.dataProvider.variantTypes,
                            displayItem: (VariantType? variantType) =>
                                variantType?.name ?? '',
                            onChanged: (newValue) {
                              if (newValue != null) {
                                context.dashBoardProvider
                                    .filterVariant(newValue);
                                // dashProvider.updateUI();
                              }
                            },
                            hintText: 'Select Variant type',
                          );
                        },
                      ),
                      SizedBox(height: 12),
                      Consumer<DashBoardProvider>(
                        builder: (context, dashProvider, child) {
                          final filteredSelectedItems = dashProvider
                              .selectedVariants
                              .where((item) => dashProvider
                                  .variantsByVariantType
                                  .contains(item))
                              .toList();
                          return MultiSelectDropDown(
                            items: dashProvider.variantsByVariantType,
                            onSelectionChanged: (newValue) {
                              dashProvider.selectedVariants = newValue;
                              // dashProvider.updateUI();
                            },
                            displayItem: (String item) => item,
                            selectedItems: filteredSelectedItems,
                          );
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            return CustomDropdown(
                              key: ValueKey(
                                  dashProvider.selectedVariantType?.sId),
                              initialValue: dashProvider.selectedVariantType,
                              items: context.dataProvider.variantTypes,
                              displayItem: (VariantType? variantType) =>
                                  variantType?.name ?? '',
                              onChanged: (newValue) {
                                if (newValue != null) {
                                  context.dashBoardProvider
                                      .filterVariant(newValue);
                                  // dashProvider.updateUI();
                                }
                              },
                              hintText: 'Select Variant type',
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Consumer<DashBoardProvider>(
                          builder: (context, dashProvider, child) {
                            final filteredSelectedItems = dashProvider
                                .selectedVariants
                                .where((item) => dashProvider
                                    .variantsByVariantType
                                    .contains(item))
                                .toList();
                            return MultiSelectDropDown(
                              items: dashProvider.variantsByVariantType,
                              onSelectionChanged: (newValue) {
                                dashProvider.selectedVariants = newValue;
                                // dashProvider.updateUI();
                              },
                              displayItem: (String item) => item,
                              selectedItems: filteredSelectedItems,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: defaultPadding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: secondaryColor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: defaultPadding),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor,
                  ),
                  onPressed: () async {
                    // Validate and save the form
                    if (context
                        .dashBoardProvider.addProductFormKey.currentState!
                        .validate()) {
                      context.dashBoardProvider.addProductFormKey.currentState!
                          .save();
                      await context.dashBoardProvider.submitProduct();
                      // Navigator.of(context).pop();
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// How to show the popup
void showAddProductForm(BuildContext context, Product? product) {
  final dashProvider = context.read<DashBoardProvider>();

  // Store the form in a variable with a stable key
  final formWidget = ProductSubmitForm(
    key: const ValueKey("AddProductForm"),
    product: product,
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final dialogHeight = screenHeight * 0.8; // 80% of screen height

      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          backgroundColor: bgColor,
          contentPadding: EdgeInsets.zero,
          title: Center(
            child: Text(
              (product == null ? 'ADD' : 'UPDATE') + ' Product'.toUpperCase(),
              style: TextStyle(color: primaryColor),
            ),
          ),
          content: SizedBox(
            height: dialogHeight,
            width: double.maxFinite,
            child: SingleChildScrollView(
              // keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              // child: ProductSubmitForm(product: product),
              // child: ProductSubmitForm(
              //   key: const PageStorageKey('product_submit_form'),
              //   product: product,
              // ),
              child: formWidget, // <- Uses stable key & prevents loss
            ),
          ),
        );
      });
    },
  );
}

extension SafeList<T> on List<T>? {
  T? safeElementAt(int index) {
    // Check if the list is null or if the index is out of range
    if (this == null || index < 0 || index >= this!.length) {
      return null;
    }
    return this![index];
  }
}
