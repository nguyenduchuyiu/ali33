import 'package:ali33/models/product_model.dart';
import 'package:ali33/services/api_service.dart';
import 'package:ali33/widgets/basic.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
  void initState() {
    super.initState();
    loadRecentSearches();
    // searches.addAll(["Mango", "Banana", "Apple"]);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.02),
          GestureDetector(
            onTap: () async {
              await showSearch(
                  context: context,
                  delegate:
                      CustomSearchDelegate(recent: searches, prefs: _prefs));
              loadRecentSearches();
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(8),
                  // border: Border.all(color: Colors.grey),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded),
                    SizedBox(width: 10),
                    Text(
                      "Search for products",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.03),
          Text("Recent Searches", style: Theme.of(context).textTheme.headline2),
          // SizedBox(height: size.height * 0.01),
          recentSearches(),
          // SizedBox(height: size.height * 0.02),
          Text("Top Categories", style: Theme.of(context).textTheme.headline2),
          // SizedBox(height: size.height * 0.01),
          topCategories(),
          SizedBox(height: size.height * 0.02),
          Text("Popular Searches",
              style: Theme.of(context).textTheme.headline2),
          SizedBox(height: size.height * 0.01),
          popularSearches()
        ],
      ),
    );
  }

  Widget popularSearches() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView.builder(
          itemCount: 6,
          // padding: EdgeInsets.symmetric(horizontal: 10),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedCartIndex = index;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.25,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(
                              selectedCartIndex == index ? 0 : 10),
                          bottomRight: Radius.circular(
                              selectedCartIndex == index ? 0 : 10)),
                      color: Colors.grey,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("images/temp/vege.png",
                            height: MediaQuery.of(context).size.height * 0.1),
                        SizedBox(height: 5),
                        Text(
                          "Carrot",
                          style: Theme.of(context)
                              .textTheme
                              .headline4!
                              .copyWith(fontWeight: FontWeight.w600,color: Colors.white),
                        ),
                        SizedBox(height: 2),
                        Text("\$ 46.05 /-",style: TextStyle(color: Colors.white),),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  selectedCartIndex == index
                      ? Container(
                          height: 35,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.25,
                          decoration: BoxDecoration(
                              color: Color(0xffA1CAF1).withOpacity(0.5),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(16))),
                          child: Text("Add to Cart"),
                        )
                      : SizedBox.shrink()
                ],
              ),
            );
          }),
    );
  }

  Widget topCategories() {
    return GridView.builder(
      itemCount: topCat.length,
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 5,
        crossAxisSpacing: 5,
        childAspectRatio: 3,
      ),
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 20, right: 10),
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            topCat[index],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(),
          ),
        );
      },
    );
  }

  Widget recentSearches() {
    // List<String> reverseRecent = searches.reversed.toList();
    return searches.isEmpty
        ? Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "No recent searches",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ))
        : GridView.builder(
            itemCount: searches.length,
            padding: const EdgeInsets.all(8),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 3,
            ),
            itemBuilder: (context, index) {
              return Container(
                // height: 30,
                // width: MediaQuery.of(context).size.width*0.2,
                // alignment: Alignment.center,
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.15,
                      child: Text(
                        searches[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // if (reverseRecent.length > 5) {
                        searches.removeAt(index);
                        _prefs.setStringList("searches", searches);
                        // } else {
                        //   searches.add(index.toString());
                        // }
                        print("searches ${searches}");
                        setState(() {});
                      },
                      child: Icon(Icons.clear),
                    )
                  ],
                ),
              );
            },
          );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  // List<String> searchTerms = [
  //   'Apple',
  //   'Avacardo',
  //   'Banana',
  //   "Pear",
  //   "Watermelons",
  //   "Oranges",
  //   "Blueberries",
  //   "Strawberries",
  //   "Raspberries"
  // ];

  List<String> recent = <String>[];
  // Future<List<ProductModel>>? apiResults;
  SharedPreferences prefs;

  CustomSearchDelegate({required this.recent, required this.prefs});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
            FocusManager.instance.primaryFocus?.requestFocus();
            // buildSuggestions(context);
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  void showResults(BuildContext context) {
    // TODO: implement showResults
    super.showResults(context);
  }

  Future<List<ProductModel>> searchProduct() async {
    return ApiService().searchProduct(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // recent = recent.reversed.toList();
    print("suggestions");

    if (query.isNotEmpty) {
      return FutureBuilder<List<ProductModel>>(
        future: searchProduct(),
        builder: (context, snapshot) {
          print("future");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadingAnimation();
          } else if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                ProductModel result = snapshot.data![index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  title: Text(result.productDetails.productName),
                  trailing: Icon(Icons.arrow_forward_ios),
                );
              },
            );
          }
          return SizedBox.shrink();
        },
      );
    }
    return ListView.builder(
      itemCount: recent.length,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          title: Text(recent[index]),
          leading: Icon(Icons.history_outlined),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            query = recent[index];
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // if (query.isNotEmpty) {
    return FutureBuilder<List<ProductModel>>(
      future: searchProduct(),
      builder: (context, snapshot) {
        print("future");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingAnimation();
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
            child: Text(
              "Search failed! Try again",
              style: Theme.of(context).textTheme.bodyText1,
            ),
          );
        } else {
          // else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              child: Text(
                "No products found",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              ProductModel result = snapshot.data![index];
              return ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                title: Text(result.productDetails.productName),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  if (!recent.contains(result.productDetails.productName)) {
                    recent.add(result.productDetails.productName);
                    if (recent.length > 6) {
                      recent.removeAt(0);
                    }
                    prefs.setStringList("searches", recent);
                  }
                },
              );
            },
          );
        }
        // return SizedBox.shrink();
      },
    );
    // } else {
    //   return Padding(
    //     padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
    //     child: Text(
    //       "No products matched",
    //       style: Theme.of(context).textTheme.bodyText1,
    //     ),
    //   );
    // }
  }
}
