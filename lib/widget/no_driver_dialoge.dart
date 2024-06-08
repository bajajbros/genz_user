import 'package:customer/screen/home/home_page.dart';
import 'package:flutter/material.dart';

class NoDriverFoundDialogue extends StatelessWidget {
  const NoDriverFoundDialogue(this.userId, this.token, {super.key});
  final String userId;
  final String token;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Row(
        children: const [
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 10),
          Text(
            "No Driver Found",
            style: TextStyle(
              color: Colors.red,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: const Text(
        "Sorry, we couldn't find any available driver at the moment. Please try again later.",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) {
            return HomePage(token: token, userId: userId);
          }), (route) => false),
          child: const Text(
            "OK",
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
