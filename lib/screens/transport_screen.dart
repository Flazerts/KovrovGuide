import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/guide_widgets.dart';
import 'route_map_screen.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});
  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  String _query = '';

  Future<void> _openUrl(String url) async {
    try {
      final success = await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      if (!success && mounted) _message('Не удалось открыть файл. Проверьте подключение к интернету.');
    } catch (_) {
      if (mounted) _message('Источник сейчас недоступен. Сведения о маршруте остаются в каталоге приложения.');
    }
  }

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  void _showRoute(CityRoute route) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) => SafeArea(child: SingleChildScrollView(child: Padding(padding: EdgeInsets.fromLTRB(22, 8, 22, 24 + MediaQuery.of(sheetContext).viewInsets.bottom), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Container(width: 58, height: 58, alignment: Alignment.center, decoration: BoxDecoration(color: GuideColors.mint, borderRadius: BorderRadius.circular(17)), child: Text(route.number, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: GuideColors.greenDark))), const SizedBox(width: 13), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(route.kind.toUpperCase(), style: const TextStyle(fontSize: 10, letterSpacing: 1.2, color: GuideColors.green, fontWeight: FontWeight.w800)), const SizedBox(height: 4), Text('Маршрут ${route.number}', style: Theme.of(context).textTheme.titleLarge)]))]),
        const SizedBox(height: 20),
        _EndpointRow(icon: Icons.trip_origin_rounded, label: 'Начальный пункт', value: route.origin),
        const SizedBox(height: 10),
        _EndpointRow(icon: Icons.location_on_rounded, label: 'Конечный пункт', value: route.destination),
        const SizedBox(height: 14),
        Container(width: double.infinity, padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: GuideColors.mint, borderRadius: BorderRadius.circular(15)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.info_outline_rounded, color: GuideColors.greenDark, size: 20), const SizedBox(width: 10), Expanded(child: Text(route.note, style: const TextStyle(color: GuideColors.ink, fontSize: 13, height: 1.4)))])),
        const SizedBox(height: 18),
        SizedBox(width: double.infinity, child: FilledButton.icon(
          onPressed: () {
            Navigator.of(sheetContext).pop();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => RouteMapScreen(title: route.hasInteractiveMap ? 'Маршрут ${route.number}' : 'Информация о троллейбусе ${route.number}', url: route.mapUrl),
            ));
          },
          icon: const Icon(Icons.map_rounded),
          label: Text(route.hasInteractiveMap ? 'Показать линию и остановки на карте' : 'Открыть страницу перевозчика'),
        )),
        const SizedBox(height: 9),
        SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () { Navigator.of(sheetContext).pop(); _openUrl(route.timetableUrl); }, icon: const Icon(Icons.open_in_new_rounded), label: const Text('Открыть опубликованное расписание'))),
        const SizedBox(height: 9),
        SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () { Navigator.of(sheetContext).pop(); _openUrl(kOfficialTransportPage); }, icon: const Icon(Icons.account_balance_outlined), label: const Text('Официальная страница администрации'))),
        const SizedBox(height: 6),
        Text('Каталог маршрутов в приложении работает офлайн. Официальные файлы расписаний открываются по запросу и требуют интернета.', style: Theme.of(context).textTheme.bodyMedium),
      ])))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routes = kCityRoutes.where((route) => '${route.number} ${route.kind} ${route.origin} ${route.destination}'.toLowerCase().contains(_query.toLowerCase().trim())).toList();
    return SafeArea(child: Center(child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 980),
      child: CustomScrollView(slivers: [
        SliverPadding(padding: const EdgeInsets.fromLTRB(22, 23, 22, 10), sliver: SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Eyebrow('Городской транспорт'),
          const SizedBox(height: 7),
          Text('Автобусы и троллейбусы', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 7),
          Text('Справочник хранится внутри приложения — не нужно загружать сайт, чтобы найти номер маршрута и конечные пункты.', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Wrap(spacing: 9, runSpacing: 8, children: [
            FilledButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const RouteMapScreen(title: 'Карта городского транспорта', url: 'https://ru.wikiroutes.info/kovrov'),
              )),
              icon: const Icon(Icons.map_outlined),
              label: const Text('Карта всех линий'),
            ),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => const RouteMapScreen(title: 'Каталог маршрутов', url: 'https://ru.wikiroutes.info/kovrov/catalog'),
              )),
              icon: const Icon(Icons.route_rounded),
              label: const Text('Каталог остановок и маршрутов'),
            ),
          ]),
          const SizedBox(height: 14),
          TextField(onChanged: (value) => setState(() => _query = value), decoration: const InputDecoration(hintText: 'Найти маршрут или остановку', prefixIcon: Icon(Icons.search_rounded))),
          const SizedBox(height: 14),
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: const Color(0xFFE9F1EC), borderRadius: BorderRadius.circular(16)), child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.offline_pin_rounded, color: GuideColors.green), SizedBox(width: 10), Expanded(child: Text('Это справочник маршрутов, а не онлайн-табло. Фактическое движение и задержки в приложении не отображаются. Схемы линий открываются по отдельному маршруту.', style: TextStyle(fontSize: 12, height: 1.4, color: GuideColors.ink)))])),
          const SizedBox(height: 16),
          SectionHeading(title: 'Маршруты', subtitle: '${routes.length} записей в локальном каталоге'),
        ]))),
        if (routes.isEmpty)
          const SliverFillRemaining(hasScrollBody: false, child: EmptyState(icon: Icons.search_off_rounded, title: 'Маршрут не найден', body: 'Проверьте номер или название конечного пункта.'))
        else
          SliverPadding(padding: const EdgeInsets.fromLTRB(22, 0, 22, 32), sliver: SliverList(delegate: SliverChildBuilderDelegate((context, index) => Padding(padding: const EdgeInsets.only(bottom: 10), child: _RouteCard(route: routes[index], onTap: () => _showRoute(routes[index]))), childCount: routes.length))),
      ]),
    )));
  }
}

