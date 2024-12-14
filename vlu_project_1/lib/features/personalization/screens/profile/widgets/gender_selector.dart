import 'package:flutter/material.dart';
import 'package:vlu_project_1/shared/size.dart';

class GenderSelector extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onValueChanged;

  const GenderSelector({
    super.key,
    required this.initialValue,
    required this.onValueChanged,
  });

  @override
  GenderSelectorState createState() => GenderSelectorState();
}

class GenderSelectorState extends State<GenderSelector> {
  late String selectedGender;

  @override
  void initState() {
    super.initState();
    selectedGender = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: TSize.spaceBtwInputField,),
        ListTile(
          title: const Text('Nam'),
          leading: Radio<String>(
            value: 'Nam',
            groupValue: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value!;
                widget.onValueChanged(selectedGender); // Gọi callback khi chọn mới
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Nữ'),
          leading: Radio<String>(
            value: 'Nữ',
            groupValue: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value!;
                widget.onValueChanged(selectedGender); // Gọi callback khi chọn mới
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Khác'),
          leading: Radio<String>(
            value: 'Khác',
            groupValue: selectedGender,
            onChanged: (value) {
              setState(() {
                selectedGender = value!;
                widget.onValueChanged(selectedGender); // Gọi callback khi chọn mới
              });
            },
          ),
        ),
      ],
    );
  }
}
