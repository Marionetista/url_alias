import '../../../common/models/url_alias_model.dart';

abstract class HomeState {
  const HomeState();
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  const HomeSuccess({required this.aliases});

  final List<UrlAliasModel> aliases;
}

class HomeError extends HomeState {
  const HomeError({required this.message});

  final String message;
}

class HomeUrlRetrieved extends HomeState {
  const HomeUrlRetrieved({
    required this.aliases,
    required this.retrievedUrl,
    required this.alias,
  });

  final List<UrlAliasModel> aliases;
  final String retrievedUrl;
  final String alias;
}
