import 'boke_user.dart';

class BokeComment {
  final int id;
  final int seq;
  final DateTime createdAt;
  final String comment;
  final BokeUser? bokeUser;

  BokeComment(
      {required this.id,
      required this.seq,
      required this.createdAt,
      required this.comment,
      this.bokeUser});

  factory BokeComment.fromJson(Map<String, dynamic> json) {
    return BokeComment(
      id: json['id'],
      seq: json['seq'],
      createdAt: DateTime.parse(json['created_at']),
      comment: json['comment'],
      // bokeUser: json['boke_user'].map((x) => BokeUser.fromJson(x)),
      bokeUser: BokeUser.fromJson(json['boke_user']),
    );
  }
}
