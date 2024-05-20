import 'package:ali33/screens/navigation_bar.dart';
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

  final List<Widget> dummyPages = [
    const HomePage(),
    const SizedBox(),
    const SizedBox(),
  ];
  @override
  void initState() {
    _selectedPage = widget.selectedPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Future<UserModel?>? user = UserService.authenticateUser(context);
    // Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AliNavigationBar(context),
      body: SafeArea(
        child: IndexedStack(
          index: _selectedPage,
          children: dummyPages,
        ),
      ),
    );
  }
}