import 'dart:math';

import 'package:flutter/material.dart';
import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/guide_widgets.dart';
import 'place_detail_screen.dart';

class PlacesScreen extends StatelessWidget {
  final bool selectionMode;
  const PlacesScreen({super.key, this.selectionMode = false});

  void _openPlace(BuildContext context, Place place) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeId: place.id)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: GuideColors.paper,
        appBar: selectionMode ? AppBar(title: const Text('Добавить места в маршрут')) : null,
        body: Material(
          color: GuideColors.paper,
          child: SafeArea(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: AnimatedBuilder(
          animation: AppState.instance,
          builder: (context, _) {
            final state = AppState.instance;
            final query = state.searchQuery.trim().toLowerCase();
            final places = kPlaces.where((place) {
              final categoryMatches = state.selectedCategory == null || place.category == state.selectedCategory;
              final searchable = '${place.name} ${place.subtitle} ${place.description} ${place.address} ${place.tags.join(' ')}'.toLowerCase();
              return categoryMatches && (query.isEmpty || searchable.contains(query));
            }).toList();
            return CustomScrollView(slivers: [
              SliverPadding(padding: const EdgeInsets.fromLTRB(22, 24, 22, 8), sliver: SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Eyebrow('Каталог города'),
                const SizedBox(height: 7),
                Text('Места Коврова', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 7),
                Text(selectionMode ? 'Отмечай интересные точки — они появятся в твоём маршруте.' : 'Музеи, памятники, парки и точки, которые помогают лучше узнать малую родину.', style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  OutlinedButton.icon(
                    onPressed: places.isEmpty ? null : () {
                      final place = places[Random().nextInt(places.length)];
                      _openPlace(context, place);
                    },
                    icon: const Icon(Icons.casino_outlined, size: 18),
                    label: const Text('Удиви меня'),
                  ),
                  if (selectionMode)
                    Chip(
                      avatar: const Icon(Icons.route_rounded, size: 17),
                      label: Text('В маршруте: ${state.planIds.length}'),
                      backgroundColor: GuideColors.mint,
                    ),
                ]),
                const SizedBox(height: 12),
                Material(
                  color: GuideColors.paper,
                  borderRadius: BorderRadius.circular(16),
                  child: TextField(
                  key: const ValueKey('places-search'),
                  onChanged: state.setSearchQuery,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(hintText: 'Поиск по названию, адресу и теме', prefixIcon: const Icon(Icons.search_rounded), suffixIcon: query.isNotEmpty ? IconButton(onPressed: () => state.setSearchQuery(''), icon: const Icon(Icons.close_rounded)) : null),
                  ),
                ),
                const SizedBox(height: 13),
                SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
                  Padding(padding: const EdgeInsets.only(right: 7), child: ChoiceChip(label: const Text('Все'), selected: state.selectedCategory == null, onSelected: (_) => state.setCategory(null))),
                  ...kCategories.map((category) => Padding(padding: const EdgeInsets.only(right: 7), child: ChoiceChip(label: Text(category), selected: state.selectedCategory == category, onSelected: (_) => state.setCategory(state.selectedCategory == category ? null : category)))),
                ])),
                const SizedBox(height: 9),
                Row(children: [Text('${places.length} мест', style: const TextStyle(color: GuideColors.muted, fontWeight: FontWeight.w700, fontSize: 12)), const Spacer(), if (state.selectedCategory != null || query.isNotEmpty) TextButton(onPressed: () { state.setCategory(null); state.setSearchQuery(''); }, child: const Text('Сбросить'))]),
              ]))),
              if (places.isEmpty)
                const SliverFillRemaining(hasScrollBody: false, child: EmptyState(icon: Icons.search_off_rounded, title: 'Ничего не нашлось', body: 'Попробуйте изменить запрос или выбрать другую категорию.'))
              else
                SliverPadding(padding: const EdgeInsets.fromLTRB(22, 0, 22, 32), sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) => Padding(padding: const EdgeInsets.only(bottom: 11), child: PlaceCard(
                  place: places[index],
                  onTap: () => _openPlace(context, places[index]),
                  showPlanAction: selectionMode,
                  onPlanAction: selectionMode ? () {
                    final place = places[index];
                    final wasInPlan = state.isInPlan(place.id);
                    state.togglePlan(place.id);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(wasInPlan ? '«${place.name}» убрано из маршрута' : '«${place.name}» добавлено в маршрут'),
                      duration: const Duration(seconds: 2),
                    ));
                  } : null,
                )), childCount: places.length))),
            ]);
          },
        ),
      ))),
        ),
      );
}
