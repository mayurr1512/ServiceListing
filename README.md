# Favorite Services (Offline Mock API)

Feature: Favorite Services screen (All Services / Favorites)
- Loads services from `assets/services.json` (mock API).
- Pagination & lazy loading (10 items per page).
- Favorite/unfavorite persisted with Hive.
- BLoC pattern for state management.
- Search support (with pagination).

## 🎥 Demo

https://github.com/user-attachments/assets/9491c9bf-5e59-491a-94c7-8a32ba3b5209



## 🖼 Screenshots

| All Services | Favourites | Search |
|--------------|------------|--------|
<table>
  <tr>
    <td><img src="Screenshots/AllServices.png" alt="All Services" width="250"/></td>
    <td><img src="Screenshots/Favouites.png" alt="Favourites" width="250"/></td>
    <td><img src="Screenshots/Search.png" alt="Search" width="250"/></td>
  </tr>
</table>

---

## Run
1. flutter pub get
2. flutter run

## Notes
- `assets/services.json` contains 50 sample services.
- Hive stores favorite IDs in a local box named `favorites`.

## Tests
### Unit & Widget Tests
- Service Item Widget Tests: `test/widget_test/service_item_test.dart`
- Search Functionality Tests: `test/widget_test/search_test.dart`

- Run widget tests:
```bash
flutter test test/widget_test/
```

### Integration Tests
- Favorite Persistence Tests: `test/integration_test/favorite_persistence_test.dart`

- Run integration tests:
```bash
flutter test test/integration_test/
```