class BokeUser {
  final String id;
  final DateTime createdAt;
  final String name;

  BokeUser({required this.id, required this.createdAt, required this.name});

  factory BokeUser.fromJson(Map<String, dynamic> json) {
    print('BOKE USER CONVERT');
    print(json);

    // return switch (json) {
    //   {
    //     'id': String id,
    //     'created_at': DateTime createdAt,
    //     'name': String name,
    //   } =>
    //     BokeUser(
    //       id: id,
    //       createdAt: createdAt,
    //       name: name,
    //     ),
    //   _ => throw const FormatException('Failed to load Menu.'),
    // };

    return BokeUser(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        name: json['name']);
  }
}
