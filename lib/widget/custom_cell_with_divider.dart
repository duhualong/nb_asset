import 'package:flutter/material.dart';

class CustomCellWithDivider extends StatelessWidget {
  final Widget child;
  final double height;
  final Color color;

  CustomCellWithDivider({
    Key key,
    this.child,
    this.height,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return height == null
        ? Container(
      color: color,
      child: Column(
        children: <Widget>[
          Expanded(
            child: child,
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          )
        ],
      ),
    )
        : Container(
      height: height,
      color: color,
      child: Column(
        children: <Widget>[
          Expanded(
            child: child,
          ),
          Container(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}
