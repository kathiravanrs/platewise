import 'package:flutter/material.dart';
import 'package:platewise/screens/assign_items.dart';
import '../data.dart';
import '../model/item.dart';

class AddItemsScreen extends StatefulWidget {
  const AddItemsScreen({Key? key}) : super(key: key);
  static const String routeName = "/add_items";

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  void deleteItem(Item item) {
    setState(() {
      items.remove(item);
    });
  }

  void updateItem(Item item, String name, double price, int quantity) {
    setState(() {
      item.name = name;
      item.price = price;
      item.quantity = quantity;
    });
  }

  void addItem(String name, double price, int quantity) {
    setState(() {
      items.add(Item(name, price, quantity));
    });
  }

  double getPreTaxTotal() {
    double preTaxTotal = 0;
    for (Item item in items) {
      preTaxTotal += item.price * item.quantity;
    }
    setState(() {
      preTaxAmount = preTaxTotal;
      totalAmountPaid = preTaxAmount + totalFees;
    });
    return preTaxTotal;
  }

  Future<void> showAddItemDialog(BuildContext context) async {
    String? itemName;
    double price = 0;
    int quantity = 1;

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
                    price = double.parse(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (quantity < 2)
                      FilledButton.tonal(
                        onPressed: () {},
                        child: const Icon(Icons.remove),
                      ),
                    if (quantity >= 2)
                      FilledButton(
                          onPressed: () {
                            setState(() {
                              quantity--;
                            });
                          },
                          child: const Icon(Icons.remove)),
                    Text(
                      "$quantity",
                      style: const TextStyle(fontSize: 32),
                    ),
                    FilledButton(
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
                    addItem(itemName!, price, quantity);
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

  Future<void> showUpdateItemDialog(BuildContext context, Item item) async {
    String itemName = item.name;
    double price = item.price;
    int quantity = item.quantity;

    TextEditingController itemNameController =
        TextEditingController(text: itemName);
    TextEditingController priceController =
        TextEditingController(text: price.toString());

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Update Item'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: itemNameController,
                  onChanged: (value) {
                    itemName = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: priceController,
                  onChanged: (value) {
                    price = double.parse(value);
                  },
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (quantity < 2)
                      FilledButton.tonal(
                        onPressed: () {},
                        child: const Icon(Icons.remove),
                      ),
                    if (quantity >= 2)
                      FilledButton(
                          onPressed: () {
                            setState(() {
                              quantity--;
                            });
                          },
                          child: const Icon(Icons.remove)),
                    Text(
                      "$quantity",
                      style: const TextStyle(fontSize: 32),
                    ),
                    FilledButton(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      deleteItem(item);
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red, // Set the color to red
                    ),
                    child: const Text('Delete'),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          if (itemName.isNotEmpty) {
                            updateItem(item, itemNameController.text,
                                double.parse(priceController.text), quantity);
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  List<Widget> buildItemChips() {
    List<Widget> itemList = [];

    for (Item item in items) {
      itemList.add(
        InkWell(
          onTap: () {
            showUpdateItemDialog(context, item);
          },
          child: Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
              side: BorderSide(),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: SizedBox(
              height: 80,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 20, // Adjust the font size as needed
                            ),
                          ),
                          Text(
                            "Quantity: ${item.quantity}",
                            style: const TextStyle(
                              fontSize: 14, // Adjust the font size as needed
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "\$${item.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18, // Adjust the font size as needed
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget addItemChip = InkWell(
      onTap: () {
        showAddItemDialog(context);
      },
      child: const Center(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: SizedBox(
            // width: 300,
            height: 80,
            child: Center(child: Text('+ Add Item')),
          ),
        ),
      ),
    );

    itemList.add(addItemChip);
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: ListView(
                children: buildItemChips(),
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pre-Tax Total: ',
                      style: TextStyle(fontSize: 24),
                    ),
                    const Spacer(),
                    const Text(
                      '\$',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        getPreTaxTotal().toStringAsFixed(2),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Taxes & Fees:',
                      style: TextStyle(fontSize: 24),
                    ),
                    const Spacer(),
                    const Text(
                      '\$',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                        totalFees.toStringAsFixed(2),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount Paid:',
                      style: TextStyle(fontSize: 24),
                    ),
                    const Spacer(),
                    const Text(
                      '\$',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                          decoration: InputDecoration(
                              hintText: preTaxAmount.toString()),
                          style: const TextStyle(fontSize: 24),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              totalFees = double.parse(value) - preTaxAmount;
                            });
                          }),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(context, AssignItemsScreen.routeName);
                },
                label: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
