import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food2go_app/controllers/Auth/forget_password_provider.dart';
import 'package:food2go_app/controllers/Auth/login_provider.dart';
import 'package:food2go_app/controllers/Auth/sign_up_provider.dart';
import 'package:food2go_app/controllers/address/get_address_provider.dart';
import 'package:food2go_app/controllers/categories/categories_provider.dart';
import 'package:food2go_app/controllers/deal/deal_provider.dart';
import 'package:food2go_app/controllers/product_provider.dart';
import 'package:food2go_app/controllers/profile/edit_profile_provider.dart';
import 'package:food2go_app/controllers/profile/get_profile_provider.dart';
import 'package:food2go_app/view/screens/splash_screen/logo_onboarding.dart';
import 'package:provider/provider.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
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
        ChangeNotifierProvider(create: (_) => AddressProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: Colors.grey.shade100,
            appBarTheme: AppBarTheme(backgroundColor: Colors.grey.shade100)),
        debugShowCheckedModeBanner: false,
        title: 'Food2go',
        home: const LogoOnboarding(),
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
