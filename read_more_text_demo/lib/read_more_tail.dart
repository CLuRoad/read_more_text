import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum ReadMoreTailAlign {
  ReadMoreTailAlignAppend,
  ReadMoreTailAlignEnd,
  ReadMoreTailAlignNextLineHead,
  ReadMoreTailAlignNextLineEnd
}

class ReadMoreTail extends StatelessWidget {
  const ReadMoreTail({
    Key key,
    this.text,
    this.tailAlign = ReadMoreTailAlign.ReadMoreTailAlignNextLineHead,
    this.padding,
    this.header,
    this.footer,
    this.onTap
})
      : super(key: key);

  final Text text;
  final ReadMoreTailAlign tailAlign;
  final EdgeInsetsGeometry padding;
  final SizedBox header;
  final SizedBox footer;
  final GestureTapCallback onTap;

  Size get size => tailSize(this);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          List<Widget> result = [text];
          if (header != null) {
            result.insert(0, header);
          }
          if (footer != null) {
            result.add(footer);
          }
          return Row(
            children: result,
            mainAxisAlignment: MainAxisAlignment.end,
          );
        });
  }

  Size tailSize(ReadMoreTail tail) {
    final text = TextSpan(
      style: tail.text.style,
      text: tail.text.data,
    );
    TextPainter textPainter = TextPainter(
        text: text,
        textAlign: tail.text.textAlign ?? TextAlign.left,
        textDirection: tail.text.textDirection ?? TextDirection.ltr,
        textScaleFactor: tail.text.textScaleFactor ?? 1.0,
        maxLines: tail.text.maxLines,
        locale: tail.text.locale,
        textWidthBasis: TextWidthBasis.parent);

    textPainter.layout(minWidth: 0, maxWidth: double.maxFinite);
    double width = textPainter.size.width +
        (this.header?.width ?? 0) +
        (this.footer?.width ?? 0);
    double height = max(
        max((this.header?.height ?? 0), (this.footer?.height ?? 0)),
        textPainter.size.height);
    return Size(width, height);
  }
}