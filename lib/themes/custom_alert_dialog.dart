import 'package:rugbydriver/themes/button_them.dart';
import 'package:rugbydriver/themes/constant_colors.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String positiveButtonText;
  final String negativeButtonText;
  final Function()? onPressPositive;
  final Function()? onPressNegative;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.positiveButtonText,
    required this.negativeButtonText,
    this.onPressPositive,
    this.onPressNegative,
  }) : super(key: key);

  @override
  CustomAlertDialogState createState() => CustomAlertDialogState();
}

class CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding:
              const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title.toString(),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  widget.onPressPositive != null
                      ? Expanded(
                          child: ButtonThem.buildButton(
                            context,
                            title: widget.positiveButtonText,
                            btnHeight: 45,
                            btnWidthRatio: 0.8,
                            btnColor: ConstantColors.primary,
                            txtColor: Colors.white,
                            onPress: widget.onPressPositive!,
                          ),
                        )
                      : Container(),
                  const SizedBox(
                    width: 8,
                  ),
                  widget.onPressNegative != null
                      ? Expanded(
                          child: ButtonThem.buildBorderButton(
                            context,
                            title: widget.negativeButtonText,
                            btnHeight: 45,
                            btnWidthRatio: 0.8,
                            btnColor: Colors.white,
                            txtColor: Colors.black.withOpacity(0.60),
                            btnBorderColor: Colors.black.withOpacity(0.20),
                            onPress: widget.onPressNegative!,
                          ),
                        )
                      : Container()
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
