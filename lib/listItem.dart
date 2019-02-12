import 'package:flutter/material.dart';
import 'content.dart';
import 'contentDetails.dart';

class ListItem extends StatelessWidget {
  Content content;
  final double height;

  ListItem(this.content, this.height);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContentDetails(content)),
          );
        },
        child: Row(children: [
          Container(
            height: height,
            child: Text(content.getTitle()),
          ),
          Container(child: Text(content.checked.toString())),
        ]));
  }
}
