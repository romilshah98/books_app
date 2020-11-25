import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth_provider.dart';
import './providers/book_provider.dart';
import './screens/auth_screen.dart';
import './screens/book_overview_screen.dart';

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
          ChangeNotifierProxyProvider<AuthProvider, BookProvider>(
            create: (_) => BookProvider(null),
            update: (ctx, authProvider, prevState) =>
                BookProvider(authProvider.token),
          ),
          // ChangeNotifierProvider(
          //   create: (_) => ListProvider(),
          // ),
          // ChangeNotifierProxyProvider<AuthProvider, PostProvider>(
          //   create: (_) => PostProvider('', ''),
          //   update: (ctx, authProvider, prevState) =>
          //       PostProvider(authProvider.email, authProvider.password),
          // ),
        ],
        child: Consumer<AuthProvider>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Book Shop',
            theme: ThemeData(
              primaryColor: Colors.blue,
            ),
            home: auth.isAuth ? BookOverviewScreen() : AuthScreen(),
            // routes: {
            //   HashTagList.routeName: (ctx) => HashTagList(),
            //   NickNameList.routeName: (ctx) => NickNameList(),
            //   NickNamePosts.routeName: (ctx) => NickNamePosts(),
            //   HashTagPosts.routeName: (ctx) => HashTagPosts(),
            //   AddPost.routeName: (ctx) => AddPost(),
            // },
          ),
        ));
  }
}
