// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SuggestionsWidget extends StatelessWidget {
  final Function(String) onSuggestionSelected;
  final bool isFirstLaunch;

  const SuggestionsWidget({super.key, required this.onSuggestionSelected, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    if (!isFirstLaunch) return Container();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Icon(Icons.add_comment_outlined, size: 100, color: Colors.grey,),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: () => onSuggestionSelected("Cách chữa đau họng bằng phương pháp dân gian là gì?"),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Cách chữa đau họng bằng phương pháp dân gian là gì?",
                style: TextStyle(fontSize: 15, color: Colors.black),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => onSuggestionSelected("Phương pháp dân gian trị cảm cúm hiệu quả là gì?"),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Phương pháp dân gian trị cảm cúm hiệu quả là gì?",
                style: TextStyle(fontSize: 15, color: Colors.black),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => onSuggestionSelected("Cách chữa đau đầu hiệu quả là gì?"),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Cách chữa đau đầu hiệu quả là gì?",
                style: TextStyle(fontSize: 15, color: Colors.black),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => onSuggestionSelected("Cách giảm mỏi mắt khi sử dụng điện thoại lâu là gì?"),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Cách giảm mỏi mắt khi sử dụng điện thoại lâu là gì?",
                style: TextStyle(fontSize: 15, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
