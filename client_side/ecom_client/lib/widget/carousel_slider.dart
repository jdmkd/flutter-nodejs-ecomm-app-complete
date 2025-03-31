import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../utility/app_color.dart';
import '../models/product.dart';
import '../utility/utility_extention.dart';
import 'custom_network_image.dart';

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({
    super.key,
    required this.items,
  });

  final List<Images> items;

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  int newIndex = 0;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: height * 0.32,
          child: PageView.builder(
            itemCount: widget.items.length,
            onPageChanged: (int currentIndex) {
              setState(() {
                newIndex = currentIndex;
              });
            },
            itemBuilder: (_, index) {
              final imageUrl = widget.items
                      .safeElementAt(index)
                      ?.url
                      ?.replaceAll('localhost', '192.168.141.74') ??
                  '';

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.grey[200],
                    child: CustomNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        AnimatedSmoothIndicator(
          effect: const WormEffect(
            dotColor: Colors.white,
            activeDotColor: AppColor.darkOrange,
            dotHeight: 8,
            dotWidth: 8,
          ),
          count: widget.items.length,
          activeIndex: newIndex,
        )
      ],
    );
  }
}
