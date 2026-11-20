import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'screens/setup_screen.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const HackatimeApp());
}

class HackatimeApp extends StatelessWidget {
  const HackatimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hackatime',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppRouter(),
    );
  }
}

class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  bool _isLoading = true;
  bool _hasApiKey = false;

  @override
  void initState() {
    super.initState();
    _checkApiKey();
  }

  Future<void> _checkApiKey() async {
    final apiKey = await ApiService.getApiKey();
    setState(() {
      _hasApiKey = apiKey != null && apiKey.isNotEmpty;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A0F),
        body: Center(
          child: CupertinoActivityIndicator(
            radius: 16,
            color: Colors.white,
          ),
        ),
      );
    }

    return _hasApiKey
        ? const HomeScreen()
        : SetupScreen(onComplete: () {
            setState(() => _hasApiKey = true);
          });
  }
}
