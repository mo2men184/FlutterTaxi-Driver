import 'package:rugbydriver/themes/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonThem {
  const ButtonThem({Key? key});

  static buildButton(
    BuildContext context, {
    required String title,
    required Color btnColor,
    required Color txtColor,
    double btnHeight = 50,
    double txtSize = 14,
    double btnWidthRatio = 0.9,
    required Function() onPress,
    bool isVisible = true,
  }) {
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: Responsive.width(100, context) * btnWidthRatio,
        child: MaterialButton(
          onPressed: onPress,
          height: btnHeight,
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          color: btnColor,
          child: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
                color: txtColor,
                fontSize: txtSize,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  static buildBorderButton(
    BuildContext context, {
    required String title,
    required Color btnColor,
    required Color btnBorderColor,
    required Color txtColor,
    double btnHeight = 50,
    double txtSize = 14,
    double btnWidthRatio = 0.9,
    required Function() onPress,
    bool isVisible = true,
  }) {
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: Responsive.width(100, context) * btnWidthRatio,
        height: btnHeight,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(btnColor),
            foregroundColor: MaterialStateProperty.all<Color>(txtColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.0),
                side: BorderSide(color: btnBorderColor, width: 1.5),
              ),
            ),
          ),
          onPressed: onPress,
          child: Text(title.toString()),
        ),
      ),
    );
  }

  static buildIconButton(
    BuildContext context, {
    required String title,
    required Color btnColor,
    required Color txtColor,
    required Color iconColor,
    required IconData icon,
    double btnHeight = 50,
    double txtSize = 16,
    double btnWidthRatio = 0.9,
    required Function() onPress,
    bool isVisible = true,
  }) {
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: Responsive.width(100, context) * btnWidthRatio,
        height: btnHeight,
        child: TextButton.icon(
          style: TextButton.styleFrom(
            backgroundColor: btnColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            ),
          ),
          onPressed: onPress,
          label: Text(
            title.toString(),
            style: TextStyle(color: txtColor, fontSize: txtSize),
          ),
          icon: Icon(icon, color: iconColor),
        ),
      ),
    );
  }
}
