import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:read_more_text_demo/read_more_tail.dart';
export 'package:read_more_text_demo/read_more_tail.dart';

class ReadMoreText extends StatefulWidget {
  const ReadMoreText(this.data,
      {Key key,
      this.maxLines = 2,
      this.style,
      this.textAlign,
      this.textDirection,
      this.locale,
      this.textScaleFactor,
      this.unfoldTail,
      this.foldTail})
      : assert(data != null),
        super(key: key);

  final String data;
  final int maxLines;
  final TextStyle style;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final Locale locale;
  final double textScaleFactor;
  final ReadMoreTail unfoldTail;
  final ReadMoreTail foldTail;

  @override
  ReadMoreTextState createState() => ReadMoreTextState();
}

class ReadMoreTextState extends State<ReadMoreText> {
  bool _readMore = true;

  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);

    TextStyle effectiveTextStyle = widget.style;
    if (widget.style == null || widget.style.inherit) {
      effectiveTextStyle = defaultTextStyle.style.merge(widget.style);
    }
    final textAlign =
        widget.textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start;
    final textDirection = widget.textDirection ?? Directionality.of(context);
    final textScaleFactor =
        widget.textScaleFactor ?? MediaQuery.textScaleFactorOf(context);
    final overflow = defaultTextStyle.overflow;
    final locale =
        widget.locale ?? Localizations.localeOf(context, nullOk: true);

    Widget result = Column(
      children: <Widget>[
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            assert(constraints.hasBoundedWidth);
            final double maxWidth = constraints.maxWidth;

            final text = TextSpan(
              style: effectiveTextStyle,
              text: widget.data,
            );
            TextPainter textPainter = TextPainter(
              text: text,
              textAlign: textAlign,
              textDirection: textDirection,
              textScaleFactor: textScaleFactor,
              maxLines: widget.maxLines,
              locale: locale,
            );

            textPainter.layout(
                minWidth: constraints.minWidth, maxWidth: maxWidth);
            final textSize = textPainter.size;

            int endIndex = _getFoldTextEndIndex(textPainter, textSize);

            var textSpan;
            if (textPainter.didExceedMaxLines) {
              textSpan = TextSpan(
                  style: effectiveTextStyle,
                  text: _readMore
                      ? widget.data.substring(0, endIndex)
                      : widget.data,
                  children: <InlineSpan>[
                    _getTextTail()
                  ]);
            } else {
              textSpan = TextSpan(
                style: effectiveTextStyle,
                text: widget.data,
              );
            }

            return RichText(
              textAlign: textAlign,
              textDirection: textDirection,
              softWrap: true,
              overflow: TextOverflow.clip,
              textScaleFactor: textScaleFactor,
              text: textSpan,
            );
          },
        ),
      ],
    );
    return result;
  }

  int _getFoldTextEndIndex(TextPainter textPainter, Size textSize) {
    double offsetX;
    switch (widget.unfoldTail.tailAlign) {
      case ReadMoreTailAlign.ReadMoreTailAlignAppend:
      case ReadMoreTailAlign.ReadMoreTailAlignEnd:
        offsetX = textSize.width - widget.unfoldTail.size.width;
        break;
      default:
        offsetX = textSize.width;
    }

    final pos = textPainter.getPositionForOffset(Offset(
      offsetX,
      textSize.height,
    ));
    return textPainter.getOffsetBefore(pos.offset);
  }

  WidgetSpan _getTextTail() {
    final tail = _readMore ? widget.unfoldTail : widget.foldTail;
    double outWidth;
    Alignment align;
    switch (widget.unfoldTail.tailAlign) {
      case ReadMoreTailAlign.ReadMoreTailAlignAppend:
      case ReadMoreTailAlign.ReadMoreTailAlignEnd:
        outWidth = tail.size.width;
        align = Alignment.centerRight;
        break;
      case ReadMoreTailAlign.ReadMoreTailAlignNextLineHead:
        outWidth = double.maxFinite;
        align = Alignment.centerLeft;
        break;
      case ReadMoreTailAlign.ReadMoreTailAlignNextLineEnd:
        outWidth = double.maxFinite;
        align = Alignment.centerRight;
        break;
      default:
    }

    return WidgetSpan(
        child: Container(
          alignment: align,
          width: outWidth,
          child: Container(
            width: tail.size.width,
            decoration: BoxDecoration(color: Colors.yellowAccent),
            child: InkWell(
              child:
              _readMore ? widget.unfoldTail : widget.foldTail,
              onTap: _onTapLink,
            ),
          ),
        ));
  }
}
