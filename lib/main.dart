import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_switch/src/features/home/controller/home_view_controller.dart';
import 'package:virtual_switch/src/features/home/view/home_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeViewController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Data Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      home: const DataExplorerScreen(),
    );
  }
}
