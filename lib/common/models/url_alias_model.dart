import 'package:equatable/equatable.dart';

class UrlAliasModel extends Equatable {
  const UrlAliasModel({
    required this.alias,
    required this.self,
    required this.short,
  });

  factory UrlAliasModel.fromJson(Map<String, dynamic> json) {
    final links = json['_links'] as Map<String, dynamic>;

    return UrlAliasModel(
      alias: json['alias'] as String,
      self: links['self'] as String,
      short: links['short'] as String,
    );
  }

  final String alias;
  final String self;
  final String short;

  Map<String, dynamic> toJson() => {
    'alias': alias,
    '_links': {'self': self, 'short': short},
  };

  @override
  List<Object?> get props => [alias, self, short];
}
