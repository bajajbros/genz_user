import 'package:customer/screen/home/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchField extends StatefulWidget {
  // final Position position;

  final String token;
  // final String userName;
  // final String userPhone;
  final String userId;
  const SearchField({
    super.key,
    required this.token, required this.userId,
    // required this.userName,
    // required this.userPhone,
    // required this.userId,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: SizeConfig.screenWidth * 0.6,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: TextField(
          readOnly: true,
          onTap: ()  {
            // Position position = await Geolocator.getCurrentPosition();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DashboardScreen(
                office: false,
                userId: widget.userId,
                token: widget.token,
                // position: position,
              );
            },
            ),
            );
          },
          // textAlign: TextAlign.center,
          // onChanged: (value) => print(value),
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: (20), vertical: (20),),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: "Where to?",
              hintStyle: GoogleFonts.manrope(
                textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.black87,
                size: 30,
              )),
        ),
      ),
    );
  }
}
