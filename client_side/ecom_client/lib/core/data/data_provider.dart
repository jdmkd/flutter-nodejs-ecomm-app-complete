import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../models/category.dart';
import '../../models/api_response.dart';
import '../../models/brand.dart';
import '../../models/order.dart';
import '../../models/poster.dart';
import '../../models/product.dart';
import '../../models/sub_category.dart';
import '../../models/user.dart';
import '../../services/http_services.dart';
import '../../utility/constants.dart';
import '../../utility/snack_bar_helper.dart';

class DataProvider extends ChangeNotifier {
  HttpService service = HttpService();

  bool isLoading = true;
  bool isOrderLoading = false;
  bool isInitialized = false; // Track if data has been loaded at least once

  // Order filters
  String? orderStatusFilter;
  DateTimeRange? dateRangeFilter;

  List<Category> _allCategories = [];
  List<Category> _filteredCategories = [];
  List<Category> get categories => _filteredCategories;

  List<SubCategory> _allSubCategories = [];
  List<SubCategory> _filteredSubCategories = [];

  List<SubCategory> get subCategories => _filteredSubCategories;

  List<Brand> _allBrands = [];
  List<Brand> _filteredBrands = [];
  List<Brand> get brands => _filteredBrands;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  List<Product> get products => _filteredProducts;
  List<Product> get allProducts => _allProducts;

  List<Poster> _allPosters = [];
  List<Poster> _filteredPosters = [];
  List<Poster> get posters => _filteredPosters;

  List<Order> _allOrders = [];
  List<Order> _filteredOrders = [];
  List<Order> get orders => _filteredOrders;

  DataProvider() {
    // Initialize data loading
    _initializeData();
  }

