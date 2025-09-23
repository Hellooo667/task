import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/home_page.dart';

void main() => runApp(const TaskApp());

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Task Management',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
    themeMode: ThemeMode.light,
        home: const HomePage(),
      );
}
