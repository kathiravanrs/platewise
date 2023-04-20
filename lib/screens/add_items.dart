import 'package:flutter/material.dart';

import '../model/item.dart';

class AddItemsScreen extends StatefulWidget {
  const AddItemsScreen({Key? key}) : super(key: key);
  static const String routeName = "/add_items";

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  List<Item> items = [];

  void removeItem(Item item) {
    setState(() {
      items.remove(item);
    });
  }

  void addItem(String name, double price, double quantity) {
    setState(() {
      items.add(Item(name, price, quantity));
    });
  }

  Future<void> showAddItemDialog(BuildContext context) async {
    String? itemName;
    double price = 0;
    double quantity = 0;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    itemName = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    price = value as double;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                Row(
                  children: [
                    FilledButton.tonal(
                        onPressed: () {
                          setState(() {
                            quantity--;
                          });
                        },
                        child: const Icon(Icons.remove)),
                    Text(
                      "$quantity",
                      style: TextStyle(fontSize: 48),
                    ),
                    FilledButton.tonal(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        child: const Icon(Icons.add)),
                  ],
                )
              ],
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
                  if (itemName != null && itemName!.isNotEmpty) {
                    // addItem(itemName!);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text('Add'),
              ),
            ],
          );
        });
      },
    );
  }

  List<Widget> buildItemChips() {
    List<Widget> itemChips = [];

    for (Item item in items) {
      itemChips.add(Chip(
        label: Text(item.name.toUpperCase()),
        deleteIcon: const Icon(
          Icons.close,
          size: 16,
        ),
        onDeleted: () {
          removeItem(item);
        },
      ));
    }

    Widget addItemChip = InkWell(
      onTap: () {
        showAddItemDialog(context);
      },
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Chip(
          label: Text('+ Add Item'),
        ),
      ),
    );

    itemChips.add(addItemChip);
    return itemChips;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0, // Space between chips horizontally
          runSpacing: 8.0, // Space between chips vertically
          children: buildItemChips(),
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
