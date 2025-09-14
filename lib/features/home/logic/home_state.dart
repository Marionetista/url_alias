import 'package:equatable/equatable.dart';
import '../../../common/models/url_alias_model.dart';

sealed class HomeState extends Equatable {
  const HomeState({required this.aliases});

  final List<UrlAliasModel> aliases;

  @override
  List<Object> get props => [aliases];
}

class HomeInitial extends HomeState {
  const HomeInitial({required super.aliases});
}

class HomeLoading extends HomeState {
  const HomeLoading({required super.aliases});
}

class HomeSuccess extends HomeState {
  const HomeSuccess({required super.aliases});
}

class HomeError extends HomeState {
  const HomeError({required super.aliases, required this.message});

  final String message;

  @override
  List<Object> get props => [aliases, message];
}
