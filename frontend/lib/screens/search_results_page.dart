
import 'package:ali33/constants/constant_values.dart';
import 'package:ali33/models/product_model.dart';
import 'package:ali33/screens/home.dart';
import 'package:ali33/widgets/navigation_bar.dart';
import 'package:ali33/screens/product_details.dart';
import 'package:ali33/widgets/search_bar.dart';
import 'package:ali33/widgets/build_photo.dart';
import 'package:flutter/material.dart';
import 'package:ali33/screens/pages/profile_page.dart';
import 'package:ali33/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    loadRecentSearches();
  }

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
  void addSearchTerm(String term) async {
    List<String>? currentSearches = _prefs.getStringList("searches") ?? [];
    if (!currentSearches.contains(term)) {
      currentSearches.add(term);
      await _prefs.setStringList("searches", currentSearches);
      loadRecentSearches(); // Tải lại các tìm kiếm gần đây với dữ liệu đã cập nhật
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      
      appBar: AliNavigationBar(context),
        body:Container(
          decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff8a2387), // Start color
                        Color(0xffe94057),
                        Color(0xfff27121) // End color
                      ]
                    ),
                  ),
          child: Column(children: [
            const SizedBox(height: 40,),
            const AliSearchBar(),
            GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: widget.results.length,
              primary: false,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
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
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Text(
                                    dollarSymbol +
                                        model.productDetails
                                            .variations[0].offerPrice
                                            .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(color: Colors.red),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    dollarSymbol +
                                        model.productDetails
                                            .variations[0].sellingPrice
                                            .toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            color: const Color.fromARGB(255, 65, 66, 63),
                                            decoration: TextDecoration.lineThrough),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "${calculateOffPercentage(
                                            model.productDetails
                                            .variations[0].offerPrice,
                                            model.productDetails
                                            .variations[0].sellingPrice
                                            )}% Off",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium!
                                        .copyWith(color: Colors.red),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )),
                  ),
                );
              },
            )
          ],),
        )
      );
    }
  }
