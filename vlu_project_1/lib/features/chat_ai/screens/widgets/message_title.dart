import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/message.dart';


class MessageTile extends StatelessWidget {
  final Message message;
  final bool isOutgoing;

  const MessageTile({
    super.key,
    required this.message,
    required this.isOutgoing,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat.Hm().format(message.createdAt);
    return Align(
      alignment: isOutgoing ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isOutgoing ? Colors.blue[300] : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: isOutgoing ? Colors.white : Colors.black,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 2),
            message.imageUrl != null
                ? Image.network(message.imageUrl!)
                : const SizedBox.shrink(),
            Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  formattedTime,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}