import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../common/constants/endpoints.dart';
import '../../../common/constants/messages.dart';
import '../../../common/models/url_alias_model.dart';

class HomeRepository {
  HomeRepository({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<UrlAliasModel> createAlias(String url) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse(aliasEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'url': url}),
          )
          .timeout(
            const Duration(seconds: 7),
            onTimeout: () => throw Exception(AppMessages.timeoutError),
          );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

        return UrlAliasModel.fromJson(jsonData);
      } else {
        throw Exception(
          AppMessages.urlAliasFailedToCreate(response.statusCode.toString()),
        );
      }
    } on SocketException {
      throw Exception(AppMessages.internetConnectionError);
    } on HttpException {
      throw Exception(AppMessages.httpError);
    } catch (e) {
      throw Exception(AppMessages.anErrorOccurred(e.toString()));
    }
  }
}
