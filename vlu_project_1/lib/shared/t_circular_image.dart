// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vlu_project_1/shared/widgets/shimmer.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.fit = BoxFit.cover,
    required this.image,
    this.isNetWorkImage = false,
    this.overlayColor,
    this.backgroundColor = Colors.white,
    this.borderWidth = 3,
    this.borderColor = Colors.blue,
    this.width = 56,
    this.height = 56,
    this.iconPlaceholder = Icons.person,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetWorkImage;
  final Color? overlayColor;
  final Color backgroundColor;
  final double width, height, borderWidth;
  final Color borderColor;
  final IconData iconPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Colors.pink.withOpacity(0.1), Colors.blue.withOpacity(0.1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipOval(
        child: Center(
          child: isNetWorkImage
              ? CachedNetworkImage(
                  imageUrl: image,
                  fit: fit,
                  filterQuality: FilterQuality.high,
                  color: overlayColor,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const TShimmer(width: 55, height: 55),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.error,
                    color: Colors.redAccent,
                    size: 40,
                  ),
                )
              : image.isNotEmpty
                  ? Image.asset(
                      image,
                      fit: fit,
                      filterQuality: FilterQuality.high,
                      color: overlayColor,
                      width: width,
                      height: height,
                    )
                  : Icon(
                      iconPlaceholder,
                      color: Colors.grey,
                      size: width * 0.5,
                    ),
        ),
      ),
    );
  }
}
