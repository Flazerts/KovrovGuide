import 'package:flutter/material.dart';
import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/guide_widgets.dart';
import 'place_detail_screen.dart';
import 'places_screen.dart';

class PlanScreen extends StatelessWidget {
  const PlanScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Мой маршрут')),
        body: SafeArea(child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: AnimatedBuilder(animation: AppState.instance, builder: (context, _) {
            final state = AppState.instance;
            final places = state.planIds.map((id) { final matches = kPlaces.where((place) => place.id == id); return matches.isEmpty ? null : matches.first; }).whereType<Place>().toList();
            return ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 34), children: [
              Container(padding: const EdgeInsets.all(22), decoration: BoxDecoration(color: GuideColors.greenDark, borderRadius: BorderRadius.circular(25)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Eyebrow('Персональная подборка'),
                const SizedBox(height: 8),
                Text(places.isEmpty ? 'Собери прогулку\nпод себя' : 'Твой маршрут\nпо Коврову', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                const SizedBox(height: 9),
                Text(places.isEmpty ? 'Добавляй места из каталога — список сохранится на устройстве.' : 'В плане ${places.length} ${_placeWord(places.length)}. Порядок точек можно менять стрелками.', style: const TextStyle(color: Color(0xFFDDEBE4), fontSize: 13, height: 1.4)),
                const SizedBox(height: 17),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  FilledButton.icon(onPressed: () {
                    AppState.instance.setSearchQuery('');
                    AppState.instance.setCategory(null);
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlacesScreen(selectionMode: true)));
                  }, icon: const Icon(Icons.add_location_alt_outlined), label: const Text('Добавить места'), style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: GuideColors.greenDark)),
                  if (places.isNotEmpty) OutlinedButton.icon(onPressed: state.clearPlan, icon: const Icon(Icons.delete_outline_rounded), label: const Text('Очистить'), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54))),
                ]),
              ])),
              const SizedBox(height: 22),
              if (places.isEmpty) ...[
                const SectionHeading(title: 'Или начни с готовой идеи', subtitle: 'Небольшая прогулка по городским символам'),
                Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('«Символы Коврова»', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: GuideColors.ink)),
                  const SizedBox(height: 6),
                  const Text('Памятник Дегтярёву, стела «Город воинской славы» и парк имени А. С. Пушкина. Это примерная подборка, а не рассчитанный навигационный трек.', style: TextStyle(fontSize: 13, color: GuideColors.muted, height: 1.45)),
                  const SizedBox(height: 15),
                  PrimaryAction(label: 'Добавить готовую подборку', icon: Icons.route_rounded, onPressed: state.createSuggestedPlan),
                ]))),
              ] else ...[
                SectionHeading(title: 'Точки маршрута', subtitle: 'Нажми на место, чтобы открыть подробности'),
                ...places.asMap().entries.map((entry) {
                  final index = entry.key;
                  final place = entry.value;
                  return Padding(padding: const EdgeInsets.only(bottom: 10), child: Card(child: InkWell(borderRadius: BorderRadius.circular(20), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeId: place.id))), child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [
                    Container(width: 38, height: 38, alignment: Alignment.center, decoration: const BoxDecoration(color: GuideColors.mint, shape: BoxShape.circle), child: Text('${index + 1}', style: const TextStyle(fontWeight: FontWeight.w800, color: GuideColors.greenDark))),
                    const SizedBox(width: 11),
                    Text(place.emoji, style: const TextStyle(fontSize: 26)),
                    const SizedBox(width: 11),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(place.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: GuideColors.ink)), const SizedBox(height: 3), Text(place.address, style: const TextStyle(fontSize: 11, color: GuideColors.muted))])),
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                        tooltip: 'Переместить выше',
                        visualDensity: VisualDensity.compact,
                        onPressed: index == 0 ? null : () => state.movePlanItem(place.id, -1),
                        icon: const Icon(Icons.keyboard_arrow_up_rounded, color: GuideColors.muted),
                      ),
                      IconButton(
                        tooltip: 'Переместить ниже',
                        visualDensity: VisualDensity.compact,
                        onPressed: index == places.length - 1 ? null : () => state.movePlanItem(place.id, 1),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: GuideColors.muted),
                      ),
                      IconButton(tooltip: 'Убрать из маршрута', onPressed: () => state.removeFromPlan(place.id), icon: const Icon(Icons.close_rounded, color: GuideColors.muted)),
                    ]),
                  ])))));
                }),
                const SizedBox(height: 8),
                OutlinedButton.icon(onPressed: () {
                  AppState.instance.setSearchQuery('');
                  AppState.instance.setCategory(null);
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlacesScreen(selectionMode: true)));
                }, icon: const Icon(Icons.add_rounded), label: const Text('Добавить ещё одно место'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14))),
              ],
              const SizedBox(height: 20),
              Text('Совет: уточни часы работы и адреса перед выходом. В этой версии порядок точек не оптимизируется по расстоянию.', style: Theme.of(context).textTheme.bodyMedium),
            ]);
          }),
        ))),
      );

  String _placeWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) return 'место';
    if ([2, 3, 4].contains(count % 10) && ![12, 13, 14].contains(count % 100)) return 'места';
    return 'мест';
  }
}
