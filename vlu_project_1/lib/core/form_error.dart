import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vlu_project_1/shared/widgets/sized_box.dart';


class FormError extends StatelessWidget {
  const FormError({
    super.key,
    required this.errors,
  });

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        errors.length,
        (index) => formErrorText(errors[index]),
      ),
    );
  }

  Row formErrorText(String error) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/error.svg",
          height: 14.h,
          width: 14.h,
        ),
        sw(10.w),
        Text(error),
      ],
    );
  }
}
