class BokeRank {
  final int id;
  final DateTime createdAt;
  final int? rank;
  final int? favCount;

  BokeRank(
      {required this.id, required this.createdAt, this.rank, this.favCount});

  factory BokeRank.fromJson(Map<String, dynamic> json) {
    return BokeRank(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        rank: json['rank'],
        favCount: json['fav_count']);
  }
}
