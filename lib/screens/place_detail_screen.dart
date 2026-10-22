import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_state.dart';
import '../data.dart';
import '../models.dart';
import '../theme.dart';
import '../widgets/guide_widgets.dart';

class PlaceDetailScreen extends StatelessWidget {
  final int placeId;
  const PlaceDetailScreen({super.key, required this.placeId});

  Future<void> _launch(BuildContext context, Uri uri) async {
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && context.mounted) _showMessage(context, 'Не удалось открыть ссылку.');
    } catch (_) {
      if (context.mounted) _showMessage(context, 'Ссылка временно недоступна.');
    }
  }

  Uri _mapUri(Place place) {
    if (!place.coordinatesVerified) {
      return Uri.https('yandex.ru', '/maps/', {'text': 'Ковров, ${place.address}'});
    }
    final point = '${place.longitude},${place.latitude}';
    return Uri.https('yandex.ru', '/maps/', {
      'll': point,
      'z': '16',
      'pt': '$point,pm2rdm',
      'text': place.name,
    });
  }

  void _showMessage(BuildContext context, String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) {
    final matchingPlaces = kPlaces.where((item) => item.id == placeId);
    final Place? place = matchingPlaces.isEmpty ? null : matchingPlaces.first;
    if (place == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: Text('Место не найдено')));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Информация о месте'), actions: [
        AnimatedBuilder(animation: AppState.instance, builder: (context, _) => IconButton(onPressed: () => AppState.instance.toggleFavorite(place.id), icon: Icon(AppState.instance.isFavorite(place.id) ? Icons.bookmark_rounded : Icons.bookmark_border_rounded), tooltip: 'Избранное')),
      ]),
      body: SafeArea(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 840),
        child: ListView(padding: const EdgeInsets.fromLTRB(20, 8, 20, 35), children: [
          // Шапка с фотографией или градиентным фоном
          ClipRRect(
            borderRadius: BorderRadius.circular(27),
            child: SizedBox(
              height: 260,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (place.imageUrl != null)
                    Image.asset(
                      place.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [GuideColors.greenDark, GuideColors.green],
                          ),
                        ),
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(22),
                        child: Text(place.emoji, style: const TextStyle(fontSize: 42)),
                      ),
                    )
                  else
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [GuideColors.greenDark, GuideColors.green],
                        ),
                      ),
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(22),
                      child: Text(place.emoji, style: const TextStyle(fontSize: 42)),
                    ),
                  
                  // Затемнение для читаемости текста поверх фото
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.75),
                        ],
                      ),
                    ),
                  ),
                  
                  // Текстовая информация в нижней части шапки
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (place.imageUrl != null) ...[
                          Text(place.emoji, style: const TextStyle(fontSize: 26)),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          place.name,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                shadows: [
                                  const Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          place.subtitle,
                          style: const TextStyle(
                            color: Color(0xFFE0EEE8),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 7,
                          runSpacing: 7,
                          children: [
                            _HeroTag(place.category),
                            if (place.status != null) const _HeroTag('Требуется проверка'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 19),
          if (place.status != null) ...[
            Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: GuideColors.warningBg, borderRadius: BorderRadius.circular(16)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.warning_amber_rounded, color: GuideColors.warning), const SizedBox(width: 10), Expanded(child: Text(place.status!, style: const TextStyle(color: GuideColors.warning, fontWeight: FontWeight.w600, height: 1.4)))])),
            const SizedBox(height: 16),
          ],
          const SectionHeading(title: 'Описание'),
          Text(place.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          const SectionHeading(title: 'Основная информация'),
          _InfoRow(icon: Icons.location_on_outlined, title: 'Адрес', value: place.address),
          if (place.workingHours != null) _InfoRow(icon: Icons.schedule_rounded, title: 'Режим работы', value: place.workingHours!),
          if (place.phone != null) _InfoRow(icon: Icons.phone_outlined, title: 'Телефон', value: place.phone!, trailing: IconButton(onPressed: () => _launch(context, Uri(scheme: 'tel', path: place.phone!.replaceAll(RegExp(r'[^+0-9]'), ''))), icon: const Icon(Icons.call_outlined), tooltip: 'Позвонить')),
          const SizedBox(height: 15),
          Row(children: [
            Expanded(child: AnimatedBuilder(animation: AppState.instance, builder: (context, _) {
              final inPlan = AppState.instance.isInPlan(place.id);
              return FilledButton.icon(onPressed: () async { await AppState.instance.togglePlan(place.id); if (context.mounted) _showMessage(context, inPlan ? 'Удалено из маршрута' : 'Добавлено в маршрут'); }, icon: Icon(inPlan ? Icons.remove_road_rounded : Icons.add_road_rounded), label: Text(inPlan ? 'Убрать из маршрута' : 'В маршрут'), style: FilledButton.styleFrom(backgroundColor: GuideColors.green, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)));
            })),
            const SizedBox(width: 9),
            IconButton.filledTonal(onPressed: () => _launch(context, _mapUri(place)), icon: const Icon(Icons.directions_outlined), tooltip: 'Открыть на карте'),
          ]),
          if (place.website != null) ...[
            const SizedBox(height: 9),
            OutlinedButton.icon(onPressed: () => _launch(context, Uri.parse(place.website!)), icon: const Icon(Icons.open_in_new_rounded), label: const Text('Официальный сайт'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 13))),
          ],
          const SizedBox(height: 20),
          Text('Режим работы и детали лучше уточнять перед поездкой.', style: Theme.of(context).textTheme.bodyMedium),
        ]),
      ))),
    );
  }
}

class _HeroTag extends StatelessWidget {
  final String text;
  const _HeroTag(this.text);
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(.15), borderRadius: BorderRadius.circular(20)), child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)));
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Widget? trailing;
  const _InfoRow({required this.icon, required this.title, required this.value, this.trailing});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 15), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 39, height: 39, decoration: BoxDecoration(color: GuideColors.mint, borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 20, color: GuideColors.green)),
        const SizedBox(width: 11),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12, color: GuideColors.muted, fontWeight: FontWeight.w600)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontSize: 14, height: 1.4, color: GuideColors.ink, fontWeight: FontWeight.w600))])),
        if (trailing != null) trailing!,
      ]));
}