import 'package:flutter/material.dart';

import '../components/color.dart';
import '../components/text_style.dart';


Widget buttonWidget(String textName ,{double padding = 20}){
  return Container(
    height: 50,
    margin:  EdgeInsets.symmetric(horizontal: 30, vertical: padding),
    width: double.infinity,
    decoration: BoxDecoration(
      color: primaryColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Center(
      child: Text(textName, style: TStyleMedia.whiteRoboto17SemiBold2,),
    ),
  );
}