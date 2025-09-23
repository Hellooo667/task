import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Enforce light system UI overlays on Android (status/navigation bars)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light, // iOS
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(const TaskApp());
}

class TaskApp extends StatelessWidget {
  const TaskApp({super.key});
  @override
  Widget build(BuildContext context) => Builder(
        builder: (context) {
          final theme = buildAppTheme();
          return MediaQuery(
            // Override platform brightness so any widget querying it sees light.
            data: MediaQuery.of(context).copyWith(platformBrightness: Brightness.light),
            child: MaterialApp(
              title: 'Task Management',
              debugShowCheckedModeBanner: false,
              theme: theme,
              darkTheme: theme, // identical to prevent dark adjustments
              themeMode: ThemeMode.light,
              home: const HomePage(),
            ),
          );
        },
      );
}
