import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/features/auth/controller/sign_up_controller.dart';
import 'package:vlu_project_1/shared/size.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';



class TermsConditionsCheckbox extends StatelessWidget {
  const TermsConditionsCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignUpController.instance;
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Obx(() => Checkbox(
              value: controller.privacyPolicy.value,
              onChanged: (value) => controller.privacyPolicy.value =
                  !controller.privacyPolicy.value)),
        ),
        const SizedBox(width: TSize.spaceBtwItems),
        Expanded(
          child: Text.rich(TextSpan(children: [
            TextSpan(
                // ignore: unnecessary_string_interpolations
                text: '${TText.iArgreeTo}',
                style: Theme.of(context).textTheme.bodySmall),
            TextSpan(
              // ignore: unnecessary_string_interpolations
              text: '${TText.privacyPolicy}',
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue),
            ),
            TextSpan(
              text: ' ${TText.and}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            TextSpan(
              // ignore: unnecessary_string_interpolations
              text: '${TText.termsOfUse}',
              style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue),
            ),
          ])),
        ),
      ],
    );
  }
}
