import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../common/models/url_alias_model.dart';
import '../data/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required HomeRepository repository})
    : _repository = repository,
      super(HomeInitial());

  final HomeRepository _repository;
  final List<UrlAliasModel> _aliases = [];

  List<UrlAliasModel> get aliases => List.unmodifiable(_aliases);

  Future<void> createAlias(String url) async {
    emit(HomeLoading());

    try {
      final alias = await _repository.createAlias(url);
      _aliases.add(alias);

      emit(HomeSuccess(aliases: _aliases));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}
