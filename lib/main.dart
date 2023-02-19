import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class ThemeController extends GetxController {
  final _isDarkModeKey = 'is_dark_mode';
  var isDarkMode = false.obs;

  @override
  void onInit() {
    _loadThemeFromPrefs();
    super.onInit();
  }

  void toggleTheme() {
    isDarkMode.toggle();
    _saveThemeToPrefs();
  }

  void _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool(_isDarkModeKey) ?? false;
  }

  void _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_isDarkModeKey, isDarkMode.value);
  }
}

class MyApp extends StatelessWidget {
  final ThemeController _themeController = ThemeController();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => MaterialApp(
          title: 'Flutter Demo',
          theme: _themeController.isDarkMode.value ? ThemeData.dark() : ThemeData.light(),
          home: MyHomePage(title: 'Flutter Demo Home Page', themeController: _themeController),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final ThemeController themeController;

  const MyHomePage({Key? key, required this.title, required this.themeController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Click the button to toggle the theme:',
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text('Toggle Theme'),
              onPressed: () => themeController.toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}
