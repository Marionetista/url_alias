import 'package:flutter_test/flutter_test.dart';
import 'package:url_alias/common/models/url_alias_model.dart';

void main() {
  test('When call fromJson should return a correct model', () {
    final alias = UrlAliasModel.fromJson(_aliasJson);

    expect(alias.alias, _alias);
    expect(alias.self, _self);
    expect(alias.short, _short);
  });

  test('When call toJson should return a correct JSON', () {
    final alias = UrlAliasModel.fromJson(_aliasJson);
    final json = alias.toJson();

    expect(json['alias'], _alias);
    expect(json['_links']['self'], _self);
    expect(json['_links']['short'], _short);
  });

  test('When compare two objects with same values, should return true', () {
    final alias1 = UrlAliasModel.fromJson(_aliasJson);
    final alias2 = UrlAliasModel.fromJson(_aliasJson);

    expect(alias1, alias2);
  });
}

final _alias = '123456789';
final _self = 'https://www.example.com';
final _short = 'https://short.ly/123456789';

final _aliasJson = {
  'alias': _alias,
  '_links': {'self': _self, 'short': _short},
};
