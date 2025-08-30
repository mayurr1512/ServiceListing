import '../model/service.dart';
import 'mock_api.dart';
import 'local_storage.dart';

class Repository {
  final MockApi api;
  final LocalStorage local;

  Repository({required this.api, required this.local});

  Future<List<Service>> fetchServices({required int page}) => api.fetchServices(page: page);

  Future<List<Service>> search(String q, {required int page}) => api.search(q, page: page);

  Set<String> getFavorites() => local.getFavorites();

  Future<void> toggleFavorite(String id, bool add) async {
    final f = local.getFavorites();
    if (add) {
      f.add(id);
    } else {
      f.remove(id);
    }
    await local.saveFavorites(f);
  }
}
