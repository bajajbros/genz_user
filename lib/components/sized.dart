import 'package:flutter/material.dart';


class SizedMedia{

  static heightDivide(BuildContext context, double size) => MediaQuery.of(context).size.height/size;
  static heightMultiply(BuildContext context, double size) => MediaQuery.of(context).size.height*size;
  static widthDivide(BuildContext context, double size) => MediaQuery.of(context).size.width/size;
  static widthMultiply(BuildContext context, double size) => MediaQuery.of(context).size.width*size;


  static sizeHeightMultiply(BuildContext context, double size) => SizedBox(height: heightMultiply(context, size),);
  static sizeHeightDivide(BuildContext context, double size) => SizedBox(height: heightDivide(context, size),);
  static sizeWidthDivide(BuildContext context, double size) => SizedBox(width: widthDivide(context, size),);
  static sizeWidthMultiply(BuildContext context, double size) => SizedBox(width: widthMultiply(context, size),);

}