// ignore_for_file: use_build_context_synchronously, avoid_print, must_be_immutable

import 'dart:async';

import 'package:ali33/constants/constant_values.dart';
import 'package:ali33/models/cart_item_model.dart';
import 'package:ali33/models/product_model.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/screens/pages/home_page.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:ali33/widgets/navigation_bar.dart';
import 'package:ali33/widgets/notification.dart';
import 'package:ali33/widgets/rating.dart';
import 'package:flutter/material.dart';
import 'package:ali33/services/authenticate_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int tag;
  final ProductModel productModel;
  const ProductDetailsScreen(
      {Key? key, required this.tag, required this.productModel})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isLoading = false;
  bool showMessage = false;
  int selectedIndex = 0;
  int offPercentage = 0;
  int noOfProdAdded = 1;
  int productKey = 0;


  String calculateOffPercentage() {
    double sPrice = widget
        .productModel.productDetails.variations[selectedIndex].sellingPrice;
    double offPrice = widget
        .productModel.productDetails.variations[selectedIndex].offerPrice;
    return (((sPrice - offPrice) / sPrice) * 100).round().toString();
  }

  @override
  void initState() {
    productKey = widget.productModel.productDetails.key;
    super.initState(); 
    // Create a timer to hide the message after 2 seconds
    _timer = Timer(const Duration(seconds: 2), () {
      // setState(() {
      //   showMessage = false; 
      // });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Timer? _timer; // Add a timer variable

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<ProductModel>>(
        future: ApiService().getRelatedProducts(widget.productModel.productDetails.key),
        builder: (context, snapshots) {
          return Scaffold(
            appBar: AliNavigationBar(context),
            body: SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width : MediaQuery.of(context).size.width,
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
               child :Stack(
                children: [
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      primary: true,
                      children: [
                          Container(
                            height: size.height * 0.4,
                            width: size.width,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 78, 96, 102),
                                borderRadius: BorderRadius.circular(16)),
                            child: buildPhoto(
                                widget.productModel.productDetails.productPicture,
                                size.height * 0.4,
                                size.width,
                                BoxFit.contain),
                          ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          widget.productModel.productDetails.productName,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text(
                              dollarSymbol +
                                  widget.productModel.productDetails
                                      .variations[selectedIndex].offerPrice
                                      .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: Colors.red),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              dollarSymbol +
                                  widget.productModel.productDetails
                                      .variations[selectedIndex].sellingPrice
                                      .toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: Color.fromARGB(255, 245, 248, 240),
                                      decoration: TextDecoration.lineThrough),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "${calculateOffPercentage()}% Off",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(color: Colors.red),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                      const SizedBox(height: 20),
                      Text(
                          widget.productModel.productDetails.productDescription,
                          style: Theme.of(context).textTheme.headlineMedium!,
                        ),
                      const SizedBox(height: 5),
                      Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(height: 5,),
                              Container(
                                width: size.width * 0.2,
                                height: 46,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (noOfProdAdded > 1) {
                                            noOfProdAdded--;
                                          }
                                        });
                                      },
                                      child: const Text(
                                        "-",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text("Rent for ${noOfProdAdded.toString()} months",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (noOfProdAdded <= 100) {
                                            noOfProdAdded++;
                                          }
                                        });
                                      },
                                      child: const Text(
                                        "+",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isLoading = true;
                                    showMessage = false;
                                    _timer?.cancel();
                                  });
                                  // UserModel? user =
                                  //     await UserService.authenticateUser(context);
                                  if (true) {
                                    bool addedToCart = await ApiService()
                                        .addToCart(
                                      CartItem(
                                        productKey: widget
                                            .productModel.productDetails.key,
                                        noOfItems: noOfProdAdded,
                                        variationQuantity: widget
                                            .productModel.productDetails
                                            .variations[selectedIndex]
                                            .quantity,
                                      ),
                                      
                                    );
                                    setState(() {
                                      isLoading = false;
                                      showMessage = addedToCart;
                                      _timer = Timer(const Duration(seconds: 2), () {
                                        setState(() {
                                          showMessage = false;
                                        });
                                      });
                                    });
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showAliNotification(context, "Added to cart!");
                                },
                                child: Container(
                                  width: size.width * 0.2,
                                  height: 46,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Text(
                                    "Add to Cart",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                                
                              ),
                             const SizedBox(height: 5,)
                            ],
                          ),
                      const SizedBox(height: 30),
                      Rating(rating: widget.productModel.productDetails.productRating),
                      Text(
                          "Ratings Overall : ${widget.productModel.productDetails.productRating}",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                      const SizedBox(height: 10),
                      Text(
                        "Products you might like :",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      const SizedBox(height: 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Products(
                          size: size, 
                          category: 3, 
                          productKey: productKey
                          ),
                        ]
                      )
                    ],
                    ),
                  if (isLoading) loadingAnimation(),
                ],
              ),
              )
            ),
          );
        });
  }
}