class _RouteCard extends StatelessWidget {
  final CityRoute route;
  final VoidCallback onTap;
  const _RouteCard({required this.route, required this.onTap});
  @override
  Widget build(BuildContext context) => Card(child: InkWell(borderRadius: BorderRadius.circular(22), onTap: onTap, child: Padding(padding: const EdgeInsets.all(15), child: Row(children: [
        Container(width: 56, height: 56, alignment: Alignment.center, decoration: BoxDecoration(color: GuideColors.mint, borderRadius: BorderRadius.circular(16)), child: Text(route.number, textAlign: TextAlign.center, style: const TextStyle(color: GuideColors.greenDark, fontWeight: FontWeight.w800, fontSize: 17))),
        const SizedBox(width: 13),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(route.kind, style: const TextStyle(fontSize: 10, color: GuideColors.green, fontWeight: FontWeight.w800, letterSpacing: .6)), const SizedBox(height: 3), Text(route.origin, style: const TextStyle(fontSize: 14, color: GuideColors.ink, fontWeight: FontWeight.w700)), const Padding(padding: EdgeInsets.symmetric(vertical: 3), child: Icon(Icons.south_rounded, size: 15, color: GuideColors.muted)), Text(route.destination, style: const TextStyle(fontSize: 14, color: GuideColors.ink, fontWeight: FontWeight.w700)), const SizedBox(height: 7), Text(route.hasInteractiveMap ? 'Схема и остановки доступны' : 'Информация на сайте перевозчика', style: const TextStyle(fontSize: 11, color: GuideColors.muted, fontWeight: FontWeight.w600))])),
        const Icon(Icons.chevron_right_rounded, color: GuideColors.muted),
      ]))));
}

class _EndpointRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _EndpointRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, color: GuideColors.green, size: 19), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: GuideColors.muted, fontSize: 11)), const SizedBox(height: 2), Text(value, style: const TextStyle(color: GuideColors.ink, fontSize: 14, fontWeight: FontWeight.w700))]))]);
}