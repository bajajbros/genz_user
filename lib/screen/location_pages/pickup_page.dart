import 'package:customer/components/color.dart';
import 'package:flutter/material.dart';

class PickUpScreen extends StatefulWidget {
  const PickUpScreen({Key? key}) : super(key: key);

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(110),
            child: Container(
              color: Colors.yellow,
              height: 110,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorMedia.blue,
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
