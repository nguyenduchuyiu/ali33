// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:ali33/bloc/cart_bloc.dart';
import 'package:ali33/constants/constant_values.dart';
import 'package:ali33/constants/route_animation.dart';
import 'package:ali33/models/cart_item_model.dart';
import 'package:ali33/models/product_model.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/screens/cart.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  int selectedIndex = 0;
  int offPercentage = 0;
  int noOfProdAdded = 1;

  String calculateOffPercentage() {
    int sPrice = widget
        .productModel.productDetails.variations[selectedIndex].sellingPrice;
    int offPrice =
        widget.productModel.productDetails.variations[selectedIndex].offerPrice;
    return (((sPrice - offPrice) / sPrice) * 100).round().toString();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // elevation: 0,
        // backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
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
                Text(widget.productModel.productDetails.productName,
                    style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 5),
                Text(
                    "${widget.productModel.productDetails.variations[selectedIndex]
                            .quantity} KG",
                    style: Theme.of(context).textTheme.displaySmall),
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
                            .copyWith(color: Colors.red)),
                    const SizedBox(width: 10),
                    Text(
                        dollarSymbol +
                            widget.productModel.productDetails
                                .variations[selectedIndex].sellingPrice
                                .toString(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: const Color.fromARGB(255, 167, 190, 52),
                            decoration: TextDecoration.lineThrough)),
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
                    itemCount:
                        widget.productModel.productDetails.variations.length,
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
                              color: Color(0xffFAC06E),
                            ),
                            child: Text(
                              "${widget.productModel.productDetails
                                      .variations[index].quantity} KG",
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(color: const Color.fromARGB(255, 51, 175, 144)),
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
                                  : null,
                            ),
                            child: selectedIndex == index
                                ? const Icon(
                                    Icons.done,
                                    size: 40,
                                    color: Color.fromARGB(255, 9, 48, 202),
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
                const SizedBox(height: 30),
                Text("Reviews & Ratings",style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 10),
                ListView.builder(
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const CircleAvatar(backgroundImage: AssetImage("images/profile_icon.png"),radius: 15),
                              const SizedBox(width: 5),
                              Text("Sai Teja",style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text("Worth buying this at this low price and thanks to ali33 for this fabulous products.",style: Theme.of(context).textTheme.headlineMedium,)
                        ],
                      ),
                    );
                  }),
              ],
            ),
            if(isLoading) loadingAnimation()
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
                topLeft: Radius.circular(16), topRight: Radius.circular(30))),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (noOfProdAdded > 1) noOfProdAdded--;
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
                  Text(noOfProdAdded.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (noOfProdAdded <= 100) noOfProdAdded++;
                      });
                    },
                    child: const Text("+",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                UserModel? user = await ApiService().getCurrentUser();
                if (user != null) {
                  print("user");
                  // OrderModel orderModel = OrderModel(
                  //           orderedDate: DateTime.now().toUtc(),
                  //           userId: user.key!,
                  //           quantity: noOfProdAdded,
                  //           variationQuantity: widget
                  //               .productModel
                  //               .productDetails
                  //               .variations[selectedIndex]
                  //               .quantity,
                  //           productId: widget.productModel.productDetails.key,
                  //           paidPrice: widget.productModel.productDetails
                  //               .variations[selectedIndex].offerPrice,
                  //           paymentStatus: 0,
                  //           deliveryStages: null,
                  //           deliveryAddress: null,                          
                  //       );
                  bool addedToCart =  await ApiService().addToCart(CartItem(productKey: widget.productModel.productDetails.key, noOfItems: noOfProdAdded, variationQuantity: widget.productModel.productDetails.variations[selectedIndex].quantity));
                   setState(() {
                  isLoading = false;
                });
                  if(addedToCart){
                  bool? res = await Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
                      reverseTransitionDuration: const Duration(milliseconds: 500),
                      opaque: false,
                      barrierDismissible: false,
                      barrierColor: null,
                      fullscreenDialog: true,
                      pageBuilder: (BuildContext context, a, b) {
                        return AddtoCartWidget(
                          tag: widget.tag,
                          productModel: widget.productModel,
                          selectedIndex: selectedIndex,
                          noOfItems: noOfProdAdded,
                          );
                      },
                    ),
                  );
                  if (res != null && res) {
                    Navigator.push(
                        context, SlideLeftRoute(widget: BlocProvider<CartBloc>(
                                  create: (context) => CartBloc(),
                                  child: const CartScreen(),
                                )),);
                  }
                }
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
      // CustomScrollView(
      //   slivers: [
      //     SliverAppBar(
      //       leading: BackButton(onPressed: () => Navigator.pop(context)),
      //       expandedHeight: size.height * 0.3,
      //       pinned: true,
      //       flexibleSpace: FlexibleSpaceBar(
      //         title: Text("Carrots"),
      //         // titlePadding: EdgeInsets.all(10),
      //         background: Image.asset(
      //           "images/temp/banner1.png",
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //     ),
      //     SliverToBoxAdapter(
      //       child: Container(
      //         height: double.maxFinite,
      //         decoration: BoxDecoration(
      //           // color: Colors.red,
      //             borderRadius: BorderRadius.only(
      //                 topLeft: Radius.circular(16),
      //                 topRight: Radius.circular(16))),
      //       ),
      //     )
      //   ],
      // ),
    );
  }
}

