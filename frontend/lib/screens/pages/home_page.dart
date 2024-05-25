// ignore_for_file: avoid_print

import 'package:ali33/constants/constant_values.dart';
import 'package:ali33/models/product_model.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/screens/product_details.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:ali33/widgets/slider.dart';
import 'package:flutter/material.dart';
import 'package:ali33/screens/search_results_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/error_builder.dart';
import 'dart:async';
import 'dart:math';
import 'package:ali33/widgets/search_bar.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  late Future<UserModel?> user;
  int category = 1;

  getUser() {
    user = ApiService().getCurrentUser();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  List<String> bannerImages = [
    "images/temp/banner2.jpg",
    "images/temp/banner3.jpg",
    "images/temp/banner4.jpg",
  ];

  bool isExpanded = true;
  int currentIndex = 0;

  List<String> searches = <String>[];
  int selectedCartIndex = 0;
  late SharedPreferences _prefs;

  void loadRecentSearches() async {
    _prefs = await SharedPreferences.getInstance();
    List<String> temp = _prefs.getStringList("searches")!.toList();
    searches = temp.reversed.toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<UserModel?>(
        future: user,
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return loadingAnimation();
          } else if (snapshots.hasError) {
            return buildErrorWidget(context, () => getUser());
          }
          if (snapshots.data == null) {
            print('home page snapshot null');
            return buildErrorWidget(
                context, () => getUser(), "Items not Found! Try again");
          }
          return Container(
            decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
Color(0xff404258), // Start color
Color(0xff474E68),
Color(0xff50577A),
Color(0xff6B728E) // End color
                    ]
                  ),
                ),
          child:ListView( 
            children: [
              //This is the Search Box 
              SizedBox(height: size.height * 0.02),

              const AliSearchBar(),
              const AliSlider(),
              SizedBox(
                height: size.height * 0.3,
                width: size.width,
                child: ListView.builder(
                    itemCount: 3,
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                switch (index) {
                                  case 0:
                                    category = 1;
                                    break;
                                  case 1:
                                    category = 2;
                                    break;
                                  case 2:
                                    category = 3;
                                    break;
                                }
                                setState(() {
                                  if (isExpanded && index != currentIndex) {
                                    currentIndex = index;
                                  } else if (currentIndex != index) {
                                    isExpanded = !isExpanded;
                                    currentIndex = index;
                                  }
                                });
                              },
                              child: AnimatedSize(
                                duration: const Duration(milliseconds: 100),
                                child: Card(
                                  color: Color(data[index]["color"]).withOpacity(0),
                                  elevation: 30,
                                  shadowColor: Colors.black,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    height: isExpanded && currentIndex == index
                                        ? size.height * 0.3
                                        : size.height * 0.25,
                                    alignment: Alignment.center,
                                    width: isExpanded && currentIndex == index
                                        ? size.width * 0.32
                                        : size.width * 0.31,
                                    child: Container(
                                      height: isExpanded && currentIndex == index
                                        ? size.height * 0.35
                                        : size.height * 0.3,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(data[index]["img"].toString()),
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                                          ),
                                        ),
                                      child: Align( // Use Align to position the text
                                        alignment: Alignment.bottomCenter,
                                        child: Padding( // Add padding for some spacing
                                          padding: const EdgeInsets.all(16.0), // Adjust padding value as needed
                                          child: Text(
                                            data[index]["title"].toString(),
                                            style: isExpanded && currentIndex == index
                                                ? Theme.of(context).textTheme.displayMedium!
                                                .copyWith(color: Colors.white)
                                                : Theme.of(context).textTheme.displaySmall!
                                                .copyWith(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              SizedBox(height: size.height * 0.01),
              Products(size: size, category: category, productKey: Random().nextInt(100),)
            ],
          ),
        ); 
      } 
    );
  }


  List<Map<String, dynamic>> data = [
    { 
      "img": "/images/best_seller.png",
      "title": "Best Seller",
      "color": 0xffFFA500,
    },
    {
      "img": "/images/popular_brands.png",
      "title": "Popular Brands",
      "color": 0xffFFC001,
    },
    {
      "img": "/images/recommend.png",
      "title": "Product you might like",
      "color": 0xff00FFEF
    }
  ];
}

class Products extends StatelessWidget {
  final Size size;
  final int category;
  final int productKey;
  const Products({required this.size, required this.category, super.key, required this.productKey});

  @override
  Widget build(BuildContext context) {
    final Future<List<ProductModel>> productFuture =
        category == 3 //Recommend Products
        ? ApiService().getRelatedProducts(productKey) 
        : ApiService().getAllProducts(1, 20, category);
    return FutureBuilder<List<ProductModel>>(
        future: productFuture,
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return loadingAnimation();
          } else if (snapshots.hasError) {
            return buildErrorWidget(context, () {});
          }
          if (snapshots.data == null) {
            return buildErrorWidget(
                context, () {}, "Items not Found! Try again");
          }
          return GridView.builder(
            itemCount: snapshots.data!.length,
            primary: false,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 1, // the greater the shorter
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                              tag: index,
                              productModel: snapshots.data![index])));
                },
                child: Hero(
                  tag: index,
                  child: Card(
                      elevation: 10,
                      shadowColor: const Color.fromARGB(255, 7, 1, 7).withOpacity(0.9),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child:Center(
                                child: buildPhoto(
                                    snapshots.data![index].productDetails.productPicture,
                                    size.height,
                                    300,
                                    BoxFit.contain),
                                )
                              ),
                            Text(
                              snapshots.data![index].productDetails.productName,
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            Text(
                              dollarSymbol +
                                  snapshots.data![index].productDetails
                                      .variations[0].offerPrice
                                      .toString(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                      )),
                ),
              );
            },
          );
        });
  }
}
