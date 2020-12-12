import 'package:books_app/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth_provider.dart';
import './providers/book_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './screens/auth_screen.dart';
import './screens/book_overview_screen.dart';
import './screens/cart_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => AuthProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => CartProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => OrdersProvider(),
          ),
          ChangeNotifierProxyProvider<AuthProvider, BookProvider>(
            create: (_) => BookProvider(null),
            update: (ctx, authProvider, prevState) =>
                BookProvider(authProvider.token),
          ),
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Book Shop',
            theme: ThemeData(
              primaryColor: Colors.blue,
            ),
            home: auth.isAuth ? BookOverviewScreen() : AuthScreen(),
            routes: {
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              BookOverviewScreen.routeName: (ctx) => BookOverviewScreen(),
            },
          ),
        ));
  }
}
