import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  final double rating;
  const Rating({super.key, required this.rating});

  @override
  _RatingState createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  @override
  Widget build(BuildContext context) {
    return StarRating(
      rating: widget.rating/2,
      onRatingChanged: (rating) => setState(() => rating), 
      color: Colors.yellow,
    );
  }
}

typedef RatingChangeCallback = void Function(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;

  const StarRating({
    super.key, 
    this.starCount = 5,
    this.rating = .0, 
    required this.onRatingChanged, 
    required this.color,
  });

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = const Icon(
        Icons.star_border,
        color: Colors.yellow,
        size: 30, // Adjust the size here
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color,
        size: 30, // Adjust the size here
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color,
        size: 30, // Adjust the size here
      );
    }
    return InkResponse(
      // ignore: unnecessary_null_comparison
      onTap: onRatingChanged == null ? null : () => onRatingChanged(index + 1.0),
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: List.generate(starCount, (index) => buildStar(context, index)));
  }
}