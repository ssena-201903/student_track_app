import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final FontWeight fontWeight;
  final double fontSize;
  final TextAlign? textAlign;
  final String? fontFamily;

  const CustomText({
    super.key,
    required this.text,
    required this.color,
    required this.fontWeight,
    required this.fontSize,
    this.textAlign,
    this.fontFamily,
  });

  @override
  Widget build(BuildContext context) {
    final style = fontFamily != null
        ? GoogleFonts.getFont(
            fontFamily!,
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          )
        : TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: fontWeight,
          );

    return Text(
      text,
      style: style,
      textAlign: textAlign,
    );
  }
}
