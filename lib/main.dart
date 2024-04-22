import 'package:online_store/constants/app_them_data.dart';
import 'package:online_store/services/theme_provider_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:online_store/screens/home.dart';
import 'package:online_store/screens/login.dart';

bool? isViewd;
String? token;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  isViewd = prefs.getBool('onBoard');
  token = prefs.getString("token");
  print("isviewd $isViewd");
  print("token $token");
  ModeDataStorageService().setTheme(false); 

  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppThemeNotifier>(
      create: (context) => AppThemeNotifier(false),
      child: Consumer<AppThemeNotifier>(
        builder: (context, AppThemeNotifier appThemeNotifier, child) {
          return ConnectivityAppWrapper(
            app: MaterialApp(
              title: 'online_store',
              debugShowCheckedModeBanner: false,
              theme: appThemeNotifier.darkTheme
                  ? AppThemeData.darkTheme
                  : AppThemeData.lightTheme,
              // darkTheme: ThemeData.dark(),
              home: token != null 
                  ? HomeScreen() 
                  : LoginScreen(isEditing: false),
            ),
          );
        },
      ),
    );
  }
}


