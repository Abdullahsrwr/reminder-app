import 'package:flutter/material.dart';
import 'notifications.dart';
import 'add.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key, required this.title});
  final String title;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Implementation Coming Soon"),
          ],
        ),
      ),
    );
  }
}
