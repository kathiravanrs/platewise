class Friend {
  final String name;

  Friend({required this.name});

  // Convert a Friend instance into a Map
  Map<String, dynamic> toJson() => {
        'name': name,
      };

  @override
  String toString() {
    return 'Friend{name: $name}';
  } // Create a Friend instance from a Map

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      name: json['name'],
    );
  }
}
