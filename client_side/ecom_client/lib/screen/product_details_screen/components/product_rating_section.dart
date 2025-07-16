import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductRatingSection extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const ProductRatingSection({
    super.key,
    this.rating = 3.2, // You can pass the rating dynamically
    this.reviewCount = 26, // You can pass the review count dynamically
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12, // Adjust the spacing between elements
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true, // Allow half ratings
          itemCount: 5,
          itemSize: 24, // Set the size of the stars
          itemBuilder: (_, __) =>
              const FaIcon(FontAwesomeIcons.solidStar, color: Colors.amber),
          onRatingUpdate: (newRating) {
            // Handle the rating update if necessary
            print("Rating updated: $newRating");
          },
        ),
        Text(
          "($reviewCount Reviews)",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
        ),
      ],
    );
  }
}
