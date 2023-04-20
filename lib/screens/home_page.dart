import 'package:flutter/material.dart';
import 'package:platewise/screens/add_friends.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PlateWise"),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, right: 8),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, AddFriendsScreen.routeName);
          },
          label: const Text("Add Friends"),
        ),
      ),
    );
  }
}
