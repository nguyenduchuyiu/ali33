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
      return Scaffold(
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
            title: 'ali33',
            debugShowCheckedModeBanner: false,
            theme: appThemeNotifier.darkTheme
                ? AppThemeData.darkTheme
                : AppThemeData.lightTheme,
            home: ConnectionCheckWrapper( // Wrap ConnectionCheckWrapper inside MaterialApp
              child: token != null
                  ? HomeScreen()
                  : LoginScreen(isEditing: false),
            ),
          );
        },
      ),
    );
  }
}
// import 'package:ali33/constants/app_them_data.dart';
// import 'package:ali33/services/theme_provider_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_web_plugins/url_strategy.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:connectivity_wrapper/connectivity_wrapper.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:ali33/screens/home.dart';
// import 'package:ali33/screens/login.dart';

// bool? isViewd;
// String? token;
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
//   isViewd = prefs.getBool('onBoard');
//   token = prefs.getString("token");
//   print("isviewd $isViewd");
//   print("token $token");
//   ModeDataStorageService().setTheme(false); 

//   usePathUrlStrategy();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<AppThemeNotifier>(
//       create: (context) => AppThemeNotifier(false),
//       child: Consumer<AppThemeNotifier>(
//         builder: (context, AppThemeNotifier appThemeNotifier, child) {
//           return ConnectivityAppWrapper(
//             app: MaterialApp(
//               title: 'ali33',
//               debugShowCheckedModeBanner: false,
//               theme: appThemeNotifier.darkTheme
//                   ? AppThemeData.darkTheme
//                   : AppThemeData.lightTheme,
//               // darkTheme: ThemeData.dark(),
//               home: token != null 
//                   ? HomeScreen() 
//                   : LoginScreen(isEditing: false),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }


