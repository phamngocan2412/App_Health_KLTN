import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

part './icons.dart';
part './images.dart';

class Assets {
  static final img = _Image();
  static final ic = _Icon();
}

extension StringAssetExt on String {
  SvgPicture buildSvg(
      {double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return SvgPicture.asset(
      this,
      width: width,
      height: height,
      fit: fit,
    );
  }

  Widget build({double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return Image.asset(
      this,
      width: width,
      height: height,
      fit: fit,
    );
  }
}
