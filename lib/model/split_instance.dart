import 'dart:convert';

import 'friend.dart';
import 'item.dart';

class SplitInstance {
  List<Friend> friends;
  List<Item> items;

  Map<Item, Set<Friend>> itemFriendMap;
  Map<Friend, double> friendPreTaxSplit;
  Map<Friend, double> friendTaxSplit;

  double preTaxAmount;
  double totalFees;
  double totalAmountPaid;

  SplitInstance.name(
    this.friends,
    this.items,
    this.itemFriendMap,
    this.friendPreTaxSplit,
    this.friendTaxSplit,
    this.preTaxAmount,
    this.totalFees,
    this.totalAmountPaid,
  );

  // Convert a SplitInstance instance into a Map
  Map<String, dynamic> toJson() => {
        'friends': friends.map((friend) => friend.toJson()).toList(),
        'items': items.map((item) => item.toJson()).toList(),
        'itemFriendMap': itemFriendMap.map((item, friends) {
          return MapEntry(
            item.toJson(),
            friends.map((friend) => friend.toJson()).toSet(),
          );
        }),
        'friendPreTaxSplit': friendPreTaxSplit.map((friend, value) {
          return MapEntry(friend.toJson(), value);
        }),
        'friendTaxSplit': friendTaxSplit.map((friend, value) {
          return MapEntry(friend.toJson(), value);
        }),
        'preTaxAmount': preTaxAmount,
        'totalFees': totalFees,
        'totalAmountPaid': totalAmountPaid,
      };

  // Create a SplitInstance instance from a Map
  factory SplitInstance.fromJson(Map<String, dynamic> json) {
    return SplitInstance.name(
      (json['friends'] as List<dynamic>)
          .map((friendJson) => Friend.fromJson(friendJson))
          .toList(),
      (json['items'] as List<dynamic>)
          .map((itemJson) => Item.fromJson(itemJson))
          .toList(),
      (json['itemFriendMap'] as Map<String, dynamic>)
          .map((itemJson, friendsJson) {
        return MapEntry(
          Item.fromJson(jsonDecode(itemJson)),
          (friendsJson as List<dynamic>)
              .map((friendJson) => Friend.fromJson(friendJson))
              .toSet(),
        );
      }),
      (json['friendPreTaxSplit'] as Map<String, dynamic>)
          .map((friendJson, value) {
        return MapEntry(Friend.fromJson(jsonDecode(friendJson)), value);
      }),
      (json['friendTaxSplit'] as Map<String, dynamic>).map((friendJson, value) {
        return MapEntry(Friend.fromJson(jsonDecode(friendJson)), value);
      }),
      json['preTaxAmount'],
      json['totalFees'],
      json['totalAmountPaid'],
    );
  }
}
