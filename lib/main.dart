import 'dart:async';
import 'package:curve/home/home_screen_page.dart';
import 'package:curve/routes/AppRouter.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as developer;

void main() {
  String TAG = "Main";
  runZonedGuarded(() async {
    runApp(
        ProviderScope(child: MyApp())
    );
  },(error, stackTrace) {
    developer.log(TAG , name: "Error FROM OUT_SIDE FRAMEWORK ");
    developer.log(TAG , name: "--------------------------------");
    developer.log(TAG , name: "Error :  $error");
    developer.log(TAG , name: "StackTrace :  $stackTrace");
  });

}

class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key);
  final _appRouter = AppRouter();
  String currentScreen = "Main";
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Curve Tomorrow",
      routeInformationParser: _appRouter.defaultRouteParser(),
      routerDelegate: _appRouter.delegate(),
      builder: (context, router) => router!,
    );
  }
}

