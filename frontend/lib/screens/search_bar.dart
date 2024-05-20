import 'dart:async';

import 'package:ali33/models/product_model.dart';
import 'package:ali33/screens/search_results_page.dart';
import 'package:ali33/services/api_service.dart';
import 'package:flutter/material.dart';

class AliSearchBar extends StatefulWidget {
  const AliSearchBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<AliSearchBar> {
  final TextEditingController _controller = TextEditingController();
  OverlayEntry? _overlayEntry;
  List<String> _suggestions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged); 
  }

  @override
  void dispose() {
    _controller.dispose();
    _removeOverlay();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _mayShowSuggestions();
    });
  }

  void _mayShowSuggestions() {
    final query = _controller.text;
    if (query.isNotEmpty && _overlayEntry == null) {
      _fetchSuggestions(query).then((suggestions) {
        _suggestions = suggestions;
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
      });
    } else if (query.isEmpty || _overlayEntry == null) {
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
    // Implement search handling logic here
    final List<ProductModel> results = await ApiService().searchProduct(value.trim());
    _removeOverlay();
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