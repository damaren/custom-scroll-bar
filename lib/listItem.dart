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
          Container(
              child: Icon(
            Icons.check_box,
            color: content.checked ? Colors.green : Colors.red,
          )),
//              child: Text(
//            "bool checked",
//            style:
//                TextStyle(color: content.checked ? Colors.green : Colors.red),
//          )),
        ]));
  }
}
