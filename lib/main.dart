import 'package:flutter/material.dart';
import 'package:testing_flutter/config/app_router.dart';
import 'package:testing_flutter/core/di/app_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
  setup();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),  
        useMaterial3: true,
        fontFamily: 'Outfit'
        ),
    );
  }
}