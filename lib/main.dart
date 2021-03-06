import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final ScrollController controller = ScrollController();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Scrollbar',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(
          title: 'Custom Scrollbar test app', controller: controller),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.controller}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final ScrollController controller;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _childHeight = 20.0;

  Widget _buildRow(int index) {
    return Container(
      height: _childHeight,
      child: Text("item " + index.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        child: CustomScrollBar(
          scrollBarHeight: 35.0,
          controller: widget.controller,
          childHeight: _childHeight,
          buildRow: _buildRow,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomScrollBar extends StatefulWidget {
  final double scrollBarHeight;
  final ScrollController controller;
  final double childHeight;
  final Function buildRow;

  CustomScrollBar(
      {this.scrollBarHeight, this.controller, this.childHeight, this.buildRow});

  @override
  State createState() => new CustomScrollBarState();
}

class CustomScrollBarState extends State<CustomScrollBar> {
  double get _viewPortDimension => widget.controller.position.viewportDimension;
  bool _isDragInProcess = false;
  double get _minScrollBarOffset => 0.0;
  double get _maxScrollBarOffset => _viewPortDimension - widget.scrollBarHeight;
  double _minScrollExtent = 0.0;
  double _maxScrollExtent = 0.0;
  double _scrollBarOffset = 0.0;
  double _listViewOffset = 0.0;
  int _nOfChildren = 0;
  double _childHeight = 20.0;

  ListView _listView;

  @override
  void initState() {
    _listView = _buildList();

    //print("_listView.controller: " + _listView.controller.toString() + "\n");
    //print("_listView.controller.position: " + _listView.controller.position.toString() + "\n");

    //print("My home page context height: " + context.size.height.toString() + "\n");
    super.initState();
  }

  Widget _buildList() {
    //print("context height: " + context.size.height.toString() + "\n");
    return ListView.builder(
      controller: widget.controller,
      itemBuilder: (BuildContext context, int index) {
        _nOfChildren = max(_nOfChildren, index);
        _maxScrollExtent = _nOfChildren * _childHeight - _viewPortDimension;
        return widget.buildRow(index);
      },
    );
  }

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
    widget.controller.position.jumpTo(_listViewOffset);

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
          _listView,
          GestureDetector(
              onVerticalDragUpdate: _onVerticalDragUpdate,
              onVerticalDragStart: _onVerticalDragStart,
              onVerticalDragEnd: _onVerticalDragEnd,
              child: Container(
                color: Colors.red,
                height: widget.scrollBarHeight,
                width: 12.0,
                margin: EdgeInsets.only(top: _scrollBarOffset),
                padding: EdgeInsets.only(left: 5.0),
              )),
        ]));
  }
}
