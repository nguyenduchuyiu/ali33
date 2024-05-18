
import 'package:ali33/models/product_model.dart';
import 'package:ali33/screens/home.dart';
import 'package:ali33/screens/product_details.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:flutter/material.dart';
import 'package:ali33/screens/pages/profile_page.dart';

class SearchResultsScreen extends StatefulWidget {
  final List<ProductModel> results;
  final String searchTerm;
  const SearchResultsScreen(
      {Key? key, required this.results, required this.searchTerm})
      : super(key: key);

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.blueGrey,),
            onPressed: () => 
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(selectedPage: 0),
              ),
            ),
          ),
        title: Text('Search results for ${widget.searchTerm}: '),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget.results.length,
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        // physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          ProductModel model = widget.results[index];
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
              tag: index,
              child: Card(
                  elevation: 5,
                  shadowColor: const Color(0xffFFA500).withOpacity(0.3),
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
                                model.productDetails.productPicture,
                                size.height,
                                300,
                                BoxFit.contain),
                            )
                      ),
                        Text(
                          model.productDetails.productName,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        Text(
                          "${model.productDetails.variations[0].quantity} kg",
                          style: Theme.of(context).textTheme.bodyMedium ,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "\$${model.productDetails.variations[0].offerPrice}",
                          style: Theme.of(context).textTheme.displaySmall,
                        )
                      ],
                    ),
                  )),
            ),
          );
        },
      )
    );
  }
}