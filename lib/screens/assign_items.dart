import 'package:flutter/material.dart';
import 'package:platewise/model/item.dart';

import '../model/friend.dart';

class AssignItemsScreen extends StatefulWidget {
  final List<Item> items;
  final List<Friend> friends;
  static const String routeName = "/assign_items";

  const AssignItemsScreen(
      {super.key, required this.items, required this.friends});

  @override
  _AssignItemsScreenState createState() => _AssignItemsScreenState();
}

class _AssignItemsScreenState extends State<AssignItemsScreen> {
  Item? selectedItem;
  Set<Friend> selectedFriends = <Friend>{};

  void selectItem(Item item) {
    setState(() {
      selectedItem = item;
    });
  }

  void toggleFriendSelection(Friend friend) {
    setState(() {
      if (selectedFriends.contains(friend)) {
        selectedFriends.remove(friend);
      } else {
        selectedFriends.add(friend);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Assign Items')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(child: Text("Pick An Item")),
                        Wrap(
                          spacing: 8,
                          children: widget.items.map((item) {
                            return ChoiceChip(
                              label: Text(item.name),
                              selected: selectedItem == item,
                              onSelected: (bool selected) {
                                selectItem(item);
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                            child: Text("Select People For Each Item")),
                        Wrap(
                          spacing: 8,
                          children: widget.friends.map((friend) {
                            return FilterChip(
                                label: Text(friend.name),
                                selected: selectedFriends.contains(friend),
                                onSelected: (bool selected) {
                                  toggleFriendSelection(friend);
                                });
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
