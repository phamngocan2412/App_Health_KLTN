import "package:flutter/widgets.dart";
import "package:vlu_project_1/shared/size.dart";

class TSpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
      top: TSize.appBarHeight,
      left: TSize.defaultSpace,
      right: TSize.defaultSpace,
      bottom: TSize.defaultSpace);
}
