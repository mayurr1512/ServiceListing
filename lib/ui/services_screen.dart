import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_app/ui/service_item.dart';
import '../bloc/services_bloc.dart';
import '../bloc/services_event.dart';
import '../bloc/services_state.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final ScrollController _scroll = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 200) {
        context.read<ServicesBloc>().add(LoadMoreServices());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        focusNode: _focusNode,
                        onChanged: (v) {
                          context.read<ServicesBloc>().add(SearchServices(v));
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Search any services here...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          suffixIcon: (_focusNode.hasFocus || _searchCtrl.text.isNotEmpty) ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.blueGrey),
                            onPressed: () {
                              _searchCtrl.clear();
                              context.read<ServicesBloc>().add(LoadServices());
                              _focusNode.unfocus();
                              setState(() {});
                            },
                          ) : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 5),

            const TabBarWidget(),

            Expanded(
              child: BlocBuilder<ServicesBloc, ServicesState>(
                builder: (context, s) {
                  final items = s.activeTab == 0 ? s.services : s.favServices;
        
                  if (s.loading && items.isEmpty) return const Center(child: CircularProgressIndicator());
                  if (items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(s.activeTab == 0 ? Icons.search : Icons.favorite_border, color: Colors.grey, size: 50),
                          SizedBox(height: 10),
                          Text(s.activeTab == 0 ? 'No services found' : 'No favorites yet', style: TextStyle(color: Colors.grey, fontSize: 20)),
                        ],
                      )
                    );
                  }

                  var itemCount = s.activeTab == 1 ? items.length : (items.length + (s.hasMore ? 1 : 0));
        
                  return ListView.separated(
                    controller: _scroll,
                    itemCount:itemCount,
                    padding: EdgeInsets.symmetric(vertical: 5),
                    separatorBuilder: (ctx, idx) {
                      return Divider(
                          color: Colors.grey,
                          thickness: 0.3
                      );
                    },
                    itemBuilder: (ctx, idx) {
                      if (idx >= items.length) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final service = items[idx];
                      final isFav = s.favServices.any((fav) => fav.id == service.id);

                      return ServiceItem(
                        service: service,
                        isFav: isFav,
                        onFav: () {
                          if (isFav) {
                            context.read<ServicesBloc>().add(RemoveFavorite(service));
                          } else {
                            context.read<ServicesBloc>().add(AddFavorite(service));
                          }
                        }
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scroll.dispose();
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServicesBloc, ServicesState>(
      builder: (c, s) {

        var isActiveTab = s.activeTab;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => c.read<ServicesBloc>().add(const SwitchTab(0)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(isActiveTab == 0 ? Colors.blueGrey : Colors.transparent),
                  ),
                  child: Text('All Services', style: TextStyle(color: isActiveTab == 0 ? Colors.white : Colors.grey, fontSize: 16)),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => c.read<ServicesBloc>().add(const SwitchTab(1)),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(isActiveTab == 1 ? Colors.blueGrey : Colors.transparent),
                  ),
                  child: Text('Favorites', style: TextStyle(color: isActiveTab == 1 ? Colors.white : Colors.grey, fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}