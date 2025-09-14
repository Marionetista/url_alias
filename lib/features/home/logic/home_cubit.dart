import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/constants/messages.dart';
import '../data/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required HomeRepository repository})
    : _repository = repository,
      super(const HomeInitial(aliases: []));

  final HomeRepository _repository;

  Future<void> createAlias(String url) async {
    final existingAlias = state.aliases
        .where((alias) => alias.self == url)
        .firstOrNull;

    if (existingAlias != null) {
      emit(
        HomeError(
          aliases: state.aliases,
          message: AppMessages.urlAlreadyShortened,
        ),
      );

      return;
    }

    emit(HomeLoading(aliases: state.aliases));

    try {
      final alias = await _repository.createAlias(url);
      final newAliases = [...state.aliases, alias];

      emit(HomeSuccess(aliases: newAliases));
    } catch (e) {
      emit(HomeError(aliases: state.aliases, message: e.toString()));
    }
  }
}
