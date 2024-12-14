import 'package:flutter/material.dart';

class ColorPickerWidget extends StatefulWidget {
  final int initialSelectedColor;
  final Function(int) onColorSelected;

  const ColorPickerWidget({
    super.key,
    required this.initialSelectedColor,
    required this.onColorSelected,
  });

  @override
  ColorPickerWidgetState createState() => ColorPickerWidgetState();
}

class ColorPickerWidgetState extends State<ColorPickerWidget> {
  late int selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialSelectedColor;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Chọn màu sắc", // Thay đổi TText.colorTitle nếu cần
          style: TextStyle(
            color: Colors.black54,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16), // Thay đổi TSize.spaceFormField nếu cần
        Wrap(
          children: List<Widget>.generate(5, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = index;
                });
                widget.onColorSelected(selectedColor);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: _getColorForIndex(index),
                  child: selectedColor == index
                      ? const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 16,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Color _getColorForIndex(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.red[600]!;
      case 2:
        return Colors.indigo[600]!;
      case 3:
        return Colors.orange[600]!;
      default:
        return Colors.purple[600]!;
    }
  }
}
