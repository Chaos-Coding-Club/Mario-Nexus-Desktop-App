import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:mario_nexus/screens/loading.dart';

class MarioNexus extends StatelessWidget {
  const MarioNexus({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      debugShowCheckedModeBanner: false,
      title: "Mario Nexus",
      theme: MacosThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.red,
      ),
      home: const Loading(),
    );
  }
}
