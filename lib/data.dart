import 'model/friend.dart';
import 'model/item.dart';

List<Friend> friends = [];

List<Item> items = [];

Map<Item, Set<Friend>> itemFriendMap = {};
Map<Friend, double> friendPreTaxSplit = {};
Map<Friend, double> friendTaxSplit = {};

double preTaxAmount = 0;
double totalFees = 0;
double totalAmountPaid = 0;
