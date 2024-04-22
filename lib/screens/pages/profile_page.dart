import 'package:online_store/bloc/cart_bloc.dart';
import 'package:online_store/constants/route_animation.dart';
import 'package:online_store/models/user_model.dart';
import 'package:online_store/screens/cart.dart';
import 'package:online_store/screens/delivery_address.dart';
import 'package:online_store/screens/login.dart';
import 'package:online_store/screens/order_track.dart';
import 'package:online_store/screens/orders.dart';
import 'package:online_store/screens/place_order.dart';
import 'package:online_store/screens/profile.dart';
import 'package:online_store/services/api_service.dart';
import 'package:online_store/services/theme_provider_service.dart';
import 'package:online_store/widgets/basic.dart';
import 'package:online_store/widgets/build_photo.dart';
import 'package:online_store/widgets/error_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<UserModel?>? user;
  late AppThemeNotifier appThemeNotifier;

  Future<void> getCurrentUser() async {
    user = ApiService().getCurrentUser();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void didChangeDependencies() {
    appThemeNotifier = Provider.of<AppThemeNotifier>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: user,
        builder: (context, AsyncSnapshot<UserModel?> snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return loadingAnimation();
          } else if (snapshots.hasError) {
            return buildErrorWidget(context, () => getCurrentUser());
          }
          if (snapshots.data == null) {
            return buildErrorWidget(
                context, () => getCurrentUser(), "User not Found! Try again");
          }
          print(snapshots.data);

          return SingleChildScrollView(
            child: Container(
              // height: size.height,
              // width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  snapshots.data!.profilePic != ""
                      ? buildCircularProfilePhoto(snapshots.data!.profilePic,
                          appThemeNotifier.darkTheme, size.height * 0.2)
                      : buildPlaceholderPhoto(
                          appThemeNotifier.darkTheme, size.height * 0.2),
                  SizedBox(height: size.height * 0.02),
                  GestureDetector(
                    onTap: () async {
                      bool res = await Navigator.push(
                        context,
                        SlideLeftRoute(
                            widget: ProfileScreen(
                          isFirstTime: false,
                          userModel: snapshots.data!,
                        )),
                      );
                      if (res != null && res) {
                        await getCurrentUser();
                        setState(() {});
                      }
                    },
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      elevation: 2,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(snapshots.data!.shopName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline1!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                Text(
                                  "Edit",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.white),
                                )
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.phone, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  "9502493929",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Text(snapshots.data!.emailId,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline3!
                                        .copyWith(
                                          color: Colors.white,
                                        )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      buildItem(
                          "Cart Items",
                          () => Navigator.push(
                              context,
                              SlideLeftRoute(
                                widget: BlocProvider<CartBloc>(
                                  create: (context) => CartBloc(),
                                  child: const CartScreen(),
                                ),
                              ))),
                      buildItem(
                          "Orders",
                          () => Navigator.push(
                              context, SlideLeftRoute(widget: OrdersScreen()))),
                      buildItem(
                          "My Address",
                          () => Navigator.push(context,
                              SlideLeftRoute(widget: DeliveryAddressScreen()))),
                      buildItem(
                          "Theme Mode",
                          () => {
                                appThemeNotifier.darkTheme =
                                    !appThemeNotifier.darkTheme
                              }),
                      // buildItem("Contact Us", () => null),
                    ],
                  ),
                  SizedBox(height: size.height * 0.02),
                  InkWell(
                    onTap: () async {
                      bool res = await ApiService().logout();
                      if (res) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            SlideRightRoute(
                                widget: LoginScreen(isEditing: false)),
                            (route) => false);
                      }
                    },
                    child: Container(
                      width: 150,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: Row(
                        children: [
                          Text(
                            "Logout",
                            style:
                                Theme.of(context).textTheme.headline1!.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.logout_outlined,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget buildItem(String title, Function() onPress) {
    return InkWell(
      onTap: onPress,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headline3,
              ),
              Icon(Icons.keyboard_arrow_right, size: 30)
            ],
          ),
          SizedBox(height: 2),
          Divider(thickness: 2),
        ],
      ),
    );
  }
}
