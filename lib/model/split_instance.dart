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
            json.encode(item.toJson()), // Encode Item object to a JSON string
            friends
                .map((friend) => friend.toJson())
                .toList(), // Change from Set to List for JSON compatibility
          );
        }),
        'friendPreTaxSplit': friendPreTaxSplit.map((friend, value) {
          return MapEntry(json.encode(friend.toJson()),
              value); // Encode Friend object to a JSON string
        }),
        'friendTaxSplit': friendTaxSplit.map((friend, value) {
          return MapEntry(json.encode(friend.toJson()),
              value); // Encode Friend object to a JSON string
        }),
        'preTaxAmount': preTaxAmount,
        'totalFees': totalFees,
        'totalAmountPaid': totalAmountPaid,
      };

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
          Item.fromJson(
              jsonDecode(itemJson)), // Decode Item object from a JSON string
          (friendsJson as List<dynamic>)
              .map((friendJson) => Friend.fromJson(friendJson))
              .toSet(), // Convert back to Set
        );
      }),
      (json['friendPreTaxSplit'] as Map<String, dynamic>)
          .map((friendJson, value) {
        return MapEntry(Friend.fromJson(jsonDecode(friendJson)),
            value); // Decode Friend object from a JSON string
      }),
      (json['friendTaxSplit'] as Map<String, dynamic>).map((friendJson, value) {
        return MapEntry(Friend.fromJson(jsonDecode(friendJson)),
            value); // Decode Friend object from a JSON string
      }),
      json['preTaxAmount'],
      json['totalFees'],
      json['totalAmountPaid'],
    );
  }
}
