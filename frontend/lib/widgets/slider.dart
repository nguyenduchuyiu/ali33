import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AliSlider extends StatefulWidget {
  const AliSlider({Key? key}) : super(key: key);

  @override
  State<AliSlider> createState() => _AliSliderState();
}

class _AliSliderState extends State<AliSlider> {
  int activeIndex = 0;

  // Replace these with your actual image URLs
  final urlImages = [
    'https://iguov8nhvyobj.vcdn.cloud/media/catalog/product/cache/1/image/1800x/71252117777b696995f01934522c402d/p/o/poster_payoff_godzilla_va_kong_3_1_.jpg',
    'https://m.media-amazon.com/images/M/MV5BYmQ4YWMxYjUtNjZmYi00MDQ1LWFjMjMtNjA5ZDdiYjdiODU5XkEyXkFqcGdeQXVyMTMzNDExODE5._V1_.jpg',
    'https://m.media-amazon.com/images/M/MV5BNTkyNmYwMDMtMTQ2ZC00YTdiLTlkNmMtNTJhYzQ3YTcxMWMxXkEyXkFqcGdeQXVyMTE5NzI0NDM@._V1_.jpg',
    'https://m.media-amazon.com/images/M/MV5BNmI3MTQ2NjEtMWI1ZC00NDExLWI5MmEtMjJkYjJhMWQxOTEzXkEyXkFqcGdeQXVyNzYzNjg0NDk@._V1_FMjpg_UX1000_.jpg',
    'https://m.media-amazon.com/images/M/MV5BZjdkOTU3MDktN2IxOS00OGEyLWFmMjktY2FiMmZkNWIyODZiXkEyXkFqcGdeQXVyMTMxODk2OTU@._V1_.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image Row with Previous, Current, and Next
          SizedBox(
            // Provide a fixed width for the Row
            width: 300, // Adjust as needed
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, 
              children: [
                Expanded(
                  child: CarouselSlider.builder(
                    itemCount: urlImages.length,
                    itemBuilder: (context, index, realIndex) {
                      final urlImage = urlImages[index];
                      return buildImage(urlImage, index);
                    },
                    options: CarouselOptions(
                      height: 400, // Adjust height as needed
                      onPageChanged: (index, reason) =>
                          setState(() => activeIndex = index),
                      autoPlay: true,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      animateToClosest: true,
                      aspectRatio: 3.0,
                      enableInfiniteScroll: true, // To show previous/next image
                      viewportFraction: 0.8, // Adjust for image width
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          buildIndicator(),
        ],
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        effect: const ExpandingDotsEffect(
            dotWidth: 15, activeDotColor: Colors.blue),
        activeIndex: activeIndex,
        count: urlImages.length,
      );

  Widget buildImage(String urlImage, int index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Image.network(urlImage, fit: BoxFit.cover),
      );
}