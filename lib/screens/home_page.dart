import 'package:flutter/material.dart';
import 'package:platewise/data.dart';
import 'package:platewise/screens/add_friends.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  static const String routeName = "/home";

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AddFriendsScreen.routeName);
        },
        label: const Text("New Split"),
      ),
      body: ListView.builder(
        itemCount: savedSplits.length,
        itemBuilder: (BuildContext ctx, int index) {
          return InkWell(
            onTap: () {
              loadData(savedSplits[index]);
              Navigator.pushNamed(context, AddFriendsScreen.routeName);
            },
            child: Card(
              elevation: 0,
              child: SizedBox(height: 20, child: Text(savedSplits[index].name)),
            ),
          );
        },
      ),
    );
  }
}
