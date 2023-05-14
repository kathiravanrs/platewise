import 'package:flutter/material.dart';
import 'package:platewise/model/item.dart';
import 'package:platewise/screens/review_screen.dart';

import '../data.dart';
import '../model/friend.dart';

class AssignItemsScreen extends StatefulWidget {
  static const String routeName = "/assign_items";

  const AssignItemsScreen({super.key});

  @override
  State<AssignItemsScreen> createState() => _AssignItemsScreenState();
}

class _AssignItemsScreenState extends State<AssignItemsScreen> {
  Item? selectedItem;

  void selectItem(Item item) {
    setState(() {
      selectedItem = item;
    });
  }

  void toggleFriendSelection(Friend friend) {
    setState(() {
      if (selectedItem != null) {
        if (!itemFriendMap.containsKey(selectedItem!)) {
          itemFriendMap[selectedItem!] = <Friend>{};
        }

        if (itemFriendMap[selectedItem!]!.contains(friend)) {
          itemFriendMap[selectedItem!]!.remove(friend);
        } else {
          itemFriendMap[selectedItem!]!.add(friend);
        }
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      children: items.map((item) {
                        return ChoiceChip(
                          label: Text(item.name),
                          selected: selectedItem == item,
                          onSelected: (bool selected) {
                            selectItem(item);
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8,
                      children: friends.map((friend) {
                        bool selected = false;
                        if (selectedItem != null &&
                            itemFriendMap.containsKey(selectedItem!)) {
                          selected =
                              itemFriendMap[selectedItem!]!.contains(friend);
                        }
                        return FilterChip(
                            label: Text(friend.name),
                            selected: selected,
                            onSelected: (bool selected) {
                              toggleFriendSelection(friend);
                            });
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, ReviewScreen.routeName);
          },
          label: const Text("Continue")),
    );
  }
}
