
import 'package:ali33/models/product_model.dart';
import 'package:ali33/screens/home.dart';
import 'package:ali33/screens/product_details.dart';
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
    addSearchTerm(widget.searchTerm);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () => 
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(selectedPage: 0),
              ),
            ),
          ),
          titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
      toolbarHeight: 80,
        flexibleSpace: 
              Container(
                
                padding: const EdgeInsets.symmetric(horizontal: 16),
                // shrinkWrap: true, 
                height: 80,
                width: size.width-16*2,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // IconButton(
                  //   onPressed: () => Navigator.pop(context, false),
                  //   icon: const Icon(
                  //     Icons.arrow_back_ios_new_outlined,
                  //     color: Colors.blueGrey,
                  //   ),
                  // ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const HomeScreen(selectedPage: 0)), // Giả sử HomePage là trang đầu tiên trong HomeScreen
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: Image.asset("images/logo.png", height: 50,),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 18,),
                      Text("More Quality",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(fontWeight: FontWeight.w700,fontSize: 17)),
                      Text("for Less Quantity",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontWeight: FontWeight.w500,fontSize: 15)),
                    ],
                  ),
                  ]
           
          // titleTextStyle: Theme.of(context).appBarTheme.titleTextStyle,
        ),),),
      
      // appBar: AppBar(
      //     leading: IconButton(
      //       icon: const Icon(Icons.arrow_back, color: Colors.blueGrey,),
      //       onPressed: () => 
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //           builder: (context) => const HomeScreen(selectedPage: 0),
      //         ),
      //       ),
      //     ),
      // //   title: Text('Search results for ${widget.searchTerm}: '),
      // // ),
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
          SizedBox(height: 40,),
          SearchBar(),
          GridView.builder(
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
        ],),
      )
       



    );
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
    _removeOverlay();
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