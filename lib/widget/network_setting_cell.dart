import 'package:flutter/material.dart';
import '../common/model/network.dart';
import '../common/style/string_set.dart';

class NetworkSettingCell extends StatefulWidget {
  final Network network;
  final GestureTapCallback onTap;
  final GestureTapCallback onEdit;
  final GestureTapCallback onDelete;

  NetworkSettingCell({
    @required this.network,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  _NetworkSettingCellState createState() => _NetworkSettingCellState();
}

class _NetworkSettingCellState extends State<NetworkSettingCell> {
  Offset _tapPosition;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _storePosition,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                (widget.network.name ?? StringSet.EMPTY).isEmpty
                    ? widget.network.address
                    : widget.network.name,
              ),
              subtitle: (widget.network.name ?? StringSet.EMPTY).isEmpty
                  ? null
                  : Text(
                      widget.network.address,
                      style: TextStyle(color: Colors.black),
                    ),
              trailing: Offstage(
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).primaryColor,
                ),
                offstage: !widget.network.isChecked,
              ),
              onTap: widget.onTap,
              onLongPress: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromRect(
                      _tapPosition & Size.zero,
                      Offset.zero &
                          (Overlay.of(context).context.findRenderObject()
                                  as RenderBox)
                              .size),
                  items: <PopupMenuEntry>[
                    PopupMenuItem(
                      value: StringSet.EDIT,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.edit),
                          Text(StringSet.EDIT),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: StringSet.DELETE,
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.delete),
                          Text(StringSet.DELETE),
                        ],
                      ),
                    ),
                  ],
                ).then((value) {
                  switch (value) {
                    case StringSet.EDIT:
                      widget.onEdit();
                      break;
                    case StringSet.DELETE:
                      widget.onDelete();
                      break;
                    default:
                      break;
                  }
                });
              },
            ),
            Divider(
              height: 1,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}
