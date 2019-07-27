import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Logo extends StatelessWidget {
  var logoHeight = 36.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 20.0),
      child: SvgPicture.asset(
        "assets/logo.svg",
        width: 60.0,
        height: logoHeight,
      ),
    );
  }
}
