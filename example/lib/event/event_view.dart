import 'package:flutter/material.dart';

class EventView extends StatelessWidget {
  const EventView({Key? key, required this.titleEvent}) : super(key: key);
  final String titleEvent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Event"),
      ),
      body: Center(
        child: Text(
          "$titleEvent",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
