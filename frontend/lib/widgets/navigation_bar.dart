import 'package:ali33/bloc/cart_bloc.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/screens/cart.dart';
import 'package:ali33/screens/home.dart';
import 'package:ali33/screens/pages/profile_page.dart';
import 'package:ali33/services/authenticate_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AliNavigationBar extends StatelessWidget implements PreferredSizeWidget{
  final BuildContext curContext;

  const AliNavigationBar(this.curContext, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(curContext).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        flexibleSpace: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // shrinkWrap: true,
          height: 80,
          width: size.width - 16 * 2,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
Color(0xff404258), // Start color
Color(0xff474E68),
Color(0xff50577A),
Color(0xff6B728E) // End color
              ],
            ),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen(
                              selectedPage: 0,
                            )),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Image.asset(
                  "images/logo.png",
                  height: 50,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 18,),
                  Text(
                    "Your Personal",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                  Text(
                    "Hollywood at Home",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(fontWeight: FontWeight.w700, fontSize: 17),
                  ),
                ],
              ),
              const Spacer(),
              FutureBuilder(
                future: null,
                builder: (context, snapshot) {
                  return InkWell(
                    onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider<CartBloc>(
                              create: (context) => CartBloc(),
                              child: const CartScreen(),
                            ),
                          ),
                        );
                    },
                    child: Container(
                            alignment: Alignment.center,
                            child: Image.asset("images/cart_icon.png")
                          ),
                  );
                },
              ),
              const SizedBox(width: 15),
              InkWell(
                onTap: () {
                  // Handle the tap
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
                child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        backgroundImage: AssetImage("images/profile_icon.png"), // Ảnh mặc định
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
