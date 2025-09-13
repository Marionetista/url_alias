import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../common/constants/endpoints.dart';
import '../../../common/models/url_alias_model.dart';

class HomeRepository {
  Future<UrlAliasModel> createAlias(String url) async {
    try {
      final response = await http.post(
        Uri.parse(aliasEndpoint),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        return UrlAliasModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to create alias: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('HTTP error occurred');
    } catch (e) {
      throw Exception('An error occurred: $e');
    }
  }
}
