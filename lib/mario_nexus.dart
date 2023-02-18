import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mario_nexus/screens/loading.dart';

class MarioNexus extends StatelessWidget {
  const MarioNexus({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: "Mario Nexus",
      theme: CupertinoThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
      ),
      home: Loading(),
    );
  }
}