class AddtoCartWidget extends StatefulWidget {
  final int tag;
  final ProductModel productModel;
  final int selectedIndex;
   int noOfItems;
  AddtoCartWidget(
      {Key? key,
      required this.tag,
      required this.productModel,
      required this.selectedIndex,
      required this.noOfItems, })
      : super(key: key);

  @override
  State<AddtoCartWidget> createState() => _AddtoCartWidgetState();
}

class _AddtoCartWidgetState extends State<AddtoCartWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onTap: () {
              // print("body");
            },
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.73),
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 25),
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    alignment: Alignment.center,
                    width: size.width,
                    color: const Color(0xffC59623),
                    child: Text(
                      "Items added to cart can avail FREE Delivery now",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shopping_cart_outlined),
                            const SizedBox(width: 10),
                            Text(
                              widget.noOfItems.toString(),
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const SizedBox(width: 10),
                            Text(dollarSymbol+widget.productModel.productDetails.variations[widget.selectedIndex].offerPrice.toString(),style: Theme.of(context).textTheme.displaySmall,),
                            const SizedBox(width: 5),
                            Text( "saved $dollarSymbol${calculateSavedAmount(widget.productModel.productDetails.variations[widget.selectedIndex].sellingPrice , widget.productModel.productDetails.variations[widget.selectedIndex].offerPrice)}",style: Theme.of(context).textTheme.headlineMedium,),
                            const Spacer(),
                            Hero(
                              tag: widget.tag,
                              flightShuttleBuilder: (context, anim, direction,
                                  fromContext, toContext) {
                                final Widget toHero = toContext.widget;
                                if (direction == HeroFlightDirection.pop) {
                                  return FadeTransition(
                                    opacity: const AlwaysStoppedAnimation(0),
                                    child: toHero,
                                  );
                                } else {
                                  return toHero;
                                }
                              },
                              child: buildCircularPhoto(widget.productModel.productDetails.productPicture)
                              // CircleAvatar(
                              //   radius: 30,
                              //   backgroundColor:
                              //       Color(0xffD5F8F4).withOpacity(0.5),
                              //   backgroundImage: AssetImage(
                              //     "images/temp/vege.png",
                              //   ),
                              // ),
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
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
                        if (widget.noOfItems > 1) widget.noOfItems--;
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
                                  Text(widget.noOfItems.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold)),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                        if (widget.noOfItems <= 100) widget.noOfItems++;
                      });
                                    },

                                    child: const Text("+",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context, true);
                              },
                              child: Container(
                                width: size.width * 0.4,
                                height: 46,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Text(
                                  "View Cart",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
