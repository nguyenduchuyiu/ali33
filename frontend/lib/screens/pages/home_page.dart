// ignore_for_file: avoid_print

import 'package:ali33/constants/constant_values.dart';
import 'package:ali33/models/product_model.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/screens/product_details.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:flutter/material.dart';

import '../../widgets/error_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  late Future<UserModel?> user;
  String category = "";

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
            print('snapshot null');
            return buildErrorWidget(
                context, () => getUser(), "Items not Found! Try again");
          }
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            children: [
              SizedBox(height: size.height * 0.01),
              Row(
                children: [
                  Image.asset("images/logo.png", height: 46),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi ${snapshots.data!.proprietorName}",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontWeight: FontWeight.w700)),
                      Text("Welcome to ALI33",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontWeight: FontWeight.w500)),
                    ],
                  )
                ],
              ),
              // This is the Search Box 88-110
              // SizedBox(height: size.height * 0.02),
              // Container(
              //   height: 46,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //     border: Border.all(color: Colors.grey),
              //   ),
              //   padding: const EdgeInsets.symmetric(horizontal: 16),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         children: [
              //           const Icon(Icons.search_rounded),
              //           const SizedBox(width: 10),
              //           Text("Search",style: Theme.of(context).textTheme.displaySmall,),
              //         ],
              //       ),
              //       const Icon(Icons.menu),
              //     ],
              //   ),
              // ),
              SizedBox(height: size.height * 0.02),
              SizedBox(
                height: size.height * 0.25,
                child: ListView.builder(
                  itemCount: bannerImages.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      color: Colors.red,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        width: size.width * 0.31,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: AssetImage(bannerImages[index]),
                              fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // SizedBox(height: size.height * 0.02),
              SizedBox(
                // color: Colors.blue,
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
                                    category = "best_seller";
                                    break;
                                  case 1:
                                    category = "popular_brand";
                                    break;
                                  case 2:
                                    category = "free_delivery";
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
                                  color: Color(data[index]["color"])
                                      .withOpacity(0.5),
                                  elevation: 3,
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
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          data[index]["img"].toString(),
                                          fit: BoxFit.cover,
                                          height: isExpanded &&
                                                  currentIndex == index
                                              ? size.height * 0.2
                                              : size.height * 0.1,
                                        ),
                                        Text(
                                          data[index]["title"].toString(),
                                          style: isExpanded &&
                                                  currentIndex == index
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .displayMedium
                                              : Theme.of(context)
                                                  .textTheme
                                                  .displaySmall,
                                        ),
                                      ],
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
              Products(size: size, category: category)
            ],
          );
        });
  }

  List<Map<String, dynamic>> data = [
    { 
      "img": "/images/temp/best_seller.png",
      "title": "Best Seller",
      "color": 0xffFFA500,
    },
    {
      "img": "/images/temp/popular_brands.png",
      "title": "Popular Brands",
      "color": 0xffFFC001,
    },
    {
      "img": "/images/temp/free_delivery.png",
      "title": "Free Delivery",
      "color": 0xff00FFEF
    }
  ];
}

class Products extends StatelessWidget {
  final Size size;
  final String category;
  const Products({required this.size, required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
        future: ApiService().getAllProducts("0", 20, category),
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
                      shadowColor: const Color.fromARGB(255, 7, 1, 7).withOpacity(0.3),
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
                              "${snapshots.data![index].productDetails
                                      .variations[0].quantity} Kg",
                              style: Theme.of(context).textTheme.bodyLarge,
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
