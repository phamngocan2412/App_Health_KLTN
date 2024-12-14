import 'package:flutter/material.dart';
import 'package:vlu_project_1/shared/helper_functions.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:vlu_project_1/shared/spacing_styles.dart';
import 'package:vlu_project_1/shared/widgets/app_bar_custom.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';


class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      required this.onPressed});

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarCustom(),
        body: SingleChildScrollView(
            child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(children: [
            // Image
            Image(
              image: const AssetImage("assets/images/sign_up_success.png"),
              width: HelperFunctions.screenWidth() * 0.6,
            ),
            // Title & SubTitle
            Text(title,
                style: const TextStyle(fontSize: 24),
                textAlign: TextAlign.center), // Example title
            const SizedBox(height: TSize.spaceBtwItems),
            Text(subTitle,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center), // Example subtitle
            const SizedBox(height: TSize.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: onPressed,
                child: const Text(TText.tcontinue),
              ),
            ),
          ]),
        )));
  }
}
