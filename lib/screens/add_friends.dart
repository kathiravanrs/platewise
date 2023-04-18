import 'package:flutter/material.dart';

import '../model/friend.dart';

class AddFriendsScreen extends StatefulWidget {
  AddFriendsScreen({Key? key}) : super(key: key);
  static const String routeName = "/add_friends";

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  List<Friend> friends = [
    Friend(name: 'Alice'),
    Friend(name: 'Bob'),
    Friend(name: 'Charlie'),
  ];

  void removeFriend(Friend friend) {
    setState(() {
      friends.remove(friend);
    });
  }

  void addFriend(String name) {
    setState(() {
      friends.add(Friend(name: name));
    });
  }

  Future<void> showAddFriendDialog(BuildContext context) async {
    String? friendName;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Friend'),
          content: TextField(
            onChanged: (value) {
              friendName = value;
            },
            decoration: const InputDecoration(
              labelText: 'Friend Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (friendName != null && friendName!.isNotEmpty) {
                  addFriend(friendName!);
                }
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friends'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: friends.length + 1,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            // Check if the current index is the last one
            if (index == friends.length) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: InkWell(
                  onTap: () {
                    showAddFriendDialog(context);
                  },
                  child: const Chip(
                    label: Text('+ Add Friend'),
                  ),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Chip(
                label: Text(friends[index].name),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () {
                  removeFriend(friends[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
