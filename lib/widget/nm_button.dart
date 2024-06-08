import 'package:customer/components/color.dart';
import 'package:flutter/material.dart';

class NMButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const NMButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
        width: screenWidth - 40,
        child: ElevatedButton(
          onPressed: () => onPressed(),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            // boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
            // depth: 8,
            // intensity: 0.4,
            // color: primaryColor,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ));
  }
}
