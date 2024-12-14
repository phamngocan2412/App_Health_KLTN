import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TShimmer extends StatelessWidget {
  const TShimmer(
      {super.key,
      required this.width,
      required this.height,
      this.radius = 15,
      this.color});

  final double width, height, radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: color ?? Colors.grey[300]!,
      highlightColor: color ?? Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.white,
        ),
      ),
    );
  }
}
