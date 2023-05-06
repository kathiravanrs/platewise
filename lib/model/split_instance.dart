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
}
