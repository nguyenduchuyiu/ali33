// ignore_for_file: avoid_print

import 'package:ali33/constants/constant_values.dart';
import 'package:ali33/models/product_model.dart';
import 'package:ali33/models/user_model.dart';
import 'package:ali33/screens/product_details.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:flutter/material.dart';
import 'package:ali33/screens/search_results_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/error_builder.dart';

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
  List<String> topCat = ["Apple", "Mango", "Basmati Rice", "Guva"];

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
          return ListView( 
            children: [
              //This is the Search Box 
              SizedBox(height: size.height * 0.02),
              const SearchBar(),
              SizedBox(height: size.height * 0.02),
              Container(
                padding: EdgeInsets.fromLTRB(size.width*0.0213333333, 10, size.width*0.0213333333, 0),
                child: Column(children: <Widget> [SizedBox(
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
              ),
              )  
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
      "title": "Product you might like",
      "color": 0xff00FFEF
    }
  ];
}

class Products extends StatelessWidget {
  final Size size;
  final int category;
  const Products({required this.size, required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    final Future<List<ProductModel>> productFuture =
        category == 3 //Recommend Products
        ? ApiService().getRelatedProducts('Minions') 
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
            // physics: const NeverScrollableScrollPhysics(),
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

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_mayShowSuggestions);
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _mayShowSuggestions() {
    final query = _controller.text;
    if (query.isNotEmpty && _overlayEntry == null) {
      _fetchSuggestions(query).then((suggestions) {
        _suggestions = suggestions;
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
      });
    } else if (query.isEmpty && _overlayEntry != null) {
      _removeOverlay();
    }
  }

  Future<List<String>> _fetchSuggestions(String query) async {
    try {
      final List<ProductModel> products = await ApiService().searchProduct(query);
      return products.map((result) => result.productDetails.productName).toList();
    } catch (e) {
      print('Error fetching suggestions: $e');
      return [];
    }
  }

  OverlayEntry _createOverlayEntry() {
  RenderBox? renderBox = context.findRenderObject() as RenderBox?;
  if (renderBox != null && renderBox.hasSize) {
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: _suggestions.map((suggestion) => ListTile(
              title: Text(suggestion),
              onTap: () {
                _controller.text = suggestion;
                _handleSearch(suggestion);
                _removeOverlay();
              },
            )).toList(),
          ),
        ),
      ),
    );
  } else {
    // Return an empty OverlayEntry if renderBox is not ready
    return OverlayEntry(builder: (context) => const SizedBox.shrink());
  }
}

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _handleSearch(String value) async {
    if (value.trim().isEmpty) return;
    // Implement your search handling logic here
    // For example, navigating to a new screen with the search results
    final List<ProductModel> results = await ApiService().searchProduct(value.trim());
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(MaterialPageRoute(
       builder: (context) => SearchResultsScreen(results: results, searchTerm: value),
     ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 60, // Set the desired height
          width: 1420,
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search...',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onSubmitted: _handleSearch,
            maxLines: 1, // Allow only one line
          ),
        ),
      ],
    );
  }
}