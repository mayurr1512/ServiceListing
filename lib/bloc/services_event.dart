import 'package:equatable/equatable.dart';
import 'package:service_app/model/service.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();
  @override
  List<Object?> get props => [];
}

class LoadServices extends ServicesEvent {
  final bool refresh;
  const LoadServices({this.refresh = false});
}

class LoadMoreServices extends ServicesEvent {}

class SwitchTab extends ServicesEvent {
  final int index; // 0 => all, 1 => favorites
  const SwitchTab(this.index);
  @override
  List<Object?> get props => [index];
}

class SearchServices extends ServicesEvent {
  final String query;
  final bool reset;
  const SearchServices(this.query, {this.reset = false});
  @override
  List<Object?> get props => [query, reset];
}

class AddFavorite extends ServicesEvent {
  final Service service;
  const AddFavorite(this.service);
}

class RemoveFavorite extends ServicesEvent {
  final Service service;
  const RemoveFavorite(this.service);
}