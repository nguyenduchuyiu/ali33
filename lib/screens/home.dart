import 'package:online_store/screens/pages/home_page.dart';
import 'package:online_store/screens/pages/more_products_page.dart';
import 'package:online_store/screens/pages/profile_page.dart';
import 'package:online_store/screens/pages/search_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPage = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const ProductsPage(),
    const SearchPage(),
    const ProfilePage(),
  ];
  final List<Widget> dummyPages = [
    const HomePage(),
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedPage,
          children: dummyPages,
        ),
      ),
      // Container(
      //   height: MediaQuery.of(context).size.height,
      //   width: MediaQuery.of(context).size.width,
      //   color: Colors.amber,
      //   alignment: Alignment.center,
      //   child: SizedBox(
      //     height: 56,
      //     width: 200,
      //     child: OutlinedButton(
      //         style: OutlinedButton.styleFrom(
      //             fixedSize: Size(200, 56), backgroundColor: Colors.green),
      //         onPressed: () async {
      //           Navigator.push(
      //               context,
      //               SlideLeftRoute(
      //                   widget: ProfileScreen(
      //                 isFirstTime: false,
      //                 userModel: UserModel(
      //                   cartItems: [],
      //                   deliveryAddress: [],
      //                   deviceToken: "deviceToken",
      //                   dob: DateTime.now(),
      //                   emailId: "surya@gmail.com",
      //                   name: "",
      //                   orders: [],
      //                   phoneNo: "",
      //                   profilePic: "",
      //                   userType: "customer",
      //                 ),
      //               )));
      //           // _ripplePageTransition.navigateTo(OtpScreen(email: "iamhere11229@gmail.com", isPresent: ""));
      //           // await ApiService().register();
      //           // Navigator.of(context).push(FadeRouteBuilder(page: OnboardingScreen()));
      //           // rippleController.currentState!.pushRippleTransitionPage(
      //           //   context,
      //           //   OnboardingScreen(),
      //           // );
      //         },
      //         child: const Text("Click Here")),
      //   ),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPage,
        onTap: (int page) {
          setState(() {
            if(page == 1){
            dummyPages[page] = _pages[page];
            }
            else if(page ==2){
              dummyPages[page] = _pages[page];
            }else if(page ==3 ){
              dummyPages[page] = _pages[page];
            }
            _selectedPage = page;
          });
        },
        selectedIconTheme:
            IconThemeData(color: Theme.of(context).primaryColor, size: 30),
        unselectedIconTheme: IconThemeData(
            color: Theme.of(context).textTheme.bodyLarge!.color, size: 22),
        items: const [
          BottomNavigationBarItem(
            label: "",
            icon: ImageIcon(AssetImage("assets/images/home_icon.png")),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: ImageIcon(AssetImage("assets/images/products_icon.png")),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: ImageIcon(AssetImage("assets/images/search_icon.png")),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: ImageIcon(AssetImage("assets/images/profile_icon.png")),
          ),
        ],
      ),
    );
  }
}


// class FadeRouteBuilder<T> extends PageRouteBuilder<T> {
//   final Widget page;

//   FadeRouteBuilder({required this.page})
//       : super(
//           pageBuilder: (context, animation, secondaryAnimation) => page,
//           transitionDuration: Duration(milliseconds: 1000),
//           transitionsBuilder: (
//             context,
//             animation,
//             secondaryAnimation,
//             child,
//           ) {
//             return FadeTransition(
//               opacity: animation,
//               child: child,
//             );
//           },
//         );
// }

// class FadeTransitionRoute extends PageRouteBuilder {
//   final Widget widget;

//   FadeTransitionRoute({required this.widget})
//       : super(
//           transitionDuration: Duration(milliseconds: 1000),
//           pageBuilder: (BuildContext context, Animation<double> animation,
//               Animation<double> secondaryAnimation) {
//             return widget;
//           },
//           transitionsBuilder: (BuildContext context,
//               Animation<double> animation,
//               Animation<double> secondaryAnimation,
//               Widget child) {
//             animation =
//                 CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
//             return FadeTransition(
//               opacity: animation,
//               child: child,
//             );
//           },
//         );
// }