  // Initialize data loading with proper error handling
  Future<void> _initializeData() async {
    try {
      isLoading = true;
      notifyListeners();

      await fetchAllData();

      isInitialized = true;
    } catch (e) {
      // Even if there's an error, we should stop loading to show the UI
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllData() async {
    print('DataProvider: fetchAllData called');
    try {
      isLoading = true;
      notifyListeners();

      log('DataProvider: Fetching all data...');
      await Future.wait([
        getAllProduct(),
        getAllCategory(),
        getAllSubCategory(),
        getAllBrands(),
        getAllPosters(),
      ]);
    } catch (e) {
      print('DataProvider: Error in fetchAllData: $e');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Category>> getAllCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'categories');
      if (response.isOk) {
        ApiResponse<List<Category>> apiResponse =
            ApiResponse<List<Category>>.fromJson(
              response.body,
              (json) => (json as List)
                  .map((item) => Category.fromJson(item))
                  .toList(),
            );
        _allCategories = apiResponse.data ?? [];
        _filteredCategories = List.from(
          _allCategories,
        ); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        log('DataProvider: Categories loaded: ${_allCategories.length}');
      }
    } catch (e) {
      log('DataProvider: Error loading categories: $e');
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredCategories;
  }

  void filterCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredCategories = List.from(_allCategories);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredCategories = _allCategories.where((category) {
        return (category.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<SubCategory>> getAllSubCategory({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'subCategories');
      if (response.isOk) {
        ApiResponse<List<SubCategory>> apiResponse =
            ApiResponse<List<SubCategory>>.fromJson(
              response.body,
              (json) => (json as List)
                  .map((item) => SubCategory.fromJson(item))
                  .toList(),
            );
        _allSubCategories = apiResponse.data ?? [];
        _filteredSubCategories = List.from(
          _allSubCategories,
        ); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        log('DataProvider: SubCategories loaded: ${_allSubCategories.length}');
      }
    } catch (e) {
      log('DataProvider: Error loading subcategories: $e');
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredSubCategories;
  }

  void filterSubCategories(String keyword) {
    if (keyword.isEmpty) {
      _filteredSubCategories = List.from(_allSubCategories);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredSubCategories = _allSubCategories.where((subcategory) {
        return (subcategory.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  Future<List<Brand>> getAllBrands({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'brands');
      if (response.isOk) {
        ApiResponse<List<Brand>> apiResponse =
            ApiResponse<List<Brand>>.fromJson(
              response.body,
              (json) =>
                  (json as List).map((item) => Brand.fromJson(item)).toList(),
            );
        _allBrands = apiResponse.data ?? [];
        _filteredBrands = List.from(
          _allBrands,
        ); // Initialize filtered list with all data
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        log('DataProvider: Brands loaded: ${_allBrands.length}');
      }
    } catch (e) {
      log('DataProvider: Error loading brands: $e');
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredBrands;
  }

  void filterBrands(String keyword) {
    if (keyword.isEmpty) {
      _filteredBrands = List.from(_allBrands);
    } else {
      final lowerKeyword = keyword.toLowerCase();
      _filteredBrands = _allBrands.where((brand) {
        return (brand.name ?? '').toLowerCase().contains(lowerKeyword);
      }).toList();
    }
    notifyListeners();
  }

  Future<void> getAllProduct({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'products');

      ApiResponse<List<Product>> apiResponse =
          ApiResponse<List<Product>>.fromJson(
            response.body,
            (json) =>
                (json as List).map((item) => Product.fromJson(item)).toList(),
          );
      _allProducts = apiResponse.data ?? [];
      _filteredProducts = List.from(
        _allProducts,
      ); // Initialize with original data
      notifyListeners();
      if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      log('DataProvider: Products loaded: ${_allProducts.length}');
    } catch (e) {
      log('DataProvider: Error loading products: $e');
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
  }

  void filterProducts(String keyword) {
    if (keyword.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      final lowerKeyword = keyword.toLowerCase();

      _filteredProducts = _allProducts.where((product) {
        final productNameContainsKeyword = (product.name ?? '')
            .toLowerCase()
            .contains(lowerKeyword);
        final categoryNameContainsKeyword =
            product.proSubCategoryId?.name?.toLowerCase().contains(
              lowerKeyword,
            ) ??
            false;
        final subCategoryNameContainsKeyword =
            product.proSubCategoryId?.name?.toLowerCase().contains(
              lowerKeyword,
            ) ??
            false;

        //? You can add more conditions here if there are more fields to match against
        return productNameContainsKeyword ||
            categoryNameContainsKeyword ||
            subCategoryNameContainsKeyword;
      }).toList();
    }
    notifyListeners();
  }

  Future<List<Poster>> getAllPosters({bool showSnack = false}) async {
    try {
      Response response = await service.getItems(endpointUrl: 'posters');
      if (response.isOk) {
        ApiResponse<List<Poster>> apiResponse =
            ApiResponse<List<Poster>>.fromJson(
              response.body,
              (json) =>
                  (json as List).map((item) => Poster.fromJson(item)).toList(),
            );
        _allPosters = apiResponse.data ?? [];
        _filteredPosters = List.from(_allPosters);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
        log('DataProvider: Posters loaded: ${_allPosters.length}');
      }
    } catch (e) {
      log('DataProvider: Error loading posters: $e');
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    }
    return _filteredPosters;
  }

  double calculateDiscountPercentage(num originalPrice, num? discountedPrice) {
    if (originalPrice <= 0) {
      throw ArgumentError('Original price must be greater than zero.');
    }

    //? Ensure discountedPrice is not null; if it is, default to the original price (no discount)
    num finalDiscountedPrice = discountedPrice ?? originalPrice;

    if (finalDiscountedPrice > originalPrice) {
      throw ArgumentError(
        'Discounted price must not be greater than the original price.',
      );
    }

    double discount =
        ((originalPrice - finalDiscountedPrice) / originalPrice) * 100;

    //? Return the discount percentage as an integer
    return discount;
  }

  Future<List<Order>> getAllOrderByUser(
    User? user, {
    bool showSnack = false,
  }) async {
    try {
      isOrderLoading = true;
      notifyListeners();
      String userId = user?.sId ?? '';
      Response response = await service.getItems(
        endpointUrl: 'orders/orderByUserId/$userId',
      );
      if (response.isOk) {
        ApiResponse<List<Order>> apiResponse =
            ApiResponse<List<Order>>.fromJson(
              response.body,
              (json) =>
                  (json as List).map((item) => Order.fromJson(item)).toList(),
            );
        print(apiResponse.message);
        _allOrders = apiResponse.data ?? [];
        _filteredOrders = List.from(_allOrders);
        notifyListeners();
        if (showSnack) SnackBarHelper.showSuccessSnackBar(apiResponse.message);
      }
    } catch (e) {
      if (showSnack) SnackBarHelper.showErrorSnackBar(e.toString());
      rethrow;
    } finally {
      isOrderLoading = false;
      notifyListeners();
    }
    return _filteredOrders;
  }

  // Setters for filters
  void setOrderStatusFilter(String? status) {
    orderStatusFilter = status;
    notifyListeners();
  }

  void setDateRangeFilter(DateTimeRange? range) {
    dateRangeFilter = range;
    notifyListeners();
  }

  // Filtered orders getter
  List<Order> get filteredOrders {
    List<Order> filtered = List.from(_filteredOrders);
    if (orderStatusFilter != null && orderStatusFilter!.isNotEmpty) {
      filtered = filtered
          .where((order) => order.orderStatus == orderStatusFilter)
          .toList();
    }
    if (dateRangeFilter != null) {
      filtered = filtered.where((order) {
        if (order.orderDate == null) return false;
        final orderDate = DateTime.tryParse(order.orderDate!);
        if (orderDate == null) return false;
        return orderDate.isAfter(
              dateRangeFilter!.start.subtract(const Duration(days: 1)),
            ) &&
            orderDate.isBefore(
              dateRangeFilter!.end.add(const Duration(days: 1)),
            );
      }).toList();
    }
    return filtered;
  }

  // Cancel an order by updating its status to 'cancelled'
  Future<void> cancelOrder(String orderId) async {
    try {
      isOrderLoading = true;
      notifyListeners();
      final response = await service.updateItem(
        endpointUrl: 'orders/update',
        itemId: orderId,
        itemData: {"orderStatus": "cancelled"},
        withAuth: true,
      );
      if (response.isOk) {
        SnackBarHelper.showSuccessSnackBar('Order cancelled successfully.');
        // Refresh orders after cancellation
        await fetchAllData();
      } else {
        SnackBarHelper.showErrorSnackBar('Failed to cancel order.');
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar('An error occurred: $e');
    } finally {
      isOrderLoading = false;
      notifyListeners();
    }
  }
}
