import 'package:ali33/screens/pages/home_page.dart';
import 'package:ali33/screens/pages/more_products_page.dart';
import 'package:ali33/screens/pages/profile_page.dart';
import 'package:ali33/screens/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/services/authenticate_service.dart';
import 'package:ali33/screens/cart.dart';
import 'package:ali33/bloc/cart_bloc.dart';
import 'package:ali33/services/theme_provider_service.dart';
import 'package:ali33/bloc/cart_bloc.dart';
import 'package:ali33/constants/route_animation.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/screens/cart.dart';
import 'package:ali33/screens/delivery_address.dart';
import 'package:ali33/screens/login.dart';
import 'package:ali33/screens/orders.dart';
import 'package:ali33/screens/pages/home_page.dart';
import 'package:ali33/screens/profile.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/services/authenticate_service.dart';
import 'package:ali33/services/theme_provider_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:ali33/widgets/error_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ali33/screens/home.dart';

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
    // const SearchPage(),
    const ProfilePage(),
  ];
  final List<Widget> dummyPages = [
    const HomePage(),
    const SizedBox(),
    // const SearchPage(),
    const SizedBox(),
  ];
  @override
  void initState() {
    _selectedPage = widget.selectedPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<UserModel?>? user = UserService.authenticateUser(context);
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
                  const Spacer(),
                  FutureBuilder(
                      future: user, // Gọi hàm lấy dữ liệu người dùng hiện tại
                      builder: (BuildContext context, AsyncSnapshot<UserModel?> snapshot) {
                        // Kiểm tra trạng thái của Future và xây dựng UI tương ứng
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Nếu Future đang chờ, hiển thị loading indicator
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // Nếu xảy ra lỗi, hiển thị thông báo lỗi
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          // Khi có dữ liệu, sử dụng dữ liệu để xây dựng UI
                          UserModel? user = snapshot.data;
                          return InkWell(
                            onTap: () {
                              if (user != null && user.key != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider<CartBloc>(
                                      create: (context) => CartBloc(),
                                      child: CartScreen(userKey: user.key!),
                                    ),
                                  ),
                                );
                              } else {
                                // Xử lý trường hợp user hoặc key của user là null
                                print('User key is not available.');
                              }
                            },
                            child: Icon(Icons.shopping_cart,color: Colors.white,size: 30,),
                          );
                        } else {
                          // Trường hợp không có dữ liệu
                          return Text('No user found');
                        }
                      },
                    ),
                    SizedBox(width: 15,),
                  InkWell(
                    onTap: () {
                      // Handle the tap
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ProfilePage()),
                      );
                    },
                    child: FutureBuilder(
                      future: user, // Giả sử getUser() là một Future trả về UserModel
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Hiển thị placeholder hoặc loading indicator
                          return CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey, // Màu nền khi đang tải
                            child: CircularProgressIndicator(), // Loading indicator
                          );
                        } else if (snapshot.hasData && snapshot.data!.profilePic.isNotEmpty) {
                          // Nếu dữ liệu có sẵn và có ảnh đại diện
                          return CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(snapshot.data!.profilePic),
                          );
                        } else {
                          // Nếu không có ảnh đại diện, hiển thị placeholder
                          return CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage("images/user.jpeg"), // Ảnh mặc định
                          );
                        }
                      },
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
      //       if(page == 1){
      //       dummyPages[page] = _pages[page];
      //       }
      //       else if(page ==2){
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