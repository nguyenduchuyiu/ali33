import 'package:online_store/bloc/cart_bloc.dart';
import 'package:online_store/constants/constant_values.dart';
import 'package:online_store/constants/route_animation.dart';
import 'package:online_store/models/cart_item_model.dart';
import 'package:online_store/models/order_model.dart';
import 'package:online_store/models/product_model.dart';
import 'package:online_store/models/user_model.dart';
import 'package:online_store/screens/delivery_address.dart';
import 'package:online_store/screens/place_order.dart';
import 'package:online_store/services/api_service.dart';
import 'package:online_store/widgets/basic.dart';
import 'package:online_store/widgets/build_photo.dart';
import 'package:online_store/widgets/error_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // int count = 1;

  bool isLoading = false;

  Future<UserModel?> getCurrentUser() async {
    return await ApiService().getCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(FetchCartItems());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartInitialState || state is CartProductsLoading) {
          return Scaffold(
              appBar: AppBar(title: const Text("Cart Preview")),
              body: loadingAnimation());
        } else if (state is CartProductsFetched) {
          if (state.products.cartModel.isEmpty) {
            return Scaffold(
              appBar: AppBar(title: const Text("Cart Preview")),
              body: Container(
                alignment: Alignment.center,
                child: Text("Look's like no Products in Cart. Add some!",
                    style: Theme.of(context).textTheme.headline4),
              ),
            );
          }
          List<int> calculatedValues = calculateTotal(state.products.cartModel);

          return Scaffold(
            appBar: AppBar(title: const Text("Cart Preview")),
            body: ListView(
              primary: true,
              children: [
                SizedBox(height: size.height * 0.01),
                Container(
                  // height: size.height * 0.1,
                  color: Colors.amberAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.cabin),
                      SizedBox(width: 5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Add a coupon code",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 22)),
                          Text("Avail offer and discounts on your order",
                              style: Theme.of(context).textTheme.headline4),
                        ],
                      ),
                      const Spacer(),
                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                ListView.builder(
                  itemCount: state.products.cartModel.length,
                  primary: false,
                  shrinkWrap: true,
                  // padding: EdgeInsets.symmetric(horizontal: 8),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    CartModel item = state.products.cartModel[index];

                    int variationIndex = item.productDetails.variations.indexOf(
                        item.productDetails.variations.firstWhere((element) =>
                            element.quantity ==
                            item.cartItem.variationQuantity));
                    return Dismissible(
                      background: Container(
                        padding: const EdgeInsets.only(right: 20),
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      key: Key(index.toString()),
                      onDismissed: (DismissDirection direction) {
                        print("dismissed");
                        context
                            .read<CartBloc>()
                            .add(RemoveItemFromCart(item: item.cartItem));
                      },
                      child: Card(
                        margin: const EdgeInsets.all(5),
                        child: SizedBox(
                          height: size.height * 0.2,
                          // color: Colors.black,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  buildPhoto(
                                      item.productDetails.productPicture,
                                      size.height * 0.12,
                                      size.width * 0.32,
                                      BoxFit.contain)
                                  // Container(
                                  //   decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(16),
                                  //     color: Color(0xffF0E0D8),
                                  //   ),
                                  //   height: size.height * 0.17,
                                  //   width: size.width * 0.32,
                                  //   child: Image.asset(
                                  //     "assets/images/temp/vege.png",
                                  //   ),
                                  // ),
                                  // SizedBox(height: size.height * 0.02),
                                ],
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.productDetails.productName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2),
                                  SizedBox(height: 5),
                                  Text(
                                    item.productDetails
                                            .variations[variationIndex].quantity
                                            .toString() +
                                        " KG",
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                          rupeeSymbol +
                                              item
                                                  .productDetails
                                                  .variations[variationIndex]
                                                  .offerPrice
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1),
                                      SizedBox(width: 5),
                                      Text(
                                          rupeeSymbol +
                                              item
                                                  .productDetails
                                                  .variations[variationIndex]
                                                  .sellingPrice
                                                  .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  decoration: TextDecoration
                                                      .lineThrough)),
                                      SizedBox(width: 5),
                                      Text(calculateOffPercentage(
                                              item
                                                  .productDetails
                                                  .variations[variationIndex]
                                                  .sellingPrice,
                                              item
                                                  .productDetails
                                                  .variations[variationIndex]
                                                  .offerPrice) +
                                          "% off"),
                                    ],
                                  ),
                                  SizedBox(height: size.height * 0.01),
                                  Container(
                                    width: size.width * 0.3,
                                    height: 40,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (item.cartItem.noOfItems > 1) {
                                              Map<String, dynamic> citem = {
                                                "old": CartItem(
                                                    productKey: item
                                                        .cartItem.productKey,
                                                    noOfItems:
                                                        item.cartItem.noOfItems,
                                                    variationQuantity: item
                                                        .cartItem
                                                        .variationQuantity),
                                                "new": CartItem(
                                                    productKey: item
                                                        .cartItem.productKey,
                                                    noOfItems: --item
                                                        .cartItem.noOfItems,
                                                    variationQuantity: item
                                                        .cartItem
                                                        .variationQuantity)
                                              };
                                              // item.cartItem.quantity =
                                              //     item.cartItem.quantity--;

                                              context.read<CartBloc>().add(
                                                  ChangeNoOfProducts(citem));
                                            }
                                          },
                                          child: Text(
                                            "-",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 26,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Text(item.cartItem.noOfItems.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                        GestureDetector(
                                          onTap: () {
                                            if (item.cartItem.noOfItems < 100) {
                                              Map<String, dynamic> citem = {
                                                "old": CartItem(
                                                    productKey: item
                                                        .cartItem.productKey,
                                                    noOfItems:
                                                        item.cartItem.noOfItems,
                                                    variationQuantity: item
                                                        .cartItem
                                                        .variationQuantity),
                                                "new": CartItem(
                                                    productKey: item
                                                        .cartItem.productKey,
                                                    noOfItems: ++item
                                                        .cartItem.noOfItems,
                                                    variationQuantity: item
                                                        .cartItem
                                                        .variationQuantity)
                                              };
                                              // item.cartItem.quantity =
                                              //     item.cartItem.quantity++;

                                              context.read<CartBloc>().add(
                                                  ChangeNoOfProducts(citem));
                                            }
                                          },
                                          child: Text("+",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(height: size.height*0.02),
                                  // Spacer(),
                                  // ElevatedButton(
                                  //     // style: ElevatedButton.styleFrom(),
                                  //     onPressed: () {},
                                  //     child: Row(
                                  //       children: [
                                  //         Text(
                                  //           "Delete",
                                  //           style:
                                  //               Theme.of(context).textTheme.bodyText1,
                                  //         ),
                                  //         SizedBox(width: 5),
                                  //         Icon(
                                  //           Icons.delete,
                                  //           color: Colors.white,
                                  //         )
                                  //       ],
                                  //     ))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: size.height * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Similar Products",
                      style: Theme.of(context).textTheme.headline2),
                ),
                SizedBox(height: size.height * 0.01),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: popularSearches(),
                ),
                SizedBox(height: size.height * 0.05),
              ],
            ),
            bottomNavigationBar: Container(
              // height: size.height * 0.28,
              width: size.width,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      // spreadRadius: 3.0,
                      blurRadius: 5)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size.width,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    color: Color(0xffC59623),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "$rupeeSymbol${calculatedValues[1]} saved on this order",
                            style: Theme.of(context)
                                .textTheme
                                .headline3!
                                .copyWith(color: Colors.white)),
                        Text(
                          "Checkout now to get FREE instant delivery",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.pin_drop_outlined,
                          size: 35,
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                bool res = await Navigator.push(
                                    context,
                                    SlideLeftRoute(
                                        widget: DeliveryAddressScreen()));
                                if (res) {
                                  context
                                      .read<CartBloc>()
                                      .add(FetchCartItems());
                                  setState(() {});
                                }
                              },
                              child: Row(
                                children: [
                                  Text("Home",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1),
                                  const Icon(Icons.arrow_drop_down_outlined,
                                      size: 35),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.8,
                              child: Text(
                                state.products.userDetails.deliveryAddress[0]
                                    .address,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  nextButton("Pay  $rupeeSymbol${calculatedValues[0]}",
                      () async {
                    List<OrderModel> orders = generateOrderList(
                        state.products.cartModel, state.products.userDetails);
                    List<CartItem> cartItems = List<CartItem>.from(
                            state.products.cartModel.map((e) => e.cartItem))
                        .toList();
                    bool res = await Navigator.push(
                        context,
                        SlideLeftRoute(
                            widget: PlaceOrderScreen(
                          ordersList: orders,
                          cartItems: cartItems,
                          subTotal: calculatedValues[0],
                        )));
                    print(res);
                    if (res)
                      setState(() {
                        context.read<CartBloc>().add(FetchCartItems());
                      });
                  })
                ],
              ),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text("Cart Preview")),
          body: buildErrorWidget(
              context, () => context.read<CartBloc>().add(FetchCartItems())),
        );
      },
    );
  }

  List<OrderModel> generateOrderList(List<CartModel> cartList, UserModel user) {
    return List<OrderModel>.from(cartList.map((item) {
      int variationIndex = item.productDetails.variations.indexOf(
          item.productDetails.variations.firstWhere((element) =>
              element.quantity == item.cartItem.variationQuantity));

      return OrderModel(
          orderedDate: DateTime.now().toUtc(),
          userId: user.key!,
          productDetails: ProductOrderingDetails(
              productKey: item.productDetails.key,
              noOfItems: item.cartItem.noOfItems,
              variationQuantity: item.cartItem.variationQuantity),
          paidPrice: item.productDetails.variations[variationIndex].offerPrice,
          paymentStatus: 0,
          // deliveryStages: DeliveryStages(
          //     stageOne: "Order Placed",
          //     stageTwo: "",
          //     stageThree: "",
          //     stageFour: ""),
          deliveryStages: [DateTime.now().toUtc()],
          deliveryAddress: user.deliveryAddress[0]);
    }).toList());
  }

  List<int> calculateTotal(List<CartModel> cartlist) {
    int totalAmount = 0;
    int savedAmount = 0;
    int originalAmount = 0;
    for (var item in cartlist) {
      int variationIndex = item.productDetails.variations.indexOf(
          item.productDetails.variations.firstWhere((element) =>
              element.quantity == item.cartItem.variationQuantity));
      int noOfProds = item.cartItem.noOfItems;

      originalAmount +=
          item.productDetails.variations[variationIndex].sellingPrice *
              noOfProds;
      totalAmount +=
          item.productDetails.variations[variationIndex].offerPrice * noOfProds;
    }
    savedAmount = originalAmount - totalAmount;
    return [totalAmount, savedAmount];
  }

  Widget popularSearches() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.18,
      child: ListView.builder(
          itemCount: 6,
          // padding: EdgeInsets.symmetric(horizontal: 10),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.25,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: Colors.grey[300],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/temp/vege.png",
                        height: MediaQuery.of(context).size.height * 0.1),
                    SizedBox(height: 5),
                    Text(
                      "Carrot",
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2),
                    Text("\$ 46.05 /-"),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
