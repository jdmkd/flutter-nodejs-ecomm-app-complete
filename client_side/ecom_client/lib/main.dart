import 'dart:developer';

import 'package:device_preview/device_preview.dart';
import 'package:ecom_client/screen/product_by_subcategory_screen/provider/product_by_subcategory_provider.dart';
import 'package:ecom_client/utility/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screen/home_screen.dart';
import 'screen/auth_screen/login_screen/login_screen.dart';
import 'screen/auth_screen/login_screen/provider/user_provider.dart';
import 'screen/product_by_category_screen/provider/product_by_category_provider.dart';
import 'screen/product_cart_screen/provider/cart_provider.dart';
import 'screen/product_details_screen/provider/product_detail_provider.dart';
import 'screen/product_favorite_screen/provider/favorite_provider.dart';
import 'screen/profile_screen/provider/profile_provider.dart';
import 'utility/app_theme.dart';
import 'utility/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/cart.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:provider/provider.dart';
import 'core/data/data_provider.dart';
import 'models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Ensure the status bar is visible with proper contrast
  // SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  //   statusBarColor: Colors.white, // White background for status bar
  //   statusBarIconBrightness:
  //       Brightness.dark, // Dark icons for better visibility
  //   statusBarBrightness: Brightness.light, // iOS-specific
  // ));

  await GetStorage.init();
  var cart = FlutterCart();

  // TODO: Add OneSignal app ID
  // OneSignal.initialize("YOUR_ONE_SIGNAL_APP_ID");
  OneSignal.initialize(dotenv.env['ONESIGNAL_APP_ID'] ?? '');

  OneSignal.Notifications.requestPermission(true);
  await cart.initializeCart(isPersistenceSupportEnabled: true);
  log("AppConfig.baseUrl ==> ${AppConfig.baseUrl}");
  runApp(
    DevicePreview(
      enabled: false, // Set to false to disable DevicePreview
      backgroundColor: Colors.white,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => DataProvider()),
          ChangeNotifierProvider(
              create: (context) => UserProvider(context.dataProvider)),
          ChangeNotifierProvider(
              create: (context) => ProfileProvider(context.dataProvider)),
          ChangeNotifierProvider(
              create: (context) =>
                  ProductByCategoryProvider(context.dataProvider)),
          ChangeNotifierProvider(
              create: (context) =>
                  ProductBySubCategoryProvider(context.dataProvider)),
          ChangeNotifierProvider(
              create: (context) => ProductDetailProvider(context.dataProvider)),
          ChangeNotifierProvider(
              create: (context) => CartProvider(context.userProvider)),
          ChangeNotifierProvider(
              create: (context) => FavoriteProvider(context.dataProvider)),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? loginUser = context.userProvider.getLoginUsr();
    return GetMaterialApp(
      builder: DevicePreview.appBuilder, // Integrate DevicePreview
      useInheritedMediaQuery: true, // Ensures proper media query handling
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      debugShowCheckedModeBanner: false,
      home: loginUser?.sId == null ? LoginScreen() : const HomeScreen(),
      theme: AppTheme.lightAppTheme,
    );
  }
}
