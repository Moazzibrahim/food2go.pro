import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:food2go_app/controllers/Auth/forget_password_provider.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/controllers/Auth/sign_up_provider.dart';
import 'package:food2go_app/controllers/address/get_address_provider.dart';
import 'package:food2go_app/controllers/banners/banners_provider.dart';
import 'package:food2go_app/controllers/categories/categories_provider.dart';
import 'package:food2go_app/controllers/checkout/deal_checkout_provider.dart';
import 'package:food2go_app/controllers/checkout/place_order_provider.dart';
import 'package:food2go_app/controllers/deal/deal_provider.dart';
import 'package:food2go_app/controllers/delivery/history_delivery_provider.dart';
import 'package:food2go_app/controllers/delivery/order_provider.dart';
import 'package:food2go_app/controllers/delivery/profile_delivery_provider.dart';
import 'package:food2go_app/controllers/notification_controller.dart';
import 'package:food2go_app/controllers/orders/orders_history_provider.dart';
import 'package:food2go_app/controllers/orders/orders_provider.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/controllers/profile/edit_profile_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:food2go_app/firebase_options.dart';
import 'package:food2go_app/view/screens/splash_screen/logo_onboarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => CategoriesProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => GetProfileProvider()),
        ChangeNotifierProvider(create: (_) => DealProvider()),
        ChangeNotifierProvider(create: (_) => EditProfileProvider()),
        ChangeNotifierProvider(create: (_) => OtpProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => OrdersHistoryProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => BannerProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => OrderdeliveryProvider()),
        ChangeNotifierProvider(create: (_) => DeliveryUserProvider()),
        ChangeNotifierProvider(create: (_) => OrderHistoryProvider()),
        ChangeNotifierProvider(create: (_) => OrderTypesAndPaymentsProvider()),
        ChangeNotifierProvider(create: (_) => NotificationController()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) => MaterialApp(
          theme: ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: Colors.grey.shade100,
            appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade100),
          ),
          debugShowCheckedModeBanner: false,
          title: 'Food2go',
          home: const LogoOnboarding(),
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
