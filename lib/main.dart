import 'package:flutter/material.dart';
import 'package:products_shop_app/src/bloc/provider.dart';
import 'package:products_shop_app/src/pages/home_page.dart';
import 'package:products_shop_app/src/pages/login_page.dart';
import 'package:products_shop_app/src/pages/product_page.dart';
import 'package:products_shop_app/src/pages/signup.dart';
import 'package:products_shop_app/src/user_preferences/user_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new UserPreferences();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'signup': (BuildContext context) => SignUp(),
          'home': (BuildContext context) => HomePage(),
          'product': (BuildContext context) => ProductPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ),
      ),
    );
  }
}
