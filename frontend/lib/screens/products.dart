import 'package:ali33/bloc/products_bloc.dart';
import 'package:ali33/constants/constant_values.dart';
import 'package:ali33/models/product_model.dart';
import 'package:ali33/screens/product_details.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:ali33/widgets/error_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductsScreen extends StatefulWidget {
  final String categoryKey;
  final String categoryName;
  const ProductsScreen(
      {Key? key, required this.categoryName, required this.categoryKey})
      : super(key: key);

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(FetchProducts(
        limit: defaultLimit, isInitial: true, category: widget.categoryKey));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          switch (state.status) {
            case ProductStatus.failure:
              return buildErrorWidget(
                  context,
                  () => context.read<ProductBloc>().add(FetchProducts(
                      limit: defaultLimit,
                      isInitial: true,
                      category: widget.categoryKey)));
            case ProductStatus.success:
              if (state.products.isEmpty) {
                return Container(
                    alignment: Alignment.center,
                    child: const Text("No Products Available in this Category"));
              }
              return GridView.builder(
                padding: EdgeInsets.all(8),
                itemCount: state.products.length,
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  ProductModel model = state.products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailsScreen(
                            tag: index,
                            productModel: model,
                          ),
                        ),
                      );
                    },
                    child: Hero(
                      // flightShuttleBuilder:
                      //     (context, anim, direction, fromContext, toContext) {
                      //   final Widget toHero = toContext.widget;
                      //   if (direction == HeroFlightDirection.push) {
                      //     return FadeTransition(
                      //       opacity: AlwaysStoppedAnimation(0),
                      //       child: toHero,
                      //     );
                      //   } else {
                      //     return toHero;
                      //   }
                      // },
                      tag: index,
                      child: Card(
                          elevation: 5,
                          shadowColor: Color(0xffFFA500).withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildPhoto(model.productDetails.productPicture,
                                    size.height * 0.15),
                                Text(
                                  model.productDetails.productName,
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                Text(
                                  model.productDetails.variations[0].quantity
                                          .toString() +
                                      " kg",
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  "\$${model.productDetails.variations[0].offerPrice}",
                                  style: Theme.of(context).textTheme.headline3,
                                )
                              ],
                            ),
                          )),
                    ),
                  );
                },
              );
            default:
              return loadingAnimation();
          }
        },
      ),
    );
  }
}
