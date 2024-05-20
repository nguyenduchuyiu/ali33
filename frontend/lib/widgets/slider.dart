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
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider.builder(
              itemCount: urlImages.length,
              itemBuilder: (context, index, realIndex) {
                final urlImage = urlImages[index];
                return buildImage(urlImage, index);
              },
              options: CarouselOptions(
                // height: 400,
                onPageChanged: (index, reason) => setState(() => activeIndex = index),
                autoPlay: true,
                autoPlayCurve : Curves.fastOutSlowIn,
                animateToClosest: true,
                aspectRatio: 4,
              ),
            ),
            const SizedBox(height: 12),
            buildIndicator(),
          ],
        ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
    effect: const ExpandingDotsEffect(dotWidth: 15, activeDotColor: Colors.blue),
    activeIndex: activeIndex,
    count: urlImages.length,
  );

  Widget buildImage(String urlImage, int index) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Image.network(urlImage, fit: BoxFit.cover));
}