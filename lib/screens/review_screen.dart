import 'package:flutter/material.dart';
import 'package:platewise/data.dart';
import 'package:platewise/model/friend.dart';
import '../model/item.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);
  static const String routeName = "/add_taxes";

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
    return Scaffold(
      appBar: AppBar(title: const Text("Review")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: buildFriendListView(),
            ),
            Text(selectedFriend.name),
            Expanded(
              child: buildItemListForFriend(),
            )
          ],
        ),
      ),
    );
  }

  ListView buildItemListForFriend() {
    return ListView.builder(
      itemCount: itemListForFriend.length,
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
                        itemListForFriend[index].name,
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        "Total: \$${itemListForFriend[index].getTotalAfterTax().toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 40,
                        child: buildChipListForItem(index),
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "\$${(itemListForFriend[index].getTotalAfterTax() / (itemFriendMap[itemListForFriend[index]]?.toList().length ?? 1)).toStringAsFixed(2)}",
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

  ListView buildFriendListView() {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (BuildContext context, int index) {
        Friend friend = friends[index];
        return InkWell(
          onTap: () {
            setState(() {
              selectedFriend = friends[index];
              generateList();
            });
          },
          child: Card(
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
                          "Pre Tax: ${friendPreTaxSplit[friend]!.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Fees: ${friendTaxSplit[friend]!.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "\$${(friendPreTaxSplit[friend]! + friendTaxSplit[friend]!).toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ListView buildChipListForItem(int index) {
    return ListView.builder(
      itemCount: itemFriendMap[itemListForFriend[index]]?.toList().length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext ctx, int i) {
        List<Friend> l =
            itemFriendMap[itemListForFriend[index]]?.toList() ?? [];
        return Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Chip(
              label: Text(l[i].name, style: const TextStyle(fontSize: 10))),
        );
      },
    );
  }
}
