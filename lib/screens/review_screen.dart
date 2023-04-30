import 'package:flutter/material.dart';
import 'package:platewise/data.dart';
import 'package:platewise/model/friend.dart';

import '../model/item.dart';

//
// class ReviewScreen extends StatefulWidget {
//   const ReviewScreen({Key? key}) : super(key: key);
//   static const String routeName = "/add_taxes";
//
//   @override
//   State<ReviewScreen> createState() => _ReviewScreenState();
// }
//
// class _ReviewScreenState extends State<ReviewScreen> {
//   void calculateSplit() {
//     for (Item item in itemFriendMap.keys) {
//       Set<Friend> friends = itemFriendMap[item] ?? {};
//       for (Friend f in friends) {
//         friendSplitMap[f] = friendSplitMap[f] ??
//             0 + (item.price * item.quantity) / friends.length.toDouble();
//       }
//     }
//     calculateTotal();
//   }
//
//   void calculateTotal() {
//     for (Friend f in friendSplitMap.keys) {
//       double amt = friendSplitMap[f] ?? 0;
//       double tax = totalFees * (amt.toDouble() / preTaxAmount.toDouble());
//       friendTotal[f] = amt + tax;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     calculateSplit();
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Review")),
//       body: Column(children: []),
//     );
//   }
// }
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);
  static const String routeName = "/add_taxes";

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  Friend? _selectedFriend;

  void calculateSplit() {
    for (Item item in itemFriendMap.keys) {
      Set<Friend> friends = itemFriendMap[item] ?? {};
      for (Friend f in friends) {
        friendSplitMap[f] = friendSplitMap[f] ??
            0 + (item.price * item.quantity) / friends.length.toDouble();
      }
    }
    calculateTotal();
  }

  void calculateTotal() {
    for (Friend f in friendSplitMap.keys) {
      double amt = friendSplitMap[f] ?? 0;
      double tax = totalFees * (amt.toDouble() / preTaxAmount.toDouble());
      friendTotal[f] = amt + tax;
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
            flex: 1,
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (BuildContext context, int index) {
                Friend friend = friends[index];
                return ListTile(
                  title: Text(friend.name),
                  subtitle: Text(
                      '\$${friendTotal[friend]?.toStringAsFixed(2) ?? '0.00'}'),
                  onTap: () {
                    setState(() {
                      _selectedFriend = friend;
                    });
                  },
                  selected: _selectedFriend == friend,
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            flex: 2,
            child: _selectedFriend == null
                ? Center(child: const Text('Select a friend to view details'))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Items assigned to ${_selectedFriend!.name}:',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, int index) {
                            Item item = items[index];
                            Set<Friend> itemFriends = itemFriendMap[item] ?? {};

                            if (itemFriends.contains(_selectedFriend)) {
                              return ListTile(
                                title: Text(item.name),
                                subtitle: Text(
                                    '\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Pre-Tax Amount: \$${friendSplitMap[_selectedFriend]?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Total Amount: \$${friendTotal[_selectedFriend]?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
