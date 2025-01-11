import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vlu_project_1/shared/size.dart';

class AnimationLoaderWidget extends StatelessWidget {
  const AnimationLoaderWidget(
      {super.key,
      required this.text,
      required this.animation,
      this.showAction = false,
      this.onActionPressed,
      this.actionText});

  final String text;
  final String animation;
  final bool showAction;
  final VoidCallback? onActionPressed;
  final String? actionText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            animation,
            width: MediaQuery.of(context).size.width * 0.8, 
          ),
          const SizedBox(height: TSize.defaultSpace),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TSize.defaultSpace),
          showAction
              ? SizedBox(
                  width: 250,
                  child: OutlinedButton(
                    onPressed: onActionPressed,
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.transparent),
                    child: Text(
                      actionText!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .apply(color: Colors.grey),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
