import 'package:flutter/material.dart';



Widget backgroundImage({required String imageURl}){
  return Image.asset(imageURl,
    fit: BoxFit.fill,
    height: double.infinity,
    width: double.infinity,
  );
}