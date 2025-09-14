import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

import 'package:url_alias/common/constants/endpoints.dart';
import 'package:url_alias/common/constants/messages.dart';
import 'package:url_alias/features/home/data/home_repository.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  const responseBody = {
    'alias': '123456789',
    '_links': {
      'self': 'https://www.example.com',
      'short': 'https://short.ly/123456789',
    },
  };

  group('HomeRepository Tests', () {
    late HomeRepository repository;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      repository = HomeRepository(httpClient: mockHttpClient);
    });

    test('When call createAlias with valid URL '
        'should return the correct UrlAliasModel', () async {
      // Arrange
      const url = 'https://www.example.com';

      when(
        () => mockHttpClient.post(
          Uri.parse(aliasEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'url': url}),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(responseBody), 201));

      // Act
      final result = await repository.createAlias(url);

      // Assert
      expect(result.alias, '123456789');
      expect(result.self, 'https://www.example.com');
      expect(result.short, 'https://short.ly/123456789');
    });

    test('When call createAlias with invalid response '
        'should throw Exception', () async {
      // Arrange
      const url = 'https://www.example.com';

      when(
        () => mockHttpClient.post(
          Uri.parse(aliasEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'url': url}),
        ),
      ).thenAnswer((_) async => http.Response('Error', 400));

      // Act & Assert
      expect(
        () => repository.createAlias(url),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Failed to create URL alias'),
          ),
        ),
      );
    });

    test('When call createAlias with network error '
        'should throw Exception', () async {
      // Arrange
      const url = 'https://www.example.com';

      when(
        () => mockHttpClient.post(
          Uri.parse(aliasEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'url': url}),
        ),
      ).thenThrow(SocketException('No internet'));

      // Act & Assert
      expect(
        () => repository.createAlias(url),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(AppMessages.internetConnectionError),
          ),
        ),
      );
    });

    test('When call createAlias with status 200 '
        'should return UrlAliasModel', () async {
      // Arrange
      const url = 'https://www.example.com';

      when(
        () => mockHttpClient.post(
          Uri.parse(aliasEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'url': url}),
        ),
      ).thenAnswer((_) async => http.Response(jsonEncode(responseBody), 200));

      // Act
      final result = await repository.createAlias(url);

      // Assert
      expect(result.alias, '123456789');
      expect(result.self, 'https://www.example.com');
      expect(result.short, 'https://short.ly/123456789');
    });

    test('When call createAlias with HttpException '
        'should throw Exception', () async {
      // Arrange
      const url = 'https://www.example.com';

      when(
        () => mockHttpClient.post(
          Uri.parse(aliasEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'url': url}),
        ),
      ).thenThrow(HttpException('HTTP error'));

      // Act & Assert
      expect(
        () => repository.createAlias(url),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(AppMessages.httpError),
          ),
        ),
      );
    });

    test('When call createAlias with generic exception '
        'should throw Exception', () async {
      // Arrange
      const url = 'https://www.example.com';

      when(
        () => mockHttpClient.post(
          Uri.parse(aliasEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'url': url}),
        ),
      ).thenThrow(Exception('Generic error'));

      // Act & Assert
      expect(
        () => repository.createAlias(url),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(AppMessages.anErrorOccurred('Exception: Generic error')),
          ),
        ),
      );
    });

    test('When HomeRepository is created without httpClient '
        'should use default', () {
      // Act
      final repository = HomeRepository();

      // Assert
      expect(repository, isA<HomeRepository>());
    });

    test('When call createAlias with timeout '
        'should throw timeout Exception', () async {
      // Arrange
      const url = 'https://www.example.com';

      when(
        () => mockHttpClient.post(
          Uri.parse(aliasEndpoint),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'url': url}),
        ),
      ).thenAnswer((_) async {
        await Future.delayed(const Duration(seconds: 8));
        return http.Response(jsonEncode(responseBody), 201);
      });

      // Act & Assert
      expect(
        () => repository.createAlias(url),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Request timeout - please try again'),
          ),
        ),
      );
    }, timeout: const Timeout(Duration(seconds: 10)));
  });
}
