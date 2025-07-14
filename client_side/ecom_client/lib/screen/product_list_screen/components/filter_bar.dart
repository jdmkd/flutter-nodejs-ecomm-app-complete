import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/brand.dart';
import '../../../models/sub_category.dart';
import '../../../widget/multi_select_drop_down.dart';
import '../../../widget/custom_text_field.dart';

class FilterBar extends StatefulWidget {
  final List<Brand> brandsForSubCat;
  final List<Brand> selectedBrands;
  final double? minPrice;
  final double? maxPrice;
  final String? sortOption;
  final List<String> priceRanges;
  final String? selectedPriceRange;
  final List<String> sortOptions;
  final String selectedSortLabel;
  final ValueChanged<List<Brand>> onBrandsChanged;
  final ValueChanged<double?> onMinPriceChanged;
  final ValueChanged<double?> onMaxPriceChanged;
  final ValueChanged<String?> onSortOptionChanged;
  final ValueChanged<String?> onPriceRangeChanged;
  final VoidCallback onClearAll;

  const FilterBar({
    super.key,
    required this.brandsForSubCat,
    required this.selectedBrands,
    required this.minPrice,
    required this.maxPrice,
    required this.sortOption,
    required this.priceRanges,
    required this.selectedPriceRange,
    required this.sortOptions,
    required this.selectedSortLabel,
    required this.onBrandsChanged,
    required this.onMinPriceChanged,
    required this.onMaxPriceChanged,
    required this.onSortOptionChanged,
    required this.onPriceRangeChanged,
    required this.onClearAll,
  });

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  @override
  Widget build(BuildContext context) {
    // Filter summary chips
    final List<Widget> filterChips = [];
    if (widget.selectedBrands.isNotEmpty) {
      for (final brand in widget.selectedBrands) {
        filterChips.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Chip(
              label: Text(brand.name ?? ''),
              onDeleted: () {
                final updated = List<Brand>.from(widget.selectedBrands);
                updated.remove(brand);
                widget.onBrandsChanged(updated);
              },
            ),
          ),
        );
      }
    }
    if (widget.minPrice != null || widget.maxPrice != null) {
      filterChips.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Chip(
            label: Text(
              '\u20b9${widget.minPrice?.toStringAsFixed(0) ?? "0"} - \u20b9${widget.maxPrice?.toStringAsFixed(0) ?? "\u221e"}',
            ),
            onDeleted: () {
              widget.onMinPriceChanged(null);
              widget.onMaxPriceChanged(null);
              widget.onPriceRangeChanged(null);
            },
          ),
        ),
      );
    }
    if (widget.sortOption != null) {
      filterChips.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Chip(
            label: Text(widget.sortOption!),
            onDeleted: () => widget.onSortOptionChanged(null),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filter controls row (price, sort, filter)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Price button (ActionChip style)
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                alignment: Alignment.center,
                child: ActionChip(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  label: const Text(
                    'Price',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  avatar: const Icon(
                    Icons.currency_rupee,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final result = await showModalBottomSheet<String>(
                      context: context,
                      useRootNavigator: true,
                      backgroundColor: Colors.white,
                      builder: (context) {
                        return ListView(
                          children: widget.priceRanges
                              .map(
                                (range) => ListTile(
                                  title: Text(range),
                                  onTap: () => Navigator.pop(context, range),
                                ),
                              )
                              .toList(),
                        );
                      },
                    );
                    if (result != null) {
                      widget.onPriceRangeChanged(result);
                    }
                  },
                  backgroundColor: Colors.blueAccent[400],
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.white70, width: 1),
                  ),
                  elevation: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            // Sort button
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                alignment: Alignment.center,
                child: ActionChip(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  label: const Text(
                    'Sort',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  avatar: const Icon(Icons.sort, size: 20, color: Colors.white),
                  onPressed: () async {
                    final result = await showModalBottomSheet<String>(
                      context: context,
                      useRootNavigator: true,
                      backgroundColor: Colors.white,
                      builder: (context) {
                        return ListView(
                          children: widget.sortOptions
                              .map(
                                (option) => ListTile(
                                  title: Text(option),
                                  onTap: () => Navigator.pop(context, option),
                                ),
                              )
                              .toList(),
                        );
                      },
                    );
                    if (result != null) {
                      widget.onSortOptionChanged(result);
                    }
                  },
                  backgroundColor: Colors.blueAccent[400],
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.white70, width: 1),
                  ),
                  elevation: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
            // Filter button
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minHeight: 48),
                alignment: Alignment.center,
                child: ActionChip(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  label: const Text(
                    'Filter',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  avatar: const Icon(
                    Icons.filter_alt,
                    size: 20,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    // Local state for popup
                    List<Brand> tempSelectedBrands = List.from(
                      widget.selectedBrands,
                    );
                    TextEditingController tempMinPriceController =
                        TextEditingController(
                          text: widget.minPrice?.toString() ?? '',
                        );
                    TextEditingController tempMaxPriceController =
                        TextEditingController(
                          text: widget.maxPrice?.toString() ?? '',
                        );
                    String? tempSelectedPriceRange = widget.selectedPriceRange;
                    await showModalBottomSheet(
                      context: context,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: StatefulBuilder(
                            builder: (context, setModalState) {
                              return SingleChildScrollView(
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Center(
                                        child: Text(
                                          'Filter Options',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      // Brand multi-select
                                      if (widget
                                          .brandsForSubCat
                                          .isNotEmpty) ...[
                                        const Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 6,
                                            left: 2,
                                          ),
                                          child: Text(
                                            'Brand',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 16,
                                          ),
                                          child: MultiSelectDropDown<Brand>(
                                            items: widget.brandsForSubCat,
                                            selectedItems: tempSelectedBrands,
                                            displayItem: (b) => b.name ?? '',
                                            onSelectionChanged: (brands) {
                                              setModalState(() {
                                                tempSelectedBrands = List.from(
                                                  brands,
                                                );
                                              });
                                            },
                                            hintText: 'Select Brands',
                                          ),
                                        ),
                                      ],
                                      // Price range quick select
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 6,
                                          left: 2,
                                        ),
                                        child: Text(
                                          'Price Range',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: widget.priceRanges.map((
                                            range,
                                          ) {
                                            final selected =
                                                tempSelectedPriceRange == range;
                                            return ChoiceChip(
                                              label: Text(
                                                range,
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              selected: selected,
                                              selectedColor:
                                                  Colors.indigoAccent[100],
                                              backgroundColor: Colors.grey[100],
                                              labelStyle: TextStyle(
                                                color: selected
                                                    ? Colors.white
                                                    : Colors.black45,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              onSelected: (val) {
                                                setModalState(() {
                                                  tempSelectedPriceRange = val
                                                      ? range
                                                      : null;
                                                  // Set min/max price based on range
                                                  if (val) {
                                                    if (range == 'Below ₹500') {
                                                      tempMinPriceController
                                                              .text =
                                                          '';
                                                      tempMaxPriceController
                                                              .text =
                                                          '500';
                                                    } else if (range ==
                                                        '₹500 - ₹1000') {
                                                      tempMinPriceController
                                                              .text =
                                                          '500';
                                                      tempMaxPriceController
                                                              .text =
                                                          '1000';
                                                    } else if (range ==
                                                        '₹1000 - ₹5000') {
                                                      tempMinPriceController
                                                              .text =
                                                          '1000';
                                                      tempMaxPriceController
                                                              .text =
                                                          '5000';
                                                    } else if (range ==
                                                        'Above ₹5000') {
                                                      tempMinPriceController
                                                              .text =
                                                          '5000';
                                                      tempMaxPriceController
                                                              .text =
                                                          '';
                                                    } else {
                                                      tempMinPriceController
                                                              .text =
                                                          '';
                                                      tempMaxPriceController
                                                              .text =
                                                          '';
                                                    }
                                                  }
                                                });
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      // Custom price
                                      const Padding(
                                        padding: EdgeInsets.only(
                                          bottom: 6,
                                          left: 2,
                                        ),
                                        child: Text(
                                          'Custom Price',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 1,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: 65,
                                                child: CustomTextField(
                                                  labelText: 'Min',
                                                  controller:
                                                      tempMinPriceController,
                                                  inputType:
                                                      TextInputType.number,
                                                  onSave: (_) {},
                                                  height: 65,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Expanded(
                                              child: SizedBox(
                                                height: 65,
                                                child: CustomTextField(
                                                  labelText: 'Max',
                                                  controller:
                                                      tempMaxPriceController,
                                                  inputType:
                                                      TextInputType.number,
                                                  onSave: (_) {},
                                                  height: 65,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 28),
                                      Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Color(0xFFF0F0F0),
                                      ),
                                      const SizedBox(height: 18),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  Colors.indigoAccent[400],
                                              backgroundColor: Colors
                                                  .indigoAccent
                                                  .withOpacity(0.08),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 22,
                                                    vertical: 12,
                                                  ),
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              widget.onClearAll();
                                            },
                                            child: const Text('Clear All'),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.indigoAccent[400],
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 32,
                                                    vertical: 12,
                                                  ),
                                              textStyle: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                            onPressed: () {
                                              // Apply selected filters
                                              double? min;
                                              double? max;
                                              if (tempMinPriceController
                                                  .text
                                                  .isNotEmpty) {
                                                min = double.tryParse(
                                                  tempMinPriceController.text,
                                                );
                                              }
                                              if (tempMaxPriceController
                                                  .text
                                                  .isNotEmpty) {
                                                max = double.tryParse(
                                                  tempMaxPriceController.text,
                                                );
                                              }
                                              widget.onBrandsChanged(
                                                tempSelectedBrands,
                                              );
                                              widget.onMinPriceChanged(min);
                                              widget.onMaxPriceChanged(max);
                                              widget.onPriceRangeChanged(
                                                tempSelectedPriceRange,
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Apply'),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                  backgroundColor: Colors.blueAccent[400],
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.white70, width: 1),
                  ),
                  elevation: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        ),
        // Filter summary chips row (chips + clear all)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...filterChips,
              if (filterChips.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                      backgroundColor: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.black54,
                      size: 20,
                    ),
                    label: const Text(
                      'Clear All',
                      style: TextStyle(color: Colors.black54),
                    ),
                    onPressed: widget.onClearAll,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
