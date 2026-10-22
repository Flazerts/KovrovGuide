import 'package:flutter/material.dart';
import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/guide_widgets.dart';
import 'place_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;
  const FavoritesScreen({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) => SafeArea(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: AnimatedBuilder(animation: AppState.instance, builder: (context, _) {
          final favorites = kPlaces.where((place) => AppState.instance.favoriteIds.contains(place.id)).toList();
          return CustomScrollView(slivers: [
            SliverPadding(padding: const EdgeInsets.fromLTRB(22, 24, 22, 13), sliver: SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Eyebrow('Сохранённые места'),
              const SizedBox(height: 7),
              Text('Избранное', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 7),
              Text('Интересные точки, к которым хочется вернуться.', style: Theme.of(context).textTheme.bodyMedium),
            ]))),
            if (favorites.isEmpty)
              SliverFillRemaining(hasScrollBody: false, child: EmptyState(icon: Icons.bookmark_border_rounded, title: 'Список пуст', body: 'Добавляйте сюда места из каталога с помощью значка закладки.', action: FilledButton.icon(onPressed: () { AppState.instance.setCategory(null); AppState.instance.setSearchQuery(''); onNavigate(1); }, icon: const Icon(Icons.explore_rounded), label: const Text('Перейти к каталогу'))))
            else
              SliverPadding(padding: const EdgeInsets.fromLTRB(22, 0, 22, 30), sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) {
                final Place place = favorites[index];
                return Padding(padding: const EdgeInsets.only(bottom: 11), child: PlaceCard(place: place, onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeId: place.id)))));
              }, childCount: favorites.length))),
          ]);
        }),
      )));
}