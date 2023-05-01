import 'model/friend.dart';
import 'model/item.dart';

List<Friend> friends = [
  Friend(name: 'Alice'),
  Friend(name: 'Bob'),
  Friend(name: 'Charlie'),
];

List<Item> items = [
  Item("ABC", 30, 1),
  Item("IJK", 20, 1),
  Item("XYZ", 10, 1),
];

Map<Item, Set<Friend>> itemFriendMap = {};
Map<Friend, double> friendPreTaxSplit = {};
Map<Friend, double> friendTaxSplit = {};

double preTaxAmount = 0;
double totalFees = 0;
double totalAmountPaid = 0;
