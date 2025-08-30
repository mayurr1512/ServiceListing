import 'package:flutter/material.dart';

import '../model/service.dart';

class ServiceItem extends StatelessWidget {
  final Service service;
  final bool isFav;
  final VoidCallback onFav;

  const ServiceItem({super.key, required this.service, required this.isFav, required this.onFav});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(service.title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18)),
      subtitle: Text(service.description, style: TextStyle(color: Colors.grey, fontSize: 16)),
      trailing: IconButton(
        key: Key('fav_${service.id}'),
        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey, size: 30),
        onPressed: onFav,
      ),
    );
  }
}
