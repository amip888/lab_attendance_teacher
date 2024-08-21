import 'package:flutter/material.dart';

class ComponentFilter {
  final String? id, title;
  final Color? color;
  bool isSelected;

  ComponentFilter({this.id, this.title, this.color, this.isSelected = false});
}
