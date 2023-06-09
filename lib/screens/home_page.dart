import 'package:flutter/material.dart';
import 'package:platewise/data.dart';
import 'package:platewise/screens/add_friends.dart';
import 'package:platewise/screens/review_screen.dart';

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
              Navigator.pushNamed(context, ReviewScreen.routeName);
            },
            onLongPress: () async {
              bool? delete = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirmation'),
                    content: const Text(
                        'Are you sure you want to delete this item?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                },
              );

              if (delete == true) {
                setState(() {
                  deleteData(savedSplits[index]);
                });
              }
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
