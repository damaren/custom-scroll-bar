import 'package:flutter/material.dart';

class CustomScrollBar extends StatefulWidget {
  final double childHeight;
  final Function buildRow;

  CustomScrollBar({this.childHeight, this.buildRow});

  @override
  State createState() => new CustomScrollBarState();
}

class CustomScrollBarState extends State<CustomScrollBar> {
  double scrollBarHeight = 40.0;
  ScrollController _controller = ScrollController();
  double get _viewPortDimension => _controller.position.viewportDimension;
  bool _isDragInProcess = false;
  double get _minScrollBarOffset => 0.0;
  double get _maxScrollBarOffset => _viewPortDimension - scrollBarHeight;
  double _minScrollExtent = 0.0;
  double _maxScrollExtent = 0.0;
  double _scrollBarOffset = 0.0;
  double _listViewOffset = 0.0;
  int _nOfChildren = 0;
  double get _childHeight => widget.childHeight;

  int max(int a, int b) {
    if (a > b) return a;
    return b;
  }

  // called when the scrollbar has been dragged
  _onVerticalDragUpdate(DragUpdateDetails details) {
    print("_maxScrollExtent: " + _maxScrollExtent.toString() + "\n\n");
    print("_listViewOffset: " + _listViewOffset.toString() + "\n\n");

    // update the scroll bar offset according to the drag
    _scrollBarOffset += details.delta.dy;

    // don't allow the scroll bar offset to be outside the limits
    if (_scrollBarOffset < _minScrollBarOffset) {
      _scrollBarOffset = _minScrollBarOffset;
    }
    if (_scrollBarOffset > _maxScrollBarOffset) {
      _scrollBarOffset = _maxScrollBarOffset;
    }

    // calculate the list view offset according to the formula (listViewOffset/masScrollExtent=scrollBarOffset/maxScrollBarOffset)
    _listViewOffset =
        (_scrollBarOffset * _maxScrollExtent) / _maxScrollBarOffset;

    // update the list view's position
    _controller.position.jumpTo(_listViewOffset);

    setState(() {});
  }

  // called when the listview has been scrolled
  _onNotification(ScrollNotification notification) {
    // dragging the scrollbar will trigger a movement in the listview, and thus _onNotification will be called. In that case, _onNotification should return without doing anything.
    if (_isDragInProcess) {
      return;
    }

    setState(() {
      if (notification is ScrollUpdateNotification) {
        // update the list view offset according to the scroll
        _listViewOffset += notification.scrollDelta;

        // dont't allow the list view offset to be outside the limits
        if (_listViewOffset < _minScrollExtent) {
          _listViewOffset = _minScrollExtent;
        }
        if (_listViewOffset > _maxScrollExtent) {
          _listViewOffset = _maxScrollExtent;
        }

        // calculate the scroll bar offset according to the formula (listViewOffset/masScrollExtent=scrollBarOffset/maxScrollBarOffset)
        _scrollBarOffset =
            (_listViewOffset * _maxScrollBarOffset) / _maxScrollExtent;
      }
    });
  }

  _onVerticalDragStart(DragStartDetails details) {
    _isDragInProcess = true;
  }

  _onVerticalDragEnd(DragEndDetails details) {
    _isDragInProcess = false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          _onNotification(notification);
        },
        child: Stack(alignment: Alignment.topRight, children: <Widget>[
          ListView.builder(
            controller: _controller,
            itemBuilder: (BuildContext context, int index) {
              _nOfChildren = max(_nOfChildren, index);
              _maxScrollExtent =
                  _nOfChildren * _childHeight - _viewPortDimension;
              return widget.buildRow(index);
            },
          ),
          GestureDetector(
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: Container(
                color: Colors.red,
                height: scrollBarHeight,
                width: 12.0,
                margin: EdgeInsets.only(top: _scrollBarOffset),
                padding: EdgeInsets.only(left: 5.0),
              )),
        ]));
  }
}