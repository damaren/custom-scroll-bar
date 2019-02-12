import 'package:flutter/material.dart';
import 'content.dart';

class ContentDetails extends StatefulWidget {
  Content content;

  @override
  createState() => new ContentDetailsState();

  ContentDetails(this.content);
}

class ContentDetailsState extends State<ContentDetails> {
  @override
  void initSate() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.content.getTitle()),
        ),
        body: Column(children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(widget.content.getDescription()),
          ),
          Container(
            alignment: Alignment.center,
            child: Checkbox(
                value: widget.content.checked,
                onChanged: (bool value) {
                  widget.content.setChecked();
                  setState(() {
                  });
                }),
          )
        ]));
  }
}
