import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      home: MyHomePage(title: 'Custom Scrollbar test app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    //print("My home page context height: " + context.size.height.toString() + "\n");
    super.initState();
  }

  Widget _buildList() {
    //print("context height: " + context.size.height.toString() + "\n");
    return ListView(

      controller: ScrollController(),
      children: <Widget>[
        ListTile(
          title: Text("item 1"),
        ),
        ListTile(
          title: Text("item 2"),
        ),
        ListTile(
          title: Text("item 3"),
        ),
        ListTile(
          title: Text("item 4"),
        ),
        ListTile(
          title: Text("item 5"),
        ),
        ListTile(
          title: Text("item 6"),
        ),
        ListTile(
          title: Text("item 7"),
        ),
        ListTile(
          title: Text("item 8"),
        ),
        ListTile(
          title: Text("item 9"),
        ),
        ListTile(
          title: Text("item 10"),
        ),
        ListTile(
          title: Text("item 11"),
        ),
        ListTile(
          title: Text("item 12"),
        ),
        ListTile(
          title: Text("item 13"),
        ),
        ListTile(
          title: Text("item 14"),
        ),
        ListTile(
          title: Text("item 15"),
        ),
      ],
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
      body: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          CustomScrollBar(child: _buildList(), scrollBarHeight: 35.0,),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomScrollBar extends StatefulWidget {
  final ListView child;
  final double scrollBarHeight;

  CustomScrollBar({this.child, this.scrollBarHeight});

  @override
  State createState() => new CustomScrollBarState();
}

class CustomScrollBarState extends State<CustomScrollBar> {
  double get _minScrollBarOffset => 0.0;
  double get _maxScrollBarOffset => context.size.height - widget.scrollBarHeight;
  double get _maxScrollExtent => widget.child.controller.position.maxScrollExtent;
  double _scrollBarOffset = 0.0;

  void scrollBarUpdate(DragUpdateDetails details) {
    //print(details.delta.toString() + "\n\n");
    _scrollBarOffset += details.delta.dy;
    if(_scrollBarOffset < _minScrollBarOffset) {
      _scrollBarOffset = _minScrollBarOffset;
    }
    if(_scrollBarOffset > _maxScrollBarOffset) {
      _scrollBarOffset = _maxScrollBarOffset;
    }

    double newControllerPosition = (_scrollBarOffset*_maxScrollExtent)/_maxScrollBarOffset;

    widget.child.controller.position.jumpTo(newControllerPosition);

    //print("context.size.height: " + context.size.height.toString() + "\n\n");

//    print("child.controller.offset: " + widget.child.controller.offset.toString() + "\n\n");

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topRight, children: <Widget>[
      widget.child,
      GestureDetector(
          onVerticalDragUpdate: scrollBarUpdate,
          child: Container(
            color: Colors.red,
            height: widget.scrollBarHeight,
            width: 12.0,
            margin: EdgeInsets.only(top: _scrollBarOffset),
            padding: EdgeInsets.only(left: 5.0),
          )),
    ]);
  }
}
