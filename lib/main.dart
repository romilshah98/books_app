import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth_provider.dart';
import './providers/book_provider.dart';
import './providers/cart_provider.dart';
import './providers/orders_provider.dart';
import './screens/auth_screen.dart';
import './screens/book_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        ChangeNotifierProxyProvider<AuthProvider, BookProvider>(
          create: (_) => BookProvider(null),
          update: (ctx, authProvider, prevState) =>
              BookProvider(authProvider.token),
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrdersProvider>(
          create: (_) => OrdersProvider(null, null),
          update: (ctx, authProvider, prevState) =>
              OrdersProvider(authProvider.token, authProvider.userId),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Book Shop',
          theme: ThemeData(
            primaryColor: Colors.blue,
          ),
          home: auth.isAuth
              ? BookOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, snapShot) =>
                      snapShot.connectionState == ConnectionState.waiting
                          ? Container(child: CircularProgressIndicator())
                          : AuthScreen(),
                ),
          routes: {
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            BookOverviewScreen.routeName: (ctx) => BookOverviewScreen(),
          },
        ),
      ),
    );
  }
}
