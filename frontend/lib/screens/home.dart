import 'package:ali33/screens/pages/home_page.dart';
import 'package:ali33/screens/pages/more_products_page.dart';
import 'package:ali33/screens/pages/profile_page.dart';
import 'package:ali33/screens/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:ali33/constants/constant_values.dart';
import 'package:ali33/models/product_model.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/screens/home.dart';
import 'package:ali33/screens/pages/profile_page.dart';
import 'package:ali33/screens/product_details.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final int selectedPage;
  const HomeScreen({super.key, required this.selectedPage});

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
    const SearchPage(),
    const SizedBox(),
  ];
  @override
  void initState() {
    _selectedPage = widget.selectedPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar : AppBar(
        toolbarHeight: 80,
        flexibleSpace: 
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // shrinkWrap: true, 
                height: 80,
                width: size.width-16*2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff8a2387), // Start color
                      Color(0xffe94057),
                      Color(0xfff27121) // End color
                    ]
                  ),
                ),

                child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const HomeScreen(selectedPage: 0)), // Giả sử HomePage là trang đầu tiên trong HomeScreen
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Image.asset("images/logo.png", height: 50,),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(height: 18,),
                      Text("More Quality",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontWeight: FontWeight.w700,fontSize: 17)),
                      Text("for Less Quantity",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontWeight: FontWeight.w500,fontSize: 15)),
                    ],
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      // Handle the tap
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage("images/user.jpeg"),
                    ),
                  )
                ],
              ),
              ),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedPage,
          children: dummyPages,
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   elevation: 0,
      //   showSelectedLabels: false,
      //   showUnselectedLabels: false,
      //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //   type: BottomNavigationBarType.fixed,
      //   currentIndex: _selectedPage,
      //   onTap: (int page) {
      //     setState(() {
      //       if(page == 0){
      //       dummyPages[page] = _pages[page];
      //       }else if(page == 1){
      //       dummyPages[page] = _pages[page];
      //       }else if(page ==2){
      //         dummyPages[page] = _pages[page];
      //       }else if(page ==3 ){
      //         dummyPages[page] = _pages[page];
      //       }
      //       _selectedPage = page;
      //     });
      //   },
      //   selectedIconTheme:
      //       IconThemeData(color: Theme.of(context).primaryColor, size: 30),
      //   unselectedIconTheme: IconThemeData(
      //       color: Theme.of(context).textTheme.bodyLarge!.color, size: 22),
      //   items: const [
      //     BottomNavigationBarItem(
      //       label: "",
      //       icon: ImageIcon(AssetImage("images/home_icon.png")),
      //     ),
      //     BottomNavigationBarItem(
      //       label: "",
      //       icon: ImageIcon(AssetImage("images/products_icon.png")),
      //     ),
      //     BottomNavigationBarItem(
      //       label: "",
      //       icon: ImageIcon(AssetImage("images/search_icon.png")),
      //     ),
      //     BottomNavigationBarItem(
      //       label: "",
      //       icon: ImageIcon(AssetImage("images/profile_icon.png")),
      //     ),
      //   ],
      // ),
    );
  }
}