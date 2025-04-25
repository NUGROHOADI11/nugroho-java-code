import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../styles/color_style.dart';

class CustomForm extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final Widget? suffixIcon;
  final bool required;
  final String? requiredText;
  final RxBool showError = false.obs;

  CustomForm({
    super.key,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.labelText,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.required = false,
    this.requiredText,
  }) {
    controller.addListener(_checkIfEmpty);
  }

  void _checkIfEmpty() {
    if (required && controller.text.isEmpty) {
      showError.value = true;
    } else {
      showError.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            floatingLabelStyle: const TextStyle(
              color: ColorStyle.primary,
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorStyle.secondary),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: ColorStyle.primary, width: 1.5),
            ),
            suffixIcon: suffixIcon,
          ),
        ),
        Obx(
          () => showError.value && requiredText != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    requiredText!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
