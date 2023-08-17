import 'package:dynamic_color/dynamic_color.dart' show DynamicColorBuilder;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode;

import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => MaterialApp(
        title: 'Flutter Wordle',
        theme: ThemeData(
          colorScheme: lightDynamic,
        ),
        darkTheme: ThemeData(
          colorScheme: darkDynamic,
          brightness: Brightness.dark,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
