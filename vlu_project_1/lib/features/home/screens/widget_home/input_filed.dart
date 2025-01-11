import 'package:flutter/material.dart';
import 'package:vlu_project_1/core/validate.dart';
import 'package:vlu_project_1/shared/size.dart';


class InputField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final String? text;
  final Icon? icon;

  const InputField({
    super.key,
    required this.hint,
    this.controller,
    this.icon,
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSize.spaceFormField),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            cursorColor: Colors.black,
            autofocus: false,
            controller: controller,
            validator: (value) {
              return Validate.string(value, enableNullOrEmpty: false);
            },
            decoration: InputDecoration(
              suffixIcon: icon,
              hintText: text,
              labelText: hint,
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 20.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
          ),
          const SizedBox(height: TSize.spaceBtwItems),
        ],
      ),
    );
  }
}

class InputDateFiled extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final String? text;
  final Widget? widget;
  const InputDateFiled({
    super.key, 
    required this.hint, 
    this.controller, this.widget, this.text
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSize.spaceFormField),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            cursorColor: Colors.black,
            autofocus: false,
            readOnly: widget == null ? false : true,
            controller: controller,
            validator: (text) {
              return Validate.userName(text, enableNullOrEmpty: false);
            },
            decoration: InputDecoration(
              suffixIcon: widget,
              hintText: text,
              labelText: hint,
              hintStyle: TextStyle(color: Colors.grey[600]),
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always, 
            ),
          ),
          const SizedBox(height: TSize.spaceBtwItems),
        ],
      ),
    );
  }
}

