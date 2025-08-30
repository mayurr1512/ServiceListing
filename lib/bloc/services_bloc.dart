import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/service.dart';
import 'services_event.dart';
import 'services_state.dart';
import '../data/repository.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final Repository repo;
  ServicesBloc({required this.repo}) : super(const ServicesState()) {
    on<LoadServices>(_onLoad);
    on<LoadMoreServices>(_onLoadMore);
    on<SwitchTab>((e, emit) => emit(state.copyWith(activeTab: e.index)));
    on<SearchServices>(_onSearch);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);

    // initial load
    add(const LoadServices());
  }

  Future<void> _onLoad(LoadServices e, Emitter<ServicesState> emit) async {
    final page = 1;
    emit(state.copyWith(loading: true, page: page, query: '', searching: false));
    try {
      final data = await repo.fetchServices(page: page);

      // Set favourite services list
      final favs = repo.getFavorites();
      final favServices = data.where((s) => favs.contains(s.id)).toList();

      emit(state.copyWith(
        services: data,
        favorites: favs,
        favServices: favServices,
        loading: false,
        page: page,
        hasMore: data.length >= 10,
      ));
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }

  Future<void> _onLoadMore(LoadMoreServices e, Emitter<ServicesState> emit) async {
    if (!state.hasMore || state.loading) return;
    emit(state.copyWith(loading: true));
    final next = state.page + 1;
    try {
      final more = state.query.isEmpty
          ? await repo.fetchServices(page: next)
          : await repo.search(state.query, page: next);
      final all = List.of(state.services)..addAll(more);
      emit(state.copyWith(
        services: all,
        loading: false,
        page: next,
        hasMore: more.length >= 10,
      ));
    } catch (_) {
      emit(state.copyWith(loading: false));
    }
  }

  void _onAddFavorite(AddFavorite event, Emitter<ServicesState> emit) {
    final updated = List<Service>.from(state.favServices)..add(event.service);
    saveFavourites(event.service.id);
    emit(state.copyWith(favServices: updated));
  }

  void _onRemoveFavorite(RemoveFavorite event, Emitter<ServicesState> emit) {
    final updated = List<Service>.from(state.favServices)..remove(event.service);
    saveFavourites(event.service.id);
    emit(state.copyWith(favServices: updated));
  }

  Future<void> saveFavourites(String id) async {
    final current = Set<String>.from(state.favorites);
    final isFav = current.contains(id);
    if (isFav) {
      current.remove(id);
    } else {
      current.add(id);
    }
    await repo.toggleFavorite(id, !isFav);
  }

  Future<void> _onSearch(SearchServices e, Emitter<ServicesState> emit) async {
    final q = e.query;
    if (e.reset) {
      emit(state.copyWith(loading: true, query: q, searching: true, page: 1));
    } else {
      emit(state.copyWith(loading: true, query: q, searching: true));
    }
    try {
      final results = await repo.search(q, page: 1);
      emit(state.copyWith(
        services: results,
        loading: false,
        page: 1,
        hasMore: results.length >= 10,
        searching: false,
      ));
    } catch (_) {
      emit(state.copyWith(loading: false, searching: false));
    }
  }
}