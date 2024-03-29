import 'package:flutter/material.dart';
import 'package:platewise/data.dart';
import 'package:platewise/model/friend.dart';
import 'package:platewise/model/split_instance.dart';
import 'package:platewise/screens/home_page.dart';
import '../model/item.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);
  static const String routeName = "/review_screen";

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  Friend selectedFriend = friends[0];
  List<Item> itemListForFriend = [];

  void calculateSplit() {
    friendPreTaxSplit.clear();
    for (Item item in itemFriendMap.keys) {
      Set<Friend> friends = itemFriendMap[item] ?? {};
      for (Friend f in friends) {
        friendPreTaxSplit[f] = (friendPreTaxSplit[f] ?? 0) +
            (item.price * item.quantity) / friends.length.toDouble();
      }
    }
    calculateTotal();
  }

  void calculateTotal() {
    for (Friend f in friendPreTaxSplit.keys) {
      double amt = friendPreTaxSplit[f] ?? 0;
      double tax = totalFees * (amt.toDouble() / preTaxAmount.toDouble());
      friendTaxSplit[f] = tax;
    }
  }

  void generateList() {
    itemListForFriend.clear();
    for (Item item in itemFriendMap.keys) {
      if (itemFriendMap[item]?.contains(selectedFriend) ?? false) {
        itemListForFriend.add(item);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    calculateSplit();
    generateList();
    // print(itemFriendMap);
    print(itemListForFriend);

    return Scaffold(
      appBar: AppBar(title: const Text("Review")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            friendsList(),
            tabView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.save),
        onPressed: () async {
          String? splitName = await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              String input = "";
              return AlertDialog(
                title: const Text('Save split as ?'),
                content: TextFormField(
                  onChanged: (value) => input = value,
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(input);
                    },
                  ),
                ],
              );
            },
          );

          if (splitName != null) {
            SplitInstance splitInstance = SplitInstance.name(
              splitName,
              friends,
              items,
              itemFriendMap,
              friendPreTaxSplit,
              friendTaxSplit,
              preTaxAmount,
              totalFees,
              totalAmountPaid,
            );
            savedSplits.add(splitInstance);
            saveSplitInstancesToPreferences(savedSplits).then(
                (value) => Navigator.pushNamed(context, MyHomePage.routeName));
          }
        },
      ),
    );
  }

  Widget friendsList() {
    // print(friendPreTaxSplit);
    return Expanded(
      child: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (BuildContext context, int index) {
          Friend friend = friends[index];
          // print(friend);
          return InkWell(
            onTap: () {
              setState(() {
                selectedFriend = friends[index];
                generateList();
              });
            },
            child: friendTotalCard(friend),
          );
        },
      ),
    );
  }

  Card friendTotalCard(Friend friend) {
    double preTax = friendPreTaxSplit[friend] ?? 0;
    double tax = friendTaxSplit[friend] ?? 0;
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        side: BorderSide(),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Pre Tax: ${preTax.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    "Fees: ${tax.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "\$${(tax + preTax).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemWidgetListForFriend(Friend friend) {
    List<Item> itemList = [];
    for (Item item in itemFriendMap.keys) {
      if (itemFriendMap[item]?.contains(friend) ?? false) {
        itemList.add(item);
      }
    }
    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (BuildContext ctx, int index) {
        return Card(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemList[index].name,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Total: \$${itemList[index].getTotalAfterTax().toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 20,
                        child: buildChipListForItem(itemList[index]),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "\$${(itemList[index].getTotalAfterTax() / (itemFriendMap[itemList[index]]!.toList().length ?? 1)).toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget tabView() {
    return Expanded(
      child: DefaultTabController(
        length: friends.length,
        child: Column(
          children: [
            TabBar(
              isScrollable: true,
              tabs: friends.map((Friend f) => Tab(text: f.name)).toList(),
            ),
            Expanded(
              child: TabBarView(
                children: friends.map((Friend f) {
                  return itemWidgetListForFriend(f);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildChipListForItem(Item item) {
    return ListView.builder(
      itemCount: itemFriendMap[item]?.toList().length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext ctx, int i) {
        List<Friend> l = itemFriendMap[item]?.toList() ?? [];
        return Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).hoverColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 0.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(l[i].name, style: const TextStyle(fontSize: 10)),
            ),
          ),
        );
      },
    );
  }
}
