import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vlu_project_1/features/auth/controller/user_controller.dart';
import 'package:vlu_project_1/shared/widgets/shimmer.dart';
import 'package:vlu_project_1/shared/widgets/text_string.dart';



class THomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const THomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());

    return AppBar(
      elevation: 2,
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 30,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                TText.homeAppBarTitle,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium!
                    .apply(color: Colors.black87),
              ),
              Obx(() {
                if (controller.profileLoading.value) {
                  return const TShimmer(width: 80, height: 15);
                }
                return Text(
                  controller.user.value.fullName,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: Colors.blue),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
