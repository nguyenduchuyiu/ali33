import 'package:ali33/screens/pages/home_page.dart';
import 'package:ali33/screens/pages/more_products_page.dart';
import 'package:ali33/screens/pages/profile_page.dart';
import 'package:ali33/screens/pages/search_page.dart';
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
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedPage,
          children: dummyPages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPage,
        onTap: (int page) {
          setState(() {
            if(page == 0){
            dummyPages[page] = _pages[page];
            }else if(page == 1){
            dummyPages[page] = _pages[page];
            }else if(page ==2){
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
            icon: ImageIcon(AssetImage("images/home_icon.png")),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: ImageIcon(AssetImage("images/products_icon.png")),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: ImageIcon(AssetImage("images/search_icon.png")),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: ImageIcon(AssetImage("images/profile_icon.png")),
          ),
        ],
      ),
    );
  }
}