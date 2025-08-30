import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final String id;
  final String title;
  final String description;

  const Service({required this.id, required this.title, required this.description});

  factory Service.fromJson(Map<String, dynamic> j) => Service(
    id: j['id'].toString(),
    title: j['title'] ?? j['name'] ?? '',
    description: j['description'] ?? '',
  );

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'description': description};

  @override
  List<Object?> get props => [id, title, description];
}
