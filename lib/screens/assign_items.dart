import 'package:flutter/material.dart';
import 'package:flutter_titled_container/flutter_titled_container.dart';
import 'package:platewise/model/item.dart';

import '../model/friend.dart';

class AssignItemsScreen extends StatefulWidget {
  final List<Item> items;
  final List<Friend> friends;
  static const String routeName = "/assign_items";

  const AssignItemsScreen(
      {super.key, required this.items, required this.friends});

  @override
  State<AssignItemsScreen> createState() => _AssignItemsScreenState();
}

class _AssignItemsScreenState extends State<AssignItemsScreen> {
  Item? selectedItem;
  Map<Item, Set<Friend>> itemFriendMap = {};

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
              child: TitledContainer(
                title: 'Pick Item',
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      child: Wrap(
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
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TitledContainer(
                title: 'Select Friends',
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      child: Wrap(
                        spacing: 8,
                        children: widget.friends.map((friend) {
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
            ),
          ],
        ),
      ),
    );
  }
}