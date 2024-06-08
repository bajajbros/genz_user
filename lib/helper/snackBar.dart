import 'package:customer/components/color.dart';
import 'package:flutter/material.dart';


snackWidget(context, message){
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: primaryColor,
      ),
  );
}