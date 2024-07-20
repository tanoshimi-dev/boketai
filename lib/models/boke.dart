import 'boke_comment.dart';
import 'boke_rank.dart';

class Boke {
  final int id;
  final DateTime createdAt;
  final String prompt;
  // Assuming boke_comment and boke_rank are lists of comments and ranks respectively
  final List<BokeComment>? bokeComments;
  final BokeRank? bokeRank;

  Boke(
      {required this.id,
      required this.createdAt,
      required this.prompt,
      this.bokeComments,
      this.bokeRank});

  factory Boke.fromJson(Map<String, dynamic> json) {
    return Boke(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      prompt: json['prompt'],
      bokeComments: json['boke_comment'] != null
          ? List<BokeComment>.from(
              json['boke_comment'].map((x) => BokeComment.fromJson(x)))
          : null,
      bokeRank: json['boke_rank'] != null
          ? BokeRank.fromJson(json['boke_rank'])
          : null,
    );
  }
}
