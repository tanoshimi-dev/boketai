class Menu {
  final int menuId;
  final String name;
  final String description;
  final int price;

  const Menu({
    required this.menuId,
    required this.name,
    required this.description,
    required this.price,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'menuId': int menuId,
        'name': String name,
        'description': String description,
        'price': int price,
      } =>
        Menu(
          menuId: menuId,
          name: name,
          description: description,
          price: price,
        ),
      _ => throw const FormatException('Failed to load Menu.'),
    };
  }

  get id => null;
}
