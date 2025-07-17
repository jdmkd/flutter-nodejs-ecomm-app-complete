import 'dart:developer';
import 'package:ecom_client/presentation/device_frame_preview.dart';
// import 'package:device_frame_plus/src/devices/devices.dart';
import 'package:device_frame_plus/device_frame_plus.dart';
import 'package:ecom_client/screen/auth_screen/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:ecom_client/screen/product_by_subcategory_screen/provider/product_by_subcategory_provider.dart';
import 'package:ecom_client/utility/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'screen/home_screen.dart';
import 'screen/auth_screen/login_screen/provider/user_provider.dart';
import 'screen/product_by_category_screen/provider/product_by_category_provider.dart';
import 'screen/product_cart_screen/provider/cart_provider.dart';
import 'screen/product_details_screen/provider/product_detail_provider.dart';
import 'screen/product_favorite_screen/provider/favorite_provider.dart';
import 'screen/profile_screen/provider/profile_provider.dart';
import 'screen/address_screen/provider/address_provider.dart';
import 'utility/app_theme.dart';
import 'utility/extensions.dart';
import 'package:flutter_cart/cart.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:provider/provider.dart';
import 'core/data/data_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'utility/snack_bar_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables with error handling
  try {
    await dotenv.load(fileName: ".env");
    await MediaStore.ensureInitialized();
    MediaStore.appFolder = 'Invoices';
  } catch (e) {
    log("Warning: Could not load .env file: $e");
    log("Warning: MediaStore.ensureInitialized()");
  }

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge); // optional
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  await GetStorage.init();
  var cart = FlutterCart();

  // TODO: Add OneSignal app ID
  // OneSignal.initialize("YOUR_ONE_SIGNAL_APP_ID");
  OneSignal.initialize(dotenv.env['ONESIGNAL_APP_ID'] ?? '');
  OneSignal.Notifications.requestPermission(true);

  await cart.initializeCart(isPersistenceSupportEnabled: true);

  log("AppConfig.baseUrl ==> ${AppConfig.baseUrl}");

  // enable Device Preview Mode
  const bool enablePreviewMode = false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataProvider()),
        ChangeNotifierProvider(
          create: (context) => UserProvider(context.dataProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(context.dataProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductByCategoryProvider(context.dataProvider),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              ProductBySubCategoryProvider(context.dataProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => ProductDetailProvider(context.dataProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(context.userProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => FavoriteProvider(context.dataProvider),
        ),
        ChangeNotifierProvider(
          create: (context) => AddressProvider(context.userProvider),
        ),
      ],
      // child: const MyApp(),
      child: kReleaseMode || !enablePreviewMode
          ? MyApp()
          : FramePreviewWrapper(child: MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  Future<void> _checkInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      SnackBarHelper.showErrorSnackBar(
        'No internet connection. Please check your network.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.userProvider.getLoginUsr();

    return GetMaterialApp(
      useInheritedMediaQuery: true,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.white, // Ensures white background
        canvasColor: Colors.white, // Ensures all surfaces are white
      ),
      themeMode: ThemeMode.system,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
      ),
      home: user?.sId == null ? LoginScreen() : const HomeScreen(),
    );
  }
}
