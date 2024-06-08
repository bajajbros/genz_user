import 'package:customer/components/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'home_page.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  final String htmlData;
  final String name;
  const TermsAndConditionsScreen({super.key, required this.name, required this.htmlData});

  // ignore: library_private_types_in_public_api
  @override
  _TermsAndConditionsScreenState createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  final bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: primaryColor),
        backgroundColor: backgroundColor,
        title: CustomText(
          color: Colors.white,
          text: widget.name,
          size: 22,
          weight: FontWeight.w600,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
           
                const SizedBox(height: 20),
              
                const SizedBox(height: 20),
                Html(data: widget.htmlData)
                // CustomText(
                //   text:
                //       'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, eu    ismod non, mi. Proin porttitor, orci nec nonummy molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat. Duis semper. Duis arcu massa, scelerisque vitae, consequat in, pretium a, enim. Pellentesque congue. Ut in risus volutpat libero pharetra tempor. Cras vestibulum bibendum augue. Praesent egestas leo in pede. Praesent blandit odio eu enim. Pellentesque sed dui ut augue blandit sodales. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Aliquam nibh. Mauris ac mauris sed pede pellentesque fermentum. Maecenas adipiscing ante non diam sodales hendrerit.',
                //   color: Colors.grey[400],
                //   weight: FontWeight.w500,
                //   size: 18,
                // ),
                ,
                const SizedBox(height: 20),
                // CheckboxListTile(
                //   side: BorderSide(color: primaryColor),
                //   activeColor: primaryColor,
                //   value: _accepted,
                //   onChanged: (bool? value) {
                //     setState(() {
                //       _accepted = value!;
                //     });
                //   },
                //   title: Text(
                //     'I accept the ${widget.name}',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                // const SizedBox(height: 20),
                // buttonWidget('Accept'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
