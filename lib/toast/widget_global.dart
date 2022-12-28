import 'package:flutter/material.dart';

class Widgets {
  static AlertDialog baseAlertDialog(
    Color backgroundColor,
    double radius,
    String title,
    TextStyle titleStyle,
    List<Widget> actions,
    String middleText,
    TextStyle middleTextStyle,
    dynamic content,
  ) {
    return AlertDialog(
      titlePadding: const EdgeInsets.all(8),
      contentPadding: const EdgeInsets.all(8),

      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius))),
      title: Text(title, textAlign: TextAlign.center, style: titleStyle),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          content ??
              Text(middleText,
                  textAlign: TextAlign.center, style: middleTextStyle),
          const SizedBox(height: 16),
          ButtonTheme(
            minWidth: 78.0,
            height: 34.0,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: actions,
            ),
          )
        ],
      ),
      // actions: actions, // ?? <Widget>[cancelButton, confirmButton],
      buttonPadding: EdgeInsets.zero,
    );
  }
}
