import 'package:flutter/material.dart';
import 'package:vlu_project_1/core/utils/extensions/list_extensions.dart';

class SpacingColumn extends Column {
  SpacingColumn({
    double spacing = 0,
    List<Widget> children = const [],
    super.mainAxisSize = MainAxisSize.min,
    super.mainAxisAlignment = MainAxisAlignment.start,
    super.crossAxisAlignment = CrossAxisAlignment.start,
    super.key,
  }) : super(
          children: children.addBetweenEvery(SizedBox(height: spacing)),
        );
}
