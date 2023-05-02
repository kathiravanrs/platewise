import 'package:platewise/data.dart';

class Item {
  String name;
  double price;
  int quantity;

  Item(this.name, this.price, this.quantity);

  double getTotal() {
    return quantity * price;
  }

  double getTotalAfterTax() {
    return getTotal() * (1 + totalFees / preTaxAmount);
  }
}
