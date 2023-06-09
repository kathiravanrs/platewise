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
  name = splitInstance.name;
  friends = splitInstance.friends;
  items = splitInstance.items;
  friendTaxSplit = splitInstance.friendTaxSplit;
  friendPreTaxSplit = splitInstance.friendPreTaxSplit;
  preTaxAmount = splitInstance.preTaxAmount;
  totalFees = splitInstance.totalFees;
  totalAmountPaid = splitInstance.totalAmountPaid;
  itemFriendMap.clear();

  for (Item i in splitInstance.itemFriendMap.keys) {
    Item item = items.firstWhere((element) => element.name == i.name);
    itemFriendMap[item] = {};
    for (Friend f in splitInstance.itemFriendMap[i]!) {
      itemFriendMap[item]
          ?.add(friends.firstWhere((element) => element.name == f.name));
    }
  }
}

Future<void> deleteData(SplitInstance splitInstance) async {
  savedSplits.remove(splitInstance);
  await saveSplitInstancesToPreferences(savedSplits);
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
  }
  return jsonList
      .map((jsonString) => SplitInstance.fromJson(json.decode(jsonString)))
      .toList();
}
