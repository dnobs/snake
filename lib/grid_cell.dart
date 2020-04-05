import 'package:flutter/material.dart';

class GridCell{
  final loc;
  String text;
  Color color;

  GridCell({
    this.loc,
    this.text = "",
    this.color = Colors.grey,
  });
}