import 'package:flutter/material.dart';
import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/guide_widgets.dart';
import 'place_detail_screen.dart';
import 'plan_screen.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  final ValueChanged<int> onNavigate;
  const HomeScreen({super.key, required this.onNavigate});

  void _openPlace(BuildContext context, Place place) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => PlaceDetailScreen(placeId: place.id)));
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Center(child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1140),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(22, 23, 22, 36),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(width: 42, height: 42, decoration: BoxDecoration(color: GuideColors.green, borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.explore_rounded, color: Colors.white, size: 25)),
                const SizedBox(width: 11),
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Eyebrow('Путеводитель по городу'),
                  SizedBox(height: 3),
                  Text('Ковров', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: GuideColors.ink)),
                ]),
                const Spacer(),
                IconButton.filledTonal(onPressed: () => onNavigate(4), icon: const Icon(Icons.bookmark_outline_rounded), tooltip: 'Избранное'),
              ]),
              const SizedBox(height: 28),
              LayoutBuilder(builder: (context, constraints) {
                final wide = constraints.maxWidth > 720;
                return Flex(
                  direction: wide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: wide ? CrossAxisAlignment.start : CrossAxisAlignment.stretch,
                  children: [
                  ExpandedIfWide(wide: wide, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Eyebrow('Откройте город заново'),
                    const SizedBox(height: 9),
                    Text('Знакомьтесь\nс Ковровом', style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(height: 13),
                    Text('Лучшие места, готовые маршруты и полезные советы для прогулок. Каталог работает без интернета.', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 20),
                    TextField(
                      textInputAction: TextInputAction.search,
                      onChanged: AppState.instance.setSearchQuery,
                      onSubmitted: (_) => onNavigate(1),
                      decoration: InputDecoration(
                        hintText: 'Найти музей, памятник или парк…',
                        prefixIcon: const Icon(Icons.search_rounded, color: GuideColors.green),
                        suffixIcon: IconButton(onPressed: () => onNavigate(1), icon: const Icon(Icons.arrow_forward_rounded)),
                      ),
                    ),
                    const SizedBox(height: 17),
                    Wrap(spacing: 8, runSpacing: 8, children: [
                      _QuickChip(icon: Icons.account_balance_rounded, label: 'Музеи', onTap: () { AppState.instance.setCategory('Музеи'); onNavigate(1); }),
                      _QuickChip(icon: Icons.park_rounded, label: 'Парки', onTap: () { AppState.instance.setCategory('Парки'); onNavigate(1); }),
                      _QuickChip(icon: Icons.directions_bus_rounded, label: 'Транспорт', onTap: () => onNavigate(3)),
                    ]),
                  ])),
                  if (wide) const SizedBox(width: 24) else const SizedBox(height: 22),
                  ExpandedIfWide(wide: wide, child: _HeroCard(onPlaces: () => onNavigate(1), onPlan: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlanScreen())))),
                ]);
              }),
              const SizedBox(height: 33),
              const SectionHeading(title: 'С чего начать', subtitle: 'Полезные разделы и инструменты'),
              LayoutBuilder(builder: (context, constraints) {
                final wide = constraints.maxWidth > 730;
                final tiles = [
                  _ActionTile(icon: Icons.route_rounded, title: 'Мой маршрут', subtitle: 'Соберите список мест для прогулки', color: const Color(0xFFE5F1EB), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlanScreen()))),
                  _ActionTile(icon: Icons.quiz_rounded, title: 'Викторина', subtitle: 'Проверьте знание истории города', color: const Color(0xFFFFEEDB), onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const QuizScreen()))),
                  _ActionTile(icon: Icons.map_rounded, title: 'Карта', subtitle: 'Расположение объектов на карте', color: const Color(0xFFE7ECFA), onTap: () => onNavigate(2)),
                ];
                if (!wide) return Column(children: tiles.map((tile) => Padding(padding: const EdgeInsets.only(bottom: 10), child: tile)).toList());
                return Row(crossAxisAlignment: CrossAxisAlignment.start, children: tiles.map((tile) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 10), child: tile))).toList());
              }),
              const SizedBox(height: 28),
              SectionHeading(title: 'Интересные места', subtitle: 'Для первого знакомства с городом', trailing: TextButton(onPressed: () => onNavigate(1), child: const Text('Все места'))),
              ...kPlaces.where((p) => [1, 2, 8].contains(p.id)).map((place) => Padding(padding: const EdgeInsets.only(bottom: 11), child: PlaceCard(place: place, onTap: () => _openPlace(context, place)))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(color: const Color(0xFFE9F1EC), borderRadius: BorderRadius.circular(20)),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.info_outline_rounded, color: GuideColors.green),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Режим работы и расписание могут меняться. Рекомендуем сверять актуальные данные перед поездкой.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: GuideColors.ink))),
                ]),
              ),
            ]),
          ),
        )),
      );
}

class ExpandedIfWide extends StatelessWidget {
  final bool wide;
  final Widget child;
  const ExpandedIfWide({super.key, required this.wide, required this.child});
  @override
  Widget build(BuildContext context) => wide ? Expanded(child: child) : child;
}

class _HeroCard extends StatelessWidget {
  final VoidCallback onPlaces;
  final VoidCallback onPlan;
  const _HeroCard({required this.onPlaces, required this.onPlan});

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints(minHeight: 255),
        padding: const EdgeInsets.all(23),
        decoration: BoxDecoration(
          gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [GuideColors.greenDark, GuideColors.green]),
          borderRadius: BorderRadius.circular(26),
        ),
        child: Stack(children: [
          const Positioned(right: -4, top: -5, child: Icon(Icons.location_city_rounded, size: 130, color: Color(0x22FFFFFF))),
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(.15), borderRadius: BorderRadius.circular(20)), child: const Text('ИДЕИ ДЛЯ ПРОГУЛОК', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.2))),
            const SizedBox(height: 25),
            const Text('История рядом.\nПора на прогулку.', style: TextStyle(color: Colors.white, fontSize: 23, height: 1.16, fontWeight: FontWeight.w800, letterSpacing: -.3)),
            const SizedBox(height: 10),
            const Text('Выбирайте интересные точки и составляйте свой маршрут.', style: TextStyle(color: Color(0xFFDCEBE4), fontSize: 13, height: 1.4)),
            const SizedBox(height: 18),
            Wrap(spacing: 9, runSpacing: 8, children: [
              FilledButton(onPressed: onPlaces, style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: GuideColors.greenDark), child: const Text('Смотреть места')),
              OutlinedButton(onPressed: onPlan, style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white70)), child: const Text('Собрать маршрут')),
            ]),
          ]),
        ]),
      );
}

class _QuickChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickChip({required this.icon, required this.label, required this.onTap});
  @override
  Widget build(BuildContext context) => ActionChip(avatar: Icon(icon, size: 16, color: GuideColors.green), label: Text(label), onPressed: onTap, backgroundColor: Colors.white, side: const BorderSide(color: GuideColors.line));
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  const _ActionTile({required this.icon, required this.title, required this.subtitle, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) => Card(child: InkWell(borderRadius: BorderRadius.circular(22), onTap: onTap, child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
        Container(width: 47, height: 47, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: GuideColors.greenDark, size: 24)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleMedium), const SizedBox(height: 4), Text(subtitle, style: Theme.of(context).textTheme.bodyMedium)])),
        const Icon(Icons.arrow_forward_ios_rounded, size: 15, color: GuideColors.muted),
      ]))));
}