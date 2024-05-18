// ignore_for_file: use_build_context_synchronously, avoid_print, must_be_immutable

import 'dart:async';

import 'package:ali33/bloc/cart_bloc.dart';
import 'package:ali33/bloc/products_bloc.dart';
import 'package:ali33/constants/constant_values.dart';
import 'package:ali33/constants/route_animation.dart';
import 'package:ali33/models/cart_item_model.dart';
import 'package:ali33/models/order_model.dart';
import 'package:ali33/models/product_model.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/screens/cart.dart';
import 'package:ali33/screens/pages/home_page.dart';
import 'package:ali33/screens/products.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  String calculateOffPercentage() {
    int sPrice = widget
        .productModel.productDetails.variations[selectedIndex].sellingPrice;
    int offPrice = widget
        .productModel.productDetails.variations[selectedIndex].offerPrice;
    return (((sPrice - offPrice) / sPrice) * 100).round().toString();
  }

  @override
  void initState() {
    super.initState();
    // Create a timer to hide the message after 2 seconds
    _timer = Timer(const Duration(seconds: 2), () {
      setState(() {
        showMessage = false; 
      });
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
        future: ApiService().getRelatedProducts(
            widget.productModel.productDetails.productName),
        builder: (context, snapshots) {
          return Scaffold(
            appBar: AppBar(
              // elevation: 0,
              // backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.blueGrey,
                  )),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                    ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      primary: true,
                      children: [
                        Hero(
                          tag: widget.tag,
                          placeholderBuilder: (context, size, child) {
                            return Container(
                              height: size.height,
                              width: size.width,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 166, 41, 126),
                                  borderRadius: BorderRadius.circular(16)),
                              child: buildPhoto(
                                  widget.productModel.productDetails.productPicture,
                                  size.height,
                                  size.width,
                                  BoxFit.contain),
                            );
                          },
                          child: Container(
                            height: size.height * 0.4,
                            width: size.width,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 7, 175, 236),
                                borderRadius: BorderRadius.circular(16)),
                            child: buildPhoto(
                                widget.productModel.productDetails.productPicture,
                                size.height * 0.4,
                                size.width,
                                BoxFit.contain),
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Text(
                          widget.productModel.productDetails.productName,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${widget.productModel.productDetails.variations[selectedIndex].quantity} KG",
                          style: Theme.of(context).textTheme.displaySmall,
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
                                      color: const Color.fromARGB(
                                          255, 167, 190, 52),
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
                        SizedBox(
                          height: 80,
                          child: ListView.builder(
                            itemCount: widget
                                .productModel.productDetails.variations.length,
                            scrollDirection: Axis.horizontal,
                            primary: false,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        // borderRadius: BorderRadius.circular(16),
                                        color: Color(0xffFAC06E)),
                                    child: Text(
                                      "${widget.productModel.productDetails.variations[index].quantity} KG",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              color: const Color.fromARGB(
                                                  255, 51, 175, 144)),
                                    ),
                                  ),
                                  Container(
                                    height: 80,
                                    width: 80,
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: selectedIndex == index
                                            ? Colors.black54
                                            : null),
                                    child: selectedIndex == index
                                        ? const Icon(
                                            Icons.done,
                                            size: 40,
                                            color: Color.fromARGB(
                                                255, 9, 48, 202),
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          // widget.productModel.productDetails.productDescription,
                          "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).",
                          style: Theme.of(context).textTheme.headlineMedium!,
                        ),
                        Container(
                          height: 80,
                          // alignment: Alignment.center,
                          // margin: EdgeInsets.symmetric(vertical: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(color: Colors.black38, blurRadius: 25),
                              ],
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(30))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: size.width * 0.4,
                                height: 46,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
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
                                    Text(
                                        noOfProdAdded.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
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
                                  UserModel? user =
                                      await UserService.authenticateUser(context);
                                  if (user != null) {
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
                                      user.key!,
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
                                },
                                child: Container(
                                  width: size.width * 0.4,
                                  height: 46,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Text(
                                    "Add to Cart",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "Ratings",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          primary: false,
                          // physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ...
                                ],
                              ),
                            );
                          },
                        ),
                      Text(
                        "Products you might like :",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      SizedBox(height: size.height ),
                      Products(size: size, category: 3)
                      ],
                    ),
                  if (isLoading) loadingAnimation(),
                  if (showMessage) 
                    Align(
                      alignment: Alignment.center,
                      child: 
                        Container(
                          padding: const EdgeInsets.all(32), // Add padding to create space
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8), 
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const SizedBox( // Wrap the Stack in a SizedBox to control its size
                            height: 160, // Set a larger height
                            width: 160, // Set a larger width
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 50,
                                  top: 20,
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 60,
                                    color: Colors.green,
                                  ),
                                ),
                                Positioned(
                                  left: 10, 
                                  top: 100,
                                  child: Text(
                                    'Added to cart!',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                ],
              ),
            ),
          );
        });
  }
}