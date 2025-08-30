import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:async';

import '../model/service.dart';

class MockApi {
  final int pageSize;
  List<Service>? _all;

  MockApi({this.pageSize = 10});

  Future<void> _loadAll() async {
    if (_all != null) return;
    final raw = await rootBundle.loadString('assets/services.json');
    final list = json.decode(raw) as List<dynamic>;
    _all = list.map((e) => Service.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Simulates a paginated GET /services?page=X
  Future<List<Service>> fetchServices({int page = 1}) async {
    await _loadAll();
    // simulate network latency
    await Future.delayed(const Duration(milliseconds: 600));
    final start = (page - 1) * pageSize;
    if (start >= (_all!.length)) return [];
    final end = (start + pageSize).clamp(0, _all!.length);
    return _all!.sublist(start, end);
  }

  /// Simulate search
  Future<List<Service>> search(String q, {int page = 1}) async {
    await _loadAll();
    await Future.delayed(const Duration(milliseconds: 400));
    final filtered = _all!.where((s) =>
    s.title.toLowerCase().contains(q.toLowerCase()) ||
        s.description.toLowerCase().contains(q.toLowerCase())
    ).toList();
    final start = (page - 1) * pageSize;
    if (start >= filtered.length) return [];
    final end = (start + pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }
}