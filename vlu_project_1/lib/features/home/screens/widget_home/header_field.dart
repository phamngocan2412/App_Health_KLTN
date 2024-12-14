import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vlu_project_1/core/utils/assets/theme.dart';

import 'package:vlu_project_1/features/home/screens/widget_home/button_add.dart';

class HeaderField extends StatelessWidget {
  final VoidCallback onTap; // Hàm được truyền vào

  const HeaderField({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: AppTextStyles.heading2,
              ),
              const Text("Hôm nay", style: AppTextStyles.heading1),
            ],
          ),
          // Button để thêm tác vụ mới
          ButtonAdd(
            label: "+ Thêm",
            onTap: onTap, // Gọi hàm onTap truyền từ ngoài vào
          ),
        ],
      ),
    );
  }
}
