// ignore_for_file: avoid_print

import 'package:ali33/constants/app_them_data.dart';
import 'package:ali33/services/theme_provider_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // Use connectivity_plus
import 'package:ali33/screens/home.dart';
import 'package:ali33/screens/login.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:js' as js;

bool? isViewd;
String? token;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  isViewd = prefs.getBool('onBoard');
  token = prefs.getString("token");
  ModeDataStorageService().setTheme(false);

  usePathUrlStrategy();
  runApp(const MyApp());
}

// Connection Check Widget (as defined in the previous response)
class ConnectionCheckWrapper extends StatefulWidget {
  final Widget child;

  const ConnectionCheckWrapper({Key? key, required this.child}) : super(key: key);

  @override
  State<ConnectionCheckWrapper> createState() => _ConnectionCheckWrapperState();
}

class _ConnectionCheckWrapperState extends State<ConnectionCheckWrapper> {
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    // String stripePublishableKey = 'pk_test_51PK0KuP4liLqgqFbwdFJwpwoB0tUisAl7D9bqyRzpaFrF0DmX1bCdxK5dyXCsmJyN1Y00uCfL4rlzLws4B1Ji52J0008I34doS';
    // js.context.callMethod('Stripe', [stripePublishableKey]); 
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() => _isConnected = result != ConnectivityResult.none);
    });
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    setState(() => _isConnected = result != ConnectivityResult.none);
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected) {
      return widget.child;
    } else {
      return const Scaffold(
        body: Center(
          child: Text('No internet connection!'),
        ),
      );
    }
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppThemeNotifier>(
      create: (context) => AppThemeNotifier(false),
      child: Consumer<AppThemeNotifier>(
        builder: (context, AppThemeNotifier appThemeNotifier, child) {
          return MaterialApp( // Move MaterialApp to the outer level
            title: 'ALI33',
            debugShowCheckedModeBanner: false,
            theme: appThemeNotifier.darkTheme
                ? AppThemeData.darkTheme
                : AppThemeData.lightTheme,
            home: ConnectionCheckWrapper( // Wrap ConnectionCheckWrapper inside MaterialApp
              child: token != null
                  ? const HomeScreen(selectedPage: 0,)
                  : const LoginScreen(isEditing: false),
            ),
          );
        },
      ),
    );
  }
}



