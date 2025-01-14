import 'package:flutter/material.dart';

import '../page_index.dart';

class SelectTextItem extends StatelessWidget {
  const SelectTextItem({
    Key key,
    this.onTap,
    @required this.title,
    this.content: "",
    this.textAlign: TextAlign.end,
    this.style,
    this.leading,
    this.subTitle: "",
    this.height: 55.0,
    this.trailing: Icons.chevron_right,
  }) : super(key: key);

  final GestureTapCallback onTap;
  final String title;
  final String content;
  final TextAlign textAlign;
  final TextStyle style;
  final IconData leading;
  final IconData trailing;
  final String subTitle;
  final double height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Container(
            height: height,
            margin: const EdgeInsets.only(right: 8.0, left: 8.0),
            width: double.infinity,
            child: Row(children: <Widget>[
              Offstage(
                  offstage: leading == null,
                  child: Row(children: <Widget>[
                    Icon(leading, size: 26.0),
                    Gaps.hGap8
                  ])),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(title, style: TextStyles.textDark14, maxLines: 1),
                    Offstage(
                        offstage: subTitle.isEmpty,
                        child: Text(subTitle,
                            style: TextStyles.textGray12, maxLines: 1))
                  ]),
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                      child: Text(content,
                          maxLines: 2,
                          textAlign: textAlign,
                          overflow: TextOverflow.ellipsis,
                          style: style ?? TextStyles.textDark14))),
              Icon(trailing, size: 22.0)
            ])));
  }
}
