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
  List<Item> itemListForSelectedFriend = [];

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
    itemListForSelectedFriend.clear();
    for (Item item in itemFriendMap.keys) {
      if (itemFriendMap[item]?.contains(selectedFriend) ?? false) {
        itemListForSelectedFriend.add(item);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    calculateSplit();
    return Scaffold(
      appBar: AppBar(title: const Text("Review")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text("Selected Friend ${selectedFriend.name}"),
                Expanded(
                  child: ListView.builder(
                    itemCount: itemListForSelectedFriend.length,
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
                                      itemListForSelectedFriend[index].name,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "Total: \$${itemListForSelectedFriend[index].getTotalAfterTax().toStringAsFixed(2)}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: ListView.builder(
                                          itemCount: itemFriendMap[
                                                  itemListForSelectedFriend[
                                                      index]]
                                              ?.toList()
                                              .length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder:
                                              (BuildContext ctx, int i) {
                                            List<Friend> l = itemFriendMap[
                                                        itemListForSelectedFriend[
                                                            index]]
                                                    ?.toList() ??
                                                [];
                                            return Chip(label: Text(l[i].name));
                                          }),
                                    )
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "\$${(itemListForSelectedFriend[index].getTotalAfterTax() / (itemFriendMap[itemListForSelectedFriend[index]]?.toList().length ?? 1)).toStringAsFixed(2)}",
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
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
