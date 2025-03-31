import 'package:flutter/cupertino.dart';
import 'package:flutter_cart/flutter_cart.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/product.dart';
import '../../../utility/snack_bar_helper.dart';
import '../../../utility/utility_extention.dart';

class ProductDetailProvider extends ChangeNotifier {
  final DataProvider _dataProvider;
  String? selectedVariant;
  var flutterCart = FlutterCart();

  ProductDetailProvider(this._dataProvider);

  void addToCart(Product product) {
    if (product.proVariantId!.isNotEmpty && selectedVariant == null) {
      SnackBarHelper.showErrorSnackBar('Please select a variant');
      return;
    }
    double? price = product.offerPrice != product.price
        ? product.offerPrice
        : product.price;

    String imageUrl = product.images != null && product.images!.isNotEmpty
        ? product.images![0].url?.replaceAll('localhost', '192.168.141.74') ??
            ''
        : 'https://dummyimage.com/300x400/aaaaaa/ffffff&text=Loading...';

    flutterCart.addToCart(
      cartModel: CartModel(
          productId: '${product.sId}',
          productName: '${product.name}',
          // productImages: ['${product.images.safeElementAt(0)?.url}'],
          productImages: [imageUrl],
          variants: [ProductVariant(price: price ?? 0, color: selectedVariant)],
          productDetails: '${product.description}'),
    );

    selectedVariant = null;
    SnackBarHelper.showSuccessSnackBar('Item Added');
    notifyListeners();
  }

  //? to update UI
  void updateUI() {
    notifyListeners();
  }
}
