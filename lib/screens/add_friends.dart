import 'package:flutter/material.dart';
import 'package:platewise/screens/add_items.dart';

import '../data.dart';
import '../model/friend.dart';

class AddFriendsScreen extends StatefulWidget {
  const AddFriendsScreen({Key? key}) : super(key: key);
  static const String routeName = "/add_friends";

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
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

  List<Widget> buildFriendChips() {
    List<Widget> friendChips = [];

    for (Friend friend in friends) {
      friendChips.add(Chip(
        label: Text(friend.name.toUpperCase()),
        deleteIcon: const Icon(
          Icons.close,
          size: 16,
        ),
        onDeleted: () {
          removeFriend(friend);
        },
      ));
    }

    Widget addFriendChip = InkWell(
      onTap: () {
        showAddFriendDialog(context);
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Chip(
          label: Text('+ Add Friend'),
        ),
      ),
    );

    friendChips.add(addFriendChip);
    return friendChips;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Friends'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0, // Space between chips horizontally
          runSpacing: 8.0, // Space between chips vertically
          children: buildFriendChips(),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 32.0, right: 8),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, AddItemsScreen.routeName);
          },
          label: const Text("Add Bill Items"),
        ),
      ),
    );
  }
}
