import 'package:platewise/data.dart';

class Item {
  String name;
  double price;
  int quantity;

  Item(this.name, this.price, this.quantity);

  double getTotal() {
    return quantity * price;
  }

  @override
  String toString() {
    return 'Item{name: $name, price: $price, quantity: $quantity}';
  }

  double getTotalAfterTax() {
    return getTotal() * (1 + totalFees / preTaxAmount);
  }

  // Convert an Item instance into a Map
  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'quantity': quantity,
      };

  // Create an Item instance from a Map
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      json['name'],
      json['price'],
      json['quantity'],
    );
  }
}
