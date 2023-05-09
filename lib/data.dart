import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'model/friend.dart';
import 'model/item.dart';
import 'model/split_instance.dart';

List<Friend> friends = [
  Friend(name: 'Alice'),
  Friend(name: 'Bob'),
  Friend(name: 'Charlie'),
];

List<Item> items = [
  Item("Pizza", 30, 1),
  Item("Burger", 20, 1),
  Item("Lasagna", 10, 1),
];
String name = "";
List<SplitInstance> savedSplits = [];

Map<Item, Set<Friend>> itemFriendMap = {};
Map<Friend, double> friendPreTaxSplit = {};
Map<Friend, double> friendTaxSplit = {};

double preTaxAmount = 0;
double totalFees = 0;
double totalAmountPaid = 0;

void loadData(SplitInstance splitInstance) {
  print(splitInstance.itemFriendMap);
  name = splitInstance.name;
  friends = splitInstance.friends;
  items = splitInstance.items;
  itemFriendMap = splitInstance.itemFriendMap;
  friendTaxSplit = splitInstance.friendTaxSplit;
  friendPreTaxSplit = splitInstance.friendPreTaxSplit;
  preTaxAmount = splitInstance.preTaxAmount;
  totalFees = splitInstance.totalFees;
  totalAmountPaid = splitInstance.totalAmountPaid;
}

Future<void> saveSplitInstancesToPreferences(
    List<SplitInstance> instances) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> jsonList =
      instances.map((instance) => json.encode(instance.toJson())).toList();
  await prefs.setStringList('split_instances', jsonList);
}

Future<List<SplitInstance>> loadSplitInstancesFromPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String>? jsonList = prefs.getStringList('split_instances');
  if (jsonList == null) {
    return [];
  } else {
    return jsonList
        .map((jsonString) => SplitInstance.fromJson(json.decode(jsonString)))
        .toList();
  }
}
