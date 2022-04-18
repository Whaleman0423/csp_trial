import 'package:flutter/material.dart';

// 主背景 白色
const Color primaryBackground = Colors.white10;
// 主按鈕元件-背景 深綠
const Color primaryElement = Color(0xFF607D8B);
// 主按鈕元件-文字 白色
const Color primaryTextElement = Colors.white;
// 文字按鈕元件-背景 透明
const Color secondElement = Colors.transparent;

const BorderSide primaryBorder = BorderSide(
  color: primaryElement,
  width: 1,
  style: BorderStyle.solid,
);

// 按鈕元件Border
const BorderRadiusGeometry k5pxRadius = BorderRadius.all(Radius.circular(5));
// 圖片元件Border
const BorderRadiusGeometry k10pxRadius = BorderRadius.all(Radius.circular(10));
// 廣告元件Border
const BorderRadiusGeometry k15pxRadius = BorderRadius.all(Radius.circular(15));
