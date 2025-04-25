import 'package:flutter/material.dart';

Widget buildInfoCard(List<Widget> children) {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(children: children),
  );
}
