import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/ui/shared/app_colors.dart';
import 'package:chat_app/ui/shared/font_size.dart';

class MyText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign align;

  MyText(this.text, {this.style, this.align});

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: style,
      maxLines: 1,
      minFontSize: 0,
      textAlign: align,
    );
  }
}
