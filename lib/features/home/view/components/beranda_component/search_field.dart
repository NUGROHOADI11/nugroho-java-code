
  import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../shared/styles/color_style.dart';

Widget buildSearchField(controller) {
    return TextField(
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontFamily: 'OpenSans',
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: ColorStyle.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: ColorStyle.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: ColorStyle.primary),
        ),
        contentPadding: const EdgeInsets.only(top: 14.0),
        prefixIcon: const Icon(Icons.search, color: ColorStyle.primary),
        prefixIconColor: Colors.grey[700],
        hintText: 'Pencarian'.tr,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontFamily: 'OpenSans',
        ),
      ),
      onChanged: controller.setSearchQuery,
    );
  }