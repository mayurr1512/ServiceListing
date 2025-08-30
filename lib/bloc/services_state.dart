import 'package:equatable/equatable.dart';
import '../model/service.dart';

class ServicesState extends Equatable {
  final List<Service> services;
  final List<Service> favServices;
  final Set<String> favorites;
  final bool loading;
  final int page;
  final bool hasMore;
  final int activeTab; // 0 all, 1 favorites
  final String query;
  final bool searching;

  const ServicesState({
    this.services = const [],
    this.favServices = const [],
    this.favorites = const {},
    this.loading = false,
    this.page = 1,
    this.hasMore = true,
    this.activeTab = 0,
    this.query = '',
    this.searching = false,
  });

  ServicesState copyWith({
    List<Service>? services,
    List<Service>? favServices,
    Set<String>? favorites,
    bool? loading,
    int? page,
    bool? hasMore,
    int? activeTab,
    String? query,
    bool? searching,
  }) => ServicesState(
    services: services ?? this.services,
    favServices: favServices ?? this.favServices,
    favorites: favorites ?? this.favorites,
    loading: loading ?? this.loading,
    page: page ?? this.page,
    hasMore: hasMore ?? this.hasMore,
    activeTab: activeTab ?? this.activeTab,
    query: query ?? this.query,
    searching: searching ?? this.searching,
  );

  @override
  List<Object?> get props => [services, favServices, favorites, loading, page, hasMore, activeTab, query, searching];
}