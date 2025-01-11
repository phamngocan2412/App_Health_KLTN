import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vlu_project_1/core/utils/assets/theme.dart';
import 'package:vlu_project_1/features/home/screens/widget_home/button_add.dart';
import '../../../../localization.dart';

class HeaderField extends StatelessWidget {
  final VoidCallback onTap;

  const HeaderField({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final formattedDate = DateFormat.yMMMMd(localizations.locale.toString())
        .format(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style: AppTextStyles.heading2,
              ),
              Text(
                localizations.today, 
                style: AppTextStyles.heading1,
              ),
            ],
          ),
          ButtonAdd(
            label: localizations.addButtonLabel,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
