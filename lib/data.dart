import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'model/friend.dart';
import 'model/item.dart';
import 'model/split_instance.dart';

List<Friend> friends = [];
List<Item> items = [];
List<SplitInstance> savedInstances = [];

Map<Item, Set<Friend>> itemFriendMap = {};
Map<Friend, double> friendPreTaxSplit = {};
Map<Friend, double> friendTaxSplit = {};

double preTaxAmount = 0;
double totalFees = 0;
double totalAmountPaid = 0;

Future<void> saveSplitInstances(List<SplitInstance> instances) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String> jsonList =
      instances.map((instance) => json.encode(instance.toJson())).toList();
  await prefs.setStringList('split_instances', jsonList);
}

Future<List<SplitInstance>> loadSplitInstances() async {
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
