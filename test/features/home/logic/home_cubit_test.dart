import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:url_alias/common/models/url_alias_model.dart';
import 'package:url_alias/features/home/data/home_repository.dart';
import 'package:url_alias/features/home/logic/home_cubit.dart';
import 'package:url_alias/features/home/logic/home_state.dart';

class MockHomeRepository extends Mock implements HomeRepository {}

void main() {
  group('HomeCubit Tests', () {
    late HomeCubit cubit;
    late MockHomeRepository mockRepository;

    setUp(() {
      mockRepository = MockHomeRepository();
      cubit = HomeCubit(repository: mockRepository);
    });

    tearDown(() => cubit.close());

    test(
      'When HomeCubit is created '
      'should emit HomeInitial',
      () => expect(cubit.state, isA<HomeInitial>()),
    );

    test(
      'When call createAlias with valid URL should emit HomeSuccess',
      () async {
        // Arrange
        const url = 'https://www.example.com';
        const alias = UrlAliasModel(
          alias: '123456789',
          self: 'https://www.example.com',
          short: 'https://short.ly/123456789',
        );

        when(
          () => mockRepository.createAlias(url),
        ).thenAnswer((_) async => alias);

        // Act
        await cubit.createAlias(url);

        // Assert
        expect(cubit.state, isA<HomeSuccess>());
        final successState = cubit.state as HomeSuccess;
        expect(successState.aliases.length, 1);
        expect(successState.aliases.first.alias, '123456789');
      },
    );

    test('When call createAlias with error should emit HomeError', () async {
      // Arrange
      const url = 'https://www.example.com';
      const errorMessage = 'Network error';

      when(
        () => mockRepository.createAlias(url),
      ).thenThrow(Exception(errorMessage));

      // Act
      await cubit.createAlias(url);

      // Assert
      expect(cubit.state, isA<HomeError>());
      final errorState = cubit.state as HomeError;
      expect(errorState.message, contains(errorMessage));
    });

    test('When access aliases getter should return unmodifiable list', () {
      // Act
      final aliases = cubit.aliases;

      // Assert
      expect(aliases, isA<List<UrlAliasModel>>());
      expect(
        () => aliases.add(
          const UrlAliasModel(alias: 'test', self: 'test', short: 'test'),
        ),
        throwsA(isA<UnsupportedError>()),
      );
    });

    test('When create HomeUrlRetrieved state should work correctly', () {
      // Arrange
      const aliases = <UrlAliasModel>[];
      const retrievedUrl = 'https://www.example.com';
      const alias = '123456789';

      // Act
      final state = HomeUrlRetrieved(
        aliases: aliases,
        retrievedUrl: retrievedUrl,
        alias: alias,
      );

      // Assert
      expect(state.aliases, aliases);
      expect(state.retrievedUrl, retrievedUrl);
      expect(state.alias, alias);
    });
  });
}
